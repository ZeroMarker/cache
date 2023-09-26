/// modified by ZY0299 修改任务内容
/// 此类直接覆盖更新
Class web.DHCEQ.BA.BUSJob Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 补采一段时间内的数据
/// d ##Class(web.DHCEQ.BA.BUSJob).Gather()
ClassMethod Gather()
{
	s (FindGRowID,sDate,eDate)=""
	Set rowid=""
	f  s rowid=$o(^DHCEQGather(rowid),-1)  q:rowid=0||(FindGRowID'="")  Do
	.s Datalist=$Get(^DHCEQGather(rowid))
	.q:$p(Datalist,"^",8)="Y"
	.q:$p(Datalist,"^",3)'=1	//0:"新增",1:"执行",2:"异常",3:"完成"
	.;q:$p(Datalist,"^",4)'=Type	//0:"补采记录",1:"正常任务记录"
	.s FindGRowID=rowid
	.s sDate=$p(Datalist,"^",1)
	.s eDate=$p(Datalist,"^",2)
	i FindGRowID="" q
	s Node="End"
	i '$Data(^DHCEQGatherList(0,"Version",FindGRowID,Node))
	{
		s GatherDate=sDate
	}
	else
	{
		s FirLastDate=$o(^DHCEQGatherList(0,"Version",FindGRowID,"DHC-HIS",""),-1)
		
		s LastDate=$o(^DHCEQGatherList(0,"Version",FindGRowID,Node,""),-1)
		i (FirLastDate'=LastDate) q
		i LastDate="" q
		s Version=$o(^DHCEQGatherList(0,"Version",FindGRowID,Node,LastDate,""),-1)
		i Version="" q
		s GLRowID=$o(^DHCEQGatherList(0,"Version",FindGRowID,Node,LastDate,Version,""),-1)
		i GLRowID="" q
		s GatherDate=LastDate+1
	}
	i GatherDate>eDate q
	//  晚上11点($ZT(82799,1)=22:59:59)之后挂起三个小时(60*60*3)=10800
	;s CurTime=$ZT($p($H,",",2),1)
	;if ((CurTime>82799)||(CurTime<7200)||((CurTime>21600)&&(CurTime<7200))) q
	//s ^DHCEQLog("Job","Gather",GatherDate,FindGRowID,$H)=""
	d ##Class(web.DHCEQ.BA.BUSJob).GatherData(GatherDate,FindGRowID)
}

/// 设备使用信息采集，一般每天凌晨采集前一天的数据
/// d ##Class(web.DHCEQ.BA.BUSJob).GatherData()
/// d ##Class(web.DHCEQ.BA.BUSJob).GatherData(65379,1)
ClassMethod GatherData(Date As %String = "", GRowID As %String = "")
{
	i Date="" d
	.s Date=$H
	.s GatherDate=+$H-1
	e  d
	.s GatherDate=Date
	//s Node="GatherData"
	//s Result=""
	//s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	s tmpDate=$ZD(GatherDate,3)
 	i GRowID="" d
	.s GatherInfo=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d GatherInfo.%Set("GRowID",GRowID)
	.d GatherInfo.%Set("GStartDate",tmpDate)
	.d GatherInfo.%Set("GEndDate",tmpDate)
	.d GatherInfo.%Set("GStatus",3)
	.d GatherInfo.%Set("GType",0)
 	.s GatherInfo=GatherInfo.%ToJSON()
	.s GatherInfo=##class(web.DHCEQ.BA.BUSGather).SaveData(GatherInfo,0)
	.s GatherInfo=##class(web.DHCEQ.Plat.LIBCommon).StringToJson(GatherInfo)	// modified by ZY0307 发现的bug
	.s SQLCODE=GatherInfo.SQLCODE
	.i SQLCODE=0 s GRowID=GatherInfo.Data
	if GRowID'=""
	{
		s eBeginTime=$H
		d ##Class(web.DHCEQ.BA.BUSGather).GatherDHCHISNew(GatherDate,"",GRowID)
		s LISVersion=+##class(web.DHCEQCommon).GetSysInfo("992001")
		if (LISVersion=0)
		{
			d ##Class(web.DHCEQIUsedRecord).GatherDHCLIS(GatherDate)
		}
		elseif (LISVersion=1)
		{
			d ##Class(web.DHCEQ.BA.BUSGather).GatherDHCLISNew(GatherDate,"",GRowID)	
		}
		elseif (LISVersion=9)
		{
			d ##class(web.DHCEQ.BA.BUSUseRecordQueue).GatherDataToIUseRcordQueue(GatherDate,"LIS")
			d ##Class(web.DHCEQ.BA.BUSGather).GatherThirdParty(GatherDate,"LIS","",GRowID)
		}
		s RISVersion=+##class(web.DHCEQCommon).GetSysInfo("992002")
		if (RISVersion=0)
		{
			d ##Class(web.DHCEQIUsedRecord).GatherDHCRIS(GatherDate)
		}
		elseif (RISVersion=1)
		{
			d ##Class(web.DHCEQ.BA.BUSGather).GatherDHCRISNew(GatherDate,"",GRowID)	
		}
		elseif (RISVersion=9)
		{
			d ##class(web.DHCEQ.BA.BUSUseRecordQueue).GatherDataToIUseRcordQueue(GatherDate,"RIS")
			d ##Class(web.DHCEQ.BA.BUSGather).GatherThirdParty(GatherDate,"RIS","",GRowID)
		}
		i 1=##Class(web.DHCEQReport).IsLastReportDate(GatherDate)
		{
			s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(GatherDate)
			d ##class(web.DHCEQ.BA.BUSUseRecordStat).GatherUseRecordStat(MonthStr)
			d ##Class(web.DHCEQ.BA.BUSUseContext).AutoCreateUseContext(MonthStr,"")
		}
		
		;记录采集结果开始结束时间
		s eEndTime=$H
		s Node="End"
		s Version=$o(^DHCEQGatherList(0,"Version",GRowID,Node,GatherDate,""),-1)
		s Version=1+Version
		s GatherListInfo=##class(web.DHCEQ.Plat.JsonObject).%New() 
		d GatherListInfo.%Set("GLGatherDR",GRowID)
		d GatherListInfo.%Set("GLExType",Node)
		d GatherListInfo.%Set("GLUseDate",##class(web.DHCEQCommon).TransValueToPage(GatherDate,"date"))
		d GatherListInfo.%Set("GLBeginTime",##class(web.DHCEQCommon).TransValueToPage($p(eBeginTime,",",2),"time"))
		d GatherListInfo.%Set("GLEndTime",##class(web.DHCEQCommon).TransValueToPage($p(eEndTime,",",2),"time"))
		d GatherListInfo.%Set("GLStatus",0)
		d GatherListInfo.%Set("GLVersion",Version)
	 	s GatherListInfo=GatherListInfo.%ToJSON()
		s GatherInfo=##class(web.DHCEQ.BA.BUSGather).SaveDataList(GatherListInfo)
	}
}

/// 每月定期汇总使用记录、消耗记录 生成月使用记录汇总及月消耗汇总
/// d ##Class(web.DHCEQ.BA.BUSJob).GetUseRecordStat()
ClassMethod GetUseRecordStat()
{
	s Date=$H
	s Node="UseRecordStat"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;获取当前日期所属会计周期的上月数据)
	s vDate=+Date-1
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(vDate)
	s Result= ##class(web.DHCEQ.BA.BUSUseRecordStat).GatherUseRecordStat(MonthStr)
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// add by ZY0237
/// 每月定期汇总使用记录、消耗记录 生成月使用记录汇总及月消耗汇总
/// d ##Class(web.DHCEQ.BA.BUSJob).GetUseRecordStat()
ClassMethod AutoGetUseContext()
{
	s Date=$H
	s Node="UseContext"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;获取当前日期所属会计周期的上月数据
	s vDate=+Date-1
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(vDate)
	s Result= ##Class(web.DHCEQ.BA.BUSUseContext).AutoCreateUseContext(MonthStr,"")
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// Add by JDL 2010-11-09  JDL0057
/// 根据月消耗的消耗项目量，来倒推各个项目的消耗,并生成使用记录消耗项目
/// 可以定义在每月初 凌晨执行，来推算上月项目消耗。
/// d ##Class(web.DHCEQ.BA.BUSJob).GenUsedConsumableItem()
ClassMethod GenUsedConsumableItem()
{
	s GenYear=$p($zd(+$H,3),"-",1)
	s GenMonth=$p($zd(+$H,3),"-",2)
	i ((+GenMonth)="1")
	{
		s GenYear=GenYear-1
		s GenMonth="12"
	}
	else
	{
		s GenMonth=GenMonth-1
	}
	d ##Class(web.DHCEQIUsedRecord).GenUsedConsumableItem(GenYear,GenMonth)
}

/// Add by JDL 2010-12-23
/// 根据设备月度消耗资源定义，生成设备当月资源消耗
/// 可以定义在每月初 凌晨执行，生成设备当月资源消耗
/// d ##Class(web.DHCEQ.BA.BUSJob).AutoCreateUsedResource()
ClassMethod AutoCreateUsedResource()
{
	d ##class(web.DHCEQUsedResource).AutoCreateUsedResource()
}

/// add by zy 20141117 ZY0117
/// 定期采集设备对照消耗项目，一般是一个月
/// d ##Class(web.DHCEQ.BA.BUSJob).GatherDHCSTNew()
ClassMethod AutoCreateUseConsumableItem()
{
	s Date=$H
	
	s Node="UseConsumableItem"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;获取当前日期所属会计周期的上月数据
	s vDate=+Date-1
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(vDate)
	//s MonthStr=$e($ZD(vDate,3),1,7)
	s Result=##Class(web.DHCEQIUsedRecord).SaveUseConsumableItem("DHC-ST",MonthStr)
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

}
