Import SQLUser

Class web.udhcOPBill Extends BILL.COM.Abstract
{

ClassMethod GetPresPhw()
{
	kill ^TMP1("Loc",$j)
	set instypenot=""
	for  set instypenot=$o(^TMP1("OPOrdITEM",$j,instypenot)) quit:(instypenot="")  do
	.set PBOrderRowid=""
	.for  set PBOrderRowid=$o(^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid)) quit:(PBOrderRowid="")  do
	..set info=^TMP1("OPOrdITEM",$j,instypenot,PBOrderRowid)
	..set loctype=$p(info,"^",13)
	..set Presno=$p(info,"^",10)
	..set reloc=$p(info,"^",3)
	..set billno=$p(info,"^",14)
	..if ((loctype="D")&&(Presno'=""))  do
	...if ('$d(^TMP1("Bill",$j,billno))) set ^TMP1("Bill",$j,billno)=billno
	...//统计接收科室?药房?
	...if ('$d(^TMP1("Loc",$j,reloc))) set ^TMP1("Loc",$j,reloc)=reloc
	...if ('$d(^TMP1("Loc",$j,reloc,Presno))) set ^TMP1("Loc",$j,reloc,Presno)=Presno
	...//统计处方号
	...if (Presno'="") do
	....if ('$d(^TMP1("Pres",$j,Presno)))  set ^TMP1("Pres",$j,Presno)=Presno
	
	if ($d(^TMP1("Pres",$j))) do
	.set presinfo=""
	.set ipres=""
	.for  set ipres=$o(^TMP1("Pres",$j,ipres)) quit:(ipres="")  do
	..set presinfo=presinfo_"^"_^TMP1("Pres",$j,ipres)
	
	quit 0
}

/// w ##class(web.udhcOPBill).GetnobilledCount("7^8","")
ClassMethod GetnobilledCount(PAADMStr As %String = "", unBillStr As %String) As %String
{
	set nCount=0
	
	set PALen=$l(PAADMStr,"^")
	for i=1:1:PALen  {
		set adm=$p(PAADMStr,"^",i)
		set ord=$o(^OEORD(0,"Adm",adm,0))
		continue:(ord="")
		set itm=0
		while($o(^OEORD(ord,"I",itm))) {
			set itm=$o(^OEORD(ord,"I",itm))
			continue:('$d(^OEORD(ord,"I",itm,1)))
			continue:(("^"_unBillStr_"^")[("^"_ord_"||"_itm_"^"))
			set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
			continue:(" P I "[(" "_billed_" "))
			set itemstat=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
			set statcode=$s((+itemstat'=0):$p($g(^OEC("OSTAT",itemstat)),"^",1),1:"")
			continue:(" V E "'[(" "_statcode_" "))
			set nCount=$i(nCount)
		}
	}
	
	quit nCount
}

/// w ##class(web.udhcOPBill).GetreceipNO("","","10137")
ClassMethod GetreceipNO(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
	set usr=val
	set myrtn=..ReadReceiptNO(usr)
	set rtn=$p(myrtn,"^",1)
	quit:(+rtn) 100
	set sno=$p(myrtn,"^",2)
	set sid=$p(myrtn,"^",3)
	set str=sno
	set retval=itmjs_"('"_$zcvt(str,"O","JS")_"');"
	//if (itmjsex'="""") set retval=retval_itmjsex_"('"_$zcvt(str,"O","JS")_"');"
	&javascript<#(retval)#>
	quit rtn
}

/// Input: instr:PayAmt^PayMode^CardNo
/// Debug: w ##class(web.udhcOPBill).InsertReceipts("", 1, 2, 3)
ClassMethod InsertReceipts(instr As %String, userId As %String, ctLocId As %String, patientId As %String)
{
	set rtn=0
	
	&SQL(
		INSERT INTO AR_Receipts (
			ARRCP_Location_DR, ARRCP_RecvAmt, ARRCP_AddUserID, ARRCP_PAPMI_DR
		)
		VALUES (
			:ctLocId, 0, :userId, :patientId
		)
	)
 	set rtn=SQLCODE
 	if (+rtn) quit rtn_"^"_$g(%msg)
 	set id=$g(%ROWID)
	
	set mylen=$l(instr,$c(2))
	for i=1:1:mylen {
		set mySPayInfo=$p(instr,$c(2),i)
		continue:(mySPayInfo="")
		set payAmt=$p(mySPayInfo,"^",1)
		set paymode=$p(mySPayInfo,"^",2)
		set cardno=$p(mySPayInfo,"^",3)
		&SQL(
			INSERT INTO AR_RcptPayMode (
				PAYM_ParRef, PAYM_PayMode_DR, PAYM_Amt, PAYM_CardChequeNo
			)
			VALUES (
				:id, :paymode, :payAmt, :cardno
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) quit rtn
	
	quit rtn_"^"_id
}

ClassMethod KTMP()
{
	kill ^TMP1("Pres",$j)
	kill ^TMP1("Loc",$j)
	kill ^TMP1("OPITEM",$j)
	kill ^TMP1("OPOrdITEM",$j)
	kill ^TMP1("Bill",$j)
}

/// w ##class(web.udhcOPBill).ReadReceiptNO("23351")
ClassMethod ReadReceiptNO(UserDR As %String) As %String
{
	set myReceiptNo=""
	set rid=""
	set endno="", title=""
	set rtn=108
	quit:(UserDR="") rtn	//没有发票
	set myINVType="O"		//默认为门诊发票
	
	set myINVRowID=0
	while($o(^DHCINVOICE(0,"USER",UserDR,myINVRowID))) {
		set myINVRowID=$o(^DHCINVOICE(0,"USER",UserDR,myINVRowID))
		set myINVData=$g(^DHCINVOICE(myINVRowID))
		set myFinFlag=$p(myINVData,"^",7)
		set myType=$p(myINVData,"^",8)
		continue:((myFinFlag'="Y")||(myType'=myINVType))   //条件不等退出
		set myReceiptNo=$p(myINVData,"^",6)
		set rid=myINVRowID
		set endno=$p(myINVData,"^",2)
		set myBegNo=$p(myINVData,"^",1)
		set title=$p(myINVData,"^",16)
		continue:(+myReceiptNo<+myBegNo)
		continue:(+myReceiptNo>+endno)
		set rtn=0
		quit
	}
	
	quit rtn_"^"_myReceiptNo_"^"_rid_"^"_endno_"^"_title
}

ClassMethod UpdateReceipNO(userId As %String, rcpno As %String, GroupDR As %String = "", FairType As %String = "", InsType As %String = "", HospDR As %String = "") As %String
{
	set rtn=0
	
	set checkstr="1234567890"
	set rcpno1=$e(rcpno,1,1)
	if (checkstr'[rcpno1) set rcpno=$e(rcpno,2,$l(rcpno))
	
	set myUseINVType="O"
	if (GroupDR'="") {
		set myGSVal=##class(web.UDHCOPGSConfig).ReadCFByGRowID(GroupDR, HospDR)
		set rtn=$p(myGSVal,"^",1)
		quit:(+rtn) rtn
		set myGSUseINVType=$p(myGSVal,"^",13)
		if (myGSUseINVType'="") {
			set myUseINVType=myGSUseINVType
		}
	}
	
	//增加费别与发票类型的配置，按如果做了费别与发票类型的配置则按费别取发票类型
	set myInsINVType=##class(web.UDHCJFPAY).GetInvTypeByAdmRea(InsType, "O", HospDR)
	if (myInsINVType'="") set myUseINVType=myInsINVType
	
	set myRegReceiptType=##class(web.udhcOPBill7).GetRegReceiptType(HospDR)
	if ((FairType="R")&&(myRegReceiptType'="")) set myUseINVType=myRegReceiptType

	set startno="", endno="", rowid=""
	&SQL(
		SELECT TOP 1 INV_StartInv, INV_EndInv, %ID INTO :startno, :endno, :rowid
		FROM DHC_INVOICE
		WHERE INV_Usr = :userId AND INV_Finalflag = 'Y' AND INV_type = :myUseINVType AND INV_hospital = :HospDR
		ORDER BY %ID
	)
	
	set len=$l(endno)
	if ($l(rcpno)<len) {
		set rcpno=##class(web.UDHCJFBaseCommon).FormatINVNO(rcpno, len)
	}
	
	set curlen=$l(rcpno)
	quit:(len'=curlen)||(+rcpno<+startno)||(+rcpno>+(endno+1)) -202  //add by zhl 增加发票号段归属判断
	
	if (rcpno>endno) {
		&SQL(
			UPDATE DHC_INVOICE
			SET INV_Finalflag = 'N'
			WHERE %ID = :rowid
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
		&SQL(
			SELECT TOP 1 %ID INTO :rowid1
			FROM DHC_INVOICE
			WHERE (INV_Finalflag='' OR INV_Finalflag IS NULL) AND INV_Usr = :userId AND INV_type = :myUseINVType AND INV_hospital = :HospDR
			ORDER BY %ID
		)
		if (+rowid1'=0) {
			&SQL(
				UPDATE DHC_INVOICE
				SET INV_Finalflag = 'Y'
				WHERE %ID = :rowid1
			)
			set rtn=SQLCODE
			quit:(+rtn) rtn_"^"_$g(%msg)
		}
	}else {
		&SQL(
			UPDATE DHC_INVOICE
			SET INV_LastNum = :rcpno
			WHERE %ID = :rowid
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
	}
	
	quit rtn
}

/// w ##class(web.udhcOPBill).Updatearpbl(276851, 6476)
ClassMethod Updatearpbl(billId As %String, userId As %String, curDate As %Date = {+$h}, curTime As %Time = {$p($h,",",2)}) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	&SQL(
		UPDATE DHC_PatientBill AS PB
		SET PB_AmountPaid = PB.PB_TotalAmount, PB_AmountToPay = PB.PB_TotalAmount, PB_PayedFlag = 'P',
			PB_UpdateDate = :curDate, PB_UpdateTime = :curTime, PB_UpdateUser = :userId
		WHERE %ID = :billId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	
	set rtn=..updateitms(billId)
	
	quit rtn

ERROR
	quit ..AppException()
}

/// 更新医嘱表收费状态
/// Debug: w ##class(web.udhcOPBill).updateitms(276851, 6476)
ClassMethod updateitms(pb As %String) As %String
{
	set rtn=0
	
	set isStayCharge="N"
	set billConInvDR=$o(^DHCBCI(0,"Bill",pb,0))
	if (billConInvDR'="") {
		set prtRowId=$p(^DHCBCI(billConInvDR),"^",1)
		set isStayCharge=$p(^DHCINVPRT(prtRowId),"^",44)
	}
	set pbo=0
	while($o(^DHCPB(pb,"O",pbo))&&(rtn=0)) {
		set pbo=$o(^DHCPB(pb,"O",pbo))
		set pboData=$g(^DHCPB(pb,"O",pbo))
		continue:(pboData="")
		set pboRowId=pb_"||"_pbo
		set oeitm=$p(pboData,"^",4)
		continue:'$d(^OEORD($p(oeitm,"||",1),"I",$p(oeitm,"||",2),1))
		set billStatus=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)
		set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)="P"
		if (billStatus'="P") {
			set $p(^DHCPB(pb,"O",pbo),"^",16)=billStatus
		}
		set priceDate=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",15)
		set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
		set itm=0
		while($o(^DHCPB(pb,"O",pbo,"D",itm))&&(rtn=0)) {
			set itm=$o(^DHCPB(pb,"O",pbo,"D",itm))
			set pbdData=$g(^DHCPB(pb,"O",pbo,"D",itm))
			set $p(^DHCPB(pb,"O",pbo,"D",itm),"^",14)="P"
			set price=$p(pbdData,"^",4)
			set dspbDR=$p(pbdData,"^",27)
			//加入检查申请单的计费状态的更新，由B更新为P
			if (isAppRepFlag="Y") {
				set rtn=..UpdateAppRepTarItm(oeitm, pboRowId)
				quit:(+rtn)
			}
			//调用药房组接口更新打包子表价格
			if ((isStayCharge'="Y")&&(+dspbDR'=0)) {
				set rtnValue=##class(PHA.FACE.OUT.Com).UpdateDspbPrice(dspbDR, price, priceDate, 2)
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) {
					set rtn=+rtn_"^"_"药房组接口[PHA.FACE.OUT.Com||UpdateDspbPrice("_$lts($lb(dspbDR, price, priceDate, 2))_")]失败:"_rtnValue
					quit
				}
			}
		}
	}
	
	quit rtn
}

ClassMethod UpdateAppRepTarItm(oeitm As %String, pbo As %String) As %String
{
	set rtn=0
	set newStatus="P"
	set itmDr=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))) {
		set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))
		set artiDr=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))) {
			set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))
			set artiData=$g(^DHCAPREPTA(artiDr))
			set billStatus=$p(artiData,"^",9)     //账单状态
			continue:(" B P "'[(" "_billStatus_" "))
			&SQL(
				UPDATE DHC_AppRepTarItm
				SET ARTI_Billed = :newStatus, ARTI_PBO_Dr = :pbo
				WHERE %ID = :artiDr)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
		quit:(+rtn)
	}
	
	quit rtn
}

}
