Import SQLUser

Class web.DHCEQCAffix Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "A_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "A_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "A_RowID";

Parameter SQLFILTER = " (A_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT A_Desc,
	   A_RowID,
	   A_Code
FROM sqluser.DHC_EQCAffix
where A_InvalidFlag = 'N' and A_Desc like nvl(:para,'')||'%'
}

}
