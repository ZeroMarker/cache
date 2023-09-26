Class web.UDHCJFITM Extends BILL.COM.Abstract
{

/// Description: 医嘱支付明细医嘱项明细
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFITM","FindOrdDetail",281918)
Query FindOrdDetail(BillNo As %String, LangId As %String = "") As websys.Query(ROWSPEC = "Torder:%String:医嘱名称,Tdate:%String:医嘱日期,Tseqno:%String:医嘱序号,Tqty:%String:数量,Tprice:%Float:单价,TbillFlag:%String:收费状态,Tamt:%Float:总金额,Tdiscount:%Float:折扣金额,Tpayorshare:%Float:记账金额,Tpatshare:%Float:自付金额,TPBORowId:%String:医嘱账单ID,TUom:%String:单位")
{
}

ClassMethod FindOrdDetailExecute(ByRef qHandle As %Binary, BillNo As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (BillNo="") quit $$$OK
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
 	set sum=0, discount=0, payorshare=0, patshare=0
	
	set itm=0
	while($o(^DHCPB(BillNo,"O",itm))) {
		set itm=$o(^DHCPB(BillNo,"O",itm))
		set pboData=$g(^DHCPB(BillNo,"O",itm))
		continue:(pboData="")
		set pboRowId=BillNo_"||"_itm
		set arcim=$p(pboData,"^",3)
		set oeori=$p(pboData,"^",4)
		continue:'$d(^OEORD(+oeori,"I",$p(oeori,"||",2),1))
	    set pboDate=$p(pboData,"^",12)
		set pboDate=##class(websys.Conversions).DateLogicalToHtml(pboDate)
		set seqNo=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",4)
		set billStatus=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",5)
		set billStatus=$case(billStatus,"P":"已结算","R":"已退费",:"未收费")
		set billStatus=##class(websys.Translation).Get("", billStatus, LangId)
		set arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
		set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, LangId)
		set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeori)
		if (isAppRepFlag="Y") {
			set partDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(oeori)
			set arcimDesc=arcimDesc_partDesc          //名称 + 部位
		}
		set pboBillQty=$p(pboData,"^",5)
		set pboRefQty=$p(pboData,"^",6)
		set qty=$i(pboBillQty, pboRefQty)
		set qty=$fn(qty,"N")
		set price=$p(pboData,"^",7)
		set price=$fn(price,"",4)
		set amt=$p(pboData,"^",8)
		set amt=$fn(amt,"",2)
		set discAmt=$p(pboData,"^",9)
		set discAmt=$fn(discAmt,"",2)
		set payorAmt=$p(pboData,"^",10)
		set payorAmt=$fn(payorAmt,"",2)
		set patShareAmt=$p(pboData,"^",11)
		set patShareAmt=$fn(patShareAmt,"",2)
		set baseUom=##class(web.DHCBillCommon).GetBaseUom(arcim, oeori)   //基本单位
		set baseUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", baseUom, LangId)
		set sum=$i(sum, amt)
		set discount=$i(discount, discAmt)
		set payorshare=$i(payorshare, payorAmt)
		set patshare=$i(patshare, patShareAmt)
		do OutputOrdDetail
	}
	
	do InitOutOrdDetail
	set arcimDesc=##class(websys.Translation).Get("", "合计", LangId)
	set amt=$fn(sum,"",2)
	set discAmt=$fn(discount,"",2)
	set payorAmt=$fn(payorshare,"",2)
	set patShareAmt=$fn(patshare,"",2)
	do OutputOrdDetail

	quit $$$OK
InitOutOrdDetail
	set (arcimDesc,pboDate,seqNo,qty,price,billStatus,amt,discAmt,payorAmt,patShareAmt,pboRowId,baseUom)=""
	quit
OutputOrdDetail
	set Data=$lb(arcimDesc,pboDate,seqNo,qty,price,billStatus,amt,discAmt,payorAmt,patShareAmt,pboRowId,baseUom)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 收费项目查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFITM","FindItmDetail",279215)
