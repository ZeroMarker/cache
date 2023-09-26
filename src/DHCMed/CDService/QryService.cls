/// 名称: DHCMed.CDService.QryService
/// 描述: 查询报告信息
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-31
Class DHCMed.CDService.QryService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-01
/// Description:  根据EpisodeID慢病报告
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryRepByEpisodeID","170","")
Query QryRepByEpisodeID(aEpisodeID As %String, aRepType As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,ReportTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReportLoc:%String,KPBH:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,DelReason:%String")
{
}

ClassMethod QryRepByEpisodeIDExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aRepType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_aEpisodeID,xRepID))
		Quit:xRepID=""
		
		Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		
		Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,ReportLoc)=""
		Set (KPBH,PapmiNo,PatName,PatSex,PatAge)=""
		
		Set RepTypeCode=objRep.CRReportType.CRFCode
		Continue:(aRepType'="")&&(aRepType'=RepTypeCode)
		Set RepTypeDesc=objRep.CRReportType.CRFDesc
		Set RepStatusDesc=objRep.CRReportStatus.Description
		Set ReportUser=objRep.CRReportUser
		Set ReportDate=objRep.CRReportDate
		;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
		Set ReportTime=objRep.CRReportTime
		set:ReportTime'="" ReportTime=$zt(ReportTime,1)
		Set CheckUserDr=objRep.CRCheckUser
		If (CheckUserDr'=""){
			set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
			If ($IsObject(objUser)){
				set CheckUser=objUser.Name
			}
		}
		Set CheckDate=objRep.CRCheckDate
		;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
		Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
		Set CheckTime=objRep.CRCheckTime
		set:CheckTime'="" CheckTime=$zt(CheckTime,1)
		Set ReportUser=objRep.CRReportUser
		Set ReportLoc=$p($g(^CTLOC(objRep.CRReportLoc)),"^",2) 
		Set:ReportLoc["-" ReportLoc=$p(ReportLoc,"-",2)
		Set DelReason=objRep.CRDelReason
	
		If (RepTypeCode="ZLK") {
			Set objChild=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="XNXG") {
			Set objChild=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="SHK") {
			Set objChild=##class(DHCMed.CD.CRReportSHK).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="NYZD") {
			Set objChild=##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="GWZS") {
			Set objChild=##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="FZYCO") {
			Set objChild=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="YSZYB") {
			Set objChild=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="TNB") {
			Set objChild=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(xRepID)
		} ElseIf (RepTypeCode="MBBK") {
			Set objChild=##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(xRepID)
		}ElseIf (RepTypeCode="CSQX") {
			Set objChild=##class(DHCMed.CD.CRReportCSQX).GetObjByParRef(xRepID)
		}ElseIf (RepTypeCode="ETSH") {
			Set objChild=##class(DHCMed.CD.CRReportETSH).GetObjByParRef(xRepID)
		} Else {

		}
		
		Set:$IsObject(objChild) KPBH=objChild.CRKPBH
		
		Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
		If ($IsObject(objPat)) {
			Set PapmiNo=objPat.CRDJH
			Set PatName=objPat.CRXM
			Set PatSex=objPat.CRXB
			Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
			Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
			Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
		}
		If (PapmiNo="") {
			Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
			Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
		}
		Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,ReportTime,CheckUser,CheckDate,CheckTime,ReportLoc)
		Set Data=Data_$lb(KPBH,PapmiNo,PatName,PatSex,PatAge,DelReason)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryRepByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByEpisodeIDExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2022-02-28
/// Description:  根据PatientID取慢病报告
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryRepByPatientID","170","")
Query QryRepByPatientID(aPatientID As %String, aRepType As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,ReportTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReportLoc:%String,KPBH:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,DelReason:%String")
{
}

ClassMethod QryRepByPatientIDExecute(ByRef qHandle As %Binary, aPatientID As %String, aRepType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xAdmType=""
	For {
		Set xAdmType=$o(^PAPERdr(aPatientID,"ADM",xAdmType))
		Quit:xAdmType=""

		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^PAPERdr(aPatientID,"ADM",xAdmType,EpisodeID))
			Quit:EpisodeID=""

			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_EpisodeID,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,ReportLoc)=""
				Set (KPBH,PapmiNo,PatName,PatSex,PatAge)=""
				
				Set RepTypeCode=objRep.CRReportType.CRFCode
				Continue:RepTypeCode=""
				Continue:(aRepType'="")&&(aRepType'=RepTypeCode)
				Set RepTypeDesc=objRep.CRReportType.CRFDesc
				Set RepTypeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",RepTypeDesc)	
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set RepStatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",RepStatusDesc)	
				
				Set ReportUser=objRep.CRReportUser
				Set ReportUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",ReportUser)
				
				if (RepTypeCode="ZLK"){
					set objReportUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUser)
					
					if ($IsObject(objReportUser)){
						Set ReportUser = objReportUser.Name
						Set ReportUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",ReportUser)
					}
				}
				Set ReportDate=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set ReportTime=objRep.CRReportTime
				set:ReportTime'="" ReportTime=$zt(ReportTime,1)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
						Set CheckUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",CheckUser)
					
					}
				}
				Set CheckDate=objRep.CRCheckDate
				;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				Set CheckTime=objRep.CRCheckTime
				set:CheckTime'="" CheckTime=$zt(CheckTime,1)
				//Set ReportUser=objRep.CRReportUser
				Set ReportLoc=$p($g(^CTLOC(objRep.CRReportLoc)),"^",2) 
				Set:ReportLoc["-" ReportLoc=$p(ReportLoc,"-",2)
				Set ReportLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",ReportLoc)
				Set DelReason=objRep.CRDelReason
			
				If (RepTypeCode="ZLK") {
					Set objChild=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="XNXG") {
					Set objChild=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="SHK") {
					Set objChild=##class(DHCMed.CD.CRReportSHK).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="NYZD") {
					Set objChild=##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="GWZS") {
					Set objChild=##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="FZYCO") {
					Set objChild=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="YSZYB") {
					Set objChild=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="TNB") {
					Set objChild=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(xRepID)
				} ElseIf (RepTypeCode="MBBK") {
					Set objChild=##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(xRepID)
				}ElseIf (RepTypeCode="CSQX") {
					Set objChild=##class(DHCMed.CD.CRReportCSQX).GetObjByParRef(xRepID)
				}ElseIf (RepTypeCode="ETSH") {
					Set objChild=##class(DHCMed.CD.CRReportETSH).GetObjByParRef(xRepID)
				}ElseIf (RepTypeCode="GXY") {
					Set objChild=##class(DHCMed.CD.CRReportGXY).GetObjByParRef(xRepID)
				} Else {

				}
				Continue:'$IsObject(objChild)
				Set:$IsObject(objChild) KPBH=objChild.CRKPBH
				
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PapmiNo=objPat.CRDJH
					Set PatName=objPat.CRXM
					Set PatSex=objPat.CRXB
					Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
					Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
					Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
				}
				If (PapmiNo="") {
					Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
					Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
				}
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,ReportTime,CheckUser,CheckDate,CheckTime,ReportLoc)
				Set Data=Data_$lb(KPBH,PapmiNo,PatName,PatSex,PatAge,DelReason)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryRepByPatientIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByPatientIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepByPatientIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByPatientIDExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-09
/// Description:  根据日期查询肿瘤卡信息(ZLK)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportZLK
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryZLKRepByDate","2015-10-01","2015-10-29","","")
Query QryZLKRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,MrNo:%String,OPNo:%String,KPBH:%String,FamilyHistory:%String,PatRelationship:%String,DiagICD:%String,SymptomList:%String,PapmiNo:%String,PatName:%String,PatSex:%String,Birthday:%String,CardType:%String,CaraNo:%String,Nation:%String,Country:%String,Education:%String,Marriage:%String,Occupation:%String,Company:%String,RelateMan:%String,Relationship:%String,RelationTelOne:%String,RelationTelTwo:%String,CurrAddType:%String,CurrAddCode:%String,CurrAddInfo:%String,IsLiveSixInfo:%String,RegAddType:%String,RegAddCode:%String,RegAddInfo:%String,FirstDiagDate:%String,DiagDate:%String,Reversion:%String,DeathDate:%String,DeathReason:%String,DeathReasonInfo:%String,MostUnit:%String,DiagPlaceCode:%String,DiagUnitCode:%String,TreatDate:%String,StartTreatDate:%String,TreatType:%String,ADRsAppearDate:%String,ADRsDiagDate:%String,ADRsDiag:%String,ADRsDrug:%String,EndTreatDate:%String,EndTreatReason:%String,AppointmentDate:%String,ActualDate:%String,TreatPlaceCode:%String,TreatUnitCode:%String,CaseType:%String,CaseNo:%String,CaseDiag:%String,ICDO3Morphology:%String,ICDO3Degree:%String,IsStages:%String,TNMT:%String,TNMN:%String,TNMM:%String,PathologyTNMT:%String,PathologyTNMN:%String,PathologyTNMM:%String,ClinicalTNMT:%String,ClinicalTNMN:%String,ClinicalTNMM:%String,ClinicalTNMM:%String,Action:%String,LateralPosition:%String,ChildTumor:%String,TumorSign:%String,AdmDate:%String,DishDate:%String,HospDiagInfo:%String,PathDiagInfo:%String,DiagList:%String,HighDiagList:%String,AnatomicalSite:%String,EpisodeID:%String,DelReason:%String")
{
}

