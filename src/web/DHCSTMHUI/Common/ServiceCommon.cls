Import sqluser

/// Descript:其他组方法公共调用
/// CreateDate:20200508
/// Creator:  lxt
Class web.DHCSTMHUI.Common.ServiceCommon Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	根据就诊号EpisodeID获取病案号
/// Creator:	lxt
/// CreateDate:	20200508
/// Input:		EpisodeID ：就诊号
/// 			MedType   ：门诊（O）、急诊（E）、住院（I）
/// return:		病案号
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetMrNoByEpisodeID(12)
ClassMethod GetMrNoByEpisodeID(EpisodeID, MedType = "") As %String
{
	n (EpisodeID,MedType)
	s MrNo=""
	s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	i MrNo=""  d
	.s PatientID=$p(^PAADM(EpisodeID),"^",1) 
	.s:PatientID'="" MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)
	q MrNo
}

/// Descript:	根据PatientID获取住院病案号
/// Creator:	lxt
/// CreateDate:	20200508
/// Input:		EpisodeID ：就诊号
/// 			MedType   ：门诊（O）、急诊（E）、住院（I）
/// return:		病案号
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetMrNoByPatientID(12)
ClassMethod GetMrNoByPatientID(PatientID, MedType = "", HosptialID = "") As %String
{
	n (PatientID,MedType,HosptialID)
	s MrNo=""
	s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,MedType,HosptialID,.ErrMsg)
	i MrNo=""  d
	.s MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)
	q MrNo
}

/// Descript:	获取病人年龄
/// Creator:	lxt
/// CreateDate:	20200603
/// Input:		病人id，就诊id，医院Id(202006增加医院Id)
/// return:		年龄
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetPapmiAge()
ClassMethod GetPapmiAge(Papmi, Adm, HospId = "") As %String
{
	n (Papmi,Adm,HospId)
	s Age=""
	
	i HospId="" d
	.s HospId=..GetHospIdByAdm(Adm)
	
	s HISVersion=..sssHISVersion()
	i HISVersion>="8.4" d
	.s Age=##class(web.DHCBillInterface).GetPapmiAge(Papmi,Adm,HospId)	//增加院区参数
	e  d
	.s Age=##class(web.DHCBillInterface).GetPapmiAge(Papmi,Adm)
	
	q Age
}

/// Descript:	获取急诊留观收费模式
/// Creator:	lxt
/// CreateDate:	20200603
/// Input:		医院Id(202006增加医院Id)（IStayPayModeByEpisodeID不再使用）
/// return:		模式 0:普通收费模式, 1:押金收费模式
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(HospId)
ClassMethod GetStayPayMode(HospId) As %String
{
	n (HospId)
	s PayMode=""
	
	s HISVersion=..sssHISVersion()
	i HISVersion>="8.4" d
	.s PayMode=..sssWrap("web.DHCBillInterface","IGetStayPayMode",HospId)
	e  d
	.s PayMode=..sssWrap("web.DHCBillInterface","IStayPayModeByEpisodeID")
	
	q PayMode
}

/// Descript:	根据就诊id获取医院id
/// Creator:	lxt
/// CreateDate:	20200603
/// Input:		Adm
/// return:		HospId
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetHospIdByAdm(Adm)
ClassMethod GetHospIdByAdm(Adm) As %String
{
	n (Adm)
	s HospId=""
	;s AdmLocId=$p(^PAADM(Adm),"^",4)
	;s HospId=$p($G(^CTLOC(AdmLocId)),"^",22)
	s HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	q HospId
}

/// Descript:	根据医嘱RowID获取结算记录RowID
/// Creator:	lxt
/// CreateDate:	20200603
/// Input:		oeori
/// return:		OPPrtRowID
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(oeori)
ClassMethod GetOPPrtRowIDByOrdItm(oeori) As %String
{
	n (oeori)
	s OPPrtRowID=""
	s OPPrtRowID=##class(web.DHCBillInterface).IGetOPPrtRowIDByOrdItm(oeori)
	q OPPrtRowID
}

/// Descript:	非药品医嘱部分退费数量查询接口
/// Creator:	lxt
/// CreateDate:	20200603
/// Input:		oeori，PrtRowID
/// return:		总退费数量^申请退费数量^实际退费数量
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetApplyRefundQty(oeori,PrtRowID)
ClassMethod GetApplyRefundQty(oeori, PrtRowID) As %String
{
	n (oeori,PrtRowID)
	s ApplyRefundQty=""
	s ApplyRefundQty=##class(web.DHCBillInterface).IGetApplyRefundQty(oeori,PrtRowID)
	q ApplyRefundQty
}

