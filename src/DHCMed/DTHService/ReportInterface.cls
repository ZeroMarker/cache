/// 创建者：聂鹏
/// 创建日期：2013-12-27
/// 创建目的：按标准格式导出死亡报告详细数据
Class DHCMed.DTHService.ReportInterface Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-04-03
/// Description:  取值死亡日期
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCMed.DTHService.ReportInterface).GetDeathDateTime(9726218)
ClassMethod GetDeathDateTime(aEpisodeID As %String, aPatientID As %String = "") As %String
{
	New (aEpisodeID,aPatientID)
	Set return=""
	Quit:(aEpisodeID="")&&(aPatientID="") return
	
	Set:aEpisodeID'="" aPatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	
	Set xReportID=0
 	For {
	 	Set xReportID=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_aPatientID,xReportID))
	 	Quit:xReportID=""
	 	
	 	Set objReport=##Class(DHCMed.DTH.Report).GetObjById(xReportID)
	 	Continue:'$IsObject(objReport)
	 	Continue:'$IsObject(objReport.RepStatusDR)
	 	Continue:objReport.RepStatusDR.Code=0  //删除状态过滤
	 	Continue:objReport.RepStatusDR.Code=5  //作废状态过滤
	 	Continue:objReport.RepStatusDR.Code=6  //草稿状态过滤
	 	If aEpisodeID'="" {
		 	Continue:objReport.EpisodeID'=aEpisodeID
	 	}
	 	Set DeathDate=objReport.DeathDate
	 	Continue:DeathDate=""
	 	Set DeathTime=objReport.DeathTime
	 	Set return=DeathDate_","_DeathTime
	 	Quit
	}
	
	Quit return
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// w ##Class(DHCMed.DTHService.ReportInterface).GetServerInfoNP()
ClassMethod GetServerInfoNP()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

