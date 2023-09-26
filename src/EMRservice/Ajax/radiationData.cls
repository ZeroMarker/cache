/// 名称：		EMRservice.Ajax.radiationData
/// 描述：		获取放疗数据
/// 编写者：	yejian
/// 编写时间：	2021-10-30
Class EMRservice.Ajax.radiationData Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
 	s Id = $Get(%request.Data("ID",1),"")
 	s startDateTime = $Get(%request.Data("StartDateTime",1),"")
 	s endDateTime = $Get(%request.Data("EndDateTime",1),"")
 	///authStDateTime、authEndDateTime是按审核日期查询的始末条件
 	//s authStDateTime = $Get(%request.Data("AuthStartDateTime",1),"")
 	//s authEndDateTime = $Get(%request.Data("EndDateTime",1),"")
 	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s labEpisodeNo = $Get(%request.Data("LabEpisodeNo",1),"")
	s userID = $g(%session.Data("LOGON.USERID"))
	s ID = $Get(%request.Data("ID",1),"")
	s OEordItemDesc = $Get(%request.Data("OEordItemDesc",1),"")
	if (action = "GetRadiationData")
	{
		s patientID = $Get(%request.Data("PatientID",1),"")
		s dateGap = $Get(%request.Data("DateGap",1),"")
		s length = $l(episodeId,",")
		s admType = ""
		s:(episodeId '= "")&&(length = 1) admType = $p($g(^PAADM(episodeId)),"^",2)
 		w ..GetRadiationData(interface,episodeId,startDateTime,endDateTime,idxStart,idxLast,patientID,dateGap,admType)
	}
	elseif (action = "InputReferenceDataLog")
	{
		//w ##Class(EMRservice.BL.BLLisdataReference).AddLisdataReferenceData(episodeId,userID,ID,OEordItemDesc)
	}	
	Quit $$$OK
}

