/// 名称:DHCMed.EPDService.CasesXSrv
/// 描述: 传染病例筛查日志 查询
/// 编写者：pylian
/// 编写日期: 2016-02-07
Class DHCMed.EPDService.CasesXSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2016-02-27
/// Description:  传染病例筛查日志 查询
/// Table：       DHCMed.EPD.Casesx
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.EPDService.CasesXSrv","QryCasesXByDate","EPDCC","2016-02-01","2016-02-29","","","I,O,E")
Query QryCasesXByDate(aSubjectCode As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String = "", aAdmType As %String = "") As %Query(ROWSPEC = "CasesXID:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,AdmType:%String,EncryptLevel:%String,PatLevel:%String,ActDate:%String,ActLoc:%String,ActDiagnos:%String,LnkResults:%String,LnkResultsDesc:%String,EpdStatusCode:%String,EpdStatusDesc:%String,EpdDiagnos:%String,Opinion:%String")
{
}

ClassMethod QryCasesXByDateExecute(ByRef qHandle As %Binary, aSubjectCode As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String = "", aAdmType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aSubjectCode="")||(aDateFrom="")||(aDateTo="") $$$OK
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)

 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h	

	For xDate=aDateFrom:1:aDateTo {
 		Set xCasesXID=""
 		For {
 			Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectActDate",aSubjectCode,xDate,xCasesXID))
 			Quit:xCasesXID=""
 		
 			Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
			Continue:'$IsObject(objCasesX)
			Set IsActive=objCasesX.CXIsActive
			Continue:IsActive'=1
		
			Set EpisodeID=objCasesX.CXEpisodeID
 			Set AdmInfo=$g(^PAADM(EpisodeID))
 			Set AdmType=$p(AdmInfo,"^",2)                   //就诊类型过滤
 			Continue:(aAdmType'="")&&(aAdmType'[AdmType)
			Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:AdmLoc=""
			Continue:(aLocID'="")&&(aLocID'=AdmLoc)
 			//Set HospID=$p($g(^CTLOC(AdmLoc)),"^",22)
			//Continue:(aHospID'="")&&(aHospID'=HospID)
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
				continue:flg<1
			}
		
			Set ActDate=objCasesX.CXActDate
			Set ActLoc=objCasesX.CXActLoc
			Set ActDiagnos=objCasesX.CXActDiagnos
			Set LnkResults=objCasesX.CXLnkResults
			
			Set DataValue="",LnkResultsDesc=""
 			For indRst=1:1:$l(LnkResults,",") {
				Set ResultID=$p(LnkResults,",",indRst)
				Continue:ResultID=""
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
			
				Set DataValue=DataValue_","_objResult.DataValue
				
 			}
 			Set:DataValue'="" LnkResultsDesc=$e(DataValue,2,$l(DataValue))
 			Set IsRepEpd=##class(DHCMed.EPD.Epidemic).CheckIsRepEpd(EpisodeID,LnkResultsDesc)
 			Continue:IsRepEpd=1
 		
 			Set EpdStatus=objCasesX.CXEpdStatus
			Set EpdStatusDesc=$s(EpdStatus="-1":"未处置",EpdStatus="0":"排除",EpdStatus="1":"确诊",-1:"")
			Set EpdDiagnosID=objCasesX.CXEpdDiagnos
		    Set EpdDiagnos=""
			If (EpdDiagnosID'="") {	
				Set objInf=##class(DHCMed.EPD.Infection).GetObjById(EpdDiagnosID)
				Set:$IsObject(objInf) EpdDiagnos=objInf.MIFDisease
			}
							
			Set Opinion=objCasesX.CXOpinion
			
			Set Data=##class(DHCMed.EPDService.CtlResultSrv).BuildData(EpisodeID)
			Continue:Data=""
			Set Data=$lb(xCasesXID)_Data_$lb(ActDate,ActLoc,ActDiagnos,LnkResults,LnkResultsDesc,EpdStatus,EpdStatusDesc,EpdDiagnos,Opinion)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
	}
	
	Quit $$$OK
}

