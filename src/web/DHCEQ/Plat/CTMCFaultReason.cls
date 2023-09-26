Class web.DHCEQ.Plat.CTMCFaultReason Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
ClassMethod UpdFaultReason(data)
{
	n frrowid,OperMethod,code,desc
	Set frrowid=""
	Set code=$ZCONVERT($Piece(data,"^",1),"U")
	Set desc=$ZCONVERT($Piece(data,"^",2),"U")
	Set SQLCODE=0
	Set OperMethod=##class(web.DHCEQCommon).GetSysInfo("503002")
	if (OperMethod=0)||(desc="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select FR_RowID Into :frrowid from SQLUSER.DHC_EQMCFaultReason Where FR_InvalidFlag='N' and FR_Desc=:desc)
	if frrowid=""
	{
		if code=""
		{
			Set frrowid=$Order(^DHCEQCCode("DHCEQMCFaultReason",""),-1)
			Set code=$Piece($Get(^DHCEQCCode("DHCEQMCFaultReason",frrowid)),"^",1)+1
			Set code=##class(web.DHCEQCCounter).LPAD(code,"0",2)
		}
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultReason(FR_Code, FR_Desc, FR_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-2002)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		Set frrowid=$Get(%ROWID)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,frrowid)
}

}
