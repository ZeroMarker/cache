Class web.PACSnomedRelation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 74;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SNOR_RowId";

Parameter SQLDESCRIPTION = "SNOR_RowId";

Parameter SQLROWID = "SNOR_RowId";

ClassMethod GetQualifiersExecute(ByRef QHandle As %Library.Binary, ConceptID As %Library.String = "") As %Library.Status
{
}

ClassMethod GetQualifiersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetQualifiersExecute ]
{
}

ClassMethod GetQualifiersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetQualifiersFetch ]
{
}

Query GetQualifiers(ConceptID As %Library.String = "") As %Library.Query(ROWSPEC = "SubQualList,QualID,QualDesc,RelID,RelDesc")
{
}

}
