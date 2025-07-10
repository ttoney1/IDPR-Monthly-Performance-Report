	/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
	/* Together, these files form one big long data step */

%macro CurrentStage;

	format 
		lchr_dn $62.
		lchr_dd MMDDYY10.
		stage $26.
		phase $24.
		tab_resp_for_nseq $9.
		department_resp $6.;

	length
		lchr_dn $62.
		stage $26.
		phase $24.
		tab_resp_for_nseq $9.;

	label
		lchr_dn = "Last Chronological Date (Name)"
		lchr_dd = "Last Chronological Date (Date)"
		stage = "Stage as of &date"
		phase = "Phase as of &date"
		tab_resp_for_nseq = "Tab Responsible for Next Sequential Date";

	array date_chr[*] 
		/*dropped stuff, in order from the one we least want to display to most*/
		old_p_fp_ddx
		old_p_fpa_dcndx
		old_p_vpratreq_dx
		old_p_vprat_edx
		old_p_vrrat_edx
		old_p_venters_rat_and_award_dx
		old_tr_vreceives_dd214_dx
		p_vrratreq_dx
		p_vnotified_of_fdpn_dx
		/*real stuff*/
		m_ref_dx
		m_pdclm_sdx
		m_vmsc_sm_intvw_dx
		m_vmeval_sdx
		m_vex_edx
		m_vmeval_edx
		m_nars_dx
		imr_sdx
		imr_edx
		m_rebut_sdx
		m_rebut_edx
		m_meb_edx
		p_ip_sdx
		p_ip_dcndx
		p_vprat_sdx
		p_vprat_edx
		p_cfa_sdx
		p_cfa_edx
		p_ipc_sdx
		p_ipc_edx
		p_fp_sdx
		p_fp_dcndx
		p_fp_edx
		p_fpa_sdx
		p_fpa_dcndx
		p_fpa_edx
		p_vrrat_sdx
		p_vrrat_edx
		p_fdpn_dx
		p_secrev_sdx
		p_secrev_edx
		tr_finoutproccomplet_dx
		tr_vadir_sepn_dx
		tr_sepn_dx
		vben_dx;

	/*Last Chronological Date*/
	lchr_dd = max(of date_chr[*]);

	do i = 1 to dim(date_chr);
		if date_chr[i] = lchr_dd
			then lchr_dn = vlabel(date_chr[i]);
	end;

	if missing(lchr_dd)
		then lchr_dn = "(no dates entered)";

	select (nseq_dn);
		when ("Disenrolled") do;
			stage = "Disenrolled";
			phase = "Disenrolled";
			tab_resp_for_nseq = "--";
			department_resp = "--";
			end;
		when ("(disenrollment)") do;
			stage = "(awaiting disenrollment)";
			phase = "(awaiting disenrollment)";
			department_resp = "--";
			tab_resp_for_nseq = "--";
			end;
		when ("(awaiting disenrollment)") do;
			stage = "(awaiting disenrollment)";
			phase = "(awaiting disenrollment)";
			tab_resp_for_nseq = "--";
			department_resp = "--";
			end;
		when ("VA Benefits Date") do;
			stage = "VA Benefits";
			phase = "VA Benefits";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("Final Out-Processing Completion Date") do;
			stage = "Transition";
			phase = "Transition";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("Date of Separation") do;
			stage = "Transition";
			phase = "Transition";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("VTA Separation Date") do;
			stage = "Transition";
			phase = "Transition";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("VADIR Separation Date") do;
			stage = "Transition";
			phase = "Transition";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("Secretarial Review End Date") do;
			stage = "Sec. Review of Final Disp.";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("Secretarial Review Start Date") do;
			stage = "Sec. Review of Final Disp.";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("Final Disposition Date") do;
			stage = "Post-Appeal Disposition";
			phase = "PEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("VA Rating Reconsideration End Date") do;
			stage = "VA Rating Reconsideration";
			phase = "PEB";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("VA Rating Reconsideration Start Date") do;
			stage = "VA Rating Reconsideration";
			phase = "PEB";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("FPEB Appeal End Date") do;
			stage = "FPEB Appeal";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("FPEB Appeal Decision Date") do;
			stage = "FPEB Appeal";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("FPEB Appeal Start Date") do;
			stage = "FPEB Appeal";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("FPEB End Date") do;
			stage = "FPEB";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("FPEB's Decision Date") do;
			stage = "FPEB";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("FPEB Start Date") do;
			stage = "FPEB";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("IPEB Counsel End Date") do;
			stage = "IPEB Counsel";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("Case File Assembly End Date") do;
			stage = "Case File Assembly";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("Case File Assembly Start Date") do;
			stage = "Case File Assembly";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("VA Preliminary Rating End Date") do;
			stage = "VA Proposed Rating";
			phase = "PEB";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("VA Preliminary Rating Start Date") do;
			stage = "VA Proposed Rating";
			phase = "PEB";
			tab_resp_for_nseq = "R/O";
			department_resp = "VA";
			end;
		when ("IPEB's Decision Date") do;
			stage = "IPEB Stage";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("IPEB Start Date") do;
			stage = "IPEB Stage";
			phase = "PEB";
			tab_resp_for_nseq = "PEB Admin";
			department_resp = "DoD";
			end;
		when ("MEB End Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("MEB Rebuttal End Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("MEB Rebuttal Start Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("MEB End Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("IMR End Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("IMR Start Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("MEB End Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("MEB End Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("NARSUM Date") do;
			stage = "MEB Stage";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("VA Medical Evaluation End Date") do;
			stage = "VA Medical Exam";
			phase = "MEB";
			tab_resp_for_nseq = "MSC";
			department_resp = "VA";
			end;
		when ("VA Exam End Date") do;
			stage = "VA Medical Exam";
			phase = "MEB";
			tab_resp_for_nseq = "MSC";
			department_resp = "VA";
			end;
		when ("MSC-Service Member Interview Date") do;
			stage = "Claim Development";
			phase = "MEB";
			tab_resp_for_nseq = "MSC";
			department_resp = "VA";
			end;
		when ("VA Medical Evaluation Start Date") do;
			stage = "Claim Development";
			phase = "MEB";
			tab_resp_for_nseq = "MSC";
			department_resp = "VA";
			end;
		when ("Prepare Claim Start Date") do;
			stage = "Referral";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD/VA";
			end;
		when ("Prepared Claim Start Date") do;
			stage = "Referral";
			phase = "MEB";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		when ("MEB Referral Date") do;
			stage = "(no dates entered)";
			phase = "(no dates entered)";
			tab_resp_for_nseq = "PEBLO";
			department_resp = "DoD";
			end;
		otherwise;
	end;

%mend CurrentStage;
