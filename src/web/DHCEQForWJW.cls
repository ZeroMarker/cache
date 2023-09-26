Import SQLUser

Class web.DHCEQForWJW Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "AT_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "AT_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "AT_RowID";

Parameter SQLFILTER = " (AT_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT AT_Desc,
	   AT_RowID,
	   AT_Code
FROM sqluser.DHC_EQForCWJW
where AT_InvalidFlag = 'N' and AT_Desc like nvl(:para,'')||'%'
}

}
