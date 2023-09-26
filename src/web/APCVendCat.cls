Class web.APCVendCat Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 4;

Parameter SQLCODE = "APCVC_CoCode_DR";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "APCVC_Desc";

Parameter SQLROWID = "APCVC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query Find() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "a,b")
{
SELECT APCVC_Code,APCVC_Desc
FROM SQLUser.APC_VendCat
}

}
