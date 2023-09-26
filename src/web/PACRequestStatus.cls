Class web.PACRequestStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLCODE = "REQST_Code";

Parameter SQLDATEFROM = "REQST_DateFrom";

Parameter SQLDATETO = "REQST_DateTo";

Parameter SQLDESCRIPTION = "REQST_Desc";

Parameter SQLROWID = "REQST_RowId";

Query FindAllForList() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "hidden,desc")
{
SELECT REQST_Code,REQST_Desc
FROM SQLUser.PAC_RequestStatus
}

}
