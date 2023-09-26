Class web.PACAdmissionPoint Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 171;

Parameter SQLDATEFROM = "ADMPOINT_DateFrom";

Parameter SQLDATETO = "ADMPOINT_DateTo";

Parameter SQLCODE = "ADMPOINT_Code";

Parameter SQLDESCRIPTION = "ADMPOINT_Desc";

Parameter SQLROWID = "ADMPOINT_RowId";

/// AJI 18/11/03 - 37966 : added filter by user logon hospital
ClassMethod LookUpWLBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String, usergroup As %String = "", hospDesc As %String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpWLClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWLFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpWLExecute(ByRef QHandle As %Library.Binary, desc As %String, usergroup As %String, hospDesc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
/// AJI 18/11/03 - 37966 : added filter by user logon hospital
ClassMethod LookUpWLFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWLExecute ]
{
}

///  Basic query returning description from a partial description, ordered by description.
///  Compiled will attempt to derive the 'description' property from available properties unless it is explicity
///  set in the SQLDESCRIPTION parameter.
///  SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpWL(desc As %String, usergroup As %String, hospDesc As %String) As %Query(ROWSPEC = "Code:%String,Description:%String")
{
}

}