ClassMethod QryZLKRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="ZLK"
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				// 初始化
				Set (RepStatusDesc,ReportUser,ReportDate,MrNo,OPNo,KPBH,FamilyHistory,PatRelationship,DiagICD,SymptomList,PapmiNo,PatName,PatSex,Birthday,CaraType,CaraNo,Nation,Country,Education,Marriage,Occupation,Company,RelateMan,Relationship,RelationTelOne,RelationTelTwo,CurrAddType,CurrAddCode,CurrAddInfo,IsLiveSixInfo,RegAddType,RegAddCode,RegAddInfo,FirstDiagDate,DiagDate,Reversion,DeathDate,DeathReason,DeathReasonInfo,MostUnit,DiagPlaceCode,DiagUnitCode,TreatDate,StartTreatDate,TreatType,ADRsAppearDate,ADRsDiagDate,ADRsDiag,ADRsDrug,EndTreatDate,EndTreatReason,AppointmentDate,ActualDate,TreatPlaceCode,TreatUnitCode)=""
				Set (CaseType,CaseNo,CaseDiag,ICDO3Morphology,ICDO3Degree,IsStages,TNMT,TNMN,TNMM,PathologyTNMT,PathologyTNMN,PathologyTNMM,ClinicalTNMT,ClinicalTNMN,ClinicalTNMM,ClinicalTNMM,Action,LateralPosition,ChildTumor,TumorSign,AdmDate,DishDate,HospDiagInfo,PathDiagInfo,DiagList,HighDiagList,AnatomicalSite) = ""
				// 报告信息
				Set EpisodeID		= objRep.CREpisodeID
				Set RepStatusDesc	= objRep.CRReportStatus.Description
				Set ReportUser		= objRep.CRReportUser
				Set DelReason		= objRep.CRDelReason
				Set ReportDate		= objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				// 肿瘤报告内容
				Set objChild		= ##class(DHCMed.CD.CRReportZLK).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH			= objChild.CRKPBH		// 卡片编号
				Set ZDDesc			= ##class(DHCMed.CD.CRICDDx).GetDescByID(objChild.CRZD)  // 诊断
				Set:ZDDesc'="" ZDDesc = $p(ZDDesc,$c(1),2)
				Set CaseType		= objChild.CRBLXLX		// 病例分类
				Set CaseNo			= objChild.CRBLH		// 病例号
				Set IsStages 		= "是"					// 肿瘤分期是否不详
				Set TNMT			= objChild.CRTNMFQT.Description
				Set TNMN			= objChild.CRTNMFQN.Description
				Set TNMM			= objChild.CRTNMFQM.Description
				if ((TNMT'="")||(TNMN'="")||(TNMM'="")){
					Set IsStages 		= "否"
				}
				Set Action			= objChild.Action.Description	// 行为
				// 诊断日期
				Set DiagDate		= objChild.CRZDRQ
				Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
				// 诊断依据
				Set ZDYJ			= objChild.CRZDYJ
				Set ZDYJstr=""
				For xInd=1:1:ZDYJ.Count() {
					Set objDic=ZDYJ.GetAt(xInd)
					Continue:'$IsObject(objDic)
					Set ZDYJstr=ZDYJstr_","_objDic.Description
				}
				Set:ZDYJstr'="" ZDYJstr=$e(ZDYJstr,2,$l(ZDYJstr))
				Set DiagList 		= ZDYJstr
				// 最高诊断单位
				Set MostUnit		= objChild.CRZGZDDW.Description
				// 死亡日期
				Set DeathDate		= objChild.CRSWRQ
				Set:DeathDate'="" DeathDate	= ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
				Set DeathReason		= objChild.CRSWYY.Description 
				// 解剖学部位
				Set AnatomicalSite	= objChild.CRZDBW
				Set DiagICD			= objChild.CRZDICD
				
				// 患者信息
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PapmiNo		= objPat.CRDJH		// 登记号
					Continue:((aRegNo'="")&&(aRegNo'=PapmiNo))
					Set PatName		= objPat.CRXM		// 姓名	
					Continue:((aPatName'="")&&(aPatName'=PatName))
					Set PatSex		= objPat.CRXB		// 性别
					Set Birthday	= objPat.CRCSRQ		// 出生日期
					Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
					Set CardType	= "居民身份证"		// 证件类型  默认身份证
					Set CaraNo		= objPat.CRSFZH		// 身份证号
					Set Nation		= objPat.CRMZ.Description		// 民族
					Set Country		= ""				// 国籍
					Set Education	= objPat.CRWHCD.Description		// 学历
					Set Marriage	= objPat.CRHYZK.Description		// 婚姻状况
					Set Occupation	= objPat.CRZY.Description		// 职业类型
					Set Company		= objPat.CRGZDW		// 工作单位
					Set RelateMan	= objPat.CRLXR		// 联系人
					Set Relationship= objPat.CRYBRGX.Description 	// 联系人/监护人与本人关系
					Set RelationTelOne= objPat.CRLXDH	// 联系电话(手机)
					Set RelationTelTwo= ""				// 联系电话(座机)
					Set CurrAddType	= ""				// 现住址(类型)
					Set CurrAddCode	= ""				// 现住址(编码)
					Set CurrAddInfo	= objPat.CRCZDZXX	// 现住详细地址
					Set IsLiveSixInfo	= ""			// 本县区居住6个月以上
					Set RegAddType	= ""				// 户籍地址(类型)
					Set RegAddCode	= ""				// 户籍地址(编码)
					Set RegAddInfo	= ""				// 户籍详细地址
				}
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				Set OPNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"O","")
				Set CardType		= objChild.CRCardType.Description	// 证件类型
				// 入院时间
		     	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
				Set AdmDate=$p(AdmDateTime,"^",1)
				Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
				// 出院时间
		     	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
				Set DishDate=$p(DischDateTime,"^",1)
				Set:DishDate'="" DishDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DishDate)
				
				
				Set Data=$lb(ind,xRepID,RepStatusDesc,ReportUser,ReportDate,MrNo,OPNo,KPBH,FamilyHistory,PatRelationship,DiagICD,SymptomList,PapmiNo,PatName,PatSex,Birthday,CardType,CaraNo,Nation,Country,Education,Marriage,Occupation,Company,RelateMan,Relationship,RelationTelOne,RelationTelTwo,CurrAddType,CurrAddCode,CurrAddInfo,IsLiveSixInfo,RegAddType,RegAddCode,RegAddInfo,FirstDiagDate,DiagDate,Reversion,DeathDate,DeathReason,DeathReasonInfo,MostUnit,DiagPlaceCode,DiagUnitCode,TreatDate,StartTreatDate,TreatType,ADRsAppearDate,ADRsDiagDate,ADRsDiag,ADRsDrug,EndTreatDate,EndTreatReason,AppointmentDate,ActualDate,TreatPlaceCode,TreatUnitCode)
				Set Data=Data_$lb(CaseType,CaseNo,CaseDiag,ICDO3Morphology,ICDO3Degree,IsStages,TNMT,TNMN,TNMM,PathologyTNMT,PathologyTNMN,PathologyTNMM,ClinicalTNMT,ClinicalTNMN,ClinicalTNMM,ClinicalTNMM,Action,LateralPosition,ChildTumor,TumorSign,AdmDate,DishDate,HospDiagInfo,PathDiagInfo,DiagList,HighDiagList,AnatomicalSite) 
				Set Data=Data_$lb(EpisodeID,DelReason)
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryZLKRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryZLKRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryZLKRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryZLKRepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-10-12
/// Description:  根据日期查询非职业CO卡信息(FZYCO)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportFZYCO
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryFZYCORepByDate","2015-09-01","2015-09-09","","")
Query QryFZYCORepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,MrNo:%String,ZDZD:%String,ZDYY:%String,ZYZZs:%String,COZDRQ:%String,JZCSs:%String,ZDRQ:%String,SWRQ:%String,EpisodeID:%String,ZDCS:%String,ZDYS:%String,COZG:%String,DelReason:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PersonalID:%String,Nation:%String,Birthday:%String,TelPhone:%String,Occupation:%String,Company:%String,CurrAddress:%String,RegAddress:%String,Education:%String,Marriage:%String")
{
}

