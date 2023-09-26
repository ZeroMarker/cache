Class web.DHCEQCApproveType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 7;

Parameter SQLCODE = "AT_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = " (AT_InvalidFlag = 'N') ";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "AT_Desc";

Parameter SQLROWID = "AT_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:名称,HIDDEN:%String,Code:%String:编码")
{
SELECT AT_Desc,
	   AT_RowID,
	   AT_Code
FROM sqluser.DHC_EQCApproveType
where AT_InvalidFlag = 'N' and AT_Desc like '%'||nvl(:para,'')||'%'
}

}
