Class DHCDoc.DHCDocCure.Common Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:清理治疗基础数据
/// Note：得以保留未清除的项目有：
/// 		治疗常规设置：		除治疗默认科室、链接界面设置以外的所有配置
/// 		治疗分类设置：		治疗分类
/// 		治疗服务组设置：	所有
/// 		治疗时间段设置：	所有
/// 		治疗评估模板维护：	所有
/// 		治疗报到状态：		所有
/// 		治疗评定量表维护：	除量表设置的科室、医嘱项数据外的所有
/// Input:	ClearAllFlag：Y 清除所有治疗基础及配置数据；其他：保留同产品部讨论的上述数据
/// Debug：	d ##class(DHCDoc.DHCDocCure.Common).ClearBaseDHCDocCure()
ClassMethod ClearBaseDHCDocCure(ClearAllFlag As %String = "")
{
	;清理治疗基础数据----start
	;治疗子类配置
	k ^DHCDocConfig("DHCDocCureItemCat")
	;治疗科室配置
	k ^DHCDocConfig("DHCDocCureLocStr")
	if ClearAllFlag="Y"{
		;治疗是否启用分诊配置
		k ^DHCDocConfig("DHCDocCureNeedTriage")
		k ^DHCDocConfig("DHCDocCureAppDoseQty")
		k ^DHCDocConfig("DHCDocCureAppQryNotWithTab")
		k ^DHCDocConfig("DHCDocCureWorkQrySelf")
		k ^DHCDocConfig("DHCDocCureFTPIPAddress")
		k ^DHCDocConfig("DHCDocCureFTPPort")
		k ^DHCDocConfig("DHCDocCureFTPUserCode")
		k ^DHCDocConfig("DHCDocCureFTPPassWord")
		k ^DHCDocConfig("DHCDocCureFTPPassWordC")
		k ^DHCDocConfig("DHCDocCureRecordContent")
		
		k ^DHCDocConfig("DHCDocCureAppHiddenOtherUser")
		k ^DHCDocConfig("DHCDocCureAppointAllowExec")
		;k ^DHCDocConfig("DHCDocCureLinkPage")
		;k ^DHCDocConfig("DHCDocCureRecordLinkPage")
		;k ^DHCDocConfig("DHCDocCureAssLinkPage")
		k ^DHCDocConfig("DHCDocCureUseCall")
		k ^DHCDocConfig("DHCDocCureAdviseInsertOrd")
	}
	
	s HospID=""
	for {
		s HospID=$O(^CT("HOSP",HospID))
		q:(HospID="")
		d ..ClearBaseDHCDocCureByHospId(HospID,ClearAllFlag)
	}
	
	if ClearAllFlag="Y"{
		;治疗分类
		k ^DHCDocCureArcCat
		
		;治疗服务组配置
		k ^DHCDocCureRBCServiceGroupSet
		;治疗服务组关联服务组配置
		k ^User.DHCDocCureSGLinkD
		k ^User.DHCDocCureSGLinkI
		k ^User.DHCDocCureSGLinkS
		d ##class(DHCDoc.Common.Hospital).DeleteTableHospitals("DHC_DocCureRBCServiceGroupSet")
		;治疗时间段配置
		k ^DHCDocCureRBCTimePeriodSet
		d ##class(DHCDoc.Common.Hospital).DeleteTableHospitals("DHC_DocCureRBCTimePeriodSet")
		;治疗时间段关联服务组配置
		k ^User.DHCDocCureTimeLinkGroupD
		k ^User.DHCDocCureTimeLinkGroupI
	}else{
		;保留治疗分类,分类下关联的子类及医嘱项需清除
		s ArcCatID=""
		for{
			s ArcCatID=$o(^DHCDocCureArcCat(ArcCatID))
			Q:ArcCatID=""
			;分类关联子类及指定的治疗科室
			k ^DHCDocCureArcCat(ArcCatID,"LIC")
			;分类关联医嘱项及指定的治疗科室
			k ^DHCDocCureArcCat(ArcCatID,"LIM")
		}
		;分类关联子类索引
		k ^DHCDocCureArcCat(0,"LICCAT")
		k ^DHCDocCureArcCat(0,"LICCAT1")
		;分类关联医嘱项索引
		k ^DHCDocCureArcCat(0,"LIMMAST")
		k ^DHCDocCureArcCat(0,"LIMMAST1")
		;分类关联医嘱项指定治疗科室索引
		k ^DHCDocCureArcCat(0,"LIMMASTLOC")
		;分类关联子类指定治疗科室索引
		k ^DHCDocCureArcCat(0,"LICCATLOC")
	}
	;治疗项目设置
	k ^DHCDocCureItemSet
	k ^DHCDocCureItemSeti
	;治疗关联科室配置
	k ^DHCDocCureLinkLoc
	k ^DHCDocCureLinkLoci
	;治疗资源计划
	k ^DHCDocCureRBCResPlan
	;治疗排班记录
	k ^DHCDocCureRBCResSchdule
	
	;治疗分配资源配置
	k ^DHCDocCureTR
	k ^DHCDocCureTRi
	
	;清治疗科室扩展设置
	k ^DHCDocCureLE
	k ^DHCDocCureLEi
	
	s AssScaleID=""
	for{
		s AssScaleID=$o(^User.DHCDocCureAssScaleD(AssScaleID))
		Q:AssScaleID=""
		k ^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet")
		k ^User.DHCDocCureAssScaleC("ChildDHCDocCureAssScaleSet")
		k ^User.DHCDocCureAssScaleSetI
	}
	
	;清治疗部位穴位数据
	k ^User.DHCDocCurePartSetD
	k ^User.DHCDocCurePartSetI
	k ^User.DHCDocCurePartSetS
	d ##class(DHCDoc.Common.Hospital).DeleteTableHospitals("DHC_DocCure_PartSet")
	;清治疗部位穴位组及关联数据
	k ^User.DHCDocCurePartGrpSetD
	k ^User.DHCDocCurePartGrpSetI
	k ^User.DHCDocCurePartGrpSetS
	k ^User.DHCDocCurePartGrpSetC("ChildDHCDocCurePartGrpLinkSet")
	k ^User.DHCDocCurePartGrpLinkSetI
	k ^User.DHCDocCurePartGrpLinkSetS
	d ##class(DHCDoc.Common.Hospital).DeleteTableHospitals("DHC_DocCure_PartGrpSet")
	
	;清理治疗基础数据----end
}

