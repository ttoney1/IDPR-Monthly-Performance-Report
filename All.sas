/* Calculate all variables for each case */

	/* In one big long data step whose code is spread		*/
	/* across multiple files,								*/
	/* create the dataset "enchilada" that will             */
	/* perform *all* case-by-case calculations              */
	/* needed for *any* VTA extract-based                   */
	/* product this week				                    */

%macro AllVariableColumns;
data enchilada;
	set extract;

	/* 1. Service Member Status variables include:  */
	/* a placeholder for Non Active Duty			*/
	/* Did the Service member have any appeals?		*/
	/* Dispositions									*/
	%include "&program_folder.Helper Code\Variables\Service Member Status.sas";
	%ServiceMemberStatus;

	/* 2.'Hybrid Dates' is first of two files where we arrive at process start/end dates
	/* by choosing conditionally between extract dates */ 
	%include "&program_folder.Helper Code\Variables\Hybrid Dates.sas";
	/* First, Hybrid Date of Separation
	/* Figures out which Date of Separation to use: VTA is preferable to VADIR */
	%HybridDoS;
	/* Then, Hybrid Out Processing Date figures out which date marks the end of Transition:
	/* 'Date Final Outprocessing Complete' is preferable to the Hybrid DoS		*/
	%HybridOutProc;
	/*New Field added for FPEB Appeal End Date all old data in FPEB Appeal Decision Date */
	%HybridFPEBAppEnd;

	/* 3. Backward Process Date variables include:
	/* Consistent Dates (backward)					*/
	/* Last Sequential Date (Date)					*/
	/* Last Sequential Date (Name)					*/
	/* Next Sequential Date (Name)					*/
	%include "&program_folder.Helper Code\Variables\Backward Process Dates.sas";
	%BackwardProcessDate;

	/* 4. Current Stage variables include:
	/* Last Chronological Date (Date)				*/
	/* Last Chronological Date (Name)				*/
	/* Stage										*/
	/* Phase										*/
	/* VTA Tab Responsible for Next Date				*/
	%include "&program_folder.Helper Code\Variables\Current Stage.sas";
	%CurrentStage;

	/* Consistent Dates (forward)					*/
	/* Pretty much the same as "backward", but reversed. The "backward" logic is preferable.
	/* Therefore, the "(forward)" one is commented out here.
	%include "&program_folder.Helper Code\Variables\Forward Process Dates.sas";
	%ForwardProcessDate;
	*/

	/* 5. 'Quality Dates' has Quality-Flagged Dates
	/* COULD MOVE THIS CODE TO CASE TRACKER */
	/* Unlike a column in Excel, a variable in SAS must be either a number or a string, not both. */
	/* Here, we represent the date as a string with a message explaining data entry quality,
	/* such as '(missing)' (to output to Case Tracker) */
	%include "&program_folder.Helper Code\Variables\Quality Dates.sas";
	%QualityDate;

	/* 6. Quality Service Member Status				*/
	/* COULD MOVE THIS CODE TO CASE TRACKER */
	%include "&program_folder.Helper Code\Variables\Quality Status.sas";
	%QualityStatus;

	/* 7.'More Hybrid Dates' is second of two files where we arrive at process start/end dates
	/* by choosing conditionally between extract dates */ 
	%include "&program_folder.Helper Code\Variables\More Hybrid Dates.sas";
	/* 'End of all Appeals' file, for some reason, only has 'End of DoD	*/
	/* Appeals' variable spelled out, not 'End of All Appeals'.*/
	%EndofAppeals;
	/* IDES End Date is either VA Benefits, SR End 	*/
	/* or last date entered for RTD						*/
	%IDESEndDate;

	/* 8. 'Interval' metrics are case-by-case timeliness calculations, returning numbers */
	%include "&program_folder.Helper Code\Variables\Interval.sas";
	%ServiceMemberInterval;

	/* 9. 'Quality Interval' has 'Quality-flagged Intervals': timeliness metrics represented as strings, */
	/* so that if there's a data quality error we can write something like 'missing' */
	/* (to output to Case Tracker)		*/
	%include "&program_folder.Helper Code\Variables\Quality Interval.sas";
	%QualityInterval;

	/* 10. 'Met Goal' file has a 0-or-1 variable for each stage that has a goal,
	/* indicating whether the case (AFTER COMPLETING) met goal in the stage for its component */
	%include "&program_folder.Helper Code\Variables\Met Goal.sas";
	%IntervalGoal;

	/* 11. 'Exceeding Goal' Currently exceeding goal status				*/
	%include "&program_folder.Helper Code\Variables\Exceeding Goal.sas";
	%IDESexceeding;

run;
%put Note: Completed AllVariableColumns;
%mend AllVariableColumns;
