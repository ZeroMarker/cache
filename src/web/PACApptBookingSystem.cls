Include webimport

IncludeGenerator webimport

Class web.PACApptBookingSystem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

Parameter SQLDATEFROM = "APPTBS_DateFrom";

Parameter SQLDATETO = "APPTBS_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "APPTBS_Code";

Parameter SQLDESCRIPTION = "APPTBS_Desc";

Parameter SQLROWID = "APPTBS_RowId";

Parameter SQLFILTER = "((APPTBS_DateFrom <= CURRENT_DATE OR APPTBS_DateFrom IS NULL) AND (APPTBS_DateTo >= CURRENT_DATE OR APPTBS_DateTo IS NULL))";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpForListBox(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,Description:%String,Code:%String")
{
SELECT APPTBS_RowId, APPTBS_Desc, APPTBS_Code
FROM SQLUser.PAC_ApptBookingSystem
ORDER BY APPTBS_Desc
}

}