ClassMethod ClearBaseDHCDocCureByHospId(HospID As %String, ClearAllFlag As %String = "")
{
	q:(HospID="") 0
	s HospCodeNode="HospDr_"_HospID
	;治疗子类配置
	kill ^DHCDocConfig(HospCodeNode,"DHCDocCureItemCat")
	;治疗科室配置
	kill ^DHCDocConfig(HospCodeNode,"DHCDocCureLocStr")
	
	if ClearAllFlag="Y"{
		;治疗是否启用分诊配置
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureNeedTriage")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureAppDoseQty")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureAppQryNotWithTab")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureWorkQrySelf")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureFTPIPAddress")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureFTPPort")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureFTPUserCode")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureFTPPassWord")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureFTPPassWordC")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureRecordContent")
		
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureAppHiddenOtherUser")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureAppointAllowExec")
		
		;k ^DHCDocConfig(HospCodeNode,"DHCDocCureLinkPage")
		;k ^DHCDocConfig(HospCodeNode,"DHCDocCureRecordLinkPage")
		;k ^DHCDocConfig(HospCodeNode,"DHCDocCureAssLinkPage")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureUseCall")
		k ^DHCDocConfig(HospCodeNode,"DHCDocCureAdviseInsertOrd")
	}
}

/// 清理治疗业务数据
/// d ##class(DHCDoc.DHCDocCure.Common).ClearDataDHCDocCure()
ClassMethod ClearDataDHCDocCure()
{
	;清理治疗业务数据----start
	;治疗申请单、预约记录、治疗记录
	k ^DHCDocCure 
	;治疗分配
	k ^DHCDocCureTRI
	k ^DHCDocCureTRIi
	;预约记录状态改变变化表
	k ^DHCDocCureAASTAT
	k ^DHCDocCureAASTATi
	
	k ^User.DHCDocCureAssScoreD
	k ^User.DHCDocCureAssScoreI
	k ^User.DHCDocCureAssScoreS
	k ^User.DHCDocCureAssScoreFormI
	k ^User.DHCDocCureAssScoreFormS
	k ^User.DHCDocCureAssScoreC("ChildDHCDocCureAssScoreForm")
	
	;清治疗评估模板
	k ^DHCDocCureAssTemp
	k ^DHCDocCureAssTempi
	;清理治疗业务数据----end
}

