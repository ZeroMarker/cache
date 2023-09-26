Import SQLUser

Class DHCDoc.DHCDocCure.CureCall Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:nk
/// CreateDate:
/// Description:
/// Input:  VoiceQueueJson:呼叫信息串 CallRowId:呼叫的ID 
/// 		Type:呼叫 
/// 		SourceType:AP(原来的治疗处理对治疗预约记录的呼叫)、CQ(新版治疗处理的对治疗患者队列记录的呼叫)、A(治疗执行) 
/// 		UserId:用户ID
/// Output:
/// Debug:w ##class(DHCDoc.DHCDocCure.CureCall).CureCall($lg(^tmplog("CureCall"),1),"5","Call","CQ","17473")
ClassMethod CureCall(VoiceQueueJson As %String, CallRowId As %String, Type As %String, SourceType As %String = "", UserId As %String = "")
{
	s ^tmplog("CureCall")=$lb(VoiceQueueJson,CallRowId,Type,SourceType,UserId)
	s CheckRet=..CheckBeforeCall(CallRowId,Type,SourceType,UserId)
	if +CheckRet'=0{
		Q CheckRet	
	}
	
	s VoiceQueueObj={}.%FromJSON(VoiceQueueJson)
	s voiceContent=VoiceQueueObj.voiceContent
	s userId=VoiceQueueObj.userId
	s clientIP=VoiceQueueObj.clientIP
	s type=VoiceQueueObj.type
	s sound=VoiceQueueObj.sound
	s repeat=VoiceQueueObj.repeat
	s ZHScreenStr=VoiceQueueObj.ZHScreenStr
	s CKScreenStr=VoiceQueueObj.CKScreenStr
	s WaitList=VoiceQueueObj.WaitList
	s Note=VoiceQueueObj.Note
	s ret=0
	Ts
	s ret=##class(web.DHCVISVoiceCall).InsertVoiceQueue(voiceContent , userId , clientIP , type , sound , repeat , ZHScreenStr , CKScreenStr , WaitList , Note )
	if +ret=0{
		s ret=..DHCDocCureReport(CallRowId,Type,SourceType,UserId)	
		if +ret'=0{
			Tro	
		}else{
			Tc	
		}
	}else{
		Tro
	}
	Q ret
}

ClassMethod CheckBeforeCall(CallRowId As %String, Type As %String, SourceType As %String = "", UserId As %String = "")
{
	//SourceType:AP(原来的治疗处理对治疗预约记录的呼叫)、
	//	CQ(新版治疗处理的对治疗患者队列记录的呼叫)、
	//	A(治疗执行) 
	s (DCAARowId,DCARowId,QueRowId)=""
	if SourceType="AP" s DCAARowId=CallRowId
	else  if SourceType="CQ" s QueRowId=CallRowId
	else  s DCARowId=CallRowId
	if QueRowId'=""{
		s CallStatusFlag=$lg(^User.DHCDocCureQueueD(QueRowId),19)
		s CallUserDr=$lg(^User.DHCDocCureQueueD(QueRowId),20)
		if Type="Pass"{
			if CallStatusFlag=""{
				q "-400"
			}
			if CallStatusFlag="N"{
				q "-401"
			}
		}
	}elseif DCAARowId'=""{
		s DCARowId=+DCAARowId
		s DCAASub=$p(DCAARowId, "||", 2)
		s RBASId=$p(^DHCDocCure(DCARowId,"Arrive",DCAASub),"^",1)
		q:RBASId="" "-302"
		s CurPerStateDr=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",15)
		s CallUserDr=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",17)
		if Type="Pass"{
			if CurPerStateDr'="" {
				s CallStatusCode=$p(^DHCDocCurePS(CurPerStateDr),"^",1)
				s CallStatus=$p(^DHCDocCurePS(CurPerStateDr),"^",2)
				if CallStatusCode="Pass"{
					Q "-401"
				}elseif CallStatusCode'="Call"{
					Q "-400"
				}
			}
		}
	}else{
		s CallStatus="Y"
		s CallStatusFlag=$p($g(^DHCDocCure(DCARowId)),"^",16)
		s CallUserDr=$p($g(^DHCDocCure(DCARowId)),"^",21)
		
		if Type="Pass"{
			s CallStatus="N"
			if CallStatusFlag=""{
				q "-400"
			}
			if CallStatusFlag="N"{
				q "-401"
			}
		}else{
			s Billed=##class(DHCDoc.DHCDocCure.Apply).GetCureBilled(DCARowId)
			if Billed=0{
				q "-500"	
			}
		}
	}
	if ("Call Pass"[Type)&&(CallUserDr'="")&&(CallUserDr'=UserId){
		q "-402"	
	}
	q 0
}

