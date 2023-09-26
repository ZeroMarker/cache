Class web.PADischargeSummary Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 44;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DIS_RowId";

Parameter SQLDESCRIPTION = "DIS_RowId";

Parameter SQLROWID = "DIS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// This returns description,id,code (this is to be consitent with lookups)
ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

}
