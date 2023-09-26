Class web.DHCEQCCheckResult Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLCODE = "CR_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "CR_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "CR_RowID";

Parameter SQLFILTER = " (CR_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CR_Desc,
	   CR_RowID,
	   CR_Code
FROM sqluser.DHC_EQCCheckResult
where CR_InvalidFlag = 'N' and CR_Desc like nvl(:para,'')||'%'
}

}
