Import SQLUser

Class web.DHCEQCDisuseType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLCODE = "DR_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "DR_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "DR_RowID";

Parameter SQLFILTER = " (DR_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:描述,HIDDEN:%String,Code:%String:编码")
{
SELECT DR_Desc,
	   DR_RowID,
	   DR_Code
FROM sqluser.DHC_EQCDisuseType
where DR_InvalidFlag = 'N' and DR_Desc like nvl(:para,'')||'%'
}

}
