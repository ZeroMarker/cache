Import SQLUser

Class web.DHCEQCDocOriginal Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLCODE = "DO_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "DO_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "DO_RowID";

Parameter SQLFILTER = " (DO_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT DO_Desc,
	   DO_RowID,
	   DO_Code
FROM sqluser.DHC_EQCDocOriginal
where DO_InvalidFlag = 'N' and DO_Desc like nvl(:para,'')||'%'
}

}
