Include webimport

Class web.PACMaconiumStain Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "MACS_Code";

Parameter SQLDESCRIPTION = "MACS_Desc";

Parameter SQLROWID = "MACS_RowId";

}
