/* Data Quality (work in progress to build Data Quality tool in SAS) */
/* Note: can we delete this file? it doesn't seem to be called from anywhere. */

%macro MissingData;

if not missing(p_secrev_edx)
	then do;
		if 	missing(m_ref_dx) or
			missing(m_pdclm_sdx) or
			missing(m_meb_edx) or
			missing(p_fdpn_dx) or
			missing(p_fdpn_x)
			then do	peblo_data = "Missing";
		else peblo_data = "Entered";
	end;

%mend MissingData;


