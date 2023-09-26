Class web.PACIVTherapy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Property dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "IVT_Code";

Parameter SQLDATEFROM = "IVT_DateFrom";

Parameter SQLDATETO = "IVT_DateTo";

Parameter SQLDESCRIPTION = "IVT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((IVT_DateFrom <= CURRENT_DATE OR IVT_DateFrom IS NULL) AND (IVT_DateTo >= CURRENT_DATE OR IVT_DateTo IS NULL))";

Parameter SQLROWID = "IVT_RowId";

}
