/// 病历分配
Class EPRservice.Quality.Ajax.Assign Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	// 分配人ID
	s AssignUser = $Get(%request.Data("AssignUser",1),"")
	s LastAssignDate= $Get(%request.Data("LastAssignDate",1),"")
	s method=$Get(%request.Data("method",1),"")
	s docStr = $Get(%request.Data("docStr",1),"")
	s admStr = $Get(%request.Data("admStr",1),"")
	s doAssignDates= $Get(%request.Data("doAssignDates",1),"")
	s userID = $Get(%request.Data("userID",1),"")
	s QualityFlag = $Get(%request.Data("QualityFlag",1),"")
	s range=$Get(%request.Data("range",1),"")
	s problemFlag=$Get(%request.Data("problemFlag",1),"")
	s assignDoctors=$Get(%request.Data("assignDoctors",1),"")
	s assignDates=$Get(%request.Data("assignDates",1),"") 
	
	s StartDate=$Get(%request.Data("StartDate",1),"") //质控员查询界面出院日期（起始）
	s EndDate=$Get(%request.Data("EndDate",1),"") //质控员查询界面出院日期（截止）
	s AssignDates=$Get(%request.Data("AssignDates",1),"") //质控员查询界面分配日期段
	s regNo=$Get(%request.Data("regNo",1),"")
	
	
	s status=$Get(%request.Data("status",1),"")  //分发(Y)或者撤回(N)病历
	  
	//AdmType
	s AdmType=$Get(%request.Data("AdmType",1),"")
	//s ^temp("wei")=QualityFlag
	
	
	
	s userList=$Get(%request.Data("userList",1),"")
	s admList=$Get(%request.Data("admList",1),"") 
	
	if (method="CrossAssign")
	{
		//分配
		w ..Assign(AdmType,"",admList)
		Quit $$$OK	
	}
	
	if (method="appointAssign")
	{
		//指定分配
		w ..Assign(AdmType,userList,admList)
		Quit $$$OK	
	}
	
	if (method="reAssign")
	{
		//转分配
		w ..Assign(AdmType,userList,admList,method)
		Quit $$$OK	
	}
	
	if (method="GetHistoryAssignInfo")
	{
		//分配历史
		w ..GetAssignHistory(LastAssignDate,AdmType)
		Quit $$$OK
	}
	
	if (method="DoAssignInfo")
	{
		//分发或者撤回,取决于status的值，Y即分发，N即撤回
		//s:admStr["/" admStr=$e(admStr,1,*-1)
		
		w ..AssignConfirm(admStr,status)  
		Quit $$$OK
	}
	
	if (method="GetAssignInfoByUserId")
	{
		w ..GetAssignInfoByUserId(userID,QualityFlag,range)
		
		Quit $$$OK
	}
	
	if (method="GetProblemPat")
	{
		w ..GetProblemPat(assignDoctors,assignDates,problemFlag)
		Quit $$$OK
	}
	
	Quit $$$OK
}

