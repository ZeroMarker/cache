/// Descript:住院集成视图相关
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-24
/// 
Class DWR.BL.TimeLineView Extends (%RegisteredObject, %XML.Adaptor)
{

/// Descript:生成集成视图展现数据
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-24
/// Table:icare.ClinicalRepository
/// Input:<Request><admId>患者就诊id</admId></Request>
/// Output:		
/// Return：0^成功
/// w ##class(DWR.BL.TimeLineView).GenerateData("<Request><admId>67</admId></Request>")
ClassMethod GenerateData(Param As %String = "") As %String
{
	s retStr=""
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.TimeLineRequest")
    //Do reader.Rewind()
	if reader.Next(.request,.sc)
	{	  
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))	   
	}
	q:($G(admId)="") "202^就诊号不能为空!"
	s ret=##Class(icare.TimeLineService.BOIntergrateView).ExtractData(admId)
	;
	q 0
}

/// Descript:获取集成视图项目分类
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-24
/// Table:icare.TimeLineCategroy
/// Input:<Request><timeLineId>时间线表id</timeLineId></Request>
/// Output:<TimeLineCategory></TimeLineCategory>…<TimeLineCategory></TimeLineCategory>		
/// Return：0^成功
ClassMethod GetTimeLineCategory(Param As %String = "") As %String
{
	s retStr=""
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.TimeLineRequest")
    //Do reader.Rewind()
	if reader.Next(.request,.sc)
	{
	   s timeLineId=request.timeLineId
	}
	q:$G(timeLineId)="" "200^视图id不能为空!"
	;
	s lstTimeLine = ##class(%ResultSet).%New("icare.TimeLineView:GetTimeLineInfor")
	s sc = lstTimeLine.Execute(timeLineId)
	;
	While (lstTimeLine.Next()) {
		s viewType =lstTimeLine.Data("ViewType")
	   	s categroyCode =lstTimeLine.Data("CategroyCode")
	   	s categroyDesc =lstTimeLine.Data("CategroyDesc")
	   	s categroyID =lstTimeLine.Data("CategroyID")
	   	s viewConfigId = lstTimeLine.Data("ViewConfig")
	   	if $G(categroyID) '= ""
	   	{
	   		s obj=##class(icare.TimeLineCategroy).%OpenId(categroyID)
	   		if $G(obj) '= ""
	 		{
		 		s categroyDesc=obj.Description   //重新赋值，通过query取出的有可能为空
		 		s lstDataType = obj.DataTypeList
		 		s lstCount = $LISTLENGTH(lstDataType)
		 		for i=1:1:lstCount
		 		{
			 		s dataTypeCode = $LIST(lstDataType,i)			 		
			 		s objDataType=##class(icare.ClinicalDataType).%OpenId(dataTypeCode)			 		
			 		s dataTypeDesc = objDataType.Description
			 		s myObj=##class(DWR.MSG.TimeLineCategory).%New()
			 		s myObj.categoryCode=categroyCode
			 		s myObj.categoryDesc=categroyDesc
			 		s myObj.dataTypeCode=dataTypeCode
			 		s myObj.dataTypeDesc=dataTypeDesc
			 		s myObj.viewType=viewType
			 		s ret=myObj.XMLExportToString(.Xml,"TimeLineCategory")
			 		d myObj.%Close()
			 		i ret=1 s retStr=retStr_Xml			 		
		 		}
	 		}
	   }
	}
	do lstTimeLine.%Close()
	q retStr
}

/// Descript:设置某用户集成视图显示配置
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-27
/// Table:^userTimeLineConfig
/// Input:<Request><userCode>用户名</userCode><timeLineId>时间线表id</timeLineId>
/// <timeLineConfigStr>项目分类代码:项目分类明细代码:显示类型|项目分类代码:项目分类明细代码:显示类型</timeLineConfigStr></Request>
/// Output:	
/// Return：0^成功
/// w ##class(DWR.BL.TimeLineView).ConfigTimeLineCategory("<Request><userCode>demo</userCode><timeLineId>AdmView</timeLineId><timeLineConfigStr>01:0101:A|02:0202:C|02:0203:C|02:0204:C|03:0306:T|03:0301:T|03:0303:T|03:0302:T|03:0305:T|03:0304:T|04:0401:A|05:0501:A|06:0601:N|07:0701:L|19:1901:I|08:0801:L|09:0901:L|13:1301:A</timeLineConfigStr></Request>")
ClassMethod ConfigTimeLineCategory(Param As %String = "") As %String
{
	s configStr=""
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    If $$$ISERR(sc) s err= $system.Status.GetErrorText(sc) q "210^读取参数错误:"_err
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.TimeLineRequest")
    //Do reader.Rewind()
	if reader.Next(.request,.sc)
	{
		s userCode=request.userCode
	   	s timeLineId=request.timeLineId
	   	s timeLineConfigStr=request.timeLineConfigStr
	}
	
	q:$g(userCode)="" "200^用户名不能为空"
	q:$g(timeLineId)="" "201^视图id不能为空"
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),0))
	q:userId="" "202^用户名不存在"
	s configSettingName = userId_timeLineId
	s ^userTimeLineConfig(configSettingName) = $g(timeLineConfigStr)
	;
	q 0
}

