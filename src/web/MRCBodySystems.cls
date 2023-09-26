Class web.MRCBodySystems Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 25;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "BODS_Code";

Parameter SQLDESCRIPTION = "BODS_Desc";

Parameter SQLROWID = "BODS_RowId";

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %String = "") As %Boolean
{
}

ClassMethod LookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFetch ]
{
}

ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpExecute ]
{
}

Query LookUp(Desc As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "BodySystem:%String,Code:%String,HIDDEN:%String")
{
}

}
