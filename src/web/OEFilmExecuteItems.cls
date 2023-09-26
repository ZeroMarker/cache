Class web.OEFilmExecuteItems Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ITM_RowId";

Parameter SQLDESCRIPTION = "ITM_RowId";

Parameter SQLROWID = "ITM_RowId";

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query FindGroupedItems(oefilmid) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OrdItemID,ARCItmMastID,ARCIMDesc")
{
SELECT ITM_RowID, ITM_OEORI_DR, ITM_OEORI_DR->OEORI_ItmMast_DR, ITM_OEORI_DR->OEORI_ItmMast_DR->ARCIM_Desc
FROM SQLUser.OE_FilmExecuteItems
WHERE ITM_ParRef = :oefilmid
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query FindPreviouslyGroupedItem(searchDate) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OrdItemID,ARCItmMastID,ARCIMDesc")
{
SELECT ITM_RowID, ITM_OEORI_DR, ITM_OEORI_DR->OEORI_ItmMast_DR, ITM_OEORI_DR->OEORI_ItmMast_DR->ARCIM_Desc
FROM SQLUser.OE_FilmExecuteItems, SQLUser.OE_FilmExecute
WHERE ITM_ParRef = OEFE_RowId
AND OEFE_Date=:searchDate
}

}
