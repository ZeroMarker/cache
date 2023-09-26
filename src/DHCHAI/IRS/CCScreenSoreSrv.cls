/// 名称: DHCHAI.IRS.CCScreenSoreSrv
/// 描述: 疑似病例筛查评分相关服务
/// 编写者：zhufei
/// 编写日期: 2018-03-15
Class DHCHAI.IRS.CCScreenSoreSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-03-15
/// Description:  疑似病例筛查评分病人列表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.CCScreening
/// Input：       aTypeFlag : 查询类型（1在院、2出院）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aLocID    : 科室ID
///               aScroe    : 分值界限
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.CCScreenSoreSrv","QryScreenPatList","","2017-01-01","2018-03-15","","100","")
Query QryScreenPatList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMinScroe As %String, aMaxScroe As %String, aLocID As %String) As %Query(ROWSPEC = "EpisodeDr:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,LocDesc:%String,WardDesc:%String,CurrBed:%String,VisitStatus:%String,AdmDate:%String,DischDate:%String,ScoreCnt:%String,SuspendDesc:%String") [ SqlProc ]
{
}

ClassMethod QryScreenPatListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMinScroe As %String, aMaxScroe As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set MaxScore=+aMaxScroe
 	Set MinScore=+aMinScroe
 	
	Set xAdmType="",Count=0
	For {
		Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
		Quit:xAdmType=""
		Continue:(xAdmType'="I")&&(xAdmType'="EP")
		
		Set xAdmDays=""
		For {
			Set xAdmDays=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays))
			Quit:xAdmDays=""
			
			Set xDate=""  //xAdmDays<0 表示住院病人
			Set:xAdmDays>=0 xDate=aDateFrom-xAdmDays  //xAdmDays>0 表示出院病人  往前找15天
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xEpisodeDr=""
				For {
					Set xEpisodeDr=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xAdmDays,xDate,xEpisodeDr))
					Quit:xEpisodeDr=""
					
					Set ScreenAttInfo=##class(DHCHAI.IRS.CCScreenAttSrv).GetScreenAttInfo(xEpisodeDr)
					Set IsSusInf=+$p(ScreenAttInfo,"^",2)   //疑似病例  （1疑似病例）
					Set IsSuspend=+$p(ScreenAttInfo,"^",3)  //处置病例  （0待处理、1已确诊、2已排除、3已上报）
					Set ScoreCnt=+$p(ScreenAttInfo,"^",4)   //评估分值
					Continue:ScoreCnt<=MinScore
					Continue:ScoreCnt>MaxScore
					
					Set EpisodeDr=xEpisodeDr
					Do BuildDataToScreenPat(EpisodeDr,aHospIDs,aLocID,ScreenAttInfo)
				}	
			}
		}
	}
	
	Quit $$$OK
	
BuildDataToScreenPat(aEpisodeDr,aHospIDs,aLocID,aScreenAttInfo)
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
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
	Set WardID=objAdmWard.%Id()
	Set WardDesc=objAdmWard.BTDesc
	Set WardDesc2=objAdmWard.BTDesc2
	Set:WardDesc2'="" WardDesc=WardDesc2
	Quit:(aLocID'="")&((aLocID'=LocID)&&(aLocID'=WardID))  //过滤科室、病区
	Set HospID=objAdmLoc.BTHospDr.%Id()
	Set HospDesc=objAdmLoc.BTHospDr.BTDesc
	Set HospDesc2=objAdmLoc.BTHospDr.BTDesc2
	Set:HospDesc2'="" HospDesc=HospDesc2
	Quit:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
	
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
	
	Set IsSusInf=+$p(aScreenAttInfo,"^",2)   //疑似病例  （1疑似病例）
	Set IsSuspend=+$p(aScreenAttInfo,"^",3)  //处置病例  （0待处理、1已确诊、2已排除、3已上报）
	Set ScoreCnt=+$p(aScreenAttInfo,"^",4)   //评估分值
	If IsSusInf=1 {
		Set SuspendCode=IsSuspend
		Set SuspendDesc=$s(SuspendCode=0:"待处理",SuspendCode=1:"已确诊",SuspendCode=2:"已排除",SuspendCode=3:"已上报",1:"错误")
		Set SuspendDesc="疑似病例（"_SuspendDesc_"）"
	} Else {
		Set SuspendDesc="非疑似病例"
	}
	
 	//疑似病例筛查病人列表查询
 	//就诊号、登记号/病案号、姓名、性别、年龄、科室、病区、床号、在院状态、入院日期、出院日期、评分、疑似病例
 	Set Data=$lb(aEpisodeDr,PapmiNo,PatName,Sex,Age,LocDesc,WardDesc,CurrBed,VisitStatus,AdmDate,DischDate,ScoreCnt,SuspendDesc)
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

}
