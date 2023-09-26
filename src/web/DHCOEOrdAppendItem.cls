Class web.DHCOEOrdAppendItem Extends DHCDoc.Util.RegisteredObject [ ClassType = "" ]
{

/// creator: 宋春莉
/// date: 2020-07-03
/// desc: 根据医嘱录入需要审核的医嘱项目获取绑定的医嘱列表并重新整合需要插入的串
/// input:	Adm：就诊ID OrdItemStr:医嘱录入需要审核的医嘱项目拼接字符串 
/// 		Loc 录入科室ID
/// 		SessionStr:	websys.js->GetSessionStr\websys_getSessionStr;DHCDoc.Util.RegisteredObject->%SessionStr;部分通过接口传入，可能无完整数据
/// 		BaseParamJson:基本参数列表，可自行扩展
/// 			DisBindTypeList:不需要计算的绑定类型，关键字参照BindSource，逗号分隔
/// output:	包含绑定医嘱的新医嘱录入串
/// w ##class(web.DHCOEOrdAppendItem).GetAppendOrdItemArr($LG(^tempscl("GetAppendOrdItemArr"),1),$LG(^tempscl("GetAppendOrdItemArr"),2),$LG(^tempscl("GetAppendOrdItemArr"),3),$LG(^tempscl("GetAppendOrdItemArr"),4),$LG(^tempscl("GetAppendOrdItemArr"),5),$LG(^tempscl("GetAppendOrdItemArr"),6))
ClassMethod GetAppendOrdItemArr(Adm As %String, OrdItemStr As %String, Loc As %String = "", ByRef OrdAddCongeriesArr, SessionStr As %String = "", BaseParamJson As %String = "{}") As %String
{
	s:Adm=7599 ^tempscl("GetAppendOrdItemArr")=$lb(Adm,OrdItemStr,Loc,"",SessionStr,BaseParamJson)
	if (SessionStr=""){
		s SessionStr=..%SessionStr()
	}
	k OrdAddCongeriesArr
	s UserRowId=$P(SessionStr,"^",1)
	s GroupID=$P(SessionStr,"^",2)
	s:Loc="" Loc=$P(SessionStr,"^",3)
	s HospID=$P(SessionStr,"^",4)
	
	k BaseParamArr
	d ##class(DHCDoc.Util.FromXML).FromJSONToArr(BaseParamJson,.BaseParamArr)
	s DisBindTypeList=$G(BaseParamArr("DisBindTypeList"))
	s MaxOrderSeqNo=0
	Kill OrdCongeriesArr,LabEpisArray
	if '((DisBindTypeList[",BF,")&&(DisBindTypeList[",CT,")&&(DisBindTypeList[",SP,")){
		s OrdItemStr=##Class(web.DHCDocPrescript).CreatOrdNo(Adm,OrdItemStr,SessionStr,.LabEpisArray)
	}
	
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	for i=1:1:OrdItemCount {
		s OrdItem=$p(OrdItemStr,$c(1),i)
		continue:OrdItem=""
		s ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		Set MasterSeqNo=$p(OrdItem,"^",19)
		Set OrderSeqNo=$p(OrdItem,"^",20)
		i OrderSeqNo="" s OrderSeqNo=i
		;s OrdCongeriesArr(OrderSeqNo)=OrdItem
		if MasterSeqNo'="" s OrdCongeriesArr(MasterSeqNo,"sub",OrderSeqNo)=OrdItem
		else  s OrdCongeriesArr(OrderSeqNo)=OrdItem
		s:OrderSeqNo>MaxOrderSeqNo MaxOrderSeqNo=OrderSeqNo
	}
	s OrdCounter="" for {
		s OrdCounter=$O(OrdCongeriesArr(OrdCounter)) Q:(OrdCounter="")
		s ExpStr=OrdCounter_"^"_$LFS(SessionStr,"^")
		;1.获取皮试备注绑定医嘱列表
		if (DisBindTypeList'[",SK,"){
			s OrdActionAppendItem=..GetOrdActionAppendItem(Adm,OrdCounter,.OrdCongeriesArr)
			d ..SetAppendItemDataArr(Adm,OrdActionAppendItem,.OrdCongeriesArr,.OrdAddCongeriesArr,.MaxOrderSeqNo,ExpStr)
		}
		;2.病区绑定医嘱设置
		if (DisBindTypeList'[",WB,"){
			s WardAppendItem=..GetWardAppendItem(Adm,OrdCounter,SessionStr,.OrdCongeriesArr)
			s NewExpStr=ExpStr_"^WB"
			d ..SetAppendItemDataArr(Adm,WardAppendItem,.OrdCongeriesArr,.OrdAddCongeriesArr,.MaxOrderSeqNo,NewExpStr)
		}
		;3.获取用法关联医嘱
		if (DisBindTypeList'[",IS,"){
			s OrdInstrAppendItem=..GetOrdInstrAppendItem(Adm,OrdCounter,SessionStr,.OrdCongeriesArr)
			d ..SetAppendItemDataArr(Adm,OrdInstrAppendItem,.OrdCongeriesArr,.OrdAddCongeriesArr,.MaxOrderSeqNo,ExpStr)
		}
		;4.附加医嘱设定(按子类)
		if (DisBindTypeList'[",IC,"){
			s OrdCatAppendItem=..GetOrdCatAppendItem(Adm,OrdCounter,SessionStr,.OrdCongeriesArr)
			d ..SetAppendItemDataArr(Adm,OrdCatAppendItem,.OrdCongeriesArr,.OrdAddCongeriesArr,.MaxOrderSeqNo,ExpStr)
		}
		;5.附加医嘱设置(按医嘱)
		if (DisBindTypeList'[",IT,"){
			s OrdItemAppendItem=..GetOrdItemAppendItem(Adm,OrdCounter,SessionStr,.OrdCongeriesArr)
			d ..SetAppendItemDataArr(Adm,OrdItemAppendItem,.OrdCongeriesArr,.OrdAddCongeriesArr,.MaxOrderSeqNo,ExpStr)
		}
	}
	;6.检验医嘱绑定
	s LabAppendItemStr=..GetLabOrdItemAppendItem(Adm,SessionStr,.OrdCongeriesArr,.LabEpisArray,.OrdAddCongeriesArr,.MaxOrderSeqNo)
	
	s OrdAddCongeriesJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.OrdAddCongeriesArr)
	Q OrdAddCongeriesJson
}

/// creator: tanjishan
/// date: 2022-09-05
/// desc: 根据草药录入需要审核的医嘱项目获取绑定的医嘱列表并重新整合需要插入的串
/// input:	Adm：就诊ID
/// 		OrdItemStr:待审核的草药信息
/// 		SessionStr:	websys.js->GetSessionStr\websys_getSessionStr;DHCDoc.Util.RegisteredObject->%SessionStr;部分通过接口传入，可能无完整数据
/// output:	包含绑定医嘱的新医嘱录入串
/// w ##class(web.DHCOEOrdAppendItem).GetAppendOrdItemCMArr()
ClassMethod GetAppendOrdItemCMArr(Adm As %String, OrdItemStr As %String, ByRef OrdAddCongeriesArr, SessionStr As %String) As %String
{
	s PrescStr=$p(OrdItemStr,$C(2),1)
	s OrdItemStr=$p(OrdItemStr,$C(2),2)
	if (OrdItemStr=""){
		q PrescStr_$C(2)_OrdItemStr
	}
	s PrOrdItemStr=OrdItemStr		;记录原始待审核医嘱串
	s CurLogonHosp=$P(SessionStr,"^",4)

	s PrescDurRowid=$P(PrescStr,"^",2)
	s PrescCookDecoction=$P(PrescStr,"^",5)
	s PrescWeight=$P(PrescStr,"^",14)
	s CMPrescTypeCode=$P(PrescStr,"^",16)
	s PrescAppenItemQty=$P(PrescStr,"^",18)		//药箅子数
	s PrescCookMode=""
	if (PrescCookDecoction'="") s PrescCookMode=PrescCookDecoction //$P($g(^DHCDocConfig("CookMode",PrescCookDecoction)),"^",2)
	s (OrderSerialNum,CalPrescNo,CalPrescSeqNo)=""
	s CMPrescTypeCode=$P(PrescStr,"^",16)
	//附加费
	s CNMedAppendItem=..%GetConfig1(CMPrescTypeCode,"CNMedAppendItem",CurLogonHosp)
	if (+CNMedAppendItem'=0){
		i '$d(^ARCIM(+CNMedAppendItem,$p(CNMedAppendItem,"||",2),1)) s CNMedAppendItem=""
	}
	if (##class(web.DHCDocOrderEntry).ValARCItem(CNMedAppendItem)){
		s CNMedAppendItem=""
	}
	if (CNMedAppendItem'="")&&(+PrescAppenItemQty>0){
		s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(Adm)
		s CNMedAppendItem=CNMedAppendItem_"^"_PrescAppenItemQty _ "^^^^^^^^^^^^CMPTAM^"_OrderSerialNum_"^"_CalPrescNo_"^"_CalPrescSeqNo
	}
	i CNMedAppendItem'=""  s OrdItemStr=OrdItemStr_$c(1)_CNMedAppendItem

	/*
	//代煎费--已弃用
	s CNMedCookModeFeeItem=..%GetConfig1(CMPrescTypeCode,"CNMedCookModeFeeItem",CurLogonHosp) //$G(^DHCDocConfig(CMPrescTypeCode,"CNMedCookModeFeeItem"))
	if (+CNMedCookModeFeeItem'=0){
		i '$d(^ARCIM(+CNMedCookModeFeeItem,$p(CNMedCookModeFeeItem,"||",2),1)) s CNMedCookModeFeeItem=""
	}
	if (##class(web.DHCDocOrderEntry).ValARCItem(CNMedCookModeFeeItem)){
		s CNMedCookModeFeeItem=""
	}
	if (CNMedCookModeFeeItem'=""){
		s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(Adm)
		s CNMedCookModeFeeItem=CNMedCookModeFeeItem_"^1^^^^^^^^^^^^^"_OrderSerialNum_"^"_CalPrescNo_"^"_CalPrescSeqNo
	}
	i CNMedCookModeFeeItem'=""  s OrdItemStr=OrdItemStr_$c(1)_CNMedCookModeFeeItem
	*/
	///处方剂型关联费用 
	s CMPrescTypeLinkFeeStr=..%GetConfig1(CMPrescTypeCode,"CMPrescTypeLinkFee",CurLogonHosp)
	for i=1:1:$L(CMPrescTypeLinkFeeStr,"^") {
		s CMPrescTypeLinkFee=$P(CMPrescTypeLinkFeeStr,"^",i)
		continue:(CMPrescTypeLinkFee="")
		continue:(##class(web.DHCDocOrderEntry).ValARCItem(CNMedAppendItem))
		s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(Adm)
		s CMPrescTypeLinkItem=CMPrescTypeLinkFee_"^1^^^^^^^^^^^^CMPTAOF^"_OrderSerialNum_"^"_CalPrescNo_"^"_CalPrescSeqNo
		s OrdItemStr=OrdItemStr_$c(1)_CMPrescTypeLinkItem
	}
	
	///附加医嘱绑定
	s CookModeArcim=..GetCookArcim(Adm,PrescCookDecoction,CurLogonHosp)
	i CookModeArcim'=""  s OrdItemStr=OrdItemStr_$c(1)_CookModeArcim
	/// 草药加工方式收费设置
 	s CookPresc=CMPrescTypeCode_"^"_PrescCookDecoction
 	s CookModeCharge=..GetCookModeChargeNew(Adm,CookPresc,PrescWeight,PrescDurRowid,CurLogonHosp)
	i CookModeCharge'=""  s OrdItemStr=OrdItemStr_$c(1)_CookModeCharge
	/// 草药加工方式收费设置--附加费
 	s CookModeAddCharge=..GetCookModeAddCharge(Adm,CookPresc,CurLogonHosp,PrOrdItemStr)
	i CookModeAddCharge'=""  s OrdItemStr=OrdItemStr_$c(1)_CookModeAddCharge
	
	q PrescStr_$C(2)_OrdItemStr
}

/// 草药录入设置->煎药方式->附加医嘱绑定
ClassMethod GetCookArcim(Adm As %String, CookArcRowid As %String, CurLogonHosp As %String) As %String
{
	q:CookArcRowid="" ""
	s HospCodeNode="HospDr_"_CurLogonHosp
	s PrescTypeChargeChargeStr=""
	s subrowid=""
    for {
	    s subrowid=$O(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid))
	    q:subrowid=""
	    s RowID=subrowid
	    s ArcimID=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid),"^",1)
		if (##class(web.DHCDocOrderEntry).ValARCItem(ArcimID)){
			continue
		}
	    s ARCIMDesc=$P($g(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1)),"^",2)
	    s Number=$P(^DHCDocConfig(HospCodeNode,"CookMode",CookArcRowid,"Arc",subrowid),"^",2)
		s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(Adm)
	    s OrderItem=ArcimID_"^"_Number_"^^^^^^^^^^^^CMCMAO^"_OrderSerialNum
		i PrescTypeChargeChargeStr="" s PrescTypeChargeChargeStr=OrderItem
		e  s PrescTypeChargeChargeStr=PrescTypeChargeChargeStr_$c(1)_OrderItem
	}
	q PrescTypeChargeChargeStr
}

/// 草药加工方式附加收费设置
/// w ##class(web.DHCOEOrdAppendItem).GetCookModeAddCharge(15,"CNMedItemCat",2,1_$c(1)_2_$c(1)_3)
ClassMethod GetCookModeAddCharge(AdmID, CMPrescTypeCode, CurLogonHosp, OrdItemStr)
{
	s PrescTypeAddChargeStr=""
	s ^templx("GetCookModeAddCharge")=$lb(AdmID, CMPrescTypeCode, CurLogonHosp, OrdItemStr)
	q:(CMPrescTypeCode="")||(OrdItemStr="") ""
	;待审核的医嘱味数
	s ItemSum=0
	for Len=1:1:$l(OrdItemStr,$c(1)) d
	.s OrdItem=$p(OrdItemStr,$c(1),Len)
	.s ARCIMRowid=$p(OrdItem,"^",1)
	.Q:ARCIMRowid=""
	.s ItemSum=ItemSum+1
	Q:+ItemSum=0 ""
		
	s HospCodeNode="HospDr_"_CurLogonHosp
	s PrescTypeChargeChargeStr=""
	s PrescTypeCode=$p(CMPrescTypeCode,"^",1)
	s PrescCookDecoction=$p(CMPrescTypeCode,"^",2)
	if (PrescCookDecoction'="") {
		s subNodeStr=PrescTypeCode_"^"_PrescCookDecoction_"!"_PrescTypeCode
	}else{
		s subNodeStr=PrescTypeCode
	}
	for subNodeIndex=1:1:$l(subNodeStr,"!") {
		s subNode=$p(subNodeStr,"!",subNodeIndex)
		Continue:subNode=""
		s ArcimRowid=""
		for {
			s ArcimRowid=$o(^DHCDocConfig(HospCodeNode,"PrescTypeAddCharge",subNode,ArcimRowid)) 
			Q:ArcimRowid=""
			Continue:'$d(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2)))
			Continue:##class(web.DHCDocOrderEntry).ValARCItem(ArcimRowid,AdmID)
			s JsonStr=$g(^DHCDocConfig(HospCodeNode,"PrescTypeAddCharge",subNode,ArcimRowid))
			s JsonObj={}.%FromJSON(JsonStr)
			s MinUomDr=JsonObj.MinUomDr
			if (MinUomDr="味"){
				s MinQty=+JsonObj.MinQty					;起始数量
				s MinEqualQty=+JsonObj.MinEqualQty			;起始等效数量
				s MinNeedBind=JsonObj.MinNeedBind			;小于起始需绑定
				s OverQty=+JsonObj.OverQty					;超出数量
				s OverEqualQty=+JsonObj.OverEqualQty		;超出等效数量
				s OverNeedBind=JsonObj.OverNeedBind			;超出不足需绑定
				
				;计算规则参看草药加工方式收费设置下的附加费使用说明
				s NeedOrderQty=0,NMinQty=0,NOverQty=0		;计算等效数量
				s MinQtyDiff=ItemSum-MinQty
				if (MinQtyDiff>=0){
					;超出起始数量
					s NMinQty=+MinEqualQty
					if (OverQty>0)&&(OverEqualQty>0){
						s OverQtyDiff=(MinQtyDiff/OverQty)
						s OverQtyEq=$SYSTEM.SQL.FLOOR(OverQtyDiff)			;向下取整
						if OverNeedBind="Y" d
						.s OverQtyEq=$SYSTEM.SQL.CEILING(OverQtyDiff)		;向上取整
						s NOverQty=OverQtyEq*OverEqualQty
					}
				}else{
					;小于起始数量
					if (MinNeedBind="Y") s NMinQty=+MinEqualQty
				}
				s NeedOrderQty=NMinQty+NOverQty
				Continue:+NeedOrderQty=0
				s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(AdmID)
				s OrderItem=ArcimRowid_"^"_NeedOrderQty_"^^^^^^^^^^^^CMPTCMA^"_OrderSerialNum
				i PrescTypeAddChargeStr="" s PrescTypeAddChargeStr=OrderItem
				e  s PrescTypeAddChargeStr=PrescTypeAddChargeStr_$c(1)_OrderItem
			}
		}
	}
	Q PrescTypeAddChargeStr
}

