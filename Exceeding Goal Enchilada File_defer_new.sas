/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
/* Together, these files form one big long data step */

/*Move this call AFTER the creation of master_deferment and make the datastep call master_deferment sa both*/

%macro exceeding_goal (start_date, end_date, stage, extra_condition, a_goal, r_goal, months);	
	/*SW: why do we not make these booleans, or control the size of the variables? */
	if
		(&start_date <= (MDY(&month,&day,&year)) < &end_date and missing(finaldefertime) &extra_condition)
		or (&start_date <= (MDY(&month,&day,&year)) and missing(&end_date) and missing(ides_ed) and missing(finaldefertime) &extra_condition)
		or (&start_date <= (MDY(&month,&day,&year)) < ides_ed and missing(&end_date) and missing(finaldefertime) &extra_condition)
	then days_in_&stage = (MDY(&month,&day,&year))-&start_date;
	else if finaldefertime^=. then days_in_&stage = (((MDY(&month,&day,&year))-&start_date)-finaldefertime);
	else days_in_&stage = .;
	/*here's where we have to insert the deferment conditions */
	if not missing(days_in_&stage)
	then do;
		if component_x = "A" then do;
			if days_in_&stage > &a_goal
				then exceeding_&stage = 1;
			else exceeding_&stage = 0;
			end;
		else if component_x = "R" or component_x = "G" then do;
			if days_in_&stage > &r_goal
				then exceeding_&stage = 1;
			else exceeding_&stage = 0;
			end;
	end;
	else exceeding_&stage = .;
%mend exceeding_goal;


%macro IDESexceeding;

	%exceeding_goal(m_ref_db, ides_ed, ides,, 295, 305, 1);
	%exceeding_goal(m_ref_db, m_meb_edb, m_ph,, 100, 140, 1);
	%exceeding_goal(m_ref_db, m_pdclm_sdb, m_ref,, 10, 30, 1);			
	%exceeding_goal(m_pdclm_sdb, m_vmeval_sdb, m_vcd,, 10, 30, 1);			
	%exceeding_goal(m_vmeval_sdb, m_vmeval_edb, m_vmeval,, 45, 45, 1);			
	%exceeding_goal(m_vmeval_edb, m_meb_edb, m_st,, 35, 35, 1);	
	%exceeding_goal(m_vmeval_edb, m_nars_db, m_nars,, 5, 5, 1);
	%exceeding_goal(m_meb_edb, p_secrev_edb, p_ph,, 120, 120, 1);
	%exceeding_goal(m_meb_edb, p_ip_dcndb, p_ip,, 15, 15, 1);
	%exceeding_goal(p_ip_dcndb, p_vprat_edb, p_vprat,, 15, 15, 1);
	%exceeding_goal(p_ipc_edb, p_fp_dcndb, p_fp,%str(and need_fp = 1), 30, 30, 1);
	%exceeding_goal(p_fp_edb, fpa_hybrid_edb, p_fpa,%str(and need_fpa = 1), 30, 30, 1);
	%exceeding_goal(p_all_app_ed, p_vrrat_edb, p_vrrat,%str(and need_vrrat = 1), 30, 30, 1);
	%exceeding_goal(p_vprat_edb, p_secrev_edb, p_disp,, 90, 90, 1);
	%exceeding_goal(p_secrev_edb, tr_hybrid_sepn_db, tr_ph,%str(and Already_in_VA = 0), 45, 45, 1);			
	%exceeding_goal(tr_hybrid_sepn_db, vben_db, vben_ph,%str(and Already_in_VA = 0), 30, 30, 1);

%mend IDESexceeding;
