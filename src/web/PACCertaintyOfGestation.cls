Include webimport

Class web.PACCertaintyOfGestation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "GEST_Code";

Parameter SQLDESCRIPTION = "GEST_Desc";

Parameter SQLROWID = "GEST_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

}
