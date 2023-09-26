Include webimport

IncludeGenerator webimport

Class web.PACNonGovOrg Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 110;

Parameter SQLDATEFROM = "NGO_DateFrom";

Parameter SQLDATETO = "NGO_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "NGO_Code";

Parameter SQLDESCRIPTION = "NGO_Desc";

Parameter SQLROWID = "NGO_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpAddressBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", vdate As %Library.Date = "", school As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpNGODetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpNGODetailsFetch ]
{
}

ClassMethod LookUpNGODetailsExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, vdate As %Library.Date = "", school As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpNGODetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpNGODetailsExecute ]
{
}

/// Look up name of organisation,it's address,suburb and postcode and pref contact method
Query LookUpAddress(desc As %Library.String, vdate As %Library.Date, school As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Desc:%String,Id:%String,Address:%String,City:%String,ZIP:%String,contact:%String,email:%String,fax:%String,phone:%String")
{
SELECT NGO_Code, NGO_Desc, NGO_RowId, NGO_Address, NGO_City_DR->CTCIT_Desc, NGO_Zip_DR->CTZIP_Code, NGO_ContactMethod, NGO_Email, NGO_Fax, NGO_Phone
FROM SQLUser.PAC_NonGovOrg
WHERE ((NGO_Code %STARTSWITH :desc) OR (NGO_Desc %STARTSWITH :desc))
AND	((NGO_DateFrom IS NULL) OR (:vdate IS NULL)OR (NGO_DateFrom <=:vdate)) 
AND	((NGO_DateTo IS NULL) OR (:vdate IS NULL) OR (NGO_DateTo >=:vdate))
AND	((:school IS NULL) OR ((:school='Y') AND (NGO_School='Y')))
}

/// Look up name of organisation,it's address,suburb and postcode and pref contact method
Query LookUpNGODetails(desc As %Library.String, vdate As %Library.Date, school As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Desc:%String,Id:%String,Address:%String,City:%String,ZIP:%String,contact:%String,email:%String,fax:%String,phone:%String")
{
}

}
