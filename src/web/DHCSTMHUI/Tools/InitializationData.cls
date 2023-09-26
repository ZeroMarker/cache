Import SqlUser

/// Descript:	初始化数据工具类
/// Creater:	qiushengxin
/// CreateDate:	2021-06-19
/// 如测试用需要初始化生成库存项数据注释264行-359行
Class web.DHCSTMHUI.Tools.InitializationData Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCSTMHUI.Tools.InitializationData).InitializationData("","东华标准版数字化医院[总院]")
ClassMethod InitializationData(LocId As %String = "", Hospital As %String) As %String
{
	n (LocId,Hospital)
	q:Hospital="" -18
	d ..InitializationBasicData()
	d ..Initialization68ClassificationData()
	s Err=0
	s Node=""
	s gScg="",StkCat="",HospId=""
	i Hospital'="" d
	.&sql(SELECT HOSP_RowId INTO:HospId FROM CT_Hospital WHERE HOSP_Desc=:Hospital)
	ts
	f  s Node=$o(^TMP("DHCSTM","InitializationBasicData",Node)) q:(Node="")||(Err'=0)  d
	.s BasicData=^TMP("DHCSTM","InitializationBasicData",Node)
	.s BasicMain=$lg(BasicData,1)
	.s BasicCode=$lg(BasicData,2)
	.s BasicDesc=$lg(BasicData,3)
	.i BasicMain="POCancFullFillReason" d
	..;s CFRRowId=$o(^INC("CFR",0,"Code",BasicCode,""))
	..s CFRRowId=""
	..&sql(SELECT CFR_RowId INTO:CFRRowId FROM INC_POCanc_FullFillReason WHERE CFR_Code=:BasicCode AND CFR_StkType='M')
	..i CFRRowId="" d
	...s CFRObj=##class(User.INCPOCancFullFillReason).%New()
	..e  d
	...s CFRObj=##class(User.INCPOCancFullFillReason).%OpenId(CFRRowId)
	..d CFRObj.%Reload()
	..s CFRObj.CFRCode=BasicCode
	..s CFRObj.CFRDesc=BasicDesc
	..s CFRObj.CFRStkType="M"
	..s Sc=CFRObj.%Save()
	..i $$$ISERR(Sc) s Err=-1 q
	.i BasicMain="ReasonForAdjustPrice" d
	..;s REARowId=$o(^DHCSTREASON("ASP",0,"Code",BasicCode,""))
	..s REARowId=""
	..&sql(SELECT REA_RowId INTO:REARowId FROM DHC_ReasonForAdjustPrice WHERE REA_Code=:BasicCode AND REA_StkType='M')
	..i REARowId'="" d
	...s REAObj=##class(User.DHCReasonForAdjustPrice).%OpenId(REARowId)
	..e  d
	...s REAObj=##class(User.DHCReasonForAdjustPrice).%New()
	..d REAObj.%Reload()
	..s REAObj.REACode=BasicCode
	..s REAObj.READesc=BasicDesc
	..s REAObj.REAStkType="M"
	..s Sc=REAObj.%Save()
	..i $$$ISERR(Sc) s Err=-2 q
	.i BasicMain="ReasonForAdjustment" d
	..s ADJRowId=""
	..&SQL(SELECT ADJ_RowId INTO:ADJRowId FROM INC_ReasonForAdjustment WHERE ADJ_Code=:BasicCode AND ADJ_StkType='M')
	..i ADJRowId="" d
	...s ADJObj=##class(User.INCReasonForAdjustment).%New()
	..e  d
	...s ADJObj=##class(User.INCReasonForAdjustment).%OpenId(ADJRowId)
	..d ADJObj.%Reload()
	..s ADJObj.ADJCode=BasicCode
	..s ADJObj.ADJDesc=BasicDesc
	..s ADJObj.ADJStkType="M"
	..s Sc=ADJObj.%Save()
	..i $$$ISERR(Sc) s Err=-3 q
	.i BasicMain="ReasonForReturn" d
	..s RETRowId=""
	..&sql(SELECT RET_Rowid INTO:RETRowId FROM INC_ReasonForReturn WHERE RET_StkType='M' AND RET_Code=:BasicCode)
	..i RETRowId="" d
	...s RETObj=##class(User.INCReasonForReturn).%New()
	..e  d
	...s RETObj=##class(User.INCReasonForReturn).%OpenId(RETRowId)
	..d RETObj.%Reload()
	..s RETObj.RETCode=BasicCode
	..s RETObj.RETDesc=BasicDesc
	..s RETObj.RETStkType="M"
	..s Sc=RETObj.%Save()
	..i $$$ISERR(Sc) s Err=-4 q
	.i BasicMain="IncReasonForStockScrap" d
	..s ScrapRowID=""
	..&SQL(SELECT REASON_ScrapRowID INTO:ScrapRowID FROM DHC_IncReasonForStockScrap WHERE REASON_ScrapCode=:BasicCode AND REASON_ScrapType='M')
	..i ScrapRowID="" d
	...s ScrapObj=##class(User.DHCIncReasonForStockScrap).%New()
	..e  d
	...s ScrapObj=##class(User.DHCIncReasonForStockScrap).%OpenId(ScrapRowID)
	..d ScrapObj.%Reload()
	..s ScrapObj.REASONScrapCode=BasicCode
	..s ScrapObj.REASONScrapDesc=BasicDesc
	..s ScrapObj.REASONScrapType="M"
	..s Sc=ScrapObj.%Save()
	..i $$$ISERR(Sc) s Err=-5 q
	.i BasicMain="ReasonForRefuseRequest" d
	..s RFRowId=""
	..&SQL(SELECT RF_RowId INTO:RFRowId FROM DHC_ReasonForRefuseRequest WHERE RF_StkType='M' AND RF_Code=:BasicCode)
	..i RFRowId="" d
	...s RefuseRequestObj=##class(User.DHCReasonForRefuseRequest).%New()
	..e  d
	...s RefuseRequestObj=##class(User.DHCReasonForRefuseRequest).%OpenId(RFRowId)
	..d RefuseRequestObj.%Reload()
	..s RefuseRequestObj.RFCode=BasicCode
	..s RefuseRequestObj.RFDesc=BasicDesc
	..s RefuseRequestObj.RFStkType="M"
	..s Sc=RefuseRequestObj.%Save()
	..i $$$ISERR(Sc) s Err=-6 q
	.i BasicMain="OperateType" d
	..s IPTType=$lg(BasicData,4)
	..s IPTRowId=""
	..&SQL(SELECT IPT_RowId INTO:IPTRowId FROM DHC_OperateType WHERE IPT_Desc=:BasicDesc AND IPT_Type=:IPTType)
	..i IPTRowId="" d
	...s OperateTypeObj=##class(User.DHCOperateType).%New()
	..e  d
	...s OperateTypeObj=##class(User.DHCOperateType).%OpenId(IPTRowId)
	..d OperateTypeObj.%Reload()
	..s OperateTypeObj.IPTCode=BasicCode
	..s OperateTypeObj.IPTDesc=BasicDesc
	..s OperateTypeObj.IPTType=IPTType
	..s Sc=OperateTypeObj.%Save()
	..i $$$ISERR(Sc) s Err=-7 q
	.i BasicMain="SourceOfFund" d
	..s SOFRowId=""
	..&sql(SELECT SOF_RowId INTO:SOFRowId FROM DHC_SourceOfFund WHERE SOF_Desc=:BasicDesc)
	..i SOFRowId="" d
	...s SOFObj=##class(User.DHCSourceOfFund).%New()
	..e  d
	...s SOFObj=##class(User.DHCSourceOfFund).%OpenId(SOFRowId)
	..d SOFObj.%Reload()
	..s SOFObj.SOFCode=BasicCode
	..s SOFObj.SOFDesc=BasicDesc
	..s Sc=SOFObj.%Save()
	..i $$$ISERR(Sc) s Err=-8 q
	.i BasicMain="ItmChargeType" d
	..s ICTRowId=""
	..&sql(SELECT ICT_RowId INTO:ICTRowId FROM DHC_ItmChargeType WHERE ICT_Desc=:BasicDesc)
	..i ICTRowId="" d
	...s ItmChargeTypeObj=##class(User.DHCItmChargeType).%New()
	..e  d
	...s ItmChargeTypeObj=##class(User.DHCItmChargeType).%OpenId(ICTRowId)
	..d ItmChargeTypeObj.%Reload()
	..s ItmChargeTypeObj.ICTCode=BasicCode
	..s ItmChargeTypeObj.ICTDesc=BasicDesc
	..s Sc=ItmChargeTypeObj.%Save()
	..i $$$ISERR(Sc) s Err=-9 q
	.i BasicMain="SterileCategory" d
	..s SCATRowId=""
	..s SCATRowId=$o(^INC("SCAT",0,"Desc",BasicDesc,""))
	..i SCATRowId="" d
	...s SCATObj=##class(User.INCSterileCategory).%New()
	..e  d
	...s SCATObj=##class(User.INCSterileCategory).%OpenId(SCATRowId)
	..s SCATObj.SCATDesc=BasicDesc
	..s Sc=SCATObj.%Save()
	..i $$$ISERR(Sc) s Err=-10 q
	.i (BasicMain="InStkTkWindow")&&(LocId'="") d
	..s STTKWID=$o(^DHCSTTKW(0,"LOCDESC",LocId,BasicDesc,""))
	..i STTKWID="" d
	...s STTKWObj=##class(User.DHCInStkTkWindow).%New()
	..e  d
	...s STTKWObj=##class(User.DHCInStkTkWindow).%OpenId(STTKWID)
	..d STTKWObj.%Reload()
	..s STTKWObj.STTKWCTLOCDR=LocId
	..s STTKWObj.STTKWCode=BasicCode
	..s STTKWObj.STTKWDesc=BasicDesc
	..s Sc=STTKWObj.%Save()
	..i $$$ISERR(Sc) s Err=-11 q
	.i BasicMain="BookCat" d
	..s BCRowID=$o(^DHCSTBC(0,"DESC",BasicDesc,""))
	..i BCRowID="" d
	...s BookCatObj=##class(User.DHCSTBookCat).%New()
	..e  d
	...s BookCatObj=##class(User.DHCSTBookCat).%OpenId(BCRowID)
	..d BookCatObj.%Reload()
	..s BookCatObj.BCCode=BasicCode
	..s BookCatObj.BCDesc=BasicDesc
	..s Sc=BookCatObj.%Save()
	..i $$$ISERR(Sc) s Err=-12 q
	.i BasicMain="PayMode" d
	..s CTPMRowId=$o(^CT("CTPM",0,"Desc",BasicDesc,"")) 
	..i CTPMRowId="" d
	...s PayModeObj=##class(User.CTPayMode).%New()
	..e  d
	...s PayModeObj=##class(User.CTPayMode).%OpenId(CTPMRowId)
	..d PayModeObj.%Reload()
	..s PayModeObj.CTPMCode=BasicCode
	..s PayModeObj.CTPMDesc=BasicDesc
	..S PayModeObj.CTPMDateFrom=+$H
	..s Sc=PayModeObj.%Save()
	..i $$$ISERR(Sc) s Err=-13 q
	.i BasicMain="ItmQualityLevel" d
	..s QLRowId=$o(^DHCITMQL(0,"Desc",BasicDesc,"")) 
	..s:QLRowId="" QLRowId=$o(^DHCITMQL(0,"Code",BasicCode,""))
	..i QLRowId="" d
	...s ItmQualityLevelObj=##class(User.DHCItmQualityLevel).%New()
	..e  d
	...s ItmQualityLevelObj=##class(User.DHCItmQualityLevel).%OpenId(QLRowId)
	..d ItmQualityLevelObj.%Reload()
	..s ItmQualityLevelObj.QLCode=BasicCode
	..s ItmQualityLevelObj.QLDesc=BasicDesc
	..S ItmQualityLevelObj.QLDateFrom=+$H
	..s Sc=ItmQualityLevelObj.%Save()
	..i $$$ISERR(Sc) s Err=-14 q
	.i BasicMain="ItmNotUseReason" d
	..s DIURRowID=$o(^DHCNUR(0,"Desc",BasicDesc,"")) 
	..i DIURRowID="" d
	...s ItmNotUseReasonObj=##class(User.DHCItmNotUseReason).%New()
	..e  d
	...s ItmNotUseReasonObj=##class(User.DHCItmNotUseReason).%OpenId(DIURRowID)
	..d ItmNotUseReasonObj.%Reload()
	..s ItmNotUseReasonObj.DIURDesc=BasicDesc
	..s Sc=ItmNotUseReasonObj.%Save()
	..i $$$ISERR(Sc) s Err=-14 q
	d ..InitializationStkCatGroupData()
	s StkSub=""
	f  s StkSub=$o(^TMP("DHCSTM","InitializationStkCatGroupData",StkSub)) q:(StkSub="")||(Err'=0)  d
	.s StkCatGroupData=^TMP("DHCSTM","InitializationStkCatGroupData",StkSub)
	.s CatGroupMain=$lg(StkCatGroupData,1)
	.s CatGroupCode=$lg(StkCatGroupData,2)
	.s CatGroupDesc=$lg(StkCatGroupData,3)
	.s StkCatCode=$lg(StkCatGroupData,5)
	.s StkCatDesc=$lg(StkCatGroupData,6)
	.i CatGroupMain="DHCStkCatGroup" d
	..s CatGroupSet=$lg(StkCatGroupData,4)
	..
	..s ScgType="M"
	..s ScgRowId=$o(^DHCSCG(0,"TYPE",ScgType,CatGroupDesc,""))
	..i ScgRowId="" d
	...s ScgObj=##class(User.DHCStkCatGroup).%New()
	..e  d
	...s ScgObj=##class(User.DHCStkCatGroup).%OpenId(ScgRowId)
	..d ScgObj.%Reload()
	..s ScgObj.SCGCode=CatGroupCode
	..s ScgObj.SCGDesc=CatGroupDesc
	..s ScgObj.SCGType=ScgType
	..s ScgObj.SCGSet=CatGroupSet
	..s Sc=ScgObj.%Save()
	..i $$$ISERR(Sc) s Err=-15 q
	..s ScgId=ScgObj.%Id()
	..s INCSCRowId=""
	..&SQL(SELECT INCSC_RowId INTO:INCSCRowId FROM INC_StkCat WHERE INCSC_StkType='M' AND INCSC_Desc=:StkCatDesc)
	..i INCSCRowId="" d
	...s INCStkCatObj=##class(User.INCStkCat).%New()
	..e  d
	...s INCStkCatObj=##class(User.INCStkCat).%OpenId(INCSCRowId)
	..d INCStkCatObj.%Reload()
	..s INCStkCatObj.INCSCCode=StkCatCode
	..s INCStkCatObj.INCSCDesc=StkCatDesc
	..s INCStkCatObj.INCSCStkType="M"
	..s Sc=INCStkCatObj.%Save()
	..i $$$ISERR(Sc) s Err=-15 q
	..s INCSCDr=INCStkCatObj.%Id()
	.i (ScgId'="")&&(INCSCDr'="") d
	..s ScgChl=$o(^DHCSCG("STKCAT",INCSCDr,ScgId,0))
	..q:ScgChl'=""
	..s Ch=$o(^DHCSCG(ScgId,"RE",""),-1)+1
	..s StkCatGrpRelationsObj=##class(User.DHCStkCatGrpRelations).%New()
	..d StkCatGrpRelationsObj.%Reload()
	..d StkCatGrpRelationsObj.SCGRStkCatDRSetObjectId(INCSCDr)
	..d StkCatGrpRelationsObj.SCGRSCGParrefSetObjectId(ScgId)
	..s StkCatGrpRelationsObj.SCGRChildsub=Ch
	..s Sc=StkCatGrpRelationsObj.%Save() 
	..i $$$ISERR(Sc) s Err=-16 q
	.s StkCat=StkCatDesc
	.s gScg=CatGroupDesc
	/*
	d ..InitializationIncItmData()
	s IncSub="",InciCode="",InciDesc="",BUomDesc="",PUomDesc="",Fac="",Spec="",Model=""
	s Rp=0,ChargFlag="",BatNoReq="",ExpDateReq="",HighPriceFlag="N"
	s (ArcCat,ArcSubCat,BillCat,BillSubCat,TarCat,TarSubCat,InpaCat,InpaSubCat,OutpCat,OutpSubCat,EMCat,EMSubCat)=""
	s (AcctCat,AcctSubCat,MrCat,MrSubCat,MrSubCatNew,ApcName,ApcCode,ManfCode,ManfDesc,AllowOrderWOStockCheckFlag,Priority)=""
	;s IncArr=[]
	f  s IncSub=$o(^TMP("DHCSTM","InitializationIncItmData",IncSub)) q:(IncSub="")||(Err'=0)  d
	.s IncNum=""
	.f  s IncNum=$o(^TMP("DHCSTM","InitializationIncItmData",IncSub,IncNum)) q:(IncNum="")||(Err'=0)  d
	..s InciItmData=^TMP("DHCSTM","InitializationIncItmData",IncSub,IncNum)
	..i (IncSub="INC_Itm")&&(IncNum="1001") d
	...
	...s InciCode=$lg(InciItmData,1)
	...s InciDesc=$lg(InciItmData,2)
	...s BUomDesc=$lg(InciItmData,3)
	...s PUomDesc=$lg(InciItmData,4)
	...s Fac=$lg(InciItmData,5)
	...s Spec=$lg(InciItmData,6)
	...s Model=$lg(InciItmData,7)
	...s Rp=$lg(InciItmData,8)
	...s ChargFlag=$lg(InciItmData,9)
	...s BatNoReq=$lg(InciItmData,10)
	...s ExpDateReq=$lg(InciItmData,11)
	...s HighPriceFlag=$lg(InciItmData,12)
	..i (IncSub="ARC_ItmMast")&&(IncNum="1001") d
	...s ArcCat=$lg(InciItmData,1)
	...s ArcSubCat=$lg(InciItmData,2)
	...s BillCat=$lg(InciItmData,3)
	...s BillSubCat=$lg(InciItmData,4)
	...s TarCat=$lg(InciItmData,5)
	...s TarSubCat=$lg(InciItmData,6)
	...s InpaCat=$lg(InciItmData,7)
	...s InpaSubCat=$lg(InciItmData,8)
	...s OutpCat=$lg(InciItmData,9)
	...s OutpSubCat=$lg(InciItmData,10)
	...s EMCat=$lg(InciItmData,11)
	...s EMSubCat=$lg(InciItmData,12)
	...s AcctCat=$lg(InciItmData,13)
	...s AcctSubCat=$lg(InciItmData,14)
	...s MrCat=$lg(InciItmData,15)
	...s MrSubCat=$lg(InciItmData,16)
	...s MrSubCatNew=$lg(InciItmData,17)
	...s AllowOrderWOStockCheckFlag=$lg(InciItmData,18)
	...s Priority=$lg(InciItmData,19)
	..i (IncSub="APC_Vendor")&&(IncNum="1001") d
	...s ApcCode=$lg(InciItmData,1)
	...s ApcName=$lg(InciItmData,2)
	..i (IncSub="PH_Manufacturer")&&(IncNum="1001") d
	...s ManfCode=$lg(InciItmData,1)
	...s ManfDesc=$lg(InciItmData,2)
	s IncObj={}
	d IncObj.%Set("医院",Hospital)
	d IncObj.%Set("物资代码",InciCode)
	d IncObj.%Set("物资名称",InciDesc)
	d IncObj.%Set("规格",Spec)
	d IncObj.%Set("型号",Model)
	d IncObj.%Set("最小单位",BUomDesc)
	d IncObj.%Set("整包装单位",PUomDesc)
	d IncObj.%Set("整包转换系数",Fac)
	d IncObj.%Set("库存大类名称",gScg)
	d IncObj.%Set("库存子类名称",StkCat)
	d IncObj.%Set("供应商名称",ApcName)
	d IncObj.%Set("生产厂家名称",ManfDesc)
	d IncObj.%Set("进价",Rp)
	d IncObj.%Set("售价",Rp)
	d IncObj.%Set("批号要求",BatNoReq)
	d IncObj.%Set("效期要求",ExpDateReq)
	d IncObj.%Set("是否高值",HighPriceFlag)
	///医嘱子类等无法确保系统已存在暂只生成库存项
	/*
	d IncObj.%Set("医嘱大类",ArcCat)
	d IncObj.%Set("医嘱子类",ArcSubCat)
	d IncObj.%Set("账单大类",BillCat)
	d IncObj.%Set("账单子类",BillSubCat)
	d IncObj.%Set("收费大类",TarCat)
	d IncObj.%Set("收费子类",TarSubCat)
	d IncObj.%Set("住院大类",InpaCat)
	d IncObj.%Set("住院子类",InpaSubCat)
	d IncObj.%Set("门诊大类",OutpCat)
	d IncObj.%Set("门诊子类",OutpSubCat)
	d IncObj.%Set("核算大类",EMCat)
	d IncObj.%Set("核算子类",EMSubCat)
	d IncObj.%Set("会计大类",AcctCat)
	d IncObj.%Set("会计子类",AcctSubCat)
	d IncObj.%Set("病案大类",MrCat)
	d IncObj.%Set("病案子类",MrSubCat)
	d IncObj.%Set("新病案首页子类",MrSubCatNew)
	d IncObj.%Set("独立医嘱",AllowOrderWOStockCheckFlag)
	d IncObj.%Set("医嘱优先级",Priority)
	d IncObj.%Set("无库存医嘱","N")
	;d IncArr.%Push(IncObj)
	;s IncObjJson=IncArr.%ToJSON()
	//s Rtn=##class(web.DHCSTMHUI.Tools.CodeInputNew).InputIncItmA(IncObj,"")
	s Rtn=##class(web.DHCSTMHUI.Tools.CodeInputNew).InputIncItm(IncObj,"")
	i Rtn.success'=0 s Err=-17_","_Rtn.msg
	*/
	s Sub=0
	f  s Sub=$o(^TMP("DHCSTM","Initialization68ClassificationData",Sub)) q:(Sub="")||(Err'=0)  d
	.s CatDataList=^TMP("DHCSTM","Initialization68ClassificationData",Sub)
	.s ParCode=$lg(CatDataList,1)
	.s ParDesc=$lg(CatDataList,2)
	.s CatCodeA=$lg(CatDataList,3)	//一级产品类别
	.s CatDescA=$lg(CatDataList,4)
	.s CatCode2002=$lg(CatDataList,5)	//2002版本
	.s CatDesc2002=$lg(CatDataList,6)
	.s CatCodeB=$lg(CatDataList,7)	//二级产品类别
	.s CatDescB=$lg(CatDataList,8)
	.
	.s ParRowId=$o(^DHCMCO(0,"Code",$$ALPHAUP^SSUTIL4(ParCode),0))
	.i ParRowId="" d
	..s Obj=##class(User.DHCMatCatOfficial).%New()
	..s Obj.MCOCode=ParCode
	..s Obj.MCODesc=ParDesc
	..s Sc=Obj.%Save()
	..i $$$ISERR(Sc) s Err=-1 q
	..s ParRowId=Obj.%Id()
	.i CatCode2002'="" d
	..s RowId2002=$o(^DHCMCO(0,"Code",$$ALPHAUP^SSUTIL4(CatCode2002),0))
	..i RowId2002="" d
	...s Obj=##class(User.DHCMatCatOfficial).%New()
	..e  d
	...s Obj=##class(User.DHCMatCatOfficial).%OpenId(RowId2002)
	..
	..s Obj.MCOCode=CatCode2002
	..s Obj.MCODesc=CatDesc2002
	..d Obj.MCOUplevelDRSetObjectId(ParRowId)
	..s Sc=Obj.%Save()
	..i $$$ISERR(Sc) s Err=-2 q
	.
	.s RowIdA=$o(^DHCMCO(0,"Code",$$ALPHAUP^SSUTIL4(CatCodeA),0))
	.i RowIdA="" d
	..s Obj=##class(User.DHCMatCatOfficial).%New()
	.e  d
	..s Obj=##class(User.DHCMatCatOfficial).%OpenId(RowIdA)
	.
	.s Obj.MCOCode=CatCodeA
	.s Obj.MCODesc=CatDescA
	.d Obj.MCOUplevelDRSetObjectId(ParRowId)
	.s Sc=Obj.%Save()
	.i $$$ISERR(Sc) s Err=-2 q
	.s RowIdA=Obj.%Id()
	.i CatCodeB'="" d
	..s RowIdB=$o(^DHCMCO(0,"Code",$$ALPHAUP^SSUTIL4(CatCodeB),0))
	..i RowIdB="" d
	...s Obj=##class(User.DHCMatCatOfficial).%New()
	..e  d
	...s Obj=##class(User.DHCMatCatOfficial).%OpenId(RowIdB)
	..
	..s Obj.MCOCode=CatCodeB
	..s Obj.MCODesc=CatDescB
	..d Obj.MCOUplevelDRSetObjectId(RowIdA)
	..s Sc=Obj.%Save()
	..i $$$ISERR(Sc) s Err=-2 q
	i Err'=0 tro  q Err
	i Err=0 tc 
	q Err
}

/// 初始化基础字典
/// 1.订单取消原因:INC_POCanc_FullFillReason
/// 2.调价原因:DHC_ReasonForAdjustPrice
/// 3.调整原因:INC_ReasonForAdjustment
/// 4.退货原因:INC_ReasonForReturn
/// 5.报损原因:DHC_IncReasonForStockScrap
/// 6.请求单拒绝原因:DHC_ReasonForRefuseRequest
/// 7.出入库类型:DHC_OperateType
/// 8.资金来源维护:DHC_SourceOfFund
/// 9.收费类型:DHC_ItmChargeType
/// 10.灭菌分类:INC_SterileCategory
/// 11.实盘窗口:DHC_InStkTkWindow---涉及科室
/// 12.账簿分类:DHCST_BookCat
/// 13.支付方式:CT_PayMode
/// 14.执行标准维护:DHC_ItmQualityLevel
/// 15.不可用原因维护:DHC_ItmNotUseReason
ClassMethod InitializationBasicData() As %String
{
	k ^TMP("DHCSTM","InitializationBasicData")
	s ^TMP("DHCSTM","InitializationBasicData",1001)=$lb("POCancFullFillReason","订单错误","订单错误")
	s ^TMP("DHCSTM","InitializationBasicData",1002)=$lb("ReasonForAdjustPrice","价格变更","价格变更")
	s ^TMP("DHCSTM","InitializationBasicData",1003)=$lb("ReasonForAdjustment","滞销商品","滞销商品")
	s ^TMP("DHCSTM","InitializationBasicData",1004)=$lb("ReasonForReturn","材料过期","材料过期")
	s ^TMP("DHCSTM","InitializationBasicData",1005)=$lb("IncReasonForStockScrap","变形变质","变形变质")
	s ^TMP("DHCSTM","InitializationBasicData",1006)=$lb("ReasonForRefuseRequest","01","质量不合格,暂不出库")
	s ^TMP("DHCSTM","InitializationBasicData",1007)=$lb("OperateType","1","正常入库","IM")
	s ^TMP("DHCSTM","InitializationBasicData",1008)=$lb("OperateType","2","正常出库","OM")
	s ^TMP("DHCSTM","InitializationBasicData",1009)=$lb("SourceOfFund","1","财政资金")
	s ^TMP("DHCSTM","InitializationBasicData",10010)=$lb("ItmChargeType","1","现金")
	s ^TMP("DHCSTM","InitializationBasicData",10011)=$lb("ItmChargeType","2","刷卡")
	s ^TMP("DHCSTM","InitializationBasicData",10012)=$lb("SterileCategory","","低温")
	s ^TMP("DHCSTM","InitializationBasicData",10013)=$lb("InStkTkWindow","1","实盘窗口1")
	s ^TMP("DHCSTM","InitializationBasicData",10014)=$lb("BookCat","1","普通日记账")
	s ^TMP("DHCSTM","InitializationBasicData",10015)=$lb("PayMode","1","现金")
	s ^TMP("DHCSTM","InitializationBasicData",10016)=$lb("ItmQualityLevel","001","国家标准 （GB, GB/T）")
	s ^TMP("DHCSTM","InitializationBasicData",10017)=$lb("ItmNotUseReason","1","质量不合格")
	s ^TMP("DHCSTM","InitializationBasicData",10018)=$lb("ItmQualityLevel","002","行业标准 （YY, YY/T）")
	s ^TMP("DHCSTM","InitializationBasicData",10019)=$lb("ItmQualityLevel","003","注册产品标准 （YZB）")
	q ""
}

/// 初始化类组相关数据
/// 1.类组:DHC_StkCatGroup
/// 2.库存分类:INC_StkCat 
/// 3.关联表:DHC_StkCatGrpRelations
ClassMethod InitializationStkCatGroupData() As %String
{
	k ^TMP("DHCSTM","InitializationStkCatGroupData")
	s ^TMP("DHCSTM","InitializationStkCatGroupData",1001)=$lb("DHCStkCatGroup","YL","医疗","MM","卫生材料","卫生材料")
	s ^TMP("DHCSTM","InitializationStkCatGroupData",1002)=$lb("DHCStkCatGroup","ZW","总务","MO","办公材料","办公材料")
	q ""
}

/// 初始化基础字典(高值材料)
/// INC_Itm 、DHC_ItmAddionInfo、
/// ARC_ItmMast、DHC_TarItem、DHC_OrderLinkTar
/// APC_Vendor、DHC_STVendor、DHC_CertDetail、PH_Manufacturer
/// DHC_Manf_AddionInfo
ClassMethod InitializationIncItmData() As %String
{
	k ^TMP("DHCSTM","InitializationIncItmData")
	///代码、名称、基本单位、入库单位、转换系数、规格、型号、单价、收费标志、批号要求、效期要求、高值标志
	s ^TMP("DHCSTM","InitializationIncItmData","INC_Itm",1001)=$lb("WZCL001","一次注射器","支","盒","10","10ml","10ml","5","N","O","O","N")
	///医嘱大类、医嘱子类、账单大类、账单子类、收费大类、收费子类、住院大类、住院子类、门诊大类、门诊子类
	///核算大类、核算子类、会计大类、会计子类、病案大类、病案子类、新病案首页子类、独立医嘱、医嘱优先级
	///医保编码、医保描述(暂未添加)
	s ^TMP("DHCSTM","InitializationIncItmData","ARC_ItmMast",1001)=$lb("材料","卫生材料费","高值耗材","高值耗材","卫生材料费","卫生材料费","卫生材料费","卫生材料费","卫生材料费","卫生材料费","高值耗材","高值耗材","其他卫生材料费","其他卫生材料费","手术用一次性医用材料费","手术用一次性医用材料费","手术用一次性医用材料费","N","临时医嘱")
	///供应商代码、供应商描述
	s ^TMP("DHCSTM","InitializationIncItmData","APC_Vendor",1001)=$lb("初始化供应商","初始化供应商")
	///附加信息待定
	///s ^TMP("DHCSTM","InitializationIncItmData","DHC_STVendor",1001)=$lb()
	///生产厂家名称、生产厂家代码
	s ^TMP("DHCSTM","InitializationIncItmData","PH_Manufacturer",1001)=$lb("国药","国药")
	///供应商资质
	///s ^TMP("DHCSTM","InitializationIncItmData","DHC_CertDetail",1001)=$lb("Vendor")
	q ""
}

/// 68分类维护:DHC_MatCatOfficial
ClassMethod Initialization68ClassificationData() [ Private ]
{
	k ^TMP("DHCSTM","Initialization68ClassificationData")
	s ^TMP("DHCSTM","Initialization68ClassificationData",1)=$lb("6801","有源手术器械","6801-01","超声手术设备","2012版-6823-03","超声治疗设备中超声手术设备和高强度聚焦超声治疗设备","6801-01-01","超声手术设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",2)=$lb("6801","有源手术器械","6801-01","超声手术设备","2012版-6823-03","超声治疗设备中超声手术设备和高强度聚焦超声治疗设备","6801-01-02","高强度超声治疗设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",3)=$lb("6801","有源手术器械","6801-01","超声手术设备","2012版-6823-03","超声治疗设备中超声手术设备和高强度聚焦超声治疗设备","6801-01-03","超声手术设备附件")
	s ^TMP("DHCSTM","Initialization68ClassificationData",4)=$lb("6801","有源手术器械","6801-01","超声手术设备","2012版-6823-04","其他中超声探头")
	s ^TMP("DHCSTM","Initialization68ClassificationData",5)=$lb("6801","有源手术器械","6801-02","激光手术设备及附件","2002版-6824-01","激光手术和治疗设备（除眼科激光光凝机、眼晶体激光乳化设备外）","6801-02-01","激光手术设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",6)=$lb("6801","有源手术器械","6801-02","激光手术设备及附件","2002版-6824-01","激光手术和治疗设备（除眼科激光光凝机、眼晶体激光乳化设备外）","6801-02-02","医用激光光纤")
	s ^TMP("DHCSTM","Initialization68ClassificationData",7)=$lb("6801","有源手术器械","6801-03","高频/射频手术设备及附件","2002版-6825-01","高频手术和电凝设备","6801-03-01","高频手术设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",8)=$lb("6801","有源手术器械","6801-03","高频/射频手术设备及附件","2002版-6825-01","高频手术和电凝设备","6801-03-02","射频消融设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",9)=$lb("6801","有源手术器械","6801-03","高频/射频手术设备及附件","2002版-6825-01","高频手术和电凝设备","6801-03-03","氩保护气凝设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",10)=$lb("6801","有源手术器械","6801-03","高频/射频手术设备及附件","2002版-6825-01","高频手术和电凝设备","6801-03-04","高频/射频用电极及导管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",11)=$lb("6801","有源手术器械","6801-03","高频/射频手术设备及附件","2002版-6825-01","高频手术和电凝设备","6801-03-05","射频消融设备用灌注泵")
	s ^TMP("DHCSTM","Initialization68ClassificationData",12)=$lb("6801","有源手术器械","6801-04","微波手术设备","2002版-6825-03","微波治疗设备","6801-04-01","微波手术设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",13)=$lb("6801","有源手术器械","6801-05","冷冻手术设备及附件","2002版-6858-01","低温治疗仪器（除低温变速降温仪、液氮冷疗机外）","6801-05-01","冷冻手术设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",14)=$lb("6801","有源手术器械","6801-05","冷冻手术设备及附件","2002版-6858-01","低温治疗仪器（除低温变速降温仪、液氮冷疗机外）","6801-05-02","冷冻消融针及导管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",15)=$lb("6801","有源手术器械","6801-06","冲击波手术设备","2002版-6821-02","有创式电生理仪器及创新电生理仪器中体外震波碎石机","6801-06-01","冲击波碎石机")
	s ^TMP("DHCSTM","Initialization68ClassificationData",16)=$lb("6801","有源手术器械","6801-07","手术导航、控制系统","2002版-6854-01","手术及急救装置（除各种气压、电动气压止血带外）","6801-07-01","手术导航系统")
	s ^TMP("DHCSTM","Initialization68ClassificationData",17)=$lb("6801","有源手术器械","6801-07","手术导航、控制系统","2002版-6854-01","手术及急救装置（除各种气压、电动气压止血带外）","6801-07-02","手术定位系统")
	s ^TMP("DHCSTM","Initialization68ClassificationData",18)=$lb("6801","有源手术器械","6801-07","手术导航、控制系统","2002版-6854-01","手术及急救装置（除各种气压、电动气压止血带外）","6801-07-03","手术控制系统")
	s ^TMP("DHCSTM","Initialization68ClassificationData",19)=$lb("6801","有源手术器械","6801-08","手术照明设备","2002版-6854-13","手术灯","6801-08-01","手术无影灯")
	s ^TMP("DHCSTM","Initialization68ClassificationData",20)=$lb("6801","有源手术器械","6801-08","手术照明设备","2002版-6854-13","手术灯","6801-08-02","手术辅助照明灯")
	s ^TMP("DHCSTM","Initialization68ClassificationData",21)=$lb("6801","有源手术器械","6801-09","内窥镜手术用有源设备","2002版-6822-02","心及血管、有创、腔内手术用内窥镜","6801-09-01","内窥镜手术用有源设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",22)=$lb("6801","有源手术器械","6801-10","其他手术设备","2002版-6816-06","烧伤（整形）用其他器械","6801-10-01","水刀")
	s ^TMP("DHCSTM","Initialization68ClassificationData",23)=$lb("6801","有源手术器械","6801-10","其他手术设备","2002版-6816-06","烧伤（整形）用其他器械","6801-10-02","分离控制盒")
	s ^TMP("DHCSTM","Initialization68ClassificationData",24)=$lb("6801","有源手术器械","6801-10","其他手术设备","2002版-6816-06","烧伤（整形）用其他器械","6801-10-03","电动吻合器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",25)=$lb("6801","有源手术器械","6801-10","其他手术设备","2002版-6816-06","烧伤（整形）用其他器械","6801-10-04","手术动力系统")
	s ^TMP("DHCSTM","Initialization68ClassificationData",26)=$lb("6801","有源手术器械","6801-10","其他手术设备","2002版-6816-06","烧伤（整形）用其他器械","6801-10-05","取、植皮设备")
	
	s ^TMP("DHCSTM","Initialization68ClassificationData",27)=$lb("6802","无源手术器械","6802-01","手术器械-刀","2002版-6801-2","基础外科用刀","6802-01-01","手术刀")
	s ^TMP("DHCSTM","Initialization68ClassificationData",28)=$lb("6802","无源手术器械","6802-01","手术器械-刀","2002版-6801-2","基础外科用刀","6802-01-02","血管刀")
	s ^TMP("DHCSTM","Initialization68ClassificationData",29)=$lb("6802","无源手术器械","6802-01","手术器械-刀","2002版-6801-2","基础外科用刀","6802-01-03","备皮刀")
	s ^TMP("DHCSTM","Initialization68ClassificationData",30)=$lb("6802","无源手术器械","6802-01","手术器械-刀","2002版-6801-2","基础外科用刀","6802-01-04","环切器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",31)=$lb("6802","无源手术器械","6802-01","手术器械-刀","2002版-6801-2","基础外科用刀","6802-01-05","内窥镜用刀")
	s ^TMP("DHCSTM","Initialization68ClassificationData",32)=$lb("6802","无源手术器械","6802-02","手术器械-凿","2002版-6802-1","显微外科用刀、凿","6802-02-01","手术凿")
	s ^TMP("DHCSTM","Initialization68ClassificationData",33)=$lb("6802","无源手术器械","6802-02","手术器械-凿","2002版-6802-1","显微外科用刀、凿","6802-02-02","手术锤")
	s ^TMP("DHCSTM","Initialization68ClassificationData",34)=$lb("6802","无源手术器械","6802-02","手术器械-凿","2002版-6816-1","烧伤（整形）用刀、凿")
	s ^TMP("DHCSTM","Initialization68ClassificationData",35)=$lb("6802","无源手术器械","6802-03","手术器械-剪","2002版-6801-3","基础外科用剪","6802-03-01","组织剪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",36)=$lb("6802","无源手术器械","6802-03","手术器械-剪","2002版-6801-3","基础外科用剪","6802-03-02","器械剪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",37)=$lb("6802","无源手术器械","6802-03","手术器械-剪","2002版-6801-3","基础外科用剪","6802-03-03","内窥镜用剪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",38)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-01","组织钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",39)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-02","取样钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",40)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-03","分离钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",41)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-04","牵引钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",42)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-05","异物钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",43)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-06","止血钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",44)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-07","扩张钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",45)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-08","器械钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",46)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-09","内窥镜用组织钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",47)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-10","内窥镜用取样钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",48)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-11","内窥镜用分离钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",49)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-12","内窥镜用异物钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",50)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳","6802-04-13","内窥镜用器械钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",51)=$lb("6802","无源手术器械","6802-05","手术器械-镊","2002版-6801-5","基础外科用镊、夹")
	s ^TMP("DHCSTM","Initialization68ClassificationData",52)=$lb("6802","无源手术器械","6802-05","手术器械-镊","2002版-6802-4","显微外科用镊、夹")
	s ^TMP("DHCSTM","Initialization68ClassificationData",53)=$lb("6802","无源手术器械","6802-05","手术器械-镊","2002版-6805-4","耳鼻喉科用镊、夹","6802-05-01","组织镊")
	s ^TMP("DHCSTM","Initialization68ClassificationData",54)=$lb("6802","无源手术器械","6802-05","手术器械-镊","2002版-6805-4","耳鼻喉科用镊、夹","6802-05-02","器械镊")
	s ^TMP("DHCSTM","Initialization68ClassificationData",55)=$lb("6802","无源手术器械","6802-06","手术器械-夹","2002版-6809-6","泌尿肛肠科用其他器械中的阴茎夹")
	s ^TMP("DHCSTM","Initialization68ClassificationData",56)=$lb("6802","无源手术器械","6802-06","手术器械-夹","2002版-6816-4","烧伤（整形）用镊、夹","6802-06-01","闭合夹")
	s ^TMP("DHCSTM","Initialization68ClassificationData",57)=$lb("6802","无源手术器械","6802-06","手术器械-夹","2002版-6816-4","烧伤（整形）用镊、夹","6802-06-02","止血夹")
	s ^TMP("DHCSTM","Initialization68ClassificationData",58)=$lb("6802","无源手术器械","6802-06","手术器械-夹","2002版-6816-4","烧伤（整形）用镊、夹","6802-06-03","器械夹")
	s ^TMP("DHCSTM","Initialization68ClassificationData",59)=$lb("6802","无源手术器械","6802-07","手术器械-针","2002版-6801-1","医用缝合针（不带线）","6802-07-01","缝合针")
	s ^TMP("DHCSTM","Initialization68ClassificationData",60)=$lb("6802","无源手术器械","6802-07","手术器械-针","2002版-6801-1","医用缝合针（不带线）","6802-07-02","手术针")
	s ^TMP("DHCSTM","Initialization68ClassificationData",61)=$lb("6802","无源手术器械","6802-07","手术器械-针","2002版-6801-1","医用缝合针（不带线）","6802-07-03","定位针")
	s ^TMP("DHCSTM","Initialization68ClassificationData",62)=$lb("6802","无源手术器械","6802-07","手术器械-针","2002版-6801-1","医用缝合针（不带线）","6802-07-04","内窥镜取样针")
	s ^TMP("DHCSTM","Initialization68ClassificationData",63)=$lb("6802","无源手术器械","6802-08","手术器械-钩","2002版-6801-6","基础外科用针、钩")
	s ^TMP("DHCSTM","Initialization68ClassificationData",64)=$lb("6802","无源手术器械","6802-08","手术器械-钩","2002版-6802-5","显微外科用针、钩")
	s ^TMP("DHCSTM","Initialization68ClassificationData",65)=$lb("6802","无源手术器械","6802-08","手术器械-钩","2002版-6805-5","耳鼻喉科用针、钩")
	s ^TMP("DHCSTM","Initialization68ClassificationData",66)=$lb("6802","无源手术器械","6802-08","手术器械-钩","2002版-6808-4","腹部外科用针、钩")
	s ^TMP("DHCSTM","Initialization68ClassificationData",67)=$lb("6802","无源手术器械","6802-08","手术器械-钩","2002版-6809-5","泌尿肛肠科用针、钩")
	s ^TMP("DHCSTM","Initialization68ClassificationData",68)=$lb("6802","无源手术器械","6802-08","手术器械-钩","2002版-6809-5","泌尿肛肠科用针、钩","6802-08-01","手术钩")
	s ^TMP("DHCSTM","Initialization68ClassificationData",69)=$lb("6802","无源手术器械","6802-08","手术器械-钩","2002版-6809-5","泌尿肛肠科用针、钩","6802-08-02","内窥镜用钩")
	s ^TMP("DHCSTM","Initialization68ClassificationData",70)=$lb("6802","无源手术器械","6802-09","手术器械-刮匙","2002版-6801-7","基础外科用其他器械中的皮肤刮匙")
	s ^TMP("DHCSTM","Initialization68ClassificationData",71)=$lb("6802","无源手术器械","6802-09","手术器械-刮匙","2002版-6805-6","耳鼻喉科用其他器械中的耳单头（双头）刮匙")
	s ^TMP("DHCSTM","Initialization68ClassificationData",72)=$lb("6802","无源手术器械","6802-09","手术器械-刮匙","2002版-6808-6","腹部外科用其他器械中的单（双）胆石匙","6802-09-01","手术刮匙")
	s ^TMP("DHCSTM","Initialization68ClassificationData",72)=$lb("6802","无源手术器械","6802-09","手术器械-刮匙","2002版-6808-6","腹部外科用其他器械中的单（双）胆石匙","6802-09-02","内窥镜用组织刮匙")
	s ^TMP("DHCSTM","Initialization68ClassificationData",73)=$lb("6802","无源手术器械","6802-10","手术器械-剥离器","6802-10-01","剥离器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",74)=$lb("6802","无源手术器械","6802-10","手术器械-剥离器","6802-10-02","内窥镜用剥离器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",75)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6802-6","显微外科用其他器械中的显微合拢器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",76)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-1","医用可吸收缝合线（带针/不带针）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",77)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-2","不可吸收缝合线（带针/不带针）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",78)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-3","医用粘合剂中的医用α氰基丙烯酸脂类、血管吻合粘合剂、表皮粘合剂、粘合带、生物胶")
	s ^TMP("DHCSTM","Initialization68ClassificationData",79)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料")
	s ^TMP("DHCSTM","Initialization68ClassificationData",80)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-01","吻合器（带钉）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",81)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-02","吻合器（不带钉）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",82)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-03","内窥镜用吻（缝）合器械（不带钉）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",83)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-04","血管缝合装置")
	s ^TMP("DHCSTM","Initialization68ClassificationData",84)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-05","施夹器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",85)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-06","可吸收缝合线")
	s ^TMP("DHCSTM","Initialization68ClassificationData",86)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-07","不可吸收缝合线")
	s ^TMP("DHCSTM","Initialization68ClassificationData",87)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-08","免缝闭合器械")
	s ^TMP("DHCSTM","Initialization68ClassificationData",88)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-09","粘合剂")
	s ^TMP("DHCSTM","Initialization68ClassificationData",89)=$lb("6802","无源手术器械","6802-13","手术器械-吻（缝）合器械及材料","2002版-6865-4","表面缝合材料","6802-13-10","粘堵剂")
	s ^TMP("DHCSTM","Initialization68ClassificationData",90)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-01","套扎器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",91)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-02","推结器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",92)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-03","固位器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",93)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-04","清洁器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",94)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-05","测量器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",95)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-06","保护器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",96)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-07","植皮器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",97)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-08","标记器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",98)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-09","手柄")
	s ^TMP("DHCSTM","Initialization68ClassificationData",99)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-10","手术锉")
	s ^TMP("DHCSTM","Initialization68ClassificationData",100)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-11","手术叉")
	s ^TMP("DHCSTM","Initialization68ClassificationData",101)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-12","手术环")
	s ^TMP("DHCSTM","Initialization68ClassificationData",102)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-13","试模")
	s ^TMP("DHCSTM","Initialization68ClassificationData",103)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-14","夹子装置")
	s ^TMP("DHCSTM","Initialization68ClassificationData",104)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-15","肛门镜")
	s ^TMP("DHCSTM","Initialization68ClassificationData",105)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-16","内窥镜用推结器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",106)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-17","内窥镜用细胞刷")
	s ^TMP("DHCSTM","Initialization68ClassificationData",107)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-18","内窥镜用取石器械")
	s ^TMP("DHCSTM","Initialization68ClassificationData",108)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-19","内窥镜切口牵开保护器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",109)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-20","内窥镜用取石球囊导管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",110)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-21","内窥镜用气囊导管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",111)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-22","内窥镜用给物器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",112)=$lb("6802","无源手术器械","6802-15","手术器械-其他器械","2002版-6801-7","基础外科用其他器械中的皮肤刮划测检器、皮肤检查尺、开口器","6802-15-23","内窥镜用套扎器")
	
	/*
	s ^TMP("DHCSTM","Initialization68ClassificationData",21)=$lb("6802","无源手术器械","6802-06","手术器械-夹","2002版-6809-6","泌尿肛肠科用其他器械中的阴茎夹")
	s ^TMP("DHCSTM","Initialization68ClassificationData",43)=$lb("6802","无源手术器械","6802-07","手术器械-夹","2002版-6816-4","烧伤（整形）用镊、夹")
	
	
	
	s ^TMP("DHCSTM","Initialization68ClassificationData",26)=$lb("6802","无源手术器械","6802-11","手术器械-牵开器","2002版-6805-6","耳鼻喉科用其他器械中的乳突牵开器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",50)=$lb("6802","无源手术器械","6802-12","手术器械-牵开器","2002版-6808-6","腹部外科用其他器械中的压肠板、胆道探条、腹壁固定牵开器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",51)=$lb("6802","无源手术器械","6802-13","手术器械-牵开器","2002版-6809-6","泌尿肛肠科用其他器械中的尿道扩张器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",52)=$lb("6802","无源手术器械","6802-14","手术器械-牵开器","2002版-6816-6","烧伤（整形）用其他器械中的嘴形撑开器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",27)=$lb("6802","无源手术器械","6802-12","手术器械-穿刺导引器","2002版-6801-7","基础外科用其他器械中的皮肤组织钻孔器")
	
	
	s ^TMP("DHCSTM","Initialization68ClassificationData",31)=$lb("6802","无源手术器械","6802-03","手术器械-剪","2002版-6802-2","显微外科用剪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",32)=$lb("6802","无源手术器械","6802-03","手术器械-剪","2002版-6805-2","耳鼻喉科用剪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",33)=$lb("6802","无源手术器械","6802-03","手术器械-剪","2002版-6808-2","腹部外科用剪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",34)=$lb("6802","无源手术器械","6802-03","手术器械-剪","2002版-6809-2","泌尿肛肠科用剪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",35)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6801-4","基础外科用钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",36)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6802-3","显微外科用钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",37)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6805-3","耳鼻喉科用钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",38)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6808-3","腹部外科用钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",39)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6809-3","泌尿肛肠科用钳")
	s ^TMP("DHCSTM","Initialization68ClassificationData",40)=$lb("6802","无源手术器械","6802-04","手术器械-钳","2002版-6816-3","烧伤（整形）用钳")
	
	s ^TMP("DHCSTM","Initialization68ClassificationData",53)=$lb("6807","医用诊察和监护器械","6807-01","诊察辅助器械","2002版-6820-4","听诊器（无电能）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",54)=$lb("6807","医用诊察和监护器械","6807-01","诊察辅助器械","2002版-6820-5","叩诊锤（无电能）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",55)=$lb("6807","医用诊察和监护器械","6807-01","诊察辅助器械","2002版-6820-6","反光器具")
	s ^TMP("DHCSTM","Initialization68ClassificationData",56)=$lb("6807","医用诊察和监护器械","6807-02","呼吸功能及气体分析测定装置","2002版-6820-3","肺量计")
	s ^TMP("DHCSTM","Initialization68ClassificationData",57)=$lb("6807","医用诊察和监护器械","6807-02","呼吸功能及气体分析测定装置","2002版-6821-10","呼吸功能及气体分析测定装置")
	s ^TMP("DHCSTM","Initialization68ClassificationData",58)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6820-1","体温计")
	s ^TMP("DHCSTM","Initialization68ClassificationData",59)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6820-2","血压计")
	s ^TMP("DHCSTM","Initialization68ClassificationData",60)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-2","有创式电生理仪器及创新电生理仪器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",61)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-4","心电诊断仪器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",62)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-5","脑电诊断仪器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",63)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-6","肌电诊断仪器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",64)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-9","无创监护仪器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",65)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-12","血流量、容量测定装置")
	s ^TMP("DHCSTM","Initialization68ClassificationData",66)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-13","电子压力测定装置-电子血压脉搏仪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",67)=$lb("6807","医用诊察和监护器械","6807-03","生理参数分析测量设备","2002版-6821-14","生理研究实验仪器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",68)=$lb("6807","医用诊察和监护器械","6807-04","监护设备","2002版-6821-13","电子压力测定装置-动态血压监护仪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",69)=$lb("6807","医用诊察和监护器械","6807-05","电声学测量、分析设备","2002版-6821-8","电声诊断仪器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",70)=$lb("6807","医用诊察和监护器械","6807-06","放射性核素诊断设备","2002版-6833-8","放射性核素诊断设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",71)=$lb("6807","医用诊察和监护器械","6807-07","超声测量、分析设备","2012版-6823-1","超声诊断设备中的超声多普勒血流分析设备和超声骨密度仪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",72)=$lb("6807","医用诊察和监护器械","6807-07","超声测量、分析设备","2012版-6823-2","超声监护设备中的超声多普勒胎儿监护仪")
	s ^TMP("DHCSTM","Initialization68ClassificationData",73)=$lb("6807","医用诊察和监护器械","6807-08","遥测和中央监护设备","","")
	s ^TMP("DHCSTM","Initialization68ClassificationData",74)=$lb("6807","医用诊察和监护器械","6807-09","其他测量、分析设备","","")
	s ^TMP("DHCSTM","Initialization68ClassificationData",75)=$lb("6807","医用诊察和监护器械","6807-10","附件、耗材","2002版-6821-3","有创医用传感器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",76)=$lb("6807","医用诊察和监护器械","6807-10","附件、耗材","2002版-6821-3","无创医用传感器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",77)=$lb("6807","医用诊察和监护器械","6807-10","附件、耗材","2002版-6821-18","心电电极")
	s ^TMP("DHCSTM","Initialization68ClassificationData",78)=$lb("6807","医用诊察和监护器械","6807-10","附件、耗材","2002版-6821-19","心电导联线")
	
	s ^TMP("DHCSTM","Initialization68ClassificationData",79)=$lb("6808","呼吸、麻醉和急救器械","6808-01","呼吸设备","2002版-6854-2","呼吸设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",80)=$lb("6808","呼吸、麻醉和急救器械","6808-02","麻醉器械","2002版-6854-3","呼吸麻醉设备及附件（不包括碱石灰）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",81)=$lb("6808","呼吸、麻醉和急救器械","6808-03","急救设备","2002版-6821-1","用于心脏的治疗、急救装置中的心脏除颤器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",82)=$lb("6808","呼吸、麻醉和急救器械","6808-04","急救设备","2002版-6854-4","婴儿保育设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",83)=$lb("6808","呼吸、麻醉和急救器械","6808-05","急救设备","2002版-6854-7","呼吸设备配件中的简易呼吸器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",84)=$lb("6808","呼吸、麻醉和急救器械","6808-04","医用制氧设备","2002版-6854-8","医用制气设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",85)=$lb("6808","呼吸、麻醉和急救器械","6808-05","呼吸、麻醉、急救设备辅助装置","2002版-6805-6","耳鼻喉科用其他器械中的麻醉咽喉镜")
	s ^TMP("DHCSTM","Initialization68ClassificationData",86)=$lb("6808","呼吸、麻醉和急救器械","6808-06","呼吸、麻醉、急救设备辅助装置","2002版-6823-3","超声治疗设备中的超声雾化器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",87)=$lb("6808","呼吸、麻醉和急救器械","6808-07","呼吸、麻醉、急救设备辅助装置","2002版-6826-5","理疗康复仪器中的防打鼾器（正压呼吸治疗机）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",88)=$lb("6808","呼吸、麻醉和急救器械","6808-08","呼吸、麻醉、急救设备辅助装置","2002版-6854-3","呼吸麻醉设备及附件中的碱石灰")
	s ^TMP("DHCSTM","Initialization68ClassificationData",89)=$lb("6808","呼吸、麻醉和急救器械","6808-09","呼吸、麻醉、急救设备辅助装置","2002版-6854-7","呼吸设备配件中的浮标式、墙式、手提式氧气吸入器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",90)=$lb("6808","呼吸、麻醉和急救器械","6808-10","呼吸、麻醉、急救设备辅助装置","2002版-6866-5","呼吸麻醉或通气用气管插管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",91)=$lb("6808","呼吸、麻醉和急救器械","6808-06","呼吸、麻醉用管路、面罩","2002版-6856-4","医用供气、输气装置（不包括氧气袋）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",92)=$lb("6808","呼吸、麻醉和急救器械","6808-07","呼吸、麻醉用管路、面罩","2002版-6866-1","输液、输血器具及管路中的麻醉导管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",93)=$lb("6808","呼吸、麻醉和急救器械","6808-08","呼吸、麻醉用管路、面罩","2002版-6866-5","呼吸麻醉或通气用气管插管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",94)=$lb("6808","呼吸、麻醉和急救器械","6808-07","医用供气排气相关设备","2002版-6856-1","供氧系统（不包括氧浓度监察仪）")
	
	s ^TMP("DHCSTM","Initialization68ClassificationData",95)=$lb("6809","物理治疗器械","6809-01","电疗设备/器具","2002版-6826-02","电疗仪器（全部）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",96)=$lb("6809","物理治疗器械","6809-01","电疗设备/器具","2002版-6826-4","高压电位治疗设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",97)=$lb("6809","物理治疗器械","6809-01","电疗设备/器具","2002版-6826-9","理疗用电极")
	s ^TMP("DHCSTM","Initialization68ClassificationData",98)=$lb("6809","物理治疗器械","6809-02","温热（冷）治疗设备/器具","2002版-6858-01","低温治疗仪器（液氮冷疗机、低温治疗机）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",99)=$lb("6809","物理治疗器械","6809-02","温热（冷）治疗设备/器具","2002版-6858-5","冷敷器具")
	s ^TMP("DHCSTM","Initialization68ClassificationData",100)=$lb("6809","物理治疗器械","6809-03","光治疗设备","2002版-6826-03","光谱辐射治疗仪器（紫外线治疗机、红外线治疗机、光谱治疗仪、强光辐射治疗仪）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",101)=$lb("6809","物理治疗器械","6809-03","光治疗设备","2002版-6824-05","弱激光体外治疗仪器（氦氖激光治疗机、半导体激光治疗机）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",102)=$lb("6809","物理治疗器械","6809-04","力疗设备/器具","2002版-6826-05","理疗康复仪器（医疗压力带、腰部保健带、颈椎固定带）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",103)=$lb("6809","物理治疗器械","6809-05","磁疗设备/器具","2002版-6826-07","磁疗仪器（磁疗机、磁感应电疗机、磁疗器具）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",104)=$lb("6809","物理治疗器械","6809-06","超声治疗设备","2002版-6823-03-04","非理疗超声治疗设备（超声治疗系统、超声治疗仪）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",105)=$lb("6809","物理治疗器械","6809-06","超声治疗设备","2002版-6823-03-05","超声理疗设备（超声理疗仪）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",106)=$lb("6809","物理治疗器械","6809-07","高频治疗设备","2002版-6825-03","微波治疗设备（微波治疗机）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",107)=$lb("6809","物理治疗器械","6809-07","高频治疗设备","2002版-6825-04","射频治疗设备（短波治疗机）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",108)=$lb("6809","物理治疗器械","6809-08","其他物理治疗设备","2002版-6826-01","高压氧治疗设备（空气加压医用氧舱、氧气加压氧舱）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",109)=$lb("6809","物理治疗器械","6809-08","其他物理治疗设备","2002版-6826-05","理疗设备（肠道水疗机）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",110)=$lb("6809","物理治疗器械","6809-08","其他物理治疗设备","2002版-6826-06","生物反馈仪（肌电生物反馈仪）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",111)=$lb("6809","物理治疗器械","6809-08","其他物理治疗设备","2002版-6826-10","其他（部分）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",112)=$lb("6809","物理治疗器械","6809-04","力疗设备/器具","2002版-6826-16","体外反搏及其辅助循环装置")
	
	s ^TMP("DHCSTM","Initialization68ClassificationData",113)=$lb("6810","输血、透析和体外循环器械","6810-01","血液分离、处理、贮存设备","2002版-6845-4","血液净化设备和血液净化器具中术中自体血液回输机")
	s ^TMP("DHCSTM","Initialization68ClassificationData",114)=$lb("6810","输血、透析和体外循环器械","6810-01","血液分离、处理、贮存设备","2002版-6845-6","体液处理设备中单采血浆机、人体血液处理机、腹水浓缩机、血液成分输血装置、血液成分分离机")
	s ^TMP("DHCSTM","Initialization68ClassificationData",115)=$lb("6810","输血、透析和体外循环器械","6810-02","血液分离、处理、贮存器具","2002版-6845-4","血液净化设备和血液净化器具中动静脉穿刺器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",116)=$lb("6810","输血、透析和体外循环器械","6810-02","血液分离、处理、贮存器具","2002版-6866-1","输液、输血器具及管路中输血器、血袋、血液成分分离器材、连接管路")
	s ^TMP("DHCSTM","Initialization68ClassificationData",117)=$lb("6810","输血、透析和体外循环器械","6810-03","血液净化及腹膜透析设备","2002版-6845-4","血液净化设备和血液净化器具中血液透析装置、血液透析滤过装置、血液滤过装置")
	s ^TMP("DHCSTM","Initialization68ClassificationData",118)=$lb("6810","输血、透析和体外循环器械","6810-03","血液净化及腹膜透析设备","2002版-6845-5","血液净化设备辅助装置中滚柱式离心式输血泵")
	s ^TMP("DHCSTM","Initialization68ClassificationData",119)=$lb("6810","输血、透析和体外循环器械","6810-03","血液净化及腹膜透析设备","2002版-6845-6","体液处理设备中腹膜透析机")
	s ^TMP("DHCSTM","Initialization68ClassificationData",120)=$lb("6810","输血、透析和体外循环器械","6810-04","血液净化及腹膜透析器具","2002版-6845-4","血液净化设备和血液净化器具中血液净化管路、透析血路、血路塑料泵管、中空纤维透析器、中空纤维滤过器、吸附器、血浆分离器、血液解毒（灌流灌注）器、血液净化体外循环血路（管道）")
	s ^TMP("DHCSTM","Initialization68ClassificationData",121)=$lb("6810","输血、透析和体外循环器械","6810-04","血液净化及腹膜透析器具","2002版-6845-6","体液处理设备中腹膜透析管")
	s ^TMP("DHCSTM","Initialization68ClassificationData",122)=$lb("6810","输血、透析和体外循环器械","6810-04","血液净化及腹膜透析器具","2002版-6845-7","透析粉、透析液")
	s ^TMP("DHCSTM","Initialization68ClassificationData",123)=$lb("6810","输血、透析和体外循环器械","6810-05","心肺转流设备","2002版-6845-1","人工心肺设备")
	s ^TMP("DHCSTM","Initialization68ClassificationData",124)=$lb("6810","输血、透析和体外循环器械","6810-05","心肺转流设备","2002版-6845-3","人工心肺设备辅助装置中血泵、热交换器、水箱")
	s ^TMP("DHCSTM","Initialization68ClassificationData",125)=$lb("6810","输血、透析和体外循环器械","6810-06","心肺转流器具","2002版-6845-2","氧合器")
	s ^TMP("DHCSTM","Initialization68ClassificationData",126)=$lb("6810","输血、透析和体外循环器械","6810-06","心肺转流器具","2002版-6845-3","人工心肺设备辅助装置中贮血滤血器、微栓过滤器、滤血器、滤水器（超滤）、泵管、血路")
	s ^TMP("DHCSTM","Initialization68ClassificationData",127)=$lb("6810","输血、透析和体外循环器械","6810-07","其他","2002版-6845-6","体液处理设备中腹水浓缩机")
	*/
	q ""
}

}
