/// 名称：DHCMed.EPDService.NCPInvestigationSrv
/// 描述：传染病疑似诊断服务
Class DHCMed.EPDService.NCPInvestigationSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator： pylian
/// CreatDate： 2020-02-11
/// Description: 查询患者个案调查登记
/// Table： DHCMed.EPD.NCPInvestigation
/// Input： PatientID
/// Return： ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.EPDService.NCPInvestigationSrv","QryReportByPat","61")
Query QryReportByPat(aPatientID As %String) As %Query(ROWSPEC = "RepoetID:%String,CardNo:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatientName:%String,PatientSex:%String,PatientAge:%String,Birthday:%String,Identity:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,SymPtomList:%String,ComplicationList:%String,PreAnamnesisList:%String,EPDRepID:%String,RepNo:%String,SeverityDesc:%String,DiagnoseDesc:%String,DiagDegreeDesc:%String,SickDate:%String,DiagDate:%String,ReportDate:%String,ReportTime:%String") [ SqlProc ]
{
}

ClassMethod QryReportByPatExecute(ByRef qHandle As %Binary, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:(aPatientID="") $$$OK
	Set xID=""
	For {
		
		Set xID=$o(^DHCMed.EPD.NCPInvestigationI("IndexPatientID"," "_$ZCVT(aPatientID,"U"),xID),-1)
		Quit:(xID="")
		Set objReport=##class(DHCMed.EPD.NCPInvestigation).GetObjById(xID)
		Continue:'$IsObject(objReport)
		Continue:'$IsObject(objReport.InvReportDr)
			
		Set CardNo           = objReport.InvCardNo
		Set EpisodeID        = objReport.InvEpisodeID
		Set PatientID        = objReport.InvPatientID
		Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	    Continue:'$IsObject(objPatient)
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatientName=objPatient.PatientName      //姓名
		Set PatientSex=objPatient.Sex               //性别
		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmitTime)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
		Set Birthday = objPatient.Birthday
		Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	
		Set StatusDr         = objReport.InvStatusDr
		Set (StatusID,StatusCode,StatusDesc)=""
		If $IsObject(StatusDr) {
			Set StatusID=StatusDr.%Id()
			Set StatusCode=StatusDr.Code
			Set StatusDesc=StatusDr.Description
		}
		Set Identity         = objReport.InvIdentity
		Set SymPtomDrs       = objReport.InvSymPtomDr
		Set SymPtomList=""
		For inds=1:1:$l(SymPtomDrs,","){
			Set SymPtomDr = $p(SymPtomDrs,",",inds)
			Continue:SymPtomDr=""
			Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(SymPtomDr)
			Continue:'$IsObject(objDic)
			Set SymPtomList=SymPtomList_","_objDic.Description
		}
		Set:SymPtomList'="" SymPtomList=$e(SymPtomList,2,$l(SymPtomList))
	    
	    Set ComplicationDrs   = objReport.InvComplication
		Set ComplicationList=""
		For indc=1:1:$l(ComplicationDrs,","){
			Set ComplicationDr = $p(ComplicationDrs,",",indc)
			Continue:ComplicationDr=""
			Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(ComplicationDr)
			Continue:'$IsObject(objDic)
			Set ComplicationList=ComplicationList_","_objDic.Description
		}
		Set:ComplicationList'="" ComplicationList=$e(ComplicationList,2,$l(ComplicationList))
	
	   Set PreAnamnesisDrs  = objReport.InvPreAnamnesisDr
		Set PreAnamnesisList=""
		For indp=1:1:$l(PreAnamnesisDrs,","){
			Set PreAnamnesisDr = $p(PreAnamnesisDrs,",",indp)
			Continue:PreAnamnesisDr=""
			Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(PreAnamnesisDr)
			Continue:'$IsObject(objDic)
			Set PreAnamnesisList=PreAnamnesisList_","_objDic.Description
		}
		Set:PreAnamnesisList'="" PreAnamnesisList=$e(PreAnamnesisList,2,$l(PreAnamnesisList))
		
		Set EPDRepID         = objReport.InvReportDr.%Id()
	    //传染病卡片编号
	    Set RepNo=objReport.InvReportDr.MEPDText2
		Set Severity=objReport.InvReportDr.MEPDSeverity                     //临床严重程度
		Set SeverityDesc=""
		Set objSeverity=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicSeverity",Severity,"")
		If $IsObject(objSeverity) {
			Set SeverityDesc=objSeverity.Description
		}	
			
		Set DiagnoseType=objReport.InvReportDr.MEPDDiagnoseType            // 诊断类型	
		Set DiagnoseDesc=""                                
		Set objDiag=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdemicType",DiagnoseType,"")
		If $IsObject(objDiag){
			Set DiagnoseDesc=objDiag.Description
		}
	
		Set DiagDegree=objReport.InvReportDr.MEPDDiagDegree                 // 诊断分类
		Set DiagDegreeDesc=""
		Set objDegree=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicDiagnoseDegree",DiagDegree,"")
		If $IsObject(objDegree){
			Set DiagDegreeDesc=objDegree.Description
		}

		Set SickDate=objReport.InvReportDr.MEPDSickDate                //发病日期
		Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
		Set DiagDate=objReport.InvReportDr.MEPDDiagDate                //诊断日期
		Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
		Set ReportDate       = objReport.InvReportDate
		Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
		Set ReportTime       = objReport.InvReportTime
		Set:ReportTime'="" ReportTime=$zt(ReportTime,1)
		
		Set Data = $lb(xID,CardNo,EpisodeID,PatientID,PapmiNo,PatientName,PatientSex,PatientAge,Birthday,Identity,StatusID,StatusCode,StatusDesc,SymPtomList,ComplicationList,PreAnamnesisList)
		Set Data =Data_$lb(EPDRepID,RepNo,SeverityDesc,DiagnoseDesc,DiagDegreeDesc,SickDate,DiagDate,ReportDate,ReportTime)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryReportByPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportByPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByPatExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind) // Save QHandle
	Quit $$$OK
}

