/// 名称: DHCHAI.IRS.CCScreeningSrv
/// 描述: 疑似病例筛查相关服务
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRS.CCScreeningSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2023-04-13
/// Description:  疑似病例筛CLABSI患者信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
///               aHospIDs  : 医院代码 多值"^"分割
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
/// 			  aIsFinDel : 确诊1/排除2/确诊+排除为空
/// Return：      返回ROWSPEC 
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryCLABSIList","1|5|7","2023-01-01","2023-04-13","","")
Query QryCLABSIList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aIsFinDel As %String) As %Query(ROWSPEC = "AdmLocDesc:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String,EpisodeID:%String,IsNeedAttDesc:%String,IsSuspend:%String,ItmScreenDesc:%String,BTDiagnos:%String,ScreenStatus:%String,CSItmScreenTxt:%String,CSRstFromDate:%String,CSActDate:%String,CSActTime:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCLABSIListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aIsFinDel As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Kill ^TMP($zn,$j,"QryCLABSIList")
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xTime=0
		For {
			Set xTime=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate,xTime))
			Quit:xTime=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate,xTime,xID))
				Quit:xID=""
				
				Set objScreening=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
				Continue:'$IsObject(objScreening)
				Continue:'$IsObject(objScreening.CSEpisodeDr)
				Continue:'$IsObject(objScreening.CSItmScreenDr)
				Set ItmScreenDesc =objScreening.CSItmScreenDr.CCDesc 
				Continue:ItmScreenDesc'["CLABSI"
				Set EpisodeID=objScreening.CSEpisodeDr.%Id()
				Set ScreenStatus=objScreening.CSStatus
				
				Continue:(aIsFinDel=1)&(ScreenStatus'=1)
				Continue:(aIsFinDel=2)&(ScreenStatus'=2)
				Set ScreenStatus = $s(ScreenStatus=1:"确诊",ScreenStatus=2:"排除",1:"")
				Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeID)
				Continue:'$IsObject(objEpisode)
				Set EpisodeIDx=objEpisode.PAEpisodeIDx
				Set SCode = $p(EpisodeIDx,"||",1)
				Set VisitStatus=objEpisode.PAVisitStatus
				Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
				If VisitStatusInfo'="" {
					Set VisitStatus=$p(VisitStatusInfo,"^",2)
				}
				Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
				
				Set objAdmLoc=objEpisode.PAAdmWardDr
				Continue:'$IsObject(objAdmLoc)
				Set LocID=objAdmLoc.%Id()
				Set LocDesc=objAdmLoc.BTDesc
				
				Set LocDesc2=objAdmLoc.BTDesc2
				Set:LocDesc2'="" LocDesc=LocDesc2
				Continue:'$IsObject(objAdmLoc.BTHospDr)
				Set HospID=objAdmLoc.BTHospDr.%Id()
				Set HospDesc=objAdmLoc.BTHospDr.BTDesc
				Set HospDesc2=objAdmLoc.BTHospDr.BTDesc2
				Set:HospDesc2'="" HospDesc=HospDesc2
				Continue:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
				
				Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(EpisodeID)
				Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)
				Set IsSusInf=+$p(ScreenAttInfo,"^",2)
				Set IsSuspend=+$p(ScreenAttInfo,"^",3)
				Set IsNeedAttDesc=""
				Set:IsNeedAtt=1 IsNeedAttDesc="需关注病例"
				Set IsSuspend=$s(IsSuspend=0:"待处理",IsSuspend=1:"已确诊",IsSuspend=2:"已排除",IsSuspend=3:"已上报",1:"")
				Set BTDiagnos="" // 疑似诊断
				If ($IsObject(objScreening.CSInfSuPosDr)){
					Set BTDiagnos=objScreening.CSInfSuPosDr.BTDiagnos
				}
				Set CSRstFromDate = objScreening.CSRstFromDate
				Set:CSRstFromDate'="" CSRstFromDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CSRstFromDate)
				Set CSActDate   = objScreening.CSActDate
				Set:CSActDate'="" CSActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CSActDate)
			   	Set CSActTime   = objScreening.CSActTime
				Set:CSActTime'="" CSActTime=$zt(CSActTime,1)
				Set (ActUserCode,ActUserDesc) = ""
				If $IsObject(objScreening.CSActUserDr) {
					Set ActUserCode = objScreening.CSActUserDr.BTCode
					Set ActUserDesc = objScreening.CSActUserDr.BTDesc
				}
				Set CSItmScreenTxt = objScreening.CSItmScreenTxt
				
				Set Data=..BuildPaadmData(EpisodeID)
				Continue:Data=""
				
				//过滤重复就诊记录
				Continue:$d(^TMP($zn,$j,"QryCLABSIList",EpisodeID))
				Set ^TMP($zn,$j,"QryCLABSIList",EpisodeID)=""
				
				Set Data=Data_$lb(EpisodeID,IsNeedAttDesc,IsSuspend,ItmScreenDesc,BTDiagnos,ScreenStatus,CSItmScreenTxt,CSRstFromDate,CSActDate,CSActTime,ActUserDesc)
     			Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				
			}
		}
	}
 	Kill ^TMP($zn,$j,"QryCLABSIList")
	Quit $$$OK
}

ClassMethod QryCLABSIListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCLABSIListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCLABSIListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCLABSIListExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-09-25
/// Description:  取筛患者确诊状态 确诊1、其他0
/// Table：       DHCHAI.IR.CCScreening
/// Input：       aEpisodeID    : 就诊号///               
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetEpisodeStatus(95)
ClassMethod GetEpisodeStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="0"
	Quit:(aEpisodeID="") return
	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		Quit:return="1"
		Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
		Quit:'$IsObject(objScreen)
		Set OprStatus=objScreen.CSStatus
		Set:OprStatus=1 return="1"
	}
	Quit return
}

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	Quit:(AdmType'="I")&&(AdmType'="EP") return
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set return = $lb(AdmLocDesc,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDate,AdmTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDate,DischTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  取筛查项目处置状态（1已处置、0未处置）及操作状态（确诊1、排除2、未操作0）
/// Table：       DHCHAI.IR.CCScreening
/// Input：       aEpisodeID    : 就诊号
///               aItmScreenID  : 疑似筛查项目
///               aItmScreenTxt : 疑似筛查文本
///               aRstToDate    : 疑似项目结束日期
/// Return：      返回String    $p(return,"^",1)=0疑似未处理、1疑似已处理
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetStatusInfo(95,1,"金黄色葡萄球菌","2017-08-10")
ClassMethod GetStatusInfo(aEpisodeID As %String, aItmScreenID As %String, aItmScreenTxt As %String, aRstFromDate As %String, aRstToDate As %String) As %String
{
	New (aEpisodeID,aItmScreenID,aItmScreenTxt,aRstFromDate,aRstToDate)
	Set return="0^0"
	Quit:(aEpisodeID="")||(aItmScreenID="") return
	//Set:aRstFromDate["-" aRstFromDate=$zdh(aRstFromDate,3)
	//Set:aRstToDate["-" aRstToDate=$zdh(aRstToDate,3)
	Set aRstFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aRstFromDate)
	Set aRstToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aRstToDate)

	Set ID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,aItmScreenID," "_$zcvt(aItmScreenTxt,"U"),""),-1)
	Quit:ID="" return
	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(ID)
	Quit:'$IsObject(objScreen) return
	Set OprStatus=objScreen.CSStatus
	Set RstFromDate=objScreen.CSRstFromDate
	Set RstToDate=objScreen.CSRstToDate
	Set $p(return,"^",1)=$s(OprStatus=1:1,1:0)
	If (aRstFromDate'="")&(aRstToDate'="") {
		If (aRstFromDate<RstFromDate)||(aRstToDate>RstToDate){
			Set OprStatus=$s(OprStatus=1:-1,OprStatus=2:-2,1:0)
		}
	}
	Set $p(return,"^",2)=OprStatus
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  确认/排除疑似筛查项目
/// Table：       DHCHAI.IR.CCScreening
/// Input：       aEpisodeID    : 就诊号
///               aOperCode     : 操作代码(1确诊、2排除)
///               aScreenInfo     : 疑似处置信息（疑似筛查项目^疑似筛查文本^疑似项目结束日期）
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).SaveScreenOpera("569","13^^64504^64504^^","1","9")
ClassMethod SaveScreenOpera(aEpisodeID As %String, aScreenInfo As %String, aOperCode As %String, aOperUser As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID,aScreenInfo,aOperCode,aOperUser)
	Set return=0
	Quit:(aEpisodeID="")||(aScreenInfo="")||(aOperCode="") return
	
	Set ItmScreenID  = $p(aScreenInfo,"^",1)   //疑似筛查项目
	Set ItmScreenTxt = $p(aScreenInfo,"^",2)   //疑似筛查文本
	Set RstFromDate  = $p(aScreenInfo,"^",3)   //疑似开始日期
	Set RstToDate    = $p(aScreenInfo,"^",4)   //疑似结束日期
	Set InfSuPosDr   = $p(aScreenInfo,"^",5)   //疑似诊断
	Set Opinion      = $p(aScreenInfo,"^",6)   //疑似处置意见
	Quit:(ItmScreenID="")||(RstToDate="") return
	
	Set ID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,ItmScreenID," "_$zcvt(ItmScreenTxt,"U"),0))
	
	Set InputStr=ID
	Set InputStr=InputStr_"^"_aEpisodeID
	Set InputStr=InputStr_"^"_ItmScreenID
	Set InputStr=InputStr_"^"_ItmScreenTxt
	Set InputStr=InputStr_"^"_aOperCode     //操作/状态（1确认、2排除）
	Set InputStr=InputStr_"^"_InfSuPosDr
	Set InputStr=InputStr_"^"_RstFromDate
	Set InputStr=InputStr_"^"_RstToDate
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_aOperUser
	Set InputStr=InputStr_"^"_Opinion
	Set return=##class(DHCHAI.IR.CCScreening).Update(InputStr)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-01-12
/// Description:  全部确认/全部排除疑似筛查项目
/// Table：       DHCHAI.IR.CCScreening
/// Input：       aEpisodeDr    : 就诊号
///               aOperCode     : 操作代码(1确诊、2排除)
///               aOperUser     : 操作人
///               aOpinion      : 处置意见
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).ScreenRstOperAll(5948,1,1,"测试")
ClassMethod ScreenRstOperAll(aEpisodeDr As %String, aOperCode As %String, aOperUser As %String, aOpinion As %String) As %String
{
	New (aEpisodeDr,aOperCode,aOperUser,aOpinion)
	Set return=0,ErrCnt=0
	Quit:aEpisodeDr="" return
	Quit:(aOperCode'=1)&(aOperCode'=2) return  //1全部确诊、2全部排除
	
	//疑似病例筛查 处置动作
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.CCScreeningSrv:QryScreenResult")
  	Set sc=rs.Execute(aEpisodeDr)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
	    Set RstStatus    = rs.Data("RstStatus")
	    Set OprStatus    = rs.Data("OprStatus")  //0未操作、1确诊、-1部分确诊、2排除、-2部分排除
	    Set ItmScreenID  = rs.Data("ItmScreenID")   //疑似筛查项目
	    Set ItmScreenTxt = rs.Data("ItmScreenTxt")  //疑似筛查文本
	    Set RstFromDate  = rs.Data("RstFromDate")   //疑似开始日期
	    Set RstToDate    = rs.Data("RstToDate")     //疑似结束日期
	    
	    //非感染相关指标无需操作
	    Continue:RstStatus'=1
	    
	    //操作代码判断已处理状态
	    If aOperCode=1 {
		    Continue:(OprStatus=1)  //确诊记录不再重复确诊
		} ElseIf aOperCode=2 {
		    Continue:OprStatus=2  //排除记录不再重复排除
		}
		
	    Set ScreenInfo=""
		Set $p(ScreenInfo,"^",1)=ItmScreenID
		Set $p(ScreenInfo,"^",2)=ItmScreenTxt
		Set $p(ScreenInfo,"^",3)=RstFromDate
		Set $p(ScreenInfo,"^",4)=RstToDate
		Set $p(ScreenInfo,"^",5)=""                 //疑似诊断
		Set $p(ScreenInfo,"^",6)=aOpinion           //疑似处置意见
		Set flg=##class(DHCHAI.IRS.CCScreeningSrv).SaveScreenOpera(aEpisodeDr,ScreenInfo,aOperCode,aOperUser)
		If (+flg)<1 {
			Set ErrCnt=ErrCnt+1 //错误记录数
		}
	}
	
	//处理疑似状态及处置状态（待处理、已确诊、已排除、已上报）
	Set flg=##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlag(aEpisodeDr)
	If (+flg)<1 {
		Set ErrCnt=ErrCnt+1 //错误记录数
	}
	Set SusInfInfo=flg
	
	If ErrCnt>0 {
		Set return=-1
	} Else {
		Set return=SusInfInfo  //ScreenAttID^IsSusInf^SuspendCode^SuspendDesc(ID^是否感染^处置代码^处置描述)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  疑似病例筛查科室列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院、3已处理、4需关注）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aHospIDs  : 医院代码 多值"^"分割
///               aViewFlag : 按科室/病区分组（1科室、2病区）
/// 			  aIsMessage: 已发消息
/// 			  aIsFollow : 持续关注
/// 			  aIsFinDel : 确诊1/排除2/确诊+排除为空
///               aIsAttFlg : 待处理1/需关注2/待处理+需关注3
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryScreenLocList","3","2018-01-03","2018-01-06","1|2|3|4|5|6","2","","","")
Query QryScreenLocList(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aIsMessage As %String = "", aIsFollow As %String = "", aIsFinDel As %String = "", aIsAttFlg As %String = "", aIsFinflag As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,HospID:%String,HospDesc:%String,InPatientCnt:%String,ScreeningCnt:%String,ScreenLogCnt:%String,ScreenAttCnt:%String,LocGrpUser:%String,ConfirmCnt:%String") [ SqlProc ]
{
}

ClassMethod QryScreenLocListExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aIsMessage As %String = "", aIsFollow As %String = "", aIsFinDel As %String = "", aIsAttFlg As %String = "", aIsFinflag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aTypeFlag'=1)&((aDateFrom="")||(aDateTo="")) $$$OK
 	
 	Kill ^TMP($zn,$j)
	If aTypeFlag=1 {
		//1在院病人
		Quit:aIsAttFlg="" $$$OK
		
		Set xDays=-1
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
					
					Set EpisodeID=xID
					Do BuildDataToScreenLoc(EpisodeID,aHospIDs,aViewFlag)
				}
			}
		}
	} ElseIf aTypeFlag=2 {
		//2出院病人
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK  //限制查询日期范围15天 31
		Quit:aIsAttFlg="" $$$OK
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime,xID))
						Quit:xID=""
						
						Set EpisodeID=xID
						Do BuildDataToScreenLoc(EpisodeID,aHospIDs,aViewFlag)
					}
				}
			}
		}
	} ElseIf aTypeFlag=3 {
		//3已处理病例
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK  //限制查询日期范围15天 31
		Quit:aIsFinDel="" $$$OK  //未选择确诊+排除
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
			For {
				Set xTime=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate,xTime))
				Quit:xTime=""
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate,xTime,xID))
					Quit:xID=""
					
					Set objScreening=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
					Continue:'$IsObject(objScreening)
					Continue:'$IsObject(objScreening.CSEpisodeDr)
					Set EpisodeID=objScreening.CSEpisodeDr.%Id()
					Set ScreenStatus=objScreening.CSStatus
					Continue:(aIsFinDel=1)&(ScreenStatus'=1)
					Continue:(aIsFinDel=2)&(ScreenStatus'=2)
					Continue:(aIsFinDel=3)&((ScreenStatus'=1)&&(ScreenStatus'=2))
					
					//过滤重复就诊记录
					Continue:$d(^TMP($zn,$j,"ScreenLoc-Adm",EpisodeID))
					Set ^TMP($zn,$j,"ScreenLoc-Adm",EpisodeID)=""
					
					Do BuildDataToScreenLoc(EpisodeID,aHospIDs,aViewFlag)
				}
			}
		}
	} ElseIf aTypeFlag=4 {
		//4需关注病例
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK  //限制查询日期范围15天 31
		
		If (aIsFollow=1){  // 持续关注
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCScreenAttI("IndexAttDateTime",xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
				For {
					Set xTime=$o(^DHCHAI.IR.CCScreenAttI("IndexAttDateTime",xDate,xTime))
					Quit:xTime=""
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.IR.CCScreenAttI("IndexAttDateTime",xDate,xTime,xID))
						Quit:xID=""
						
						Set objScreenAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(xID)
						Continue:'$IsObject(objScreenAtt)
						Continue:'$IsObject(objScreenAtt.CSEpisodeDr)
						Continue:objScreenAtt.CSIsNeedAtt'=1
						Set EpisodeID=objScreenAtt.CSEpisodeDr.%Id()
						
						//过滤重复就诊记录
						Continue:$d(^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID))
						Set ^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID)=""
						
						Do BuildDataToScreenLoc(EpisodeID,aHospIDs,aViewFlag)
					}
				}
			}
		} 
		If (aIsMessage=1) {  // 发消息的患者查询  消息类型（1院感、2临床）
		 	For xDate=aDateFrom:1:aDateTo {
				Set xTime = ""
				For {
					Set xTime = $o(^DHCHAI.IR.CCMessageI("IndexTypeDateTime",1,xDate,xTime))
					Quit:xTime=""
				 	Set xID = ""
					For {
						Set xID = $o(^DHCHAI.IR.CCMessageI("IndexTypeDateTime",1,xDate,xTime,xID))
						Quit:xID=""
						Set obj = ##class(DHCHAI.IR.CCMessage).GetObjById(xID)
						Continue:'$Isobject(obj)
						Set objEpisodeDr=obj.CSEpisodeDr
						Continue:'$Isobject(objEpisodeDr)
						Set EpisodeID=objEpisodeDr.%Id()
						
						//过滤重复就诊记录
						Continue:$d(^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID))
						Set ^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID)=""
						
						Do BuildDataToScreenLoc(EpisodeID,aHospIDs,aViewFlag)
					}
				}
		 	}
		}
	} Else {}
	
	Set xHospID=0
	For {
		Set xHospID=$o(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID))
		Quit:xHospID=""
		
		Set xLocID=0
		For {
			Set xLocID=$o(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID))
			Quit:xLocID=""
			
			Set tLoc=$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID))
			Continue:tLoc=""
			Set HospDesc=$listget(tLoc,1)
			Set LocDesc=$listget(tLoc,2)
			Set InPatientCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"InPatientCnt"))  //住院病人
			Set ScreeningCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreeningCnt"))  //疑似病例
			Set ScreenLogCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreenLogCnt"))  //处置病例
			Set ScreenAttCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreenAttCnt"))  //需关注病例
			Set ConfirmCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ConfirmCnt"))      //疑似确诊病例
			Set LocGrpUser =##class(DHCHAI.IR.CCLocGroup).GetLocGrpByLocType(xLocID,"疑似筛查工作分组")
			Set:LocGrpUser'="" LocGrpUser="[分组] "_LocGrpUser
			Continue:(aTypeFlag=3)&(ScreenLogCnt<1)  //修改主页确诊未上报bug 没有已处理病例
			Set Data=$lb(xLocID,LocDesc,xHospID,HospDesc,InPatientCnt,ScreeningCnt,ScreenLogCnt,ScreenAttCnt,LocGrpUser,ConfirmCnt)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildDataToScreenLoc(aEpisodeID,aHospIDs,aViewFlag)
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode)
	Set EpisodeIDx=objEpisode.PAEpisodeIDx
	Set infRep=0
	If (aIsFinflag'="")&&(aIsFinflag'=0){
		Set PaadmId=objEpisode.%Id()
		Set repType=""
		For {
			Quit:'$d(^DHCHAI.IR.INFReportI("IndexPaadmType",PaadmId))
			Set repType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",PaadmId,repType))
			Quit:repType=""
			Set infRepId=""
			For{
				Set infRepId=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",PaadmId,repType,infRepId))
				Quit:infRepId=""
				Quit:infRep=1
				Set objinfRep=##class(DHCHAI.IR.INFReport).GetObjById(infRepId)
	            Quit:'$IsObject(objinfRep)
	            Quit:'$IsObject(objinfRep.IRStatusDr)
	            Set StatusCode=objinfRep.IRStatusDr.BTCode
	            Set:(StatusCode=2)||(StatusCode=3)||(StatusCode=6) infRep=1
			}
			
	    }
	    Quit:infRep=1
	}
	
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=objEpisode.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	
	If aViewFlag=1 {
		Set objAdmLoc=objEpisode.PAAdmLocDr
	} Else {
		Set objAdmLoc=objEpisode.PAAdmWardDr
		//处理虚拟病区的问题
		If $IsObject(objEpisode.PAAdmBedDr){
			If $IsObject(objEpisode.PAAdmBedDr.BTXLocDr){
				Set objAdmLoc=objEpisode.PAAdmBedDr.BTXLocDr
			}
		}
	}
	Quit:'$IsObject(objAdmLoc)
	Set LocID=objAdmLoc.%Id()
	Set LocDesc=objAdmLoc.BTDesc
	Set LocDesc2=objAdmLoc.BTDesc2
	Set:LocDesc2'="" LocDesc=LocDesc2
	Quit:'$IsObject(objAdmLoc.BTHospDr)
	Set HospID=objAdmLoc.BTHospDr.%Id()
	Set HospDesc=objAdmLoc.BTHospDr.BTDesc
	Set HospDesc2=objAdmLoc.BTHospDr.BTDesc2
	Set:HospDesc2'="" HospDesc=HospDesc2
	Quit:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
	
	Set ^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID)=$lb(HospDesc,LocDesc)       //科室信息
	Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"InPatientCnt"))      //住院病例
	
	If aTypeFlag=1 {
		//在院
		Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
		Set AttStatus=+$p(ScreenAttInfo,"^",1)
		Quit:(aIsAttFlg=1)&(AttStatus'=1)
		Quit:(aIsAttFlg=2)&(AttStatus'=0)
		Quit:(aIsAttFlg=3)&((AttStatus'=1)&&(AttStatus'=0))
	} ElseIf aTypeFlag=2 {
		//出院
		Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
		Set AttStatus=+$p(ScreenAttInfo,"^",1)
		Quit:(aIsAttFlg=1)&(AttStatus'=1)
		Quit:(aIsAttFlg=2)&(AttStatus'=0)
		Quit:(aIsAttFlg=3)&((AttStatus'=1)&&(AttStatus'=0))
	} ElseIf aTypeFlag=3 {
		//已处理
	} ElseIf aTypeFlag=4 {
		//需关注
	} Else {}
	
	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)
	Quit:(IsNeedAtt'=1)&(IsSusInf'=1)
	If IsSusInf=1 {
		If IsSuspend=0 {
			//疑似待处理病例
			Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreeningCnt"))
		} Else {
			//疑似处置病例
			Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreenLogCnt"))
			If IsSuspend=1 {
				//疑似确诊病例
				Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ConfirmCnt"))
			}
		}
	}
	If IsNeedAtt=1 {  //持续关注
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreenAttCnt"))
	}
	Quit
}

ClassMethod QryScreenLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryScreenLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenLocListExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-04-02
/// Description:  疑似病例筛查病人列表床位图
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院、3已处理、4需关注）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocID    : 科室ID
/// 			  aIsMessage: 已发消息
/// 			  aIsFollow : 持续关注
/// 			  aIsFinDel : 确诊1/排除2/确诊+排除为空
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryScreenPatToBed","3","2018-01-18","2018-01-19","104","1","1","3")
Query QryScreenPatToBed(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aIsMessage As %String = "", aIsFollow As %String = "", aIsFinDel As %String = "", aIsAttFlg As %String = "") As %Query(ROWSPEC = "ind:%String,EpisodeDr:%String,BedDr:%String") [ SqlProc ]
{
}

ClassMethod QryScreenPatToBedExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aIsMessage As %String = "", aIsFollow As %String = "", aIsFinDel As %String = "", aIsAttFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aTypeFlag'=1)&((aDateFrom="")||(aDateTo="")) $$$OK
 	
 	If aTypeFlag=1 {
		//1在院病人
		Quit:aIsAttFlg="" $$$OK
		
		Set xDays=-1
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
					
					Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xID)
					Set AttStatus=+$p(ScreenAttInfo,"^",1)
					Continue:(aIsAttFlg=1)&(AttStatus'=1)
					Continue:(aIsAttFlg=2)&(AttStatus'=0)
					Continue:(aIsAttFlg=3)&((AttStatus'=1)&&(AttStatus'=0))
					
					Set EpisodeDr=xID
					Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
					Continue:'$IsObject(objEpisode)
					Set EpisodeIDx=objEpisode.PAEpisodeIDx
					Set SCode = $p(EpisodeIDx,"||",1)
					Set VisitStatus=objEpisode.PAVisitStatus
					Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
					If VisitStatusInfo'="" {
						Set VisitStatus=$p(VisitStatusInfo,"^",2)
					}
					Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
					If VisitStatusInfo'="" {
						Set VisitStatus=$p(VisitStatusInfo,"^",3)
					} Else {
						Set VisitStatus=$s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="P":"预住院",VisitStatus="C":"退院",VisitStatus="U":"作废",1:"其他")
					}
					
					Continue:'$IsObject(objEpisode.PAAdmLocDr)
					Continue:'$IsObject(objEpisode.PAAdmWardDr)
					Set objAdmLoc=objEpisode.PAAdmLocDr
					Set LocID=objAdmLoc.%Id()
					Set LocDesc=objAdmLoc.BTDesc
					Set LocDesc2=objAdmLoc.BTDesc2
					Set:LocDesc2'="" LocDesc=LocDesc2
					Set objAdmWard=objEpisode.PAAdmWardDr
					//处理虚拟病区的问题
					If $IsObject(objEpisode.PAAdmBedDr){
						If $IsObject(objEpisode.PAAdmBedDr.BTXLocDr){
							Set objAdmWard=objEpisode.PAAdmBedDr.BTXLocDr
						}
					}
					Set WardID=objAdmWard.%Id()
					Set WardDesc=objAdmWard.BTDesc
					Set WardDesc2=objAdmWard.BTDesc2
					Set:WardDesc2'="" WardDesc=WardDesc2
					Continue:(aLocID'=LocID)&(aLocID'=WardID)  //过滤科室、病区
					
					//程序处理以当前科室为准，不以疑似、处置、需关注时点的科室为准
					If aLocID=LocID {
						Set ViewType="E"  //按科室显示
						Set CurrLocID=LocID
						Set CurrLocDesc=LocDesc
					} Else {
						Set ViewType="W"  //按按病区显示
						Set CurrLocID=WardID
						Set CurrLocDesc=WardDesc
					}
					
					Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(EpisodeDr)
					Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
					Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
					Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
					If aTypeFlag=1 {
						//在院（疑似）病例
						Continue:IsSusInf'=1  //非疑似病例不显示
						Continue:(IsSuspend=2)||(IsSuspend=3)  //已排除、已上报病例不显示
					} ElseIf aTypeFlag=2 {
						//出院（疑似）病例
						Continue:IsSusInf'=1  //非疑似病例不显示
						Continue:(IsSuspend=2)||(IsSuspend=3)  //已排除、已上报病例不显示
					} ElseIf aTypeFlag=3 {
						//已处理病例
						//Quit:(aIsFinDel'="")&&(IsSuspend'=+aIsFinDel)
					} ElseIf aTypeFlag=4 {
						//需关注病例
						//Quit:(IsNeedAtt'=1)&&(aIsMessage'=1)
					} Else {
						Continue  //其他
					}
					Set SuspendCode=IsSuspend
					Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已确诊",SuspendCode=2:"已排除",SuspendCode=3:"已上报",1:"错误")
					
					Set IsNeedMsg=""
					If (IsNeedAtt=1){
						Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",EpisodeDr,0))
						Continue:AttID=""
						Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
						Continue:'$IsObject(objAtt)
						Set IsNeedMsg=objAtt.CSIsNeedMsg
					}
					Set (BedDr,CurrBed)=""           //床位
					If $IsObject(objEpisode.PAAdmBedDr){
						Set BedDr=objEpisode.PAAdmBedDr.%Id()
						Set CurrBed=objEpisode.PAAdmBedDr.BTDesc
						Set:CurrBed'["床" CurrBed=CurrBed_"床"
					}
					
					Set Data=$lb(ind,EpisodeDr,BedDr)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
 	}
	Quit $$$OK
}

