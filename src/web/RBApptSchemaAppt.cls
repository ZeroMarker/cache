Class web.RBApptSchemaAppt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 76;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AP_RowId";

Parameter SQLDESCRIPTION = "AP_RowId";

Parameter SQLROWID = "AP_RowId";

ClassMethod GetOrders(SchApID As %String = "") As %Library.String
{
}

ClassMethod websysSaveAppt(compref As %String = "", id As %String = "")
{
}

}
