Import SQLUser

Class web.PilotProject.DHCDocPilotProPat Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod SaveMethod(myProPatInfo As %String, PPRowId As %String, USERID As %String, PPPAPPPADr As %String = "", InHosp = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).SaveMethod($List(^gry("SaveMethod"),1),$List(^gry("SaveMethod"),2))
	s ^gry("SaveMethod",1)=$lb(myProPatInfo,PPRowId,USERID)
	n (myProPatInfo,PPRowId,USERID,PPPAPPPADr,InHosp)
	i InHosp="" {
		s myrtn="-120"
		goto errDescription
	}
	s HasStage=##class(web.PilotProject.Com.Func).HasStage(PPRowId)
	i HasStage'=1 {
		s myrtn=HasStage
		goto errDescription
	}
	s myrtn=0,errDesc=""
	s myProPatObj=##class(web.PilotProject.PPA.DHCDocPilotProPat).%New()
	d myProPatObj.XMLNodeDeserialize(.myProPatObj, "DHCDocPilotProPat", myProPatInfo)
	i $l(myProPatObj.AgreementDate,"/")=3 s myProPatObj.AgreementDate=$zdh( myProPatObj.AgreementDate,4)
	i $l(myProPatObj.AgreementDate,"-")=3 s myProPatObj.AgreementDate=$zdh( myProPatObj.AgreementDate,3)
	i $l(myProPatObj.ExitDate,"/")=3 s myProPatObj.ExitDate=$zdh(myProPatObj.ExitDate,4)
	i $l(myProPatObj.ExitDate,"-")=3 s myProPatObj.ExitDate=$zdh(myProPatObj.ExitDate,3)
	s AgreementDate= myProPatObj.AgreementDate
	s myrtn=..CheckSaveData(myProPatObj,PPRowId,USERID,InHosp)
	if +myrtn'=0 goto errDescription
	
	s ExistPatRowId=..CheckProPatExist(PPRowId,myProPatObj.PatientID)
	;更新病人限额，备注或者其他信息
	if ExistPatRowId'="" s myrtn=..UpdateProPatOtherInfo(myProPatObj,ExistPatRowId,InHosp)
	if +myrtn'=0 s myrtn="-110"
	if +myrtn'=0 goto errDescription
	;更新病人健康医护人员
	if (myProPatObj.PatientID'="") s myrtn=..UpdatePatHCP(myProPatObj.PatientID,myProPatObj.HealthCareProviderDr)
	if +myrtn'=0 s myrtn="-115"
	;检查项目人数限制
	s myrtn=##class(web.PilotProject.Extend.PatAdd).CheckMaxNum(PPRowId)
	if +myrtn'=0 s myrtn="-121"
	if +myrtn'=0 goto errDescription
	TS
	if ExistPatRowId'="" {
		s UObj=##class(User.DHCDocPilotProPat).%OpenId(ExistPatRowId)
		s VisitStatus=UObj.PPPVisitStatus
		if VisitStatus="N" {
			s myrtn="-108"
		}else{
			s UObj.PPPVisitStatus="N"
			d UObj.PPPCreateDepartmentDrSetObjectId(myProPatObj.PPPCreateDepartmentDr)
			d UObj.PPPCreateUserDrSetObjectId(myProPatObj.PPPCreateUserDr)
			s UObj.PPPCreateDate=..%SysDate()
			s UObj.PPPScreenNo=myProPatObj.ScreenNo
			s UObj.PPPCreateTime=..%SysTime()
			
			Set sc = UObj.%Save()
			s PPPPPParRef=UObj.%Id()
			b ;ProjectPatUpdate
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-109"
			}
		}
		
		d UObj.%Close()
	}else{
		s UObj=##class(User.DHCDocPilotProPat).%New(PPRowId)
		;myProPatObj.EpisodeID
		s defaultStage=##class(web.PilotProject.Extend.PatAdd).GetStageBySeqno(PPRowId,1)
		d UObj.PPPPPParRefSetObjectId(PPRowId)
		d UObj.PPPPapmiDrSetObjectId(myProPatObj.PatientID)
		s UObj.PPPVisitStatus=myProPatObj.PPPVisitStatus
		d UObj.PPPCreateDepartmentDrSetObjectId(myProPatObj.PPPCreateDepartmentDr)
		s UObj.PPPReMark=myProPatObj.PPPReMark
		d UObj.PPPCreateUserDrSetObjectId(myProPatObj.PPPCreateUserDr)
		s UObj.PPPCreateDate=..%SysDate()
		s UObj.PPPScreenNo=myProPatObj.ScreenNo
		s UObj.PPPCreateTime=..%SysTime()
		s UObj.PPPPatientLimit=myProPatObj.PPPPatientLimit
		s UObj.PPPAgreementDate=myProPatObj.AgreementDate
		s UObj.PPPExitDate=myProPatObj.ExitDate
		d UObj.PPPStageSetObjectId(defaultStage)
		
		Set sc = UObj.%Save()
		s PPPPPParRef=UObj.%Id()
		b ;ProjectSave
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-104"
		}
		d UObj.%Close()
	}
	
	if (+myrtn=0)&&(myProPatObj.EpisodeID'="") {
		;插入子表DHCDocPilotProPatAdm
		s myrtn=..InsertProPatAdm(PPPPPParRef,myProPatObj.EpisodeID,PPPAPPPADr,myProPatObj.AllFreeFlag,InHosp)
	}
	if (+myrtn=0) {
		;更新第一例受试者日期
		s FirstPatDate=$p($g(^DHCDocPP(PPRowId)),"^",96)
		s FirstFormConsentDate=$p($g(^DHCDocPP(PPRowId)),"^",100)
		s Tdate=..%SysDate()
		if (FirstPatDate=""){
		&sql(Update dhc_docpilotproject set PP_FirstPatDate=:Tdate where PP_RowId=:PPRowId)	
	    s myrtn=SQLCODE
		}
		if (FirstFormConsentDate=""){
		&sql(Update dhc_docpilotproject set PP_FirstPatDate=:AgreementDate where PP_RowId=:PPRowId)	
	    s myrtn=SQLCODE
		} 
	}
	
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
errDescription
	if myrtn'="0" s errDesc="保存失败."
	if myrtn="-104" s errDesc="插入项目病人数据失败."
	if myrtn="-105" s errDesc="没有就诊,病人需要挂号"
	if myrtn="-106" s errDesc="更新项目病人子表DHCDocPilotProPatAdm数据失败."
	if myrtn="-107" s errDesc="插入项目病人子表DHCDocPilotProPatAdm数据失败."
	if myrtn="-108" s errDesc="本项目此病人已经存在."
	if myrtn="-109" s errDesc="更新病人状态失败."
	if myrtn="-110" s errDesc="更新病人其他信息失败."
	if myrtn="-111" s errDesc="请将配置中的挂号次数设置成一次或每次."
	if myrtn="-112" s errDesc="此病人已经在本项目中存在."
	if myrtn="-113" s errDesc="此病人已经在其他科研项目中存在."
	if myrtn="-114" s errDesc="还没有汇款财务接收记录,不能加入受试病人."
	if myrtn="-119" s errDesc="没有账号信息,不能加入受试病人."
	if myrtn="-120" s errDesc="参数院区ID为空！."
	if myrtn="-121" s errDesc="超过项目最大限制人数."
	if myrtn="-122" s errDesc="项目没有设置阶段！"
	if myrtn="-123" s errDesc="项目没有设置第一阶段！"
	
    Q +myrtn_"^"_errDesc
}

