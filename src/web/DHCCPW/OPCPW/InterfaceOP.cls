/// Creator		: zhaoyu
/// CreateDate	: 2013-09-16
Class web.DHCCPW.OPCPW.InterfaceOP Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID("49||2")
ClassMethod GetObjByImplNewID(ImplNewID As %String) As User.DHCMRClinicalPathWayImplNew
{
	New (ImplNewID)
	Set ret=""
	Set objImplNew=##class(User.DHCMRClinicalPathWayImplNew).%OpenId(ImplNewID)
	If $IsObject(objImplNew) {
		Set ret=objImplNew
		Do objImplNew.%Close()
	}
	Quit ret
}

/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).GetStringByImplNewID("49||2")
ClassMethod GetStringByImplNewID(ImplNewID As %String) As %String
{
	New (ImplNewID)
	Set ret=""
	Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
	Quit:'$IsObject(objImplNew) ret
	Set PathWayID=objImplNew.CPWENParRef.%Id()
	Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
	Set DoctorID=objImplNew.CPWENDoctor
	Set EpisodeID=objImplNew.CPWENPaadm
	Set StepDate=objImplNew.CPWENStepStrDate
	Set:(StepDate'="") StepDate=$zd(StepDate,3)
	Set StepTime=objImplNew.CPWENStepStrTime
	Set:(StepTime'="") StepTime=$zd(StepTime,3)
	Set ret=PathWayID_"^"_EpStepID_"^"_DoctorID_"^"_EpisodeID_"^"_StepDate_"^"_StepTime
	Quit ret
}

/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByContrastID("1")
ClassMethod GetObjByContrastID(ContrastID As %String) As %String
{
	New (ContrastID)
	Set ret=""
	Set objContrast=##class(User.DHCMRClinicalPathWayContrast).%OpenId(ContrastID)
	If $IsObject(objContrast) {
		Set ret=objContrast
		Do objContrast.%Close()
	}
	Quit ret
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-09-17
/// Description	: 更新 User.DHCMRClinicalPathWayImplNew 成功：返回Id；失败：返回<0的代码
/// 1 RowID 2 StepDR 3 Doctor 4 Paadm 5 StrDate 6 StrTime
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).UpdateImplNew("1||^1||1||1^105^11111^^")
ClassMethod UpdateImplNew(InputStr As %String) As %String
{
	New (InputStr)
	Set return=-1
	Quit:(InputStr="") return
	
	Set ID=$p(InputStr,"^",1)
	Set Parref=$p(ID,"||",1)
	Set ChildSub=$p(ID,"||",2)
	
	If (ChildSub="") {
		Set obj=##class(User.DHCMRClinicalPathWayImplNew).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWayImplNew).%OpenId(ID)
		Quit:(obj="") return
	}
	
	Set objParref=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set EpStepDR=$p(InputStr,"^",2)
	Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EpStepDR)
	Quit:'$IsObject(objEpStep) return
	Set DoctorDR=$p(InputStr,"^",3)
	Set PaadmDR=$p(InputStr,"^",4)
	Quit:(DoctorDR="")!(PaadmDR="") return
	Set StrDate=$p(InputStr,"^",5)
	Set StrTime=$p(InputStr,"^",6)
	Set:StrDate["-" StrDate=$zdh(StrDate,3)
	Set:StrDate["/" StrDate=$zdh(StrDate,4)
	Set:StrTime[":" StrTime=$zth(StrTime,2)
	Set:StrDate="" StrDate=$p($h,",",1)
	Set:StrTime="" StrTime=$p($h,",",2)
	
	Set obj.CPWENParRef=objParref
	Set obj.CPWENEpStepDR=objEpStep
	Set obj.CPWENDoctor=DoctorDR
	Set obj.CPWENPaadm=PaadmDR
	Set obj.CPWENStepStrDate=StrDate
	Set obj.CPWENStepStrTime=StrTime
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-2
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// 撤销新实施记录
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).("51||3","838")
ClassMethod UpdoImplNew(ImplNewID As %String, DocID As %String) As %String
{
	New (ImplNewID,DocID)
	Set return=-1
	Set obj=##class(User.DHCMRClinicalPathWayImplNew).%OpenId(ImplNewID)
	Quit:(obj="")!(DocID="") return
	
	Set obj.CPWENUpdoDoc=DocID
	Set obj.CPWENActive="N"
	Set obj.CPWENUpdoDate=$p($h,",",1)
	Set obj.CPWENUpdoTime=$p($h,",",2)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-2
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// 门诊临床路径入径方法
ClassMethod InPathWayOP(PathWayID As %String, InputStr1 As %String, InputStr2) As %String
{
	New (PathWayID,InputStr1,InputStr2)
	Set return=-1
	Set $ZT="InPathWayError"
	If (PathWayID="") {
		TSTART
		Set flg1=##class(web.DHCCPW.MR.ClinicalPathWays).InPathWay(InputStr1)
		Set InputStr3=""
		If (flg1>0) {
			Set SubRowId=flg1_"||"
			Set InputStr3=SubRowId_"^"_InputStr2
		}
		Set flg2=##class(web.DHCCPW.OPCPW.InterfaceOP).UpdateImplNew(InputStr3)
		If (flg1>0)&&(flg2>0) {
			TCOMMIT
			Set return=flg2
		} Else {
			Set return=-2
			TROLLBACK
		}
	} Else {
		Set flg3=##class(web.DHCCPW.OPCPW.InterfaceOP).UpdateImplNew(InputStr2)
		Set return=flg3
	}
	Quit return
	
InPathWayError
	If (PathWayID="") {
		TROLLBACK
	}
	Quit return
}

/// Creator		: zhaoyu
/// CreateDate	: 2013-12-11
/// Description	: 根据就诊号及登录科室判断门诊病人是否为当前步骤
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).IsCurrStepOP(1012)
ClassMethod IsCurrStepOP(EpisodeID As %String, LocID As %String) As %String
{
	New (EpisodeID,LocID)
	Set ret="^^0^",LocID=$g(LocID)
	//Set ^TMP("zy","IsCurrStepOP",$zd($p($h,",",1),3),$zt($p($h,",",2)))=EpisodeID_"///"_LocID
	Set AdmInfo=$g(^PAADM(EpisodeID))
	Set AdmType=$p(AdmInfo,"^",2),VisitStatus=$p(AdmInfo,"^",20)
	Set AdmLoc=$p(AdmInfo,"^",4)
	Quit:(AdmType'="O")!(VisitStatus="C") ret
	
	Set PathWayID=""
	For {
		Set PathWayID=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",EpisodeID,PathWayID),-1)
		Quit:(PathWayID="")!($p(ret,"^",1)'="")
		Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
		Continue:'$IsObject(objPathWay)
		Set Status=objPathWay.CPWStatus
		Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
		Set CPWInLoc=objPathWay.CPWInLoc
		Set:(CPWInLoc="") CPWInLoc=AdmLoc
		Continue:(Status'="I")
		Continue:(LocID'="")&&(LocID'=CPWInLoc)
		Set ret=PathWayID_"^^0^"_CPWDesc
		Set ImplNewSub=""
		For {
			Set ImplNewSub=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",EpisodeID,PathWayID,ImplNewSub),-1)
			Quit:(ImplNewSub="")!($p(ret,"^",2)'="")
			Set ImplNewID=PathWayID_"||"_ImplNewSub
			Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
			Continue:'$IsObject(objImplNew)
			Set ImplNewActive=objImplNew.CPWENActive
			Continue:(ImplNewActive="N")
			Set StepStrDate=objImplNew.CPWENStepStrDate
			Set StepStrTime=objImplNew.CPWENStepStrTime
			Set CurrFlag=0
			Set:(Status="I")&&(+StepStrDate=+$h)&&(+StepStrTime<=+$p($h,",",2)) CurrFlag=1
			Set ret=PathWayID_"^"_ImplNewID_"^"_CurrFlag_"^"_CPWDesc
		}
	}
	Quit:($p(ret,"^",1)'="") ret
	
	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	Set Paadm=""
	For {
		Set Paadm=$o(^PAPERdr(PatientID,"ADM","O",Paadm),-1)
		Quit:(Paadm="")!($p(ret,"^",1)'="")
		Set AdmInfo=$g(^PAADM(Paadm))
		Set AdmType=$p(AdmInfo,"^",2),VisitStatus=$p(AdmInfo,"^",20)
		Set AdmLoc=$p(AdmInfo,"^",4)
		Continue:(AdmType'="O")!(VisitStatus="C")
		Set PathWayID=""
		For {
			Set PathWayID=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",Paadm,PathWayID),-1)
			Quit:(PathWayID="")!($p(ret,"^",1)'="")
			Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			Continue:'$IsObject(objPathWay)
			Set Status=objPathWay.CPWStatus
			Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
			Set CPWInLoc=objPathWay.CPWInLoc
			Set:(CPWInLoc="") CPWInLoc=AdmLoc
			Continue:(Status'="I")
			Continue:(LocID'="")&&(LocID'=CPWInLoc)
			Set ret=PathWayID_"^^0^"_CPWDesc
		}
	}
	Quit ret
}

/// 签名时检查变异情况
/// w ##Class(web.DHCCPW.OPCPW.InterfaceOP).ChkVarItemList("50||1","D")
ClassMethod ChkVarItemList(ImplNewID As %String, UserType As %String) As %String
{
	New (ImplNewID,UserType)
	Set return=0,Count=0
	Quit:(ImplNewID="")!(UserType="") return
	Set rs=##Class(%ResultSet).%New("web.DHCCPW.OPCPW.FormShowOP:QryVarItemListOP")
	Do rs.Execute(ImplNewID,UserType)
	While (rs.Next()) {
		Set Count=Count+1
	}
	Do rs.Close()
	Set return=Count
	Quit return
}

/// 检查步骤是否签名
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).ChkStepSign()
ClassMethod ChkStepSign(PathWayID As %String, UserID As %String, SignType As %String) As %String
{
	New (PathWayID,UserID,SignType)
	Set SignType=$g(SignType)
	Set $ZT="ChkStepSignErr"
	/*
		描述		:	完成时判断是否完成签名
		数据格式	:	Y||0-强制医生护士签名; Y||1-强制医生签名; Y||2-强制护士签名;
						N||0-提示医生护士签名; N||1-提示医生签名; N||2-提示护士签名;
		是否强制签名:	""-不判断; "Y"-强制签名; "N"-提示但不强制签名;
		是否身份校验:	"0"-全部身份校验; "1"-医生校验; "2"-护士校验;
	*/
	Set strValue=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckSignBeforeDischarge")
	Set IsCheckBeforeDisch=$p(strValue,"||",1)
	Set IsCheckCTPCPType=+$p(strValue,"||",2)
	Quit:IsCheckBeforeDisch="" "0"_$c(1)_"不检查"
	Set CPWString=##class(web.DHCCPW.MR.ClinicalPathWays).GetStringById(PathWayID,"^")
	Set Status=$p($g(CPWString),"^",9)
	Quit:(Status'="I") "-1"_$c(1)_"非入径患者!"
	Set:(UserID'="") UserType=##Class(web.DHCCPW.MR.PaPatmasSrv).getCPTInternalType(UserID)
	Set IsCheckSignType=$s(SignType="1":"DOCTOR",SignType="2":"NURSE",1:UserType)
	Quit:(IsCheckSignType'="DOCTOR")&&(IsCheckSignType'="NURSE") IsCheckBeforeDisch_$c(1)_"无法确认医疗结算、最终结算!"
	Quit:(IsCheckCTPCPType=1)&&(IsCheckSignType'="DOCTOR") "1"_$c(1)_"只检查医生"
	Quit:(IsCheckCTPCPType=2)&&(IsCheckSignType'="NURSE") "2"_$c(1)_"只检查护士"
	
	Set ImplNewSub="",IsFinishSign="Y",NotSignStep=""
	For {
		Set ImplNewSub=$o(^DHCMR("CPW",PathWayID,"IMPLNEW",ImplNewSub))
		Quit:(ImplNewSub="")
		Set ImplNewID=PathWayID_"||"_ImplNewSub
		Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
		Continue:'$IsObject(objImplNew)
		Set ImplNewDate=objImplNew.CPWENStepStrDate
		Set ImplNewTime=objImplNew.CPWENStepStrTime
		Set:(ImplNewDate'="") ImplNewDate=$zd(ImplNewDate,3)
		Set:(ImplNewTime'="") ImplNewTime=$zt(ImplNewTime)
		Set ImplNewDesc=objImplNew.CPWENEpStepDR.CPWSDesc_"("_ImplNewDate_" "_ImplNewTime_")"
		Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
		
		Set SignID=0,IsHaveSign="N"
		For {
			Set SignID=$o(^DHCMRi(0,"SIGN","IndexEpStep",PathWayID,EpStepID,SignID))
			Quit:(SignID="")!(IsHaveSign="Y")
			Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(PathWayID_"||"_SignID)
			Continue:'$IsObject(objSign)
			Set CPWSActive=objSign.CPWSActive
			Set CPWSImplNewDR=objSign.CPWSImplNewDR
			Set:$IsObject(CPWSImplNewDR) CPWSImplNewDR=CPWSImplNewDR.%Id()
			Continue:(CPWSActive'="Y")!(ImplNewID'=CPWSImplNewDR)
			Set CPWSDoctorDR=objSign.CPWSDoctorDR
			Set CPWSNurseDR=objSign.CPWSNurseDR
			Continue:(IsCheckSignType="DOCTOR")&&(CPWSDoctorDR="")	//医生签名身份校验
			Continue:(IsCheckSignType="NURSE")&&(CPWSNurseDR="")	//护士签名身份校验
			Set IsHaveSign="Y"
		}
		If (IsHaveSign="N") {
			Set IsFinishSign="N"
			Set:(ImplNewDesc'="") NotSignStep=NotSignStep_"、"_ImplNewDesc
		}
	}
	Set NotSignStep=$e(NotSignStep,2,$l(NotSignStep))
	Quit:IsFinishSign="N" IsCheckBeforeDisch_$c(1)_"当前入径表单[ "_NotSignStep_" ]步骤未完成步骤签名!"
	Quit "0"_$c(1)_"所有步骤已签名!"
	
ChkStepSignErr
	Set $ZT=""
	Quit "-999"_$c(1)_$ZError
}

/// 根据 PathWayID 获取相应的记录
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).GetImplNewStrByInd("50","1")
ClassMethod GetImplNewStrByInd(PathWayID As %String, ImplNewInd) As %String
{
	New (PathWayID,ImplNewInd)
	Set ImplNewSub="",tmpInd=0,ret=""
	For {
		Set ImplNewSub=$o(^DHCMR("CPW",PathWayID,"IMPLNEW",ImplNewSub))
		Quit:(ImplNewSub="")!(ret'="")
		Set tmpInd=tmpInd+1
		Set ImplNewID=PathWayID_"||"_ImplNewSub
		Set ImplNewStr=##class(web.DHCCPW.OPCPW.InterfaceOP).GetStringByImplNewID(ImplNewID)
		Set:(ImplNewInd=tmpInd) ret=ImplNewStr
	}
	Quit ret
}

/// 更新对照记录
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).UpdateContrast("")
ClassMethod UpdateContrast(InputStr As %String) As %String
{
	New (InputStr)
	Set ret=-1
	Quit:(InputStr="") ret
	Set ContrastID=$p(InputStr,"^",1)
	If (ContrastID="") {
		Set obj=##class(User.DHCMRClinicalPathWayContrast).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWayContrast).%OpenId(ContrastID)
		Quit:'$IsObject(obj) ret
	}
	
	Set PathwayID=$p(InputStr,"^",2)
	Set CPWCPathwayDR=##class(web.DHCCPW.MRC.CliPathWay).GetObjById(PathwayID)
	Quit:'$IsObject(CPWCPathwayDR) ret
	Set EpStepID=$p(InputStr,"^",3)
	Set CPWCEpStepDR=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EpStepID)
	Quit:'$IsObject(CPWCEpStepDR) ret
	Set EpStepItemID=$p(InputStr,"^",4)
	Set CPWCEpStepItemDR=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(EpStepItemID)
	Quit:'$IsObject(CPWCEpStepItemDR) ret
	Set CPWCContItem=$p(InputStr,"^",5)
	Quit:(CPWCContItem="") ret
	Set CPWCActive=$p(InputStr,"^",6)
	Quit:(CPWCActive'="Y")&&(CPWCActive'="N") ret
	Set CPWCContUser=$p(InputStr,"^",7)
	Set CPWCContUser=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(+CPWCContUser,"^")
	Set CPWCContUser=+CPWCContUser
	Quit:(CPWCContUser=0) ret
	Set CPWCContDate=$p(InputStr,"^",8)
	Set CPWCContTime=$p(InputStr,"^",9)
	Set:CPWCContDate["-" CPWCContDate=$zdh(CPWCContDate,3)
	Set:CPWCContDate["/" CPWCContDate=$zdh(CPWCContDate,4)
	Set:CPWCContTime[":" CPWCContTime=$zth(CPWCContTime,2)
	Set:CPWCContDate="" CPWCContDate=$p($h,",",1)
	Set:CPWCContTime="" CPWCContTime=$p($h,",",2)
	
	Set obj.CPWCPathwayDR=CPWCPathwayDR
	Set obj.CPWCEpStepDR=CPWCEpStepDR
	Set obj.CPWCEpStepItemDR=CPWCEpStepItemDR
	Set obj.CPWCContItem=CPWCContItem
	Set obj.CPWCActive=CPWCActive
	Set obj.CPWCContUser=CPWCContUser
	Set obj.CPWCContDate=CPWCContDate
	Set obj.CPWCContTime=CPWCContTime
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set ret=-2
	} Else {
		Set ret=obj.%Id()
	}
	Do obj.%Close()
	Quit ret
}

/// 撤销对照记录
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).UpdoContrast("")
ClassMethod UpdoContrast(InputStr As %String) As %String
{
	New (InputStr)
	Set ret=-1
	Set ContrastID=$p(InputStr,"^",1)
	Set UpdoUser=$p(InputStr,"^",2)
	Set obj=##class(User.DHCMRClinicalPathWayContrast).%OpenId(ContrastID)
	Quit:'$IsObject(obj) ret
	Set UpdoUser=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(+UpdoUser,"^")
	Set UpdoUser=+UpdoUser
	Quit:(UpdoUser=0) ret
	
	Set obj.CPWCActive="N"
	Set obj.CPWCUpdoUser=UpdoUser
	Set obj.CPWCUpdoDate=$p($h,",",1)
	Set obj.CPWCUpdoTime=$p($h,",",2)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set ret=-2
	} Else {
		Set ret=obj.%Id()
	}
	Do obj.%Close()
	Quit ret
}

/// 对照后增加实施记录用
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).BuildImplStr("983||17","84||4||1||15","50||3","600")
ClassMethod BuildImplStr(OeoriDR As %String, StepItemID As %String, ImplNewID As %String, User As %String) As %String
{
	New (OeoriDR,StepItemID,ImplNewID,User)
	Set ret=-1
	
	Set OrderStartDate=$p(^OEORD(+OeoriDR,"I",$P(OeoriDR,"||",2),1),"^",9)
	Set OrderStartTime=$p(^OEORD(+OeoriDR,"I",$P(OeoriDR,"||",2),1),"^",10)
	Set Doctor=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(+User,"^")
	Set Doctor=+Doctor
	Quit:(Doctor=0) ret
	
	Set ret="^"_$p(ImplNewID,"||",1)_"^"_OeoriDR_"^"_StepItemID_"^"_OrderStartDate_"^"_OrderStartTime_"^"_Doctor_"^^^"_User_"^^^^^^"_ImplNewID
	Quit ret
}

/// 检查步骤是否有签名记录
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).ChkSignList("51||1","D")
ClassMethod ChkSignList(ImplNewID As %String, UserType As %String) As %String
{
	New (ImplNewID,UserType)
	Set return=0,Count=0
	Quit:(ImplNewID="")!(UserType="") return
	Set rs=##Class(%ResultSet).%New("web.DHCCPW.OPCPW.FormShowOP:QryEpStepSigns")
	Do rs.Execute(ImplNewID,UserType)
	While (rs.Next()) {
		Set Count=Count+1
	}
	Do rs.Close()
	Set return=Count
	Quit return
}

/// 检查路径是否进行评估
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).ChkResult()
ClassMethod ChkResult(PathWayID As %String) As %String
{
	New (PathWayID)
	Set RstFlg=""
	Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	Set CPWStatus=$s($IsObject(objPathWay):objPathWay.CPWStatus,1:"")
	Quit:(CPWStatus'="I") RstFlg	// 'in cpw
	Set RstID="",RstFlg="N"
	For {
		Set RstID=$o(^DHCMR("CPW",PathWayID,"RST",RstID),-1)
		Quit:(RstID="")!(RstFlg="Y")
		Set objPathWayRst=##class(web.DHCCPW.MR.ClinPathWaysResult).GetObjById(PathWayID_"||"_RstID)
		Set:$IsObject(objPathWayRst) RstFlg="Y"
	}
	Quit RstFlg
}

/// 判断新实施记录是否有过操作
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).ChkImplNewOperation()
ClassMethod ChkImplNewOperation(ImplNewID As %String, Flag As %String) As %String
{
	New (ImplNewID,Flag)
	Set Flag=$g(Flag),ret="",PathWayID="",EpStepID=""
	Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(ImplNewID)
	If $IsObject(objImplNew) {
		Set PathWayID=objImplNew.CPWENParRef.%Id()
		Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
	}
	Quit:(PathWayID="")!(EpStepID="") ret
	Set ret="N"
	Set ImplementSub=""
	For {
		Set ImplementSub=$o(^DHCMRi(0,"IMPL","IndexStepDR",PathWayID,EpStepID,ImplementSub))
		Quit:(ImplementSub="")!(ret="Y")
		Set ImplementID=PathWayID_"||"_ImplementSub
		Set objImplement=##class(web.DHCCPW.MR.Implement).GetObjById(ImplementID)
		Continue:'$IsObject(objImplement)
		Set ImplNewDR=objImplement.CPWEImplNewDR
		Continue:'$IsObject(ImplNewDR)
		Continue:(ImplNewDR.%Id()'=ImplNewID)
		Set Active=objImplement.CPWEActive
		Continue:(Flag'="")&&(Active["N")
		Set ret="Y"
	}
	Set VarianceSub=""
	For {
		Set VarianceSub=$o(^DHCMRi(0,"VAR","IndexEpStep",PathWayID,EpStepID,VarianceSub))
		Quit:(VarianceSub="")!(ret="Y")
		Set VarianceID=PathWayID_"||"_VarianceSub
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(VarianceID)
		Continue:'$IsObject(objVariance)
		Set ImplNewDR=objVariance.CPWVImplNewDR
		Continue:'$IsObject(ImplNewDR)
		Continue:(ImplNewDR.%Id()'=ImplNewID)
		Set UpdoFlag=objVariance.CPWVUpdoFlag
		Continue:(Flag'="")&&(UpdoFlag="Y")
		Set ret="Y"
	}
	Set SignSub=""
	For {
		Set SignSub=$o(^DHCMRi(0,"SIGN","IndexEpStep",PathWayID,EpStepID,SignSub))
		Quit:(SignSub="")!(ret="Y")
		Set SignID=PathWayID_"||"_SignSub
		Set objSign=##class(web.DHCCPW.MR.ClinPathWaysSign).GetObjById(SignID)
		Continue:'$IsObject(objSign)
		Set ImplNewDR=objSign.CPWSImplNewDR
		Continue:'$IsObject(ImplNewDR)
		Continue:(ImplNewDR.%Id()'=ImplNewID)
		Set Active=objSign.CPWSActive
		Continue:(Flag'="")&&(Active["N")
		Set ret="Y"
	}
	Quit ret
}

/// 判断所选路径步骤是否可以入径
/// w ##class(web.DHCCPW.OPCPW.InterfaceOP).IfStepInOPCPW("","","")
ClassMethod IfStepInOPCPW(aPatientID As %String, aSelCPWDID As %String, aSelEpStepID As %String) As %String
{
	New (aPatientID,aSelCPWDID,aSelEpStepID)
	Set return=0
	Quit:(+aPatientID=0)!(+aSelCPWDID=0)!(aSelEpStepID="") return
	Set aSelEpID=$p(aSelEpStepID,"||",2)
	Set aSelStepID=$p(aSelEpStepID,"||",3)
	
	Set Paadm=""
	For {
		Set Paadm=$o(^PAPERdr(+aPatientID,"ADM","O",Paadm),-1)
		Quit:(Paadm="")!(return'=0)
		Set PathWayID=""
		For {
			Set PathWayID=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",Paadm,PathWayID),-1)
			Quit:(PathWayID="")!(return'=0)
			Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			Set (Status,CPWDID)=""
			If $IsObject(objPathWay) {
				Set Status=objPathWay.CPWStatus
				If $IsObject(objPathWay.CPWPathwayDR) {
					Set CPWDID=+objPathWay.CPWPathwayDR.%Id()
				}
			}
			Continue:(Status'="I")
			Continue:(aSelCPWDID'=CPWDID)
			Set SubID=""
			For {
				Set SubID=$o(^DHCMRi(0,"IMPLNEW","IndexPaadm",Paadm,PathWayID,SubID),-1)
				Quit:(SubID="")!(return'=0)
				Set objImplNew=##class(web.DHCCPW.OPCPW.InterfaceOP).GetObjByImplNewID(PathWayID_"||"_SubID)
				Continue:'$IsObject(objImplNew)
				Set Active=objImplNew.CPWENActive
				Continue:(Active="N")
				Set EpStepID=objImplNew.CPWENEpStepDR.%Id()
				Set EpID=$p(EpStepID,"||",2)
				Set StepID=$p(EpStepID,"||",3)
				Set:(aSelEpID<EpID)!(aSelStepID<StepID) return=1
			}
		}
	}
	Quit return
}

}
