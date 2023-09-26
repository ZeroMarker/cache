/// ClassName:    DHCHAI.IO.ToDtPortal04
///               替换类DtPortal.Doctor.UndoInfection.MsgService
/// Description:  医院感染提示服务
/// Creator：     zhufei
/// CreatDate:    2018-03-19
Class DHCHAI.IO.ToDtPortal04 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  处置疑似病例筛查记录
/// Table：       DHCMed.EPD.CasesX
/// Input：       aMsgInput     : 1就诊号，2处置状态(1排除/3确诊)，3科室ID，4用户ID，5处置意见
/// Return：      return>0:成功  return<1:失败
/// w ##class(DHCHAI.IO.ToDtPortal04).UnreadMsgHandle("79^3^确诊呼吸机相关性肺炎^中西医结合一科^601")
ClassMethod UnreadMsgHandle(aMsgInput As %String) As DtPortal.OutPut
{
	New (aMsgInput)
	//#Dim return As DtPortal.OutPut
	Set return=##Class(DtPortal.OutPut).%New()
	;s ^mate("UnreadMsgHandle")=aMsgInput
	Set $ZT="UnreadMsgHandleErr"
	
	Set EpisodeID=$p(aMsgInput,"^",1)
	Set Operation=$p(aMsgInput,"^",2)
	Set OperLocID=$p(aMsgInput,"^",3)
	Set OperUserID=$p(aMsgInput,"^",4)
	Set Opinion=$p(aMsgInput,"^",5)
	If (EpisodeID="")||(Operation="")||(OperLocID="")||(OperUserID="") {
		Set return.status = -101
		Set return.errMSG = "参数错误!"
		Set return.data = ""
		Quit return
	} Else {
		If (Operation'="1")&&(Operation'="3") {
			Set return.status = -102
			Set return.errMSG = "参数不合法!"
			Set return.data = ""
			Quit return
		} ElseIf (Operation="1")&&(Opinion="") {
			Set return.status = -103
			Set return.errMSG = "处置意见为空!"
			Set return.data = ""
			Quit return
		} Else {}
	}
	
	//处置疑似病例筛查记录
	Set EpisodeDr=##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(EpisodeID)
	Set OperType=$s(Operation=1:2,1:1)
	Set SysUserDr=##class(DHCHAI.CUS.ToClinReport).GetUserDr(OperUserID,OperLocID)
	Set flg=##class(DHCHAI.IRS.CCScreeningSrv).ScreenRstOperAll(EpisodeDr,OperType,SysUserDr,Opinion)
	If (+flg<1) {
		Set return.status = -301
		Set return.errMSG = "当前操作错误！提示："_flg
		Set return.data = ""
	} Else {
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = ""
	}
	
	Quit return
	
UnreadMsgHandleErr
	Set return.status = -1
	Set return.errMSG = $ZE
	Set return.data = ""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-19
/// Description:  查询当前医生未读医院感染提示列表
/// Table：       DHCHAI.IR.CCScreenAct,DHCHAI.IR.INFReport
/// Input：        aUserCode     ：医生工号(SS_User.SSUSR_Initials)
/// Return：      未读消息列表
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IO.ToDtPortal04","QryUnreadMsgList2","P","4829")
Query QryUnreadMsgList2(QueryType As %String, aUserCode As %String) As DtPortal.Query(ROWSPEC = "UserID:%String,DocLocID:%String,EpisodeID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,AdmBed:%String,MsgType:%String,RecordID:%String,PromptMsg:%String,PatientID:%String")
{
}

ClassMethod QryUnreadMsgList2Execute(ByRef qHandle As %Binary, QueryType As %String, aUserCode As %String) As %Status
{
	n (qHandle,QueryType,aUserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aUserCode="" $$$OK
	
	Set UserID=##class(DtPortal.Common.PublicService).GetUserID(aUserCode)
	Quit:UserID="" $$$OK
	Set CareProvID=$p($g(^SSU("SSUSR",UserID)),"^",14)
	Quit:CareProvID="" $$$OK
	
	//增加主诊组的判断
	set MUDocIDs=""
	Set:QueryType="PG" MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(CareProvID)
	
	Set AdmType="I"
	Set xLocID=0
	For {
		Set xLocID=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID))
		Quit:xLocID=""
		Set xDate=0
		For {
			Set xDate=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate))
			Quit:xDate=""
			Set xTime=""
			For {
				Set xTime=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate,xTime))
				Quit:xTime=""
				
				Set xPaadm=""
				For {
					Set xPaadm=$o(^PAADMi("AdmTypeCurrLoc",AdmType,xLocID,xDate,xTime,xPaadm))
					Quit:xPaadm=""
				
					Continue:$p($g(^PAADM(+xPaadm)),"^",2)'="I"   //就诊类型过滤
					Continue:$p($g(^PAADM(+xPaadm)),"^",20)="C"   //就诊状态过滤
					Set AdmDocID=$p($g(^PAADM(xPaadm)),"^",9)     //主管医生
					//Continue:CareProvID'=AdmDocID
					//增加主诊组的判断
					Set QuitFlag=""
					Set:(QueryType="P")&&(CareProvID'=AdmDocID) QuitFlag=1
					Set:(QueryType="PG")&&(MUDocIDs'[("^"_AdmDocID_"^")) QuitFlag=1   
					Quit:QuitFlag=1
					
					Set EpisodeID=xPaadm
					Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
					Continue:(EpisodeID="")||(PatientID="")
					
					
					Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
					Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
					Set PatSexID=$p($g(^PAPER(PatientID,"ALL")),"^",7)
					Set PatSex=$p($g(^CT("SEX",+PatSexID)),"^",2)
					Set AdmBedID=$p($g(^PAADM(EpisodeID)),"^",73)
					Set AdmBed=$p($g(^PAWARD(+AdmBedID,"BED",+$p(AdmBedID,"||",2))),"^",1)
					
					Set EpisodeDr=##class(DHCHAI.CUS.ToClinReport).GetEpisodeDr(EpisodeID)
					Continue:EpisodeDr=""
					
					//判断是否上报感染报告
					//提示1：退回报告未处理（RetReport）
					Set arrInfRep=##class(DHCHAI.IO.ToDtPortalSrv).GetInfReports(EpisodeDr)
					For indIR=1:1:arrInfRep.Count() {
						Set objInfRep=arrInfRep.GetAt(indIR)
						Continue:'$IsObject(objInfRep)
						Continue:'$IsObject(objInfRep.IRStatusDr)
						//1保存、2提交、3审核、4删除、5退回、6取消审核
						Set StatusCode=objInfRep.IRStatusDr.BTCode
						Continue:StatusCode'="5"  //检查报告状态（5:退回）
						Set ReportID=objInfRep.%Id()
						
						Set arrInfRepLog=##class(DHCHAI.IO.ToDtPortalSrv).GetInfRepLogs(ReportID,StatusCode)
						Set LogCnt=arrInfRepLog.Count()
						Continue:LogCnt<1
						Set objLog=arrInfRepLog.GetAt(LogCnt)
						Continue:'$IsObject(objLog)
						Set Opinion=objLog.IROpinion  //处置意见
						
						Set MsgType="RetReport"
						Set RecordID=ReportID
						Set PromptMsg="退回报告未处理，退回原因："_Opinion
						
						set DocLocID=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetDocIDLocID(aUserCode,EpisodeID) //获取医生的处理科室
						Set Data=$lb(UserID,DocLocID,EpisodeID,PapmiNo,PatName,PatSex,AdmBed,MsgType,RecordID,PromptMsg,PatientID)
						Set ^||CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
					
					//提示2：疑似病例未处理（UnreadMsg）
					//提示3：确诊病例未上报（NotReport）
					Set ScreeningInfo=##class(DHCHAI.IO.ToDtPortalSrv).GetScreenStatusByAdm(EpisodeDr)
					If ScreeningInfo'="" {
						Set EpisodeDr=$p(ScreeningInfo,"^",1)
						Set EpisodeID=$p(ScreeningInfo,"^",2)
						Set IsSuspend=$p(ScreeningInfo,"^",3)
	 					Set IsConfirmed=$p(ScreeningInfo,"^",4)
						Continue:(IsSuspend'=0)&&(IsConfirmed'=1) //IsSuspend=0疑似待处理、IsConfirmed=1确诊未上报
	 	
						If (IsSuspend=0) {
							Set MsgType="UnreadMsg"
							Set RecordID=EpisodeDr
							Set PromptMsg="疑似病例未处理;"
							
							set DocLocID=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetDocIDLocID(aUserCode,EpisodeID)
							Set Data=$lb(UserID,DocLocID,EpisodeID,PapmiNo,PatName,PatSex,AdmBed,MsgType,RecordID,PromptMsg,PatientID)
							Set ^||CacheTemp(repid,ind)=Data
							Set ind=ind+1
						} ElseIf (IsConfirmed=1) {
							Set MsgType="NotReport"
							Set RecordID=EpisodeDr
							Set ActDate=""
							Set arrScreening=##class(DHCHAI.IO.ToDtPortalSrv).GetScreeningInfo(EpisodeDr,"1")
							Set ScreenCnt=arrScreening.Count()
							If ScreenCnt>0 {
								Set Screening=arrScreening.GetAt(ScreenCnt)
								Set ActDate=$p(Screening,"^",2)
							}
							Set PromptMsg="确诊病例未上报：确诊日期"_ActDate
							
							set DocLocID=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetDocIDLocID(aUserCode,EpisodeID)
							Set Data=$lb(UserID,DocLocID,EpisodeID,PapmiNo,PatName,PatSex,AdmBed,MsgType,RecordID,PromptMsg,PatientID)
							Set ^||CacheTemp(repid,ind)=Data
							Set ind=ind+1
						} Else {}
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

}
