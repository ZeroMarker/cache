Class web.PACAccomSetting Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "ACCOMS_Code";

Parameter SQLDATEFROM = "ACCOMS_DateFrom";

Parameter SQLDATETO = "ACCOMS_DateTo";

Parameter SQLDESCRIPTION = "ACCOMS_Desc";

Parameter SQLROWID = "ACCOMS_RowId";

Property dummy As %String(TRUNCATE = 1);

}