ClassMethod QryScreenPatToBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenPatToBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryScreenPatToBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenPatToBedExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  疑似病例筛查病人列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院、3已处理、4需关注）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocID    : 科室ID
/// 			  aIsMessage: 已发消息
/// 			  aIsFollow : 持续关注
/// 			  aIsFinDel : 确诊1/排除2/确诊+排除为空
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryScreenPatList","3","2018-01-18","2018-01-19","104","1","1","3")
Query QryScreenPatList(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aIsMessage As %String = "", aIsFollow As %String = "", aIsFinDel As %String = "", aIsAttFlg As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,CurrLoc:%String,CurrBed:%String,VisitStatus:%String,InHospDate:%String,InHospLocID:%String,InHospLocDesc:%String,InLocDate:%String,CurrLocID:%String,CurrLocDesc:%String,FromLocID:%String,FromLocDesc:%String,IsNeedAtt:%String,OutHospDate:%String,SuspendCode:%String,SuspendDesc:%String,AdmDocCode:%String,AdmDocDesc:%String,IsNeedMsg:%String,IsMessage:%String") [ SqlProc ]
{
}

ClassMethod QryScreenPatListExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aIsMessage As %String = "", aIsFollow As %String = "", aIsFinDel As %String = "", aIsAttFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aTypeFlag'=1)&((aDateFrom="")||(aDateTo="")) $$$OK
 	
 	Kill ^TMP($zn,$j)
	If aTypeFlag=1 {
		//1在院病人
		Quit:aIsAttFlg="" $$$OK
		
		Set xDays=-1
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
					
					Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xID)
					Set AttStatus=+$p(ScreenAttInfo,"^",1)
					Continue:(aIsAttFlg=1)&(AttStatus'=1)
					Continue:(aIsAttFlg=2)&(AttStatus'=0)
					Continue:(aIsAttFlg=3)&((AttStatus'=1)&&(AttStatus'=0))
					
					Set EpisodeID=xID
					Do BuildDataToScreenPat(EpisodeID,aLocID,aTypeFlag)
				}
			}
		}
	} ElseIf aTypeFlag=2 {
		//2出院病人
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK  //限制查询日期范围15天 31
		Quit:aIsAttFlg="" $$$OK
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=0
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime,xID))
						Quit:xID=""
						
						Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xID)
						Set AttStatus=+$p(ScreenAttInfo,"^",1)
						Continue:(aIsAttFlg=1)&(AttStatus'=1)
						Continue:(aIsAttFlg=2)&(AttStatus'=0)
						Continue:(aIsAttFlg=3)&((AttStatus'=1)&&(AttStatus'=0))
						
						Set EpisodeID=xID
						Do BuildDataToScreenPat(EpisodeID,aLocID,aTypeFlag)
					}
				}
			}
		}
	} ElseIf aTypeFlag=3 {
		//3已处理病例
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK  //限制查询日期范围15天 31
		Quit:aIsFinDel="" $$$OK
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=0
			For {
				Set xTime=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate,xTime))
				Quit:xTime=""
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.IR.CCScreeningI("IndexActDateTime",xDate,xTime,xID))
					Quit:xID=""
					
					Set objScreening=##class(DHCHAI.IR.CCScreening).GetObjById(xID)
					Continue:'$IsObject(objScreening)
					Continue:'$IsObject(objScreening.CSEpisodeDr)
					Set EpisodeID=objScreening.CSEpisodeDr.%Id()
					Set ScreenStatus=objScreening.CSStatus
					Continue:(aIsFinDel=1)&(ScreenStatus'=1)
					Continue:(aIsFinDel=2)&(ScreenStatus'=2)
					Continue:(aIsFinDel=3)&((ScreenStatus'=1)&&(ScreenStatus'=2))
					
					//过滤重复就诊记录
					Continue:$d(^TMP($zn,$j,"ScreenLoc-Adm",EpisodeID))
					Set ^TMP($zn,$j,"ScreenLoc-Adm",EpisodeID)=""
					
					Do BuildDataToScreenPat(EpisodeID,aLocID,aTypeFlag)
				}
			}
		}
	} ElseIf aTypeFlag=4 {
		//4需关注病例
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK //限制查询日期范围15天 31
		
		If (aIsFollow=1){  // 持续关注
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.CCScreenAttI("IndexAttDateTime",xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=0
				For {
					Set xTime=$o(^DHCHAI.IR.CCScreenAttI("IndexAttDateTime",xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.IR.CCScreenAttI("IndexAttDateTime",xDate,xTime,xID))
						Quit:xID=""
						
						Set objScreenAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(xID)
						Continue:'$IsObject(objScreenAtt)
						Continue:'$IsObject(objScreenAtt.CSEpisodeDr)
						Continue:objScreenAtt.CSIsNeedAtt'=1
						Set EpisodeID=objScreenAtt.CSEpisodeDr.%Id()
						
						//过滤重复就诊记录
						Continue:$d(^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID))
						Set ^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID)=""
						
						Do BuildDataToScreenPat(EpisodeID,aLocID,aTypeFlag)
					}
				}
			}
		}
		If (aIsMessage=1) {  // 发消息的患者查询  消息类型（1院感、2临床）
		 	For xDate=aDateFrom:1:aDateTo {
				Set xTime = ""
				For {
					Set xTime = $o(^DHCHAI.IR.CCMessageI("IndexTypeDateTime",1,xDate,xTime))
					Quit:xTime=""
				 	Set xID = ""
					For {
						Set xID = $o(^DHCHAI.IR.CCMessageI("IndexTypeDateTime",1,xDate,xTime,xID))
						Quit:xID=""
						
						Set obj = ##class(DHCHAI.IR.CCMessage).GetObjById(xID)
						Continue:'$Isobject(obj)
						Set objEpisodeDr=obj.CSEpisodeDr
						Continue:'$Isobject(objEpisodeDr)
						Set EpisodeID=objEpisodeDr.%Id()
						
						//过滤重复就诊记录
						Continue:$d(^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID))
						Set ^TMP($zn,$j,"ScreenAtt-Adm",EpisodeID)=""
					
						Do BuildDataToScreenPat(EpisodeID,aLocID,aTypeFlag)
					}
				}
		 	}
		}
	} Else {}
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildDataToScreenPat(aEpisodeID,aLocID,aTypeFlag)
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode)
	Set EpisodeIDx=objEpisode.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=objEpisode.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",3)
	} Else {
		Set VisitStatus=$s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="P":"预住院",VisitStatus="C":"退院",VisitStatus="U":"作废",1:"其他")
	}
	
	Quit:'$IsObject(objEpisode.PAAdmLocDr)
	Quit:'$IsObject(objEpisode.PAAdmWardDr)
	Set objAdmLoc=objEpisode.PAAdmLocDr
	Set LocID=objAdmLoc.%Id()
	Set LocDesc=objAdmLoc.BTDesc
	Set LocDesc2=objAdmLoc.BTDesc2
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set objAdmWard=objEpisode.PAAdmWardDr
	//处理虚拟病区的问题
	If $IsObject(objEpisode.PAAdmBedDr){
		If $IsObject(objEpisode.PAAdmBedDr.BTXLocDr){
			Set objAdmWard=objEpisode.PAAdmBedDr.BTXLocDr
		}
	}
	Set WardID=objAdmWard.%Id()
	Set WardDesc=objAdmWard.BTDesc
	Set WardDesc2=objAdmWard.BTDesc2
	Set:WardDesc2'="" WardDesc=WardDesc2
	Quit:(aLocID'=LocID)&(aLocID'=WardID)  //过滤科室、病区
	
	//程序处理以当前科室为准，不以疑似、处置、需关注时点的科室为准
	If aLocID=LocID {
		Set ViewType="E"  //按科室显示
		Set CurrLocID=LocID
		Set CurrLocDesc=LocDesc
	} Else {
		Set ViewType="W"  //按按病区显示
		Set CurrLocID=WardID
		Set CurrLocDesc=WardDesc
	}
	
	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
	If aTypeFlag=1 {
		//在院（疑似）病例
		Quit:IsSusInf'=1  //非疑似病例不显示
		Quit:(IsSuspend=2)||(IsSuspend=3)  //已排除、已上报病例不显示
	} ElseIf aTypeFlag=2 {
		//出院（疑似）病例
		Quit:IsSusInf'=1  //非疑似病例不显示
		Quit:(IsSuspend=2)||(IsSuspend=3)  //已排除、已上报病例不显示
	} ElseIf aTypeFlag=3 {
		//已处理病例
		//Quit:(aIsFinDel'="")&&(IsSuspend'=+aIsFinDel)
	} ElseIf aTypeFlag=4 {
		//需关注病例
		//Quit:(IsNeedAtt'=1)&&(aIsMessage'=1)
	} Else {
		Quit  //其他
	}
	Set SuspendCode=IsSuspend
	Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已确诊",SuspendCode=2:"已排除",SuspendCode=3:"已上报",1:"错误")
	
	Set IsNeedMsg=""
	If (IsNeedAtt=1){
		Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
		Quit:AttID="" return
		Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
		Quit:'$IsObject(objAtt) return
		Set IsNeedMsg=objAtt.CSIsNeedMsg
	}
	
	Set PapmiNo=objEpisode.PAPapmiNo     //登记号
	Set MrNo=objEpisode.PAMrNo           //病案号
	Set PatName=objEpisode.PAPatName     //姓名
	Set Sex=objEpisode.PASex             //性别
	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Birthday=objEpisode.PABirthday   //出生日期
	Set Age=objEpisode.PAAge             //年龄
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set AdmDate=objEpisode.PAAdmDate     //就诊日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objEpisode.PAAdmTime     //就诊时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set DischDate=objEpisode.PADischDate //出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set OutHospDate = ""
	If DischDate'=""{
		Set OutHospDate = DischDate
	}
	Set DischTime=objEpisode.PADischTime //出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set (CurrBedDr,CurrBed)=""           //床位
	If $IsObject(objEpisode.PAAdmBedDr){
		Set CurrBedDr=objEpisode.PAAdmBedDr.%Id()
		Set CurrBed=objEpisode.PAAdmBedDr.BTDesc
		Set:CurrBed'["床" CurrBed=CurrBed_"床"
	}
	Set PAAdmDoc=objEpisode.PAAdmDoc
	Set AdmDocCode=$p(PAAdmDoc,"|",2)  //医生工号
	Set AdmDocDesc=$p(PAAdmDoc,"|",3)  //医生姓名
	
	//入院日期、入院科室、入科日期、当前科室、入科来源信息
	Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(aEpisodeID,ViewType)
	Quit:TransLocInfo=""
	Set InHospDate=$p(TransLocInfo,"^",1)
	Set InHospLocID=$p(TransLocInfo,"^",2)
	Set InHospLocDesc=$p(TransLocInfo,"^",3)
	Set InLocDate=$p(TransLocInfo,"^",4)
	Set CurrLocID=$p(TransLocInfo,"^",5)
	Set CurrLocDesc=$p(TransLocInfo,"^",6)
	Set FromLocID=$p(TransLocInfo,"^",7)
	Set FromLocDesc=$p(TransLocInfo,"^",8)
	
	Set:InHospDate'="" InHospDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InHospDate)
	Set:InLocDate'="" InLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InLocDate)
	// 判断患者是否有消息记录
	Set IsMessage=0
	Set:$d(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID)) IsMessage=1
 	//疑似病例筛查病人列表查询
 	//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、床号、入院日期、入院科室、入科日期、入科来源、需关注病例、出院日期
 	Set Data=$lb(EpisodeID,PapmiNo,PatName,Sex,Age,CurrLocDesc,CurrBed,VisitStatus,InHospDate,InHospLocID,InHospLocDesc,InLocDate,CurrLocID,CurrLocDesc,FromLocID,FromLocDesc,IsNeedAtt,OutHospDate,SuspendCode,SuspendDesc,AdmDocCode,AdmDocDesc,IsNeedMsg,IsMessage)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	Quit
}

ClassMethod QryScreenPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryScreenPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenPatListExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-06-26
/// Description:  根据就诊号获取疑似筛查病人信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aEpisodeID : aEpisodeID
/// w ##class("DHCHAI.IRS.CCScreeningSrv").GetCCScreenByEpisodeID("5581")
ClassMethod GetCCScreenByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set EpisodeIDx=objEpisode.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=objEpisode.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") return //预住院、退院、作废
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",3)
	} Else {
		Set VisitStatus=$s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="P":"预住院",VisitStatus="C":"退院",VisitStatus="U":"作废",1:"其他")
	}
	
	Quit:'$IsObject(objEpisode.PAAdmLocDr) return
	Quit:'$IsObject(objEpisode.PAAdmWardDr) return
	Set objAdmLoc=objEpisode.PAAdmLocDr
	Set LocID=objAdmLoc.%Id()
	Set LocDesc=objAdmLoc.BTDesc
	Set LocDesc2=objAdmLoc.BTDesc2
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set objAdmWard=objEpisode.PAAdmWardDr
	//处理虚拟病区的问题
	If $IsObject(objEpisode.PAAdmBedDr){
		If $IsObject(objEpisode.PAAdmBedDr.BTXLocDr){
			Set objAdmWard=objEpisode.PAAdmBedDr.BTXLocDr
		}
	}
	Set WardID=objAdmWard.%Id()
	Set WardDesc=objAdmWard.BTDesc
	Set WardDesc2=objAdmWard.BTDesc2
	Set:WardDesc2'="" WardDesc=WardDesc2
	
	//程序处理以当前科室为准，不以疑似、处置、需关注时点的科室为准
	/*If aLocID=LocID {
		Set ViewType="E"  //按科室显示
		Set CurrLocID=LocID
		Set CurrLocDesc=LocDesc
	} Else {
		Set ViewType="W"  //按按病区显示
		Set CurrLocID=WardID
		Set CurrLocDesc=WardDesc
	}
	*/
	Set ViewType="W"  //按按病区显示
	Set CurrLocID=WardID
	Set CurrLocDesc=WardDesc
		
	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
	
	Set SuspendCode=IsSuspend
	Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已确诊",SuspendCode=2:"已排除",SuspendCode=3:"已上报",1:"错误")
	
	Set IsNeedMsg=""
	If (IsNeedAtt=1){
		Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
		Quit:AttID="" return
		Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
		Quit:'$IsObject(objAtt) return
		Set IsNeedMsg=objAtt.CSIsNeedMsg
	}
	
	Set PapmiNo=objEpisode.PAPapmiNo     //登记号
	Set MrNo=objEpisode.PAMrNo           //病案号
	Set PatName=objEpisode.PAPatName     //姓名
	Set Sex=objEpisode.PASex             //性别
	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Birthday=objEpisode.PABirthday   //出生日期
	Set Age=objEpisode.PAAge             //年龄
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set AdmDate=objEpisode.PAAdmDate     //就诊日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objEpisode.PAAdmTime     //就诊时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set DischDate=objEpisode.PADischDate //出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set OutHospDate = ""
	If DischDate'=""{
		Set OutHospDate = DischDate
	}
	Set DischTime=objEpisode.PADischTime //出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set (CurrBedDr,CurrBed)=""           //床位
	If $IsObject(objEpisode.PAAdmBedDr){
		Set CurrBedDr=objEpisode.PAAdmBedDr.%Id()
		Set CurrBed=objEpisode.PAAdmBedDr.BTDesc
		Set:CurrBed'["床" CurrBed=CurrBed_"床"
	}
	Set PAAdmDoc=objEpisode.PAAdmDoc
	Set AdmDocCode=$p(PAAdmDoc,"|",2)  //医生工号
	Set AdmDocDesc=$p(PAAdmDoc,"|",3)  //医生姓名
	
	//入院日期、入院科室、入科日期、当前科室、入科来源信息
	Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(aEpisodeID,ViewType)
	Quit:TransLocInfo="" return
	Set InHospDate=$p(TransLocInfo,"^",1)
	Set InHospLocID=$p(TransLocInfo,"^",2)
	Set InHospLocDesc=$p(TransLocInfo,"^",3)
	Set InLocDate=$p(TransLocInfo,"^",4)
	Set CurrLocID=$p(TransLocInfo,"^",5)
	Set CurrLocDesc=$p(TransLocInfo,"^",6)
	Set FromLocID=$p(TransLocInfo,"^",7)
	Set FromLocDesc=$p(TransLocInfo,"^",8)
	
	Set:InHospDate'="" InHospDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InHospDate)
	Set:InLocDate'="" InLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InLocDate)
	// 判断患者是否有消息记录
	Set IsMessage=0
	Set:$d(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID)) IsMessage=1
 	//疑似病例筛查病人列表查询
 	//就诊号0、登记号/病案号1、姓名2、性别3、年龄4、当前科室5、床号6、         就诊状态7                          入院日期8、入院科室ID9、入院科室名称10、入科日期11、当前科室id12 、当前科室名称13、        14              15                   需关注病例16、出院日期17       18         19           20              21             22             23   
 	Set return=aEpisodeID_"^"_PapmiNo_"^"_PatName_"^"_Sex_"^"_Age_"^"_CurrLocDesc_"^"_CurrBed_"^"_VisitStatus_"^"_InHospDate_"^"_InHospLocID_"^"_InHospLocDesc_"^"_InLocDate_"^"_CurrLocID_"^"_CurrLocDesc_"^"_FromLocID_"^"_FromLocDesc_"^"_IsNeedAtt_"^"_OutHospDate_"^"_SuspendCode_"^"_SuspendDesc_"^"_AdmDocCode_"^"_AdmDocDesc_"^"_IsNeedMsg_"^"_IsMessage
 	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-20
/// Description:  根据就诊号查找疑似筛查记录
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCScreening
/// Input：       aEpisodeID : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryScreenResult","690")
Query QryScreenResult(aEpisodeID As %String) As %Query(ROWSPEC = "ItmScreenID:%String,ItmScreenTxt:%String,ResultNote:%String,ResultDate:%String,ResultDays:%String,ResultCnt:%String,RstFromDate:%String,RstToDate:%String,RstStatus:%String,OprStatus:%String,InfDiagnosDr:%String,InfPosDr:%String,InfPosDesc:%String,FeverDays:%String,TestAbTimes:%String,OEUCIntuDays:%String,OEVAPIntuDays:%String,OEPICCIntuDays:%String") [ SqlProc ]
{
}

ClassMethod QryScreenResultExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aEpisodeID="" $$$OK
 	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetScreenResult(aEpisodeID)
 	Quit:arrResult.Count()<1 $$$OK
 	
 	Set arrAdmFeverDates=..GetAdmFeverDates(aEpisodeID)       //取发热日期列表
 	Set arrAdmTSSubmitDates=..GetAdmTSSubmitDates(aEpisodeID) //取血常规送检日期列表
 	Set arrAdmTSAbDates=..GetAdmTSAbDates(aEpisodeID)         //取血常规异常日期列表
 	Set arrAdmOEIntuDates=..GetAdmOEIntuDates(aEpisodeID)     //取器械相关治疗日期列表
 	
 	Set Count=arrResult.Count()
 	For indArr=1:1:Count {
		Set obj=arrResult.GetAt(indArr)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.CSItmScreenDr)
		Continue:obj.CSIsActive'=1 //增加是否有效标志
		
		Set ItmScreenID   = obj.CSItmScreenDr.%Id()
		Set ItmScreenTxt  = obj.CSItmScreenTxt
		Set ResultNote    = obj.CSResultNote
		//Set ResultDate=$tr(ResultDate,"-","")
		Set ResultDate    = obj.CSResultDate
		Set ResultCnt     = obj.CSResultCnt
		Set RstFromDate   = obj.CSRstFromDate
		Set RstToDate     = obj.CSRstToDate
		Set RstStatus     = obj.CSRstStatus
		Set OprStatus     = obj.CSOprStatus
		Set ResultDays=$s(RstToDate="":(+$h-RstFromDate+1),1:(RstToDate-RstFromDate+1))
		Set InfDiagnosDr  = obj.CSInfDiagnosDr  //感染诊断记录指针
		Set InfPosDr      = obj.CSInfPosDr      //感染诊断ID
		Set InfPosDesc    = obj.CSInfPosDesc    //感染诊断名称
		
		Set (FeverDays,TestAbTimes,OEUCIntuDays,OEVAPIntuDays,OEPICCIntuDays)=0
		Set TSSubmitTimes=0,TSAbTimes=0
		For indDate=RstFromDate:1:RstToDate {
			Set Times=arrAdmFeverDates.GetAt(indDate)
			If (+Times)>0 {
				Set FeverDays=FeverDays+1
			}
			Set Times=arrAdmTSSubmitDates.GetAt(indDate)
			If (+Times)>0 {
				Set TSSubmitTimes=TSSubmitTimes+Times
			}
			Set Times=arrAdmTSAbDates.GetAt(indDate)
			If (+Times)>0 {
				Set TSAbTimes=TSAbTimes+Times
			}
			
			Set Times=arrAdmOEIntuDates.GetAt(indDate_":导尿管")
			If (+Times)>0 {
				Set OEUCIntuDays=OEUCIntuDays+1
			}
			Set Times=arrAdmOEIntuDates.GetAt(indDate_":呼吸机")
			If (+Times)>0 {
				Set OEVAPIntuDays=OEVAPIntuDays+1
			}
			Set Times=arrAdmOEIntuDates.GetAt(indDate_":中心静脉置管")
			If (+Times)>0 {
				Set OEPICCIntuDays=OEPICCIntuDays+1
			}
		}
		Set TestAbTimes=TSAbTimes_"/"_TSSubmitTimes
		//不需要转换
		//Set:RstFromDate'="" RstFromDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RstFromDate)
        //Set:RstToDate'="" RstToDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RstToDate)
		
		Set Data=$lb(ItmScreenID,ItmScreenTxt,ResultNote,ResultDate,ResultDays,ResultCnt,RstFromDate,RstToDate,RstStatus,OprStatus,InfDiagnosDr,InfPosDr,InfPosDesc,FeverDays,TestAbTimes,OEUCIntuDays,OEVAPIntuDays,OEPICCIntuDays)
		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryScreenResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryScreenResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenResultExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-11-02