/// Description:根据报告Id得到$lb
/// w ##Class(DHCMed.DTHService.ReportInterface).GetDataByReportId("1","","","")
ClassMethod GetDataByReportId(repId As %String, locId As %String, hospId As %String, status As %String, RepType As %String = "") As %String
{
	new (repId,locId,hospId,status,RepType)
	set rpObj=##Class(DHCMed.DTH.Report).%OpenId(repId),data=""
	if ($IsObject(rpObj)){
        set ReportID=repId
	    set RepAreaNo=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-AdministrativeRegionCode","")
	    //报告卡编号=医院代码+年份+流水号
	    set repLocDR=rpObj.RepLocDR
	    set HospitalID=$p($g(^CTLOC(repLocDR)),"^",22)
	
	    set RepCardNo=rpObj.RepNo
	    set ManKindNo=" "
	    set ManKind=" "
		set Name=rpObj.Name
		set Sex=rpObj.Sex
		if (Sex ="男"){
			set SexNo=1	
		}elseif(Sex ="女"){
			set SexNo=2	
		}else{
			set SexNo=3
		}
		set Identify=rpObj.Identify
		set Identify="'"_Identify
		set Birthday=$zd(rpObj.Birthday,3)
		set Age=rpObj.Age
		set Nation=rpObj.Nation
		set NationN=" "_Nation
		set NationID=""
		For {
			set NationID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," NATION",NationN,NationID))
			quit:NationID=""
			set obj=##Class(DHCMed.SS.Dictionary).GetObjById(NationID)
			if ($IsObject(obj)){
	  			 set NationNo=obj.Code
			}
		}
		set (Marital,MaritalNo)=""
		set objMarital=rpObj.Marital
		if ($IsObject(objMarital)){
	  			 set Marital=objMarital.Description
	  			 set MaritalNo=objMarital.Code
		}	
		set objOccupation=rpObj.Occupation
		if ($IsObject(objOccupation)){
	  			 set Occupation=objOccupation.Description
	  			 set OccupationNo=objOccupation.Code
		}
		set (Education,EducationNo)=""
		set objEducation=rpObj.Education
		if ($IsObject(objEducation)){
	  			 set Education=objEducation.Description
	  			 set EducationNo=objEducation.Code
		}
	
		set CurrAddressType=" "
		set CurrAddress=rpObj.CurrAddress
		set CurrAddressNo=" "
		set CurrCountyID=rpObj.MEPDVillage
		set CurrAddressobj=##Class(DHCMed.SS.AreaDic).GetObjById(CurrCountyID)
		if ($IsObject(CurrAddressobj)){
	  		set CurrAddressNo=CurrAddressobj.Code
		}
		
		set Household=rpObj.Household
		set RegAddress=rpObj.RegAddress
		set RegAddressNo=" "
		set CountyID=rpObj.RegVillage
		set RegAddressobj=##Class(DHCMed.SS.AreaDic).GetObjById(CountyID)
		if ($IsObject(RegAddressobj)){
	  		set RegAddressNo=RegAddressobj.Code
		}
		set Company=rpObj.Company
		set DeathTime=$zt(rpObj.DeathTime,1)
		set objDeathPlace=rpObj.DeathPlace
		set DeathPlace=""
		if ($IsObject(objDeathPlace)){
			set DeathPlace=objDeathPlace.Description
			set DeathPlaceNo=objDeathPlace.Code
	    }
	    set FamName=rpObj.FamName
	    set FamTel=rpObj.FamTel
		set FamAddr=rpObj.FamAddr	
		
		set AFPReason=rpObj.AFPReason
		if (AFPReason'=""){
			set AReason=AFPReason
			set AReasonICD=rpObj.AFPReasonICD
		}else{
			set AReason=rpObj.AReason
			set AReasonICD=rpObj.AReasonICD
		}
		set AInterval=rpObj.AInterval
		set BFPReason=rpObj.BFPReason
		if (BFPReason'=""){
			set BReason=BFPReason
			set BReasonICD=rpObj.BFPReasonICD
		}else{
			set BReason=rpObj.BReason
			set BReasonICD=rpObj.BReasonICD
		}
		set BInterval=rpObj.BInterval
		
		set CFPReason=rpObj.CFPReason
		if (CFPReason'=""){
			set CReason=CFPReason
			set CReasonICD=rpObj.CFPReasonICD
		}else{
			set CReason=rpObj.CReason
			set CReasonICD=rpObj.CReasonICD
		}
		set CInterval=rpObj.CInterval
		set DFPReason=rpObj.DFPReason
		if (DFPReason'=""){
			set DReason=DFPReason
			set DReasonICD=rpObj.DFPReasonICD
		}else{
			set DReason=rpObj.DReason
			set DReasonICD=rpObj.DReasonICD
		}
		set DInterval=rpObj.DInterval
		
		set objATime=rpObj.ATime
		set ATime=""
		if ($IsObject(objATime)){
			set ATime=objATime.Description
	    }
		set objBTime=rpObj.BTime
		set BTime=""
		if ($IsObject(objBTime)){
			set BTime=objBTime.Description
	    }
		set objCTime=rpObj.CTime
		set CTime=""
		if ($IsObject(objCTime)){
			set CTime=objCTime.Description
	    }
		set objDTime=rpObj.DTime
		set DTime=""
		if ($IsObject(objDTime)){
			set DTime=objDTime.Description
	    }
		set OtherDiagnose=rpObj.OtherDiagnose
		set OtherDiagnoseICD=" "
		set BaseReason=rpObj.BaseReason
		set BaseReasonICD=rpObj.BaseReasonICD
		//根本死因  如果根本死因为空则以dcba顺序取诊断
		if (BaseReason=""){  
			if (DReason'=""){
				set BaseReason=DReason
				set BaseReasonICD=DReasonICD
			}elseif (CReason'=""){
				set BaseReason=CReason
				set BaseReasonICD=CReasonICD
			}elseif(BReason'=""){
				set BaseReason=BReason
				set BaseReasonICD=BReasonICD
			}elseif(AReason'=""){
				set BaseReason=AReason
				set BaseReasonICD=AReasonICD
			}
		}
		set objDiagnoseUnit=rpObj.DiagnoseUnit
		set DiagnoseUnitNo=""
		set DiagnoseUnit=""
		if ($IsObject(objDiagnoseUnit)){
			set DiagnoseUnit=objDiagnoseUnit.Description
			set DiagnoseUnitNo=objDiagnoseUnit.Code
	    }
		
		set objDiagnoseBasis=rpObj.DiagnoseBasis
		set DiagnoseBasis=""
		if ($IsObject(objDiagnoseBasis)){
			set DiagnoseBasis=objDiagnoseBasis.Description
			set DiagnoseBasisNo=objDiagnoseBasis.Code
	    }
	    set DiagnoseBasisD=" "_DiagnoseBasis
	    set DiagnoseBasisID=""
		For {
			set DiagnoseBasisID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," DTHDIAGNOSEBASIS",DiagnoseBasisD,DiagnoseBasisID))
			quit:DiagnoseBasisID=""
			set obj=##Class(DHCMed.SS.Dictionary).GetObjById(DiagnoseBasisID)
			if ($IsObject(obj)){
	  			 set DiagnoseBasisNo=obj.Code
			}
		}
		set RepDocDR=rpObj.RepUsrDR
		if (RepDocDR'=""){
		set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+RepDocDR)
			if ($IsObject(objUser)){
				set RepDocDR=objUser.Name
			}
		}
		set MrNo=rpObj.MrNo
		set PapmiNo=rpObj.PapmiNo
		set RepDate=$zd(rpObj.RepDate,3)
		
		Set DTHHopsDescCode = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-HopsDescCode","")
		set RepHospitalNo=$p(DTHHopsDescCode,"`",1)
		set RepHospital=$p(DTHHopsDescCode,"`",2)
		set UnitTypeNo=$p(DTHHopsDescCode,"`",3)
		set UnitType=$p(DTHHopsDescCode,"`",4)
		set ResumeText=rpObj.ResumeText
		set ExamMedical=rpObj.ExamMedical
		set ExamName=rpObj.ExamName
		set objExamRelation=rpObj.ExamRelation
		set ExamRelation=""
		if ($IsObject(objExamRelation)){
			set ExamRelation=objExamRelation.Description
	    }
		set ExamAddress=rpObj.ExamAddress
		set ExamTel=rpObj.ExamTel
		set ExamDeathReason=rpObj.ExamDeathReason
		set ExamName=" "
		set ExamDate=rpObj.ExamDate
		set:ExamDate'="" ExamDate=$zd(ExamDate,3)    
		set DeleteTime=" "
		set AddTime=RepDate
		set AddPersonID=RepDocDR
		set ChildReportStatus=rpObj.ChildReportStatus
		/*if ($IsObject(ChildReportStatus)){
			set OpeDate=ChildReportStatus.OpeDate
			s ^tempNP=OpeDate
			set StatusDR=ChildReportStatus.StatusDR
			if ($IsObject(StatusDR)){
				set AuditFlags=obj.Code
			}
	    }*/
	    
	    set CardSource="web录入"
 	
 	    set EpisodeID=rpObj.EpisodeID
		Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		quit:(RepType'="")&&(AdmType'=RepType) ""
	
	    set RepStatus=""
		set RepStatusCode=""
	    set BackReason=""
	    set dicObj=rpObj.RepStatusDR
	    if ($IsObject(dicObj)){
			q:(status'="")&(dicObj.%Id()'=status) ""
			set statusCode=dicObj.Code
			if (statusCode=9){  //退回状态
				;^DHCMed.DTH("REP",9,"Status",4)
				set repStatusId=""
				set repStatusId=$o(^DHCMed.DTH("REP",repId,"Status",repStatusId),-1)
				if (repStatusId'=""){
				    set BackReason=$list(^DHCMed.DTH("REP",repId,"Status",repStatusId),6)
				}
			}
			set RepStatus=dicObj.Description
			Set RepStatusCode = dicObj.Code
		 }
		set CardStatusNo=RepStatusCode
		set CardStatus=RepStatus
		Set AuditFlags = ""
		set:RepStatus="审核" AuditFlags="1"
		Set OpeDate = ""
		set xPrintId=""
	    for { 
	       set xPrintId=$o(^DHCMed.DTH("REP",repId,"Status",xPrintId))
	       q:xPrintId=""
	       set xRepID=repId_"||"_xPrintId
           set Statusobj=##Class(DHCMed.DTH.ReportStatus).%OpenId(xRepID)
		   set StatusDesc=Statusobj.StatusDR.Description
		   Continue:StatusDesc'="审核"
		   set OpeDate=Statusobj.OpeDate
		   Set:OpeDate'="" OpeDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OpeDate)
        }
		 
		set PrintReason=""
		set PrintId=""
	    for { 
	       set PrintId=$o(^DHCMed.DTH("REP",repId,"ChildPrintStatus",PrintId))
	       q:PrintId=""
	       set icd=repId_"||"_PrintId
           set Printobj=##Class(DHCMed.DTH.PrintStatus).%OpenId(icd)
           set PrintReason=Printobj.ResumeText
        }
		set data=$lb(ReportID,RepAreaNo,RepCardNo,ManKindNo,ManKind,Name,SexNo,Sex,Identify,Birthday,Age,NationNo,Nation,MaritalNo,Marital,OccupationNo,Occupation,EducationNo,Education,CurrAddressType,CurrAddress,CurrAddressNo,Household,RegAddress,RegAddressNo,Company,DeathTime,DeathPlaceNo,DeathPlace,FamName,FamTel,FamAddr,AReason,AReasonICD,AInterval,ATime,BReason,BReasonICD,BInterval,BTime,CReason,CReasonICD,CInterval,CTime,DReason,DReasonICD,DInterval,DTime,OtherDiagnose,OtherDiagnoseICD,BaseReason,BaseReasonICD,DiagnoseUnitNo,DiagnoseUnit,DiagnoseBasisNo,DiagnoseBasis,RepDocDR,MrNo,RepDate,RepHospitalNo,RepHospital,UnitTypeNo,UnitType,ResumeText,ExamMedical,ExamName,ExamRelation,ExamAddress,ExamTel,ExamDeathReason,ExamName,ExamDate,DeleteTime,AddTime,AddPersonID,AuditFlags,OpeDate,CardStatusNo,CardStatus,CardSource)	
    }
    quit data
}

