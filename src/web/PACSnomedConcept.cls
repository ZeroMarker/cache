Class web.PACSnomedConcept Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 110;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SNOC_RowId";

Parameter SQLDESCRIPTION = "SNOC_RowId";

Parameter SQLROWID = "SNOC_RowId";

ClassMethod FindConceptClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindConceptFetch ]
{
}

ClassMethod FindConceptExecute(ByRef QHandle As %Library.Binary, keyword As %Library.String, code As %Library.String) As %Library.Status
{
}

ClassMethod FindConceptFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindConceptExecute ]
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", Concept As %Library.String = "") As %Library.Status
{
}

ClassMethod FindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod FindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
}

ClassMethod HierarchyExecute(ByRef QHandle As %Library.Binary, parConceptID As %Library.String = "") As %Library.Status
{
}

ClassMethod HierarchyFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = HierarchyExecute ]
{
}

ClassMethod HierarchyClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = HierarchyFetch ]
{
}

/// Looks for description in following order
/// 1. Preferred Term from Snomed Terms (descriptions) table
/// 2. Fully Specified Name from Snomed Terms (descriptions) table
/// 3. Fully Specified Name from Snomed Concepts table
ClassMethod GetConceptDesc(ConceptID As %Library.String = "") As %Library.String
{
}

Query Hierarchy(parConceptID As %Library.String = "") As %Library.Query(ROWSPEC = "ConceptID,Description")
{
}

Query Find(Concept) As %Library.Query(ROWSPEC = "")
{
}

Query FindConcept(keyword As %String, code As %String) As %Library.Query(CONTAINID = 3, ROWSPEC = "ConceptID:%String,Desc:%String,ID")
{
SELECT 
FROM PACSnomedConcept
}

}