/// Description:  取感染诊断信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryINFDiagnos","5392")
Query QryINFDiagnos(aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,InfPosID:%String,InfPos:%String,InfSubID:%String,InfSub:%String,InfDiagnos:%String,InfDate:%String,InfLocID:%String,InfLoc:%String,InfDiagnosisBasis:%String,InfDiseaseCourse:%String,InfXDate:%String,InfEffectID:%String,InfEffect:%String,DeathRelationID:%String,DeathRelation:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String,IsReportDiag:%String,Bacteria:%String,IsActive:%String,IsActDesc:%String,InfType:%String,InfTypeDesc:%String,DiagnosType:%String")
{
}

ClassMethod QryINFDiagnosExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
		Quit:xID=""
		
		Set Data=..BuildInfDiagData(xID)
		Continue:Data=""
		
		Set DiagnosType="确诊诊断"
		Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xID)
		Set ReportCnt=listReports.Count()
		// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
		Set IsReportDiag = $lg(Data,22) //BuildInfDiagData增加一个字段，该字段位置变化 2019-04-01
		If (IsReportDiag=1)&&(ReportCnt=0){
			Continue
		}
		Set:ReportCnt>0 DiagnosType="报告诊断"
		Set Data=Data_$lb(DiagnosType)
		
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryINFDiagnosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFDiagnosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFDiagnosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFDiagnosExecute ]
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

/// 取单个疾病诊断信息
ClassMethod BuildInfDiagData(aINFDiagID As %String) As %String
{
	New (aINFDiagID)
	Set return=""
	Quit:aINFDiagID="" return
	
	Set objINFDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(aINFDiagID)
	Quit:'$IsObject(objINFDiagnos) return
	Quit:'$IsObject(objINFDiagnos.IREpisodeDr) return
	
	Set EpisodeID=objINFDiagnos.IREpisodeDr.%Id()
	Set objInfPos = objINFDiagnos.IRInfPosDr
	Set (InfPosID,InfPos)=""
	If $IsObject(objInfPos){
		Set InfPosID = objInfPos.%Id()
		Set InfPos = objInfPos.BTDesc
	}
	Set objInfSub = objINFDiagnos.IRInfSubDr
	Set (InfSubID,InfSub)=""
	If $IsObject(objInfSub){
		Set InfSubID = objInfSub.%Id()
		Set InfSub = objInfSub.BTDesc
	}
	Set InfDate = objINFDiagnos.IRInfDate
	Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
	Set objInfLoc = objINFDiagnos.IRInfLocDr
	Set (InfLocID,InfLoc)=""
	If $IsObject(objInfLoc){
		Set InfLocID = objInfLoc.%Id()
		Set LocDesc2 = objInfLoc.BTDesc2
		Set LocDesc = objInfLoc.BTDesc
		Set InfLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set InfDiagnosisBasis = objINFDiagnos.IRInfDiagnosisBasis
	Set InfDiseaseCourse = objINFDiagnos.IRInfDiseaseCourse
	Set InfXDate = objINFDiagnos.IRInfXDate
	Set:InfXDate'="" InfXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
	Set objInfEffect = objINFDiagnos.IRInfEffectDr
	Set (InfEffectID,InfEffect)=""
	If $IsObject(objInfEffect){
		Set InfEffectID = objInfEffect.%Id()
		Set InfEffect = objInfEffect.BTDesc
	}
	Set objDeathRelation = objINFDiagnos.IRDeathRelationDr
	Set (DeathRelationID,DeathRelation)=""
	If $IsObject(objDeathRelation){
		Set DeathRelationID = objDeathRelation.%Id()
		Set DeathRelation = objDeathRelation.BTDesc
	}
	Set UpdateDate = objINFDiagnos.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = objINFDiagnos.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser = objINFDiagnos.IRUpdateUserDr
	Set (UpdateUserID,UpdateUser)=""
	If $IsObject(objUpdateUser){
		Set UpdateUserID = objUpdateUser.%Id()
		Set UpdateUser = objUpdateUser.BTDesc
	}
	Set IsReportDiag = objINFDiagnos.IRIsReportDiag	// 是否临床上报诊断
	
	Set InfDiagnos=InfPos
	Set:InfSub'="" InfDiagnos=InfDiagnos_"【"_InfSub_"】"
	
	Set Bacteria = objINFDiagnos.IRBacteria
	Set IsActive = objINFDiagnos.IRIsActive
	Set IsActDesc = $s(IsActive=1:"是",1:"否")  
	Set InfType = objINFDiagnos.IRInfType
	Set InfTypeDesc = $s(InfType=1:"医院感染",InfType=0:"社区感染",1:"医院感染")
	Set return = $lb(aINFDiagID,EpisodeID,InfPosID,InfPos,InfSubID,InfSub,InfDiagnos,InfDate,InfLocID,InfLoc,InfDiagnosisBasis,InfDiseaseCourse,InfXDate,InfEffectID,InfEffect,DeathRelationID,DeathRelation,UpdateDate,UpdateTime,UpdateUserID,UpdateUser,IsReportDiag,Bacteria,IsActive,IsActDesc,InfType,InfTypeDesc)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取发热日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetAdmFeverDates(67)
ClassMethod GetAdmFeverDates(aEpisodeID As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	
	Kill arrResult
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="MR-ObsFever"  //护理-发热
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Set num=$i(arrResult(ActDate))
			}
		}
	}
	
	Set xDate=0
	For {
		Set xDate=$o(arrResult(xDate))
		Quit:xDate=""
		Set Times=$g(arrResult(xDate))
		Do return.SetAt(Times,xDate)
	}
	Kill arrResult
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取血常规送检日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetAdmTSSubmitDates()
ClassMethod GetAdmTSSubmitDates(aEpisodeID As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	
	Kill arrResult
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-Submit"  //检验-常规送检
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:tKeyword'="血常规"
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Set num=$i(arrResult(ActDate))
			}
		}
	}
	
	Set xDate=0
	For {
		Set xDate=$o(arrResult(xDate))
		Quit:xDate=""
		Set Times=$g(arrResult(xDate))
		Do return.SetAt(Times,xDate)
	}
	Kill arrResult
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取血常规异常日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetAdmTSAbDates()
ClassMethod GetAdmTSAbDates(aEpisodeID As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	
	Kill arrResult
	Set xItemID=0,Count=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-TestAb"  //检验-常规检验异常
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:tKeyword'="血常规"
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				Set ObjectID=obj.CCObjectID
				Set LabReportID =$p(ObjectID,"||",1)   //检验报告号
				Set Count = $i(arrResult(LabReportID))
				Continue:Count>1                       //一份送检报告有多项异常值算一次
				Set num=$i(arrResult(ActDate))
			}
		}
	}
	
	Set xDate=0
	For {
		Set xDate=$o(arrResult(xDate))
		Quit:xDate=""
		Set Times=$g(arrResult(xDate))
		Do return.SetAt(Times,xDate)
	}
	Kill arrResult
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取器械相关治疗日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetAdmOEIntuDates()
ClassMethod GetAdmOEIntuDates(aEpisodeID As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	
	Kill arrResult
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="OE-Intubate"  //医嘱-器械相关治疗
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Continue:'$IsObject(obj.CCKeyWordDr)
				Set KeyWord=obj.CCKeyWordDr.CCDesc
				
				Set num=$i(arrResult(ActDate_":"_KeyWord))
			}
		}
	}
	
	Set xDate=0
	For {
		Set xDate=$o(arrResult(xDate))
		Quit:xDate=""
		Set Times=$g(arrResult(xDate))
		Do return.SetAt(Times,xDate)
	}
	Kill arrResult
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-01-23
/// Description:  疑似病例筛查工作量统计
/// Table：       DHCHAI.IR.CCScreening,DHCHAI.IR.CCScreenLog
/// Input:        aFromDate :开始日期
///               aToDAte   :结束日期
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","StaCCSWork","2019-02-28","2019-04-01","1")
Query StaCCSWork(aFromDate As %String, aToDate As %String, aHospIDs As %String) As %Query(ROWSPEC = "UserDesc:%String,DiagSum:%Integer,RemoSum:%Integer,AllDiagSum:%Integer,AllRemoSum:%Integer") [ SqlProc ]
{
}

ClassMethod StaCCSWorkExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aHospIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	
	Kill ^TMP($zn,$j,"StaCCSWork")
	Kill ^TMP($zn,$j,"StaCCSWorkSum")
	Kill ^TMP($zn,$j,"StaCCSWorkOperation")
	
	For xDate=aFromDate:1:aToDate {
		Set xTime=""
		For {
			Set xTime=$o(^DHCHAI.IR.CCScreeningI("Log","IndexActDateTime",xDate,xTime),-1)
			Quit:xTime=""
			Set xParf=""
			For {
				Set xParf=$o(^DHCHAI.IR.CCScreeningI("Log","IndexActDateTime",xDate,xTime,xParf),-1)
				Quit:xParf=""
				Set xId=""
				For {
					Set xId=$o(^DHCHAI.IR.CCScreeningI("Log","IndexActDateTime",xDate,xTime,xParf,xId),-1)
					Quit:xId=""
					
					Set obj=##class(DHCHAI.IR.CCScreenLog).GetObjById(xParf_"||"_xId)
					Continue:'$IsObject(obj)
					
					Set objParf=##class(DHCHAI.IR.CCScreening).GetObjById(xParf)
					Continue:'$IsObject(objParf)
					Continue:'$IsObject(objParf.CSEpisodeDr)
					Set EpisodeDr = objParf.CSEpisodeDr.%Id()
					
					Set (UserID,UserDesc)=""
					If $IsObject(obj.CSActUserDr){
						Set UserID   = obj.CSActUserDr.%Id()
						Set UserDesc = obj.CSActUserDr.BTDesc
					}
					Continue:UserDesc=""
					//用户院区
					If $IsObject(obj.CSActUserDr){
						Set LocID=obj.CSActUserDr.BTLocDr.%Id()
						Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
						Set HospDr=$lg(LocData,8)
					
						Continue:(aHospIDs'="")&&(("|"_aHospIDs_"|")'[("|"_HospDr_"|"))			//过滤院区
					}
					
					Set Status = obj.CSStatus //疑似状态（1确诊、2排除、0未处理）

					//同一就诊同一操作人同一状态算一次 
					If ('$d(^TMP($zn,$j,"StaCCSWorkOperation",UserDesc,Status,EpisodeDr))){
						Set ^TMP($zn,$j,"StaCCSWorkOperation",UserDesc,Status,EpisodeDr)=""
						Set:Status=1 num=$i(^TMP($zn,$j,"StaCCSWork",UserDesc,"DiagNum"))
						Set:Status=2 num=$i(^TMP($zn,$j,"StaCCSWork",UserDesc,"RemoNum"))
					}
					If ('$d(^TMP($zn,$j,"StaCCSWorkSum",Status,EpisodeDr))){
						Set ^TMP($zn,$j,"StaCCSWorkSum",Status,EpisodeDr)=""
						Set:Status=1 num=$i(^TMP($zn,$j,"StaCCSWorkSum","DiagNum"))
						Set:Status=2 num=$i(^TMP($zn,$j,"StaCCSWorkSum","RemoNum"))
					}
				}
			}
		}
	}
	
	Set (AllDiagSum,AllRemoSum)=0
	Set AllDiagSum=AllDiagSum+(+$g(^TMP($zn,$j,"StaCCSWorkSum","DiagNum")))
	Set AllRemoSum=AllRemoSum+(+$g(^TMP($zn,$j,"StaCCSWorkSum","RemoNum")))

	Set xUser=""
	For {
		Set xUser=$o(^TMP($zn,$j,"StaCCSWork",xUser))
		Quit:xUser=""
		Set (DiagSum,RemoSum)=0
		
		Set DiagSum=DiagSum+(+$g(^TMP($zn,$j,"StaCCSWork",xUser,"DiagNum")))
		Set RemoSum=RemoSum+(+$g(^TMP($zn,$j,"StaCCSWork",xUser,"RemoNum")))
		
		Set Data=$lb(xUser,DiagSum,RemoSum,AllDiagSum,AllRemoSum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaCCSWork")
	Kill ^TMP($zn,$j,"StaCCSWorkSum")
	Kill ^TMP($zn,$j,"StaCCSWorkOperation")

	Quit $$$OK
}

ClassMethod StaCCSWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaCCSWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaCCSWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaCCSWorkExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2018-06-12
/// Description:  疑似病例筛查工作量统计明细
/// Table：       DHCHAI.IR.CCScreening,DHCHAI.IR.CCScreenLog
/// Input:        aFromDate :开始日期
///               aToDate   :结束日期
///               aUserName :用户名
///               aStatus   :疑似状态（1确诊、2排除、0未处理）
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","StaCCSWorkDtl","1","medmanager","2019-02-01","2019-03-01")
Query StaCCSWorkDtl(aStatus As %String, aUserName As %String, aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "EpisodeID:%String,ScreenID:%String,ItmScreenID:%String,ItmScreen:%String,ItmScreenTxt:%String,Status:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,Opinion:%String,OpinionTxt:%String,Details:%String,LocDesc:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDate:%String,DischTime:%String,DischLocDesc:%String,DischWardDesc:%String") [ SqlProc ]
{
}

ClassMethod StaCCSWorkDtlExecute(ByRef qHandle As %Binary, aStatus As %String, aUserName As %String, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aFromDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aToDate)
	Kill ^TMP($zn,$j,"StaCCSWorkDtl")
	
	For xDate=aFromDate:1:aToDate {
		Set xTime=""
		For {
			Set xTime=$o(^DHCHAI.IR.CCScreeningI("Log","IndexActDateTime",xDate,xTime),-1)
			Quit:xTime=""
			Set xParf=""
			For {
				Set xParf=$o(^DHCHAI.IR.CCScreeningI("Log","IndexActDateTime",xDate,xTime,xParf),-1)
				Quit:xParf=""
								
				Set objParf=##class(DHCHAI.IR.CCScreening).GetObjById(xParf)
				Continue:'$IsObject(objParf)
				Continue:'$IsObject(objParf.CSEpisodeDr)
				Set EpisodeDr = objParf.CSEpisodeDr.%Id()
			
				If ('$d(^TMP($zn,$j,"StaCCSWorkDtl",EpisodeDr))){
					Set ^TMP($zn,$j,"StaCCSWorkDtl",EpisodeDr)=""
				}
			}
		}
	}
	Set xEpisodeDr=""
	For {
		Set xEpisodeDr=$o(^TMP($zn,$j,"StaCCSWorkDtl",xEpisodeDr))
		Quit:xEpisodeDr=""
		
		Set PatData=..BuildPaadmData(xEpisodeDr)
		Continue:PatData=""
	
		Set xScreenID = ""
		For {
			Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",xEpisodeDr,xScreenID))
			Quit:xScreenID=""
		    
			Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(objScreen)
			Continue:'$IsObject(objScreen.CSItmScreenDr)
			Set ItmScreenID=objScreen.CSItmScreenDr.%Id()
			Set ItmScreen=objScreen.CSItmScreenDr.CCDesc
			Set ItmScreen2=objScreen.CSItmScreenDr.CCDesc2
			Set:ItmScreen2'="" ItmScreen=ItmScreen2
	       
			Set ItmScreenTxt=objScreen.CSItmScreenTxt
			Set Details=""
			If ((ItmScreen="检出致病菌")||(ItmScreen="诊断血流感染"))&(ItmScreenTxt'=""){
				Set Details=##class(DHCHAI.IRS.CCScreenLogSrv).BacteriaItem(xEpisodeDr,ItmScreenTxt)
		    }
		    
		  	If (ItmScreen="病程阳性症状或体征")&(ItmScreenTxt'=""){
		    	Set Details=##class(DHCHAI.IRS.CCScreenLogSrv).SymptomItem(xEpisodeDr,ItmScreenTxt)
	    	}
			
			Set:Details'="" ItmScreen=$tr(Details,"#","")
			
			
		    Set xLogID = ""  //操作日志
		   	For {
		   		Set xLogID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Log",xLogID))
		   		Quit:xLogID=""
		   		
		   		Set xID =xScreenID_"||"_xLogID	   		
		   		Set objLog=##class(DHCHAI.IR.CCScreenLog).GetObjById(xID)
				Continue:'$IsObject(objLog)
				Set Status = objLog.CSStatus
				Continue:((aStatus'="")&&(aStatus'=Status))
				Set Status =$s(Status=2:"排除",Status=1:"确诊",1:"待处理")
				Set ActDate = objLog.CSActDate
				Continue:(aFromDate>ActDate)||(ActDate>aToDate)		
				Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set ActTime   = objLog.CSActTime
				Set:ActTime'="" ActTime=$zt(ActTime,1)
				Set (ActUserID,ActUserCode,ActUserDesc)=""
				If $IsObject(objLog.CSActUserDr) {
					Set ActUserID = objLog.CSActUserDr.%Id()
					Set ActUserCode = objLog.CSActUserDr.BTCode
					Set ActUserDesc = objLog.CSActUserDr.BTDesc
				}
				Continue:((aUserName'="")&&(aUserName'=ActUserDesc))
			
				Set Opinion=""
				If $IsObject(objLog.CSOpinionDr) {
					Set Opinion = objLog.CSOpinionDr.BTDesc
				}
				Set OpinionTxt = objLog.CSOpinion
				Set:OpinionTxt'="" Opinion=Opinion_"("_OpinionTxt_")"

				Set Data=$lb(xEpisodeDr,xScreenID,ItmScreenID,ItmScreen,ItmScreenTxt,Status,ActDate,ActTime,ActUserCode,ActUserDesc,Opinion,OpinionTxt,Details)_PatData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		   	}
		}
	}
	Kill ^TMP($zn,$j,"StaCCSWorkDtl")

	
	Quit $$$OK
}

ClassMethod StaCCSWorkDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaCCSWorkDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaCCSWorkDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaCCSWorkDtlExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2018-04-10
/// Description:  取阳性症状或体征信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryINFSymptom","83237")
Query QryINFSymptom(aEpisodeID As %String, aAllFlag As %String = 0) As %Query(ROWSPEC = "EpisodeID:%String,ActDate:%String,FeResult:%String,SxResult:%String,OpResult:%String")
{
}

ClassMethod QryINFSymptomExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aAllFlag As %String = 0) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 		
	Kill arrResult
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		//护理-发热、语义-症状或体征
		Set ItmMastCode=objItmMast.CCCode
		Continue:(ItmMastCode'="MR-ObsFever")&(ItmMastCode'="RME-Radiology")&(ItmMastCode'="RME-Symptom")&(ItmMastCode'="OR-Incision")
		
		Set xActDate=""
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate))
			Quit:xActDate=""
			
			Set PriorDate=""
			Set PriorTime=""
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Continue:ActDate=""
				Set ActTime=obj.CCActTime
				Set ActTime=+ActTime
				Set ItemDr=obj.CCItemDr.%Id()
				
				If (ItmMastCode="RME-Symptom") {
					Set TextRes=obj.CCUnit_" "_obj.CCResult_"["_obj.CCTextRes_"]"
				} ElseIf (ItmMastCode="RME-Radiology") {
					Set ActDate=obj.CCRepDate
					Continue:ActDate=""
					Set ActTime=obj.CCRepTime
					Set ActTime=+ActTime
					Set TextRes=obj.CCUnit_" "_obj.CCResult_"["_obj.CCTextRes_"]"
				} Else {
					Set TextRes=obj.CCTextRes
					Set:TextRes="" TextRes=obj.CCResult  //手术
				}
				//过滤相同时间点的多余信息
				if ((ActDate=PriorDate)&(ActTime=PriorTime)){
					continue
				}
				else{
					Set PriorDate=ActDate
					Set PriorTime=ActTime
				}
				Set arrResult(ActDate,ItmMastCode,ActTime,xID)=TextRes
			}
		}
	}
	
	//疑似筛查阳性症状或体征显示天数设置
	If aAllFlag<1 {
		Set INFSyViewDay=##class(DHCHAI.BT.Config).GetValByCode("IR-CCScreenINFSymptomViewDay","")
		Set INFSyViewDay=+INFSyViewDay
		Set:INFSyViewDay=0 INFSyViewDay=7
		Set:INFSyViewDay<3 INFSyViewDay=3
		Set:INFSyViewDay>10 INFSyViewDay=10
	} Else {
		Set INFSyViewDay=365
	}
	
	Set ActDateCnt=0
	Set xActDate=""
	For {
		Set xActDate=$o(arrResult(xActDate),-1)
		Quit:xActDate=""
		
		Set ActDateCnt=ActDateCnt+1
		Quit:ActDateCnt>INFSyViewDay  //疑似筛查阳性症状或体征过滤
		
		Set FeResult="",SxResult="",OpResult=""
		Set xItmMast=""
		For {
			Set xItmMast=$o(arrResult(xActDate,xItmMast))
			Quit:xItmMast=""
			
			Set xActTime=""
			For {
				Set xActTime=$o(arrResult(xActDate,xItmMast,xActTime))
				Quit:xActTime=""
				
				Set xID=0
				For {
					Set xID=$o(arrResult(xActDate,xItmMast,xActTime,xID))
					Quit:xID=""
					
					Set TextRst=$g(arrResult(xActDate,xItmMast,xActTime,xID))
					Set TextRst=$tr(TextRst,";","+")
					Set:xItmMast="MR-ObsFever" FeResult=FeResult_";"_TextRst
					Set:xItmMast="RME-Symptom" SxResult=SxResult_";"_TextRst
					Set:xItmMast="RME-Radiology" SxResult=SxResult_";"_TextRst
					Set:xItmMast="OR-Incision" OpResult=OpResult_";"_TextRst
				}
			}
		}
		Set:FeResult'="" FeResult=$e(FeResult,2,$l(FeResult))
		Set:SxResult'="" SxResult=$e(SxResult,2,$l(SxResult))
		Set:OpResult'="" OpResult=$e(OpResult,2,$l(OpResult))
		Set FeResult=$tr(FeResult,";","、")
		Set SxResult=$tr(SxResult,";","、")
		Set OpResult=$tr(OpResult,";","、")
		Set ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xActDate)
		Set Data=$lb(aEpisodeID,ActDate,FeResult,SxResult,OpResult)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrResult
	
	Quit $$$OK
}

ClassMethod QryINFSymptomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFSymptomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFSymptomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFSymptomExecute ]
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
/// CreatDate：   2019-07-06
/// Description:  转换日期显示
/// Table：       
/// Input：       aDateList : 日期列表
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetResultDates()
ClassMethod GetResultDates(aDateList As %String, aToDate As %String = "") As %String
{
	New (aDateList,aToDate)
	Set return=""
	Quit:(aDateList="") return
	Set:aToDate="" aToDate=0
	Kill arrResult
	Kill arrAddDate
	
	Set ResultDates=""
   	For indDate=1:1:$ll(aDateList)  {
	    Set ResultList=$lg(aDateList,indDate)
	    Continue:ResultList=""	
	    Set ResultDate=$zd(ResultList,3) 
	    Set YY=+$p(ResultDate,"-",1)
	    Set MM=+$p(ResultDate,"-",2)
	    Set DD=+$p(ResultDate,"-",3)  
	    Set arrResult(MM,indDate)=DD

	    If (ResultList>aToDate) {   //新增异常日期
	    	Set arrAddDate(MM,indDate)=DD
	    } 
    }
   
    Set ResultDates=""
    Set xMM=0
	For {
		Set xMM=$o(arrResult(xMM))
		Quit:xMM=""
		Set DDs=""
		Set xindArr = ""
		For {
			Set xindArr =$o(arrResult(xMM,xindArr))
			Quit:xindArr=""
			Set xDD = $g(arrResult(xMM,xindArr))
			Set nDD = $g(arrAddDate(xMM,xindArr))
			if (xDD=nDD) {
				Set DDs=DDs_"、"_xDD_"日"
			}else {
				Set DDs=DDs_"、"_"<span style='color:#333'>"_xDD_"日</span>"
			}
		}
		Set:DDs'="" DDs=$e(DDs,2,$l(DDs))
		Set ResultDates=ResultDates_"，"_xMM_"月("_DDs_")"   
	} 
   
	Set:ResultDates'="" ResultDates=$e(ResultDates,2,$l(ResultDates))
	Set return = ResultDates
	
	Kill arrResult
	Kill arrAddDate
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-07-19
/// Description:  获取相同感染诊断、感染日期的感染信息
/// Table：       
/// Input：       
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetDiagInfo("92","2","2019-02-18")
ClassMethod GetDiagInfo(aEpisodeID As %String, aInfPosID As %String, aInfDate As %String) As %String
{
	New (aEpisodeID,aInfPosID,aInfDate)
	Set return=""
	Quit:(aEpisodeID="")||(aInfPosID="")||(aInfDate="") return
	Set aInfDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aInfDate)
	
	Quit:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID)) return
	Set DiagID="",ReportID=""
	Set xDiagID = ""
	For {
		Set xDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xDiagID))
		Quit:xDiagID=""
		
		Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiag)
		Continue:'$IsObject(objDiag.IRInfPosDr) 
		Set IsActive = objDiag.IRIsActive
		Continue:IsActive'=1
		Set InfPosID = objDiag.IRInfPosDr.%Id()
		Set InfPos = objDiag.IRInfPosDr.BTDesc
		Set InfDate = objDiag.IRInfDate
	    Continue:(aInfPosID'=InfPosID)||(InfDate'=aInfDate) 
	    Set DiagID = xDiagID
	    
	    Set xRepID=""
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID))
			Quit:xRepID=""
			
			Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.IREpisodeDr)
			Continue:objReport.IREpisodeDr.%Id()'=aEpisodeID
			Continue:(objReport.IRRepType'=1)
			Continue:'$IsObject(objReport.IRStatusDr)
			Continue:objReport.IRStatusDr.BTCode=4
			
			Set xRepSubID=""
			For {
				Set xRepSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xRepSubID))
				Quit:xRepSubID=""
				 
		   	 	Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepSubID)
				Continue:'$IsObject(objExt)
				Set ObjectID = objExt.IRObjectID
			
				Continue:ObjectID'=DiagID
				Set ReportID = xRepID
			}
		}			
	    
	}
  	Set return = DiagID_"^"_ReportID
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-07-10
/// Description:  根据感染诊断查找感染信息
/// Table：       
/// Input：       aEpisodeID : 就诊号, aInfPosID: 感染诊断ID, aIsReport：是否报告,1:报告
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryRepInfo","7","","")
Query QryRepInfo(aEpisodeID As %String, aInfPosIDs As %String, aIsReport As %String = "") As %Query(ROWSPEC = "ReportID:%String,RepStatus:%String,RepDate:%String,DiagID:%String,InfPosID:%String,InfPos:%String,InfSubID:%String,InfSub:%String,InfDate:%String,InfType:%String,InfTypeDesc:%String,InfDiagnosisBasis:%String,InfDiseaseCourse:%String,InfXDate:%String,InfEffectID:%String,InfEffect:%String,DeathRelationID:%String,DeathRelation:%String,InfLocID:%String,InfLoc:%String") [ SqlProc ]
{
}

