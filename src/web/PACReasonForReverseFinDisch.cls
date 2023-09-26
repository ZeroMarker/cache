Class web.PACReasonForReverseFinDisch Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 19;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RFD_Code";

Parameter SQLDESCRIPTION = "RFD_Desc";

Parameter SQLROWID = "RFD_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
