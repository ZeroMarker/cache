Import sqluser

/// 物资管理后台任务专用
Class web.DHCSTMHUI.Tasks Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 物资系统内部夜间任务
/// Description:统一售价和批次售价合并生效任务(0点之后尽快执行)
/// Creator:    zx
/// CreateDate: 2021602
/// Input:		
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).NightRunAspAmount()
ClassMethod NightRunAspAmount() As %String
{
	d ##class(web.DHCSTMHUI.INAdjSalePrice).NightRunAspAmount()
	d ##class(web.DHCSTMHUI.INAdjPriceBatch).NightRunAspAmount()
}

/// Description:高值夜间任务(23:50执行)
/// Creator:    zx
/// CreateDate: 20210226
/// Input:		
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).NightRunCreateRecHV()
ClassMethod NightRunCreateRecHV() As %String
{
	d ##class(web.DHCSTMHUI.HVMatOrdItm).NightRunCreateRecHV()
}

/// Description:清除门诊未交费医嘱在途数
/// Creator:    zx
/// CreateDate: 20210227
/// description:根据任务清除门诊未交费医嘱在途数,规则为这次执行任务,清除前24到12小时的未交费数据,或72-36
/// Input:任务间隔的小时数,比如12小时一次则入参为12,Type:1-清除未交费,2清除未发药
/// 先发药后交费的不清	
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).ClearReserveQtyClinicNoPay()
ClassMethod ClearReserveQtyClinicNoPay(Hours = "", Type = "") As %String
{
	s:Hours="" Hours=12
	s:Type="" Type=1
	d ##class(web.DHCSTMHUI.LocItmStk).ClearReserveQtyClinicNoPay(Hours,Type)
}

/// Description:根据合同截止日期,停用相关库存项
/// d ##class(web.DHCSTMHUI.Tasks).StopInciByContract()
ClassMethod StopInciByContract()
{
	new
	d ##class(web.DHCSTMHUI.Common.AutoStopUse).StopInciByContract()
}

/// Description:根据医嘱截止日期停用库存项
/// d ##class(web.DHCSTMHUI.Tasks).StopInciByArcimEffDate()
ClassMethod StopInciByArcimEffDate()
{
	new
	d ##class(web.DHCSTMHUI.Common.AutoStopUse).StopInciByArcimEffDate()
}

/// Description:通过库存项里的截止日期停用物资
/// d ##class(web.DHCSTMHUI.Tasks).ItmStop()
ClassMethod ItmStop()
{
	new
	d ##class(web.DHCSTMHUI.Common.AutoStopUse).ItmStop()
}

/// Description:通过供应商的合同截止日期停用供应商
/// d ##class(web.DHCSTMHUI.Tasks).ApcStop()
ClassMethod ApcStop()
{
	new
	d ##class(web.DHCSTMHUI.Common.AutoStopUse).ApcStop()
}

/// Description:清除请求单设置的在途数(清除**小时之前的,默认为12)
/// Creator:    wangjiabin
/// CreateDate: 2017-04-10
/// Input:		hours(小时数)
/// Output:     
/// Return:		处理单据数量^处理成功数量
/// d ##class(web.DHCSTMHUI.Tasks).ClearReqReserved()
ClassMethod ClearReqReserved(hours As %Integer = "") As %String
{
	n (hours)
	s:$g(hours)="" hours=12
	s negtiveHours=-hours
	s endInfo=$SYSTEM.SQL.DATEADD("hh",negtiveHours,$h)
	s endDate=$zdh($p(endInfo," ",1),3),endTime=$zth($p(endInfo," ",2))
	s days=$SYSTEM.SQL.CEILING(hours/24)+1		;多计算一些起始日期
	s startDate=endDate-days,startTime=0
	
	s count=0,successCount=0
	f date=startDate:1:endDate d
	.s inrq=0
	.f  s inrq=$o(^INRQ(0,"Date",date,inrq)) q:inrq=""  d
	..s reqTime=$p(^INRQ(inrq),"^",3)
	..q:(date=startDate)&&(reqTime<startTime)
	..q:(date=endDate)&&(reqTime>endTime)
	..
	..s comp=$p(^INRQ(inrq),"^",8)
	..q:comp'="Y"			;未完成的
	..s dhcInrq=$o(^DHCINRQ(0,"INRQ",inrq,0))
	..q:dhcInrq=""
	..s auditUserProv=$p(^DHCINRQ(dhcInrq),"^",14)
	..s auditDateProv=$p(^DHCINRQ(dhcInrq),"^",15)
	..q:auditUserProv'=""	;供应方已审批的,过滤
	..
	..s count=count+1
	..s ret=##class(web.DHCSTMHUI.INRequest).CancelComp(inrq,"T")
	..s:ret=0 successCount=successCount+1
	
	q count_"^"_successCount
}

