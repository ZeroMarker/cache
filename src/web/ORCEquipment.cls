Include webimport

IncludeGenerator webimport

Class web.ORCEquipment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EQ_Code";

Parameter SQLDESCRIPTION = "EQ_Desc";

Parameter SQLROWID = "EQ_RowId";

Property dummy As %String(TRUNCATE = 1);

}