/// Descript:获取某用户集成视图显示配置
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-28
/// Table:icare.TimeLineCategroy
/// Input:<Request><userCode>用户名</userCode><timeLineId>时间线表id</timeLineId></Request>
/// Output:<TimeLineCategory></TimeLineCategory>…<TimeLineCategory></TimeLineCategory>		
/// Return：0^成功
ClassMethod GetTimeLineConfig(Param As %String = "") As %String
{
	s retStr=""
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.TimeLineRequest")
    //Do reader.Rewind()
	if reader.Next(.request,.sc)
	{
		s userCode=request.userCode
	   	s timeLineId=request.timeLineId
	}
	q:$G(userCode)="" "201^用户名不能为空!"
	q:$G(timeLineId)="" "200^视图id不能为空!"
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),0))
	q:userId="" "202^用户名不存在"
	;
	s configSettingName = userId_timeLineId
	q:'$d(^userTimeLineConfig(configSettingName)) "203^没有配置显示项目"
	s configStr=^userTimeLineConfig(configSettingName) 
	s len=$l(configStr,"|")
	for i=1:1:len {
		s config=$p(configStr,"|",i)
		s categoryCode=$p(config,":",1)
		s dataTypeCode=$p(config,":",2)	
		s viewType=$p(config,":",3)	
		;
		s objCategory=##class(icare.TimeLineCategroy).%OpenId(categoryCode)
		;
		if (objCategory'=""){
			s categoryDesc=objCategory.Description
		}
		
		s objDataType=##class(icare.ClinicalDataType).%OpenId(dataTypeCode)
		if (objDataType'=""){
			s dataTypeDesc=objDataType.Description	
		}
		
		s myObj=##class(DWR.MSG.TimeLineCategory).%New()
		s myObj.categoryCode=categoryCode
		s myObj.categoryDesc=$g(categoryDesc)
		s myObj.dataTypeCode=dataTypeCode
		s myObj.dataTypeDesc=$g(dataTypeDesc)
		s myObj.viewType=viewType
		s ret=myObj.XMLExportToString(.Xml,"TimeLineCategory")
		d myObj.%Close()
		i ret=1 s retStr=retStr_Xml			 
	}
	;
	q retStr
}

