Class web.MRCBodySystemProblemSubp Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SUBP_Code";

Parameter SQLDESCRIPTION = "SUBP_Desc";

Parameter SQLROWID = "SUBP_RowId";

ClassMethod LookUpByBodSysProbBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %String = "", Bodsysprob As %String = "") As %Boolean
{
}

ClassMethod LookUpByBodSysProbClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByBodSysProbFetch ]
{
}

ClassMethod LookUpByBodSysProbExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "", Bodsysprob As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByBodSysProbFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByBodSysProbExecute ]
{
}

Query LookUpByBodSysProb(Desc As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "SubProblem:%String,Problem:%String,BodySystem:%String,HIDDEN:%String")
{
}

}