ClassMethod QryFZYCORepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="FZYCO"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,MrNo,ZDZD,ZDYY,ZYZZs,COZDRQ,JZCSs,ZDRQ,SWRQ,EpisodeID,ZDCS,ZDYS,COZG,PapmiNo,PatName,PatSex,PatAge,PersonalID,Nation,Birthday,TelPhone,Occupation,Company,CurrAddress,RegAddress,Education,Marriage)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
							
				Set objChild=##class(DHCMed.CD.CRReportFZYCO).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
				Set ZDZD=objChild.CRZDZD.Description
				Set ZDYY=objChild.CRZDYY.Description
				Set ZYZZList=objChild.CRZYZZ
				For indz=1:1:ZYZZList.Count(){
					Set objDic=ZYZZList.GetAt(indz)
					Continue:'$IsObject(objDic)
					Set ZYZZs=ZYZZs_","_objDic.Description
				}
				Set:ZYZZs'="" ZYZZs=$e(ZYZZs,2,$l(ZYZZs))
				Set JZCSList=objChild.CRJZCS
				For indj=1:1:JZCSList.Count(){
					Set objDic=JZCSList.GetAt(indj)
					Continue:'$IsObject(objDic)
					Set JZCSs=JZCSs_","_objDic.Description
				}
				Set:JZCSs'="" JZCSs=$e(JZCSs,2,$l(JZCSs))
				Set COZDRQ=objChild.CRCOZDRQ
				Set:COZDRQ'="" COZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(COZDRQ)
				Set ZDRQ=objChild.CRZDRQ
				Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
				Set SWRQ=objChild.CRSWRQ
				Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
				
				
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				Set ZDCS=objChild.CRZDCS.Description
				Set ZDYS=objChild.CRZDYS.Description
				Set COZG=objChild.CRCOZG.Description
				
				Set PatInfo = ..GetPatInfoByRepID(xRepID,aPatName,aRegNo)
				Continue:PatInfo=""
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,MrNo,ZDZD,ZDYY,ZYZZs,COZDRQ,JZCSs,ZDRQ,SWRQ,EpisodeID,ZDCS,ZDYS,COZG,DelReason)
				Set Data=Data_PatInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryFZYCORepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFZYCORepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFZYCORepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFZYCORepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-10-12
/// Description:  根据日期查询农药中毒卡信息(NYZD)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportNYZD
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryNYZDRepByDate","2015-12-20","2015-12-30","","")
Query QryNYZDRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,MrNo:%String,ZDNYMC:%String,ZDYY:%String,ZSPX:%String,SYFS:%String,WXXWs:%String,ZDRQ:%String,SWRQ:%String,EpisodeID:%String,DelReason:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PersonalID:%String,Nation:%String,Birthday:%String,TelPhone:%String,Occupation:%String,Company:%String,CurrAddress:%String,RegAddress:%String,Education:%String,Marriage:%String")
{
}

ClassMethod QryNYZDRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="NYZD"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,PapmiNo,PatName,PatSex,PatAge)=""
				Set (MrNo,ZDNYMC,ZDYY,ZSPX,SYFS,WXXWs,ZDRQ,SWRQ)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
				
				Set objChild=##class(DHCMed.CD.CRReportNYZD).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
				Set ZDNYMC=objChild.CRZDNYMC
				Set ZDYY=objChild.CRZDYY.Description
				Set ZSPX=objChild.CRZSPX.Description
				Set SYFS=objChild.CRSYFS.Description
				Set WXXWList=objChild.CRWXXW
				For indw=1:1:WXXWList.Count(){
					Set objDic=WXXWList.GetAt(indw)
					Continue:'$IsObject(objDic)
					Set WXXWs=WXXWs_","_objDic.Description
				}
				Set:WXXWs'="" WXXWs=$e(WXXWs,2,$l(WXXWs))
				Set ZDRQ=objChild.CRZDRQ
				;Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
				Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
				Set SWRQ=objChild.CRSWRQ
				;Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
				Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
				
				
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				Set PatInfo = ..GetPatInfoByRepID(xRepID,aPatName,aRegNo)
				Continue:PatInfo=""
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,MrNo,ZDNYMC,ZDYY,ZSPX,SYFS,WXXWs,ZDRQ,SWRQ,EpisodeID,DelReason)
				Set Data=Data_PatInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryNYZDRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNYZDRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNYZDRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNYZDRepByDateExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2019-12-11
/// Description:  根据日期查询出生缺陷儿报卡信息(CSQX)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportCSQX
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryCSQXRepByDate","2015-09-01","2015-09-09","","")
Query QryCSQXRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,MrNo:%String,ChildSex:%String,Birthday:%String,BirHospital:%String,DiagBasis:%String,Defect:%String,EpisodeID:%String,DelReason:%String")
{
}

ClassMethod QryCSQXRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="CSQX"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,PapmiNo,PatName,PatSex,PatAge)=""
				Set (ChildSex,Birthday,BirHospital,DiagBasis,Defect)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
				
				Set objChild=##class(DHCMed.CD.CRReportCSQX).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild)
				Set KPBH=objChild.CRKPBH			//卡片编号
				Set (ChildSexID,ChildSexDesc)=""	//缺陷儿性别
				Set ChildSexDr=objChild.CRXBDr
				If $IsObject(ChildSexDr) {
					Set ChildSexID=ChildSexDr.%Id()
					Set ChildSexDesc=ChildSexDr.Description
					Set ChildSex=ChildSexDesc
				}
				Set Birthday=objChild.CRCSRQ		//出生日期
				Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
				Set BirHospital=objChild.CRCSYY    //出生医院
				Set (DiagBasisID,DiagBasisDesc)=""	//诊断依据
				Set DiagBasisDr=objChild.CRZDYJDr
				If $IsObject(DiagBasisDr) {
					Set DiagBasisID=DiagBasisDr.%Id()
					Set DiagBasisDesc=DiagBasisDr.Description
					Set DiagBasis=DiagBasisDesc
				}
				Set (DefectID,DefectDesc)=""	//缺陷诊断
				Set DefectDr=objChild.CRZDDr
				If $IsObject(DefectDr) {
					Set DefectID=DefectDr.%Id()
					Set DefectDesc=DefectDr.Description
					Set Defect=DefectDesc
				}
			
				
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PapmiNo		= objPat.CRDJH		// 登记号
					Continue:((aRegNo'="")&&(aRegNo'=PapmiNo))
					Set PatName		= objPat.CRXM		// 姓名	
					Continue:((aPatName'="")&&(aPatName'=PatName))
					Set PatSex=objPat.CRXB
					Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
					Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
					Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
				}
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,PapmiNo,PatName,PatSex,PatAge)
				Set Data=Data_$lb(MrNo,ChildSex,Birthday,BirHospital,DiagBasis,Defect,EpisodeID,DelReason)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCSQXRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryXNXGRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSQXRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryXNXGRepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-10-19
/// Description:  根据日期查询心脑血管报卡信息(XNXG)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportXNXG
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryXNXGRepByDate","2022-03-01","2022-03-10","","","")
Query QryXNXGRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,ReportOrgan:%String,EpisodeID:%String,KPBH:%String,RepProvince:%String,RepCity:%String,RepCounty:%String,CardType:%String,LiveSix:%String,FBRQ:%String,SFSCFB:%String,ZDMC:%String,ZDICD:%String,CureMethod:%String,ApoplexyType:%String,SCD:%String,Infer:%String,ZDYJs:%String,BiochemicalMark:%String,Reissue:%String,QZRQ:%String,QZDW:%String,DWLevel:%String,OutCome:%String,SWRQ:%String,SWYY:%String,IDCradNum:%String,Certificate:%String,SYID:%String,MrNo:%String,TempNullData:%String,NullData1:%String,NullData2:%String,NullData3:%String,NullData4:%String,NullData5:%String,NullData6:%String,NullData7:%String,NullData8:%String,NullData9:%String,NullData10:%String,NullData11:%String,NullData12:%String,NullData13:%String,NullData14:%String,DelReason:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PersonalID:%String,Nation:%String,Birthday:%String,TelPhone:%String,Occupation:%String,Company:%String,CurrAddress:%String,RegAddress:%String,Education:%String,Marriage:%String,RegProvince:%String,RegCity:%String,RegCounty:%String,RegVillage:%String,RegRoad:%String,CurrProvince:%String,CurrCity:%String,CurrCounty:%String,CurrVillage:%String,CurrRoad:%String,MZH:%String,LXR:%String")
{
}