/// Descript:获取集成视图显示数据
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-28
/// Table:icare.ClinicalRepository
/// Input:<Request><admId>病人id</admId><startDate>查询开始时间</startDate>
/// <timeLineConfigStr>项目分类代码:项目分类明细代码:显示类型|项目分类代码:项目分类明细代码:显示类型</timeLineConfigStr></Request>
/// Output:	
/// Return：<ViewInfo></ViewInfo>
/// w ##class(DWR.BL.TimeLineView).GetDisplayInfo("<Request><admId>67</admId><startDate></startDate><timeLineConfigStr>01:0101:A|02:0202:C|02:0203:C|02:0204:C|03:0306:T|03:0301:T|03:0303:T|03:0302:T|03:0305:T|03:0304:T|04:0401:A|05:0501:A|06:0601:N|07:0701:L|19:1901:I|08:0801:L|09:0901:L|13:1301:A</timeLineConfigStr></Request>")
ClassMethod GetDisplayInfo(Param As %String = "") As %String
{
	s retStr=""
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    If $$$ISERR(sc) s err= $system.Status.GetErrorText(sc) q "210^读取参数错误:"_err
    d reader.Correlate("Request","DWR.MSG.TimeLineRequest")
    ;
    s startDate=""
	if reader.Next(.request,.sc)
	{	
		s admId=request.admId
	   	s startDate=request.startDate
	   	s timeLineConfigStr=request.timeLineConfigStr
	}
	;
	q:$G(admId)="" "201^病人id不能为空!"
	s:+startDate=0 startDate=""
	if (startDate '="")
	{
		s sDate = $ZDATEH(startDate,3)
	}
	;
	s delim = "|"
	s index = 1
	s count =$LENGTH(timeLineConfigStr,delim)
	//取得就诊开始日期和结束日期
	s strStartAndEndDate = ##class(icare.TimeLineView).GetStartAndEndDate(admId)
	s seeDocStartDate = $p(strStartAndEndDate,"|",1)
	s seeDocEndDate = $p(strStartAndEndDate,"|",2)
	;
	//第一次显示该就诊数据时，从最后的日期开始显示数
   	if ((startDate = "")&(seeDocStartDate'=""))
   	{
	   	if ($ZDATEH(seeDocEndDate,3) > ($ZDATEH(seeDocStartDate,3)+6))
	   	{
	   		s sDate = $ZDATEH(seeDocEndDate,3)-6
	   	}
	   	else
	   	{
		   s sDate = $ZDATEH(seeDocStartDate,3)
	   	}
   	}
	s searchDate = ""
	if (sDate '= "")
	{
		s searchDate = $ZDATE(sDate,3)
	}
	//取得病人的信息
	s PatientInfo =..GetPatientInfo(admId)
	s objPatient=##class(DWR.MSG.PatientInfo).%New()
	s objPatient.admId=admId
	s objPatient.patName=$p(PatientInfo,"^",1)
	s objPatient.patSex=$p(PatientInfo,"^",2)
	s objPatient.patAge=$p(PatientInfo,"^",3)
	s objPatient.inDate=$p(PatientInfo,"^",4)
	s objPatient.departmentName=$p(PatientInfo,"^",5)
	s objPatient.mainDoctor=$p(PatientInfo,"^",6)
	;
	s objView=##class(DWR.MSG.ViewInfo).%New()
	s objView.startDate=seeDocStartDate
	s objView.endDate=seeDocEndDate
	s objView.searchDate=searchDate
	s objView.patientInfo=objPatient
	;
	FOR reps=count:-1:1
	{
      	s oneCode=$PIECE(timeLineConfigStr,delim,index)
      	s CateCode = $PIECE(oneCode,":",1)
      	s dtCode = $PIECE(oneCode,":",2)
      	s viewType = $PIECE(oneCode,":",3)
      	s objCategory=##class(DWR.MSG.ActCategoryData).%New()
      	s objCategory.categoryCode=CateCode
		s objCategory.dataTypeCode=dtCode
      	s index = index +1
      	;
	   	if (viewType = "N")
	   	{
			//取得线型显示的数据
		   	s lstLineData = ##class(%ResultSet).%New("icare.TimeLineView:GetLineDisplayData")
	   	  	s sc = lstLineData.Execute(dtCode,admId,sDate)	   	  	
	   	  	;	
	   	  	While (lstLineData.Next()) {
		   	  	;
				s objActRecord=##class(DWR.MSG.ActRecord).%New()
				s objActRecord.actDate=lstLineData.Data("startDate")
				s objActRecord.actTime=lstLineData.Data("startTime")
				s objActRecord.endDate=lstLineData.Data("endDate")
				s objActRecord.endTime=lstLineData.Data("endTime")
				s objActRecord.objId=""  ;lstLineData.Data("ObjectID")
				s objActRecord.dataValue=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLineData.Data("DataValue"))
				s objActRecord.summary=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLineData.Data("Summary"))
				do objCategory.actRecord.Insert(objActRecord)
				s objActRecord=""
	   	  	}
	   	  	s lstLineData=""
	   	  	
	   	}elseif ((viewType = "A")& ((CateCode = "04")||(CateCode = "05")))
	   	{
			//取得检查,检验连接显示的数据
		   	s lstLinkData = ##class(%ResultSet).%New("icare.TimeLineView:GetLinkDisplayData")
	   	  	s sc = lstLinkData.Execute(dtCode,admId,sDate)
	   	  	While (lstLinkData.Next()) {
		   	  	;
				s objActRecord=##class(DWR.MSG.ActRecord).%New()
				s objActRecord.actDate=lstLinkData.Data("ActDate")
				s objActRecord.actTime=lstLinkData.Data("ActTime")
				s objActRecord.dataValue=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLinkData.Data("DataValue"))
				s objActRecord.summary=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLinkData.Data("Summary"))
				s objActRecord.parameters=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLinkData.Data("Parameters"))
				s objActRecord.actDesc=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLinkData.Data("ActDesc"))
				;
		   	  	s reportObjectID = lstLinkData.Data("ObjectID")
		   	  	if reportObjectID '= ""
		   	  	{
			   	  	s lstLinkDetailData = ##class(%ResultSet).%New("icare.TimeLineView:GetLinkDisplayDetailData")
			   	  	s sc = lstLinkDetailData.Execute(dtCode,admId,reportObjectID)
			   	  	While (lstLinkDetailData.Next()) {
				   	  	s objSubAct=##class(DWR.MSG.ActRecord).%New()
				   	  	s objSubAct.actDate=lstLinkDetailData.Data("ActDate")
				   	  	s objSubAct.actTime=lstLinkDetailData.Data("ActTime")
				   	  	s objSubAct.dataValue=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLinkDetailData.Data("DataValue"))
				   	  	s objSubAct.summary=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLinkDetailData.Data("Summary"))
				   	  	s objSubAct.actDesc=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstLinkDetailData.Data("ActDesc"))
				   	  	do objActRecord.subActRecord.Insert(objSubAct)
				   	  	s objSubAct=""
			   	  	}
			   	  	s lstLinkDetailData=""
		   	  	}
		   	  	;
		   	  	do objCategory.actRecord.Insert(objActRecord)
		   	  	s objActRecord=""		   	  	
	   	  	}	   	  	
	   	  	s lstLinkData=""
	   	}else{
	      	//取得无特殊逻辑的数据
      		s lstData = ##class(%ResultSet).%New("icare.TimeLineView:GetClincalData")
	   	  	s sc = lstData.Execute(dtCode,admId,sDate)
	   	  	While (lstData.Next()) {
		   	  	;
				s objActRecord=##class(DWR.MSG.ActRecord).%New()
				s objActRecord.actDate=lstData.Data("ActDate")
				s objActRecord.actTime=lstData.Data("ActTime")
				s objActRecord.dataValue=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstData.Data("DataValue"))
				s objActRecord.summary=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstData.Data("Summary"))
				s objActRecord.parameters=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstData.Data("Parameters"))
				s objActRecord.actCode=lstData.Data("ActCode")
				s objActRecord.actDesc=##class(web.DHCExtUtil).ReplaceCharacterForJS(lstData.Data("ActDesc"))
				do objCategory.actRecord.Insert(objActRecord)
				s objActRecord=""
	   	  	}
	   	  	s lstData=""
	   	}
	   	  
	   	do objView.actCategoryData.Insert(objCategory)
   }
   
   s ret=objView.XMLExportToString(.Xml,"ViewInfo")
   s objView=""
   s objPatient=""
   q Xml
}

