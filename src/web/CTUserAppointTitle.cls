Class web.CTUserAppointTitle Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLCODE = "USAPTL_Code";

Parameter SQLDATEFROM = "USAPTL_DateFrom";

Parameter SQLDATETO = "USAPTL_DateTo";

Parameter SQLDESCRIPTION = "USAPTL_Desc";

Parameter SQLROWID = "USAPTL_RowId";

Parameter SQLFILTER = "((USAPTL_DateFrom <= CURRENT_DATE OR USAPTL_DateFrom IS NULL) AND (USAPTL_DateTo >= CURRENT_DATE OR USAPTL_DateTo IS NULL))";

}