ClassMethod QryXNXGRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="XNXG"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc,ReportOrgan)=""
				Set (MrNo,KPBH,RepProvince,RepCity,RepCounty,CardType,LiveSix,FBRQ,SFSCFB,ZDMC,ZDICD,CureMethod,ApoplexyType,SCD,Infer,ZDYJs,BiochemicalMark,Reissue,QZRQ,QZDW,DWLevel,OutCome,SWRQ,SWYY,SYID,TempNullData)=""
				Set (NullData1,NullData2,NullData3,NullData4,NullData5,NullData6,NullData7,NullData8,NullData9,NullData10,NullData11,NullData12,NullData13,NullData14)=""
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				
				Set ReportOrgan=objRep.CRReportOrgan
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
				// 心脑血管报卡
				Set objChild=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild)
				Set KPBH		= objChild.CRKPBH  			// 卡片编号
				Set RepProvince	= objChild.CRRepProvince.ShortDesc  // 报卡省
				Set RepCity 	= objChild.CRRepCity.ShortDesc  	// 报卡市
				Set RepCounty	= objChild.CRRepCounty.ShortDesc  	// 报卡县
				Set CardType 	= objChild.CRCardType.Description   // 证件类型
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				if (CardType["身份证"){
					Set IDCradNum=objPat.CRSFZH		// 身份证号
				}else{
					Set Certificate=objPat.CRSFZH  // 其他证件号
				}
				Set LiveSix 	= objChild.CRLiveSix.Description    // 在本辖区居住六个月以上
				Set FBRQ		= objChild.CRFBRQ 					// 发病日期
				Set:FBRQ'="" FBRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FBRQ)
				Set SFSCFB 	= objChild.CRSFSCFB.Description   		// 是否首次发病
				Set ZDMC 	= objChild.CRDaig.Description			// 诊断
				Set ZDICD	= objChild.CRZDBM						// 诊断ICD
				
				Set CureMethod 	= objChild.CRCureMethod.Description			// 心绞痛治疗措施
				Set ApoplexyType= objChild.CRApoplexyType.Description		// 脑卒中类型
				Set SCD= objChild.CRSCD.Description					// 心源性猝死
				Set Infer= objChild.CRInfer.Description				// 推断
				
				Set ZDYJLis=objChild.CRZDYJ
				For indz=1:1:ZDYJLis.Count(){
					Set objDic=ZDYJLis.GetAt(indz)
					Continue:'$IsObject(objDic)
					Set ZDYJs=ZDYJs_","_objDic.Description
				}
				Set:objChild.CRSHTD.Description="是" ZDYJs=ZDYJs_",死后推断" //诊断依据添加死后推断
				Set:ZDYJs'="" ZDYJs=$e(ZDYJs,2,$l(ZDYJs)) 
				Set BiochemicalMark= objChild.CRBiochemicalMark.Description	// 生化标志物
				Set Reissue= objChild.CRReissue.Description				// 补发
				
				Set QZRQ=objChild.CRQZRQ
				Set:QZRQ'="" QZRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(QZRQ)
				Set QZDW= objChild.CRQZDW.Description				// 确诊单位
				Set DWLevel= objChild.CRLevel.Description			// 单位级别
				Set OutCome= objChild.CROutCome.Description			// 转归
				Set SWRQ=objChild.CRSWRQ
				Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ) // 死亡日期
				Set SWYY=objChild.CRSWYY
				Set SYID=objChild.CRSYID
				
				Set PatInfo = ..GetPatInfoByRepID(xRepID,aPatName,aRegNo)
				Continue:PatInfo=""
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc,ReportOrgan)
				Set Data=Data_$lb(EpisodeID,KPBH,RepProvince,RepCity,RepCounty,CardType,LiveSix,FBRQ,SFSCFB,ZDMC,ZDICD,CureMethod,ApoplexyType,SCD,Infer,ZDYJs,BiochemicalMark,Reissue,QZRQ,QZDW,DWLevel,OutCome,SWRQ,SWYY,IDCradNum,Certificate,SYID,MrNo,TempNullData,NullData1,NullData2,NullData3,NullData4,NullData5,NullData6,NullData7,NullData8,NullData9,NullData10,NullData11,NullData12,NullData13,NullData14,DelReason)

				Set Data=Data_PatInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryXNXGRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryXNXGRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryXNXGRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryXNXGRepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-14
/// Description:  根据日期查询糖尿病卡信息(TNB)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportTNB
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryTNBRepByDate","2022-01-01","2023-04-17","","","")
Query QryTNBRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,MrNo:%String,OPNo:%String,KPBH:%String,FamilyHistory:%String,PatRelationship:%String,DiagICD:%String,SymptomList:%String,CRZYJCQK1:%String,CRZYJCQK2:%String,PapmiNo:%String,PatName:%String,PatSex:%String,Birthday:%String,CaraType:%String,CaraNo:%String,Nation:%String,Country:%String,Education:%String,Marriage:%String,Occupation:%String,Company:%String,RelateMan:%String,Relationship:%String,RelationTelOne:%String,RelationTelTwo:%String,CurrAddType:%String,CurrAddCode:%String,CurrAddInfo:%String,IsLiveSixInfo:%String,RegAddType:%String,RegAddCode:%String,RegAddInfo:%String,FirstDiagDate:%String,DiagDate:%String,Reversion:%String,DeathDate:%String,DeathReason:%String,DeathReasonInfo:%String,MostUnit:%String,DiagPlaceCode:%String,DiagUnitCode:%String,TreatDate:%String,StartTreatDate:%String,TreatType:%String,ADRsAppearDate:%String,ADRsDiagDate:%String,ADRsDiag:%String,ADRsDrug:%String,EndTreatDate:%String,EndTreatReason:%String,AppointmentDate:%String,ActualDate:%String,TreatPlaceCode:%String,TreatUnitCode:%String,EpisodeID:%String,DelReason:%String")
{
}

ClassMethod QryTNBRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Set (RepStatusDesc,ReportUser,ReportDate,MrNo,OPNo,KPBH,FamilyHistory,PatRelationship,DiagICD,SymptomList,SSY,SZY,PapmiNo,PatName,PatSex,Birthday,CaraType,CaraNo,Nation,Country,Education,Marriage,Occupation,Company,RelateMan,Relationship,RelationTelOne,RelationTelTwo,CurrAddType,CurrAddCode,CurrAddInfo,IsLiveSixInfo,RegAddType,RegAddCode,RegAddInfo,FirstDiagDate,DiagDate,Reversion,DeathDate,DeathReason,DeathReasonInfo,MostUnit,DiagPlaceCode,DiagUnitCode,TreatDate,StartTreatDate,TreatType,ADRsAppearDate,ADRsDiagDate,ADRsDiag,ADRsDrug,EndTreatDate,EndTreatReason,AppointmentDate,ActualDate,TreatPlaceCode,TreatUnitCode)=""
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="TNB"
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				
				// 报告状态内容
				Set EpisodeID		= objRep.CREpisodeID
				Set RepStatusDesc	= objRep.CRReportStatus.Description
				
				Set ReportUser		= objRep.CRReportUser
				Set DelReason		= objRep.CRDelReason
				Set ReportDate		= objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				// 糖尿病报卡内容
				Set objChild=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH			= objChild.CRKPBH	// 卡片编号
				Set FamilyConut		= objChild.CRRS
				Set FamilyHistory 	= "无"
				Set:FamilyConut'="" FamilyHistory 	= "有"	// 家族史
				Set CRRelationDrs	= objChild.CRJZS      	//   与患者关系          
				Set PatRelationship=""
				For xind=1:1:CRRelationDrs.Count() {
					Set objDic=CRRelationDrs.GetAt(xind)
					Continue:'$IsObject(objDic)
					Set PatRelationship=PatRelationship_","_objDic.Description
				}
				Set:PatRelationship'="" PatRelationship=$e(PatRelationship,2,$l(PatRelationship))
				
				  
				Set CRZYJCQK1		= objChild.CRZYJCQK1	// 空腹血糖
				Set CRZYJCQK2		= objChild.CRZYJCQK2	// 餐后血糖  
				Set DiagDate		= objChild.CRZDRQ		// 诊断日期  
				Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
				Set DeathDate		= objChild.CRSWRQ		// 死亡日期 
				Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)  
				Set DeathReason		= objChild.CRSWYY		// 死亡原因  
				Set DeathReasonInfo	= objChild.CRJTSWYY		// 具体死亡原因  
				Set DiagICD			= objChild.CRZDICD		// 疾病icd
				// 患者信息
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PapmiNo		= objPat.CRDJH		// 登记号
					Continue:((aRegNo'="")&&(aRegNo'=PapmiNo))
					Set PatName		= objPat.CRXM		// 姓名	
					Continue:((aPatName'="")&&(aPatName'=PatName))
					Set PatSex		= objPat.CRXB		// 性别
					Set Birthday	= objPat.CRCSRQ		// 出生日期
					Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
					Set CaraType	= "居民身份证"		// 证件类型  默认身份证
					Set CaraNo		= objPat.CRSFZH		// 身份证号
					Set Nation		= objPat.CRMZ.Description		// 民族
					Set Country		= ""				// 国籍
					Set Education	= objPat.CRWHCD.Description		// 学历
					Set Marriage	= objPat.CRHYZK.Description		// 婚姻状况
					Set Occupation	= objPat.CRZY.Description		// 职业类型
					Set Company		= objPat.CRGZDW		// 工作单位
					Set RelateMan	= objPat.CRLXR		// 联系人
					Set Relationship= objPat.CRYBRGX.Description 	// 联系人/监护人与本人关系
					Set RelationTelOne= objPat.CRLXDH	// 联系电话(手机)
					Set RelationTelTwo= ""				// 联系电话(座机)
					Set CurrAddType	= ""				// 现住址(类型)
					Set CurrAddCode	= ""				// 现住址(编码)
					Set CurrAddInfo	= objPat.CRCZDZXX	// 现住详细地址
					Set IsLiveSixInfo	= ""			// 本县区居住6个月以上
					Set RegAddType	= ""				// 户籍地址(类型)
					Set RegAddCode	= ""				// 户籍地址(编码)
					Set RegAddInfo	= objPat.CRHJDZXX	// 户籍详细地址
				}
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				Set OPNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"O","")
				Set Data=$lb(ind,xRepID,RepStatusDesc,ReportUser,ReportDate,MrNo,OPNo)
				// 糖尿病报卡内容
				Set Data=Data_$lb(KPBH,FamilyHistory,PatRelationship,DiagICD,SymptomList,CRZYJCQK1,CRZYJCQK2)
				// 患者信息
				Set Data=Data_$lb(PapmiNo,PatName,PatSex,Birthday,CaraType,CaraNo,Nation,Country,Education,Marriage,Occupation,Company,RelateMan,Relationship,RelationTelOne,RelationTelTwo,CurrAddType,CurrAddCode,CurrAddInfo,IsLiveSixInfo,RegAddType,RegAddCode,RegAddInfo)
				Set Data=Data_$lb(FirstDiagDate,DiagDate,Reversion,DeathDate,DeathReason,DeathReasonInfo,MostUnit,DiagPlaceCode,DiagUnitCode,TreatDate,StartTreatDate,TreatType,ADRsAppearDate,ADRsDiagDate,ADRsDiag,ADRsDrug,EndTreatDate,EndTreatReason,AppointmentDate,ActualDate,TreatPlaceCode,TreatUnitCode)
				Set Data=Data_$lb(EpisodeID,DelReason)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryTNBRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTNBRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTNBRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTNBRepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-21
