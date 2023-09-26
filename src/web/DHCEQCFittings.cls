Import SQLUser

Class web.DHCEQCFittings Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLCODE = "F_Code";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "F_Desc";

Parameter SQLROWID = "F_RowID";

Parameter SQLFILTER = " (F_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT F_Desc,
	   F_RowID,
	   F_Code
FROM sqluser.DHC_EQCFittings
where F_InvalidFlag = 'N' and F_Desc like nvl(:para,'')||'%'
}

}
