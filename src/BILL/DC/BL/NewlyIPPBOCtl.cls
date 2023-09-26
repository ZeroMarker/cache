Import SQLUser

Class BILL.DC.BL.NewlyIPPBOCtl Extends BILL.COM.Abstract
{

/// Creator: zhangjb
/// CreateDate: 2023-01-30
/// Description: 根据pboid查询医嘱明细
/// Input:	pbo.rowid
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("BILL.DC.BL.NewlyIPPBOCtl","QueryDHCPBOData","6||3")
Query QueryDHCPBOData(pboid) As websys.Query(ROWSPEC = "pboid,PatName,AdmType,AdmTypeDesc,PBOARCIMDR,ARCIMDesc,PBPayedFlag,PBOOrdExecDR,OEOREBilled,OEOREOrderStatusDR,STATDesc,PBOUnitPrice,PBOBillQty,PBORefundQty,PBOTotalAmount,PBODiscAmount,PBOPayorShare,PBOPatientShare") [ SqlProc ]
{
}

ClassMethod QueryDHCPBODataExecute(ByRef qHandle As %Binary, pboid) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (pboid="") quit $$$OK
	
	s pbrowid=+pboid
	s PBOData=$g(^DHCPB(pbrowid,"O",$p(pboid,"||",2)))
	q:(PBOData="") $$$OK
	s PBData=$g(^DHCPB(pbrowid))
	q:(PBData="") $$$OK
	s AdmId=$p(PBData,"^",1)  //就诊信息
	s AdmType=$p(^PAADM(AdmId),"^",2)
	s AdmTypeDesc=""
	i (AdmType="I") d
	.s AdmTypeDesc="住院"
	e  d
	.s AdmTypeDesc="非住院"
	s PAADMPAPMIDR=$p(^PAADM(AdmId),"^",1) //患者信息
	s PatName=$s((+PAADMPAPMIDR'=0):$p($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",1),1:"")
	s PBOARCIMDR=$p(PBOData,"^",3)    //医嘱项
	s ARCIMDesc=$p($g(^ARCIM(+PBOARCIMDR,$p(PBOARCIMDR,"||",2),1)),"^",2)
	s PBPayedFlag=$p(PBData,"^",16) //计费状态 
	s PBOOrdExecDR=$p(PBOData,"^",20) //执行记录
	s (OEOREBilled,OEOREOrderStatusDR,STATDesc)=""
	if PBOOrdExecDR'="" d
	.s OEOREBilled=$p($g(^OEORD(+PBOOrdExecDR,"I",$p(PBOOrdExecDR,"||",2),"X",$p(PBOOrdExecDR,"||",3))),"^",6)  //执行记录计费状态
	.s OEOREOrderStatusDR=$p($g(^OEORD(+PBOOrdExecDR,"I",$p(PBOOrdExecDR,"||",2),"X",$p(PBOOrdExecDR,"||",3))),"^",16)  //执行记录执行状态
	.if OEOREOrderStatusDR'="" d
	..s STATDesc=$p($g(^OEC("STAT",OEOREOrderStatusDR)),"^",2) //执行状态
	s PBOUnitPrice=$fn($p(PBOData,"^",7),"",2)  //单价
	s PBOBillQty=$p(PBOData,"^",5) //数量
	s PBORefundQty=$p(PBOData,"^",6) //退费数量	
	//s PBOBillQty=PBOBillQty+PBORefundQty
	s PBODiscAmount=$fn($p(PBOData,"^",9),"",2) //折扣金额
	s PBOPayorShare=$fn($p(PBOData,"^",10),"",2) //记账部分
	s PBOPatientShare=$fn($p(PBOData,"^",11),"",2) //自费部分
	s PBOTotalAmount=$fn($p(PBOData,"^",8),"",2) //医嘱总金额
	d QueryDHCPBODataOut
	quit $$$OK
QueryDHCPBODataOut
	set Data=$lb(pboid,PatName,AdmType,AdmTypeDesc,PBOARCIMDR,ARCIMDesc,PBPayedFlag,PBOOrdExecDR,OEOREBilled,OEOREOrderStatusDR,STATDesc,PBOUnitPrice,PBOBillQty,PBORefundQty,PBOTotalAmount,PBODiscAmount,PBOPayorShare,PBOPatientShare)
	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-12-01
/// Description: 删除医嘱账单表记录
/// Input: PBO:DHC_PatBillOrder.RowId, UserId:SS_User.RowId
/// Return: 0:成功, <>0:失败
/// Others: 只针对住院账单的删除
/// Debug: w ##class(BILL.DC.BL.NewlyIPPBOCtl).DELPBO("6||1", "1")
ClassMethod DELPBO(PBO As %String, UserId As %String) As %String
{
	set $zt="ERROR"
	quit:(PBO="") -1_"^"_"参数错误"

	//校验能否删除
	set BILL=+PBO
	set PBData=$g(^DHCPB(+BILL))
	quit:(PBData="") -1_"^"_"账单为空，请核实参数"
	
	set Adm=$p(PBData,"^",1)
	set AdmType=$p(^PAADM(Adm),"^",2)
	quit:(AdmType'="I") -1_"^"_"非住院账单，不能重新账单"
	
	set PayedFlag=$p(PBData,"^",16)
	if (PayedFlag="P") {
		set IsCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(BILL)
		quit:(IsCloseAcount="Y") -1_"^"_"账单已封账，不能重新账单"
		quit -1_"^"_"账单已结算，不能重新账单"
	}
	
	set insuUpFlag=##class(web.DHCINSUPort).GetInsuUpFlag(BILL, "")
	if (+insuUpFlag>0) {    //医保未上传、未医保结算时重新生成账单
		quit -1_"^"_$case(insuUpFlag,1:"医保已上传",2:"医保已结算",:"")_"，不能重新账单"
	}
	
	set OEORE=$p($g(^DHCPB(+BILL,"O",$p(PBO,"||",2))),"^",20)   //执行记录
	quit:(OEORE="") -1_"^"_"执行记录为空，不能重新账单"
	
	set BillFlag=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)    //执行记录的计费状态
	quit:(BillFlag="P") -1_"^"_"执行记录计费状态为已结算，不能重新账单"
	
	ts
	
	do ##class(web.UDHCJFBILLIP).SetDetPatBillDetails(PBO)
	
	//记录删除的收费项目费用明细，用于综合查询组冲账
	set PBD=0
	while($o(^DHCPB(BILL,"O",$p(PBO,"||",2),"D",PBD))) {
		set PBD=$o(^DHCPB(BILL,"O",$p(PBO,"||",2),"D",PBD))
		set PBDRowID=PBO_"||"_PBD
		set ^DHCBILLPBODEL(+$h,PBO,PBDRowID)=$lb(Adm, PBO, OEORE)   //记录删除的收费项目费用明细，用于综合查询组冲账
	}
	
	//取原PBO费用
	&SQL(
		SELECT -PBO_ToTalAmount, -PBO_DiscAmount, -PBO_PayorShare, -PBO_PatientShare
		INTO :TotalAmount, :DiscAmount, :PayorShare, :PatientShare
		FROM DHC_PatBillOrder
		WHERE %ID = :PBO
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//删除账单医嘱表和账单明细表
	set rtn=##class(web.UDHCJFPBO).PBODEL(PBO)
	if (+rtn) tro  quit rtn
	
	//找平主账单
	set PBTotalAmount=$p(PBData,"^",8)
	set PBDiscAmount=$p(PBData,"^",9)
	set PBPayorShare=$p(PBData,"^",11)
	set PBPatientShare=$p(PBData,"^",12)
	set TotalAmount=$i(TotalAmount, PBTotalAmount)
	set DiscAmount=$i(DiscAmount, PBDiscAmount)
	set PayorShare=$i(PayorShare, PBPayorShare)
	set PatientShare=$i(PatientShare, PBPatientShare)
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_TotalAmount = :TotalAmount, PB_DiscAmount = :DiscAmount, PB_PayorShare = :PayorShare, PB_PatientShare = :PatientShare,
			PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :UserId
		WHERE %ID = :BILL
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//更新指向记录状态
	&SQL(
		UPDATE OE_OrdExec
		SET OEORE_Billed = 'TB'
		WHERE %ID = :OEORE
	)
    set rtn=SQLCODE
    if (+rtn) tro  quit rtn_"^"_$g(%msg)
    
	set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL"),"^",2)=""   //OEORE_PBO_DR
	//如果是新版申请单，需要把中间表的账单状态也改为TB
    set IsAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
    if (IsAppRep="Y") {
   		set rtn=##class(web.UDHCJFBILLIP).UpdateAppRepTarItmBillStatus($p(OEORE,"||",1,2), "B", "TB", OEORE)
   		if (+rtn) tro  quit rtn
    }
	
	//日志记录
	set ^BILL.IP("DELPBO",PBO)=$lb(OEORE, $zdt($zdth($zts,-3),3,1,6), UserId)
		
	if ($tl>0) tc
	
	do ##class(web.UDHCJFBILL).BILLN(Adm, UserId, OEORE, 1)   //将该执行记录账单
	quit rtn

ERROR
	quit ..AppException()
}

}
