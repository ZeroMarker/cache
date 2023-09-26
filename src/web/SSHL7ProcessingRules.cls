Class web.SSHL7ProcessingRules Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7PR_RowId";

Parameter SQLDESCRIPTION = "HL7PR_RowId";

Parameter SQLROWID = "HL7PR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 44852 - AI - 14-07-2004 : Simply return comma-separated list of selected DisSum rules, as stored.
ClassMethod GetSelectedDisSum(ParRef As %Library.String = "") As %Library.String
{
}

/// Log 44852 - AI - 14-07-2004 : LookUpForListBox is required for the generic LISTBOX functionality.
/// 					Returns the rows that are to be selected (highlighted) within the list.
ClassMethod LookUpForListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForListBoxFetch ]
{
}

/// Log 44852 - AI - 14-07-2004 : LookUpForListBox is required for the generic LISTBOX functionality.
/// 					Returns the rows that are to be selected (highlighted) within the list.
ClassMethod LookUpForListBoxExecute(ByRef QHandle As %Library.Binary, ParRef As %Library.String = "") As %Library.Status
{
}

/// Log 44852 - AI - 14-07-2004 : LookUpForListBox is required for the generic LISTBOX functionality.
/// 					Returns the rows that are to be selected (highlighted) within the list.
ClassMethod LookUpForListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
}

ClassMethod websysSaveRules(compref As %Library.String, ParRef As %Library.String = "", selectedDisSum As %Library.String = "")
{
}

/// Log 44852 - AI - 14-07-2004 : LookUpForListBox is required for the generic LISTBOX functionality.
/// 					Returns the rows that are to be selected (highlighted) within the list.
Query LookUpForListBox(ParRef) As %Library.Query(CONTAINID = 0, ROWSPEC = "DisSumCode,DisSumDesc")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef PARREF As %String) As %Boolean
{
}

}
