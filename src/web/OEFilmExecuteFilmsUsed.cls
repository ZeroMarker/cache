Class web.OEFilmExecuteFilmsUsed Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 134;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod Insert(oefilmid As %Library.String = "", id As %Library.String = "", type As %Library.String = "", filmtype As %Library.String = "", number As %Library.String = "", reason As %Library.String = "", OeordIDs As %Library.String = "")
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByOrdItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByOrdItemsFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByOrdItemsExecute(ByRef QHandle As %Library.Binary, orditemids As %String = "", type As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByOrdItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByOrdItemsExecute ]
{
}

Parameter SQLCODE = "FU_RowId";

Parameter SQLDESCRIPTION = "FU_RowId";

Parameter SQLROWID = "FU_RowId";

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query Find(oefilmid As %String, type) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,FUUsageType,FUNumberOfFilms,FUFilmTypeDR,FUFilmTypeDesc,FUReasonForRejectionDR,FUReasonForRejectionDesc")
{
SELECT FU_RowID, FU_UsageType, FU_NumberOfFilms, FU_FilmType_DR, FU_FilmType_DR->FTS_Desc, FU_ReasonForRejection_DR, FU_ReasonForRejection_DR->FRR_Desc
FROM SQLUser.OE_FilmExecuteFilmsUsed
WHERE (FU_ParRef = :oefilmid) AND ((FU_UsageType = :type) OR (:type IS NULL))
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query FindDuplicate(oefilmid As %String, type, oeordID) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,FUUsageType,FUNumberOfFilms,FUFilmTypeDR,FUFilmTypeDesc,FUReasonForRejectionDR,FUReasonForRejectionDesc")
{
SELECT FU_RowID, FU_UsageType, FU_NumberOfFilms, FU_FilmType_DR, FU_FilmType_DR->FTS_Desc, FU_ReasonForRejection_DR, FU_ReasonForRejection_DR->FRR_Desc
FROM SQLUser.OE_FilmExecuteFilmsUsed, SQLUser.OE_FilmExecuteItems 
WHERE (FU_ParRef = :oefilmid) AND ((FU_UsageType = :type) OR (:type IS NULL))
AND ITM_OEORI_DR=:oeordID
AND ((ITM_OEFilmUse_DR=FU_RowId) OR (ITM_RowId=FU_RowId AND ITM_OEFilmUse_DR NOT=''))
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query FindFilmReject(oefilmid As %String, type, oeordID) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,FUUsageType,FUNumberOfFilms,FUFilmTypeDR,FUFilmTypeDesc,FUReasonForRejectionDR,FUReasonForRejectionDesc")
{
SELECT FU_RowID, FU_UsageType, FU_NumberOfFilms, FU_FilmType_DR, FU_FilmType_DR->FTS_Desc, FU_ReasonForRejection_DR, FU_ReasonForRejection_DR->FRR_Desc
FROM SQLUser.OE_FilmExecuteFilmsUsed, SQLUser.OE_FilmExecuteItems 
WHERE (FU_ParRef = :oefilmid) AND ((FU_UsageType = :type) OR (:type IS NULL))
AND ITM_OEORI_DR=:oeordID
AND ITM_RowId=FU_OEFilmExecuteItems_DR
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query FindFilmUsed(oefilmid As %String, type, oeordID) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,FUUsageType,FUNumberOfFilms,FUFilmTypeDR,FUFilmTypeDesc,FUReasonForRejectionDR,FUReasonForRejectionDesc")
{
SELECT FU_RowID, FU_UsageType, FU_NumberOfFilms, FU_FilmType_DR, FU_FilmType_DR->FTS_Desc, FU_ReasonForRejection_DR, FU_ReasonForRejection_DR->FRR_Desc
FROM SQLUser.OE_FilmExecuteFilmsUsed, SQLUser.OE_FilmExecuteItems 
WHERE (FU_ParRef = :oefilmid) AND ((FU_UsageType = :type) OR (:type IS NULL))
AND ITM_OEORI_DR=:oeordID
AND ITM_RowId=FU_OEFilmExecuteItems_DR
}

/// LookUp used to populate listbox of items
Query LookUpByOrdItems(orditemids, type) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

}
