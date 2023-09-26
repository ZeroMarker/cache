Import SQLUser

Class web.DHCOPINVQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

///  /用来做票据的查询
ClassMethod INVOrdDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = INVOrdDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod INVOrdDetailsExecute(ByRef qHandle As %Binary, INVRowID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;w "---------",!
	i INVRowID=""  {
		;w OrderRowid_"--------------------",!
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	;循环取出医嘱
	
	;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	s bill=""
	s INVConDr=""
	f  s INVConDr=$o(^DHCBCI(0,"INV",INVRowID,INVConDr)) q:INVConDr=""  d
	.s bill=$p(^DHCBCI(INVConDr),"^",2)					;DHC_PatientBill->Dr
	.s PBOChildsub=0  f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:PBOChildsub=""  d
	..s Prescno=""
	..s Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s BillSubDR=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",9) 
	..;s OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)
	..s ORCATDesc=$p(^ARCBG($p(BillSubDR,"||",1)),"^",2)
	..s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2) ;名称
	..s ArcimUomrowid=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),8)),"^",14) ;计价单位  库存单位?
	..i ArcimUomrowid'="" d
	...s PBDItemUomDesc=$p($g(^CT("UOM",ArcimUomrowid)),"^",2) ;计价单位描述
	..e  d
	...s PBDItemUomDesc=""	
	..s OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
	..s billflag=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",5)
	..s oederstatus=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)
	..s Prescno=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",14) ;处方号
	..;w OEORI_billflag_oederstatus
	..;s partflag=1		;代表部分结帐标志?false 表示不结帐   true表示结帐?
	..;if (ordItmridstr[OEORI) s partflag=0     ;如果包含?代表不结帐?
	..;s ordinstype=$p(^OEORD($p(OEORI,"||",1),"I",$p(OEORI,"||",2),11),"^",18)  ;OE_OrdItem->OEORI_BBExtCode
	..;不要这个条件		i (billflag="B")&(oederstatus'="4")&(partflag=1)&&(ordinstype=instypenot)  d
	...s ItemGroup=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),6)),"^",1) ;组别
	...s OEQty=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),9)),"^",4) ;整包装数量
	...i (OEQty="")!(OEQty="0")  d 
	....s OEQty=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",12) ;OE_OrdItem->OEORI_PhQtyOrd
	...s recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	...s recdepdesc=$p(^CTLOC(recdepcode),"^",2)
	...i (reclocFlag=0) d
		....s reclocnot="RecID"				;;定值
	...e  d
		....s reclocnot=recdepcode
	...s loctype=$p(^CTLOC(recdepcode),"^",13) 
	...s OrderUnitPrice=$p(^DHCPB(bill,"O",PBOChildsub),"^",7)
	...s OrdPatShare=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
	...s OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)
	...s OrderSum=OrderUnitPrice*OrderBillQty
	...s itmnum=0
	...s PBOrderRowid=bill_"||"_PBOChildsub       ;把账单医嘱考虑在内
	...s PBDChildsub=0 f  s PBDChildsub=$o(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub)) q:PBDChildsub=""  d
	....s PBDRowid=bill_"||"_PBOChildsub_"||"_PBDChildsub
	....s PBDItemDR=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",3)
	....s PBDUnitprice=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",4)
	....s PBDPatShare=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",10)
	....s OEPrice=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",7)
	....s OEunitPrice=OEPrice/OEQty
	....s PBDQty=$p(^DHCPB(bill,"O",PBOChildsub,"D",PBDChildsub),"^",5)
	....s PBDItemdesc=$p(^DHCTARI(PBDItemDR),"^",2) ;收费项目描述
	....;s PBDItemUom=$p(^DHCTARI(PBDItemDR),"^",3) ;收费项目单位rowid
	....;s PBDItemUomDesc=$p(^CT("UOM",PBDItemUom),"^",2) ;收费项目单位描述
	....i itemFlag=0 
	....s PBDCatsub=$p(^DHCTARI(PBDItemDR),"^",15) ;门诊子类DHC_TarItem->TARI_OutpatCate	
	....i PBDCatsub="" d
	.....&sql(select taroc_tartoc_dr into :PBDCat from DHC_TarOutpatCate where taroc_desc='其他费')
	.....s PBDCat=$p(PBDCat,$C(1))
	.....if $d(^DHCTarC("TOC",PBDCat)) d  s PBCCatdesc=$p(^DHCTarC("TOC",PBDCat),"^",2)
	....e  d
	.....s PBDCat=$p(^DHCTarC("OC",PBDCatsub),"^",3) ;门诊大类DHC_TarOutpatCate->TAROC_TARTOC_DR
	....i (itemFlag=0) d
		.. ...s itemsubnot="ItemID"	;;定值
	....e  d
		.. ...s itemsubnot=PBDCatsub
	....if $d(^DHCTarC("TOC",PBDCat))  d  s PBCCatdesc=$p(^DHCTarC("TOC",PBDCat),"^",2) ;DHC_TarOC->
	....;w PBCCatdesc,!
	....s Price=OEPrice
	....s OEQtyUom=OEQty_$c(1)_PBDItemUomDesc
	....s itmnum=itmnum+1
	....s ^TMP1("OPITEM",$j,instypenot,PBOrderRowid,reclocnot,itemsubnot,itmnum)=Arcim_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBDItemDR_"^"_PBDItemdesc_"^"_Price_"^"_PBDQty_"^"_PBDCat_"^"_PBCCatdesc_"^"_PBDCatsub_"^"_PBDUnitprice_"^"_PBDPatShare
	...s PBOrderRowid=bill_"||"_PBOChildsub
	...s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	...s OrderType=$p(^ARC("IC",ARCCATRowid),"^",7)
	...s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid,"ItmNum")=itmnum	;费用项数量?
	...s ^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid)=ArcimDesc_"^"_OEORI_"^"_recdepcode_"^"_recdepdesc_"^"_PBOrderRowid_"^"_OrderUnitPrice_"^"_OrderBillQty_"^"_OrderSum_"^"_OrderType_"^"_Prescno_"^"_ORCATDesc_"^"_ItemGroup_"^"_loctype_"^"_bill_"^"_OrdPatShare

	Do OutputRowOrd
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowOrd
	set Data=$lb(ARCIMDesc,ARCIMRegu,ARCIMPrice,ARCIMQty,ARCIMPay)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
ResetVariablesOrd
	s (ARCIMDesc,ARCIMRegu,ARCIMPrice,ARCIMQty,ARCIMPay)=""
	quit
}

ClassMethod INVOrdDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = INVOrdDetailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {			
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query INVOrdDetails(INVRowID As %String = "") As %Query(ROWSPEC = "ARCIMDesc:%String:"""",ARCIMRegu:%String,ARCIMPrice:%String,ARCIMQty:%String,ARCIMPay:%String")
{
}

}
