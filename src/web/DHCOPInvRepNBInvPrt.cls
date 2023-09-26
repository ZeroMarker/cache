Class web.DHCOPInvRepNBInvPrt Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 41;

ClassMethod DateFMat(pdate, num)
{
	;w ##class(web.DHCOPInvFRepJSTEwStat).DateFMat(pdate, num)
	
	s pdate=$zd($zdh(pdate,num),3)
	
	q pdate
}

ClassMethod GetOPINVDetail(JSFunName As %String, ReceipID As %String) As %String
{
	; 打印明细清单

	;s ^yany=JSFunName_"^"_ReceipID

	;w ##class(web.DHCOPInvRepNBInvPrt).GetOPINVDetail("WrtExcle","1664")
	
	Quit:$g(ReceipID)=""
	
	s SelectPrtDr=ReceipID

	Kill ^TMP($ZN,$j)
	
	s myidx=""
	s INVLinkDr=""
	;获取中草药配制            ？？
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	s HerbIdx=0						;;草药费明细索引
	
	;Add an Index for RecLoc
	;西药，成药，草药，
	
	;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})

	d ..GetPrtFeeDetail(ReceipID)
	

	s myidx=""

	;s ^TMPInvPrtD($ZN,$j,"D",idx)=idx_"^"_ItemDesc_"^"_ItmUPrice_"^"_ItmQty_"^"_UDesc_"^"_ItmTotalAmount
	s myidx=""
	s SumXJ=0.00
	f  s myidx=$o(^TMPInvPrtD($ZN,$j,"D",myidx)) q:myidx=""  d 
	.q:($d(^TMPInvPrtD($ZN,$j,"D",myidx))=10)
	.s SumXJ=SumXJ+$p($g(^TMPInvPrtD($ZN,$j,"D",myidx)),"^",6)	;ItmTotalAmount
	.s myList=^TMPInvPrtD($ZN,$j,"D",myidx)
	.s rtnval=JSFunName_"('"_$ZCVT($g(myList),"O","JS")_"');"
	.&javascript<#(rtnval)#>
	
	;idx_"^"_ItemDesc_"^"_ItmUPrice_"^"_ItmQty_"^"_UDesc_"^"_ItmTotalAmount
	
	s SumXJ=$fn(SumXJ,"",2)
	q:(SumXJ="0.00")
	s myList=""_"^"_"合计："_"^^^^"_SumXJ
	s rtnval=JSFunName_"('"_$ZCVT($g(myList),"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	
	KILL ^TMPInvPrtD($ZN,$j)
	Quit "0"
}

ClassMethod GetPrtFeeDetail(ReceipID)
{
	;w ##class(web.DHCOPInvRepNBInvPrt).GetPrtFeeDetail("1664")

	s BciId=""			;DHC_BillConINV
    s idx=0
	f  s BciId=$o(^DHCBCI(0,"INV",ReceipID,BciId)) q:BciId=""  d
	.q:($d(^DHCBCI(BciId))=10)
	.s PBId=$p($g(^DHCBCI(BciId)),"^",2)			;DHCBCI_PatBillDR
	.s PBOSubId="0"
	.f  s PBOSubId=$o(^DHCPB(PBId,"O",PBOSubId)) q:PBOSubId=""  d
	..q:($d(^DHCPB(PBId,"O",PBOSubId))=10)
	..d AddJfItmToDetails(PBId,PBOSubId)
	
	Quit $$$OK

AddJfItmToDetails(PBId,PBOSubId)
	q:'$d(^DHCPB(PBId,"O",PBOSubId))

	s PBDSubId="0"		;DHC_PatBillDetails
	f  s PBDSubId=$o(^DHCPB(PBId,"O",PBOSubId,"D",PBDSubId))  q:PBDSubId=""  d
	.q:($d(^DHCPB(PBId,"O",PBOSubId,"D",PBDSubId))=10)
	.b ; ItemDesc
	.s TMPData=$g(^DHCPB(PBId,"O",PBOSubId,"D",PBDSubId))
	.s ItemDesc=""
	.s UDesc=""
	.s ItemId=$p(TMPData,"^",3)					;PBD_TARI_DR ;DHC_TarItem	;^TMP($ZN,$j,"D",myIOPCatDR)
	.i ItemId'="" d 
	..s ItemDesc=$p($g(^DHCTARI(ItemId)),"^",2)	;TARI_Desc
	..s UOMId=$p($g(^DHCTARI(ItemId)),"^",3) 	;TARI_UOM---> CT_UOM 
	..s UDesc=$p($g(^CT("UOM",UOMId)),"^",2)	;CTUOM_Desc
	.                    
	.s ItmUPrice=$fn($p(TMPData,"^",4),"",4)		;PBD_UnitPrice
	.s ItmQty=$p(TMPData,"^",5)						;PBD_BillQty
	.s ItmTotalAmount=$fn($p(TMPData,"^",10),"",2)	;PBD_TotalAmount
	.
	.s ^TMPInvPrtD($ZN,$j,"D",idx)=(idx+1)_"^"_ItemDesc_"^"_ItmUPrice_"^"_ItmQty_"^"_UDesc_"^"_ItmTotalAmount
	.s idx=idx+1
	
	q
}

ClassMethod GetUomConvFactor(ARCIM As %String) As %String
{
	;w ##class(web.DHCOPInvFRepJSTInvPrt).GetUomConvFactor("2719||1")
	Set inci=$o(^INCI(0,"ARCIM_DR",+ARCIM,""))   ;INC_Itm
	Quit:inci="" 1
	Set BaseUom=$p(^INCI(inci,1),"^",10)
	Set BillUom=$p(^ARCIM(+ARCIM,1,8),"^",14)
	Quit:(BaseUom="")!(BillUom="") 1
	Set ConvDr=$o(^CT("CTCF",0,"UOM",BillUom,BaseUom,""))
	Quit:ConvDr="" 1
	Set Conv=+$p(^CT("CTCF",ConvDr),"^",3)
	;INCI_CTUOM_DR----> CT_UOM
	;s ^CT("UOM",{CTUOM_RowId})
	s CumId=$p(^INCI(inci,3),"^",6) ;INCI_CTUOM_Purch_DR
	s UDesc=$p($g(^CT("UOM",CumId)),"^",2)		;CTUOM_Desc
	q Conv_"^"_UDesc
}

}