ClassMethod UpdatePatHCP(PatientID As %String, HealthCareProviderDr As %String)
{
	TS
	&sql(Update SQLUser.Pa_Person set PAPER_HCP_DR=:HealthCareProviderDr where PAPER_RowId=:PatientID)
	if SQLCODE TRO
	TC
	
	Q SQLCODE
}

ClassMethod InsertProPatAdm(ParRef As %String, PAADMRowId As %String, PPPAPPPADr As %String = "", AllFreeFlag As %String = "", InHosp = "") As %String
{
	n (ParRef,PAADMRowId,PPPAPPPADr,AllFreeFlag,InHosp)
	s myrtn=0
	s ^DHCDocConfig("PilotProReg")=1
	Q:InHosp="" "-120"
	//s CFConReg=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotProReg")  ;是否需要挂号配置
	s CFConReg=##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(InHosp,"PilotProReg")
	if (CFConReg>0)&&(PAADMRowId="") s myrtn="-105"   ;没有就诊,病人需要挂号
	Q:myrtn'=0
	
	;不需要挂号,应当在此插入就诊记录
	if (CFConReg<1) {
		Q "-111"
	}else{
	;需要挂号,在就诊列表上操作
		s AdmLoc=$p(^PAADM(PAADMRowId),"^",4)
		s AdmDoc=$p(^PAADM(PAADMRowId),"^",9)
		s ActiveFlag="Y"
		s ExistRowId=..CheckProPatAdmExist(ParRef,PAADMRowId)
		if ExistRowId'="" {
			s ActiveFlag=$p(^DHCDocPPPA(+ExistRowId,$p(ExistRowId,"||",2),$p(ExistRowId,"||",3)),"^",4)
			if ActiveFlag="N" {
				s ActiveFlag="Y"
				s ProAdmObj=##class(User.DHCDocPilotProPatAdm).%OpenId(ExistRowId)
				s ProAdmObj.PPPAActiveFlag=ActiveFlag
				i PPPAPPPADr'=""  d ProAdmObj.PPPAPPPADrSetObjectId(PPPAPPPADr)
				S sc = ProAdmObj.%Save()
				b ;ProPatAdmSave
				If ($System.Status.IsError(sc))
				{
					Do $System.Status.DisplayError(sc)
					Set myrtn = "-106"
					Q myrtn
				}
			}else{
				;更新其他信息
				s ProAdmObj=##class(User.DHCDocPilotProPatAdm).%OpenId(ExistRowId)
				i AllFreeFlag="on" s AllFreeFlag="Y"
				e  s AllFreeFlag="N"
				s ProAdmObj.PPPAAllFreeFlag=AllFreeFlag
				S sc = ProAdmObj.%Save()
				b ;ProPatAdmSave 1
				If ($System.Status.IsError(sc))
				{
					Do $System.Status.DisplayError(sc)
					Set myrtn = "-106"
					Q myrtn
				}
			}
		}else{
			s ActiveFlag="Y"
			s PPPCreateDepartmentDr=$p(^DHCDocPPP(+ParRef,$p(ParRef,"||",2)),"^",4)
			s PPPCreateUserDr=$p(^DHCDocPPP(+ParRef,$p(ParRef,"||",2)),"^",5)
			s ProAdmObj=##class(User.DHCDocPilotProPatAdm).%New(ParRef)
			d ProAdmObj.PPPAPPPParRefSetObjectId(ParRef)
			d ProAdmObj.PPPAAdmDrSetObjectId(PAADMRowId)
			d ProAdmObj.PPPALocDrSetObjectId(AdmLoc)
			d ProAdmObj.PPPADocDrSetObjectId(AdmDoc)
			s ProAdmObj.PPPAActiveFlag=ActiveFlag
			s ProAdmObj.PPPADateAdd=..%SysDate()
			s ProAdmObj.PPPATimeAdd=..%SysTime()
			s ProAdmObj.PPPANote1=PPPCreateDepartmentDr
			s ProAdmObj.PPPANote2=PPPCreateUserDr
			i PPPAPPPADr'=""  d ProAdmObj.PPPAPPPADrSetObjectId(PPPAPPPADr)
			i AllFreeFlag="on" s AllFreeFlag="Y"
			e  s AllFreeFlag="N"
			s ProAdmObj.PPPAAllFreeFlag=AllFreeFlag
			S sc = ProAdmObj.%Save()
			b ;ProPatAdmSave
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-107"
				Q myrtn
			}
		}
		d ProAdmObj.%Close()
	}
	
	Q myrtn
}

ClassMethod UpdateProPatOtherInfo(myProPatObj As web.PilotProject.PPA.DHCDocPilotProPat, PPPRowId As %String, InHosp = "") As %String
{
	Q:InHosp="" "-120"
	s PatientLimit=+myProPatObj.PPPPatientLimit
	s ReMark=myProPatObj.PPPReMark
	s AgreementDate=myProPatObj.AgreementDate
	s ExitDate=myProPatObj.ExitDate
	s ScreenNo=myProPatObj.ScreenNo
	i myProPatObj.AllFreeFlag="on" s myProPatObj.AllFreeFlag="Y"
	else  s myProPatObj.AllFreeFlag="N"
	s AllFreeFlag=myProPatObj.AllFreeFlag
	TS
	&sql(Update SQLUser.DHC_DocPilotProPat set PPP_PatientLimit=:PatientLimit,PPP_ReMark=:ReMark,PPP_AgreementDate=:AgreementDate,PPP_ExitDate=:ExitDate,PPP_ScreenNo=:ScreenNo where PPP_RowId=:PPPRowId)
	if SQLCODE {
		TRO
		Q SQLCODE
	}
	;更新科研病人子表就诊关联表的信息
	s myrtn=..InsertProPatAdm(PPPRowId,myProPatObj.EpisodeID,"",myProPatObj.AllFreeFlag,InHosp)
	i myrtn'=0 {
		TRO
		Q myrtn
	}	
	
	TC
	
	Q SQLCODE
}

