/// 名称：EMR.OP.BL.PacsData
/// 描述：门急诊检查结果功能相关业务
/// 编写者：huhao
/// 编写日期：2021-7-19
/// 产品组：电子病历产品组
Class EMR.OP.BL.PacsData Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取检查主数据
/// Creator:    huhao
/// CreateDate: 2021-07-19
/// Input:      argArray  	命令参数 {"action":"GET_PACSDATA","params":{"interface":"HIS","episodeIds":"4","startDate":" ","endDate":" ","rrtStartDate":" ","rrtEndDate":" ","rrtedFlag":" ","patientId":" ","dateGap":" ","current":1,"pageSize":20},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetPData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s interface=argInJson.params.interface
        s interface = $CASE(interface,"":"HIS",:interface)

    s episodeIDs=argInJson.params.episodeIds
    s episodeIDs = $CASE(episodeIDs,"":4,:episodeIDs)
    s startDate=argInJson.params.startDate
    s endDate=argInJson.params.endDate
    s rrtStartDate=argInJson.params.rrtStartDate
    s rrtEndDate=argInJson.params.rrtEndDate
    s rrtedFlag=argInJson.params.rrtedFlag
    s pagesize = argInJson.params.pageSize  
    s pagesize = $CASE(pagesize,"":20,:pagesize)
    s current=argInJson.params.current
	s current = $CASE(current,"":1,:current)

    s idxStart=pagesize *(current - 1) + 1
    s idxLast= idxStart + pagesize -1

    s strRes = ..GetPacsData(interface,episodeIDs,startDate,endDate,rrtStartDate,rrtEndDate,rrtedFlag,idxStart,idxLast,"","",.argOutData)

	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","参数错误,未获取到检查医嘱数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       取检查项
