Class web.PATumorMetatstatic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MET_RowId";

Parameter SQLDESCRIPTION = "MET_RowId";

Parameter SQLROWID = "MET_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveTumorMetastatic(compref As %Library.String, rowid As %Library.String, PARREF As %Library.String)
{
}

Query FindByTumor(Tumor As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "site,code,rowid,childsub,parref")
{
SELECT MET_MetastaticSite, MET_Metastatic_DR->MRCID_Code, MET_RowId, MET_Childsub, MET_ParRef
FROM SQLUser.PA_TumorMetatstatic
WHERE MET_ParRef=:Tumor
}

}