ClassMethod QryCasesXByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCasesXByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCasesXByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCasesXByDateExecute ]
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
/// CreatDate：   2016-02-29
/// Description:  检查当前状态是否允许处置操作
/// Table：       DHCMed.EPD.CasesX
/// Input：       主题配置代码\筛查ID
/// Return：      返回Object
/// w ##class(DHCMed.EPDService.CasesXSrv).CheckCasesStatus("EPDCC",15)
ClassMethod CheckCasesStatus(aSubjectCode As %String, aCasesXID As %String)
{
	new (aSubjectCode,aCasesXID)
	Set return=0
	Quit:(aSubjectCode="")||(aCasesXID="") return
	
	Set $ZT="CheckCasesStatusError"
	
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
			
	Set EpdStatus=objCasesX.CXEpdStatus
 
	If (EpdStatus="0")||(EpdStatus="1") {
		Set return=-1
		Quit return
	}
 	Set return=1
	Quit return
	
CheckCasesStatusError
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2016-02-29
/// Description:  处理传染病处置记录(排除\确诊)
/// Table：       DHCMed.EPD.CasesX
/// Input：       就诊号\传染病筛查记录ID\操作代码\诊断\意见\操作员登录科室\操作员
/// Return：      返回Object
/// w ##class(DHCMed.EPDService.CasesXSrv).ProcCasesHandle("EPDCC","12","1","3333","117","9")
ClassMethod ProcCasesHandle(aSubjectCode As %String, aCasesXID As %String, aOperation As %String, aDiagnosID As %String, aOpinion As %String, aLocID As %String, aUserID As %String)
{
	new (aSubjectCode,aCasesXID,aOperation,aDiagnosID,aOpinion,aLocID,aUserID)
	Set return=0
	Quit:(aSubjectCode="")||(aCasesXID="")||(aOperation="") return
	
	
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
	Set EpisodeID=objCasesX.CXEpisodeID
	
    Set inputStr=aCasesXID		
	Set inputStr=inputStr_"^"_aSubjectCode
	Set inputStr=inputStr_"^"_EpisodeID
	Set inputStr=inputStr_"^"_objCasesX.CXActDate
	Set inputStr=inputStr_"^"_objCasesX.CXActLoc
		
	Set inputStr=inputStr_"^"_objCasesX.CXActDiagnos
	Set inputStr=inputStr_"^"_objCasesX.CXIsReAdm
	Set inputStr=inputStr_"^"_objCasesX.CXLnkResults
	Set inputStr=inputStr_"^"_aOperation
	Set inputStr=inputStr_"^"_aDiagnosID
	Set inputStr=inputStr_"^"_aOpinion 
	Set inputStr=inputStr_"^"_+$h
	Set inputStr=inputStr_"^"_$p($h,",",2)
	Set inputStr=inputStr_"^"_aLocID
	Set inputStr=inputStr_"^"_aUserID
	Set inputStr=inputStr_"^"_objCasesX.CXIsActive
	Set inputStr=inputStr_"^"_objCasesX.CXResume
	
	Set flg=##class(DHCMed.EPD.CasesX).Update(inputStr,"^")
	//传染病排除/确诊消息推送
	If aOperation="1"  {//确诊
	    Set RepFlag=##class(DHCMed.EPDService.CasesXSrv).IsReportByCasesXID(aCasesXID)
	    IF (RepFlag=1) {
	   		Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000040",aCasesXID,"4",EpisodeID)
	    }ElseIf(RepFlag=0) {
			Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000040",aCasesXID,"1",EpisodeID)
			//add by liuyh 2016-08-31 确诊未报时往消息平台发送消息
	    	Set SendMessage = ##class(websys.DHCMessageInterface).Send(aOpinion,"1018",aUserID,EpisodeID,"","","{""linkParam"":""EpisodeID="_EpisodeID_""",""dialogWidth"":""1340px"",""dialogHeight"":""90%""}","","","")
		}
	}ElseIf aOperation="0"{    //排除
		Set Hisret=##Class(DHCMed.SSIO.FromEnsSrv).DHCHisInterface("S00000040",aCasesXID,"2",EpisodeID)
	}
	Set return=1
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-03-02
/// Description:  检查处置操作的患者是否上报传染病
/// Table：       DHCMed.EPD.CasesX、DHCMed.EPD.Epidemic
/// Input：       筛查ID
/// Return：      上报传染病报告（传染病诊断名称、传染病报卡日期）,是，"",否
/// w ##class(DHCMed.EPDService.CasesXSrv).GetIsReportByCasesXID(15)
ClassMethod GetIsReportByCasesXID(aCasesXID As %String)
{
	new (aCasesXID)
	Set return=""
	Quit:(aCasesXID="") return
		
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
			
	Set EpdStatus=objCasesX.CXEpdStatus
    Set EpisodeID=objCasesX.CXEpisodeID
    Quit:'$d(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID)) return  //无报告退出
   
    Set RepDiseases="" ,RepDates="",RepDisease="" ,RepDate=""
    Set RepID=""
    For {
	    Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID,RepID))
	    Quit:RepID=""
	    
	    Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
	    Continue:'$IsObject(objRep)
	  	Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		Continue:'$IsObject(objRep.MEPDICDDR)
		
		Set RepDisease=objRep.MEPDICDDR.MIFDisease
	    Set RepDate=objRep.MEPDRepDate
	    //Set:RepDate'="" RepDate=$zd(RepDate,3)
	    Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	    
	    Set RepDiseases=RepDiseases_","_RepDisease
		Set RepDates=RepDates_","_RepDate   
    }
    
	Set:RepDiseases'="" RepDiseases=$e(RepDiseases,2,$l(RepDiseases))
	Set:RepDates'="" RepDates=$e(RepDates,2,$l(RepDates))
	
	Set:(RepDiseases'="")&&(RepDates'="") return=RepDiseases_"^"_RepDates
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-03-29
/// Description:  检查处置操作的患者是否上报某种传染病
/// Table：       DHCMed.EPD.CasesX、DHCMed.EPD.Epidemic
/// Input：       筛查ID
/// Return：      是:1,否:0
/// w ##class(DHCMed.EPDService.CasesXSrv).IsReportByCasesXID(1)
ClassMethod IsReportByCasesXID(aCasesXID As %String)
{
	new (aCasesXID)
	Set return=0
	Quit:(aCasesXID="") return
		
	Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(aCasesXID)
	Quit:'$IsObject(objCasesX) return
	Set IsActive=objCasesX.CXIsActive
	Quit:IsActive'=1 return
			
	Set EpdStatus=objCasesX.CXEpdStatus
    Set EpisodeID=objCasesX.CXEpisodeID
    Quit:'$d(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID)) return  //无报告退出
    
    Set EpdDiagnos=objCasesX.CXEpdDiagnos  //确诊诊断
    
    Set RepID=""
    For {
	    Set RepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID,RepID))
	    Quit:RepID=""
	    Quit:return=1
	    
	    Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
	    Continue:'$IsObject(objRep)
	  	Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		Continue:'$IsObject(objRep.MEPDICDDR)
		
		Set EpdDesc=objRep.MEPDICDDR.MIFDisease
		Set EpdKind=objRep.MEPDICDDR.MIFKind
		Continue:(EpdKind'="")&&(EpdDiagnos'=EpdKind)
		Set return=1
    }
    
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2016-03-29
/// Description:  上报时检查是否有确诊处置记录
/// Table：       DHCMed.EPD.CasesX、DHCMed.EPD.Epidemic
/// Input：       ReportID
/// Return：      是:1,否:0
/// w ##class(DHCMed.EPDService.CasesXSrv).IsCasesXByReportID(139)
ClassMethod IsCasesXByReportID(aReportID As %String)
{
	new (aReportID)
	Set return=0
	Quit:(aReportID="") return
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	//Quit:objRep.MEPDStatus="4" return           //被订状态报告无效
	//Quit:objRep.MEPDStatus="6" return           //草稿状态报告无效
	//Quit:objRep.MEPDStatus="7" return           //删除状态报告无效
	Quit:'$IsObject(objRep.MEPDICDDR) return
    
    Set EpisodeID=objRep.MEPDText1
    Quit:'$d(^DHCMed.EPDi("CasesX","IndexSubjectPaadm","EPDCC",EpisodeID)) return  //无处置记录退出
	
    Set EpdDesc=objRep.MEPDICDDR.MIFDisease
	Set EpdKind=objRep.MEPDICDDR.MIFKind
    Set RepDate=objRep.MEPDRepDate
	
    Set xCasesXID=""
	For {
		Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectPaadm","EPDCC",EpisodeID,xCasesXID))
		Quit:xCasesXID=""
	    Quit:$p(return,"^",1)=1
		
		Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
		Continue:'$IsObject(objCasesX)
		Set IsActive=objCasesX.CXIsActive
		Continue:IsActive'=1
		
		Set AdmInfo=$g(^PAADM(EpisodeID))
		Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
		
		Set EpdStatus=objCasesX.CXEpdStatus
		Continue:EpdStatus'=1                           //非确诊状态退出
		Set EpdDiagnos=objCasesX.CXEpdDiagnos           //确诊诊断
		Set EvalDate=objCasesX.CXEvalDate
		//Continue:(EvalDate>RepDate)||((EvalDate+15)<RepDate)  //报告之后的处置记录不在范围内,半个月之前的处置记录不在范围内
		
		Continue:(EpdDiagnos'="")&&(EpdDiagnos'=EpdKind)
		Set return=1_"^"_xCasesXID
		
	}
    
	Quit return
}

