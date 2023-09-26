Class CHSSWeb.HISInterface.CommunityStatWebService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter LOCATION = "http://localhost/trakcarelivess/trak/Web";

/// Name of the WebService.
Parameter SERVICENAME = "CHSSWeb.HISInterface.CommunityStatWeb";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CHSSWeb/HISInterface/CommunityStatWeb";

/// Description:公共卫生服务情况接口
ClassMethod GetCommunityHSInfo(CommunityCode As %String, DateOfStart As %String, DateOfEnd As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.CommunityHSInfoInterface).CommunityHSInfoData(CommunityCode, DateOfStart, DateOfEnd)
	Quit rtn
}

/// Description:公共卫生人力资源情况接口
ClassMethod GetCommunityHrInfo(CommunityCode As %String, DateOfStart As %String, DateOfEnd As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.CommunityHrInfoInterface).getCommunityHrInfo(CommunityCode, DateOfStart, DateOfEnd)
	Quit rtn
}

/// Description:个人健康档案基本信息
ClassMethod GetPersonHealthInfo(idcard As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.PersonHealthInfoService).getPersonHealthInfo(idcard)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-17
/// Description:个人高血压随访记录
ClassMethod GetHBPCheckRecordInfo(personRowid As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.HBPCheckRecordInterface).HBPCheckRecordList(personRowid,start,limit)	
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-17
/// Description:个人糖尿病随访记录
ClassMethod GetDiabetasCheckRecordInfo(personRowid As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn=##class(CHSSWeb.HISInterface.DiabetesCheckRecordInterface).DiabetesCheckRecordList(personRowid,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-19
/// Description:健康体检表--【一般状况】列表数据
ClassMethod GetPersonYearCheckRecordInfo(personRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonBaseCheckRecordInfoService).PersonBaseCheckRecordList(personRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-20
/// Description:健康体检表--脏器功能与查体
ClassMethod GetPersonOrganCheckRecordInfo(personRowId As %String, checkRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonOrganCheckRecordInfoService).PersonOrganCheckRecordInfo(personRowId,checkRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-20
/// Description:健康体检表--生活方式
ClassMethod GetPersonLifeStyleInfo(personRowId As %String, checkRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonLifeStyleInterface).PersonLifeStyleInfo(personRowId,checkRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-20
/// Description:健康体检表--辅助检查
ClassMethod GetPersonAccessoryInfo(personRowId As %String, checkRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonAccessoryCheckInfoService).PersonAccessoryCheckInfo(personRowId,checkRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-20
/// Description:健康体检表--健康评价与指导
ClassMethod GetPersonHealthAppraiseInfo(personRowId As %String, checkRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonHealthAppraiseInfoService).PersonHealthAppraiseInfo(personRowId,checkRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:健康体检表--健康情况--中医体质辨识,现存主要健康问题,家庭病床史,计划外免疫史
ClassMethod GetPersonHealthCheckInfo(personRowId As %String, ItemdCode As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonHealthRecordInfoService).PersonHealthDiagnoseInfo(personRowId,ItemdCode)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:健康体检表--健康情况--住院史
ClassMethod GetPersonInHosRecordInfo(personRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonHealthRecordInfoService).PersonInHosRecordInfo(personRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:健康体检表--健康情况--主要用药情况
ClassMethod GetPersonUseDrugInfo(personRowId As %String, checkRowId As %String, tableType As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonHealthRecordInfoService).PersonUseDrugInfo(personRowId,checkRowId,tableType)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-05-30
/// Description:妇女档案列表
ClassMethod GetWomenBaseInfoList(personRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenBaseInfoService).WomenBaseInfoList(personRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-01
/// Description:第1次产前随访服务记录表
ClassMethod GetWomanFirstCheckInfo(womanRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenFirstCheckInfoService).WomenFirstCheckInfo(womanRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-01
/// Description:第2~5次产前随访服务记录表
ClassMethod GetWomenAntepartumRecheckList(womanRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenAntepartumRecheckInfoService).WomenAntepartumRecheckList(womanRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-02
/// Description:在第1次产前随访服务记录表获取‘总体评估’字段
ClassMethod GetWomenFCE(firstCheckRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenFirstCheckInfoService).WomenFCE(firstCheckRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-02
/// Description:孕妇分娩情况
ClassMethod GetWomenBirthCheckInfo(womanRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenBirthRecordInfoService).WomenBirthRecordInfo(womanRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-02
/// Description:孕妇分娩情况，获取“新生儿情况”字段
ClassMethod GetWhNewBorn(womanRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenBirthRecordInfoService).WhNewBorn(womanRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-03
/// Description:产后访视记录表
ClassMethod GetWomenAfterCheckList(womanRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenAfterCheckInfoService).WomenAfterCheckList(womanRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-03
/// Description:产后42天健康检查记录表
ClassMethod GetWomenAfter42DaysInfo(WomanRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenAfter42DaysRecordInfoService).WomenAfter42DaysRecordInfo(WomanRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-07
/// Description:高危评分记录
ClassMethod GetWomenDangerScoreList(WomanRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenDangerScoreInfoService).WomenDangerScoreList(WomanRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// Date:2011-6-7
/// Description:获取高危因素字段
ClassMethod GetDangerFactor(DangerRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.WomenDangerScoreInfoService).DangerFactor(DangerRowId)
	q rtn
}

/// Creator:jinming
/// Date:2011-6-13
/// Description:儿童档案
ClassMethod GetChildInfoList(personRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.ChildInfoService).ChildInfoList(personRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// Date:2011-6-14
/// Description:新生儿第一次访视随访表
ClassMethod GetChildFirstCheckInfo(childRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.ChildFirstCheckInfoService).ChildFirstCheckInfo(childRowId)
	q rtn
}

/// Creator:jinming
/// Date:2011-6-14
/// Description:儿童健康管理随访表
ClassMethod GetChildCheckRecordList(childRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.ChildCheckRecordInfoService).ChildCheckRecordList(childRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// Date:2011-6-15
/// Description:婴儿36个月访视随访表
ClassMethod GetChild36CheckRecordInfo(childRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.Child36CheckRecordInfoService).Child36CheckRecordInfo(childRowId)
	q rtn
}

/// Creator:jinming
/// Date:2011-6-16
/// Description:儿童患病情况
ClassMethod GetChildDisease(Child36Id As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.Child36CheckRecordInfoService).ChildDisease(Child36Id)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-6-20
/// Description:EHR浏览器老年人随访记录
ClassMethod GetElerlyHealthCheckList(PersonRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.ElerlyHealthCheckInterface).ElerlyHealthCheckList(PersonRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-6-21
/// Description:EHR浏览器精神病人随访记录
ClassMethod GetSchizoCheckRecordList(PersonRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonSchizoCheckRecordService).SchizoCheckRecordList(PersonRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-6-21
/// Description:获取【患病对家庭社会的影响】字段
ClassMethod GetEffectToFamily(PersonRowId As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonSchizoCheckRecordService).EffectToFamily(PersonRowId)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-6-22
/// Description:获取【患病对家庭社会的影响】列表
ClassMethod GetEffectToFamilyList(PersonRowId As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonSchizoCheckRecordService).EffectToFamilyList(PersonRowId,start,limit)
	q rtn
}

/// Creator:jinming
/// CreateDate:2011-06-22
/// Description:健康体检表--健康情况--主要用药情况列表
ClassMethod GetPersonUseDrugList(personRowId As %String, checkRowId As %String, tableType As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	s rtn = ##class(CHSSWeb.HISInterface.PersonHealthRecordInfoService).PersonUseDrugList(personRowId,checkRowId,tableType,start,limit)
	q rtn
}

}