ClassMethod QryRepInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aInfPosIDs As %String, aIsReport As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="") $$$OK

    Set InfPosIDList =""
	Quit:'$d(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID)) $$$OK
	For indP=1:1:$l(aInfPosIDs,",") {
		Set aInfPosID=$p(aInfPosIDs,",",indP)
		Continue:aInfPosID=""
		Continue:($listfind(InfPosIDList,aInfPosID)>0)    //去重复
 	   	Set InfPosIDList=InfPosIDList_$lb(aInfPosID)
	}   
	
	Set xInfDate = ""
	For {
		Set xInfDate = $o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aEpisodeID,xInfDate),-1)   //倒序查询，便于关联上次报告
		Quit:xInfDate=""
		
		Set xDiagID = ""
		For {
			Set xDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexEpisInfDate",aEpisodeID,xInfDate,xDiagID))  
			Quit:xDiagID=""
			
			Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiag)
			Continue:'$IsObject(objDiag.IRInfPosDr) 
			Set IsActive = objDiag.IRIsActive
			Continue:IsActive'=1
			Set InfPosID = objDiag.IRInfPosDr.%Id()
			Continue:(aInfPosID'="")&&($listfind(InfPosIDList,InfPosID)<1) 
		
			Set InfPos = objDiag.IRInfPosDr.BTDesc
			Set InfDate = objDiag.IRInfDate
		
			Set objInfSub = objDiag.IRInfSubDr
			Set (InfSubID,InfSub)=""
			If $IsObject(objInfSub){
				Set InfSubID = objInfSub.%Id()
				Set InfSub = objInfSub.BTDesc
			}
			Set (InfLocID,InfLoc)=""
			If $IsObject(objDiag.IRInfLocDr) {
				Set InfLocID = objDiag.IRInfLocDr.%Id()
				Set InfLoc = objDiag.IRInfLocDr.BTDesc
			}
			Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			Set InfXDate = objDiag.IRInfXDate
			Set:InfXDate'="" InfXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
			Set InfType = objDiag.IRInfType
			Set InfTypeDesc = $s(InfType=1:"医院感染",InfType=0:"社区感染",1:"医院感染")

			Set InfDiagnosisBasis = objDiag.IRInfDiagnosisBasis
			Set InfDiseaseCourse = objDiag.IRInfDiseaseCourse
			Set objInfEffect = objDiag.IRInfEffectDr
			Set (InfEffectID,InfEffect)=""
			If $IsObject(objInfEffect){
				Set InfEffectID = objInfEffect.%Id()
				Set InfEffect = objInfEffect.BTDesc
			}
			Set objDeathRelation = objDiag.IRDeathRelationDr
			Set (DeathRelationID,DeathRelation)=""
			If $IsObject(objDeathRelation){
				Set DeathRelationID = objDeathRelation.%Id()
				Set DeathRelation = objDeathRelation.BTDesc
			}
	
			Set ReportID="",RepStatus="",RepDate=""
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID))
				Quit:xRepID=""
				
				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:objReport.IREpisodeDr.%Id()'=aEpisodeID
				Continue:(objReport.IRRepType'=1)
				
				Set xSubID=""
				For {
					Set xSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xSubID))
					Quit:xSubID=""
				    
				    Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xSubID)
					Continue:'$IsObject(objExt)
					Set ObjectID = objExt.IRObjectID
					Continue:ObjectID'=xDiagID
					Set ReportID =xRepID
					Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(ReportID)
					Continue:'$IsObject(objReport)
					Continue:'$IsObject(objReport.IRStatusDr)
					Set RepStatus=objReport.IRStatusDr.BTCode	
					Set RepDate =objReport.IRRepDate
					Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
							
				}	
			}
			Continue:RepStatus=4
			Continue:(aIsReport=1)&&(ReportID="")
			//多语言处理
			Set InfPos=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfPos,"DHCHAI.BT.InfPos")
			Set Data=$lb(ReportID,RepStatus,RepDate,xDiagID,InfPosID,InfPos,InfSubID,InfSub,InfDate,InfType,InfTypeDesc,InfDiagnosisBasis,InfDiseaseCourse,InfXDate,InfEffectID,InfEffect,DeathRelationID,DeathRelation,InfLocID,InfLoc)
			Set ^CacheTemp(repid,ind)=Data
	 		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoExecute ]
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
/// CreatDate：   2019-07-06
/// Description:  根据就诊号查找疑似筛查记录
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCScreening
/// Input：       aEpisodeID : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QrySuRuleResult","23")
Query QrySuRuleResult(aEpisodeID As %String) As %Query(ROWSPEC = "InfReportID:%String,RepStatusCode:%String,ItmScreenID:%String,ItmScreenTxt:%String,ResultNote:%String,ResultDates:%String,InfType:%String,InfTypeDesc:%String,ResultCnt:%String,RstStatus:%String,RstFromDate:%String,RstToDate:%String,IsFever:%String,IsTSAb:%String,IsOEUC:%String,IsOEVAP:%String,IsOEPICC:%String,InfSuDate:%String,InfPosIDList:%String,InfPosList:%String,InfRepDiagID:%String,InfPosID:%String,InfRepPos:%String,InfDate:%String,AdmDate:%String,DischDate:%String,InfRepInfo:%String,ScreenID:%String,Status:%String,OprStatus:%String,DetailsList:%String,OutTxt:%String,LinkDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleResultExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Kill ^TMP($zn,$j,"QrySuRuleResult")
 	Quit:(aEpisodeID="") $$$OK

 	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) $$$OK
	Set AdmDate=objEpisode.PAAdmDate
	Set DischDate=objEpisode.PADischDate
	Set DateFrom=AdmDate
	Set DateTo=DischDate
	Set:DateTo="" DateTo=+$h 
   
    Set arrAdmFeverDates=..GetAdmFeverDates(aEpisodeID)       //取发热日期列表
 	Set arrAdmTSSubmitDates=..GetAdmTSSubmitDates(aEpisodeID) //取血常规送检日期列表
 	Set arrAdmTSAbDates=..GetAdmTSAbDates(aEpisodeID)         //取血常规异常日期列表
 	Set arrAdmOEIntuDates=..GetAdmOEIntuDates(aEpisodeID)     //取器械相关治疗日期列表
 
	//报告数据
	Set xRepType = ""
    Set LinkDesc=""
    Set objDict=##class(DHCHAI.BT.Dictionary).GetObjByCode("CCScreenLink","自报感染")
    Set:$IsObject(objDict) LinkDesc=objDict.BTDesc
	For {
		Quit:'$d(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID))
		Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
		Quit:xRepType=""
		Continue:(xRepType'=1)
		
	    Set xReportID = ""
		For {
			Set xReportID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xReportID))
			Quit:xReportID=""
			
			Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xReportID)
			Continue:'$IsObject(objRep)	
			Set RepDate  = objRep.IRRepDate
			Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			Set RepTime  = objRep.IRRepTime
			Set:RepTime'="" RepTime=$zt(RepTime)
			Set objStatus  = objRep.IRStatusDr
			Set (RepStatusID,RepStatus,RepStatusCode)=""
			If $IsObject(objStatus){
				Set RepStatusID = objStatus.%Id()
				Set RepStatus = objStatus.BTDesc
				Set RepStatusCode  = objStatus.BTCode
			}
			
			Set LinkDiagID = +objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")   //新生儿多份感染诊断只取一条
		    Continue:LinkDiagID=""
		   	
		    Set objINFDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(LinkDiagID)
			Continue:'$IsObject(objINFDiagnos) 
	
			Set objInfPos = objINFDiagnos.IRInfPosDr
			Set (InfPosID,InfPos)=""
			If $IsObject(objInfPos){
				Set InfPosID = objInfPos.%Id()
				Set InfPos = objInfPos.BTDesc
				//多语言处理
				Set InfPos =##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfPos,"DHCHAI.BT.InfPos")
			}
			Set objInfSub = objINFDiagnos.IRInfSubDr
			Set (InfSubID,InfSub)=""
			If $IsObject(objInfSub){
				Set InfSubID = objInfSub.%Id()
				Set InfSub = objInfSub.BTDesc
			}
			Set InfDate = objINFDiagnos.IRInfDate
			Set RstFromDate=InfDate
			Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			Set InfXDate = objINFDiagnos.IRInfXDate
			Set:InfXDate'="" InfXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
			Set InfType = objINFDiagnos.IRInfType
			Set InfTypeDesc = $s(InfType=1:"医院感染",InfType=0:"社区感染",1:"医院感染")
			Set InfPos=$s(InfSub'="":InfSub,1:InfPos)
	        Set InfRepInfo = InfPos_"("_InfDate_")"_"#"_LinkDiagID_"#"_xReportID
	        Set ItmScreenTxt=##class(websys.Translation).Get("dhcma.hai.ir.ccscreening.csp","自报感染")
	        Set ResultNote=##class(websys.Translation).Get("dhcma.hai.ir.ccscreening.csp","报告诊断")_"->"_InfPos_"("_InfDate_")"
	        Set OprStatus = 1
	        Set:RepStatusCode=4 OprStatus=2
	        
	        Set (IsFever,IsTSAb,IsOEUC,IsOEVAP,IsOEPICC)=0
			For indDatex=(RstFromDate-3):1:(RstFromDate+3) {  //感染前后3天是否有发热、血常规异常
				Set Times=arrAdmFeverDates.GetAt(indDatex)
				If (+Times)>0 {
					Set IsFever=1
				}
				
				Set Times=arrAdmTSAbDates.GetAt(indDatex)
				If (+Times)>0 {
					Set IsTSAb=1
				}
			}
			For indDatey=(RstFromDate-7):1:RstFromDate {  //感染前7天是否使用器械相关医嘱	
				Set Times=arrAdmOEIntuDates.GetAt(indDatey_":导尿管")
				If (+Times)>0 {
					Set IsOEUC=1
				}
				Set Times=arrAdmOEIntuDates.GetAt(indDatey_":呼吸机")
				If (+Times)>0 {
					Set IsOEVAP=1
				}
				Set Times=arrAdmOEIntuDates.GetAt(indDatey_":中心静脉置管")
				If (+Times)>0 {
					Set IsOEPICC=1
				}
			}	
		   
            Set Data=$lb(xReportID,RepStatusCode,"",ItmScreenTxt,ResultNote,InfDate,InfType,InfTypeDesc,"",OprStatus,InfDate,InfXDate,IsFever,IsTSAb,IsOEUC,IsOEVAP,IsOEPICC,"","","",LinkDiagID,InfPosID,InfPos,InfDate,AdmDate,DischDate,InfRepInfo,xScreenID,1,OprStatus,"","",LinkDesc)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}		
	
	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetSuRuleResult(aEpisodeID,DateFrom,DateTo)
 	Quit:arrResult.Count()<1 $$$OK
 	Set Count=arrResult.Count()
 	For indArr=1:1:Count {
		Set obj=arrResult.GetAt(indArr)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.CSItmScreenDr)
		Continue:obj.CSIsActive'=1 //增加是否有效标志
		
		Set ItmScreenID   = obj.CSItmScreenDr.%Id()
		Set ItmScreenTxt  = $tr(obj.CSItmScreenTxt," ","")
		Set ResultNote    = obj.CSResultNote

		Set ResultDate    = obj.CSResultDate
		Set ResultCnt     = obj.CSResultCnt
		Set RstFromDate   = obj.CSRstFromDate
		Set RstToDate     = obj.CSRstToDate
		Set RstStatus     = obj.CSRstStatus
		Set OprStatus     = obj.CSOprStatus
		Set InfSuDate     = obj.CSInfSuDate     //推荐感染日期
		Set InfSuKeys     = obj.CSInfSuKeys     //疑似诊断关键词信息
		Set InfSuPosID    = obj.CSInfSuPosDr    //疑似诊断（部位）
		Set Specimen      = obj.CSSpecimen      //(新增)标本名称（多值#分隔）
		Set MRBType       = obj.CSMRBType       //(新增)多耐分类名称（多值#分隔）
		Set InfSuRuleDr   = obj.CSInfSuRuleDr   //(新增)规则ID（多值#分隔)
		Set Details       = obj.CSDetails       //病毒支原体检测结果明细
	    
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(InfSuRuleDr)
		Continue:'$IsObject(objRule)
		
		Set InfSuRuleNote = objRule.BTRuleNote
		Set ItmTxt=ItmScreenTxt
		Set:ItmTxt="" ItmTxt="*"
		Set ^TMP($zn,$j,"QrySuRuleResult",InfSuRuleDr,ItmScreenID,ItmTxt,indArr) = $lb(InfSuRuleDr,InfSuPosID,InfSuKeys,InfSuDate,Specimen,MRBType,ItmScreenTxt,ResultDate,RstStatus,OprStatus,ResultCnt,ResultNote,RstFromDate,RstToDate,Details)
 	}
 	
    Set xInfSuRuleID=""
 	For{
	 	Set xInfSuRuleID=$o(^TMP($zn,$j,"QrySuRuleResult",xInfSuRuleID))
	 	Quit:xInfSuRuleID=""
	 	Set xItmScreenID=""
	 	For{
		 	Set xItmScreenID=$o(^TMP($zn,$j,"QrySuRuleResult",xInfSuRuleID,xItmScreenID))
		 	Quit:xItmScreenID=""
		 	
		 	Set ResultCount=0
		 	Set xItmScreenTxt=""	 	
		 	For{
		 		Set xItmScreenTxt=$o(^TMP($zn,$j,"QrySuRuleResult",xInfSuRuleID,xItmScreenID,xItmScreenTxt))
		 		Quit:xItmScreenTxt=""	
		 	  
			 	Set InfSuPosIDList="",InfSuDateList="",ResultDateList="",SpecimenList="",MRBTypeList="",ResultCount="",DetailsList="",InfSuKeyList=""
			 	Set xindArr=""
			 	For{
			 		Set xindArr=$o(^TMP($zn,$j,"QrySuRuleResult",xInfSuRuleID,xItmScreenID,xItmScreenTxt,xindArr))
			 		Quit:xindArr=""
			 		
			 		Set SuRuleInfo = $g(^TMP($zn,$j,"QrySuRuleResult",xInfSuRuleID,xItmScreenID,xItmScreenTxt,xindArr))
			 	    Continue:SuRuleInfo=""
			 	    Set InfSuRuleDr  = $lg(SuRuleInfo,1)
			 	    Set InfSuPosID   = $lg(SuRuleInfo,2)
			 	    Set InfSuKeys    = $lg(SuRuleInfo,3)
			 	    Set InfSuDate    = $lg(SuRuleInfo,4)
			 	    Set Specimen     = $lg(SuRuleInfo,5)
			 	    Set MRBType      = $lg(SuRuleInfo,6)
			 	    Set ItmScreenTxt = $lg(SuRuleInfo,7)
			 	    Set ResultDate   = $lg(SuRuleInfo,8)
			 	    Set RstStatus    = $lg(SuRuleInfo,9)
			 	    Set OprStatus    = $lg(SuRuleInfo,10)   
			 	   	Set ResultCnt    = $lg(SuRuleInfo,11)
			 	   	Set ResultNote   = $lg(SuRuleInfo,12)
			 	   	Set RstFromDate  = $lg(SuRuleInfo,13)
			 	   	Set RstToDate    = $lg(SuRuleInfo,14)
			 	    Set Details      = $lg(SuRuleInfo,15)
			 	    
			 	   	If ($listfind(InfSuPosIDList,InfSuPosID)<1) {
			 	   		Set InfSuPosIDList=InfSuPosIDList_$lb(InfSuPosID)
			 	   	}
			 	   	If ($listfind(InfSuDateList,InfSuDate)<1) {
			 	   		Set InfSuDateList=InfSuDateList_$lb(InfSuDate)
			 	   	}
			 	   	If ($listfind(ResultDateList,ResultDate)<1) {
			 	   		Set ResultDateList=ResultDateList_$lb(ResultDate)
			 	   	}
			 	  	Set SpecimenList=SpecimenList_"#"_Specimen
			 	   
			 	   	If ($listfind(MRBTypeList,MRBType)<1) {
			 	   		Set MRBTypeList=MRBTypeList_$lb(MRBType)
			 	   	} 	
			 	   	Set ResultCount=ResultCount+ResultCnt
			 	   	Set:Details'="" DetailsList=DetailsList_"#"_Details	
			 	   	Set:ResultNote["病程" DetailsList="#"_InfSuKeys	  
			 	   	Set:ResultNote["权重" ResultDateList = ResultDate   //update 2022-05-10 权重组合判断规则日期比较特殊 
			 	}
			   
			    Set InfSuPosIDs="",InfSuPosID="",InfPosIDList="",InfPosList=""
			   
			    For indPos=1:1:$ll(InfSuPosIDList) {    
				    Set InfSuPosIDs=$lg(InfSuPosIDList,indPos)
				    Continue:InfSuPosIDs=""	     
				    For indInf =1:1:$l(InfSuPosIDs,"#") {                   //一个项目推荐多个感染部位
					    Set InfSuPosID=$p(InfSuPosIDs,"#",indInf)
					    Continue:InfSuPosID=""
					    Set objInfSup =##class(DHCHAI.BT.InfSuPos).GetObjById(InfSuPosID)
				   		Continue:'$IsObject(objInfSup)
				   		Continue:'$IsObject(objInfSup.BTInfPosDr)
				   		Set InfSuPos = objInfSup.BTDiagnos
						Set InfPosID = objInfSup.BTInfPosDr.%Id()
				   		Set InfPos = objInfSup.BTInfPosDr.BTDesc
				   		Set InfPosIDList=InfPosIDList_"，"_InfSuPosID
				   		Set InfPosList=InfPosList_"，"_InfPos
				    }
			    }
			  
			    Set:InfPosIDList'="" InfPosIDList=$e(InfPosIDList,2,$l(InfPosIDList))
			    Set:InfPosList'="" InfPosList=$e(InfPosList,2,$l(InfPosList))
			    Set:DetailsList'="" DetailsList=$e(DetailsList,2,$l(DetailsList))
			    Set InfSuDate=$lg(InfSuDateList,1)   //推荐日期只显示第一个
				Set:InfSuDate'="" InfSuDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfSuDate) 
				
				//Set ResultDates=##class(DHCHAI.IRS.CCScreeningSrv).GetResultDates(ResultDateList)   //结果日期列表	    
			  
			    Set RstFromDate=$lg(ResultDateList,1)
			    //update  20210517判断是否入院48h项目
			    Set OutTxt=""
			    Set:RstFromDate<(AdmDate+2) OutTxt="院外"
			    Set RstToDate=$lg(ResultDateList,($ll(ResultDateList)))
			    Set:RstToDate="" RstToDate=RstFromDate
			    Set:RstFromDate'="" RstFromDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RstFromDate)
			    Set:RstToDate'="" RstToDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RstToDate)
			   
			    Set Specimens=""
			   	For indSpe=1:1:$l(SpecimenList,"#")  {
				    Set Specimen=$p(SpecimenList,"#",indSpe)
				    Continue:Specimen=""
				    Continue:Specimens[Specimen
				    Set Specimens=Specimens_"、"_ Specimen	    
			    }
			    Set:Specimens'="" Specimens=$e(Specimens,2,$l(Specimens))
			   
			    If ($l(Specimens,"、")>1) {
				    Set Note=""
				    Set:ResultNote["多耐" Note=$p(ResultNote,") (",3)
				    Set ResultNote =$p(ResultNote,") (",1)
				    Set ResultNote=ResultNote_") ("_Specimens_")"
				    Set:Note'="" ResultNote=ResultNote_" ("_Note
			    }
			    
			   	Set MRBTypes=""
			   	For indMRB=1:1:$ll(MRBTypeList)  {
				    Set MRBType=$lg(MRBTypeList,indMRB)
				    Continue:MRBType=""
				    Set MRBTypes=MRBTypes_"#"_ MRBType	    
			    }
			    Set:MRBTypes'="" MRBTypes=$e(MRBTypes,2,$l(MRBTypes))
			  
			   	Set (InfReportID,RepStatusCode,ScreenID,Status,InfRepDiagID,InfRepPosID,InfRepPos,InfType,InfTypeDesc,InfRepInfo,OprRstToDate)=""		
			   	Set (InfRepDiagList)=""
			   	Set xScreenID=""
			   	For {
				   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeID,xItmScreenID," "_$zcvt(ItmScreenTxt,"U"),xScreenID))
				   	Quit:xScreenID=""
				    
				    Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
					Continue:'$IsObject(objScreen)
					Set Status=objScreen.CSStatus
				    Set OprRstToDate=objScreen.CSRstToDate
				    Set OutTxt=""    //update  20210517已确诊、排除不再显示院外标记
					Set xSubID = ""
				   	For {
				   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
				   		Quit:xSubID=""
				   		
				   		Set xID =xScreenID_"||"_xSubID
				   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
						Continue:'$IsObject(objScreenDtl)
						Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
						Continue:objScreenDtl.CSStatus=2
						Set InfRepDiagID=objScreenDtl.CSInfRepPosDr.%Id()	              //项目确诊感染诊断信息ID
						Continue:($listfind(InfRepDiagList,InfRepDiagID)>0)               //处理7日内检出同种菌与检出菌全部确诊时的情况
			 	   		Set InfRepDiagList=InfRepDiagList_$lb(InfRepDiagID)   
			 	   		
						Set InfType =objScreenDtl.CSInfRepPosDr.IRInfType
						Set InfTypeDesc = $s(InfType=1:"医院感染",InfType=0:"社区感染",1:"医院感染")
						
						Set InfDate = objScreenDtl.CSInfRepPosDr.IRInfDate
						Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
				
						If $IsObject(objScreenDtl.CSInfRepPosDr.IRInfPosDr) {
							Set InfRepPosID=objScreenDtl.CSInfRepPosDr.IRInfPosDr.%Id()
							Set InfRepPos=objScreenDtl.CSInfRepPosDr.IRInfPosDr.BTDesc   //项目确诊感染部位描述
							Set InfSubPos=""
							If $IsObject(objScreenDtl.CSInfRepPosDr.IRInfSubDr){
								Set InfSubPos=objScreenDtl.CSInfRepPosDr.IRInfSubDr.BTDesc
							}
							Set InfRepPos=$s(InfSubPos'="":InfSubPos,1:InfRepPos)
							
						}
						
				   		Set xRepID=""
						For {
							Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID))
							Quit:xRepID=""
							
							Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
							Continue:'$IsObject(objReport)
							Continue:'$IsObject(objReport.IREpisodeDr)
							Continue:objReport.IREpisodeDr.%Id()'=aEpisodeID
							Continue:(objReport.IRRepType'=1)
							Continue:'$IsObject(objReport.IRStatusDr)
							Set RepStatusCode = objReport.IRStatusDr.BTCode
							Continue:RepStatusCode=4
						  
							Set xRepSubID=""
							For {
								Set xRepSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xRepSubID))
								Quit:xRepSubID=""
								
						   	 	Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepSubID)
								Continue:'$IsObject(objExt)
								Set ObjectID = objExt.IRObjectID
							
								Continue:ObjectID'=InfRepDiagID
								Set InfReportID = xRepID
							}
						}		
						//多语言处理
						Set InfRepPos =##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",InfRepPos,"DHCHAI.BT.InfPos")	
						Set:InfRepPos'="" InfRepInfo=InfRepInfo_","_InfRepPos_"("_InfDate_")"_"#"_InfRepDiagID_"#"_InfReportID
				   	}	  
				   	Set:InfRepInfo'="" InfRepInfo=$e(InfRepInfo,2,$l(InfRepInfo))
				   	Set ScreenID=xScreenID
			   	}
			    
			    Set ResultDates=##class(DHCHAI.IRS.CCScreeningSrv).GetResultDates(ResultDateList,OprRstToDate)   //结果日期列表 与处置结束日期比较				    
				Set (IsFever,IsTSAb,IsOEUC,IsOEVAP,IsOEPICC)=0
				For indDate=1:1:$ll(ResultDateList) {
					Set RstDate = $lg(ResultDateList,indDate)
					Continue:RstDate=""
					For indDatex=(RstDate-3):1:(RstDate+3) {  //感染前后3天是否有发热、血常规异常
						Set Times=arrAdmFeverDates.GetAt(indDatex)
						If (+Times)>0 {
							Set IsFever=1
							
						}
						
						Set Times=arrAdmTSAbDates.GetAt(indDatex)
						If (+Times)>0 {
							Set IsTSAb=1
						}
					}
					
					For indDatey=(RstDate-7):1:RstDate {  //感染前7天是否使用器械相关医嘱	
						Set Times=arrAdmOEIntuDates.GetAt(indDatey_":导尿管")
						If (+Times)>0 {
							Set IsOEUC=1
						}
						Set Times=arrAdmOEIntuDates.GetAt(indDatey_":呼吸机")
						If (+Times)>0 {
							Set IsOEVAP=1
						}
						Set Times=arrAdmOEIntuDates.GetAt(indDatey_":中心静脉置管")
						If (+Times)>0 {
							Set IsOEPICC=1
						}
					}
					Continue:IsFever=1
					Continue:IsTSAb=1
					Continue:IsOEUC=1
					Continue:IsOEVAP=1
					Continue:IsOEPICC=1	
				}
                Set LinkDesc=""
                Set objDict=##class(DHCHAI.BT.Dictionary).GetObjByCode("CCScreenLink",InfSuKeys)
                Set:$IsObject(objDict) LinkDesc=objDict.BTDesc
                Set Data=$lb(InfReportID,RepStatusCode,xItmScreenID,ItmScreenTxt,ResultNote,ResultDates,InfType,InfTypeDesc,ResultCount,RstStatus,RstFromDate,RstToDate,IsFever,IsTSAb,IsOEUC,IsOEVAP,IsOEPICC,InfSuDate,InfPosIDList,InfPosList,InfRepDiagID,InfRepPosID,InfRepPos,InfDate,AdmDate,DischDate,InfRepInfo,ScreenID,Status,OprStatus,DetailsList,OutTxt,LinkDesc)
				Set ^CacheTemp(repid,ind)=Data
		 		Set ind=ind+1
		 	}
	 	}
 	}
 	Kill ^TMP($zn,$j,"QrySuRuleResult")
 	
	Quit $$$OK
}

