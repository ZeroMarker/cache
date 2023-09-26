Import SQLUser

Class web.DHCANOPInterfaceNew Extends %RegisteredObject
{

/// 入参就诊号，预约日期
/// 返回0：正常
/// w ##class(web.DHCANOPInterfaceNew).UpdateDaySurgeryDate(595,"2021-09-11")
ClassMethod UpdateDaySurgeryDate(AdmId As %String, AppointDate As %String)
{
	s AppointDateH=##Class(web.DHCANOPCom).ConvertToDateH(AppointDate)
	s opaIdStr=..CheckValidDayOper(AdmId)
	s dayFlag=$p(opaIdStr,"^",1)
	q:dayFlag'="Y" "No valid daysurgery oper"
	s opaId=$p(opaIdStr,"^",3)
	&sql(select * from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	i SQLCODE  q "未找到手术申请记录!"
	&sql(update SQLUSER.DHC_AN_OPArrange set OPA_StartDate=:AppointDateH where opa_rowid=:opaId)
	i SQLCODE TRollBack  q "修改手术申请错误!"
	s opsId=..GetNewOpaIDByOld(opaId)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operSchedule.OperDate=AppointDateH
	set sc=operSchedule.%Save()
	set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
	q 0
}

/// w ##class(web.DHCANAdaptor).CheckValidDayOper(827)
/// 入参：就诊号，
/// 返回Y^A^数字，存在正式日间申请
/// 返回Y^W^数字，存在拟日间申请
/// 返回N^N^数字，不存在日间手术
/// 返回N^C^数字，存在撤销的拟日间申请
/// 只适合日间
ClassMethod CheckValidDayOper(AdmId) As %String
{
	s ret1="",ret2="",ret=""
	s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,""),-1)
	i opaId="" s ret1="N",ret2="N"
	e  d
		.s operStat=$P($g(^DHCANOPArrange(opaId)),"^",27)
		.s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2)
		.s anasub=$p(anaId,"||",2)
		.s adm=AdmId
		.s chl=anasub
		.s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
		.f  s anaOpSubTmp2=$o(^OR(adm,"ANA",chl,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		..s inum=anaOpSubTmp2
		..i inum>0 s anaOpSubTmp=inum
		.s dayOperFlag=$P(^OR(AdmId,"ANA",anasub,"OP",anaOpSubTmp),"^",22)
		.i dayOperFlag'="Y" d
			..s ret1="N",ret2="N"	;不存在日间手术
		.e  d
			..i operStat="C" s ret1="N",ret2="C"
			..e  i operStat="D" s ret1="N",ret2="C"
			..e  i operStat="S" s ret1="Y",ret2="W"	;存在拟日间申请
			..e  s ret1="Y",ret2="A"	;存在正式申请
	s ret=ret1_"^"_ret2_"^"_opaId
	q ret
}

ClassMethod GetNewOpaIDByOld(opaId)
{
		set operDataID=""
	&sql(select RowId into :operDataID from CIS_AN.OperSchedule where  ExternalID=:opaId)

	q operDataID
}

}
