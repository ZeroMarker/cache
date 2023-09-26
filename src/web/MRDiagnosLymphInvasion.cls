Class web.MRDiagnosLymphInvasion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 15;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DLI_RowId";

Parameter SQLDESCRIPTION = "DLI_RowId";

Parameter SQLROWID = "DLI_RowId";

Property dummy As %String(TRUNCATE = 1);

Query GetStoredLIList(ParRef As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Desc")
{
	SELECT DLI_BodySite_DR->BODS_Desc FROM SQLUser.MR_DiagnosLymphInvasion 
	WHERE DLI_ParRef=:ParRef
}

}
