Include webimport

IncludeGenerator webimport

Class web.MRCDiagnosisGroup1 Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "GRP1_Code";

Parameter SQLROWID = "GRP1_RowId";

Parameter SQLDESCRIPTION = "GRP1_Desc";

Property dummy As %String(TRUNCATE = 1);

}