/// Descript:   修改门诊高值医嘱超时未收费的条码状态
/// Creator:	ZhuoLK
/// CreateDate: 2019-03-31
/// Output: 总共处于未收费的条码数量^超时未收费的条码数量^成功处理数量
/// d ##class(web.DHCSTMHUI.Tasks).BarCodeStatusRec()
ClassMethod BarCodeStatusRec() As %Library.String
{
	s (day,time)=0
	s hospId=2
    s myConInfo=##class(web.DHCSTMHUI.Common.ServiceCommon).ReadOPSPConfig(hospId)       //获取计费配置 flag为0时 value代表天数，为1时代表小时
	s myOPFlag=+$p(myConInfo,"^",24)			;
	s myOPValue=+$p(myConInfo,"^",25)
	s:myOPFlag=0 day=myOPValue
	s:myOPFlag=1 time=myOPValue
	s count=0,success=0,countsum=0
	s dhcit=""
	ts
	f  s dhcit=$o(^DHCIT(0,"Status","Used",dhcit)) q:dhcit=""  d
	.s barcode=$p(^DHCIT(dhcit),"^",2)
	.q:$d(^DHCHVMORI(0,"BARCODE",barcode))  //过滤已收费的
	.s inci=$p(^DHCIT(dhcit),"^",1)
	.;q:inci'=6583
	.s child=""
	.f  s child=$o(^DHCITD(dhcit,"I",child)) q:child=""  d
	..s dhcititm=dhcit_"||"_child
	..s pointer= $p(^DHCITD(dhcit,"I",child),"^",1)
	..s type=$p(^DHCITD(dhcit,"I",child),"^",2)
	..q:type'="MF"
	..s info=##class(web.DHCSTMHUI.DHCItmTrack).GetOperNo(type,pointer)
	..s intrflag=$p(info,"^",3)
	..q:intrflag="Y"
	..s oeord=$p(pointer,"||",1)
	..s sub=$p(pointer,"||",2)
	..s StartDate=$p(^OEORD(oeord,"I",sub,1),"^",9)
	..s Starttime=$p(^OEORD(oeord,"I",sub,1),"^",10)
	..s countsum=countsum+1
	..i (+$h>(StartDate+day)) d
	...s count=count+1
	...s obj=##class(User.DHCItmTrack).%OpenId(dhcit)
	...s obj.DHCITStatus="Enable"
	...s sc=obj.%Save()
	...i $$$ISERR(sc) tro 1 q
	...s objItm=##class(User.DHCItmTrackDetail).%OpenId(dhcititm)
	...s objItm.DHCITDType="MFC"         //保留之前的台账记录，更改状态为MFC
	...s sc1=objItm.%Save()
	...i $$$ISERR(sc1) tro 1 q
	...s success=success+1
	..
	.
	tc
	q countsum_"^"_count_"^"_success
}