/// Desc:       取放疗数据
/// Creator:    yejian
/// Createdate: 2021-10-29
/// Input:      AInterFace 调用接口标识(默认HIS)
///             EpisodeIDs:就诊号
///             StDate:开始时间
///             EndDate:结束时间
///             StartPage:返回分页开始页号
///             EndPage:返回分页结束页号
///             PatientID:病人PatientID
///             DateGap:就诊日期间隔,例如90天,目前仅门诊页面提供
///             AdmType:本次就诊类型,用于标识是否为门诊
/// Output:     CommitDate:放疗医嘱提交时间,Diagnos:诊断,Course:疗程,Position:部位,Radiotherapyed:已放疗测试,
///             TotalNum:总次数,FractionalDose:分次计量,PrescriptionDose:处方剂量,StartDate:开始日期,
///             EndDate:最后日期,EpisodeID:就诊号,ID:唯一id,
///             w ##Class(EMRservice.Ajax.radiationData).GetRadiationData("数据平台","4","2021-11-1","2021-11-1",1,10)
ClassMethod GetRadiationData(AInterFace As %String, EpisodeIDs As %String, StDate As %String, EndDate As %String, StartPage As %Integer, EndPage As %Integer, PatientID As %String = "", DateGap As %String = "", AdmType As %String = "") As %String
{
	s json = ""
	s result = ""
	s TotalCount = 0
	s count = 0
	q:(EpisodeIDs = "") "{""total"":0,""rows"":["_json_"]}"
	s:(AdmType = "O")&&(DateGap '= "") EpisodeIDs = ##Class(EMRservice.Ajax.radiationData).GetEpisodeIdsByPatientId(PatientID,"",DateGap)
	s key = $i(^CacheTemp)
	k ^TempEMRRadiationData(key)
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
			s tmpEndDate = $Case(EndDate,"":$P($G(^PAADM(episodeId)),"^",17),:$zdh(EndDate,3))
		}
		s:(tmpEndDate = "") tmpEndDate = $p($h,",",1)
		s episodeDate = $ZD($p($g(^PAADM(episodeId)),"^",6),3)	 	
		s deptId = $p(^PAADM(episodeId),"^",4)
		s deptDesc = $Case(deptId,"":"",:$p(^CTLOC(deptId),"^",2))
		s:($f(deptDesc,"-") '= 0) deptDesc = $p(deptDesc,"-",2)
		
		if (AInterFace = "HIS")
		{
		}
		elseif (AInterFace = "数据平台")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLRadiationData:GetRadiationDatas")
			d ds.Execute(episodeId,tmpStDate,tmpEndDate)		
		}
		///若审核时间查询条件为当天
		if (StDate'="")&&(StDate=EndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("CommitDate")=""
				continue:($zdh(ds.Data("CommitDate"),3)'=StDate)
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
		///若审核时间查询条件为三天或一周
		elseif(StDate'="")&&(StDate'=EndDate)
		{
			While (ds.Next())
			{
				continue:ds.Data("CommitDate")=""
				continue:'(($zdh(ds.Data("CommitDate"),3)>=StDate)&&($zdh(ds.Data("CommitDate"),3)<=EndDate))
				s TotalCount = TotalCount + 1 
				d setJson
			 }
		}
		else
		{
			while (ds.Next())
			{
				s TotalCount = TotalCount + 1 
				d setJson
			}
		}
	}
	
	//倒序排序输出
	s LisAuthDate="",j=0,i=1
	for
	{
		s LisAuthDate = $o(^TempEMRRadiationData(key,LisAuthDate),-1)
		q:(LisAuthDate="")
		s LisAuthTime=""
		for
		{
			s LisAuthTime = $o(^TempEMRRadiationData(key,LisAuthDate,LisAuthTime),-1)
			q:(LisAuthTime = "")
			s order = ""
			for {
				s order = $o(^TempEMRRadiationData(key,LisAuthDate,LisAuthTime,order))
				q:(order = "")
				if ((StartPage <= i)&(i <= EndPage))
				{
					s:(j'=0) result = result_","
					s result = result_^TempEMRRadiationData(key,LisAuthDate,LisAuthTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRRadiationData(key)
	s result = "{""total"":"_TotalCount_",""rows"":["_result_"]}"
	s result = $ZSTRIP(result,"*C")
	q result
	q
setJson
	s json = json_"{"
	s comDate = ds.Data("CommitDate")
	//s json = json_"""CommitDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("CommitDate"))_""","
	s json = json_"""CommitDate"":"""_comDate_""","
	s json = json_"""Diagnos"":"""_ds.Data("Diagnos")_""","
	s json = json_"""Course"":"""_ds.Data("Course")_""","
	s json = json_"""Position"":"""_ds.Data("Position")_"""," 
	s json = json_"""Radiotherapyed"":"""_ds.Data("Radiotherapyed")_"""," 
	s json = json_"""TotalNum"":"""_ds.Data("TotalNum")_""","
	s json = json_"""FractionalDose"":"""_ds.Data("FractionalDose")_""","
	s json = json_"""RadiationDose"":"""_$g(ds.Data("RadiationDose"))_""","
	s json = json_"""PrescriptionDose"":"""_$g(ds.Data("PrescriptionDose"))_""","
	s json = json_"""StartDate"":"""_ds.Data("StartDate")_""","
	s json = json_"""EndDate"":"""_ds.Data("EndDate")_""","
	s json = json_"""EpisodeID"":"""_$g(ds.Data("EpisodeID"))_""","
	s json = json_"""ID"":"""_$g(ds.Data("ID"))_""""
	s json = json_"}"
	
	s AuthDate = "00000"
	s AuthTime = "00000"
	if (comDate'="")&&(comDate[" ")
	{
		s strDate = $p(comDate," ",1)
		s strTime = $p(comDate," ",2)
		if (##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",strDate) '= "")
		{
			s AuthDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",strDate)
		}
		if (##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",strTime) '= "")
		{
			s AuthTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",strTime)
		}
	}
	s ^TempEMRRadiationData(key,AuthDate,AuthTime,count) = json
	s json = ""
	s count = count + 1
	q
}

/// Desc:       根据Anum、AdateGap获取患者的就诊IDs
/// Creator:    yejian
/// CreateDate: 2019-03-19
/// Input:      ApatientId 患者号
///             Anum 获取最近几次就诊
///             AdateGap 就诊日期间隔,例如90天
/// OutPut:     episodeIDs 患者就诊IDs,用逗号分隔
/// Debug:      w ##Class(EMRservice.Ajax.radiationData).GetEpisodeIdsByPatientId(20,2,"90")
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

}