/// Description:更新治疗记录呼叫状态、队列状态
/// Description:
/// Input:  VoiceQueueJson:呼叫信息串 CallRowId:呼叫的ID 
/// 		Type:呼叫 
/// 		SourceType:AP(原来的治疗处理对治疗预约记录的呼叫)、CQ(新版治疗处理的对治疗患者队列记录的呼叫)、A(治疗执行) 
/// 		UserId:用户ID
/// Output:
/// w ##class(DHCDoc.DHCDocCure.CureCall).DHCDocCureReport("5||1","Complete")
ClassMethod DHCDocCureReport(CallRowId As %String, Type As %String, SourceType As %String, UserId As %String = "")
{
	s ^tmp("DHCDocCureReport")=$lb(CallRowId, Type,SourceType,UserId)
	//SourceType:
	//	AP(原来的治疗处理对治疗预约记录的呼叫)、
	//	CQ(新版治疗处理的对治疗患者队列记录的呼叫)、
	//	A(治疗执行) 
	s (DCAARowId,DCARowId,QueRowId)=""
	if SourceType="AP" s DCAARowId=CallRowId
	else  if SourceType="CQ" s QueRowId=CallRowId
	else  s DCARowId=CallRowId
	
	s CheckRet=..CheckBeforeCall(CallRowId,Type,SourceType,UserId)
	if +CheckRet'=0{
		Q CheckRet	
	}
	s ret=0
	if QueRowId'=""{
		;新版治疗处理的对治疗患者队列记录的呼叫
		;仅涉及呼叫、过号，报到操作位于DHCDoc.DHCDocCure.Alloc.cls:UpdateCureQue
		d UpdateByQue
	}elseif DCAARowId'=""{
		;原来的治疗处理对治疗预约记录的呼叫
		d UpdateByDCAA
	}else{
		d UpdateByDCA
	}
	q ret
UpdateByQue	
	s UpdateReportID=""
	s CallStatusFlag=$lg(^User.DHCDocCureQueueD(QueRowId),19)
	s CallUserDr=$lg(^User.DHCDocCureQueueD(QueRowId),20)
	if Type="Pass"{
		;过号置过号状态
		s ReportID=$o(^DHCDocCurePSi(0,"Code",Type,""))
		s CallStatus="N"
		;s UpdateReportID=ReportID
	}else{
		s ReportID=$o(^DHCDocCurePSi(0,"Code","Wait",""))
		;呼叫置呼叫状态
		s QueStatusDr=$lg(^User.DHCDocCureQueueD(QueRowId),9)
		s QueStatusCode=$p($g(^DHCDocCurePS(QueStatusDr)),"^",1)
		s CallStatus="Y"
		;s:"Complete Cancel"'[QueStatusCode UpdateReportID=ReportID	
	}
	q:ReportID="" "-300"
	s obj=##class(User.DHCDocCureQueue).%OpenId(QueRowId)
	if $IsObject(obj){
		s obj.DDCQCallStatus=CallStatus
		d obj.DDCQCallUserDrSetObjectId(UserId)
		d:UpdateReportID'="" obj.DDCQStatusDrSetObjectId(UpdateReportID)
	}
	s sc=obj.%Save()
	If $$$ISERR(sc){
	    s ret="-303"	
    }
	d obj.%Close()
	Q
