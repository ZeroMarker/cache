Class web.PATumorClinDiagReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CDR_RowId";

Parameter SQLDESCRIPTION = "CDR_RowId";

Parameter SQLROWID = "CDR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveTumorClinDiagReason(compref As %Library.String, rowid As %Library.String, PARREF As %Library.String)
{
}

Query FindByTumor(Tumor As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "reasondesc,comment,rowid,childsub,parref")
{
SELECT CDR_ClinDiagReason_DR->CLDR_Desc, CDR_Comment, CDR_RowId, CDR_Childsub, CDR_ParRef
FROM SQLUser.PA_TumorClinDiagReason
WHERE CDR_ParRef=:Tumor
}

}
