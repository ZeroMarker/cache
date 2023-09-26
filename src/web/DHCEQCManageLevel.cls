Class web.DHCEQCManageLevel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "ML_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "ML_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "ML_RowID";

Parameter SQLFILTER = " (ML_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT ML_Desc,
	   ML_RowID,
	   ML_Code
FROM sqluser.DHC_EQCManageLevel
where ML_InvalidFlag = 'N' and ML_Desc like nvl(:para,'')||'%'
}

}
