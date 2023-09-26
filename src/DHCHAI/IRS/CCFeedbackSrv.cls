/// 名称: DHCHAI.IRS.CCFeedbackSrv
/// 描述: 用户反馈信息登记服务
/// 编写者：mayanpeng
/// 编写日期: 2017-10-12
Class DHCHAI.IRS.CCFeedbackSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2017-10-12
/// Description:  根据就诊记录和问题类型取用户反馈信息，均为空则取全部反馈
/// Table：       DHCHAI.IR.CCFeedback
/// Input：       aEpisodeID:DHCHAI.IR.CCFeedback.CCEpisodeDr
/// 			  aTypeDr:DHCHAI.IR.CCFeedback.CCQuestTypeDr
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.CCFeedbackSrv","QryFeedbackSrv","","","","")
Query QryFeedbackSrv(aEpisodeID As %String = "", aTypeCode As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aHospIDs As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "ID:%String,EpisodeDr:%String,PatName:%String,Sex:%String,Age:%String,VisitStatus:%String,AdmDate:%String,AdmWard:%String,TypeCode:%String,QuestNote:%String,RegDate:%String,RegTime:%String,RegUser:%String,RegUserLoc:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActUserLoc:%String,Opinion:%String,IsOpinion:%String") [ SqlProc ]
{
}

