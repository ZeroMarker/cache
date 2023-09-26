Class web.PAComplaintServices Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SER_RowId";

Parameter SQLDESCRIPTION = "SER_RowId";

Parameter SQLROWID = "SER_RowId";

Query ListServices(PARREF As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%Library.String,Service:%Library.String")
{
SELECT SER_RowId,SER_CTLOC_DR->CTLOC_Desc
FROM SQLUSER.PA_ComplaintServices
WHERE SER_PARREF=:PARREF
}

}