UpdateByDCAA	
	s ReportID=$o(^DHCDocCurePSi(0,"Code",Type,""))
	q:ReportID="" "-300"
	s (DCAAppSeqNo,ReportSeqFlag)=""
	s DCARowId=+DCAARowId
	s DCAASub=$p(DCAARowId, "||", 2)
	s RBASId=$p(^DHCDocCure(DCARowId,"Arrive",DCAASub),"^",1)
	s DCAAppSeqNo=$p(^DHCDocCure(DCARowId,"Arrive",DCAASub),"^",13)
	s ReportSeqFlag=$p(^DHCDocCure(DCARowId,"Arrive",DCAASub),"^",18)
	q:RBASId="" "-302"
	
	s ret="-101"
	if Type="Wait" {
		if DCAAppSeqNo=""{
			Lock +^DHCDocCureRBCResSchduleLOCK(RBASId):10
			if $test {
				ts
				s DDCRSSeqNoStr=$p($g(^DHCDocCureRBCResSchdule(RBASId)),"^",21)
				if DDCRSSeqNoStr=""{
					s AppSeqNo=1
					s DDCRSSeqNoStr=AppSeqNo	
				}else{
					s DDCRSSeqNoStrLen=$l(DDCRSSeqNoStr,",")
					s AppSeqNo=+$p(DDCRSSeqNoStr,",",DDCRSSeqNoStrLen)+1
					s DDCRSSeqNoStr=DDCRSSeqNoStr_","_AppSeqNo
				}
				&sql(update DHC_DocCureAppArrive set DCAA_PerStatusDr=:ReportID,DCAA_SeqNo=:AppSeqNo,DCAA_ReportSeqFlag="Y" where DCAA_RowId = :DCAARowId)
				if SQLCODE {
					tro
					Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
					q "-305"
				}
				&sql(Update SQLUser.DHC_DocCureRBCResSchdule set DDCRS_SeqNoStr=:DDCRSSeqNoStr where DDCRS_RowID=:RBASId)
				if SQLCODE {
					tro
					Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
					q "-306"
				}
				tc
			}
			Lock -^DHCDocCureRBCResSchduleLOCK(RBASId)
		}else{
			&sql(update DHC_DocCureAppArrive set DCAA_PerStatusDr=:ReportID where DCAA_RowId = :DCAARowId)
			if SQLCODE {
				q "-305"
			}
		}
		s ret=SQLCODE
	}else {
		s SeqNo=$p($g(^DHCDocCure(+DCAARowId,"Arrive",$p(DCAARowId,"||",2))),"^",13)
		s CallUser=""
		if Type="Report"{
			s:ReportSeqFlag="Y" SeqNo="" ;取消报到,排队号置空
		}elseif Type="Call"{
			s CallUser=UserId
		}
		K PLIST
		s PLIST(15)=SeqNo
		s PLIST(17)=ReportID
		s PLIST(19)=CallUser
		
		&sql(update DHC_DocCureAppArrive VALUES :PLIST() where DCAA_RowId = :DCAARowId)
		if SQLCODE{
			s ret="-305"	
		}else{
			s ret=0
		}
	}
	Q
UpdateByDCA	
	s CallStatus="Y"
	s CallStatusFlag=$p($g(^DHCDocCure(DCARowId)),"^",16)
	if Type="Pass"{
		s CallStatus="N"
	}
	s ret=..UpdateTreatCallStatus(DCARowId,CallStatus,UserId)
	if ret'=0{
		s ret="-303"	
	}
	Q
}