ClassMethod GetOrderPrior(OrderId As %String)
{
	s LongFlag=0
	Q:OrderId="" LongFlag
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	Q:PriorityDR="" LongFlag
	Q ##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
}

/// Desc:根据申请单ID获取病人的就诊ID及病人主索引ID	
ClassMethod GetPatAdmIDByDCA(DCARowId As %String)
{
	Set ret=""
	Set DCARowId=+DCARowId
	Quit:DCARowId=0 ret
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Quit:Adm="" ""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	Set ret=Adm_"^"_PatientId
	Quit ret
}

/// w ##class(DHCDoc.DHCDocCure.Common).DateLogicalToHtml() $h
ClassMethod DateLogicalToHtml(h As %String = "", a As %String = "")
{
	if h="" s h=+$H
	if a'="" s h=h+(+a)
	s Date=##class(websys.Conversions).DateLogicalToHtml(h)	
	Q Date
}

/// w ##class(DHCDoc.DHCDocCure.Common).GetCurrendDateTime()
ClassMethod GetCurrendDateTime(EpisodeID As %String = "")
{
	s DateFormat=##Class(websys.Conversions).DateFormat()
	s OrderStartDate="",OrderStartTime=""
	if EpisodeID'=""{
		s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
		s val = ##class(websys.Conversions).IsValidMethodName("web.DHCDocInterfaceMethod","DHCDocHisInterface")
		if (val){
			s DischargeDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
		}else{
			s DischargeDateTime=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
		}
		s DischargeDate=$p(DischargeDateTime,"^",1)
		i DischargeDate'="" s DischargeDate=##class(websys.Conversions).DateLogicalToHtml(DischargeDate) //$zd(DischargeDate,3)
		s DischargeTime=$p(DischargeDateTime,"^",2)
		i DischargeTime'="" s DischargeTime=$zt(DischargeTime-1,1)
		if CurrentDischargeStatus="B"{
			s OrderStartDate = DischargeDate
	    	s OrderStartTime = DischargeTime
		}
	}
	if OrderStartDate=""{
		s CurrDateTime = ##Class(web.DHCDocOrderCommon).GetCurrentDateTime(DateFormat, "1")
		s OrderStartDate = $P(CurrDateTime,"^",1)
    	s OrderStartTime = $P(CurrDateTime,"^",2)
	}
    Q OrderStartDate_" "_OrderStartTime
}

/// Desc:批量生成治疗申请记录，并当做直接执行处理，同时生成治疗记录
/// Input:data: OrderID
/// Debug:w ##class(DHCDoc.DHCDocCure.Common).CreateCureDataBatch("D:\\Doctor.txt")
ClassMethod CreateCureDataBatch(FilePath)
{
	Q ##class(DHCDoc.DHCDocCure.OnlineSupport).CreateCureDataBatch(FilePath)
}

