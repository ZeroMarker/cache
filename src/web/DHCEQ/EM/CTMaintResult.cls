Class web.DHCEQ.EM.CTMaintResult Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetMaintResults(MaintResults) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT MR_Desc,
	   MR_RowID,
	   MR_Code
FROM sqluser.DHC_EQMCMaintResults
where MR_InvalidFlag = 'N' and MR_Desc like nvl(:MaintResults,'')||'%'
}

}
