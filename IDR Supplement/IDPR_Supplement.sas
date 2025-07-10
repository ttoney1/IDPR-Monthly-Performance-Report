/*Before running this, you need to run the Enchilada for the main extract*/
/*'Insufficient Exams' extract is not necessary */

/*Clean the log so you can search for errors from the top*/
dm log 'clear' Log;

*options mprint;

/*Establish the SAS library on the User's computer*/
%let this_user = &sysuserid;
%let user_folder = C:\Users\&this_user\SAS Files\;
%let destination_folder = O:\ES-TPCC-VA\TPCC\Transition Policy\DES\3. DES Pilot Working\3.1 Analysis & Reporting\3.1.3 Recurrent\03-Monthly\IDPR\Supplement\Output\&date.;

/* Find the path to the folder holding this code*/
%let filepath = %sysget(sas_execfilepath);
%let filename = %sysget(sas_execfilename);
%let program_folder = %sysfunc(substr(&filepath,1,%length(&filepath)-%length(&filename)));
%put &program_folder;
%put NOTE: This IDES program is located at &program_folder;

%include "&program_folder.Calculations\Timeliness.sas";
%IDES_Timeliness;

%include "&program_folder.Calculations\Inventory.sas";
%IDES_Inventory;

%include "&program_folder.Calculations\Disposition.sas";
%Disposition_MEB;

%include "&program_folder.Calculations\Exceeding Goal.sas";
%ides_exceeding_goal;

%include "&program_folder.Calculations\Supplement Template.sas";
%CreateTemplate;

options nomprint;
options nonotes;

%include "&program_folder.Calculations\Export.sas";
%Export;

%put NOTE: Finished executing 'IDPR Supplement';
