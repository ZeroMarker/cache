Class web.DHCEQCTechLevel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLCODE = "TL_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "TL_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "TL_RowID";

Parameter SQLFILTER = " (TL_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT TL_Desc,
	   TL_RowID,
	   TL_Code
FROM sqluser.DHC_EQCTechLevel
where TL_InvalidFlag = 'N' and TL_Desc like nvl(:para,'')||'%'
}

}
