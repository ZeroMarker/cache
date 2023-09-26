Class web.PACModule Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MODUL_Code";

Parameter SQLDESCRIPTION = "MODUL_Desc";

Parameter SQLROWID = "MODUL_RowId";

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpModule(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT MODUL_Desc,MODUL_Code,MODUL_RowId
FROM SQLUser.PAC_Module
WHERE %UPPER MODUL_Desc %STARTSWITH %UPPER :desc
}

}