ClassMethod QrySuRuleResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleResultExecute ]
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
/// CreatDate：   20120-05-26
/// Description:  手工添加感染诊断
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenLog
/// Input：       aEpisodeDr    : 就诊号
///               aDiagInfo     : 感染信息/疑似处置信息
///               aInfSuPos     : 推荐诊断名称
///               aUserID       : 操作人
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).SaveDiagScreen("17","^17^2^^2020-07-20^^^^^^^^^8^0^^1^1","上呼吸道感染","13")
ClassMethod SaveDiagScreen(aEpisodeDr As %String, aDiagInfo As %String, aInfSuPos As %String, aOperUser As %String, aActType As %String = "") As %String
{
	New (aEpisodeDr,aDiagInfo,aInfSuPos,aOperUser,aActType)
	Set return=0 
	Quit:(aEpisodeDr="")||(aInfSuPos="")||(aDiagInfo="") return
   
	Set ItmScreenID=""
	Set ItmScreenID=$o(^DHCHAI.IR.CCItmScreenI("IdxofDesc","手工添加感染诊断",0))  //疑似筛查项目
	Quit:ItmScreenID="" return
	Set DiagPosID    = $p(aDiagInfo,$c(1),3)   //诊断ID
	Set RstFromDate  = $p(aDiagInfo,$c(1),5)   //疑似开始日期
	Set RstToDate    = $p(aDiagInfo,$c(1),9)   //疑似结束日期
	Set:RstToDate="" RstToDate=RstFromDate
	Set InfSuPosID=""

	Set xSuPosID=""   //由感染诊断转化为疑似诊断
	For {
		Set xSuPosID=$o(^DHCHAI.BT.InfSuPosD(xSuPosID))
		Quit:xSuPosID=""
		Set InfSuPosData=$g(^DHCHAI.BT.InfSuPosD(xSuPosID))
		Set InfPosID=$lg(InfSuPosData,3)
		Continue:(InfPosID'=aInfSuPos)
		Set InfSuPosID=xSuPosID
		Quit:InfSuPosID'=""  //取第一条疑似诊断
	}
	Quit:InfSuPosID="" return -777
	
	Set:RstFromDate'="" RstFromDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(RstFromDate)
	Set xDiagID = "",IsActive=0
	For {
		Set xDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeDr,xDiagID))
		Quit:xDiagID=""
		Quit:IsActive=1
		Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiag)
		Continue:'$IsObject(objDiag.IRInfPosDr) 
		Continue:objDiag.IRIsActive'=1
		Set InfPosID = objDiag.IRInfPosDr.%Id()
		Set InfPos = objDiag.IRInfPosDr.BTDesc
		Set InfDate = objDiag.IRInfDate
	    Continue:DiagPosID'=InfPosID   //诊断不同不判断日期	    
	    Continue:(InfDate>=RstFromDate)&&(InfDate>(RstFromDate+15))  //添加感染日期早于历史感染日期15天为有效
	    Continue:(InfDate<RstFromDate)&&(RstFromDate>(InfDate+15))   //添加感染日期晚于历史感染日期15天为有效
	    Set IsActive=1
	}
	Quit:IsActive=1 return -999
	
    Set DiagID = ##class(DHCHAI.IR.INFDiagnos).Update(aDiagInfo,$c(1))
	Set InputStr=""
	Set InputStr=InputStr_"^"_aEpisodeDr
	Set InputStr=InputStr_"^"_ItmScreenID
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_1     //操作/状态(1确认、2排除)
	Set InputStr=InputStr_"^"_InfSuPosID
	Set InputStr=InputStr_"^"_RstFromDate
	Set InputStr=InputStr_"^"_RstToDate
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_aOperUser
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_aActType
    
    Set ScreenID=##class(DHCHAI.IR.CCScreening).Update(InputStr)
    If (ScreenID>0) {
	 	Set obj=##class(DHCHAI.IR.CCScreening).%OpenId(ScreenID)
		Quit:'$IsObject(obj) return
		
		Set obj.CSItmScreenTxt = ScreenID      //保证数据唯一
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
			Do $system.OBJ.DisplayError(sc)
			Set return=-1
		}else{
			Set return=ScreenID
		}
		Do obj.%Close()
		
		Set InputSub = ScreenID_"^^"_1_"^"_RstFromDate_"^"_DiagID_"^^^"_aOperUser
		Set Dtl=##class(DHCHAI.IR.CCScreenDtl).Update(InputSub)
    }
    
    Set flg=##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlagNew(aEpisodeDr)
    If return>0 {
		Set return=flg  
	}
   
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-08-06
/// Description:  确诊、排除操作
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreenLog
/// Input：       aEpisodeDr    : 就诊号
///               aScreenInfo   : 疑似处置信息（疑似筛查项目^疑似筛查文本^疑似项目结束日期）
///               aOperCode     : 操作代码(1确诊、2排除)
///               aOperUser     : 操作人
///               aOpinion      : 处置意见
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).SaveSuRuleOper("93",",19^^2019-01-31^2019-02-26^undefined^13^",2,32,"13")
ClassMethod SaveSuRuleOper(aEpisodeDr As %String, aScreenInfos As %String, aOperCode As %String, aOperUser As %String, aOpinionDr As %String = "", aOpinion As %String = "", aActType As %String = "") As %String
{
	New (aEpisodeDr,aScreenInfos,aOperCode,aOperUser,aOpinionDr,aOpinion,aActType)
	Set return=0,ErrCnt=0
	Quit:(aEpisodeDr="")||(aScreenInfos="") return
	Quit:(aOperCode'=1)&(aOperCode'=2) return  //1确诊、2排除
	Set (MsgScreenTxt,MsgInfRepPos)=""
	For indS=1:1:$l(aScreenInfos,",") {
		Set aScreenInfo = $p(aScreenInfos,",",indS)
		Continue:aScreenInfo=""
		Set ItmScreenID  = $p(aScreenInfo,"^",1)   //疑似筛查项目
		Set ItmScreenTxt = $p(aScreenInfo,"^",2)   //疑似筛查文本
		Set RstFromDate  = $p(aScreenInfo,"^",3)   //疑似开始日期
		Set RstToDate    = $p(aScreenInfo,"^",4)   //疑似结束日期
		Set InfSuPosDr   = $p(aScreenInfo,"^",5)   //疑似诊断
		Set Opinion      = $p(aScreenInfo,"^",6)   //疑似处置意见
		Set OpinionDr    = $p(aScreenInfo,"^",7)   //疑似处置意见字典
		Set InfRepPosDr  = $p(aScreenInfo,"^",8)   //确诊诊断
		Continue:(ItmScreenID="")||(RstToDate="")	
		Set ItmScreenTxt=$tr(ItmScreenTxt," ","")
		
		Set ID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeDr,ItmScreenID," "_$zcvt(ItmScreenTxt,"U"),0))
		Set InputStr=ID
		Set InputStr=InputStr_"^"_aEpisodeDr
		Set InputStr=InputStr_"^"_ItmScreenID
		Set InputStr=InputStr_"^"_ItmScreenTxt
		Set InputStr=InputStr_"^"_aOperCode     //操作/状态（1确认、2排除）
		Set InputStr=InputStr_"^"_InfSuPosDr
		Set InputStr=InputStr_"^"_RstFromDate
		Set InputStr=InputStr_"^"_RstToDate
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_aOperUser
		Set InputStr=InputStr_"^"_Opinion
		Set InputStr=InputStr_"^"_OpinionDr
		Set InputStr=InputStr_"^"_aActType
	    //组织消息内容
	    Set objItmScreen = ##class(DHCHAI.IR.CCItmScreen).GetObjById(ItmScreenID)
	    Set:ItmScreenTxt'="" MsgTmp = objItmScreen.CCDesc_"("_ItmScreenTxt_")"
	    Set:ItmScreenTxt="" MsgTmp=objItmScreen.CCDesc
	    Set:MsgScreenTxt'="" MsgScreenTxt=MsgScreenTxt_";"_MsgTmp
	    Set:MsgScreenTxt="" MsgScreenTxt=MsgTmp
	    Set:(MsgInfRepPos="")&(InfRepPosDr'="") MsgInfRepPos=##class(DHCHAI.IR.INFDiagnos).GetObjById(InfRepPosDr).IRInfPosDr.BTDesc
	    Set flg=##class(DHCHAI.IR.CCScreening).Update(InputStr)
		If (+flg>0) {
			Set InputSub = flg_"^^"_aOperCode_"^"_RstToDate_"^"_InfRepPosDr_"^^^"_aOperUser
			Set Dtl=##class(DHCHAI.IR.CCScreenDtl).Update(InputSub)
			If (+Dtl<1) {
				Set ErrCnt=ErrCnt+1 //错误记录数
			}
		} Else {
			Set ErrCnt=ErrCnt+1 //错误记录数
		} 		
	}

	//处理疑似状态及处置状态（待处理、已处理）
	Set flg=##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlagNew(aEpisodeDr)
	If (+flg)<1 {
		Set ErrCnt=ErrCnt+1 //错误记录数
	}
	Set SusInfInfo=flg
			
	If ErrCnt>0 {
		Set return=-1
	} Else {
		Set return=SusInfInfo  
		//aOperCode=1 确诊
		//操作全部和单条都会调用  配置判断是否启用发送标识
		//根据系统配置获取是否往HIS下发送消息 消息代码暂用1011
		Set MsgActSendCode=##class(DHCHAI.BT.Config).GetValByCode("MsgActSendCode")
		if (MsgActSendCode'="")&(aOperCode=1)&(MsgActSendCode'="99999")
		{
			//组织发送消息内容：  患者因{}原因，院感科已确诊为{}。请及时处理！
			Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
			Set PatName = objAdm.PAPatName
			Set MsgTxt = "患者因"_MsgScreenTxt_"原因，院感科已确诊为"_MsgInfRepPos_"。请及时处理！"						
			Set HisPaadm = $p(objAdm.PAEpisodeIDx,"||",2)
			Set otherInfoJson="{""linkParam"":""EpisodeDr="_aEpisodeDr_"&Paadm="_HisPaadm_"&MsgType=2""}"   //处理消息对应的链接
			Set MsgUserFrom = ##class(DHCHAI.BT.SysUser).GetObjById(aOperUser)
			Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(MsgTxt,MsgActSendCode,$p(MsgUserFrom.BTXCode,"||",2),HisPaadm,"",otherInfoJson)
		}
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-08-06
/// Description:  修改操作明细记录 
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreenLog
/// Input：       aScreenInfo   : 疑似处置信息（历史处置信息）
///               aOperCode     : 操作代码(1确诊、2排除)
///               aOperUser     : 操作人
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).UpdateOper(",2||1,2||2,2||3,2||4,4||1","2","32")
ClassMethod UpdateOper(aScrDtlInfos As %String, aOperCode As %String, aOperUser As %String, aOpinionDr As %String = "", aOpinion As %String = "", aScreenIDs As %String = "", aActType As %String = "") As %String
{
	New (aScrDtlInfos,aOperCode,aOperUser,aOpinionDr,aOpinion,aScreenIDs,aActType)
	Set return=0,ErrCnt=0

	Quit:(aOperCode'=1)&(aOperCode'=2) return  //1确诊、2排除
	Quit:(aScrDtlInfos="") return
	
	For indS=1:1:$l(aScrDtlInfos,",") {
	 	Set aScrDtlID = $p(aScrDtlInfos,",",indS)
	 	Continue:aScrDtlID=""
	 	Set aScreenID = $p(aScrDtlID,"||",1)
	 	Set aDtlSubID = $p(aScrDtlID,"||",2)
	 	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(aScreenID)
		Continue:'$IsObject(objScreen) 
		Continue:'$IsObject(objScreen.CSEpisodeDr)
		Continue:'$IsObject(objScreen.CSItmScreenDr)
		Continue:aOperCode=objScreen.CSStatus
		Set InfSuPosID=""
		If $IsObject(objScreen.CSInfSuPosDr) {
			Set InfSuPosID =objScreen.CSInfSuPosDr.%Id()
		}
	
	   	Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(aScrDtlID)
		Continue:'$IsObject(objScreenDtl) 
		Continue:objScreenDtl.CSStatus=aOperCode        //确诊已排除的项目过滤确诊,排除已确诊过滤排除
   		Set InfRepPosID=""
   		If $IsObject(objScreenDtl.CSInfRepPosDr) {
	  		Set InfRepPosID=objScreenDtl.CSInfRepPosDr.%Id()	
   		}
		
	  	Set InputStr=""
		Set $p(InputStr,"^",1)=aScreenID
		Set $p(InputStr,"^",2)=objScreen.CSEpisodeDr.%Id()
		Set $p(InputStr,"^",3)=objScreen.CSItmScreenDr.%Id()
		Set $p(InputStr,"^",4)=objScreen.CSItmScreenTxt
		Set $p(InputStr,"^",5)=aOperCode     //操作/状态（1确认、2排除）
		Set $p(InputStr,"^",6)=InfSuPosID
		Set $p(InputStr,"^",7)=objScreen.CSRstFromDate
		Set $p(InputStr,"^",8)=objScreen.CSRstToDate
		Set $p(InputStr,"^",9)=""
		Set $p(InputStr,"^",10)=""
		Set $p(InputStr,"^",11)=aOperUser
		Set $p(InputStr,"^",12)=aOpinion
		Set $p(InputStr,"^",13)=aOpinionDr	
		Set $p(InputStr,"^",14)=aActType	
		
		Set ScrDtlInfo=""
		Set $p(ScrDtlInfo,"^",1)=aScreenID
		Set $p(ScrDtlInfo,"^",2)=aDtlSubID
		Set $p(ScrDtlInfo,"^",3)=aOperCode
		Set $p(ScrDtlInfo,"^",4)=objScreenDtl.CSRstDate  
		Set $p(ScrDtlInfo,"^",5)=InfRepPosID   
		Set $p(ScrDtlInfo,"^",6)="" 
		Set $p(ScrDtlInfo,"^",7)=""
		Set $p(ScrDtlInfo,"^",8)=aOperUser
	   
	    Set flg=##class(DHCHAI.IR.CCScreening).Update(InputStr)
		If (+flg>0) {
			Set Dtl=##class(DHCHAI.IR.CCScreenDtl).Update(ScrDtlInfo)
			If (+Dtl<1) {
				Set ErrCnt=ErrCnt+1 //错误记录数
			}Else{  // 取消确诊成功，设置诊断无效
				Set SetIsActFlag=..UpdateDiagStatus(aScrDtlID,aScreenIDs)
				If ((+SetIsActFlag=3)&&(InfRepPosID'="")){
					Set Flag=##class(DHCHAI.IR.INFDiagnos).UpdateActive(InfRepPosID,"0")
				}
			}
		} Else {
			Set ErrCnt=ErrCnt+1 //错误记录数
		} 		
	}
	
	If ErrCnt>0 {
		Set return=-1
	} Else {
		Set return=1  
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-03-27
/// Description:  取消确诊把关联的感染诊断记录状态置为无效 
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreenLog
/// Input：       aScrDtlID   
/// Return：      返回String   1:诊断已上报，存在有效的院感报告，需先作废报告才能取消确诊
///                            2:患者其他筛查指标关联该条诊断记录，不能把诊断记录置为无效
///                            0:不需要处理
///                            3:需要处理诊断信息有效性
/// w ##class(DHCHAI.IRS.CCScreeningSrv).UpdateDiagStatus("1||1",",1")
ClassMethod UpdateDiagStatus(aScrDtlID As %String, aScreenIDs As %String) As %String
{
	New (aScrDtlID,aScreenIDs)
	Set return="0"
	Quit:(aScrDtlID="")||(aScreenIDs="") return
	
	Set aScreenID = $p(aScrDtlID,"||",1)
	Set aScreenIDs=aScreenIDs_","
 	Set aDtlSubID = $p(aScrDtlID,"||",2)
 	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(aScreenID)
	Quit:'$IsObject(objScreen) return
	Quit:'$IsObject(objScreen.CSEpisodeDr) return
	Quit:'$IsObject(objScreen.CSItmScreenDr) return
	
   	Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(aScrDtlID)
	Quit:'$IsObject(objScreenDtl) return
	Set InfDiagID=""
	If $IsObject(objScreenDtl.CSInfRepPosDr) {
  		Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	
	}
	Quit:InfDiagID="" return  // 无确诊诊断
	// 1,判断诊断是否上报
	Set InfFlag=0
	Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagID)
	If (arrInfRep.Count()>0){
		For indIR=1:1:arrInfRep.Count() {
			Quit:InfFlag=1
			Set objInfRep=arrInfRep.GetAt(indIR)
			Continue:'$IsObject(objInfRep)
			Set InfRepType=objInfRep.IRRepType
			Continue:(InfRepType'=1)   //感染报告 
			Set ReportID=objInfRep.%Id()
			Set ReportStatusCode=""
			If $IsObject(objInfRep.IRStatusDr) {
				Set ReportStatusID=objInfRep.IRStatusDr.%Id()
				Set ReportStatusCode=objInfRep.IRStatusDr.BTCode
				Set ReportStatusDesc=objInfRep.IRStatusDr.BTDesc
			}
			Continue:ReportStatusCode=4   // 过滤删除的报告
			Set InfFlag=1   // 诊断已上报，存在有效的院感报告，需先作废报告才能取消确诊
		}
	}
	Quit:InfFlag=1 "1"
	// 2,判断患者其他筛查指标是否关联该条诊断记录，如果有一个关联是则不能把诊断记录置为无效
	Set InfRepPosID="",CSStatus=""	
	For xind=1:1:$l(aScreenIDs,",") {
		Quit:InfRepPosID'=""
		Set ScreenID=$p(aScreenIDs,",",xind)
		Continue:ScreenID=""
		Continue:ScreenID=aScreenID
		Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(ScreenID)
		Continue:'$IsObject(objScreen) 
		Continue:'$IsObject(objScreen.CSEpisodeDr)
		Continue:'$IsObject(objScreen.CSItmScreenDr)
		
		Set xSubID = ""
	   	For {
	   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(ScreenID,"Dtl",xSubID))
	   		Quit:xSubID=""
	   		
	   		Set xID =ScreenID_"||"_xSubID
	   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
	   		Set CSStatus=objScreenDtl.CSStatus
			If $IsObject(objScreenDtl.CSInfRepPosDr) {
		  		Set InfRepPosID=objScreenDtl.CSInfRepPosDr.%Id()	
			}
	   	}
	}
	Quit:CSStatus=2 "3"  // 记录处置状态为无效，需处理诊断状态
	Quit:InfRepPosID'="" "2"
	
	Quit "3"
}

/// Creator：     zhoubo
/// CreatDate：   2020-03-27
/// Description:  判断诊断是否上报 
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreenLog
/// Input：       aScreenID    DHCHAI.IR.CCScreening--->ID
/// Return：      返回String   1:已上报有效报卡
/// w ##class(DHCHAI.IRS.CCScreeningSrv).CheckDiagRep("1")
ClassMethod CheckDiagRep(aScreenID As %String) As %String
{
	New (aScreenID)
	Set return=""
	Quit:(aScreenID="") return
	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(aScreenID)
	Quit:'$IsObject(objScreen) return
	Quit:'$IsObject(objScreen.CSEpisodeDr) return
	Quit:'$IsObject(objScreen.CSItmScreenDr) return
	
	Set xSubID = ""
   	For {
   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(aScreenID,"Dtl",xSubID))
   		Quit:xSubID=""
   		
   		Set xID =aScreenID_"||"_xSubID
   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
		Set InfDiagID=""
		If $IsObject(objScreenDtl.CSInfRepPosDr) {
	  		Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	
		}
		Continue:InfDiagID=""
		Set InfFlag=""
		Set arrInfRep=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagID)
		If (arrInfRep.Count()>0){
			For indIR=1:1:arrInfRep.Count() {
				Quit:InfFlag=1
				Set objInfRep=arrInfRep.GetAt(indIR)
				Continue:'$IsObject(objInfRep)
				Set InfRepType=objInfRep.IRRepType
				Continue:(InfRepType'=1) //感染报告 
				Set ReportID=objInfRep.%Id()
				Set ReportStatusCode=""
				If $IsObject(objInfRep.IRStatusDr) {
					Set ReportStatusID=objInfRep.IRStatusDr.%Id()
					Set ReportStatusCode=objInfRep.IRStatusDr.BTCode
					Set ReportStatusDesc=objInfRep.IRStatusDr.BTDesc
				}
				Continue:ReportStatusCode=4   // 过滤删除的报告
				Set InfFlag=1   // 诊断已上报，存在有效的院感报告
			}
		}
   	}
	Set:InfFlag'="" return=InfFlag
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-08-08
/// Description:  修改排除、确诊记录（最后一条明细记录）
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreenLog
/// Input：       aScreenID     : DHCHAI.IR.CCScreening.ID
///               aOperCode     : 操作代码(1确诊、2排除)
///               aOperUser     : 操作人
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).UpdateFinalOper("7598","1439","1","8","")
ClassMethod UpdateFinalOper(aScreenID As %String, aInfSuPosID As %String, aOperCode As %String, aOperUser As %String, aOpinionDr As %String = "", aOpinion As %String, aScreenIDs As %String = "", aActType As %String = "") As %String
{
	New (aScreenID,aInfSuPosID,aOperCode,aOperUser,aOpinionDr,aOpinion,aScreenIDs,aActType)
	Set return=0,ErrCnt=0

	Quit:(aOperCode'=1)&(aOperCode'=2) return  //1确诊、2排除
	Quit:(aScreenID="") return
	Quit:(aOperCode=1)&&(aInfSuPosID="") return

   	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(aScreenID)
	Quit:'$IsObject(objScreen) return
	Quit:'$IsObject(objScreen.CSEpisodeDr) return 
	Quit:'$IsObject(objScreen.CSItmScreenDr) return	
   
	Quit:aOperCode=objScreen.CSStatus return
	Set InfSuPosID=""
	If $IsObject(objScreen.CSInfSuPosDr) {
		Set InfSuPosID =objScreen.CSInfSuPosDr.%Id()
	}
   	
   	If ('$d(^DHCHAI.IR.CCScreeningD(aScreenID,"Dtl"))) { //历史疑似病例筛查没有明细信息，先生成一条明细再处理
   		Set ScrDtlInfo=""
    	Set $p(ScrDtlInfo,"^",1)=aScreenID
		Set $p(ScrDtlInfo,"^",2)=""
		Set $p(ScrDtlInfo,"^",3)=objScreen.CSStatus
		Set $p(ScrDtlInfo,"^",4)=objScreen.CSRstToDate  
		Set $p(ScrDtlInfo,"^",5)=InfSuPosID   
		Set $p(ScrDtlInfo,"^",6)="" 
		Set $p(ScrDtlInfo,"^",7)=""
		Set $p(ScrDtlInfo,"^",8)=objScreen.CSActUserDr.%Id()
   		Set flg = ##class(DHCHAI.IR.CCScreenDtl).Update(ScrDtlInfo)
   	} 
  
   	Set xSubID = ""
	Set xSubID=$o(^DHCHAI.IR.CCScreeningD(aScreenID,"Dtl",xSubID),-1)
	Quit:xSubID="" return
    
 	Set ScrDtlID=aScreenID_"||"_xSubID
   	Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(ScrDtlID)
	Quit:'$IsObject(objScreenDtl) return
	Quit:objScreenDtl.CSStatus=aOperCode return      //确诊已排除的项目过滤确诊,排除已确诊过滤排除
   	Set InfRepPosID=""
   	If $IsObject(objScreenDtl.CSInfRepPosDr) {
	  Set InfRepPosID=objScreenDtl.CSInfRepPosDr.%Id()	
   	}
    Set:aOperCode=1 InfRepPosID=aInfSuPosID
    
    Set InputStr=""
	Set $p(InputStr,"^",1)=aScreenID
	Set $p(InputStr,"^",2)=objScreen.CSEpisodeDr.%Id()
	Set $p(InputStr,"^",3)=objScreen.CSItmScreenDr.%Id()
	Set $p(InputStr,"^",4)=objScreen.CSItmScreenTxt
	Set $p(InputStr,"^",5)=aOperCode     //操作/状态（1确认、2排除）
	Set $p(InputStr,"^",6)=InfSuPosID
	Set $p(InputStr,"^",7)=objScreen.CSRstFromDate
	Set $p(InputStr,"^",8)=objScreen.CSRstToDate
	Set $p(InputStr,"^",9)=""
	Set $p(InputStr,"^",10)=""
	Set $p(InputStr,"^",11)=aOperUser
	Set $p(InputStr,"^",12)=aOpinion
	Set $p(InputStr,"^",13)=aOpinionDr
	Set $p(InputStr,"^",14)=aActType
		
	Set ScrDtlInfo=""
	Set $p(ScrDtlInfo,"^",1)=aScreenID
	Set $p(ScrDtlInfo,"^",2)=xSubID
	Set $p(ScrDtlInfo,"^",3)=aOperCode
	Set $p(ScrDtlInfo,"^",4)=objScreenDtl.CSRstDate  
	Set $p(ScrDtlInfo,"^",5)=InfRepPosID   
	Set $p(ScrDtlInfo,"^",6)="" 
	Set $p(ScrDtlInfo,"^",7)=""
	Set $p(ScrDtlInfo,"^",8)=aOperUser
   
    Set flg=##class(DHCHAI.IR.CCScreening).Update(InputStr)
	If (+flg>0) {
		Set Dtl=##class(DHCHAI.IR.CCScreenDtl).Update(ScrDtlInfo)
		If (+Dtl<1) {
			Set ErrCnt=ErrCnt+1 //错误记录数
		}Else{
			If (aOperCode=2){
				Set SetIsActFlag=..UpdateDiagStatus(ScrDtlID,aScreenIDs)
				If ((+SetIsActFlag=3)&&(InfRepPosID'="")){
					Set Flag=##class(DHCHAI.IR.INFDiagnos).UpdateActive(InfRepPosID,"0")
				}
			}
		}
	} Else {
		Set ErrCnt=ErrCnt+1 //错误记录数
	} 		

	If ErrCnt>0 {
		Set return=-1
	} Else {
		Set return=1  
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-08-02
/// Description:  根据筛查结果ID筛查确诊、排除明细
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl
/// Input：       aEpisodeID : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryScreenDtl","6","1")
Query QryScreenDtl(aScreenIDs As %String, aStatus As %String) As %Query(ROWSPEC = "ScreenID:%String,ScrDtlID:%String,EpisodeID:%String,ItmScreenID:%String,ItmScreenDesc:%String,ItmScreenTxt:%String,Status:%String,RstDate:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUserDesc:%String,InfDiagID:%String,InfType:%String,InfTypeDesc:%String,InfDate:%String,InfRepPosID:%String,InfRepPos:%String") [ SqlProc ]
{
}

ClassMethod QryScreenDtlExecute(ByRef qHandle As %Binary, aScreenIDs As %String, aStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aScreenIDs="")||(aStatus="") $$$OK	
 	For indS=1:1:$l(aScreenIDs,",") {
	 	Set aScreenID = $p(aScreenIDs,",",indS)
	 	Continue:aScreenID=""
	   	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(aScreenID)
		Continue:'$IsObject(objScreen) 
		Continue:aStatus'=objScreen.CSStatus
		Continue:'$IsObject(objScreen.CSItmScreenDr) 
		Continue:'$IsObject(objScreen.CSEpisodeDr) 
		Set EpisodeID=objScreen.CSEpisodeDr.%Id()
		Set ItmScreenID = objScreen.CSItmScreenDr.%Id()
		Set ItmScreenDesc =  objScreen.CSItmScreenDr.CCDesc
		Set ItmScreenTxt = objScreen.CSItmScreenTxt
			
	   	Set xSubID = ""
	   	For {
	   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(aScreenID,"Dtl",xSubID))
	   		Quit:xSubID=""
	   		
	   		Set xID =aScreenID_"||"_xSubID
	   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
			Continue:'$IsObject(objScreenDtl)
			
			Set Status = objScreenDtl.CSStatus
			Continue:Status'=aStatus
			Set Status = $s(Status=1:"确诊",Status=2:"排除",1:"")
			
			Set RstDate   = objScreenDtl.CSRstDate
			Set:RstDate'="" RstDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RstDate)
		   	Set ActDate   = objScreenDtl.CSActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime   = objScreenDtl.CSActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set (ActUserCode,ActUserDesc) = ""
			If $IsObject(objScreenDtl.CSActUserDr) {
				Set ActUserCode = objScreenDtl.CSActUserDr.BTCode
				Set ActUserDesc = objScreenDtl.CSActUserDr.BTDesc
			}			
			Set (InfDiagID,InfType,InfTypeDesc,InfDate,InfRepPosID,InfRepPos)=""
			If $IsObject(objScreenDtl.CSInfRepPosDr) {
				Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	     
				Set InfType =objScreenDtl.CSInfRepPosDr.IRInfType
				Set InfTypeDesc = $s(InfType=1:"医院感染",InfType=0:"社区感染",1:"医院感染")
				Set InfDate =objScreenDtl.CSInfRepPosDr.IRInfDate
				Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
	  
				If $IsObject(objScreenDtl.CSInfRepPosDr.IRInfPosDr) {
					Set InfRepPosID=objScreenDtl.CSInfRepPosDr.IRInfPosDr.%Id()
					Set InfRepPos=objScreenDtl.CSInfRepPosDr.IRInfPosDr.BTDesc   //项目确诊感染部位描述
					Set InfSubPos=""
					If $IsObject(objScreenDtl.CSInfRepPosDr.IRInfSubDr){
						Set InfSubPos=objScreenDtl.CSInfRepPosDr.IRInfSubDr.BTDesc
					}
					Set InfRepPos=$s(InfSubPos'="":InfSubPos,1:InfRepPos)

				}
			}
			
			Set Data=$lb(aScreenID,xID,EpisodeID,ItmScreenID,ItmScreenDesc,ItmScreenTxt,Status,RstDate,ActDate,ActTime,ActUserCode,ActUserDesc,InfDiagID,InfType,InfTypeDesc,InfDate,InfRepPosID,InfRepPos)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1			
		}
 	}
	Quit $$$OK
}

ClassMethod QryScreenDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryScreenDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenDtlExecute ]
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
/// CreatDate：   2019-07-06
/// Description:  根据就诊号查找感染报告（主动上报记录、确诊上报后排除的，非确诊上报的）
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFDiagnos、DHCHAI.IR.CCScreening
/// Input：       aEpisodeID : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QrySuRuleReport","121")
Query QrySuRuleReport(aEpisodeID As %String) As %Query(ROWSPEC = "InfReportID:%String,ItmScreenID:%String,ItmScreenTxt:%String,ResultNote:%String,ResultDates:%String,ResultCount:%String,RstStatus:%String,IsFever:%String,IsTSAb:%String,IsOEUC:%String,IsOEVAP:%String,IsOEPICC:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	

 	Quit:(aEpisodeID="") $$$OK
 	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) $$$OK

    Set arrAdmFeverDates=..GetAdmFeverDates(aEpisodeID)       //取发热日期列表
 	Set arrAdmTSAbDates=..GetAdmTSAbDates(aEpisodeID)         //取血常规异常日期列表
 	Set arrAdmOEIntuDates=..GetAdmOEIntuDates(aEpisodeID)     //取器械相关治疗日期列表
 	
	//主动上报的数据感染信息与DHCHAI.IR.CCScreenDtl的CSInfRepPosDr不对应
	Set xRepType = ""
	For {
		Quit:'$d(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID))
		Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
		Quit:xRepType=""
		Continue:(xRepType'=1)
		
	    Set xReportID = ""
		For {
			Set xReportID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xReportID))
			Quit:xReportID=""
			
			Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xReportID)
			Continue:'$IsObject(objRep)	
			Set RepDate  = objRep.IRRepDate
			Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			Set RepTime  = objRep.IRRepTime
			Set:RepTime'="" RepTime=$zt(RepTime)
			Set objStatus  = objRep.IRStatusDr
			Set (RepStatusID,RepStatus,RepStatusCode)=""
			If $IsObject(objStatus){
				Set RepStatusID = objStatus.%Id()
				Set RepStatus = objStatus.BTDesc
				Set RepStatusCode  = objStatus.BTCode
			}
			
			Set LinkDiagID = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		    Continue:LinkDiagID=""
		    
		    Set InfDiagID="",RepFlg=0
		    Set xScreenID=""
		   	For {
			   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
			   	Quit:xScreenID=""
			   	Set xSubID = ""
			   	For {
			   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
			   		Quit:xSubID=""
			   		
			   		Set xID =xScreenID_"||"_xSubID
			   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
					Continue:'$IsObject(objScreenDtl)
					Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
					Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	      //项目确诊感染诊断信息ID
					Continue:InfDiagID'=LinkDiagID                         //确诊上报的报告不需显示
					Set RepFlg=1
			   	}
			   Continue:RepFlg=1
			   
		   	}
		   	Continue:RepFlg=1 
		    Set objINFDiagnos = ##class(DHCHAI.IR.INFDiagnos).GetObjById(LinkDiagID)
			Continue:'$IsObject(objINFDiagnos) 
	
			Set objInfPos = objINFDiagnos.IRInfPosDr
			Set (InfPosID,InfPos)=""
			If $IsObject(objInfPos){
				Set InfPosID = objInfPos.%Id()
				Set InfPos = objInfPos.BTDesc
			}
			Set objInfSub = objINFDiagnos.IRInfSubDr
			Set (InfSubID,InfSub)=""
			If $IsObject(objInfSub){
				Set InfSubID = objInfSub.%Id()
				Set InfSub = objInfSub.BTDesc
			}
			Set InfDate = objINFDiagnos.IRInfDate
			Set RstFromDate=InfDate
			Set:InfDate'="" InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			Set InfXDate = objINFDiagnos.IRInfXDate
			Set:InfXDate'="" InfXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
			Set InfType = objINFDiagnos.IRInfType
			Set InfTypeDesc = $s(InfType=1:"医院感染",InfType=0:"社区感染",1:"医院感染")
	        
	        Set ItmScreenTxt="自报感染"
	        Set ResultNote="报告诊断->"_InfPos_"("_InfDate_")"
	        Set ResultCount=1
	        Set RstStatus = 1
	        
	        Set (IsFever,IsTSAb,IsOEUC,IsOEVAP,IsOEPICC)=0
			For indDatex=(RstFromDate-3):1:(RstFromDate+3) {  //感染前后3天是否有发热、血常规异常
				Set Times=arrAdmFeverDates.GetAt(indDatex)
				If (+Times)>0 {
					Set IsFever=1
				}
				
				Set Times=arrAdmTSAbDates.GetAt(indDatex)
				If (+Times)>0 {
					Set IsTSAb=1
				}
			}
			For indDatey=(RstFromDate-7):1:RstFromDate {  //感染前7天是否使用器械相关医嘱	
				Set Times=arrAdmOEIntuDates.GetAt(indDatey_":导尿管")
				If (+Times)>0 {
					Set IsOEUC=1
				}
				Set Times=arrAdmOEIntuDates.GetAt(indDatey_":呼吸机")
				If (+Times)>0 {
					Set IsOEVAP=1
				}
				Set Times=arrAdmOEIntuDates.GetAt(indDatey_":中心静脉置管")
				If (+Times)>0 {
					Set IsOEPICC=1
				}
			}	
		
			Set Data=$lb(xReportID,"",ItmScreenTxt,ResultNote,InfDate,InfType,InfTypeDesc,ResultCount,RstStatus,IsFever,IsTSAb,IsOEUC,IsOEVAP,IsOEPICC)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}		
 
	Quit $$$OK
}

