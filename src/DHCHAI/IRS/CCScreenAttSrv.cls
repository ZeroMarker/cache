/// 名称: DHCHAI.IRS.CCScreenAttSrv
/// 描述: 需关注病例标记相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-27
Class DHCHAI.IRS.CCScreenAttSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-27
/// Description:  检查是否需关注病人
/// Table：       DHCHAI.IR.CCScreenAtt
/// Input：       aEpisodeDr : 就诊号
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo()
ClassMethod GetScreenAttInfo(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	Quit:aEpisodeDr="" return
	
	Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeDr,0))
	Quit:AttID="" return
	Set objAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(AttID)
	Quit:'$IsObject(objAtt) return
	Set IsNeedAtt=objAtt.CSIsNeedAtt  //需关注病例（1持续关注）
	Set IsSusInf=objAtt.CSIsSusInf    //疑似病例  （1疑似病例）
	Set IsSuspend=objAtt.CSIsSuspend  //处置病例  （0待处理、1已确诊、2已排除、3已上报）
	Set ScoreCnt=objAtt.CSScore       //评估分值
	Set return=IsNeedAtt_"^"_IsSusInf_"^"_IsSuspend_"^"_ScoreCnt
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-10
/// Description:  检查疑似病例标志
/// Table：       DHCHAI.IR.CCScreenAtt
/// Input：       aEpisodeDr : 就诊号
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlag(4310)
ClassMethod UpdateSusInfFlag(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	Quit:aEpisodeDr="" return
	
	do ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlagNew(aEpisodeDr)  //指向新方法
	Quit return

 	Set IsSusInf=0,OprStatusList="",IsReport=0,ScoreCnt=0
 	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetScreenResult(aEpisodeDr)
 	If arrResult.Count()>0 {
	 	Set Count=arrResult.Count()
	 	For indArr=1:1:Count {
			Set obj=arrResult.GetAt(indArr)
			Continue:'$IsObject(obj)
			Set RstStatus   = obj.CSRstStatus
			Set OprStatus   = obj.CSOprStatus
			Set IsActive    = obj.CSIsActive
			Continue:IsActive'=1 //是否有效
			Continue:'$IsObject(obj.CSItmScreenDr)
			Set ItemScore   = obj.CSItmScreenDr.CCScore
			Set:ItemScore<1 ItemScore=5  //如果为空，默认5分
			If RstStatus>0 {
				//如果满足组合条件，自动归入疑似病例，自动加100分
				Set ScoreCnt=ScoreCnt+ItemScore+100
			} Else {
				Set ScoreCnt=ScoreCnt+ItemScore
			}
			
			If RstStatus=1 {  //疑似感染
				Set IsSusInf=1
				//OprStatus=0未确认、1确认、-1部分确认、2排除、-2部分排除
				Set OprStatusList=OprStatusList_$lb(OprStatus)
			}
		}
 	}
 	
	//检查是否上报感染报告
 	Set xID=0
	For {
		Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeDr,xID))
		Quit:xID=""
		Set objINFDiagnos=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
		Continue:'$IsObject(objINFDiagnos)
		// 检查关联有效感染报告记录
		Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",xID)
		Continue:listReports.Count()<1
 		Set IsReport=1
 		Quit //退出
	}
	
	If IsSusInf=1 {
	 	If IsReport=1 {
		 	Set IsSuspend=3 //已上报
		} Else {
			If ($listfind(OprStatusList,"1")>0)||($listfind(OprStatusList,"-1")>0){
				Set IsSuspend=1 //已确诊
			} ElseIf ($listfind(OprStatusList,"0")>0) {
				Set IsSuspend=0 //待处理
			} Else {
				Set IsSuspend=2 //已排除
			}
		}
	} Else {
		Set IsSuspend=0
	}
 	Set:IsSusInf=0 IsSuspend=0
 	
	Set ID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeDr,0))
	//Quit:(ID="")&(IsSusInf'=1) return
	Set InputStr=aEpisodeDr_"^"_IsSusInf_"^"_IsSuspend_"^"_ScoreCnt
	Set ScreenAttID=##class(DHCHAI.IR.CCScreenAtt).UpdateSusInfFlag(InputStr)
	If (+ScreenAttID)>0 {
		Set IsSusInf=0,IsSuspend=0
		Set objScreenAtt=##class(DHCHAI.IR.CCScreenAtt).GetObjById(ScreenAttID)
		If $IsObject(objScreenAtt) {
			Set IsSusInf=objScreenAtt.CSIsSusInf
			Set IsSuspend=objScreenAtt.CSIsSuspend
			Set ScoreCnt=objScreenAtt.CSScore
		}
	} Else {
		Set IsSusInf=0,IsSuspend=0,ScoreCnt=0
	}
	Set SuspendCode=IsSuspend
	Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已确诊",SuspendCode=2:"已排除",SuspendCode=3:"已上报",1:"错误")
	Set return=ScreenAttID_"^"_IsSusInf_"^"_SuspendCode_"^"_SuspendDesc_"^"_ScoreCnt
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-07-05
/// Description:  (新)检查疑似病例标志
/// Table：       DHCHAI.IR.CCScreenAtt
/// Input：       aEpisodeDr : 就诊号
/// Return：      返回obj
/// w ##class(DHCHAI.IRS.CCScreenAttSrv).UpdateSusInfFlagNew(119)
ClassMethod UpdateSusInfFlagNew(aEpisodeDr As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo)
	Set return=0
	Quit:(aEpisodeDr="") return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set AdmDate = objEpisode.PAAdmDate
    Set:aDateFrom="" aDateFrom=AdmDate
    Set:aDateTo="" aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") return
 	
 	Set IsSusInf=0,OprStatusList="",ScoreCnt=0
 	Set arrResult=##class(DHCHAI.IRC.CSResultSrv).GetSuRuleResult(aEpisodeDr,aDateFrom,aDateTo)
 	If arrResult.Count()>0 {
	 	Set Count=arrResult.Count()
	 	For indArr=1:1:Count {
			Set obj=arrResult.GetAt(indArr)
			Continue:'$IsObject(obj)
			Set RstStatus   = obj.CSRstStatus   //结果状态(0触发疑似指标、1触发组合条件)
			Set OprStatus   = obj.CSOprStatus   //操作状态(0未操作、1确诊、2排除)
			Set IsActive    = obj.CSIsActive
			Continue:IsActive'=1 //是否有效
			Continue:'$IsObject(obj.CSItmScreenDr)
			
			If RstStatus=1 {  //疑似感染
				Set IsSusInf=1		
				//OprStatus=0未操作、1确认、2排除
				Set OprStatusList=OprStatusList_$lb(OprStatus)
			}
		}
 	}
 	
    If (IsSusInf=1) {
		If ($listfind(OprStatusList,"0")>0){
			Set IsSuspend=0   //有待处理项目
		} else {
			Set IsSuspend=1   //所有项目已处理完
		}	
    }Else {
	    Set IsSuspend=0
    }
    
	Set InputStr=aEpisodeDr_"^"_IsSusInf_"^"_IsSuspend_"^"_ScoreCnt
	Set ScreenAttID=##class(DHCHAI.IR.CCScreenAtt).UpdateSusInfFlag(InputStr)

	Set SuspendCode=IsSuspend
	Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已处理",1:"")
	Set return=ScreenAttID_"^"_IsSusInf_"^"_SuspendCode_"^"_SuspendDesc_"^"_ScoreCnt
	Quit return
}

