Class web.MRDiagnosDistalMetasta Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MET_RowId";

Parameter SQLDESCRIPTION = "MET_RowId";

Parameter SQLROWID = "MET_RowId";

Property dummy As %String(TRUNCATE = 1);

Query GetStoredDMList(ParRef As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Desc")
{
	SELECT MET_BodySite_DR->BODS_Desc FROM SQLUser.MR_DiagnosDistalMetasta
	WHERE MET_ParRef=:ParRef
}

}