/// Description:  根据日期查询高血压卡信息(GXY)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportGXY
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryGXYRepByDate","2022-06-21","2023-04-14","","","")
Query QryGXYRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,MrNo:%String,OPNo:%String,KPBH:%String,FamilyHistory:%String,PatRelationship:%String,DiagICD:%String,SymptomList:%String,SSY:%String,SZY:%String,PapmiNo:%String,PatName:%String,PatSex:%String,Birthday:%String,CaraType:%String,CaraNo:%String,Nation:%String,Country:%String,Education:%String,Marriage:%String,Occupation:%String,Company:%String,RelateMan:%String,Relationship:%String,RelationTelOne:%String,RelationTelTwo:%String,CurrAddType:%String,CurrAddCode:%String,CurrAddInfo:%String,IsLiveSixInfo:%String,RegAddType:%String,RegAddCode:%String,RegAddInfo:%String,FirstDiagDate:%String,DiagDate:%String,Reversion:%String,DeathDate:%String,DeathReason:%String,DeathReasonInfo:%String,MostUnit:%String,DiagPlaceCode:%String,DiagUnitCode:%String,TreatDate:%String,StartTreatDate:%String,TreatType:%String,ADRsAppearDate:%String,ADRsDiagDate:%String,ADRsDiag:%String,ADRsDrug:%String,EndTreatDate:%String,EndTreatReason:%String,AppointmentDate:%String,ActualDate:%String,TreatPlaceCode:%String,TreatUnitCode:%String,EpisodeID:%String,DelReason:%String")
{
}

ClassMethod QryGXYRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="GXY"
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				
				Set (RepStatusDesc,ReportUser,ReportDate,MrNo,OPNo,KPBH,FamilyHistory,PatRelationship,DiagICD,SymptomList,SSY,SZY,PapmiNo,PatName,PatSex,Birthday,CaraType,CaraNo,Nation,Country,Education,Marriage,Occupation,Company,RelateMan,Relationship,RelationTelOne,RelationTelTwo,CurrAddType,CurrAddCode,CurrAddInfo,IsLiveSixInfo,RegAddType,RegAddCode,RegAddInfo,FirstDiagDate,DiagDate,Reversion,DeathDate,DeathReason,DeathReasonInfo,MostUnit,DiagPlaceCode,DiagUnitCode,TreatDate,StartTreatDate,TreatType,ADRsAppearDate,ADRsDiagDate,ADRsDiag,ADRsDrug,EndTreatDate,EndTreatReason,AppointmentDate,ActualDate,TreatPlaceCode,TreatUnitCode)=""
	
				// 报告状态内容
				Set EpisodeID		= objRep.CREpisodeID
				Set RepStatusDesc	= objRep.CRReportStatus.Description
				Set ReportUser		= objRep.CRReportUser
				Set DelReason		= objRep.CRDelReason
				Set ReportDate		=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
			
				// 高血压报卡内容
				Set objChild=##class(DHCMed.CD.CRReportGXY).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH			= objChild.CRKPBH	// 卡片编号
				Set FamilyConut		= objChild.CRFamilyConut
				Set FamilyHistory 	= "无"
				Set:FamilyConut'="" FamilyHistory 	= "有"	// 家族史
				Set CRRelationDrs	= objChild.CRRelationDrs      	//   与患者关系           
				Set PatRelationship=""
				For xind=1:1:CRRelationDrs.Count() {
					Set objDic=CRRelationDrs.GetAt(xind)
					Continue:'$IsObject(objDic)
					Set PatRelationship=PatRelationship_","_objDic.Description
				}
				Set:PatRelationship'="" PatRelationship=$e(PatRelationship,2,$l(PatRelationship))
				Set DiagICD			= objChild.CRGXYZDICD	// 疾病icd
				Set SymptomDrs		= objChild.CRSymptomDrs // 症状                 
				Set SymptomList=""
				For xind=1:1:SymptomDrs.Count() {
					Set objDic=SymptomDrs.GetAt(xind)
					Continue:'$IsObject(objDic)
					Set SymptomList=SymptomList_","_objDic.Description
				}
				Set:SymptomList'="" SymptomList=$e(SymptomList,2,$l(SymptomList))
				Set SSY				= objChild.CRSSY		// 收缩压
				Set SZY				= objChild.CRSZY		// 舒张压
				
				// 患者信息
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PapmiNo		= objPat.CRDJH		// 登记号
					Continue:((aRegNo'="")&&(aRegNo'=PapmiNo))
					Set PatName		= objPat.CRXM		// 姓名	
					Continue:((aPatName'="")&&(aPatName'=PatName))
					Set PatSex		= objPat.CRXB		// 性别
					Set Birthday	= objPat.CRCSRQ		// 出生日期
					Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
					Set CaraType	= "居民身份证"		// 证件类型  默认身份证
					Set CaraNo		= objPat.CRSFZH		// 身份证号
					Set Nation		= objPat.CRMZ.Description		// 民族
					Set Country		= ""				// 国籍
					Set Education	= objPat.CRWHCD.Description		// 学历
					Set Marriage	= objPat.CRHYZK.Description		// 婚姻状况
					Set Occupation	= objPat.CRZY.Description		// 职业类型
					Set Company		= objPat.CRGZDW		// 工作单位
					Set RelateMan	= objPat.CRLXR		// 联系人
					Set Relationship= objPat.CRYBRGX.Description 	// 联系人/监护人与本人关系
					Set RelationTelOne= objPat.CRLXDH	// 联系电话(手机)
					Set RelationTelTwo= ""				// 联系电话(座机)
					Set CurrAddType	= ""				// 现住址(类型)
					Set CurrAddCode	= ""				// 现住址(编码)
					Set CurrAddInfo	= objPat.CRCZDZXX	// 现住详细地址
					Set IsLiveSixInfo	= ""			// 本县区居住6个月以上
					Set RegAddType	= ""				// 户籍地址(类型)
					Set RegAddCode	= ""				// 户籍地址(编码)
					Set RegAddInfo	= ""				// 户籍详细地址
				}
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				Set OPNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"O","")
				
				Set Data=$lb(ind,xRepID,RepStatusDesc,ReportUser,ReportDate,MrNo,OPNo)
				// 高血压报卡内容
				Set Data=Data_$lb(KPBH,FamilyHistory,PatRelationship,DiagICD,SymptomList,SSY,SZY)
				// 患者信息
				Set Data=Data_$lb(PapmiNo,PatName,PatSex,Birthday,CaraType,CaraNo,Nation,Country,Education,Marriage,Occupation,Company,RelateMan,Relationship,RelationTelOne,RelationTelTwo,CurrAddType,CurrAddCode,CurrAddInfo,IsLiveSixInfo,RegAddType,RegAddCode,RegAddInfo)
				Set Data=Data_$lb(FirstDiagDate,DiagDate,Reversion,DeathDate,DeathReason,DeathReasonInfo,MostUnit,DiagPlaceCode,DiagUnitCode,TreatDate,StartTreatDate,TreatType,ADRsAppearDate,ADRsDiagDate,ADRsDiag,ADRsDrug,EndTreatDate,EndTreatReason,AppointmentDate,ActualDate,TreatPlaceCode,TreatUnitCode)
				Set Data=Data_$lb(EpisodeID,DelReason)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryGXYRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGXYRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGXYRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGXYRepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-21