/// Description:通过任务自动生成月报(生成的是上月1号到上月最后一天的月报，生成[科室扩充信息]页面的"自动生成月报标志"来取值)
/// 任务可以改在每月1号
/// d ##class(web.DHCSTMHUI.Tasks).AutoCreateStkMonDemo()
ClassMethod AutoCreateStkMonDemo()
{
	new
	d ##class(web.DHCSTMHUI.DHCStkMon).AutoCreateStkMonDemo()
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 上传科室信息
/// Creator:    zx
/// CreateDate: 20210302
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).saveHopDepartECS()
ClassMethod saveHopDepartECS() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"saveHopDepart",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).saveHopDepart()
}

/// Description:ECS供应链, 上传高值消耗数据
/// Creator:    zx
/// CreateDate: 20220330
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getHvLabelsECS()
ClassMethod getHvLabelsECS() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getHvLabels",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getHvLabels()
}

/// Description:ECS供应链, 往院内同步发票信息
/// Creator:    zx
/// CreateDate: 20220330
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getInvNosECS()
ClassMethod getInvNosECS() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getInvNos",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getInvNos()
}

/// SCI供应链对接夜间任务
/// Description:SCI供应链, 上传科室、供应商、物资信息
/// Creator:    zx
/// CreateDate: 20210706
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).saveInforMationSCI()
ClassMethod saveInforMationSCI() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.Sci.SciClient"_"||"_"getHopLoc",0)
	i $IsObject(CompiledObj) d
	.d ##class(web.DHCSTMService.Sci.SciClient).getHopLoc()

	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.Sci.SciClient"_"||"_"getHopVendor",0)
	i $IsObject(CompiledObj) d
	.d ##class(web.DHCSTMService.Sci.SciClient).getHopVendor()
	
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.Sci.SciClient"_"||"_"getHopInc",0)
	i $IsObject(CompiledObj) d
	.d ##class(web.DHCSTMService.Sci.SciClient).getHopInc()
}

/// Description:SCI供应链, 上传科室信息
/// Creator:    zx
/// CreateDate: 20210303
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).saveHopDepartSCI()
ClassMethod saveHopDepartSCI() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.Sci.SciClient"_"||"_"getHopLoc",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.Sci.SciClient).getHopLoc()
}

/// Description:SCI供应链, 上传供应商信息
/// Creator:    zx
/// CreateDate: 20210303
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).saveHopVendorSCI()
ClassMethod saveHopVendorSCI() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.Sci.SciClient"_"||"_"getHopVendor",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.Sci.SciClient).getHopVendor()
}

/// Description:SCI供应链, 上传物资信息
/// Creator:    zx
/// CreateDate: 20210303
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).saveHopIncSCI()
ClassMethod saveHopIncSCI() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.Sci.SciClient"_"||"_"getHopInc",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.Sci.SciClient).getHopInc()
}

/// Description:SCI供应链, 上传高值消耗
/// Creator:    zx
/// CreateDate: 20210416
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getHvLabelsSCI()
ClassMethod getHvLabelsSCI() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.Sci.SciClient"_"||"_"getHvLabels",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.Sci.SciClient).getHvLabels()
}