Query FindItmDetail(BillNo As %String, StDate As %String, EndDate As %String, TarItmId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TItemDesc:%String:收费项,TUom:%String:单位,TBillDate:%String:计费日期,TBillTime:%String:计费时间,TQty:%String:数量,TPrice:%Float:单价,TBillStatus:%String:计费状态,TAmt:%Float:总金额,TDiscAmt:%Float:折扣金额,TPayorAmt:%Float:记账金额,TPatShareAmt:%Float:自付金额,TCreatDate:%String:账单日期,TCreatTime:%String:账单时间,TID:%String:PBDRowID")
{
}

ClassMethod FindItmDetailExecute(ByRef qHandle As %Binary, BillNo As %String, StDate As %String, EndDate As %String, TarItmId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (BillNo="")  quit $$$OK
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
 	set (sum, discount, payorshare, patshare)=0

 	set pbo=0
 	while($o(^DHCPB(BillNo,"O",pbo))) {
	 	set pbo=$o(^DHCPB(BillNo,"O",pbo))
	 	set pboData=$g(^DHCPB(BillNo,"O",pbo))
		continue:(pboData="")
		set oeori=$p(pboData,"^",4)
		set pbd=0
		while($o(^DHCPB(BillNo,"O",pbo,"D",pbd))) {
			set pbd=$o(^DHCPB(BillNo,"O",pbo,"D",pbd))
			set pbdData=$g(^DHCPB(BillNo,"O",pbo,"D",pbd))
			set pbdRowId=BillNo_"||"_pbo_"||"_pbd
			set billDate=$p(pbdData,"^",11)   //PBD_BillDate
			set billTime=$p(pbdData,"^",12)
			continue:((StDate'="")&&(StDate>billDate))
			continue:((EndDate'="")&&(EndDate<billDate))
			set billDate=##class(websys.Conversions).DateLogicalToHtml(billDate)
			set billTime=##class(websys.Conversions).TimeLogicalToHtml(billTime, 1)
			set itmDR=$p(pbdData,"^",3)
			continue:((TarItmId'="")&&(TarItmId'=itmDR))
			set itmDesc=$s((+itmDR'=0):$p($g(^DHCTARI(itmDR)),"^",2),1:"")
			set itmDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", itmDesc, LangId)
			set tarUomDR=$p($g(^DHCTARI(itmDR)),"^",3)
		 	set uomDesc=$s((+tarUomDR'=0):$p($g(^CT("UOM",tarUomDR)),"^",2),1:"")
		 	set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, LangId)
			set billQty=$p(pbdData,"^",5)
			set billQty=$fn(billQty,"N")
			set price=$fn($p(pbdData,"^",4),"",4)
			set billStatus=$p(pbdData,"^",14)
			set billStatus=$case(billStatus,"P":"已结算","B":"已计费","R":"已退费",:"")
			set billStatus=##class(websys.Translation).Get("", billStatus, LangId)
			set totalAmt=$fn($p(pbdData,"^",7),"",2)
			set discAmt=$fn($p(pbdData,"^",8),"",2)
			set payorShareAmt=$fn($p(pbdData,"^",9),"",2)
			set patientShareAmt=$fn($p(pbdData,"^",10),"",2)
			set sum=$i(sum, totalAmt)
			set discount=$i(discount, discAmt)
			set payorshare=$i(payorshare, payorShareAmt)
			set patshare=$i(patshare, patientShareAmt)
			set createDate=$p(pbdData,"^",15)   //PBD_CreateDate
			set createDate=##class(websys.Conversions).DateLogicalToHtml(createDate)     
			set createTime=$p(pbdData,"^",16)   //PBD_CreateTime
			set createTime=##class(websys.Conversions).TimeLogicalToHtml(createTime, 1)  
			do OutputItmDetail
		}
	}
	
	do InitOutItmDetail
	set itmDesc=##class(websys.Translation).Get("", "合计", LangId)
	set totalAmt=$fn(sum,"",2)
	set discAmt=$fn(discount,"",2)
	set payorShareAmt=$fn(payorshare,"",2)
	set patientShareAmt=$fn(patshare,"",2)
	do OutputItmDetail
	
	quit $$$OK
	
InitOutItmDetail
	set (itmDesc,uomDesc,billDate,billTime,billQty,price,billStatus,totalAmt,discAmt,payorShareAmt,patientShareAmt,createDate,createTime,pbdRowId)=""
	quit
	
OutputItmDetail
	set Data=$lb(itmDesc,uomDesc,billDate,billTime,billQty,price,billStatus,totalAmt,discAmt,payorShareAmt,patientShareAmt,createDate,createTime,pbdRowId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
