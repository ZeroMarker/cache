Class web.CTLocCPType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 44;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// check if the care type is in the care type allocation for that ward
ClassMethod IsValidWardCareType(ward As %Library.String, ct As %Library.String) As %Library.Integer
{
}

Parameter SQLCODE = "CPT_RowId";

Parameter SQLDESCRIPTION = "CPT_RowId";

Parameter SQLROWID = "CPT_RowId";

}