/* 与 SendTask 重复
/// 物资系统与HRP对接夜间任务
/// 推送普通材料消耗任务以及库存请求任务
ClassMethod SendHRPInfo() As %String
{
	s st=+$H-1
	s et=+$H-1
	s:st'="" st=$zd(st,3)
	s:et'="" et=$zd(et,3)
	d ##class(web.DHCSTMService.HRP.Out2InServiceImpl).SendDispInfo(st,et)
	d ##class(web.DHCSTMService.HRP.Out2InServiceImpl).SendReqInfoTask(st,et)
	q

}
*/
/// Description:推送前一天的普通材料消耗和前一天库存请求单(与医为HRP系统对接)
/// Creator:    zx
/// CreateDate: 20210227
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).SendHRPTask()
ClassMethod SendHRPTask(HospId) As %String
{
	d ##class(web.DHCSTMHUI.ServiceForHRP).SendTask(HospId)
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 下载品规信息
/// Creator:    lxt
/// CreateDate: 20210719
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getSpecifications()
ClassMethod getSpecifications() As %String
{
	s StartDate=+$H-1
	s EndDate=+$H-1
	s StartDate=$zd(StartDate,3)_" "_"00:00:00"
	s EndDate=$zd(EndDate,3)_" "_"23:59:59"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getSpecifications",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getSpecifications("",StartDate, EndDate,"")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 下载供应商
/// Creator:    lxt
/// CreateDate: 20210719
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getSuppliers()
ClassMethod getSuppliers() As %String
{
	s StartDate=+$H-1
	s EndDate=+$H-1
	s StartDate=$zd(StartDate,3)_" "_"00:00:00"
	s EndDate=$zd(EndDate,3)_" "_"23:59:59"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getSuppliers",0)
	q:'$IsObject(CompiledObj) ""
	
	s HospStr=##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("APC_Vendor")
	i HospStr'="" d
	.s HospLen=$l(HospStr,"^")
	.f j=1:1:HospLen d
	..s HospId=$p(HospStr,"^",j)
	..d ##class(web.DHCSTMService.ECS.ECS2STMClient).getSuppliers("",StartDate, EndDate,HospId)
	e  d
	.d ##class(web.DHCSTMService.ECS.ECS2STMClient).getSuppliers("",StartDate, EndDate,"")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 下载生产厂家
/// Creator:    lxt
/// CreateDate: 20210719
/// description:
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getFactories()
ClassMethod getFactories() As %String
{
	s StartDate=+$H-1
	s EndDate=+$H-1
	s StartDate=$zd(StartDate,3)_" "_"00:00:00"
	s EndDate=$zd(EndDate,3)_" "_"23:59:59"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getFactories",0)
	q:'$IsObject(CompiledObj) ""
	
	s HospStr=##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("PH_Manufacturer")
	i HospStr'="" d
	.s HospLen=$l(HospStr,"^")
	.f j=1:1:HospLen d
	..s HospId=$p(HospStr,"^",j)
	..d ##class(web.DHCSTMService.ECS.ECS2STMClient).getFactories("",StartDate, EndDate,HospId)
	e  d
	.d ##class(web.DHCSTMService.ECS.ECS2STMClient).getFactories("",StartDate, EndDate,"")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 下载资质(注册证)及图片
/// Creator:    lxt
/// CreateDate: 20210719
/// description: OrgType(Vendor/Manf/Inci)
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getCertificates()
ClassMethod getCertificates(OrgType) As %String
{
	s StartDate=+$H-1
	s EndDate=+$H-1
	s StartDate=$zd(StartDate,3)_" "_"00:00:00"
	s EndDate=$zd(EndDate,3)_" "_"23:59:59"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getCertificates",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getCertificates("",StartDate, EndDate,OrgType,"")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 下载订单状态
/// Creator:    lxt
/// CreateDate: 20210719
/// description: 
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getOrdersState()
ClassMethod getOrdersState() As %String
{
	s StartDate=+$H-1
	s EndDate=+$H-1
	s StartDate=$zd(StartDate,3)_" "_"00:00:00"
	s EndDate=$zd(EndDate,3)_" "_"23:59:59"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getOrdersState",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getOrdersState("",StartDate, EndDate,"")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 上传消耗汇总
/// Creator:    lxt
/// CreateDate: 20210719
/// description: 
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getHvLabels()
ClassMethod getHvLabels() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getHvLabels",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getHvLabels("")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 上传停用汇总
/// Creator:    lxt
/// CreateDate: 20210719
/// description: 
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getHvReturnLabels()
ClassMethod getHvReturnLabels() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getHvReturnLabels",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getHvReturnLabels("")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 下载发票信息
/// Creator:    lxt
/// CreateDate: 20210719
/// description: 
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).getInvNos()
ClassMethod getInvNos() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"getInvNos",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).getInvNos("")
}

/// ECS供应链对接夜间任务
/// Description:ECS供应链, 心跳测试，每10分钟调用一次
/// Creator:    lxt
/// CreateDate: 20210719
/// description: 
/// Output:     
/// Return:		
/// d ##class(web.DHCSTMHUI.Tasks).ecstest()
ClassMethod ecstest() As %String
{
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCSTMService.ECS.ECS2STMClient"_"||"_"test",0)
	q:'$IsObject(CompiledObj) ""
	d ##class(web.DHCSTMService.ECS.ECS2STMClient).test("")
}

/// Description:出(退)库单自动接收
/// Creator:    wxj
/// CreateDate: 2022-02-18	
/// d ##class(web.DHCSTMHUI.Tasks).AutoTransInYes()
/// Remark:按制单日期计算,执行时间每天23:50
/// Type=1:自动接收一天前已审核单据
/// Type=2:自动接收两天前已审核单据
/// Type=3:每个月最后一天自动接收本月已审核单据
ClassMethod AutoTransInYes(Type = "1", User = "")
{
	n (Type,User)
	s StartDate="",EndDate=""
	if Type=1 d
	.s StartDate=+$h-2 ;防止有23:50后出库单据漏接收
	.s EndDate=+$h-1
	else  if Type=2 d
	.s StartDate=+$h-3
	.s EndDate=+$h-2
	else  if Type=3 d
	.s today=$zd(+$h,3)
	.s nextday=$zd(+$h+1,3)
	.s Year=+$p(today,"-",1)
	.s Mon=+$p(today,"-",2)
	.s NextYear=+$p(nextday,"-",1)
	.s NextMon=+$p(nextday,"-",2)
	.s:Year'=NextYear StartDate=$zdh(Year_"-"_Mon_"-"_"01",3),EndDate=$zdh(Year_"-"_Mon_"-"_"31",3)
	.s:(Year=NextYear)&&(Mon'=NextMon) StartDate=$zdh(Year_"-"_Mon_"-"_"01",3),EndDate=+$h
	q:StartDate="" ""
	q:EndDate="" ""
	i User="" d
	.&sql(select %id into :User from ss_user where SSUSR_Initials ="demo")	
	
	f date=StartDate:1:EndDate d
	.s Init=""
	.f  s Init=$o(^DHCINIT(0,"TrfDate",date,Init)) q:+Init=0  d
	..s Status=$p(^DHCINIT(Init),"^",14)
	..q:Status'="21"
	..s Type=$p(^DHCINIT(Init),"^",24)
	..q:Type'="M"
	..d ##class(web.DHCSTMHUI.DHCINIsTrf).jsTransInAuditYes(Init,User)
}

/// 自动汇总申领计划并生成最终的请求单
/// Author:zhwh
/// Date:2014-02-18
/// Arguments: void
/// Return:
///    已经汇总的科室数目
///    d ##class(web.DHCSTMHUI.INRequestTemplate).AutoSumReqPlan()
ClassMethod AutoSumReqPlan()
{
	new
	;任务挂在设置时间的当天,设置时间在23:58之前
	s grp=""
	s user=""
	s hosp=""
	s loc=""
	s str=grp_"^"_loc_"^"_user_"^"_hosp	
	s time=$p($h,",",2)
	s enddate=+$h
	s endtime=time
	
	s startdate=$p($SYSTEM.SQL.DATEADD("mm",-1,enddate)," ")
	s startdate=$zdh(startdate,3)
	s starttime=time+1
	s n=0
	&sql(declare x2 cursor for SELECT %id FROM ct_loc)
	&sql(open x2)
	f  &sql(fetch x2 into :loc)  q:SQLCODE  d
	.s ret=..LocReqPlan(loc,startdate,enddate,starttime,endtime)
	.s n=n+1

	&sql(close x2)
	q n
}

/// 汇总某科室一段时间内的申领计划单,并生成新的申领计划单。
/// 1) 申领计划单条件要求：
///  1.已审核(请求方)
///  2.尚未汇总过
///  3.必须是申领计划
///  4.必须是请求部门=供应部门(即申领计划)
///  5.申领计划的项目，必须设置供应科室(INC_Itm.INCI_CTLOC_DR)
///  
/// 2) 汇总生成后的申领计划单:
///  1."完成"状态
///  2."请求方已审核"状态
///  3.制单用户为空
///  4.制单日期为汇总日
///  
/// Author:zhwh
/// Date:2014-02-18
/// Arguments:
///   loc - 科室RowId
///   sd ,_起始日期
///   ed - 截止日期
///   
/// Return:
///   <0 - failure
///   0 - success
ClassMethod LocReqPlan(loc As %String, startdate As %String, enddate As %String, st As %String, et As %String) As %String
{
	n (loc,startdate,enddate,st,et)
	s RtnObj=##class(RtnObj).%New()
	s pid=..NewPid()
	k ^TMP("AutoSumReq",pid)
	s $ZT=..sssError() 
	s rowidStr=""
	
	;获取inrqi_remark字段最大长度,处理数据时判断,避免合并出现的超长
	s RemarkPropId="User.DHCINReqItm||INRQIRemark"
	try{
		s propObj=##class(%Dictionary.PropertyDefinition).%OpenId(RemarkPropId,0)
		s RemarkMaxLen=propObj.Parameters.GetAt("MAXLEN")
	}catch{}
	i +$g(RemarkMaxLen)<=0 s RemarkMaxLen=60
	k propObj
	
	s reqType="C"    //请求单类型
	s reclocAuditUser=""
	&sql(declare x1 cursor for select %id,inrq_time,inrq_date,INRQ_UserCompleted
		from in_request where inrq_date between :startdate and :enddate
			and inrq_recloc_dr=:loc and inrq_reqloc_dr=:loc)
	&sql(open x1)
	f  &sql(fetch x1 into :rowid,:reqTime,:reqDate,:comp) q:SQLCODE  d
	.q:comp'="Y"
	.s xtype="",auditUser="",autoSumed="",template="",auditDateProv=""
	.&sql(SELECT inrq_audituser_dr,inrq_autosum,inrq_type,inrq_template,INRQ_AuditDate,
			INRQ_AuditTime
		INTO :auditUser,:autoSumed,:xtype,:template,:auditDate,
			:auditTime
		FROM  dhc_inrequest WHERE INRQ_INRQ_DR=:rowid)
	.
	.q:reqType'=xtype
	.q:auditDate=""			//请求方未审核	
	.q:autoSumed="Y"		//已经审核
	.q:template="Y"			//请求单模板
	.//根据请求方审核日期,时间判断
	.i auditDate=startdate q:auditTime<st
	.i auditDate=enddate q:auditTime>et
	.
	.i reclocAuditUser="" s reclocAuditUser=auditUser
	.
	.i rowidStr="" s rowidStr=rowid
	.e  s rowidStr=rowidStr_"^"_rowid
	.s ch=0
	.f  s ch=$O(^INRQ(rowid,"RQI",ch)) q:ch=""  d
	..s data=^(ch)
	..
	..s inci=$p(data,"^",4)
	..s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	..s scg=$p(scgInfo,"^",5)  //类组
	..q:scg=""
	..s scgType=$p(scgInfo,"^",3)
	..q:scgType'=..sssCode()
	..s buom=$P(^INCI(inci,1),"^",10)
	..s qty=$p(data,"^",3)
	..s uom=$p(data,"^",5)
	..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	..s qty=qty*fac
	..
	..s inrqi=rowid_"||"_ch
	..s dhcInrqi=$o(^DHCINRQI(0,"INRQI",inrqi,0))
	..s remark=$s(dhcInrqi'="":$p($g(^DHCINRQI(dhcInrqi)),"^",2),1:"")
	..
	..s ProvLocInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(inci,loc)
	..s provloc=$p(ProvLocInfo,"^",1)
	..q:provloc=""
	..q:provloc=loc		;2015-08-28 供应仓库为申请科室的过滤,否则会多出一个原始申领计划单
	..
	..i $d(^TMP("AutoSumReq",pid,provloc,scg,inci)) d
	...s $p(^TMP("AutoSumReq",pid,provloc,scg,inci),"^",1)=$p(^TMP("AutoSumReq",pid,provloc,scg,inci),"^",1)+qty
	...i remark'="" d
	....s tmpRemark=$p(^TMP("AutoSumReq",pid,provloc,scg,inci),"^",4)_";"_remark
	....q:$l(tmpRemark)>=RemarkMaxLen		;长度控制
	....s $p(^TMP("AutoSumReq",pid,provloc,scg,inci),"^",4)=tmpRemark
	..e  d
	...s ^TMP("AutoSumReq",pid,provloc,scg,inci)=qty_"^"_uom_"^"_fac_"^"_remark
	..
	&sql(close x1)
	q:'$d(^TMP("AutoSumReq",pid)) 0
	
	s err=0
	ts
	s provloc=""
	f  s provloc=$O(^TMP("AutoSumReq",pid,provloc)) q:(provloc="")!(err<0)  d
	.s scg="" f  s scg=$o(^TMP("AutoSumReq",pid,provloc,scg)) q:(scg="")!(err<0)  d
	..s frLoc=provloc
	..s toLoc=loc
	..s user=""
	..
	..s m=frLoc_"^"_toLoc_"^"_user_"^"_scg_"^"_reqType
	..s t="SupLoc^ReqLoc^gUserId^ScgStk^ReqType"
	..s m=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(m,t)
	..s RtnObj=##class(web.DHCSTMHUI.INRequest).Update(m) //生成主表
	..i RtnObj.success'=0  s err=-1
	..q:err<0
	..s inrq=RtnObj.rowid
	..s inci=0
	..f  s inci=$o(^TMP("AutoSumReq",pid,provloc,scg,inci)) q:(inci="")!(err<0)  d
	...s SumReqData=^TMP("AutoSumReq",pid,provloc,scg,inci)
	...s qty=$p(SumReqData,"^",1)
	...s uom=$p(SumReqData,"^",2)
	...s fac=$p(SumReqData,"^",3)
	...s colremark=$p(SumReqData,"^",4)
	...s qty=qty/fac
	...s itmobj={}
	...s itmobj.Inci=inci
	...s itmobj.Uom=uom
	...s itmobj.Qty=qty
	...s itmobj.ReqRemarks=colremark
	...s itmobj.Scg=scg
	...s rows="["_itmobj.%ToJSON()_"]"
	...s RtnObj=##class(web.DHCSTMHUI.INReqItm).Save(inrq,rows)
	...i RtnObj.success'=0 s err=-2
	...q:err<0
	..
	..s com="Y"
	..&sql(update in_request set inrq_usercompleted=:com where %id=:inrq)		//自动设置完成
	..i SQLCODE'=0 s err=-4  
	..q:err<0 
	..s m=inrq_"^"_reclocAuditUser
	..s t="Req^gUserId"
	..s m=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(m,t)
	..s RtnObj=##class(web.DHCSTMHUI.INRequest).ReqSideAudit(m)	//请求方审核
	..i RtnObj.success'=0  s err=-1
	..q:err<0 
	..
	..s ret=##class(web.DHCSTMHUI.INRequest).SetDefaultQtyApproved(inrq)		//自动将"批准数量"设置为"请求数量"。
	..i ret<0 s err=-6
	..q:err<0
	
	i err<0 tro  q err
	k ^TMP("AutoSumReq",pid)
	s cnt=$l(rowidStr,"^")
	i cnt>0 d
	.f i=1:1:cnt q:err<0   d
	..s rowid=$p(rowidStr,"^",i)
	..s autosum="Y"
	..&sql(update dhc_inrequest set inrq_autosum=:autosum where inrq_inrq_dr=:rowid)
	..i SQLCODE'=0 s err=-3 q 
	..
	i err<0 tro  q err
	tc 
	
	q err
}

}