/// Description:根据条件查询死亡报告信息
/// d ##Class(%ResultSet).RunQuery("DHCMed.DTHService.ReportInterface","QryReportInfo","2013-12-01","2013-12-25","","","","","")
Query QryReportInfo(startDate As %String, endDate As %String, locId As %String, hospId As %String, status As %String, argPatName As %String, argMrNo As %String, argRegNo As %String, RepType As %String = "") As %Query(ROWSPEC = "ReportID:%String,RepAreaNo:%String,RepCardNo:%String,ManKindNo:%String,ManKind:%String,Name:%String,SexNo:%String,Sex:%String,Identify:%String,Birthday:%String,Age:%String,NationNo:%String,Nation:%String,MaritalNo:%String,Marital:%String,OccupationNo:%String,Occupation:%String,EducationNo:%String,Education:%String,CurrAddressType:%String,CurrAddress:%String,CurrAddressNo:%String,Household:%String,RegAddress:%String,RegAddressNo:%String,Company:%String,DeathTime:%String,DeathPlaceNo:%String,DeathPlace:%String,FamName:%String,FamTel:%String,FamAddr:%String,AReason:%String,AReasonICD:%String,AInterval:%String,ATime:%String,BReason:%String,BReasonICD:%String,BInterval:%String,BTime:%String,CReason:%String,CReasonICD:%String,CInterval:%String,CTime:%String,DReason:%String,DReasonICD:%String,DInterval:%String,DTime:%String,OtherDiagnose:%String,OtherDiagnoseICD:%String,BaseReason:%String,BaseReasonICD:%String,DiagnoseUnitNo:%String,DiagnoseUnit:%String,DiagnoseBasisNo:%String,DiagnoseBasis:%String,RepDocDR:%String,MrNo:%String,RepDate:%String,RepHospitalNo:%String,RepHospital:%String,UnitTypeNo:%String,UnitType:%String,ResumeText:%String,ExamMedical:%String,ExamName:%String,ExamRelation:%String,ExamAddress:%String,ExamTel:%String,ExamDeathReason:%String,ExamNameDesc:%String,ExamDate:%String,DeleteTime:%String,AddTime:%String,AddPersonID:%String,AuditFlags:%String,OpeDate:%String,CardStatusNo:%String,CardStatus:%String,CardSource:%String")
{
}

