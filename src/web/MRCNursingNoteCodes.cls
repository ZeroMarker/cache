Class web.MRCNursingNoteCodes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 106;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "NURN_Code";

Parameter SQLDESCRIPTION = "NURN_Text";

Parameter SQLROWID = "NURN_RowId";

/// Called by the web broker.
/// 
/// TN.
/// This is not the normal broker method!!!
/// This is used on textarea's to replace a certain code with it's description.
/// 
ClassMethod LookUpBrokerReplaceCode(code As %Library.String = "", isrtf As %String = 0) As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCodeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByCodeFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCodeExecute(ByRef QHandle As %Library.Binary, code As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCodeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByCodeExecute ]
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query FindByCode(code As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "NURNCode:%String,NURNText:%List,ID")
{
SELECT NURN_Code, NURN_Text, NURN_RowID
FROM SQLUser.MRC_NursingNoteCodes
WHERE (NURN_Code %STARTSWITH :code)
ORDER BY NURN_Code
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpByCode(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

}
