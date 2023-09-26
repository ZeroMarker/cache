Class web.PAAdmSepRef Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SEPREF_RowId";

Parameter SQLDESCRIPTION = "SEPREF_RowId";

Parameter SQLROWID = "SEPREF_RowId";

ClassMethod GetSepRefForAdm(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetSepRefForAdmM(EpisodeID As %Library.String) As %Library.String
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpSepRefClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSepRefFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpSepRefExecute(ByRef QHandle As %Library.Binary, EpisodeID As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpSepRefFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSepRefExecute ]
{
}

ClassMethod websysSaveAll(EpisodeID As %Library.String, SepRefs As %Library.String)
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query FindSepRef(parentid As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "ID,SEPREFDesc,SEPREFCode,SEPREFSepRef")
{
SELECT SEPREF_RowId,SEPREF_SepRef_DR->SEPREF_Desc,SEPREF_SepRef_DR->SEPREF_Code,SEPREF_SepRef_DR
FROM SQLUser.PA_AdmSepRef
WHERE SEPREF_ParRef=:parentid
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpSepRef(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "values:%String,desc:%String")
{
}

}
