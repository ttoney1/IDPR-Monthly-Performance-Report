%macro inventory (start_date, end_date, stage, group, extra_condition, months);

%do i = 1 %to &months;

proc summary data = inventory;
	where
		&start_date <= intnx('Month', (MDY(&month,&day,&year)),-&i, 'END') < &end_date &extra_condition
		or (&start_date <= intnx('Month', (MDY(&month,&day,&year)),-&i, 'END') and missing(&end_date) and missing(ides_ed) &extra_condition)
		or (&start_date <= intnx('Month', (MDY(&month,&day,&year)),-&i, 'END') < ides_ed and missing(&end_date) &extra_condition);
	var &start_date;
	class &group;
	output out = &stage&i n = &stage;
run;

data &stage&i;
	set &stage&i;
	Month = &i;
run;

/* Reserve and Guard Component */
%if %index("&group",component_x) ne 0 %then %do;
proc summary data = inventory;
	where
		(component_x = 'R' or component_x = 'G') and &start_date <= intnx('Month', (MDY(&month,&day,&year)),-&i, 'END') < &end_date &extra_condition
		or (component_x = 'R' or component_x = 'G') and (&start_date <= intnx('Month', (MDY(&month,&day,&year)),-&i, 'END') and missing(&end_date) and missing(ides_ed) &extra_condition)
		or (component_x = 'R' or component_x = 'G') and (&start_date <= intnx('Month', (MDY(&month,&day,&year)),-&i, 'END') < ides_ed and missing(&end_date) &extra_condition);
	var &start_date;
	class %if %index("&group",l_meb_x) ne 0 %then %do; l_meb_x %end; %if %index("&group",service_x) ne 0 %then %do; service_x %end;;
	output out = &stage.RC&i n = &stage;
run;

data &stage.RC&i;
	set &stage.RC&i;
	Month = &i;
	component_x = 'RC';
run;
%end;

%end;

data &stage._total;
	set 
	%do i = 1 %to &months;
		&stage&i
	%end;
	%if %index("&group",component_x) ne 0 %then %do i = 1 %to &months;
		&stage.RC&i
	%end;
	;
	drop _type_ _freq_;
run;

proc datasets library=work nolist;
	delete 
		%do i = 1 %to &months;
			&stage&i
		%end;
		%if %index("&group",component_x) ne 0 %then %do i = 1 %to &months;
			&stage.RC&i
		%end;
		;
run;

proc sort data = &stage._total;
	by &group descending month;
run;

proc transpose data = &stage._total out = &stage._trans let;			
	by &group;		
	id month;		
	var &stage;
run;

%mend inventory;

%macro IDES_Inventory;

data inventory;
	set enchilada (keep = service_x m_ref_db ides_ed l_meb_x
		m_ref_db m_meb_edb
		m_ref_db m_pdclm_sdb
		m_pdclm_sdb m_vmeval_sdb
		m_vmeval_sdb m_vmeval_edb
		m_vmeval_edb m_meb_edb m_vmeval_edb m_nars_db
		m_meb_edb p_secrev_edb
		m_meb_edb p_ip_dcndb
		p_ip_dcndb p_vprat_edb
		p_ipc_edb p_fp_dcndb l_peb_x need_fp
		p_all_app_ed p_vrrat_edb need_vrrat
		p_secrev_edb tr_hybrid_sepn_db component_x
		tr_hybrid_sepn_db vben_db l_vdras_x non_active_duty);
run;

%inventory(m_ref_db, ides_ed, ides, service_x component_x l_meb_x,, 13);
%inventory(m_ref_db, m_meb_edb, m_ph, service_x component_x l_meb_x,, 13);
%inventory(m_ref_db, m_pdclm_sdb, m_ref, service_x component_x l_meb_x,, 13);
%inventory(m_pdclm_sdb, m_vmeval_sdb, m_vcd, service_x component_x l_meb_x,, 13);
%inventory(m_vmeval_sdb, m_vmeval_edb, m_vmeval, service_x component_x l_meb_x,, 13);
%inventory(m_vmeval_edb, m_meb_edb, m_st, service_x component_x l_meb_x,, 13);
%inventory(m_meb_edb, p_secrev_edb, p_ph, service_x component_x l_meb_x,, 13);
%inventory(m_meb_edb, p_ip_dcndb, p_ip, service_x component_x l_meb_x,, 13);
%inventory(p_ip_dcndb, p_vprat_edb, p_vprat, service_x component_x l_meb_x,, 13);
%inventory(p_vprat_edb, p_secrev_edb, p_disp, service_x component_x l_meb_x,, 13);
%inventory(p_secrev_edb, tr_hybrid_sepn_db, tr_ph, service_x component_x l_meb_x,%str(and non_active_duty = 0), 13);
%inventory(tr_hybrid_sepn_db, vben_db, vben_ph, service_x component_x l_meb_x,%str(and non_active_duty = 0), 13);


data IDES_Inventory;
	length _Name_ $20;
	set
		ides_trans
		m_ph_trans
		m_ref_trans
		m_vcd_trans
		m_vmeval_trans
		m_st_trans
		p_ph_trans
		p_ip_trans
		p_vprat_trans
		p_disp_trans
		tr_ph_trans
		vben_ph_trans
		;
	
	label
		ides = "IDES Inventory"
		m_ph = "MEB Phase Inventory"
		m_ref = "Referral Stage Inventory"
		m_vcd = "Claim Development Stage Inventory"
		m_vmeval = "Medical Examination Stage Inventory"
		m_st = "MEB Stage Inventory"
		m_nars = "NARSUM Stage Inventory"
		p_ph = "PEB Phase Inventory"
		p_ip = "IPEB Stage Inventory"
		p_vprat = "Proposed Rating Stage Inventory"
		p_fp = "FPEB Stage Inventory"
		p_vrrat = "Rating Reconsideration Inventory"
		p_disp = "PEB Dispositions and Appeals"
		tr_ph = "Transition Phase Inventory"
		vben_ph = "Benefits Phase Inventory";

run;
	

%put Not Finished Inventory;
proc datasets library=work nolist;
	delete 
		ides_total
		m_ph_total
		m_ref_total
		m_vcd_total
		m_vmeval_total
		m_st_total
		m_nars_total
		p_ph_total
		p_ip_total
		p_vprat_total
		p_fp_total
		p_vrrat_total
		p_disp_total
		tr_ph_total
		vben_ph_total
		vben_ph_comp_total
		ides_trans
		m_ph_trans
		m_ref_trans
		m_vcd_trans
		m_vmeval_trans
		m_st_trans
		m_nars_trans
		p_ph_trans
		p_ip_trans
		p_vprat_trans
		p_fp_trans
		p_vrrat_trans
		p_disp_total
		tr_ph_trans
		vben_ph_trans
		vben_ph_comp_trans
		inventory
		;
run;
%put Finished Inventory;

proc sort data = IDES_Inventory;
	by l_meb_x;
run;

%mend IDES_Inventory;