ClassMethod QryReportInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locId As %String, hospId As %String, status As %String, argPatName As %String, argMrNo As %String, argRegNo As %String, RepType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	if (argPatName'="")||(argMrNo'="")||(argRegNo'="") {
	 	Set repId=""
	 	For {
		 	Set repId=$o(^DHCMed.DTH("REP",repId))
		 	Quit:repId=""
		 	
		 	Set obj=##class(DHCMed.DTH.Report).GetObjById(repId)
		 	Continue:'$IsObject(obj)	
		 	
		 	Set PapmiNo=obj.PapmiNo
		 	Set MrNo=obj.MrNo
		 	Set Name=obj.Name
		 	Set EpisodeID=obj.EpisodeID
		 	Continue:EpisodeID=""
		 	
		 	Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		 	Continue:(RepType'="")&&(AdmType'=RepType)
		 	Continue:(argPatName'="")&&(Name'[argPatName)
		 	Continue:(argMrNo'="")&&(MrNo'[argMrNo)
		 	Continue:(argRegNo'="")&&(PapmiNo'[argRegNo)
		 	
		 	Set data=..GetDataByReportId(repId,"","","",RepType)	
		 	Continue:data=""
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1
		 }
	 }
	Quit:(argPatName'="")||(argMrNo'="")||(argRegNo'="") $$$OK
	set:startDate'="" startDate=##Class(DHCMed.DTHService.CommonSrv).ConvertToDate(startDate)
	set endDate=##Class(DHCMed.DTHService.CommonSrv).ConvertToDate(endDate)
	set:status'="" status=##Class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(status,"DTHRunningState")
	for startDate=+startDate:1:endDate
	{
		if ($d(^DHCMed.DTHi("REP","IndexDate",startDate))){
				set repId=0
				set repId=$o(^DHCMed.DTHi("REP","IndexDate",startDate,repId))
				
				while (repId'=""){
					    set data=..GetDataByReportId(repId,locId,hospId,status,RepType)
					    
					    set repId=$o(^DHCMed.DTHi("REP","IndexDate",startDate,repId))
					    continue:data=""	
						set ^CacheTemp(repid,ind)=data
						set ind=ind+1
						
				        }
       }
	}
	Quit $$$OK
}

ClassMethod QryReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCMed.DTHService.ReportInterface).QryReportInfoToPrintNP("fillxlSheet",1)
ClassMethod QryReportInfoToPrintNP(itmjs As %String, ArgStr As %String) As %String
{
	n (itmjs,ArgStr)
	s Count=0
	s startDate=$p(ArgStr,"^",1)
    s endDate=$p(ArgStr,"^",2)
    s loc=$p(ArgStr,"^",3)
    s hosp=$p(ArgStr,"^",4)
    s status=$p(ArgStr,"^",5)
    s PatName=$p(ArgStr,"^",6)
	s MrNo=$p(ArgStr,"^",7)
	s RegNo=$p(ArgStr,"^",8)
	s ds = ##class(%Library.ResultSet).%New("DHCMed.DTHService.ReportInterface:QryReportInfo")
	d ds.Execute(startDate,endDate,loc,hosp,status,PatName,MrNo,RegNo)
	
	s StartRow=2
	while(ds.Next())
	{
		s ReportID=ds.Data("ReportID")
		s RepAreaNo=ds.Data("RepAreaNo")
		s RepCardNo=ds.Data("RepCardNo")
		s ManKindNo=ds.Data("ManKindNo")
		s ManKind=ds.Data("ManKind")
		s Name=ds.Data("Name")
		s SexNo=ds.Data("SexNo")
		s Sex=ds.Data("Sex")
		s Identify=ds.Data("Identify")
		s Birthday=ds.Data("Birthday")
		s Age=ds.Data("Age")
		s NationNo=ds.Data("NationNo")
		s Nation=ds.Data("Nation")
		s MaritalNo=ds.Data("MaritalNo")
		s Marital=ds.Data("Marital")
		s OccupationNo=ds.Data("OccupationNo")
		s Occupation=ds.Data("Occupation")
		s EducationNo=ds.Data("EducationNo")
		s Education=ds.Data("Education")
		s CurrAddressType=ds.Data("CurrAddressType")
		s CurrAddress=ds.Data("CurrAddress")
		s CurrAddressNo=ds.Data("CurrAddressNo")
		s Household=ds.Data("Household")
		s RegAddress=ds.Data("RegAddress")
		s RegAddressNo=ds.Data("RegAddressNo")
		s Company=ds.Data("Company")
		s DeathTime=ds.Data("DeathTime")
		s DeathPlaceNo=ds.Data("DeathPlaceNo")
		s DeathPlace=ds.Data("DeathPlace")
		s FamName=ds.Data("FamName")
		s FamTel=ds.Data("FamTel")
		s FamAddr=ds.Data("FamAddr")
		s AReason=ds.Data("AReason")
		s AReasonICD=ds.Data("AReasonICD")
		s AInterval=ds.Data("AInterval")
		s ATime=ds.Data("ATime")
		s BReason=ds.Data("BReason")
		s BReasonICD=ds.Data("BReasonICD")
		s BInterval=ds.Data("BInterval")
		s BTime=ds.Data("BTime")
		s CReason=ds.Data("CReason")
		s CReasonICD=ds.Data("CReasonICD")
		s CInterval=ds.Data("CInterval")
		s CTime=ds.Data("CTime")
		s DReason=ds.Data("DReason")
		s DReasonICD=ds.Data("DReasonICD")
		s DInterval=ds.Data("DInterval")
		s DTime=ds.Data("DTime")
		s OtherDiagnose=ds.Data("OtherDiagnose")
		s OtherDiagnoseICD=ds.Data("OtherDiagnoseICD")
		s BaseReason=ds.Data("BaseReason")
		s BaseReasonICD=ds.Data("BaseReasonICD")
		s DiagnoseUnitNo=ds.Data("DiagnoseUnitNo")
		s DiagnoseUnit=ds.Data("DiagnoseUnit")
		s DiagnoseBasisNo=ds.Data("DiagnoseBasisNo")
		s DiagnoseBasis=ds.Data("DiagnoseBasis")
		s RepDocDR=ds.Data("RepDocDR")
		s PapmiNo=ds.Data("PapmiNo")
		s RepDate=ds.Data("RepDate")
		s RepHospitalNo=ds.Data("RepHospitalNo")
		s RepHospital=ds.Data("RepHospital")
		s UnitTypeNo=ds.Data("UnitTypeNo")
		s UnitType=ds.Data("UnitType")
		s ResumeText=ds.Data("ResumeText")
		s ExamMedical=ds.Data("ExamMedical")
		s ExamName=ds.Data("ExamName")
		s ExamRelation=ds.Data("ExamRelation")
		s ExamAddress=ds.Data("ExamAddress")
		s ExamTel=ds.Data("ExamTel")
		s ExamDeathReason=ds.Data("ExamDeathReason")
		s ExamName=ds.Data("ExamName")
		s ExamDate=ds.Data("ExamDate")
		s DeleteTime=ds.Data("DeleteTime")
		s AddTime=ds.Data("AddTime")
		s AddPersonID=ds.Data("AddPersonID")
		s AuditFlags=ds.Data("AuditFlags")
		s OpeDate=ds.Data("OpeDate")
		s CardStatusNo=ds.Data("CardStatusNo")
		s CardStatus=ds.Data("CardStatus")
		s CardSource=ds.Data("CardSource")
		s MrNo=ds.Data("MrNo")
		
		s str=ReportID_$c(1)_RepAreaNo_$c(1)_RepCardNo_$c(1)_ManKindNo_$c(1)_ManKind_$c(1)_Name_$c(1)_SexNo_$c(1)_Sex_$c(1)_Identify_$c(1)_Birthday_$c(1)_Age_$c(1)_NationNo_$c(1)_Nation_$c(1)_MaritalNo_$c(1)_Marital_$c(1)_OccupationNo_$c(1)_Occupation_$c(1)_EducationNo_$c(1)_Education_$c(1)_CurrAddressType_$c(1)_CurrAddress_$c(1)_CurrAddressNo_$c(1)_Household_$c(1)_RegAddress_$c(1)_RegAddressNo_$c(1)_Company_$c(1)_DeathTime_$c(1)_DeathPlaceNo_$c(1)_DeathPlace_$c(1)_FamName_$c(1)_FamTel_$c(1)_FamAddr_$c(1)_AReason_$c(1)_AReasonICD_$c(1)_AInterval_$c(1)_ATime_$c(1)_BReason_$c(1)_BReasonICD_$c(1)_BInterval_$c(1)_BTime_$c(1)_CReason_$c(1)_CReasonICD_$c(1)_CInterval_$c(1)_CTime_$c(1)_DReason_$c(1)_DReasonICD_$c(1)_DInterval_$c(1)_DTime_$c(1)_OtherDiagnose_$c(1)_OtherDiagnoseICD_$c(1)_BaseReason_$c(1)_BaseReasonICD_$c(1)_DiagnoseUnitNo_$c(1)_DiagnoseUnit_$c(1)_DiagnoseBasisNo_$c(1)_DiagnoseBasis_$c(1)_RepDocDR_$c(1)_MrNo_$c(1)_RepDate_$c(1)_RepHospitalNo_$c(1)_RepHospital_$c(1)_UnitTypeNo_$c(1)_UnitType_$c(1)_ResumeText_$c(1)_ExamMedical_$c(1)_ExamName_$c(1)_ExamRelation_$c(1)_ExamAddress_$c(1)_ExamTel_$c(1)_ExamDeathReason_$c(1)_ExamName_$c(1)_ExamDate_$c(1)_DeleteTime_$c(1)_AddTime_$c(1)_AddPersonID_$c(1)_AuditFlags_$c(1)_OpeDate_$c(1)_CardStatusNo_$c(1)_CardStatus_$c(1)_CardSource
		s retval=itmjs_"(xlSheet,'"_$ZCVT(str,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s StartRow=StartRow+1
	}
	
	
	d ds.Close()
	
	q 1
}

}