ClassMethod QrySuRuleReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleReportExecute ]
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
/// CreatDate：   2019-06-25
/// Description:  疑似病例筛查病人列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocID    : 科室ID
/// 			  aIsInf    : 是否疑似
/// 			  aPatInfo  : 患者信息
///               aShowType : 展示方式（1：待处理，2：确诊未报，3：需关注，4：已处理，5：报告未审核，：默认全院）
///               aHospIDs  : 医院代码 多值"^"分割
///               aViewFlag : 按科室/病区分组（1科室、2病区）
/// 			  aGroupUser: 科室分组
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QrySuRulePatList","1","","","","","","1")
Query QrySuRulePatList(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aIsInf As %String = "", aPatInfo As %String = "", aShowType As %String = "", aHospIDs As %String = "", aViewFlag As %String = "", aGroupUser As %String = "", aCLABSIFlag As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,CurrLoc:%String,CurrBed:%String,VisitStatus:%String,InHospDate:%String,InHospLocID:%String,InHospLocDesc:%String,InLocDate:%String,CurrLocID:%String,CurrLocDesc:%String,FromLocID:%String,FromLocDesc:%String,IsNeedAtt:%String,OutHospDate:%String,SuspendCode:%String,SuspendDesc:%String,AdmDocCode:%String,AdmDocDesc:%String,IsNeedMsg:%String,IsMessage:%String,IsSusInf:%String,LocUnRead:%String,AdminUnRead:%String,NeedRepCnt:%String,IsReport:%String,NeedMsgDesc:%String,NeedMsgExt:%String,SureFlag:%String,OutCnt:%String,MrNo:%String") [ SqlProc ]
{
}

ClassMethod QrySuRulePatListExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aIsInf As %String = "", aPatInfo As %String = "", aShowType As %String = "", aHospIDs As %String = "", aViewFlag As %String = "", aGroupUser As %String = "", aCLABSIFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
  	
    Set aPatName =$p(aPatInfo,"^",1)
    Set aRegNo = $p(aPatInfo,"^",2)
    Set aMrNo = $p(aPatInfo,"^",3)
    Set aBed = $p(aPatInfo,"^",4)
    Set aEpisodeID = $p(aPatInfo,"^",5)
  
    If (aPatName'="")||(aRegNo'="")||(aMrNo'="")||(aEpisodeID'="") {  //按患者查询，可查询转科患者
	  Set aLocID = ""
    }
 	Quit:(aTypeFlag=2)&((aDateFrom="")||(aDateTo="")) $$$OK
 	
 	Kill ^TMP($zn,$j)
 	If (aTypeFlag="")&&(aEpisodeID'="") {  //单个患者查询
	 	Do BuildDataToSuRulePat(aEpisodeID,"","",aCLABSIFlag)
 	}
	If aTypeFlag=1 {
		
		Set xDays=-1
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
					
					Set EpisodeID=xID
					Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
					Do BuildDataToSuRulePat(EpisodeID,aLocID,aTypeFlag,aCLABSIFlag)
				}
			}
		}
	} ElseIf aTypeFlag=2 {
		//2出院病人
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK  //限制查询日期范围15天 31
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime,xID))
						Quit:xID=""	

						Set EpisodeID=xID
						Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
						Do BuildDataToSuRulePat(EpisodeID,aLocID,aTypeFlag,aCLABSIFlag)
					}
				}
			}
		}
	} ElseIf aTypeFlag=4 {
		//4需关注病例
		//Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK //限制查询日期范围15天 31
		Do BuildDataToSuRulePat(aEpisodeID,aLocID,aTypeFlag,aCLABSIFlag)
					
	}
		
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildDataToSuRulePat(aEpisodeID,aLocID,aTypeFlag,aCLABSIFlag)
	Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData=""
	Set EpisodeIDx=$li(PAAdmData,2)
	
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=$li(PAAdmData,19)
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",3)
	} Else {
		set tZY=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp","在院")
		set tCY=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp","出院")
		set tYZY=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp","预住院")
		set tTY=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp","退院")
		set tZF=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp","作废")
		set tOTH=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp","其他")
		Set VisitStatus=$s(VisitStatus="A":tZY,VisitStatus="D":tCY,VisitStatus="P":tYZY,VisitStatus="C":tTY,VisitStatus="U":tZF,1:tOTH)
	}
	If (aCLABSIFlag=1){
		Set arrResult=##class(DHCHAI.IRC.CSResultSrv).CheckPatCLABSI(aEpisodeID,$li(PAAdmData,20),$li(PAAdmData,26))
		Quit:arrResult.Count()<1
	}
	
	Set LocID=$li(PAAdmData,22)
	Quit:LocID=""
	Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
	Set LocDesc=$li(AdmLocData,3)
	Set LocDesc2=$li(AdmLocData,4)
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set WardID=$li(PAAdmData,23)
	//处理虚拟病区的问题
	Set (CurrBedDr,CurrBed,AdmBedData)=""           //床位
	Set CurrBedDr=$li(PAAdmData,25)
	If CurrBedDr'=""{
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(CurrBedDr))
		If AdmBedData'=""{
			Set WardID=$li(AdmBedData,11)
		}
	}
	Quit:WardID=""
	Set AdmWardData=$g(^DHCHAI.BT.LocationD(WardID))
	Set WardDesc=$li(AdmWardData,3)
	Set WardDesc2=$li(AdmWardData,4)
	Set:WardDesc2'="" WardDesc=WardDesc2
	Quit:(aLocID'="")&&(aLocID'=LocID)&(aLocID'=WardID)  //过滤科室、病区
	
	If aViewFlag=1 {
		Set ViewType="E"  //按科室显示
		Set CurrLocID=LocID
		Set HospID=$li(AdmLocData,8)
		Quit:HospID=""
	} Else {
		Set ViewType="W"  //按按病区显示
		Set CurrLocID=WardID
		Set HospID=$li(AdmWardData,8)
		Quit:HospID=""
	}
	Set HospData = $g(^DHCHAI.BT.HospitalD(HospID))
	Set HospDesc=$li(HospData,3)
	Set HospDesc2=$li(HospData,4)
	Set:HospDesc2'="" HospDesc=HospDesc2
	Quit:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
    
    If (aGroupUser'="")&&(aGroupUser'="全部工作组") {
	    Set DicTypeID=$o(^DHCHAI.BT.DicTypeI("IdxofCode","CCLocGroupType",0))
		Quit:DicTypeID="" 
	    Set GrpTypeDr=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrDesc",DicTypeID,"疑似筛查工作分组",0))
		Quit:GrpTypeDr="" 
		Set LocGrpUser="其他科"
		Set xGroupID=""
		For {
			Set xGroupID=$o(^DHCHAI.IR.CCLocGroupI("IndexLocType",CurrLocID,GrpTypeDr,xGroupID))
			Quit:xGroupID=""
			
        	Set GroupInfo = $g(^DHCHAI.IR.CCLocGroupD(xGroupID))
        	Continue:GroupInfo=""
    		Set LocGrpUser =$lg(GroupInfo,4)
    		Continue:(LocGrpUser'=aGroupUser)	
    	}
    }
	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
	Quit:(aIsInf'="")&&(aIsInf'=IsSusInf)
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
	Set SureFlag=""
	If (IsSuspend=1){
		Set SureFlag=2 // 确诊
		Set IsSure=..GetEpisodeStatus(aEpisodeID)
		Set:IsSure=1 SureFlag=1 // 排除
	}
	Set SuspendCode=IsSuspend
	If (IsSusInf'=1)&&(SuspendCode=0) Set SuspendCode=""	  //处理非疑似非处理的患者
	Set:(SuspendCode=2)||(SuspendCode=3) SuspendCode=1        //处理历史升级项目展示
	Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已处理",1:"")
	//多语言 移到js中处理
    //Set SuspendDesc=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp",SuspendDesc)
	Set IsNeedMsg="",NeedMsgDesc="",NeedMsgExt=""
	If (IsNeedAtt=1){
		Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
		Quit:AttID="" 
		Set AttData=$g(^DHCHAI.IR.CCScreenAttD(AttID))
		Quit:AttData="" 
		Set IsNeedMsg=$li(AttData,11)
		Set NeedMsgDr =$p(IsNeedMsg,",",1)
		Set NeedMsgExt=$p(IsNeedMsg,",",2)
		If (NeedMsgDr'=0){
			//多个关注原因
			Set NeedMsgDesc=""
			For xNeedMsgInd=1:1:$l(NeedMsgDr,"|"){
				Set NeedMsgID=$p(NeedMsgDr,"|",xNeedMsgInd)
				
				Set DicMsgData = $g(^DHCHAI.BT.DictionaryD(NeedMsgID))
				Continue:DicMsgData="" 
				Set NeedMsgDesc=NeedMsgDesc_","_$lg(DicMsgData,3)
			}
			Set:NeedMsgDesc'="" NeedMsgDesc=$e(NeedMsgDesc,2,$l(NeedMsgDesc))
		}else {
			Set NeedMsgDr=""
			Set NeedMsgExt =$p(IsNeedMsg,",",1)
		}
	}
    
	Set PapmiNo=$li(PAAdmData,4)     //登记号
	Set MrNo=$li(PAAdmData,5)        //病案号
	Set PatName=$li(PAAdmData,6)     //姓名
	Quit:(aRegNo'="")&&(aRegNo'=PapmiNo)
	Quit:(aMrNo'="")&&(aMrNo'=MrNo)
	Quit:(aPatName'="")&&(aPatName'=PatName)
	Set Sex=$li(PAAdmData,7)             //性别
	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
	//多语言
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
	Set Birthday=$li(PAAdmData,9)   //出生日期
	Set Age=$li(PAAdmData,37)             //年龄
	//多语言
	Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
	Set:Age["月" Age=$Replace(Age,"月",##class(websys.Translation).Get("Bill.Com.Age","月"))
	Set:Age["天" Age=$Replace(Age,"天",##class(websys.Translation).Get("Bill.Com.Age","天"))
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set AdmDate=$li(PAAdmData,20)     //就诊日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=$li(PAAdmData,21)     //就诊时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set DischDate=$li(PAAdmData,26) //出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set OutHospDate = ""
	If DischDate'=""{
		Set OutHospDate = DischDate
	}
	Set DischTime=$li(PAAdmData,27) //出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set:AdmBedData'="" CurrBed=$li(AdmBedData,3)
	set tBed=##class(websys.Translation).Get("dhcma.hai.ir.patscreening.csp","床")
	Set:CurrBed'[tBed CurrBed=CurrBed_tBed
	Set aBedDesc=aBed
	Set:aBed'[tBed aBedDesc=aBed_tBed
	Quit:(aBed'="")&&(aBedDesc'=CurrBed)
	
	Set PAAdmDoc=$li(PAAdmData,39)
	Set AdmDocCode=$p(PAAdmDoc,"|",2)  //医生工号
	Set AdmDocDesc=$p(PAAdmDoc,"|",3)  //医生姓名
	
	//入院日期、入院科室、入科日期、当前科室、入科来源信息
	Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(aEpisodeID,ViewType)
	Quit:TransLocInfo=""
	Set InHospDate=$p(TransLocInfo,"^",1)
	Set InHospLocID=$p(TransLocInfo,"^",2)
	Set InHospLocDesc=$p(TransLocInfo,"^",3)
	Set InLocDate=$p(TransLocInfo,"^",4)
	Set CurrLocID=$p(TransLocInfo,"^",5)
	Set CurrLocDesc=$p(TransLocInfo,"^",6)
	Set FromLocID=$p(TransLocInfo,"^",7)
	Set FromLocDesc=$p(TransLocInfo,"^",8)
	
	Set:InHospDate'="" InHospDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InHospDate)
	Set:InLocDate'="" InLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InLocDate)
	
	// 获取患者是否存在消息记录、临床未阅读消息、管理科未读消息
	Set MsgInfo=##class(DHCHAI.IRS.CCScreeningSrv).GetMsgInfo(aEpisodeID)
 	Set IsMessage = $p(MsgInfo,"^",1)
	Set LocUnRead = $p(MsgInfo,"^",2)
	Set AdminUnRead = $p(MsgInfo,"^",3)

	//获取患者需上报数量
	Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(aEpisodeID)
	Set ConfCnt = $p(ConfRepCnt,"^",1)
	Set RepCnt = $p(ConfRepCnt,"^",2)
	Set OutCnt = $p(ConfRepCnt,"^",3)
	Set NeedRepCnt=ConfCnt-RepCnt
	Set:NeedRepCnt<0 NeedRepCnt=0
    
    Set IsDealToday =0
    If (SuspendCode=1) {
    	Set IsDealToday = ##class(DHCHAI.IRS.CCScreenLogSrv).IsDealToday(aEpisodeID) //今日处理病例
    }
	Set xRepType = "",IsReport=0,ReportCnt=0,UnCheckCnt=0
	For {
		Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
		Quit:xRepType=""
		
		Continue:(xRepType'=1)
		Set IsReport=1	
	    Set xRepID = ""
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xRepID))
			Quit:xRepID=""
			Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
			Quit:RepData=""
			Set IRStatusDr=$li(RepData,8)
			Set StatusData=$g(^DHCHAI.BT.DictionaryD(IRStatusDr))
			Set RepStatus=$li(StatusData,2)
			Set ReportCnt=ReportCnt+1      //报告数据	
			If (RepStatus="1")||(RepStatus="2") {
				Set UnCheckCnt=UnCheckCnt+1      //报告未审核数据
			}
		}
	}
  
    If (aShowType=1){
		Quit:(IsSusInf'=1)||((SuspendCode=1)&&(IsDealToday'=1))
	}
	If (aShowType=2){
		Quit:(+NeedRepCnt=+0)&&(+OutCnt=+0)
	}
	If (aShowType=3){
		Quit:+IsNeedAtt=+0
	}
	If (aShowType=4){
		Quit:SuspendCode'=1
	}
	If (aShowType=5){
		Quit:UnCheckCnt=0
	}
	//多语言
	Set CurrLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",CurrLocDesc,"User.CTLoc")
	Set InHospLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",InHospLocDesc,"User.CTLoc")
	Set FromLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",FromLocDesc,"User.CTLoc")	
	Set AdmDocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",AdmDocDesc,"User.SSUser")
	Set NeedMsgDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",NeedMsgDesc,"DHCHAI.BT.Dictionary")
 	//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、床号、入院日期、入院科室、入科日期、入科来源、需关注病例、出院日期
 	Set Data=$lb(aEpisodeID,PapmiNo,PatName,Sex,Age,CurrLocDesc,CurrBed,VisitStatus,InHospDate,InHospLocID,InHospLocDesc,InLocDate,CurrLocID,CurrLocDesc,FromLocID,FromLocDesc,IsNeedAtt,OutHospDate,SuspendCode,SuspendDesc,AdmDocCode,AdmDocDesc,IsNeedMsg,IsMessage,IsSusInf,LocUnRead,AdminUnRead,NeedRepCnt,IsReport,NeedMsgDesc,NeedMsgExt,SureFlag,OutCnt,MrNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	Quit
}

ClassMethod QrySuRulePatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRulePatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRulePatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRulePatListExecute ]
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
/// CreatDate：   2019-07-19
/// Description:  获取患者是否存在消息记录、临床未阅读消息、管理科未读消息
/// Table：       DHCHAI.IR.CCMessage
/// Input：       aEpisodeID:就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetMsgInfo("90")
ClassMethod GetMsgInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set IsMessage=0,LocUnRead=0,AdminUnRead=0
	Set:$d(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID)) IsMessage=1
	Set xMsgDate =""
 	For {
	 	Set xMsgDate = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID,xMsgDate))
		Quit:xMsgDate=""
		Set xMsgTime = ""
		For {
			Set xMsgTime = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID,xMsgDate,xMsgTime))
			Quit:xMsgTime=""
		 	Set xMsgID = ""
			For {
				Set xMsgID = $o(^DHCHAI.IR.CCMessageI("IndexPaadmDate",aEpisodeID,xMsgDate,xMsgTime,xMsgID))
				Quit:xMsgID=""
				
				Set objMsg = ##class(DHCHAI.IR.CCMessage).GetObjById(xMsgID)
				Continue:'$Isobject(objMsg)
				Continue:objMsg.CSIsRead=1
				Set MsgType = objMsg.CSMsgType  //1院感、2临床
				If MsgType=1 {    //院感科发送的消息，科室未阅读
					Set LocUnRead=1
					Continue:LocUnRead=1
				}
				If MsgType=2 {     //科室发送的消息，院感未阅读
					Set AdminUnRead=1
					Continue:AdminUnRead=1
				}
			}
		}
 	}
	
	Set return=IsMessage_"^"_LocUnRead_"^"_AdminUnRead
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-07-19
/// Description:  获取患者确诊数量、确诊已报数量
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.INFReport、DHCHAI.IR.INFRepExt
/// Input：       aEpisodeID:就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt("40")
ClassMethod GetConfRepCnt(aEpisodeID As %String) As %String
{
	New (aEpisodeID,aHomeFlag)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set ConfCnt=0,RepCnt=0
	Set InfDiagIDList="",OutDiagIDList=""
	Set xScreenID=""
   	For {
	   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",aEpisodeID,xScreenID))
	   	Quit:xScreenID=""
	   	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
		Continue:'$IsObject(objScreen)
		Set OprStatus=objScreen.CSStatus
		//Continue:OprStatus'=1
		
	   	Set xSubID = ""
	   	For {
	   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
	   		Quit:xSubID=""
	   		
	   		Set xID =xScreenID_"||"_xSubID
	   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
			Continue:'$IsObject(objScreenDtl)
			Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
			Continue:(objScreen.CSStatus'=1)
			Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	       //项目确诊感染诊断信息ID
			Set IRInfType=objScreenDtl.CSInfRepPosDr.IRInfType
			Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
			Continue:IsActive'=1
			If (IRInfType=1)&&($listfind(InfDiagIDList,InfDiagID)<1) {   //院内感染
		 	    Set InfDiagIDList=InfDiagIDList_$lb(InfDiagID)
		 	}
		 	
		 	If (IRInfType'=1)&&($listfind(OutDiagIDList,InfDiagID)<1) {   //社区感染
		 	    Set OutDiagIDList=OutDiagIDList_$lb(InfDiagID)
		 	}
	   	}
   	}
	
   	For indC=1:1:$ll(InfDiagIDList)	 {
	   	Set InfDiagID =$lg(InfDiagIDList,indC) 
	   	Quit:InfDiagID="" 		
		Set ConfCnt=ConfCnt+1	  //确诊数量	
				
		Set xRepType = ""
		For {
			Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
			Quit:xRepType=""
			Continue:(xRepType'=1)
		
		    Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xRepID))
				Quit:xRepID=""			
	
				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:'$IsObject(objReport.IRStatusDr)
				Continue:objReport.IRStatusDr.BTCode=4
						
				Set xRepSubID=""
				For {
					Set xRepSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xRepSubID))
					Quit:xRepSubID=""
					 
			   	 	Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepSubID)
					Continue:'$IsObject(objExt)
					Set ObjectID = objExt.IRObjectID
				   
					Continue:ObjectID'=InfDiagID
					Set RepCnt=RepCnt+1   //报告数量
				}
			}
		}			
   	}	   	
	Set OutCnt=$ll(OutDiagIDList) 
	Set return=ConfCnt_"^"_RepCnt_"^"_OutCnt	
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-03-06
/// Description:  根据就诊号查找需上报感染诊断用于主动上报
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.INFReport、DHCHAI.IR.INFRepExt
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CCScreeningSrv).GetUnRepDiag("5")
ClassMethod GetUnRepDiag(aEpisodeID As %String) As %String
{
	
 	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
    
    Set DiagList =""
	Set xDiagID = ""
	For {
		Set xDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xDiagID))
		Quit:xDiagID=""
		
		Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiag)
		Continue:'$IsObject(objDiag.IRInfPosDr) 
		Set IsActive = objDiag.IRIsActive
		Continue:IsActive'=1
		
		Set IsRep=0
	    Set xRepID=""
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID))
			Quit:xRepID=""
			Quit:IsRep=1
			
			Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.IREpisodeDr)
			Continue:objReport.IREpisodeDr.%Id()'=aEpisodeID
			Continue:(objReport.IRRepType'=1)
			Continue:'$IsObject(objReport.IRStatusDr)
			Continue:objReport.IRStatusDr.BTCode=4
			
			Set xRepSubID=""
			For {
				Set xRepSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xRepSubID))
				Quit:xRepSubID=""
				 
		   	 	Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepSubID)
				Continue:'$IsObject(objExt)
				Set ObjectID = objExt.IRObjectID
			    Continue:ObjectID'=xDiagID    
			    Set IsRep=1
			}
		} 
		Continue:IsRep=1    //已报
		
		Set Bacterias="",ScreenIDs=""
		Set xScreenID=""
	   	For {
		   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID))
		   	Quit:xScreenID=""
		   	
		   	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(objScreen)
			Continue:'$IsObject(objScreen.CSItmScreenDr)
			Set ItmScreenTxt =objScreen.CSItmScreenTxt
		
			Set IsConfirm =0
			Set xSubID=""
	   		For {
		   		Set xSubID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID,xSubID))
		   		Quit:xSubID=""
		   	    Quit:IsConfirm=1
		   		Set xID =xScreenID_"||"_xSubID
		   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
				Continue:'$IsObject(objScreenDtl)
				Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
				Continue:(objScreen.CSStatus'=1)		
				Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
				Continue:IsActive'=1
				Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	       //项目确诊感染诊断信息ID
				Continue:InfDiagID'=xDiagID
				Set IsConfirm =1
	   		}
	   		Continue:IsConfirm=0
	   		Set ScreenIDs=ScreenIDs_","_xScreenID
	   		Set:ItmScreenTxt'="" Bacterias=Bacterias_","_ItmScreenTxt
	   		
	   	}
		Set:ScreenIDs'="" ScreenIDs=$e(ScreenIDs,2,$l(ScreenIDs))
		Set:Bacterias'="" Bacterias=$e(Bacterias,2,$l(Bacterias))
		Continue:ScreenIDs=""
		
	    Set DiagList=DiagList_","_xDiagID
	}
	Set:DiagList'="" DiagList=$e(DiagList,2,$l(DiagList)) 
	Set return = DiagList
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-08-12
/// Description:  根据就诊号查找需上报感染报告的筛查信息
/// Table：       DHCHAI.IR.CCScreening、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.INFReport、DHCHAI.IR.INFRepExt
/// Input：       aEpisodeID : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryUnRepScreen","121")
Query QryUnRepScreen(aEpisodeID As %String) As %Query(ROWSPEC = "DiagID:%String,ScreenIDs:%String,Bacterias:%String") [ SqlProc ]
{
}