/// Creator： pylian
/// CreatDate： 2020-02-11
/// Description: 根据日期查询个案调查登记
/// Table： DHCMed.EPD.NCPInvestigation
/// Input： aDateType:日期类型,aStaDate:开始日期, aEndDate:结束日期 , aStatusList:状态
/// Return： ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.EPDService.NCPInvestigationSrv","QryReportByDate","","","2020-01-01","2020-02-28","")
Query QryReportByDate(aHospID As %String, aDateType As %String, aStaDate As %String, aEndDate As %String, aStatusList As %String) As %Query(ROWSPEC = "ReportID:%String,CardNo:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatientName:%String,PatientSex:%String,PatientAge:%String,Birthday:%String,Identity:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,SymPtomList:%String,Temperature:%String,SymPtomExt:%String,ComplicationList:%String,ComplicationExt:%String,PreAnamnesisList:%String,PreAnamnesisExt:%String,IsIsolated:%String,IsIsolatedDesc:%String,IsolatedDate:%String,IsInHosp:%String,IsInHospDesc:%String,InHospDate:%String,IsInICU:%String,IsInICUDesc:%String,InICUDate:%String,OccupationDesc:%String,OccupationExt:%String,IsGravida:%String,IsGravidaDesc:%String,TravelLiveDesc:%String,IsContactFever:%String,IsContactFeverDesc:%String,IsContactTrave:%String,IsContactTraveDesc:%String,IsContactDiag:%String,IsContactDiagDesc:%String,GatherDesc:%String,EPDRepID:%String,RepNo:%String,SeverityDesc:%String,DiagnoseDesc:%String,DiagDegreeDesc:%String,SickDate:%String,DiagDate:%String,ReportDate:%String,ReportTime:%String") [ SqlProc ]
{
}

