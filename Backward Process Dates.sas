
	/****************************************/
	/* Backward Process Date Variables		*/
	/****************************************/

	/* One of the files of helper code that the 'AllVariableColumns' macro in 'All.sas' calls */
	/* Together, these files form one big long data step */


%macro date_b (extract_date, consistent_date, extra_condition);
	if missing(lseq_dd)
		then do;
			if &extract_date = . or mdy(&month, &day, &year) <= &extract_date
				then nseq_dn = vlabel(&extract_date);
			else if &extract_date <= mdy(&month, &day, &year)
				then do;
					lseq_dn = vlabel(&extract_date);
					lseq_dd = &extract_date;
				end;
		end;

	if missing(latest_possible) &extra_condition
		then do;
			latest_possible = &extract_date;
			&consistent_date = &extract_date;
			last_process_date = %sysfunc(inputn(&extract_date,MMDDYY10.));
		end;
	else if missing(&extract_date) &extra_condition
		then &consistent_date = latest_possible;
	else if latest_possible <= &extract_date &extra_condition
		then &consistent_date = latest_possible;
	else if &extract_date <= latest_possible &extra_condition
		then do;
			&consistent_date = &extract_date;
			latest_possible = &extract_date;
		end;
	else &consistent_date = .;
%mend date_b;



