Include webimport

IncludeGenerator webimport

Class web.PHCDrgMast Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 108;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "PHCD_Code";

Parameter SQLDESCRIPTION = "PHCD_Name";

Parameter SQLROWID = "PHCD_RowId";

Query LookUpByGenRtFrm(desc, rtFrm) As %SQLQuery(CONTAINID = 0, ROWSPEC = "PHCDName:%String,HIDDEN:%String,PHCDCode:%String")
{
SELECT PHCD_Name,PHCD_RowId, PHCD_Code
FROM PHC_DrgMast,PHC_GenericRtForms
WHERE ((PHCD_Name %STARTSWITH :desc) OR (PHCD_Code %STARTSWITH :desc))
AND PHCD_Generic_DR->PHCGE_RowId=RTF_ParRef
AND ((RTF_Ident=:rtFrm) OR (:rtFrm IS NULL))
ORDER BY PHCD_Name
}

ClassMethod LookUpBrokerByGenRtFrm(itmjs As %String = "", itmjsex As %String = "", val As %String = "", val2 As %String) As %Boolean
{
}

Query LookUpMaster(desc, active) As %Library.Query(CONTAINID = 0, ROWSPEC = "PHCDName:%String,HIDDEN:%String,PHCDCode:%String")
{
}

ClassMethod LookUpMasterClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpMasterFetch ]
{
}

/// ab 18.10.06 61252 - now checking that at least one drug form is active if 'active' is passed
ClassMethod LookUpMasterExecute(ByRef QHandle As %Library.Binary, desc As %String = "", active As %String = "") As %Library.Status
{
}

ClassMethod LookUpMasterFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpMasterExecute ]
{
}

ClassMethod LookUpMasterBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", active As %String = "") As %Boolean
{
}

}
