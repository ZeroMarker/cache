Class web.CTStaffType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLCODE = "STAFF_Code";

Parameter SQLDATEFROM = "STAFF_DateFrom";

Parameter SQLDATETO = "STAFF_DateTo";

Parameter SQLDESCRIPTION = "STAFF_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((STAFF_DateFrom <= CURRENT_DATE OR STAFF_DateFrom IS NULL) AND (STAFF_DateTo >= CURRENT_DATE OR STAFF_DateTo IS NULL))";

Parameter SQLROWID = "STAFF_RowId";

}
