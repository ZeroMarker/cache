Import SQLUser

Class web.DHCEQCPart Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 14;

Parameter SQLCODE = "P_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "P_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "P_RowID";

Parameter SQLFILTER = " (P_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT P_Desc,
	   P_RowID,
	   P_Code
FROM sqluser.DHC_EQCPart
where P_InvalidFlag = 'N' and P_Desc like nvl(:para,'')||'%'
}

}
