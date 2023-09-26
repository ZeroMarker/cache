Class web.OECResDeliveryMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 7;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RDM_Code";

Parameter SQLDESCRIPTION = "RDM_Desc";

Parameter SQLROWID = "RDM_RowId";

Property dummy As %String(TRUNCATE = 1);

}