%macro BackwardProcessDate;												
												
	format											
		latest_possible MMDDYY10.										
		ides_ed MMDDYY10.										
		vben_db MMDDYY10.
		tr_sepn_db MMDDYY10.	
		tr_hybrid_sepn_db MMDDYY10.										
		tr_finoutproccomplet_db MMDDYY10.										
		p_secrev_edb MMDDYY10.										
		p_secrev_sdb MMDDYY10.										
		p_fdpn_db MMDDYY10.										
		p_vrrat_edb MMDDYY10.										
		p_vrrat_sdb MMDDYY10.
		fpa_hybrid_edb MMDDYY10.
		p_fpa_edb MMDDYY10.		
		p_fpa_dcndb MMDDYY10.		
		p_fpa_sdb MMDDYY10.										
		p_fp_edb MMDDYY10.										
		p_fp_dcndb MMDDYY10.										
		p_fp_sdb MMDDYY10.										
		p_ipc_edb MMDDYY10.										
		p_ipc_sdb MMDDYY10.										
		p_cfa_edb MMDDYY10.										
		p_cfa_sdb MMDDYY10.										
		p_vprat_edb MMDDYY10.										
		p_vprat_sdb MMDDYY10.										
		p_ip_dcndb MMDDYY10.										
		p_ip_sdb MMDDYY10.										
		m_meb_edb MMDDYY10.										
		m_rebut_edb MMDDYY10.										
		m_rebut_sdb MMDDYY10.										
		imr_edb MMDDYY10.										
		imr_sdb MMDDYY10.										
		m_nars_db MMDDYY10.										
		m_vmeval_edb MMDDYY10.										
		m_vex_edb MMDDYY10.										
		m_vmeval_sdb MMDDYY10.										
		m_vmsc_sm_intvw_db MMDDYY10.										
		m_pdclm_sdb MMDDYY10.										
		m_ref_db MMDDYY10.
		tr_sepn_db MMDDYY10.
		tr_vadir_sepn_db MMDDYY10.
		lseq_dd MMDDYY10.
		lseq_dn $40.
		nseq_dn $40.;

	label								
		vben_db = 					'VA Benefits Date back'
		tr_sepn_db =				'VTA Separation Date back'		
		tr_hybrid_sepn_db =			'Hybrid Separation Date back'				
		tr_finoutproccomplet_db = 	'Final Out-Processing Completion Date back'						
		p_secrev_edb = 				'Secretarial Review End Date back'			
		p_secrev_sdb = 				'Secretarial Review Start Date back'			
		p_fdpn_db = 				'Final Disposition Date back'			
		p_vrrat_edb = 				'VA Rating Reconsideration End Date back'			
		p_vrrat_sdb = 				'VA Rating Reconsideration Start Date back'	
		fpa_hybrid_edb = 			'Hybrid FPEB Appeal End Date back'	
		p_fpa_edb = 				'FPEB Appeal End Date back'	
		p_fpa_dcndb =				'FPEB Appeal Decision Date back'		
		p_fpa_sdb = 				'FPEB Appeal Start Date back'			
		p_fp_edb = 					'FPEB End Date back'		
		p_fp_dcndb = 				'FPEBs Decision Date back'			
		p_fp_sdb = 					'FPEB Start Date back'		
		p_ipc_edb = 				'IPEB Counsel End Date back'			
		p_ipc_sdb = 				'IPEB Counsel Start Date back'			
		p_cfa_edb = 				'Case File Assembly End Date back'			
		p_cfa_sdb = 				'Case File Assembly Start Date back'			
		p_vprat_edb = 				'VA Preliminary Rating End Date back'			
		p_vprat_sdb = 				'VA Preliminary Rating Start Date back'			
		p_ip_dcndb = 				'IPEB''s Decision Date back'			
		p_ip_sdb = 					'IPEB Start Date back'		
		m_meb_edb = 				'MEB End Date back'			
		m_rebut_edb = 				'MEB Rebuttal End Date back'			
		m_rebut_sdb = 				'MEB Rebuttal Start Date back'			
		imr_edb = 					'IMR End Date back'		
		imr_sdb = 					'IMR Start Date back'		
		m_nars_db = 				'NARSUM Date back'			
		m_vmeval_edb = 				'VA Medical Evaluation End Date back'			
		m_vex_edb = 				'VA Exam End Date back'			
		m_vmeval_sdb = 				'VA Medical Evaluation Start Date back'			
		m_vmsc_sm_intvw_db = 		'MSC-Service Member Interview Date back'					
		m_pdclm_sdb = 				'Prepared Claim Start Date back'			
		m_ref_db = 					'MEB Referral Date back'
		lseq_dd = 					'Last Sequential Date (Date)'
		lseq_dn = 					'Last Sequential Date (Name)'
		nseq_dn = 					'Next Sequential Date (Name)';		
	

	
												
	/* Dates created by walking through the process backward */											
												
	%date_b (vben_dx, 					vben_db						,%str(and non_active_duty = 0));
	%date_b (tr_sepn_dx, 				tr_sepn_db					,%str(and non_active_duty = 0));
	%date_b (tr_hybrid_sepn_dx, 		tr_hybrid_sepn_db			,%str(and non_active_duty = 0));
	*%date_b (tr_vadir_sepn_dx, 			tr_vadir_sepn_db			,%str(and non_active_duty = 0));	
	%date_b (tr_finoutproccomplet_dx,	tr_finoutproccomplet_db		,%str(and non_active_duty = 0));
	%date_b (p_secrev_edx, 				p_secrev_edb				,);			
	%date_b (p_secrev_sdx, 				p_secrev_sdb				,);			
	%date_b (p_fdpn_dx, 				p_fdpn_db					,);		
	%date_b (p_vrrat_edx, 				p_vrrat_edb					,%str(and need_vrrat = 1));		
	%date_b (p_vrrat_sdx, 				p_vrrat_sdb					,%str(and need_vrrat = 1));	
	%date_b (fpa_hybrid_edx, 			fpa_hybrid_edb				,%str(and need_fpa = 1));	
	%date_b (p_fpa_edx, 				p_fpa_edb					,%str(and need_fpa = 1));	
	%date_b (p_fpa_dcndx, 				p_fpa_dcndb					,%str(and need_fpa = 1));	
	%date_b (p_fpa_sdx, 				p_fpa_sdb					,%str(and need_fpa = 1));		
	%date_b (p_fp_edx, 					p_fp_edb					,%str(and need_fp = 1));	
	%date_b (p_fp_dcndx, 				p_fp_dcndb					,%str(and need_fp = 1));		
	%date_b (p_fp_sdx, 					p_fp_sdb					,%str(and need_fp = 1));	
	%date_b (p_ipc_edx,					p_ipc_edb					,);	
	*%date_b (p_ipc_sdx,				p_ipc_sdb					,);	
	%date_b (p_cfa_edx,				 	p_cfa_edb					,);
	%date_b (p_cfa_sdx, 				p_cfa_sdb					,);
	%date_b (p_vprat_edx, 				p_vprat_edb					,);
	%date_b (p_vprat_sdx, 				p_vprat_sdb					,);
	%date_b (p_ip_dcndx, 				p_ip_dcndb					,);
	%date_b (p_ip_sdx, 					p_ip_sdb					,);
	%date_b (m_meb_edx, 				m_meb_edb					,);
	%date_b (m_rebut_edx, 				m_rebut_edb					,%str(and need_m_rebut = 1));
	%date_b (m_rebut_sdx, 				m_rebut_sdb					,%str(and need_m_rebut = 1));
	%date_b (imr_edx, 					imr_edb						,%str(and need_imr = 1));
	%date_b (imr_sdx, 					imr_sdb						,%str(and need_imr = 1));
	%date_b (m_nars_dx, 				m_nars_db					,);
	%date_b (m_vmeval_edx, 				m_vmeval_edb				,);
	%date_b (m_vex_edx, 				m_vex_edb					,);
	%date_b (m_vmeval_sdx, 				m_vmeval_sdb				,);
	%date_b (m_vmsc_sm_intvw_dx, 		m_vmsc_sm_intvw_db			,);
	%date_b (m_pdclm_sdx, 				m_pdclm_sdb					,);
	%date_b (m_ref_dx, 					m_ref_db					,);	

	if enrolled_x = "DISENROLLED" then nseq_dn = "Disenrolled";
	else if nseq_dn = "" then nseq_dn = "(awaiting disenrollment)";

	/* IPEB Counsel Start Date is placed out of order a lot and is not included in the above code */

	if  p_ipc_sdx < p_cfa_edb then
		p_ipc_sdb = p_cfa_edb;
	else p_ipc_sdb = p_ipc_sdx;

%mend BackwardProcessDate;												