/// Creator：     mxp
/// CreatDate：   2016-12-29
/// Description:  获取传染病处置排除诊断
/// Table：       DHCMed.EPD.CasesX、DHCMed.EPD.Epidemic
/// Input：       EpisodeID
/// Return：      是:1,否:0
/// w ##class(DHCMed.EPDService.CasesXSrv).GetOutDiagnos(794,"EPDCC")
ClassMethod GetOutDiagnos(aEpisodeID As %String, aSubjectCode As %String)
{
	new (aEpisodeID,aSubjectCode)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set:aSubjectCode="" aSubjectCode="EPDCC"
	
	Set OutDiagnos=""
	
	Set xCasesXID=""
 	For {
 		Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectPaadm",aSubjectCode,aEpisodeID,xCasesXID))
 		Quit:xCasesXID=""
 		
 		Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
		Continue:'$IsObject(objCasesX)
		Set IsActive=objCasesX.CXIsActive
		Continue:IsActive'=1
	
		Set EpdStatus=objCasesX.CXEpdStatus
		Continue:EpdStatus'=0 
		Set ActDiagnos=objCasesX.CXActDiagnos
		for ind=1:1:$l(ActDiagnos,",") {
			Set tmpEpdDiagnos=$p(ActDiagnos,",",ind)
			Continue:tmpEpdDiagnos=""
			Continue:$listfind(OutDiagnos,tmpEpdDiagnos)>0
			Set OutDiagnos=OutDiagnos_$lb(tmpEpdDiagnos)
		} 
 	}
 	
    Set return=OutDiagnos
	Quit return
}

}
