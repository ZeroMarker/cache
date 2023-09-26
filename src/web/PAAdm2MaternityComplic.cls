Include webimport

IncludeGenerator webimport

/// Maternity Complications
Class web.PAAdm2MaternityComplic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MATC_RowId";

Parameter SQLDESCRIPTION = "MATC_RowId";

Parameter SQLROWID = "MATC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Invoked before websysSave - can be used to cancel the save.
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

Query List(PARREF As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "MaternityComplication,RowID")
{
	select MATC_MaternityReason_DR->ADMMR_Desc, MATC_RowID
	from SQLUser.PA_Adm2MaternityComplic
	where MATC_ParRef=:PARREF
}

}