/// Descript:	非药品医嘱部分退费接口
/// Creator:	lxt
/// CreateDate:	20200603
/// Input:		医嘱RowID_"^"_数量_"!"_医嘱RowID_"^"_数量, RefUser:操作员, ExpStr:DHC_INVPRT.RowID
/// return:		0成功, <>0失败
ClassMethod SaveApplyRefundQty(ApplyRefundData, RefUser, ExpStr) As %String
{
	n (ApplyRefundData, RefUser,ExpStr)
	s ret=0
	s ret=##class(web.DHCBillInterface).ISaveApplyRefundQty(ApplyRefundData,RefUser,ExpStr)
	q ret
}

/// Descript:	根据计费项id判断计费项是否关联药品
/// Creator:	lxt
/// CreateDate:	20201204
/// Input:		计费项id
/// return:		Y是药品计费项  N不是药品计费项 （DHC_IncTarRela药品库存项计费项关联表，一对一）
ClassMethod GetDrugTarFlag(tariID As %String, paraDate As %String = "") As %String
{
	n (tariID,paraDate)
	s Flag="N"
	s inciList=..GetIncListByTar(tariID,paraDate)
	i inciList'="" s Flag="Y"
	q Flag
}

/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetIncListByTar()
/// 
ClassMethod GetIncListByTar(tariID As %String, paraDate As %String) As %String
{
    q:tariID="" ""
    i paraDate="" s paraDate=+$h
    s inciList=""
    s trID=""
    f  s trID=$o(^DHCINCTARi("TAR",tariID,trID)) q:trID=""  d
    .s inctrData = $g(^DHCINCTAR(trID))
    .s inciID = $p(inctrData,"^",1)
    .q:..IsMat("",inciID)'=1
    .
    .s trStartDate = $p(inctrData,"^",4)
    .q:(trStartDate'="")&&(trStartDate>paraDate)
    .s trEndDate = $p(inctrData,"^",5)
    .q:(trEndDate'="")&&(trEndDate<paraDate)
    .i inciList="" d
    ..s inciList=$lb(inciID)
    .e  d
    ..s inciList=inciList_$lb(inciID)
    q inciList
}

/// Description: 是否物资材料
/// Return:      1 - 是, 0 - 否
/// Debug:		 w ##class(web.DHCSTMHUI.Common.ServiceCommon).IsMat("","1")
ClassMethod IsMat(arcim As %String = "", inci As %String = "") As %String
{
	n (arcim,inci)
	s arcim=$g(arcim)
	s inci=$g(inci)
	s ret = 0
	q:(arcim = "")&&(inci = "") ret
#;	s pInput = $lb(arcim, inci)
#;	q:($d(%PHACOMDRUG("IsDrug", pInput))) $g(%PHACOMDRUG("IsDrug", pInput))
	if (arcim '= ""){
		s arcic = $p($g(^ARCIM(+arcim, +$p(arcim, "||", 2), 1)), "^", 10)
		if (arcic '= "")&&($p($g(^ARC("IC", arcic)), "^", 7) = "M"){
			s ret = 1
		}
	}else {
		s incsc = $p($g(^INCI(inci, 2)), "^", 2)
		if (incsc '= "")&&($p($g(^INC("SC", incsc)), "^", 3) = "M"){
			s ret = 1
		}
	}
#;	s %PHACOMDRUG("IsDrug", pInput) = ret	
	q ret
}

/// Descript:	判断病人当前是否有非急诊留观医嘱
/// Creator:	lxt
/// CreateDate:	20210301
/// Input:		就诊id
/// return:		1留观 2曾经留观 -1未留观
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayStatus()
ClassMethod GetStayStatus(Adm) As %String
{
	n (Adm)
	s ret=0
	s ret=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
	q ret
}

/// Descript:	获取计费点
/// Creator:	lxt
/// CreateDate:	20210301
/// Input:		
/// return:		0-开医嘱计费 1-发药计费
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetFeePoint()
ClassMethod GetFeePoint(OrdItmCat As %String) As %String
{
	n (OrdItmCat)
	s ArcCatId=$p(OrdItmCat,"^",1)
	s PriorityCode=$p(OrdItmCat,"^",2)
	s Oeori=$p(OrdItmCat,"^",3)

	s RecLocId="",HospId=""
	s:Oeori'="" RecLocId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),3)),"^",6)
	s:RecLocId'="" HospId=$p(^CTLOC(RecLocId),"^",22)
	s Config=##class(web.DHCSTInterfaceFromElse).IGetIPParamConfig(HospId, "OutPhBillCondition") // 出院带药是否按计费点计费,yunhaibao,20191127
	q:(PriorityCode="OUT")&(Config'="Y") "0"
	
	s BC=""
	s BCId=0
	f  s BCId=$o(^DHCTarC("BC",0,ArcCatId,BCId)) q:(BCId="")||(BC'="")  d
	.s BCHospId=$p(^DHCTarC("BC",BCId),"^",3)
	.q:BCHospId'=HospId
	.s BC=BCId
	q:BC="" "0"
	
	s Condition=$p(^DHCTarC("BC",BC),"^",2) ;本行正式上线时放开
	i Condition="OD" q "0"  ;开医嘱计费
	i Condition="CR" q "1"  ;发药计费
	q 1
}

/// Descript:	根据就诊id取病人是否当前在院状态
/// Creator:	lxt
/// CreateDate:	20210301
/// Input:		
/// return:		1-在院 0-不在院
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetCurrentAdmStatus()
ClassMethod GetCurrentAdmStatus(AdmId As %String) As %String
{
	n (AdmId)
	s Status=$p(^PAADM(AdmId),"^",20)
	q:Status="C" 0
	
	i $d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed")) d
	.//新入院流程 F:护士办理出院 T:结束费用调整
	.s admstatus=##class(web.DHCSTInterfaceFromElse).GetCurrentDischargeStatus(AdmId)
	.i (admstatus="F")!(admstatus="T") d
	..s result=0
	.e  d
	..s result=1
	e  d
	.i status="D" d		;已经做过最终结算
	..s result=0
	.e  d
	..s result=1
	q result
}

/// Descript:	给叫号系统传消息
/// Creator:	lxt
/// CreateDate:	20210521
/// Input:		患者登记号,患者姓名,IP地址,发放人员
/// return:		1-在院 0-不在院
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).SendMessToVoice()
ClassMethod SendMessToVoice(PatNo, PatName, ServerIP, UserID) As %String
{
	n (PatNo, PatName, ServerIP, UserID)
	q:(PatNo="")||(PatName="")||(ServerIP="")||(UserID="") -1
	
	s WinDesc="材料发放窗口"
	s VoiceContent="请"_PatName_"到"_WinDesc_"领取"
	//s PrescNo=null
	//s ScreentContent=WinDesc_","_PatName_","_PatNo_","_PrescNo_","
	s ScreentContent=WinDesc_","_PatName_","_PatNo
	s Ret=##class(web.DHCVISVoiceCall).InsertVoiceQueue(VoiceContent,UserID,ServerIP,"D","LR","N",ScreentContent,ScreentContent,"","")
	q Ret
}

/// Descript:	根据库存项id取医保贯标码信息
/// Creator:	wxj
/// CreateDate:	20211125
/// Input:		
/// return:		国家医保编码、国家医保描述
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetInsuInfo(15,2)
ClassMethod GetInsuInfo(Inci, HosptialID) As %String
{
	n (Inci,HosptialID)
	s Inci=$g(Inci)
	s HosptialID=$g(HosptialID)
	q:Inci="" ""
	q:HosptialID="" ""
	s TarItmId=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTARI(Inci)
	q:TarItmId="" ""
	i '$d(^||TMPDHCSTM("GetMatInsuInfo",$j)) d
	.s ClassMethodStr="web.DHCINSUPort||GetStdInfoByDHCTarItemRowId"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPDHCSTM("GetMatInsuInfo",$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("GetMatInsuInfo",$j),"^",1)
	q:Flag'="Y" ""
	s InsuInfo=##class(web.DHCINSUPort).GetStdInfoByDHCTarItemRowId(TarItmId,HosptialID)
	q InsuInfo
}

/// Descript:	获取国家医保编码取值配置
/// Creator:	wxj
/// CreateDate:	20220408
/// Input:	hospid:医院rowid;	
/// return:
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetInsuConfig(2)
ClassMethod GetInsuConfig(HosptialID) As %String
{
	n (HosptialID)
	q:HosptialID="" ""
	i '$d(^||TMPDHCSTM("GetInsuConfig",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.INSUConfig||GetConfigByHospId"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPDHCSTM("GetInsuConfig",$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("GetInsuConfig",$j),"^",1)
	q:Flag'="Y" ""
	s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(HosptialID,"DHC_TarItem")	
	q Config
}

/// Descript:用来获得一条医嘱的ID对应的医嘱详细信息
/// Creator:wxj
/// CreateDate:	20220527
/// InPut:	Oeori：医嘱ID
/// OutPut:	医嘱信息串用^分割
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetOrderMesage("")
ClassMethod GetOrderMesage(Oeori) As %String
{
	n (Oeori)
	q:Oeori="" ""
	s OeoriData=""
	i '$d(^||TMPDHCSTM("GetOrderMesage",$j)) d
	.s ClassMethodStr="web.DHCDocOrderCommon||GetOrderMesage"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s OeoriData=##class(web.DHCDocOrderCommon).GetOrderMesage(Oeori)
	.s ^||TMPDHCSTM("GetOrderMesage",$j)=OeoriData
	e  d
	.s OeoriData=^||TMPDHCSTM("GetOrderMesage",$j)
	q OeoriData
}

/// Descript:	获取计费配置
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).ReadOPSPConfig(2)
ClassMethod ReadOPSPConfig(HosptialId As %String) As %String
{
	n (HosptialId)
	s myConInfo=##class(web.DHCOPConfig).ReadOPSPConfig(HosptialId)
	q myConInfo
}

/// Descript:	根据病案号获取病人信息ID
/// Creator:	GP
/// CreateDate:	20221019
/// Input:	Medicare
/// return:	病人信息ID
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetPatientIDByMrNo(100109,"",.ErrMsg)
ClassMethod GetPatientIDByMrNo(Medicare As %String, MedType As %String = "", ByRef ErrMsg As %String) As %String
{
	n (Medicare,MedType,ErrMsg)
	s PatientID=""
	s ClassMethodStr="MA.IPMR.IO.OutService||GetPatientIDByMrNo"
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	i $IsObject(CompiledObj) d
	.s PatientID=##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(Medicare,"",.ErrMsg)
	e  d
	.s PatientID=$o(^PAPERi("Medicare1",$$ALPHAUP^SSUTIL4(Medicare),0))
	q PatientID
}

/// Descript:更新医嘱项别名表
/// Creator:wxj
/// CreateDate:	2023-04-18
/// InPut:	Oeori：医嘱ID  
/// OutPut:	医嘱信息串用^分割
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).UpdateArcAlias("2||1")
ClassMethod UpdateArcAlias(ArcimId As %String) As %String
{
	n (ArcimId)
	q:ArcimId="" -1
	s ArcSub=+ArcimId
	s ArcVer=$p(ArcimId,"||",2)
	q:(ArcSub="")||(ArcVer="") -2
	s AliasId=$o(^ARC("ALIAS",0,"ARCIM",ArcimId,""))
	q:+AliasId'>0 -3
	s AliasDesc=$p($g(^ARC("ALIAS",AliasId)),"^",3)
	s AliasItmCat=$p($g(^ARC("ALIAS",AliasId)),"^",4)
	s AliasOwnFlag=$p($g(^ARC("ALIAS",AliasId)),"^",7)
	s ArcDesc=$p($g(^ARCIM(ArcSub,ArcVer,1)),"^",2)			;医嘱项描述
	s ArcOrderSubCat=$p($g(^ARCIM(ArcSub,ArcVer,1)),"^",10)	;医嘱子类DR
	s ArcOwnFlag=$p($g(^ARCIM(ArcSub,ArcVer,7)),"^",13)		;独立医嘱标志
	q:(AliasDesc=ArcDesc)&&(AliasItmCat=ArcOrderSubCat)&&(AliasOwnFlag=ArcOwnFlag) ""
	s ClassMethodStr="web.DHCBL.CT.ARCAlias||BatchUpdate"               
	s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	s Ret=""
	i $IsObject(CompiledObj) d
	.s Ret=##class(web.DHCBL.CT.ARCAlias).BatchUpdate(ArcimId)
	.&sql(update ARC_Alias set ALIAS_OrderOnItsOwn=:ArcOwnFlag where ALIAS_ARCIM_DR=:ArcimId)
	.i SQLCODE'=0  s Ret=-4
	e  d
	.&sql(update ARC_Alias set ALIAS_OrderOnItsOwn=:ArcOwnFlag,ALIAS_OrderSubCat_DR=:ArcOrderSubCat,ALIAS_Desc=:ArcDesc where ALIAS_ARCIM_DR=:ArcimId) 
	.i SQLCODE'=0  s Ret=-4
	q Ret
}

}
