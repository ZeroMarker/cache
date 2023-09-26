Class web.PAAdmEstDischargeHistory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 64;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ESTDIS_RowId";

Parameter SQLDESCRIPTION = "ESTDIS_RowId";

Parameter SQLROWID = "ESTDIS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// KM 14-Jan-2002: Log 21953
ClassMethod AddNew(EpisodeID As %Library.String, EstDate As %Library.Date, EstTime As %Library.Time, UserID As %Library.String)
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

}