ClassMethod CheckProPatExist(ParRef As %String, PAPMIRowId As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).CheckProPatExist(16,132478)
	n (ParRef,PAPMIRowId)
	s rtn=""
	s find=0
	s PPRowId=+ParRef
	s PPPRowId=0
	for {
		s PPPRowId=$O(^DHCDocPPP(PPRowId,PPPRowId)) q:(PPPRowId="")||(find=1)
		s SelPAPMIDr=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
		if SelPAPMIDr=PAPMIRowId s find=1
		Q:find=1
	}
	if find=1 s rtn=PPRowId_"||"_PPPRowId
	
	Q rtn
}

ClassMethod CheckProPatAdmExist(ParRef As %String, PAADMRowId As %String) As %String
{
	n (ParRef,PAADMRowId)
	s rtn=""
	s find=0
	s PPRowId=+ParRef
	s PPPRowId=$P(ParRef,"||",2)
	s PPPARowId=0
	for {
		s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)) q:(PPPARowId="")||(find=1)
		s SelAdmDr=$p($G(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId)),"^",1)
		if SelAdmDr=PAADMRowId s find=1
		Q:find=1
	}
	if find=1 s rtn=PPRowId_"||"_PPPRowId_"||"_PPPARowId
	
	Q rtn
}

ClassMethod CheckSaveData(myProPatObj As web.PilotProject.PPA.DHCDocPilotProPat, PPRowId As %String, USERID As %String, InHosp) As %String
{
	s myrtn=0
	q:InHosp="" "-120"
	;有汇款记录才能加入受试者配置
	s CFPatAddNeedProRem=##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(InHosp,"PatAddNeedProRem")
	s CFConReg=##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(InHosp,"PilotProReg")
	;s CFPatAddNeedProRem=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PatAddNeedProRem")
	;s CFConReg=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotProReg")  ;是否需要挂号配置
	if (CFConReg>0)&&(myProPatObj.EpisodeID="") s myrtn="-105"   ;没有就诊,病人需要挂号
	Q:+myrtn'=0 myrtn
	
	s ActiveProPatID=..GetActiveProPatID(myProPatObj.PatientID)
	if +ActiveProPatID=PPRowId s myrtn="-112"
	else  if ActiveProPatID'="" s myrtn="-113"
	;判断必须有PI的账号才可以加入研究者,如果使用科研中心管理系统才涉及.临床试验管理不控制.
	;s account=##class(web.PilotProject.DHCDocPilotProCommon).GetAccount(PPRowId,USERID)
	;if (account="") s myrtn="-119"
	i CFPatAddNeedProRem=1 {
		s RemAmount=0
		s RemAmount=##class(web.PilotProject.DHCDocPilotProject).GetRemNum(PPRowId,USERID)
		s ^QP("RemAmount")=$LB(PPRowId,USERID,RemAmount)
		;&sql(Select Sum(PPR_RemAmount) into :RemAmount from SQLUser.DHC_DocPilotProRem where PPR_PP_ParRef=:PPRowId and PPR_State="A")
		if RemAmount'>0 s myrtn="-114"
	}
	
	Q myrtn
}

/// w ##class(web.PilotProject.DHCDocPilotProPat).GetProPatStrByProID(19)
ClassMethod GetProPatStrByProID(PPRowId As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetProPatStrByProID(16)
	s ^gry("GetProPatStrByProID")=PPRowId
	Q:PPRowId="" ""
	
	s rtnStr=""
	s PPPRowId=0
	for {
	    s PPPRowId=$O(^DHCDocPPP(PPRowId,PPPRowId)) Q:PPPRowId=""
	    s PPPPapmiDr=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
	    s PPPVisitStatus=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
	    s PPPID=PPRowId_"||"_PPPRowId
	    if " C O R "[(" "_PPPVisitStatus_" ") continue
	    s PatDesc=""
		if PPPPapmiDr'="" {
			s PatDesc=$p($g(^PAPER(PPPPapmiDr,"ALL")),"^",1)
			if rtnStr="" s rtnStr=PPPPapmiDr_$C(1)_PatDesc_$C(1)_PPPID
			else  s rtnStr=rtnStr_"^"_PPPPapmiDr_$C(1)_PatDesc_$C(1)_PPPID
		}
    }
	
	Q rtnStr
}

/// 得到项目病人的附属信息
/// w ##class(web.PilotProject.DHCDocPilotProPat).GetProPatInfo(59,19)
ClassMethod GetProPatInfo(PatientID, PPRowId)
{
	s myXML=""
	s ExistPatRowId=..CheckProPatExist(PPRowId,PatientID)
	Q:ExistPatRowId="" myXML
	s UObj=##class(User.DHCDocPilotProPat).%OpenId(ExistPatRowId)
	s PPPReMark=UObj.PPPReMark
	s PPPPatientLimit=UObj.PPPPatientLimit
	s AgreementDate=UObj.PPPAgreementDate
	i AgreementDate'="" s AgreementDate=..%ZD(AgreementDate) //$zd(AgreementDate,4)
	s ExitDate=UObj.PPPExitDate
	i ExitDate'="" s ExitDate=..%ZD(ExitDate) //$zd(ExitDate,4)
	
	s PPPAChildSub=$O(^DHCDocPPPA(+ExistPatRowId,$p(ExistPatRowId,"||",2),""),-1)
	i PPPAChildSub'="" {
		s PPPAllFreeFlag=$p($g(^DHCDocPPPA(+ExistPatRowId,$p(ExistPatRowId,"||",2),PPPAChildSub)),"^",10)
		i PPPAllFreeFlag="Y" s PPPAllFreeFlag=1
		e  s PPPAllFreeFlag=0
	}
	
	s PPPScreenNo=UObj.PPPScreenNo
	;得到合同单位
	s HealthCareProvider=""
	s HealthCareProviderDr=$p($g(^PAPER(PatientID,"PER",4)),"^",17)
	i HealthCareProviderDr'="" s HealthCareProvider=$p(^CT("HCP",HealthCareProviderDr),"^",2)
	s myXML="<ProPatInfo><PPPReMark>"_PPPReMark_"</PPPReMark><PPPPatientLimit>"_PPPPatientLimit_"</PPPPatientLimit><AgreementDate>"_AgreementDate_"</AgreementDate><ExitDate>"_ExitDate_"</ExitDate>"
	s myXML=myXML_"<HealthCareProviderDr>"_HealthCareProviderDr_"</HealthCareProviderDr><HealthCareProvider>"_HealthCareProvider_"</HealthCareProvider>"_"<AllFreeFlag>"_PPPAllFreeFlag_"</AllFreeFlag>"_"<ScreenNo>"_PPPScreenNo_"</ScreenNo>"_"</ProPatInfo>"
	Q myXML
}