/// 获取停止时间的json串
/// w ##Class(DHCDoc.DHCDocCure.Common).GetIntervalTimeList("Y")
ClassMethod GetIntervalTimeList(BeginCurrTime As %String = "") As %String
{
	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCDocInPatUICommon"_"||"_"GetIntervalTimeList")
 	if (flag=1){
	 	s JsonInfo=##Class(web.DHCDocInPatUICommon).GetIntervalTimeList()
	 	Q JsonInfo
 	}
	s JsonObj=[]
	//s Bool=##Class(%Library.Boolean).%New()
	s Inteval=$ZTH("00:15:00")
	if (BeginCurrTime="Y"){
		s JsonData={}
		do JsonData.%Set("id",$ZT($P($H,",",2)))
		do JsonData.%Set("text",$ZT($P($H,",",2)))
		do JsonData.%Set("selected","1")
		do JsonObj.%Push(JsonData,"")
		s LoopTime=($P($H,",",2)\Inteval+1)*Inteval
	}else{
		s LoopTime=Inteval
	}
	
	while (LoopTime<$ZTH("23:59:59")) {
		s JsonData={}
		do JsonData.%Set("id",$ZT(LoopTime))
		do JsonData.%Set("text",$ZT(LoopTime))
		do JsonData.%Set("selected","0")
		//do JsonData.%Set("selected",Bool.XSDToLogical(0))
		do JsonObj.%Push(JsonData,"")
		if ((LoopTime+Inteval)>$P($H,",",2))&&(LoopTime<$P($H,",",2)){
			s JsonData={}
			do JsonData.%Set("id",$ZT($P($H,",",2)))
			do JsonData.%Set("text",$ZT($P($H,",",2)))
			do JsonData.%Set("selected","1")
			do JsonObj.%Push(JsonData,"")
		}
		s LoopTime=LoopTime+Inteval
	}
	Q JsonObj.%ToJSON()
	
	s JsonInfo=""
	s obj=##class(%Library.GlobalCharacterStream).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

/// w ##Class(DHCDoc.DHCDocCure.Common).GetBillType("1503","",1)
ClassMethod GetBillType(EpisodeID, PPRowId As %String = "", langid As %String = "")
{
	s ^tmpnk("GetBillType")=$lb(EpisodeID,PPRowId,langid)
	if (langid="")&&($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    if langid=""{
		s langid=20    
	}
    
	s Stream=##class(%Library.GlobalCharacterStream).%New()
 	d Stream.Write("[")
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (PPRowId'="") {
		s:PAAdmType="I" BillTypeID=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason")
		s:PAAdmType'="I" BillTypeID=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason")
		if (BillTypeID'="")&&($d(^PAC("ADMREA",BillTypeID))) {
			s BillType=$p($g(^PAC("ADMREA",BillTypeID)),"^",2)
			s BillType=##class(User.PACAdmReason).GetTranByDesc("READesc",BillType,langid)
			s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(BillTypeID,PAAdmType)
			s str=BillType_"^"_BillTypeID_"^"_1_"^"_InsurFlag
			d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData("CombDesc^CombValue^selected^CombCode",str))
			d Stream.Write("]")
			s JsonInfo=Stream.Read()
			Q JsonInfo
		}
	}
	s BillTypeStr=""
	s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s PrescriptTypeStr=""
	s DefaultType=""
	if (BillTypeID'=""){
		s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PAAdmType,langid)
		s DefaultType=$p(PrescriptTypeStr,"^",2)
		s PrescriptTypeStr=$p(PrescriptTypeStr,"^",1)
		if DefaultType'="" s DefaultType=$p(DefaultType,":",1)
	}
	s LenR=$L(PrescriptTypeStr,";")
	for J=1:1:LenR{
		s SUStr=$P(PrescriptTypeStr,";",J)
		s SRowID=$P(SUStr,":",1)
		Continue:SRowID=""
		s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(SRowID)
		s SDesc=$P(SUStr,":",2)
		s Default=0
		if (DefaultType=SRowID) s Default=1
		s str=SDesc_"^"_SRowID_"^"_Default_"^"_InsurFlag
		if J=1{
			d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData("CombDesc^CombValue^selected^CombCode",str))
		}else{
			d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData("CombDesc^CombValue^selected^CombCode",str))
		}
		
	}
	d Stream.Write("]")
	s JsonInfo=Stream.Read()
	Q JsonInfo
}

/// Description:  根据就诊类型，获取医嘱项发药单位
ClassMethod GetBillUOMRowID(ArcimRowid As %String, AdmType As %String) As %String
{
	s val = ##class(websys.Conversions).IsValidMethodName("web.DHCDocOrderCommon","GetBillUOMRowID")
	if (val){
		Q ##class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,AdmType)
	}else{
		s ArcimBillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
		s OrderType=""
		s ItemCatDr=$P(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1),"^",10) 
		s:ItemCatDr'="" OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
		s INCI=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
		if (INCI'=""){
			//门诊发药单位 INCI_CTUOM_OutPat_DR
			s CTUOMOutPatDR=$P(^INCI(INCI,1),"^",12)
			//住院发药单位 INCI_CTUOM_InPat_DR
			s CTUOMInPatDR=$P(^INCI(INCI,1),"^",13)
		}else{
			s CTUOMOutPatDR=""
			s CTUOMInPatDR=""
		}
		if (AdmType="I"){
			s BillUOMRowID=CTUOMInPatDR
		}else{
			s BillUOMRowID=CTUOMOutPatDR
		}
		i BillUOMRowID="" s BillUOMRowID=ArcimBillUOMRowid
		
		q BillUOMRowID
	}
}

