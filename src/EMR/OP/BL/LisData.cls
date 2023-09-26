/// 名称：EMR.OP.BL.LisData
/// 描述：门急诊检验结果功能相关业务
/// 编写者：huhao
/// 编写日期：2021-7-22
/// 产品组：电子病历产品组
Class EMR.OP.BL.LisData Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取检验主数据
/// Creator:    huhao
/// CreateDate: 2021-07-22
/// Input:      argInJson  	命令参数 {"action":"GET_LISDATA","params":{"interface":"HIS","episodeIds":"4","startDate":" ","endDate":" ","authStartDate":" ","authEndDate":" ","patientId":"31","authorizedFlag":" ","dateGap":" ","current":1,"pageSize":20},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetDataList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s interface=argInJson.params.interface
	s interface = $CASE(interface,"":"HIS",:interface)
	s episodeIDs=argInJson.params.episodeIds
	s episodeIDs = $CASE(episodeIDs,"":4,:episodeIDs)
	s startDateTime=argInJson.params.startDate
	s endDateTime=argInJson.params.endDate
	s authStDateTime=argInJson.params.authStartDate
	s authEndDateTime=argInJson.params.authEndDate
	s authorizedFlag=argInJson.params.authorizedFlag
	s dateGap=argInJson.params.dateGap
	s patientID=argInJson.params.patientId
	s pagesize=argInJson.params.pageSize
	s current=argInJson.params.current
	s pagesize = $CASE(pagesize,"":20,:pagesize)
	s current = $CASE(current,"":1,:current)

	s idxStart=pagesize *(current - 1) +1
	s idxLast=idxStart + pagesize -1
    s strRes = ..GetLisData(interface,episodeIDs,startDateTime,endDateTime,authStDateTime,authEndDateTime,authorizedFlag,idxStart,idxLast,patientID,dateGap,"",current,pagesize,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到检验医嘱数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       取检验项
/// Creator:    huhao
/// Createdate: 2021-7-22
/// Input:      AInterFace 调用接口标识(默认HIS)  
///             EpisodeIDs:就诊号
///             StDate:开始时间
///             EndDate:结束时间
///             AuthStDate:审核查询开始时间
///             AuthEndDate:审核查询结束时间
///             AuthorizedFlag:审核标识,0为本次就诊未审核;1为本次就诊审核;2为该患者最新两次就诊所有,目前仅HISUI门诊页面提供
///             StartPage:返回分页开始页号
///             EndPage:返回分页结束页号
///             PatientID:病人PatientID
///             DateGap:就诊日期间隔,例如90天,目前仅门诊页面提供
///             AdmType:本次就诊类型,用于标识是否为门诊
/// Output:     EpisodeDate:就诊日期,DeptDesc:就诊科室,OEordItemRowID:医嘱ID,OEordItemDesc:医嘱名称,LabEpisodeNo:标本号,
///             SpecimenDesc:标本类型,CollectionDate:标本采集日期,CollectionTime:标本采集时间,ReceiveDate:标本接收日期,
///             ReceiveTime:标本接收时间,AuthorisationDate:标本审核日期,AuthorisationTime:标本审核时间,
///             ExistReport:是否有报告(Y:存在，N:不存在)
/// Debug：     w ##Class(EMRservice.Ajax.lisData).GetLisData("HIS","4","","","","","",1,10)
ClassMethod GetLisData(AInterFace As %String, EpisodeIDs As %String, StDate As %String, EndDate As %String, AuthStDate As %String = "", AuthEndDate As %String = "", AuthorizedFlag As %String = "", StartPage As %Integer, EndPage As %Integer, PatientID As %String = "", DateGap As %String = "", AdmType As %String = "", Current As %String, PageSize As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json = ""
	s result = ""
	s TotalCount = 0
	s count = 0
	s:(AuthorizedFlag =2) EpisodeIDs = ..GetEpisodeIdsByPatientId(PatientID,AuthorizedFlag)
	s:(AdmType = "O")&&(DateGap '= "") EpisodeIDs = ..GetEpisodeIdsByPatientId(PatientID,"",DateGap)
	q:(EpisodeIDs = "") "{""total"":0,""rows"":["_json_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMRLisData(key)
	///审核时间查询条件的格式转换
	s:(AuthStDate'="") AuthStDate = $zdh(AuthStDate,3)
	s:(AuthEndDate'="") AuthEndDate= $zdh(AuthEndDate,3)
	s length = $l(EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)
		s IsPreInPatient = $p($g(^PAADM(episodeId,"DHC")),"^",56)
		if (IsPreInPatient = "Y")
		{
			s tmpStDate = $Case(StDate,"":$p($g(^PAADM(episodeId)),"^",34),:$zdh(StDate,3))
			s tmpEndDate = $p($h,",",1)
		}
		else
		{
			s tmpStDate = $Case(StDate,"":$p($g(^PAADM(episodeId)),"^",6),:$zdh(StDate,3))
		
			//检查的开始时间取建住院证的时间，南大二附院个性化修改
			s stDateType = ..GetResourceStartDate()
			if (stDateType = "Y")
			{
				s patientId = $p($g(^PAADM(episodeId)),"^",1)
				s bookId = $o(^DHCDocIPBK(0,"PatientID",patientId,""))
				s bookStDate = $p($g(^DHCDocIPBK(bookId)),"^",10)
				s tmpStDate = bookStDate
			}
			s tmpEndDate = $Case(EndDate,"":$P($G(^PAADM(episodeId)),"^",17),:$zdh(EndDate,3))
		}
		s:(tmpEndDate = "") tmpEndDate = $p($h,",",1)
		s episodeDate = $ZD($p($g(^PAADM(episodeId)),"^",6),3)	 	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		
		if (AInterFace = "HIS")
		{
			s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (AInterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLLisData:GetLisDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)		
		}
		elseif (AInterFace = "HSBToHis")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		///若审核时间查询条件为当天
		if (AuthStDate'="")&&(AuthStDate=AuthEndDate)
		{
		While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:($zdh(ds.Data("AuthorisationDate"),3)'=AuthStDate)
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///若审核时间查询条件为三天或一周
		elseif(AuthStDate'="")&&(AuthStDate'=AuthEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("AuthorisationDate")=""
				continue:'(($zdh(ds.Data("AuthorisationDate"),3)>=AuthStDate)&&($zdh(ds.Data("AuthorisationDate"),3)<=AuthEndDate))
				s TotalCount = TotalCount + 1 
				d setJson
			 }
		}
		///若审核时间查询条件为本次就诊
		elseif(AuthorizedFlag = 1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")'="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///未审核
		elseif(AuthorizedFlag = 0)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("AuthorisationDate")="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}else
		{
			while (ds.Next())
			{
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
	}
	
	//倒序排序输出
	s jsonArrUser = ##class(%DynamicArray).%New()
	s msgObj = ##class(%DynamicObject).%New() //存储list内的键值
	s LisAuthDate="",j=0,i=1
	for
	{
		s LisAuthDate = $o(^TempEMRLisData(key,LisAuthDate),-1)
		q:(LisAuthDate="")
		s LisAuthTime=""
		for
		{
			s LisAuthTime = $o(^TempEMRLisData(key,LisAuthDate,LisAuthTime),-1)
			q:(LisAuthTime = "")
			s order = ""
			for {
				s order = $o(^TempEMRLisData(key,LisAuthDate,LisAuthTime,order))
				q:(order = "")
				if ((StartPage <= i)&(i <= EndPage))
				{
					s:(j'=0) result = result_","
					s result = result_$g(^TempEMRLisData(key,LisAuthDate,LisAuthTime,order))
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRLisData(key)
	s result = "{""list"":["_result_"],""total"":"_TotalCount_","_"""current"":"_Current_",""pageSize"":"_PageSize_"}"
	s result = $ZSTRIP(result,"*C")
	
	s finalJson = ##class(%DynamicObject).%FromJSON(result)
	d finalJson.%ToJSON(argOutData)


	q "1"
setJson
	s json = json_"{"
	s json = json_"""episodeDate"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""","
	s json = json_"""episodeID"":"""_episodeId_""","
	s json = json_"""deptDesc"":"""_deptDesc_""","
	s json = json_"""oEordItemRowID"":"""_ds.Data("OEordItemRowID")_"""," 
	s json = json_"""oEordItemDesc"":"""_ds.Data("OEordItemDesc")_"""," 
	s json = json_"""labEpisodeNo"":"""_ds.Data("LabEpisodeNo")_""","
	s json = json_"""specimenDesc"":"""_ds.Data("SpecimenDesc")_""","
	s json = json_"""collectionDate"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("CollectionDate"))_""","
	s json = json_"""collectionTime"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("CollectionTime"))_""","
	s json = json_"""receiveDate"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("ReceiveDate"))_""","
	s json = json_"""receiveTime"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("ReceiveTime"))_""","
	s json = json_"""authorisationDate"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("AuthorisationDate"))_""","
	s json = json_"""authorisationTime"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("AuthorisationTime"))_""","
	s:($g(ds.Data("ReportURL"))) json = json_"""ReportURL"":""<a href='"_ds.Data("ReportURL")_"' target='_balnk' style='scrollbars=0,resizable=0;width=300;'>影像报告</a>"","
	s json = json_"""existReport"":"""_ds.Data("ExistReport")_""""
	s json = json_"}"
	if (ds.Data("AuthorisationDate") '= "")
	{
		s AuthDate = ##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("AuthorisationDate"))
	}
	else
	{
		s AuthDate = "00000"
	}
	if (##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("AuthorisationTime")) '= "")
	{
		s AuthTime = ##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",ds.Data("AuthorisationTime"))
	}
	else
	{
		s AuthTime = "00000"
	}
	s ^TempEMRLisData(key,AuthDate,AuthTime,count) = json
	s json = ""
	s count = count + 1
	q
}

/// Desc:       根据Anum、AdateGap获取患者的就诊IDs
/// Creator:    Lina
/// CreateDate: 2019-03-19
/// Input:      ApatientId 患者号
///             Anum 获取最近几次就诊
///             AdateGap 就诊日期间隔,例如90天
/// OutPut:     episodeIDs 患者就诊IDs,用逗号分隔
/// Debug:      w ##Class(EMRservice.Ajax.hisData).GetEpisodeIdsByPatientId(20,2,"90")
ClassMethod GetEpisodeIdsByPatientId(ApatientId As %String, Anum As %Integer = "", AdateGap As %String = "") As %String
{
	s episodeIDs = ""
	s count = 0
	q:(ApatientId = "") episodeIDs
	if (AdateGap '= "") {
		//取指定日期
		s Systemdatetime = $HOROLOG
		s Systemdateint = $p(Systemdatetime,",",1)
		if (AdateGap = "currentWeek") {
			s weekDay = $zd(Systemdateint,10)
			if (weekDay=0) {
				s StartDate = Systemdateint-6
				s EndDate = Systemdateint
			} else {
				s StartDate = Systemdateint-(weekDay-1)
				s EndDate = Systemdateint+(7-weekDay)
			}
		}elseif (AdateGap = "1") {
			s StartDate = Systemdateint-1
			s EndDate = Systemdateint+1
		}else {
			s StartDate = Systemdateint+1-AdateGap
			s EndDate = Systemdateint
		}
	}
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(ApatientId,"","")
	While (ds.Next()) {
		s date = $zdh(ds.Data("EpisodeDate"),3)
		q:(AdateGap '= "")&&((date < StartDate) || (date > EndDate))
		s episodeIDs = $Case(episodeIDs,"":ds.Data("EpisodeID"),:episodeIDs_","_ds.Data("EpisodeID"))
		s count = count + 1
		q:(Anum '= "")&&(Anum = count)
	}
	q episodeIDs
}

/// 资源区检查、检验接口的开始时间是否为建住院证日期，南大二附院个性化修改
/// Output：返回"Y"  按建住院证时间取
///         默认返回"N"  按就诊时间取
/// w ##Class(EMRservice.SystemParameter).GetResourceStartDate()
ClassMethod GetResourceStartDate() As %String
{
	//q "Y" //检查、检验接口的开始时间取建住院证的时间，南大二附院个性化修改
	q "N" //检查、检验接口的开始时间取就诊的时间
}

/// Desc:       获取检验子数据
/// Creator:    huhao
/// CreateDate: 2021-07-19
/// Input:      argInJson  	命令参数{"action":"GET_SUBLISDATA","params":{"oeordId":"17||3","interface":"HIS","episodeId":"19","labEpisodeNo":"1000003705","current":1,"pageSize":20},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetSonDataList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s AInterFace=argInJson.params.interface
	s AInterFace = $CASE(AInterFace,"":"HIS",:AInterFace)
    s EpisodeID=argInJson.params.episodeId
    s OeordID=argInJson.params.oeordId
    s LabEpisodeNo=argInJson.params.LabEpisodeNo
    s current=argInJson.params.current
    s current = $CASE(current,"":1,:current)
    s pagesize=argInJson.params.pageSize
    s pagesize = $CASE(pagesize,"":20,:pagesize)

    s strRes = ..GetSubLis(AInterFace,EpisodeID,OeordID,LabEpisodeNo,current,pagesize,.argOutData)

	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到检验结果数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       取检验子项
/// Creator:    huhao
/// Createdate: 2021-7-19
/// Input:      AInterFace 调用接口标识(默认HIS)  
///            	医嘱OeordID
/// OutPut:     ItemDesc:描述,Synonym:英文缩写,ItemResult:结果,ItemUnit:单位,AbnorFlag:异常标记,ItemRanges:范围值
/// debug:      d ##Class(EMRservice.Ajax.lisData).GetSubLis("HIS",174,"53||26")
ClassMethod GetSubLis(AInterFace As %String, EpisodeID As %String, OeordID As %String, LabEpisodeNo As %String, current As %String, pageSzie As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json = ""
	s result = ""
	s count = 0
	q:(OeordID = "") "{""total"":0,""list"":["_json_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMRLisData(key)
	if (AInterFace = "HIS")
	{
		s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectReportByOeordID")
		d ds.Execute(OeordID)
	}
	elseif (AInterFace = "数据平台")
	{
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLLisData:GetLisDataDetial")
		d ds.Execute(EpisodeID,"","",OeordID)	
	}
	elseif (AInterFace = "HSBToHis")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISReportByOeordID")
		d ds.Execute(OeordID)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
	
	While (ds.Next())
	{
		s itemDesc = ..JsonEscape(ds.Data("ItemDesc"))
		s itemResult = ..JsonEscape(ds.Data("ItemResult"))
		s abnorFlag=""
		if ((ds.Data("AbnorFlag")="高")||(ds.Data("AbnorFlag")="H"))
		{
			s abnorFlag="↑"
		}
		elseif ((ds.Data("AbnorFlag")="低")||(ds.Data("AbnorFlag")="L"))
		{
			s abnorFlag="↓"
		}
		elseif ((ds.Data("AbnorFlag")="A"))
		{
			s abnorFlag="A"
		}
		s itemUnit = ds.Data("ItemUnit")
		s itemUnitFw = $e(itemUnit,0,1)
		s itemUnit = $case(itemUnitFw,"*":"×","×":"×",:"")_itemUnit
		
		s detailData = "[]"
		if (AInterFace = "数据平台")
		{
			s detailData = $g(ds.Data("DetailData"),"[]")
		}
		else
		{
			if (($g(ds.Data("ResultDR")) '= ""))
			{
				s detailData = ..GetQryAntResult(ds.Data("ResultDR"))
			}
		}
		
		s json = json_"{"
		s json = json_"""oeordID"":"""_OeordID_""","
		s json = json_"""labEpisodeNo"":"""_LabEpisodeNo_""","
		s json = json_"""episodeID"":"""_EpisodeID_""","
		s json = json_"""itemDesc"":"""_itemDesc_""","
		s json = json_"""synonym"":"""_$case(ds.Data("Synonym"),"":itemDesc,:ds.Data("Synonym"))_""","  
		s json = json_"""itemResult"":"""_itemResult_"""," 
		s json = json_"""itemUnit"":"""_itemUnit_"""," 
		s json = json_"""abnorFlag"":"""_abnorFlag_"""," 
		s json = json_"""itemRanges"":"""_ds.Data("ItemRanges")_"""," 
		s json = json_"""reportDR"":"""_$g(ds.Data("ResultDR"))_""","  
		s json = json_"""detailData"":"_detailData_"" 
		s json = json_"}"
		s Sequence = $g(ds.Data("Sequence"))
		s:(Sequence = "") Sequence = 0
		s ^TempEMRLisData(key,Sequence,count) = json
		s json = ""
		s count = count + 1
	}
	s LisSequence="",j=0
	for
	{
		s LisSequence = $o(^TempEMRLisData(key,LisSequence))
		q:(LisSequence="")
		s order = ""
		for {
			s order = $o(^TempEMRLisData(key,LisSequence,order))
			q:(order = "")
			s:(j'=0) result = result_","
			s result = result_^TempEMRLisData(key,LisSequence,order)
			s j = j + 1
		}
	}
	k ^TempEMRLisData(key)
	
	
	s result = "{""list"":["_result_"],""total"":"_count_","_"""current"":"_current_",""pageSize"":"_pageSzie_"}"
	s result = $ZSTRIP(result,"*C")
	s finalJson = ##class(%DynamicObject).%FromJSON(result)
	d finalJson.%ToJSON(argOutData)
	q "1"
}

/// Desc:       存入json前的特殊字符处理
/// Creator:    Candy
/// CreateDate: 2016-5-5  
/// Input:      AValue json项描述
/// OutPut:     result 处理好的字符串 
/// Debug:   w ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape("入院记录\现病史")
ClassMethod JsonEscape(AValue As %String)
{
		s result = AValue
		s result = $Replace(result,"\","\\")
		s result = $Replace(result,"""","\""")
		s result = $Replace(result,"\\b","\b")
		s result = $Replace(result,"\\f","\f")
		s result = $Replace(result,"\\n","\n")
		s result = $Replace(result,"\\r","\r")
		s result = $Replace(result,"\\t","\t")
		q result
}

/// Desc:       取微生物药敏结果
/// Creator:    Donglulu
/// CreateDate: 2018-9-29
/// Input:      ReportDR
/// Output:     json
/// ##Class(EMRservice.Ajax.lisData).GetQryAntResult("468")
ClassMethod GetQryAntResult(AReportDR As %String)
{
	s json = ""
	s count = 0
	q:(AReportDR = "") "{""total"":"_count_",""list"":["_json_"]}"
	s ds = ##class(%ResultSet).%New("LabService.TCResult:QryAntResult")
	d ds.Execute(AReportDR)
	s columCount = ds.GetColumnCount()
	while ds.%Next()
	{  
		s antName = ..JsonEscape($g(ds.Data("AntName"))) 
		s senName = ..JsonEscape($g(ds.Data("SenName"))) 
		s suggest = ..JsonEscape($g(ds.Data("Suggest"))) 
		s senMethod = ..JsonEscape($g(ds.Data("SenMethod")))
		s json = json_"{"
		s json = json_"""ReportDR"":"""_AReportDR_""","
		s json = json_"""AntCode"":"""_$g(ds.Data("AntCode"))_""","
		s json = json_"""AntName"":"""_antName_""","
		s json = json_"""LowRange"":"""_$g(ds.Data("LowRange"))_""","
		s json = json_"""SenCode"":"""_$g(ds.Data("SenCode"))_""","
		s json = json_"""SenName"":"""_senName_""","
		s json = json_"""Suggest"":"""_suggest_""","
		s json = json_"""SenMethod"":"""_senMethod_""""  
		s json = json_"}"
		s json = json_","
		s count = count + 1
	}
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	q "["_json_"]"
}

}