ClassMethod CancelMethod(PPRowId As %String, PatientID As %String, PPPCancelUserDr As %String, CancelReason As %String, CancelVisitStatus As %String, Auto As %String = "", ExitDate As %String = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).CancelMethod("16","1","5797","","C")
	s ^gry("SaveMethod")=$lb(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus)
	n (PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus,Auto,ExitDate)
	
	s myrtn=0,errDesc=""
	
	s ExistPatRowId=..CheckProPatExist(PPRowId,PatientID)
	if ExistPatRowId="" goto errDescription1   ;找不到可取消的病人,返回正常结果,界面没有变化
	if (ExitDate["-") s ExitDate=$zdh(ExitDate,3)
	if (ExitDate["/") s ExitDate=$zdh(ExitDate,4)
	//
	Ts
	s PatRowId=0
	for {
		s PatRowId=$o(^DHCDocPPP(PPRowId,PatRowId)) Q:(PatRowId="")||(+myrtn'=0)
		s SelPatRowId=PPRowId_"||"_PatRowId
		s AddProDate=$P($g(^DHCDocPPP(PPRowId,PatRowId)),"^",6)
		if (ExitDate'="")&&(ExitDate<AddProDate)&&((CancelVisitStatus="R")||(CancelVisitStatus="C")) {
			s myrtn="-106" Q
		}
		s UObj=##class(User.DHCDocPilotProPat).%OpenId(SelPatRowId)
		s SelPapmiDr=UObj.PPPPapmiDrGetObjectId()
		if (SelPapmiDr'=PatientID) continue
		s UObj.PPPVisitStatus=CancelVisitStatus
		if Auto'=1 {
			if (ExitDate'="") s UObj.PPPCancelDate=ExitDate
			else  s UObj.PPPCancelDate=..%SysDate()
		}
		d UObj.PPPCancelUserDrSetObjectId(PPPCancelUserDr)
		s UObj.PPPCancelReason=CancelReason
		
		Set sc = UObj.%Save()
		s PPPPPParRef=UObj.%Id()
		b ;ProjectSave
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-104"
		}
		d UObj.%Close()
			
		if (+myrtn=0) {
			;记录每次取消原因
			d ..SaveCancelReason(PPPPPParRef,PPPCancelUserDr,CancelReason)
			;插入子表DHCDocPilotProPatAdm
			s myrtn=..UpdateProPatAdm(PPPPPParRef)
		}
	}
	
	if +myrtn=0{
		TC
	}else{
		TRO
	}
errDescription1
	if myrtn'="0" s errDesc="取消失败."
	if myrtn="-104" s errDesc="插入项目病人数据失败."
	if myrtn="-105" s errDesc="插入项目病人子表DHCDocPilotProPatAdm数据失败."
	if myrtn="-106" s errDesc="患者退出日期不能早于加入日期"
    Q +myrtn_"^"_errDesc
}

ClassMethod SaveCancelReason(PPPPPParRef As %String, PPPCancelUserDr As %String, CancelReason As %String) As %String
{
	s i=+$O(^DHCDocPPPR(+PPPPPParRef,$p(PPPPPParRef,"||",2),""),-1)+1
	s ^DHCDocPPPR(+PPPPPParRef,$p(PPPPPParRef,"||",2),i)=PPPCancelUserDr_"^"_CancelReason_"^"_+$H_"^"_..%SysTime()
	
	q 0
}

ClassMethod UpdateProPatAdm(ParRef As %String) As %String
{
	&sql(update SQLUser.DHC_DocPilotProPatAdm set PPPA_ActiveFlag="N" where PPPA_PPP_ParRef=:ParRef)
	
	Q:SQLCODE=100 0
	Q SQLCODE
}

ClassMethod GetPatNoByID(EpisodeID As %String, PatientID As %String) As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetPatNoByID("","")
	if EpisodeID'="" {
		s PAPMIRowId=$p(^PAADM(EpisodeID),"^",1)
		S PatNo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",2)
		
		Q PatNo
	}elseif PatientID'="" {
		S PatNo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",2)
		
		Q PatNo
	}else {
		Q ""
	}
}

ClassMethod SetDefaultPilotPro(PPRowId As %String, myrtnStr As %String, EpisodeID As %String) As %String
{
	n (PPRowId,myrtnStr,EpisodeID)
	s find=0
	for i=1:1:$l(myrtnStr,$C(2)) {
		s SelStr=$p(myrtnStr,$C(2),i)
		s SelPPRowId=$p(SelStr,$C(1),1)
		s SelPPDesc=$p(SelStr,$C(1),2)
		s DefaultFlag=$p(SelStr,$C(1),3)
		if SelPPRowId=PPRowId {
			s $P(myrtnStr,$C(2),i)=SelPPRowId_$C(1)_SelPPDesc_$C(1)_"Y"
			s find=1
		}else{
			s $P(myrtnStr,$C(2),i)=SelPPRowId_$C(1)_SelPPDesc_$C(1)_"N"
		}
	}
	if (find=1)&&(PPRowId'="") {
		s ^TMPFacePilotFlag(EpisodeID)="Y"
	}else{
		s ^TMPFacePilotFlag(EpisodeID)="N"
	}

	Q myrtnStr
}

