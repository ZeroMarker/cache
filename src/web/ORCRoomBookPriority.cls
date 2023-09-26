Class web.ORCRoomBookPriority Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RBP_Code";

Parameter SQLDESCRIPTION = "RBP_Desc";

Parameter SQLROWID = "RBP_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

}
