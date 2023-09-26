/// 名称:	EMR.DOC.HISInterface.EpisodeInfo
/// 描述:	HIS中的就诊信息接口
/// 编写者：yejian
/// 编写日期: 2022-10-13
/// 产品组：电子病历产品组
Class EMR.DOC.HISInterface.EpisodeInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：       yejian
/// CreateDate：    2022-10-13
/// Description:：  查询患者的就诊信息
/// Table：         PA_ADM
/// Input：         APatientID 病人APatientID
/// 				aProductCode 项目标识
/// Output：		EpisodeID 就诊号
///        		    EpisodeDate:就诊日期
///                 DeptDesc:就诊科室
///         		MainDocName:就诊医生
///         		EpisodeType:就诊类型
///         		EpisodeReason:病人类型
///         		DischargeDate:出院日期
///         		Diagnosis:诊断
///                 HospitalDesc:院区
/// Debug：			d ##class(%ResultSet).RunQuery("EMR.DOC.HISInterface.EpisodeInfo","GetEpisodeListByPID","8","","O")
Query GetEpisodeListByPID(APatientID As %String, ADiagnosis As %String = "", AEpisodeType As %String = "", aProductCode As %String, aLangID As %String = "20", ASequence As %String = "-1") As %Query(ROWSPEC = "EpisodeID:%String,EpisodeDate:%String,EpisodeTime:%String,EpisodeDeptID:%String,EpisodeDeptDesc:%String,MainDocName:%String,EpisodeType:%String,EpisodeReason:%String,DischargeDate:%String,Diagnosis:%String,AdmSequence:%String,MedicareNo:%String,MrAdm:%String,HospitalDesc:%String")
{
}

