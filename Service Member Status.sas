	/* First of the files of helper code that the 'AllVariableColumns' macro in 'All' calls */
	/* Together, these files form one big long data step */

	/* These 'SM Status' variables tell some basic facts about things like Service member elections.
	/* 'Current Stage' and 'Interval' will need to reference these 'SM Status' variables*/

%macro ServiceMemberStatus;
	format
		p_req_fp $5.
		p_req_vrrat $5.
		non_active_duty 8.

		/* strictly speaking, by "need" for these five, we mean */
		/* "either SM needs this appeal step, OR has already had it" */
		need_m_rebut 8.
		need_imr 8.
		need_vrrat 8.
		need_fpa 8.
		need_fp 8.

		rtd 8.
		separated 8.
		disposition $9.;

	length
		p_req_fp $5.
		p_req_vrrat $5.;

	if p_ip_smsx = "Request FPEB" or p_ip_smsx = "Request FPEB and VA Rating Reconsideration"
		then p_req_fp = 'TRUE';
		else p_req_fp = 'FALSE';

	if p_ip_smsx = 'Request VA Rating Reconsideration' or 
		p_ip_smsx = 'Request FPEB and VA Rating Reconsideration'
		then p_req_vrrat = 'TRUE';
		else p_req_vrrat = 'FALSE';

	if disenroll_catx = "Returned to Duty" 
		or disenroll_subcatx = "Best Interest of Servicemember" 
		or disenroll_subcatx = "MEB Terminated at direction of referring physician"
		or disenroll_subcatx = "Terminated by PEB"
		then rtd = 1;
	else rtd = 0;

	if disenroll_subcatx = "SWOB (Separated Without Benefits (SWOB))"
		or disenroll_subcatx = "SWB (Separated With Benefits (SWB))"
		then separated = 1;
	else separated = 0;

	if disenroll_subcatx = "PDRL" then disposition = "PDRL";
	else if disenroll_subcatx = "TDRL" then disposition = "TDRL";
	else if separated = 1 then disposition = "Separated";
	else if rtd = 1 then disposition = "RTD";
	else disposition = "";

	/* "Non-Active Duty" was previously called "Already in VA", before we understood that these cases */
	/* are probably the Reservists who were not on active duty */
	/* This gets used in calculating the 'interval' variables: a NAD case turns up a blank for the last few stages */
	/* It should also be used in the corresponding place for the 'quality interval' variables */
	/* in order to keep the Case Tracker (from 'quality interval') synched to the IDPR (from 'interval'). */
	if duty_status = "Not on active duty" then non_active_duty = 1;
	else if not missing(vben_dx) and not missing(p_fdpn_dx) and (vben_dx < p_fdpn_dx)
		then non_active_duty = 1;
	else if not missing(vben_dx) and enrolled_x = "ENROLLED" and missing(p_fdpn_dx)
		then non_active_duty = 1;
	else non_active_duty = 0;

	/* Case requires dates for MEB Rebuttal */
	if not missing(m_rebut_sdx) or not missing(m_rebut_edx)
		then need_m_rebut = 1;
		else need_m_rebut = 0;

	/* Case requires dates for IMR */
	if not missing(imr_sdx) or not missing(imr_edx)
		then need_imr = 1;
		else need_imr = 0;

	/* Case requires dates for Rating Reconsideration */
	if not missing(p_vrrat_sdx) or not missing (p_vrrat_edx) or p_req_vrrat = 'TRUE'
		then need_vrrat = 1;
		else need_vrrat = 0;

	/* Case requires dates for FPEB Appeal */
	if not missing(p_fpa_sdx) or not missing(p_fpa_edx) or not missing(p_fpa_dcndx) or p_fp_smsx = 'Request FPEB Appeal'
		then need_fpa = 1;
		else need_fpa = 0;

	/* Case requires dates for FPEB */
	if not missing(p_fp_sdx) or not missing(p_fp_dcndx) or not missing(p_fp_edx) or p_req_fp = 'TRUE' or need_fpa = 1
		then need_fp = 1;
		else need_fp = 0;


%mend ServiceMemberStatus;