ClassMethod CheckIsUser(userCode As %String)
{
	Q:userCode="" 0
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	if userID'=""{
		s ActiveFlag=$p($g(^SSU("SSUSR",userID)),"^",19)
		s DateFrom=$p($g(^SSU("SSUSR",userID)),"^",96)
		s DateTo=$p($g(^SSU("SSUSR",userID)),"^",97)
		if (ActiveFlag'="Y"){
			s userID=-1	
		}	
		if (DateFrom'="")&&(DateFrom>+$H){
			s userID=-1	
		}
		if (DateTo'="")&&(DateTo'>+$H){
			s userID=-1	
		}
	}
	Q userID
}

/// w ##Class(DHCDoc.DHCDocCure.Common).ConfirmPassWord("YS02",1)
ClassMethod ConfirmPassWord(userCode As %String, passWord As %String, userLoc As %String = "")
{
	s retStr=0
	s userId=..CheckIsUser(userCode)
	q:+userId'>0 "无效的用户或用户未激活!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"
	if userLoc'=""{
		if '$d(^RB("RES",0,"CTPCP",ctpcpId,userLoc)){
			Q "非本科用户!"	
		}	
	}
	s err=##Class(web.DHCOEOrdItem).PinNumberValid(userId,passWord)
	if err'=0{
		s retStr="密码错误!"
	}else{
		s retStr=0_"^"_userId
	}
	q retStr
}

ClassMethod CheckActiveDoc(CTCPDR)
{
	q:CTCPDR="" "N"
	if '$d(^CTPCP(CTCPDR,1)){
		s ActiveFlag="N"
		Q ActiveFlag	
	}
	s ActiveFlag=$p($g(^CTPCP(CTCPDR,1)),"^",9)
	if (ActiveFlag'="Y"){
		s ActiveFlag="N"
		Q ActiveFlag	
	}
	s ActiveDateFrom=$p($g(^CTPCP(CTCPDR,2)),"^",14)
	if (ActiveDateFrom'="")&&(ActiveDateFrom>+$H){
		s ActiveFlag="N"	
		Q ActiveFlag
	}
	s ActiveDateTo=$p($g(^CTPCP(CTCPDR,2)),"^",15)
	if (ActiveDateTo'="")&&(ActiveDateTo'>+$H){
		s ActiveFlag="N"
		Q ActiveFlag		
	}
	Q ActiveFlag
}

ClassMethod CheckActiveUser(UserDR)
{
	q:UserDR="" "N"
	if '$d(^SSU("SSUSR",UserDR)){
		s ActiveFlag="N"
		Q ActiveFlag	
	}
	s ActiveFlag=$p(^SSU("SSUSR",UserDR),"^",19)
	if (ActiveFlag'="Y"){
		s ActiveFlag="N"
		Q ActiveFlag	
	}
	s ActiveDateFrom=$p(^SSU("SSUSR",UserDR),"^",96)
	if (ActiveDateFrom'="")&&(ActiveDateFrom>+$H){
		s ActiveFlag="N"	
		Q ActiveFlag
	}
	s ActiveDateTo=$p(^SSU("SSUSR",UserDR),"^",97)
	if (ActiveDateTo'="")&&(ActiveDateTo'>+$H){
		s ActiveFlag="N"
		Q ActiveFlag		
	}
	Q ActiveFlag
}

ClassMethod CheckActiveLoc(LocDR)
{
	q:LocDR="" "N"
	if '$d(^CTLOC(LocDR)){
		s ActiveFlag="N"
		Q ActiveFlag	
	}
	s ActiveFlag=$p(^CTLOC(LocDR),"^",14)
	if (ActiveFlag'="Y"){
		s ActiveFlag="N"
		Q ActiveFlag	
	}
	s ActiveDateFrom=$p(^CTLOC(LocDR),"^",24)
	if (ActiveDateFrom'="")&&(ActiveDateFrom>+$H){
		s ActiveFlag="N"	
		Q ActiveFlag
	}
	s ActiveDateTo=$p($g(^CTLOC(LocDR)),"^",25)
	if (ActiveDateTo'="")&&(ActiveDateTo'>+$H){
		s ActiveFlag="N"
		Q ActiveFlag		
	}
	Q ActiveFlag
}

}
