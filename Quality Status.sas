	/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
	/* Together, these files form one big long data step */

%macro quality (quality_status, extract_status, later_date, extra_condition);
	if &extract_status = ''
		then do;
		if not missing(&later_date) %if &extra_condition ne none %then and &extra_condition;
			then &quality_status = '(missing)';
		else &quality_status = '';
		end;
	else
		&quality_status = &extract_status;
%mend quality;

%macro QualityStatus;

	/****************************************/
	/* Quality-Flagged Variables: non-dates */
	/****************************************/

	length
		service_q $2.
		component_q $9.
		personnelclass_q $15.
		l_refmtf_q $100.
		l_meb_q $100.
		l_vex_q $100.
		l_peb_q $100.
		l_vdras_q $100.
		peblo_q $100.
		v_msc_q $100.
		m_rfcondns_nq $50.
		m_clcondns_nq $50.
		p_vdegr_rfcondns_q $50.
		p_vdegr_alcondns_q $50.
		p_vrrat_results_q $50.
		p_vtotalrat_q $50.
		p_ddadjustedrat_q $50.
		p_ddpct_q $50.
		m_ipref_q $50.
		p_ip_dcnq $50.
		p_ip_smsq $50.
		p_fp_altact_q $50.
		p_fp_dcnq $50.
		p_fp_smsq $50.
		p_fpa_dcnq $50.
		p_fdpn_q $50.
		;

	select (service_x);
		when ('A') service_q = 'A';
		when ('F') service_q = 'AF';
		when ('N') service_q = 'N';
		when ('M') service_q = 'MC';
		when ('') service_q = '(missing)';
		otherwise;
	end;

	select (component_x);
		when ('A') component_q = 'Active';
		when ('R') component_q = 'Reserve';
		when ('G') component_q = 'Guard';
		when ('') component_q = '(missing)';	
		otherwise;
	end;

	if personnelclass_x = '' then personnelclass_q = '(missing)';	
		else personnelclass_q = propcase(personnelclass_x);

	/*ok, now it's business as usual*/
	if l_refmtf_x = '' then l_refmtf_q = '(missing)';	
		else l_refmtf_q = l_refmtf_x;

	if l_meb_x = '' then l_meb_q = '(missing)';	
		else l_meb_q = l_meb_x;
	
	%quality(l_vex_q, l_vex_x, m_vmeval_sdq, none);

	if l_peb_x = '' then l_peb_q = '(missing)';	
		else l_peb_q = l_peb_x;

	%quality(l_vdras_q, l_vdras_x, p_vprat_sdq, none);

	/*caseworker*/
	if peblo_x = '' then peblo_q = '(missing)';	
		else peblo_q = peblo_x;
	
	%quality(v_msc_q, v_msc_x, m_pdclm_sdq, none);

	/*rating*/
	
	%quality(m_rfcondns_nq, m_rfcondns_nx, m_ref_dq, none);
	%quality(m_clcondns_nq, m_clcondns_nx, m_vmeval_sdq, none);
	%quality(p_vdegr_rfcondns_q, p_vdegr_rfcondns_x, p_vprat_edq, none);
	%quality(p_vdegr_alcondns_q, p_vdegr_alcondns_x, p_vprat_edq, none);
	%quality(p_vrrat_results_q, p_vrrat_results_x, p_vrrat_edq, none);

	/*create a boolean-ish helper*/
	length p_fdpn_rtd $1;
	select (p_fdpn_x);
		when ('Found fit and returned to duty') p_fdpn_rtd = 'T';
		when ('Unfit, but RTD') p_fdpn_rtd = 'T';
		otherwise p_fdpn_rtd = 'F';
	end;
	
	%quality(p_vtotalrat_q, p_vtotalrat_x, p_fdpn_dq, %str(p_fdpn_rtd = 'F'));
	%quality(p_ddadjustedrat_q, p_ddadjustedrat_x, p_fdpn_dq, %str(p_fdpn_rtd = 'F'));
	%quality(p_ddpct_q, p_ddpct_x, p_fdpn_dq, %str(p_fdpn_rtd = 'F'));

	/*routing*/
	
	%quality(m_ipref_q, m_ipref_x, p_ip_sdq, none);
	%quality(p_ip_dcnq, p_ip_dcnx, p_ip_dcndq, none);
	%quality(p_ip_smsq, p_ip_smsx, p_ipc_edq, none);

	/*(placeholder for FPEB alternative actions) */
	p_fp_altact_x = '';

	/*decisions*/	
	%quality(p_fp_dcnq, p_fp_dcnx, p_fp_dcndq, none);
	%quality(p_fp_smsq, p_fp_smsx, p_fp_edq, none);
	%quality(p_fpa_dcnq, p_fpa_dcnx, p_fpa_dcndq, none);
	%quality(p_fdpn_q, p_fdpn_x, p_fdpn_dq, none);
	
	/*Special Case: these ones have no error check*/
	length enrolled_q $50;
	enrolled_q = propcase(enrolled_x);
%mend QualityStatus;