ClassMethod QryReportByDateExecute(ByRef qHandle As %Binary, aHospID As %String, aDateType As %String, aStaDate As %String, aEndDate As %String, aStatusList As %String) As %Status
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
		Set xDate=$o(^DHCMed.EPD.NCPInvestigationI(aDateType,xDate))
		Quit:(xDate="")||(xDate>aEndDate)
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.EPD.NCPInvestigationI(aDateType,xDate,xTime))
			Quit:(xTime="")
			
			Set xID=""
			For {
				Set xID=$o(^DHCMed.EPD.NCPInvestigationI(aDateType,xDate,xTime,xID))
				Quit:(xID="")
				Set objReport=##class(DHCMed.EPD.NCPInvestigation).GetObjById(xID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.InvReportDr)
				Set (StatusID,StatusCode,StatusDesc)=""
				Set StatusDr=objReport.InvStatusDr
				If $IsObject(StatusDr) {
					Set StatusID=StatusDr.%Id()
					Set StatusCode=StatusDr.Code
					Set StatusDesc=StatusDr.Description
				}
				Continue:(StatusCode="")||($ListFind(StatusList,StatusCode)<1)
					
				Set CardNo           = objReport.InvCardNo
				Set EpisodeID        = objReport.InvEpisodeID
				Set PatientID        = objReport.InvPatientID
				Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			    Continue:'$IsObject(objPatient)
				Set PapmiNo=objPatient.PapmiNo              //登记号
				Set PatientName=objPatient.PatientName      //姓名
				Set PatientSex=objPatient.Sex               //性别
				Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
				Set AdmDate=$p(AdmDateTime,"^",1)
				Set AdmitTime=$p(AdmDateTime,"^",2)
				Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmitTime)
				Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
				Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
				Set Birthday = objPatient.Birthday
				Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
			
			    Set AdmLocID = $p($g(^PAADM(+EpisodeID)),"^",4)
			   	If aHospID'="" {
					Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLocID,aHospID)
					Continue:flg<1
				}
				Set Identity         = objReport.InvIdentity
				Set SymPtomDrs       = objReport.InvSymPtomDr
				Set SymPtomList=""
				For inds=1:1:$l(SymPtomDrs,","){
					Set SymPtomDr = $p(SymPtomDrs,",",inds)
					Continue:SymPtomDr=""
					Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(SymPtomDr)
					Continue:'$IsObject(objDic)
					Set SymPtomList=SymPtomList_","_objDic.Description
				}
				Set:SymPtomList'="" SymPtomList=$e(SymPtomList,2,$l(SymPtomList))
				Set Temperature      = objReport.InvTemperature
				Set SymPtomExt       = objReport.InvSymPtomExt
			   
			    Set ComplicationDrs   = objReport.InvComplication
				Set ComplicationList=""
				For indc=1:1:$l(ComplicationDrs,","){
					Set ComplicationDr = $p(ComplicationDrs,",",indc)
					Continue:ComplicationDr=""
					Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(ComplicationDr)
					Continue:'$IsObject(objDic)
					Set ComplicationList=ComplicationList_","_objDic.Description
				}
				Set:ComplicationList'="" ComplicationList=$e(ComplicationList,2,$l(ComplicationList))
				Set ComplicationExt  = objReport.InvComplicationExt

			    Set PreAnamnesisDrs  = objReport.InvPreAnamnesisDr
				Set PreAnamnesisList=""
				For indp=1:1:$l(PreAnamnesisDrs,","){
					Set PreAnamnesisDr = $p(PreAnamnesisDrs,",",indp)
					Continue:PreAnamnesisDr=""
					Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(PreAnamnesisDr)
					Continue:'$IsObject(objDic)
					Set PreAnamnesisList=PreAnamnesisList_","_objDic.Description
				}
				Set:PreAnamnesisList'="" PreAnamnesisList=$e(PreAnamnesisList,2,$l(PreAnamnesisList))
				Set PreAnamnesisExt    = objReport.InvPreAnamnesisExt
		  	  	Set IsIsolated       = objReport.InvIsIsolated
				Set IsIsolatedDesc=$s(IsIsolated=1:"是",1:"否")
				Set IsolatedDate     = objReport.InvIsolatedDate
				Set:IsolatedDate'="" IsolatedDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(IsolatedDate)
				Set IsInHosp         = objReport.InvIsInHosp
				Set IsInHospDesc=$s(IsInHosp=1:"是",1:"否")
				Set InHospDate       = objReport.InvInHospDate
				Set:InHospDate'="" InHospDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InHospDate)
				Set IsInICU          = objReport.InvIsInICU
				Set IsInICUDesc=$s(IsInICU=1:"是",1:"否")
				Set InICUDate        = objReport.InvInICUDate
				Set:InICUDate'="" InICUDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InICUDate)				
				Set OccupationDr     = objReport.InvOccupationDr
				Set (OccupationID,OccupationCode,OccupationDesc)=""
				If $IsObject(OccupationDr) {
					Set OccupationID=OccupationDr.%Id()
					Set OccupationCode=OccupationDr.Code
					Set OccupationDesc=OccupationDr.Description
				}
				Set OccupationExt    = objReport.InvOccupationExt
				Set IsGravida        = objReport.InvIsGravida
				Set IsGravidaDesc=$s(IsGravida=1:"是",1:"否")  
				Set TravelLiveDr     = objReport.InvTravelLiveDr
				Set (TravelLiveID,TravelLiveCode,TravelLiveDesc)=""
				If $IsObject(TravelLiveDr) {
					Set TravelLiveID=TravelLiveDr.%Id()
					Set TravelLiveCode=TravelLiveDr.Code
					Set TravelLiveDesc=TravelLiveDr.Description
				}
				Set IsContactFever   = objReport.InvIsContactFever
				Set IsContactFeverDesc=$s(IsContactFever=1:"是",1:"否")  
				Set IsContactTrave   = objReport.InvIsContactTrave 
				Set IsContactTraveDesc=$s(IsContactTrave=1:"是",1:"否")
				Set IsContactDiag    = objReport.InvIsContactDiag
				Set IsContactDiagDesc=$s(IsContactDiag=1:"是",1:"否")
				Set GatherDr         = objReport.InvGatherDr
				Set (GatherID,GatherCode,GatherDesc)=""
				If $IsObject(GatherDr) {
					Set GatherID=GatherDr.%Id()
					Set GatherCode=GatherDr.Code
					Set GatherDesc=GatherDr.Description
				}
				
				Set EPDRepID         = objReport.InvReportDr.%Id()
			    //传染病卡片编号
			    Set RepNo=objReport.InvReportDr.MEPDText2
				Set Severity=objReport.InvReportDr.MEPDSeverity                     //临床严重程度
				Set SeverityDesc=""
				Set objSeverity=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicSeverity",Severity,"")
				If $IsObject(objSeverity) {
					Set SeverityDesc=objSeverity.Description
				}	
					
				Set DiagnoseType=objReport.InvReportDr.MEPDDiagnoseType            // 诊断类型	
				Set DiagnoseDesc=""                                
				Set objDiag=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdemicType",DiagnoseType,"")
				If $IsObject(objDiag){
					Set DiagnoseDesc=objDiag.Description
				}
			
				Set DiagDegree=objReport.InvReportDr.MEPDDiagDegree                 // 诊断分类
				Set DiagDegreeDesc=""
				Set objDegree=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicDiagnoseDegree",DiagDegree,"")
				If $IsObject(objDegree){
					Set DiagDegreeDesc=objDegree.Description
				}

				Set SickDate=objReport.InvReportDr.MEPDSickDate                //发病日期
				Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
				Set DiagDate=objReport.InvReportDr.MEPDDiagDate                //诊断日期
				Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
				Set ReportDate       = objReport.InvReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set ReportTime       = objReport.InvReportTime
				Set:ReportTime'="" ReportTime=$zt(ReportTime,1)
		
				Set Data = $lb(xID,CardNo,EpisodeID,PatientID,PapmiNo,PatientName,PatientSex,PatientAge,Birthday,Identity,StatusID,StatusCode,StatusDesc,SymPtomList,Temperature,SymPtomExt)
				Set Data =Data_$lb(ComplicationList,ComplicationExt,PreAnamnesisList,PreAnamnesisExt,IsIsolated,IsIsolatedDesc,IsolatedDate,IsInHosp,IsInHospDesc,InHospDate,IsInICU,IsInICUDesc,InICUDate)
				Set Data =Data_$lb(OccupationDesc,OccupationExt,IsGravida,IsGravidaDesc,TravelLiveDesc,IsContactFever,IsContactFeverDesc,IsContactTrave,IsContactTraveDesc,IsContactDiag)
				Set Data =Data_$lb(IsContactDiagDesc,GatherDesc,EPDRepID,RepNo,SeverityDesc,DiagnoseDesc,DiagDegreeDesc,SickDate,DiagDate,ReportDate,ReportTime)

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
 	Set qHandle=$lb(AtEnd,repid,ind) // Save QHandle
	Quit $$$OK
}

