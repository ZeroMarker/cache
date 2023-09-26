Class web.PACMedicareSuffix Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MEDSUF_Code";

Parameter SQLDATEFROM = "MEDSUF_DateFrom";

Parameter SQLDATETO = "MEDSUF_DateTo";

Parameter SQLDESCRIPTION = "MEDSUF_Desc";

Parameter SQLROWID = "MEDSUF_RowId";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((MEDSUF_DateFrom <= CURRENT_DATE OR MEDSUF_DateFrom IS NULL) AND (MEDSUF_DateTo >= CURRENT_DATE OR MEDSUF_DateTo IS NULL))";

}
