/*WHY DID HE NAME THE SAME MACROS TWICE?
	/****************************************/
	/* Quality-Flagged Timeliness Variables	*/
	/* for each process interval			*/
	/****************************************/

/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
	/* Together, these files form one big long data step */

	/* We've already gone through and calculated the variables			*/
	/* in the file 'Interval', which represent as a number the			*/
	/* time spent in each interval. Now, for each interval we will		*/
	/* create a string (named something like *_tq, and called 'duration'*/
	/* in the 'interval' macro below) that is either the				*/
	/* number of days (matching the normal interval) or a message		*/
	/* explaining why this can't be calculated. We will output these	*/
	/* *_tq variables into the Case Tracker								*/
	
%macro qinterval (duration, interval, pmd, sdq, edq, nmd);
	if &sdq = ''
		then do;
			if &edq = ''
			then &duration = '(not started)';
			else if &edq = '(missing)'
			then &duration = '(end date missing)';
			else &duration = '(start date missing)';
		end;
	else if  &sdq = '(missing)'
		then do;
			if  &edq = ''
			then  &duration = '(start date missing)';
			else if &edq = '(missing)'
			then &duration = '(both dates missing)';
			else &duration = '(start date missing)';
		end;
	else do;
			if &edq = ''
			then &duration = '(in progress)';
			else if &edq = '(missing)'
			then &duration = '(end date missing)';
			else do;
				if input(&sdq,MMDDYY10.) > input(&edq,MMDDYY10.)
				then &duration = '(dates reversed)';
				else if &interval = .
				then &duration= "";
				else &duration = &interval;
			end;
	end;
%mend qinterval;

