/// ClassName:    DHCHAI.IO.ToDtPortal01
///               替换类DtPortal.DD.DD11HospInfectionWarning
/// Description:  临床科主任医院感染服务
/// Creator：     zhufei
/// CreatDate:    2018-03-19
Class DHCHAI.IO.ToDtPortal01 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-03-19
/// Description:  DD11.01.01 按月查询科室感染暴发预警患者信息
/// Table：       DHCHAI.IR.CCResult、DHCHAI.IR.CCWarning
/// Input：       userCode   ：用户工号
///               warnDate   : 预警日期
///               locGroupId : 科室组ID
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal01","QueryLocWarningPatinfo","4829","2018-03-27","")
Query QueryLocWarningPatinfo(userCode As %String, warnDate As %String, locGroupId As %String = "") As DtPortal.Query(ROWSPEC = "bedNum:%String,name:%String,sex:%String,age:%String,medicareNo:%String,doctor:%String,warningDate:%String,warningInfo:%String,promptType:%String,wardName:%String,PatientID:%String,episodeID:%String,instanceID:%String,docId:%String,DocLoc:%String,AdmDocID:%String")
{
}

ClassMethod QueryLocWarningPatinfoExecute(ByRef qHandle As %Binary, userCode As %String, warnDate As %String, locGroupId As %String = "") As %Status
{
	new (qHandle,userCode,warnDate,locGroupId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:warnDate="" $$$OK
 	If (warnDate["-") {
	 	Quit:$l(warnDate,"-")<3 $$$OK
 		Set warnDate=$zdh(warnDate,3)
 	}
 	/*Set locGroupId=$g(locGroupId)
 	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
 	if DocLoc=""{
 		set DocLoc=##class(DtPortal.Common.PaadmService).getDDLocIDByUserCode(userCode)
		Quit:DocLoc="" $$$OK
 	}
 	set DocLoc="^"_DocLoc_"^"*/
	
	set DocLoc=locGroupId
 	//按日期、科室筛查预警信息
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetWarningPatInfo(warnDate,"")
 	For indEpis=1:1:arr.Count() {
	 	Set WarningInfo=arr.GetAt(indEpis)
	 	Continue:WarningInfo=""
	 	Set EpisodeDr=$p(WarningInfo,"^",1)
	 	Set EpisodeID=$p(WarningInfo,"^",2)
	 	Set WarnDate=$p(WarningInfo,"^",3)
	 	Set SummaryStr=$p(WarningInfo,"^",4)
	 	Set WarnLocID=$p(WarningInfo,"^",5)
	 	Continue:EpisodeID=""
	 	Continue:SummaryStr=""
	 	
	 	Continue:DocLoc'[("^"_WarnLocID_"^")
	 	
	 	//SummaryStr包含项目：实时现患||3^发热|7|3^检出同种同源菌|7|3^便常规异常|7|3^呼吸机使用|7|3^中心静脉置管|7|3^泌尿道插管|7|3
	 	Set promptType="",promptTypeList=""
	 	For indSS=1:1:$l(SummaryStr,",") {
			Set tSummary=$p(SummaryStr,",",indSS)
			Continue:tSummary=""
			
			If tSummary["发热" {
				Set tpromptType="体温异常"
			} ElseIf tSummary["检出同种同源菌" {
				Set tpromptType="同种同源菌"
			} ElseIf ((tSummary["上呼吸道感染")||(tSummary["下呼吸道感染")
				||(tSummary["泌尿道感染")||(tSummary["血管相关性感染")
				||(tSummary["手术切口感染")) {
				Set tpromptType="感染诊断"
			} Else {
				Set tpromptType="其他"
			}
			Continue:$listfind(promptTypeList,tpromptType)>0
			Set promptTypeList=promptTypeList_$lb(tpromptType)
	 	}
	 	Set promptType=$ListToString(promptTypeList,";")
		Set warningInfo=SummaryStr               //预警信息摘要
		Set warningDate=$zd(WarnDate,3)			 //预警日期
		Do WarningPatOut2
	}
	Quit $$$OK
	
WarningPatOut2
	set PatInfo=##class(DtPortal.Common.PublicService).GetPatInfo(EpisodeID)
	quit:PatInfo=""
	set name=$p(PatInfo,"^",2)											//姓名
	set sex=$p(PatInfo,"^",3)											//性别
	set age=$p(PatInfo,"^",4)											//年龄
	set medicareNo=$p(PatInfo,"^",5)									//病案号
	set admReason=$p(PatInfo,"^",6)										//费用类别
	set bedNum=$p(PatInfo,"^",1)
 	
	Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	quit:'$IsObject(AdmObj)
	
	Set PatientID=AdmObj.PatientID									//患者Id
	Set doctor=AdmObj.DoctorName									//主管医生
	
	set wardID=$p(^PAADM(+EpisodeID),"^",70)	
	set wardName=""							
	set:wardID'="" wardName=$p(^PAWARD(wardID),"^",2)
	set:wardName["-" wardName=$p(wardName,"-",2)						//病区名称
 	
 	set EMRStr=##class(DtPortal.Common.PaadmService).getEMRInput(EpisodeID)
 	set instanceID=""
 	set docId=""
 	set instanceID=$p(EMRStr,"^",1)									//病历实例数据ID
 	set docId=$p(EMRStr,"^",2)										//病历目录展现结构ID
 	set episodeID=EpisodeID
 	
 	set AdmDocID=""
 	set CPDocID=$p(^PAADM(+episodeID),"^",9)
	set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
 	Set Data=$lb(bedNum,name,sex,age,medicareNo,doctor,warningDate,warningInfo,promptType,wardName,PatientID,episodeID,instanceID,docId,DocLoc,AdmDocID)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// Creator：     zhufei
/// CreatDate：   2018-03-19
/// Description:  DD11.02.01 查询当前病区疑似未处置和确诊未报病人信息
/// Table：       DHCHAI.IR.CCScreenAct
/// Input：       userCode   ：用户工号
///               yearMonth  : 监控月份
///               locGroupId : 科室组ID
/// D ##class(%ResultSet).RunQuery("DHCHAI.IO.ToDtPortal01","QueryCasesPatInfo","601","2018-03")
Query QueryCasesPatInfo(userCode As %String, yearMonth As %String, locGroupId As %String = "") As DtPortal.Query(ROWSPEC = "bedNum:%String,name:%String,sex:%String,age:%String,medicareNo:%String,doctor:%String,dealDate:%String,dealDoctor:%String,dealInfo:%String,promptType:%String,wardName:%String,PatientID:%String,episodeID:%String,instanceID:%String,docId:%String,DocLoc:%String,AdmDocID:%String")
{
}

ClassMethod QueryCasesPatInfoExecute(ByRef qHandle As %Binary, userCode As %String, yearMonth As %String, locGroupId As %String = "") As %Status
{
	new (qHandle,userCode,yearMonth,locGroupId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set locGroupId=$g(locGroupId)
 	set DocLoc=##class(DtPortal.DD.DD00PublicService).getDDloc(locGroupId,"I")
 	if DocLoc=""{
 		set DocLoc=##class(DtPortal.Common.PaadmService).getDDLocIDByUserCode(userCode)
 		Quit:DocLoc="" $$$OK
 	}
 	set DocLoc="^"_DocLoc_"^"
 	
 	set startDate=""
	set EndDate=""
	
	set Year=$p(yearMonth,"-",1)
	set Month=$p(yearMonth,"-",2)
	set startDate=$zdh(yearMonth_"-01",3)
	
	set:Month'=12 EndDate=$zdh(Year_"-"_(Month+1)_"-"_"01",3)-1
	set:Month=12 EndDate=$zdh(Year_"-"_Month_"-"_"31",3)
	
 	//按科室、日期筛查预警信息
 	Set arr=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningPatInfo(startDate,EndDate)
	Quit:arr.Count()<1 $$$OK
 	For indEpis=1:1:arr.Count() {
	 	Set ScreeningInfo=arr.GetAt(indEpis)
	 	Continue:ScreeningInfo=""
	 	Set EpisodeDr=$p(ScreeningInfo,"^",1)
	 	Set EpisodeID=$p(ScreeningInfo,"^",2)
	 	Set IsSusInf=$p(ScreeningInfo,"^",3)
	 	Set IsSuspend=$p(ScreeningInfo,"^",4)
	 	Continue:EpisodeID=""
	 	Continue:IsSusInf'=1
	 	
		Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(objPaadm)
		set LocID=objPaadm.DepartmentID										//科室ID
		set LocID="^"_LocID_"^"
		continue:DocLoc'[LocID
		
		set LocDesc=objPaadm.Department			
		set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)							//科室描述
		set PatInfo=##class(DtPortal.Common.PublicService).GetPatInfo(EpisodeID)
		Continue:PatInfo=""
		set name=$p(PatInfo,"^",2)											//姓名
		set sex=$p(PatInfo,"^",3)											//性别
		set age=$p(PatInfo,"^",4)											//年龄
		set medicareNo=$p(PatInfo,"^",5)									//病案号
		set admReason=$p(PatInfo,"^",6)										//费用类别
		set bedNum=$p(PatInfo,"^",1)											//床号
		
		set wardName=""
		set WardID=$p(^PAADM(+EpisodeID),"^",70)
		set:WardID'="" wardName=$p($g(^PAWARD(WardID)),"^",2)	
		set:wardName["-" wardName=$p(wardName,"-",2)						//病区描述		
		
		Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		Continue:'$IsObject(AdmObj)
		Set PatientID=AdmObj.PatientID										//患者Id
		Set doctor=AdmObj.DoctorName										//主管医生
		
		set dealDoctor=""													//处置医生
		set dealDate=""														//处置日期
		set dealInfo=""														//处置意见
		Set arrScreeningInfo=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningInfo(EpisodeDr,"1")
		If arrScreeningInfo.Count()>0 {
			Set LastIndex=arrScreeningInfo.Count()
			Set tScreeningInfo=arrScreeningInfo.GetAt(LastIndex)
			Set dealDate=$p(tScreeningInfo,"^",2)
			Set dealDoctor=$p(tScreeningInfo,"^",4)
			Set:dealDoctor'="" dealDoctor=$p($g(^SSU("SSUSR",dealDoctor)),"^",2)
			Set dealInfo=$p(tScreeningInfo,"^",5)
		}
		
		set promptType=""	
		set:(IsSusInf=1)&&(IsSuspend=0) promptType="疑似未处置"		//提示类型
		set:(IsSusInf=1)&&(IsSuspend=1) promptType="确诊未报"
		
		set EMRStr=##class(DtPortal.Common.PaadmService).getEMRInput(EpisodeID)
	 	set instanceID=""
	 	set docId=""
	 	set instanceID=$p(EMRStr,"^",1)									//病历实例数据ID
	 	set docId=$p(EMRStr,"^",2)										//病历目录展现结构ID
	 	set episodeID=EpisodeID
		
		set AdmDocID=""
		set CPDocID=$p(^PAADM(+episodeID),"^",9)
		set:CPDocID'="" AdmDocID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
		Set Data=$lb(bedNum,name,sex,age,medicareNo,doctor,dealDate,dealDoctor,dealInfo,promptType,wardName,PatientID,episodeID,instanceID,docId,DocLoc,AdmDocID)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
 	
	Quit $$$OK
}

}
