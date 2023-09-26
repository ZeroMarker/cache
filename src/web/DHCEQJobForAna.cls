/// add by zy 2013-05-29 ZY0107
Class web.DHCEQJobForAna Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 设备使用信息采集，一般每天凌晨采集前一天的数据
ClassMethod GatherData()
{
	s Date=$H
	s Node="GatherData"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	s GatherDate=+$H-1
	s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCHIS(GatherDate)	
	s ^DHCEQLog("Job",Node,Date,"Result","His")=Result
	///modified by ZY0200 增加采购数据的接口版本系统参数控制
	s LISVersion=##class(web.DHCEQCommon).GetSysInfo("992001")
	if (LISVersion=0)
	{
		s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCLIS(GatherDate)
	}
	elseif (LISVersion=1)
	{
		s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCLISNew(GatherDate)	
	}
	elseif (LISVersion=9)
	{
		s Result=##Class(web.DHCEQIUsedRecord).GatherPacs(GatherDate,"Lis")
	}
	s ^DHCEQLog("Job",Node,Date,"Result","Lis")=Result
	s RISVersion=##class(web.DHCEQCommon).GetSysInfo("992002")
	if (RISVersion=0)
	{
		s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCRIS(GatherDate)
	}
	elseif (RISVersion=1)
	{
		s Result= ##Class(web.DHCEQIUsedRecord).GatherDHCRISNew(GatherDate)	
	}
	elseif (RISVersion=9)
	{
		s Result=##Class(web.DHCEQIUsedRecord).GatherPacs(GatherDate,"Ris")
	}
	s ^DHCEQLog("Job",Node,Date,"Result","Ris")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// Add by JDL 2010-11-09  JDL0057
/// 根据月消耗的消耗项目量，来倒推各个项目的消耗,并生成使用记录消耗项目
/// 可以定义在每月初 凌晨执行，来推算上月项目消耗。
/// d ##Class(web.DHCEQJob).GenUsedConsumableItem()
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
ClassMethod AutoCreateUsedResource()
{
	d ##class(web.DHCEQUsedResource).AutoCreateUsedResource()
}

/// 每月定期汇总使用记录、消耗记录 生成月使用记录汇总及月消耗汇总
/// d ##Class(web.DHCEQJobForAna).GetUseRecordStat()
ClassMethod GetUseRecordStat()
{
	s Date=$H
	s Node="UseRecordStat"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;获取当前日期所属会计周期的上月数据
	s vDate=+Date-1
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(vDate)
	s Result= ##class(web.DHCEQUseRecordStat).GatherUseRecordStat(MonthStr)
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// add by zy 2011-11-11 ZY0085 地坛锐珂Pacs	每天凌晨，在GatherData之前执行
ClassMethod GatherDataFromSoap(Date)
{
	d ##Class(web.DHCEQIUseRecord).ExecSoap(Date)
}

/// add by zy 20141117 ZY0117
/// 定期采集设备对照消耗项目，一般是一个月
/// d ##Class(web.DHCEQJobForAna).GatherDHCSTNew()
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

/// add by ZY0208 
/// 每月定期汇总使用记录、消耗记录 生成月使用记录汇总及月消耗汇总
/// d ##Class(web.DHCEQJobForAna).GetUseRecordStat()
ClassMethod AutoGetUseContext()
{
	s Date=$H
	s Node="UseContext"
	s Result=""
	s ^DHCEQLog("Job",Node,Date,"Begin")=$H
	;获取当前日期所属会计周期的上月数据
	s vDate=+Date-1
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(vDate)
	s Result= ##class(web.DHCEQUseContext).GatherUseContext(MonthStr)
	s ^DHCEQLog("Job",Node,Date,"Result")=Result
	s ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// Add By DJ 2017-07-21
/// 描述：龙岩二院采集卡易RIS效益分析数据到中间表
/// d ##class(web.DHCEQJobForAna).GatherDataToIUseRcordQueue()
ClassMethod GatherDataToIUseRcordQueue()
{
	s Date=$ZD(+$H-1,3)
	s objService=##class(web.DHCEQ.Interface.Outer.HistorySearchWebServiceSoap).%New()
	s objDataSet=objService.DHCEQIUseRecordQueue(Date,Date)
	
	s reader = ##class(%XML.Reader).%New()
	s sc=reader.OpenStream(objDataSet)
	d reader.Correlate("DHC_EQIUseRecordQueue","web.DHCEQ.Interface.OuterTableProperty.DHCEQIUseRecordQueueProperty")
	s CurErrorID=+$o(^DHCEQLog("Job","GatherKYData",$H,"Result",0))
	while(reader.Next(.object,.sc))
	{
		s URQExType=object.URQExType
		s URQExDeviceID=object.URQExDeviceID
		s URQExItemID=object.URQExItemID
		s URQExBussID=object.URQExBussID
		s URQExUseLocID=object.URQExUseLocID
		s URQUseDate=object.URQUseDate
		s URQWorkLoadNum=object.URQWorkLoadNum
		s URQPrice=object.URQPrice
		s URQTotalFee=object.URQTotalFee
		s URQPatientInfo=object.URQPatientInfo
		s URQStartDate=object.URQStartDate
		s URQStartTime=object.URQStartTime
		s URQEndDate=object.URQEndDate
		s URQEndTime=object.URQEndTime
		s URQRemark=object.URQRemark
		s URQPositiveFlag=object.URQPositiveFlag
		s URQPatientAge=object.URQPatientAge
		s URQPatientSex=object.URQPatientSex
		s URQRemark=""
		i URQExType="KY-RIS"
		{
			s URQExBussID=##Class(web.DHCEQCommon).Replace(URQExBussID,"_","||")
			s URQExItemID=$p(^OEORD($p(URQExBussID,"||",1),"I",$p(URQExBussID,"||",2),1),"^",2)		//HIS遗嘱ID获取医嘱项ID
		}
		s ListInfo=URQExType_"^"_URQExDeviceID_"^"_URQExItemID_"^"_URQExBussID_"^"_URQExUseLocID_"^"_URQUseDate_"^"_URQWorkLoadNum_"^"_URQPrice_"^"_URQTotalFee_"^"_URQPatientInfo_"^"_URQStartDate_"^"_URQStartTime_"^"_URQEndDate_"^"_URQEndTime_"^"_URQRemark_"^"_URQPositiveFlag_"^"_URQPatientAge_"^"_URQPatientSex
		s SQLCODE=##Class(web.DHCEQIUseRecordQueue).SaveData("",ListInfo,"0")
		i SQLCODE	//采集记录失败
		{
			s CurErrorID=CurErrorID+1
			s ^DHCEQLog("Job","GatherKYData",$H,"Result",CurErrorID)=SQLCODE_"@"_ListInfo			
		}
	}
}

}
