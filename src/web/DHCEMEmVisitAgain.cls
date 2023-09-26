Class web.DHCEMEmVisitAgain Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMEmVisitAgain).ListEmAdmData(60,1,"^^^^^等候")
ClassMethod ListEmAdmData(rows As %String, page As %String, Params = "", LgParams = "")
{
	n (rows,page,Params,LgParams,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s LgHospID=+LgParams
	s StartDate=$p(Params,"^",1)
	s EndDate=$p(Params,"^",2)
	s InPatNo=$p(Params,"^",3)
	s InAdmLocID=$p(Params,"^",4)
	s InAdmCareID=$p(Params,"^",5)
	s InStatus=$p(Params,"^",6)
	s:InStatus="全部" InStatus=""
	
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s:StartDate="" StartDate=+$h-1
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:EndDate="" EndDate=+$h
	
	
	s Pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	
	f QueueDate=StartDate:1:EndDate d
	.s QueDr=""
	.f  s QueDr=$o(^User.DHCQueueI("QueDateIndex",QueueDate,QueDr)) q:QueDr=""   d
	..s PatNo=$List(^User.DHCQueueD(QueDr),12)
	..q:(PatNo'=InPatNo)&(InPatNo'="")   
	..s QueStateDr=$List(^User.DHCQueueD(QueDr),14)
	..s Status=$List(^User.DHCPerStateD(+QueStateDr),4)
	..q:(InStatus'="")&(InStatus'=Status)
	..s QueDepID=$List(^User.DHCQueueD(QueDr),4)
	..q:(InAdmLocID'="")&(InAdmLocID'=QueDepID)
	..s QueMarkDr = $List(^User.DHCQueueD(QueDr),8)
	..q:(InAdmCareID'="")&(InAdmCareID'=QueMarkDr)
	..s AdmID=$List(^User.DHCQueueD(QueDr),11)
	..s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalByAdm(AdmID)
	..q:(AdmHospID'=LgHospID)
	..s Priority=$P($g(^PAADM(AdmID)),"^",33)
	..s PAAdmPriority=""
	..i Priority'="" s PAAdmPriority=$p($g(^CT("ACU",Priority)),"^",1)
	..s AdmLoc = $p(^CTLOC(QueDepID),"^",2)
	..s AdmCare=""
	..s:QueMarkDr'="" AdmCare=$p(^CTPCP(QueMarkDr,1),"^",2)
	..q:+AdmID=0
	..s PatientID=+^PAADM(AdmID)
	..s PatWardID=$p(^PAADM(AdmID),"^",70)
	..q:+PatWardID'=0
	..s AdmType=$p(^PAADM(AdmID),"^",2)
	..q:AdmType'="E"
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	..s PatSex=""
	..s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	..i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	..s AdmHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(QueDepID)
	..;s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",AdmHospID)  /// 年龄
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(AdmID)
	..s QueDocDr = $List(^User.DHCQueueD(QueDr),5)
	..s PatDoctor=""
	..s:QueDocDr'="" PatDoctor=$p(^CTPCP(QueDocDr,1),"^",2)
	..s PatChkLev=""
	..s EmPCLvID=""
	..s:$d(^DHCEMPCA(0,"AdmChkLev",AdmID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",AdmID,""))
	..i EmPCLvID'="" d
	...s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	...s PatChkLev=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	..s AdmStatus = $List(^User.DHCPerStateD(+QueStateDr),6)
	..s ChAdmStatus=AdmStatus
	..s AdmDate= $p(^PAADM(AdmID),"^",6)
	..s AdmTime=$p(^PAADM(AdmID),"^",7)
	..s Index=QueDr
	..s:AdmDate'="" AdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate)
	..s:AdmTime'="" AdmTime=$zt(AdmTime,2)
	..s AdmStatus=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPerState","PersShowName","",AdmStatus)
	..s AdmLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLoc)
	..s AdmCare=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",AdmCare) 
	..s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	..s PatDoctor=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PatDoctor) 
	..s ItmData=QueDr_"^"_AdmLoc_"^"_AdmCare_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDoctor
	..s ItmData=ItmData_"^"_PatChkLev_"^"_AdmStatus_"^"_AdmDate_"^"_AdmTime_"^"_PatNo_"^"_PAAdmPriority_"^"_ChAdmStatus
	..s ^TMP("web.DHCEMEmVisitAgain","ListEmAdmData",Pid,Index)=ItmData
	
	s JsonTitle="QueDr^AdmLoc^AdmCare^PatName^PatSex^PatAge^PatDoctor^PatChkLev^AdmStatus^AdmDate^AdmTime^PatNo^PAAdmPriority^ChAdmStatus"
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s Count=0
	s Index=""
	f  s Index=$o(^TMP("web.DHCEMEmVisitAgain","ListEmAdmData",Pid,Index),-1) q:Index=""  d
	.s ItmData = ^TMP("web.DHCEMEmVisitAgain","ListEmAdmData",Pid,Index)
	.s Count=Count+1
	.q:(Count<Start)||(Count>End)
	.i Count=Start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(JsonTitle,ItmData)
	.E  D
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(JsonTitle,ItmData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count) //输出json结尾符
	q ""
}

ClassMethod PatAgain(QueID, UserID)
{
	n (QueID , UserID)
	q:+QueID=0 "QueID为空,无法操作!"
	s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	s DocName=$List(^User.DHCQueueD(QueID),5)
	if (status="退号")||(status="等候")||(DocName=""){
		s id=0,desc1=""
		for {
			s id=$o(^User.DHCPerStateD(id)) Q:id=""
			Q:(desc1'="")
			s persname=$List(^User.DHCPerStateD(id),4)
			s pershowsname=$List(^User.DHCPerStateD(id),6)
			if (pershowsname="") s pershowsname=persname
			if (persname="退号") s desc1=pershowsname
		}
		Q "未就诊或"_desc1_"记录不能进行复诊!"
	}
	
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	
	&sql(select ID into :RetrunPersDr from SQLUser.DHCPerState where PersName='退号')
	q:SQLCODE'=0 "获取退号状态ID出现异常!"_SQLCODE
	&sql(select ID into :FirstDr from SQLUser.DHCFirstCode where FirstcName='正常')
	q:SQLCODE'=0 "获取正常FirstCodeID出现异常!"_SQLCODE
	&sql(select ID into :StateID from SQLUser.DHCPerState where PersName='复诊')
	q:SQLCODE'=0 "获复诊状态ID出现异常!"_SQLCODE
	s ^qqa("Data")=$lb(StateID,FirstDr,RetrunPersDr)
	&sql(update SQLUser.DHCQueue set questatedr=:StateID,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID,queFirstdr=:FirstDr
	 where Id=:QueID and QueStateDr<>:RetrunPersDr)
	q:SQLCODE'=0 "修改状态出错！"_SQLCODE
	s ^DHCDocAgain(+$H,QueID)=$P($H,",",2)	
	q 0
}

}
