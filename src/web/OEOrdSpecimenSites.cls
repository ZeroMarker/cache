Class web.OEOrdSpecimenSites Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SITE_Code";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetSpecimenSites(SITEParRef As %Library.String) As %Library.String
{
}

ClassMethod GetSites(SITEParRef As %Library.String) As %Library.String
{
}

ClassMethod OEORDSpecimenSitesInsert(SITEParRef As %Library.String = "")
{
}

Parameter SQLDESCRIPTION = "SITE_RowId";

Parameter SQLROWID = "SITE_RowId";

}
