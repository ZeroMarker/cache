Class EPRservice.tool.EPRStructMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 	检查某段时间内写过的病历中，哪些PrintDocID被删除了，
/// 		并将其记录临时Global中
/// Input: 	argStDate 开始日期，格式 2009-10-1
/// 		argEndDate 结束日期，格式 2010-9-9
/// Ouput: 	无
/// Debug: 	w ##class(EPRservice.tool.EPRStructMgr).GetMissedStructID("2008-9-1","2010-10-10")
ClassMethod GetMissedStructID(argStDate As %String, argEndDate As %String)
{
	w "开始检查",!
	
	s stDate = $zdh(argStDate,3)
	s endDate = $zdh(argEndDate,3)
	
	d ..ClearTempDocID()
	
	for date = stDate:1:endDate
	{
		s admId = ""
		for {
			s admId = $O(^PAADMi("PAADM_AdmDate",date,admId))
			q:(admId="")
			
			//只检查入院病人
			s type = $p($g(^PAADM(admId)),"^",2)
			continue:(type'="I")
			
			d ..GetByAdmId(admId)
		}
	}
	
	w "检查结束",!,!
	s count = $g(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr","Count"))
	w "丢失的PrintDocID共有: "_(+count),!
	w "详细信息参见Global: ^CacheTempDHCEPR("_$C(34)_"EPRservice.tool.EPRStructMgr"_$c(34)_","_$c(34)_"Count"_$c(34)_")",!
}

ClassMethod GetByAdmId(admId As %String)
{
	w ..GetPatientInfo(admId),!
	
	s docId = ""
	for {
		s docId = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_admId,docId))
		q:(docId="")
		
		s pureDocId = $e(docId, 2,$l(docId))
		s isExist = ..IsPrintDocIDExist(pureDocId)
		if isExist="0"
		{
			w "发现丢失的PrintDocID: "_pureDocId,!
			d ..SetTempDocID(pureDocId,admId)
		}
	}
}

ClassMethod IsPrintDocIDExist(docId As %String) As %String
{
	q:($d(^DHCEPRM.EPRTemplateCategoryD(docId))=0) "0"
	q:($d(^DHCEPRM.EPRTemplateCategoryD(docId))=10) "0"
	q "1"
}

ClassMethod SetTempDocID(docId As %String, admId As %String)
{
	if $d(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr",docId))=0
	{
		s ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr",docId)=admId	
		s count = $g(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr","Count"))
		s ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr","Count") = count + 1
	}
}

ClassMethod ClearTempDocID()
{
	k ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr")
}

ClassMethod GetPatientInfo(admId As %String)
{
	s papmiDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(admId)
	s papmiNo = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDR)
	s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(papmiDR)
	//s sex = ##class(EPRservice.HISInterface.PatientInfoAssist).Gender(papmiDR)
	//s sex = $P(sex,"^",3)
	
	s retVal = "病人信息: {姓名: "_name_"},{登记号:"_papmiNo_"},{EpisodeID:"_admId_"}"
	q retVal
}

/// Debug: w ##class(EPRservice.tool.EPRStructMgr).GetMissedChartByAdm("201764")
ClassMethod GetMissedChartByAdm(argEpisodeID As %String)
{
	d ..ClearTempChartID()
	
	s tmpcount = 0
	
	w ..GetPatientInfo(argEpisodeID),!
	
	s blankEId = " "_argEpisodeID
	s chartId = ""
	for {
		s chartId = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", blankEId, chartId))
		q:(chartId = "")
		
		s realChartId = $e(chartId, 2, $L(chartId))
		s isExisted = ..IsChartExisted(chartId)
		if ('isExisted)
		{
			s tmpcount = tmpcount + 1
			w !, tmpcount
			w "发现丢失的ChartItemID: "_realChartId,!
			d ..SetTempChartID(realChartId,argEpisodeID,"1")
			continue
		}
		
		s ecRecordId = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", blankEId, chartId, ""))
		continue:(ecRecordId = "")
		
		s childSub = ""
		for {
			s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord", ecRecordId, childSub))
			q:(childSub = "")
			
			s instanceId = ecRecordId_"||"_childSub
			
			s obj = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
			continue:(obj = "")
			
			if ((obj.Status = "")||(obj.Status = "UnSave"))&&(obj.Log.Count() > 0)
			{
				s tmpcount = tmpcount + 1
				w !, "hah"_tmpcount
				w "发现被清空的病历: "_instanceId,!
				d ..SetTempChartID(instanceId,argEpisodeID,"2")
				continue
			}
		}
	}
	
	
	w "检查结束,结果如下:",!
	w "-----------------",!
	s count = $g(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedChart","ErrorCount"))
	w "丢失的ChartID共有: "_(+count),!
	w "详细信息参见Global: ^CacheTempDHCEPR("_$C(34)_"EPRservice.tool.EPRStructMgr.ChartID"_$c(34)_","_$c(34)_"MissedChart"_$c(34)_")",!
    w !
	s count = $g(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedInstance","ErrorCount"))
	w "可能被医生误清空的InstanceDataID共有: "_(+count),!
	w "详细信息参见Global: ^CacheTempDHCEPR("_$C(34)_"EPRservice.tool.EPRStructMgr.ChartID"_$c(34)_","_$c(34)_"MissedInstance"_$c(34)_")",!
	w "----------------",!
}

ClassMethod ClearTempChartID()
{
	k ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID")
}

ClassMethod SetTempChartID(missId As %String, admId As %String, type As %String)
{
	
	if type = "1"
	{
		q:($g(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedChart",missId))'="")
		
		s ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedChart",missId)=admId
		s count = $g(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedChart","ErrorCount"))
		s ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedChart","ErrorCount") = count + 1
	}
	elseif type = "2"
	{
		s ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedInstance",missId)=admId
		s count = $g(^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedInstance","ErrorCount"))
		s ^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID","MissedInstance","ErrorCount") = count + 1
	}
}

ClassMethod IsChartExisted(chartId As %String) As %String
{
	s totcount = "0"
	&sql(select count(*) into :totcount from SQLUser.epr.CTProfileParams where ID = :chartId)
	if totcount > 0
	{ 
		q "1"
	}
	else
	{
		q "0"
	}
}

}