ClassMethod QryUnRepScreenExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Quit:(aEpisodeID="") $$$OK
 
	Set xDiagID = ""
	For {
		Set xDiagID = $o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xDiagID))
		Quit:xDiagID=""
		
		Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
		Continue:'$IsObject(objDiag)
		Continue:'$IsObject(objDiag.IRInfPosDr) 
		Set IsActive = objDiag.IRIsActive
		Continue:IsActive'=1
		
		Set IsRep=0
	    Set xRepID=""
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID))
			Quit:xRepID=""
			Quit:IsRep=1
			
			Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.IREpisodeDr)
			Continue:objReport.IREpisodeDr.%Id()'=aEpisodeID
			Continue:(objReport.IRRepType'=1)
			Continue:'$IsObject(objReport.IRStatusDr)
			Continue:objReport.IRStatusDr.BTCode=4
			
			Set xRepSubID=""
			For {
				Set xRepSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xRepSubID))
				Quit:xRepSubID=""
				 
		   	 	Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepSubID)
				Continue:'$IsObject(objExt)
				Set ObjectID = objExt.IRObjectID
			    Continue:ObjectID'=xDiagID    
			    Set IsRep=1
			}
		} 
		Continue:IsRep=1    //已报
	    
	    Set Bacterias="",ScreenIDs=""
		Set xScreenID=""
	   	For {
		   	Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID))
		   	Quit:xScreenID=""
		   	
		   	Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(objScreen)
			Continue:'$IsObject(objScreen.CSItmScreenDr)
			Set ItmScreenTxt =objScreen.CSItmScreenTxt
		    Set:ItmScreenTxt=xScreenID ItmScreenTxt=""  //手工添加感染诊断的
			Set IsConfirm =0
			Set xSubID=""
	   		For {
		   		Set xSubID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID,xSubID))
		   		Quit:xSubID=""
		   	    Quit:IsConfirm=1
		   		Set xID =xScreenID_"||"_xSubID
		   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
				Continue:'$IsObject(objScreenDtl)
				Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
				Continue:(objScreen.CSStatus'=1)		
				Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
				Continue:IsActive'=1
				Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	       //项目确诊感染诊断信息ID
				Continue:InfDiagID'=xDiagID
				Set IsConfirm =1
	   		}
	   		Continue:IsConfirm=0
	   		Set ScreenIDs=ScreenIDs_","_xScreenID
	   		Set:ItmScreenTxt'="" Bacterias=Bacterias_","_ItmScreenTxt
	   		
	   	}
		Set:ScreenIDs'="" ScreenIDs=$e(ScreenIDs,2,$l(ScreenIDs))
		Set:Bacterias'="" Bacterias=$e(Bacterias,2,$l(Bacterias))
		Continue:ScreenIDs=""
		Set Data=$lb(xDiagID,ScreenIDs,Bacterias)	
			
		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}		
 
	Quit $$$OK
}

ClassMethod QryUnRepScreenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnRepScreenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUnRepScreenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnRepScreenExecute ]
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
/// CreatDate：   2019-06-25
/// Description:  疑似病例筛查科室列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aHospIDs  : 医院代码 多值"^"分割
///               aViewFlag : 按科室/病区分组（1科室、2病区）
/// 			  aGroupUser: 科室分组
///               aPatInfo  : 患者信息
///               aLocID    : 科室
///               aShowType : 展示方式（1：待处理，2：确诊未报，3：需关注，4：已处理，5：报告未审核，：默认全院）
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QrySuRuleLocList","1","","","1|2","2","","","","5")
Query QrySuRuleLocList(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aGroupUser As %String = "", aPatInfo As %String = "", aLocID As %String = "", aShowType As %String = "", aCLABSIFlag As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,HospID:%String,HospDesc:%String,InPatientCnt:%String,ScreeningCnt:%String,ScreenProCnt:%String,ScreenLogCnt:%String,ScreenAttCnt:%String,ConfirmCnt:%String,DiagNoRepCnt:%String,LocGrpUser:%String,DealTodayCnt:%String,ReportCnt:%String,UnCheckCnt:%String,DiagOutCnt:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleLocListExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aGroupUser As %String = "", aPatInfo As %String = "", aLocID As %String = "", aShowType As %String = "", aCLABSIFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aTypeFlag'=1)&((aDateFrom="")||(aDateTo="")) $$$OK
 	
 	Set aPatName =$p(aPatInfo,"^",1)
    Set aRegNo = $p(aPatInfo,"^",2)
    Set aMrNo = $p(aPatInfo,"^",3)
    Set aBed = $p(aPatInfo,"^",4)
    
 	Kill ^TMP($zn,$j)
	If aTypeFlag=1 {		
		Set xDays=-1
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
				
					Set EpisodeID=xID
					Do BuildDataToSuRuleLoc(EpisodeID,aHospIDs,aViewFlag,aCLABSIFlag)
				}
			}
		}
	} ElseIf aTypeFlag=2 {
		//2出院病人
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		Quit:(aDateTo-aDateFrom)>31 $$$OK  //限制查询日期范围15天 31
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")&(xAdmType'="EP")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime,xID))
						Quit:xID=""
						
						Set EpisodeID=xID
						Do BuildDataToSuRuleLoc(EpisodeID,aHospIDs,aViewFlag,aCLABSIFlag)
					}
				}
			}
		}
	} 

	Set xHospID=0
	For {
		Set xHospID=$o(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID))
		Quit:xHospID=""
		
		Set xLocID=0
		For {
			Set xLocID=$o(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID))
			Quit:xLocID=""
			
			Set tLoc=$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID))
			Continue:tLoc=""
			Set HospDesc=$listget(tLoc,1)
			Set LocDesc=$listget(tLoc,2)
			Set InPatientCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"InPatientCnt"))  //住院病人
			Set ScreeningCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreeningCnt"))  //疑似病例
			Set ScreenProCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreenProCnt"))  //疑似待处理
			Set ScreenLogCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreenLogCnt"))  //处置病例
			Set ScreenAttCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreenAttCnt"))  //需关注病例
			Set ConfirmCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ConfirmCnt"))      //疑似确诊病例
			Set DiagNoRepCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"DiagNoRepCnt"))  //确诊未报病例
			Set DealTodayCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"DealTodayCnt"))  //今日处理病例			
			Set ReportCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ReportCnt"))        //报告数据
			Set UnCheckCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"UnCheckCnt"))      //报告未审核
			Set DiagOutCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"DiagOutCnt"))      //确诊社区感染人数

			//1：待处理，2：确诊未报，3：需关注，4：已处理，5：报告未审核 ，：默认全院
			If (aShowType=1){
				Continue:(+ScreenProCnt=+0)&&(+DealTodayCnt=0)
			}
			If (aShowType=2){
				Continue:+DiagNoRepCnt=+0
			}
			If (aShowType=3){
				Continue:+ScreenAttCnt=+0
			}
			If (aShowType=4){
				Continue:+ScreenLogCnt=+0
			}
			If (aShowType=5){
				Continue:+UnCheckCnt=+0
			}
			Set LocGrpUser =##class(DHCHAI.IR.CCLocGroup).GetLocGrpByLocType(xLocID,"疑似筛查工作分组")
			Continue:(aGroupUser'="")&&(aGroupUser'="全部工作组")&&(LocGrpUser'=aGroupUser)	
			Set:LocGrpUser'="" LocGrpUser="[分组] "_LocGrpUser
			
			Set Data=$lb(xLocID,LocDesc,xHospID,HospDesc,InPatientCnt,ScreeningCnt,ScreenProCnt,ScreenLogCnt,ScreenAttCnt,ConfirmCnt,DiagNoRepCnt,LocGrpUser,DealTodayCnt,ReportCnt,UnCheckCnt,DiagOutCnt)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildDataToSuRuleLoc(aEpisodeID,aHospIDs,aViewFlag,aCLABSIFlag)
	Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData=""
	Set EpisodeIDx=$li(PAAdmData,2)
	
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=$li(PAAdmData,19)
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	
	If aViewFlag=1 {
		Set LocID=$li(PAAdmData,22)
	} Else {
		Set LocID=$li(PAAdmData,23)
		//处理虚拟病区的问题
		Set AdmBedDr=$li(PAAdmData,25)
		If AdmBedDr'=""{
			Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
			If AdmBedData'=""{
				Set LocID=$li(AdmBedData,11)
			}
		}
	}
	Quit:LocID=""
	If (aCLABSIFlag=1){
		Set arrResult=##class(DHCHAI.IRC.CSResultSrv).CheckPatCLABSI(aEpisodeID,$li(PAAdmData,20),$li(PAAdmData,26))
		Quit:arrResult.Count()<1
	}
	Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
	Quit:(aLocID'="")&&(aLocID'=LocID)
	Set LocDesc=$li(AdmLocData,3)
	Set LocDesc2=$li(AdmLocData,4)
	Set:LocDesc2'="" LocDesc=LocDesc2
	
	Set HospID=$li(AdmLocData,8)
	Quit:HospID=""
	Set HospData = $g(^DHCHAI.BT.HospitalD(HospID))
	Set HospDesc=$li(HospData,3)
	Set HospDesc2=$li(HospData,4)
	Set:HospDesc2'="" HospDesc=HospDesc2
	Quit:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
	
	Set PapmiNo=$li(PAAdmData,4)     //登记号
	Set MrNo=$li(PAAdmData,5)        //病案号
	Set PatName=$li(PAAdmData,6)     //姓名
	Quit:(aRegNo'="")&&(aRegNo'=PapmiNo)
	Quit:(aMrNo'="")&&(aMrNo'=MrNo)
	Quit:(aPatName'="")&&(aPatName'=PatName)
	Set CurrBed="",AdmBedData=""           //床位
	Set AdmBedDr=$li(PAAdmData,25)
	If AdmBedDr'=""{
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
	}
	If AdmBedData'=""{
		Set CurrBed=$li(AdmBedData,3)
		Set:CurrBed'["床" CurrBed=CurrBed_"床"
	}
	Set aBedDesc=aBed
	Set:aBed'["床" aBedDesc=aBed_"床"
	
	Quit:(aBed'="")&&(aBedDesc'=CurrBed)
	Set ^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID)=$lb(HospDesc,LocDesc)       //科室信息
	Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"InPatientCnt"))      //住院病例
	
	Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(aEpisodeID)
	Set ConfCnt = $p(ConfRepCnt,"^",1)
	Set RepCnt = $p(ConfRepCnt,"^",2)
	Set OutCnt = $p(ConfRepCnt,"^",3)  //确诊社区感染人数
    
   	Set xRepType = "",IsReport=0
	For {
		Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
		Quit:xRepType=""
		Continue:(xRepType'=1)	
	    Set xRepID = ""
		For {
			Set xRepID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xRepID))
			Quit:xRepID=""
			Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
			Quit:RepData=""
			Set IRStatusDr=$li(RepData,8)
			Set StatusData=$g(^DHCHAI.BT.DictionaryD(IRStatusDr))
			Set RepStatus=$li(StatusData,2)
			
			Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ReportCnt"))      //报告数据
			If (RepStatus="1")||(RepStatus="2") {
				Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"UnCheckCnt"))      //报告未审核数据
			}
		}
	}
  
	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)  //需关注
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //1 疑似
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //0待处理、1已处理
    Quit:(IsNeedAtt'=1)&&(IsSusInf'=1)
   
    If IsSusInf=1 {//疑似病例
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreeningCnt"))	
		If IsSuspend=0 {   //疑似待处理
			Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreenProCnt"))
		}
		If IsSuspend=1 { //已处理病例
			Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreenLogCnt"))
		} 
	}
	
	Set IsDealToday = ##class(DHCHAI.IRS.CCScreenLogSrv).IsDealToday(aEpisodeID)
	If IsDealToday=1 { //今日处理病例（包括未处理完及手工添加感染诊断）
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"DealTodayCnt"))
	}
			
	If IsNeedAtt=1 {  //需关注
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreenAttCnt"))
	}
	If ConfCnt>0 {  //已确诊
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ConfirmCnt"))
	} 
	If (ConfCnt-RepCnt)>0 {  //确诊未报	
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"DiagNoRepCnt"))
	} 
	If OutCnt>0 {  //社区确诊人数	
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"DiagOutCnt"))
	} 
	Quit
}

ClassMethod QrySuRuleLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleLocListExecute ]
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
/// CreatDate：   2019-07-01
/// Description:  疑似责任患者列表（按确诊日期判断患者所在科室与当前所在科室不一致者）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.PAAdmTrans、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocID    : 科室ID
/// 			  aIsInf    : 是否疑似
/// 			  aPatInfo  : 患者信息
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryDutyPatList","49")
Query QryDutyPatList(aLocID As %String) As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,CurrLoc:%String,CurrBed:%String,VisitStatus:%String,InHospDate:%String,InHospLocID:%String,InHospLocDesc:%String,InLocDate:%String,CurrLocID:%String,CurrLocDesc:%String,FromLocID:%String,FromLocDesc:%String,IsNeedAtt:%String,OutHospDate:%String,SuspendCode:%String,SuspendDesc:%String,AdmDocCode:%String,AdmDocDesc:%String,IsNeedMsg:%String,IsMessage:%String,IsSusInf:%String,LocUnRead:%String,AdminUnRead:%String,NeedRepCnt:%String,IsReport:%String,NeedMsgDesc:%String,NeedMsgExt:%String") [ SqlProc ]
{
}

