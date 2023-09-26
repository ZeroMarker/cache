Class DtPortal.NH.NH19AcrimTotal Extends %RegisteredObject
{

/// 名称: DtPortal.NH.NH19AcrimTotal
/// 描述: 获取当日所有维护医嘱数量
/// 编写者：程鹏
/// 编写日期:2018-11-30
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH19AcrimTotal","NH190101","1",1,"demo")
Query NH190101(WardId As %String, Type As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "Desc,PatNum,Code,OEOrdItemIDStr") [ SqlProc ]
{
}

ClassMethod NH190101Execute(ByRef qHandle As %Binary, WardId As %String, Type As %String, UserCode As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:WardId="" $$$OK
	quit:Type="" $$$OK
	
	k ^||TMPPortalNH190101
	
	set ArcimfilterStr=""
	//取特殊的医嘱,根据医嘱项ID串过滤,医嘱项目维护在his portal配置中的医嘱配置
	if Type=1
	{
		//取所有医嘱配置中选中在病区显示的医嘱项目
    	s ArcimIDStr=##Class(DtPortal.Configure.arcim).getArcImIDByType(1,1)
		set ArcimfilterStr="^"_ArcimIDStr_"^"
	
	//取特殊的医嘱频次,根据频次Code串过滤,频次code维护在 his portal配置中的数据规则配置中,在特殊医嘱频次项目中配置
	}elseif Type=2
	{
		//取数据规则配置中配置的特殊频次code
		set frequency=##Class(DtPortal.Common.PublicService).getValueByCode("SPECIALFREQUENCY")
		set ArcimfilterStr="^"_frequency_"^"
		
	//取特殊的医嘱用法,根据用法ID串过滤,用法ID维护在 his portal配置中的数据规则配置中,在特殊医嘱用法项目中配置	
	}elseif Type=3
	{
		//取数据规则配置中配置的特殊医嘱用法ID
		set usage=##Class(DtPortal.Common.PublicService).getValueByCode("ARCIMUSAGE")
		set ArcimfilterStr="^"_usage_"^"
	}
	
	Set admIdStr=""
	Set admIdStr=##class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",WardId)
	quit:admIdStr="" $$$OK
	
	Set inNNum=$l(admIdStr,"^")
	for index=1:1:inNNum
	{
		set EpisodeId=$p(admIdStr,"^",index)
		set ord=$o(^OEORD(0,"Adm",EpisodeId,""))
 		continue:ord=""
 		
 		set ordSttTime="" 
 		for
 		{
	 		set ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) 
	 		quit:ordSttTime=""
	 		
	 		set OrdSub=""
	 		for
	 		{
		 		set OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub))
		 		quit:OrdSub=""
		 		
		 		set OEOrdItemID=ord_"||"_OrdSub
		 		//类型为2时,过滤频次
		 		if Type=2
		 		{
			 		//医嘱频次
			 		set PHFreqID=$p($g(^OEORD(ord,"I",OrdSub,2)),"^",4)
			 		continue:PHFreqID=""
			 		
			 		set PHFreqCode=$p(^PHCFR(PHFreqID),"^",1)
			 		set PHFreqCode=$$ALPHAUP^SSUTIL4(PHFreqCode)
			 		set PHFreqCodeStr="^"_PHFreqCode_"^"
			 		set ArcimfilterStr=$ZCONVERT(ArcimfilterStr,"U")
			 		continue:ArcimfilterStr'[PHFreqCodeStr
			 		set PHFreqDesc=$p(^PHCFR(PHFreqID),"^",4)
			 		
			 		if '$d(^||TMPPortalNH190101(PHFreqCode,"OEOrdItem",OEOrdItemID))
					{
						set ^||TMPPortalNH190101(PHFreqCode,"Desc")=PHFreqDesc
						set ^||TMPPortalNH190101(PHFreqCode,"OEOrdItem",OEOrdItemID)=""
						set ^||TMPPortalNH190101(PHFreqCode,"PatNum")=$g(^||TMPPortalNH190101(PHFreqCode,"PatNum"))+1
					}
					continue
			 	}
			 	
			 	//类型为3时,过滤用法
			 	if Type=3
		 		{
			 		//医嘱用法
			 		set usageID=$p($g(^OEORD(ord,"I",OrdSub,2)),"^",7)
			 		continue:usageID=""
			 		
			 		set usageIDStr="^"_usageID_"^"
			 		continue:ArcimfilterStr'[usageIDStr
			 		
			 		set desc=$p(^PHCIN(usageID),"^",2)
			 		if '$d(^||TMPPortalNH190101(usageID,"OEOrdItem",OEOrdItemID))
					{
						set ^||TMPPortalNH190101(usageID,"Desc")=desc
						set ^||TMPPortalNH190101(usageID,"OEOrdItem",OEOrdItemID)=""
						set ^||TMPPortalNH190101(usageID,"PatNum")=$g(^||TMPPortalNH190101(usageID,"PatNum"))+1
					}
					continue
			 	}
			 	
			 	//只有查询医嘱项的时候循环
			 	continue:Type'=1
		 		set OreSub=""
		 		for
		 		{	
		 			
			 		set OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub))
			 		quit:OreSub=""
			 		
				 	//类型为1时,过滤医嘱项
				 	if Type=1
			 		{
				 		set ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
						set ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
						continue:(ordStat'="V")&(ordStat'="E") 
						set ArcRowId=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
						set ArcRowIdsS="^"_ArcRowId_"^"
						continue:ArcimfilterStr'[ArcRowIdsS
						
						set ArcPzCodeStr=..getArcCode(ArcRowId)
						for indexCode=1:1:$l(ArcPzCodeStr,"^")
						{
							set ArcPzCode=$p(ArcPzCodeStr,"^",indexCode)
							set arcPzID=$o(^DtPortal.Configure.ArcimI("ArcimCodeIndex"," "_ArcPzCode,""))
							set arcObj=##class(DtPortal.Configure.arcim).GetObjById(arcPzID)
							continue:'$IsObject(arcObj)
							set ArcimDesc=arcObj.ArcimDesc
							if '$d(^||TMPPortalNH190101(ArcPzCode,"OEOrdItem",OEOrdItemID))
							{
								set ^||TMPPortalNH190101(ArcPzCode,"Desc")=ArcimDesc
								set ^||TMPPortalNH190101(ArcPzCode,"OEOrdItem",OEOrdItemID)=""
								set ^||TMPPortalNH190101(ArcPzCode,"PatNum")=$g(^||TMPPortalNH190101(ArcPzCode,"PatNum"))+1
							}
						}
						q
				 	}	
			 	}
		 	}
	 	} 	
	}
	
	set Code=""
	for
	{
		set Code=$o(^||TMPPortalNH190101(Code))
		quit:Code=""
		
		set Desc=$g(^||TMPPortalNH190101(Code,"Desc"))
		set PatNum=$g(^||TMPPortalNH190101(Code,"PatNum"))
		set OEOrdItemIDStr=""
		set OEOrdItemID=""
		for
		{
			set OEOrdItemID=$o(^||TMPPortalNH190101(Code,"OEOrdItem",OEOrdItemID))
			quit:OEOrdItemID=""
			set:OEOrdItemIDStr'="" OEOrdItemIDStr=OEOrdItemIDStr_"^"_OEOrdItemID
			set:OEOrdItemIDStr="" OEOrdItemIDStr=OEOrdItemID
		}
		
		set ^||CacheTemp(repid,ind)=$lb(Desc,PatNum,Code,OEOrdItemIDStr)
 		set ind=ind+1  
	}
 	
 	k ^||TMPPortalNH190101
	Quit $$$OK
}