ClassMethod GetEpisodeListByPIDExecute(ByRef qHandle As %Binary, APatientID As %String, ADiagnosis As %String = "", AEpisodeType As %String = "", aProductCode As %String, aLangID As %String = "20", ASequence As %String = "-1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s aProductCode ="OP"
 	q:(APatientID="") $$$OK
 	s key = $I(^CacheTemp)
	k ^TempEMRBrowser(key)
 	s AdmSequence = 0
	set typeRowID = "0" 
	for {
	 	set typeRowID = $o(^PAPERdr(APatientID,"ADM",typeRowID))
	 	q:(typeRowID = "")
	 	
	 	set episodeID = ""
	 	for {
		 	s episodeID = $o(^PAPERdr(APatientID,"ADM",typeRowID,episodeID))
		 	q:(episodeID = "")
		 	
		 	set VisitStatus = $p($g(^PAADM(episodeID)),"^",20)
		 	continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息 
		 	
		 	
		 	s episodeDateTime=##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
		 	s (episodeDate,episodeTime)=""
		 	if (episodeDateTime'="")
		 	{
		 		s episodeDate = $p($g(episodeDateTime),",",1)	
		 		s episodeTime = $p($g(episodeDateTime),",",2)	
		 	}
		 	else
		 	{
			 	//兼容预住院患者，标准接口无日期
		 		s episodeDate = $p($g(^PAADM(episodeID)),"^",6)	
		 		s episodeTime = $p($g(^PAADM(episodeID)),"^",7)	
		 	}
			 

			set episodeDept = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(episodeID)		
			set episodeDeptID = $p(episodeDept,"^",1)
			set episodeDeptDesc = $p(episodeDept,"^",3)
			s episodeDeptDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans",episodeDeptDesc)
			
			///按照用户登录的医院信息，过滤患者数据
			s LocID=##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
			s hospitalID=$piece($get(^CTLOC($p(LocID,"^",1))),"^",22)
			s showShareHospital=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ShowShareHospital",aProductCode,"N")
			//科室所在医院
			s locHospitalID = $p($g(^CTLOC(episodeDeptID)),"^",22)
			continue:((hospitalID'="")&&(hospitalID'=locHospitalID)&&(showShareHospital="N"))
       
            s hospitalDesc = $p(^CT("HOSP",locHospitalID),"^",2)
			s hospitalDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans",hospitalDesc)
			
			set mainDoc = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).MainDoc(episodeID,aLangID)
			set mainDocName = $P(mainDoc, "^", 3) 
			
			//取患者病案号
			s MedicareNo = ""
			s patientID = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)

			s Hospital=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",aProductCode)
			// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
		 	s IPRecordNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
		 	
		 	// 门诊病案号		[OPRecordNo]		PA_Person.PAPER_GovernCardNo
		 	s OPRecordNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
		 	
		 	// 急诊病案号		[EPRecordNo]		DHC_Person.PAPER_FCMedicareCode1
		 	s EPRecordNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
		 	
		 	//依据患者类型，返回病案号
		 	s AdmType=$p(^PAADM(episodeID),"^",2)
			s MedicareNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
			
			
			set episodeType= $p(^PAADM(episodeID),"^",2)
			
			//住院数据范围：预住院+住院
			//预住院数据范围：预住院
			if (AEpisodeType '= "")
			{
				if $l(AEpisodeType) = 2
				{
					s argEpisodeType= $e(AEpisodeType,1)
					s argEpisodeVisitStatus =$e(AEpisodeType,2)
					continue:((argEpisodeType'=episodeType)||(argEpisodeVisitStatus'=VisitStatus))	
				}
				else
				{
					continue:(episodeType '= AEpisodeType)
				}
			}
			
			if episodeType="I" Set episodeType= ##class(EMR.DOC.COM.Translation).Get("EMRTrans","住院")
			if ((episodeType="I")&&(VisitStatus="P")) Set episodeType= ##class(EMR.DOC.COM.Translation).Get("EMRTrans","预住院")
	        if episodeType="O" Set episodeType= ##class(EMR.DOC.COM.Translation).Get("EMRTrans","门诊")
	        if episodeType="E" Set episodeType= ##class(EMR.DOC.COM.Translation).Get("EMRTrans","急诊")
	        if episodeType="H" Set episodeType= ##class(EMR.DOC.COM.Translation).Get("EMRTrans","体检")
	        
	        set episodeReason = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).PayType(episodeID)     
	        set episodeReason = ##class(EMR.DOC.COM.Translation).Get("EMRTrans",episodeReason)   
	        set dischargeDate = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
		    set dischargeDate = $P(dischargeDate, ",", 1)
		    if (dischargeDate '= "") set dischargeDate = $ZD(dischargeDate,3)
		       
	           
	        set diagnosis= ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
		    if (diagnosis '= "")
			{	
				s diagnosis = $P(diagnosis,"^",3)
			}
	        continue:((ADiagnosis '="")&&(diagnosis'[ADiagnosis))
	        //应该在判断是否符合查询条件之后，再对diagnosis做特殊符号处理
	        s diagnosis = $tr(diagnosis,"'","\'")
	        
	        //增加判断当前符合条件的住院就诊是第几次住院
	        s AdmSequence = AdmSequence + 1
	        
	        //add by lifb 20170817
	        s sysFormatepisodeDate=##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)
	        s sysFormatepisodeTime=##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",episodeTime)
	        s sysFormatdischargeDate=##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",dischargeDate)
			s mrAdm = $p($g(^PAADM(episodeID)),"^",61)
            s ^TempEMRBrowser(key,APatientID,"AdmDate",episodeDate,episodeTime,episodeID)= $lb(episodeID,sysFormatepisodeDate,sysFormatepisodeTime,episodeDeptID,episodeDeptDesc,mainDocName,episodeType,episodeReason,sysFormatdischargeDate,diagnosis,AdmSequence,MedicareNo,mrAdm,hospitalDesc)
		 		
	 	}
	}
	s tmpdate=""
	for {
		s tmpdate=$o(^TempEMRBrowser(key,APatientID,"AdmDate",tmpdate),ASequence)
		q:tmpdate=""
		s tmptime=""
		for {
			s tmptime=$o(^TempEMRBrowser(key,APatientID,"AdmDate",tmpdate,tmptime),ASequence)
			q:tmptime=""
			s tmpepisodeID=""
			for{
				s tmpepisodeID=$o(^TempEMRBrowser(key,APatientID,"AdmDate",tmpdate,tmptime,tmpepisodeID))
				q:tmpepisodeID=""
				set data= ^TempEMRBrowser(key,APatientID,"AdmDate",tmpdate,tmptime,tmpepisodeID)
				set ^CacheTemp(repid,ind)=data
				set ind=ind+1
			} 
		}
	}
	k ^TempEMRBrowser(key)
 	Quit $$$OK
}

ClassMethod GetEpisodeListByPIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListByPIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeListByPIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListByPIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       根据Anum、AdateGap获取患者的就诊IDs
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      ApatientId 患者号
///             Anum 获取最近几次就诊
///             AdateGap 就诊日期间隔,例如90天
/// 				aProductCode 项目标识
/// OutPut:     episodeIDs 患者就诊IDs,用逗号分隔
/// Debug:      w ##Class(EMR.DOC.HISInterface.EpisodeInfo).GetEpisodeIdsByPatientId(8,2,"90")
ClassMethod GetEpisodeIdsByPatientId(ApatientId As %String, Anum As %Integer = "", AdateGap As %String = "", aProductCode As %String, aLangID As %String = "20") As %String
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
	s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(ApatientId,"","",aProductCode,aLangID)
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
