
	/****************************************/
	/* Met Goal                             */
	/****************************************/
/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
/* Together, these files form one big long data step */

%macro goal(interval, met_goal, a_goal, r_goal);
	if missing(&interval)
		then &met_goal = .;
	else do;
		if component_x = "A"
			then do;
				if &interval <= &a_goal
					then &met_goal = 1;
					else &met_goal = 0;
			end;
		else if component_x = "R"
			then do;
				if &interval <= &r_goal
					then &met_goal = 1;
					else &met_goal = 0;
			end;
		else if component_x = "G"
			then do;
				if &interval <= &r_goal
					then &met_goal = 1;
					else &met_goal = 0;
			end;
		else &met_goal = .;
	end;
%mend goal;

%macro IntervalGoal;
	%goal(ides_t, ides_tg, 295, 305);
	%goal(ides_noleave_t, ides_noleave_tg, 295, 305);
	%goal(ides_nortd_t, ides_nortd_tg, 295, 305);
	%goal(ides_noleave_nortd_t, ides_noleave_nortd_tg, 295, 305);
	%goal(m_ph_t, m_ph_tg, 100, 140);
	%goal(m_ref_t, m_ref_tg, 10, 30);
	%goal(m_vcd_t, m_vcd_tg, 10, 30);
	%goal(m_vmeval_t, m_vmeval_tg, 45, 45);
	%goal(m_st_t, m_st_tg, 35, 35);
	%goal(m_nars_t, m_nars_tg, 5, 5);
	%goal(p_ph_t, p_ph_tg, 120, 120);
	%goal(p_ip_t, p_ip_tg, 15, 15);
	%goal(p_vprat_t, p_vprat_tg, 15, 15);
	%goal(p_ipc_t, p_ipc_tg, 10, 10);
	%goal(p_fp_t, p_fp_tg, 30, 30);
	%goal(p_fpa_t, p_fpa_tg, 30, 30);
	%goal(p_vrrat_t, p_vrrat_tg, 15, 15);
	%goal(tr_ph_noleave_t, tr_ph_noleave_tg, 45, 45);
	%goal(tr_ph_t, tr_ph_tg, 45, 45);
	%goal(vben_ph_t, vben_ph_tg, 30, 30);
	%goal(ides_dod_core, ides_dod_coreg, 105, 125);
%mend IntervalGoal;
