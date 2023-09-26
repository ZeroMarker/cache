Class web.OEFilmExecuteIsotope Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod Insert(oefilmid As %Library.String = "", id As %Library.String = "", type As %Library.String = "", isodose As %Library.String = "")
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByOrdItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByOrdItemsFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByOrdItemsExecute(ByRef QHandle As %Library.Binary, orditemids As %String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByOrdItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByOrdItemsExecute ]
{
}

Parameter SQLCODE = "IS_RowId";

Parameter SQLDESCRIPTION = "IS_RowId";

Parameter SQLROWID = "IS_RowId";

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query Find(oefilmid) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ISIsotopeDose:%Float,RADFId,RADFDesc")
{
SELECT IS_RowID, IS_IsotopeDose, IS_RadioPharmaceutical_DR, IS_RadioPharmaceutical_DR->RADF_Desc
FROM SQLUser.OE_FilmExecuteIsotope
WHERE (IS_ParRef = :oefilmid)
}

/// LookUp used to populate listbox of items
Query LookUpByOrdItems(orditemids) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

}
