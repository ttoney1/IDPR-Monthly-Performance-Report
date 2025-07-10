/* One of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
/* Together, these files form one big long data step */
/*Some warnings trigger about numeric definitions on some of these dates*/

%macro HybridDoS;
	format
		tr_hybrid_sepn_dx MMDDYY10.;
	label
		tr_hybrid_sepn_dx = "Date of Separation";
	if missing(tr_sepn_dx) and not missing(p_secrev_edx) then do;
		if missing(vben_dx) then do;
			if p_secrev_edx <= tr_vadir_sepn_dx then do;
					if /*tr_vadir_sepn_dx <= vben_dx or*/ enrolled_x = "ENROLLED" /*this contradicts the above...*/
						then tr_hybrid_sepn_dx = tr_vadir_sepn_dx;
				end;
			else tr_hybrid_sepn_dx = .;
		end;
		else if p_secrev_edx <= tr_vadir_sepn_dx <= vben_dx then tr_hybrid_sepn_dx = tr_vadir_sepn_dx;
	end;
	else tr_hybrid_sepn_dx = tr_sepn_dx;
%mend HybridDoS;

%macro HybridOutProc;
	format
		tr_hybrid_outproc_dx MMDDYY10.;
	label
		tr_hybrid_outproc_dx = "Hybrid Out-processing Date";
	if not missing(tr_hybrid_sepn_dx) and not missing(p_secrev_edx) and not missing(tr_finoutproccomplet_dx)
		then do;
			if p_secrev_edx <= tr_finoutproccomplet_dx <= tr_hybrid_sepn_dx
				then tr_hybrid_outproc_dx = tr_finoutproccomplet_dx;
			else tr_hybrid_outproc_dx = tr_hybrid_sepn_dx;
		end;
	else tr_hybrid_outproc_dx = tr_hybrid_sepn_dx;
%mend HybridOutProc;


%macro HybridFPEBAppEnd;
	format fpa_hybrid_edx MMDDYY10.;

	label fpa_hybrid_edx = "Hybrid FPEB Appeal End Date";

	if not missing(p_fpa_edx) then fpa_hybrid_edx = p_fpa_edx;
	else if not missing(p_fpa_dcndx) and p_fpa_dcndx <= MDY(10,18,2015) then
		fpa_hybrid_edx = p_fpa_dcndx;
	else fpa_hybrid_edx = .;
	
%mend HybridFPEBAppEnd;