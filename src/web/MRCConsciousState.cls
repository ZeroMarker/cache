Class web.MRCConsciousState Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

Parameter SQLDATEFROM = "CONST_DateFrom";

Parameter SQLDATETO = "CONST_DateTo";

Parameter SQLCODE = "CONST_Code";

Parameter SQLDESCRIPTION = "CONST_Desc";

Parameter SQLROWID = "CONST_RowId";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CONST_DateFrom <= CURRENT_DATE OR CONST_DateFrom IS NULL) AND (CONST_DateTo >= CURRENT_DATE OR CONST_DateTo IS NULL))";

}
