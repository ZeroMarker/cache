/// 名称：EPRservice.BLL.Query.BLQueryAdvanced
/// 描述：高级查询业务逻辑对象
/// 创建者：houjian
/// 创建日期：2011-06-15
Class EPRservice.BLL.Query.BLQueryAdvanced Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

Parameter ReleationAND As %String = "&&&";

Parameter ReleationOR As %String = "|||";

Parameter ConditionSplitor As %String = "$";

Parameter ConditionItemSplitor As %String = "^";

/// 唯一标识符	
Property GUID As %String(TRUNCATE = 1);

/// 查询条件:入院起始日期
Property AdmStartDate As %String(TRUNCATE = 1);

/// 查询条件:入院结束日期
Property AdmEndDate As %String(TRUNCATE = 1);

/// 查询条件:其他查询条件集合
Property ConditionList As %ListOfDataTypes;

/// 查询类型:按照  入院日期/出院日期  进行查询
Property queryType As %String(TRUNCATE = 1);

/// 查询类型:登录科室
Property LogonLocID As %String(TRUNCATE = 1);

/// HIS信息查询业务对象
Property BLHISInfo As EPRservice.BLL.Query.BLHISInfo;

/// EPR信息查询业务对象
Property BLEPRInfo As EPRservice.BLL.Query.BLEPRInfo;

/// LIS信息查询业务对象
Property BLLISInfo As EPRservice.BLL.Query.BLLISInfo;

/// Glossary信息查询业务对象
Property BLGlossary As EPRservice.BLL.Query.BLGlossaryInfo;

/// Desc:	实例化业务逻辑对象
ClassMethod CreateInstance(AGUID As %String, AAdmStartDate As %String, AAdmEndDate As %String, AConditionList As %ListOfDataTypes, AqueryType As %String, ALogonLocID As %String = "") As EPRservice.BLL.Query.BLQueryAdvanced
{
	s obj = ##Class(EPRservice.BLL.Query.BLQueryAdvanced).%New()
	s obj.GUID = AGUID
	s obj.AdmStartDate = AAdmStartDate
	s obj.AdmEndDate = AAdmEndDate
	s obj.ConditionList = AConditionList
	s obj.queryType = AqueryType
	s obj.LogonLocID = ALogonLocID
	q obj
}