/// 名称: DtPortal.NH.NH19AcrimTotal
/// CreatDate： 2016-07-18
/// Description: 查询护士长下了某些特殊医嘱的患者详情
/// Input：  OEOrdItemIDStr 医嘱子表ID串,以^分割
/// Return： 
/// 服务代码 NH19.01.02
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH19AcrimTotal","NH190102","262||34^262||38")
Query NH190102(OEOrdItemIDStr As %String) As DtPortal.Query(ROWSPEC = "bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inTime,locDesc,ArcImDesc")
{
}

ClassMethod NH190102Execute(ByRef qHandle As %Binary, OEOrdItemIDStr As %String, Type As %String, Code As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:OEOrdItemIDStr="" $$$OK

	Set OrdNum=$l(OEOrdItemIDStr,"^")
	for i=1:1:OrdNum
	{
		set OEOrdItemID=$p(OEOrdItemIDStr,"^",i)
		continue:OEOrdItemID=""
		set ord=$p(OEOrdItemID,"||",1)
		set OrdSub=$p(OEOrdItemID,"||",2)
		set EpisodeId=$p($g(^OEORD(ord)),"^",1)
		continue:EpisodeId=""
		
		set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
	 	set bedCode=$p(patInfoStr,"^",1)
	 	set name=$p(patInfoStr,"^",2)
	 	set sex=$p(patInfoStr,"^",3)
	 	set age=$p(patInfoStr,"^",4)
	 	set medicareNo=$p(patInfoStr,"^",5)   //病案号
	 	set admReason=$p(patInfoStr,"^",6)    //费用类型
	 	set regNo=$p(patInfoStr,"^",7)    //登记号
	 	set locDesc=$p(patInfoStr,"^",9)  
		set docDesc=$p(patInfoStr,"^",11)
		set nurseDesc=$p(patInfoStr,"^",12)
		set diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
		set inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
	    set inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)	//入院时间
	    set inDate=$p(inTimeStr,"^",1)
	    set inTime=$p(inTimeStr,"^",2)
	    set inDate=$zd(inDate,3)
	    set inTime=$zt(inTime,2)
	    set inTime=inDate_"&nbsp;"_inTime
	    
	    set ArcimID=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
		set ArcImDesc=$p(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),1),"^",2)		//医嘱描述
	    
	    set Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inTime,locDesc,ArcImDesc)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	    
	}
  	q $$$OK
}

/// Creator：     chengpeng
/// CreatDate：   2017-05-16
/// Description:  获取医嘱配置code
/// Table：       DtPortal_Configure.arcimItem
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DtPortal.NH.NH19AcrimTotal).getArcCode("10076||1")
ClassMethod getArcCode(ArcRowIds) As %String
{
	Set return=""
	
	set arcPzID=""
	for
	{
		set arcPzID=$o(^DtPortal.Configure.ArcimI("Item","IndexItmMastID",ArcRowIds,arcPzID))
		quit:arcPzID=""
		
		set arcimStr=$g(^DtPortal.Configure.ArcimD(arcPzID))
 		set ArcimCode=$li(arcimStr,2)
 		set ArcimIsActive=$li(arcimStr,4)
 		set ArcimIsShowWard=$li(arcimStr,7)
 		set ArcimIsToItmMast=$li(arcimStr,10)
 		continue:ArcimIsActive'="Y"
 		continue:ArcimIsToItmMast'="Y"
 		continue:ArcimIsShowWard'="Y"
 		set:return'="" return=return_"^"_ArcimCode
 		set:return="" return=ArcimCode
	}
	
	Quit return
}

}