/// Description:  根据日期查询伤害卡信息(SHK)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportSHK
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QrySHKRepByDate","2022-03-08","2022-03-08","","","")
Query QrySHKRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,EpisodeID:%String,KPBH:%String,SHFSRQ:%String,HZJZRQ:%String,SHFSYY:%String,SHFSDD:%String,SHFSSHD:%String,SHSFGY:%String,SHXZ:%String,SHBW:%String,SHZDID:%String,SHZDDesc:%String,SHJJ:%String,CPMC1:%String,CPXH1:%String,CPFL1:%String,CPMC2:%String,CPXH2:%String,CPFL2:%String,DXALstr:%String,DelReason:%String,SHZDCode:%String,MrNo:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PersonalID:%String,Nation:%String,Birthday:%String,TelPhone:%String,Occupation:%String,Company:%String,CurrAddress:%String,RegAddress:%String,Education:%String,Marriage:%String")
{
}

ClassMethod QrySHKRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="SHK"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,SHFSRQ,HZJZRQ,SHFSYY,SHFSDD,SHFSSHD,SHSFGY,SHXZ,SHBW,SHZDID,SHZDDesc,SHJJ,CPMC1,CPXH1,CPFL1,CPMC2,CPXH2,CPFL2,DXALstr,SHZDCode,PapmiNo,PatName,PatSex,PatAge,PersonalID,Nation,Birthday,TelPhone,Occupation,Company,CurrAddress,RegAddress,Education,Marriage)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
				
				If (PapmiNo="") {
					Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
					Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
				}
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				
				Set objChild=##class(DHCMed.CD.CRReportSHK).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
				Set SHFSRQ=objChild.CRSHFSRQ
				Set:SHFSRQ'="" SHFSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SHFSRQ)
				Set SHFSSJ=objChild.CRSHFSSJ
				Set SHFSRQ = SHFSRQ_" "_SHFSSJ
				Set HZJZRQ=objChild.CRHZJZRQ
				Set:HZJZRQ'="" HZJZRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HZJZRQ)
				Set HZJZSJ=objChild.CRHZJZSJ
				Set HZJZRQ = HZJZRQ_" "_HZJZSJ
				Set SHFSYY=objChild.CRSHFSYY.Description
				Set SHFSDD=objChild.CRSHFSDD.Description
				Set SHFSSHD=objChild.CRSHFSSHD.Description
				Set SHSFGY=objChild.CRSHSFGY.Description
				Set SHXZ=objChild.CRSHXZ.Description
				Set SHBW=objChild.CRSHBW.Description
				
				Set SHZDID=objChild.CRSHZD
				Set SHZDDesc=##class(DHCMed.CD.CRReportSHK).GetICDDescByID(SHZDID)
				Set:SHZDDesc'="" SHZDCode=$p(SHZDDesc,$c(1),3)
				Set:SHZDDesc'="" SHZDDesc=$p(SHZDDesc,$c(1),2) 
				Set SHJJ=objChild.CRSHJJ.Description
				
				Set CPMC1=objChild.CRCPMC1
				Set CPXH1=objChild.CRCPXH1
				Set CPFL1=objChild.CRCPFL1.Description
				Set CPMC2=objChild.CRCPMC2
				Set CPXH2=objChild.CRCPXH2
				Set CPFL2=objChild.CRCPFL2.Description
				
				Set DXALs=objChild.CRDXAL
				Set DXALstr=""
				For xind=1:1:DXALs.Count() {
					Set objDic=DXALs.GetAt(xind)
					Continue:'$IsObject(objDic)
					Set DXALstr=DXALstr_","_objDic.Description
				}
				Set:DXALstr'="" DXALstr=$e(DXALstr,2,$l(DXALstr))
				
				Set PatInfo = ..GetPatInfoByRepID(xRepID,aPatName,aRegNo)
				Continue:PatInfo=""
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(EpisodeID,KPBH,SHFSRQ,HZJZRQ,SHFSYY,SHFSDD,SHFSSHD,SHSFGY,SHXZ,SHBW,SHZDID,SHZDDesc,SHJJ,CPMC1,CPXH1,CPFL1,CPMC2,CPXH2,CPFL2,DXALstr,DelReason,SHZDCode,MrNo)
				Set Data=Data_PatInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySHKRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySHKRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySHKRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySHKRepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-21
/// Description:  根据日期查询高温中暑卡信息(GWZS)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportGWZS
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryGWZSRepByDate","2022-03-08","2022-03-08","","","")
Query QryGWZSRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,MrNo:%String,ZSXZ:%String,ZSLCBX:%String,ZSZD:%String,ZDRQ:%String,EpisodeID:%String,OutCome:%String,DelReason:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PersonalID:%String,Nation:%String,Birthday:%String,TelPhone:%String,Occupation:%String,Company:%String,CurrAddress:%String,RegAddress:%String,Education:%String,Marriage:%String")
{
}

ClassMethod QryGWZSRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="GWZS"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,PapmiNo,PatName,PatSex,PatAge,PersonalID,Nation,Birthday,TelPhone,Occupation,Company,CurrAddress,RegAddress,Education,Marriage)=""
				Set (MrNo,ZSXZ,ZSLCBX,ZSZD,ZDRQ,OutCome)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
				
				Set objChild=##class(DHCMed.CD.CRReportGWZS).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
				Set ZSXZ=objChild.CRZSXZ.Description
				Set ZSLCBX=objChild.CRZSLCBX
				Set ZSZD=objChild.CRZSZD.Description
				Set ZDRQ=objChild.CRZDRQ
				;Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
				Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
				Set OutCome=objChild.CRZSZG.Description
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PapmiNo		= objPat.CRDJH		// 登记号
					Set PatName		= objPat.CRXM		// 姓名	
					Continue:((aPatName'="")&&(aPatName'=PatName))
					Set PatSex=objPat.CRXB
					Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
					Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
					Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
					
				}
				If (PapmiNo="") {
					Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
					Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
				}
				Continue:((aRegNo'="")&&(aRegNo'=PapmiNo))
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,MrNo,ZSXZ,ZSLCBX,ZSZD,ZDRQ,EpisodeID,OutCome,DelReason)
				Set Data=Data_..GetPatInfoByRepID(xRepID)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryGWZSRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGWZSRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryGWZSRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGWZSRepByDateExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-12-21
/// Description:  根据日期查询疑似职业病信息(YSZYB)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportYSZYB
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryYSZYBRepByDate","2015-11-11","2015-11-19","","")
Query QryYSZYBRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,MrNo:%String,YRDWMC:%String,YRDWDZ:%String,YRDWYB:%String,YRDWLXR:%String,YRDWLXRDH:%String,JJLX:%String,DWHY:%String,QYGM:%String,BRLY:%String,ZYBZL:%String,JTBM:%String,ZDSGBM:%String,TSZDRS:%String,TJGZ:%String,ZYGL:%String,JCSJ:%String,FSRQ:%String,ZDRQ:%String,DelReason:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PersonalID:%String,Nation:%String,Birthday:%String,TelPhone:%String,Occupation:%String,Company:%String,CurrAddress:%String,RegAddress:%String,Education:%String,Marriage:%String")
{
}

