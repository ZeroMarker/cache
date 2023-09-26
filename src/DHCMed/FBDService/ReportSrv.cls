/// 名称: DHCMed.FBDService.ReportSrv
/// 描述: 食源性疾病报告
Class DHCMed.FBDService.ReportSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 查询病人历史报卡Qry
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.ReportSrv","QryReportByPapmi","")
Query QryReportByPapmi(aPatientID As %String) As %Query(ROWSPEC = "RowID:%String,PatName:%String,Sex:%String,PatAge:%String,PapmiNo:%String,CardNo:%String,CateDesc:%String,DiseaseDesc:%String,SickDateTime:%String,StatusDesc:%String,RepUserName:%String,RepDateTime:%String,ReportLocDesc:%String,ChkUserName:%String,ChkDateTime:%String,EncryptLevel:%String,PatLevel:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryReportByPapmiExecute(ByRef qHandle As %Binary, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(aPatientID="") $$$OK
	Set xID=""
	For {
		Set xID=$o(^DHCMed.FBD.ReportI("IndexPatientID"," "_$ZCVT(aPatientID,"U"),xID),-1)
		Quit:(xID="")
		Set objReport=##class(DHCMed.FBD.Report).GetObjById(xID)
		Continue:'$IsObject(objReport)
		Set (StatusID,StatusCode,StatusDesc)=""
		Set StatusDr=objReport.FRStatusDr
		If $IsObject(StatusDr) {
			Set StatusID=StatusDr.%Id()
			Set StatusCode=StatusDr.Code
			Set StatusDesc=StatusDr.Description
			Set StatusDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",StatusDesc)
		}
		Set (DiseaseID,DiseaseDesc,CateID,CateDesc)=""
		Set DiseaseDr=objReport.FRDiseaseDr
		If $IsObject(DiseaseDr) {
			Set DiseaseID=DiseaseDr.%Id()
			Set DiseaseDesc=DiseaseDr.IDDesc
			Set DiseaseDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Disease","IDDesc","",DiseaseDesc)
			Set CateDr=DiseaseDr.IDCateDr
			If (CateDr) {
				Set CateID=CateDr.%Id()
				Set CateDesc=CateDr.Description
				Set CateDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",CateDesc)
			}
		}
		Set (PatName,Sex,Birthday,PatAge,PapmiNo)=""
		Set PatientObj=objReport.FRPatientObj
		If $IsObject(PatientObj) {
			Set PatName=PatientObj.RPPatName
			Set Sex=PatientObj.RPSex
			Set Birthday=PatientObj.RPBirthday
		}
		Set objPatient=##class(DHCMed.Base.Patient).GetObjById(aPatientID)
		If $IsObject(objPatient) {
			Set:(PatName="") PatName=objPatient.PatientName
			Set:(Sex="") Sex=objPatient.Sex
			Set:(Birthday="") Birthday=objPatient.Birthday
			Set PapmiNo=objPatient.PapmiNo	// dengjihao			
		}
		//统一调用年龄计算方法
		Set EpisodeID=objReport.FREpisodeID
		//upadte by pylian 2016-02-18 修改入院时间取值方式
   		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(aPatientID,EpisodeID,AdmDate,AdmitTime)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,2)
		Set (EncryptLevel,PatLevel)=""
		Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(aPatientID,.ErrMsg)
		Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
		Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
		Set CardNo=objReport.FRCardNo
		Set (RepUserName,ChkUserName,RepDateTime,ChkDateTime,SickDate,SickTime)=""
		Set ReportUser=objReport.FRReportUser
		Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
		Set:$IsObject(objRepUser) RepUserName=objRepUser.Name
		Set:RepUserName'="" RepUserName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",RepUserName)
		Set CheckUser=objReport.FRCheckUser
		Set objChkUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
		Set:$IsObject(objChkUser) ChkUserName=objChkUser.Name
		Set:ChkUserName'="" ChkUserName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",ChkUserName)
		Set ReportDate=objReport.FRReportDate
		Set:+ReportDate'=0 ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
		Set ReportTime=objReport.FRReportTime
		Set:+ReportTime'=0 ReportTime=$zt(ReportTime)
		Set:+ReportDate=0 ReportDate="",ReportTime=""
		Set CheckDate=objReport.FRCheckDate
		Set:+CheckDate'=0 CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
		Set CheckTime=objReport.FRCheckTime
		Set:+CheckTime'=0 CheckTime=$zt(CheckTime)
		Set (RepDateTime,ChkDateTime)=""
		Set:+ReportDate'=0 RepDateTime=ReportDate_" "_ReportTime
		Set:+CheckDate'=0 ChkDateTime=CheckDate_" "_CheckTime
		Set SickDate=objReport.FRSickDate
		Set:+SickDate'=0 SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
		Set SickTime=objReport.FRSickTime
		Set:+SickTime'=0 SickTime=$zt(SickTime)
		Set:+SickDate'=0 SickDateTime=SickDate_" "_SickTime
	
		Set ReportLocDesc=""
		Set ReportLoc=objReport.FRReportLoc
		Set objReportLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
		If $IsObject(objReportLoc) {
			Set ReportLocDesc=objReportLoc.Descs
			Set ReportLocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",ReportLocDesc)
	
		}
		Set Resume=objReport.FRResume
		Set Data=$lb(xID,PatName,Sex,PatAge,PapmiNo,CardNo,CateDesc,DiseaseDesc,SickDateTime,StatusDesc,RepUserName,RepDateTime,ReportLocDesc,ChkUserName,ChkDateTime,EncryptLevel,PatLevel,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryReportByPapmiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByPapmiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportByPapmiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByPapmiExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-15
/// Description:  查询食源性疾病报告
/// Table：       DHCMed.FBD.Report
/// Input：       ProductCode : 产品代码
///               IsActive ：是否有效
///               CateID : 分类ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.ReportSrv","QryReportByDate","","","","","","","","")
Query QryReportByDate(aStaDate As %String, aEndDate As %String, aDateType As %String, aStatusList As %String, aRepLoc As %String, aPatType As %String, aDisCateID As %String, aDiseaseID As %String, aHospID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,PatAge:%String,AdmType:%String,AdmTypeDesc:%String,PersonalID:%String,CardNo:%String,Contactor:%String,Telephone:%String,Company:%String,CurrAddress:%String,Address:%String,CateID:%String,CateDesc:%String,DiseaseID:%String,DiseaseDesc:%String,DiseaseText:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,AreaID:%String,AreaDesc:%String,OccupationID:%String,OccupationDesc:%String,IsInHosp:%String,IsInHospDesc:%String,IsUseAnti:%String,IsUseAntiDesc:%String,UseAntiDesc:%String,SickDate:%String,SickTime:%String,AdmitDate:%String,AdmitTime:%String,DeathDate:%String,DeathTime:%String,RepUserName:%String,ReportDate:%String,ReportTime:%String,ChkUserName:%String,CheckDate:%String,CheckTime:%String,ReportLoc:%String,ReportLocDesc:%String,PreDiagnosDrs:%String,PreDiagnos:%String,AnamnesisDrs:%String,Anamnesis:%String,Resume:%String,EncryptLevel:%String,PatLevel:%String") [ SqlProc ]
{
}

ClassMethod QryReportByDateExecute(ByRef qHandle As %Binary, aStaDate As %String, aEndDate As %String, aDateType As %String, aStatusList As %String, aRepLoc As %String, aPatType As %String, aDisCateID As %String, aDiseaseID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(aStaDate="")||(aEndDate="") $$$OK
	Set aStaDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aStaDate)
	Set aEndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aEndDate)
	Set:(aDateType="") aDateType="IndexReportDate"
	Set StatusList=""
	If $l(aStatusList,",")>0 {
		For tmpStatusInd=1:1:$l(aStatusList,",") {
			Set StatusList=StatusList_$lb($p(aStatusList,",",tmpStatusInd))
		}
	}
	Set xDate=aStaDate-1
	For {
		Set xDate=$o(^DHCMed.FBD.ReportI(aDateType,xDate))
		Quit:(xDate="")||(xDate>aEndDate)
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.FBD.ReportI(aDateType,xDate,xTime))
			Quit:(xTime="")
			Set xID=""
			For {
				Set xID=$o(^DHCMed.FBD.ReportI(aDateType,xDate,xTime,xID))
				Quit:(xID="")
				Set objReport=##class(DHCMed.FBD.Report).GetObjById(xID)
				Continue:'$IsObject(objReport)
				Set (StatusID,StatusCode,StatusDesc)=""
				Set StatusDr=objReport.FRStatusDr
				If $IsObject(StatusDr) {
					Set StatusID=StatusDr.%Id()
					Set StatusCode=StatusDr.Code
					Set StatusDesc=StatusDr.Description
				}
				Continue:(StatusCode="")||($ListFind(StatusList,StatusCode)<1)
				Set (DiseaseID,DiseaseDesc,CateID,CateDesc)=""
				Set DiseaseDr=objReport.FRDiseaseDr
				If $IsObject(DiseaseDr) {
					Set DiseaseID=DiseaseDr.%Id()
					Set DiseaseDesc=DiseaseDr.IDDesc
					Set CateDr=DiseaseDr.IDCateDr
					If (CateDr) {
						Set CateID=CateDr.%Id()
						Set CateDesc=CateDr.Description
					}
				}
				Continue:(aDisCateID'="")&&(aDisCateID'=CateID)
				Continue:(aDiseaseID'="")&&(aDiseaseID'=DiseaseID)
				Set DiseaseText=objReport.FRDiseaseText
				Set ReportLoc=objReport.FRReportLoc
				if aHospID'="" {
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(ReportLoc,aHospID)
					continue:flg<1
				}
				Continue:(aRepLoc'="")&&(aRepLoc'=ReportLoc)
				Set ReportLocDesc=""
				Set objReportLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
				If $IsObject(objReportLoc) {
					Set ReportLocDesc=objReportLoc.Descs
				}
				Set (PatName,Sex,Birthday,PersonalID,Nation,OPNo,IPNo)=""
				Set (PatAge,Age,AgeMonth,AgeDay,PapmiNo,AdmType)=""
				Set PatientObj=objReport.FRPatientObj //DHCMed.FBD.ReportPat
				If $IsObject(PatientObj) {
					Set PatName=PatientObj.RPPatName
					Set Sex=PatientObj.RPSex
					Set Birthday=PatientObj.RPBirthday
					Set PersonalID=PatientObj.RPPersonalID
					Set Nation=PatientObj.RPNation
					Set OPNo=PatientObj.RPOPNo
					Set IPNo=PatientObj.RPIPNo
				}
				Set EpisodeID=objReport.FREpisodeID
				Set objPatientAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				If $IsObject(objPatientAdm) {
					Set AdmType=objPatientAdm.AdmType
				}
				Continue:(aPatType'="")&&(aPatType'=AdmType)
				Set AdmTypeDesc=$s(AdmType="O":"门诊",AdmType="I":"病区",AdmType="E":"急诊",1:"")
				Set PatientID=objReport.FRPatientID
				Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				If $IsObject(objPatient) {
					Set:(PatName="") PatName=objPatient.PatientName
					Set:(Sex="") Sex=objPatient.Sex
					Set:(Birthday="") Birthday=objPatient.Birthday
					Set PapmiNo=objPatient.PapmiNo	// 登记号
				}
				//统一调用年龄计算方法
				//upadte by pylian 2016-02-18 修改入院时间取值方式
   				Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
				Set AdmDate=$p(AdmDateTime,"^",1)
				Set AdmTime=$p(AdmDateTime,"^",2)
				Set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
				Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
				Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
				Set (EncryptLevel,PatLevel)=""
				Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
				Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
				Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
				
				Set CardNo=objReport.FRCardNo
				Set IsInHosp=objReport.FRIsInHosp
				Set IsInHospDesc=$s(+IsInHosp=1:"是",1:"否")
				Set Contactor=objReport.FRContactor
				Set Telephone=objReport.FRTelephone
				Set Company=objReport.FRCompany
				Set (AreaID,AreaDesc)=""
				Set AreaDr=objReport.FRAreaDr
				If $IsObject(AreaDr) {
					Set AreaID=AreaDr.%Id()
					Set AreaDesc=AreaDr.Description
				}
				Set CurrAddress=objReport.FRCurrAddress
				Set CurrProvince=objReport.FRCurrProvince
				Set CurrCity=objReport.FRCurrCity
				Set CurrCounty=objReport.FRCurrCounty
				Set CurrVillage=objReport.FRCurrVillage
				Set CurrRoad=objReport.FRCurrRoad
				Set Address=CurrProvince_CurrCity_CurrCounty_CurrVillage_CurrRoad
				Set (OccupationID,OccupationDesc)=""
				Set OccupationDr=objReport.FROccupationDr
				If $IsObject(OccupationDr) {
					Set OccupationID=OccupationDr.%Id()
					Set OccupationDesc=OccupationDr.Description
				}
				Set SickDate=objReport.FRSickDate
				Set:+SickDate'=0 SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
				Set SickTime=objReport.FRSickTime
				Set SickTime=$zt(SickTime)
				Set:+SickDate=0 SickDate="",SickTime=""
				Set AdmitDate=objReport.FRAdmitDate
				Set:+AdmitDate'=0 AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
				Set AdmitTime=objReport.FRAdmitTime
				Set AdmitTime=$zt(AdmitTime)
				Set:+AdmitDate=0 AdmitDate="",AdmitTime=""
				Set DeathDate=objReport.FRDeathDate
				Set:+DeathDate'=0 DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
				Set DeathTime=objReport.FRDeathTime
				Set DeathTime=$zt(DeathTime)
				Set:+DeathDate=0 DeathDate="",DeathTime=""
				Set IsUseAnti=objReport.FRIsUseAnti
				Set IsUseAntiDesc=$s(+IsUseAnti=1:"是",1:"否")
				Set UseAntiDesc=objReport.FRUseAntiDesc
				Set PreDiagnosDrs=objReport.FRPreDiagnosDrs   //初步诊断
				Set PreDiagnosList=""
				For indm=1:1:PreDiagnosDrs.Count(){
					Set objDic=PreDiagnosDrs.GetAt(indm)
					Continue:'$IsObject(objDic)
					Set PreDiagnosList=PreDiagnosList_","_objDic.Description
				}
				Set:PreDiagnosList'="" PreDiagnosList=$e(PreDiagnosList,2,$l(PreDiagnosList))
				Set PreDiagnos=objReport.FRPreDiagnos

				Set AnamnesisDrs=objReport.FRAnamnesisDrs                             //既往病史
				Set AnamnesisList=""
				For indn=1:1:AnamnesisDrs.Count() {
					Set objDic=AnamnesisDrs.GetAt(indn)
					Continue:'$IsObject(objDic)
					Set AnamnesisList=AnamnesisList_","_objDic.Description
				}
				Set:AnamnesisList'="" AnamnesisList=$e(AnamnesisList,2,$l(AnamnesisList))
				Set Anamnesis=objReport.FRAnamnesis
				Set (RepUserName,ChkUserName)=""
				Set ReportUser=objReport.FRReportUser
				Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
				Set:$IsObject(objRepUser) RepUserName=objRepUser.Name
				Set CheckUser=objReport.FRCheckUser
				Set objChkUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
				Set:$IsObject(objChkUser) ChkUserName=objChkUser.Name
				Set ReportDate=objReport.FRReportDate
				Set:+ReportDate'=0 ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set ReportTime=objReport.FRReportTime
				Set ReportTime=$zt(ReportTime)
				Set:+ReportDate=0 ReportDate="",ReportTime=""
				Set CheckDate=objReport.FRCheckDate
				Set:+CheckDate'=0 CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				Set CheckTime=objReport.FRCheckTime
				Set CheckTime=$zt(CheckTime)
				Set:+CheckDate=0 CheckDate="",CheckTime=""
				Set Resume=objReport.FRResume
				Set Data=$lb(xID,EpisodeID,PatientID,PapmiNo,PatName,Sex,PatAge,AdmType,AdmTypeDesc)
				Set Data=Data_$lb(PersonalID,CardNo,Contactor,Telephone,Company,CurrAddress,Address)
				Set Data=Data_$lb(CateID,CateDesc,DiseaseID,DiseaseDesc,DiseaseText)
				Set Data=Data_$lb(StatusID,StatusCode,StatusDesc,AreaID,AreaDesc,OccupationID,OccupationDesc)
				Set Data=Data_$lb(IsInHosp,IsInHospDesc,IsUseAnti,IsUseAntiDesc,UseAntiDesc)
				Set Data=Data_$lb(SickDate,SickTime,AdmitDate,AdmitTime,DeathDate,DeathTime)
				Set Data=Data_$lb(RepUserName,ReportDate,ReportTime,ChkUserName,CheckDate,CheckTime)
				Set Data=Data_$lb(ReportLoc,ReportLocDesc,PreDiagnosList,PreDiagnos,AnamnesisList,Anamnesis,Resume,EncryptLevel,PatLevel)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryReportByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2019-11-20
/// Description:  查询报告中患者信息
/// Table：       DHCMed.FBD.Report
/// Input：       ReportID : 报告ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.ReportSrv","QryReportPat","15")
Query QryReportPat(aReportID As %String) As %Query(ROWSPEC = "EpisodeID:%String,CardNo:%String,OPNo:%String,IsInHospDesc:%String,IPNo:%String,PatName:%String,SexDesc:%String,Contactor:%String,PersonalID:%String,BirthdayDesc:%String,Telephone:%String,Company:%String,AreaCode:%String,AreaDesc:%String,Address:%String,OccupationCode:%String,OccupationDesc:%String,SickDT:%String,AdmitDT:%String,DeathDT:%String,IsUseAntiDesc:%String,UseAntiDesc:%String,PreDiagnos:%String,Anamnesis:%String,HospitalDesc:%String,RepUserName:%String,ReportDT:%String,PreDiagnosList:%String,AnamnesisList:%String,CateDesc:%String,ExamResult:%String,DiseaseDesc:%String") [ SqlProc ]
{
}

ClassMethod QryReportPatExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	
	Set chkY="☑",chkN="□",space="    "	// ☑gou■hei□bai
	
	Set CardNo=objReport.FRCardNo	// 卡号
	Set (StatusID,StatusCode,StatusDesc)=""	// 状态
	Set StatusDr=objReport.FRStatusDr
	If $IsObject(StatusDr) {
		Set StatusID=StatusDr.%Id()
		Set StatusCode=StatusDr.Code
		Set StatusDesc=StatusDr.Description
	}
	Set (DiseaseID,DiseaseDesc,CateID,CateDesc)=""	// 疾病
	Set DiseaseDr=objReport.FRDiseaseDr
	If $IsObject(DiseaseDr) {
		Set DiseaseID=DiseaseDr.%Id()
		Set DiseaseDesc=DiseaseDr.IDDesc
		Set CateDr=DiseaseDr.IDCateDr
		If (CateDr) {
			Set CateID=CateDr.%Id()
			Set CateDesc=CateDr.Description
		}
	}
	Set DiseaseText=objReport.FRDiseaseText
	Set ReportLoc=objReport.FRReportLoc	// 科室
	Set HospitalDr=""
	set:ReportLoc'="" HospitalDr=+$p($g(^CTLOC(+ReportLoc)),"^",22)
	Set ReportLocDesc=""
	Set objReportLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
	If $IsObject(objReportLoc) {
		Set ReportLocDesc=objReportLoc.Descs
	}
	Set (PatName,Sex,Birthday,PersonalID,Nation,OPNo,IPNo)=""
	Set (PatAge,Age,AgeMonth,AgeDay,PapmiNo,AdmType)=""
	Set PatientObj=objReport.FRPatientObj //DHCMed.FBD.ReportPat
	If $IsObject(PatientObj) {
		Set PatName=PatientObj.RPPatName
		Set Sex=PatientObj.RPSex
		Set Birthday=PatientObj.RPBirthday
		Set:Birthday'="" Birthday=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
		Set PersonalID=PatientObj.RPPersonalID
		Set Nation=PatientObj.RPNation
		Set OPNo=PatientObj.RPOPNo
		Set IPNo=PatientObj.RPIPNo
	}
	Set EpisodeID=objReport.FREpisodeID
	Set objPatientAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	If $IsObject(objPatientAdm) {
		Set AdmType=objPatientAdm.AdmType
	}
	Set AdmTypeDesc=$s(AdmType="O":"门诊",AdmType="I":"病区",AdmType="E":"急诊",1:"")
	Set PatientID=objReport.FRPatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient) {
		Set:(PatName="") PatName=objPatient.PatientName
		Set:(Sex="") Sex=objPatient.Sex
		Set:(Birthday="") Birthday=objPatient.Birthday
		Set Age=objPatient.Age
		Set AgeMonth=objPatient.AgeMonth
		Set AgeDay=objPatient.AgeDay
		Set PapmiNo=objPatient.PapmiNo	// 登记号
		If (Age>0) {
			Set PatAge=Age_"岁"
		} ElseIf (AgeMonth>0) {
			Set PatAge=AgeMonth_"月"
		} Else {
			Set PatAge=AgeDay_"天"
		}
	}
	Set SexDesc=chkN_"男"_space_chkN_"女"
	Set $e(SexDesc,$f(SexDesc,Sex)-2)=chkY
	Set BirthdayDesc=Birthday
	
	Set (OccupationID,OccupationCode,OccupationDesc)=""	// 职业
	Set OccupationDr=objReport.FROccupationDr
	If $IsObject(OccupationDr) {
		Set OccupationID=OccupationDr.%Id()
		Set OccupationCode=OccupationDr.Code
		Set OccupationDesc=OccupationDr.Description
	}
	Set (AreaID,AreaCode,AreaDesc)=""	// 地址
	Set AreaDr=objReport.FRAreaDr
	If $IsObject(AreaDr) {
		Set AreaID=AreaDr.%Id()
		Set AreaCode=AreaDr.Code
		Set AreaDesc=AreaDr.Description
	}
	Set CurrAddress=objReport.FRCurrAddress
	Set CurrProvince=objReport.FRCurrProvince
	Set CurrCity=objReport.FRCurrCity
	Set CurrCounty=objReport.FRCurrCounty
	Set CurrVillage=objReport.FRCurrVillage
	Set CurrRoad=objReport.FRCurrRoad
	Set Address=CurrProvince_CurrCity_CurrCounty_CurrVillage_CurrRoad
	Set (IsInHospDesc,IsUseAntiDesc)=chkN_"是"_space_chkN_"否"
	Set IsInHosp=objReport.FRIsInHosp
	Set IsInHosp=$s(+IsInHosp=1:"是",1:"否")
	Set $e(IsInHospDesc,$f(IsInHospDesc,IsInHosp)-2)=chkY
	Set IsUseAnti=objReport.FRIsUseAnti
	Set IsUseAnti=$s(+IsUseAnti=1:"是",1:"否")
	Set $e(IsUseAntiDesc,$f(IsUseAntiDesc,IsUseAnti)-2)=chkY
	Set UseAntiDesc=objReport.FRUseAntiDesc
	Set Contactor=objReport.FRContactor
	Set Telephone=objReport.FRTelephone
	Set Company=objReport.FRCompany
	Set (SickDT,AdmitDT,DeathDT)="    年  月  日  时"
	Set SickDate=objReport.FRSickDate
	Set SickDate=$zd(SickDate,3)
	Set SickTime=objReport.FRSickTime
	Set SickTime=$zt(SickTime)
	If (SickDate'="1840-12-31") {
		Set SickDT=$p(SickDate,"-",1)_"年"_$p(SickDate,"-",2)_"月"_$p(SickDate,"-",3)_"日"_$p(SickTime,":",1)_"时"
	}
	Set AdmitDate=objReport.FRAdmitDate
	Set AdmitDate=$zd(AdmitDate,3)
	Set AdmitTime=objReport.FRAdmitTime
	Set AdmitTime=$zt(AdmitTime)
	If (AdmitDate'="1840-12-31") {
		Set AdmitDT=$p(AdmitDate,"-",1)_"年"_$p(AdmitDate,"-",2)_"月"_$p(AdmitDate,"-",3)_"日"_$p(AdmitTime,":",1)_"时"
	}
	Set DeathDate=objReport.FRDeathDate
    Set DeathDate=$zd(DeathDate,3)
	Set DeathTime=objReport.FRDeathTime
	Set DeathTime=$zt(DeathTime)
	If (DeathDate'="1840-12-31") {
    	Set DeathDT=$p(DeathDate,"-",1)_"年"_$p(DeathDate,"-",2)_"月"_$p(DeathDate,"-",3)_"日"_$p(DeathTime,":",1)_"时"
	}
	Set PreDiagnos=objReport.FRPreDiagnos
	Set Anamnesis=objReport.FRAnamnesis
	Set (RepUserName,ChkUserName)=""
	Set ReportUser=objReport.FRReportUser
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
	Set:$IsObject(objRepUser) RepUserName=objRepUser.Name
	Set CheckUser=objReport.FRCheckUser
	Set objChkUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	Set:$IsObject(objChkUser) ChkUserName=objChkUser.Name
	Set ReportDate=objReport.FRReportDate
	Set ReportDate=$zd(ReportDate,3)
	Set ReportTime=objReport.FRReportTime
	Set ReportTime=$zt(ReportTime)
	Set ReportDT="    年  月  日"
	If (ReportDate'="1840-12-31") {
		Set ReportDT=$p(ReportDate,"-",1)_"年"_$p(ReportDate,"-",2)_"月"_$p(ReportDate,"-",3)_"日"
	}
	Set CheckDate=objReport.FRCheckDate
	Set CheckDate=$zd(CheckDate,3)
	Set CheckTime=objReport.FRCheckTime
	Set CheckTime=$zt(CheckTime)
	Set Resume=objReport.FRResume
	Set HospitalDesc=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-HospitalDesc","")	
	// 为空取是否没有院区
	if (HospitalDesc=""){
		Set HospitalDesc=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-HospitalDesc",HospitalDr)
	}
	/*Set PreDiagnosDrs=objReport.FRPreDiagnosDrs   //初步诊断
	Set PreDiagnosList=""
	For indm=1:1:PreDiagnosDrs.Count(){
		Set objDic=PreDiagnosDrs.GetAt(indm)
		Continue:'$IsObject(objDic)
		Set PreDiagnosList=PreDiagnosList_","_objDic.Description
	}
	Set:PreDiagnosList'="" PreDiagnosList=$e(PreDiagnosList,2,$l(PreDiagnosList))
	Set PreDiagnos=objReport.FRPreDiagnos
	Set:PreDiagnos'="" PreDiagnosList=$replace(PreDiagnosList,"其他",PreDiagnos)
    Set PreDiagnoss = ..GetDicList("FBDPreDiagnos",PreDiagnosList)
    
	Set AnamnesisDrs=objReport.FRAnamnesisDrs                             //既往病史
	Set AnamnesisList=""
	For indn=1:1:AnamnesisDrs.Count() {
		Set objDic=AnamnesisDrs.GetAt(indn)
		Continue:'$IsObject(objDic)
		Set AnamnesisList=AnamnesisList_","_objDic.Description
	}
	Set:AnamnesisList'="" AnamnesisList=$e(AnamnesisList,2,$l(AnamnesisList))
	Set Anamnesis=objReport.FRAnamnesis
	Set:Anamnesis'="" AnamnesisDrsList=$replace(AnamnesisList,"其他",Anamnesis)
	Set Anamnesiss = ..GetDicList("FBDAnamnesis",AnamnesisList)*/
	Set PreDiagnoss = ""
	Set Anamnesiss  = ""
	Set ExamResult=objReport.FRExamResult                             // 检测结果   				
	Set Data=$lb(EpisodeID,CardNo,OPNo,IsInHospDesc,IPNo,PatName,SexDesc,Contactor,PersonalID,BirthdayDesc,Telephone,Company,AreaCode,AreaDesc,Address,OccupationCode,OccupationDesc,SickDT,AdmitDT,DeathDT,IsUseAntiDesc,UseAntiDesc,PreDiagnos,Anamnesis,HospitalDesc,RepUserName,ReportDT,PreDiagnoss,Anamnesiss,CateDesc,ExamResult,DiseaseDesc)	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QryReportPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// w ##Class(DHCMed.FBDService.ReportSrv).GetDicList("FBDPreDiagnos","")
ClassMethod GetDicList(aDicType As %String, aDicDesc As %String)
{
	New (aDicType,aDicDesc)
	Set return=""
	Quit:aDicType="" return
	
	Set aDicDesc=","_aDicDesc_","
	
	Set xID=0,Number=0,IsHave=0
 	For {
	 	Set xID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$zcvt(aDicType,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(objDic)
	 	
		Set IsActive=objDic.Active
		Continue:IsActive'=1
	 	Set Code=objDic.Code
		Set Description=objDic.Description
		Set Type=objDic.Type
		Continue:aDicType'=Type
		
		Set Number=Number+1
		Set:Number>1 return=return_"  "
		
		Set tmpDescription=","_Description_","
		If aDicDesc[tmpDescription {
			Set return=return_"☑"_Description
			Set IsHave=1
		} Else {
			Set return=return_"□"_Description
		}
	}
	
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-12-02
/// Description:  查询体征信息
/// Table：       DHCMed.FBD.ReportSign
///               DHCMed.FBD.SignDic
/// Input：       ReportID : 报告ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.ReportSrv","QryReportSign","1","1")
Query QryReportSign(aReportID As %String, aType As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,ExtraTypeID:%String,ExtraTypeDesc:%String,ExtraUnit:%String,Resume:%String,ExtraText:%String,Impl:%String,chkID:%String") [ SqlProc ]
{
}

ClassMethod QryReportSignExecute(ByRef qHandle As %Binary, aReportID As %String, aType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	if (aType=1){
		Set objReport=##class(DHCMed.FBD.SusAbRep).GetObjById(aReportID)
	}else{
		Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)	
	}
	
	Set xCode=""
	For {
		Set xCode=$o(^DHCMed.FBD.SignDicI("IndexCode",xCode))
		Quit:(xCode="")
		Set TypeCode=$e(xCode,2,2)
		Continue:(aType=1)&&(TypeCode'=1)	
		Continue:(aType'=1)&&(TypeCode'=0)	
		
		Continue:(($l(xCode)-1)#3'=0)
		Set xID=""
		For {
			Set xID=$o(^DHCMed.FBD.SignDicI("IndexCode",xCode,xID))
			Quit:(xID="")
			Set objSignDic=##class(DHCMed.FBD.SignDic).GetObjById(xID)
			Continue:'$IsObject(objSignDic)
			Set Code=objSignDic.SDCode
			Set Desc=objSignDic.SDDesc
			Set:Desc'="" Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.FBD.SignDic","SDDesc","",Desc)
			Set ExtraType=objSignDic.SDExtraType
			Set ExtraUnit=objSignDic.SDExtraUnit
			Set:ExtraUnit'="" ExtraUnit = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.FBD.SignDic","SDDesc","",ExtraUnit)
			
			Set IsActive=objSignDic.SDIsActive
			Continue:(IsActive=0)
			Set Resume=objSignDic.SDResume
			Set (ExtraTypeID,ExtraTypeDesc)=""
			If $IsObject(ExtraType) {
				Set ExtraTypeID=ExtraType.%Id()
				Set ExtraTypeDesc=ExtraType.Description
				Set ExtraTypeDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",ExtraTypeDesc)	
			}
			Set ExtraText="",Impl=0,chkID=""
			If $IsObject(objReport) {
				If (aType=1) {   //疑似食源性疾病
					If $d(^DHCMed.FBD.SusAbRepI("RSI","IndexSign",xID,aReportID)) {
						Set yID=$o(^DHCMed.FBD.SusAbRepI("RSI","IndexSign",xID,aReportID,""))
					
						Set:(+yID'=0) chkID=aReportID_"||"_yID
						Set objSign=##class(DHCMed.FBD.SusAbRepSign).GetObjById(chkID)
						If $IsObject(objSign) {
							Set ExtraText=objSign.RSExtraText
							Set Impl=1
						}
					}
				}else {
					If $d(^DHCMed.FBD.ReportI("RSI","IndexSign",xID,aReportID)) {
						Set yID=$o(^DHCMed.FBD.ReportI("RSI","IndexSign",xID,aReportID,""))
						Set:(+yID'=0) chkID=aReportID_"||"_yID
						Set objSign=##class(DHCMed.FBD.ReportSign).GetObjById(chkID)
						If $IsObject(objSign) {
							Set ExtraText=objSign.RSExtraText
							Set Impl=1
						}
					}
				}
			}
			Set Data=$lb(xID,Code,Desc,ExtraTypeID,ExtraTypeDesc,ExtraUnit,Resume,ExtraText,Impl,chkID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryReportSignClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportSignExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportSignFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportSignExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-28
/// Description:  查询暴露信息
/// Table：       DHCMed.FBD.ReportFood
/// Input：       ReportID : 报告ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.ReportSrv","QryReportFood","")
Query QryReportFood(aReportID As %String) As %Query(ROWSPEC = "ind:%String,ID:%String,FoodName:%String,FoodBrand:%String,Manufacturer:%String,WhereToBuy:%String,EatingPlaces:%String,EatingDate:%String,EatingTime:%String,EatingNum:%String,IsIncidence:%String,IsIncidenceDesc:%String,IsSampling:%String,IsSamplingDesc:%String,FoodTypeID:%String,FoodType:%String,PackingID:%String,Packing:%String,EatingSiteCateID:%String,EatingSiteCateCode:%String,EatingSiteCate:%String,EatingSiteID:%String,EatingSite:%String,BuySiteCateID:%String,BuySiteCateCode:%String,BuySiteCate:%String,BuySiteID:%String,BuySite:%String,EatingTypeID:%String,EatingType:%String,EatingTypeDesc:%String,EatProvince:%String,EatProvinceDesc:%String,EatCity:%String,EatCityDesc:%String,EatCounty:%String,EatCountyDesc:%String,BuyTypeID:%String,BuyType:%String,BuyTypeDesc:%String,BuyProvince:%String,BuyProvinceDesc:%String,BuyCity:%String,BuyCityDesc:%String,BuyCounty:%String,BuyCountyDesc:%String") [ SqlProc ]
{
}

ClassMethod QryReportFoodExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objReport) $$$OK
	Set SubID=""
	For {
		Set SubID=$o(^DHCMed.FBD.ReportD(aReportID,"F",SubID))
		Quit:(SubID="")
		Set ID=aReportID_"||"_SubID
		Set objFood=##class(DHCMed.FBD.ReportFood).GetObjById(ID)
		Continue:'$IsObject(objFood)
		Set FoodName=objFood.RFFoodName
		Set FoodBrand=objFood.RFFoodBrand
		Set Manufacturer=objFood.RFManufacturer
		Set WhereToBuy=objFood.RFWhereToBuy
		Set EatingPlaces=objFood.RFEatingPlaces
		Set EatingDate=objFood.RFEatingDate
		Set:(EatingDate'="") EatingDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EatingDate)
		Set EatingTime=objFood.RFEatingTime
		Set:(EatingTime'="") EatingTime=$zt(EatingTime)
		Set EatingNum=objFood.RFEatingNum
		Set IsIncidence=objFood.RFIsIncidence
		Set YesInfo = "是"
		Set YesInfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",YesInfo)	
		Set NotInfo = "否"
		Set NotInfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",NotInfo)	
		Set IsIncidenceDesc=$s(IsIncidence=1:YesInfo,1:NotInfo)
		Set IsSampling=objFood.RFIsSampling
		Set IsSamplingDesc=$s(IsSampling=1:YesInfo,1:NotInfo)
		
		Set (FoodTypeID,FoodType)=""
		If $IsObject(objFood.RFFoodType) {
			Set FoodTypeID=objFood.RFFoodType.%Id()
			Set FoodTypeCode=objFood.RFFoodType.Code
			Set FoodType=objFood.RFFoodType.Description
			Set FoodType = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",FoodType)	
			
		}      
		Set (PackingID,PackingCode,Packing)=""
		If $IsObject(objFood.RFPacking) {
			Set PackingID=objFood.RFPacking.%Id()
			Set PackingCode=objFood.RFPacking.Code
			Set Packing=objFood.RFPacking.Description
			Set Packing = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",Packing)
		}             

		Set (EatingSiteCateID,EatingSiteCateCode,EatingSiteCate)=""
		If $IsObject(objFood.RFEatingSiteCate) {
			Set EatingSiteCateID=objFood.RFEatingSiteCate.%Id()
			Set EatingSiteCateCode=objFood.RFEatingSiteCate.Code
			Set EatingSiteCate=objFood.RFEatingSiteCate.Description
			Set EatingSiteCate = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",EatingSiteCate)
		}      

		Set (EatingSiteID,EatingSiteCode,EatingSite)=""
		If $IsObject(objFood.RFEatingSite) {
			Set EatingSiteID=objFood.RFEatingSite.%Id()
			Set EatingSiteCode=objFood.RFEatingSite.Code
			Set EatingSite=objFood.RFEatingSite.Description
			Set EatingSite = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",EatingSite)
		}         
		
		Set (BuySiteCateID,BuySiteCateCode,BuySiteCate)=""
		If $IsObject(objFood.RFBuySiteCate) {
			Set BuySiteCateID=objFood.RFBuySiteCate.%Id()
			Set BuySiteCateCode=objFood.RFBuySiteCate.Code
			Set BuySiteCate=objFood.RFBuySiteCate.Description
			Set BuySiteCate = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",BuySiteCate)
		}         
		Set BuySite=objFood.RFBuySite
		Set (BuySiteID,BuySiteCode,BuySite)=""
		If $IsObject(objFood.RFBuySite) {
			Set BuySiteID=objFood.RFBuySite.%Id()
			Set BuySiteCode=objFood.RFBuySite.Code
			Set BuySite=objFood.RFBuySite.Description
			Set BuySite = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",BuySite)
		}             
		
		Set (EatingTypeID,EatingType,EatingTypeDesc)=""
		If $IsObject(objFood.RFEatingType) {
			Set EatingTypeID=objFood.RFEatingType.%Id()
			Set EatingType=objFood.RFEatingType.Code
			Set EatingTypeDesc=objFood.RFEatingType.Description
			Set EatingTypeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",EatingTypeDesc)
		}
		Set (EatProvinceDesc,EatCityDesc,EatCountyDesc)=""            
		Set EatProvince=objFood.RFEatProvince
		If (EatProvince'="") {
			Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(EatProvince)
			If $IsObject(objArea)  {
				Set EatProvinceDesc = objArea.ShortDesc
				Set EatProvinceDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc","",EatProvinceDesc)	
			} 
		}
		Set EatCity=objFood.RFEatCity 
		If (EatCity'="") { 
			Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(EatCity)
			If $IsObject(objArea)  {
				Set EatCityDesc = objArea.ShortDesc
				Set EatCityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc","",EatCityDesc)
			}   	     
		}
		Set EatCounty=objFood.RFEatCounty 
		If (EatCounty'="") {
			Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(EatCounty)
			If $IsObject(objArea)  {
				Set EatCountyDesc = objArea.ShortDesc
				Set EatCountyDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc","",EatCountyDesc)
			}   
		}    	
		Set (BuyTypeID,BuyType,BuyTypeDesc)=""
		If $IsObject(objFood.RFBuyType) {
			Set BuyTypeID=objFood.RFBuyType.%Id()
			Set BuyType=objFood.RFBuyType.Code
			Set BuyTypeDesc=objFood.RFBuyType.Description
			Set BuyTypeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",BuyTypeDesc)
		}
		Set (BuyProvinceDesc,BuyCityDesc,BuyCountyDesc)=""            
		Set BuyProvince=objFood.RFBuyProvince
		If (BuyProvince'="") { 
			Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(BuyProvince)
			If $IsObject(objArea)  {
				Set BuyProvinceDesc = objArea.ShortDesc
				Set BuyProvinceDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc","",BuyProvinceDesc)	
			}     
		}
		Set BuyCity=objFood.RFBuyCity 
		If (BuyCity'="") {
			Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(BuyCity) 
			If $IsObject(objArea)  {
				Set BuyCityDesc = objArea.ShortDesc
				Set BuyCityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc","",BuyCityDesc)
			}         
		}
		Set BuyCounty=objFood.RFBuyCounty  
		If (BuyCounty'="") {
			Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(BuyCounty)
			If $IsObject(objArea)  {
				Set BuyCountyDesc = objArea.ShortDesc
				Set BuyCountyDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc","",BuyCountyDesc)
			}       
		}
		Set DomesticInfo = "境内"
		Set DomesticInfo = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",DomesticInfo)
		
		if ((EatingTypeDesc=DomesticInfo)&&(EatingPlaces'[EatProvinceDesc)){
			Set EatingPlaces = EatProvinceDesc_EatCityDesc_EatCountyDesc_EatingPlaces
		}
		if ((BuyTypeDesc=DomesticInfo)&&(WhereToBuy'[BuyProvinceDesc)){
			Set WhereToBuy = BuyProvinceDesc_BuyCityDesc_BuyCountyDesc_WhereToBuy
		}
		Set Data=$lb(ind,ID,FoodName,FoodBrand,Manufacturer,WhereToBuy,EatingPlaces,EatingDate,EatingTime,EatingNum,IsIncidence,IsIncidenceDesc,IsSampling,IsSamplingDesc)
		Set Data=Data_$lb(FoodTypeID,FoodType,PackingID,Packing,EatingSiteCateID,EatingSiteCateCode,EatingSiteCate,EatingSiteID,EatingSite,BuySiteCateID,BuySiteCateCode,BuySiteCate,BuySiteID,BuySite)
		Set Data=Data_$lb(EatingTypeID,EatingType,EatingTypeDesc,EatProvince,EatProvinceDesc,EatCity,EatCityDesc,EatCounty,EatCountyDesc,BuyTypeID,BuyType,BuyTypeDesc,BuyProvince,BuyProvinceDesc,BuyCity,BuyCityDesc,BuyCounty,BuyCountyDesc)
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryReportFoodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportFoodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportFoodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportFoodExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-28
/// Description:  查询生物样本采集
/// Table：       DHCMed.FBD.ReportSample
/// Input：       ReportID : 报告ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.ReportSrv","QryReportSample","")
Query QryReportSample(aReportID As %String) As %Query(ROWSPEC = "ind:%String,ID:%String,SampleNo:%String,SampleTypeID:%String,SampleTypeDesc:%String,SampleNumber:%String,SampleUnitID:%String,SampleUnitDesc:%String,SampleDate:%String,Resume:%String") [ SqlProc ]
{
}

ClassMethod QryReportSampleExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objReport) $$$OK
	Set SubID=""
	For {
		Set SubID=$o(^DHCMed.FBD.ReportD(aReportID,"SA",SubID))
		Quit:(SubID="")
		Set ID=aReportID_"||"_SubID
		Set objSample=##class(DHCMed.FBD.ReportSample).GetObjById(ID)
		Continue:'$IsObject(objSample)
		Set SampleNo=objSample.RSNo
		Set SampleNumber=objSample.RSNumber
		Set (SampleTypeID,SampleTypeDesc,SampleUnitID,SampleUnitDesc)=""
		If $IsObject(objSample.RSType) {
			Set SampleTypeID=objSample.RSType.%Id()
			Set SampleTypeDesc=objSample.RSType.Description
		}
		If $IsObject(objSample.RSUnit) {
			Set SampleUnitID=objSample.RSUnit.%Id()
			Set SampleUnitDesc=objSample.RSUnit.Description
		}
		Set SampleDate=objSample.RSDate
		Set:(SampleDate'="") SampleDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SampleDate)
		Set Resume=objSample.RSResume
		Set Data=$lb(ind,ID,SampleNo,SampleTypeID,SampleTypeDesc,SampleNumber,SampleUnitID,SampleUnitDesc,SampleDate,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryReportSampleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportSampleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportSampleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportSampleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)	// Save QHandle
	Quit $$$OK
}

/// Creator：     zhaoyu
/// CreatDate：   2014-12-11
/// Description:  获取住院、门诊号
/// Table：       Pa_Patmas
/// Input：       PatientID : ID
/// Return：      住院号^门诊号
/// w ##Class("DHCMed.FBDService.ReportSrv").GetIPOPNo("")
ClassMethod GetIPOPNo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:(aEpisodeID="")!(PatientID="") return
	//Set IPNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)	// IPNo
	//Set OPNo=$p($g(^PAPER(PatientID,"PAT",2)),"^",2)	// OPNo
	//Set IPNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(aEpisodeID)	// 新版病案号(非最新版)
	//Set IPNo=##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",aEpisodeID)	// 旧版病案号
	//Set OPNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)	// 登记号
	Set (IPNo,OPNo)=""
	Set AdmType=$p($g(^PAADM(+aEpisodeID)),"^",2)
	Set:AdmType="I" IPNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(aEpisodeID,"I")
	Set:AdmType="O" OPNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(aEpisodeID,"O")
	Set return=IPNo_"^"_OPNo
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-12-15
/// Description:  获取病人基本信息
/// Table：       
/// Input：       ReportID : 报告ID
/// Return：      obj
/// w ##class(DHCMed.FBDService.ReportSrv).GetPatientObj("")
ClassMethod GetPatientObj(aReportID As %String) As DHCMed.FBD.ReportPat
{
	New (aReportID)
	Set return=""
	Quit:(aReportID="") return
	Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)
	If $IsObject(objReport) {
		Set PatientObj=objReport.FRPatientObj
		If $IsObject(PatientObj) {
			Set return=PatientObj
		}
	}
	Quit return
}

/// w ##class(DHCMed.FBDService.ReportSrv).GetFBDNo("","","")
ClassMethod GetFBDNo(aHospID As %String, aNoType As %String, aExtraValue As %String) As %String
{
	New (aHospID,aNoType,aExtraValue)
	Set return=""
	Set NoType=$s(aNoType=1:"ReportNo",aNoType=2:"SampleNo",1:"")
	Set ProvCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-ProvinceCode",aHospID)
	Set AreaCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-AreaCode",aHospID)
	Set HospCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-HospitalCode",aHospID)
	Quit:(NoType="")||(ProvCode="")||(AreaCode="")||(HospCode="") return
	Set IndexDate=$p($zd(+$h,3),"-",1)
	Set SerialCnt=$i(^DHCMed.FBD(NoType,IndexDate))
	If $l(SerialCnt)<4 {
		Set $p(SerialNo,"0",5-$l(SerialCnt))=SerialCnt
	} Else {
		Set SerialNo=SerialCnt
	}
	Set return=ProvCode_AreaCode_HospCode_IndexDate_SerialNo
	If (NoType="SampleNo")&&(aExtraValue'="") {
		Set SampleCode=""
		Set SampleType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-SampleType",aHospID)
		Set SampleType=$tr(SampleType,"，",",")
		If $l(SampleType,",")>0 {
			For SampleInd=1:1:$l(SampleType,",") {
				Set tmpSample=$p(SampleType,",",SampleInd)
				Set tmpValue=$p(tmpSample,"-",1)
				Set tmpCode=$p(tmpSample,"-",2)
				Set:(aExtraValue=tmpValue) SampleCode=tmpCode
			}
		}
		Set return=return_SampleCode
	}
	Quit return
}

/// w ##class(DHCMed.FBDService.ReportSrv).GetDicForCheckGroup("","")
ClassMethod GetDicForCheckGroup(aType As %String, aActive As %String) As %String
{
	New (aType,aActive)
	Set return=""
	Quit:(aType="") return
	Set rs=##class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute(aType,aActive)
	While (rs.Next()) {
		Set Code=rs.Get("Code")
		Set Desc=rs.Get("Description")
		Set return=return_Code_"^"_Desc_","
	}
	Do rs.Close()
	Set:(return'="") return=$e(return,1,$l(return)-1)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-10-15
/// Description:  修改获取食源性疾病返回对象的方法
/// Table：       DHCMed.FBD.Report
/// Input：       ID: DHCMed.FBD.Report
/// Return：      返回obj
/// W ##class(DHCMed.FBDService.ReportSrv).GetObjById("1")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.Report
{
	New (aID)
	Set return = "{}"
	
	quit:aID="" return
	quit:'##class(DHCMed.FBD.Report).%ExistsId(+aID) return
	set obj=##Class(DHCMed.FBD.Report).%OpenId(+aID)
	set return=obj
	do obj.%Close()
	Quit return
}

/// Description:  获取病人基本信息
/// Table：       
/// Input：       ReportID : 报告ID
/// Return：      字符串
/// w ##class(DHCMed.FBDService.ReportSrv).GetPatByRepID("")  //DHCMed.FBD.ReportPat
ClassMethod GetPatByRepID(aReportID As %String) As %String
{
	New (aReportID)
	Set return = "{}"
	Quit:(aReportID="") return
	Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)
	If $IsObject(objReport) {
		Set PatientObj=objReport.FRPatientObj
		If $IsObject(PatientObj) {
			Set Birthday = PatientObj.RPBirthday
			Set:Birthday'="" Birthday = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
			Set return=PatientObj.RPPatName_"^"_PatientObj.RPSex_"^"_Birthday_"^"_PatientObj.RPPersonalID_"^"_PatientObj.RPNation_"^"_PatientObj.RPOPNo_"^"_PatientObj.RPIPNo
		}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-10-15
/// Description:  获取病人基本信息
/// Table：       
/// Input：       ReportID : 报告ID
/// Return：      obj
/// w ##class(DHCMed.FBDService.ReportSrv).GetPatObject("")
ClassMethod GetPatObject(aReportID As %String) As DHCMed.FBD.ReportPat
{
	New (aReportID)
	Set return = "{}"
	Quit:(aReportID="") return
	Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)
	If $IsObject(objReport) {
		Set PatientObj=objReport.FRPatientObj
		If $IsObject(PatientObj) {
			Set return=PatientObj
		}
	}
	Quit return
}

}