ClassMethod QryFeedbackSrvExecute(ByRef qHandle As %Binary, aEpisodeID As %String = "", aTypeCode As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aHospIDs As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

 	Quit:((aDateFrom="")&&(aDateTo'=""))||((aDateFrom'="")&&(aDateTo=""))||(aDateFrom>aDateTo) $$$OK
	
	If (aEpisodeID'=""){
		Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
		Quit:'$IsObject(objAdm) $$$OK
	}
	If (aTypeCode'=""){
		Set objType = ##class(DHCHAI.BT.Dictionary).GetObjByCode("FeedbackType",aTypeCode)
		Quit:'$IsObject(objType) $$$OK
	}
	
	Set xDate = ""
	For {
		Set xDate = $o(^DHCHAI.IR.CCFeedbackI("IndexRegDateTime",xDate),-1)
		Quit:xDate=""
		If (aDateFrom'=""){
			Quit:xDate<aDateFrom
			Continue:xDate>aDateTo
		}
		Set xTime = ""
		For {
			Set xTime = $o(^DHCHAI.IR.CCFeedbackI("IndexRegDateTime",xDate,xTime),-1)
			Quit:xTime=""
			
			Set xID = 0
			For {
				Set xID = $o(^DHCHAI.IR.CCFeedbackI("IndexRegDateTime",xDate,xTime,xID))
				Quit:xID=""
				
				Set objFeedback = ##class(DHCHAI.IR.CCFeedback).GetObjById(xID)
				Continue:'$IsObject(objFeedback)
				
				//通过就诊ID，过滤出当前病人
				If (aEpisodeID'=""){
					Set xEpisodeID = objFeedback.CCEpisodeDr.%Id()
					Set objxAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
					Continue:'$IsObject(objxAdm)
					Continue:objAdm.PAPapmiNo'=objxAdm.PAPapmiNo
				}
				//过滤问题类型
				If (aTypeCode'=""){
					Quit:objType'=objFeedback.CCQuestTypeDr
				}
				Do BuildFeedback
			}
		}
	}
	Quit $$$OK
BuildFeedback
	Set (EpisodeDr,Sex,Age,VisitStatus,AdmDate,AdmWardDr,AdmWard) = "",PatName="无"
	If $IsObject(objFeedback.CCEpisodeDr){
		Set objAdmLoc = objFeedback.CCEpisodeDr.PAAdmLocDr
		If $IsObject(objAdmLoc.BTHospDr){
			Set HospID=objAdmLoc.BTHospDr.%Id()	
					
			Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1) "" 	//医院过滤	
		}
		Set AdmLocDesc="",AdmLocID =""
		If $isobject(objAdmLoc) {
			Set LocDesc2 = objAdmLoc.BTDesc2
			Set LocDesc = objAdmLoc.BTDesc
			Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
			Set AdmLocID = objAdmLoc.%Id()
		}
		Quit:(aLocID'="")&&(aLocID'=AdmLocID) ""
				
		Set EpisodeIDx=objFeedback.CCEpisodeDr.PAEpisodeIDx
		Set SCode = $p(EpisodeIDx,"||",1)
		Set EpisodeDr = objFeedback.CCEpisodeDr.%Id()
		Set PatName = objFeedback.CCEpisodeDr.PAPatName
		Set Sex = objFeedback.CCEpisodeDr.PASex
		//Set Sex = $s(Sex="F":"男",Sex="M":"女",1:"其他")
		Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
		Set Age = objFeedback.CCEpisodeDr.PAAge
		Set VisitStatus=objFeedback.CCEpisodeDr.PAVisitStatus
		Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
		If VisitStatusInfo'="" {
			Set VisitStatus=$p(VisitStatusInfo,"^",3)
		} Else {
			Set VisitStatus = $s(VisitStatus="P":"预住院",VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="C":"退院",1:"作废")
		}
		Set AdmDate = objFeedback.CCEpisodeDr.PAAdmDate
		Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		Set AdmWardDr = objFeedback.CCEpisodeDr.PAAdmWardDr
		Set:AdmWardDr'="" AdmWard = AdmWardDr.BTDesc2
	}
	Set TypeCode = ""
	Set:($IsObject(objFeedback.CCQuestTypeDr)) TypeCode = objFeedback.CCQuestTypeDr.BTDesc
	Set QuestNote = objFeedback.CCQuestNote
	Set RegDate = objFeedback.CCRegDate
	Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate)
	Set RegTime = objFeedback.CCRegTime
	Set:RegTime'="" RegTime=$zt(RegTime,1)
	Set RegUser = objFeedback.CCRegUserDr.BTDesc
    Set RegUserLoc="",RegLocDr=objFeedback.CCRegLocDr
    Set:($IsObject(RegLocDr)) RegUserLoc = RegLocDr.BTDesc
	Set ActDate = objFeedback.CCActDate
	Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set ActTime = objFeedback.CCActTime
	Set:ActTime'="" ActTime=$zt(ActTime,1)
	Set ActUser = objFeedback.CCActUserDr.BTDesc
    Set ActUserLoc="",ActLocDr=objFeedback.CCActLocDr
    Set:($IsObject(ActLocDr)) ActUserLoc = ActLocDr.BTDesc
	Set Opinion = objFeedback.CCOpinion
	Set IsOpinion = $s(Opinion'="":1,1:0)
	//多语言处理
	Set Sex=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTSEXDesc",Sex,"User.CTSex")
	Set:Age["岁" Age=$Replace(Age,"岁",##class(websys.Translation).Get("Bill.Com.Age","岁"))
	Set AdmWard	=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",AdmWard,"User.CTLoc")
	Set TypeCode=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",TypeCode,"DHCHAI.BT.Dictionary")
	Set RegUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",RegUser,"User.SSUser")
	Set RegUserLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",RegUserLoc,"User.CTLoc")
	Set ActUser=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",ActUser,"User.SSUser")
	Set ActUserLoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",ActUserLoc,"User.CTLoc")
	Set Data = $lb(xID,EpisodeDr,PatName,Sex,Age,VisitStatus,AdmDate,AdmWard,TypeCode,QuestNote,RegDate,RegTime,RegUser,RegUserLoc,ActDate,ActTime,ActUser,ActUserLoc,Opinion,IsOpinion)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryFeedbackSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeedbackSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryFeedbackSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeedbackExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2017-10-16
/// Description:  更新处置意见
/// Table：       DHCHAI.IR.CCFeedback
/// Input：       aFeedbackID : DHCHAI.IR.CCFeedback.ID
///               aOpinion : DHCHAI.IR.CCFeedback.CCOpinion处置意见
/// 			  aUserDr : DHCHAI.IR.CCFeedback.CCActUserDr处置人
/// Return：      返回%String  >0 成功 <=0 失败
/// w ##class(DHCHAI.IRS.CCFeedbackSrv).UpdateOpinion("4","这里是处置意见","9")
ClassMethod UpdateOpinion(aFeedbackID As %String = "", aOpinion As %String = "", aUserDr As %String = "", aLocDr As %String = "") As %String
{
    New (aFeedbackID,aOpinion,aUserDr,aLocDr)
	Set return = 0
	Quit:(aFeedbackID="")||(aOpinion="") return
	
	Set objFeed = ##class(DHCHAI.IR.CCFeedback).GetObjById(aFeedbackID)
	Quit:'$IsObject(objFeed) return
	
	Set objUser = ""
	If aUserDr'=""{
		Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(aUserDr)
		Quit:'$IsObject(objUser) return
	}
    Set objActLoc = ""
    If aLocDr'=""{
        Set objActLoc = ##class(DHCHAI.BT.Location).GetObjById(aLocDr)
        Quit:'$IsObject(objActLoc) return
    }
	Set objFeed.CCOpinion = aOpinion
	Set objFeed.CCActUserDr = objUser
	Set objFeed.CCActDate = +$h
	Set objFeed.CCActTime = +($p($h,",",2))
    Set objFeed.CCActLocDr    = objActLoc
	
	Set sc=objFeed.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=objFeed.%Id()
	}
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-10-17
/// Description:  通过类型Code获得描述Desc
/// Table：       DHCHAI.BT.Dictionary
/// Input：       aCode : DHCHAI.BT.Dictionary.BTCode
/// Return：      返回%String
/// w ##class(DHCHAI.IRS.CCFeedbackSrv).GetDescByCode("1")
ClassMethod GetDescByCode(aCode As %String = "") As %String
{
	New (aCode,%session)
	Set return = 0
	Quit:aCode="" return
	
	Set obj = ##class(DHCHAI.BT.Dictionary).GetObjByCode("FeedbackType",aCode)
	Quit:'$IsObject(obj) return
	//多语言
	Set return = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",obj.BTDesc,"DHCHAI.BT.Dictionary")
	Quit return
}

}
