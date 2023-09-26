Import SQLUser

Class web.UDHCJFREBILL1 Extends BILL.COM.Abstract
{

/// Description: 门诊重新计算费用
/// Debug: w ##class(web.UDHCJFREBILL1).REBILLOP()
ClassMethod REBILLOP(Adm As %String, BILL As %String, InsTypeId As %String) As %String
{
	set $zt="ERROR"
	
	quit:((+Adm=0)||(+BILL=0)) -1_"^"_"参数错误"
	
	set PayedFlag=$p($g(^DHCPB(BILL)),"^",16)
	quit:(PayedFlag="P") -20001_"^"_"账单已结算"
	
	//set ^DHCBILLDEL(+$h,BILL)=Adm_"^"_BILL    //Lid 2020-10-13 BILL不一定是新、老账单，不能按删掉的账单记录
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	if (InsTypeId="") set InsTypeId=$p($g(^PAADM(Adm,1)),"^",7)

	set EpisSubType=$p($g(^PAADM(Adm,1)),"^",6)
	set RCDRowID=$p($g(^PAADM(Adm,"DHC")),"^",25)    //挂号优惠类型
	
	set TotalAmt=0
	set DiscAmt=0
	set PayOrAmt=0
	set PatShareAmt=0
	
	set rtn=0
    ts
	
	set PBO=0
	while($o(^DHCPB(BILL,"O",PBO))) {
		set PBO=$o(^DHCPB(BILL,"O",PBO))
		set PBOData=$g(^DHCPB(BILL,"O",PBO))
		continue:(PBOData="")
		set PBORowID=BILL_"||"_PBO
		set RefundFlag=$p(PBOData,"^",14)
		if (RefundFlag="Y") {
			set TotalAmt=$i(TotalAmt, $p(PBOData,"^",8))
			set DiscAmt=$i(DiscAmt, $p(PBOData,"^",9))
			set PayOrAmt=$i(PayOrAmt, $p(PBOData,"^",10))
			set PatShareAmt=$i(PatShareAmt, $p(PBOData,"^",11))
			continue
		}
		set OEORI=$p(PBOData,"^",4)
		continue:('$d(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)))
		set PriceDate=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),9),"^",15)    //OEORI_BillPriceDate +2019-01-29 ZhYW
		set OEPrice=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",25)
		set Arcim=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
		continue:('$d(^ARCIM(+Arcim,1)))
		set BillQty=$p(PBOData,"^",5)
		set RefundQty=$p(PBOData,"^",6)
		set Qty=BillQty+RefundQty
		set OEORE=""
		set RegLoc=""
		set ItmPriceExpStr=RCDRowID_"^"_OEORI_"^"_OEORE_"^"_Adm_"^"_RegLoc_"^"_Arcim
	    set PriceO=##class(web.UDHCJFPRICE).GetOrderPrice(EpisSubType, InsTypeId, Arcim, PriceDate, "", "", "", OEPrice, HospId, ItmPriceExpStr)
		set OrdPrice=$p(PriceO,"^",1)
		set OrdDiscPrice=$p(PriceO,"^",2)
		set OrdPayorPrice=$p(PriceO,"^",3)
		set OrdPatPrice=$p(PriceO,"^",4)
		set OrdTotalAmt=##class(web.UDHCJFBILL).round(OrdPrice*Qty)
		set OrdDiscAmt=##class(web.UDHCJFBILL).round(OrdDiscPrice*Qty)
		set OrdPayorAmt=##class(web.UDHCJFBILL).round(OrdPayorPrice*Qty)
		set OrdPatAmt=OrdTotalAmt-OrdDiscAmt-OrdPayorAmt
		&SQL(
			UPDATE DHC_PatBillOrder
			SET PBO_UnitPrice = :OrdPrice, PBO_DiscPrice = :OrdDiscPrice, PBO_InsPrice = :OrdPayorPrice, PBO_PatPrice = :OrdPatPrice,
				PBO_ToTalAmount = :OrdTotalAmt, PBO_DiscAmount = :OrdDiscAmt, PBO_PayorShare = :OrdPayorAmt, PBO_PatientShare = :OrdPatAmt
			WHERE %ID = :PBORowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set PBD=0
		while($o(^DHCPB(BILL,"O",PBO,"D",PBD))) {
			set PBD=$o(^DHCPB(BILL,"O",PBO,"D",PBD))
			set PBDData=$g(^DHCPB(BILL,"O",PBO,"D",PBD))
			continue:(PBDData="")
			set PBDRowID=BILL_"||"_PBO_"||"_PBD
			set Qty0=$p(PBDData,"^",5)
			set TarItem=$p(PBDData,"^",3)
			set ArtiDisc=$p(PBDData,"^",25)
			set ArtiDR=$p(PBDData,"^",26)	       //多部位申请单中间表指针
			set DspbDR=$p(PBDData,"^",27)
			set $p(ItmPriceExpStr,"^",8)=DspbDR    //wangjian 2018-06-12
			set Price=##class(web.UDHCJFPRICE).GetItmPrice(TarItem, PriceDate, InsTypeId, EpisSubType, OEPrice, HospId, ItmPriceExpStr)
			//+2017-07-04 ZhYW 将DHC_AppRepTarItm.ARTI_PBO_Dr 更新为新账单医嘱表指针
			if (ArtiDR>0) {
				&SQL(
					UPDATE DHC_AppRepTarItm
					SET ARTI_PBO_Dr = :PBORowID
					WHERE %ID = :ArtiDR
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			//
			set ItmPrice=$p(Price,"^",1)
			set ItmDiscPrice=$p(Price,"^",2)
			set ItmPayorPrice=$p(Price,"^",3)
			set ItmPatPrice=$p(Price,"^",4)
			if (ArtiDR>0) {
				set ItmPrice=ItmPrice*ArtiDisc
				set ItmDiscPrice=ItmDiscPrice*ArtiDisc
				set ItmPayorPrice=ItmPayorPrice*ArtiDisc
				set ItmPatPrice=ItmPrice-ItmDiscPrice-ItmPayorPrice
			}
			set ItmTotalAmt=##class(web.UDHCJFBILL).round(ItmPrice*Qty0)
			set ItmDiscAmt=##class(web.UDHCJFBILL).round(ItmDiscPrice*Qty0)
			set ItmPayorAmt=##class(web.UDHCJFBILL).round(ItmPayorPrice*Qty0)
			set ItmPatAmt=ItmTotalAmt-ItmDiscAmt-ItmPayorAmt
			&SQL(
				UPDATE DHC_PatBillDetails
				SET PBD_UnitPrice = :ItmPrice, PBD_DiscPrice = :ItmDiscPrice, PBD_InsPrice = :ItmPayorPrice, PBD_PatPrice = :ItmPatPrice,
					PBD_TotalAmount = :ItmTotalAmt, PBD_DiscAmount = :ItmDiscAmt, PBD_PayorShare = :ItmPayorAmt, PBD_PatientShare = :ItmPatAmt
				WHERE %ID = :PBDRowID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		//+2022-07-25 ZhYW 药品医嘱根据PBD更新PBO
		set OrdCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(Arcim, 0)
		if (OrdCateType="R") {
			set rtnValue=##class(web.UDHCJFBILL).PBOUpdateByPBD(PBORowID)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		set rtn=##class(web.UDHCJFBILL).UpdateOrdDetailBalance(OEORI)
		quit:(+rtn)
		set PBOData=$g(^DHCPB(BILL,"O",PBO))
		set PBOTotalAmt=$p(PBOData,"^",8)
		set PBODiscAmt=$p(PBOData,"^",9)
		set PBOPayOrAmt=$p(PBOData,"^",10)
		set PBOPatShareAmt=$p(PBOData,"^",11)
		set TotalAmt=$i(TotalAmt, PBOTotalAmt)
		set DiscAmt=$i(DiscAmt, PBODiscAmt)
		set PayOrAmt=$i(PayOrAmt, PBOPayOrAmt)
		set PatShareAmt=$i(PatShareAmt, PBOPatShareAmt)
	}
	if (+rtn) tro  quit rtn
	
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_PatInsType_DR = :InsTypeId, PB_TotalAmount = :TotalAmt, PB_DiscAmount = :DiscAmt, PB_PayorShare = :PayOrAmt,
			PB_PatientShare = :PatShareAmt, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW())
		WHERE %ID = :BILL
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc

	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: Lid
/// CreatDate: 2015-03-18
/// Description: 住院重新计算费用
/// Debug: w ##class(web.UDHCJFREBILL1).REBILLIP()
ClassMethod REBILLIP(Adm As %String, BILL As %String, InsTypeId As %String) As %String
{
	set $zt="ERROR"
	
	quit:((+Adm=0)||(+BILL=0)) -1_"^"_"参数错误"
	
	set PayedFlag=$p($g(^DHCPB(BILL)),"^",16)
	quit:(PayedFlag="P") -20001_"^"_"账单已结算"
	
	//set ^DHCBILLDEL(+$h,BILL)=Adm_"^"_BILL  //Lid 2020-10-13 BILL不一定是新、老账单，不能按删掉的账单记录
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	if (InsTypeId="") set InsTypeId=$p($g(^PAADM(Adm,1)),"^",7)
	
	set EpisSubType=$p($g(^PAADM(Adm,1)),"^",6)
	set RCDRowID=$p($g(^PAADM(Adm,"DHC")),"^",25)    //挂号优惠类型
	
	set TotalAmt=0
	set DiscAmt=0
	set PayOrAmt=0
	set PatShareAmt=0

	set rtn=0
    ts
	
	set PBO=0
	while($o(^DHCPB(BILL,"O",PBO))) {
		set PBO=$o(^DHCPB(BILL,"O",PBO))
		set PBOData=$g(^DHCPB(BILL,"O",PBO))
		continue:(PBOData="")
		set PBORowID=BILL_"||"_PBO
		set RefundFlag=$p(PBOData,"^",14)
		if (RefundFlag="Y") {
			set TotalAmt=$i(TotalAmt, $p(PBOData,"^",8))
			set DiscAmt=$i(DiscAmt, $p(PBOData,"^",9))
			set PayOrAmt=$i(PayOrAmt, $p(PBOData,"^",10))
			set PatShareAmt=$i(PatShareAmt, $p(PBOData,"^",11))
			continue
		}
		set OEORI=$p(PBOData,"^",4)
		continue:('$d(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)))
		set OEPrice=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",25)
		set Arcim=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
		continue:('$d(^ARCIM(+Arcim,1)))
		set BillQty=$p(PBOData,"^",5)
		set RefundQty=$p(PBOData,"^",6)
		set Qty=BillQty+RefundQty
		set OEORE=$p(PBOData,"^",20)
		set PriceDate=$p($g(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3))),"^",47)      //OEORE_BillPriceDate +2019-01-29 ZhYW
		set RegLoc=""
		set ItmPriceExpStr=RCDRowID_"^"_OEORI_"^"_OEORE_"^"_Adm_"^"_RegLoc_"^"_Arcim
	    set PriceO=##class(web.UDHCJFPRICE).GetOrderPrice(EpisSubType, InsTypeId, Arcim, PriceDate, "", "", "", OEPrice, HospId, ItmPriceExpStr)
		set OrdPrice=$p(PriceO,"^",1)
		set OrdDiscPrice=$p(PriceO,"^",2)
		set OrdPayorPrice=$p(PriceO,"^",3)
		set OrdPatPrice=$p(PriceO,"^",4)
		set OrdTotalAmt=##class(web.UDHCJFBILL).round(OrdPrice*Qty)
		set OrdDiscAmt=##class(web.UDHCJFBILL).round(OrdDiscPrice*Qty)
		set OrdPayorAmt=##class(web.UDHCJFBILL).round(OrdPayorPrice*Qty)
		set OrdPatAmt=OrdTotalAmt-OrdDiscAmt-OrdPayorAmt
		&SQL(
			UPDATE DHC_PatBillOrder
			SET PBO_UnitPrice = :OrdPrice, PBO_DiscPrice = :OrdDiscPrice, PBO_InsPrice = :OrdPayorPrice, PBO_PatPrice = :OrdPatPrice,
				PBO_ToTalAmount = :OrdTotalAmt, PBO_DiscAmount = :OrdDiscAmt, PBO_PayorShare = :OrdPayorAmt, PBO_PatientShare = :OrdPatAmt
			WHERE %ID = :PBORowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set PBD=0
		while($o(^DHCPB(BILL,"O",PBO,"D",PBD))) {
			set PBD=$o(^DHCPB(BILL,"O",PBO,"D",PBD))
			set PBDData=$g(^DHCPB(BILL,"O",PBO,"D",PBD))
			continue:(PBDData="")
			set PBDRowID=BILL_"||"_PBO_"||"_PBD
			set TarItem=$p(PBDData,"^",3)
			set Qty0=$p(PBDData,"^",5)
			set ArtiDisc=$p(PBDData,"^",25)
			set ArtiDR=$p(PBDData,"^",26)	       //多部位申请单中间表指针
			set DspbDR=$p(PBDData,"^",27)
			set $p(ItmPriceExpStr,"^",8)=DspbDR    //wangjian 2018-06-12
			set Price=##class(web.UDHCJFPRICE).GetItmPrice(TarItem, PriceDate, InsTypeId, EpisSubType, OEPrice, HospId, ItmPriceExpStr)
			//+2017-07-04 ZhYW 将DHC_AppRepTarItm.ARTI_PBO_Dr 更新为新账单医嘱表指针
			if (ArtiDR>0) {
				&SQL(
					UPDATE DHC_AppRepTarItm
					SET ARTI_PBO_Dr = :PBORowID
					WHERE %ID = :ArtiDR
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
			//
			set ItmPrice=$p(Price,"^",1)
			set ItmDiscPrice=$p(Price,"^",2)
			set ItmPayorPrice=$p(Price,"^",3)
			set ItmPatPrice=$p(Price,"^",4)
			if (ArtiDR>0) {
				set ItmPrice=ItmPrice*ArtiDisc
				set ItmDiscPrice=ItmDiscPrice*ArtiDisc
				set ItmPayorPrice=ItmPayorPrice*ArtiDisc
				set ItmPatPrice=ItmPrice-ItmDiscPrice-ItmPayorPrice
			}
			set ItmTotalAmt=##class(web.UDHCJFBILL).round(ItmPrice*Qty0)
			set ItmDiscAmt=##class(web.UDHCJFBILL).round(ItmDiscPrice*Qty0)
			set ItmPayorAmt=##class(web.UDHCJFBILL).round(ItmPayorPrice*Qty0)
			set ItmPatAmt=ItmTotalAmt-ItmDiscAmt-ItmPayorAmt
			&SQL(
				UPDATE DHC_PatBillDetails
				SET PBD_UnitPrice = :ItmPrice, PBD_DiscPrice = :ItmDiscPrice, PBD_InsPrice = :ItmPayorPrice, PBD_PatPrice = :ItmPatPrice,
					PBD_TotalAmount = :ItmTotalAmt, PBD_DiscAmount = :ItmDiscAmt, PBD_PayorShare = :ItmPayorAmt, PBD_PatientShare = :ItmPatAmt
				WHERE %ID = :PBDRowID
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
		//+2022-07-25 ZhYW 药品医嘱根据PBD更新PBO
		set OrdCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(Arcim, 0)
		if (OrdCateType="R") {
			set rtnValue=##class(web.UDHCJFBILLIP).PBOUpdateByPBD(PBORowID)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		set rtn=##class(web.UDHCJFBILLIP).UpdateOrdDetailBalance(OEORE)
		quit:(+rtn)
		set PBOData=$g(^DHCPB(BILL,"O",PBO))
		set PBOTotalAmt=$p(PBOData,"^",8)
		set PBODiscAmt=$p(PBOData,"^",9)
		set PBOPayOrAmt=$p(PBOData,"^",10)
		set PBOPatShareAmt=$p(PBOData,"^",11)
		set TotalAmt=$i(TotalAmt, PBOTotalAmt)
		set DiscAmt=$i(DiscAmt, PBODiscAmt)
		set PayOrAmt=$i(PayOrAmt, PBOPayOrAmt)
		set PatShareAmt=$i(PatShareAmt, PBOPatShareAmt)
	}
	if (+rtn) tro  quit rtn
	
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_PatInsType_DR = :InsTypeId, PB_TotalAmount = :TotalAmt, PB_DiscAmount = :DiscAmt, PB_PayorShare = :PayOrAmt,
			PB_PatientShare = :PatShareAmt, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW())
		WHERE %ID = :BILL
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc

	quit rtn

ERROR
	quit ..AppException()
}

}
