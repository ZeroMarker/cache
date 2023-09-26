Class web.MRCNursingNotesStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 97;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "NNS_Code";

Parameter SQLDESCRIPTION = "NNS_Desc";

Parameter SQLROWID = "NNS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetDescriptionFromCodeOrID(val As %Library.String) As %Library.String
{
}

/// This is a borker to give the illusion of having an option "No Notes" as well as the two options "Entered" and
/// "Authorised" that are in the code table.
/// 
/// Used in MRNursingNotes.Find 
ClassMethod LookUpBrokerExtended(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpExtendedClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpExtendedFetch ]
{
}

ClassMethod LookUpExtendedExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpExtendedFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpExtendedExecute ]
{
}

Query LookUpExtended(desc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "NoteDesc,NoteCode")
{
SELECT 
FROM MRCNursingNotesStatus
}

}
