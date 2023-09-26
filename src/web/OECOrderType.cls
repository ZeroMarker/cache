Class web.OECOrderType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 79;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "TYP_Code";

Parameter SQLDESCRIPTION = "TYP_RowId";

Parameter SQLROWID = "TYP_RowId";

Query List() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Code,Desc")
{
SELECT TYP_RowID, TYP_Code, TYP_Desc
FROM SQLUser.OEC_OrderType
}

}