/// 0^生殖中心**检查报到单!患者姓名!就诊卡号!检查日期!报到时段!报到序号
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetPrintData("54946||1")
ClassMethod GetPrintData(DCAARowId As %String) As %String
{
	s DCARowId=+DCAARowId
	s ArriveSub=$p(DCAARowId,"||",2)
	
	s CureData=$g(^DHCDocCure(DCARowId))
	s AdmId=$p(CureData,"^",1)
	s PatId=$P($G(^PAADM(AdmId)),"^",1)
	s PatName=$P($G(^PAPER(PatId,"ALL")),"^",1)
	s CardNo=$$GetCardNo(PatId)
	
	
	s OrderId=$p(CureData,"^",2)
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	s AppDate=$p(^DHCDocCure(DCARowId,"Arrive",ArriveSub),"^",4)
	s RBASId=$p(^DHCDocCure(DCARowId,"Arrive",ArriveSub),"^",1)
	s ASDate=$p(^DHCDocCureRBCResSchdule(RBASId),"^",4)
	s:ASDate'="" ASDate=$zd(ASDate,3)
	s StTime=$p(^DHCDocCureRBCResSchdule(RBASId),"^",6)
	s EndTime=$p(^DHCDocCureRBCResSchdule(RBASId),"^",7)
	s TimeRange=$zt(StTime,1)_" - "_$zt(EndTime,1)
	s SeqNo=$p(^DHCDocCure(DCARowId,"Arrive",ArriveSub),"^",13)
	
	s rtn=0_"^"_ArcimDesc_"^"_PatName_"^"_CardNo_"^"_ASDate_"^"_TimeRange_"^"_SeqNo
	q rtn
	
GetCardNo(PatId)
	s CardNo=""
	s CfRowId=0 f {
		s CfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatId,CfRowId))
		q:CfRowId=""
		s Active=$p(^DHCCARD("CF",CfRowId),"^",10)
		continue:Active'="N"
		s CardNo=$p(^DHCCARD("CF",CfRowId),"^",2)
		q
	}
	q CardNo
}

/// 获取DHC_DocCurePerState数据
Query CurePerStatusData() As %SQLQuery(ROWSPEC = "RowId:%String, Code:%String, Desc:%String, Priority:%String, ShowName:%String")
{
	select DDCPS_RowID, DDCPS_Code, DDCPS_Desc, DDCPS_Priority , DDCPS_ShowName 
	from DHC_DocCurePerState
}

/// 获取DHC_DocCurePerState数据(过滤正在呼叫和等候呼叫)
Query CurePerStatusDataNew() As %SQLQuery(ROWSPEC = "RowId:%String, Code:%String, Desc:%String, Priority:%String, ShowName:%String")
{
	select DDCPS_RowID, DDCPS_Code, DDCPS_Desc, DDCPS_Priority , DDCPS_ShowName 
	from DHC_DocCurePerState where DDCPS_Code NOT IN ('Call','WaitCall','Pass')
}

/// 根据desc获取Id
/// table： DHC_DocCurePerState
ClassMethod GetCurePerStateId(PerState As %String) As %String
{
	s PerStateId="" 
	&sql(select DDCPS_RowID into :PerStateId from DHC_DocCurePerState where DDCPS_Code=:PerState)
	q PerStateId
}

/// Description:初始化DHC_DocCurePerState表数据
/// 注意: Code已规范化，不可随意更改
/// w ##class(DHCDoc.DHCDocCure.CureCall).InitTabPerStateData()
ClassMethod InitTabPerStateData()
{
	s $zt="InitTabPerStateDataErr"
	if $g(^DHCDocCureConfig("InitTabPerStateData"))=1 {
		q "已初始化过数据，如需再次初始化请联系产品组咨询！"
	}
	s InitData="Report^报到^5"
	s InitData=InitData_$c(1)_"Wait^等候^3"
	s InitData=InitData_$c(1)_"Call^正在呼叫^1"
	s InitData=InitData_$c(1)_"WaitCall^等候呼叫^2"
	s InitData=InitData_$c(1)_"Complete^已完成^4"
	s InitData=InitData_$c(1)_"Pass^过号^6"
	s ret=0
	ts
	f i=1:1:$l(InitData,$c(1)) {
		s Date=$p(InitData,$c(1),i)
		s code=$p(Date,"^",1)
		s desc=$p(Date,"^",2)
		s Priority=$p(Date,"^",3)
		continue:(code="")!(desc="")
		&sql(insert into SQLUser.DHC_DocCurePerState (DDCPS_Code, DDCPS_Desc, DDCPS_Priority) values (:code, :desc, :Priority))
		s ret=ret+SQLCODE
	}
	
	if ret'=0 {
		tro
		q "数据初始化失败"
	}
	tc
	s ^DHCDocCureConfig("InitTabPerStateData")=1
	q "数据初始化成功"