/// Creator： pylian
/// CreatDate： 2020-02-11
/// Description: 获取新冠肺炎信息
/// Table： DHCMed.EPD.NCPInvestigation
/// Input： aReportID
/// Return： 
/// W ##class(DHCMed.EPDService.NCPInvestigationSrv).GetInvDataByID("2")
ClassMethod GetInvDataByID(aReportID As %String) As %String
{
	New (aReportID)
	Set return = ""
	Set separete=..#SEPARATE
	
	Set objReport=##class(DHCMed.EPD.NCPInvestigation).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Quit:'$IsObject(objReport.InvReportDr) return
		
	Set CardNo           = objReport.InvCardNo
	Set EpisodeID        = objReport.InvEpisodeID
	Set PatientID        = objReport.InvPatientID
	Set StatusDr         = objReport.InvStatusDr
	Set (StatusID,StatusCode,StatusDesc)=""
	If $IsObject(StatusDr) {
		Set StatusID=StatusDr.%Id()
		Set StatusCode=StatusDr.Code
		Set StatusDesc=StatusDr.Description
	}
	Set Identity         = objReport.InvIdentity
	Set EPDRepID         = objReport.InvReportDr.%Id()
	Set SymPtomDrs       = objReport.InvSymPtomDr
	Set SymPtomList=""
	For inds=1:1:$l(SymPtomDrs,","){
		Set SymPtomDr = $p(SymPtomDrs,",",inds)
		Continue:SymPtomDr=""
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(SymPtomDr)
		Continue:'$IsObject(objDic)
		Set SymPtomList=SymPtomList_","_objDic.Description
	}
	Set:SymPtomList'="" SymPtomList=$e(SymPtomList,2,$l(SymPtomList))
	Set Temperature      = objReport.InvTemperature
	Set SymPtomExt       = objReport.InvSymPtomExt
	Set IsComplication   = objReport.InvIsComplication
	Set IsComplicationDesc=$s(IsComplication=1:"有",1:"无")
	Set ComplicationDrs   = objReport.InvComplication
	Set ComplicationList=""
	For indc=1:1:$l(ComplicationDrs,","){
		Set ComplicationDr = $p(ComplicationDrs,",",indc)
		Continue:ComplicationDr=""
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(ComplicationDr)
		Continue:'$IsObject(objDic)
		Set ComplicationList=ComplicationList_","_objDic.Description
	}
	Set:ComplicationList'="" ComplicationList=$e(ComplicationList,2,$l(ComplicationList))
	
	Set ComplicationExt  = objReport.InvComplicationExt
	Set IsBloodTest      = objReport.InvIsBloodTest
	Set IsBloodTestDesc=$s(IsBloodTest=1:"是",1:"否")
	Set BloodTestDate    = objReport.InvBloodTestDate
	Set:BloodTestDate'="" BloodTestDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(BloodTestDate)
	Set WBC              = objReport.InvWBC
	Set Lymphocyte       = objReport.InvLymphocyte
	Set LymphocytePer    = objReport.InvLymphocytePer
	Set NePer            = objReport.InvNePer
	Set ChestXrayDr      = objReport.InvChestXrayDr
	Set (ChestXrayID,ChestXrayCode,ChestXrayDesc)=""
	If $IsObject(ChestXrayDr) {
		Set ChestXrayID=ChestXrayDr.%Id()
		Set ChestXrayCode=ChestXrayDr.Code
		Set ChestXrayDesc=ChestXrayDr.Description
	}
	Set ChestXrayDate    = objReport.InvChestXrayDate
	Set:ChestXrayDate'="" ChestXrayDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ChestXrayDate)
	Set ChestCTDr        = objReport.InvChestCTDr
	Set (ChestCTID,ChestCTCode,ChestCTDesc)=""
	If $IsObject(ChestCTDr) {
		Set ChestCTID=ChestCTDr.%Id()
		Set ChestCTCode=ChestCTDr.Code
		Set ChestCTDesc=ChestCTDr.Description
	}
	Set ChestctDate      = objReport.InvChestctDate
	Set:ChestctDate'="" ChestctDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ChestctDate)
	Set IsMedical        = objReport.InvIsMedical
	Set IsMedicalDesc=$s(IsMedical=1:"是",1:"否")
	Set FirstAdmDate     = objReport.InvFirstAdmDate
	Set:FirstAdmDate'="" FirstAdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FirstAdmDate)
	Set AdmHospital      = objReport.InvAdmHospital
	Set IsIsolated       = objReport.InvIsIsolated
	Set IsIsolatedDesc=$s(IsIsolated=1:"是",1:"否")
	Set IsolatedDate     = objReport.InvIsolatedDate
	Set:IsolatedDate'="" IsolatedDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(IsolatedDate)
	Set IsInHosp         = objReport.InvIsInHosp
	Set IsInHospDesc=$s(IsInHosp=1:"是",1:"否")
	Set InHospDate       = objReport.InvInHospDate
	Set:InHospDate'="" InHospDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InHospDate)
	Set IsInICU          = objReport.InvIsInICU
	Set IsInICUDesc=$s(IsInICU=1:"是",1:"否")
	Set InICUDate        = objReport.InvInICUDate
	Set:InICUDate'="" InICUDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InICUDate)
	Set OccupationDr     = objReport.InvOccupationDr
	Set (OccupationID,OccupationCode,OccupationDesc)=""
	If $IsObject(OccupationDr) {
		Set OccupationID=OccupationDr.%Id()
		Set OccupationCode=OccupationDr.Code
		Set OccupationDesc=OccupationDr.Description
	}
	Set OccupationExt    = objReport.InvOccupationExt
	
	Set IsGravida        = objReport.InvIsGravida
	Set IsGravidaDesc=$s(IsGravida=1:"是",1:"否")  
	Set PreAnamnesisDrs  = objReport.InvPreAnamnesisDr
	Set PreAnamnesisList=""
	For indp=1:1:$l(PreAnamnesisDrs,","){
		Set PreAnamnesisDr = $p(PreAnamnesisDrs,",",indp)
		Continue:PreAnamnesisDr=""
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(PreAnamnesisDr)
		Continue:'$IsObject(objDic)
		Set PreAnamnesisList=PreAnamnesisList_","_objDic.Description
	}
	Set:PreAnamnesisList'="" PreAnamnesisList=$e(PreAnamnesisList,2,$l(PreAnamnesisList))
	
	Set PreAnamnesisExt    = objReport.InvPreAnamnesisExt
	Set TravelLiveDr     = objReport.InvTravelLiveDr
	Set (TravelLiveID,TravelLiveCode,TravelLiveDesc)=""
	If $IsObject(TravelLiveDr) {
		Set TravelLiveID=TravelLiveDr.%Id()
		Set TravelLiveCode=TravelLiveDr.Code
		Set TravelLiveDesc=TravelLiveDr.Description
	}
	Set IsContactFever   = objReport.InvIsContactFever
	Set IsContactFeverDesc=$s(IsContactFever=1:"是",1:"否")  
	Set IsContactTrave   = objReport.InvIsContactTrave 
	Set IsContactTraveDesc=$s(IsContactTrave=1:"是",1:"否")
	Set IsContactDiag    = objReport.InvIsContactDiag
	Set IsContactDiagDesc=$s(IsContactDiag=1:"是",1:"否")
	Set GatherDr         = objReport.InvGatherDr
	Set (GatherID,GatherCode,GatherDesc)=""
	If $IsObject(GatherDr) {
		Set GatherID=GatherDr.%Id()
		Set GatherCode=GatherDr.Code
		Set GatherDesc=GatherDr.Description
	}
	Set IsTreatment      = objReport.InvIsTreatment
	Set MarketDr         = objReport.InvMarketDr
	Set (MarketID, MarketCode, MarketDesc)=""
	If $IsObject(MarketDr) {
		Set MarketID=MarketDr.%Id()
		Set MarketCode=MarketDr.Code
		Set MarketDesc=MarketDr.Description
	}
	Set Distance         = objReport.InvDistance
	Set IsMarketDr       = objReport.InvIsMarketDr
	Set (IsMarketID,IsMarketCode,IsMarketDesc)=""
	If $IsObject(IsMarketDr) {
		Set IsMarketID=IsMarketDr.%Id()
		Set IsMarketCode=IsMarketDr.Code
		Set IsMarketDesc=IsMarketDr.Description
	}
	Set MarketTypeDr     = objReport.InvMarketType
	Set (MarketTypeID,MarketTypeCode,MarketTypeDesc)=""
	If $IsObject(MarketTypeDr) {
		Set MarketTypeID=MarketTypeDr.%Id()
		Set MarketTypeCode=MarketTypeDr.Code
		Set MarketTypeDesc=MarketTypeDr.Description
	}
	Set RpeortCompany    = objReport.InvReportCompany
	Set ReportLoc        = objReport.InvReportLoc
	Set ReportUser       = objReport.InvReportUser
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
	Set:$IsObject(objRepUser) ReportUser=objRepUser.Name
	Set ReportDate       = objReport.InvReportDate
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	Set ReportTime       = objReport.InvReportTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,1)
	Set CheckUser        = objReport.InvCheckUser
	Set objChkUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	Set:$IsObject(objChkUser) CheckUser=objChkUser.Name
		
	Set CheckDate        = objReport.InvCheckDate
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set CheckTime        = objReport.InvCheckTime
	Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
	
	Set return=aReportID_separete                                    //报告ID
	Set return=return_CardNo_separete                            
	Set return=return_EpisodeID_separete                           
	Set return=return_PatientID_separete                           
	Set return=return_StatusID_$c(2)_StatusCode_$c(2)_StatusDesc_separete                              
	Set return=return_Identity_separete                        
	Set return=return_EPDRepID_separete                          
	Set return=return_SymPtomDrs_$c(2)_SymPtomList_separete
	Set return=return_Temperature_separete                              
	Set return=return_SymPtomExt_separete                         
	Set return=return_IsComplication_$c(2)_IsComplicationDesc_separete                             
	Set return=return_ComplicationDrs_$c(2)_ComplicationList_separete                       
	Set return=return_ComplicationExt_separete                                                      
	Set return=return_IsBloodTest_$c(2)_IsBloodTestDesc_separete                              
	Set return=return_BloodTestDate_separete                         
	Set return=return_WBC_separete                         
	Set return=return_Lymphocyte_separete                             
	Set return=return_LymphocytePer_separete                       
	Set return=return_NePer_separete   	
	Set return=return_ChestXrayID_$c(2)_ChestXrayCode_$c(2)_ChestXrayDesc_separete                              
	Set return=return_ChestXrayDate_separete                         
	Set return=return_ChestCTID_$c(2)_ChestCTCode_$c(2)_ChestCTDesc_separete                         
	Set return=return_ChestctDate_separete                             
	Set return=return_IsMedical_$c(2)_IsMedicalDesc_separete                              
	Set return=return_FirstAdmDate_separete                              
	Set return=return_AdmHospital_separete 
	
	Set return=return_IsIsolated_$c(2)_IsIsolatedDesc_separete                             
	Set return=return_IsolatedDate_separete                       
	Set return=return_IsInHosp_$c(2)_IsInHospDesc_separete                              
	Set return=return_InHospDate_separete   	                      
	Set return=return_IsInICU_$c(2)_IsInICUDesc_separete                             
	Set return=return_InICUDate_separete                       
	Set return=return_OccupationID_$c(2)_OccupationCode_$c(2)_OccupationDesc_separete                              
	Set return=return_OccupationExt_separete  
	
	Set return=return_IsGravida_$c(2)_IsGravidaDesc_separete                             
	Set return=return_PreAnamnesisDrs_$c(2)_PreAnamnesisList_separete                       
	Set return=return_PreAnamnesisExt_separete                              
	Set return=return_TravelLiveID_$c(2)_TravelLiveCode_$c(2)_TravelLiveDesc_separete                              
	Set return=return_IsContactFever_$c(2)_IsContactFeverDesc_separete                         
	Set return=return_IsContactTrave_$c(2)_IsContactTraveDesc_separete  
	Set return=return_IsContactDiag_$c(2)_IsContactDiagDesc_separete                      
	Set return=return_GatherID_$c(2)_GatherCode_$c(2)_GatherDesc_separete                              
	Set return=return_IsTreatment_separete                    
	Set return=return_MarketID_$c(2)_MarketCode_$c(2)_MarketDesc_separete                              
	Set return=return_Distance_separete  
	Set return=return_IsMarketID_$c(2)_IsMarketCode_$c(2)_IsMarketDesc_separete  
	Set return=return_MarketTypeID_$c(2)_MarketTypeCode_$c(2)_MarketTypeDesc_separete                         
	Set return=return_RpeortCompany_separete                         
	Set return=return_ReportLoc_separete                             
	Set return=return_ReportUser_separete                       
	Set return=return_ReportDate_separete   
	Set return=return_ReportTime_separete                         
	Set return=return_CheckUser_separete                         
	Set return=return_CheckDate_separete                             
	Set return=return_CheckTime_separete
	
	Quit return
}

