Class web.INCItmLoc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 16;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "INCIL_RowId";

Parameter SQLDESCRIPTION = "INCIL_RowId";

Parameter SQLROWID = "INCIL_RowId";

ClassMethod GetItemLocData(itemID As %String, loc As %String) As %String
{
}

}