/// 描述: 取得病人信息
/// 入参：episodeId 就诊Id
/// w ##class(icare.TimeLineView).GetPatientInfo(41)
ClassMethod GetPatientInfo(EpisodeID As %String) As %String
{
	s delim = "^"
	s name="",sex ="",age ="",inDate ="",inDept ="",paDoctor =""

	//当前科室
	 //s curDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)
	 //s curDept = $P(curDept,"^",3)
	 s curDept =##class(icare.TimeLineCommon).CurrentDept(EpisodeID)
	 
	///主治医生
	s mainDoc = ##class(icare.TimeLineCommon).MainDoc(EpisodeID)
	//s mainDoc =##class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(EpisodeID)
	//s mainDoc = $P(mainDoc,"^",3)
	//s docid=$P($g(^PAADM(EpisodeID)),"^",9) ;^CTPCP({CTPCP_RowId}) 
	//i docid'="" s paDoctor=$P($g(^CTPCP(docid,1)),"^",1)_"^"_$P($g(^CTPCP(docid,1)),"^",2)

	///入院日期 
	//s argadmDateTime=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
	//s AdmDate=$p($g(argadmDateTime),",",1)  ;///前面的日期后面的是时间
	s AdmDate=##class(icare.TimeLineCommon).AdmDateTime(EpisodeID)
	s inDate=$zd(AdmDate,3)

	//s PapmiDR=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	s PapmiDR=##class(icare.TimeLineCommon).GetPapmiDR(EpisodeID)
	//s name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	s name= ##class(icare.TimeLineCommon).Name(PapmiDR)
	//s sex=##Class(EPRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR)
	s sex=##class(icare.TimeLineCommon).Gender(PapmiDR)
	if ((sex '= "") & $LENGTH(sex,delim) >0) s sex = $PIECE(sex,delim,3)

	//s ArgBirthday=##Class(EPRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
	//s age = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(EpisodeID,ArgBirthday,AdmDate,1)
	s ArgBirthday = ##class(icare.TimeLineCommon).Birthday(PapmiDR)
	s age = ##class(icare.TimeLineCommon).Age(EpisodeID,ArgBirthday,AdmDate)
	
	//if ((inDept '= "") & $LENGTH(inDept,delim) >0) s inDept = $PIECE(inDept,delim,2)
	//if ((paDoctor '= "") & $LENGTH(paDoctor,delim) >0) s paDoctor = $PIECE(paDoctor,delim,2)

	s result = name_"^"_sex_"^"_age_"^"_inDate_"^"_curDept_"^"_mainDoc
	quit result
}

/// 描述: 
/// d ##class(icare.TimeLineView).GetSeeDocDateList(33)
/// 入参：PatientId 病人Id
/// Descript:取得病人就诊日期列表
/// Creater:	ZhangDongmei
/// CreateDate:	2013-05-31
/// Table:
/// Input:<Request><patientId>病人id</patientId></Request>
/// Output:	
/// Return：<SeeDoctorRecord></SeeDoctorRecord>…<SeeDoctorRecord></SeeDoctorRecord>
/// w ##class(DWR.BL.TimeLineView).GetSeeDocDateList(1)
ClassMethod GetSeeDocDateList(PatientId As %String) As %String
{
	s retStr=""
	s ind = 1
	//取得该病人的就诊列表
	s lstEpisode = ##class(%ResultSet).%New("EPRservice.browser.BOEpisodeInfo:GetPatientList")
	s sc = lstEpisode.Execute(PatientId,"I","")
	//根据就诊ID生成数据
	While (lstEpisode.Next()) {
		s mDate = lstEpisode.Data("AdmDate")
		s mTime = lstEpisode.Data("AdmTime")
		s mEpisodeID = lstEpisode.Data("EpisodeID")
		s EpisodeTemSort(mDate,mTime,ind) = mEpisodeID
		s ind = ind +1
		
	}
	;
	s lstEpisode=""
	//对就诊列表按时间排序
	s dateKey = $o(EpisodeTemSort(""))
	s timeKey = ""
	s nextKey = ""
	;
	while dateKey '= ""
	{
		s timeKey = $o(EpisodeTemSort(dateKey,timeKey))
		while timeKey '=""
		{
			s nextKey = $o(EpisodeTemSort(dateKey,timeKey,nextKey))
			while nextKey '=""
			{
				s episodeID = EpisodeTemSort(dateKey,timeKey,nextKey)
				s objSeeDoctorRecord=##class(DWR.MSG.SeeDoctorRecord).%New()
				s objSeeDoctorRecord.admDate=$ZDATE(dateKey,3)
				s objSeeDoctorRecord.admId=episodeID
				s objSeeDoctorRecord.admType="I"
				s ret=objSeeDoctorRecord.XMLExportToString(.Xml,"SeeDoctorRecord")
				i ret=1 s retStr=retStr_Xml	
				;
				s objSeeDoctorRecord=""
				s nextKey = $o(EpisodeTemSort(dateKey,timeKey,nextKey))
			}
			s nextKey = ""
			s timeKey = $o(EpisodeTemSort(dateKey,timeKey))
		}
		s dateKey = $o(EpisodeTemSort(dateKey))
		s timeKey = ""
		s nextKey = ""
	}
	;
	k EpisodeTemSort
	;
	s lstOutEpisode = ##class(%ResultSet).%New("EPRservice.browser.BOEpisodeInfo:GetPatientList")
	s sc = lstOutEpisode.Execute(PatientId,"O","")
	if (lstOutEpisode.Next())
	{
		s outEpisodeID = lstOutEpisode.Data("EpisodeID")
		s objSeeDoctorRecord=##class(DWR.MSG.SeeDoctorRecord).%New()
		s objSeeDoctorRecord.admId=outEpisodeID
		s objSeeDoctorRecord.admType="O"
		s ret=objSeeDoctorRecord.XMLExportToString(.Xml,"SeeDoctorRecord")
		i ret=1 s retStr=retStr_Xml
		s objSeeDoctorRecord=""
	}
	s lstOutEpisode=""
	q retStr
}

}