/// Creator：     pyllian
/// CreatDate：   2020-03-11
/// Description:  查询需关注记录
/// Table：       
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreenAttSrv","QryNeedAtt","","","")
Query QryNeedAtt(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,CurrBed:%String,VisitStatus:%String,LocDesc:%String,DischDate:%String,DischTime:%String,LocUnRead:%String,AdminUnRead:%String,IsNeedAtt:%String,IsSusInf:%String,SuspendCode:%String,NeedRepCnt:%String")
{
}

ClassMethod QryNeedAttExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    Set:aDateFrom'="" aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set:aDateTo'="" aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)	
	
	Set xEpisodeID = ""
	For {
		Set xEpisodeID = $o(^DHCHAI.IR.CCScreenAttI("IndexNeedAttEpd",1,xEpisodeID))
		Quit:xEpisodeID=""
		
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$IsObject(objEpisode)
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
		
		Continue:'$IsObject(objEpisode.PAAdmLocDr)
		Continue:'$IsObject(objEpisode.PAAdmWardDr)
		Set objAdmLoc=objEpisode.PAAdmLocDr
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
		
		Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xEpisodeID)
		Set IsNeedAtt=+$p(ScreenAttInfo,"^",1)	//需关注标记
		Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似标记
		Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置标记
		Set SuspendCode=IsSuspend
		Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已确诊",SuspendCode=2:"已排除",SuspendCode=3:"已上报",1:"错误")
	   
		Set PapmiNo=objEpisode.PAPapmiNo     //登记号
		Set MrNo=objEpisode.PAMrNo           //病案号
		Set PatName=objEpisode.PAPatName     //姓名
		Set Sex=objEpisode.PASex             //性别
		Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
		Set Age=objEpisode.PAAge             //年龄
		Set AdmDate=objEpisode.PAAdmDate     //就诊日期
		Continue:(aDateFrom'="")&&(AdmDate<aDateFrom)
		Continue:(aDateTo'="")&&(AdmDate>aDateTo)
		Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		Set AdmTime=objEpisode.PAAdmTime     //就诊时间
		Set:AdmTime'="" AdmTime=$zt(AdmTime)
		Set DischDate=objEpisode.PADischDate //出院日期
		Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
		Set DischTime=objEpisode.PADischTime //出院时间
		Set:DischTime'="" DischTime=$zt(DischTime)
        Set (CurrBedDr,CurrBed)=""           //床位
		If $IsObject(objEpisode.PAAdmBedDr){
			Set CurrBedDr=objEpisode.PAAdmBedDr.%Id()
			Set CurrBed=objEpisode.PAAdmBedDr.BTDesc
			Set:CurrBed'["床" CurrBed=CurrBed_"床"
		}
		
		// 获取患者是否存在消息记录、临床未阅读消息、管理科未读消息
		Set MsgInfo=##class(DHCHAI.IRS.CCScreeningSrv).GetMsgInfo(xEpisodeID)
	 	Set IsMessage = $p(MsgInfo,"^",1)
		Set LocUnRead = $p(MsgInfo,"^",2)
		Set AdminUnRead = $p(MsgInfo,"^",3)
		
		//获取患者需上报数量
		Set ConfRepCnt=##class(DHCHAI.IRS.CCScreeningSrv).GetConfRepCnt(xEpisodeID)
		Set ConfCnt = $p(ConfRepCnt,"^",1)
		Set RepCnt = $p(ConfRepCnt,"^",2)
		Set NeedRepCnt=ConfCnt-RepCnt
		Set:NeedRepCnt<0 NeedRepCnt=0
  
		Set Data=$lb(xEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmDate,AdmTime,CurrBed,VisitStatus,LocDesc,DischDate,DischTime,LocUnRead,AdminUnRead,IsNeedAtt,IsSusInf,SuspendCode,NeedRepCnt)
     
     	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryNeedAttClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNeedAttExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNeedAttFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNeedAttExecute ]
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

/// 需关注病例数
/// w ##class(DHCHAI.IRS.CCScreenAttSrv).GetNeedAttCnt(6)
ClassMethod GetNeedAttCnt(aLocID As %String) As %String
{
	New (aLocID)
	
	Set return=0
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set HospID=objLoc.BTHospDr.%Id() 	
    Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
    
	Set Count=0
   	Set xEpisodeID = ""
	For {
		Set xEpisodeID = $o(^DHCHAI.IR.CCScreenAttI("IndexNeedAttEpd","1",xEpisodeID))
		Quit:xEpisodeID=""
		
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$IsObject(objEpisode)
		Continue:'$IsObject(objEpisode.PAAdmLocDr)
		Continue:'$IsObject(objEpisode.PAAdmWardDr)
		Set objAdmLoc=objEpisode.PAAdmLocDr
	    Continue:'$IsObject(objAdmLoc.BTHospDr)
	    Continue:'$IsObject(objAdmLoc.BTHospDr.BTGroupDr)
		Set HospID=objAdmLoc.BTHospDr.%Id()
		Set tHospGrpID=objAdmLoc.BTHospDr.BTGroupDr.%Id()
		Continue:HospGrpID'=tHospGrpID
	
		Set Count=Count+1	
	}
	
   Set return = Count
   Quit return
}

/// 获取关注内容
/// w ##class(DHCHAI.IRS.CCScreenAttSrv).GetNeedAttInfo(326)
ClassMethod GetNeedAttInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return	

	Set AttID=$o(^DHCHAI.IR.CCScreenAttI("IndexEpisodeDr",aEpisodeID,0))
	Quit:AttID="" return
	Set AttData=$g(^DHCHAI.IR.CCScreenAttD(AttID))
	Quit:AttData="" return 
	Set IsNeedMsg=$li(AttData,11)
	Set NeedMsgDr =+$p(IsNeedMsg,",",1)
	Set NeedMsgExt=$p(IsNeedMsg,",",2)
	Set NeedMsgDesc=""
	If (NeedMsgDr'=0){
		Set DicMsgData = $g(^DHCHAI.BT.DictionaryD(NeedMsgDr))
		Quit:DicMsgData="" return
		Set NeedMsgDesc=$li(DicMsgData,3)
	} Else {
		Set NeedMsgDr=""
		Set NeedMsgExt =$p(IsNeedMsg,",",1)
	}
	
	Set return = NeedMsgDr_","_NeedMsgDesc_","_NeedMsgExt
	Quit return
}

}
