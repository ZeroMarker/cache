Class web.MRCClinNotesType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "CNT_Code";

Parameter SQLDESCRIPTION = "CNT_Desc";

Parameter SQLROWID = "CNT_RowId";

}
