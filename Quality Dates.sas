/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
/* Together, these files form one big long data step */

%macro date_q(extract, backward, forward, quality);
	if missing(&backward) and missing(&extract) then &quality = "";
	else if missing(&extract) and not missing(&backward) then &quality = "(missing)";
	else &quality = put(&extract, MMDDYY10.);
%mend date_q;

%macro QualityDate;
	format
		vben_dq $10.
		tr_hybrid_sepn_dq $10.	
		tr_sepn_dq $10.
		tr_vadir_sepn_dq $10.
		tr_finoutproccomplet_dq $10.
		p_secrev_edq $10.
		p_secrev_sdq $10.
		p_fdpn_dq $10.
		p_vrrat_edq $10.
		p_vrrat_sdq $10.
		fpa_hybrid_edq $10.
		p_fpa_edq $10.
		p_fpa_dcndq $10.
		p_fpa_sdq $10.
		p_fp_edq $10.
		p_fp_dcndq $10.
		p_fp_sdq $10.
		p_ipc_edq $10.
		p_ipc_sdq $10.
		p_cfa_edq $10.
		p_cfa_sdq $10.
		p_vprat_edq $10.
		p_vprat_sdq $10.
		p_ip_dcndq $10.
		p_ip_sdq $10.
		m_meb_edq $10.
		m_rebut_edq $10.
		m_rebut_sdq $10.
		imr_edq $10.
		imr_sdq $10.
		m_nars_dq $10.
		m_vmeval_edq $10.
		m_vmsc_sm_intvw_dq $10.
		m_vex_edq $10.
		m_vmeval_sdq $10.
		m_pdclm_sdq $10.
		m_ref_dq $10.
		;


	label									
		vben_dq = 					'VA Benefits Date quality'		
		tr_hybrid_sepn_dq =			'Hybrid Separation Date quality'				
		tr_finoutproccomplet_dq = 	'Final Out-Processing Completion Date quality'						
		p_secrev_edq = 				'Secretarial Review End Date quality'			
		p_secrev_sdq = 				'Secretarial Review Start Date quality'			
		p_fdpn_dq = 				'Final Disposition Date quality'			
		p_vrrat_edq = 				'VA Rating Reconsideration End Date quality'			
		p_vrrat_sdq = 				'VA Rating Reconsideration Start Date quality'
		fpa_hybrid_edq = 			'Hybrid FPEB Appeal End Date quality'	
		p_fpa_edq = 				'FPEB Appeal End Date quality'		
		p_fpa_dcndq = 				'FPEB Appeal Decision Date quality'		
		p_fpa_sdq = 				'FPEB Appeal Start Date quality'			
		p_fp_edq = 					'FPEB End Date quality'		
		p_fp_dcndq = 				'FPEBs Decision Date quality'			
		p_fp_sdq = 					'FPEB Start Date quality'		
		p_ipc_edq = 				'IPEB Counsel End Date quality'			
		p_ipc_sdq = 				'IPEB Counsel Start Date quality'			
		p_cfa_edq = 				'Case File Assembly End Date quality'			
		p_cfa_sdq = 				'Case File Assembly Start Date quality'			
		p_vprat_edq = 				'VA Preliminary Rating End Date quality'			
		p_vprat_sdq = 				'VA Preliminary Rating Start Date quality'			
		p_ip_dcndq = 				'IPEB''s Decision Date quality'			
		p_ip_sdq = 					'IPEB Start Date quality'		
		m_meb_edq = 				'MEB End Date quality'			
		m_rebut_edq = 				'MEB Rebuttal End Date quality'			
		m_rebut_sdq = 				'MEB Rebuttal Start Date quality'			
		imr_edq = 					'IMR End Date quality'		
		imr_sdq = 					'IMR Start Date quality'		
		m_nars_dq = 				'NARSUM Date quality'			
		m_vmeval_edq = 				'VA Medical Evaluation End Date quality'			
		m_vex_edq = 				'VA Exam End Date quality'			
		m_vmeval_sdq = 				'VA Medical Evaluation Start Date quality'			
		m_vmsc_sm_intvw_dq = 		'MSC-Service Member Interview Date quality'					
		m_pdclm_sdq = 				'Prepared Claim Start Date quality'			
		m_ref_dq = 					'MEB Referral Date quality';

	%date_q (vben_dx, vben_db, vben_df, vben_dq);
	%date_q (tr_sepn_dx, tr_sepn_db, tr_sepn_df, tr_sepn_dq);
	%date_q (tr_vadir_sepn_dx, tr_vadir_sepn_db, tr_vadir_sepn_df, tr_vadir_sepn_dq);
	%date_q (tr_hybrid_sepn_dx, tr_hybrid_sepn_db, tr_hybrid_sepn_df, tr_hybrid_sepn_dq);
	%date_q (tr_finoutproccomplet_dx, tr_finoutproccomplet_db, tr_finoutproccomplet_df, tr_finoutproccomplet_dq);
	%date_q (p_secrev_edx, p_secrev_edb, p_secrev_edf, p_secrev_edq);
	%date_q (p_secrev_sdx, p_secrev_sdb, p_secrev_sdf, p_secrev_sdq);
	%date_q (p_fdpn_dx, p_fdpn_db, p_fdpn_df, p_fdpn_dq);
	%date_q (p_vrrat_edx, p_vrrat_edb, p_vrrat_edf, p_vrrat_edq);
	%date_q (p_vrrat_sdx, p_vrrat_sdb, p_vrrat_sdf, p_vrrat_sdq);
	%date_q (fpa_hybrid_edx, fpa_hybrid_edb, fpa_hybrid_edf, fpa_hybrid_edq);
	%date_q (p_fpa_edx, p_fpa_edb, p_fpa_edf, p_fpa_edq);
	%date_q (p_fpa_dcndx, p_fpa_dcndb, p_fpa_dcndf, p_fpa_dcndq);
	%date_q (p_fpa_sdx, p_fpa_sdb, p_fpa_sdf, p_fpa_sdq);
	%date_q (p_fp_edx, p_fp_edb, p_fp_edf, p_fp_edq);
	%date_q (p_fp_dcndx, p_fp_dcndb, p_fp_dcndf, p_fp_dcndq);
	%date_q (p_fp_sdx, p_fp_sdb, p_fp_sdf, p_fp_sdq);
	%date_q (p_ipc_edx, p_ipc_edb, p_ipc_edf, p_ipc_edq);
	%date_q (p_ipc_sdx, p_ipc_sdb, p_ipc_sdf, p_ipc_sdq);
	%date_q (p_cfa_edx, p_cfa_edb, p_cfa_edf, p_cfa_edq);
	%date_q (p_cfa_sdx, p_cfa_sdb, p_cfa_sdf, p_cfa_sdq);
	%date_q (p_vprat_edx, p_vprat_edb, p_vprat_edf, p_vprat_edq);
	%date_q (p_vprat_sdx, p_vprat_sdb, p_vprat_sdf, p_vprat_sdq);
	%date_q (p_ip_dcndx, p_ip_dcndb, p_ip_dcndf, p_ip_dcndq);
	%date_q (p_ip_sdx, p_ip_sdb, p_ip_sdf, p_ip_sdq);
	%date_q (m_meb_edx, m_meb_edb, m_meb_edf, m_meb_edq);
	%date_q (m_rebut_edx, m_rebut_edb, m_rebut_edf, m_rebut_edq);
	%date_q (m_rebut_sdx, m_rebut_sdb, m_rebut_sdf, m_rebut_sdq);
	%date_q (imr_edx, imr_edb, imr_edf, imr_edq);
	%date_q (imr_sdx, imr_sdb, imr_sdf, imr_sdq);
	%date_q (m_nars_dx, m_nars_db, m_nars_df, m_nars_dq);
	%date_q (m_vmeval_edx, m_vmeval_edb, m_vmeval_edf, m_vmeval_edq);
	%date_q (m_vex_edx, m_vex_edb, m_vex_edf, m_vex_edq);
	%date_q (m_vmeval_sdx, m_vmeval_sdb, m_vmeval_sdf, m_vmeval_sdq);
	%date_q (m_vmsc_sm_intvw_dx, m_vmsc_sm_intvw_db, m_vmsc_sm_intvw_df, m_vmsc_sm_intvw_dq);
	%date_q (m_pdclm_sdx, m_pdclm_sdb, m_pdclm_sdf, m_pdclm_sdq);
	%date_q (m_ref_dx, m_ref_db, m_ref_df, m_ref_dq);

	v_x_intvw_dq = v_x_intvw_dx;

%mend QualityDate;