ClassMethod GetFacePilotFlag(Para As %String, PPRowId As %String) As %String
{
	n (Para,PPRowId)
	if (PPRowId'="")&&($Get(^TMPFacePilotFlag(Para))="Y") q "Y"
	q "N"
}

ClassMethod GetPilotProStr(EpisodeID As %String, UserID As %String) As %String
{
	s ^TMPgry("GetPilotProStr",EpisodeID)=UserID
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetPilotProStr("7000353","716")
	s UserProStr="",PatProStr="",myrtnStr=""
	s PAPMIRowId=$p(^PAADM(EpisodeID),"^",1)
	;数据量大后需要用索引取数据
	;取用户可以管理的科研项目
	s langid=..%LanguageID()
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPP(PPRowId))
		Q:PPRowId=""
		s sflag=0
		s cflag=0
        s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
		i ProStartUserDr=UserID s sflag=1 
		s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
		i UserUserDr=UserID s sflag=1
		s child=0
		for{
			s child=$o(^DHCDocPPD(PPRowId,child))
			q:child=""  
			s ProStartUserDr1=""
			s UserUserDr1=""
			s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
			s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
			i (((UserID=ProStartUserDr1)||(UserID=UserUserDr1))&&(UserID'=""))  s sflag=1	
		}	
		s PPCRowId=0,FindPPC=""
		for {
			s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId))
			Q:PPCRowId=""
			s JionUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
			s State=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",5)
			
			if State'="N" continue
			s StartDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",6)
			s EndDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",7)
			if ((StartDate>+$h)&&(StartDate'=""))||((EndDate<+$h)&&(EndDate'="")) continue
			
			//if JionUserDr=UserID s FindPPC=PPRowId
			if JionUserDr=UserID s cflag=1
			//Q:FindPPC'=""
			
		}
		
		if ((cflag=1)||(sflag=1)){
			if (UserProStr="") s UserProStr=PPRowId
		    else  if (UserProStr'="") s UserProStr=UserProStr_"^"_PPRowId
		}
		/*
		if (UserProStr="") s UserProStr=FindPPC
		    else  if (FindPPC'="") s UserProStr=UserProStr_"^"_FindPPC
		*/
	}
	;取病人参与的科研项目
	;需要增加病人找项目的索引
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPPP(PPRowId))
		Q:PPRowId=""
		s PPPRowId=0,FindPPP=""
		for {
			s PPPRowId=$O(^DHCDocPPP(PPRowId,PPPRowId))
			Q:PPPRowId=""
			s PapmiDr=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
			s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
			if VisitState'="N" continue
			s PatientLimit=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",9)
			;if PatientLimit continue   ;判断超出限额则等同不参与项目
			if PapmiDr=PAPMIRowId s FindPPP=PPRowId
			Q:FindPPP'=""
		}
		if (PatProStr="") s PatProStr=FindPPP
		else  if (FindPPP'="") s PatProStr=PatProStr_"^"_FindPPP
	}
	Q:(PatProStr="")||(UserProStr="") ""
	for i=1:1:$l(UserProStr,"^") {
		s CompUserProID=$p(UserProStr,"^",i)
		if CompUserProID="" continue
		s FindStr=""
		for j=1:1:$l(PatProStr,"^") {
			s CompPatProID=$p(PatProStr,"^",j)
			if CompUserProID=CompPatProID {
				s TPPName=$p(^DHCDocPP(CompUserProID),"^",2)
				s TPPName= ##class(User.DHCDocPilotProject).GetTranByDesc("PPDesc",TPPName,langid)
				s FindStr=CompUserProID_$c(1)_TPPName
			}
			Q:FindStr'=""
		}
		if (myrtnStr="") s myrtnStr=FindStr
		else  if (FindStr'="") s myrtnStr=myrtnStr_$c(2)_FindStr
	}
	
	s DefaultPilotPro=""   ;设置用户默认项目
	i DefaultPilotPro'="" {
		s myrtnStr=myrtnStr_$C(2)_""_$c(1)_""   ;为list添加空项目
		if myrtnStr'="" {
			s Count=$LENGTH(myrtnStr,$C(2))
		    F i=1:1:Count {
			    S PilotProStr=$P(myrtnStr,$C(2),i)
			    if DefaultPilotPro=$P(PilotProStr,$C(1),1) d
			    .s $P(myrtnStr,$C(2),i)=PilotProStr_$C(1)_"Y"
			    e  s $P(myrtnStr,$C(2),i)=PilotProStr_$C(1)_"N"
		    }
		}
	}else{
		if myrtnStr'="" {
			s Count=$LENGTH(myrtnStr,$C(2))
		    F i=1:1:Count {
			    S PilotProStr=$P(myrtnStr,$C(2),i)
			    if i=1 d
			    .s $P(myrtnStr,$C(2),i)=PilotProStr_$C(1)_"Y"
			    e  s $P(myrtnStr,$C(2),i)=PilotProStr_$C(1)_"N"
		    }
		}
	}
	
	Q myrtnStr
}

ClassMethod FindProPatByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProPatByUserExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##class(web.PilotProject.DHCDocPilotProPat).GetUserProStr(716)

ClassMethod GetUserProStr(UserID As %String) As %String
{
	n (UserID)
	s UserProStr=""
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPP(PPRowId))
		Q:PPRowId=""
		s sflag=0
		s cflag=0
	s ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
	i ProStartUserDr=UserID s sflag=1
	s UserUserDr=$p($g(^DHCDocPP(PPRowId)),"^",101)
	i UserUserDr=UserID s sflag=1
	s child=0
	for{
		 s child=$o(^DHCDocPPD(PPRowId,child))
		 q:child=""  
	s ProStartUserDr1=""
	s UserUserDr1=""
	s ProStartUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",2)
	s UserUserDr1=$p($g(^DHCDocPPD(PPRowId,child)),"^",3)
	i (((UserID=ProStartUserDr1)||(UserID=UserUserDr1))&&(UserID'=""))  s sflag=1	
	}	
		
		s PPCRowId=0,FindPPC=""
		for {
			s PPCRowId=$O(^DHCDocPPC(PPRowId,PPCRowId))
			Q:PPCRowId=""
			s JionUserDr=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",1)
			s State=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",5)
			if State'="N" continue
			s StartDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",6)
			s EndDate=$p(^DHCDocPPC(PPRowId,PPCRowId),"^",7)
			if ((StartDate>+$h)&&(StartDate'=""))||((EndDate<+$h)&&(EndDate'="")) continue
			if (JionUserDr=UserID) s cflag=1
			;Q:FindPPC'=""
		}
		if ((cflag=1)||(sflag=1)){
		if (UserProStr="") s UserProStr=PPRowId
		else   s UserProStr=UserProStr_"^"_PPRowId
		}
	}
	
	Q UserProStr
}

ClassMethod GetAllProStr() As %String
{
	s AllProStr=""
	s PPRowId=0
	for {
		s PPRowId=$O(^DHCDocPP(PPRowId))
		Q:PPRowId=""
		s State=$p(^DHCDocPP(PPRowId),"^",16)
		if " N A S V "'[(" "_State_" ") continue
		if (AllProStr="") s AllProStr=PPRowId
		else  s AllProStr=AllProStr_"^"_PPRowId
	}
	
	Q AllProStr
}

ClassMethod GetActiveProPatAdmID(PPRowId As %String, PPPRowId As %String, UserLoc As %String = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetActiveProPatAdmID(2,1)
	n (PPRowId,PPPRowId,UserLoc)
	s FindAdmID=""
	s ActiveProPatAdm=..GetActiveProPatAdm(PPRowId,PPPRowId,UserLoc)
	i ActiveProPatAdm'="" {
		s FindAdmID=$p(^DHCDocPPPA(+ActiveProPatAdm,$p(ActiveProPatAdm,"||",2),$p(ActiveProPatAdm,"||",3)),"^",1)
	}
	
	Q FindAdmID
}

ClassMethod GetLastProPatAdmID(PPRowId As %String, PPPRowId As %String, UserLoc As %String = "") As %String
{
	n (PPRowId,PPPRowId,UserLoc)
	s LocType=""
	i UserLoc'="" {
		s ADMLOCID=""
		for {
			s ADMLOCID=$O(^PAC("ADMLOC",ADMLOCID)) Q:ADMLOCID=""
			s CTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",2)
			continue:UserLoc'=CTLOCDR
			s ADMLOCType=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",1)
			s LocType=ADMLOCType
			quit
		}
	}
	if LocType'="" {
		i LocType'="I" s LocType="O"
	}
	s PPPARowId="",FindAdmID=""
	for {
		s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),-1)
		Q:PPPARowId=""
		s PAAdmRowId=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
		s ActiveFlag=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",4)
		s PAAdmType=$p(^PAADM(PAAdmRowId),"^",2)
		i PAAdmType'="I" s PAAdmType="O"
		continue:(LocType'="")&&(LocType'=PAAdmType)
		s FindAdmID=PAAdmRowId
		Q:FindAdmID'=""
	}
	
	Q FindAdmID
}

