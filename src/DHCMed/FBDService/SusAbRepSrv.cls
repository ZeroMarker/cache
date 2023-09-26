/// 名称: DHCMed.FBDService.SusAbRepSrv
/// 描述: 食源性疾病报告
Class DHCMed.FBDService.SusAbRepSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 查询病人历史报卡Qry
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.SusAbRepSrv","QrySusAbRepByPapmi","")
Query QrySusAbRepByPapmi(aPatientID As %String) As %Query(ROWSPEC = "RowID:%String,PatName:%String,Sex:%String,PatAge:%String,PapmiNo:%String,CardNo:%String,CateDesc:%String,DiseaseDesc:%String,SickDateTime:%String,StatusDesc:%String,RepUserName:%String,RepDateTime:%String,ReportLocDesc:%String,ChkUserName:%String,ChkDateTime:%String,EncryptLevel:%String,PatLevel:%String") [ SqlProc ]
{
}

ClassMethod QrySusAbRepByPapmiExecute(ByRef qHandle As %Binary, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(aPatientID="") $$$OK
	Set xID=""
	For {
		Set xID=$o(^DHCMed.FBD.SusAbRepI("IndexPatientID"," "_$ZCVT(aPatientID,"U"),xID),-1)
		Quit:(xID="")
		Set objReport=##class(DHCMed.FBD.SusAbRep).GetObjById(xID)
		Continue:'$IsObject(objReport)
		Set (StatusID,StatusCode,StatusDesc)=""
		Set StatusDr=objReport.FRStatusDr
		If $IsObject(StatusDr) {
			Set StatusID=StatusDr.%Id()
			Set StatusCode=StatusDr.Code
			Set StatusDesc=StatusDr.Description
			Set StatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",StatusDesc)	
			
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
				Set CateDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",CateDesc)	
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
		Set:RepUserName'="" RepUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",RepUserName)
		
		Set CheckUser=objReport.FRCheckUser
		Set objChkUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
		Set:$IsObject(objChkUser) ChkUserName=objChkUser.Name
		Set:ChkUserName'="" ChkUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",ChkUserName)
		    
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
			Set ReportLocDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",ReportLocDesc)
		}
		Set Data=$lb(xID,PatName,Sex,PatAge,PapmiNo,CardNo,CateDesc,DiseaseDesc,SickDateTime,StatusDesc,RepUserName,RepDateTime,ReportLocDesc,ChkUserName,ChkDateTime,EncryptLevel,PatLevel)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QrySusAbRepByPapmiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByPapmiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySusAbRepByPapmiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByPapmiExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2019-12-23
/// Description:  查询疑似食源性疾病报告
/// Table：       DHCMed.FBD.SusAbRep
/// Input：       ProductCode : 产品代码
///               IsActive ：是否有效
///               CateID : 分类ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.SusAbRepSrv","QryReportByDate","2019-10-28","2019-11-28","IndexReportDate","1","","","","","2,3")
Query QryReportByDate(aStaDate As %String, aEndDate As %String, aDateType As %String, aStatusList As %String, aRepLoc As %String, aPatType As %String, aDisCateID As %String, aDiseaseID As %String, aHospID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,PatAge:%String,AdmType:%String,AdmTypeDesc:%String,CardNo:%String,Contactor:%String,Telephone:%String,FixedTel:%String,RegAddress:%String,RegAdd:%String,CurrAddress:%String,Address:%String,CateID:%String,CateDesc:%String,DiseaseID:%String,DiseaseDesc:%String,DiseaseText:%String,Identify:%String,CardTypeID:%String,CardTypeDesc:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,ReasonID:%String,ReasonDesc:%String,OccupationID:%String,OccupationDesc:%String,IsInHosp:%String,IsInHospDesc:%String,MainSym:%String,OtherSym:%String,MainSign:%String,SusAbFood:%String,TestResult:%String,TestAssist:%String,SickDate:%String,SickTime:%String,AdmitDate:%String,AdmitTime:%String,LurkTime:%String,RepUserName:%String,ReportDate:%String,ReportTime:%String,ChkUserName:%String,CheckDate:%String,CheckTime:%String,ReportLoc:%String,ReportLocDesc:%String,PreDiagnosDrs:%String,PreDiagnos:%String,SusCauseList:%String,SusCause:%String") [ SqlProc ]
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
		Set xDate=$o(^DHCMed.FBD.SusAbRepI(aDateType,xDate))
		Quit:(xDate="")||(xDate>aEndDate)
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.FBD.SusAbRepI(aDateType,xDate,xTime))
			Quit:(xTime="")
			Set xID=""
			For {
				Set xID=$o(^DHCMed.FBD.SusAbRepI(aDateType,xDate,xTime,xID))
				Quit:(xID="")
				Set objReport=##class(DHCMed.FBD.SusAbRep).GetObjById(xID)
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
				Continue:ReportLoc=""
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
				
				
				Set CardNo=objReport.FRCardNo
				Set IsInHosp=objReport.FRIsInHosp
				Set IsInHospDesc=$s(+IsInHosp=1:"是",1:"否")
				Set Contactor=objReport.FRContactor
				Set Telephone=objReport.FRTelephone
				Set FixedTel=objReport.FRFixedTel
				Set (ReasonID,ReasonDesc)=""
				Set ReasonDr=objReport.FRcboReasonDr
				If $IsObject(ReasonDr) {
					Set ReasonID=ReasonDr.%Id()
					Set ReasonDesc=ReasonDr.Description
				}
				Set (CardTypeID,CardTypeDesc)=""
				Set CardTypeDr=objReport.FRCardTypeDR
				If $IsObject(CardTypeDr) {
					Set CardTypeID=CardTypeDr.%Id()
					Set CardTypeDesc=CardTypeDr.Description
				}
				Set Identify=objReport.FRIdentify
				Set RegAddress=objReport.FRRegAddress
				Set (RegProvinceID,RegProvinceDesc)=""
				Set RegProvinceDr=objReport.FRRegProvinceDr
				If $IsObject(RegProvinceDr) {
					Set RegProvinceID=RegProvinceDr.%Id()
					Set RegProvinceDesc=RegProvinceDr.ShortDesc
				}
				Set (RegCityID,RegCityDesc)=""
				Set RegCityDr=objReport.FRRegCityDr
				If $IsObject(RegCityDr) {
					Set RegCityID=RegCityDr.%Id()
					Set RegCityDesc=RegCityDr.ShortDesc
				}
				Set (RegCountyID,RegCountyDesc)=""
				Set RegCountyDr=objReport.FRRegCountyDr
				If $IsObject(RegProvinceDr) {
					Set RegCountyID=RegCountyDr.%Id()
					Set RegCountyDesc=RegCountyDr.ShortDesc
				}
				Set (RegVillageID,RegVillageDesc)=""
				Set RegVillageDr=objReport.FRRegVillageDr
				If $IsObject(RegVillageDr) {
					Set RegVillageID=RegVillageDr.%Id()
					Set RegVillageDesc=RegVillageDr.ShortDesc
				}
				Set RegRoad=objReport.FRRegRoad
				Set RegAdd=RegProvinceDesc_RegCityDesc_RegCountyDesc_RegVillageDesc_RegRoad
				
				Set CurrAddress=objReport.FRCurrAddress
				
				Set (CurrProvinceID,CurrProvinceDesc)=""
				Set CurrProvinceDr=objReport.FRCurrProvinceDr
				If $IsObject(CurrProvinceDr) {
					Set CurrProvinceID=CurrProvinceDr.%Id()
					Set CurrProvinceDesc=CurrProvinceDr.ShortDesc
				}
				
				Set (CurrCityID,CurrCityDesc)=""
				Set CurrCityDr=objReport.FRCurrCityDr
				If $IsObject(CurrCityDr) {
					Set CurrCityID=CurrCityDr.%Id()
					Set CurrCityDesc=CurrCityDr.ShortDesc
				}
				
				Set (CurrCountyID,CurrCountyDesc)=""
				Set CurrCountyDr=objReport.FRCurrCountyDr
				If $IsObject(CurrCountyDr) {
					Set CurrCountyID=CurrCountyDr.%Id()
					Set CurrCountyDesc=CurrCountyDr.ShortDesc
				}
				
				Set (CurrVillageID,CurrVillageDesc)=""
				Set CurrVillageDr=objReport.FRCurrVillageDr
				If $IsObject(CurrVillageDr) {
					Set CurrVillageID=CurrVillageDr.%Id()
					Set CurrVillageDesc=CurrVillageDr.ShortDesc
				}
				Set CurrRoad=objReport.FRCurrRoad
				Set Address=CurrProvinceDesc_CurrCityDesc_CurrCountyDesc_CurrVillageDesc_CurrRoad
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
				
				Set PreDiagnosDrs=objReport.FRPreDiagnosDrs   //初步诊断
				Set PreDiagnosList=""
				For indm=1:1:PreDiagnosDrs.Count(){
					Set objDic=PreDiagnosDrs.GetAt(indm)
					Continue:'$IsObject(objDic)
					Set PreDiagnosList=PreDiagnosList_","_objDic.Description
				}
				Set:PreDiagnosList'="" PreDiagnosList=$e(PreDiagnosList,2,$l(PreDiagnosList))
				Set PreDiagnos=objReport.FRPreDiagnos

				Set SusCauseDrs=objReport.FRSusCauseDrs                             //既往病史
				Set SusCauseList=""
				For indn=1:1:SusCauseDrs.Count() {
					Set objDic=SusCauseDrs.GetAt(indn)
					Continue:'$IsObject(objDic)
					Set SusCauseList=SusCauseList_","_objDic.Description
				}
				Set:SusCauseList'="" SusCauseList=$e(SusCauseList,2,$l(SusCauseList))
				Set SusCause=objReport.FRSusCause
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
				Set LurkTime=objReport.FRLurkTime
				Set MainSym=objReport.FRMainSym
				Set OtherSym=objReport.FROtherSym
				Set MainSign=objReport.FRMainSign
				Set SusAbFood=objReport.FRSusAbFood
				Set TestResult=objReport.FRTestResult
				Set TestAssist=objReport.FRTestAssist
				Set Data=$lb(xID,EpisodeID,PatientID,PapmiNo,PatName,Sex,PatAge,AdmType,AdmTypeDesc)
				Set Data=Data_$lb(CardNo,Contactor,Telephone,FixedTel,RegAddress,RegAdd,CurrAddress,Address)
				Set Data=Data_$lb(CateID,CateDesc,DiseaseID,DiseaseDesc,DiseaseText,Identify,CardTypeID,CardTypeDesc)
				Set Data=Data_$lb(StatusID,StatusCode,StatusDesc,ReasonID,ReasonDesc,OccupationID,OccupationDesc)
				Set Data=Data_$lb(IsInHosp,IsInHospDesc,MainSym,OtherSym,MainSign,SusAbFood,TestResult,TestAssist)
				Set Data=Data_$lb(SickDate,SickTime,AdmitDate,AdmitTime,LurkTime)
				Set Data=Data_$lb(RepUserName,ReportDate,ReportTime,ChkUserName,CheckDate,CheckTime)
				Set Data=Data_$lb(ReportLoc,ReportLocDesc,PreDiagnosList,PreDiagnos,SusCauseList,SusCause)
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

/// Creator：     chenrui
/// CreatDate：   2019-12-23
/// Description:  查询报告中患者信息
/// Table：       DHCMed.FBD.SusAbRep
/// Input：       ReportID : 报告ID
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.FBDService.SusAbRepSrv","QryReportPat","15")
Query QryReportPat(aReportID As %String) As %Query(ROWSPEC = "EpisodeID:%String,CardNo:%String,OPNo:%String,IsInHospDesc:%String,IPNo:%String,PatName:%String,SexDesc:%String,Contactor:%String,BirthdayDesc:%String,CardTypeDesc:%String,Identify:%String,LurkTime:%String,cboReasonDesc:%String,Telephone:%String,FixedTel:%String,MainSym:%String,OtherSym:%String,MainSign:%String,SusAbFood:%String,TestResult:%String,TestAssist:%String,RegAddress:%String,Address:%String,OccupationCode:%String,OccupationDesc:%String,SickDT:%String,AdmitDT:%String,PreDiagnos:%String,SusCause:%String,HospitalDesc:%String,RepUserName:%String,ReportDT:%String,PreDiagnosList:%String,SusCauseList:%String") [ SqlProc ]
{
}

ClassMethod QryReportPatExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objReport=##class(DHCMed.FBD.SusAbRep).GetObjById(aReportID)
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

	Set (CardTypeID,CardTypeCode,CardTypeDesc)=""	// 证件类型
	Set CardTypeDr=objReport.FRCardTypeDR
	If $IsObject(CardTypeDr) {
		Set CardTypeID=CardTypeDr.%Id()
		Set CardTypeCode=CardTypeDr.Code
		Set CardTypeDesc=CardTypeDr.Description
	}
	Set Identify=objReport.FRIdentify	//证件号

	
	Set RegAddress=objReport.FRRegAddress	//户籍地址
	Set (RegProvinceID,RegProvinceDesc)=""	// 户籍省
	Set RegProvinceDr=objReport.FRRegProvinceDr
	If $IsObject(RegProvinceDr) {
		Set RegProvinceID=RegProvinceDr.%Id()
		Set RegProvinceDesc=RegProvinceDr.ShortDesc
	}
	
	Set (RegCityID,RegCityDesc)=""	// 户籍市
	Set RegCityDr=objReport.FRRegCityDr
	If $IsObject(RegCityDr) {
		Set RegCityID=RegCityDr.%Id()
		Set RegCityDesc=RegCityDr.ShortDesc
	}
	
	Set (RegCountyID,RegCountyDesc)=""	// 户籍乡
	Set RegCountyDr=objReport.FRRegCountyDr
	If $IsObject(RegCountyDr) {
		Set RegCountyID=RegCountyDr.%Id()
		Set RegCountyDesc=RegCountyDr.ShortDesc
	}
	Set (RegVillageID,RegVillageDesc)=""	// 户籍乡
	Set RegVillageDr=objReport.FRRegVillageDr
	If $IsObject(RegVillageDr) {
		Set RegVillageID=RegVillageDr.%Id()
		Set RegVillageDesc=RegVillageDr.ShortDesc
	}
	Set RegRoad=objReport.FRRegRoad
	Set RegAddress=RegProvinceDesc_RegCityDesc_RegCountyDesc_RegVillageDesc_RegRoad
	
	Set CurrAddress=objReport.FRCurrAddress	//现住址
	Set (CurrProvinceID,CurrProvinceDesc)=""	// 现住省
	Set CurrProvinceDr=objReport.FRCurrProvinceDr
	If $IsObject(CurrProvinceDr) {
		Set CurrProvinceID=CurrProvinceDr.%Id()
		Set CurrProvinceDesc=CurrProvinceDr.ShortDesc
	}
	
	Set (CurrCityID,CurrCityDesc)=""	// 现住市
	Set CurrCityDr=objReport.FRCurrCityDr
	If $IsObject(CurrCityDr) {
		Set CurrCityID=CurrCityDr.%Id()
		Set CurrCityDesc=CurrCityDr.ShortDesc
	}
	
	Set (CurrCountyID,CurrCountyDesc)=""	// 现住乡
	Set CurrCountyDr=objReport.FRCurrCountyDr
	If $IsObject(CurrCountyDr) {
		Set CurrCountyID=CurrCountyDr.%Id()
		Set CurrCountyDesc=CurrCountyDr.ShortDesc
	}
	Set (CurrVillageID,CurrVillageDesc)=""	// 现住乡
	Set CurrVillageDr=objReport.FRCurrVillageDr
	If $IsObject(CurrVillageDr) {
		Set CurrVillageID=CurrVillageDr.%Id()
		Set CurrVillageDesc=CurrVillageDr.ShortDesc
	}
	Set CurrRoad=objReport.FRCurrRoad
	Set Address=CurrProvinceDesc_CurrCityDesc_CurrCountyDesc_CurrVillageDesc_CurrRoad
	
	Set (IsInHospDesc)=chkN_"是"_space_chkN_"否"
	Set IsInHosp=objReport.FRIsInHosp
	Set IsInHosp=$s(+IsInHosp=1:"是",1:"否")
	Set $e(IsInHospDesc,$f(IsInHospDesc,IsInHosp)-2)=chkY
	
	Set (cboReasonID,cboReasonCode,cboReasonDesc)=""	// 上报原因
	Set cboReasonDr=objReport.FRcboReasonDr
	If $IsObject(cboReasonDr) {
		Set cboReasonID=cboReasonDr.%Id()
		Set cboReasonCode=cboReasonDr.Code
		Set cboReasonDesc=cboReasonDr.Description
	}
	Set LurkTime=objReport.FRLurkTime	//潜伏时间
	
	Set Contactor=objReport.FRContactor
	Set Telephone=objReport.FRTelephone
	Set FixedTel=objReport.FRFixedTel
	
	Set MainSym=objReport.FRMainSym
	Set OtherSym=objReport.FROtherSym
	Set MainSign=objReport.FRMainSign
	Set SusAbFood=objReport.FRSusAbFood
	Set TestResult=objReport.FRTestResult
	Set TestAssist=objReport.FRTestAssist
	
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

	Set PreDiagnos=objReport.FRPreDiagnos
	Set SusCause=objReport.FRSusCause
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
	Set HospitalDesc=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-HospitalDesc","")	
	
	Set PreDiagnosDrs=objReport.FRPreDiagnosDrs   //初步诊断
	Set PreDiagnosList=""
	For indm=1:1:PreDiagnosDrs.Count(){
		Set objDic=PreDiagnosDrs.GetAt(indm)
		Continue:'$IsObject(objDic)
		Set PreDiagnosList=PreDiagnosList_","_objDic.Description
	}
	Set:PreDiagnosList'="" PreDiagnosList=$e(PreDiagnosList,2,$l(PreDiagnosList))
	Set PreDiagnos=objReport.FRPreDiagnos
	Set:PreDiagnos'="" PreDiagnosList=$replace(PreDiagnosList,"其他",PreDiagnos)
    Set PreDiagnoss =  ##class(DHCMed.FBDService.ReportSrv).GetDicList("FBDPreDiagnos",PreDiagnosList)
    
	Set SusCauseDrs=objReport.FRSusCauseDrs                             //既往病史
	Set SusCauseList=""
	For indn=1:1:SusCauseDrs.Count() {
		Set objDic=SusCauseDrs.GetAt(indn)
		Continue:'$IsObject(objDic)
		Set SusCauseList=SusCauseList_","_objDic.Description
	}
	Set:SusCauseList'="" SusCauseList=$e(SusCauseList,2,$l(SusCauseList))
	Set SusCause=objReport.FRSusCause
	Set:SusCause'="" SusCauseDrsList=$replace(SusCauseList,"其他",SusCause)
	Set SusCauses = ##class(DHCMed.FBDService.ReportSrv).GetDicList("FBDSusCause",SusCauseList)	
				
	Set Data=$lb(EpisodeID,CardNo,OPNo,IsInHospDesc,IPNo,PatName,SexDesc,Contactor,BirthdayDesc,CardTypeDesc,Identify,LurkTime,cboReasonDesc,Telephone,FixedTel,MainSym,OtherSym,MainSign,SusAbFood,TestResult,TestAssist,RegAddress,Address,OccupationCode,OccupationDesc,SickDT,AdmitDT,PreDiagnos,SusCause,HospitalDesc,RepUserName,ReportDT,PreDiagnoss,SusCauses)	
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

/// Creator：     pylian
/// CreatDate：   2018-10-15
/// Description:  修改获取食源性疾病返回对象的方法
/// Table：       DHCMed.FBD.SusAbRep
/// Input：       ID: DHCMed.FBD.SusAbRep
/// Return：      返回obj
/// W ##class(DHCMed.FBDService.SusAbRepSrv).GetObjById("1")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.SusAbRep
{
	New (aID)
	Set return = "{}"
	
	quit:aID="" return
	quit:'##class(DHCMed.FBD.SusAbRep).%ExistsId(+aID) return
	set obj=##Class(DHCMed.FBD.SusAbRep).%OpenId(+aID)
	set return=obj
	do obj.%Close()
	Quit return
}

/// Description:  获取病人基本信息
/// Table：       
/// Input：       ReportID : 报告ID
/// Return：      字符串
/// w ##class(DHCMed.FBDService.SusAbRepSrv).GetPatByRepID("")  //DHCMed.FBD.SusAbRep
ClassMethod GetPatByRepID(aReportID As %String) As %String
{
	New (aReportID)
	Set return = "{}"
	Quit:(aReportID="") return
	Set objReport=##class(DHCMed.FBD.SusAbRep).GetObjById(aReportID)
	If $IsObject(objReport) {
		Set PatientObj=objReport.FRPatientObj
		If $IsObject(PatientObj) {
			Set return=PatientObj.RPPatName_"^"_PatientObj.RPSex_"^"_PatientObj.RPBirthday_"^"_PatientObj.RPPersonalID_"^"_PatientObj.RPNation_"^"_PatientObj.RPOPNo_"^"_PatientObj.RPIPNo
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
/// w ##class(DHCMed.FBDService.SusAbRepSrv).GetPatObject("")
ClassMethod GetPatObject(aReportID As %String) As DHCMed.FBD.ReportPat
{
	New (aReportID)
	Set return = "{}"
	Quit:(aReportID="") return
	Set objReport=##class(DHCMed.FBD.SusAbRep).GetObjById(aReportID)
	If $IsObject(objReport) {
		Set PatientObj=objReport.FRPatientObj
		If $IsObject(PatientObj) {
			Set return=PatientObj
		}
	}
	Quit return
}

}