InitTabPerStateDataErr
	s $zt=""
	q "数据初始化异常：ErrCode="_$ze
}

/// Description:提供给叫号组接口，根据服务组ID得到当前处于呼叫状态的人员信息
/// Input:ServiceGroupId服务组ID,LocId科室ID
/// OutPut:当前处于呼叫状态的人员信息
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetTreatCallInfo(6,68)
ClassMethod GetTreatCallInfo(ServiceGroupId, LocId, SearchDate As %String = "")
{
	k ^DHCVISTreatCallN(+$h-1)
	s StartDate=+$h
	s EndDate=+$h
	s Info="",Str=""
	s ResRowId="" for  s ResRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId)) q:ResRowId=""  d
	.for ASDate=StartDate:1:EndDate  d
	..s RSRowId="" for  s RSRowId=$o(^DHCDocCureRBCResSchdule(0,"LocId-Res-Date",LocId,ResRowId,ASDate,RSRowId)) q:RSRowId=""  d
	...s DDCRSStatus=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",9)
	...Q:DDCRSStatus'="N"
	...s ServiceGroupDR=$p($g(^DHCDocCureRBCResSchdule(RSRowId)),"^",8)
	...Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
	...s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId)) Q:DCARowId=""  d
	....s Adm=$p($g(^DHCDocCure(DCARowId)),"^",1)
	....s:Adm'="" PapmiDr=$p($g(^PAADM(Adm)),"^",1),AdmType=$p($g(^PAADM(Adm)),"^",2)
	....s:Adm'="" AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	....s:$g(AdmDepId)'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	....s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	....Q:rtn=""
	....s PatientInfo=$p(rtn,$c(1),1)
	....s PatientNo=$p(PatientInfo,"^",2)
	....s PatientName=$p(PatientInfo,"^",3)
	....//s PatientName=PatientNo_"-"_PatientName
	....s CureAppInfo=$p(rtn,$c(1),2)
	....s Project=$p(CureAppInfo,"^",1)   //项目
	....s Project=$tr(Project,"0123456789")
	....i Project["(" s Project=$p(Project,"(",1)
	....s State=$p(CureAppInfo,"^",2)     //预约
	....s GroupName=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupId)),"^",2)
	....s DCAAChildSub="" for  s DCAAChildSub=$o(^DHCDocCure(0,"RBAS",RSRowId,DCARowId,DCAAChildSub))  Q:DCAAChildSub=""  d
	.....s DCAARowId=DCARowId_"||"_DCAAChildSub
	.....s DCAAStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",7)
	.....q:DCAAStatus'="I"
	.....s CallStatus=$p($g(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub)),"^",12)
	.....q:CallStatus'="Y"
	.....s Str=GroupName_","_PatientName_","_Project_","_State
	.....i Info="" s Info=Str
	.....e  s Info=Info_","_Str
	.....//q:($D(^TempDHCVISTreatCall(+$h,"GetTreatCallInfo",ServiceGroupId))=1)
	.....s ^DHCVISTreatCallN(+$h,"GetTreatCallInfo",ServiceGroupId,PatientNo)=Str
	s DCARowId="" for  s DCARowId=$o(^DHCDocCure(0,"CallStatus","Y",DCARowId)) Q:DCARowId=""  d
	.s rtn=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DCARowId)
	.Q:rtn=""
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s ServiceGroupDR=$p(CureAppInfo,"^",21)
	.Q:(ServiceGroupId'="")&&(ServiceGroupDR'=ServiceGroupId)
	.s CallStatus=$p(^DHCDocCure(DCARowId),"^",16)
	.s PatientInfo=$p(rtn,$c(1),1)
	.s PatientNo=$p(PatientInfo,"^",2)
	.s PatientName=$p(PatientInfo,"^",3)
	.s GroupName=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR)),"^",2)
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s Project=$p(CureAppInfo,"^",1)   //项目
	.s Project=$tr(Project,"0123456789")
	.i Project["(" s Project=$p(Project,"(",1)
	.s State=$p(CureAppInfo,"^",2)     //预约
	.s Str=GroupName_","_PatientName_"(现场号)"_","_Project_","_State
	.i Info="" s Info=Str
	.e  s Info=Info_","_Str
	.s ^DHCVISTreatCallN(+$h,"GetTreatCallInfo",ServiceGroupId,PatientNo)=Str
	q Info
}