ClassMethod GetActiveProPatID(PAPMIRowId As %String) As %String
{
	s ^gry("GetActiveProPatID")=PAPMIRowId
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetActiveProPatID(132478)
	n (PAPMIRowId)
	Q:PAPMIRowId="" ""
	s PPRowId="",FindProPatID=""
	for {
		s PPRowId=$O(^DHCDocPPP("PapmiDr",0,PAPMIRowId,PPRowId))
		Q:PPRowId=""
		s PPPRowId=0
		for {
			s PPPRowId=$O(^DHCDocPPP("PapmiDr",0,PAPMIRowId,PPRowId,PPPRowId))
			Q:PPPRowId=""
			s VisitStatus=$P(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
			if VisitStatus="N" s FindProPatID=PPRowId_"||"_PPPRowId
			Q:FindProPatID'=""
		}
	}
	
	Q FindProPatID
}

ClassMethod GetPatInfoByPatNo(PatNo As %String)
{
	n (PatNo)
	s myrtnStr=##class(web.DHCDocOrderEntry).GetPatientByNo(PatNo)
	
	Q myrtnStr
}

ClassMethod GetPatProInfoMethod(PPRowId As %String, PatNo As %String) As %String
{
	s ^gry("GetPatProInfoMethod")=PPRowId_","_PatNo
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetPatProInfoMethod()
	n (PPRowId,PatNo)
	Q:(PatNo="")||(PPRowId="") ""
	
	s myrtnStr=""
	s PapmiRowid=""
	s PapmiRowId=$O(^PAPERi("PAPMI_PatNo",PatNo,PapmiRowid))
	s PPPRowId=""
	s PPPRowId=$O(^DHCDocPPP("PapmiDr",0,PapmiRowId,PPRowId,PPPRowId))
	
	s PatientLimit=$P(^DHCDocPPP(PPRowId,PPPRowId),"^",9)
	s ReMark=$P(^DHCDocPPP(PPRowId,PPPRowId),"^",10)
	s myrtnStr=PatientLimit_"^"_ReMark
	
	Q myrtnStr
}

ClassMethod CheckActiveProPatIsExit(UserID As %String, EpisodeID As %String, PatientID As %String) As %String
{
	n (UserID,EpisodeID,PatientID)
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetPatNoByID("","")
	;直接走##class(web.PilotProject.DHCDocPilotProPat).GetPilotProStr(EpisodeID,UserID)方法
	;返回空则用户不能控制此病人的任何项目,不为空则可以控制部分或者全部
	/*
	if EpisodeID'="" {
		s PAPMIRowId=$p(^PAADM(EpisodeID),"^",1)
		
		Q PatNo
	}elseif PatientID'="" {
		
		Q PatNo
	}else {
		Q "0"
	}
	*/
}

ClassMethod FindProPatByUserExecute(ByRef qHandle As %Binary, CardTypeDefine, CardNo, PatientNo, PatName, StartDate, EndDate, UserID, UserLoc, PPRowId, All, PPStatus As %String = "", InHosp = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	kill ^TempFindProPatByUser($j)
	s ProStartUserDr=""
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProPat","FindProPatByUser","","","","",63137,"",4175,194)
    s CardTypeDefine=$get(CardTypeDefine),CardNo=$get(CardNo),PatientNo=$get(PatientNo),PatName=$get(PatName),StartDate=$get(StartDate),EndDate=$get(EndDate),UserID=$get(UserID),UserLoc=$get(UserLoc)
	if UserID="" Set UserID=%session.Get("LOGON.USERID")
	if UserID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	if UserLoc="" Set UserLoc=%session.Get("LOGON.CTLOCID")
	s UserLocHospDr=$p(^CTLOC(UserLoc),"^",22)
	s StartDate=..%ZDH(StartDate)
	s EndDate=..%ZDH(EndDate)
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	s langid=..%LanguageID()
	d ##class(web.PilotProject.DHCDocPilotService).TransPilotPatToInPatient(UserID,UserLoc)
	s SuperDepRowId=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("SuperDepRowId","","",InHosp)
	if (PPRowId=""){
		if SuperDepRowId=UserLoc {
			s All=""
			s UserProStr=..GetAllProStr()
		}else{
			s UserProStr=..GetUserProStr(UserID)
		}
	}
	i PPRowId'=""  s UserProStr=PPRowId
	if CardNo'="" {
		if (CardTypeDefine="") s CFRowId=$O(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
		else  s CFRowId=$O(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDefine,CardNo,""))
		if CFRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
		
		s PatientID=$p(^DHCCARD("CF",CFRowId),"^",4)
		d PatientIDFindPro
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	/****按登记号查询*****/
	if PatientNo'="" {
		s PatientNo=$e("000000000000000",1,8-$l(PatientNo))_PatientNo
		s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
		if PatientID'="" d PatientIDFindPro
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	/****按姓名查询*****/
	if PatName'="" {
		s Qflag="N"
		s name0=$$ALPHAUP^SSUTIL4(PatName)
		;先找全名
		Set PatientID=0
		For  Set PatientID=$O(^PAPERi("PAPER_PatName",name0,PatientID)) Quit:PatientID=""  Do
		.Do PatientIDFindPro
		
		For  Set name0=$O(^PAPERi("PAPER_PatName",name0)) Quit:(name0="")!(Qflag="Y")  Do
		.If $e(name0,1,$l(PatName))'[$$ALPHAUP^SSUTIL4(PatName) d
		..Set Qflag="Y" 
		.Quit:Qflag="Y"
		.Set PatientID=0
		.For  Set PatientID=$O(^PAPERi("PAPER_PatName",name0,PatientID)) Quit:PatientID=""  Do
		..Do PatientIDFindPro
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	/****按开始日期和结束日期查询*****/
	if StartDate'="" {
		if EndDate="" s EndDate=..%SysDate()
		if StartDate>EndDate Set qHandle=$lb(0,repid,0) Quit $$$OK
		for CurDate=StartDate:1:EndDate {
			s CurPPRowId=0
			for {
				s CurPPRowId=$O(^DHCDocPPP("CreateDate",0,CurDate,CurPPRowId))
				Q:CurPPRowId=""
				s CurPPPRowId=0
				for {
					s CurPPPRowId=$O(^DHCDocPPP("CreateDate",0,CurDate,CurPPRowId,CurPPPRowId))
					Q:CurPPPRowId=""
					s PatientID=$p(^DHCDocPPP(CurPPRowId,CurPPPRowId),"^",1)
					s VisitState=$p(^DHCDocPPP(CurPPRowId,CurPPPRowId),"^",2)
			        if (PPStatus="ALL")||(PPStatus="") {
						//continue:((VisitState'="N")&& (VisitState'="R"))
					}else{
						continue:(VisitState'=PPStatus)
					}
			
			        ;i CurPPRowId="1" b //5
					d PatientIDFindPro
				}
			}
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;输出当前用户可见项目的所有病人
	for i=1:1:$l(UserProStr,"^") {
		s PPRowId=$p(UserProStr,"^",i)
		if PPRowId="" continue
		Set CreateProLoc=$p($g(^DHCDocPP(PPRowId)),"^",6)
		Set ProStartUserDr=$p($g(^DHCDocPP(PPRowId)),"^",10)
		Set ProStartDate=$p($g(^DHCDocPP(PPRowId)),"^",11)
		Set ProEndDate=$p($g(^DHCDocPP(PPRowId)),"^",13)
		Set ProState=$p($g(^DHCDocPP(PPRowId)),"^",16)
		;if ((ProStartDate>=..%SysDate())&&(ProStartDate'=""))||((ProEndDate<=..%SysDate())&&(ProEndDate'=""))||(ProState'="N") continue
		s PPPRowId=0
		for {
			s PPPRowId=$O(^DHCDocPPP(PPRowId,PPPRowId))
			Q:PPPRowId=""
			s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
			if (PPStatus="ALL")||(PPStatus="") {
				//continue:((VisitState'="N")&& (VisitState'="R"))
			}else{
				continue:(VisitState'=PPStatus)
			}
			s AddProPatUser=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",5)
			s AddProPatLoc=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",4)
			;if ((AddProPatLoc'=UserLoc)||(AddProPatUser'=UserID))&&(ProStartUserDr'=UserID) continue
			s ^gry("PPRowId",PPRowId,PPPRowId)=CreateProLoc_","_UserLoc_"^"_AddProPatUser_","_UserID
			s PatientID=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
			d OutputRow
		}
	}
	kill ^TempFindProPatByUser($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PatientIDFindPro
    ;必须已经得到PatientID、UserProStr
    s PPRowId=0
	for {
		s PPRowId=$o(^DHCDocPPP("PapmiDr",0,PatientID,PPRowId))
		Q:PPRowId=""
		if ("^"_UserProStr_"^")'[("^"_PPRowId_"^") continue
		Set CreateProLoc=$p($g(^DHCDocPP(PPRowId)),"^",6)
		Set ProStartDate=$p($g(^DHCDocPP(PPRowId)),"^",11)
		Set ProEndDate=$p($g(^DHCDocPP(PPRowId)),"^",13)
		Set ProState=$p($g(^DHCDocPP(PPRowId)),"^",16)
		;if ((ProStartDate>+$H)&&(ProStartDate'=""))||((ProEndDate>+$H)&&(ProEndDate'=""))||(ProState'="N") continue
		
		s PPPRowId=0
		for {
			s PPPRowId=$o(^DHCDocPPP(PPRowId,PPPRowId))
			Q:PPPRowId=""
			s VisitState=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",2)
			//if ((VisitState'="N")&& (VisitState'="R")) continue 
			s AddProPatUser=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",5)
			s AddProPatLoc=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",4)
			s ProPatCreate=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",6)
			//20150402 portal查询已结题的患者 是传入日期的
			continue:((StartDate'="")&&(ProPatCreate<StartDate))||((EndDate'="")&&(ProPatCreate>EndDate))
			s PapmiDr=$p(^DHCDocPPP(PPRowId,PPPRowId),"^",1)
			if PapmiDr'=PatientID continue
			d OutputRow
		}
	}
    
    Q
OutputRow
	;Do ResetVariables
	Set PAAdm=..GetActiveProPatAdmID(PPRowId,PPPRowId,UserLoc)
	if PAAdm="" s PAAdm=..GetLastProPatAdmID(PPRowId,PPPRowId)
	Q:PAAdm=""
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PAAdm)
	Q:UserLocHospDr'=AdmHospitalId
	Set EpisodeID=PAAdm
	Set mradm=$P($g(^PAADM(PAAdm)),"^",61)
	Set Loc=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",4)
	Set PAPMINO=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
	Set PAPMIName=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set Age=$fn((+$H-DobDate)/365,"",0)
	Else  Do
	.Set PAPMIDOB="",Age=""
	s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm,UserLocHospDr)
	Set Sex=$P($g(^PAPER(PatientID,"ALL")),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Else  Set PAPMISex=""
	s PAPMISex= ##class(User.CTSex).GetTranByDesc("CTSEXDesc",PAPMISex,langid)
	Set AddProDate=..%ZD($P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",6)) //$ZD($P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",6),3)
	Set AddProTime=..%ZT($P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",7),3)
	Set AddProUserDr=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",5)
	Set AddProUser=""
	if AddProUserDr'="" s AddProUser=$p($g(^SSU("SSUSR",AddProUserDr)),"^",2)
	s AddProUser=$tr(AddProUser,$C(13,10),"")
	s AddProUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AddProUser,langid)
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Q:(All'="")&&(All'="I")&&(PAAdmType="I")
	Q:(All'="")&&(All="I")&&(PAAdmType'="I")
	;q:$d(^PAC("ADMLOC",0,"AdmType","O",%session.Get("LOGON.CTLOCID")))&&(PAAdmType="I")&&(All'="on")
	;q:'$d(^PAC("ADMLOC",0,"AdmType","O",%session.Get("LOGON.CTLOCID")))&&(PAAdmType="O")&&(All'="on")
	Set Hospital=""
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	Q:(InHosp'="")&&(InHosp'=Hosp)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	s Hospital= ##class(User.CTHospital).GetTranByDesc("HOSPDesc",Hospital,langid)
	Set Ward=$P($g(^PAADM(PAAdm)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	s PAAdmWard= ##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	s PAAdmReason= ##class(User.PACAdmReason).GetTranByDesc("READesc",PAAdmReason,langid)
	
	s CancelDate="",CancelUser="",CancelReason=""
	s VisitStatus=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",2)
	i " C R "[(" "_VisitStatus_" ") {
		Set CancelDate=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",8)
		if CancelDate'="" Set CancelDate=..%ZD(CancelDate) //$ZD(CancelDate,3)
		Set CancelUserDr=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",16)
		if CancelUserDr'="" s CancelUser=$p($g(^SSU("SSUSR",CancelUserDr)),"^",2)
		Set CancelReason=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",11)
		s CancelReason= ##class(User.DHCDocCTDefineData).GetTranByDesc("DHCDocCTDefineDataDesc",CancelReason,langid)
	}
	set PPPAgreementDate=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",12)
	if PPPAgreementDate'="" Set PPPAgreementDate=..%ZD(PPPAgreementDate) //$ZD(PPPAgreementDate,3)
	If $g(mradm)'="" Set Diagnosis=##class(web.DHCDocOutPatientList).GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	Set ProPatReMark=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",10)
    s TPPDesc=$p($g(^DHCDocPP(PPRowId)),"^",2)
    s TPPDesc= ##class(User.DHCDocPilotProject).GetTranByDesc("PPDesc",TPPDesc,langid)
    ;i VisitState="R" s EpisodeID=""
    s PatStatus=..GetPatStatusByCode(VisitState)
 	s PatStatus=##class(User.DHCDocPilotProPat).GetTranByDesc("PPPVisitStatus",PatStatus,langid)
	Q:$d(^TempFindProPatByUser($j,PPPRowId,PatStatus))
    s ScreenNo=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",17)
    s StageDr=$P($g(^DHCDocPPP(PPRowId,PPPRowId)),"^",18)
    s Stage=""
    i StageDr'="" {
	    s Stage=$P(^CF.DOC.Pilot.OEStageD(StageDr),"^",1)
	    s Stage= ##class(User.DHCDocPilotProStage).GetTranByDesc("STName",Stage,langid)
    }
	set Data=$lb(PPRowId,PPPRowId,PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,AddProDate,AddProTime,AddProUser,PAAdmType,Hospital,PAAdmWard,PAAdmBed,PAAdmReason,Diagnosis,CancelDate,Age,ProPatReMark,CancelUser,CancelReason,TPPDesc,PatStatus,PPPAgreementDate,ScreenNo,VisitState,StageDr,Stage)
 	s ^TempFindProPatByUser($j,PPRowId,PPPRowId,PatStatus)=1
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
ResetVariables
    Set (PPRowId,PPPRowId,PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,AddProDate,AddProTime,AddProUser,PAAdmType,Hospital,PAAdmWard,PAAdmBed,PAAdmReason,Diagnosis,CancelDate,Age,ProPatReMark,CancelUser,CancelReason,TPPDesc,PatStatus,ScreenNo,VisitState,StageDr,Stage)=""
    Quit
}

ClassMethod FindProPatByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProPatByUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
		//
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindProPatByUser(CardTypeDefine, CardNo, PatientNo, PatName, StartDate, EndDate, UserID, UserLoc, PPRowId, All, PPStatus As %String = "", InHosp = "") As %Query(ROWSPEC = "PPRowId:%String,PPPRowId:%String,PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,AddProDate:%String,AddProTime:%String,AddProUser:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,PAAdmReason:%String,Diagnosis:%String,CancelDate:%String,Age:%String,ProPatReMark:%String,CancelUser:%String,CancelReason:%String,TPPDesc:%String,PatStatus:%String,PPPAgreementDate:%String,ScreenNo:%String,VisitState:%String,StageDr,Stage")
{
}

ClassMethod FindHealthCareProviderClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindHealthCareProviderExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHealthCareProviderExecute(ByRef QHandle As %Binary, HealthCareProvider As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProPat","FindHealthCareProvider","")
	Set repid=$I(^CacheTemp)
	s ind=1
	s HCPRowId=0
	f  s HCPRowId=$O(^CT("HCP",HCPRowId)) q:HCPRowId=""  d
	.s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2)
	.q:HCPDesc'["科研"
	.q:((HCPDesc'[HealthCareProvider) &&(HealthCareProvider'=""))
	.Do OutputRow4
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(HCPDesc,HCPRowId)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables4
	///set (repid)=0
	set (HCPDesc,HCPRowId)=""
	quit
}

ClassMethod FindHealthCareProviderFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHealthCareProviderExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindHealthCareProvider(HealthCareProvider As %String) As %Query(ROWSPEC = "HCPDesc:%String,HCPRowId:%String") [ SqlProc ]
{
}

ClassMethod GetHealthCareProviderByDoc() As %String
{
	s DocName=%session.Get("LOGON.USERNAME")
	q:DocName="" ""
	s ret=""
	s DocName=DocName_"科研"
	s HCPRowId=0
	f  s HCPRowId=$O(^CT("HCP",HCPRowId)) q:HCPRowId=""  d
	.s HCPDesc=$p($g(^CT("HCP",HCPRowId)),"^",2)
	.i HCPDesc=DocName d
	..s ret=HCPRowId_"^"_HCPDesc
	q ret
}

// 

ClassMethod GetActiveProPatAdm(PPRowId As %String, PPPRowId As %String, UserLoc As %String = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPilotProPat).GetActiveProPatAdmID(2,1)
	n (PPRowId,PPPRowId,UserLoc)
	;如果传入科室UserLoc不为空,则只找和此科室同类型(门诊/住院)的有效记录
	s LocType=""
	i UserLoc'="" {
		s ADMLOCID=""
		for {
			s ADMLOCID=$O(^PAC("ADMLOC",ADMLOCID)) Q:ADMLOCID=""
			s CTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",2)
			continue:UserLoc'=CTLOCDR
			s ADMLOCType=$p($g(^PAC("ADMLOC",ADMLOCID)),"^",1)
			s LocType=ADMLOCType
			quit
		}
	}
	if LocType'="" {
		i LocType'="I" s LocType="O"
	}
	
	s PPPARowId="",ProPatAdm=""
	for {
		s PPPARowId=$O(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),-1)
		Q:PPPARowId=""
		s PAAdmRowId=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",1)
		s ActiveFlag=$p(^DHCDocPPPA(PPRowId,PPPRowId,PPPARowId),"^",4)
		if ActiveFlag'="Y" continue
		s PAAdmType=$p($g(^PAADM(PAAdmRowId)),"^",2)
		i PAAdmType'="I" s PAAdmType="O"
		continue:(LocType'="")&&(LocType'=PAAdmType)
		s ProPatAdm=PPRowId_"||"_PPPRowId_"||"_PPPARowId
		Q:ProPatAdm'=""
	}
	
	Q ProPatAdm
}

/// CTOR: QP
/// DATE: 2021-11-16
/// DESC: 查询GCP患者状态
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProPat","QryPatStatus")
Query QryPatStatus() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryPatStatusExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s langid=..%LanguageID()
 	s str="ALL,R,C,N,O"
 	f i=1:1:$l(str,",") {
		s id=$p(str,",",i)	
		s text=..GetPatStatusByCode(id)
		s text=##class(User.DHCDocPilotProPat).GetTranByDesc("PPPVisitStatus",text,langid)
		d output4
	}
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output4
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryPatStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPatStatusExecute ]
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

ClassMethod QryPatStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPatStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-01-22
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.Stage).GetPatStatusByCode("")
ClassMethod GetPatStatusByCode(code)
{
	if code="R"  s mRtn="退出"
    else  if code="N" s mRtn="在组"
    else  if code="C" s mRtn="取消"
    else  if code="O" s mRtn="完成"
     else  if code="ALL" s mRtn="全部"
    else  s mRtn=code
    
	Q mRtn
}

}