/// Creator： pylian
/// CreatDate： 2020-02-11
/// Description: 查询实验室结果
/// Table： DHCMed.EPD.NCPSample
/// Input： ReportID : 报告ID
/// Return： ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.EPDService.NCPInvestigationSrv","QryReportSample","")
Query QryReportSample(aReportID As %String) As %Query(ROWSPEC = "ind:%String,ID:%String,SampleTypeID:%String,SampleTypeDesc:%String,SampleResultID:%String,SampleResultDesc:%String,SampleDate:%String") [ SqlProc ]
{
}

ClassMethod QryReportSampleExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set objReport=##class(DHCMed.EPD.NCPInvestigation).GetObjById(aReportID)
	Quit:'$IsObject(objReport) $$$OK
	Set SubID=""
	For {
		Set SubID=$o(^DHCMed.EPD.NCPInvestigationD(aReportID,"SA",SubID))
		Quit:(SubID="")
		Set ID=aReportID_"||"_SubID
		Set objSample=##class(DHCMed.EPD.NCPSample).GetObjById(ID)
		Continue:'$IsObject(objSample)
		Set (SampleTypeID,SampleTypeDesc,SampleResultID,SampleResultDesc)=""
		If $IsObject(objSample.InvLabType) {
			Set SampleTypeID=objSample.InvLabType.%Id()
			Set SampleTypeDesc=objSample.InvLabType.Description
		}
		If $IsObject(objSample.InvLabResult) {
			Set SampleResultID=objSample.InvLabResult.%Id()
			Set SampleResultDesc=objSample.InvLabResult.Description
		}
		Set SampleDate=objSample.InvLabDate
		Set:(SampleDate'="") SampleDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SampleDate)
		Set Data=$lb(ind,ID,SampleTypeID,SampleTypeDesc,SampleResultID,SampleResultDesc,SampleDate)
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
 	Set qHandle=$lb(AtEnd,repid,ind) // Save QHandle
	Quit $$$OK
}

/// Creator： pylian
/// CreatDate： 2020-02-11
/// Description: 获取新冠肺炎对应的传染病报告ID
/// Table： DHCMed.EPD.Epidemic
/// Input： aEpisodeID
/// Return： 
/// W ##class(DHCMed.EPDService.NCPInvestigationSrv).GetEpdID("67")
ClassMethod GetEpdID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return = ""
	
	Set EpdID =""
	Set xRepID=""   //查找本次就诊
	For {
		Set xRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,xRepID),-1)   //倒序查找报告，取最新新型冠状病毒肺炎报告
		Quit:xRepID=""
		Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.MEPDICDDR)
		Continue:objRep.MEPDStatus="4" //被订状态报告无效 
		Continue:objRep.MEPDStatus="6" //草稿状态报告无效
		Continue:objRep.MEPDStatus="7" //删除状态报告无效  
		Set RepDisease=objRep.MEPDICDDR.MIFDisease	//疾病名称 
		Continue:(RepDisease["新型冠状")&&(RepDisease["新型冠状")
		Set EpdID=xRepID
		Quit:EpdID'=""	
	}
	If (EpdID="") { //查找历次就诊
		Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(aEpisodeID)
		Quit:$IsObject(objAdm)=0 ""
		Set PatientID=objAdm.PatientID
		Quit:PatientID="" ""
		Set xInfectionDr=""
		For {
			Set xInfectionDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfectionDr))
			Quit:xInfectionDr=""
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,xInfectionDr,xRepID),-1)
				Quit:xRepID=""
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.MEPDICDDR)
				Continue:objRep.MEPDStatus="4" //被订状态报告无效 
				Continue:objRep.MEPDStatus="6" //草稿状态报告无效
				Continue:objRep.MEPDStatus="7" //删除状态报告无效  
				Set RepDisease=objRep.MEPDICDDR.MIFDisease	//疾病名称 
				Continue:(RepDisease'="新型冠状病毒感染")&&(RepDisease'="新型冠状病毒感染的肺炎")
				Set EpdID=xRepID
				Quit:EpdID'=""
			}
			Quit:EpdID'=""
		}			
	}
	
	Set return = EpdID
	Quit return
}

