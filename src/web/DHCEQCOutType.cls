/// Modify By DJ 2011-06-01
/// 减少类型过滤报废类型
Class web.DHCEQCOutType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLCODE = "OT_Code";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "OT_Desc";

Parameter SQLROWID = "OT_RowID";

Parameter SQLFILTER = " (OT_InvalidFlag = 'N' And OT_Code<>'TH') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:描述,HIDDEN:%String,Code:%String:编码")
{
SELECT OT_Desc,
	   OT_RowID,
	   OT_Code
FROM sqluser.DHC_EQCOutType
where OT_InvalidFlag = 'N' And OT_Code<>'BF' And OT_Code<>'TH' and OT_Desc like nvl(:para,'')||'%'
}

}
