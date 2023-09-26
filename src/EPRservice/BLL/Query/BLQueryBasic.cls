/// 名称：EPRservice.BLL.Query.BLQueryBasic
/// 描述：简单查询业务逻辑对象
/// 创建者：houjian
/// 创建日期：2011-06-03
Class EPRservice.BLL.Query.BLQueryBasic Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

Property GUID As %String(TRUNCATE = 1);

/// Desc:	获取简单查询业务逻辑对象实例
ClassMethod CreateInstance(AGUID As %String) As EPRservice.BLL.Query.BLQueryBasic
{
	s obj = ##Class(EPRservice.BLL.Query.BLQueryBasic).%New()
	s obj.GUID = AGUID
	q obj
}

/// Desc:	将符合查询条件的EpisodeID列表存储在临时Global
Method SetAdmListIntoGlobal(AName, APatNo, AAdmNo, AType, AStartAdmDate, AEndAdmDate, AStartDisDate, AEndDisDate, ACurrentDept As %String = "", ACurrentWard As %String = "", ADiagnose, ADiagnote) As %Integer
{
	//b "s"
	s totCount = 0
	
	s AGUID = %this.GUID
	q:(AGUID = "") totCount
	
	s admList = ..GetAdmList(AAdmNo, APatNo, AName, AType,AStartAdmDate, AEndAdmDate, AStartDisDate, AEndDisDate)
	s globalMgr = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).CreateInstance(AGUID)
	
	s key = ""
	for {
		s key = admList.Next(key)
		q:(key = "")
		
		s episodeID = admList.GetAt(key)
		
		s isOK = ..IsConditionOK(episodeID, AName, APatNo, AAdmNo,AType, AStartAdmDate, AEndAdmDate, AStartDisDate, AEndDisDate, ACurrentDept, ACurrentWard, ADiagnose,ADiagnote)
		continue:('isOK)
		
		s totCount =  totCount + 1
		d globalMgr.SetEpisodeIDAt(episodeID, totCount)
		
		//w !, "Count: "_totCount_",EpisodeID: "_episodeID
	}
	
	d globalMgr.SetEpisodeCount(totCount)
	
	q totCount
}

Method GetAdmList(AAdmNo, APatNo, AName, AType, AStartAdmDate, AEndAdmDate, AStartDisDate, AEndDisDate) As %ListOfDataTypes [ Private ]
{
	s admList = ##Class(%ListOfDataTypes).%New()
	
	if (AAdmNo '= "")
	{	
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByAdmNo(AAdmNo) 	
	}
	elseif (APatNo '= "")
	{	
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByPatNo(APatNo)	
	}
	elseif (AName '= "")
	{	
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByName(AName)		
	}
	//add by yaolin 增加诊断类型判断条件
	elseif (AType '= "")
	{	
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByType(AType)		
	}
	elseif (AStartAdmDate '= "")&&(AEndAdmDate '= "")
	{	
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByAdmDate(AStartAdmDate, AEndAdmDate)		
	}
	elseif (AStartDisDate '= "")&&(AEndDisDate '= "")
	{
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByDisDate(AStartDisDate, AEndDisDate)		
	}
	
	q admList
}

Method IsConditionOK(AEpisodeID, AName, APatNo, AAdmNo, AType, AStartAdmDate, AEndAdmDate, AStartDisDate, AEndDisDate, ACurrentDept, ACurrentWard, ADiagnose, ADiagnote) As %Boolean [ Private ]
{
	s false = 0, true =1
	/////共库时，判断是否只显示本院区 modify candy//////////
	s hospitalId = $Get(%session.Data("LOGON.HOSPID"))
    if (hospitalId '= "")
    {
		s showShareHospital= ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
		s currentDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(AEpisodeID)
		s currentDeptId = $P(currentDept,"^",1)
		q:(currentDeptId = "") false
		s locHospitalId = $p($g(^CTLOC(currentDeptId)),"^",22)
		q:(locHospitalId = "") false
		q:((locHospitalId'=hospitalId)&&(showShareHospital="N")) false
    }
	///////////////////////////////////////////
	if (AAdmNo '= "")
	{
		s value =  ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmNo(AEpisodeID)
		//q:(AAdmNo '= value) false
		q:(AAdmNo '[ value) false
	}
	
	if (AStartAdmDate '= "")||(AEndAdmDate '= "")
	{
		s value = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmDateTime(AEpisodeID)
		s value = $P(value, ",", 1)
		q:(AStartAdmDate '= "")&&(value < AStartAdmDate) false
		q:(AEndAdmDate '= "")&&(value > AEndAdmDate) false
	}
	
	if (AStartDisDate '= "")||(AEndDisDate '= "")
	{
		s value = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDisDateTime(AEpisodeID)
		s value = $P(value, ",", 1)
		q:(AStartDisDate '= "")&&(value < AStartDisDate) false
		q:(AEndDisDate '= "")&&(value > AEndDisDate) false
	}
	
	if (ACurrentDept '= "")
	{
		s value = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentDept(AEpisodeID)
		s value = $P(value, "^", 1)
		q:(ACurrentDept '= value) false
	}
	
	if (ACurrentWard '= "")
	{
		s value = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentWard(AEpisodeID)
		s value = $P(value, "^", 1)
		q:(ACurrentWard '= value) false
	}
	//add by yaolin 
	if (AType '= "")
	{
		s value =  ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmType(AEpisodeID)
		s Type = $zcvt(AType,"u")
		q:(Type '= value) false
	}
 	s papmiDR = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetPapmiDR(AEpisodeID)
 	
	if (AName '= "")
	{
		s name = ##Class(EPRservice.HISInterface.DAPatientInfo).GetName(papmiDR)
		q:(name '= AName) false
	}
	
	if (APatNo '= "")
	{
		s patNo = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiNo(papmiDR)
		//q:(patNo '= APatNo) false
		q:(APatNo '[ patNo) false
	}
	
	if (ADiagnose '= "")
	{
		s value =  ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDiagnos(AEpisodeID)
		q:(value '[ ADiagnose) false
	}
	
	
	if (ADiagnote '= "")
	{
		s value =  ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetDiagnote(AEpisodeID)
		q:(value '[ ADiagnote) false
	}
	q true
}

/// Desc:	获取就诊列表总数
ClassMethod GetEpisodeCount(AGUID As %String) As %Integer
{
	q:(AGUID = "") 0
	s globalMgr = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).CreateInstance(AGUID)
	q globalMgr.GetEpisodeCount()
}

/// Desc:	清空缓存数据
ClassMethod ClearTempGlobal(AGUID As %String) As %Integer
{
}

}
