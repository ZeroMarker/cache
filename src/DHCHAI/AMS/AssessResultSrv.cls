/// 名称: DHCHAI.AMS.AssessResultSrv
/// 描述: 疑似病例筛查评估结果相关服务
/// 编写者：zhufei
/// 编写日期: 2019-03-13
Class DHCHAI.AMS.AssessResultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-03-13
/// Description:  查询评估结果
/// Table：       DHCHAI.AM.AssessResult
/// Input：       无
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.AMS.AssessResultSrv","QryAssessResult","1","")
Query QryAssessResult(aModelDr As %String, aInfPos As %String = "") As %Query(ROWSPEC = "ID:%String,ModelID:%String,ModelCode:%String,ModelDesc:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,AdmDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,OprStatus:%String,InfType:%String,InfTypeDesc:%String,SusResult:%String,SusDiagnos:%String,Status:%String,StatusDesc:%String,DiagDate:%String,DiagNote:%String,RstDate:%String,RstTime:%String,RstUserCode:%String,RstUserDesc:%String,InfRepList:%String,DiagonsList:%String,AdmDiagonsList:%String,LabList:%String,SuMatrix:%String") [ SqlProc ]
{
}

ClassMethod QryAssessResultExecute(ByRef qHandle As %Binary, aModelDr As %String, aInfPos As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aModelDr="" $$$OK
	Set objModel=##class(DHCHAI.AM.AssessModel).GetObjById(aModelDr)	    
	Quit:'$IsObject(objModel) $$$OK
	Set ModelCode = objModel.AMCode
	Set ModelDesc = objModel.AMDesc		
	Set SttDate   = objModel.AMSttDate
	Set EndDate   = objModel.AMEndDate 
	Set AdmStatus = objModel.AMAdmStatus
		
	Set LabItemDr=""
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-Bacteria")
	If $IsObject(objItem) {
		Quit:objItem.CCIsActive'=1 $$$OK
		Set LabItemDr=objItem.%Id()
	}
	Set DiagItemDr=""
	Set objItem2=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-AdmDiagnos")
	If $IsObject(objItem2) {
		Quit:objItem2.CCIsActive'=1 $$$OK
		Set DiagItemDr=objItem2.%Id()
	}
	
    Set xEpisodeDr=""	    
	For {
		Set xEpisodeDr=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr))
	    Quit:xEpisodeDr=""
	    
	    Set xID=""	    
		For {
			Set xID=$o(^DHCHAI.AM.AssessResultI("IdxofModelEpis",aModelDr,xEpisodeDr,xID))
		    Quit:xID=""

		    Set obj= ##class(DHCHAI.AM.AssessResult).GetObjById(xID)
		    Continue:'$IsObject(obj)
		    Continue:obj.ARIsActive'=1
	   
			Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
			Continue:'$IsObject(objEpisode)
			
			Set PapmiNo = objEpisode.PAPapmiNo	
			Set MrNo = objEpisode.PAMrNo		
			Set PatName = objEpisode.PAPatName	
			Set Sex = objEpisode.PASex
			Set Sex = $s(Sex="F":"女",Sex="M":"男",1:"")  			
			Set Age = objEpisode.PAAge	
			Set AdmType = objEpisode.PAAdmType
			Continue:(AdmType'="I")&&(AdmType'="EP") 
			Set AdmType = $s(AdmType="I":"住院",AdmType="EP":"急诊留观") 
			Set AdmDate=objEpisode.PAAdmDate
			Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set DischDate=objEpisode.PADischDate
			Set:DischDate'="" DischDate=$zd(DischDate,3)
			Set AdmLoc = ""
			If $IsObject(objEpisode.PAAdmLocDr){
				Set AdmLoc=objEpisode.PAAdmLocDr.BTDesc
				Set AdmLoc2=objEpisode.PAAdmLocDr.BTDesc2
				Set:AdmLoc2'="" AdmLoc=AdmLoc2
			}
			Set AdmWard = ""
			If $IsObject(objEpisode.PAAdmWardDr){
				Set AdmWard=objEpisode.PAAdmWardDr.BTDesc
				Set AdmWard2=objEpisode.PAAdmWardDr.BTDesc2
				Set:AdmWard2'="" AdmWard=AdmWard2
			}
			
		    Set OprStatus=""
		    Set xScreenID = ""
			For {
				Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",xEpisodeDr,xScreenID))
				Quit:xScreenID=""
				Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
				Continue:'$IsObject(objScreen)
				Set xOprStatus=objScreen.CSStatus
				Set:OprStatus'=1 OprStatus=xOprStatus
			}
			Set OprStatus = $s(OprStatus=1:"确诊",OprStatus=2:"排除",1:"未处理")
		
			Set InfType    = obj.ARInfType	  //1疑似病例、2自报感染、3疑似社区感染
			Set InfTypeDesc = $s(InfType=1:"疑似病例",InfType=2:"自报感染",InfType=3:"疑似社区感染",1:"")  
			Set SusResult  = obj.ARSusResult   //疑似筛查结果
			Set SusDiagnos = obj.ARSusDiagnos  //疑似感染诊断/部位
			Set Status     = obj.ARStatus	   //状态（-1未处置、0排除、1确诊、2上报）
			Set StatusDesc = $s(Status=-1:"未处置",Status=0:"排除",Status=1:"确诊",Status=2:"自报",1:"")  
			Set DiagDate   = obj.ARDiagDate	  //确诊日期
			Set:DiagDate'="" DiagDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DiagDate)
			Set DiagNote   = obj.ARDiagNote	  //诊断依据、排除依据
			Set RstDate    = obj.ARRstDate	  //处置日期
			Set:RstDate'="" RstDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RstDate)
			Set RstTime    = obj.ARRstTime	  //处置时间
			Set:RstTime'="" RstTime=$zt(RstTime,1)
			Set (RstUserCode,RstUserDesc)="" //处置人
			If $IsObject( obj.ARRstUserDr) {
				Set RstUserCode =  obj.ARRstUserDr.BTCode
				Set RstUserDesc =  obj.ARRstUserDr.BTDesc
			}
			Set SuMatrix = obj.ARSuMatrix
			Set SuMatrix = $s(SuMatrix="TP":"感染疑似",SuMatrix="FP":"疑似非感染",SuMatrix="FN":"感染非疑似",1:"")  
			
			Set DateFrom =SttDate
		    Set DateTo =EndDate
		    If (AdmStatus="D") {
			    Set DateFrom =objEpisode.PAAdmDate
		   		Set DateTo =objEpisode.PADischDate
		    }
			Set InfRepList=..GetInfRepList(xEpisodeDr,aInfPos,DateFrom,DateTo)
			Continue:(aInfPos'="")&&(InfRepList="")
			
			Set DiagonsList ="",Diagons=""
			Set xDiagID=""
			For {
				Set xDiagID=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",xEpisodeDr,xDiagID))
				Quit:xDiagID=""
				
				Set obj=##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagID)
				Continue:'$isobject(obj)
				Set IsActive = obj.MRIsActive
				Continue:IsActive'=1
				
				Set SCode	 	= obj.MRSCode
				Set ICD10  		= obj.MRDiagICD10
				Set DiagDesc   	= obj.MRDiagDesc
				Set DiagTpCode  = obj.MRDiagTpCode
				Set DiagTpDesc 	= obj.MRDiagTpDesc
				Set DiagSource  = obj.MRDiagSource
				Continue:DiagSource'="E"
				Set Admission = obj.MRAdmission
				Set Diagnos=DiagDesc_"("_Admission_")"
				
				Set DiagonsList = DiagonsList_","_Diagnos
			}
			Set:DiagonsList'="" DiagonsList=$e(DiagonsList,2,$l(DiagonsList))
			
			
			Set LabList =""
			Set xActDate=""
			For {
				Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeDr,LabItemDr,xActDate))
				Quit:xActDate=""
				
				Set xResultID=""
				For {
					Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeDr,LabItemDr,xActDate,xResultID))
					Quit:xResultID=""
					
					Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
					Continue:'$isobject(obj)
					Set IsActive = obj.CCIsActive
					Continue:IsActive'=1
					
					Set Specimen	 	= obj.CCSpecimen
					Set Bacteria	 	= obj.CCBacteria
					Set LabList = LabList_","_Specimen_"("_Bacteria_")"_$zd(xActDate,3)
				}
			}
			Set:LabList'="" LabList=$e(LabList,2,$l(LabList))
			
			Set AdmDiagonsList =""
			Set xActDate=""
			For {
				Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeDr,DiagItemDr,xActDate))
				Quit:xActDate=""
				
				Set xResultID=""
				For {
					Set xResultID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",xEpisodeDr,DiagItemDr,xActDate,xResultID))
					Quit:xResultID=""
					
					Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xResultID)
					Continue:'$isobject(obj)
					Set IsActive = obj.CCIsActive
					Continue:IsActive'=1
					
					Set Result	 	= obj.CCResult
					Set AdmDiagonsList = AdmDiagonsList_","_Result
				}
			}
			Set:AdmDiagonsList'="" AdmDiagonsList=$e(AdmDiagonsList,2,$l(AdmDiagonsList))
			
			
			Set Data= $lb(xID,aModelDr,ModelCode,ModelDesc,xEpisodeDr,PapmiNo,MrNo,PatName,Sex,Age,AdmType,AdmDate,DischDate,AdmLoc,AdmWard,OprStatus,InfType,InfTypeDesc)
			Set Data= Data_$lb(SusResult,SusDiagnos,Status,StatusDesc,DiagDate,DiagNote,RstDate,RstTime,RstUserCode,RstUserDesc,InfRepList,DiagonsList,AdmDiagonsList,LabList,SuMatrix)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
	Quit $$$OK
}

