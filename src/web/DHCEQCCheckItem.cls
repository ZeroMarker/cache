Class web.DHCEQCCheckItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "CI_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "CI_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "CI_RowID";

Parameter SQLFILTER = " (CI_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CI_Desc,
	   CI_RowID,
	   CI_Code
FROM sqluser.DHC_EQCCheckItem
where CI_InvalidFlag = 'N' and CI_Desc like nvl(:para,'')||'%'
}

}
