Class web.OECImpression Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 25;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "IMPR_Code";

Parameter SQLDESCRIPTION = "IMPR_Desc";

Parameter SQLROWID = "IMPR_RowId";

Property dummy As %String(TRUNCATE = 1);

}