ClassMethod QryDutyPatListExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aLocID="" $$$OK
 	
 	Kill ^TMP($zn,$j,"QryDutyPatList")
 	
 	Set xActDate = ""
	For {
		Set xActDate=$o(^DHCHAI.IR.CCScreeningI("IndexStatusActDate",1,xActDate))
		Quit:xActDate=""
		
		Set xScreenID = ""
		For {
			Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexStatusActDate",1,xActDate,xScreenID))
			Quit:xScreenID=""
		    
			Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(objScreen)
			Continue:'$IsObject(objScreen.CSEpisodeDr)
			Continue:'$IsObject(objScreen.CSEpisodeDr.PAAdmLocDr)  
			Set EpisodeID = objScreen.CSEpisodeDr.%Id()
			Set objLoc =  objScreen.CSEpisodeDr.PAAdmLocDr
			Set AdmLocID = objLoc.%Id()
			Continue:AdmLocID=aLocID  //当前所在科室为本科室不记入
		   
		    Continue:$d(^TMP($zn,$j,"QryDutyPatList",EpisodeID))
		   
		    Set xSubID = ""  //判断是否确诊已报
		   	For {
		   		Set xSubID=$o(^DHCHAI.IR.CCScreeningD(xScreenID,"Dtl",xSubID))
		   		Quit:xSubID=""
		   		
		   		Set xID =xScreenID_"||"_xSubID
		   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(xID)
				Continue:'$IsObject(objScreenDtl)
				Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
				Set InfDiagID=objScreenDtl.CSInfRepPosDr.%Id()	       //项目确诊感染诊断信息ID
				Continue:objScreenDtl.CSStatus=2
				Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
				Continue:IsActive'=1
				Set InfDate = objScreenDtl.CSInfRepPosDr.IRInfDate
				
				Set InfRep=0
				Set xRepType = ""
		
				Set xRepID=""
				For {
					Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID))
					Quit:xRepID=""
					Quit:InfRep=1
					
					Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
					Continue:'$IsObject(objReport)
					Continue:'$IsObject(objReport.IREpisodeDr)
					Continue:objReport.IREpisodeDr.%Id()'=EpisodeID
					Continue:(objReport.IRRepType'=1)
					Continue:'$IsObject(objReport.IRStatusDr)
					Continue:objReport.IRStatusDr.BTCode=4
			
					Set xRepSubID=""
					For {
						Set xRepSubID=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xRepID,xRepSubID))
						Quit:xRepSubID=""
						 
				   	 	Set objExt = ##class(DHCHAI.IR.INFRepExt).GetObjById(xRepID_"||"_xRepSubID)
						Continue:'$IsObject(objExt)
						Set ObjectID = objExt.IRObjectID
						Continue:ObjectID'=InfDiagID
						Set InfRep=1
					}
				}
				Continue:InfRep=1
				
				Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,InfDate,"00:00:01")  //获取感染当日所在科室（转科当日感染归属如何分？）
				Set TransLoc = $p(TransInfo,"^",1)
				Continue:TransLoc'=aLocID    //感染日所在科室不在查询科室退出
				
				If '$d(^TMP($zn,$j,"QryDutyPatList",EpisodeID)) {
					Set ^TMP($zn,$j,"QryDutyPatList",EpisodeID)=""
					Do BuildDutyPatList(EpisodeID)
				}
		   	}	
		}
	}	
		
 	Kill ^TMP($zn,$j,"QryDutyPatList")
 	
	Quit $$$OK
	
BuildDutyPatList(aEpisodeID)
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode)
	Set EpisodeIDx=objEpisode.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=objEpisode.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",3)
	} Else {
		Set VisitStatus=$s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="P":"预住院",VisitStatus="C":"退院",VisitStatus="U":"作废",1:"其他")
	}
	
	Quit:'$IsObject(objEpisode.PAAdmLocDr)
	Quit:'$IsObject(objEpisode.PAAdmWardDr)
	Set objAdmLoc=objEpisode.PAAdmLocDr
	Set LocID=objAdmLoc.%Id()
	Set LocDesc=objAdmLoc.BTDesc
	Set LocDesc2=objAdmLoc.BTDesc2
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set objAdmWard=objEpisode.PAAdmWardDr
	//处理虚拟病区的问题
	If $IsObject(objEpisode.PAAdmBedDr){
		If $IsObject(objEpisode.PAAdmBedDr.BTXLocDr){
			Set objAdmWard=objEpisode.PAAdmBedDr.BTXLocDr
		}
	}
	Set WardID=objAdmWard.%Id()
	Set WardDesc=objAdmWard.BTDesc
	Set WardDesc2=objAdmWard.BTDesc2
	Set:WardDesc2'="" WardDesc=WardDesc2

	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
	
	Set SuspendCode=IsSuspend
	If (IsSusInf'=1)&&(SuspendCode=0) Set SuspendCode=""	  //处理非疑似非处理的患者
	Set:(SuspendCode=2)||(SuspendCode=3) SuspendCode=1        //处理历史升级项目展示
	Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已处理",1:"")

	Set IsNeedMsg="",NeedMsgDesc="",NeedMsgExt=""
	If (IsNeedAtt=1){
		Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
		Quit:AttID="" return
		Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
		Quit:'$IsObject(objAtt) return
		Set IsNeedMsg=objAtt.CSIsNeedMsg
		Set NeedMsgDr =$p(IsNeedMsg,",",1)
		If (NeedMsgDr'=""){
			 Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(NeedMsgDr)
			 Quit:'$IsObject(objDic) return
			 Set NeedMsgDesc=objDic.BTDesc 
		}
		Set NeedMsgExt =$p(IsNeedMsg,",",2)
	}
   
	Set PapmiNo=objEpisode.PAPapmiNo     //登记号
	Set MrNo=objEpisode.PAMrNo           //病案号
	Set PatName=objEpisode.PAPatName     //姓名
	Set Sex=objEpisode.PASex             //性别
	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Birthday=objEpisode.PABirthday   //出生日期
	Set Age=objEpisode.PAAge             //年龄
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set AdmDate=objEpisode.PAAdmDate     //就诊日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objEpisode.PAAdmTime     //就诊时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set DischDate=objEpisode.PADischDate //出院日期
	If (DischDate'="") {
		Quit:(DischDate+31)<(+$h)        //出院患者只统计出院一个月内的	
	}
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set OutHospDate = ""
	If DischDate'=""{
		Set OutHospDate = DischDate
	}
	Set DischTime=objEpisode.PADischTime //出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set (CurrBedDr,CurrBed)=""           //床位
	If $IsObject(objEpisode.PAAdmBedDr){
		Set CurrBedDr=objEpisode.PAAdmBedDr.%Id()
		Set CurrBed=objEpisode.PAAdmBedDr.BTDesc
		Set:CurrBed'["床" CurrBed=CurrBed_"床"
	}
	
	Set PAAdmDoc=objEpisode.PAAdmDoc
	Set AdmDocCode=$p(PAAdmDoc,"|",2)  //医生工号
	Set AdmDocDesc=$p(PAAdmDoc,"|",3)  //医生姓名
	
	//入院日期、入院科室、入科日期、当前科室、入科来源信息
	Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(aEpisodeID,"E")
	Quit:TransLocInfo=""
	Set InHospDate=$p(TransLocInfo,"^",1)
	Set InHospLocID=$p(TransLocInfo,"^",2)
	Set InHospLocDesc=$p(TransLocInfo,"^",3)
	Set InLocDate=$p(TransLocInfo,"^",4)
	Set CurrLocID=$p(TransLocInfo,"^",5)
	Set CurrLocDesc=$p(TransLocInfo,"^",6)
	Set FromLocID=$p(TransLocInfo,"^",7)
	Set FromLocDesc=$p(TransLocInfo,"^",8)
	
	Set:InHospDate'="" InHospDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InHospDate)
	Set:InLocDate'="" InLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InLocDate)
	
	// 获取患者是否存在消息记录、临床未阅读消息、管理科未读消息
	Set MsgInfo=##class(DHCHAI.IRS.CCScreeningSrv).GetMsgInfo(EpisodeID)
 	Set IsMessage = $p(MsgInfo,"^",1)
	Set LocUnRead = $p(MsgInfo,"^",2)
	Set AdminUnRead = $p(MsgInfo,"^",3)
 	
	//获取患者需上报数量
	Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(EpisodeID)
	Set ConfCnt = $p(ConfRepCnt,"^",1)
	Set RepCnt = $p(ConfRepCnt,"^",2)
	Set NeedRepCnt=ConfCnt-RepCnt
	Set:NeedRepCnt<0 NeedRepCnt=0
	//判断患者是否报告感染报告，包括删除状态，用于需上报列显示红星	
	Set xRepType = "",IsReport=0
	For {
		Quit:'$d(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID))
		Set xRepType = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
		Quit:xRepType=""
		Quit:IsReport=1
		Continue:(xRepType'=1)
		Set IsReport=1
	}	
	
 	//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、床号、入院日期、入院科室、入科日期、入科来源、需关注病例、出院日期
 	Set Data=$lb(EpisodeID,PapmiNo,PatName,Sex,Age,CurrLocDesc,CurrBed,VisitStatus,InHospDate,InHospLocID,InHospLocDesc,InLocDate,CurrLocID,CurrLocDesc,FromLocID,FromLocDesc,IsNeedAtt,OutHospDate,SuspendCode,SuspendDesc,AdmDocCode,AdmDocDesc,IsNeedMsg,IsMessage,IsSusInf,LocUnRead,AdminUnRead,NeedRepCnt,IsReport,NeedMsgDesc,NeedMsgExt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	Quit
}

ClassMethod QryDutyPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDutyPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDutyPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDutyPatListExecute ]
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
/// CreatDate：   2020-01-14
/// Description:  查询确诊未上报病例数（当前在院及出院30天内的确诊未报告患者数）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreenDtl、DHCHAI.IR.CCScreening
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aHospIDs   : 医院
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryInfNoRep","2020-01-01","2020-08-14","1|2")
Query QryInfNoRep(aDateFrom As %String, aDateTo As %String, aHospIDs As %String) As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,CurrLoc:%String,CurrBed:%String,VisitStatus:%String,InHospDate:%String,InHospLocID:%String,InHospLocDesc:%String,InLocDate:%String,CurrLocID:%String,CurrLocDesc:%String,FromLocID:%String,FromLocDesc:%String,IsNeedAtt:%String,OutHospDate:%String,SuspendCode:%String,SuspendDesc:%String,AdmDocCode:%String,AdmDocDesc:%String,IsNeedMsg:%String,IsMessage:%String,IsSusInf:%String,LocUnRead:%String,AdminUnRead:%String,NeedRepCnt:%String,NeedMsgDesc:%String,NeedMsgExt:%String") [ SqlProc ]
{
}

ClassMethod QryInfNoRepExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
 	Set QryDate=##class(DHCHAI.BT.Config).GetValByCode("UnRepIntervalDate")
 	Set:QryDate="" QryDate=30
	Set:aDateFrom="" aDateFrom=+$h-(+QryDate)
	Set:aDateTo="" aDateTo=+$h
	
 	Kill ^TMP($zn,$j,"QryInfNoRep")
 	
 	Set xDiagID=""
	For {
		Set xDiagID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID))
		Quit:xDiagID=""
		
		Set xScreenID=""
		For {
			Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID))
			Quit:xScreenID=""
			
			Set objScreen=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(objScreen)
			Continue:'$IsObject(objScreen.CSItmScreenDr)
			Continue:'$IsObject(objScreen.CSEpisodeDr)

			Set IsConfirm =0	
			Set xSubID=""
			For {
				Set xSubID=$o(^DHCHAI.IR.CCScreeningI("Dtl","IndexInfRepPosDr",xDiagID,xScreenID,xSubID))
				Quit:xSubID=""
			    Quit:IsConfirm=1
			    Set DtlID = xScreenID_"||"_xSubID
			    
		   		Set objScreenDtl=##class(DHCHAI.IR.CCScreenDtl).GetObjById(DtlID)
				Continue:'$IsObject(objScreenDtl)
				Continue:'$IsObject(objScreenDtl.CSInfRepPosDr)
				Continue:(objScreen.CSStatus'=1)	   //只筛查确诊条目	
				Set IsActive = objScreenDtl.CSInfRepPosDr.IRIsActive
				Continue:IsActive'=1
				Set IsConfirm =1
			}
		    Continue:IsConfirm=0  //未确诊
		   
		    Set IsRep=0
		    Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt("DHCHAI.IR.INFDiagnos","U")," "_xDiagID,xRepID))
				Quit:xRepID=""
				Quit:IsRep=1
				
				Set objReport = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				Continue:'$IsObject(objReport)
				Continue:'$IsObject(objReport.IREpisodeDr)
				Continue:(objReport.IRRepType'=1)
				Continue:'$IsObject(objReport.IRStatusDr)
				Continue:objReport.IRStatusDr.BTCode=4
				Set IsRep=1
			} 
			Continue:IsRep=1    //已报
		
			Set EpisodeID =objScreen.CSEpisodeDr.%Id()		
			Continue:$d(^TMP($zn,$j,"QryInfNoRep",EpisodeID))  
			Set ^TMP($zn,$j,"QryInfNoRep",EpisodeID)=""
		    
			Set EpisodeIDx=objScreen.CSEpisodeDr.PAEpisodeIDx
			Set AdmDate=objScreen.CSEpisodeDr.PAAdmDate
			Set DischDate=objScreen.CSEpisodeDr.PADischDate
			Continue:(DischDate'="")&&(DischDate<aDateFrom)   //查询日期限制
			Continue:(DischDate'="")&&(DischDate>aDateTo)   //查询日期限制
			Continue:(AdmDate>aDateTo)   //查询日期限制
		
			Do BuildPatList(EpisodeID)

		}
	}	
		
 	Kill ^TMP($zn,$j,"QryInfNoRep")
 	
	Quit $$$OK
	
BuildPatList(aEpisodeID)
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode)
	Set EpisodeIDx=objEpisode.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=objEpisode.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",3)
	} Else {
		Set VisitStatus=$s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="P":"预住院",VisitStatus="C":"退院",VisitStatus="U":"作废",1:"其他")
	}
	
	Quit:'$IsObject(objEpisode.PAAdmLocDr)
	Quit:'$IsObject(objEpisode.PAAdmWardDr)
	Set objAdmLoc=objEpisode.PAAdmLocDr
	Set LocID=objAdmLoc.%Id()
	Set LocDesc=objAdmLoc.BTDesc
	Set LocDesc2=objAdmLoc.BTDesc2
	Set:LocDesc2'="" LocDesc=LocDesc2
	
    Quit:'$IsObject(objAdmLoc.BTHospDr)
	Set HospID=objAdmLoc.BTHospDr.%Id()
	Set HospDesc=objAdmLoc.BTHospDr.BTDesc
	Set HospDesc2=objAdmLoc.BTHospDr.BTDesc2
	Set:HospDesc2'="" HospDesc=HospDesc2
	Quit:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
	
	Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(aEpisodeID)
	Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
	Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
	Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
	
	Set SuspendCode=IsSuspend
	If (IsSusInf'=1)&&(SuspendCode=0) Set SuspendCode=""	  //处理非疑似非处理的患者
	Set:(SuspendCode=2)||(SuspendCode=3) SuspendCode=1        //处理历史升级项目展示
	Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已处理",1:"")

	Set IsNeedMsg="",NeedMsgDesc="",NeedMsgExt=""
	If (IsNeedAtt=1){
		Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
		Quit:AttID="" 
		Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
		Quit:AttID="" 
		Set AttData=$g(^DHCHAI.IR.CCScreenAttD(AttID))
		Quit:AttData="" 
		Set IsNeedMsg=$li(AttData,11)
		Set NeedMsgDr =$p(IsNeedMsg,",",1)
		If (NeedMsgDr'=""){
			Set DicMsgData = $g(^DHCHAI.BT.DictionaryD(NeedMsgDr))
			 Quit:DicMsgData=""
			 Set NeedMsgDesc=$li(DicMsgData,3)
		}
		Set NeedMsgExt =$p(IsNeedMsg,",",2)
	}
	Set PapmiNo=objEpisode.PAPapmiNo     //登记号
	Set MrNo=objEpisode.PAMrNo           //病案号
	Set PatName=objEpisode.PAPatName     //姓名
	Set Sex=objEpisode.PASex             //性别
	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Birthday=objEpisode.PABirthday   //出生日期
	Set Age=objEpisode.PAAge             //年龄
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set AdmDate=objEpisode.PAAdmDate     //就诊日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objEpisode.PAAdmTime     //就诊时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set DischDate=objEpisode.PADischDate //出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set OutHospDate = ""
	If DischDate'=""{
		Set OutHospDate = DischDate
	}
	Set DischTime=objEpisode.PADischTime //出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set (CurrBedDr,CurrBed)=""           //床位
	If $IsObject(objEpisode.PAAdmBedDr){
		Set CurrBedDr=objEpisode.PAAdmBedDr.%Id()
		Set CurrBed=objEpisode.PAAdmBedDr.BTDesc
		Set:CurrBed'["床" CurrBed=CurrBed_"床"
	}
	
	Set PAAdmDoc=objEpisode.PAAdmDoc
	Set AdmDocCode=$p(PAAdmDoc,"|",2)  //医生工号
	Set AdmDocDesc=$p(PAAdmDoc,"|",3)  //医生姓名
	
	//入院日期、入院科室、入科日期、当前科室、入科来源信息
	Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(aEpisodeID,"E")
	Quit:TransLocInfo=""
	Set InHospDate=$p(TransLocInfo,"^",1)
	Set InHospLocID=$p(TransLocInfo,"^",2)
	Set InHospLocDesc=$p(TransLocInfo,"^",3)
	Set InLocDate=$p(TransLocInfo,"^",4)
	Set CurrLocID=$p(TransLocInfo,"^",5)
	Set CurrLocDesc=$p(TransLocInfo,"^",6)
	Set FromLocID=$p(TransLocInfo,"^",7)
	Set FromLocDesc=$p(TransLocInfo,"^",8)
	
	Set:InHospDate'="" InHospDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InHospDate)
	Set:InLocDate'="" InLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InLocDate)
	
	// 获取患者是否存在消息记录、临床未阅读消息、管理科未读消息
	Set MsgInfo=##class(DHCHAI.IRS.CCScreeningSrv).GetMsgInfo(EpisodeID)
 	Set IsMessage = $p(MsgInfo,"^",1)
	Set LocUnRead = $p(MsgInfo,"^",2)
	Set AdminUnRead = $p(MsgInfo,"^",3)
 	
	//获取患者需上报数量
	Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(EpisodeID)
	Set ConfCnt = $p(ConfRepCnt,"^",1)
	Set RepCnt = $p(ConfRepCnt,"^",2)
	Set NeedRepCnt=ConfCnt-RepCnt
	Set:NeedRepCnt<0 NeedRepCnt=0
	Quit:NeedRepCnt=0   //只显示需报告院感报告数据
	
 	//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、床号、入院日期、入院科室、入科日期、入科来源、需关注病例、出院日期
 	Set Data=$lb(EpisodeID,PapmiNo,MrNo,PatName,Sex,Age,CurrLocDesc,CurrBed,VisitStatus,InHospDate,InHospLocID,InHospLocDesc,InLocDate,CurrLocID,CurrLocDesc,FromLocID,FromLocDesc,IsNeedAtt,OutHospDate,SuspendCode,SuspendDesc,AdmDocCode,AdmDocDesc,IsNeedMsg,IsMessage,IsSusInf,LocUnRead,AdminUnRead,NeedRepCnt,NeedMsgDesc,NeedMsgExt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	Quit
}

ClassMethod QryInfNoRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfNoRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfNoRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfNoRepExecute ]
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
/// CreatDate：   2020-10-26
/// Description:  疑似病例筛查病人信息导出
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocID    : 科室ID
/// 			  aIsInf    : 是否疑似
/// 			  aPatInfo  : 患者信息
///               aShowType : 展示方式（1：待处理，2：确诊未报，3：需关注，4：已处理，5：报告未审核，：默认全院）
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreeningSrv","QryScreenAllInfo","1","","","1|2|3|4|5","2","","^^^","","1")
Query QryScreenAllInfo(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aGroupUser As %String = "", aPatInfo As %String = "", aLocID As %String = "", aShowType As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,CurrLoc:%String,CurrBed:%String,VisitStatus:%String,InHospDate:%String,InLocDate:%String,CurrLocID:%String,CurrLocDesc:%String,OutHospDate:%String,IsReport:%String,NeedMsgDesc:%String,NeedMsgExt:%String,ResultNotes:%String") [ SqlProc ]
{
}

ClassMethod QryScreenAllInfoExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aGroupUser As %String = "", aPatInfo As %String = "", aLocID As %String = "", aShowType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ScreenArray=..GetScreenAllInfo(aTypeFlag,aDateFrom,aDateTo,aHospIDs,aViewFlag,aGroupUser,aPatInfo,aLocID,aShowType)
 	Set ScreenCount=ScreenArray.Count()
 	Quit:ScreenCount=0 $$$OK
 	
 	For ScreenInd=1:1:ScreenCount {
		Set ScreenInfo = ScreenArray.GetAt(ScreenInd)
		Continue:ScreenInfo=""
		
		Set Data=ScreenInfo
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryScreenAllInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryScreenAllInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryScreenAllInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryScreenAllInfoExecute ]
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
/// CreatDate：   2020-10-26
/// Description:  疑似病例筛查病人信息导出
/// Return：      返回ROWSPEC
/// zw ##class(DHCHAI.IRS.CCScreeningSrv).GetScreenAllInfo("1","","","1|2|3|4|5","2","","^^^","","1")
ClassMethod GetScreenAllInfo(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aGroupUser As %String = "", aPatInfo As %String = "", aLocID As %String = "", aShowType As %String = "") As %ArrayOfDataTypes
{
	New (aTypeFlag,aDateFrom,aDateTo,aHospIDs,aViewFlag,aGroupUser,aPatInfo,aLocID,aShowType)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Set xCount=0
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.IRS.CCScreeningSrv:QrySuRuleLocList")
  	Set sc=rs.Execute(aTypeFlag,aDateFrom,aDateTo,aHospIDs,aViewFlag,aGroupUser,aPatInfo,aLocID,aShowType)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
    While (rs.Next()){
		Set xLocID = rs.Data("LocID")
		
		Set rs2=##Class(%ResultSet).%New("DHCHAI.IRS.CCScreeningSrv:QrySuRulePatList")
	  	Set sc2=rs2.Execute(aTypeFlag,aDateFrom,aDateTo,xLocID,"",aPatInfo,aShowType,aHospIDs,aViewFlag)
	  	If $$$ISERR(sc2) {
		  	Do $System.Status.DisplayError(sc2)
		  	Continue
	  	}
	    While (rs2.Next()){
			Set EpisodeID = rs2.Data("EpisodeID")
			Continue:EpisodeID=""
			
			//EpisodeID,RegNo,PatName,Sex,Age,CurrLoc,CurrBed,VisitStatus,InHospDate,InHospLocID,InHospLocDesc,
			//InLocDate,CurrLocID,CurrLocDesc,FromLocID,FromLocDesc,IsNeedAtt,OutHospDate,SuspendCode,SuspendDesc,
			//AdmDocCode,AdmDocDesc,IsNeedMsg,IsMessage,IsSusInf,LocUnRead,AdminUnRead,NeedRepCnt,IsReport,NeedMsgDesc,NeedMsgExt
			Set RegNo = rs2.Data("RegNo")
			Set PatName = rs2.Data("PatName")
			Set Sex = rs2.Data("Sex")
			Set Age = rs2.Data("Age")
			Set CurrLoc = rs2.Data("CurrLoc")
			Set CurrBed = rs2.Data("CurrBed")
			Set VisitStatus = rs2.Data("VisitStatus")
			Set InHospDate = rs2.Data("InHospDate")
			Set InLocDate = rs2.Data("InLocDate")
			Set CurrLocID = rs2.Data("CurrLocID")
			Set CurrLocDesc = rs2.Data("CurrLocDesc")
			Set OutHospDate = rs2.Data("OutHospDate")
			Set IsReport = rs2.Data("IsReport")
			Set NeedMsgDesc = rs2.Data("NeedMsgDesc")
			Set NeedMsgExt = rs2.Data("NeedMsgExt")
			Set:NeedMsgExt'="" NeedMsgDesc=NeedMsgDesc_"("_NeedMsgExt_")"
			
			//指标
			Set rs3=##Class(%ResultSet).%New("DHCHAI.IRS.CCScreeningSrv:QrySuRuleResult")
		  	Set sc3=rs3.Execute(EpisodeID)
		  	If $$$ISERR(sc3) {
			  	Do $System.Status.DisplayError(sc3)
			  	Continue
		  	}
		  	Set ResultNotes=""
		    While (rs3.Next()){
				Set ResultNotes = ResultNotes_","_rs3.Data("ResultNote")
			}
			Do rs3.Close()
			Set:ResultNotes'="" ResultNotes=$e(ResultNotes,2,$l(ResultNotes))
			
			Set ScreenInfo=$lb(EpisodeID,RegNo,PatName,Sex,Age,CurrLoc,CurrBed,VisitStatus,InHospDate,InLocDate,CurrLocID,CurrLocDesc,OutHospDate,IsReport,NeedMsgDesc,NeedMsgExt,ResultNotes)
			Set xCount=xCount+1
			Do return.SetAt(ScreenInfo, xCount)
		}
		Do rs2.Close()
	}
	Do rs.Close()
	Quit return
}

}
