Class web.OEOrdSpecimen Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 127;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SPEC_Code";

Parameter SQLDESCRIPTION = "SPEC_RowId";

Parameter SQLROWID = "SPEC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetCollectionDateTime(Parref As %Library.String = "") As %Library.String
{
}

ClassMethod GetReceivedDateTime(OEOrdItem As %String = "") As %Library.String
{
}

Query FindLabEpisodeNo(LabOrdDescEpNo As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ItemDesc:%String,LabEpNo:%String")
{
}

ClassMethod FindLabEpisodeNoClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLabEpisodeNoFetch ]
{
}

/// HiddenDelete is only there to pass on for paging
ClassMethod FindLabEpisodeNoExecute(ByRef QHandle As %Library.Binary, LabOrdDescEpNo As %Library.String = "") As %Library.Status
{
}

ClassMethod FindLabEpisodeNoFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLabEpisodeNoExecute ]
{
}

ClassMethod FindTestSet(arcim As %Library.String = "") As %Library.String
{
}

ClassMethod LookUpSpecimenClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSpecimenFetch ]
{
}

ClassMethod LookUpSpecimenExecute(ByRef QHandle As %Library.Binary, Order As %String, arcim As %Library.String) As %Library.Status
{
}

ClassMethod LookUpSpecimenFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSpecimenExecute ]
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpSpecimen(desc As %String, ARCIM As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "code:%String,desc:%String,defstatus:%String")
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Log 43867 - AI - 30-06-2004 : Save the Reason Not Collected from the single Specimen to all Specimens in the Lab Episode Number.
/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

}
