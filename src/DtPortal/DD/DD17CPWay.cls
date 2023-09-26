/// ClassName:    DtPortal.DD.DD17CPWay
/// Description:  临床科主任临床路径服务
/// Creator：     chengpeng
/// CreatDate:    2015-12-8
Class DtPortal.DD.DD17CPWay Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description	:	DD17.01.01 查询科室当前开展路径数量
/// Input		:	UserCode
/// Return		:	num  临床路径的数量
/// set a= ##class(DtPortal.DD.DD17CPWay).getLocCPWayNum("601")
ClassMethod DD170101(locGroupId) As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret=##class(DtPortal.OutPut).%New()
	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
	if DocLoc=""{
	Set ret.status = -2
	Set ret.errMSG = "用户不是科主任!"
	Set ret.data = ""
	Quit:DocLoc="" ret
	}
	Set $zt="ERRDD170101"
	
	set inCPWNub=0
	for locIndex=1:1:$l(DocLoc,"^")
	{
		set locID=$p(DocLoc,"^",locIndex)
		continue:locID=""
		
		set admStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc",UserCode,locID)
		
		for admIndex=1:1:$l(admStr,"^")
		{
			set EpisodeID=$p(admStr,"^",admIndex)
			
			set isCPW=##class(DHCMA.CPW.IO.ToPortal).CheckCPWStatus(EpisodeID,"I",0) 
			continue:isCPW=""
			
			set inCPWNub=+inCPWNub+1
		}
		
	}
	
	Set ret.status=1
	Set ret.errMSG=""
	Set ret.data=inCPWNub
	Quit ret
	
ERRDD170101
	TRollBack
	Set ret.status=-1
	Set ret.errMSG=$ZE
	Set ret.data="Null"
	Quit ret
}

/// Description	:	DD17.01.03 查询科室各临床路径开展人数、完成人数和覆盖率
/// Input		:	userCode  用户工号
/// Input		:	yearMonth 年月
/// Return		:	月份代号:月份名称:完成路径人数:变异率
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.DD.DD17CPWay","GetCPWayMouth","601","2017-02",1)
Query DD170103(StarDate As %String, EndDate As %String, locGroupId As %String) As DtPortal.Query(ROWSPEC = "ind,CPWDesc,InWay,OutWay,DischgPatNub,CompleteRadio,OutRatio")
{
}

ClassMethod DD170103Execute(ByRef qHandle As %Binary, StarDate As %String, EndDate As %String, locGroupId As %String) As %Status
{

	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
	Quit:DocLoc="" $$$OK
	
	k ^||TMPPortalMD170103
	set DocLoc="^"_DocLoc_"^"
	set StarDate=$p(StarDate,"-",1)_"-"_$p(StarDate,"-",2)
	set EndDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)
	
	set NowDate=$zd(+$h,3)
	set NowMonth=$p(NowDate,"-",1)_"-"_$p(NowDate,"-",2)
	
	s dateType="byMonth"	
	s filterRule=""
	s mode="H"
	s contract=""
	set:StarDate=NowMonth dateType="currentMonth"			//可以查询当月数据
	
	set DischgPatNub=0
	//出院人数
	s kpiRule="SK0140:PatLoc"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StarDate,EndDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit

		set locID=rs.Data("dimIdCol1")
		set aLocID="^"_locID_"^"
		continue:DocLoc'[aLocID
		set value=rs.Data("kpiValueCol1")
		
		set DischgPatNub=+DischgPatNub+value
	 	
	}
	
	//临床路径开展人数,临床路径完成人数
	s kpiRule="DtPortal0006,DtPortal0007"
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StarDate,EndDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit

		set locID=rs.Data("dimIdCol1")
		set aLocID="^"_locID_"^"
		continue:DocLoc'[aLocID
		set CPWDesc=rs.Data("dimIdCol2")
	

		set value1=rs.Data("kpiValueCol1")		//开展人数
		set value2=rs.Data("kpiValueCol2")		//完成人数
		
		set ^||TMPPortalMD170103(CPWDesc,"Develop")=+$g(^||TMPPortalMD170103(CPWDesc,"Develop"))+value1
		set ^||TMPPortalMD170103(CPWDesc,"Complete")=+$g(^||TMPPortalMD170103(CPWDesc,"Complete"))+value2
	 	
	}
	
	
		
	set CPWDesc=""
	for
	{
		set CPWDesc=$o(^||TMPPortalMD170103(CPWDesc))
		quit:CPWDesc=""
		
		set InWay=+$g(^||TMPPortalMD170103(CPWDesc,"Develop"))		//开展人数
		set OutWay=+$g(^||TMPPortalMD170103(CPWDesc,"Complete"))		//完成人数
		
		set CompleteRadio=0,OutRatio=0
		set:+InWay'=0 CompleteRadio=$fn(OutWay/InWay*100,"",2)			//完成率
		set:+DischgPatNub'=0 OutRatio=$fn(OutWay/DischgPatNub*100,"",2)						//出院病人覆盖率
		
		set CompleteRadio=CompleteRadio_"%"
		set OutRatio=OutRatio_"%"
		
		Set Data=$lb(ind,CPWDesc,InWay,OutWay,DischgPatNub,CompleteRadio,OutRatio)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	
	k ^||TMPPortalMD170103
	
	Quit $$$OK
}

}
