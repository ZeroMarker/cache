Class web.OEOrdDiagnos Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 33;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DIA_RowId";

Parameter SQLDESCRIPTION = "DIA_RowId";

Parameter SQLROWID = "DIA_RowId";

ClassMethod SetOrdDiagnos(ordIDs As %String = "", diagIDs As %String = "")
{
}

ClassMethod InsertOrdDiagnos(ordID As %String)
{
}

}