/// Creator： pylian
/// CreatDate： 2020-02-11
/// Description: 根据获取传染病报告
/// Table： DHCMed.EPD.Epidemic/DHCMed.EPD.NCPInvestigation
/// Input： aInvID:DHCMed.EPD.NCPInvestigation
/// Return：
/// W ##class(DHCMed.EPDService.NCPInvestigationSrv).GetEpidemic("","49")
ClassMethod GetEpidemic(aInvID As %String, aEpdID As %String) As %String
{
	New (aInvID,aEpdID,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return = ""
	Quit:(aInvID="")&&(aEpdID="") return
	
	Set separete=..#SEPARATE
	
	If (aInvID '="") {   //个案调查存在
		Set objInv =##class(DHCMed.EPD.NCPInvestigation).GetObjById(aInvID)
		Quit:'$IsObject(objInv) return
		Set objRep =objInv.InvReportDr
		Quit:'$IsObject(objRep) return
		Set ReportID = objRep.%Id()	
	} else {  //个案调查不存在	
		Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aEpdID)
		Quit:'$IsObject(objRep)
		Set ReportID =aEpdID 	
	}
    Set RepNo = objRep.MEPDText2 //报告编号
	Set PatientID = objRep.MEPDPapmiDR                //PatientID
	Set EpisodeID = objRep.MEPDText1
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatientName=objPatient.PatientName      //姓名
		Set PatientSex=objPatient.Sex               //性别
		Set:PatientSex'="" PatientSex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,PatientSex)
		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmitTime)
		Set AgeNumber = +PatientAge
		Set AgeUnit = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,$p(PatientAge,AgeNumber,2))
		Set PatientAge = AgeNumber_AgeUnit
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
		Set Birthday = objPatient.Birthday
		Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	}
	
	Set FamName=objRep.MEPDFamName                  //家长姓名	
	Set DiseaseDr = objRep.MEPDICDDR.%Id()          //疾病ID
	Set DiseaseICD = objRep.MEPDICDDR.MIFICD	    //ICD
	Set Disease = objRep.MEPDICDDR.MIFDisease	   //疾病名称
    
    Set Severity=objRep.MEPDSeverity                     //临床严重程度
	Set SeverityDesc=""
	Set objSeverity=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicSeverity",Severity,"")
	If $IsObject(objSeverity) {
		Set SeverityDesc=objSeverity.Description
		Set SeverityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,SeverityDesc)
	}
	
    Set Intimate=objRep.MEPDIntimateCode            //密切接触情况	
	Set IntimateDesc=""
	Set objInt=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicContact",Intimate,"")
	If $IsObject(objInt){
		Set IntimateDesc=objInt.Description
		Set IntimateDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,IntimateDesc)
	}
		
	Set DiagnoseType=objRep.MEPDDiagnoseType            // 诊断类型	
	Set DiagnoseDesc=""                                
	Set objDiag=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdemicType",DiagnoseType,"")
	If $IsObject(objDiag){
		Set DiagnoseDesc=objDiag.Description
		Set DiagnoseDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,DiagnoseDesc)
	}
	
	Set DiagDegree=objRep.MEPDDiagDegree                 // 诊断分类
	Set DiagDegreeDesc=""
	Set objDegree=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicDiagnoseDegree",DiagDegree,"")
	If $IsObject(objDegree){
		Set DiagDegreeDesc=objDegree.Description
		Set DiagDegreeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,DiagDegreeDesc)
	}
	Set SickKind=objRep.MEPDSickKind                     // 发病程度
	Set SickKindDesc=""
	Set objSick=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicSickQuality",SickKind,"")
	If $IsObject(objSick){
		Set SickKindDesc=objSick.Description
		Set SickKindDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,SickKindDesc)
	}
	
	Set TelPhone=objRep.MEPDTelPhone                //联系电话
	Set SickDate=objRep.MEPDSickDate                //发病日期
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set DiagDate=objRep.MEPDDiagDate                //诊断日期
	Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
		
	Set (ProvinceDesc,CityDesc,CountyDesc,VillageDesc)=""
	Set ProvinceID=objRep.MEPDProvince
	If ProvinceID'="" {
		Set ProvinceDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(ProvinceID)
		Set ProvinceDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc","EN",ProvinceDesc)	
		Set:ProvinceDesc'="" Province=ProvinceID_$c(2)_ProvinceDesc
	}
	Set CityID=objRep.MEPDCity
	If CityID'="" {
		Set CityDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(CityID)
		Set CityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc","EN",CityDesc)
		Set:CityDesc'="" City=CityID_$c(2)_CityDesc
	}
	set CountyID=objRep.MEPDCounty
	If CountyID'="" {
		Set CountyDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(CountyID)
		Set CountyDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc","EN",CountyDesc)
		Set:CountyDesc'="" County=CountyID_$c(2)_CountyDesc
	}
	set VillageID=objRep.MEPDVillage
	If VillageID'="" {
		Set VillageDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(VillageID)
		Set VillageDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc","EN",VillageDesc)
		Set:VillageDesc'="" Village=VillageID_$c(2)_VillageDesc
	}	
	Set Road=objRep.MEPDRoad

	Set CardType=objRep.MEPDText4 	     //有效证件类型
	Set CardTypeDesc=""
	Set objCardType=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicCardType",CardType,"")
	If $IsObject(objCardType){
		Set CardTypeDesc=objCardType.Description
		Set CardTypeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,CardTypeDesc)
	}
	Set Identity=""
	If (CardTypeDesc="居民身份证号") {
	
		Set Identity=objRep.MEPDText5          //有效证件号
	}

    Set IPNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I") 
   
    Set RepDate=objRep.MEPDRepDate                  //报告日期
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set:RepTime'="" RepTime=$zt(RepTime,2)
	Set RepStatus=objRep.MEPDStatus                 //报告状态
	Set (RepStatusDesc,RepStatusCode)=""
	Set objRepStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",RepStatus,"")
	If $IsObject(objRepStatus){
		Set RepStatusDesc=objRepStatus.Description
		Set RepStatusCode=objRepStatus.Code
	}
	Set return=ReportID_separete                                    //报告ID
	Set return=return_PatientID_separete                            //PatientID
	Set return=return_PapmiNo_separete                              //登记号
	Set return=return_IPNo_separete                                 //病案号
	Set return=return_PatientName_separete                          //姓名
	Set return=return_PatientSex_separete                           //性别
	Set return=return_PatientAge_separete                           //年龄
	Set return=return_Birthday_separete                             //出生日期        
	Set return=return_FamName_separete                              //家长姓名
	Set return=return_IntimateDesc_separete                         //密切接触
	Set return=return_DiagnoseDesc_separete                         //诊断类型
	Set return=return_SickDate_separete                             //发病日期
	Set return=return_DiagDegreeDesc_separete                       //诊断分类
	Set return=return_DiagDate_separete                             //诊断日期
	 
	Set return=return_SickKindDesc_separete                         //发病程度	
	Set return=return_SeverityDesc_separete 
	Set return=return_TelPhone_separete                             //联系电话
	Set return=return_RepNo_separete                                //卡片编号
	Set return=return_Identity_separete                             //身份证号
	Set return=return_ProvinceDesc_separete                         // 居住地省市
	Set return=return_CityDesc_separete                             // 居住地地市
	Set return=return_CountyDesc_separete                           // 居住地区县
	Set return=return_VillageDesc_separete                          // 居住地乡镇
	Set return=return_Road_separete                                 // 街道门牌号
	Set return=return_RepStatusDesc_separete                           
	Set return=return_RepDate_separete                              
	
	
	
	Quit return
}

