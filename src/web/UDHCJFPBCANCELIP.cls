Import SQLUser

Class web.UDHCJFPBCANCELIP Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod PBCancel(Adm As %String, BILL As %String, UserId As %String) As %String
{
	new (Adm, BILL, UserId)
	
	quit:(+BILL=0) -1_"^"_"参数错误"
	quit:($p($g(^DHCPB(BILL)),"^",16)'="P") -1_"^"_"账单未结算，不能取消"
	quit:($p($g(^DHCPB(BILL)),"^",17)'="") -1_"^"_"账单已取消结算"
	
	set rtn=0
	
	//Lid 2014-06-19 根据DHC_PatBillOrder表的条数判断是否锁表
	set NoLockFlag=##class(web.UDHCJFBaseCommon).IsNoLockTable("", BILL, "")
	
	ts
	
	set rtn=##class(web.UDHCJFPB).SELECT(BILL)
	set PLIST(9)=-PLIST(9)
	set PLIST(10)=-PLIST(10)
	set PLIST(12)=-PLIST(12)
	set PLIST(13)=-PLIST(13)
	set PLIST(14)=-PLIST(14)
	set PLIST(15)=-PLIST(15)
	set PLIST(18)="R"
	set PLIST(19)=BILL
	set PLIST(20)=+$h
	set PLIST(21)=$p($h,",",2)
	set PLIST(22)=UserId
	set rtn=##class(web.UDHCJFPB).INSERT()
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	set StrikeBill=PLIST(1)
	
	set PBO=0
	while($o(^DHCPB(BILL,"O",PBO))) {
		set PBO=$o(^DHCPB(BILL,"O",PBO))
		set PBOData=$g(^DHCPB(BILL,"O",PBO))
		continue:(PBOData="")
		set PBORowID=BILL_"||"_PBO
		set oeitm=$p(PBOData,"^",4)
		set BillStatus=$p(PBOData,"^",16)
		set OrdExcRowID=$p(PBOData,"^",20)
		//+2022-07-20 ZhYW 急诊转入住院的医嘱取消结算时，医嘱的计费状态不能修改
		if (##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)'=1) {
			set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)=BillStatus
		}
		set $p(^OEORD($p(OrdExcRowID,"||",1),"I",$p(OrdExcRowID,"||",2),"X",$p(OrdExcRowID,"||",3)),"^",6)=BillStatus
		//
		if (NoLockFlag'="NoLock") {
			set rtn=##class(web.UDHCJFPBO).SELECT(PBORowID)
		}else {
			set rtn=##class(web.UDHCJFPBONoLock).SELECT(PBORowID)
		}
		kill PLIST(1), PLIST(2)
		set PLIST(0)=StrikeBill
		set PLIST(6)=-PLIST(6)
		set PLIST(7)=-PLIST(7)
		set PLIST(8)=-PLIST(8)
		set PLIST(9)=-PLIST(9)
		set PLIST(10)=-PLIST(10)
		set PLIST(11)=-PLIST(11)
		if (NoLockFlag'="NoLock") {
			set rtn=##class(web.UDHCJFPBO).INSERT()
		}else {
			set rtn=##class(web.UDHCJFPBONoLock).INSERT()
		}
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set NewPBORowID=PLIST(1)
		set Itm=0
		while($o(^DHCPB(BILL,"O",PBO,"D",Itm))) {
			set Itm=$o(^DHCPB(BILL,"O",PBO,"D",Itm))
			set PBDRowID=BILL_"||"_PBO_"||"_Itm
			if (NoLockFlag'="NoLock") {
				set rtn=##class(web.UDHCJFPBOD).SELECT(PBDRowID)
			}else {
				set rtn=##class(web.UDHCJFPBODNoLock).SELECT(PBDRowID)
			}
			kill PLIST(1), PLIST(2)
			set PLIST(0)=NewPBORowID
			set PLIST(5)=-PLIST(5)
			set PLIST(7)=-PLIST(7)
			set PLIST(8)=-PLIST(8)
			set PLIST(9)=-PLIST(9)
			set PLIST(10)=-PLIST(10)
			set PLIST(14)=+$h
			set PLIST(15)=$p($h,",",2)
			set PLIST(16)=UserId
			if (NoLockFlag'="NoLock") {
				set rtn=##class(web.UDHCJFPBOD).INSERT()
			}else {
				set rtn=##class(web.UDHCJFPBODNoLock).INSERT()
			}
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
	}
	if (+rtn) tro  quit rtn
	
	//Update BILL to mark it is a refunded bill
	&SQL(
		UPDATE DHC_PatientBill
		SET PB_RefundFlag = 'B', PB_OriginalBill_DR = :StrikeBill
		WHERE %ID = :BILL
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	set NewBill=""
	set PB=0
	while($o(^DHCPB(0,"ADM",Adm,PB))) {
		set PB=$o(^DHCPB(0,"ADM",Adm,PB))
		set payedFlag=$p(^DHCPB(PB),"^",16)
		continue:(payedFlag'="B")
		set NewBill=PB
		quit
	}
	if (NewBill="") {
		set rtnValue=##class(web.UDHCJFPB).PBINS(Adm, UserId)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set NewBill=$p(rtnValue,"^",2)
	}
	
	set TotalAmount=0
	set DiscAmount=0
	set PayorShare=0
	set PatientShare=0
	set DateFrom=+$h, DateTo=0
	
	//生成新账单
	set PBO=0
	while($o(^DHCPB(BILL,"O",PBO))) {
		set PBO=$o(^DHCPB(BILL,"O",PBO))
		set PBOData=$g(^DHCPB(BILL,"O",PBO))
		continue:(PBOData="")
		set PBORowID=BILL_"||"_PBO
		set oeitm=$p(PBOData,"^",4)
		set OrdDate=$p(PBOData,"^",12)
		set OrdExcRowID=$p(PBOData,"^",20)
		if ((+OrdDate'=0)&&(OrdDate<DateFrom)) set DateFrom=OrdDate
		if (OrdDate>DateTo) set DateTo=OrdDate
		if (NoLockFlag'="NoLock") {
			set rtn=##class(web.UDHCJFPBO).SELECT(PBORowID)
		}else {
			set rtn=##class(web.UDHCJFPBONoLock).SELECT(PBORowID)
		}
		set PLIST(0)=NewBill
		kill PLIST(1), PLIST(2), PLIST(16)
		if (NoLockFlag'="NoLock") {
			set rtn=##class(web.UDHCJFPBO).INSERT()
		}else {
			set rtn=##class(web.UDHCJFPBONoLock).INSERT()
		}
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set NewPBORowID=PLIST(1)
		set TotalAmount=TotalAmount+PLIST(8)
		set DiscAmount=DiscAmount+PLIST(9)
		set PayorShare=PayorShare+PLIST(10)
		set PatientShare=PatientShare+PLIST(11)
		
		set $p(^OEORD($p(OrdExcRowID,"||",1),"I",$p(OrdExcRowID,"||",2),"X",$p(OrdExcRowID,"||",3),"BILL"),"^",2)=NewPBORowID
		//加入检查申请单的计费状态的更新，由P更新为B
		set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
		if (isAppRepFlag="Y") {
			set rtnValue=##class(web.UDHCJFBILLIP).UpdateAppRepTarItmBillStatus(oeitm, "P", "B", OrdExcRowID)
			set rtn=$p(rtnValue,"^",1)
		}
		set Itm=0
		while($o(^DHCPB(BILL,"O",PBO,"D",Itm))) {
			set Itm=$o(^DHCPB(BILL,"O",PBO,"D",Itm))
			set PBDRowID=BILL_"||"_PBO_"||"_Itm
			if (NoLockFlag'="NoLock") {
				set rtn=##class(web.UDHCJFPBOD).SELECT(PBDRowID)
			}else {
				set rtn=##class(web.UDHCJFPBODNoLock).SELECT(PBDRowID)
			}
			kill PLIST(1), PLIST(2)
			set PLIST(0)=NewPBORowID
			set PLIST(13)="B"
			set PLIST(14)=+$h
			set PLIST(15)=$p($h,",",2)
			set PLIST(16)=UserId
			set PLIST(28)=PBDRowID
			if (NoLockFlag'="NoLock") {
				set rtn=##class(web.UDHCJFPBOD).INSERT()
			}else {
				set rtn=##class(web.UDHCJFPBODNoLock).INSERT()
			}
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			set NewPBDRowID=%ROWID
			set ^DHCPBDETAIL("DETAIL",NewPBDRowID)=$s($d(^DHCPBDETAIL("DETAIL",PBDRowID)):^DHCPBDETAIL("DETAIL",PBDRowID),1:PBDRowID)
		}
	}
	if (+rtn) tro  quit rtn
	
	set rtn=##class(web.UDHCJFPB).SELECT(NewBill)
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	if (+PLIST(7)=0) set PLIST(7)=DateFrom
	if (+PLIST(8)=0) set PLIST(8)=DateTo
	if (PLIST(7)>DateFrom) set PLIST(7)=DateFrom
	if (PLIST(8)<DateTo) set PLIST(8)=DateTo
	set PLIST(9)=PLIST(9)+TotalAmount
	set PLIST(10)=PLIST(10)+DiscAmount
	set PLIST(12)=PLIST(12)+PayorShare
	set PLIST(13)=PLIST(13)+PatientShare
	set PLIST(20)=+$h
	set PLIST(21)=$p($h,",",2)
	set PLIST(22)=UserId
	set rtn=##class(web.UDHCJFPB).UPDATE(NewBill)
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn_"^"_StrikeBill_"^"_NewBill
}

}
