Import sqluser

/// Descript:	采购计划制单
/// Creator:	lxt
/// CreateDate:	2018-05-09
Class web.DHCSTMHUI.INPurPlan Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTPURPLANAUDITM";

/// Descript:	查询采购计划单
/// Creator:	lxt
/// CreateDate:	2018-05-09
/// Table:		IN_PurPlan
/// Input:		排序，查询条件
/// Return：	采购计划单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlan","Query","{""StartDate"":""2021-04-10"",""gUserId"":""12183"",""gLocId"":""163"",""gGroupId"":""96"",""gHospId"":""2"",""PurLoc"":""163"",""EndDate"":""2021-05-10"",""AuditFlag"":""N"",""Vendor"":"""",""DefLocPP"":"""",""PurNo"":""MPUR20210509001"",""CompFlag"":""Y""}")
Query Query(Params As %String) As Query(ROWSPEC = "RowId,PurNo,PurLocId,PurLoc,CreateDate,CreateUser,StkScgId,StkScg,CompFlag,AuditFlag,PoFlag,RefuseCase,DHCPlanStatus,DHCPlanStatusDesc") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s pRowId=PJObj.%Get("RowId")			//主单RowId
	s pStartDate=PJObj.%Get("StartDate")	//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	s pPurLocId=PJObj.%Get("PurLoc")		//采购科室
	s pVendorId=PJObj.%Get("Vendor")		//供应商
	s pStkScgId=PJObj.%Get("StkScg")		//类组
	s pStkCatId=PJObj.%Get("StkCat")		//库存分类
	s pInciId=PJObj.%Get("Inci")			//物资
	s pInciDesc=PJObj.%Get("InciDesc")		//物资
	s pPurNo=PJObj.%Get("PurNo")			//单号
	s pCompFlag=PJObj.%Get("CompFlag")		//完成标志
	s pAuditFlag=PJObj.%Get("AuditFlag")	//审核标志
	s pAuditLevel=PJObj.%Get("AuditFlag")	//审核级别
	s pDefLocPP=PJObj.%Get("DefLocPP")		//是否包含支配科室
	s pMouldFlag=PJObj.%Get("MouldFlag")	//模板标记(Y/N)
	s pType=PJObj.%Get("Type")	//0: 制单界面；1：审核界面；2：执行情况界面
	s pAuditStatus=PJObj.%Get("AuditStatus")	//审核状态
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	s:pMouldFlag="" pMouldFlag="N"
	
	s type=..sssCode()
	s pHospId=..sssHospId(pPurLocId)
	s:pHospId="" pHospId=gHospId
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,pPurLocId,pStkScgId,pHospId)
	s:pAuditLevel="" pAuditLevel=1
	s SqlStr="select INPP_Rowid RowId,"
	s SqlStr=SqlStr_"INPP_No PurNo,"
	s SqlStr=SqlStr_"INPP_CTLOC_DR PurLocId,"
	s SqlStr=SqlStr_"INPP_CTLOC_DR->CTLOC_Desc PurLoc,"
	s SqlStr=SqlStr_"INPP_Date CreateDate,"
	s SqlStr=SqlStr_"INPP_SSUSR_DR->SSUSR_Name CreateUser,"
	s SqlStr=SqlStr_"INPP_SCG_DR StkScgId,"
	s SqlStr=SqlStr_"INPP_Complete CompFlag,"
	s SqlStr=SqlStr_"INPP_AuditFlag AuditFlag,"
	s SqlStr=SqlStr_"INPP_PoFlag PoFlag,"
	s SqlStr=SqlStr_"INPP_RefuseCase RefuseCase" 
	s SqlStr=SqlStr_" from IN_PurPlan"
	s SqlStr=SqlStr_" where INPP_StkType='"_type_"'"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	i ((pPurLocId'="")&&(pDefLocPP="Y")) d
	.s domiLocs=##class(web.DHCSTMHUI.Common.UtilCommon).GetDominLoc(pPurLocId)
	.i domiLocs'=""  d
	..s pPurLocId=pPurLocId_","_domiLocs
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		continue:(pRowId'="")&&(pRowId'=RowId)
		s MouldFlag=$p(^INPP(RowId),"^",19)
		s:MouldFlag="" MouldFlag="N"
		continue:(pMouldFlag'="")&&(MouldFlag'=pMouldFlag)
		s PurNo = Result.Data("PurNo")
		continue:(pPurNo'="")&&(pPurNo'=PurNo)
		s CreateDate = Result.Data("CreateDate")
		continue:(pStartDate'="")&&(pStartDate>CreateDate)
		continue:(pEndDate'="")&&(pEndDate<CreateDate)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s PurLocId = Result.Data("PurLocId")
		;continue:(pPurLocId'="")&&(pPurLocId'=PurLocId)
		continue:((","_pPurLocId_",")'[(","_PurLocId_","))
		s PurLoc = Result.Data("PurLoc")
		s CreateUser = Result.Data("CreateUser")
		s StkScgId = Result.Data("StkScgId")
		continue:(pStkScgId'="")&&(pStkScgId'=StkScgId)
		continue:(StkScgId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkScgId_"^"))
		s StkScg=""
		s:StkScgId'="" StkScg=$p(^DHCSCG(StkScgId),"^",2)
		s CompFlag = Result.Data("CompFlag")
		s:CompFlag="" CompFlag="N"
		i pCompFlag'="" continue:pCompFlag'=CompFlag
		s AuditFlag = Result.Data("AuditFlag")
		s DHCPlanStatusInfo=..GetPlanStatusInfo(RowId,gGroupId)
		s DHCPlanStatus=$p(DHCPlanStatusInfo,"^",1)
		s DHCPlanStatusDesc=$p(DHCPlanStatusInfo,"^",2)
		s AlreadyAudit=$p(DHCPlanStatusInfo,"^",3)
		s MyTurnAudit=$p(DHCPlanStatusInfo,"^",4)
		continue:(pType="0")&&(DHCPlanStatus'="")	;制单界面只能查到未审核单子
		continue:(pType="1")&&(pAuditFlag="N")&&((AuditFlag="N")||('(AlreadyAudit=""))||(MyTurnAudit=""))	;审核界面查询未审核：自己能审
		continue:(pType="1")&&(pAuditFlag="Y")&&((AlreadyAudit'="Y")&&(AuditFlag'="Y"))						;审核界面查询已审核：自己已审和AuditFlag="Y"
		continue:(pType="1")&&(pAuditFlag="")&&(MyTurnAudit="")&&(AuditFlag'="Y")&&(AlreadyAudit'="Y")		;审核界面查询全部：自己能审、自己已审和AuditFlag="Y"
		continue:(pType="2")&&(pAuditStatus="3")&&(AuditFlag'="Y")						;执行情况查询已审核
		continue:(pType="2")&&(pAuditStatus="2")&&((AuditFlag="Y")||(DHCPlanStatus=""))	;执行情况查询审核中
		continue:(pType="2")&&(pAuditStatus="1")&&(DHCPlanStatus'="")					;执行情况查询未审核
		s PoFlag = Result.Data("PoFlag")
		s RefuseCase = Result.Data("RefuseCase")
		i pVendorId'="" continue:..ExistVendor(pVendorId,RowId)="N"
		i (pInciId'="")!(pInciDesc'="") continue:..ExistInci(pInciId,pInciDesc,RowId)="N"
		i pStkCatId'="" continue:..ExistStkCat(pStkCatId,RowId)="N"
		;s DHCPlanStatus=""
		;s DHCPlanStatusDesc=""
		;s PlanAuditId=""
		;s PlanAuditId=$o(^DHCPA(0,"INPP",RowId,""),-1)
		;s:PlanAuditId'="" DHCPlanStatus=$p(^DHCPA(PlanAuditId),"^",2)
		;s:DHCPlanStatus'="" DHCPlanStatusDesc=$p(^DHCPS(DHCPlanStatus),"^",2)
		;是否已经完全审核判断
		s PlanStatusInit=""
		s PlanStatusInit=$o(^DHCPSI(0,"CTLOC",PurLocId,""),-1)
		s DHCPlanStatustmp=""
		s:PlanStatusInit'="" DHCPlanStatustmp=$p(^DHCPSI(PlanStatusInit),"^",2)
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,PurNo,PurLocId,PurLoc,CreateDate,CreateUser,StkScgId,StkScg,CompFlag,AuditFlag,PoFlag,RefuseCase,DHCPlanStatus,DHCPlanStatusDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	判断采购单明细是否包含某供应商
/// Creator:	lxt
/// CreateDate:	2018-05-09
/// Table:		IN_PurPlanItm
/// Input:		VendorId,PurId
/// Return：	Y是，N否
ClassMethod ExistVendor(VendorId As %String, PurId As %String) As %String [ Private ]
{
	n (VendorId,PurId)
	s ch=0
	s flag="N"
	f  s ch=$o(^INPP(PurId,"PPI",ch)) q:(ch="")!(flag="Y")  d
	.i $p(^INPP(PurId,"PPI",ch),"^",1)=VendorId  s flag="Y"
	q flag
}

/// Descript:	判断采购单明细是否包含某库存项
/// Creator:	lxt
/// CreateDate:	2018-05-09
/// Table:		IN_PurPlanItm
/// Input:		VendorId,PurId
/// Return：	Y是，N否
ClassMethod ExistInci(InciId As %String, InciDesc As %String, PurId As %String) As %String [ Private ]
{
	n (InciId,InciDesc,PurId)
	s ch=0
	s flag="N"
	f  s ch=$o(^INPP(PurId,"PPI",ch)) q:(ch="")!(flag="Y")  d
	.s purInciId=$p(^INPP(PurId,"PPI",ch),"^",2)
	.s purInciDesc=$p(^INCI(purInciId,1),"^",2)
	.i InciId'=""  d
	..i purInciId=InciId  s flag="Y"
	.i (InciId="")&&(InciDesc'="")   d
	..i purInciDesc[InciDesc  s flag="Y"
	q flag
}

/// Descript:	判断采购单明细是否包含某库存项
/// Creator:	lxt
/// CreateDate:	2018-05-09
/// Table:		IN_PurPlanItm
/// Input:		VendorId,PurId
/// Return：	Y是，N否
ClassMethod ExistStkCat(StkCatId As %String, PurId As %String) As %String [ Private ]
{
	n (StkCatId,PurId)
	s ch=0
	s flag="N"
	f  s ch=$o(^INPP(PurId,"PPI",ch)) q:(ch="")!(flag="Y")  d
	.s InciId=$p(^INPP(PurId,"PPI",ch),"^",2)
	.s Incsc=$p(^INCI(InciId,2),"^",2)
	.i StkCatId=Incsc  s flag="Y"
	q flag
}

/// Descript:	查询采购计划单主单信息
/// Creator:	lxt
/// CreateDate:	2018-05-09
/// Table:		IN_PurPlan
/// Input:		主单RowId
/// Return：	采购计划单主单信息数据串
/// w ##class(web.DHCSTMHUI.INPurPlan).Select(29)
ClassMethod Select(PurId As %String) As %String
{
	n (PurId)
	q:+PurId=0 "{}"
	s PurNo = $p(^INPP(PurId),"^",1)
	s CreateDate = $p(^INPP(PurId),"^",2)
	s UserId = $p(^INPP(PurId),"^",3)
	s AuditDate = $p(^INPP(PurId),"^",4)
	s AuditUserId = $p(^INPP(PurId),"^",5)
	s PoFlag = $p(^INPP(PurId),"^",6)
	s LocId = $p(^INPP(PurId),"^",7)
	s CompFlag = $p(^INPP(PurId),"^",8)
	s CreateTime = $p(^INPP(PurId),"^",9)
	s AuditFlag=$p(^INPP(PurId),"^",10)
	s AuditTime = $p(^INPP(PurId),"^",11)
	s StkGrpId= $p(^INPP(PurId),"^",12)
	s MouldFlag=$p(^INPP(PurId),"^",19)
	
	s (UserName,AuditUserName,LocDesc,StkGrpDesc)=""
	s:+CreateDate'=0 CreateDate=..DL2H(CreateDate)
	s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s:+AuditDate'=0 AuditDate=..DL2H(AuditDate)
	s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2) 
	s:CompFlag="" CompFlag="N"
	s:+CreateTime'=0 CreateTime=..TL2H(CreateTime)
	s:AuditFlag="" AuditFlag="N"
	s:+AuditTime'=0 AuditTime=..TL2H(AuditTime)
	s:StkGrpId'="" StkGrpDesc=$p(^DHCSCG(StkGrpId),"^",2)
	
	s Data=PurId_"^"_PurNo_"^"_LocId_"^"_LocDesc_"^"_StkGrpId_"^"_StkGrpDesc
		_"^"_CreateDate_"^"_CreateTime_"^"_UserId_"^"_UserName_"^"_CompFlag
		_"^"_AuditFlag_"^"_AuditDate_"^"_AuditTime_"^"_AuditUserId_"^"_AuditUserName
		_"^"_PoFlag_"^"_MouldFlag
	
	s Title="RowId^PurNo^PurLoc^PurLocDesc^StkScg^StkScgDesc"
		_"^CreateDate^CreateTime^UserId^UserName^CompFlag"
		_"^AuditFlag^AuditDate^AuditTime^AuditUserId^AuditUserName"
		_"^PoFlag^MouldFlag"
	
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:	删除采购计划单信息
/// 对象类型数据
ClassMethod jsDelete(PurId As %String) As %String
{
	n (PurId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Delete(PurId)
	q RtnObj.Json()
}

/// Descript:	删除采购计划单信息
/// Creator:	lxt
/// CreateDate:	2018-05-15
/// Table:		IN_Purplan
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod Delete(PurId As %String) As RtnObj
{
	n (PurId)
	s RtnObj=##class(RtnObj).%New()
	i PurId="" s Sc=RtnObj.Err(-1,"","入参不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i ..sssLock(..%GetParameter("AppName")_PurId)<0 s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	i ..AllowDel(PurId)<0 d ..sssUnLock(..%GetParameter("AppName")_PurId) s Sc=RtnObj.Err(-2,"","已完成或已审核,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	ts
	&sql(delete from IN_PurPlan where INPP_Rowid=:PurId)
	i SQLCODE<0 d ..sssUnLock(..%GetParameter("AppName")_PurId) tro  s Sc=RtnObj.Err(-3,"","删除失败!")
	q:RtnObj.success'=0 RtnObj
	tc
	q RtnObj
}

/// 检查是否允许删除
/// Creator:	lxt
/// CreateDate:	2018-05-15
/// Table:		IN_PurPlan
/// Input:		PurId
/// Return：	0可以删除 <0不允许删除
ClassMethod AllowDel(PurId As %String) As %String
{
	n (PurId)
	s CompFlag=$p(^INPP(PurId),"^",8)
	s AuditFlag=$p(^INPP(PurId),"^",10)
	q:CompFlag="Y" -1		;订单已经完成，不能删除
	q:AuditFlag="Y" -2		;订单已经审核，不能删除
	q 0
}

/// Descript:	确认完成某采购计划单
/// 对象类型数据
ClassMethod jsSetComplete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetComplete(Params)
	q RtnObj.Json()
}

/// Descript:	确认完成采购计划单
/// Creator:	lxt
/// CreateDate:	2018-05-15
/// Table:		IN_Purplan
/// Input:		主单RowId
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INPurPlan).SetComplete("{""PurLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StkScg"":""12"",""CompFlag"":""N"",""CreateDate"":""28/03/2017"",""RowId"":""2"",""PurNo"":""QXKKFWJWSMPUR20170328001""}")
ClassMethod SetComplete(Params As %String) As RtnObj
{
	n (Params)
	s Flag="Y"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s PurId=PJObj.%Get("RowId")
	i PurId="" s Sc=RtnObj.Err(-2,"","PurId不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s LocId=$p(^INPP(PurId),"^",7)
	s UserId=$p(^INPP(PurId),"^",3)
	s GroupId=$p(^SSU("SSUSR",UserId),"^",5)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	
	s CompFlag=$p(^INPP(PurId),"^",8)
	i CompFlag="Y" s Sc=RtnObj.Err(-3,"","已经完成,不能重复完成!","",0)
	q:RtnObj.success'=0 RtnObj
	
	i ..sssLock(..%GetParameter("AppName")_PurId)<0 s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	
	s VendorNeeded=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"VendorNeeded",ParamStr)
	s AutoAuditAfterCompleted=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"AutoAuditAfterCompleted",ParamStr)
	
	ts
	s ret=0
	i VendorNeeded'="N" d 		;供应商是否必填
	.s ret=..CheckVendorofInPP(PurId)
	i ret'=0 tro  d ..sssUnLock(..%GetParameter("AppName")_PurId) s Sc=RtnObj.Err(-4,"","存在供应商为空物资!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s ret=..CheckRPInPP(PurId)
	i ret'=0 tro  d ..sssUnLock(..%GetParameter("AppName")_PurId) s Sc=RtnObj.Err(-4,"","进价不能小于0!","",0)
	q:RtnObj.success'=0 RtnObj
	
	&sql(Update IN_PurPlan set INPP_Complete=:Flag, INPP_RefuseCase=NULL where INPP_Rowid=:PurId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PurId) s Sc=RtnObj.Err(-5,"","完成状态更新失败!")
	q:RtnObj.success'=0 RtnObj
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(PurId,"PD",UserId,"PP")
	
	i AutoAuditAfterCompleted="Y"  d		;自动审批
	.s RtnObj=..Audit(Params)
	i RtnObj.success'=0 tro  d ..sssUnLock(..%GetParameter("AppName")_PurId) s Sc=RtnObj.Err(-6,"","自动审批失败！"_RtnObj.msg)
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(..%GetParameter("AppName")_PurId)
	
	tc
	s RtnObj.rowid=PurId
	q RtnObj
}

/// Descript:	遍历采购计划单供应商是否为空
/// Creator:	lxt
/// CreateDate:	2018-05-15
/// Table:		IN_PurplanItm
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod CheckVendorofInPP(Rowid As %String) As %Library.String [ Private ]
{
	s ret=0
	s ChildRowid=0
	f  s ChildRowid=$o(^INPP(Rowid,"PPI",ChildRowid)) q:ChildRowid=""  d
	.s INPPIAPCVMDR=$p(^INPP(Rowid,"PPI",ChildRowid),"^",1)
	.i INPPIAPCVMDR="" d
	..s ret=-11
	q ret
}

/// Descript:	遍历采购计划单进价是否有不大于0的
/// Creator:	lxt
/// CreateDate:	2018-05-15
/// Table:		IN_PurplanItm
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod CheckRPInPP(Rowid As %String) As %Library.String [ Private ]
{
	s ret=0
	s ChildRowid=0
	f  s ChildRowid=$o(^INPP(Rowid,"PPI",ChildRowid)) q:ChildRowid=""  d
	.s Rp=$p(^INPP(Rowid,"PPI",ChildRowid),"^",5)
	.;2016-09-26 允许0进价
	.i +Rp<0 d
	..s ret=-12
	q ret
}

/// Descript:	取消完成采购计划单
/// 对象类型数据
ClassMethod jsCancelComplete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelComplete(Params)
	q RtnObj.Json()
}

/// Descript:	取消完成采购计划单
/// Creator:	lxt
/// CreateDate:	2018-05-16
/// Table:		IN_Purplan
/// Input:		主单RowId
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INPurPlan).CancelComplete("{""PurLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StkScg"":""12"",""CompFlag"":""N"",""CreateDate"":""28/03/2017"",""RowId"":""2"",""PurNo"":""QXKKFWJWSMPUR20170328001""}")
ClassMethod CancelComplete(Params As %String) As RtnObj
{
	n (Params)
	s Flag="N"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s PurId=PJObj.%Get("RowId")
	i PurId="" s Sc=RtnObj.Err(-2,"","PurId不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s CompFlag=$p(^INPP(PurId),"^",8)
	i CompFlag'="Y" s Sc=RtnObj.Err(-3,"","尚未完成，不需要取消!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s dhcpaid=""  	;审核记录DHC_PlanAudit表id
	s dhcpaid=$o(^DHCPA(0,"INPP",PurId,0))
	i dhcpaid'="" s Sc=RtnObj.Err(-3,"","采购单已开始审批，不能取消!","",0)
	q:RtnObj.success'=0 RtnObj
	
	i ..sssLock(..%GetParameter("AppName")_PurId)<0 s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	
	&sql(Update IN_PurPlan set INPP_Complete=:Flag where INPP_Rowid=:PurId)
	i SQLCODE'=0 s Sc=RtnObj.Err(-4,"","采购单已开始审批，不能取消!","",0)
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(..%GetParameter("AppName")_PurId)
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(PurId,"PD","PP")
	
	s RtnObj.rowid=PurId
	q RtnObj
}

/// Descript:	根据药品id取药品采购默认信息
/// Creator:	lxt
/// CreateDate:	2018-05-22
/// Table:		inc_itm
/// Input:		库存项id,安全组id^科室id^用户id
/// Return：	供应商id^供应商名称^产地id^产地名称^配送商id^配送商名称^入库单位id
/// ^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
/// w ##class(web.DHCSTMHUI.INPurPlan).GetItmInfo(9628,"{""PurLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
ClassMethod GetItmInfo(IncId As %String, Params As %String) As %Library.String
{
	n (IncId,Params)
	s Data=..GetItmStr(IncId,Params)
	s Title="VenId^VenDesc^ManfId^ManfDesc^CarrierId^CarrierDesc"
		_"^PurUomId^PurUomDesc^Rp^Sp^StkQty^MaxQty^MinQty"
		_"^BRp^BSp^BUomDesc^Spec^BUomId^Confac"
	
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

ClassMethod GetItmStr(IncId As %String, Params As %String) As %Library.String
{
	n (IncId,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	q:+IncId=0 ""
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s LocId=PJObj.%Get("PurLoc")
	s:((HospId="")&&(LocId'="")) HospId=$p(^CTLOC(LocId),"^",22)
	s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	
	s VenInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigVendor(IncId,..%GetParameter("AppName"),ParamStr)
	s VenId=$p(VenInfo,"^",1)
	s VenDesc=$p(VenInfo,"^",2)
	
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigManf(IncId,..%GetParameter("AppName"),ParamStr)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfDesc=$p(ManfInfo,"^",2)
	
	s CarrierInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigCarrier(IncId,..%GetParameter("AppName"),ParamStr)
	s CarrierId=$p(CarrierInfo,"^",1)
	s CarrierDesc=$p(CarrierInfo,"^",2)
	
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
	
	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PurUomId=$p(^INCI(IncId,3),"^",6)
	s PurUomDesc=""
	s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	s Confac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetConfigRp(IncId,PurUomId,..%GetParameter("AppName"),ParamStr)
	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId)
	s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(IncId,LocId,PurUomId,+$h)
	s QtyInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetItmLocMNRQtyUO(IncId,LocId,PurUomId)
	s MinQty=$p(QtyInfo,"^",1)
	s MaxQty=$p(QtyInfo,"^",2)
	
	s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	s BRp=$s(+Confac'=0:Rp/Confac,1:Rp)
	s BSp=$s(+Confac'=0:Sp/Confac,1:Sp)
	s BRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BRp,HospId,2)
	s BSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BSp,HospId,2)
	
	s Data=VenId_"^"_VenDesc_"^"_ManfId_"^"_ManfDesc_"^"_CarrierId_"^"_CarrierDesc
		_"^"_PurUomId_"^"_PurUomDesc_"^"_Rp_"^"_Sp_"^"_StkQty_"^"_MaxQty_"^"_MinQty
		_"^"_BRp_"^"_BSp_"^"_BUomDesc_"^"_Spec_"^"_BUomId_"^"_Confac
		
	q Data
}

/// Descript:	保存采购计划单
/// Creator:	lxt
/// CreateDate:	2018-05-22
/// Table:		IN_Purplan,IN_PurPlanItm
/// Input:		主单信息，明细信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INPurPlan).Save("{""PurLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StkScg"":""12"",""CompFlag"":""N"",""CreateDate"":""28/03/2017"",""RowId"":""2"",""PurNo"":""QXKKFWJWSMPUR20170328001""}","[{""RowId"":""2||1"",""InciId"":""9617"",""InciCode"":""cl0327"",""InciDesc"":""cl测试0327  "",""Spec"":""规格"",""SpecDesc"":"""",""ManfId"":"""",""ManfDesc"":"""",""Qty""  :""2"",""UomId"":""7"",""UomDesc"":""瓶"",""Rp"":""66"",""Sp"":""68"",""RpAmt"": ""66"",""SpAmt"":""68"",""VendorId"":""812"",""VendorDesc"":""cl测试201701"",""C  arrierId"":"""",""CarrierDesc"":"""",""Inpoi"":"""",""ReqLocId"":"""",""ReqLocDesc"":"""",""StkQty"":""1"",""MaxQty"":""0.00"",""MinQty"":""0.00"",""RecQty"":""0"",""LeftQty"":""1"",""BUomId"":""7"",""Confac"":""6"",""LocQty"":""1"",""ReqQty"":""0"",""TrfQty"":""0"",""LocAvaQty"":""1""}]")
ClassMethod Save(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	ts
	s $ZT=..sssError()                        ;增加错误处理
	s RtnObj=..Update(Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	s MainId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.INPurPlanItm).Save(MainId,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=MainId   
	q RtnObj.Json()
}

/// Descript:	保存采购计划主单信息
/// Creator:	lxt
/// CreateDate:	2018-05-23
/// Table:		IN_Purplan
/// Input:		主单信息
/// Return：	成功，失败
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s PurId=PJObj.%Get("RowId")
	s StkGrpId=PJObj.%Get("StkScg")
	s LocId=PJObj.%Get("PurLoc")
	s UserId=PJObj.%Get("gUserId")
	s MouldFlag=PJObj.%Get("MouldFlag")	;模板标记
	i LocId=""  d
	.s Sc=RtnObj.Err(-1,"","采购科室不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s PurDate=+$h
	s PurTime=$p($h,",",2)
	s AppName=..%GetParameter("AppName")
	
	i PurId="" d
	.s Type=..sssCode()
	.s CompFlag="N"  
	.s PoFlag="N"
	.s PurNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
	.i PurNo="" s Sc=RtnObj.Err(-2,"","采购单号生成失败") q
	.s obj=##class(User.INPurPlan).%New()
	.s obj.INPPNo=PurNo
	.s obj.INPPPoFlag=PoFlag
	.s obj.INPPComplete=CompFlag
	.s obj.INPPStkType=Type
	e  d
	.i ..sssLock(AppName_PurId)<0 s Sc=RtnObj.Err(-99,"","加锁失败!") q
	.s obj=##class(User.INPurPlan).%OpenId(PurId)
	q:RtnObj.success<0 RtnObj
	
	d obj.INPPCTLOCDRSetObjectId(LocId)
	d obj.INPPSSUSRDRSetObjectId(UserId)
	d obj.INPPSCGDRSetObjectId(StkGrpId)
	s obj.INPPDate=PurDate
	s obj.INPPTime=PurTime
	s obj.INPPMouldFlag=MouldFlag
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.d ..sssUnLock(AppName_PurId)
	.d RtnObj.Err(-5,"","主表更新失败!")
	i RtnObj.success'=0 q RtnObj
	
	s PurId=obj.%Id()
	s RtnObj.rowid=PurId
	q RtnObj
}

/// Descript:	审核采购计划单信息
/// 对象类型数据
ClassMethod jsAudit(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Audit(Params)
	q RtnObj.Json()
}

/// Descript:	审核采购计划单信息
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		IN_Purplan
/// Input:		主单信息
/// Return：	成功，失败
/// d ##class(web.DHCSTMHUI.INPurPlan).Audit("{""RowId"":""14"",""gUserId"":""12183"",""gLocId"":""163"",""gGroupId"":""96"",""gHospId"":""2""}")
ClassMethod Audit(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s PurId=PJObj.%Get("RowId")
	i +PurId=0  s Sc=RtnObj.Err(-1,"","采购单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s LocId=$p(^INPP(PurId),"^",7)
	s Audit=$p(^INPP(PurId),"^",10)
	i Audit="Y"  s Sc=RtnObj.Err(-2,"","已完成审核!","",0)
	q:RtnObj.success'=0 RtnObj
	
	;判断此审核级别是否已经审核
	s Status=..GetDHCPlanStatus(GroupId,LocId)	;DHC_PlanStatus	rowid
	i Status=""  s Sc=RtnObj.Err(-2,"","无审核权限!","",0)
	q:RtnObj.success'=0 RtnObj
	s PlanAudit=..GetPlanAudit(PurId,Status)	;DHC_PlanAudit	rowid
	i PlanAudit'=""  s Sc=RtnObj.Err(-2,"","此安全组已经审核!","",0)
	q:RtnObj.success'=0 RtnObj
	
	;判断是否到该安全组审核
	s LastStatus=""
	s PlanStatusInit=""
	s PlanStatusInit=..GetPlanStatusInit(LocId,Status)
	s LastStatusInit=$o(^DHCPSI(0,"CTLOC",LocId,PlanStatusInit),-1)
	s:LastStatusInit'="" LastStatus=$p(^DHCPSI(LastStatusInit),"^",2)
	s Ret=..CheckAudit(PurId,LastStatus) ;判断上一级审核是否已经完成
	i Ret'=0  s Sc=RtnObj.Err(-2,"","上一级未审核!","",0)
	q:RtnObj.success'=0 RtnObj
	ts
	;采购单审批记录表里插入数据20140320
	s MaxAmt=$p(^DHCPS(Status),"^",3)  ;采购级别最大审核金额
	s PlanAmt=..GetPlanAmt(PurId)        ;获取采购单合计金额
	s ret=..SetDHCPlanAudit(PurId,Status,UserId)
	i ret'=0  s Sc=RtnObj.Err(-2,"","插入审核记录失败！")
	i RtnObj.success'=0 tro  q RtnObj
			
	;是否已经完全审批判断
	s AuditCom="N"  //完全审批标志
	s PlanStatusInit=$o(^DHCPSI(0,"CTLOC",LocId,""),-1)
	s DHCPlanStatustmp=""
	s:PlanStatusInit'="" DHCPlanStatustmp=$p(^DHCPSI(PlanStatusInit),"^",2)
	i ((MaxAmt'="")&(PlanAmt<=MaxAmt))!(Status=DHCPlanStatustmp) d   //当前级别审批金额大于等于采购单金额，或当前审批级别为最终审批级别 
	.s AuditCom ="Y" 
	.s ret=..SetPurplanAudit(PurId,UserId,"N")
	.i ret'=0  s Sc=RtnObj.Err(-2,"","更新某采购计划单审核标志失败！")
	i RtnObj.success'=0 tro  q RtnObj
	
	;采购计划拆分为订单
	i (AuditCom="Y") d   
	.s RtnObj=..CreatePo(PurId,UserId)
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=PurId
	q RtnObj
}

/// 返回当前采购单的审核级别信息
/// w ##class(web.DHCSTMHUI.INPurPlan).GetPlanStatusInfo()
/// ^^我已经审核^轮到我审核
ClassMethod GetPlanStatusInfo(Inpp, GroupId)
{
	n (Inpp,GroupId)
	s LocId=$p(^INPP(Inpp),"^",7)
	s DHCPlanStatus="",DHCPlanStatusDesc=""
	s PlanAuditId=""
	s PlanAuditId=$o(^DHCPA(0,"INPP",Inpp,""),-1)
	s:PlanAuditId'="" DHCPlanStatus=$p(^DHCPA(PlanAuditId),"^",2)
	s:DHCPlanStatus'="" DHCPlanStatusDesc=$p(^DHCPS(DHCPlanStatus),"^",2)
	;判断此审核级别是否已经审核
	s PlanAudit="",LastAudit=""
	s Status=..GetDHCPlanStatus(GroupId,LocId)
	i Status'="" d
	.s PlanAudit=..GetPlanAudit(Inpp,Status)
	.i PlanAudit'="" s PlanAudit="Y"
	.s LastStatus=""
	.s PlanStatusInit=""
	.s PlanStatusInit=..GetPlanStatusInit(LocId,Status)
	.s LastStatusInit=$o(^DHCPSI(0,"CTLOC",LocId,PlanStatusInit),-1)
	.i LastStatusInit'="" d
	..s LastStatus=$p(^DHCPSI(LastStatusInit),"^",2)
	..s LastPlanAudit=..GetPlanAudit(Inpp,LastStatus) ;判断上一级审核是否已经完成
	..i LastPlanAudit="" d
	...s LastAudit="N"
	..e  d
	...s LastAudit="Y"
	.e  d
	..s LastAudit="Y"
	s MyTurnAudit=""
	i (Status'="")&&(LastAudit="Y")&&(PlanAudit'="Y") s MyTurnAudit="Y"
	q DHCPlanStatus_"^"_DHCPlanStatusDesc_"^"_PlanAudit_"^"_MyTurnAudit
}

/// Descript:	获取安全组对于某科室采购单的审核级别rowid(DHC_PlanStatusInit)
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		DHC_PlanStatusInit
/// Input:		审核人安全组rowid, 采购单科室rowid
/// Return：	"":没有审核权限, 非空:审核级别rowid
/// w ##class(web.DHCSTMHUI.INPurPlan).GetDHCPlanStatus(99,153)
ClassMethod GetDHCPlanStatus(GroupId As %String, LocId As %String) As %Library.String
{
	n (GroupId,LocId)
	s Status=""
	&sql(select DHCPSI_DHCPS_DR into:Status from DHC_PlanStatusInit where DHCPSI_SSGRP_DR=:GroupId and DHCPSI_CTLOC_DR=:LocId)
	q Status
}

/// Descript:	获取采购单在某审核级别(Status rowid)下的审核记录rowid(DHC_PlanAudit), 改级别未审核时返回空
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		DHC_PlanAudit
/// Input:		采购单rowid, DHC_PlanStatusInit-rowid
/// Return:		"":该级别尚未审核, 非空:该级别审核记录rowid(DHC_PlanAudit)
ClassMethod GetPlanAudit(Rowid As %String, Status As %String) As %Library.String
{
	n (Rowid,Status)
	s PlanAudit=""
	&sql(select DHCPA_RowId into:PlanAudit from DHC_PlanAudit where DHCPA_INPP_DR=:Rowid and DHCPA_DHCPS_DR=:Status)
	q PlanAudit
}

/// Descript:	获取对于某科室采购单的审核级别rowid(DHC_PlanStatusInit)
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		DHC_PlanStatusInit
/// Input:		科室id，状态
/// Return:		当前审批级别
ClassMethod GetPlanStatusInit(LocId As %String, Status As %String) As %Library.String
{
	n (LocId,Status)
	s PlanStatusInit=""
	&sql(select DHCPSI_RowId into:PlanStatusInit from DHC_PlanStatusInit where DHCPSI_CTLOC_DR=:LocId and DHCPSI_DHCPS_DR=:Status)
	q PlanStatusInit
}

/// Descript:	检查上一级审核级别是否已经审核
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		DHC_PlanStatusInit
/// Input:		单据id，上一级状态
/// Return:		已经审核返回0
ClassMethod CheckAudit(Rowid As %String, LastStatus As %String) As %Library.String
{
	n (Rowid,LastStatus)
	q:LastStatus="" 0
	&sql(select DHCPA_RowId into:Rowid from DHC_PlanAudit where DHCPA_INPP_DR=:Rowid and DHCPA_DHCPS_DR=:LastStatus)
	q SQLCODE
}

/// Descript:	获取采购单合计金额
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		IN_PurplanItm
/// Input:		单据id
/// Return:		合计金额
ClassMethod GetPlanAmt(Rowid As %String) As %Library.String
{
	n (Rowid)
	s ch=""
	s amt=0
	f  s ch=$o(^INPP(Rowid,"PPI",ch))   q:ch=""  d
	.s rpamt=0, qty=0 ,price=0
	.s qty=$P(^INPP(Rowid,"PPI",ch),"^",3)
	.s price=$P(^INPP(Rowid,"PPI",ch),"^",5)
	.s rpamt=price*qty
	.s amt=amt+rpamt
	q amt
}

/// Descript:	插入采购单审核记录
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		DHC_PlanAudit
/// Input:		采购单id,状态，审核人id
/// Return:		0成功,-1计划单已经完成，-3操作失败
ClassMethod SetDHCPlanAudit(Rowid As %String, DHCPlanStatus As %String, UserId As %String) As %Library.String
{
	n (Rowid,DHCPlanStatus,UserId)
	q:Rowid="" -100
	q:UserId="" -100
	q:DHCPlanStatus="" -101 ;此人无权限审核
	s Date=+$h
	s Time=$p($h,",",2)
	
	s Err=0
	&sql(insert into DHC_PlanAudit
	(DHCPA_INPP_DR,DHCPA_DHCPS_DR,DHCPA_Date,DHCPA_SSUSR_DR,DHCPA_Time)
	values 
	(:Rowid,:DHCPlanStatus,:Date,:UserId,:Time))
	i SQLCODE'=0  d
	.s Err=-102 ;插入数据失败
	
	q Err
}

/// Descript:	更新某采购计划单审批标志
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		DHC_PlanAudit
/// Input:		rowid，审批人id,是否已生成订单标志
/// Return:		0成功,-1计划单已经完成，-3操作失败
ClassMethod SetPurplanAudit(Rowid As %String, User As %String, PoFlag As %String) As %Library.String
{
	n (Rowid,PoFlag,User)
	
	q:Rowid="" -1
	s AuditFlag=$p(^INPP(Rowid),"^",10)
	s Flag="Y"
	s Date=+$h
	s Time=$p($h,",",2)
	
	s Err=0
	;更新采购计划审批标志
	&sql(update IN_PURPLAN set 
	INPP_AuditDate=:Date,INPP_AuditSSUSR_DR=:User,
	INPP_PoFlag=:PoFlag,INPP_AuditTime=:Time,INPP_AuditFlag=:Flag 
	where INPP_Rowid=:Rowid)
	i SQLCODE'=0  d
	.s Err=-2
	q:Err'=0 Err
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Rowid,"PA",User,"PP")
	q Err
}

/// Descript:	根据采购计划单自动生成订单
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		Table:IN_Purplan
/// Input:		Rowid-采购计划id, UserId:审批人
/// Return:		RtnObj
/// zw ##class(web.DHCSTMHUI.INPurPlan).CreatePo(18,6423)
ClassMethod CreatePo(Rowid As %String, UserId As %String) As RtnObj
{
	n (Rowid,UserId)
	s RtnObj=##class(RtnObj).%New()
	i Rowid="" d RtnObj.Err(-1,"","采购单ID为空!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s InppNo=$p(^INPP(Rowid),"^",1)
	s PoFlag=$p(^INPP(Rowid),"^",6)
	s PurLocId=$p(^INPP(Rowid),"^",7)
	s StkGrpId=$p(^INPP(Rowid),"^",12)
	i PoFlag="Y" q RtnObj.Err(-2,"",InppNo_"已经生成订单!","",0)
	
	s ParamsStr="^"_PurLocId_"^"
	s ItmTrackAppName=##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName")
	s UseItmTrack=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(ItmTrackAppName,"UseItmTrack",ParamsStr)
	
	s AppName=..%GetParameter("AppName")
	s VendorNeeded=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"VendorNeeded",ParamsStr)
	
	s PoAppName=##class(web.DHCSTMHUI.INPO).%GetParameter("AppName")
	s PoByLoc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(PoAppName,"PoByLoc",ParamsStr)
	s PoByProLoc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(PoAppName,"PoByProLoc",ParamsStr)
	;订单拆分类型,记录到Type变量中(字符串)
	;制单默认单位
	s DefUom=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"DefaUom",ParamsStr)
	s Type=$s(PoByLoc="Y":"PoByLoc",PoByProLoc="Y":"PoByProLoc",1:"")
	
	s PoFlag="Y"
	&sql(update IN_PURPLAN set INPP_PoFlag=:PoFlag where INPP_Rowid=:Rowid)
	i SQLCODE'=0 d RtnObj.Err(-2,"","更新采购计划状态失败")
	q:RtnObj.success'=0 RtnObj
	
	s Pid=..NewPid()
	s ret=$$CollectData(Type,Rowid)
	i ret'=0 d RtnObj.Err(-3,"","收集订单信息失败")
	q:RtnObj.success'=0 RtnObj

	s SubStr=""
	f  s SubStr=$o(^TMPDHCSTM(Pid,SubStr)) q:(SubStr="")!(RtnObj.success'=0)  d
	.s VenId=$p(SubStr,",",1)
	.s HVFlag=$p(SubStr,",",2)
	.s ReqLocId=$p(SubStr,",",3)
	.s ProLocId=$p(SubStr,",",4)
	.s PoLocId=$s(ProLocId'="":ProLocId,1:PurLocId)		;按请求单的供应科室
	.
	.s MainTitle="Vendor^PoLoc^gUserId^StkScg^ReqLoc"
	.s MainData=VenId_"^"_PoLocId_"^"_UserId_"^"_StkGrpId_"^"_ReqLocId
	.s Main=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	.
	.s RtnObj=##class(web.DHCSTMHUI.INPO).Update(Main)
	.i RtnObj.success'=0 d RtnObj.Err(-4,"","生成订单主单失败") q
	.s PoId=RtnObj.rowid
	.
	.s Inppi=""
	.f  s Inppi=$o(^TMPDHCSTM(Pid,SubStr,Inppi)) q:(Inppi="")!(RtnObj.success'=0)  d
	..s Data=^TMPDHCSTM(Pid,SubStr,Inppi)
	..s IncId=$p(Data,"^",1)
	..s UomId=$p(Data,"^",2)
	..s Rp=$p(Data,"^",3)
	..s Qty=$p(Data,"^",4)
	..s SpecDesc=$p(Data,"^",5)
	..s ManfId=$p(Data,"^",6)
	..s DemandDate=$p(Data,"^",7)
	..s ReqQty=0
	..s Detail="[{""InciId"":"""_IncId_""",""UomId"":"""_UomId_""",""Rp"":"""_Rp_""",""PurQty"":"""_Qty_""",""ReqQty"":"""_ReqQty_""",""SpecDesc"":"""_SpecDesc_""",""ManfId"":"""_ManfId_""",""DemandDate"":"""_DemandDate_"""}]"
	..s RtnObj=##class(web.DHCSTMHUI.INPOItm).Save(PoId,Detail)
	..i RtnObj.success'=0 d RtnObj.Err(-4,"","生成订单明细失败") q
	..s PoItmId=RtnObj.rowid
	..
	..&sql(update in_purplanitm set inppi_inpoi_dr=:PoItmId where inppi_rowid=:Inppi)
	..i SQLCODE'=0 d RtnObj.Err(-4,"","更新采购单明细失败") q
	.
	.s Comp="{""RowId"":"""_PoId_""",""gUserId"":"""_UserId_""",""PoLoc"":"""_PurLocId_"""}"
	.s RtnObj=##class(web.DHCSTMHUI.INPO).SetComplete(Comp)
	.i RtnObj.success'=0 d RtnObj.Err(-5,"","订单完成失败") q
	.
	.d ..CheckSendInpo(PoId)

	k ^TMPDHCSTM(Pid)
	q RtnObj
	
CollectData(Type,Inpp)
	k ^TMPDHCSTM(Pid)
	s Ret=0
	s Chl=0
	f  s Chl=$o(^INPP(Inpp,"PPI",Chl)) q:(Chl="")!(Ret'=0)  d
	.s Inppi=Inpp_"||"_Chl
	.s InppiData=^INPP(Inpp,"PPI",Chl)
	.s VendorId=$p(InppiData,"^",1)
	.s IncId=$p(InppiData,"^",2)
	.s Qty=$p(InppiData,"^",3)
	.s UomId=$p(InppiData,"^",4)
	.s Rp=$p(InppiData,"^",5)
	.s ManfId=$p(InppiData,"^",6)
	.s ReqLocId=$p(InppiData,"^",10)				;请求科室
	.s SpecDesc=$p(InppiData,"^",14)
	.s RefuseFlag=$p(InppiData,"^",15)
	.s CanceledFlag=$p(InppiData,"^",19)
	.s DemandDate=$p(InppiData,"^",22)
	.
	.q:RefuseFlag="Y"
	.q:CanceledFlag="Y"
	.i VendorNeeded'="N" d    //采购计划供应商必填判断供应商,否则过滤供应商为空
	..s:VendorId="" Ret=-10
	.q:Ret<0
	.q:VendorId=""
	.
	.i ReqLocId="" s ReqLocId=PurLocId
	.s ProLocId=..GetProLocByInppi(Rowid_"||"_Chl)	;供应科室(请求单上的供给科室)
	.i ProLocId="" s ProLocId=PurLocId
	.
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
	.s BUomId=$p(^INCI(IncId,1),"^",10)
	.s PurUomId=$p(^INCI(IncId,3),"^",6)
	.i DefUom=1 s PurUomId=BUomId //参数控制制单默认单位
	.s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	.s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s PurQty=Qty*Fac1/Fac2
	.s PurRp=Rp/Fac1*Fac2
	.
	.;组织SubStr节点,逗号隔开(Vendor,高值标记,请求科室,供给库房)
	.s $p(SubStr,",",1)=VendorId
	.i UseItmTrack="Y" s $p(SubStr,",",2)=HVFlag
	.i Type="PoByLoc" s $p(SubStr,",",3)=ReqLocId
	.i Type="PoByProLoc" s $p(SubStr,",",4)=ProLocId
	.;四川阳光采购
	.s HospId=..sssHospId(PurLocId)
	.s sunpurparamStr="^^^"_HospId
	.s SunPurPlanParam=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","SunPurPlan",sunpurparamStr)
	.if SunPurPlanParam="四川省"  d
	..s ScgFlag=##class(web.DHCSTMHUI.ServiceForSCYGCG).GetInciFlag(IncId)
	..s $p(SubStr,",",5)=ScgFlag   ;区分开物资试剂
	.
	.s ^TMPDHCSTM(Pid,SubStr,Inppi)=IncId_"^"_PurUomId_"^"_PurRp_"^"_PurQty_"^"_SpecDesc_"^"_ManfId_"^"_DemandDate
	
	q Ret
}

/// Descript:	根据采购明细id取库存请求科室
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		DHC_INPPReqItm，in_request
/// Input:		采购明细id
/// Return:		请求科室id
ClassMethod GetProLocByInppi(inppi)
{
	n (inppi)
	s inreqi=""
	&sql(select PPREQI_REQITM_DR into :inreqi from  DHC_INPPReqItm where PPREQI_INPPI_Parref=:inppi)
	s inreq=+inreqi
	s ProLoc=""
	&sql(select INRQ_ReqLoc_DR into :ProLoc from in_request where INRQ_RowId=:inreq)
	q ProLoc
}

/// Descript:	拒绝采购计划单
/// 对象类型数据
ClassMethod jsDeny(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Deny(Params)
	q RtnObj.Json()
}

/// Descript:	拒绝采购计划单
/// Creator:	lxt
/// CreateDate:	2018-05-28
/// Table:		IN_Purplan
/// Input:		rowid，拒绝人
/// Return:		请求科室id
/// w ##class(web.DHCSTMHUI.INPurPlan).Deny()
ClassMethod Deny(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s PurId=PJObj.%Get("RowId")
	i +PurId=0  s Sc=RtnObj.Err(-1,"","采购单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s RefuseCase=PJObj.%Get("RefuseCase")
	s LocId=$p(^INPP(PurId),"^",7)

	s Status=""
	s Status=..GetDHCPlanStatus(GroupId,LocId)
	i Status=""  s Sc=RtnObj.Err(-2,"","无审核权限!","",0)
	q:RtnObj.success'=0 RtnObj
	s PlanAudit=""
	s PlanAudit=..GetPlanAudit(PurId,Status)
	i PlanAudit'=""  s Sc=RtnObj.Err(-2,"","此安全组已经审核!","",0)
	q:RtnObj.success'=0 RtnObj
	
	ts
	&sql(SELECT INPP_AuditFlag into :AuditFlag FROM IN_PurPlan where INPP_Rowid=:PurId)
	
	i AuditFlag'="" d
	.&sql(UPDATE IN_PurPlan SET INPP_AuditDate=NULL, INPP_AuditSSUSR_DR=NULL, INPP_AuditTime=NULL, INPP_AuditFlag=NULL WHERE INPP_Rowid=:PurId)
	.i SQLCODE'=0  s Sc=RtnObj.Err(-3,"","更新审核信息失败！")
	i RtnObj.success'=0 tro  q RtnObj
	
	&sql(UPDATE IN_PurPlan SET INPP_RefuseCase=:RefuseCase WHERE INPP_Rowid=:PurId)
	i SQLCODE'=0  s Sc=RtnObj.Err(-4,"","更新拒绝信息失败！")
	i RtnObj.success'=0 tro  q RtnObj
	
	&sql(DELETE FROM DHC_PlanAudit WHERE DHCPA_INPP_DR=:PurId)
	i (SQLCODE'=0)&(SQLCODE'=100)  s Sc=RtnObj.Err(-4,"","删除审核记录失败！")
	i RtnObj.success'=0 tro  q RtnObj
	
	s Flag="N"
	&sql(Update IN_PurPlan set INPP_Complete=:Flag where INPP_Rowid=:PurId)
	i SQLCODE'=0  s Sc=RtnObj.Err(-4,"","更新完成标志失败")
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=PurId   
	q RtnObj
}

/// //自动审核功能
/// //任务
ClassMethod AutoAudit()
{
	s user="",demo="demo"
	&sql(select %id into :user from ss_user where SSUSR_Initials = :demo)
	s GroupId=""
	s inpp=0
	s da=+$h		;任务挂在当天23:55
	f  s inpp=$O(^INPP(0,"DATE",da,inpp)) q:inpp=""  d
	.s AuditFlag=$p(^INPP(inpp),"^",10)
	.q:AuditFlag="Y"
	.s ret=..Audit(Inpp,user,GroupId)
	q
}

/// 上传订单到平台
/// Input:		订单Id
ClassMethod CheckSendInpo(Inpo) As %String
{
	n (Inpo)
	s Params=..sssParamStr()
	s AppName=..%GetParameter("AppName")
	s AutoSendToSci=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoSendToSci",Params)
	q:AutoSendToSci'="Y" 0
	
	i HospId="" d
	.s DhcPoId=$o(^DHCINPO(0,"INPO",Inpo,""),-1)
	.i DhcPoId'="" d
	..s PoLocId =$p(^DHCINPO(DhcPoId),"^",2)
	..s HospId=..sssHospId(PoLocId)
	
	s Ret=##class(web.DHCSTMHUI.ServiceForSCI).getHopOrder(Inpo, "")
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).saveSupOrder(Inpo, "",HospId)
	i Ret=0 d
	.s PlatSend="Y"
	.&sql(UPDATE IN_PO SET INPO_PlatSend=:PlatSend WHERE IN_PO=:Inpo)
	
	q Ret
}

/// Table:		
/// Input:		库存项代码,生产厂家名称,供应商名称,单位描述
/// w ##class(web.DHCSTMHUI.INPurPlan).GetInciMsg(CS001","","上海巨彤商贸有限公司","片","东华标准版数字化医院[总院]")
ClassMethod GetInciMsg(InciCode As %String, Manf As %String, Vendor As %String, UomDesc As %String, Hospital As %String) As %Library.String
{
	n (InciCode,Manf,Vendor,UomDesc,Hospital,%session)
	s ^zlktemp("GetInciMsg")=$lb(InciCode,Manf,Vendor,UomDesc,Hospital)
	s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital),0))
	q:InciCode="" ""
	s Inci=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",InciCode,"INC_Itm",HospId)
	s ManfId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",Manf,"PH_Manufacturer",HospId,"M")
	s VendorId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",Vendor,"APC_Vendor",HospId,"M")
	s UomId=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(UomDesc),0))
	s (Spec,Model)=""
	i Inci'="" d
	.s AddInfo=$O(^DHCITMINFO(0,"INCI",Inci,0))
	.i AddInfo'="" d
	..s AddInfoData=^DHCITMINFO(AddInfo)
	..s Spec=$p(AddInfoData,"^",27)
	..s Model=$p(AddInfoData,"^",59)
	q Inci_"^"_ManfId_"^"_UomId_"^"_Spec_"^"_VendorId
}

/// Descript:	取消审核采购计划单
/// 对象类型数据
ClassMethod jsCancelAudit(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelAudit(Params)
	q RtnObj.Json()
}

/// Descript:	取消审核采购计划单
/// Creator:	why
/// CreateDate:	20221226
/// Table:		IN_Purplan
/// Input:		rowid，拒绝人
/// Return:		请求科室id
/// w ##class(web.DHCSTMHUI.INPurPlan).Deny()
ClassMethod CancelAudit(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s PurId=PJObj.%Get("RowId")
	i +PurId=0  s Sc=RtnObj.Err(-1,"","采购单ID不能为空!")
	q:RtnObj.success'=0 RtnObj
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s LocId=$p(^INPP(PurId),"^",7)

	s Status=""
	s Status=..GetDHCPlanStatus(GroupId,LocId)
	i Status=""  s Sc=RtnObj.Err(-2,"","无取消审核权限!")
	q:RtnObj.success'=0 RtnObj
	s PoFlag=$p(^INPP(PurId),"^",6)
	i PoFlag="Y" q RtnObj.Err(-2,"","已经生成订单!")
	
	ts
	&sql(SELECT INPP_AuditFlag into :AuditFlag FROM IN_PurPlan where INPP_Rowid=:PurId)
	
	i AuditFlag="Y" d
	.&sql(UPDATE IN_PurPlan SET INPP_AuditDate=NULL, INPP_AuditSSUSR_DR=NULL, INPP_AuditTime=NULL, INPP_AuditFlag=NULL WHERE INPP_Rowid=:PurId)
	.i SQLCODE'=0  s Sc=RtnObj.Err(-3,"","更新审核信息失败！")
	i RtnObj.success'=0 tro  q RtnObj
	
	&sql(DELETE FROM DHC_PlanAudit WHERE DHCPA_INPP_DR=:PurId)
	i (SQLCODE'=0)&(SQLCODE'=100)  s Sc=RtnObj.Err(-4,"","删除审核记录失败！")
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=PurId   
	q RtnObj
}

/// Descript:   批量生成订单根据入库单(Js调用)
/// Creator:    lihui
/// CreateDate: 20221130
/// w ##class(web.DHCSTMHUI.INPurPlan).jsCreatePoByRec(135,12183)
ClassMethod jsCreatePoByRec(IngrIdStr, UserId As %String) As %Library.String
{
	n (IngrIdStr,UserId)
	s ^tmpli("jsCreatePoByRec")=$lb(IngrIdStr,UserId)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s del="^"
	s cnt=$l(IngrIdStr,del)
	s ErrMsg="",Succnt=0,RowidStr=""
	f i=1:1:cnt d
	.s IngrId=$p(IngrIdStr,del,i)
	.s RtnObj=..CreatePoByRec(IngrId,UserId)
	.i RtnObj.success=0 d
	..s Succnt=Succnt+1
	..i RowidStr="" d
	...s RowidStr= IngrId
	..e  d
	...s RowidStr=RowidStr_"^"_IngrId
	.e  d
	..s msginfo=IngrId_":"_RtnObj.msg
	..i ErrMsg="" d
	...s ErrMsg= msginfo
	..e  d
	...s ErrMsg=ErrMsg_"#"_msginfo
	s RtnObj.rowid=RowidStr
	s RtnObj.msg=cnt_"@"_Succnt_"@"_ErrMsg
	s RtnObj.success=0
	q RtnObj.Json()
}

/// Descript:	根据入库单自动生成订单
/// Creator:	lihui
/// CreateDate:	20221130
/// Table:		Table: DHC_INGdRec
/// Input:		Rowid-入库单id, UserId:操作人ID
/// Return:		RtnObj
/// w ##class(web.DHCSTMHUI.INPurPlan).CreatePoByRec(166,12183)
ClassMethod CreatePoByRec(Rowid As %String, UserId As %String) As RtnObj
{
	n (Rowid,UserId)
	s RtnObj=##class(RtnObj).%New()
	i (Rowid="")||('$d(^DHCINGR(Rowid))) d RtnObj.Err(-1,"","入库单ID为空或者入库单不存在!")   q RtnObj
	s ingrinfo=^DHCINGR(Rowid)
	s IngrNo=$p(ingrinfo,"^",1)
	s PurLocId=$p(ingrinfo,"^",13)
	s StkGrpId=$p(ingrinfo,"^",28)
	s INGRINPODR=$p(ingrinfo,"^",11)
	i INGRINPODR'="" q RtnObj.Err(-2,"",IngrNo_"已经生成订单!")
	s AuditFlag=$p(ingrinfo,"^",29)
	i AuditFlag'="Y" q RtnObj.Err(-2,"",IngrNo_"入库单未审核!")
	s VenId=$p(ingrinfo,"^",3)
	s MainRemark="入库单生成订单"
	s MainTitle="Vendor^PoLoc^gUserId^StkScg^Remark"
	s MainData=VenId_"^"_PurLocId_"^"_UserId_"^"_StkGrpId_"^"_MainRemark
	s Main=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	
	ts
	s RtnObj=##class(web.DHCSTMHUI.INPO).Update(Main)
	i RtnObj.success'=0 d RtnObj.Err(-4,"","生成订单主单失败") tro  q RtnObj
	s PoId=RtnObj.rowid
	&sql(UPDATE DHC_INGdRec SET INGR_INPO_DR=:PoId WHERE INGR_RowId=:Rowid)
	i SQLCODE'=0 d RtnObj.Err(-2,"","更新采购计划状态失败") tro  q RtnObj
	
	s Pid=..NewPid()
	s ret=$$CollectDataByRec(Rowid)
	s incid="" 
	f  s incid=$o(^TMPDHCSTMRECPO(Pid,incid)) q:(incid="")!(RtnObj.success'=0)  d
	.s Qty=$p(^TMPDHCSTMRECPO(Pid,incid),"&",1)
	.s ingritmidstr=$p(^TMPDHCSTMRECPO(Pid,incid),"&",2)
	.s Data=$p(^TMPDHCSTMRECPO(Pid,incid),"&",3)
	.s UomId=$p(Data,"^",1)
	.s Rp=$p(Data,"^",2)
	.s ManfId=$p(Data,"^",3)
	.
	.s Detail="[{""InciId"":"""_incid_""",""UomId"":"""_UomId_""",""Rp"":"""_Rp_""",""PurQty"":"""_Qty_""",""ManfId"":"""_ManfId_"""}]"
	.s RtnObj=##class(web.DHCSTMHUI.INPOItm).Save(PoId,Detail)
	.i RtnObj.success'=0 d RtnObj.Err(-4,"","生成订单明细失败") q
	.s PoItmId=RtnObj.rowid
	.
	.
	.f i=1:1:$l(ingritmidstr,"^") q:(RtnObj.success'=0)  d
	..s ingritmid=$p(ingritmidstr,"^",i)
	..&sql(UPDATE DHC_INGdRecItm SET INGRI_INPOI_DR=:PoItmId WHERE INGRI_RowId=:ingritmid)
	..i SQLCODE'=0 d RtnObj.Err(-4,"","更新入库单明细失败") q
	i RtnObj.success'=0  tro  q RtnObj
	s Comp="{""RowId"":"""_PoId_""",""gUserId"":"""_UserId_""",""PoLoc"":"""_PurLocId_"""}"
	s RtnObj=##class(web.DHCSTMHUI.INPO).SetComplete(Comp)
	i RtnObj.success'=0 d RtnObj.Err(-5,"","订单完成失败")  tro  q RtnObj
	tc
	;发送阳光平台
	;s retinfo= ##class(web.DHCSTMHUI.ServiceForSCYGCG).UpLoadPo(PoId)
	;i +retinfo'=0 d RtnObj.Err(-1,"","同步订单至阳光平台失败"_retinfo) q RtnObj
	q RtnObj
CollectDataByRec(IngrId)
	k ^TMPDHCSTMRECPO(Pid)
	s Ret=0
	s chl="" 
	f  s chl=$o(^DHCINGR(IngrId,"GRI",chl)) q:(chl="")  d
	.s ingritmid=IngrId_"||"_chl
	.q:'$d(^DHCINGR(Rowid,"GRI",chl))
	.s Data=^DHCINGR(Rowid,"GRI",chl)
	.s IncId=$p(Data,"^",25)
	.s Qty=$p(Data,"^",4)
	.s UomId=$p(Data,"^",4)
	.s Rp=$p(Data,"^",5)
	.s ManfId=$p(Data,"^",6)
	.s BUomId=$p(^INCI(IncId,1),"^",10)
	.s PurUomId=$p(^INCI(IncId,3),"^",6)
	.s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	.s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s PurQty=Qty*Fac1/Fac2
	.s PurRp=Rp/Fac1*Fac2
	.
	.i $d(^TMPDHCSTMRECPO(Pid,IncId)) d
	..s $p(^TMPDHCSTMRECPO(Pid,IncId),"&",1)=$p(^TMPDHCSTMRECPO(Pid,IncId),"&",1)+PurQty
	..s $p(^TMPDHCSTMRECPO(Pid,IncId),"&",2)=$p(^TMPDHCSTMRECPO(Pid,IncId),"&",2)_"^"_ingritmid
	.e  d
	..s ^TMPDHCSTMRECPO(Pid,IncId)=PurQty_"&"_ingritmid_"&"_PurUomId_"^"_PurRp_"^"_ManfId
	q Ret
}

}