ClassMethod QryYSZYBRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="YSZYB"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,MrNo,YRDWMC,YRDWDZ,YRDWYB,YRDWLXR,YRDWLXRDH,JJLX,DWHY,QYGM,BRLY,ZYBZL,JTBM,ZDSGBM,TSZDRS,TJGZ,ZYGL,JCSJ,FSRQ,ZDRQ,PapmiNo,PatName,PatSex,PatAge,PersonalID,Nation,Birthday,TelPhone,Occupation,Company,CurrAddress,RegAddress,Education,Marriage)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set:ReportUser'="" ReportUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTCareProv","CTPCPDesc","EN",ReportUser)
				
				Set ReportDate=objRep.CRReportDate
				;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
						Set:CheckUser'="" CheckUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTCareProv","CTPCPDesc","EN",CheckUser)
				
					}
				}
				Set CheckDate=objRep.CRCheckDate
				;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
 				Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)         //病人ID
				Set DelReason=objRep.CRDelReason
				
				Set objChild=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				
				Set YRDWMC = objChild.CRYRDWMC
				Set YRDWDZ = objChild.CRYRDWDZ
				Set YRDWYB = objChild.CRYRDWYB
				Set YRDWLXR = objChild.CRYRDWLXR
				Set YRDWLXRDH = objChild.CRYRDWLXRDH
				Set JJLX = objChild.CRJJLX
				
				Set DWHY = objChild.CRDWHY
				Set QYGM = objChild.CRQYGM.Description
				Set BRLY = objChild.CRBRLY.Description
				Set ZYBZL = objChild.CRZYBZL
				Set JTBM = objChild.CRJTBM
				Set ZDSGBM = objChild.CRZDSGBM
				
				Set TSZDRS = objChild.CRTSZDRS
				Set TJGZ   = objChild.CRTJGZ.Description
				Set ZYGL   = objChild.CRZYGLN_"年"_objChild.CRZYGLY_"月"
				Set JCSJ   = objChild.CRJCSJT_"天"_objChild.CRJCSJS_"时"_objChild.CRJCSJF_"分"
				Set FSRQ=objChild.CRFSRQ
				Set:FSRQ'="" FSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FSRQ)
				Set ZDRQ=objChild.CRZDRQ
				Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
				
				Set PatInfo = ..GetPatInfoByRepID(xRepID,aPatName,aRegNo)
				Continue:PatInfo=""
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,MrNo,YRDWMC,YRDWDZ,YRDWYB,YRDWLXR,YRDWLXRDH,JJLX,DWHY,QYGM,BRLY,ZYBZL,JTBM,ZDSGBM,TSZDRS,TJGZ,ZYGL,JCSJ,FSRQ,ZDRQ,DelReason,EpisodeID,PatientID)
				Set Data=Data_PatInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryYSZYBRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryYSZYBRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryYSZYBRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryYSZYBRepByDateExecute ]
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

/// Creator：     zhouruimeng
/// CreatDate：   2015-12-28
/// Description:  根据日期查询职业病报卡信息(ZYB)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportYSZYB
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryZYBRepByDate","2015-11-11","2015-11-19","","")
Query QryZYBRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,MrNo:%String,ZYBZL:%String,JTBM:%String,FSRQ:%String,ZDRQ:%String,SWRQ:%String,EpisodeID:%String,DelReason:%String")
{
}

ClassMethod QryZYBRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="YSZYB"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,PapmiNo,PatName,PatSex,PatAge)=""
				Set (MrNo,ZYBZL,JTBM,FSRQ,ZDRQ,SWRQ)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
				
				Set objChild=##class(DHCMed.CD.CRReportYSZYB).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
				Set ZYBZL=objChild.CRZYBZL
				Set JTBM=objChild.CRJTBM
				Set FSRQ=objChild.CRFSRQ
				;Set:FSRQ'="" FSRQ=$zd(FSRQ,3)
				Set:FSRQ'="" FSRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FSRQ)
				Set ZDRQ=objChild.CRZDRQ
				;Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
				Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
				Set SWRQ=objChild.CRSWRQ
				;Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
				Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
				
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PatientID=objPat.CRPatientID
					Set PapmiNo=objPat.CRDJH
					Set:PapmiNo="" PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
					Continue:((aRegNo'="")&&(aRegNo'=PapmiNo))
					Set PatName= objPat.CRXM		// 姓名	
					Continue:((aPatName'="")&&(aPatName'=PatName))
					Set PatSex=objPat.CRXB
					Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
					Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
					Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
				}
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,PapmiNo,PatName,PatSex,PatAge)
				Set Data=Data_$lb(MrNo,ZYBZL,JTBM,FSRQ,ZDRQ,SWRQ,EpisodeID,DelReason)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryZYBRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryZYBRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryZYBRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryZYBRepByDateExecute ]
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

/// Creator：     pylian
/// CreatDate：   2016-04-27
/// Description:  根据日期查询慢性病报病卡信息(MBBK)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportMBBK
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryMBBKRepByDate","2016-04-21","2016-05-01","","")
Query QryMBBKRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String, aMrNo As %String, aRegNo As %String) As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,BGKLX:%String,ZDYJ:%String,Diganose:%String,SWRQ:%String,JTSWYY:%String,EpisodeID:%String,DelReason:%String,LocID:%String,GXBZD:%String,NCZZD:%String,TNBZD:%String,ZDMC:%String,Flg:%Integer") [ SqlProc ]
{
}

ClassMethod QryMBBKRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String, aMrNo As %String, aRegNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			//Continue:(aRepLoc'="")&&(aRepLoc'=$p(xLoc," ",2))
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="MBBK"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,PapmiNo,PatName,PatSex,PatAge)=""
				Set (MrNo,ZDDesc,ZDICD,ZDRQ,SWRQ,SWYY)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
							
				Set objChild=##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
                
                Set BGKLX=objChild.CRBGKLX.Description    //报告类型
				
				Set ZDYJLis=objChild.CRZDYJ   //诊断依据
				Set ZDYJs=""
				For indz=1:1:ZDYJLis.Count(){
					Set objDic=ZDYJLis.GetAt(indz)
					Continue:'$IsObject(objDic)
					Set ZDYJs=ZDYJs_","_objDic.Description
				}
				Set GXBZD=objChild.CRGXBZD.Description
				Set NCZZD=objChild.CRNCZZD.Description
				Set TNBZD=objChild.CRTNBZD.Description
				Set ZDMC=##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objChild.CRZDMC)  //肿瘤诊断
				Set ZDMC=$p(ZDMC,$c(1),2)
				Set GZZD=##class(DHCMed.CD.CRReportXNXG).GetICDDescByID(objChild.CRGZZD)  //肿瘤更正诊断
				Set GZZD=$p(GZZD,$c(1),2)
				Set:GZZD'="" ZDMC=GZZD
				Set Flg=0
				Set:ZDMC'="" Flg=1
				Set Diganose=""
				If (GXBZD'=""){
					Set Diganose=Diganose_" "_GXBZD
				}
				If (NCZZD'=""){
					Set Diganose=Diganose_" "_NCZZD
				}
				If (TNBZD'=""){
					Set Diganose=Diganose_" "_TNBZD
				}
				If (ZDMC'=""){
					Set Diganose=Diganose_" "_ZDMC
				}
				Set SWRQ=objChild.CRSWRQ
				Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
				
				Set JTSWYY=objChild.CRJTSWYY
				
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
					Set PapmiNo=objPat.CRDJH
					Set:PapmiNo="" PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
					Set PatName=objPat.CRXM
					Set PatSex=objPat.CRXB
					Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
					Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
					Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
				}
				
				Set MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,"I","")
				
				//add by xwj 解决根据名字，登记号，病案号查询
				continue:(aRegNo'="")&&(PapmiNo'[aRegNo)
				continue:(aMrNo'="")&&(MrNo'[aMrNo)
				continue:(aPatName'="")&&(PatName'[aPatName)
				//end
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,PapmiNo,MrNo,PatName,PatSex,PatAge,BGKLX,ZDYJs,Diganose,SWRQ,JTSWYY,EpisodeID,DelReason)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryMBBKRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMBBKRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMBBKRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMBBKRepByDateExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2021-10-13
/// Description:  根据日期查询儿童伤害卡信息(ETSH)
/// Table：       DHCMed.CD.CRReport,DHCMed.CD.CRReportETSH
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryETSHRepByDate","2021-10-13","2021-10-13","","","")
Query QryETSHRepByDate(aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,CheckUser:%String,CheckDate:%String,RepLocDesc:%String,KPBH:%String,PatName:%String,PatSex:%String,ChildSchool:%String,HappenTime:%String,HappenResaon:%String,HappenPlace:%String,HappenActivity:%String,IsWillfully:%String,IsDrink:%String,DelReason:%String,EpisodeID:%String")
{
}

ClassMethod QryETSHRepByDateExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospID As %String, aRepLoc As %String, aRepStatus As %String, aPatName As %String = "", aRegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Set tmpRepLoc=$p(xLoc," ",2)
			Continue:(aRepLoc'="")&&(aRepLoc'=tmpRepLoc)
			
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(+tmpRepLoc,aHospID)
				continue:flg<1
			}
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLoc,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:objRep.CRReportType.CRFCode'="ETSH"
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)=""
				Set (KPBH,PatName,PatSex)=""
				Set (ChildSchool,HappenTime,HappenResaon,HappenPlace,HappenActivity,IsWillfully,IsDrink)=""
				
				Set RepStatusID=objRep.CRReportStatus.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusID)
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				set RepLocDesc=$p($g(^CTLOC(+$p(xLoc," ",2))),"^",2)
				set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
				Set EpisodeID=objRep.CREpisodeID
				Set DelReason=objRep.CRDelReason
				
				Set objChild=##class(DHCMed.CD.CRReportETSH).GetObjByParRef(xRepID)
				Continue:'$IsObject(objChild) 
				Set KPBH=objChild.CRKPBH
				Set HappenTime=objChild.HappenTime
				Set:$IsObject(objChild.ChildSchool) ChildSchool = objChild.ChildSchool.Description
				Set:$IsObject(objChild.HappenResaon) HappenResaon = objChild.HappenResaon.Description
				Set:$IsObject(objChild.HappenPlace) HappenPlace = objChild.HappenPlace.Description
				Set:$IsObject(objChild.HappenActivity) HappenActivity = objChild.HappenActivity.Description
				Set:$IsObject(objChild.IsWillfully) IsWillfully = objChild.IsWillfully.Description
				Set:$IsObject(objChild.IsDrink) IsDrink = objChild.IsDrink.Description
				   
				Set objChildPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				if ($IsObject(objChildPat)){
					Set PapmiNo		= objChildPat.CRDJH		// 登记号
					Continue:((aRegNo'="")&&(aRegNo'=PapmiNo))
					Set PatName		= objChildPat.CRXM		// 姓名	
					Continue:((aPatName'="")&&(aPatName'=PatName))
					Set PatSex  = objChildPat.CRXB
				}
				
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,RepLocDesc)
				Set Data=Data_$lb(KPBH,PatName,PatSex,ChildSchool,HappenTime,HappenResaon,HappenPlace,HappenActivity,IsWillfully,IsDrink,DelReason,EpisodeID)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryETSHRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryETSHRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryETSHRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryETSHRepByDateExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2022-03-08
