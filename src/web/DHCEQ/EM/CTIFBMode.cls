Import SQLUser

Class web.DHCEQ.EM.CTIFBMode Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetIFBMode(Desc) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT IFBM_Desc,
	   IFBM_RowID,
	   IFBM_Code
FROM sqluser.DHC_EQCIFBMode
where IFBM_InvalidFlag = 'N' and IFBM_Desc like nvl(:Desc,'')||'%'
}

}