/// 草药加工方式收费设置
ClassMethod GetCookModeChargeNew(Adm As %String, CMPrescTypeCode As %String, PrescWeight As %String, PrescDurRowid As %String, CurLogonHosp As %String) As %String
{
	q:CMPrescTypeCode="" ""
	s HospCodeNode="HospDr_"_CurLogonHosp
	i PrescDurRowid'="" s PrescDurFactor=$p($g(^PHCDU(PrescDurRowid)),"^",2)
	e  s PrescDurFactor=1
	s OnePrescWeight=PrescWeight/PrescDurFactor //前台PrescWeight乘了疗程,此处验证的是单处方，此处方中数量之和
	s PrescTypeChargeChargeStr=""
	s PrescTypeCode=$p(CMPrescTypeCode,"^",1)
	s PrescCookDecoction=$p(CMPrescTypeCode,"^",2)
	if (PrescCookDecoction'="") {
		s subNodeStr=PrescTypeCode_"^"_PrescCookDecoction_"!"_PrescTypeCode
	}else{
		s subNodeStr=PrescTypeCode
	}
	for subNodeIndex=1:1:$l(subNodeStr,"!") {
		s subNode=$p(subNodeStr,"!",subNodeIndex)
		s CookModePrescBound=##class(web.DHCDocOrderEntryCM).GetPrescBound(subNode,CurLogonHosp)
		continue:CookModePrescBound=""
		s UomRowid=$p(CookModePrescBound,"^",1)
		s PrescQtyStt=$p(CookModePrescBound,"^",2)
		s PrescQtyEnd=$p(CookModePrescBound,"^",3)
		s CalUomType=##class(DHCDoc.DHCDocConfig.CookModeCharge).GetCalUomType(UomRowid)
		if (CalUomType="WeightUom"){
			s BaseUomRowId=##class(DHCDoc.DHCDocConfig.CookModeCharge).GetCMBaseUomRowId("WeightUom",CurLogonHosp)
			s convqty=$$ConvFac^ST02(UomRowid,BaseUomRowId),convqty=$p(convqty,$c(1),1)
			if (convqty="") s convqty=1
			if (PrescQtyStt'="") s PrescQtyStt=PrescQtyStt*convqty
			if (PrescQtyEnd'="") s PrescQtyEnd=PrescQtyEnd*convqty
			continue:((OnePrescWeight<PrescQtyStt)&&(PrescQtyStt'=""))||((OnePrescWeight>PrescQtyEnd)&&(PrescQtyEnd'=""))
		}else{
			s BaseUomRowId=##class(DHCDoc.DHCDocConfig.CookModeCharge).GetCMBaseUomRowId("DurUom",CurLogonHosp)
			s convqty=$$ConvFac^ST02(UomRowid,BaseUomRowId),convqty=$p(convqty,$c(1),1)
			if (convqty="") s convqty=1
			if (PrescQtyStt'="") s PrescQtyStt=PrescQtyStt*convqty
			if (PrescQtyEnd'="") s PrescQtyEnd=PrescQtyEnd*convqty
			continue:((PrescDurFactor<PrescQtyStt)&&(PrescQtyStt'=""))||((PrescDurFactor>PrescQtyEnd)&&(PrescQtyEnd'=""))
		}
		s ArcimRowid=0
		for {
			s ArcimRowid=$o(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",subNode,ArcimRowid)) q:ArcimRowid=""
			continue:'$d(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2)))
			s DataStr=$g(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",subNode,ArcimRowid))
			s Qty=$p(DataStr,"!",1)
			s ChargeUOMRowid=$p(DataStr,"!",2)
			s ChargeUOM=$ZCVT($p($g(^CT("UOM",ChargeUOMRowid)),"^",1),"U")
			s MinQty=$p(DataStr,"!",3)
			s EqualQty=$p(DataStr,"!",4)
			if (EqualQty="") s EqualQty=1
			s CalUomType=##class(DHCDoc.DHCDocConfig.CookModeCharge).GetCalUomType(ChargeUOMRowid)
			if (CalUomType="DurUom"){
				s BaseUomRowId=$o(^CT("UOM",0,"Desc","付",""))
				s convqty=$$ConvFac^ST02(ChargeUOMRowid,BaseUomRowId),convqty=$p(convqty,$c(1),1)
				if (convqty="") s convqty=1
				s OrderQty=(PrescDurFactor/(Qty*convqty))*EqualQty
			}else{
				s BaseUomRowId=$o(^CT("UOM",0,"Desc","G",""))
				s convqty=$$ConvFac^ST02(ChargeUOMRowid,BaseUomRowId),convqty=$p(convqty,$c(1),1)
				if (convqty="") s convqty=1
				s OrderQty=(OnePrescWeight*PrescDurFactor/(Qty*convqty))*EqualQty
			}
			//向上取整
			s OrderQty=OrderQty\1+$s(OrderQty#1:1,1:0)
			continue:(OrderQty<MinQty)&&(MinQty'="")
			s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(Adm)
			s OrderItem=ArcimRowid_"^"_OrderQty_"^^^^^^^^^^^^CMPTCMA^"_OrderSerialNum
			i PrescTypeChargeChargeStr="" s PrescTypeChargeChargeStr=OrderItem
			e  s PrescTypeChargeChargeStr=PrescTypeChargeChargeStr_$c(1)_OrderItem
		}
	}
	q PrescTypeChargeChargeStr
	/*s ArcimRowid=0
	f  s ArcimRowid=$o(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",CMPrescTypeCode,ArcimRowid)) q:ArcimRowid=""  d
	.q:'$d(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2)))
	.s Qty=$p($g(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",CMPrescTypeCode,ArcimRowid)),"!",1)
	.s ChargeUOMRowid=$p($g(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",CMPrescTypeCode,ArcimRowid)),"!",2)
	.s FlagDownFare=$p($g(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",CMPrescTypeCode,ArcimRowid)),"!",3)
	.i ChargeUOMRowid'=""  d
	..s ChargeUOM=$p($g(^CT("UOM",ChargeUOMRowid)),"^",2)
	..i PrescDurRowid'="" s PrescDurFactor=$p($g(^PHCDU(PrescDurRowid)),"^",2)
	..e  s PrescDurFactor=1
	..i (ChargeUOM["付")&&(ChargeUOM'="付")  d
	...s PeriodFactor=$p(ChargeUOM,"付")
	...s PeriodDesc=PeriodFactor_"付"
	...s PeriodQty=$case(((PrescDurFactor/PeriodFactor)-(PrescDurFactor\PeriodFactor))>0,1:(PrescDurFactor\PeriodFactor)+1,:(PrescDurFactor\PeriodFactor))
	..e  d
	...s PeriodDesc=""
	...s PeriodQty=1
	..s PrescQty=$case(ChargeUOM,"100g":PrescWeight/100,"200g":PrescWeight/200,"g":PrescWeight,"付":PrescDurFactor,PeriodDesc:PeriodQty,"每处方":1,:1)
	..s OrderQty=$fn(PrescQty*Qty,"",0)
	..i OrderQty<FlagDownFare s OrderQty=FlagDownFare
	.e  d
	..s OrderQty=Qty
	.s OrderItem=ArcimRowid_"^"_OrderQty_"^^^^^^^^^^^^CMPTCMA"
	.i PrescTypeChargeChargeStr="" s PrescTypeChargeChargeStr=OrderItem
	.e  s PrescTypeChargeChargeStr=PrescTypeChargeChargeStr_$c(1)_OrderItem*/
}

ClassMethod SetAppendItemDataArr(Adm As %String, AppendItemStr As %String, ByRef OrdCongeriesArr, ByRef OrdAddCongeriesArr, ByRef MaxOrderSeqNo, ExpStr As %String) As %String
{
	Q:AppendItemStr="" ""
	s PatientID=$P(^PAADM(Adm),"^",1)
	s AdmDepId=$P($G(^PAADM(Adm)),"^",4)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s OEORDRowId=$o(^OEORD(0,"Adm",Adm,""))
	s OrderSeqNo=$p(ExpStr,"^",1)
	s SessionStr=$LTS($p(ExpStr,"^",2),"^")
	
	s UserRowId=$P(SessionStr,"^",1)
	s GROUPID=$P(SessionStr,"^",2)
	s Loc=$P(SessionStr,"^",3)

	s BindSource=$p(ExpStr,"^",3)
	s OrdItem=$G(OrdCongeriesArr(OrderSeqNo))
	s MasterSeqNo=$p(OrdItem,"^",19)
	if (MasterSeqNo="") s MasterSeqNo=OrderSeqNo
	s MasterDepProcNotes=$p(OrdItem,"^",11)
	s OrderLocalInfusionQty=$p(OrdItem,"^",52)
	s OrderFreqWeekStr=$p(OrdItem,"^",67)
	s AppendOrdItemStr=""
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	s SelectInstrNotDrugCat=..%GetConfig("SelectInstrNotDrugCat",HospitalId)
	;禁用配液用法
	s ForbidDosingInstr=""
	if (Loc'=""){
		s ForbidDosing=$P($G(^CTLOC(Loc,"DHC")),"^",18)
		i (ForbidDosing="1"){
			if (AdmType="I"){
				s ForbidDosingInstr=..%GetConfig("IPDosingInstr",HospitalId)
			}elseif (AdmType="O"){
				s ForbidDosingInstr=..%GetConfig("OPInfusionInstr",HospitalId)
			}
		}
	}
	for i=1:1:$L(AppendItemStr,"^") {
		s MaxOrderSeqNo=MaxOrderSeqNo+1
		s AddItem=$P(AppendItemStr,"^",i)
		s ARCIMRowid=$P(AddItem,$c(1),1)
		s ReplaceArcimRowId=##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).GetReplaceItm(Adm,ARCIMRowid)
		if (ReplaceArcimRowId'="") s ARCIMRowid=ReplaceArcimRowId
		if (..CheckItemAgeSexRestriction(Adm,ARCIMRowid)=1) continue
		;权限控制
		s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GROUPID,ARCIMRowid,"",AdmDepId,UserRowId,Loc,"","",PatientID)
		if (OrderAuthInValid=0) continue
		;已经停止项目过滤
		continue:##class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
		;按就诊类型过滤
		s Restrict=##class(web.DHCDocOrderCommon).CheckArcimType(ARCIMRowid,"",AdmType)
		continue:Restrict'=""
		s AddQty=$P(AddItem,$c(1),2)
		s AddRecLocId=$P(AddItem,$c(1),3)
		s AddInstrId=$P(AddItem,$c(1),4)
		s OrderOpenForAllHosp=$P(AddItem,$c(1),5)
		s ByDay=$P(AddItem,$c(1),6)
		s DoseQty=$P(AddItem,$c(1),7)
		s DoseUOMRowid=$P(AddItem,$c(1),8)
		s DefaultSpecRowid=$P(AddItem,$c(1),9)
		s AddBindSource=$P(AddItem,$c(1),10)
		if (AddBindSource'="") s BindSource=AddBindSource
		s InstrRecLocID=$P(AddItem,$c(1),11)	;用法绑定医嘱默认接收科室
		s LabEpisodeNoStr=$P(AddItem,$c(1),12)	;检验附加医嘱关联的标本号
		;是否根据绑定来源医嘱的基本单位数量进行计算
		s CalByBindOrdQty=$P(AddItem,$c(1),13)	
		s BindSourceSeqNo=$P(AddItem,$c(1),14)		;绑定来源的SeqNo，成组医嘱类似2.1描述
		s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		
		if (BindSourceSeqNo["."){
			s BindSourceItem=$G(OrdCongeriesArr(+$P(BindSourceSeqNo,"."),"sub",+$P(BindSourceSeqNo,".",2)))
		}else{
			s BindSourceItem=$G(OrdCongeriesArr(+BindSourceSeqNo))
		}
		//这里重置绑定源医嘱，应该没有问题
		if (BindSourceItem'=""){
			s OrdItem=BindSourceItem
		}
		Set BindArcim=$p(OrdItem,"^",1)
		Set BindOrderType=$p(OrdItem,"^",2)	
		Set BindPriorRowid=$p(OrdItem,"^",3)
		Set BindPackQty=$p(OrdItem,"^",6)
		Set BindDoseQty=$p(OrdItem,"^",12)
		Set BindDoseUOMRowid=$p(OrdItem,"^",13)
		Set BindDoseQtySum=$p(OrdItem,"^",14)
		Set FreqRowid=$p(OrdItem,"^",15)
		Set BindOrderPackUOMRowid=$p(OrdItem,"^",55)
		s drgform=$p($g(^ARCIM(+BindArcim,+$p(BindArcim,"||",2),1)),"^",12)
		if (CalByBindOrdQty="Y"){
			//计算来源医嘱的基本单位数量
			i BindOrderType="R"{
				i BindPackQty="" {
					s dispqty=$$calcqty^DHCOEOrdItem(drgform,BindDoseUOMRowid,BindDoseQty,AdmType)
				}else{
					s convFac=##class(appcom.OEDispensing).convFac(BindArcim,BindOrderPackUOMRowid)
					s dispqty=BindPackQty*convFac
				}
			}else{
				i BindDoseQtySum="" s BindDoseQtySum=1
				i ##class(appcom.OEOrdItem).ISShortOrderPrior(BindPriorRowid)||(FreqRowid="") {
					;基本单位和计价单位不一致需要将数量从计价单位换算为基本单位
					s convFac=##class(appcom.OEDispensing).convFac(BindArcim,BindOrderPackUOMRowid)
					i convFac="" s convFac=1
					s dispqty=BindDoseQtySum*convFac
				}else{
					s dispqty=BindDoseQty
				}
			}
			i $G(dispqty)="" s dispqty=1
			s:(AddQty>0) AddQty=$FN(AddQty*dispqty,"N")
			;s:(DoseQty>0) DoseQty=DoseQty*dispqty
			;Wqy 单次剂量按绑定医嘱的单次剂量来算
			if DoseQty>0{
				s BindDispqty=$$calcqty^DHCOEOrdItem(drgform,BindDoseUOMRowid,BindDoseQty,AdmType)
				s:+BindDispqty=0 BindDispqty=1
				s DoseQty=$FN(DoseQty*BindDispqty,"N")
			}
		}
		s PriorRowid=..GetAppendItemPrior(OrderType,BindPriorRowid)
		s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		s startdate=$p(OrdItem,"^",4)
		s starttime=$p(OrdItem,"^",5)
		s AdmReason=$p(OrdItem,"^",9)
		s FirstDayTimes=$p(OrdItem,"^",33)
		;检验/检查不允许绑定为长期
		s OrderVirtualtLong=$p(OrdItem,"^",79)
		s OrderFillterNo=$p(OrdItem,"^",80)
		if (OrderFillterNo'="")&&(OrderVirtualtLong'="Y") s OrderVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetVirtualtLongFlag(OrderFillterNo)
		
		s IsExamItemFlag=##Class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowid)
		if (((OrderType="L")||(IsExamItemFlag=1))&&((LongPriorFlag=1)||(OrderVirtualtLong="Y"))){
			continue
		}
		;20220128 WangQingyong 判断医嘱类型是否合法
		s ret=##Class(web.DHCOEOrdItem).CheckPriorAllow(Adm,PriorRowid,ARCIMRowid,Loc,FreqRowid)
		continue:$P(ret,"^",1)'=0
		/*if (IsExamItemFlag=1){
			continue
		}*/
		s ChronicDiagCode=$p(OrdItem,"^",82)
		/*
  		if (ChronicDiagCode'="") {
	  		s OrderCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	  		s ChronicOrdStartDt=..%ZDH(startdate)
	  		if ('##class(insuqc.service.chronic.ServicePort).ISChronicOrdItm(Adm,ChronicDiagCode,OrderCode,$ZD(ChronicOrdStartDt,3),AdmReason)) continue 
	  	}*/
	  	if ((OrderType="R")||(("^"_SelectInstrNotDrugCat_"^")[("^"_ItemCatDR_"^"))){
			if AddInstrId'="" {
				;皮试用法
				s SkinTestInstr=..%GetConfig("SkinTestInstr",HospitalId)
				if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
				;按照默认皮试及皮试备注审核,不允许单独修改(完全按照皮试引导录入)
				s DisableOrdSkinChange=..%GetConfig("DisableOrdSkinChange",HospitalId)
				s AddPHCINClinicType=$p(^PHCIN(AddInstrId),"^",5)
				if (AddPHCINClinicType'="")&&(AddPHCINClinicType'[AdmType) s InstrRowid=$p(OrdItem,"^",17)
				else  if (ForbidDosingInstr'="")&&(("^"_ForbidDosingInstr_"^")[("^"_AddInstrId_"^")) s InstrRowid=$p(OrdItem,"^",17)
				else  if (SkinTestInstr'="")&&(SkinTestInstr[("^"_AddInstrId_"^"))&&(DisableOrdSkinChange=1) s InstrRowid=$p(OrdItem,"^",17)
				else  s InstrRowid=AddInstrId
			}else {
				s InstrRowid=$p(OrdItem,"^",17)
			}
		}else{
			s InstrRowid=""
		}
		if AddRecLocId'="" {
			s RecDepRowid=AddRecLocId
		}else{
			s RecDepRowid=..GetAppendItemRecLoc(Adm,ARCIMRowid,SessionStr,PriorRowid,InstrRowid,OrderOpenForAllHosp,InstrRecLocID)
		}
		;没有维护接受科室默认为患者所在科室
		s admloc=$P($G(^PAADM(Adm)),"^",4)
		s:RecDepRowid="" RecDepRowid=admloc
		if (OrderVirtualtLong="Y")&&(OrderType="R") {
			///临时医嘱拆分整包装发药
    		s NormSplitPackQty=##Class(web.DHCDocOrderVirtualLong).GetNormSplitPackQtyFlag(Adm,RecDepRowid,ItemCatDR)
			s AddQty=""
			if (NormSplitPackQty=0){
				if PriorRowid=+$O(^OECPR(0,"Code","NORM",0)) s PriorRowid=$O(^OECPR(0,"Code","OMLSZT",0))
			}
		}
		s BindSourceStr=""
		if (BindSource="SP")||(BindSource="BF") {
			;检验绑定医嘱为独立医嘱
			s AppendMasterSeqNo=""
		}else{
			if ByDay=1 {
				s BindSourceStr=$p(OrdItem,"^",87)
				;验证已审核医嘱是否已按天绑定
				s NotInsertOrdStr=$$GetInstrNotInsertOrdStr(RecDepRowid,InstrRowid,ARCIMRowid,OEORDRowId,startdate,Loc)
				if NotInsertOrdStr'="" {
					;如果找到了已绑定的费用医嘱，把当前的医嘱流水号更新进去
					for k=1:1:$Length(NotInsertOrdStr,"^") {
						s NotInsertOrd=$P(NotInsertOrdStr,"^",k)
						continue:(NotInsertOrd="")
						s NotInsertOrdBindSourceStr=$P($G(^OEORD(+NotInsertOrd,"I",$P(NotInsertOrd,"||",2),"DHC")),"^",76)
						if (NotInsertOrdBindSourceStr[BindSourceStr) continue
						if (NotInsertOrdBindSourceStr=""){
							s NotInsertOrdBindSourceStr=BindSourceStr
						}else{
							s NotInsertOrdBindSourceStr=NotInsertOrdBindSourceStr_"@"_BindSourceStr
						}
						&SQL(UPDATE SQLUser.OE_OrdItemExt SET OEORI_BindSourceSerialNumStr =:NotInsertOrdBindSourceStr WHERE OEORI_RowId =:NotInsertOrd)
					}
					continue
				}
				;验证本次未审核医嘱是否存在相同用法、日期、开单科室的医嘱
				s IsNotInsertFlag=..GetInstrNotInsertFlag(OrderSeqNo,$p(OrdItem,"^",17),startdate,.OrdCongeriesArr,.OrdAddCongeriesArr)
				if IsNotInsertFlag=1 continue
				s STFreqRowid=$O(^PHCFR(0,"Code","ONCE",0))
				if (LongPriorFlag=1)||(OrderVirtualtLong="Y"){
					s QdFreqRowid=$O(^PHCFR(0,"Desc1","QD",0))
					if (QdFreqRowid'=FreqRowid) s FirstDayTimes=1
					s FreqRowid=QdFreqRowid
				}else{
					s StFreqRowid=$O(^PHCFR(0,"Desc1","ST",0))
					if (StFreqRowid'=FreqRowid) s FirstDayTimes=""
					s FreqRowid=StFreqRowid
				}
				s AppendMasterSeqNo=""
			}else{
				s AppendMasterSeqNo=MasterSeqNo
			}
		}
		if (OrderType="R")&&(FreqRowid=""){
			if (LongPriorFlag=1)||(OrderVirtualtLong="Y"){
				s FreqRowid=$O(^PHCFR(0,"Desc1","QD",0))
			}else{
				s FreqRowid=$O(^PHCFR(0,"Code","ONCE",0))
			}
		}
		s oeprice=..GetAppendItemPrice(Adm,ARCIMRowid,RecDepRowid,AdmReason)
		s DrugFormRowid=""
		s DurRowid=$p(OrdItem,"^",16)
		if (+DurRowid'=0) {
			s DurFactor=$P($g(^PHCDU(DurRowid)),"^",2)
		}else{
			s DurFactor=1
			&SQL(SELECT PHCDU_RowId INTO :DurRowid FROM SQLUser.PHC_Duration WHERE PHCDU_Factor=:DurFactor AND PHCDU_Desc2<>'饮片')
		}
		s DepProcNotes=""
		s LimitDays=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),9)),"^",31)
		if (LimitDays'="")&&(LimitDays'=0)&&(DurFactor > LimitDays) {
			s DepProcNotes=MasterDepProcNotes
		}
		s PHPrescType=""
		s SkinTest=""
		s PhSpecInstr=""
		s OrderCoverMainIns=$p(OrdItem,"^",23)
		s ActionRowid=""
		s ARCOSRowid=""
		s EndDate=$p(OrdItem,"^",26)
		s EndTime=$p(OrdItem,"^",27)
		if EndDate'="" s EndDate=..%ZDH(EndDate)
	    if EndTime'="" s EndTime=..%ZTH(EndTime)
	    s DefaultSpecCSiteRowid="" //默认采集部位
	    if (OrderType="L") {
		    s OrderLabSpec=##class(web.DHCDocOrderCommon).GetLabSpec(ARCIMRowid,HospitalId)
		    if (OrderLabSpec '= "") {
			    s tmpDefaultSpecRowid=""
		        for k=1:1:$L(OrderLabSpec,$C(2)){
		            s ArrData=$p(OrderLabSpec,$C(2),k)
		            if (DefaultSpecRowid'="")&&($P(ArrData,$C(3),1)=DefaultSpecRowid) {
			            Q
			        }
	                if ($P(ArrData,$C(3),5)= "Y"){
		                s tmpDefaultSpecRowid = $P(ArrData,$C(3),1)
		                Q
		            }
	            }
		        if (DefaultSpecRowid=""){
			        if (tmpDefaultSpecRowid'="") s DefaultSpecRowid=tmpDefaultSpecRowid
			    	e  s DefaultSpecRowid=$p($p(OrderLabSpec,$C(2),1),$C(3),1)
			    }
			    if (DefaultSpecRowid'="") {
				    s excode=##class(web.DHCDocOrderCommon).GetExCode(ARCIMRowid)
				    s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(HospitalId)
				    s OrderLabSpecCollectionSiteStr=##Class(DHCLIS.DHCCommon).GetTestSetSpecimenSite(excode,DefaultSpecRowid,HospitalCode)
				    if (OrderLabSpecCollectionSiteStr'="") {
					    s DefaultSpecCSiteStr=$p(OrderLabSpecCollectionSiteStr,$C(3),1)
					    s DefaultSpecCSiteRowid=$p(DefaultSpecCSiteStr,$C(2),1)
					}
				}
		    }
		}
		s ExecuteDateStr=""
		s NotifyClinician=""
		s DIACatRowId=""
		s InsurCatRowId=""	
		if (AdmType="I") {
			if (OrderType="R") {
				if (LongPriorFlag) {
					s DoseQty=DoseQty
					s PackQty=""
				}else {
					if (+AddQty=0){
						s PackQty=1
					}else{
						;s PackQty=$$CalcuQty^DHCDocOrderCommonNew(FreqRowid,DurRowid,startdate,FirstDayTimes,OrderFreqWeekStr)
						s CalPackObj={}
						s CalPackObj.EpisodeID=Adm
						s CalPackObj.OrderPriorRowid=PriorRowid
						s CalPackObj.OrderARCIMRowid=ARCIMRowid
						s CalPackObj.OrderFreqRowid=FreqRowid
						s CalPackObj.OrderDurRowid=DurRowid
						s CalPackObj.OrderStartDate=startdate_" "_starttime
						s CalPackObj.OrderFirstDayTimes=FirstDayTimes
						s CalPackObj.OrderFreqDispTimeStr=OrderFreqWeekStr
						s CalPackObj.SessionStr=SessionStr
						s retObj={}.%FromJSON(##Class(web.DHCOEOrdItemView).CalPackQty(CalPackObj.%ToJSON()))
						s PackQty=retObj.OrderPackQty
					}
				}
			}else{
				if (+AddQty=0){
					s PackQty=1
				}else{
					s PackQty=AddQty
					if (LongPriorFlag){
						s DoseQty=AddQty
						s PackQty=""
					}
				}
			}
			Set DoseQtySum=PackQty
		}else{
			;按用法绑定
			if (BindSource="IS") {
				;s PackQty=$$CalcuQty^DHCDocOrderCommonNew(FreqRowid,DurRowid,..%ZDH(startdate),FirstDayTimes,OrderFreqWeekStr)
				s CalPackObj={}
				s CalPackObj.EpisodeID=Adm
				s CalPackObj.OrderPriorRowid=PriorRowid
				s CalPackObj.OrderARCIMRowid=ARCIMRowid
				s CalPackObj.OrderFreqRowid=FreqRowid
				s CalPackObj.OrderDurRowid=DurRowid
				s CalPackObj.OrderStartDate=startdate_" "_starttime
				s CalPackObj.OrderFirstDayTimes=FirstDayTimes
				s CalPackObj.OrderFreqDispTimeStr=OrderFreqWeekStr
				s CalPackObj.SessionStr=SessionStr
				s retObj={}.%FromJSON(##Class(web.DHCOEOrdItemView).CalPackQty(CalPackObj.%ToJSON()))
				s PackQty=retObj.OrderPackQty
				if (+PackQty>OrderLocalInfusionQty)&(OrderLocalInfusionQty'="") {
					;本院输液次数为0,则不产生医嘱
					Continue:OrderLocalInfusionQty=0
					Set DoseQtySum=OrderLocalInfusionQty
					Set PackQty=OrderLocalInfusionQty
				}else {
					if (+AddQty'=0){
						Set PackQty=AddQty
					}
					Set DoseQtySum=PackQty
				}
			}else{
				s PackQty=AddQty
				s DoseQtySum=AddQty
			}
		}
		s SpeedFlowRate="",OrderFlowRateUnit=""
		;滴速用法
		s DrippingSpeedInstr=..%GetConfig("DrippingSpeedInstr",HospitalId)
		if ((OrderType="R")&&(InstrRowid'="")&&(("^"_DrippingSpeedInstr_"^")[("^"_InstrRowid_"^"))) {
			s SpeedFlowRate=$p(OrdItem,"^",36)
			s OrderFlowRateUnit=$p(OrdItem,"^",45)
		}
		//绑定的医嘱暂时统一按照门诊发药单位为准，一是维护便捷，二是防止预住院转门诊后医嘱单位变化的问题
		s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,"O")
		s AppendOrdItem=ARCIMRowid_"^"_OrderType_"^"_PriorRowid_"^"_startdate_"^"_starttime_"^"_PackQty_"^"_oeprice //1-7
		s AppendOrdItem=AppendOrdItem_"^"_RecDepRowid_"^"_AdmReason_"^"_DrugFormRowid_"^"_DepProcNotes //8-11
		s AppendOrdItem=AppendOrdItem_"^"_DoseQty_"^"_DoseUOMRowid_"^"_DoseQtySum_"^"_FreqRowid_"^"_DurRowid_"^"_InstrRowid //12-17
		s AppendOrdItem=AppendOrdItem_"^"_PHPrescType_"^"_AppendMasterSeqNo_"^"_MaxOrderSeqNo_"^"_SkinTest_"^"_PhSpecInstr_"^"_OrderCoverMainIns //18-23
		s AppendOrdItem=AppendOrdItem_"^"_ActionRowid_"^"_ARCOSRowid //24-25
		s $p(AppendOrdItem,"^",26)=EndDate
  		s $p(AppendOrdItem,"^",27)=EndTime
		s $p(AppendOrdItem,"^",28)=DefaultSpecRowid
		s $p(AppendOrdItem,"^",33)=FirstDayTimes ;FirstDayTimes
		s $p(AppendOrdItem,"^",35)=$p(OrdItem,"^",35) ;OrderStageCode
		s $p(AppendOrdItem,"^",36)=SpeedFlowRate
		s $p(AppendOrdItem,"^",37)=$p(OrdItem,"^",37) ;AnaesthesiaID
		s $P(AppendOrdItem,"^",45)=OrderFlowRateUnit
		s $P(AppendOrdItem,"^",46)=$p(OrdItem,"^",46) ;OrderDate
		s $P(AppendOrdItem,"^",47)=$p(OrdItem,"^",47) ;OrderTime
		if (OrderType="R") {
			s $p(AppendOrdItem,"^",54)=$p(OrdItem,"^",54) ;ExceedReasonID
		}
		s $p(AppendOrdItem,"^",55)=OrderPackUOMRowid
  		s $p(AppendOrdItem,"^",56)=$p(OrdItem,"^",56) ;PilotProRowId
  		s $P(AppendOrdItem,"^",58)=BindSource
  		s $p(AppendOrdItem,"^",61)=$p(OrdItem,"^",61) ;OperationCode
  		s $P(AppendOrdItem,"^",66)=$p(OrdItem,"^",66) ;RowIndex
  		s $P(AppendOrdItem,"^",67)=$p(OrdItem,"^",67) ;OrderFreqWeekStr
  		s $P(AppendOrdItem,"^",68)=$case(OrderOpenForAllHosp,1:"Y",:"N")
  		s $P(AppendOrdItem,"^",71)=$p(OrdItem,"^",71)
  		s $P(AppendOrdItem,"^",73)=$p(OrdItem,"^",73) ;AntCVID
  		s $p(AppendOrdItem,"^",78)=$p(OrdItem,"^",78)
  		s $p(AppendOrdItem,"^",79)=$p(OrdItem,"^",79)	;虚拟长期标识
  		s $p(AppendOrdItem,"^",81)=$p(OrdItem,"^",81)	;OEORI_EmConsultItm
		s $p(AppendOrdItem,"^",82)=ChronicDiagCode
		s $p(AppendOrdItem,"^",83)=$p(OrdItem,"^",83)	;OEORI_FreqFreeTimeStr
		s $p(AppendOrdItem,"^",84)=DefaultSpecCSiteRowid
		s $p(AppendOrdItem,"^",87)=##class(web.DHCDocPrescript).GetOrderSerialNum(Adm)
		s $p(AppendOrdItem,"^",90)=LabEpisodeNoStr		;OEORI_LabEpisodeNoStr
		s $p(AppendOrdItem,"^",91)=BindSourceStr		;OEORI_BindSourceStr
		s $p(AppendOrdItem,"^",92)=$p(OrdItem,"^",92)	;OrderOpenForAllHosp
		s $p(AppendOrdItem,"^",93)=""					;OrderMedHLYYInfo
		s $p(AppendOrdItem,"^",94)=$p(OrdItem,"^",94)	;TransType
		s $p(AppendOrdItem,"^",95)=""					;PrescAuditFlag
		s $p(AppendOrdItem,"^",96)=""					;InsuRulesID
		
		k ItemOrdsArr
		s ItemOrdsArr("OrdListInfo")=AppendOrdItem
		s j=1+$O(OrdAddCongeriesArr(""),-1)
		m OrdAddCongeriesArr(j)=ItemOrdsArr
	}
	Q
GetInstrNotInsertOrdStr(RecDepRowid,InstrRowId,ARCIMRowid,ord,startdate,Loc)
	Q:ARCIMRowid="" 0
	s startdate=$$zdhFormat^DHCDocOrderCommonNew(startdate)
	s NotInsertOrdStr=""
	s itm=0
	for {
		s itm=$O(^OEORDi(0,"ARCIM",ord,ARCIMRowid,startdate,itm))
		Q:itm=""
		s stat=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		i stat s stat=$p($g(^OEC("OSTAT",stat)),"^")
        s LinkOrderRowid=$p($g(^OEORD(ord,"I",itm,11)),"^",39)
        s CurRecDepRowid=$p($g(^OEORD(ord,"I",itm,3)),"^",6)  ;接收科室
	    s CurUserDepRowid=$p($g(^OEORD(ord,"I",itm,7)),"^",2) ;开单科室
		/*
		if LinkOrderRowid'="" {
			s LinkOrderInstrRowid=$p($g(^OEORD(+LinkOrderRowid,"I",$p(LinkOrderRowid,"||",2),2)),"^",7)
			;s LinkOrderRecDepRowid=$p($g(^OEORD(+LinkOrderRowid,"I",$p(LinkOrderRowid,"||",2),3)),"^",6)  ;接收科室
			;s LinkOrderUserDepRowid=$p($g(^OEORD(+LinkOrderRowid,"I",$p(LinkOrderRowid,"||",2),7)),"^",2) ;开单科室
			if (LinkOrderInstrRowid=InstrRowId)&(Loc=CurUserDepRowid)&(stat="V") s myflag=1
		}
		*/
		s CurOrderInstrRowid=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
		if (CurOrderInstrRowid=InstrRowId)&&(Loc=CurUserDepRowid)&&(stat="V") {
			if (NotInsertOrdStr=""){
				s NotInsertOrdStr=ord_"||"_itm
			}else{
				s NotInsertOrdStr=NotInsertOrdStr_"^"_ord_"||"_itm
			}
		}
	}
	/*
	s Date=0
	for {
		s Date=$O(^OEORDi(0,"ARCIM",ord,ARCIMRowid,Date))
		Q:(Date="")||(myflag=1)
		s itm=0
		for {
			s itm=$O(^OEORDi(0,"ARCIM",ord,ARCIMRowid,Date,itm))
			Q:(itm="")||(myflag=1)
			s stat=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
			i stat s stat=$p($g(^OEC("OSTAT",stat)),"^")
			continue:(stat="U")
	        s LinkOrderRowid=$p($g(^OEORD(ord,"I",itm,11)),"^",39)
	        s CurRecDepRowid=$p($g(^OEORD(ord,"I",itm,3)),"^",6)  ;接收科室
		    s CurUserDepRowid=$p($g(^OEORD(ord,"I",itm,7)),"^",2) ;开单科室
		    
		    s ExSub=0
		    for {
				s ExSub=$O(^OEORDi(0,"OrdItem",ord,itm,startdate,ExSub))
				q:(ExSub="")||(myflag=1)
				s StatusCode=""
				s StatusRowId=$P(^OEORD(ord,"I",itm,"X",ExSub),"^",16)
				if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
				if ("CF"[StatusCode){
					s myflag=1
				}
			}
		   
		}
	}
	*/
	
	Q NotInsertOrdStr
}

ClassMethod GetWardAppendItem(Adm As %String, MasterSeqNo As %String, SessionStr As %String, ByRef OrdCongeriesArr) As %String
{
	s AppendItemStr=""
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	Q:AdmType'="I" ""
	s OrdItem=$G(OrdCongeriesArr(MasterSeqNo))
	Q:OrdItem="" ""
	s Loc=$P(SessionStr,"^",3)
	s ARCIMRowid=$p(OrdItem,"^",1)
	s PriorRowid=$p(OrdItem,"^",3)
	s InstrRowId=$p(OrdItem,"^",17)
	s OrdMasterSeqNo=$p(OrdItem,"^",19)
	Q:OrdMasterSeqNo'="" ""
	s OrderOpenForAllHosp=$p(OrdItem,"^",68)
	s OutPriorRowid=+$O(^OECPR(0,"Code","OUT",0))
	s OnePriorRowid=+$O(^OECPR(0,"Code","ONE",0))
	Q:(PriorRowid=OnePriorRowid)||(PriorRowid=OutPriorRowid) ""
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	s ArcimWardInfo=""
	s PriorList("A",ARCIMRowid,PriorRowid)=""
	s PriorList("I",+InstrRowId,PriorRowid)=""
	s ArcimList=ARCIMRowid
	;判断登陆科室是否患者就诊科室及就诊科室的linklocation中的科室
 	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(Loc,Adm)
 	if (LoginAdmLocFlag="Y"){
		;是否成组医嘱标识
	 	s GroupFlag=0
		s SubSeqNo=0
		for {
			s SubSeqNo=$o(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo)) Q:SubSeqNo=""
			s subOrdItem=$G(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo))
			s subBondSorce=$P(subOrdItem,"^",58)
			if (subBondSorce'="") continue
			s GroupFlag=1
			s subOrderOpenForAllHosp=$p(subOrdItem,"^",68)
			s subARCIMRowid=$p(subOrdItem,"^",1)
			s subPriorRowid=$p(subOrdItem,"^",3)
			S subInstrRowId=$p(subOrdItem,"^",17)
			;continue:(subInstrRowId=InstrRowId)
			;如果子医嘱用法一致 那么子医嘱就不取用法了
			s PriorList("A",subARCIMRowid,subPriorRowid)=""
			s PriorList("I",+subInstrRowId,subPriorRowid)=""
			if (subInstrRowId=InstrRowId){
				if ("^"_ArcimList_"^")[("^"_subARCIMRowid_"^"){
					continue
				}
				s ArcimList=ArcimList_"^"_subARCIMRowid
			}else{
				s ArcimWardInfo=##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(Adm,subARCIMRowid,subInstrRowId,"1",subOrderOpenForAllHosp)
				d OneArcimWardInfo
			}
		}
	}
	s ArcimWardInfo=##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(Adm,ArcimList,InstrRowId,"1",OrderOpenForAllHosp)
	d OneArcimWardInfo
	Q AppendItemStr
OneArcimWardInfo
	k OnePriorList
	m OnePriorList=PriorList
	for i=1:1:$L(ArcimWardInfo,$C(2)) {
		s OneArcimWardInfo=$P(ArcimWardInfo,$C(2),i)
		continue:OneArcimWardInfo=""
		s AddArcimItem=$P(OneArcimWardInfo,"^",1)		
		;1:按天,2:按次
		s ExecType=$P(OneArcimWardInfo,"^",2)
		continue:AddArcimItem=""
		s SingleNotFee=$P(OneArcimWardInfo,"^",6)
		continue:(SingleNotFee="1")&&'GroupFlag
		s NotLinkPriorStr=$P(OneArcimWardInfo,"^",9)
		s OrderOpenForAllHosp=$P(OneArcimWardInfo,"^",10)

		s AddType=$P(OneArcimWardInfo,"^",14)
		s AddIndexID=$P(OneArcimWardInfo,"^",15)
		
		for j=1:1:$Length(NotLinkPriorStr,"_"){
			s NotLinkPrior=$P(NotLinkPriorStr,"_",j)
			continue:(NotLinkPrior="")
			k OnePriorList(AddType,AddIndexID,NotLinkPrior)
		}
		//如果绑定方式下的可用医嘱类型均被识别为不需要绑定，则退出
		if ('$D(OnePriorList(AddType,AddIndexID))){
			continue
		}
		//continue:(("_"_NotLinkPriorStr_"_")[("_"_PriorRowid_"_"))
		s ByDay=$CASE(ExecType,1:1,2:"")
		s Qty=$P(OneArcimWardInfo,"^",4)
		;DHCIAAddItmDR_$C(1)_DHCIAQty_$c(1)_DHCIARecLocId_$C(1)_DHCIAInstrId_$C(1)_OrderOpenForAllHosp
		s oneAppendItem=AddArcimItem_$C(1)_Qty_$c(1)_""_$C(1)_""_$C(1)_OrderOpenForAllHosp_$C(1)_ByDay
		i AppendItemStr="" {
			s AppendItemStr=oneAppendItem
		}else{
			s AppendItemStr=AppendItemStr_"^"_oneAppendItem
		}
	}
	Q
}

/// creator: tanjishan
/// date: 2022年3月30日
/// desc: 根据医嘱信息串获取待绑定的检验材料\采血费
/// input:	Adm：就诊ID
/// 		SessionStr:	websys.js->GetSessionStr\websys_getSessionStr;DHCDoc.Util.RegisteredObject->%SessionStr;部分通过接口传入，可能无完整数据
/// 		OrdCongeriesArr:医嘱录入的待审核医嘱，已经按照主子医嘱拆分成了数组
/// 		LabEpisArray：待保存的医嘱中的检验信息串
/// 		OrdAddCongeriesArr：输出项，计算的待绑定医嘱结果
/// 		MaxOrderSeqNo：计算项，累计新增的数据条数
/// 		
/// output:	LabOrdItemAppendItem：计算结果，效果同OrdAddCongeriesArr，只是数据展示形式有区别
ClassMethod GetLabOrdItemAppendItem(Adm As %String, SessionStr As %String, ByRef OrdCongeriesArr, ByRef LabEpisArray, ByRef OrdAddCongeriesArr, ByRef MaxOrderSeqNo = 1) As %String [ ProcedureBlock = 0 ]
{
	n (Adm , SessionStr,OrdCongeriesArr,LabEpisArray,OrdAddCongeriesArr,MaxOrderSeqNo)
	Q:'$d(LabEpisArray) 0
	s AppendItemStr=""
	k AppendItemList
	s PatientID=$P(^PAADM(Adm),"^",1)
	s AdmLocDr=$P(^PAADM(Adm),"^",4)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)	
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonGroupDr=$P(SessionStr,"^",2)
	s LogonLocDr=$P(SessionStr,"^",3)
	s OrderRowId=$o(^OEORD(0,"Adm",Adm,""))
	s HospitalRowid=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	//准备好检验号与待审核医嘱列表的关系
	s (TempSeqNo)=0
	k LabEpisNoArray
	s keylab=0 f  {
		s keylab=$O(LabEpisArray(keylab)) 
		Q:keylab=""
		s labepisodeno=LabEpisArray(keylab)
		continue:(labepisodeno="")
		s SeqNo="" f  {
			s SeqNo=$O(OrdCongeriesArr(SeqNo)) 
			Q:SeqNo=""
			s ItemStr=$G(OrdCongeriesArr(SeqNo))
			s ItemLabEpisodeNo=$P(ItemStr,"^",38)
			if (ItemLabEpisodeNo=labepisodeno){
				s i=$I(LabEpisArray(keylab,"Items"))
				s LabEpisArray(keylab,"Items",i)=ItemStr
				s i=$I(LabEpisNoArray(labepisodeno,0))
				s LabEpisNoArray(labepisodeno,i)=ItemStr
			}
		}
		//调用前提有可能是用来补检验号和附加费，根本就没有传入OrdItemStr，这里需要找一个实例,如果连实例都找不到，则直接放弃生成附加费
		if ('$D(LabEpisArray(keylab,"Items"))) {
			s Childsub=$O(^OEORD(0,"EpisNo",labepisodeno,OrderRowId,""),-1)
			if (Childsub'=""){
				s ItemStr=..BulidOrdItemStr(OrderRowId_"||"_Childsub)
				s TempSeqNo=TempSeqNo+1
				s $P(ItemStr,"^",20)=TempSeqNo
				if (ItemStr'=""){
					s i=$I(LabEpisArray(keylab,"Items"))
					s LabEpisArray(keylab,"Items",i)=ItemStr
					s i=$I(LabEpisNoArray(labepisodeno,0))
					s LabEpisNoArray(labepisodeno,i)=ItemStr

					s OrdCongeriesArr(TempSeqNo)=ItemStr
					s:TempSeqNo>MaxOrderSeqNo MaxOrderSeqNo=TempSeqNo
				}
			}
		}
		
	}
	//根据待审核医嘱，获取检验费用信息（材料费+采血费）
	d CalLabOrdItemFee
	
	q AppendItemStr
SetAppendItemStr(BindSource)
	s OneAppendItemStr=ARCIMRowid_$C(1)_AddPackQty_$C(1)_""_$C(1)_""_$C(1)_OrderOpenForAllHosp_$C(1)_""_$C(1)_""_$C(1)_""_$C(1)_""_$C(1)_BindSource_$C(1)_$C(1)_labepisodeno
	if (AppendItemStr="") s AppendItemStr=OneAppendItemStr
	else   s AppendItemStr=AppendItemStr_"^"_OneAppendItemStr
	
	//因为OrdItemStr串需要复制一部分主医嘱的信息，这里直接使用示例医嘱串进行复制即可
	s MasterSeqNo=$p(ExamplesItem,"^",19)
	s OrderSeqNo=$p(ExamplesItem,"^",20)
	s ExpStr=OrderSeqNo_"^"_$LFS(SessionStr,"^")
	d ..SetAppendItemDataArr(Adm,OneAppendItemStr,.OrdCongeriesArr,.OrdAddCongeriesArr,.MaxOrderSeqNo,ExpStr)
	
	Q
CalLabOrdItemFee
	s CFBaseContainer=##class(web.DHCDocConfig).GetConfigNode("BaseContainer",HospitalRowid)
	k LabOrdPlanArray
	d ##class(DHCDoc.DHCDocConfig.LabBindRuleSetting).GetLabOrdUsedPlanArr(Adm,.LabOrdPlanArray)
	Q:'$d(LabOrdPlanArray) 0
	//遍历检验号
	
	s keylab=0 f  {
		s keylab=$O(LabEpisArray(keylab)) 
		Q:keylab=""
		
		s SttDate=$P(keylab,"^",2)
		s labepisodeno=LabEpisArray(keylab)
		s speccode=$ZCVT($P(keylab,"^",3),"U")
		s container=$ZCVT($P(keylab,"^",4),"U")
		//能分到同一组的检验数据，随便找一个示例数据即可
		s ExamplesItem=$O(LabEpisArray(keylab,"Items",0))
		Continue:(ExamplesItem="")
		s ExamplesItem=$G(LabEpisArray(keylab,"Items",ExamplesItem))
		Set AdmReason=$replace($p(ExamplesItem,"^",9),$c(10),"")	;$p($g(^OEORD(OrderRowId,"I",OrderChild,11)),"^",18)
		set ChronicDiagCode=$p(ExamplesItem,"^",82)						;$p($g(^OEORD(OrderRowId,"I",OrderChild,"DHC")),"^",66)
		set OrderOpenForAllHosp=$p(ExamplesItem,"^",68)
		set ImportByContingences=$p(ExamplesItem,"^",75)					;$p($G(^OEORD(OrderRowId,"I",OrderChild,"DHC")),"^",62)
		s ARCIMRowId=$p(ExamplesItem,"^",1)								;$p(^OEORD(OrderRowId,"I",OrderChild,1),"^",2)
		continue:(ImportByContingences="Y")
		//明确当前适合的绑定方案；TODO如果不同的方案之间合并了管，这里没有处理，理论上不同的方案之间应该拆管
		s OrdUsedPlanId=""
		s planlab=0 for {
			s planlab=$O(LabOrdPlanArray(planlab)) 
			Q:planlab=""
			s planData=$g(LabOrdPlanArray(planlab))
			s planLimitLocStr=$p(planData,$C(1),1)
			s planLimitOrdStr=$p(planData,$C(1),2)
			continue:("^"_planLimitLocStr_"^")'[("^"_LogonLocDr_"^")
			continue:(planLimitOrdStr'="")&&(("^"_planLimitOrdStr_"^")'[("^"_ARCIMRowId_"^"))
			if (("^"_planLimitOrdStr_"^")[("^"_ARCIMRowId_"^")) {
				s OrdUsedPlanId=planlab
				Q
			}
			s OrdUsedPlanId=planlab
		}
		continue:OrdUsedPlanId=""
		if (CFBaseContainer=1) {
		    s BloodTypeCode=container
		}else{
			s BloodTypeCode=speccode
		}		
		
		//s LabEpisodeNo=labepisodeno
		;1、按该方案容器/标本绑定的医嘱进行绑定(按照重复加收处理,即不同检验号重复绑定)
		d SetLabLinkOrderBySpecOrCon
		//获取取血类型
		s BloodFlag="" 
		s ConBloodTypeId=$o(^User.DHCDocLabPlanBloodFlagI("LabPlanDr"," "_OrdUsedPlanId," "_BloodTypeCode,""))
		if (ConBloodTypeId'="") {
			s BloodFlag=$lg(^User.DHCDocLabPlanBloodFlagD(ConBloodTypeId),3)
			if (BloodFlag'="") {
				s BloodFlagActive=$lg(^User.DHCDocLabBloodTypeD(BloodFlag),4)
				i BloodFlagActive'="Y" s BloodFlag=""
			}				
		}
		if (BloodFlag'="") {
			s LabEpisodeNos=labepisodeno
			;临时医嘱
			Set PriorRowid=$O(^OECPR(0,"Code","NORM",0))
			// 方案取血类型维护的费用
			s BindBloodOrdFeeId=0 for {
				s BindBloodOrdFeeId=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_OrdUsedPlanId," BLOODTYPE_"_BloodFlag,BindBloodOrdFeeId))
				Q:BindBloodOrdFeeId=""
				s BloodARCIMRowid=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindBloodOrdFeeId),2)
				
				s AddPackQty=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindBloodOrdFeeId),3)
				s MasterOrderRowid=""
				;是否重复加收-重复加收：不同检验号重复绑定
				s IsRepeatAdd=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindBloodOrdFeeId),5)
				if (IsRepeatAdd="Y") {
					s IsAddedFlag=$$GetItemIsAddedFlag()
					if (IsAddedFlag=0) {
						;绑定采血费用
						s ARCIMRowid=BloodARCIMRowid
						d SetAppendItemStr("BF")
					}
				}else{
					;需要判断同开始日期全部医嘱
					if (PAAdmType="I"){
						s FindBloodOrderItem=$$BloodItemOverAllEPISNew(+OrderRowId,BloodFlag,LabEpisodeNos,BloodARCIMRowid)
						
						if (FindBloodOrderItem=0) {
							s ARCIMRowid=BloodARCIMRowid
							d SetAppendItemStr("BF")
						}
					}else{
						s FindBloodOrderItem=0 Set FindBloodOrderItem=0
						//门急诊的多次就诊的采血费可以合并判断，只有有一项未使用的采血费，就不再重复收取。
						s OrderInfo=##class(web.DHCOEOrdItem).GetToDayAdmInfo(Adm)
						if (("^"_OrderInfo_"^")'[("^"_OrderRowId_"^")) s OrderInfo=OrderInfo_"^"_OrderRowId
						s Len=$l(OrderInfo,"^")
						for i=1:1:Len {
							Q:FindBloodOrderItem=1
							s OrdRowId=$p(OrderInfo,"^",i)
							continue:(OrdRowId="")
							s FindBloodOrderItemFlag=$$BloodItemOverAllEPISNew(OrdRowId,BloodFlag,labepisodeno,BloodARCIMRowid)
							i FindBloodOrderItemFlag=1 s FindBloodOrderItem=1
						}
						
						if (FindBloodOrderItem=0) {
							s ARCIMRowid=BloodARCIMRowid
							d SetAppendItemStr("BF")
						}
					}
				}
			}
		}
	}
	q 0

 ;查找当前是否存在未使用的采血费。如果有的话，就不需要再额外绑定了，并且给当前采血费绑定上当前的检验号
 ;部分内容参考来源$$BloodItemOverAllEPISNew^DHCDocOrderCommon
BloodItemOverAllEPISNew(OrderRowId,CurBloodFlag,LabEpisodeNo,BloodARCIMRowid)
	n (OrderRowId,CurBloodFlag,LabEpisodeNo,BloodARCIMRowid,LabEpisNoArray,OrdAddCongeriesArr)
	
	s adm=$p($g(^OEORD(OrderRowId)),"^",1)
	s admtype=$p($g(^PAADM(adm)),"^",2)
	s HospitalRowid=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(adm)
	s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(adm) //$$GetStayStatus^DHCDocEmerInsu(adm)
	s CFBaseContainer=##class(web.DHCDocConfig).GetConfigNode("BaseContainer",HospitalRowid)
	s findblooditem=0,Sttdate=+$h
	
	//遍历已审核医嘱的同标本号数据
	Set CurOrdBoodSugarGroupStr=""
	Set LoopOrderChild=0
	for {
		Set LoopOrderChild=$O(^OEORD(0,"EpisNo",LabEpisodeNo,OrderRowId,LoopOrderChild)) Q:LoopOrderChild=""
		s LoopStatusRowid=$P($G(^OEORD(OrderRowId,"I",LoopOrderChild,1)),"^",13),StatusCode=""
		If LoopStatusRowid'="" Set LoopStatusCode=$P(^OEC("OSTAT",LoopStatusRowid),"^",1)
		continue:($g(LoopStatusCode)'="V")&&($g(LoopStatusCode)'="E")
		Set LoopARCIMRowid=$p($g(^OEORD(OrderRowId,"I",LoopOrderChild,1)),"^",2)
		s CurOrdBloogSugarGroup=##Class(web.DHCDocPrescript).GetOrdBloogSugarGroup(LoopARCIMRowid,HospitalRowid)
		if (CurOrdBloogSugarGroup'="") {
			i CurOrdBoodSugarGroupStr="" s CurOrdBoodSugarGroupStr=CurOrdBloogSugarGroup
			e  s CurOrdBoodSugarGroupStr=CurOrdBoodSugarGroupStr_"^"_CurOrdBloogSugarGroup
		}
	}
	//遍历未审核医嘱的同标本号数据
	s i=0 f  {
		s i=$O(LabEpisNoArray(LabEpisodeNo,i)) Q:i=""
		s LoopItem=$G(LabEpisNoArray(LabEpisodeNo,i))
		s LoopARCIMRowid=$p(LoopItem,"^",1)
		continue:(LoopARCIMRowid="")
		s CurOrdBloogSugarGroup=##Class(web.DHCDocPrescript).GetOrdBloogSugarGroup(LoopARCIMRowid,HospitalRowid)
		if (CurOrdBloogSugarGroup'="") {
			i CurOrdBoodSugarGroupStr="" s CurOrdBoodSugarGroupStr=CurOrdBloogSugarGroup
			e  s CurOrdBoodSugarGroupStr=CurOrdBoodSugarGroupStr_"^"_CurOrdBloogSugarGroup
		}
	}
	if (CurOrdBoodSugarGroupStr'="") s CurOrdBoodSugarGroupStr="^"_CurOrdBoodSugarGroupStr_"^"
	
	s cursttdat=Sttdate
	s startdat=cursttdat,enddat=cursttdat
	s UnPrintOEStr="",IsExistBloodItem=0,ExistBloodItem=""
	;1、先从已审核的医嘱列表中查询是否有能够合并使用的采血费
	for datloop=startdat:1:enddat {
		s oeoriid=0
		for {
			s oeoriid=$o(^OEORDi(0,"StDt",datloop,OrderRowId,oeoriid)) q:(oeoriid="")  
			s data1=$g(^OEORD(OrderRowId,"I",oeoriid,1))
			s data3=$g(^OEORD(OrderRowId,"I",oeoriid,3))
			s arcimrowid=$p(data1,"^",2)
			continue:arcimrowid=""
			s ResultGroup=$p($g(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),9)),"^",3)
			continue:ResultGroup'=""
			s Billed=$p(data3,"^",5)
			s reclocid=$p(data3,"^",6)
			s LabEpisodeNoLoop=$p(data3,"^",20)
			s ResultFlag=$p(data1,"^",5)
			s ItemStatCode=""
			s ItemStatDR=$p(data1,"^",13)
			i ItemStatDR'="" s ItemStatCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
			continue:ItemStatCode'="V"
			if arcimrowid=BloodARCIMRowid {
				s LabEpisodeNoStr=$p($g(^OEORD(OrderRowId,"I",oeoriid,"DHC")),"^",22)
				;验证采血费是否能够合并使用
				s sc=$$BloodItemMergeCheck()
				if ($$$ISERR(sc)){
					continue
				}
				s IsExistBloodItem=1,ExistBloodItem=OrderRowId_"||"_oeoriid
			}
			s ItemCatDR=$p($g(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1)),"^",10)
			s OrderType=$P($g(^ARC("IC",+ItemCatDR)),"^",7)
			continue:OrderType'="L"
			s quitflag=0
			i (admtype="I")!(StayStatus=1) {
				;住院判断已经打印(PT)条码则退出
				s ResultPrintFlag=..IfNurPrintLabNo(OrderRowId,oeoriid)
				i ResultPrintFlag=1 s quitflag=1
			}else{
				;门急诊判断项目已经收费则退出
				i Billed="P" s quitflag=1
			}
			continue:quitflag=1
			i UnPrintOEStr="" s UnPrintOEStr=OrderRowId_"||"_oeoriid
			e  s UnPrintOEStr=UnPrintOEStr_"^"_OrderRowId_"||"_oeoriid
		}
	}
	
	
	;1.1、存在未打印的同种采血方式的并且已经有采血费,则该采血费有效，只需要更新采血费关联检验号码即可
	i (UnPrintOEStr'="")&(IsExistBloodItem=1) {
		;更新采血费关联的检验号；TODO因为当前检验医嘱不一定能审核成功，这个地方有可能会append进去无效的检查号
		s LabEpisodeNoStr=$p($g(^OEORD(+ExistBloodItem,"I",$p(ExistBloodItem,"||",2),"DHC")),"^",22)
		if ($C(1)_LabEpisodeNoStr_$C(1))'[($C(1)_LabEpisodeNo_$C(1)){
			i LabEpisodeNoStr="" s $p(^OEORD(+ExistBloodItem,"I",$p(ExistBloodItem,"||",2),"DHC"),"^",22)=LabEpisodeNo
			e  s $p(^OEORD(+ExistBloodItem,"I",$p(ExistBloodItem,"||",2),"DHC"),"^",22)=LabEpisodeNoStr_$C(1)_LabEpisodeNo
		}
		s findblooditem=1
	}
	;2、再从待保存的采血费中查询是否有能够合并使用的采血费
	s LoopIndex=0
	for{
		s LoopIndex=$O(OrdAddCongeriesArr(LoopIndex))
		q:(LoopIndex="")
		s LoopOrdItemStr=$G(OrdAddCongeriesArr(LoopIndex,"OrdListInfo"))
		s arcimrowid=$P(LoopOrdItemStr,"^",1)
		continue:(arcimrowid'=BloodARCIMRowid)
		s LabEpisodeNoStr=$p(LoopOrdItemStr,"^",90)
		continue:(LabEpisodeNoStr="")
		s LabEpisodeNoStr=$replace(LabEpisodeNoStr,"@",$C(1))
		s Billed="TB"
		;验证采血费是否能够合并使用
		s sc=$$BloodItemMergeCheck()
		if ($$$ISERR(sc)){
			continue
		}
		;2.2、更新采血费关联检验号码
		if (LabEpisodeNoStr=""){
			s LabEpisodeNoStr=LabEpisodeNo
		}else{
			s LabEpisodeNoStr=LabEpisodeNoStr_$C(1)_LabEpisodeNo
		}
		s $p(LoopOrdItemStr,"^",90)=$replace(LabEpisodeNoStr,$C(1),"@")
		s OrdAddCongeriesArr(LoopIndex,"OrdListInfo")=LoopOrdItemStr
		s findblooditem=1
		quit
	}
	
	q findblooditem
 ;验证采血费是否能够合并使用，注意，该方法会在两处被调用，其中一处采血费并未实际保存到医嘱表。
 ;OutPut	1:能合并使用，0：不能合并使用
BloodItemMergeCheck()
	n (OrderRowId,LabEpisodeNo,HospitalRowid,Billed,CurOrdBoodSugarGroupStr,LabEpisodeNoStr,LabEpisNoArray)
	;1、【已存在的采血费对应的血糖分组】与【当前管号的血糖分组】一致时，则需要插入采血费
	;2、住院或留观患者，如果采血费关联的检验项目全部打印则需要产生采血费的范围
	;3、门诊患者，如果采血费已收费，则需要重新产生采血费
	; 
	s adm=$p($g(^OEORD(OrderRowId)),"^",1)
	s admtype=$p($g(^PAADM(adm)),"^",2)
	s HospitalRowid=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(adm)
	s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(adm) //$$GetStayStatus^DHCDocEmerInsu(adm)
	s ExistLabPrintFlag=0,ExistSameOrdBoodSugarGroupFlag=0
	for i=1:1:$l(LabEpisodeNoStr,$C(1)) {
		s ExistLabTemp=$p(LabEpisodeNoStr,$C(1),i)
		continue:ExistLabTemp=""
		;如果当前检验号已与历史号码合并，就不需要再进行处理，沿用之前检验号生成的费用即可。
		continue:(ExistLabTemp=LabEpisodeNo)
		s childsub=0
		for {
			s childsub=$O(^OEORD(0,"EpisNo",ExistLabTemp,OrderRowId,childsub)) Q:(childsub="")
			s StatusRowid=$P($G(^OEORD(OrderRowId,"I",childsub,1)),"^",13),StatusCode=""
			If StatusRowid'="" Set StatusCode=$P(^OEC("OSTAT",StatusRowid),"^",1)
			continue:($g(StatusCode)'="V")&&($g(StatusCode)'="E")
			s ExistLabItemRowId=$p($g(^OEORD(OrderRowId,"I",childsub,1)),"^",2)
			s ExistLabBloogSugarGroup=##Class(web.DHCDocPrescript).GetOrdBloogSugarGroup(ExistLabItemRowId,HospitalRowid)
			if (CurOrdBoodSugarGroupStr'="")&&(CurOrdBoodSugarGroupStr[("^"_ExistLabBloogSugarGroup_"^")) s ExistSameOrdBoodSugarGroupFlag=1
			i (admtype="I")!(StayStatus=1) s ExistLabPrintFlag=..IfPrintLabNo(OrderRowId,childsub)
		}
		//遍历未审核医嘱的同标本号数据，如果有合并到之前采血费的医嘱与当前医嘱同属一个血糖分组
		s j=0 f  {
			s j=$O(LabEpisNoArray(ExistLabTemp,j)) Q:j=""
			s LoopItem=$G(LabEpisNoArray(ExistLabTemp,j))
			s LoopARCIMRowid=$p(LoopItem,"^",1)
			continue:(LoopARCIMRowid="")
			s ExistLabBloogSugarGroup=##Class(web.DHCDocPrescript).GetOrdBloogSugarGroup(LoopARCIMRowid,HospitalRowid)
			if (CurOrdBoodSugarGroupStr'="")&&(CurOrdBoodSugarGroupStr[("^"_ExistLabBloogSugarGroup_"^")) s ExistSameOrdBoodSugarGroupFlag=1
		}
	}
	if (ExistSameOrdBoodSugarGroupFlag=1){
		q $$$NO
	}
	if (admtype="I")!(StayStatus=1) {

	}else{
		if Billed="P" s ExistLabPrintFlag=1	
	}
	if (ExistLabPrintFlag=1){
		q $$$NO
	}
	
	q $$$YES
 ;获取标本\管绑定费用
SetLabLinkOrderBySpecOrCon
	s BindOrdFeeId=0 for {
		s BindOrdFeeId=$o(^User.DHCDocLabPlanBindOrdFeeI("LabPlanBindOrdFeeType"," "_OrdUsedPlanId," "_BloodTypeCode,BindOrdFeeId))
		Q:BindOrdFeeId=""
		s ARCIMRowid=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindOrdFeeId),2)
		s AddPackQty=$lg(^User.DHCDocLabPlanBindOrdFeeD(BindOrdFeeId),3)
		;同标本号是否已经绑定了有效的标本\管费用
		s IsAddedFlag=$$GetItemIsAddedFlag()
		if (IsAddedFlag=0) {
			if (CFBaseContainer=1) {
				d SetAppendItemStr("CT")
			}else{
				d SetAppendItemStr("SP")
			}
		}
	}
	Q 0
GetItemIsAddedFlag()
	s OrdSubChild="",IsAddedFlag=0
	for {
		s OrdSubChild=$o(^OEORDi(0,"ARCIM",OrderRowId,ARCIMRowid,SttDate,OrdSubChild),-1) Q:OrdSubChild=""
		Set StatusRowid=$P($G(^OEORD(OrderRowId,"I",OrdSubChild,1)),"^",13)
		If StatusRowid'="" Set StatusCode=$P(^OEC("OSTAT",StatusRowid),"^",1)
		continue:($g(StatusCode)'="V")&&($g(StatusCode)'="E")
		s LLabEpisodeNoStr=$P($G(^OEORD(OrderRowId,"I",OrdSubChild,"DHC")),"^",22)
		
		continue:LLabEpisodeNoStr'=labepisodeno
		s AcrimRowid1=$p(^OEORD(OrderRowId,"I",OrdSubChild,1),"^",2)
		
		s IsAddedFlag=1
		Q
	}
	Q IsAddedFlag
}

/// 根据医嘱ID还原成OrdItemStr，可以对标SetPlist^DHCDocOrderCommonNew
/// 如果需要一次性拼装多条医嘱，需要自行累加$P(OrdItemStr,"^",20)对应的OrderSeqNo值，防止出现多条医嘱同时审核导致的数据覆盖问题
ClassMethod BulidOrdItemStr(itmRowId As %String) As %Status
{
	s ord=+itmRowId,itm=$P(itmRowId,"||",2)
	s EpisodeID=$P(^OEORD(ord),"^",1)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s AdmHospDr=$P(^CTLOC(AdmLoc),"^",22)
	&SQL(select * INTO PLIST() from SQLUser.OE_OrdItem where OEORI_RowId=:itmRowId)
	q:(SQLCODE'=0) ""
	&SQL(select * INTO DHCPLIST() from SQLUser.OE_OrdItemExt where OEORI_RowId=:itmRowId)
	q:(SQLCODE'=0) ""
	set entrid=PLIST(3)			         ;OEORI_OrdEnt_DR
	Set ARCIMRowid=PLIST(4)
	Set admloc=PLIST(6)		 	         ;OEORI_OrdDept_DR
	Set StatusRowid=PLIST(10)	         ;OEORI_ItemStat_DR
	Set Doc=PLIST(14)   		         ;OEORI_Doctor_DR
	Set SttDate=PLIST(17)		         ;SttDate
	Set SttTime=PLIST(18)				 ;OEORI_SttTim
	Set PriorRowid=PLIST(23)	         ;OEC_Priority
	Set FreqRowid=PLIST(25)
	Set InstrRowid=PLIST(27)
	Set DoseUOMRowid=PLIST(28)
	Set DoseQtySum=PLIST(29)	 ;PhyQtyOrd	
	Set DurRowid=PLIST(35)	
	Set PhSpecInstr=PLIST(43)
	Set oeprice=PLIST(46)
	Set FirstDayTimes=PLIST(50)          ;OEORI_Qty
	Set DepProcNotes=$ListGet(PLIST(53),1)
	Set OrderCoverMainIns=PLIST(55)		 ;CoverMainIns
	Set SkinTest=PLIST(57)		         ;SkinTest
	Set SpeedFlowRate=PLIST(72)			 ;输液低速
	Set RecDepRowid=PLIST(75)
	Set OrderSeqNo=PLIST(77)
	Set DoseQty=PLIST(85)                ;DoseQty
	Set ARCOSRowid=PLIST(86)             ;ARCOS
	Set LabEpisodeNo=PLIST(88)           ;LabEpisodeNo
	Set AnaesthesiaID=PLIST(106)     ;OEORI_Anaest_DR
	Set OperationCode=PLIST(107)     ;OEORI_AnaOper_DR
	Set User=PLIST(120)	 	         ;User Add
	Set DIACatRowId=PLIST(119) 
	Set Loc=PLIST(121) 	 	         ;User Dept

	Set EpLoc=PLIST(161)		         ;OEORI_AdmLoc_Dr
	Set entrid=PLIST(139)
	Set PackQty=PLIST(154)		 ;OEORI_QtyPackUOM
	Set EndDate=PLIST(159)		         ;End Date
	Set EndTime=PLIST(160)		         ;End Time
	;Set OrderFillterNo=PLIST(163)		 ;OEORI_FillerNo
	Set ActionRowid=PLIST(209)           ;Action
	Set OrderDate=PLIST(81)
	Set OrderTime=..%ZT(PLIST(90))
	Set OrderFlowRateUnit=PLIST(125)
	Set AdmReason=PLIST(206)  
	Set OEORIOEORIDR=PLIST(230)  
	Set NotifyClinician=PLIST(248)

	;医嘱扩展表属性字段值
	Set ExecuteDateStr=DHCPLIST(3)				;OEORIExecuteDateStr
	Set PilotProRowId=DHCPLIST(12)				;OEORI_PEProject_DR
	Set OrderNeedPIVAFlag=DHCPLIST(18)			;OEORINeedPIVAFlag	
	Set OrderPackUOMRowid=DHCPLIST(15)  			;OEORIPackUOM
	Set InsurCatRowId=DHCPLIST(5)				;OEORIInsurCatDR
	Set OrderStageCode=DHCPLIST(10)				;OEORIStage
	Set OrderNutritionDrugFlag=DHCPLIST(14)		;OEORINutritionDrugFlag
	Set MaterialBarCode=DHCPLIST(16)				;OEORIMaterialNo
	Set AntUseReason=DHCPLIST(20)				;OEORITarget
	Set OrderBySelfOMFlag=DHCPLIST(35)			;OEORISelfOMFlag
	Set ExceedReasonID=DHCPLIST(68)				;OEORIExceedReasonDR
	Set OrderLocalInfusionQty=DHCPLIST(23)		;OEORILocalInfusionQty
	Set OrderOutsourcingFlag=DHCPLIST(74)		;OEORIOutsourcingFlag
	Set OEORIBindSource=DHCPLIST(78)		        ;OEORIBindSource 医嘱绑定来源
	Set ApplyArcId=DHCPLIST(79)		        	;OEORIAppReportDR
	Set ZSKMonitorLogId=DHCPLIST(81)		    ;OEORIMonitorLogId
	Set OrderFreqWeekStr=DHCPLIST(92)			;OEORI_FreqWeek
	Set OrderVirtualtLong=DHCPLIST(94)			;OEORI_VirtualtLong
	Set OrderPkgOrderNo=DHCPLIST(95)				;OEORI_PkgOrderNo
	Set OrderOpenForAllHosp=DHCPLIST(96)			;OEORI_OpenForAllHosp
	Set OrderFreqTimeDoseStr=DHCPLIST(97)
	Set OrderNurseBatchAdd=DHCPLIST(98)
	Set ImportByContingences=DHCPLIST(102)
	Set OEORIDspBatch=DHCPLIST(103)
	Set OEORIImportINCI=DHCPLIST(104)
	Set OrderFreqFreeTimeStr=DHCPLIST(108)

	s OrderAntibApplyRowid=$O(^DHCDAAi(0,"OEORI",itmRowId,0))
	s MRCPWString=##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByadm(EpisodeID)
	s CPWStepItemRowId=$p(MRCPWString,"^",1)


	if (FreqRowid'=""){
		if ((PackQty'="")){
			d SetPackQty
			s DoseQtySum=CalPackQtyArr("OrderBaseQtySum")
			s PackQty=CalPackQtyArr("OrderPackQty")
		}
	}
	Set specimen=$$GetOELabSpecimen^DHCDocOrderCommonNew(itmRowId)
	//1
	Set ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	Set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s DrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	s OrdItem=ARCIMRowid_"^"_OrderType_"^"_PriorRowid_"^"_SttDate_"^"_SttTime
	s OrdItem=OrdItem_"^"_PackQty_"^"_oeprice_"^"_RecDepRowid_"^"_AdmReason_"^"_DrugFormRowid
	//11
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,AdmHospDr,ARCIMRowid)
	s MasterSeqNo=""
	s OrderSeqNo=1
	s OrdItem=OrdItem_"^"_DepProcNotes_"^"_DoseQty_"^"_DoseUOMRowid_"^"_DoseQtySum_"^"_FreqRowid
	s OrdItem=OrdItem_"^"_DurRowid_"^"_InstrRowid_"^"_PHPrescType_"^"_MasterSeqNo_"^"_OrderSeqNo
	//21
	s OrdItem=OrdItem_"^"_SkinTest_"^"_PhSpecInstr_"^"_OrderCoverMainIns_"^"_ActionRowid_"^"_ARCOSRowid
	s OrdItem=OrdItem_"^"_EndDate_"^"_EndTime_"^"_specimen_"^"_ExecuteDateStr_"^"_NotifyClinician
	//31
	;适应症串
	s InsurSignSymptomCode=""
	s DSRowID=""
	for {
		s DSRowID=$O(^OEORD(+itmRowId,"I",$P(itmRowId,"||",2),"DSYM",DSRowID))
		q:(DSRowID="")
		s DSYMCode=$P($G(^OEORD(+itmRowId,"I",$P(itmRowId,"||",2),"DSYM",DSRowID)),"^",2)
		continue:(DSYMCode="")
		if (InsurSignSymptomCode=""){
			s InsurSignSymptomCode=DSYMCode
		}else{
			s InsurSignSymptomCode=InsurSignSymptomCode_$C(2)_DSYMCode
		}
	}
	
	s OrdItem=OrdItem_"^"_DIACatRowId_"^"_InsurCatRowId_"^"_FirstDayTimes_"^"_InsurSignSymptomCode_"^"_OrderStageCode
	s OrdItem=OrdItem_"^"_SpeedFlowRate_"^"_AnaesthesiaID_"^"_LabEpisodeNo_"^"_"^"_OrderNutritionDrugFlag
 	//41
 	s InsurApproveType=""
	s OrdItem=OrdItem_"^"_MaterialBarCode_"^^"_CPWStepItemRowId_"^"_InsurApproveType_"^"_OrderFlowRateUnit
	s OrdItem=OrdItem_"^"_OrderDate_"^"_OrderTime_"^"_OrderNeedPIVAFlag_"^"_OrderAntibApplyRowid_"^"_AntUseReason
 	//51
 	s UseReasonId=$O(^DAUP("OEORI",itmRowId,""))
	s OrdItem=OrdItem_"^"_UseReasonId_"^"_OrderLocalInfusionQty_"^"_OrderBySelfOMFlag_"^"_ExceedReasonID_"^"_OrderPackUOMRowid
	s OrdItem=OrdItem_"^"_PilotProRowId_"^"_OrderOutsourcingFlag_"^"_OEORIBindSource_"^"_ApplyArcId_"^"_DIACatRowId
	//61
	Set OrderOpenForAllHosp=$case(OrderOpenForAllHosp,"Y":"1",:"0")
	s OrderPracticePre=""
	s OrdItem=OrdItem_"^"_OperationCode_"^"_ZSKMonitorLogId_"^"_"^^"
	s OrdItem=OrdItem_"^"_"^"_OrderFreqWeekStr_"^"_OrderOpenForAllHosp_"^"_OrderPracticePre_"^"_OrderFreqTimeDoseStr
	//71
	s OrderFillterNo=""
	s OrdItem=OrdItem_"^"_"^"_"^"_"^"_OrderPkgOrderNo_"^"_ImportByContingences
	s OrdItem=OrdItem_"^"_"^"_"^"_"^"_"^"_OrderFillterNo_"^^^"_OrderFreqFreeTimeStr	
	//81

	
	q OrdItem
	//参考web.DHCOEOrdItemView中的SetPackQty
SetPackQty
	s OrderFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(FreqRowid,OrderFreqWeekStr,OrderFreqFreeTimeStr)
	s OrderFreqDispTimeStr=$TR(OrderFreqDispTimeStr,$C(1),$C(13))
	s HOSPID=$P(^CTLOC(Loc),"^",22)
	s SessionStr=User_"^^"_Loc_"^"_HOSPID
	
	k OrdParamArr
	s OrdParamArr("EpisodeID")=EpisodeID
	s OrdParamArr("OrderPriorRowid")=PriorRowid
	s OrdParamArr("OrderARCIMRowid")=ARCIMRowid
	s OrdParamArr("OrderDoseQty")=DoseQty
	s OrdParamArr("OrderDoseUOMRowid")=DoseUOMRowid
	s OrdParamArr("OrderFreqRowid")=FreqRowid
	s OrdParamArr("OrderDurRowid")=DurRowid
	s OrdParamArr("OrderPackQty")=PackQty
	s OrdParamArr("OrderPackUOMRowid")=OrderPackUOMRowid
	s OrdParamArr("OrderStartDate")=..%ZD(SttDate)
	s OrdParamArr("OrderMultiDate")=""
	s OrdParamArr("OrderPrice")=oeprice
	s OrdParamArr("LinkedMasterOrderPriorRowid")=""
	s OrdParamArr("OrderFreqDispTimeStr")=OrderFreqDispTimeStr
	s OrdParamArr("OrderFirstDayTimes")=FirstDayTimes
	s OrdParamArr("IsNotChangeFirstDayTimeFlag")="Y"
	s OrdParamArr("IsNotNeedChangeFlag")="N"
	s OrdParamArr("OrderFreqTimeDoseStr")=OrderFreqTimeDoseStr
	
	s OrdParamArr("OrderRecDepRowid")=RecDepRowid
	s OrdParamArr("SessionStr")=SessionStr
	s OrderMasterARCIMRowid=""
	if (OEORIOEORIDR'=""){
		s OrderMasterARCIMRowid=$P(^OEORD(+OEORIOEORIDR,"I",$P(OEORIOEORIDR,"||",2),1),"^",2)
	}
	s OrdParamArr("OrderMasterARCIMRowid")=OrderMasterARCIMRowid
	
	s OrdParamJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.OrdParamArr)
	s CalPackQtyJson=##Class(web.DHCOEOrdItemView).CalPackQty(OrdParamJson)
	k CalPackQtyArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(CalPackQtyJson,.CalPackQtyArr)
	q
}

/// 是否打印检验条码---该判断已弃用
ClassMethod IfPrintLabNo(oeordid, oeordsub)
{
	s find=0
	s resultid=0
	f  s resultid=$O(^OEORD(oeordid,"I",oeordsub,"RES",resultid)) q:resultid=""  d
	.s ResStatCode=""
	.s ResStatDR=$p($g(^OEORD(oeordid,"I",oeordsub,"RES",resultid)),"^",2)
	.i ResStatDR'="" s ResStatCode=$p($g(^OEC("RESST",ResStatDR)),"^",1)
	.i ResStatCode="PT" s find=1
	q find
}

/// 护士是否打印检验条码
ClassMethod IfNurPrintLabNo(oeordid, oeordsub)
{
	s find=0
	s OEOREChildsub1=0
	f  s OEOREChildsub1=$o(^OEORD(oeordid,"I",oeordsub,"X",OEOREChildsub1)) q:(OEOREChildsub1="")||(find="1")  d
	.s OEOREPrinted=$p($g(^OEORD(oeordid,"I",oeordsub,"X",OEOREChildsub1,"NUR")),"^",1)
	.i ("-"_OEOREPrinted_"-")[("-P-") s find=1
	q find
}

/// 附加医嘱设定(按医嘱)
ClassMethod GetOrdItemAppendItem(Adm As %String, MasterSeqNo As %String, SessionStr As %String, ByRef OrdCongeriesArr) As %String
{
	s AppendItemStr=""
	s OrdItem=$G(OrdCongeriesArr(MasterSeqNo))
	Q:OrdItem="" ""
	s OrdMasterSeqNo=$p(OrdItem,"^",19)
	Q:OrdMasterSeqNo'="" ""
	s Loc=$P(SessionStr,"^",3)
	s ImportByContingences=$p(OrdItem,"^",75)
	Q:ImportByContingences="Y" ""
	s PriorRowid=$p(OrdItem,"^",3)
	s OnePriorRowid=+$O(^OECPR(0,"Code","ONE",0))
	;取药医嘱不进行用法绑定
	Q:(PriorRowid=OnePriorRowid) ""
	s ARCIMRowid=$p(OrdItem,"^",1)
  	s OrderOpenForAllHosp=$p(OrdItem,"^",68)
  	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	;DHCIAAddItmDR_$C(1)_DHCIAQty_$c(1)_DHCIARecLocId_$C(1)_DHCIAInstrId_$C(1)_OrderOpenForAllHosp
	s AppendItemStr=##class(DHCDoc.DHCDocConfig.Items).GetItmAddItem(ARCIMRowid,Loc,OrderOpenForAllHosp,HospitalId, Adm)
	s AppendItemStr=..SetAppendItemSource(AppendItemStr, MasterSeqNo)
	;处理子医嘱按医嘱绑定的医嘱项
	s SubSeqNo=0
	for {
		s SubSeqNo=$o(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo)) Q:SubSeqNo=""
		s subOrdItem=$G(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo))
		s subARCIMRowid=$p(subOrdItem,"^",1)
		s subBondSorce=$P(subOrdItem,"^",58)
		s subOrderOpenForAllHosp=$p(subOrdItem,"^",68)
		if (subBondSorce'="") continue
		s subAppendItemStr=##class(DHCDoc.DHCDocConfig.Items).GetItmAddItem(subARCIMRowid,Loc,subOrderOpenForAllHosp,HospitalId,Adm)
		if (subAppendItemStr'=""){
			s subAppendItemStr=..SetAppendItemSource(subAppendItemStr, MasterSeqNo_"."_SubSeqNo)
			i AppendItemStr="" s AppendItemStr=subAppendItemStr
			e  s AppendItemStr=AppendItemStr_"^"_subAppendItemStr
		}
	}
	Q AppendItemStr
}

/// 设置绑定医嘱的来源医嘱编号
ClassMethod SetAppendItemSource(AppendItemStr, SeqNo) [ Private ]
{
	q:(AppendItemStr="") ""
	for i=1:1:$L(AppendItemStr,"^") {
		s AddItem=$P(AppendItemStr,"^",i)
		s $P(AddItem,$c(1),14)=SeqNo
		s $P(AppendItemStr,"^",i)=AddItem
	}
	q AppendItemStr
}

ClassMethod GetOrdCatAppendItem(Adm As %String, MasterSeqNo As %String, SessionStr As %String, ByRef OrdCongeriesArr) As %String
{
	s AppendItemStr=""
	s OrdItem=$G(OrdCongeriesArr(MasterSeqNo))
	Q:OrdItem="" ""
	s OrdMasterSeqNo=$p(OrdItem,"^",19)
	Q:OrdMasterSeqNo'="" ""
	s Loc=$P(SessionStr,"^",3)
	s ImportByContingences=$p(OrdItem,"^",75)
	Q:ImportByContingences="Y" ""
	s PriorRowid=$p(OrdItem,"^",3)
	s OnePriorRowid=+$O(^OECPR(0,"Code","ONE",0))
	;取药医嘱不进行用法绑定
	Q:(PriorRowid=OnePriorRowid) ""
	s ARCIMRowid=$p(OrdItem,"^",1)
	s OrderOpenForAllHosp=$p(OrdItem,"^",68)
	s ARCIMItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	;DHCIAAddItmDR_$C(1)_DHCIAQty_$C(1)_DHCIARecLocId_$C(1)_DHCIAInstrId_$C(1)_OrderOpenForAllHosp
	s AppendItemStr=##class(DHCDoc.DHCDocConfig.AppendItemInItemCat).GetCatItmAddItem(ARCIMItemCatDR,Loc,OrderOpenForAllHosp,HospitalId,Adm)
	;处理子医嘱按子类绑定的医嘱项
	s SubSeqNo=0
	for {
		s SubSeqNo=$o(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo)) Q:SubSeqNo=""
		s subOrdItem=$G(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo))
		s subARCIMRowid=$p(subOrdItem,"^",1)
		s subBondSorce=$P(subOrdItem,"^",58)
		s subOrderOpenForAllHosp=$p(subOrdItem,"^",68)
		if (subBondSorce'="") continue
		s subARCIMCatDR=$p(^ARCIM(+subARCIMRowid,$p(subARCIMRowid,"||",2),1),"^",10)
		if (ARCIMItemCatDR=subARCIMCatDR) continue
		s subAppendItemStr=##class(DHCDoc.DHCDocConfig.AppendItemInItemCat).GetCatItmAddItem(subARCIMRowid,Loc,subOrderOpenForAllHosp,HospitalId,Adm)
		if (subAppendItemStr'=""){
			i AppendItemStr="" s AppendItemStr=subAppendItemStr
			e  s AppendItemStr=AppendItemStr_"^"_subAppendItemStr
		}
	}
	Q AppendItemStr
}

ClassMethod GetOrdInstrAppendItem(Adm As %String, MasterSeqNo As %String, SessionStr As %String, ByRef OrdCongeriesArr) As %String
{
	s AppendItemStr=""
	s Loc=$P(SessionStr,"^",3)
	;不需要用法绑定医嘱
	s NotNeedInstrArcim=$$GetDHCCTLOCFieldValue^DHCDocConfig(Loc,6)
	Q:NotNeedInstrArcim=1 ""
	s OrdItem=$G(OrdCongeriesArr(MasterSeqNo))
	Q:OrdItem="" ""
	s OrdMasterSeqNo=$p(OrdItem,"^",19)
	Q:(OrdMasterSeqNo'="") ""
	s ImportByContingences=$p(OrdItem,"^",75)
	Q:ImportByContingences="Y" ""
	s PriorRowid=$p(OrdItem,"^",3)
	s OnePriorRowid=+$O(^OECPR(0,"Code","ONE",0))
	s OutPriorRowid=+$O(^OECPR(0,"Code","OUT",0))
	Q:(PriorRowid=OnePriorRowid)||(PriorRowid=OutPriorRowid) ""
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	
	s InstrRowId=$p(OrdItem,"^",17)
	s CFInstrRowId=InstrRowId_"||"_HospitalId
	s OrderOpenForAllHosp=$p(OrdItem,"^",68)
	if $g(InstrRowId)'="" {
		if AdmType="I" {
			Set AppendItemStr=$$getconfignode1^DHCDocConfig("InstrIPArcim",CFInstrRowId)
		}else{
			Set AppendItemStr=$$getconfignode1^DHCDocConfig("InstrArcim",CFInstrRowId)
		}
	}
	;例外的医嘱项
	if (AdmType="I") {
		s ExcludeArcimStr=$G(^DHCDocConfig("InstrIPArcim",CFInstrRowId,"ExcludeArcim"))
	}else{
		s ExcludeArcimStr=$G(^DHCDocConfig("InstrArcim",CFInstrRowId,"ExcludeArcim"))
	}
	s ARCIMRowid=$p(OrdItem,"^",1)
	Q:("^"_ExcludeArcimStr_"^")[("^"_ARCIMRowid_"^") ""
	;例外的医嘱类型
	if (AdmType="I") {
		s ExcluedePriorStr=..%GetConfig("IInstrAutoLinkOrdExcludePrior",HospitalId)
	}else{
		s ExcluedePriorStr=..%GetConfig("OInstrAutoLinkOrdExcludePrior",HospitalId)
	}
	if ("^"_ExcluedePriorStr_"^")[("^"_PriorRowid_"^") {
		s AppendItemStr=""
	}
	s NotAppendOrdFlag=0
	;处理子医嘱按用法绑定医嘱
	s GroupFlag=0
	s SubSeqNo=0
	for {
		s SubSeqNo=$o(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo)) Q:SubSeqNo=""
		s subOrdItem=$G(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo))
		s subARCIMRowid=$p(subOrdItem,"^",1)
		if ("^"_ExcludeArcimStr_"^")[("^"_subARCIMRowid_"^"){
			s NotAppendOrdFlag=1
		}
		s GroupFlag=1
		s subBondSorce=$P(subOrdItem,"^",58)
		s subInstrRowId=$p(subOrdItem,"^",17)
		s subOrderOpenForAllHosp=$p(subOrdItem,"^",68)
		if (subInstrRowId=InstrRowId)&&(AppendItemStr'=""){
			//主医嘱有可能是因为例外医嘱类型配置，导致没有绑定医嘱，但是子医嘱可能需要绑定
			continue
		}
		s subPriorRowid=$p(subOrdItem,"^",3)
		if ("^"_ExcluedePriorStr_"^")[("^"_subPriorRowid_"^"){
			continue
		}
		if (subPriorRowid=OnePriorRowid)||(subPriorRowid=OutPriorRowid) {
			s NotAppendOrdFlag=1
		}
		;处理主子医嘱用法不同时,子医嘱按用法绑定医嘱设置
		if (+subARCIMRowid'=0)&&(subBondSorce="")&&(subInstrRowId'=""){
			 s SubCFInstrRowId=subInstrRowId_"||"_HospitalId
			 if AdmType="I" {
				Set SubAppendItemStr=$$getconfignode1^DHCDocConfig("InstrIPArcim",SubCFInstrRowId)
			 }else{
				Set SubAppendItemStr=$$getconfignode1^DHCDocConfig("InstrArcim",SubCFInstrRowId)
			 }
			 if (SubAppendItemStr'="") {
				 if (AppendItemStr="") s AppendItemStr=SubAppendItemStr
				 else  s AppendItemStr=AppendItemStr_"^"_SubAppendItemStr
			 }
		}
	}
	Q:(NotAppendOrdFlag=1) ""
	s AppendItemStr=##Class(DHCDoc.DHCDocConfig.InstrArcim).CheckInstrAppendItemStr(AppendItemStr,Loc)
	s NewAppendItemStr=""
	for i=1:1:$l(AppendItemStr,"^") {
		s AppendItemNod=$p(AppendItemStr,"^",i)
		continue:AppendItemNod=""
		s OnlyGroupOrdBind=$p(AppendItemNod,"!",9)
		continue:(OnlyGroupOrdBind="1")&&'GroupFlag
		s ageFrom=$p(AppendItemNod,"!",7)
		s ageTo=$p(AppendItemNod,"!",8)
		s PatientID=$P(^PAADM(Adm),"^",1)
		s PatDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
		s Age=$$CalAge^at182(PatDOB,+$H,"","","")
		s Age=$p(Age,"|",12)
		continue:(Age<ageFrom)&&(ageFrom'="")
		continue:(Age>ageTo)&&(ageTo'="")
		s ArcimRowid=$p(AppendItemNod,"!",1)
		s ByDay=$p(AppendItemNod,"!",2)
		s InfusionFeeFlag=$p(AppendItemNod,"!",3)
		s Qty=$p(AppendItemNod,"!",5)
		s InstrRecLocDr=$p(AppendItemNod,"!",6)
		s oneAppendItem=ArcimRowid_$C(1)_Qty_$C(1)_""_$C(1)_""_$C(1)_OrderOpenForAllHosp_$C(1)_ByDay_$C(1)_""_$C(1)_""_$C(1)_""_$C(1)_"IS"_$c(1)_InstrRecLocDr
		if (NewAppendItemStr="") s NewAppendItemStr=oneAppendItem
		else  s NewAppendItemStr=NewAppendItemStr_"^"_oneAppendItem
	}
	Q NewAppendItemStr
}

ClassMethod GetOrdActionAppendItem(Adm As %String, MasterSeqNo As %String, ByRef OrdCongeriesArr) As %String
{
	s AppendItemStr=""
	s OrdItem=$G(OrdCongeriesArr(MasterSeqNo))
	Q:OrdItem="" ""
	s OrdMasterSeqNo=$p(OrdItem,"^",19)
	Q:OrdMasterSeqNo'="" ""
	s ImportByContingences=$p(OrdItem,"^",75)
	Q:ImportByContingences="Y" ""
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	s InstrRowId=$p(OrdItem,"^",17)
	s SkinTest=$p(OrdItem,"^",21)
	s ActionRowid=$p(OrdItem,"^",24)
	s OrderOpenForAllHosp=$p(OrdItem,"^",68)
	if ActionRowid'="" {
		Set ACTIRowid=0
		For {
			s ACTIRowid=$O(^OEC("ACT",ActionRowid,"Item",ACTIRowid)) q:ACTIRowid=""
			s ACTIHospDr=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",4)
			continue:ACTIHospDr'=HospitalId
			s ACTIARCIMDR=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",1)
			s ACTIQty=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",2)
			s ACTInstrDr=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",3)
			if (InstrRowId'=ACTInstrDr)&&(ACTInstrDr'="") continue
			s ACTIDoseQty=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",5)
			s ACTIDoseUomDR=$p($g(^OEC("ACT",ActionRowid,"Item",ACTIRowid)),"^",6)
			s oneAppendItem=ACTIARCIMDR_$C(1)_ACTIQty_$C(1)_""_$C(1)_""_$C(1)_OrderOpenForAllHosp_$C(1)_""_$C(1)_ACTIDoseQty_$C(1)_ACTIDoseUomDR_$C(1)_""_$C(1)_"SK"
			i AppendItemStr="" {
				;DHCIAAddItmDR_$C(1)_DHCIAQty_$C(1)_DHCIARecLocId_$C(1)_DHCIAInstrId_$C(1)_OrderOpenForAllHosp
				s AppendItemStr=oneAppendItem
			}else{
				s AppendItemStr=AppendItemStr_"^"_oneAppendItem
			}
		}
	}
	;处理子医嘱按皮试备注绑定
	s SubSeqNo=0
	for {
		s SubSeqNo=$o(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo)) Q:SubSeqNo=""
		s subOrdItem=$G(OrdCongeriesArr(MasterSeqNo,"sub",SubSeqNo))
		s subARCIMRowid=$p(subOrdItem,"^",1)
		s subInstrRowId=$p(subOrdItem,"^",17)
		s subActionRowid=$p(subOrdItem,"^",24)
		s subOrderOpenForAllHosp=$p(subOrdItem,"^",68)
		;主子医嘱皮试备注相同时不能重复绑定
		;子医嘱皮试备注为空不绑定
		if (subActionRowid=ActionRowid)||(subActionRowid="") continue
		s ACTIRowid=0
		For {
			s ACTIRowid=$O(^OEC("ACT",subActionRowid,"Item",ACTIRowid)) q:ACTIRowid=""
			s ACTIHospDr=$p($g(^OEC("ACT",subActionRowid,"Item",ACTIRowid)),"^",4)
			continue:ACTIHospDr'=HospitalId
			s ACTIARCIMDR=$p($g(^OEC("ACT",subActionRowid,"Item",ACTIRowid)),"^",1)
			s ACTIQty=$p($g(^OEC("ACT",subActionRowid,"Item",ACTIRowid)),"^",2)
			s ACTInstrDr=$p($g(^OEC("ACT",subActionRowid,"Item",ACTIRowid)),"^",3)
			if (subInstrRowId'=ACTInstrDr)&&(ACTInstrDr'="") continue
			s ACTIDoseQty=$p($g(^OEC("ACT",subActionRowid,"Item",ACTIRowid)),"^",5)
			s ACTIDoseUomDR=$p($g(^OEC("ACT",subActionRowid,"Item",ACTIRowid)),"^",6)
			s oneAppendItem=ACTIARCIMDR_$C(1)_ACTIQty_$C(1)_""_$C(1)_""_$C(1)_subOrderOpenForAllHosp_$C(1)_""_$C(1)_ACTIDoseQty_$C(1)_ACTIDoseUomDR_$C(1)_""_$C(1)_"SK"
			i AppendItemStr="" {
				s AppendItemStr=oneAppendItem
			}else{
				s AppendItemStr=AppendItemStr_"^"_oneAppendItem
			}
		}
	}
	Q AppendItemStr
}

ClassMethod GetAppendItemPrior(OrderType As %String, PriorRowid As %String) As %String
{
	if OrderType'="R" {
		if PriorRowid=+$O(^OECPR(0,"Code","ONE",0)) s PriorRowid=$O(^OECPR(0,"Code","NORM",0)) 
	}
	if PriorRowid=+$O(^OECPR(0,"Code","OM",0)) s PriorRowid=$O(^OECPR(0,"Code","NORM",0))
	if PriorRowid=+$O(^OECPR(0,"Code","OMST",0)) s PriorRowid=$O(^OECPR(0,"Code","S",0)) 
	if PriorRowid=+$O(^OECPR(0,"Code","OMCQZT",0)) s PriorRowid=$O(^OECPR(0,"Code","S",0)) 
	if PriorRowid=+$O(^OECPR(0,"Code","OMLSZT",0)) s PriorRowid=$O(^OECPR(0,"Code","NORM",0))
	Q PriorRowid
}

ClassMethod GetAppendItemPrice(EpisodeID As %String, ArcimRowid As %String, RecLoc As %String, AdmReason As %String) As %String
{
	
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s PatType=$P(^PAADM(EpisodeID,1),"^",6)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s BillUOMRowID=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,AdmType)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s ExpStrin=PAADMRegConDisDR_"^^^"_EpisodeID_"^"_RecLoc_"^^"
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, AdmReason, ArcimRowid, +$h, "", "", "", "",HospitalId,ExpStrin)
	s Price=$P(retPrice,"^",1)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
	if (INCIRowid'="") {
		s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ArcimRowid,INCIRowid,BillUOMRowID)
		s Price=$fn(Price*ConFac,"",4)
	}
	Q Price
}

ClassMethod GetAppendItemRecLoc(Adm As %String, ARCIMRowid As %String, SessionStr As %String, PriorRowid As %String, OrderInstrRowid As %String, OrderOpenForAllHosp As %String, InstrRecLocID As %String = "") As %String
{
	s ^Tempscl("GetAppendItemRecLoc")=Adm_","_ARCIMRowid_","_SessionStr_","_PriorRowid_","_OrderInstrRowid_","_OrderOpenForAllHosp_","_InstrRecLocID

	s BaseParamObj=##class(DHCDoc.Util.ArrayData).%New()
	d BaseParamObj.SetAt(Adm,"EpisodeID")							//*就诊号,
	d BaseParamObj.SetAt(SessionStr,"SessionStr")					//*Session串，参照DHCDoc.Util.RegisteredObject->%SessionStr，主要应用为按登陆科室取接受科室、翻译两个场景,
	d BaseParamObj.SetAt(0,"OpenForAllHosp")						//*是否允许跨院接收，(1/0),
	d BaseParamObj.SetAt($case(OrderOpenForAllHosp,"Y":"1","1":"1",:"N"),"FindRecLocByLogonLoc")				//*是否按照登录科室获取接受科室，(1/0),
	d BaseParamObj.SetAt(InstrRecLocID,"DefaultReclocRowid")		//*期望的默认接受科室ID，可在使用医嘱套、存在常用用法或治疗指定接受科室时使用，未维护该接受科室时会忽略该参数,
	d BaseParamObj.SetAt(ARCIMRowid,"OrderARCIMRowid")				//*医嘱项ID,
	d BaseParamObj.SetAt(OrderInstrRowid,"OrderInstrRowid")			//:当前用法ID,用于获取用法接受科室,非必填
	d BaseParamObj.SetAt("","OrderDateStr")							//:医嘱开立时间，用于验证接受科室的上下班时间,默认按当前时间判断,非必填
	d BaseParamObj.SetAt(PriorRowid,"OrderPriorRowid")				//*医嘱优先级,
	d BaseParamObj.SetAt("","OrderPriorRemarksRowId")				//:附加说明(OM/ZT/ONE),可统一使用医嘱优先级，内部也会自动识别附加说明
	d BaseParamObj.SetAt("N","NotifyClinician")						//:医嘱加急标志(Y\N)
	
	s BaseParamJson=BaseParamObj.%ToJSON().Read()
	s RecLocJson=##Class(web.DHCDocOrderCommon).GetRecLocInfo(BaseParamJson)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RecLocJson,.RecLocArr)
	s CurrentRecLocStr=$G(RecLocArr("CurrentRecLocStr"))
	s DefaultInstrRecLocID = ""
	for i=1:1:$L(CurrentRecLocStr,$C(2)) {
        s ArrData = $P(CurrentRecLocStr,$C(2),i)
        if (($P(ArrData,$C(1),3)="Y") && (DefaultInstrRecLocID="")) {
            s DefaultInstrRecLocID = $P(ArrData,$C(1),1)
        }
       
    }
    if (DefaultInstrRecLocID = "") {
        s ArrData = $P(CurrentRecLocStr,$C(2),1)
        s DefaultInstrRecLocID = $P(ArrData,$C(1),1)
    }
	q DefaultInstrRecLocID
}

ClassMethod CheckItemAgeSexRestriction(AdmId As %String, ArcimId As %String) As %String
{
	s PatientID=$p(^PAADM(AdmId),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmId)
	s ASCheckStr=##Class(web.DHCDocOrderCommon).GetItemAgeSexRestriction(ArcimId,PatientID,HospID)
	Q +ASCheckStr
}

ClassMethod GetInstrNotInsertFlag(OrderSeqNo As %String, InstrRowid As %String, Startdate As %String, ByRef OrdCongeriesArr, ByRef OrdAddCongeriesArr) As %String
{
	;n (OrderSeqNo,InstrRowid,Startdate,OrdCongeriesArr,%session)
	s myflag=0
	s OrdItem=$G(OrdCongeriesArr(OrderSeqNo))
	s OrderSerialNum=$p(OrdItem,"^",87)
	s OrdCounter=""
	for {
		s OrdCounter=$O(OrdCongeriesArr(OrdCounter)) Q:(OrdCounter="")
		continue:OrdCounter>=OrderSeqNo
		s OrdItem=$G(OrdCongeriesArr(OrdCounter))
	    continue:OrdItem=""
	    s CurStartdate=$p(OrdItem,"^",4)
	    continue:CurStartdate'=Startdate
	    s CurInstrRowId=$p(OrdItem,"^",17)
	    continue:CurInstrRowId'=InstrRowid
		s myflag=1
		//遍历到第一条应该插入绑定医嘱的元医嘱，通过元医嘱找到对应的绑定费用，并把当前流水号更新到该绑定费用中
		s FirstOrderSerialNum=$p(OrdItem,"^",87)
		s SubCounter=""
		for {
			s SubCounter=$O(OrdAddCongeriesArr(SubCounter)) Q:(SubCounter="")
			s OrdItem=$G(OrdAddCongeriesArr(SubCounter,"OrdListInfo"))
	    	continue:OrdItem=""
			s BindSourceStr=$P(OrdItem,"^",91)
			if (BindSourceStr[FirstOrderSerialNum)&&(BindSourceStr'[OrderSerialNum){
				s BindSourceStr=BindSourceStr_"@"_OrderSerialNum
				s $P(OrdItem,"^",91)=BindSourceStr
				s OrdAddCongeriesArr(SubCounter,"OrdListInfo")=OrdItem
			}
		}
	    Q 
	}
	Q myflag
}

/// w ##class(web.DHCOEOrdAppendItem).GetOneOrdItemAppendTipInfo("1973","5302||1^L^3^2022-04-15^17:35:27^^20.0000^155^1^^^^^1^^^^^^1^N^^N^^^^^SP004^^N^^^^^^^^^^^^^^^^2022-04-15^17:35:27^N^^^^^N^^116^^N^^^^^^^^N^1^^0^^^^20.00^^^^^^1^N^^^^^^^^220415004092^^","17276^126^60^2^^20^26092")
/// $LG(^tan("GetOneOrdItemAppendTipInfo"),1),$LG(^tan("GetOneOrdItemAppendTipInfo"),2),$LG(^tan("GetOneOrdItemAppendTipInfo"),3)
ClassMethod GetOneOrdItemAppendTipInfo(Adm As %String, OrdItemStr As %String, SessionStr As %String) As %String
{
	;s:Adm=92 ^tan("GetOneOrdItemAppendTipInfo")=$LB(Adm,OrdItemStr,SessionStr)
	s retObj=[]
	
	k OrdAddCongeriesArr
	s Loc=$P(SessionStr,"^",3)
	s langid=$P(SessionStr,"^",6)
	s BaseParamObj=##class(DHCDoc.Util.ArrayData).%New()
	//预览时不做检验预览，防止出现检验号、处方号浪费的情况
	d BaseParamObj.SetAt(",BF,CT,SP,","DisBindTypeList")
	s BaseParamJson=BaseParamObj.%ToJSON().Read()

	d ..GetAppendOrdItemArr(Adm, OrdItemStr, Loc,.OrdAddCongeriesArr,SessionStr,BaseParamJson)
	s i=0 for{
		s i=$O(OrdAddCongeriesArr(i)) Q:(i="")
		s Item=$G(OrdAddCongeriesArr(i,"OrdListInfo"))
		continue:(Item="")
		s ARCIMRowid=$P(Item,"^",1)
		continue:(ARCIMRowid="")
		Set OEORIBindSource=$p(Item,"^",58) //医嘱绑定来源
		//continue:(OEORIBindSource="BF")
		s AppendQty=$P(Item,"^",6)	;PackQty
		s:AppendQty="" AppendQty=$P(Item,"^",14)	;DoseQtySum
		s:AppendQty="" AppendQty=$P(Item,"^",12)	;DoseQty
		s:AppendQty="" AppendQty=1
		s ARCIMDesc=$P(^ARCIM(+ARCIMRowid,1,1),"^",2)
		s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
		d retObj.%Push({"ARCIMDesc":(ARCIMDesc),"Qty":(AppendQty)})
	}
	Q retObj.%ToJSON()
}

}
