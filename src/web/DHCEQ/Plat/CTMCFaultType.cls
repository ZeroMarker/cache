Class web.DHCEQ.Plat.CTMCFaultType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
ClassMethod UpdFaultType(data)
{
	n ftrowid,OperMethod,code,desc
	Set ftrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503001")
	if (OperMethod=0)||(desc="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select FT_RowID Into:ftrowid from SQLUSER.DHC_EQMCFaultType Where FT_InvalidFlag='N' and FT_Desc=:desc)
	if ftrowid=""
	{
		if code=""
		{
			Set ftrowid=$Order(^DHCEQCCode("DHCEQMCFaultType",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCFaultType",ftrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultType(FT_Code, FT_Desc, FT_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-2004)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		Set ftrowid=$Get(%ROWID)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ftrowid)
}

}
