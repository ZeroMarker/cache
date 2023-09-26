Class web.PACClinic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 155;

Parameter SQLCODE = "CLN_Code";

Parameter SQLDATEFROM = "CLN_DateFrom";

Parameter SQLDESCRIPTION = "CLN_Desc";

Parameter SQLDATETO = "CLN_DateTo";

Parameter SQLROWID = "CLN_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// cjb 29/07/2004 44103
ClassMethod GenerateCode(compid As %String, id As %String) As %String
{
}

/// cjb 03/02/2005 49474 - now returns clinaddr2
ClassMethod GetFullClinicAddress(ClinicCode As %String = "") As %String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// 
ClassMethod LookupByCodeCustomBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", clinicdesc As %Library.String, clinicaddr As %Library.String, temp As %Library.String, DocRowId As %Library.String, Multi As %Library.String) As %Library.Boolean
{
}

/// called from LookupByCodeCustomBroker and pacclinic.update.csp to retrieve the same data
ClassMethod GetBrokerData(ID As %Library.String) As %Library.String
{
}

ClassMethod LookupByCodeCustom2Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupByCodeCustom2Fetch ]
{
}

ClassMethod LookupByCodeCustom2Execute(ByRef QHandle As %Library.Binary, cliniccode As %Library.String, clinicdesc As %Library.String, clinicaddr As %Library.String, temp As %Library.String, DocRowId As %Library.String, Multi As %Library.String) As %Library.Status
{
}

ClassMethod LookupByCodeCustom2Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupByCodeCustom2Execute ]
{
}

Query LookupByCodeCustom2(cliniccode As %Library.String, clinicdesc As %Library.String, clinicaddr As %Library.String, temp As %Library.String, DocRowId As %Library.String, Multi As %Library.String) As %Library.Query(CONTAINID = 2, ROWSPEC = "CLNCode,CLNAddress1,CLNAddress2,CLNDesc,CLNDatefrom,CLNDateto,CLNEmail,CLNFax,CLNPhone,CLNVEMD,CTCITDesc,CTZIPCode,HIDDEN,CLNProviderNo,CLNBusPhone,FullAddress,HIDDEN")
{
}

Query LookupByCodeCustom(codedesc As %String, clinicaddr As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "CLNCode,CLNAddress1,CLNAddress2,CLNDesc,CLNDatefrom,CLNDateto,CLNEmail,CLNFax,CLNPhone,CLNVEMD,CTCITDesc,CTZIPCode,CLNRowId")
{
SELECT CLN_Code,CLN_Address1,CLN_Address2,CLN_Desc,CLN_DateFrom,CLN_DateTo,CLN_Email,CLN_Fax,CLN_Phone,CLN_VEMD,CLN_City_DR->CTCIT_Desc,CLN_Zip_DR->CTZIP_Code,CLN_RowId
FROM SQlUser.PAC_Clinic
}

/// cjb 14/11/2006 50857 - added default sort by clin desc
Query LookupByCodeCustom1(cliniccode As %String, clinicdesc As %String, clinicaddr As %String, rdate As %Date, Multi As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CLNCode,CLNAddress1,CLNAddress2,CLNDesc,CLNDatefrom,CLNDateto,CLNEmail,CLNFax,CLNPhone,CLNVEMD,CTCITDesc,CTZIPCode,CLNRowId,CLNProviderNo,CLNBusPhone")
{
SELECT CLN_Code,CLN_Address1,CLN_Address2,CLN_Desc,CLN_DateFrom,CLN_DateTo,CLN_Email,CLN_Fax,CLN_Phone,CLN_VEMD,CLN_City_DR->CTCIT_Desc,CLN_Zip_DR->CTZIP_Code,CLN_RowId,CLN_ProviderNo,CLN_BusPhone
FROM SQlUser.PAC_Clinic 
WHERE (
	(
		(:Multi IS NULL)
		AND ((CLN_Code %STARTSWITH :cliniccode)
			AND (CLN_Desc %STARTSWITH :clinicdesc)
			AND ((CLN_City_DR->CTCIT_Desc IS NULL) OR (CLN_City_DR->CTCIT_Desc %STARTSWITH :clinicaddr))
		)
	) OR (
		(:Multi IS NOT NULL)
		AND ((CLN_Code %STARTSWITH :Multi)
			OR (CLN_Desc %STARTSWITH :Multi)
			OR (CLN_Address1 %STARTSWITH :Multi)
		)
	)

	AND	((CLN_DateFrom IS NULL) OR (CLN_DateFrom<= :rdate))
	AND	((CLN_DateTo IS NULL) OR (CLN_DateTo>= :rdate))
)
ORDER BY CLN_Desc
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

}
