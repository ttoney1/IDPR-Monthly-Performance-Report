
	/****************************************/
	/* Intervals                            */
	/****************************************/
	/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
	/* Together, these files form one big long data step */

	/* Scroll below to see us implement the most basic calculation rules */

%macro Interval(interval, start_date, end_date, extra_condition);

	if (missing(&start_date) or missing(&end_date)) &extra_condition
		then &interval = .;
	else if &end_date - &start_date < 0
		then &interval = .;
	else &interval = &end_date - &start_date;

%mend Interval;

%macro ServiceMemberInterval;

	length
		ides_t 8.
		/*ides_core_t 8.
		ides_core_nortd_t 8.*/
		ides_nortd_t 8.
		m_ph_t 8.
		m_ref_t 8.
		m_vcd_t 8.
		m_vmeval_t 8.
		m_vex_ct 8.
		m_veval_tt 8.
		m_st_t 8.
		m_nars_t 8.
		m_dcnapp_t 8.
		imr_t 8.
		m_rebut_t 8.
		p_ph_t 8.
		p_ip_t 8.
		p_m2p_tt 8.
		p_ipdcn_ct 8.
		p_vprat_t 8.
		p_ip2vprat_tt 8.
		p_vprat_ct 8.
		p_cfa_t 8.
		p_vprat2cfa_tt 8.
		p_ipc_t 8.
		p_cfa2ipc_tt 8.
		p_appdpn_t 8.
		p_fp_t 8.
		p_ipc2fp_tt 8.
		p_fpa_t 8.
		p_vrrat_t 8.
		p_peb2vrrat_tt 8.
		p_vrrat_ct 8.
		p_dpn_t 8.
		p_secrev_t 8.
		tr_out_t 8.
		tr_leave_t 8.
		tr_ph_t 8.
		vben_ph_t 8.
		ides_dod_core 8.
		ides_va_core 8.;


	label
		ides_t = 					'IDES Total Time'
		ides_nortd_t = 				'IDES Total Time without RTD'
		/*ides_core_t = 				'IDES Processing Time'*/
		m_ph_t = 					'MEB Phase Time'
		m_ref_t = 					'MEB Referral Time'
		m_vcd_t = 					'VA Claim Development Time'
		m_vmeval_t = 				'VA Medical Evaluation Time'
		m_vex_ct = 					'VA Exam Core Time'
		m_veval_tt = 				'VA Medical Evaluation Admin Time'
		m_st_t = 					'MEB Stage Time'
		m_nars_t = 					'NARSUM Time'
		m_dcnapp_t = 				'MEB Decision and Appeal Time'
		imr_t = 					'IMR Time'
		m_rebut_t = 				'MEB Rebuttal Time'
		p_ph_t = 					'PEB Phase Time'
		p_ip_t = 					'IPEB Time'
		p_m2p_tt = 					'MEB-to-PEB Transit Time'
		p_ipdcn_ct = 				'IPEB Decision Core Time'
		p_vprat_t = 				'VA Preliminary Rating Time'
		p_ip2vprat_tt = 			'IPEB-to-DRAS Transit Time'
		p_vprat_ct = 				'VA Preliminary Rating Core Time'
		p_cfa_t = 					'Case File Assembly Time'
		p_vprat2cfa_tt = 			'DRAS-to-Case File Assembly Transit Time'
		p_ipc_t = 					'IPEB Counsel Time'
		p_cfa2ipc_tt = 				'Case File Assembly-to-IPEB Counsel Transit Time'
		p_appdpn_t = 				'Appeal and Disposition Time'
		p_fp_t = 					'FPEB Time'
		p_ipc2fp_tt = 				'IPEB Counsel-to-FPEB Transit Time'
		p_fpa_t = 					'FPEB Appeal Time'
		p_vrrat_t = 				'VA Rating Reconsideration Time'
		p_peb2vrrat_tt = 			'IPEB-/FPEB-to-VA Rating Reconsideration Transit Time'
		p_vrrat_ct = 				'VA Rating Reconsideration Core Time'
		p_dpn_t = 					'Post-Appeal Disposition Time'
		p_secrev_t = 				'Secretarial Review Time'
		tr_out_t = 					'Transition Out Processing Time'
		tr_leave_t = 				'Transition Leave Time'
		tr_ph_t = 					'Transition Phase Time'
		vben_ph_t =					'VA Benefits Phase Time'
		/*ides_dod_core = 			'DoD Core Time'*/;

	%interval(ides_t,			m_ref_dx, 				ides_ed,				%str(or disposition = ''));
	%interval(ides_nortd_t, 	m_ref_dx, 				ides_ed,				%str(or (disposition = '' or disposition = 'RTD')));
	/*%interval(ides_core_t, m_ref_dx, ides_core_ed,%str(and disposition ne ''));
	%interval(ides_core_nortd_t, m_ref_dx, ides_core_ed,%str(and (disposition ne '' or disposition ne 'rtd')));*/
	%interval(m_ph_t,			m_ref_dx,				m_meb_edx,);
	%interval(m_ref_t,			m_ref_dx,				m_pdclm_sdx,);
	%interval(m_vcd_t,			m_pdclm_sdx,			m_vmeval_sdx,);
	%interval(m_vmeval_t,		m_vmeval_sdx,			m_vmeval_edx,);
	%interval(m_vex_ct,			m_vmeval_sdx,			m_vex_edx,);
	%interval(m_veval_tt,		m_vex_edx,				m_vmeval_edx,);
	%interval(m_st_t,			m_vmeval_edx,			m_meb_edx,);
	%interval(m_nars_t,			m_vmeval_edx,			m_nars_dx,);
	%interval(m_dcnapp_t,		m_nars_dx,				m_meb_edx,);
	%interval(imr_t,			imr_sdx,				imr_edx,				%str(and need_imr = 1));
	%interval(m_rebut_t,		m_rebut_sdx,			m_rebut_edx,			%str(and need_m_rebut = 1));
	%interval(p_ph_t,			m_meb_edx,				p_secrev_edx,);
	%interval(p_ip_t,			m_meb_edx,				p_ip_dcndx,);
	%interval(p_m2p_tt,			m_meb_edx,				p_ip_sdx,);
	%interval(p_ipdcn_ct,		p_ip_sdx,				p_ip_dcndx,);
	%interval(p_vprat_t,		p_ip_dcndx,				p_vprat_edx,);
	%interval(p_ip2vprat_tt,	p_ip_dcndx,				p_vprat_sdx,);
	%interval(p_vprat_ct,		p_vprat_sdx,			p_vprat_edx,);
	%interval(p_cfa_t,			p_vprat_edx,			p_cfa_edx,);
	%interval(p_vprat2cfa_tt,	p_vprat_edx,			p_cfa_sdx,);
	%interval(p_ipc_t,			p_cfa_edx,				p_ipc_edx,);
	%interval(p_cfa2ipc_tt,		p_cfa_edx,				p_ipc_sdx,);
	%interval(p_appdpn_t,		p_ipc_edx,				p_fdpn_dx,);
	%interval(p_fp_t,			p_ipc_edx,				p_fp_edx,				%str(and need_fp = 1));
	%interval(p_ipc2fp_tt,		p_ipc_edx,				p_fp_sdx,				%str(and need_fp = 1));
	%interval(p_fpa_t,			p_fp_dcndx,				fpa_hybrid_edx,			%str(and need_fpa = 1));
	/*'p_all_app_ed' here is a misleading variable name, see note in 'More Hybrid Dates'*/
	%interval(p_vrrat_t,		p_all_app_ed,			p_vrrat_edx,			%str(and need_vrrat = 1));
	%interval(p_peb2vrrat_tt,	p_all_app_ed,			p_vrrat_sdx,			%str(and need_vrrat = 1));
	%interval(p_vrrat_ct,		p_vrrat_sdx,			p_vrrat_edx,			%str(and need_vrrat = 1));
	%interval(p_dpn_t,			p_ddapp_ed,				p_fdpn_dx,);
	%interval(p_secrev_t,		p_fdpn_dx,				p_secrev_edx,);
	/*these last five intervals will be '.' if the service member appears to be non-active duty */
	%interval(tr_out_t,			p_secrev_edx,			tr_finoutproccomplet_dx,%str(or non_active_duty = 1));
	%interval(tr_leave_t,		tr_finoutproccomplet_dx,tr_hybrid_sepn_dx,		%str(or non_active_duty = 1));
	%interval(tr_ph_t,			p_secrev_edx,			tr_hybrid_sepn_dx,		%str(or non_active_duty = 1));
	%interval(tr_ph_noleave_t,	p_secrev_edx,			tr_hybrid_outproc_dx,	%str(or non_active_duty = 1));
	%interval(vben_ph_t,		tr_hybrid_sepn_dx,		vben_dx,				%str(or non_active_duty = 1));

	/*ides_noleave_t = sum(ides_core_t, vben_ph_t);
	ides_noleave_nortd_t = sum(ides_core_nortd_t, vben_ph_t);*/

	/*
	if not missing(m_ref_t) and not missing(m_st_t) and not missing(p_ip_t) and not missing(tr_ph_t) and rtd ne 1 then
		ides_dod_core = sum(m_ref_t, m_st_t, p_ip_t, tr_ph_t);
	else if rtd = 1 then ides_dod_core = sum(m_ref_t, m_st_t, p_ip_t, tr_ph_t);
	else ides_dod_core = .;
	
	ides_va_core = sum(m_vcd_t, m_vmeval_t, p_vprat_t, p_vrrat_t, vben_ph_t);
	*/

	/*Subtract terminal leave from total IDES time */
	if not missing(ides_t) 
		then do;
		if not missing(tr_ph_noleave_t) then
			ides_noleave_t = ides_t - (tr_ph_t - tr_ph_noleave_t);
		else ides_noleave_t = ides_t;
		end;
	else ides_noleave_t = '.';

	if not missing(ides_nortd_t) 
		then do;
		if not missing(tr_ph_noleave_t) then
			ides_noleave_nortd_t = ides_nortd_t - (tr_ph_t - tr_ph_noleave_t);
		else ides_noleave_nortd_t = ides_nortd_t;
		end;
	else ides_noleave_nortd_t = '.';

%mend ServiceMemberInterval;
