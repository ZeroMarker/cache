Include webimport

IncludeGenerator webimport

Class web.PHCInstruc Extends (%RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 152;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "PHCIN_Code";

Parameter SQLDESCRIPTION = "PHCIN_Desc1";

Parameter SQLROWID = "PHCIN_RowId";

ClassMethod LookUpReplaceInstr(code As %Library.String = "", drgfrm As %Library.String = "", itmMast As %Library.String = "") As %Library.Boolean
{
}

Query LookUpInstr(Desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Desc:%String,Code:%String")
{
}

ClassMethod LookUpInstrClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpInstrFetch ]
{
}

/// Iimplementation of LookUp Query for category depending on the groupID
ClassMethod LookUpInstrExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpInstrFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpInstrExecute ]
{
}

}
