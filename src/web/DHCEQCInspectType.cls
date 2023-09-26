Import SQLUser

Class web.DHCEQCInspectType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "IT_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "IT_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "IT_RowID";

Parameter SQLFILTER = " (IT_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT IT_Desc,
	   IT_RowID,
	   IT_Code
FROM sqluser.DHC_EQCInspectType
where IT_InvalidFlag = 'N' and IT_Desc like nvl(:para,'')||'%'
}

}