/// Description:更新治疗记录呼叫状态
/// w ##class(DHCDoc.DHCDocCure.Appointment).GetTreatCallInfo(6)
ClassMethod UpdateTreatCallStatus(DCAARowId, Status, CallUserId As %String = "")
{
	if (CallUserId="")&&($d(%session)){
		s CallUserId=%session.Get("LOGON.USERID")	
	}
	;清空呼叫状态或过号时将呼叫锁定用户清空
	if Status'="Y" s CallUserId=""
	s ret=0
	if DCAARowId["||"{
		k PLIST
		s PLIST(14)=Status
		s PLIST(19)=CallUserId
		&sql(update DHC_DocCureAppArrive VALUES :PLIST() where DCAA_RowId = :DCAARowId)
		s ret=SQLCODE
		if ret'=0{
			s ret="-11001"	
		}
	}else{
		s obj=##class(User.DHCDocCureApp).%OpenId(DCAARowId)
		if $IsObject(obj){
			s obj.DCACallStatus=Status
			d obj.DCACallUserDRSetObjectId(CallUserId)
		}
		s sc=obj.%Save()
		If $$$ISERR(sc){
		    s ret="-11001"
	    }
		d obj.%Close()
	}
	q ret
}

ClassMethod insertPerState(code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "", showname As %Library.String = "")
{
	s ccode = ""
	&sql(SELECT DDCPS_RowID into :ccode FROM SQLUser.DHC_DocCurePerState where DDCPS_Code=:code)
	if ccode="" d inbor
	
	q:ccode'="" ccode
	q SQLCODE
inbor
	&sql(insert into SQLUser.DHC_DocCurePerState
	(DDCPS_Code,DDCPS_Desc,DDCPS_Priority,DDCPS_ShowName)
	values(:code,:name,:memo,:showname))
}

ClassMethod updatePerState(code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "", rowid As %Library.String = "", showname As %Library.String = "")
{
	s ccode = ""
	&sql(SELECT DDCPS_RowID into :ccode FROM SQLUser.DHC_DocCurePerState where (DDCPS_Code=:code and DDCPS_RowID<>:rowid))
	if ccode="" d inbor
	q:ccode'="" ccode
	q SQLCODE
inbor
	&sql(update SQLUser.DHC_DocCurePerState
	set DDCPS_Code=:code,DDCPS_Desc=:name,DDCPS_Priority=:memo,DDCPS_ShowName=:showname
	where DDCPS_RowID=:rowid)
}

Query FindDHCPerState() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tmemo:%String,Tid:%String,Tshowname:%String")
{
	SELECT DDCPS_Code,DDCPS_Desc,DDCPS_Priority,DDCPS_RowID,DDCPS_ShowName
	 From SQLUser.DHC_DocCurePerState
}

}
