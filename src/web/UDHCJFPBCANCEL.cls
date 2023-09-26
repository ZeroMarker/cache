Import SQLUser

Class web.UDHCJFPBCANCEL Extends BILL.COM.Abstract [ Not ProcedureBlock ]
{

ClassMethod PBCancel(ADM As %String, BILL As %String, User As %String) As %String
{
	new (ADM, BILL, User)
	
	quit:(+BILL=0) -1_"^"_"参数错误"
	quit:($p($g(^DHCPB(BILL)),"^",16)'="P") -1_"^"_"账单未结算，不能取消"
	quit:($p($g(^DHCPB(BILL)),"^",17)'="") -1_"^"_"账单已取消结算"
	
	set rtn=0
	
	set $zt="ERROR^DHCSSERR"
	
	ts
	
	set rtn=##class(web.UDHCJFPB).SELECT(BILL)
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
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
	set PLIST(22)=User
	set rtn=##class(web.UDHCJFPB).INSERT()
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	set RedBill=PLIST(1)
	
	//生成负账单
	set PBO=0
	while($o(^DHCPB(BILL,"O",PBO))) {
		set PBO=$o(^DHCPB(BILL,"O",PBO))
		continue:($d(^DHCPB(BILL,"O",PBO))=10)
		set rtn=##class(web.UDHCJFPBO).SELECT(BILL_"||"_PBO)
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		kill PLIST(1), PLIST(2)
		set PLIST(0)=RedBill
		set PLIST(6)=-PLIST(6)
		set PLIST(7)=-PLIST(7)
		set PLIST(8)=-PLIST(8)
		set PLIST(9)=-PLIST(9)
		set PLIST(10)=-PLIST(10)
		set PLIST(11)=-PLIST(11)
		set rtn=##class(web.UDHCJFPBO).INSERT()
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set NewPBORowID=PLIST(1)
		set Itm=0
		while($o(^DHCPB(BILL,"O",PBO,"D",Itm))) {
			set Itm=$o(^DHCPB(BILL,"O",PBO,"D",Itm))
			set rtn=##class(web.UDHCJFPBOD).SELECT(BILL_"||"_PBO_"||"_Itm)
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
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
			set PLIST(16)=User 
			set rtn=##class(web.UDHCJFPBOD).INSERT()
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
		SET PB_RefundFlag = 'B', PB_OriginalBill_DR = :RedBill
		WHERE %ID = :BILL
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	//Create a new BILL or Search a existed BILL
	set NewBill=""
	set admBill=0
	while($o(^DHCPB(0,"ADM",ADM,admBill))) {
		set admBill=$o(^DHCPB(0,"ADM",ADM,admBill))
		set payedFlag=$p(^DHCPB(admBill),"^",16)
		continue:(payedFlag'="B")
		set NewBill=admBill
		quit
	}
	if (NewBill="") {
		set rtnValue=##class(web.UDHCJFPB).PBINS(ADM, User)
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
		set BillStatus=$p(PBOData,"^",16)
		set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)=BillStatus
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)=1)     //+2019-07-23 ZhYW  将转出的医嘱退出
		//取消结算红冲账单生成新账单时对账单里面存在同样医嘱的先删除原纪录
		set pbo=0
		while($o(^DHCPBi(0,"OEORI",oeitm,NewBill,pbo))) {
			set pbo=$o(^DHCPBi(0,"OEORI",oeitm,NewBill,pbo))
			set pboData=$g(^DHCPB(NewBill,"O",pbo))
			continue:(pboData="")
			set pboRefundFlag=$p(pboData,"^",14)   //PBO_RefundFlag
			continue:(pboRefundFlag="Y")
			set newPBORowId=NewBill_"||"_pbo
			do ##class(web.UDHCJFBILL).SetDetPatBillDetails(newPBORowId)
			set rtn=..DELPBO(newPBORowId)
			quit
		}
		quit:(+rtn)
		set OrdDate=$p(PBOData,"^",12)
		if ((+OrdDate'=0)&&(OrdDate<DateFrom)) set DateFrom=OrdDate
		if (OrdDate>DateTo) set DateTo=OrdDate
		set rtn=##class(web.UDHCJFPBO).SELECT(PBORowID)
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set PLIST(0)=NewBill
		kill PLIST(1), PLIST(2), PLIST(16)
		set rtn=##class(web.UDHCJFPBO).INSERT()
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
		set NewPBORowID=PLIST(1)
		set TotalAmount=TotalAmount+PLIST(8)
		set DiscAmount=DiscAmount+PLIST(9)
		set PayorShare=PayorShare+PLIST(10)
		set PatientShare=PatientShare+PLIST(11)
		set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",16)=NewPBORowID
		set Itm=0
		while($o(^DHCPB(BILL,"O",PBO,"D",Itm))) {
			set Itm=$o(^DHCPB(BILL,"O",PBO,"D",Itm))
			set PBDRowID=BILL_"||"_PBO_"||"_Itm
			set rtn=##class(web.UDHCJFPBOD).SELECT(PBDRowID)
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			kill PLIST(1), PLIST(2)
			set PLIST(0)=NewPBORowID
			set PLIST(13)="B"
			set PLIST(14)=+$h
			set PLIST(15)=$p($h,",",2)
			set PLIST(16)=User
			set PLIST(28)=PBDRowID
			set ArtiDR=PLIST(26)        //多部位检查申请单中间表指针
			set rtn=##class(web.UDHCJFPBOD).INSERT()
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			if (ArtiDR'="") {
				&SQL(
					UPDATE DHC_AppRepTarItm
					SET ARTI_Billed = :BillStatus, ARTI_PBO_Dr = :NewPBORowID
					WHERE %ID = :ArtiDR
				)
				set rtn=SQLCODE
				if (+rtn) {
					set rtn=rtn_"^"_$g(%msg)
					quit
				}
			}
		}
		quit:(+rtn)
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
	set PLIST(22)=User
	set rtn=##class(web.UDHCJFPB).UPDATE(NewBill)
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	&SQL(
		UPDATE PA_Adm
		SET PAADM_BillFlag = 'N'
		WHERE %ID = :ADM
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn_"^"_RedBill_"^"_NewBill
}

/// Creator: zhl
/// CreatDate: 2019-01-24
/// Description: 取消结算红冲账单生成新账单时对账单里面存在同样医嘱的先删除原记录
/// Input: PBORowID:DHC_PatBillOrder.RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFPBCANCEL).DELPBO()
ClassMethod DELPBO(PBORowID As %String) As %String
{
	new (PBORowID)
	kill PLIST
	set rtn=##class(web.UDHCJFPBO).SELECT(PBORowID)
	quit:(+rtn) rtn_"^"_$g(%msg)
	set TotalAmount=-PLIST(8)
	set DiscAmount=-PLIST(9)
	set PayorShare=-PLIST(10)
	set PatientShare=-PLIST(11)
	set rtn=##class(web.UDHCJFPBO).PBODEL(PBORowID)
	quit:(+rtn) rtn_"^"_$g(%msg)
	set BILL=+PBORowID
	kill PLIST
  	set rtn=##class(web.UDHCJFPB).SELECT(BILL)
  	quit:(+rtn) rtn_"^"_$g(%msg)
	set PLIST(9)=PLIST(9)+TotalAmount
	set PLIST(10)=PLIST(10)+DiscAmount
	set PLIST(12)=PLIST(12)+PayorShare
	set PLIST(13)=PLIST(13)+PatientShare
	set PLIST(20)=+$h
	set PLIST(21)=$p($h,",",2)
	set rtn=##class(web.UDHCJFPB).UPDATE(BILL)
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

}