%macro QualityInterval;

	/**********************************/
	/* Timeliness Variables: Character*/
	/**********************************/

	length
	ides_tq $20.
	m_ph_tq $20.
	m_ref_tq $20.
	m_vcd_tq $20.
	m_vmeval_tq $20.
	m_vex_ctq $20.
	m_veval_ttq $20.
	m_st_tq $20.
	m_nars_tq $20.
	m_dcnapp_tq $20.
	imr_tq $20.
	m_rebut_tq $20.
	p_ph_tq $20.
	p_ip_tq $20.
	p_m2p_ttq $20.
	p_ipdcn_ctq $20.
	p_vprat_tq $20.
	p_ip2vprat_ttq $20.
	p_vprat_ctq $20.
	p_cfa_tq $20.
	p_vprat2cfa_ttq $20.
	p_ipc_tq $20.
	p_cfa2ipc_ttq $20.
	p_appdpn_tq $20.
	p_fp_tq $20.
	p_ipc2fp_ttq $20.
	p_fpa_tq $20.
	p_vrrat_tq $20.
	p_peb2vrrat_ttq $20.
	p_vrrat_ctq $20.
	p_dpn_tq $20.
	p_secrev_tq $20.
	tr_ph_tq $20.
	tr_ph_noleave_tq $20.
	vben_ph_tq $20.;

	if missing(m_ref_dx) then ides_tq = "(start date missing)";
	else if missing(ides_ed) then ides_tq = "(in progress)";
	else if m_ref_dx > ides_ed then ides_tq = "(dates reversed)";
	else if disposition = '' then ides_tq = "(removed from IDES)";
	else ides_tq = ides_t;

	%qinterval( m_ph_tq,	m_ph_t, (none), m_ref_dq, m_meb_edq, p_ip_sdx);		
	%qinterval( m_ref_tq, m_ref_t, (none), m_ref_dq,	m_pdclm_sdq, m_vmeval_sdx);		
	%qinterval( m_vcd_tq,	m_vcd_t, m_ref_dx,	m_pdclm_sdq,	m_vmeval_sdq,	m_vmeval_edx	);	
		
	%qinterval( m_vmeval_tq,	m_vmeval_t, m_pdclm_sdx,	m_vmeval_sdq,	m_vmeval_edq,	m_meb_edx	);		
	%qinterval( m_vex_ctq,	m_vex_ct,m_pdclm_sdx,	m_vmeval_sdq,	m_vex_edq,	m_vmeval_edx	);		
	%qinterval( m_veval_ttq,	m_veval_tt,m_vmeval_sdx,	m_vex_edq,	m_vmeval_edq,	m_meb_edx);	
	%qinterval( m_st_tq,	m_st_t,m_vmeval_sdx,	m_vmeval_edq,	m_meb_edq,	p_ip_sdx);	
	%qinterval( m_nars_tq,	m_nars_t,m_vmeval_sdx,	m_vmeval_edq,	m_nars_dq,	m_meb_edx);	
	%qinterval( m_dcnapp_tq,	m_dcnapp_t, m_vmeval_edx,	m_nars_dq,	m_meb_edq,	p_ip_sdx);	
		
	%qinterval( imr_tq,	imr_t,
	m_ref_dx,	
	imr_sdq,	
	imr_edq,	
	p_secrev_edx
	);	
		
	%qinterval( m_rebut_tq,	m_rebut_t,
	m_ref_dx,	
	m_rebut_sdq,	
	m_rebut_edq,	
	p_secrev_edx);	
		
	%qinterval( p_ph_tq,	p_ph_t,
	m_vmeval_edx,	
	m_meb_edq,	
	p_secrev_edq,	
	tr_sepn_dx
	);	
		
	%qinterval( p_ip_tq,	p_ip_t,
	m_vmeval_edx,	
	m_meb_edq,	
	p_ip_dcndq,	
	p_secrev_edx
	);	
		
	%qinterval( p_m2p_ttq,	p_m2p_tt,
	m_vmeval_edx,	
	m_meb_edq,	
	p_ip_sdq,	
	p_secrev_edx
	);	
		
	%qinterval( p_ipdcn_ctq,	p_ipdcn_ct,
	m_meb_edx,	
	p_ip_sdq,	
	p_ip_dcndq,	
	p_secrev_edx
	);	
		
	%qinterval( p_vprat_tq,	p_vprat_t,
	p_ip_sdx,	
	p_ip_dcndq,	
	p_vprat_edq,	
	p_secrev_edx
	);	
		
	%qinterval( p_ip2vprat_ttq,	p_ip2vprat_tt,
	m_meb_edx,	
	p_ip_dcndq,	
	p_vprat_sdq,	
	p_secrev_edx
	);	
		
	%qinterval( p_vprat_ctq,	p_vprat_ct,
	p_ip_sdx,	
	p_vprat_sdq,	
	p_vprat_edq,	
	p_secrev_edx
	);	
		
	%qinterval( p_cfa_tq,	p_cfa_t,
	p_ip_sdx,	
	p_vprat_edq,	
	p_cfa_edq,	
	p_secrev_edx
	);	
		
	%qinterval( p_vprat2cfa_ttq,	p_vprat2cfa_tt,
	p_ip_sdx,	
	p_vprat_edq,	
	p_cfa_sdq,	
	p_secrev_edx
	);	
		
	%qinterval( p_ipc_tq,	p_ipc_t,
	p_ip_sdx,	
	p_cfa_edq,	
	p_ipc_edq,	
	p_secrev_edx
	);	
		
	%qinterval( p_cfa2ipc_ttq,	p_cfa2ipc_tt,
	p_ip_sdx,	
	p_cfa_edq,	
	p_ipc_sdq,	
	p_secrev_edx
	);	
		
	%qinterval( p_appdpn_tq,	p_appdpn_t,
	p_ip_sdx,	
	p_ipc_edq,	
	p_fdpn_dq,	
	p_secrev_edx
	);
		
	%qinterval( p_fp_tq,	p_fp_t,
	p_ip_sdx,	
	p_ipc_edq,	
	p_fp_edq,	
	p_secrev_edx
	);	
		
	%qinterval( p_ipc2fp_ttq,	p_ipc2fp_tt,
	p_ip_sdx,	
	p_ipc_edq,	
	p_fp_sdq,	
	p_secrev_edx
	);	
		
	%qinterval( p_fpa_tq,	p_fpa_t,
	p_ip_sdx,	
	p_fp_dcndq,	
	fpa_hybrid_edq,	
	p_secrev_edx
	);	
		
	%qinterval( p_vrrat_tq,	p_vrrat_t, p_ip_sdx, p_ddapp_edq, p_vrrat_edq, p_secrev_edx);	
		
	%qinterval( p_peb2vrrat_ttq,	p_peb2vrrat_tt, p_ip_sdx, p_ddapp_edq, p_vrrat_sdq, p_secrev_edx);	
	%qinterval( p_vrrat_ctq,	p_vrrat_ct, p_ip_sdx, p_vrrat_sdq, p_vrrat_edq, p_secrev_edx);		
	%qinterval( p_dpn_tq, p_dpn_t, p_ip_sdx, p_all_app_edq, p_fdpn_dq, p_secrev_edx);		
	%qinterval( p_secrev_tq,	p_secrev_t, p_ip_sdx, p_fdpn_dq, p_secrev_edq, tr_sepn_dx);	
	%qinterval( tr_ph_tq, tr_ph_t, p_ip_sdx, p_secrev_edq, tr_hybrid_sepn_dq, vben_dx);
	%qinterval( tr_ph_noleave_tq, tr_ph_noleave_t, p_ip_sdx, p_secrev_edq, tr_hybrid_sepn_dq, vben_dx);
	%qinterval( vben_ph_tq, vben_ph_t, p_secrev_edx, tr_hybrid_sepn_dq, vben_dq, (none));

	if tr_ph_noleave_tq = "." then tr_ph_noleave_tq = "";
	if vben_ph_tq = "." then vben_ph_tq = "";


%mend QualityInterval;
