Class EMRservice.Ajax.hisData Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s patientId = $Get(%request.Data("PatientID",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s queryItem = $Get(%request.Data("QueryItem",1),"")
	s episodeType = $Get(%request.Data("EpisodeType",1),"")
	s locContain = $Get(%request.Data("LocContain",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
 	s page = $g(%request.Data("page",1),"1")
	s rows = $g(%request.Data("rows",1),"10")
	if ((page = -1)&&(rows = -1))
	{
		s idxStart = ""
		s idxLast = ""
	}
	else
	{
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1	
	}		
	if (action = "GetEpisodeList")
	{
        s selUserID = $Get(%request.Data("SelUserID",1),"")
        s selCTHospID = $Get(%request.Data("SelCTHospID",1),"")
        s json = ..GetEpisodeList(patientId,queryItem,episodeType,idxStart,idxLast,startDate,endDate,selUserID,selCTHospID)
		w json
	}
	elseif(action = "GetCTLocList")
	{
		d ..DicList(locContain)
	}
	elseif(action = "GetAllEpisodeIdByPatientId")
	{
		s json = ..GetAllEpisodeIdByPatientId(patientId)
		w json
	}elseif(action="GetDicList"){
		s episodeId = $Get(%request.Data("EpisodeID",1),"")
		s pageType=$g(%request.Data("PageType",1),"current")
		s dicCode=$g(%request.Data("DicCode",1),"")
		s loadType=$g(%request.Data("LoadType",1),"")
		s condition =$g(%request.Data("Condition",1),"")
		s conditionType=$g(%request.Data("ConditionType",1),"")
		s json = ..GetDicList(dicCode,episodeId,patientId,condition,page,rows,conditionType,pageType,loadType)	
		w json
	}
	Quit $$$OK
}

/// Desc:       取患者就诊列表
/// Creator:    Candy
/// CreateDate: 2014-8-19
/// Input:      ApatientId 患者号
/// OutPut:     json 患者就诊信息
/// Debug:      w ##Class(EMRservice.Ajax.hisData).GetEpisodeList(5407653,"","",1,10)
ClassMethod GetEpisodeList(ApatientId As %String, AQueryItem As %String, AEpisodeType As %String, AIdxStart As %Integer, AIdxLast As %Integer, AStartDate As %String = "", AEndDate As %String = "", ASelUserID As %String = "", ASelCTHospID As %String = "") As %String
{
	s json = ""
	s count = 0
	q:(ApatientId = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(ApatientId,AQueryItem,AEpisodeType)
	//按照输入的日期进行筛选输出 add by niucaicai 2017-11-16
	s dateFlag = 0
	if (AStartDate '= "")&&(AEndDate '= "")
	{
		s AStartDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AStartDate)
		s AEndDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AEndDate)
		s startDate = AStartDate
		s endDate = AEndDate
		s dateFlag = 1
	}
	
	While (ds.Next())
	{
		//按照输入的日期进行筛选输出 add by niucaicai 2017-11-16
		if (dateFlag = 1)
		{
			s EpisodeDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("EpisodeDate"))
			continue:((EpisodeDate < startDate)||(EpisodeDate > endDate))
        }
        //医生筛选
        if (ASelUserID '= "")
        {
            s docDR = $p($g(^SSU("SSUSR",ASelUserID)),"^",14)
            s mainDoc = ##Class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(ds.Data("EpisodeID"))
            s mainDocDR = $P(mainDoc, "^", 1)
            continue:(docDR '= mainDocDR)
        }
        if (ASelCTHospID '= "")
        {
            //就诊科室所在医院
            s admHospitalID = $p($g(^CTLOC(ds.Data("EpisodeDeptID"))),"^",22)
            continue:((ASelCTHospID '= "")&&(ASelCTHospID '= admHospitalID))
		}
		if (((AIdxStart-1)<= count) && (AIdxLast > count))||((AIdxStart="")&&(AIdxLast=""))
		{
			s json = json_"{"
			s json = json_"""EpisodeID"":"""_ds.Data("EpisodeID")_""","
			s json = json_"""MedicareNo"":"""_ds.Data("MedicareNo")_""","
			//add by lina 2017-08-24
			s episodeDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("EpisodeDate"))
			s episodeTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("EpisodeTime"))
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
	q json
}

/// 科室
/// Debug:d ##Class(EMRservice.Ajax.hisData).DicList()
ClassMethod DicList(aContain As %String = "")
{
	s hospitalID= $Get(%session.Data("LOGON.HOSPID"))
    s showShareHospital=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
    
	s json = ""
	s count = 0
	//s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLEMROrganSchemeLoc:SelectAllLocRowId")
	if (aContain = "")
	{
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLEMROrganSchemeLoc:SelectLocRowIdInE")
		d ds.Execute()
	}
	else
	{
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLEMROrganSchemeLoc:SelectContainLocRowIdInE")
		d ds.Execute(aContain)
	}
	
	While (ds.Next())
	{
		//Set DepGroupDr=+$p($g(^CTLOC(+ds.Data("Code"))),"^",19)   // 部门组 CTLOC_Dep_DR
		//Continue:(DepGroupDr'=1)&&(DepGroupDr'=5)
		
		//科室所在医院
		s locHospitalID = $p($g(^CTLOC($Replace(ds.Data("Code"),"\","\\"))),"^",22)
		continue:((hospitalID'="")&&(hospitalID'=locHospitalID)&&(showShareHospital="N"))
        
	   	 s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""Id"":"""_$Replace(ds.Data("Code"),"\","\\")_""","
		s json = json_"""Text"":"""_$Replace(ds.Data("Des"),"\","\\")_""""			
		s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	w json
}

/// 科室
/// Debug:d ##Class(EMRservice.Ajax.hisData).GetLocListbyType("内","E")
ClassMethod GetLocListbyType(AText As %String, AType As %String, AHospitalID As %String) As %String
{

	s hospitalID = ""
	if (AHospitalID = "")
	{
		s hospitalID= $Get(%session.Data("LOGON.HOSPID"))
	}
	else
	{
		s hospitalID = AHospitalID
	}
    s showShareHospital=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
    	
	s json = ""
	s count = 0
	s rowId = ""
	for
	{
		s rowId = $o(^CTLOC(0,"LocType",$zcvt(AType,"U"),rowId))
		q:(rowId = "")
		s code = $p(^CTLOC(rowId),"^",1)
		s desc = $p(^CTLOC(rowId),"^",2)
		
		//科室所在医院
		s locHospitalID = $p($g(^CTLOC(rowId)),"^",22)
		continue:((hospitalID'="")&&(hospitalID'=locHospitalID)&&(showShareHospital="N"))
       
       
		//增加按拼音检索
		//continue:((AText '= "")&&($zcvt(desc,"U")'[ $zcvt(AText,"U")))
		s DescNotInCond=0
		s PYNotInCond=0
		
		s:((AText '= "")&&($zcvt(desc,"U")[ $zcvt(AText,"U"))) DescNotInCond = 1	
		s InitialOfDescPY=##class(web.DHCINSUPort).GetCNCODE(desc,4,"")
		s:($zcvt(InitialOfDescPY,"U")[$zcvt(AText,"U")) PYNotInCond=1
		
		continue:((DescNotInCond=0)&&(PYNotInCond=0))
		
	    s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""Id"":"""_rowId_""","
		s json = json_"""Code"":"""_code_""","
		s json = json_"""Text"":"""_desc_""""			
		s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       取患者的所有就诊ID
/// Creator:    Lina
/// CreateDate: 2017-01-23
/// Input:      ApatientId 患者号
/// OutPut:     json 患者的所有就诊ID
/// Debug:      w ##Class(EMRservice.Ajax.hisData).GetAllEpisodeIdByPatientId(265)
ClassMethod GetAllEpisodeIdByPatientId(ApatientId As %String) As %String
{
	s json = ""
	s count = 0
	q:(ApatientId = "") json
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(ApatientId,"","")
	While (ds.Next())
	{
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""EpisodeID"":"""_ds.Data("EpisodeID")_""""
		s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
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

/// desc:通过字典取数据
/// input:ADicCode 字典代码
///       AEpisodeID
///       APatientID
///      Condition 查询条件
///      ApageNum  当前页码
///      ApageSize 当前页数据长度
///      AConditionType 检索类型 LeftMatch，左匹配；PerfectMatch，精确匹配；FuzzyMatch，模糊匹配
///      APageType 加载数据方式 all 所有数据  current 当前页数据
///      ALoadType  加载工具 combogrid  combobox
/// debug: w ##class(EMRservice.Ajax.hisData).GetDicList("s10","",1,10,"True",0,"","","","all","combobox")
ClassMethod GetDicList(ADicCode As %String, AEpisodeID As %String, APatientID As %String, Condition As %String, ApageNum As %Integer, ApageSize As %Integer, AConditionType As %String = "", APageType As %String = "current", ALoadType As %String = "combobox")
{
	s json=""
	s count = 0
	S SessionId=$I(^CacheTemp)
   	K ^CacheTempStdQuery(SessionId)
   	//带默认条件的查询
   	if ((Condition=""))
	{	   
	}
	
	s DefaultCondition=""
	s ConditionKeyWord =##Class(EMRservice.BL.BLStdDictionary).getConditionByStdCode(ADicCode)
	if (ConditionKeyWord'="")
	{
	    if (ConditionKeyWord="{CTLocID}")
	    {
		    s DefaultCondition=%session.Get("LOGON.CTLOCID")
	    }
	    elseif (ConditionKeyWord="{UserID}")
	    {
		    s DefaultCondition=%session.Get("LOGON.USERID")
	    }
	    elseif (ConditionKeyWord="{PatientID}")
	    {
		    
		    s:((APatientID="")&(AEpisodeID'="")) APatientID=$p($g(^PAADM(episodeID)),"^",1)
		    s DefaultCondition=APatientID
	    }
	    elseif (ConditionKeyWord="{EpisodeID}")
	    {
		    s DefaultCondition=AEpisodeID
	    }
	    elseif (ConditionKeyWord="{SsgroupID}")
	    {
		    s DefaultCondition=%session.Get("LOGON.GROUPID")
	    }
		elseif (ConditionKeyWord="{HospitalID}")
	    {
		    
		    s DefaultCondition=$Get(%session.Data("LOGON.HOSPID"))
	    }
	}
   	//取查询条件
    s ConditionCode =##Class(EMRservice.BL.BLStdDictionary).SelectConditionByStdCode(ADicCode)
 
   	//生成字典查询结果集，并存储在临时global中
   	s PageCount= ##class(EMRservice.BL.BLStdDictionary).SelectNewStdDicPageCount(ADicCode,Condition,ApageNum,ApageSize,SessionId,ConditionCode,DefaultCondition,AConditionType)
   	s TotalRowCount = $G(^CacheTempStdQuery(SessionId,"StdQueryDataCount"))
   	s:$ZCVT(APageType,"U")="ALL" ApageNum=1
   	s:$ZCVT(APageType,"U")="ALL" ApageSize=TotalRowCount
	s Result = ##class(%ResultSet).%New("EMRservice.BL.BLStdDictionary:GetStdDicOrList")
    d Result.Execute(ADicCode,Condition,ApageNum,ApageSize,SessionId)	
   
    	if ($g(Result) '= "")
		{
	 		while(Result.Next())
	 		{
		 		s count = count + 1
		 		s:(count > 1) json=json_","
				s json=json_"{"
				s json=json_..TrimEnter("""Id"":"""_$g(Result.Data("ID"))_""",")
				s json=json_..TrimEnter("""Alias"":"""_$g(Result.Data("DicAlias"))_""",")
		 		s json=json_..TrimEnter("""Code"":"""_$g(Result.Data("DicCode"))_""",")
				s json=json_..TrimEnter("""Text"":"""_$g(Result.Data("DicDesc"))_"""")
				s json=json_"}"	
			}
		} 
		
	if ($ZCVT(ALoadType,"D")="combobox"){ 
		s json = "["_json_"]"
    }elseif ($ZCVT(ALoadType,"D")="combogrid"){
		s json= "{""rows"":["_json_"],""total"":"_TotalRowCount_"}" 
	}
    s json = $ZSTRIP(json,"*C")
	q json
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// Desc:      医生数据
/// Input:     AText       筛选描述(医生名字or医生名字简拼)
/// Output:    UserID      医生ID
///            UserCode    医生Code
///            UserName    医生名字
///            JaneSpell   医生名字简拼
/// Debug:     w ##Class(EMRservice.Ajax.hisData).getDoctorList("张兵")
///            w ##Class(EMRservice.Ajax.hisData).getDoctorList("zb")
ClassMethod getDoctorList(AText As %String = "") As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    s langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s allDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","全部医师")
    s janeSpell = ##class(EMRservice.Tools.Tool).GetCNCODE(allDesc,4,"")
    //增加“全部”选项
    d json.Write("[")
    d:(AText = "") json.Write("{""UserID"":"""",""UserCode"":"""",""UserName"":"""_allDesc_""",""JaneSpell"":"""_janeSpell_""",""selected"":true}")
    
    s rowId = 0, tempJson = ""
    for {
        s rowId = $o(^SSU("SSUSR",rowId))
        q:(rowId = "")
        s docDR = $p($g(^SSU("SSUSR",rowId)),"^",14)
        continue:(docDR = "")
        s doctorflag = $p($g(^CTPCP(docDR,1)),"^",13)
        continue:(doctorflag'="1")&&(doctorflag'="2")&&(doctorflag'="3")&&(doctorflag'="4")&&(doctorflag'="5")&&(doctorflag'="21")&&(doctorflag'="22")
        s codeValue = $p($g(^SSU("SSUSR",rowId)),"^",1)
        s descValue = $p($g(^SSU("SSUSR",rowId)),"^",2)
        s:(descValue '= "") descValue = $tr(descValue," ","")
        s descValue = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",descValue,langid)
        s aliasValue = ##class(EMRservice.Tools.Tool).GetCNCODE(descValue,4,"")
        if (AText '= ""){
            s descFlag = ##Class(EMRservice.Utility).CheckContain($zcvt(descValue,"U"), $zcvt(AText,"U"), "")
            s aliasFlag = ##Class(EMRservice.Utility).CheckContain($zcvt(aliasValue,"U"), $zcvt(AText,"U"), "")
            continue:(descFlag '= 1)&&(aliasFlag '= 1)
        }
        s:((AText = "")||(tempJson '= "")) tempJson = tempJson_","
        s tempJson = tempJson_"{""UserID"":"""_rowId_""","
        s tempJson = tempJson_"""UserCode"":"""_codeValue_""","
        s tempJson = tempJson_"""UserName"":"""_descValue_""","
        s tempJson = tempJson_"""JaneSpell"":"""_aliasValue_"""}"
    }
    s:(tempJson '= "") tempJson = $ZSTRIP(tempJson,"*C")
    d json.Write(tempJson)
    d json.Write("]")
    q json
}

/// Desc:      院区数据
/// Table:     CT_Hospital
/// Output:    HOSPRowId   院区RowId
///            HOSPCode    院区CODE
///            HOSPDesc    院区描述
///            JaneSpell   院区描述简拼
/// Debug:     w ##Class(EMRservice.Ajax.hisData).getCTHospList()
ClassMethod getCTHospList() As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    s langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s allDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","全部院区")
    s janeSpell = ##class(EMRservice.Tools.Tool).GetCNCODE(allDesc,4,"")
    //增加“全部”选项
    d json.Write("[{""HOSPRowID"":"""",""HOSPCode"":"""",""HOSPDesc"":"""_allDesc_""",""JaneSpell"":"""_janeSpell_""",""selected"":true}")
    
    s rowId = 0, tempJson = ""
    for {
        s rowId = $o(^CT("HOSP",rowId))
        q:(rowId = "")
        s codeValue = $p(^CT("HOSP",rowId),"^",1)
        s descValue = $p(^CT("HOSP",rowId),"^",2)
        s:(descValue '= "") descValue = $tr(descValue," ","")
        s descValue = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.CTHospital","HOSPDesc",descValue,langid)
        s aliasValue = ##class(EMRservice.Tools.Tool).GetCNCODE(descValue,4,"")
        s tempJson = tempJson_","
        s tempJson = tempJson_"{""HOSPRowID"":"""_rowId_""","
        s tempJson = tempJson_"""HOSPCode"":"""_codeValue_""","
        s tempJson = tempJson_"""HOSPDesc"":"""_descValue_""","
        s tempJson = tempJson_"""JaneSpell"":"""_aliasValue_"""}"
    }
    s:(tempJson '= "") tempJson = $ZSTRIP(tempJson,"*C")
    d json.Write(tempJson)
    d json.Write("]")
    q json
}

}