/// Creator:    huhao
/// Createdate: 2021-7-27
/// Input:      AInterFace 调用接口标识(默认HIS)
///             EpisodeIDs:就诊号以","分隔
///             StDate:开始时间
///             EndDate:结束时间
///             RrtStartDate:报告开始时间
///             RrtEndDate:报告结束时间
///             RrtedFlag:报告标识
///             StartPage:返回分页开始页号
///             EndPage:返回分页结束页号
///             PatientID:病人PatientID
///             DateGap:就诊日期间隔,例如90天
/// OutPut:     EpisodeDate:就诊日期,EpisodeSection:就诊科室,EpisodeItemName:医嘱名称,OrdCreateDate:下医嘱日期,OrdCreateTime:下医嘱时间,OEOrdItemDR:医嘱ID,RptRowID:报告ID	
/// OutPut:     检查子项json
/// debug:      w ##Class(EMR.OP.BL.PacsData).GetPacsData("HIS",4,"2019-01-01","2019-12-31","","","",1,10)
ClassMethod GetPacsData(AInterFace As %String, EpisodeIDs As %String, StDate As %String, EndDate As %String, RrtStartDate As %String = "", RrtEndDate As %String = "", RrtedFlag As %String = "", StartPage As %Integer, EndPage As %Integer, PatientID As %String = "", DateGap As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json = ""
	s result = ""
	s TotalCount = 0
	s count = 0
	s:(RrtedFlag =2) EpisodeIDs = ..GetEpisodeIdsByPatientId(PatientID,RrtedFlag)
	s:(DateGap '= "") EpisodeIDs = ..GetEpisodeIdsByPatientId(PatientID,"",DateGap)
	q:(EpisodeIDs = "") "{""total"":0,""rows"":["_result_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMRPacsData(key)
	///报告时间查询条件的格式转换
	s:(RrtStartDate'="") RrtStartDate = $zdh(RrtStartDate,3)
	s:(RrtEndDate'="") RrtEndDate= $zdh(RrtEndDate,3)
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
			s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectPACSItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (AInterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPacsData:GetPacsDataList")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		elseif (AInterFace = "HSBToHis")
		{
			s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectPACSItemListByDate")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		s arcItemCatRowIDStr = ..getARCItemCatRowID()
		///若报告时间查询条件为当天
		if (RrtStartDate'="")&&(RrtStartDate=RrtEndDate)
		{
			While (ds.Next())
			{
				continue:($zdh(ds.Data("RrtDate"),3)'=RrtStartDate)
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///若报告时间查询条件为三天或一周
		elseif(RrtStartDate'="")&&(RrtStartDate'=RrtEndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("RrtDate")=""
				continue:'(($zdh(ds.Data("RrtDate"),3)>=RrtStartDate)&&($zdh(ds.Data("RrtDate"),3)<=RrtEndDate))
				s TotalCount = TotalCount + 1 
				d setJson
			 }
		}
		///若报告时间查询条件为本次就诊
		elseif(RrtedFlag =1)
		{
			While (ds.Next())
			{
				continue:'(ds.Data("RrtDate")'="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		elseif(RrtedFlag =0)
		{
			///未报告
			While (ds.Next())
			{
				continue:'(ds.Data("RrtDate")="")
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}else
		{
			///所有医嘱
			while (ds.Next())
			{
				 s TotalCount = TotalCount + 1 
				 d setJson
			}
		}
	}
	
	//倒序排序输出
	s PacsRrtDate="",j=0,i=1
	for
	{
		s PacsRrtDate = $o(^TempEMRPacsData(key,PacsRrtDate),-1)
		q:(PacsRrtDate="")
		s PacsRrtTime=""
		for
		{
			s PacsRrtTime = $o(^TempEMRPacsData(key,PacsRrtDate,PacsRrtTime),-1)
			q:(PacsRrtTime = "")
			s order = ""
			for {
				s order = $o(^TempEMRPacsData(key,PacsRrtDate,PacsRrtTime,order))
				q:(order = "")
				if ((StartPage <= i)&(i <= EndPage))
				{
					s:(j'=0) result = result_","
					s result = result_^TempEMRPacsData(key,PacsRrtDate,PacsRrtTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRPacsData(key)
	s result = "{""list"":["_result_"],""total"":"_TotalCount_","_"""current"":"_1_",""pageSize"":"_"20"_"}"
	s result = $ZSTRIP(result,"*C")
	s finalJson = ##class(%DynamicObject).%FromJSON(result)
	d finalJson.%ToJSON(argOutData)
	q "1"
setJson
	s json = json_"{"
	s json = json_"""episodeDate"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""","
	s json = json_"""episodeID"":"""_episodeId_""","
	s json = json_"""deptDesc"":"""_deptDesc_""","
	s json = json_"""itemName"":"""_..JsonEscape(ds.Data("ItemName"))_"""," 
	s json = json_"""ordCreateDate"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OrdCreateDate"))_"""," 
	s json = json_"""ordCreateTime"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OrdCreateTime"))_""","
	s json = json_"""oEOrdItemDR"":"""_ds.Data("OEOrdItemDR")_""","
	s json = json_"""rptRowID"":"""_ds.Data("RptRowID")_""","
	s json = json_"""reportNo"":"""_$g(ds.Data("ReportNo"))_""","
	s json = json_"""rrtDate"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate"))_""","
	
	s OrderRowid=$p(ds.Data("OEOrdItemDR"),"||",1)
	s itemsub=$p(ds.Data("OEOrdItemDR"),"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s arcItemCatRowId = $p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	if (arcItemCatRowIDStr[arcItemCatRowId)	//如果是病理医嘱，就没有报告和图像的连接
	{
		s json = json_"""reportURL"":"""_""_""","
		s json = json_"""imageURL"":"""_""_""","
	}
	else
	{
		s ReportURL = $g(ds.Data("URL"))
		s:($g(ds.Data("RptURL")) '= "") ReportURL = $g(ds.Data("RptURL"))	s json = json_"""reportURL"":""<a onclick=reportOrImageLink('"_ReportURL_"')>报告</a>"","
		s:($g(ds.Data("ImgURL")) '= "") json = json_"""imageURL"":""<a onclick=reportOrImageLink('"_ds.Data("ImgURL")_"')>图像</a>"","
	}
	s json = json_"""rISRSysCode"":"""_$g(ds.Data("RISRSysCode"))_""","
	s json = json_"""rrtTime"":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime"))_""""
	
	s json = json_"}"
	if (##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate")) '= "")
	{
		s RrtDate = ##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("RrtDate"))
	}
	else
	{
		s RrtDate = "00000"
	}
	if (##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime")) '= "")
	{
		s RrtTime = ##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("RrtTime"))
	}
	else
	{
		s RrtTime = "00000"
	}
	s ^TempEMRPacsData(key,RrtDate,RrtTime,count) = json
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

/// Desc:  		病理科RowID,表(ARC_ItemCat)。
/// Creator:    liuyunfei
/// CreateDate: 2020-07-09
/// Input:      无
/// Output:     28^98^141
/// Debug:      w ##Class(EMRservice.SystemParameter).getARCItemCatRowID()
ClassMethod getARCItemCatRowID() As %String
{
	q "28^98^141"
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

/// Desc:       获取检查子数据
/// Creator:    
/// CreateDate: 2021-07-19
/// Input:      argArray  	命令参数 {"action":"GET_SUBPACSDATA","params":{"oeordId":"3||71","interface":"HIS","episodeId":"4","current":1,"pageSize":20},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetSubPData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s AInterFace=argInJson.params.interface
    s AInterFace = $CASE(AInterFace,"":"HIS",:AInterFace)
    s EpisodeID=argInJson.params.episodeId
    s Id=argInJson.params.oeordId
    s current=argInJson.params.current
    s current = $CASE(current,"":1,:current)
    s pagesize=argInJson.params.pageSize
    s pagesize = $CASE(pagesize,"":20,:pagesize)

    
    s strRes = ..getSubpacs(AInterFace,EpisodeID,Id,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","参数错误,未获取到检查结果数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       取检查子项
/// Creator:    huhao
/// Createdate: 2021-7-28
/// Input:      AInterFace 调用接口标识(默认HIS)
///             OEItemRowID 检查医嘱ID
/// OutPut:     ExamDesc 检查所见,strResult 诊断意见,strOrderName 检查方法
/// debug:      d ##Class(EMR.OP.BL.PacsData).getSubpacs("HIS",174,"41||73")
ClassMethod getSubpacs(AInterFace As %String, EPisodeID As %String, OEItemRowID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json = ""
	s count = 0
	q:(OEItemRowID = "") "{""total"":0,""rows"":["_json_"]}"
	
	if (AInterFace = "HIS")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCRisclinicQueryEPR:SelectReportByOeordID")
		d ds.Execute(OEItemRowID)
	}
	elseif (AInterFace = "数据平台")
	{
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPacsData:GetPacsDataList")
		d ds.Execute(EPisodeID,"","",OEItemRowID)
	}
	elseif (AInterFace = "HSBToHis")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectReportByOeordID")
		d ds.Execute(OEItemRowID)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口

	While (ds.Next())
	{
		s ExamDesc = ..JsonEscape(ds.Data("ExamDesc"))
		s strResult = ..JsonEscape(ds.Data("strResult"))
		s strOrderName = ..JsonEscape(ds.Data("strOrderName"))
		s ExamDesc = ..HtmlEscape(ExamDesc)
		s strResult = ..HtmlEscape(strResult)
		s strOrderName = ..HtmlEscape(strOrderName)
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""oEItemRowID"":"""_OEItemRowID_""","
		s json = json_"""examDesc"":"""_ExamDesc_""","
		s json = json_"""strResult"":"""_strResult_"""," 
		s json = json_"""strOrderName"":"""_strOrderName_"""" 
		s json = json_"}"
		s count = count + 1
	}
	;s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = "{""list"":["_json_"],""total"":"_count_","_"""current"":"_1_",""pageSize"":"_20_"}"
	s json = $ZSTRIP(json,"*C")
	s fJson = ##class(%DynamicObject).%FromJSON(json)
	d fJson.%ToJSON(argOutData)
	q "1"
}

/// Desc:       处理HTML不合法字符串
/// Creator:    Donglulu
/// CreateDate: 2017-8-4  
/// Input:      AValue 字符串描述
/// OutPut:     result 处理好的字符串 
/// Debug:   w ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape("入院记录\现病史")
ClassMethod HtmlEscape(AValue As %String)
{
		s result = AValue
		s result = $Replace(result,"<","&lt")
		s result = $Replace(result,">","&gt")
		s result = $Replace(result,"＜","&lt")
		s result = $Replace(result,"＞","&gt")
		q result
}

}