/// Desc:	实例化业务逻辑对象
ClassMethod CreateInstanceByConText(AGUID As %String, AConditionText As %String, AqueryType As %String, ALogonLocID As %String = "") As EPRservice.BLL.Query.BLQueryAdvanced
{
	s (admStartDateValue, admEndDateValue) = ""
	s conditionList = ##Class(%ListOfDataTypes).%New()
	s count = $L(AConditionText, ..#ReleationAND)
	for i = 1:1:count
	{
		s conditionGroup = $P(AConditionText, ..#ReleationAND, i)
		
		if (i = 1)
		{
			s condition = $P(conditionGroup, ..#ReleationOR, 1)
			s admStartDateValue = $P(condition, ..#ConditionSplitor, 3)
			if (admStartDateValue '= "") s admStartDateValue = $zdh(admStartDateValue,3)
			continue
		}
		elseif (i = 2)
		{
			s condition = $P(conditionGroup, ..#ReleationOR, 1)
			s admEndDateValue = $P(condition, ..#ConditionSplitor, 3)
			if (admEndDateValue '= "") s admEndDateValue = $zdh(admEndDateValue,3)
			s conditionOr=$p(conditionGroup,..#ReleationOR,2,*)
			if (conditionOr'=""){
				s conditionOr=..#ReleationOR_conditionOr
				}
			continue
		}
		if (conditionOr'=""){
			d conditionList.Insert(conditionGroup_conditionOr)
			s conditionOr=""
			}else{
		
		d conditionList.Insert(conditionGroup)
			}
	}
	
	q ..CreateInstance(AGUID, admStartDateValue, admEndDateValue, conditionList, AqueryType, ALogonLocID)
}

/// Desc:	将符合查询条件的EpisodeID列表存储在临时Global
/// edit by Candyxu
Method SetAdmListIntoGlobal() As %Integer
{
    s TempCount = $o(^CacheTempDHCEPR(%this.GUID,"EpisodeID",""),-1)  //add by Candyxu
    if (TempCount = ""){s totCount = 0} else {s totCount = TempCount}
	//检查入参
	q:(%this.GUID = "") totCount
	q:(%this.AdmStartDate = "") totCount
	q:(%this.AdmEndDate = "") totCount
	q:(%this.AdmStartDate > %this.AdmEndDate) totCount
	q:(%this.queryType = "") totCount
	
	s hospitalId = ""
	if ($d(%session)){
		s hospitalId=$g(%session.Data("LOGON.HOSPID"))
	}
	else 
	{	//执行查询任务时走这里
		s rowId = $o(^DHCEPRI.MedicalQueryTI("IdxGUID"," "_%this.GUID,""))
		s obj = ##class(EPRinstance.Query.MedicalQueryTaskList).%OpenId(rowId)
		s hospitalId = obj.HospitalId
	}
	
	s globalMgr = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).CreateInstance(%this.GUID)

	s queryType = %this.queryType
	s startDate = %this.AdmStartDate
	s endDate = %this.AdmEndDate
	s logonLocID = %this.LogonLocID

	for date = startDate:1:endDate
	{
		s episodeID = ""
		//modify by niucaicai 2012-10-18 根据queryType判断是按“入院日期”还是按“出院日期”查询
		if (queryType = "AdmDate")
		{
			for {
				s episodeID = $O(^PAADMi("PAADM_AdmDate",date,episodeID))
				q:(episodeID = "")
                set VisitStatus = $p($g(^PAADM(episodeID)),"^",20)
                continue:(VisitStatus = "C")    //过滤掉已退院/退号的就诊信息
				
				/////共库时，判断是否只显示本院区 modify candy //////////
				//s hospitalId = $Get(%session.Data("LOGON.HOSPID"))
			    if (hospitalId '= "")
			    {
					s showShareHospital= ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
					s currentDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
					s currentDeptId = $P(currentDept,"^",1)
					s locHospitalId = $p($g(^CTLOC(currentDeptId)),"^",22)
					continue:((locHospitalId'=hospitalId)&&(showShareHospital="N")) 
			    }
				///////////////////////////////////////////
				
				//门急诊就诊时，过滤掉走号(没有挂号)的患者
				s ResultHasNotRegister = ##Class(EPRservice.BOSysOption).GetValueByName("ResultHasNotRegister")
				if (ResultHasNotRegister = "N")&&($P($g(^PAADM(episodeID)),"^",2) '= "I")
				{
					&sql(select ID into :DHCRegistrationFeeID from SQLUser.DHCRegistrationFee where RegfeeAdmDr = :episodeID)
					continue:(DHCRegistrationFeeID = "")
				}
			
				s isOK = ..IsConditionAllOK(episodeID)
				continue:('isOK)
				if (logonLocID '= "")
				{
					s value = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentDept(episodeID)
					s value = $P(value, "^", 1)
					continue:(logonLocID '= value)
				}
						
				s totCount = totCount + 1
				s ^TemptotCount = totCount
				d globalMgr.SetEpisodeIDAt(episodeID, totCount)
			}
		}
		elseif (queryType = "DischDate")
		{
			for {
				s episodeID = $O(^PAADMi("DischDate",date,episodeID))
				q:(episodeID = "")
                set VisitStatus = $p($g(^PAADM(episodeID)),"^",20)
                continue:(VisitStatus = "C")    //过滤掉已退院/退号的就诊信息
				
				//门急诊就诊时，过滤掉走号(没有挂号)的患者
				s ResultHasNotRegister = ##Class(EPRservice.BOSysOption).GetValueByName("ResultHasNotRegister")
				if (ResultHasNotRegister = "N")&&($P($g(^PAADM(episodeID)),"^",2) '= "I")
				{
					&sql(select ID into :DHCRegistrationFeeID from SQLUser.DHCRegistrationFee where RegfeeAdmDr = :episodeID)
					continue:(DHCRegistrationFeeID = "")
				}
			
				s isOK = ..IsConditionAllOK(episodeID)
				continue:('isOK)
				if (logonLocID '= "")
				{
					s value = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetCurrentDept(episodeID)
					s value = $P(value, "^", 1)
					continue:(logonLocID '= value)
				}		
				s totCount = totCount + 1
				s ^TemptotCount = totCount
				d globalMgr.SetEpisodeIDAt(episodeID, totCount)
			}
		}
	}
	d globalMgr.SetEpisodeCount(totCount)
	
	q totCount
}

/// Desc:	是否满足所有查询条件
Method IsConditionAllOK(AEpisodeID As %String) As %Boolean
{
	s isOK = 1
	
	s listCount = %this.ConditionList.Count()
	q:(listCount < 1) isOK
	
	//初始化查询业务逻辑对象
	d ..InitBLObject(AEpisodeID) 
	
	for i = 1:1:listCount
	{
		s conditionGroup = %this.ConditionList.GetAt(i)
		s isOK = ..IsConditionGroupOK(conditionGroup)
		q:('isOK)
	}
	
	q isOK
}

/// Desc:	初始化业务逻辑查询对象
Method InitBLObject(AEpisodeID As %String)
{
	if (%this.BLHISInfo = "") 
	{
		s %this.BLHISInfo = ##Class(EPRservice.BLL.Query.BLHISInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLHISInfo.SetEpisodeID(AEpisodeID)
	
	if (%this.BLEPRInfo = "")
	{
		s %this.BLEPRInfo = ##Class(EPRservice.BLL.Query.BLEPRInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLEPRInfo.SetEpisodeID(AEpisodeID)
	
	if (%this.BLLISInfo = "")
	{
		s %this.BLLISInfo = ##Class(EPRservice.BLL.Query.BLLISInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLLISInfo.SetEpisodeID(AEpisodeID)
    
	if (%this.BLGlossary = "")
	{
		s %this.BLGlossary = ##Class(EPRservice.BLL.Query.BLGlossaryInfo).CreateInstance(AEpisodeID)
	}
	d %this.BLGlossary.SetEpisodeID(AEpisodeID)
}

/// Desc:	是否满足一组 "或" 关系的查询条件
Method IsConditionGroupOK(AConditionGroup As %String) As %Boolean
{
	
	s preItem = "", preItemValue = ""
	s count = $L(AConditionGroup, ..#ReleationOR)
	for i = 1:1:count
	{
		s condition = $P(AConditionGroup, ..#ReleationOR, i)
		s item = $P(condition, ..#ConditionSplitor, 1)
		s operator = $P(condition, ..#ConditionSplitor, 2)
		s value = $P(condition, ..#ConditionSplitor, 3)
		s dataType = $P(item, ..#ConditionItemSplitor, 4)
		
		s queryCode = $P(item, ..#ConditionItemSplitor, 2)
		
		if (item = preItem)
		{
			s itemValue = preItemValue
		}
		else
		{
			s itemValue =  ..GetItemValue(item)
		}
		
		s isOK = ..IsValueOK(itemValue, operator, value, dataType)
		q:(isOK)
		
		s preItem = item, preItemValue = itemValue
	}
	
	q isOK
}

/// Desc:	获取项目值
ClassMethod GetItemValue(AConditionItem As %String) As %String
{
	s itemValue = ""
	s itemType = $P(AConditionItem, ..#ConditionItemSplitor, 1)
	//s itemName = $P(AConditionItem, ..#ConditionItemSplitor, 2)
	s itemCode = $P(AConditionItem, ..#ConditionItemSplitor, 3)
	if (itemType = "HIS")
	{
		s itemValue = $ZOBJMETHOD(%this.BLHISInfo, itemCode)
	}
	elseif (itemType = "EPR")
	{
		s itemValue = %this.BLEPRInfo.GetEPRData(itemCode)
	}
	elseif (itemType = "LIS")
	{
		s itemValue = %this.BLLISInfo.GetLISDataResult(itemCode)
	}
 
	elseif (itemType = "Glossary")
	{
		s itemValue = %this.BLGlossary.GetGlossaryData(itemCode)
	}
	
	q itemValue
}

/// Desc:	值是否满足条件
/// Other:  输入条件值为"NULL",表示前端输入的条件的值为空。
/// w ##class(EPRservice.BLL.Query.BLQueryAdvanced).IsValueOK("19/10/1999","=","19/10/1999","date")
ClassMethod IsValueOK(AItemValue, AOperator, AConditionValue, ADataType) As %Boolean
{
	if (AConditionValue="NULL")
	{
		s AConditionValue=""	
	}
	if (ADataType = "date")||(ADataType = "time")||(ADataType = "datetime")
	{
		q ..IsDateTimeValueOK(AItemValue, AOperator, AConditionValue, ADataType)
	}
	q:(AOperator = "=") AItemValue = AConditionValue
	
	q:((AOperator = ">")||(AOperator = "<")||(AOperator = ">=")||(AOperator = "<="))&&(AItemValue="") 0
	q:(AOperator = "<>") AItemValue '= AConditionValue
	q:(AOperator = ">") $ZSTRIP(AItemValue,"*E'N") > AConditionValue
	q:(AOperator = "<") $ZSTRIP(AItemValue,"*E'N") < AConditionValue
	q:(AOperator = ">=") $ZSTRIP(AItemValue,"*E'N") '< AConditionValue
	q:(AOperator = "<=") $ZSTRIP(AItemValue,"*E'N") '> AConditionValue
	
	s index = $find(AItemValue, AConditionValue)
	q:(AOperator = "like") index > 0 
	q:(AOperator = "notlike") index = 0
	q 0
}

/// Desc:	日期时间类型的值是否满足条件
ClassMethod IsDateTimeValueOK(AItemValue, AOperator, AConditionValue, ADataType) As %Boolean
{
	if (ADataType = "date")
	{
		q ..IsDateValueOK(AItemValue, AOperator, AConditionValue)
	}
	elseif (ADataType = "time")
	{
		q ..IsTimeValueOK(AItemValue, AOperator, AConditionValue)
	}
	elseif (ADataType = "datetime")
	{
		q ..IsDTValueOK(AItemValue, AOperator, AConditionValue)
	}
	q 0
}

ClassMethod IsDateValueOK(ADate, AOperator, AConditionValue) As %Boolean
{
	if (ADate = "")
	{	s date = 0}
	else
	{
		if ((ADate [ "年")||(ADate [ "月")||(ADate [ "日"))	;后台日期单元数据格式为"年月日"的进行转换
		{
			s ADate = $tr(ADate,"年","-")
			s ADate = $tr(ADate,"月","-")
			s ADate = $tr(ADate,"日","")
		}
	    //s date = $zdh(ADate, 3)}
	    s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ADate)
	}
	
	if (AConditionValue = "")
	{	s condition = 0}
	else
	{	
		//s condition = $zdh(AConditionValue,3)
		s condition = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AConditionValue)
	
	}
	
	
	q:(AOperator = "=") date = condition
	q:(AOperator = ">") date > condition
	q:(AOperator = "<") date < condition
	q:(AOperator = ">=") date >= condition
	q:(AOperator = "<=") date <= condition
	q 0
}

ClassMethod IsTimeValueOK(ATime, AOperator, AConditionValue) As %Boolean
{
	if (ATime = "")
	{	s time = 0}
	else
	{	s time = $zth(ATime, 1)}
	
	if (AConditionValue = "")
	{	s condition = 0}
	else
	{	s condition = $zth(AConditionValue,1)}
	
	
	q:(AOperator = "=") time = condition
	q:(AOperator = ">") time > condition
	q:(AOperator = "<") time < condition
	q:(AOperator = ">=") time >= condition
	q:(AOperator = "<=") time <= condition
	q 0
}

ClassMethod IsDTValueOK(ADateTime, AOperator, AConditionValue) As %Boolean
{
	if (ADateTime = "")
	{
		s date = 0, time = 0
	}
	elseif ($L(ADateTime, " ") = 2) 
	{
		s date = $P(ADateTime, " ", 1)
		if ((date [ "年")||(date [ "月")||(date [ "日"))	;后台日期单元数据格式为"年月日"的进行转换
		{
			s date = $tr(date,"年","-")
			s date = $tr(date,"月","-")
			s date = $tr(date,"日","")
		}
		s time = $P(ADateTime, " ", 2)
		//s date = $zdh(date, 3)
		s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",date)
	
		s time = $zth(time, 1)
	}
	else
	{
		q 0
	}
	
	q:($L(AConditionValue, " ") '= 2) 0 
	s conDate =  $P(AConditionValue, " ", 1)
	s conTime =  $P(AConditionValue, " ", 2)
	//s conDate = $zdh(conDate, 3)
	s conDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",conDate)
	
	s conTime = $zth(conTime, 1)
    
    
	q:(AOperator = "=") (date = conDate)&&(time = conTime)
	q:(AOperator = ">") (date > conDate)||((date = conDate)&&(time > conTime))
	q:(AOperator = "<") (date < conDate)||((date = conDate)&&(time < conTime))
	q:(AOperator = ">=") (date > conDate)||((date = conDate)&&(time >= conTime))
	q:(AOperator = "<=") (date < conDate)||((date = conDate)&&(time <= conTime))
	q 0
}

ClassMethod IsDateValid(ADate As %String) As %Boolean
{
}

ClassMethod IsDateTimeValid() As %Boolean
{
}

/// Desc:	获取就诊列表总数
ClassMethod GetEpisodeCount(AGUID As %String) As %Integer
{
	q:(AGUID = "") 0
	s globalMgr = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).CreateInstance(AGUID)
	q globalMgr.GetEpisodeCount()
}

/// Debug:	d ##Class(EPRservice.BLL.Query.BLQueryAdvanced).Test()
ClassMethod Test()
{
	s AConditionStr = "HIS^AdmDate^AdmDate$>=$2010-10-9"
	s AConditionStr = AConditionStr_"&HIS^AdmDate^AdmDate$<=$2010-10-9"
	s AConditionStr = AConditionStr_"&HIS^Name^Name$like$永"
	s AConditionStr = AConditionStr_"&EPR^Gender^新建字符单元#TYPE:Simple#TID:1073#TVER:0#SCODE:S0001#VTYPE:V$=$Male"
	s AConditionStr = AConditionStr_"|EPR^BirthDate^新建单选单元#TYPE:Simple#TID:1073#TVER:0#SCODE:O0003#VTYPE:V$=$b"
	
	s AColumnsStr = "HIS^Name^Name"
	s AColumnsStr = AColumnsStr_"&EPR^Gender^新建字符单元#TYPE:Simple#TID:1073#TVER:0#SCODE:S0001#VTYPE:V"
	s AColumnsStr = AColumnsStr_"&EPR^BirthDate^新建单选单元#TYPE:Simple#TID:1073#TVER:0#SCODE:O0003#VTYPE:V"
	
	
	s guid = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).GetGUID()
	
	s blAdvancedQuery = ##Class(EPRservice.BLL.Query.BLQueryAdvanced).CreateInstanceByConText(guid, AConditionStr)
	s count = blAdvancedQuery.SetAdmListIntoGlobal()
	
	s blItemResult = ##Class(EPRservice.BLL.Query.BLQueryResult).CreateInstanceByColText(guid,AColumnsStr)
	for i = 1:1:count
	{
		s dataList = blItemResult.GetResultByKey(i)
		//s dataList = blItemResult.GetQueryResult("201869")
		if dataList = "" 
		{
			w !, "result "_i_" is null"
		}
		else
		{
			w !, "result "_i_" :"
			s length = $LL(dataList)
			for j = 1:1:length
			{
				w !, $ListGet(dataList,j)
			}
		}
	}
	
	w !,"Test is OK"
}

}
