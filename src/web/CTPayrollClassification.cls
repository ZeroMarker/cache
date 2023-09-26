Class web.CTPayrollClassification Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 44;

Parameter SQLCODE = "PAYCLS_Code";

Parameter SQLDATEFROM = "PAYCLS_DateFrom";

Parameter SQLDATETO = "PAYCLS_DateTo";

Parameter SQLDESCRIPTION = "PAYCLS_Desc";

Parameter SQLROWID = "PAYCLS_RowId";

Parameter SQLFILTER = "((PAYCLS_DateFrom <= CURRENT_DATE OR PAYCLS_DateFrom IS NULL) AND (PAYCLS_DateTo >= CURRENT_DATE OR PAYCLS_DateTo IS NULL))";

}
