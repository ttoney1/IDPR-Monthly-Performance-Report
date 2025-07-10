	/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
	/* Together, these files form one big long data step */

	/****************************************/
	/* End of DoD Appeals            		*/
	/****************************************/

%macro EndofAppeals;
	
	format
		p_ddapp_ed MMDDYY10.
		p_all_app_ed MMDDYY10.;

	label
		p_ddapp_ed = 'End of DoD Appeals'
		/* below is an abuse of language! call the variable something else!
		this variable seems to be a more orderly "end of DoD appeals", not just a max,
		that only gets calculated when there's a rating reconsideration*/
		p_all_app_ed = 'End of DoD Appeals (if SM needs VA Rerating)';

	p_ddapp_ed = max(p_ipc_edx, p_fp_dcndx, p_fp_edx, fpa_hybrid_edx);
												
	if need_vrrat = 1 
		then do;											
			if need_fpa = 1											
				then p_all_app_ed = fpa_hybrid_edb;										
			else if need_fp = 1											
				then p_all_app_ed = p_fp_edb;										
			else p_all_app_ed = p_ipc_edb;
		end;
	else p_all_app_ed = .;
%mend EndofAppeals;	

	/****************************************/
	/* IDES End Date              			*/
	/****************************************/												

%macro IDESEndDate;	
	
	format ides_ed MMDDYY10. 
			ides_core_ed MMDDYY10.;

	if (non_active_duty = 0 and not missing(vben_dx)) or enrolled_x = "DISENROLLED" 
		then ides_ed = max(vben_db, 
			tr_hybrid_sepn_db, 
			tr_finoutproccomplet_db, 
			p_secrev_edb, 
			p_secrev_sdb, 
			p_fdpn_db, 
			p_vrrat_edb, 
			p_vrrat_sdb, 
			p_fpa_edb, 
			p_fpa_sdb, 
			p_fp_edb, 
			p_fp_dcndb, 
			p_fp_sdb, 
			p_ipc_edb, 
			p_cfa_edb, 
			p_cfa_sdb, 
			p_vprat_edb, 
			p_vprat_sdb, 
			p_ip_dcndb, 
			p_ip_sdb, 
			m_meb_edb, 
			m_rebut_edb, 
			m_rebut_sdb, 
			imr_edb, 
			imr_sdb, 
			m_nars_db, 
			m_vmeval_edb, 
			m_vex_edb, 
			m_vmeval_sdb, 
			m_vmsc_sm_intvw_db, 
			m_pdclm_sdb, 
			m_ref_db);
	*else if non_active duty = 1 then ides_ed = p_secrev_edx;

		if (non_active_duty = 0 and not missing(tr_finoutproccomplet_dx)) or enrolled_x = "DISENROLLED" 
		then ides_core_ed = max(tr_finoutproccomplet_db,
			p_secrev_edb, 
			p_secrev_sdb, 
			p_fdpn_db, 
			p_vrrat_edb, 
			p_vrrat_sdb, 
			p_fpa_edb, 
			p_fpa_sdb, 
			p_fp_edb, 
			p_fp_dcndb, 
			p_fp_sdb, 
			p_ipc_edb, 
			p_cfa_edb, 
			p_cfa_sdb, 
			p_vprat_edb, 
			p_vprat_sdb, 
			p_ip_dcndb, 
			p_ip_sdb, 
			m_meb_edb, 
			m_rebut_edb, 
			m_rebut_sdb, 
			imr_edb, 
			imr_sdb, 
			m_nars_db, 
			m_vmeval_edb, 
			m_vex_edb, 
			m_vmeval_sdb, 
			m_vmsc_sm_intvw_db, 
			m_pdclm_sdb, 
			m_ref_db);

%mend IDESEndDate;

