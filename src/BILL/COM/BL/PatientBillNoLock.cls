Import SQLUser

/// 名称: BILL.COM.BL.PatientBillNoLock.cls
/// 描述: 账单操作类(不加锁)
/// 编写者: ZhYW
/// 编写日期: 2022-10-19
Class BILL.COM.BL.PatientBillNoLock Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2022-10-19
/// Description: 拷贝DHC_PatBillOrder至新DHC_PatBillOrder
/// Input: fPBORowId:DHC_PatBillOrder.RowId, tPBRowId:DHC_PatientBill.RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillOrder("436","17771")
ClassMethod CopyIntoBillOrder(fPBORowId As %String, tPBRowId As %String) As %String
{
	set $zt="ERROR"
	
	set pb=$p(fPBORowId,"||",1)
	set pbo=$p(fPBORowId,"||",2)
	
	set pboData=$g(^DHCPB(pb,"O",pbo))
	set pboARCIMDR=$p(pboData,"^",3)
	set pboOEORIDR=$p(pboData,"^",4)
	set pboBillQty=$p(pboData,"^",5)
	set pboRefundQty=$p(pboData,"^",6)
	set pboUnitPrice=$p(pboData,"^",7)
	set pboTotalAmount=$p(pboData,"^",8)
	set pboDiscAmount=$p(pboData,"^",9)
	set pboPayorShare=$p(pboData,"^",10)
	set pboPatientShare=$p(pboData,"^",11)
	set pboOrdDate=$p(pboData,"^",12)
	set pboOrdTime=$p(pboData,"^",13)
	set pboRefundFlag=$p(pboData,"^",14)
	set pboOriginalBillDR=$p(pboData,"^",15)
	set pboBillStatus=$p(pboData,"^",16)
	set pboDiscPrice=$p(pboData,"^",17)
	set pboInsPrice=$p(pboData,"^",18)
	set pboPatPrice=$p(pboData,"^",19)
	set pboOrdExecDR=$p(pboData,"^",20)
	&SQL(
		INSERT %NOLOCK %NOCHECK INTO DHC_PatBillOrder (
			PBO_PB_ParRef, PBO_ARCIM_DR, PBO_OEORI_DR, PBO_UnitPrice, PBO_BillQty,
			PBO_RefundQty, PBO_ToTalAmount, PBO_DiscAmount, PBO_PayorShare, PBO_PatientShare,
			PBO_OrderDate, PBO_OrderTime, PBO_RefundFlag, PBO_OriginalBill_DR, PBO_BillStatus,
			PBO_DiscPrice, PBO_InsPrice, PBO_PatPrice, PBO_OrdExec_DR
		)
		VALUES (
			:tPBRowId, :pboARCIMDR, :pboOEORIDR, :pboUnitPrice, :pboBillQty,
			:pboRefundQty, :pboTotalAmount, :pboDiscAmount, :pboPayorShare, :pboPatientShare,
			:pboOrdDate, :pboOrdTime, :pboRefundFlag, :pboOriginalBillDR, :pboBillStatus,
			:pboDiscPrice, :pboInsPrice, :pboPatPrice, :pboOrdExecDR
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	set newPBORowId=$g(%ROWID)
	
	quit rtn_"^"_newPBORowId
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-10-19
/// Description: 拷贝DHC_PatBillDetails至新DHC_PatBillDetails
/// Input: fPBDRowId:DHC_PatBillDetails.RowId, tPBORowId:DHC_PatBillOrder.RowId
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(BILL.COM.BL.PatientBillNoLock).CopyIntoBillDetails("436||2||1","437||1")
ClassMethod CopyIntoBillDetails(fPBDRowId As %String, tPBORowId As %String) As %String
{
	set $zt="ERROR"
	
	set pb=$p(fPBDRowId,"||",1)
	set pbo=$p(fPBDRowId,"||",2)
	set pbd=$p(fPBDRowId,"||",3)
	
	set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	set pbdTARIDR=$p(pbdData,"^",3)
	set pbdUnitPrice=$p(pbdData,"^",4)
	set pbdBillQty=$p(pbdData,"^",5)
	set pbdDiscPerc=$p(pbdData,"^",6)
	set pbdTotalAmount=$p(pbdData,"^",7)
	set pbdDiscAmount=$p(pbdData,"^",8)
	set pbdPayorShare=$p(pbdData,"^",9)
	set pbdPatientShare=$p(pbdData,"^",10)
	set pbdBillDate=$p(pbdData,"^",11)
	set pbdBillTime=$p(pbdData,"^",12)
	set pbdBillUser=$p(pbdData,"^",13)
	set pbdBillStatus=$p(pbdData,"^",14)
	set pbdCreateDate=$p(pbdData,"^",15)
	set pbdCreateTime=$p(pbdData,"^",16)
	set pbdExecDeptDR=$p(pbdData,"^",17)
	set pbdDiscPrice=$p(pbdData,"^",18)
	set pbdInsPrice=$p(pbdData,"^",19)
	set pbdPatPrice=$p(pbdData,"^",20)
	set pbdDSPDR=$p(pbdData,"^",21)
	set pbdExtralFlag=$p(pbdData,"^",22)
	set pbdOriginalDR=$p(pbdData,"^",23)
	set pbdExtralComment=$p(pbdData,"^",24)
	set pbdARTIDisc=$p(pbdData,"^",25)
	set pbdARTIDR=$p(pbdData,"^",26)
	set pbdDSPBDR=$p(pbdData,"^",27)
	set pbdOldPBDDR=$p(pbdData,"^",28)
	set pbdOrderLinkTarDR=$p(pbdData,"^",29)
	&SQL(
		INSERT %NOLOCK %NOCHECK INTO DHC_PatBillDetails (
			PBD_PBO_ParRef, PBD_TARI_DR, PBD_UnitPrice, PBD_BillQty, PBD_DiscPerc,
			PBD_TotalAmount, PBD_DiscAmount, PBD_PayorShare, PBD_PatientShare, PBD_BillDate,
			PBD_BillTime, PBD_BillStatus, PBD_CreateDate, PBD_CreateTime, PBD_BillUser,
			PBD_ExecDept_DR, PBD_DiscPrice, PBD_InsPrice, PBD_PatPrice, PBD_DSP_DR,
			PBD_ExtralFlag, PBD_Original_DR, PBD_ExtralComment, PBD_ARTI_Disc, PBD_ARTI_DR,
			PBD_DSPB_DR, PBD_OldPBD_DR, PBD_OrderLinkTar_DR
		)
		VALUES (
			:tPBORowId, :pbdTARIDR, :pbdUnitPrice, :pbdBillQty, :pbdDiscPerc,
			:pbdTotalAmount, :pbdDiscAmount, :pbdPayorShare, :pbdPatientShare, :pbdBillDate,
			:pbdBillTime, :pbdBillStatus, :pbdCreateDate, :pbdCreateTime, :pbdBillUser,
			:pbdExecDeptDR, :pbdDiscPrice, :pbdInsPrice, :pbdPatPrice, :pbdDSPDR,
			:pbdExtralFlag, :pbdOriginalDR, :pbdExtralComment, :pbdARTIDisc, :pbdARTIDR,
			:pbdDSPBDR, :pbdOldPBDDR, :pbdOrderLinkTarDR
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	set newPBDRowId=$g(%ROWID)
	
	quit rtn_"^"_newPBDRowId
	
ERROR
	quit ..AppException()
}

}
