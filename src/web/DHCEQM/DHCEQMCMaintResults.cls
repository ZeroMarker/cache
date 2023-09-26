Import SQLUser

Class web.DHCEQM.DHCEQMCMaintResults Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "MR_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "MR_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "MR_RowID";

Parameter SQLFILTER = " (MR_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
SELECT MR_Desc,
	   MR_RowID,
	   MR_Code
FROM sqluser.DHC_EQMCMaintResults
where MR_InvalidFlag = 'N' and MR_Desc like nvl(:para,'')||'%'
}

}