/// Description:  根据报告ID查询患者信息（慢病报卡通用）
/// Table：       DHCMed.CD.CRReportPAT
/// Input：       ID:    
/// Return：      返回String
/// w ##class(DHCMed.CDService.QryService).GetPatInfoByRepID(40)
ClassMethod GetPatInfoByRepID(RepID As %String, aPatName As %String = "", aRegNo As %String = "") As %String
{
	new (RepID,aPatName,aRegNo)
	set return=""
	quit:RepID="" return
	Set (PapmiNo,PatName,PatSex,PatAge,PersonalID,Nation,Birthday,TelPhone,Occupation,Company,CurrAddress,RegAddress,Education,Marriage,RegProvince,RepCity,RegCounty,RegVillage,RegRoad,CurrProvince,CurrCity,CurrCounty,CurrVillage,CurrRoad,MZH,LXR) = ""
	Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(RepID)
	If ($IsObject(objPat)) {
		Set PatientID = objPat.CRPatientID
		Set PapmiNo=objPat.CRDJH
		Set:((PapmiNo="")&&(PatientID'="")) PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
		Quit:((aRegNo'="")&&(aRegNo'=PapmiNo)) ""
		Set PatName=objPat.CRXM
		Quit:((aPatName'="")&&(aPatName'=PatName)) ""
		Set PatSex=objPat.CRXB
		Set PatSex = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTSex","CTSEXDesc","EN",PatSex)
		Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
		Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
		Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
		Set PersonalID=objPat.CRSFZH
		Set Nation=objPat.CRMZ.Description
		Set Birthday=objPat.CRCSRQ
		Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
		Set TelPhone=objPat.CRJTDH
		Set:TelPhone="" TelPhone=objPat.CRLXDH
		Set Occupation=objPat.CRZY.Description
		Set Company=objPat.CRGZDW
		Set CurrAddress=objPat.CRCZDZXX
		Set RegAddress=objPat.CRHJDZXX
		Set Education=objPat.CRWHCD.Description
		Set Marriage=objPat.CRHYZK.Description
		
		Set RegProvince=objPat.CRHJDZS.ShortDesc
		Set RepCity=objPat.CRHJDZS2.ShortDesc
		Set RegCounty=objPat.CRHJDZX.ShortDesc
		Set RegVillage=objPat.CRHJDZX2.ShortDesc
		Set RegRoad=objPat.CRHJDZC
		
		Set CurrProvince=objPat.CRCZDZS.ShortDesc
		Set CurrCity=objPat.CRCZDZS2.ShortDesc
		Set CurrCounty=objPat.CRCZDZX.ShortDesc
		Set CurrVillage=objPat.CRCZDZX2.ShortDesc
		Set CurrRoad=objPat.CRCZDZC
		Set MZH=objPat.CRMZH
		Set LXR=objPat.CRLXR
		
	}
	Set return = $lb(PapmiNo,PatName,PatSex,PatAge,PersonalID,Nation,Birthday,TelPhone,Occupation,Company,CurrAddress,RegAddress,Education,Marriage,RegProvince,RepCity,RegCounty,RegVillage,RegRoad,CurrProvince,CurrCity,CurrCounty,CurrVillage,CurrRoad,MZH,LXR)
	quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-03-16
/// Description:  根据PatientID取肿瘤卡历史数据
/// Table：       DHCMed.CD.CRReport
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CDService.QryService","QryZLKRepByPatientID","8")
Query QryZLKRepByPatientID(aPatientID As %String) As %Query(ROWSPEC = "ind:%String,ReportID:%String,RepTypeCode:%String,RepTypeDesc:%String,RepStatusDesc:%String,ReportUser:%String,ReportDate:%String,ReportTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReportLoc:%String,KPBH:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatAge:%String,CRZD:%String")
{
}

ClassMethod QryZLKRepByPatientIDExecute(ByRef qHandle As %Binary, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xAdmType=""
	For {
		Set xAdmType=$o(^PAPERdr(aPatientID,"ADM",xAdmType))
		Quit:xAdmType=""

		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^PAPERdr(aPatientID,"ADM",xAdmType,EpisodeID))
			Quit:EpisodeID=""

			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_EpisodeID,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				
				Set (RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,CheckUser,CheckDate,ReportLoc)=""
				Set (KPBH,PapmiNo,PatName,PatSex,PatAge,CRZD)=""
				
				Set RepTypeCode=objRep.CRReportType.CRFCode
				Continue:RepTypeCode'="ZLK"
				Set RepTypeDesc=objRep.CRReportType.CRFDesc
				Set RepStatusDesc=objRep.CRReportStatus.Description
				Set ReportUser=objRep.CRReportUser
				Set ReportDate=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
				Set ReportTime=objRep.CRReportTime
				set:ReportTime'="" ReportTime=$zt(ReportTime,1)
				Set CheckUserDr=objRep.CRCheckUser
				If (CheckUserDr'=""){
					set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUserDr)
					If ($IsObject(objUser)){
						set CheckUser=objUser.Name
					}
				}
				Set CheckDate=objRep.CRCheckDate
				Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
				Set CheckTime=objRep.CRCheckTime
				set:CheckTime'="" CheckTime=$zt(CheckTime,1)
				Set ReportUser=objRep.CRReportUser
				Set ReportLoc=$p($g(^CTLOC(objRep.CRReportLoc)),"^",2) 
				Set:ReportLoc["-" ReportLoc=$p(ReportLoc,"-",2)
				Set ReportLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc","",ReportLoc)
				Set objChild=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(xRepID)
				
				Set:$IsObject(objChild) KPBH=objChild.CRKPBH
				Set:$IsObject(objChild) CRZD=objChild.CRZD
				if (CRZD'=""){
					Set CRZD = ##class(DHCMed.CD.CRICDDx).GetDescByID(CRZD)
					Set CRZD = $p(CRZD,$c(1),2)
				}
				Set objPat=##class(DHCMed.CD.CRReportPAT).GetObjByParRef(xRepID)
				If ($IsObject(objPat)) {
					Set PapmiNo=objPat.CRDJH
					Set PatName=objPat.CRXM
					Set PatSex=objPat.CRXB
					Set:objPat.CRNLS'="" PatAge=objPat.CRNLS_"岁"
					Set:objPat.CRNLY'="" PatAge=objPat.CRNLY_"月"
					Set:objPat.CRNLT'="" PatAge=objPat.CRNLT_"天"
				}
				If (PapmiNo="") {
					Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
					Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
				}
				Set Data=$lb(ind,xRepID,RepTypeCode,RepTypeDesc,RepStatusDesc,ReportUser,ReportDate,ReportTime,CheckUser,CheckDate,CheckTime,ReportLoc)
				Set Data=Data_$lb(KPBH,PapmiNo,PatName,PatSex,PatAge,CRZD)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryZLKRepByPatientIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryZLKRepByPatientIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryZLKRepByPatientIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryZLKRepByPatientIDExecute ]
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

}
