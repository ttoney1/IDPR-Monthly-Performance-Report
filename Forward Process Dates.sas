
	/****************************************/
	/* Forward Process Date Variables		*/
	/****************************************/

	/* The call from "Enchilada" to "All" to this file is currently commented out*/
	/* This is pretty much the reverse of BackwardProcessDates. Backwards is preferrable. */
	
%macro date_f (extract_date, consistent_date, extra_condition);												
	if missing(earliest_possible)											
		then do;										
			if not missing(&extract_date) 									
				then do;								
					earliest_possible = &extract_date;														
					&consistent_date = &extract_date;							
				end;								
		end;										
	/*else if missing(&extract_date) &extra_condition											
		then do;										
			&consistent_date = earliest_possible;									
		end;
	*/	
	else if not missing(&extract_date)
		then do;
			if earliest_possible <= &extract_date &extra_condition											
				then do;										
					&consistent_date = &extract_date;									
					earliest_possible = &extract_date;									
				end;							
			else if &extract_date <= earliest_possible &extra_condition 											
				then &consistent_date = earliest_possible;
		end;	
	else &consistent_date = '.';											
%mend date_f;												
												
												
												
%macro ForwardProcessDate;												
												
	format											
		earliest_possible MMDDYY10.																		
		m_ref_df MMDDYY10.
		m_pdclm_sdf MMDDYY10.
		m_vmsc_sm_intvw_df MMDDYY10.
		m_vmeval_sdf MMDDYY10.
		m_vex_edf MMDDYY10.
		m_vmeval_edf MMDDYY10.
		m_nars_df MMDDYY10.
		imr_sdf MMDDYY10.
		imr_edf MMDDYY10.
		m_rebut_sdf MMDDYY10.
		m_rebut_edf MMDDYY10.
		m_meb_edf MMDDYY10.
		p_ip_sdf MMDDYY10.
		p_ip_dcndf MMDDYY10.
		p_vprat_sdf MMDDYY10.
		p_vprat_edf MMDDYY10.
		p_cfa_sdf MMDDYY10.
		p_cfa_edf MMDDYY10.
		p_ipc_sdf MMDDYY10.
		p_ipc_edf MMDDYY10.
		p_fp_sdf MMDDYY10.
		p_fp_dcndf MMDDYY10.
		p_fp_edf MMDDYY10.
		p_fpa_sdf MMDDYY10.
		p_fpa_edf MMDDYY10.
		p_vrrat_sdf MMDDYY10.
		p_vrrat_edf MMDDYY10.
		p_fdpn_df MMDDYY10.
		p_secrev_sdf MMDDYY10.
		p_secrev_edf MMDDYY10.
		tr_finoutproccomplet_df MMDDYY10.
		tr_hybrid_sepn_df MMDDYY10.
		vben_df MMDDYY10.;

	label									
		vben_df = 					'VA Benefits Date'		
		tr_hybrid_sepn_df =			'Hybrid Separation Date'				
		tr_finoutproccomplet_df = 	'Final Out-Processing Completion Date'						
		p_secrev_edf = 				'Secretarial Review End Date'			
		p_secrev_sdf = 				'Secretarial Review Start Date'			
		p_fdpn_df = 				'Final Disposition Date'			
		p_vrrat_edf = 				'VA Rating Reconsideration End Date'			
		p_vrrat_sdf = 				'VA Rating Reconsideration Start Date'			
		p_fpa_edf = 				'FPEB Appeal End Date'			
		p_fpa_sdf = 				'FPEB Appeal Start Date'			
		p_fp_edf = 					'FPEB End Date'		
		p_fp_dcndf = 				'FPEB''s Decision Date'			
		p_fp_sdf = 					'FPEB Start Date'		
		p_ipc_edf = 				'IPEB Counsel End Date'			
		p_ipc_sdf = 				'IPEB Counsel Start Date'			
		p_cfa_edf = 				'Case File Assembly End Date'			
		p_cfa_sdf = 				'Case File Assembly Start Date'			
		p_vprat_edf = 				'VA Preliminary Rating End Date'			
		p_vprat_sdf = 				'VA Preliminary Rating Start Date'			
		p_ip_dcndf = 				'IPEB''s Decision Date'			
		p_ip_sdf = 					'IPEB Start Date'		
		m_meb_edf = 				'MEB End Date'			
		m_rebut_edf = 				'MEB Rebuttal End Date'			
		m_rebut_sdf = 				'MEB Rebuttal Start Date'			
		imr_edf = 					'IMR End Date'		
		imr_sdf = 					'IMR Start Date'		
		m_nars_df = 				'NARSUM Date'			
		m_vmeval_edf = 				'VA Medical Evaluation End Date'			
		m_vex_edf = 				'VA Exam End Date'			
		m_vmeval_sdf = 				'VA Medical Evaluation Start Date'			
		m_vmsc_sm_intvw_df = 		'MSC-Service Member Interview Date'					
		m_pdclm_sdf = 				'Prepared Claim Start Date'			
		m_ref_df = 					'MEB Referral Date';							
												
	/* Dates created by walking through the process forward */											
												
	%date_f (m_ref_dx, 					m_ref_df					,);				
	%date_f (m_pdclm_sdx, 				m_pdclm_sdf					,);					
	%date_f (m_vmsc_sm_intvw_dx, 		m_vmsc_sm_intvw_df			,);									
	%date_f (m_vmeval_sdx, 				m_vmeval_sdf				,);						
	%date_f (m_vex_edx, 				m_vex_edf					,);					
	%date_f (m_vmeval_edx, 				m_vmeval_edf				,);						
	%date_f (m_nars_dx, 				m_nars_df					,);					
	%date_f (imr_sdx, 					imr_sdf						,%str(and not missing(imr_edx)));			
	%date_f (imr_edx, 					imr_edf						,%str(and not missing(imr_sdx)));			
	%date_f (m_rebut_sdx, 				m_rebut_sdf					,%str(and not missing(m_rebut_edx)));					
	%date_f (m_rebut_edx, 				m_rebut_edf					,%str(and not missing(m_rebut_sdx)));					
	%date_f (m_meb_edx, 				m_meb_edf					,);					
	%date_f (p_ip_sdx, 					p_ip_sdf					,);				
	%date_f (p_ip_dcndx, 				p_ip_dcndf					,);					
	%date_f (p_vprat_sdx, 				p_vprat_sdf					,);					
	%date_f (p_vprat_edx, 				p_vprat_edf					,);					
	%date_f (p_cfa_sdx, 				p_cfa_sdf					,);					
	%date_f (p_cfa_edx,				 	p_cfa_edf					,);				
	*%date_f (p_ipc_sdx,					p_ipc_sdf					,);				
	%date_f (p_ipc_edx,					p_ipc_edf					,);				
	%date_f (p_fp_sdx, 					p_fp_sdf					,%str(and need_fp = 1));				
	%date_f (p_fp_dcndx, 				p_fp_dcndf					,%str(and need_fp = 1));					
	%date_f (p_fp_edx, 					p_fp_edf					,%str(and need_fp = 1));				
	%date_f (p_fpa_sdx, 				p_fpa_sdf					,%str(and need_fpa = 1));					
	%date_f (p_fpa_edx, 				p_fpa_edf					,%str(and need_fpa = 1));					
	%date_f (p_vrrat_sdx, 				p_vrrat_sdf					,%str(and need_vrrat = 1));					
	%date_f (p_vrrat_edx, 				p_vrrat_edf					,%str(and need_vrrat = 1));					
	%date_f (p_fdpn_dx, 				p_fdpn_df					,);					
	%date_f (p_secrev_sdx, 				p_secrev_sdf				,);						
	%date_f (p_secrev_edx, 				p_secrev_edf				,);						
	%date_f (tr_finoutproccomplet_dx,	tr_finoutproccomplet_df		,%str(and Already_in_VA = 0));											
	%date_f (tr_hybrid_sepn_dx, 		tr_hybrid_sepn_df			,%str(and Already_in_VA = 0));									
	%date_f (vben_dx, 					vben_df						,%str(and Already_in_VA = 0));			
	
												
																						
%mend ForwardProcessDate;												
								

