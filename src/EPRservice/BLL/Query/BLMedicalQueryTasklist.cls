/// 名称:EPRservice.BLL.Query.BLMedicalQueryTasklist
/// 描述:病历后台查询任务表--BL层
/// 编写者：liuyunfei
/// 编写日期: 2020-10-12
Class EPRservice.BLL.Query.BLMedicalQueryTasklist Extends %RegisteredObject
{

/// creator:     liuyunfei
/// CreatDate:   2020-10-22
/// Description: 记录病历浏览任务日志
/// Table:		EPRinstance.Query.MedicalQueryTaskList.cls
/// input:		Name:任务名称；UserID:用户名id；UserName:用户名；GUID:global的id；
/// 			Conditions:查询条件；ConditionsDesc:条件中文描述；ResultColumn:结果列；QueryType:查询类型（入院/出院时间/就诊时间）
/// desc:	插入查询任务信息
/// debug：	d ##Class(EPRservice.BLL.Query.BLMedicalQueryTasklist).InsertInfo()
ClassMethod InsertInfo(Name As %String, UserID As %String, UserName As %String, GUID As %String, Conditions As %String, ConditionsDesc As %String, ResultColumn As %String, QueryType As %String)
{
	s obj = ##class(EPRinstance.Query.MedicalQueryTaskList).%New()
	s obj.Name = Name
	s obj.UserID = UserID
	s obj.UserName = UserName
	s obj.GUID = GUID
	s obj.QueryType = QueryType
	s obj.Conditions = Conditions
	s obj.ConditionsDesc = ConditionsDesc
	s obj.ResultColumn = ResultColumn
	s obj.HospitalId = $Get(%session.Data("LOGON.HOSPID"))
	s obj.StartTime = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
	s obj.Status = "0"
	d obj.%Save()
}

/// creator:     liuyunfei
/// CreatDate:   2020-10-22
/// Description: 插入完任务信息后，通过触发器调用（JOB方式）此方法进行数据查询
/// Table:		EPRinstance.Query.MedicalQueryTaskList.cls
/// input:		RowID : EPRinstance.Query.MedicalQueryTaskList的rowId
/// debug：	d ##Class(EPRservice.BLL.Query.BLMedicalQueryTasklist).GetSearchResult(50)
ClassMethod GetSearchResult(RowID As %String)
{
	s obj = ##class(EPRinstance.Query.MedicalQueryTaskList).%OpenId(RowID)
	s ret = ##class(EPRservice.BLL.Query.BLMedicalQueryTasklist).GetResultInTask(obj.GUID,obj.Conditions,obj.QueryType)
	if (ret = "WriteTempGlobalOver")
	{
		s blItemResult = ##Class(EPRservice.BLL.Query.BLQueryResult).CreateInstanceByColText(obj.GUID, obj.ResultColumn)
		s colCount = blItemResult.ColumnList.Count()
		q:(colCount = 0)
		//增加^DHCEPRI.MedicalQueryTaskData用来存储查询结果
		s ^DHCEPRI.MedicalQueryTaskData(obj.GUID,"EpisodeCount") = $g(^CacheTempDHCEPR(obj.GUID,"EpisodeCount"))
		for i = 1:1:^CacheTempDHCEPR(obj.GUID,"EpisodeCount")
		{
			s dataList = blItemResult.GetResultByKey(i)
			continue:(dataList = "")
			s ^DHCEPRI.MedicalQueryTaskData(obj.GUID,"Result",i) = ##Class(EPRservice.BLL.Query.BLFormattedResult).ResultListToJson(dataList, blItemResult.ColumnList)
		}
		
		s obj.EndTime = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s obj.Status = "1"
		d obj.%Save()
	}
	else
	{
		//查询失败
		s obj.EndTime = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
		s obj.Status = "2"
		d obj.%Save()
	}
}

/// creator:    liuyunfei
/// CreatDate:  2020-10-22
/// Description:调用病历查询接口，完成后返回标志“WriteTempGlobalOver”
/// input:		AGUID:global的id；AConditions:查询条件；AqueryType:查询类型（入院/出院时间/就诊时间）；ALogonLocID:科室id
/// optput：	"WriteTempGlobalOver"
/// debug:		w ##class(EPRservice.BLL.Query.BLMedicalQueryTasklist).GetResult(1480,"$>$2020-09-01&&&$<$2020-09-11","AdmDate","")
ClassMethod GetResultInTask(AGUID As %String, AConditions As %String, AqueryType As %String) As %String
{
	d ##class(web.eprajax.query.advancedquery).QueryData(AGUID, AConditions,AqueryType)
	//上面方法执行完成后，写出字符串表示操作完成
	q "WriteTempGlobalOver"
}

/// creator:    liuyunfei
/// CreatDate:  2020-10-22
/// desc:		获取查询结果明细
/// input:		GUID:global的id；startRows:分页起始行数；countRows:每页有多少条数据
/// output：	返回查询结果明细的json
/// debug：	w ##Class(EPRservice.BLL.Query.BLMedicalQueryTasklist).GetResultDitails(35,0,10)
ClassMethod GetResultDitails(GUID As %String, startRows As %String, countRows As %String) As %String
{
	q:((GUID = "")||(startRows < 0)||(countRows < 1)) ""
	s startKey = startRows + 1		   //分页起始行Key
	s endKey = 	startRows + countRows  //分页结束行Key
	s count = 0
	s json = ""
	s count = $g(^DHCEPRI.MedicalQueryTaskData(GUID,"EpisodeCount"))
	for i = startKey:1:endKey
	{
		q:($d(^DHCEPRI.MedicalQueryTaskData(GUID,"Result",i))=0)
		s:(i'=startKey) json = json_","
		s json = json_$g(^DHCEPRI.MedicalQueryTaskData(GUID,"Result",i))
	}
	q "{""total"":"_count_",""rows"":["_json_"]}"
}

/// creator:    liuyunfei
/// CreatDate:  2020-10-22
/// desc:		根据userId获取病历查询任务列表
/// Table:		EPRinstance.Query.MedicalQueryTaskList.cls
/// input:		UserId:用户Id
/// output：	返回该用户的所有任务json
/// debug：	w ##Class(EPRservice.BLL.Query.BLMedicalQueryTasklist).SelectTaskList("10209")
ClassMethod SelectTaskList(UserId As %String) As %String
{
	s json = ""
	s count = 0
	s rowId = ""
	s queryResultDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","查看结果")
	s queryNoFinishDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","查询未完成")
	s queryFinishDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","查询已完成")
	s queryFailDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","查询失败")
	for
	{
		s rowId = $o(^DHCEPRI.MedicalQueryTI("IdxUserID"," "_UserId,rowId))
		q:(rowId="")
		s obj = ##class(EPRinstance.Query.MedicalQueryTaskList).%OpenId(rowId)
		q:(obj="")
		s:(count'=0) json = json_","
		d setJson
	}
	q "{""total"":"_count_",""rows"":["_json_"]}"
	
setJson
	s resultLink = ""
	s:(obj.Status=1) resultLink = queryResultDesc
	s dataType = "入院日期："
	if (obj.QueryType = "DischDate")
	{
		s dataType = "出院日期："
	}
	s guidStatus = obj.GUID_"^"_obj.Status
	s json = json_"{"
	s json = json_"""TaskName"":"""_obj.Name_""","
	s json = json_"""StartTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",obj.StartTime)_""","
	s json = json_"""EndTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",obj.EndTime)_""","
	s json = json_"""UserName"":"""_obj.UserName_""","
	s json = json_"""GUID"":"""_guidStatus_""","
	s json = json_"""Conditions"":"""_dataType_""_obj.ConditionsDesc_""","
	s json = json_"""ResultColumn"":"""_obj.ResultColumn_""","
	s json = json_"""TaskStatus"":"""_$case(obj.Status,0:queryNoFinishDesc,1:queryFinishDesc,2:queryFailDesc)_""","
	if (obj.Status=1)
	{
		s json = json_"""TaskResult"":""<a onclick=viewResult('"_obj.GUID_"')>"_resultLink_"</a>"""
	}
	else
	{
		s json = json_"""TaskResult"":"""_resultLink_""""
	}
	s json = json_"}"
	s count = count+1
}

/// creator:    liuyunfei
/// CreatDate:  2020-10-22
/// desc:		根据GUID获取数据
/// Table:		EPRinstance.Query.MedicalQueryTaskList.cls
/// input:		UserId:用户Id
/// output：	条件描述，结果列，日期类型
/// debug：		w ##Class(EPRservice.BLL.Query.BLMedicalQueryTasklist).GetInfoByGUID()
ClassMethod GetInfoByGUID(AGUID As %String) As %String
{
	q:(AGUID = "") ""
	s rowId = $o(^DHCEPRI.MedicalQueryTI("IdxGUID"," "_AGUID,""))
	s obj = ##class(EPRinstance.Query.MedicalQueryTaskList).%OpenId(rowId)
	q "{""ConditionsDesc"":"""_obj.ConditionsDesc_""",""ResultColumn"":"""_obj.ResultColumn_""",""QueryType"":"""_obj.QueryType_"""}"
}

/// creator:    liuyunfei
/// CreatDate:  2020-10-22
/// desc:		返回list，包含列名和值
/// Table:		EPRinstance.Query.MedicalQueryTaskList.cls
/// input:		AGUID:global的id
/// output：	datalist
/// other:		(调用导出excel公共方法)w ##class(EMRservice.Tools.ExportToExcel).toExcelByEMR("医生011","EPRservice.BLL.Query.BLMedicalQueryTasklist","ExportTaskResultDetails","723")
/// debug：		w ##Class(EPRservice.BLL.Query.BLMedicalQueryTasklist).ExportTaskResultDetails(723)
ClassMethod ExportTaskResultDetails(AGUID As %String)
{
	q:(AGUID="")
	s dataList=##class(%ListOfDataTypes).%New()
	s titleList=##class(%ListOfDataTypes).%New()
	s rowId = $o(^DHCEPRI.MedicalQueryTI("IdxGUID"," "_AGUID,""))
	s obj = ##class(EPRinstance.Query.MedicalQueryTaskList).%OpenId(rowId)
	q:(obj="")
	s resultColumn = obj.ResultColumn
	for i=1:1:$L(resultColumn,"&")
	{
		s column=$P(resultColumn,"&",i)
		s headTitle=$P(column,"^",4)	//列名
		d titleList.Insert(headTitle)
	}
	d dataList.Insert(titleList)
	s count = $g(^DHCEPRI.MedicalQueryTaskData(AGUID,"EpisodeCount"))
	for i=1:1:count
	{
		s itemList=##class(%ListOfDataTypes).%New()
		s jsonObj = {}.%FromJSON(^DHCEPRI.MedicalQueryTaskData(AGUID,"Result",i))	//字符串转成json对象
		s iter = jsonObj.%GetIterator()
		while iter.%GetNext(.key , .value )
		{
			d itemList.Insert(value)	//value是对象值
		}
		d dataList.Insert(itemList)
	}
	q dataList
}

/// creator:    liuyunfei
/// CreatDate:  2020-10-22
/// desc:		删除记录
/// Table:		EPRinstance.Query.MedicalQueryTaskList.cls
/// input:		AGUID:global的id
/// debug：		d ##Class(EPRservice.BLL.Query.BLMedicalQueryTasklist).DeleteByGUID(1488)
ClassMethod DeleteByGUID(AGUID As %String)
{
	q:(AGUID = "")
	s rowId = $o(^DHCEPRI.MedicalQueryTI("IdxGUID"," "_AGUID,""))
	d ##class(EPRinstance.Query.MedicalQueryTaskList).%DeleteId(rowId)
	//把临时global清除
	d ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).ClearGlobalByGUID(AGUID)
	k ^DHCEPRI.MedicalQueryTaskData(AGUID)
}

}
