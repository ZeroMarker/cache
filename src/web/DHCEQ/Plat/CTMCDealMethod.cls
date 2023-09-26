Class web.DHCEQ.Plat.CTMCDealMethod Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
ClassMethod UpdDealMethod(data)
{
	n dmrowid,OperMethod,code,desc
	Set dmrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503003")
	if (OperMethod=0)||(desc="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select DM_RowID Into :dmrowid from SQLUSER.DHC_EQMCDealMethod Where DM_InvalidFlag='N' and DM_Desc=:desc)
	if dmrowid=""
	{
		if code=""
		{
			Set dmrowid=$Order(^DHCEQCCode("DHCEQMCDealMethod",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCDealMethod",dmrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCDealMethod(DM_Code, DM_Desc, DM_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-2003)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		Set dmrowid=$Get(%ROWID)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,dmrowid)
}

}