/// Creator： pylian
/// CreatDate： 2020-02-12
/// Description: 获取个案调查的症状体征
/// Table： DHCMed.EPD.NCPInvestigation
/// Input： aReportID:DHCMed.EPD.NCPInvestigation
/// Return： 
/// W ##class(DHCMed.EPDService.NCPInvestigationSrv).BuildSymPtom("1")
ClassMethod BuildSymPtom(aReportID As %String) As %String
{
	New (aReportID,%session)
	Set return = ""
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set TxtDesc = "其他症状体征"	
	Set TxtDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,TxtDesc)	
	Set MaxWD   = "最高温度"
	Set MaxWD = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,MaxWD)	
	Set Fever   = "发热"	
	Set Fever = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Fever)	
	Set Other   = "其他"	
	Set Other = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Other)	
		
		
			
	Set htmlStr = "" 
	Set SymPtomList="",SymPtomDrs="",Temperature="",SymPtomExt=""
	Set objInv =##class(DHCMed.EPD.NCPInvestigation).GetObjById(aReportID)
    If ($IsObject(objInv)){
	    Set SymPtomDrs  = objInv.InvSymPtomDr
	    Set Temperature = objInv.InvTemperature   
	    Set SymPtomExt = objInv.InvSymPtomExt 
	    Set xID=""
		For {
		 	Set xID=$o(^DHCMed.SS.DictionaryI("IdxofType"," NCPSYMPTOM",xID))
		 	Quit:xID=""
		 	
		 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
		 	Continue:'$IsObject(objDic)
			Set IsActive=objDic.Active
			Continue:IsActive'=1
			Set Description=objDic.Description
			Set Description = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Description)	
	
			Set IsCheck=0
			If (","_SymPtomDrs_",")[(","_xID_",") {
				Set IsCheck=1
			} 
			
		    If (Description=Fever) {
			    Set htmlStr = htmlStr_"<div class='td-quarter'><input id=chk"_xID_" type='checkbox' class='hisui-checkbox' label="_Description_" name='chkSymPtoms'"_$s(IsCheck=1:("checked='checked'"),1:"")_"value="_xID_">"
				Set htmlStr = htmlStr_" "_MaxWD_" <input class='textbox' id='txtTemperature' style='width:50px;' value="_Temperature_">℃</div>"
			} ElseIf (Description=Other) {
			 	Set htmlStr = htmlStr_"<div class='td-quarter'><input id=chk"_xID_" type='checkbox' class='hisui-checkbox' label="_Description_" name='chkSymPtoms'" _$s(IsCheck=1:("checked='checked'"),1:"")_"value="_xID_">"
			 	Set htmlStr = htmlStr_" <input class='textbox' id='txtSymPtom' value="_SymPtomExt_"></div>"
			}Else {
			 	Set htmlStr = htmlStr_"<div class='td-quarter'><input id=chk"_xID_" type='checkbox' class='hisui-checkbox' label="_Description_" name='chkSymPtoms'"_$s(IsCheck=1:("checked='checked'"),1:"")_"value="_xID_"></div>"
			} 
		}
	        	
    } else {
    	Set xID=""
		For {
		 	Set xID=$o(^DHCMed.SS.DictionaryI("IdxofType"," NCPSYMPTOM",xID))
		 	Quit:xID=""
		 	
		 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
		 	Continue:'$IsObject(objDic)
		 	
			 Set IsActive=objDic.Active
			 Continue:IsActive'=1
			 Set Description=objDic.Description
			 Set Description = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,Description)	
	
			 If (Description=Fever) {
				 Set htmlStr = htmlStr_"<div class='td-quarter'><input id=chk"_xID_" type='checkbox' class='hisui-checkbox' label="_Description_" name='chkSymPtoms'  value="_xID_">"
				 Set htmlStr = htmlStr_" "_MaxWD_" <input class='hisui-numberbox textbox' id='txtTemperature' style='width:50px;margin-top:4px;' disabled /> ℃</div>"
			 } ElseIf (Description=Other) {
			 	Set htmlStr = htmlStr_"<div class='td-quarter'><input id=chk"_xID_" type='checkbox' class='hisui-checkbox' label="_Description_" name='chkSymPtoms'  value="_xID_">"
			 	Set htmlStr = htmlStr_" <input class='textbox' id='txtSymPtom' placeholder="_TxtDesc_"  disabled /></div>"
			 }Else {
			 	Set htmlStr = htmlStr_"<div class='td-quarter'><input id=chk"_xID_" type='checkbox' class='hisui-checkbox' label="_Description_" name='chkSymPtoms'  value="_xID_"></div>"
			 }
		}
    }
	Set return = htmlStr
	Quit return
}

}
