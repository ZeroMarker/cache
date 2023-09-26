Import SQLUser

/// Creator：陈曦
/// CreatDate: 2010-05-19
/// Description: 特殊手术拆分账单
Class web.DHCIPBILLOEORIItemGroup Extends BILL.COM.Abstract
{

/// Creator：陈曦
/// CreatDate：2010-05-19
/// Description: 查询该病人的医嘱信息
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCIPBILLOEORIItemGroup","QryOEOREList","279536","","","1^2^3^4^5^6^7^8^9^10^11^12","","","")
Query QryOEOREList(BillNo As %String, StDate As %String, EndDate As %String, OrdCatStr As %String, OrdSubCatStr As %String, ArcimStr As %String, OEOrdItemStr As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TOrdDate:%String:医嘱日期,TArcimDesc:%String:医嘱名称,TSubCatDesc:%String:医嘱分类,TCatDesc:%String:医嘱大类,TPrice:%Float:单价,TQty:%String:数量,TAmt:%Float:金额,TExecRowID:%String,TPBORowID:%String")
{
}

ClassMethod QryOEOREListExecute(ByRef qHandle As %Binary, BillNo As %String, StDate As %String, EndDate As %String, OrdCatStr As %String, OrdSubCatStr As %String, ArcimStr As %String, OEOrdItemStr As %String, LangId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryOEOREList")=$lb(BillNo, StDate, EndDate, OrdCatStr, OrdSubCatStr, ArcimStr, OEOrdItemStr, LangId)
	if (BillNo="")  quit $$$OK
	
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)

	set BillSum=0
	set PBO=0
	while($o(^DHCPB(BillNo,"O",PBO))) {
		set PBO=$o(^DHCPB(BillNo,"O",PBO))
		set PBOData=$g(^DHCPB(BillNo,"O",PBO))
		continue:(PBOData="")
		set PBORowID=BillNo_"||"_PBO
		set ArcimDR=$p(PBOData,"^",3)
		continue:((ArcimStr'="")&&(("^"_ArcimStr_"^")'[("^"_ArcimDR_"^")))
		set ArcimDesc=$p($g(^ARCIM(+$p(ArcimDR,"||",1),$p(ArcimDR,"||",2),1)),"^",2)
		set ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", ArcimDesc, LangId)
		set SubCatDR=$p($g(^ARCIM(+$p(ArcimDR,"||",1),$p(ArcimDR,"||",2),1)),"^",10)
		continue:((OrdSubCatStr'="")&&(("^"_OrdSubCatStr_"^")'[("^"_SubCatDR_"^")))
		set SubCatDesc=$p($g(^ARC("IC",SubCatDR)),"^",2)
		set SubCatDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", SubCatDesc, LangId)
		set CatDR=$p($g(^ARC("IC",SubCatDR)),"^",8)
		continue:((OrdCatStr'="")&&(("^"_OrdCatStr_"^")'[("^"_CatDR_"^")))
		set CatDesc=$p($g(^OEC("ORCAT",CatDR)),"^",2)
		set CatDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", CatDesc, LangId)
		set OEORIDR=$p(PBOData,"^",4)
		continue:((OEOrdItemStr'="")&&(("^"_OEOrdItemStr_"^")'[("^"_OEORIDR_"^")))
		set DepProcNotes=$g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),"DEP",1))    //医嘱备注
		if (DepProcNotes'="") set ArcimDesc=ArcimDesc_"("_DepProcNotes_")"
		set OrdDatTime=##class(web.UDHCJFIntBill).GetFstBillDateTime(PBORowID)   //+2022-05-06 ZhYW
		set OrdDate=$p(OrdDatTime,"^",1)
		continue:((StDate'="")&&(OrdDate<StDate))
		continue:((EndDate'="")&&(OrdDate>EndDate))
		set OrdDate=##class(websys.Conversions).DateLogicalToHtml(OrdDate)
		set OEORE=$p(PBOData,"^",20)
		set Price=$p(PBOData,"^",7)
		set Price=$fn(Price,"",4)
		set PBOBillQty=$p(PBOData,"^",5)
		set PBORefundQty=$p(PBOData,"^",6)
		set Qty=PBOBillQty+PBORefundQty
		set Amt=$p(PBOData,"^",8)
		set Amt=$fn(Amt,"",2)
		set BillSum=$i(BillSum,Amt)
		do OutputOEOREList
	}
	
	set (OrdDate,ArcimDesc,SubCatDesc,CatDesc,Price,Qty,Amt,OEORE,PBORowID)=""
	set OrdDate=##class(websys.Translation).Get("", "合计", LangId)
	set Amt=$fn(BillSum,"",2)
	do OutputOEOREList

	quit $$$OK
    
OutputOEOREList
	set Data=$lb(OrdDate,ArcimDesc,SubCatDesc,CatDesc,Price,Qty,Amt,OEORE,PBORowID)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 按执行记录拆分账单
/// Debug: do ##class(web.DHCIPBILLOEORIItemGroup).RINBILL(21019, 2988)
ClassMethod RINBILL(bill As %String, userId As %String, ByRef execAry As %String) As %String
{
	set $zt="ERROR"

	quit:(+bill=0) -1_"^"_"参数错误"

	merge ^TMPEXECAry=execAry
	
	set adm=$p($g(^DHCPB(bill)),"^",1)
	
	set insuUpFlag=##class(web.DHCIPBillCashier).JudgePBInsuUpFlag(bill, "")
	quit:(+insuUpFlag>0) -1_"^""该账单已"_$case(insuUpFlag,1:"医保上传",2:"医保结算",:"")_"，不能拆分"
	
	set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(bill)
	quit:(isCloseAcount="Y") -1_"^"_"该账单已封账，不能拆分"
	
	set payedFlag=$p($g(^DHCPB(bill)),"^",16)
	quit:(payedFlag="P") -1_"^"_"该账单已结算，不能拆分"
	
	set count=+$o(execAry(""),-1)
	quit:(count=0) -1_"^"_"没有符合条件的医嘱，不能拆分"
	
	//根据DHC_PatBillDetails表的条数判断是否锁表
	set isNoLock=##class(web.UDHCJFBaseCommon).IsNoLockTable(adm, bill, "")
	
	kill myAry
	for i=1:1:count {
		set oeore=execAry(i)
		continue:(oeore="")
		set myAry(oeore)=""
	}
	
	set rtn=0
    
    ts
    
	set rtnValue=##class(web.UDHCJFPB).PBINS(adm, userId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtn
	set newPBRowId=$p(rtnValue,"^",2)
	
	set totalAmount=0
	set discAmount=0
	set payorAmount=0
	set patShareAmount=0
	set dateFrom=+$h
	set dateTo=0
	set oldDateFrom=+$h
	set oldDateTo=0
	
	set pbo=0
	while($o(^DHCPB(bill,"O",pbo))) {
		set pbo=$o(^DHCPB(bill,"O",pbo))
		set pboData=$g(^DHCPB(bill,"O",pbo))
		continue:(pboData="")
		set pboRowId=bill_"||"_pbo
		set pboTotalAmount=$p(pboData,"^",8)
		set pboDiscAmount=$p(pboData,"^",9)
		set pboPayorShare=$p(pboData,"^",10)
		set pboPatientShare=$p(pboData,"^",11)
		set pboOrdDate=$p(pboData,"^",12)
		set oeore=$p(pboData,"^",20)
		if ('$d(myAry(oeore))) {
			if (pboOrdDate>oldDateTo) set oldDateTo=pboOrdDate
			if ((+pboOrdDate'=0)&&(pboOrdDate<oldDateFrom)) set oldDateFrom=pboOrdDate
			continue
		}
		if (pboOrdDate>dateTo) set dateTo=pboOrdDate
		if ((+pboOrdDate'=0)&&(pboOrdDate<dateFrom)) set dateFrom=pboOrdDate
		set totalAmount=$i(totalAmount, pboTotalAmount)
		set discAmount=$i(discAmount, pboDiscAmount)
		set payorAmount=$i(payorAmount, pboPayorShare)
		set patShareAmount=$i(patShareAmount, pboPatientShare)
		if (isNoLock'="NoLock") {
			set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillOrder(pboRowId, newPBRowId)
		}else {
			set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillOrder(pboRowId, newPBRowId)
		}
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set newPBORowId=$p(rtnValue,"^",2)
		set $p(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3),"BILL"),"^",2)=newPBORowId  
		set pbd=0
		while($o(^DHCPB(bill,"O",pbo,"D",pbd))) {
			set pbd=$o(^DHCPB(bill,"O",pbo,"D",pbd))
			set pbdRowId=bill_"||"_pbo_"||"_pbd
			set ^DHCBillCancel(+$h,newPBRowId,pbdRowId)=adm     //记录撤销的收费项目费用明细
			if (isNoLock'="NoLock") {
				set rtnValue=##class(BILL.COM.BL.PatientBill).CopyIntoBillDetails(pbdRowId, newPBORowId)
			}else {
				set rtnValue=##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillDetails(pbdRowId, newPBORowId)
			}
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) {
				set rtn=rtnValue
				quit
			}
		}
		quit:(+rtn)
		if (isNoLock'="NoLock") {
			&SQL(DELETE FROM DHC_PatBillOrder WHERE %ID = :pboRowId)
		}else {
			&SQL(DELETE %NOLOCK %NOCHECK FROM DHC_PatBillOrder WHERE %ID = :pboRowId)
		}
		set rtn=SQLCODE
	    if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if (dateFrom=0) set dateFrom=""
	if (dateTo=0) set dateTo=""
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_DateFrom = :dateFrom, PB_DateTo = :dateTo, PB_TotalAmount = :totalAmount, PB_DiscAmount = :discAmount, PB_PayorShare = :payorAmount,
			PB_PatientShare = :patShareAmount, PB_OriginalBill_DR = :bill, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW())
		WHERE %ID = :newPBRowId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//更新原账单
	if (oldDateFrom=0) set oldDateFrom=""
	if (oldDateTo=0) set oldDateTo=""
	set pbData=$g(^DHCPB(bill))
	set pbTotalAmount=$p(pbData,"^",8)
	set pbDiscAmount=$p(pbData,"^",9)
	set pbPayorShare=$p(pbData,"^",11)
	set pbPatientShare=$p(pbData,"^",12)
	set pbTotalAmount=pbTotalAmount-totalAmount
	set pbDiscAmount=pbDiscAmount-discAmount
	set pbPayorShare=pbPayorShare-payorAmount
	set pbPatientShare=pbPatientShare-patShareAmount
	
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_DateFrom = :oldDateFrom, PB_DateTo = :oldDateTo, PB_TotalAmount = :pbTotalAmount, PB_DiscAmount = :pbDiscAmount, PB_PayorShare = :pbPayorShare,
			PB_PatientShare = :pbPatientShare, PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :userId
		WHERE %ID = :bill
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc

	quit rtn_"^"_newPBRowId

ERROR
	quit ..AppException()
}

}
