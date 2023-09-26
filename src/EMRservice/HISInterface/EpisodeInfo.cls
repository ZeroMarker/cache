Class EMRservice.HISInterface.EpisodeInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：       Candy
/// CreateDate：    2014-08-19
/// Description:：  查询患者的就诊信息
/// Table：         PA_ADM
/// Input：         病人APatientID
/// Output：		EpisodeID 就诊号
///        		    EpisodeDate:就诊日期
///                 DeptDesc:就诊科室
///         		MainDocName:就诊医生
///         		EpisodeType:就诊类型
///         		EpisodeReason:病人类型
///         		DischargeDate:出院日期
///         		Diagnosis:诊断
///                 HospitalDesc:院区
/// Debug：			do ##class(%ResultSet).RunQuery("EMRservice.HISInterface.EpisodeInfo","GetEpisodeListByPID","50","","O")
Query GetEpisodeListByPID(APatientID As %String, ADiagnosis As %String = "", AEpisodeType As %String = "", ASequence As %String = "-1") As %Query(ROWSPEC = "EpisodeID:%String,EpisodeDate:%String,EpisodeTime:%String,EpisodeDeptID:%String,EpisodeDeptDesc:%String,MainDocName:%String,EpisodeType:%String,EpisodeReason:%String,DischargeDate:%String,Diagnosis:%String,AdmSequence:%String,MedicareNo:%String,MrAdm:%String,HospitalDesc:%String")
{
}

ClassMethod GetEpisodeListByPIDExecute(ByRef qHandle As %Binary, APatientID As %String, ADiagnosis As %String = "", AEpisodeType As %String = "", ASequence As %String = "-1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
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
		 	//continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息
		 	/*
			 	Admit||A
				Cancel||C
				Discharged||D
				Pre-Admission||P
				Released||R
				DNA||N
		 	*/ 
		 	continue:'( "AD"[VisitStatus)    //过滤掉已退号的就诊信息 
		 	
		 	
		 	s episodeDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
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
			 

			set episodeDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)		
			set episodeDeptID = $p(episodeDept,"^",1)
			set episodeDeptDesc = $p(episodeDept,"^",3)
			s episodeDeptDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",episodeDeptDesc)
			
			///按照用户登录的医院信息，过滤患者数据
			s hospitalID= $Get(%session.Data("LOGON.HOSPID"))
			s showShareHospital=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
			//科室所在医院
			s locHospitalID = $p($g(^CTLOC(episodeDeptID)),"^",22)
			continue:((hospitalID'="")&&(hospitalID'=locHospitalID)&&(showShareHospital="N"))
       
            s hospitalDesc = $p(^CT("HOSP",locHospitalID),"^",2)
			s hospitalDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",hospitalDesc)
			
			set mainDoc = ##Class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(episodeID)
			set mainDocName = $P(mainDoc, "^", 3) 
			
			//取患者病案号
			s MedicareNo = ""
			s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)

			s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
			// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
		 	s IPRecordNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
		 	
		 	// 门诊病案号		[OPRecordNo]		PA_Person.PAPER_GovernCardNo
		 	s OPRecordNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
		 	
		 	// 急诊病案号		[EPRecordNo]		DHC_Person.PAPER_FCMedicareCode1
		 	s EPRecordNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
		 	
		 	//依据患者类型，返回病案号
		 	s AdmType=$p(^PAADM(episodeID),"^",2)
			s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeID)
			
			
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
			
			if episodeType="I" Set episodeType= ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","住院")
			if ((episodeType="I")&&(VisitStatus="P")) Set episodeType= ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","预住院")
	        if episodeType="O" Set episodeType= ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","门诊")
	        if episodeType="E" Set episodeType= ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","急诊")
	        if episodeType="H" Set episodeType= ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","体检")
	        
	        set episodeReason = ##Class(EMRservice.HISInterface.PatientInfoAssist).PayType(episodeID)     
	        set episodeReason = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",episodeReason)   
	        set dischargeDate = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
		    set dischargeDate = $P(dischargeDate, ",", 1)
		    if (dischargeDate '= "") set dischargeDate = $ZD(dischargeDate,3)
		       
	           
	        set diagnosis= ##Class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
		    if (diagnosis '= "")
			{	
				//s diagnosis = $P(diagnosis,"^",3)
				s retDiagnosis = ""
				for i=1:1:$l(diagnosis,"$")
				{
					s oneDiagnosis = $p(diagnosis,"$",i)
					s:(retDiagnosis '= "") retDiagnosis = retDiagnosis_";"
					s retDiagnosis = retDiagnosis_$P(oneDiagnosis,"^",3)
				}
				s diagnosis = retDiagnosis
			}
	        continue:((ADiagnosis '="")&&(diagnosis'[ADiagnosis))
	        //应该在判断是否符合查询条件之后，再对diagnosis做特殊符号处理
	        s diagnosis = $tr(diagnosis,"'","\'")
	        
	        //增加判断当前符合条件的住院就诊是第几次住院
	        s AdmSequence = AdmSequence + 1
	        
	        //add by lifb 20170817
	        s sysFormatepisodeDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)
	        s sysFormatepisodeTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",episodeTime)
	        s sysFormatdischargeDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",dischargeDate)
			s mrAdm = $p($g(^PAADM(episodeID)),"^",61)
            set ^TempEMRBrowser(key,APatientID,"AdmDate",episodeDate,episodeTime,episodeID)= $lb(episodeID,sysFormatepisodeDate,sysFormatepisodeTime,episodeDeptID,episodeDeptDesc,mainDocName,episodeType,episodeReason,sysFormatdischargeDate,diagnosis,AdmSequence,MedicareNo,mrAdm,hospitalDesc)
		 		
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

/// Desc:	通过科室查询用户列表
/// 来自EPRservice.Quality.DataGather.SSUser:GetUserDataList
/// Move by：Lina
/// Input:	ALocID--科室查询
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.EpisodeInfo","GetUserDataList","","1")
Query GetUserDataList(AUserName As %String, ALocID As %String) As %Query(ROWSPEC = "ProvID:%String,UserID:%String,UserCode:%String,UserDesc:%String,Location:%String")
{
}

ClassMethod GetUserDataListExecute(ByRef qHandle As %Binary, AUserName As %String, ALocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	;^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})
	s UserName = $$ALPHAUP^SSUTIL4(AUserName)
	s LocID = $g(ALocID)
	q:(LocID = "") $$$OK
	s RowID = 0
	for {
		s RowID = $o(^RB("RES",0,"CTLOC",ALocID,RowID)) 
		q:(RowID = "")
		s CareProvID = $p(^RB("RES",RowID),"^",2)
		continue:(CareProvID = "")
		continue:($d(^CTPCP(CareProvID)) = 0)
		s userId = $o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
		s CareProvCode = $p($g(^CTPCP(+CareProvID,1)),"^",1)
    	s CareProvDesc = $p($g(^CTPCP(+CareProvID,1)),"^",2)
    	s CareProvOtherName = $p($g(^CTPCP(+CareProvID,3)),"^",28)
    	continue:(UserName '= "")&&(( CareProvDesc '[ UserName)&&( $zcvt(CareProvOtherName,"U") '[ $zcvt(UserName,"U")))
		s Location = $p(^CTLOC(LocID),"^",2)
		s:(Location [ "-") Location = $p(Location,"-",2)
    	s Data = $lb(CareProvID,userId,CareProvCode,CareProvDesc,Location)
    	s ^CacheTemp(repid,ind) = Data
    	s ind = ind+1
	}
	q $$$OK
}

ClassMethod GetUserDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserDataListExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if (ind="") 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetUserDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserDataListExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
