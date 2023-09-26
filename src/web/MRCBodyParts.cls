Include webimport

IncludeGenerator webimport

Class web.MRCBodyParts Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 107;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "BODP_Code";

Parameter SQLDESCRIPTION = "BODP_Desc";

Parameter SQLROWID = "BODP_RowId";

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

Query LookUp(Desc As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Body Part:%String,Code:%String,HIDDEN:%String")
{
}

}
