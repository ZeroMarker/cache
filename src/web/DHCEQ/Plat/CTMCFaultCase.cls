Class web.DHCEQ.Plat.CTMCFaultCase Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2018-07-13
ClassMethod UpdFaultCase(data)
{
	n fcrowid,FaultCaseOperMethod,FaultCase,code,desc
	s fcrowid=""
	s code=$ZCONVERT($p(data,"^",1),"U")
	s desc=$ZCONVERT($p(data,"^",2),"U")
	s SQLCODE=0
	s FaultCaseOperMethod=##class(web.DHCEQCommon).GetSysInfo("503004")
	if (FaultCaseOperMethod=0)||(desc="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	&SQL(Select FC_RowID Into:fcrowid from SQLUSER.DHC_EQMCFaultCase Where FC_InvalidFlag='N' and FC_Desc=:desc)
	if fcrowid="" //新增当前故障现象
	{
		&SQL(Insert Into SQLUSER.DHC_EQMCFaultCase (FC_Code,FC_Desc,FC_InvalidFlag) Values(:code,:desc,'N'))
		if SQLCODE
		{
			s ErrorInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(-2001)
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorInfo)
		}
		s fcrowid=$G(%ROWID)
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,fcrowid)
}

}