/// 分配逻辑，可以做系统分配(method="")、指定分配(method="")，转分配(method="reAssign")等操作
/// AdmType 范围即（门诊 AO、环节 IA、终末病历 CQC）的分配, UserName = "" 分配医师系统分配时不需指定，指定分配时需设置  , AdmList = "" 就诊号的字符串集合以“/”分隔，系统分配时不需指定, method = ""，即分配方式，（指定、系统，转分）
/// debug:w ##class(EPRservice.Quality.Ajax.Assign).Assign("ID","","","")
ClassMethod Assign(AdmType, UserName = "", AdmList = "", method = "") As %String
{
	s result = "",addInfo=""
	
	s AdmList=$replace(AdmList,",","^")
	
	s AdmList=..GetAdmList(AdmList)
	
	// 向抽查表中。开始添加数据
	TSTART
	if UserName=""
	{
		s addInfo = ##Class(EPRservice.Quality.DataAccess.AssignInfo).AddAssignInfo(AdmType,AdmList,1)  //系统分配病历	
	}else
	{
		if method=""
		{
			s addInfo = ##Class(EPRservice.Quality.DataAccess.AssignInfo).AddAppointAssignInfo(AdmList,UserName,AdmType)  //指定分配病历	
		}elseif (method="reAssign")
		{
			s addInfo=##Class(EPRservice.Quality.DataAccess.AssignInfo).UpdateMedDoc(UserName,AdmList)  //批量更新质控医师
		}
		
	}	
	
	s result=addInfo
	
	//s ^temp("wei")=result
	
	//更新质控医师不需要添加到抽查信息表
	if method="reAssign"
	{
		if (result'["成功"){
			TROLLBACK
		}else{
			TCOMMIT
		}
		q result
	}
	
	//向抽查信息表中添加本次抽查数据
	
	//s ^temp("result")=result
	
	q:(result'["成功") result
	
	s addExtractInfo=##Class(EPRservice.Quality.DataAccess.ExtractInfo).addExtractInfo()
	
	s result=addExtractInfo
	
	if (result'["成功"){
		TROLLBACK
	}else{
		TCOMMIT
	}
	
	q result
}

/// 分发或者撤回病历 status=Y 分发  status=N 撤回
/// admStr 就诊号列表以“/“ 分割  status 即操作的类型
/// debug: w ##class(EPRservice.Quality.Ajax.Assign).AssignConfirm(17,"Y")
ClassMethod AssignConfirm(admStr, status) As %String
{
	s ret="操作失败",errFlag=0
	
	s operate="分发"
	s:(status="N") operate="撤回"
	
	q:(admStr="")||(status="") ret
	
	//先将本分配时间段的数据设置有效
	for i=1:1:$l(admStr,"/")
	{
		s episodeID=$p(admStr,"/",i)
		
		s upDateStatus=##Class(EPRservice.Quality.DataAccess.CrossAssignInfo).ChangeAssignStatus(episodeID,status)
		if (upDateStatus'="操作成功")
		{
			s errFlag=1
			q
		}	
	}
	
	q:(errFlag=1) ret
	
	s:(errFlag=0) ret=operate_"操作成功"
	
	q ret
}

/// 根据分配时间查询分配数据
/// DateGap 分配时间（2021-03-27----2021-03-30）传2021-03-30 即可  AdmType 即 病历类型 O 门诊病历  IA 环节病历  ID 终末病历
/// debug:w ##class(EPRservice.Quality.Ajax.Assign).GetAssignHistory("2021-03-30","ID")
ClassMethod GetAssignHistory(DateGap, AdmType) As %String
{
	s json = ""
		// 查询该分配日期段的所有抽查患者
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.AssignInfo:GetAssignInfoByLastDate")
	 	d result.Execute(DateGap,AdmType)
	 	
	 	s count = 0
		While (result.Next())
	 	{
			s:(count '=0) json =json_","
			s json = json_"{"
		 	s json = json_"""RegNo"":"""_$g(result.Data("RegNo"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""DischDate"":"""_$g(result.Data("DischDate"))_""","
		 	s json = json_"""ResidentDays"":"""_$g(result.Data("ResidentDays"))_""","
		 	s json = json_"""MedName"":"""_$g(result.Data("MedName"))_""","
		 	s json = json_"""PAADMRowID"":"""_$g(result.Data("PAADMRowID"))_""","
			s json = json_"""IsActive"":"""_$g(result.Data("IsActive"))_""","
			s json = json_"""crossCheckFlag"":"""_$g(result.Data("crossCheckFlag"))_""","
		 	s MainDiagnos=$g(result.Data("MainDiagnos"))
		 	s MainDiagnos=$tr(MainDiagnos,"\","") //去除转义符
		 	s json = json_"""MainDiagnos"":"""_MainDiagnos_""""
		 	s json = json_"}"
			s count = count + 1		
		}
	
		s json = "{""total"":"_count_",""rows"":["_json_"]}"
	
		q json
}

/// debbug : w ##class(EPRservice.Quality.Ajax.Assign).GetAssignInfoByUserId(22489, "N")
ClassMethod GetAssignInfoByUserId(UserID, IsChecked, Range) As %String
{
	s json = ""
	
		// 查询该质控医师名下所有抽查患者
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.AssignInfo:GetAssignInfoByUserId")
	 	d result.Execute(UserID,IsChecked,Range)
	 	
	 	s count = 0
	 	//ChargeDoc,RegNo,PAPMIName,EpisodeID,CheckedFlag,Grade,Score,ResidentDays,checked,ProblemFlag,MedicareNo,Age,PAPMISex,Illness,TransLocFlag,AdmDateTime,CreateOutUser,MainDiagnos,PAAdmDocName,BedNo
		While (result.Next())
	 	{
			s:(count '=0) json =json_","
			s json = json_"{"
		 	s json = json_"""ChargeDoc"":"""_$g(result.Data("ChargeDoc"))_""","
		 	s json = json_"""RegNo"":"""_$g(result.Data("RegNo"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	s json = json_"""CheckedFlag"":"""_$g(result.Data("CheckedFlag"))_""","
		 	s json = json_"""Grade"":"""_$g(result.Data("Grade"))_""","
		 	s json = json_"""checked"":"""_$g(result.Data("checked"))_""","
		 	s json = json_"""Score"":"""_$g(result.Data("Score"))_""","
		 	
		 	s json = json_"""ProblemFlag"":"""_$g(result.Data("ProblemFlag"))_""","
		 	s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
		 	s json = json_"""Age"":"""_$g(result.Data("Age"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""Illness"":"""_$g(result.Data("Illness"))_""","
		 	s json = json_"""TransLocFlag"":"""_$g(result.Data("TransLocFlag"))_""","
		 	s json = json_"""AdmDateTime"":"""_$g(result.Data("AdmDateTime"))_""","
		 	s json = json_"""CreateOutUser"":"""_$g(result.Data("CreateOutUser"))_""","
		 	
		 	s json = json_"""MainDiagnos"":"""_$g(result.Data("MainDiagnos"))_""","
		 	s json = json_"""PAAdmDocName"":"""_$g(result.Data("PAAdmDocName"))_""","
		 	s json = json_"""BedNo"":"""_$g(result.Data("BedNo"))_""","
		 	
		 	s json = json_"""ResidentDays"":"""_$g(result.Data("ResidentDays"))_""""
		 	s json = json_"}"
		 	//s json = $tr(json,$c(10),"")
			//s json = $tr(json,$c(13),"")
			s count = count + 1		
		}
	
		s json = "{""total"":"_count_",""rows"":["_json_"]}"
	
		q json
}

ClassMethod GetProblemPat() As %String
{
	s json = ""
	
		// 查询该质控医师名下所有抽查患者
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.CrossAssignInfo:GeCrossProblemPatList")
	 	d result.Execute(ProblemFlag,UserIDs,AssignDates)
	 	
	 	s count = 0
		While (result.Next())
	 	{
			s:(count '=0) json =json_","
			s json = json_"{"
		 	s json = json_"""AssignName"":"""_$g(result.Data("AssignName"))_""","
		 	s json = json_"""MedName"":"""_$g(result.Data("MedName"))_""","
		 	//ChargeDoc
		 	s json = json_"""ChargeDoc"":"""_$g(result.Data("ChargeDoc"))_""","
		 	//RegNo
		 	s json = json_"""RegNo"":"""_$g(result.Data("RegNo"))_""","
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	//CheckedFlag,ReviewFlag,CrossQualityDate
		 	s json = json_"""CrossQualityDate"":"""_$g(result.Data("CrossQualityDate"))_""","
		 	s json = json_"""ReviewFlag"":"""_$g(result.Data("ReviewFlag"))_""","
		 	s json = json_"""CheckedFlag"":"""_$g(result.Data("CheckedFlag"))_""","
		 	s json = json_"""Score"":"""_$g(result.Data("Score"))_""","
		 	s json = json_"""Grade"":"""_$g(result.Data("Grade"))_""","
		 	s json = json_"""signName"":"""_$g(result.Data("signName"))_""","
		 	s json = json_"""locUser"":"""_$g(result.Data("locUser"))_""","
		 	s json = json_"""ReviewScore"":"""_$g(result.Data("ReviewScore"))_""","
		 	s json = json_"""ReviewGrade"":"""_$g(result.Data("ReviewGrade"))_""","
		 	s json = json_"""ReviewQualityDate"":"""_$g(result.Data("ReviewQualityDate"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""""
		 	s json = json_"}"
		 	//s json = $tr(json,$c(10),"")
			//s json = $tr(json,$c(13),"")
			s count = count + 1		
		}
	
		s json = "{""total"":"_count_",""rows"":["_json_"]}"
	
		q json
}

/// Desc:如果AdmList="",则取从抽取的临时global中取所有数据，否则从这个AdmList中取数据
/// Input:AdmList
/// Output:PAADMRowIDList
/// Creator:wzl 2022年11月23日
/// Debug:w ##class(EPRservice.Quality.Ajax.Assign).GetAdmList(AdmList)
ClassMethod GetAdmList(AdmList)
{
	s PAADMRowIDList=""
	if (AdmList="")
	{
		//获取临时global中的就诊号
		s PAADMRowIDList = $g(^tempSelect("PAADMRowID"))
		s:(PAADMRowIDList'="") PAADMRowIDList = $e(PAADMRowIDList,1,*-1)
		s PAADMLength = $l(PAADMRowIDList,"^")
		
	}else
	{
		s PAADMRowIDList=AdmList  //如果选择了分配的病历，则按照选中的进行分配
	}
	
	q PAADMRowIDList
}

/// 清除测试数据，分配数据、抽查表数据
/// debug: d ##class(EPRservice.Quality.Ajax.Assign).killTestData()
ClassMethod killTestData()
{
	kill ^DHCEPRQ.AssignInfoD
	kill ^DHCEPRQ.AssignInfoI
	kill ^DHCEPRQ.AssignInfoS
	
	kill ^DHCEPRQ.ExtractInfoD
	kill ^DHCEPRQ.ExtractInfoI
	kill ^DHCEPRQ.ExtractInfoS
}

/// 清除测试数据，分配数据、抽查表数据
/// debug: d ##class(EPRservice.Quality.Ajax.Assign).killMedData()
ClassMethod killMedData()
{
	kill ^DHCEPRQ.MedDoctorI
	kill ^DHCEPRQ.MedDoctorD
}

}
