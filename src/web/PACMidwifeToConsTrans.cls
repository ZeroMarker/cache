Include webimport

Class web.PACMidwifeToConsTrans Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MIDW_Code";

Parameter SQLDESCRIPTION = "MIDW_Desc";

Parameter SQLROWID = "MIDW_RowId";

}