ClassMethod QryAssessResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAssessResultExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAssessResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAssessResultExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2019-03-22
/// Description:  通过就诊查询本次就诊感染报告信息
/// Table：       DHCHAI.IR.INFReport
/// Input：       aEpisodeID: 就诊ID
/// Return：      成功：返回字符串，失败：空
/// w ##class(DHCHAI.AMS.AssessResultSrv).GetInfRepList("112617")
ClassMethod GetInfRepList(aEpisodeID As %String, aInfPosID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeID,aInfPosID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
		
    Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
    Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)

	Set InfRepList=""
	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,1,xID))
		Quit:xID=""
	
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Quit:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
		Set StatusCode= objRep.IRStatusDr.BTCode
		Continue:(StatusCode=4)  //4作废
		Set RepStatus = objRep.IRStatusDr.BTDesc
	    Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		// 感染诊断信息
		Set (InfPosDescs,InfSubDescs,InfDateDescs,InfLocDescs)=""
		Set IsReport=0
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			// 感染部位/感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosID = objDiags.IRInfPosDr.%Id()
				Continue:(aInfPosID'="")&&(InfPosID'=aInfPosID)
				Set InfPosDescs = InfPosDescs_","_objInfPos.BTDesc
			}
		    
			// 感染分类
			Set objInfSub = objDiags.IRInfSubDr
			If $IsObject(objInfSub){
				Set InfSubDescs = InfSubDescs_","_objInfSub.BTDesc
			}
			// 感染日期
			Set InfDate = objDiags.IRInfDate
			Continue:(aDateFrom'="")&(InfDate<aDateFrom)
			Continue:(aDateTo'="")&(InfDate>aDateTo)
			Set IsReport=1
			Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			Set:InfDate'="" InfDateDescs=InfDateDescs_","_InfDate
		}
		Continue:IsReport'=1
		Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
		Set:InfSubDescs'="" InfSubDescs = $e(InfSubDescs,2,$l(InfSubDescs))
		Set:InfDateDescs'="" InfDateDescs = $e(InfDateDescs,2,$l(InfDateDescs))
	    Set InfRepList =InfRepList_"^"_xID_" "_InfDateDescs_" "_InfPosDescs_" "_InfSubDescs_" "_RepStatus
	}
	
	Set:InfRepList'="" InfRepList=$e(InfRepList,2,$l(InfRepList))
	Set return=InfRepList
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-03-22
/// Description:  疑似病例筛查操作明细
/// Table：       DHCHAI.IR.CCScreening,DHCHAI.IR.CCScreenLog
/// Input:        aEpisodeID :就诊ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.AMS.AssessResultSrv","QryScreenLog","88586")
Query QryScreenLog(aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,Details:%String,EpisodeID:%String,Status:%String,ActDate:%String,ActTime:%String,UserID:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryScreenLogExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aEpisodeID="") $$$OK
	
	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
		Quit:'$IsObject(objScreen)
		Continue:'$IsObject(objScreen.CSItmScreenDr)
		Set ItmScreenID=objScreen.CSItmScreenDr.%Id()
		Set ItmScreen=objScreen.CSItmScreenDr.CCDesc
		Set ItmScreen2=objScreen.CSItmScreenDr.CCDesc2
		Set:ItmScreen2'="" ItmScreen=ItmScreen2
        Set OprStatus=objScreen.CSStatus
       
		Set ItmScreenTxt=objScreen.CSItmScreenTxt
		Set Details=ItmScreen
		If ((ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染"))&(ItmScreenTxt'=""){
			Set Details=##class(DHCHAI.IRS.CCScreenLogSrv).BacteriaItem(aEpisodeID,ItmScreenTxt)
	    }
		Set xSubID=""
		For {
			Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xID,"Log",xSubID))
			Quit:xSubID=""
			
			Set obj=##class(DHCHAI.IR.CCScreenLog).GetObjById(xID_"||"_xSubID)
			Continue:'$IsObject(obj)
			
			Set ActDate= obj.CSActDate
			Set:ActDate'="" ActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)

			Set ActTime= obj.CSActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			
			Set (UserID,UserDesc)=""
			If $IsObject(obj.CSActUserDr){
				Set UserID   = obj.CSActUserDr.%Id()
				Set UserDesc = obj.CSActUserDr.BTDesc
			}
			Set Status = obj.CSStatus //疑似状态（1确诊、2排除、0未处理）
			Set Status = $s(Status=1:"确诊",Status=2:"排除",1:"未处理") 

			Set Data=$lb(xID_"||"_xSubID,Details,aEpisodeID,Status,ActDate,ActTime,UserID,UserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	
	}
	Quit $$$OK
}

ClassMethod QryScreenLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryScreenLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenLogExecute ]
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
