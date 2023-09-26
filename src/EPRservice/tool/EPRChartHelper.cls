/// 	名称：EPRservice.tool.EPRChartHelper
/// 	描述：Chart管理器，检查旧框架是否有Chart被误删除，以及是否有InstanceData被医生清空
/// 	创建者：houj
/// 	创建日期：2010-12-30
Class EPRservice.tool.EPRChartHelper Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 	检查旧框架是否有Chart被误删除，以及是否有InstanceData被医生清空
///         检查结果存储在临时global中：^CacheTempDHCEPR("EPRservice.tool.EPRStructMgr.ChartID")
/// Input: argEpisodeID 病人就诊rowid
/// Output：
/// return：
/// Debug: w ##class(EPRservice.tool.EPRChartHelper).GetMissedChartByAdm("201764")
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
		s isExisted = ..IsChartExisted(realChartId)
		if ('isExisted)
		{
			s tmpcount = tmpcount + 1
			w !, tmpcount_" "
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
				w !, tmpcount_" "
				w "发现被清空的病历: "_instanceId,!
				d ..SetTempChartID(instanceId,argEpisodeID,"2")
				continue
			}
		}
	}
	
	
	w !,"检查结束,结果如下:",!
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
