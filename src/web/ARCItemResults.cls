Class web.ARCItemResults Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 76;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindResultItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindResultItemsFetch ]
{
}

ClassMethod FindResultItemsExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String, ARCIMRowId As %Library.String) As %Library.Status
{
}

ClassMethod FindResultItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindResultItemsExecute ]
{
}

ClassMethod GetResultDesc(ResultID As %Library.String = "", Result As %Library.String = "") As %Library.String
{
}

Parameter SQLCODE = "RES_TestCode_DR";

Parameter SQLDESCRIPTION = "RES_RowId";

Parameter SQLROWID = "RES_RowId";

Query FindResultItems(PatientID As %Library.String, ARCIMRowId As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RESParRef,RESRowId,TCCode,TCDesc,Result,AntibodyFlag")
{
}

Query FindResultsItem(ARCIMRowId As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RESParRef:%Library.String,RESRowId:%Library.String,RESTestCodeDR:%Library.String,TCCode:%Library.String,TCDesc:%Library.String")
{
SELECT RES_ParRef,RES_RowId,RES_TestCode_DR,RES_TestCode_DR->TC_Code,RES_TestCode_DR->TC_Desc
FROM SQLUser.ARC_ItemResults
WHERE RES_ParRef=:ARCIMRowId
}

}
