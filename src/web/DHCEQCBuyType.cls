Import SQLUser

Class web.DHCEQCBuyType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLCODE = "BT_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "BT_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "BT_RowID";

Parameter SQLFILTER = " (BT_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:采购方式,HIDDEN:%String,Code:%String:编码")
{
SELECT BT_Desc,
	   BT_RowID,
	   BT_Code
FROM sqluser.DHC_EQCBuyType
where BT_InvalidFlag = 'N' and BT_Desc like nvl(:para,'')||'%'
}

}
