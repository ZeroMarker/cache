/// creator:屈坚
/// date:2023-03-03
/// desc:医保控费处理传输数据
Class DHCDoc.Order.InsuOrderRules Extends DHCDoc.Util.RegisteredObject
{

ClassMethod GetAllBeforeOrderInfos(OrdItemStr As %String, LogonUserId As %String, LogonDep As %String)
{
	q:((OrdItemStr="")||(LogonUserId="")||(LogonDep=""))
	s AllBeforeOrderInfos=""
	f i=1:1:$l(OrdItemStr,$c(1)) d
	.s OneOrdItem=$p(OrdItemStr,$c(1),i)
	.s OrderInfoStr=..GetOneBeforeOrderInfos(OneOrdItem,LogonUserId,LogonDep)
	.i AllBeforeOrderInfos="" s AllBeforeOrderInfos=OrderInfoStr
	.e  s AllBeforeOrderInfos=AllBeforeOrderInfos_"|"_OrderInfoStr
	
	q AllBeforeOrderInfos
}

ClassMethod GetOneBeforeOrderInfos(OrdItem As %String, LogonUserId As %String, LogonLocId As %String) As %String
{
	q:((OrdItem="")||(LogonUserId="")) ""
	
	s ^TmpXpc("GetOneBeforeOrderInfos")=OrdItem_"^"_LogonUserId_"^"_LogonLocId
	s (OrderCategoryDr,MedicalFlag,ArcimCode,ArcimDesc,OrderPackQty,OrderPrice,OrderSum,PrescNo,OrderDepCode)=""
	s (OrderDepDesc,OrderAddDocCode,OrderAddDocName,OrderAddDocLevelDesc,OutPirorDr,OrderInstrucCode,OrderPHFreqCode,OrderDuraTionDays,OrderDoseQty)=""
	s (OrderOneDayQty,OrderFirstQty,OrderUnitDesc,DFFalg,OrderFactor,OrderPaQueQty,OrderBarCode,OrderExecDepCode,OrderExecDepDesc)=""
	s (OrderDate,OrderTime,OrderBabyFeeFlag,OrderLUom,OrderDocDuration,OrderArcItemCat,OrderAdmReason,OrderCoverMain,RCFlag)=""
	s (OrderPHCForm,OrderAllQty,OrderQtyALlUomCode,OrderSkinTest,MZMethod,JKMethod,OrderPlain,FinalStr,OrderLargeUom,OrderSmallUom)=""
	
	s ArcimRowId=$p(OrdItem,"^",1)
	s ArcItmCatDr=$p(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1),"^",10)
	s OrderCategoryDr=$p(^ARC("IC",ArcItmCatDr),"^",8)  ;1 医嘱大类
	s OrderType=$p(OrdItem,"^",2)  
	i OrderType="R" s MedicalFlag="Y"  e  s MedicalFlag="N" ;2 药品标志
	;q:OrderType'="R" 1
	s ArcimCode=$p(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1),"^",1) ;3
	s ArcimDesc=$p(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1),"^",2) ;4
	s OrderPackQty=$p(OrdItem,"^",14)  ;5 数量
	b ;2
	i +OrderPackQty=0 s OrderPackQty=1
	s OrderPrice=$p(OrdItem,"^",7) ;6 单价
	s OrderSum=OrderPackQty*OrderPrice ;7 总金额 需判断
	b ;j
	s PrescNo="" ;8 处方号
	s OrderDepDr=LogonLocId
	;s OrderDepCode=$p(^CTLOC(OrderDepDr),"^",1) ;9 开医嘱科室
	s OrderDepCode=OrderDepDr
	s OrderDepDesc=$p(^CTLOC(OrderDepDr),"^",2) ;10 开医嘱科室
	s OrderAddUser=LogonUserId
    s OrderAddDoc=$p(^SSU("SSUSR",OrderAddUser),"^",14)
	s OrderAddDocCode=$p(^CTPCP(OrderAddDoc,1),"^",1) ;11 开医嘱医生
	s OrderAddDocName=$p(^CTPCP(OrderAddDoc,1),"^",2) ;12 开医嘱医生
	s OrderAddDocLevelDr=$p(^CTPCP(OrderAddDoc,1),"^",4)
	s OrderAddDocLevelDesc=$p( ^CT("CPT",OrderAddDocLevelDr),"^",2) ;13 医生级别
	s OrderPirorDr=$p(OrdItem,"^",3)
	s OutPirorDr=$o(^OECPR(0,"Code","OUT",""))
	i OrderPirorDr=OutPirorDr s OutFlag="Y"  e  s OutPirorDr="N"  ;14 是否出院带药
	
	s OrderInstruc=$p(OrdItem,"^",17)
	i OrderInstruc'=""  s OrderInstrucCode=$p(^PHCIN(OrderInstruc),"^",1) ;15 用药途径
	s OrderPHFreq=$p(OrdItem,"^",15)
	i OrderPHFreq'="" s OrderPHFreqCode=$p(^PHCFR(OrderPHFreq),"^",1)  ;16 频次
	s OrderDuraTion=$p(OrdItem,"^",16)
	i OrderDuraTion'="" s OrderDuraTionDays=$p(^PHCDU(OrderDuraTion),"^",3) ;17 疗程
	s OrderDoseQty=$p(OrdItem,"^",12)  ;18 单次用量
	i OrderPHFreq'=""  d
	.s OrderOnedayFreq=$p(^PHCFR(OrderPHFreq),"^",2)
	.s OrderOneDayQty=OrderOnedayFreq*OrderDoseQty ;19 每日用量
	s OrderFirstQty="" ;20 首次用量
	
	s OrderUnitDr=$p(OrdItem,"^",13)
	i OrderUnitDr'="" s OrderUnitDesc=$p(^CT("UOM",OrderUnitDr),"^",2)  ;21 用量单位
	;22 中药单复方标志
	s OrderPackUOMRowid=$p(OrdItem,"^",55)
    s OrderFactor=1
	i ((OrderPackUOMRowid'="")&&(OrderUnitDr'="")) s OrderFactor=##class(web.DHCSTCOMMONSRV).UOMFac(OrderPackUOMRowid,OrderUnitDr) ;23 转换系数
	s OrderPaQueQty=OrderFactor*OrderPackQty ;24 处方用量
	s OrderIncidr=$o(^INCI(0,"ARCIM_DR",+ArcimRowId,""))
	i OrderIncidr'="" s OrderBarCode=$p(^INCI(OrderIncidr,3),"^",9) ;25 药品规格
	s OrderExecDepDr=$p(OrdItem,"^",8)
	;s OrderExecDepCode=$p(^CTLOC(OrderExecDepDr),"^",1)  ;26 执行科室
	s OrderExecDepCode=OrderExecDepDr
	s OrderExecDepDesc=$p(^CTLOC(OrderExecDepDr),"^",2) ;27 执行科室
	s OrderDate=$p(OrdItem,"^",46)
	;s OrderDate=$zd(OrderDate,3) ;28 开医嘱日期
	s OrderTime=$p(OrdItem,"^",47)
	;s OrderTime=$zt(OrderTime,1) ;29 开医嘱时间
	s OrderBabyFeeFlag="N" ;30 婴儿费标志
	s OrderLUom=OrderPackUOMRowid ;31 药品单位
	s OrderDocDuration=OrderDuraTionDays ;32 医生站计算的疗程
	s OrderArcItemCat=ArcItmCatDr ;33 医嘱子分类
	s OrderAdmReason=$replace($p(OrdItem,"^",9),$c(10),"") ;34 药品费别
	s OrderCoverMain=$p(OrdItem,"^",23) ;35 是否医保 可能要判断
	s OrderArcimClassification=##class(web.DHCDocOrderCommon).GetArcimClassification(ArcimRowId)
	i OrderArcimClassification="RC" s RCFlag="Y"  e  s RCFlag="N" ;36 中药处方标志
	s ItemCatCYK=$o(^ARC("IC",0,"Code","302",""))
	s ItemCatCYY=$o(^ARC("IC",0,"Code","301",""))
	i ArcItmCatDr=ItemCatCYK s OrderPHCForm=2
	e  i ArcItmCatDr=ItemCatCYY s OrderPHCForm=1  ;37 中药处方类型
	s OrderAllQty=OrderPaQueQty ;38 医嘱总用量
	i OrderUnitDr'="" s OrderQtyALlUomCode =$p(^CT("UOM",OrderUnitDr),"^",1) ;39 医嘱总用量单位编码
	s OrderSkinTest=$p(OrdItem,"^",21) 
	i OrderSkinTest'="Y" s OrderSkinTest="N"  ;40 皮试标志
	s MZMethod="" ;41 
    s JKMethod="" ;42
    ;s LongPriorStr="^S^OMST^OMCQZT^"
    ;s ShortPriorStr="^STAT^PRN^NORM^ONE^OM^OUT^OMLSZT^"
    ;OrderPirorDr
    ;s OrderPirorCode=""
    i OrderPirorDr'="" s JKMethod=$p(^OECPR(OrderPirorDr),"^",1)
    s MasterSeqNo=$p(OrdItem,"^",19)
    s OrderSeqNo=$p(OrdItem,"^",20) ;43 顺序
    
	s FinalStr=OrderCategoryDr_"^"_MedicalFlag_"^"_ArcimCode_"^"_ArcimDesc_"^"_OrderPackQty_"^"_OrderPrice_"^"_OrderSum_"^"_PrescNo_"^"_OrderDepCode
	s FinalStr=FinalStr_"^"_OrderDepDesc_"^"_OrderAddDocCode_"^"_OrderAddDocName_"^"_OrderAddDocLevelDesc_"^"_OutPirorDr_"^"_OrderInstrucCode
	s FinalStr=FinalStr_"^"_OrderPHFreqCode_"^"_OrderDuraTionDays_"^"_OrderDoseQty_"^"_OrderOneDayQty_"^"_OrderFirstQty_"^"_OrderUnitDesc_"^"_DFFalg
	s FinalStr=FinalStr_"^"_OrderFactor_"^"_OrderPaQueQty_"^"_OrderBarCode_"^"_OrderExecDepCode_"^"_OrderExecDepDesc_"^"_OrderDate_"^"_OrderTime
	s FinalStr=FinalStr_"^"_OrderBabyFeeFlag_"^"_OrderLUom_"^"_OrderDocDuration_"^"_OrderArcItemCat_"^"_OrderAdmReason_"^"_OrderCoverMain_"^"_RCFlag
	s FinalStr=FinalStr_"^"_OrderPHCForm_"^"_OrderAllQty_"^"_OrderQtyALlUomCode_"^"_OrderSkinTest_"^"_MZMethod_"^"_JKMethod_"^"_OrderPlain
	;s ^TmpXpc("FinalStr")=FinalStr
	
	q FinalStr
}

ClassMethod UpdateInsuRules(OrderStr As %String, Adm As %String)
{
	s Rtn=0
	Q:OrderStr="" Rtn
	s OrderLen=$L(OrderStr,"^")
	s BeforInsuStr=""
	f i=1:1:OrderLen 
	{
		S OneOrderStr=$P(OrderStr,"^",i)
		s OrderIDGet=$P(OneOrderStr,"*",2)
		Continue:OrderIDGet=""
		s BeforeInsuDr=$p($g(^OEORD(+OrderIDGet,"I",$p(OrderIDGet,"||",2),"BILL")),"^",18)
		if (BeforeInsuDr'=""){
			if (BeforInsuStr=""){
				s BeforInsuStr=BeforeInsuDr_"^"_OrderIDGet
				}else{s BeforInsuStr=BeforInsuStr_"@"_BeforeInsuDr_"^"_OrderIDGet}
			}
	}
	s InsuPut=##class(insuqc.service.dic.ServicePort).SaveHisFeeItms(Adm)
	;更新医保
	if (BeforInsuStr'=""){
		s Insubefore=##class(insuqc.service.dic.ServicePort).UpdateOrderIDs(BeforInsuStr)
		}
	q 0
}

}
