/// 名称:	EMR.DOC.BL.HisData
/// 描述:	HIS数据相关业务
/// 编写者:	yejian
/// 编写日期:2022-10-12
/// 产品组:	电子病历产品组
Class EMR.DOC.BL.HisData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据住院获取就诊列表
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_ALLEPISODEIDBYPATIENTID","params":{"patientID":"8"}}
/// 			patientID 住院号 	
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllEpisodeIDByPID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s product=argInJson.product
    s patientID=argInJson.params.patientID
	s LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.HisData).GetAllEpisodeIDByPIDJson(product,patientID,LangID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据住院获取就诊列表
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///             aPatientID 住院号
/// OutPut:    	argOutData    返回数据
/// Retrun: 	失败 -1^错误信息，成功 就诊列表
/// debug:     	d ##Class(EMR.DOC.BL.HisData).GetSubPacsJson()
ClassMethod GetAllEpisodeIDByPIDJson(aProduct As %String, aPatientID As %String, aLangID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	q:(aPatientID = "") "-1^住院号不能为空"
	;s resJson = ##class(%DynamicArray).%New()
	s strData =""
	s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(aPatientID,"","",aProduct,aLangID)
	While (ds.Next())
	{
		s aEpisodeID = ds.Data("EpisodeID")
		s:(aEpisodeID'="") strData = $case(strData,"":aEpisodeID,:strData_","_aEpisodeID)
		
	}
	s strData=""""_strData_""""
	d argOutData.Write(strData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       取患者就诊列表
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_EPISODE_LIST","params":{"patientID":"174","queryItem":"","episodeType":"","startDate":"","endDate":"","selUserID":"","selCTHospID":"","page":1,"rows":10},"product":"OP"}
/// 			patientID 住院号,queryItem 查询条件,episodeType 就诊类型，startDate 就诊起始日期，endDate 就诊结束日期，
/// 			selUserID 查询用户ID，selCTHospID 查询院区ID，page:当前页，rows:每页行数
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetEpisodeList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s product=argInJson.product
    s patientID=argInJson.params.patientID
    s queryItem=argInJson.params.queryItem
    s episodeType=argInJson.params.episodeType
    s startDate=argInJson.params.startDate
    s endDate=argInJson.params.endDate
    s selUserID=argInJson.params.selUserID
    s selCTHospID = argInJson.params.selCTHospID
    s page = argInJson.params.page  
    s rows=argInJson.params.rows
    s LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    ;s:(page="") page=1,rows=20
    s:(page'="") idxStart = rows * (page -1) + 1
	s:(page'="") idxLast = idxStart + rows -1	
	
    s strRes = ##Class(EMR.DOC.BL.HisData).GetEpisodeListJson(patientID,queryItem,episodeType,idxStart,idxLast,startDate,endDate,selUserID,selCTHospID,LangID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	;q argOutMessage.success = ..#OK
	  	q ..SetOutMessage(argOutMessage,"","",-1)
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       取患者就诊列表
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///             aPatientID 住院号
/// 			aQueryItem 查询条件
/// 			aEpisodeType 就诊类型 
/// 			aStartDate 就诊起始日期 
/// 			aEndDate 就诊结束日期，
/// 			aSelUserID 查询用户ID 
/// 			aSelCTHospID 查询院区ID	
/// 			aIdxStart 分页起始
/// 			aIdxLast 分页结束
/// OutPut:    	argOutData    返回数据
/// Retrun: 	失败 -1^错误信息，成功 就诊列表
/// debug:     	d ##Class(EMR.DOC.BL.HisData).GetSubPacsJson()
ClassMethod GetEpisodeListJson(aPatientID As %String, aQueryItem As %String, aEpisodeType As %String, aIdxStart As %Integer, aIdxLast As %Integer, aStartDate As %String = "", aEndDate As %String = "", aSelUserID As %String = "", aSelCTHospID As %String = "", aLangID As %String = "20", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	s json = ""
	s jsonRes ={"total":0,"rows":[]}
	s count = 0
	if (aPatientID = "")
	{ 
		d jsonRes.%ToJSON(argOutData)
		q "1"
	}
	s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(aPatientID,aQueryItem,aEpisodeType,aLangID)
	//按照输入的日期进行筛选输出 add by niucaicai 2017-11-16
	s dateFlag = 0
	if (aStartDate '= "")&&(aEndDate '= "")
	{
		s aStartDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",aStartDate)
		s aEndDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",aEndDate)
		s startDate = aStartDate
		s endDate = aEndDate
		s dateFlag = 1
	}
	While (ds.Next())
	{
		//按照输入的日期进行筛选输出 add by niucaicai 2017-11-16
		if (dateFlag = 1)
		{
			s EpisodeDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("EpisodeDate"))
			continue:((EpisodeDate < startDate)||(EpisodeDate > endDate))
        }
        //医生筛选
        if (aSelUserID '= "")
        {
            s docDR = $p($g(^SSU("SSUSR",aSelUserID)),"^",14)
            s mainDoc = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).MainDoc(ds.Data("EpisodeID"),aLangID)
            s mainDocDR = $P(mainDoc, "^", 1)
            continue:(docDR '= mainDocDR)
        }
        if (aSelCTHospID '= "")
        {
            //就诊科室所在医院
            s admHospitalID = $p($g(^CTLOC(ds.Data("EpisodeDeptID"))),"^",22)
            continue:((aSelCTHospID '= "")&&(aSelCTHospID '= admHospitalID))
		}
		if (((aIdxStart-1)<= count) && (aIdxLast > count))||((aIdxStart="")&&(aIdxLast=""))
		{
			s json = json_"{"
			s json = json_"""EpisodeID"":"""_ds.Data("EpisodeID")_""","
			s json = json_"""MedicareNo"":"""_ds.Data("MedicareNo")_""","
			//add by lina 2017-08-24
			s episodeDate=##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("EpisodeDate"))
			s episodeTime=##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("EpisodeTime"))
			s json = json_"""EpisodeDate"":"""_episodeDate_""","
			s json = json_"""EpisodeTime"":"""_episodeTime_""","
			//对于诊断中的单引号，这里输出已经使用了双引号，不会引起问题，直接输出单引号即可
			s json = json_"""Diagnosis"":"""_$tr(ds.Data("Diagnosis"),"\'","'")_""","
			s json = json_"""EpisodeType"":"""_ds.Data("EpisodeType")_""","			
			s json = json_"""EpisodeDeptDesc"":"""_ds.Data("EpisodeDeptDesc")_"""," 
			s json = json_"""EpisodeDeptID"":"""_ds.Data("EpisodeDeptID")_""","
			s json = json_"""MainDocName"":"""_ds.Data("MainDocName")_"""," 
			s json = json_"""DischargeDate"":"""_ds.Data("DischargeDate")_""","
			s json = json_"""AdmSequence"":"""_"第"_ds.Data("AdmSequence")_"次"_""","
			s json = json_"""EpisodeReason"":"""_ds.Data("EpisodeReason")_""","	
            s json = json_"""MrAdm"":"""_ds.Data("MrAdm")_"""," 
            s json = json_"""HospitalDesc"":"""_ds.Data("HospitalDesc")_""""  
			s json = json_"}"
			s json = json_","
		}
		s count = count + 1
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	s jsonRes = ##class(%DynamicObject).%FromJSON(json)
	d jsonRes.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       获取医嘱分类
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_ORDTYPE"}
/// 			patientID 住院号 	
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOrdType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s product=argInJson.product
	s aType = "2"
    s strRes = ##Class(EMR.DOC.BL.HisData).GetOrdTypeJson(product,aType,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
		;q ..SetOutMessage(argOutMessage,"","",-1)
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取医嘱分类
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///             aType 2
/// OutPut:    	argOutData    返回数据
/// Retrun: 	失败 -1^错误信息，成功 就诊列表
/// debug:     	d ##Class(EMR.DOC.BL.HisData).GetSubPacsJson()
ClassMethod GetOrdTypeJson(aProduct As %String, aType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	s strData =##class(web.DHCAPPSeePatPacs).GetOrdType(aType)
	if (strData'="")
	{
		d argOutData.Write(strData)
	}
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

}
