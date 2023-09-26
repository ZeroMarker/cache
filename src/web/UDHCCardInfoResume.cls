Import SQLUser

/// 卡信息恢复
Class web.UDHCCardInfoResume Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 63;

ClassMethod AutoRepairSec(CardNO As %String, SecNo As %String) As %String
{
	n (CFRowID, SecNo, CardNO)
	;w ##class(web.UDHCCardInfoResume).AutoRepairSec("","")
	;返回0   为正常
	;对于每次读卡自动生成交验码，
	;^DHCACDi("AccM",0,"OCDate",{AccM_OCDate},{AccM_RowID})
	;需要
	q:'$d(^DHCCardBackTMP20060703(CardNO)) 0
	
	s myCFRowID=$p($g(^DHCCardBackTMP20060703(CardNO)),"^",2)
	s mySecNo1=$p(^DHCCARD("CF",myCFRowID),"^",3)
	;如果有退出
	q:(mySecNo1'="") 0
	
	q:(SecNo="") 0
	s myPAPMINO=$e(SecNo,1,8)
	
	q:(CardNO'=myPAPMINO) 0
	
	s mySecNO=##class(web.UDHCAccEnrypt).Encrypt(SecNo)
	s myCFRowID=$p(^DHCCardBackTMP20060703(CardNO),"^",2)
	s $p(^DHCCARD("CF",myCFRowID),"^",3)=mySecNO
	
	q 0
}

/// 修复卡表，使账户表与卡表建立关联
ClassMethod CardRefRepair() As %String
{
	;w ##class(web.UDHCCardInfoResume).CardRefRepair()
	
	s myAccRowID=0
	
	;^DHCACDi("AccM",0,"OCDate",{AccM_OCDate},{AccM_RowID})
	;2006-07-03
	
	
	s myrtn=0
	
	tstart
	
	
	;先生成卡号与登记号的对照，见yn
	;需要修改mdata()
	s myPAPMI=0
	;^PAPER({PAPMI_RowId})
	f  s myPAPMI=$o(^PAPER(myPAPMI))  q:(myPAPMI="")||(+myrtn'=0)  d
	.s myCFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPAPMI,0))
	.q:(myCFRowID'="")
	.s PAPMINo=##Class(web.PAPatMas).GetRegistration(myPAPMI)
	.&sql(insert into SQLUSER.DHC_cardref (cf_cardno,cf_papmi_dr,cf_papmino) 
		values(:PAPMINo,:myPAPMI,:PAPMINo))
	.s myrtn=SQLCODE
	
	b	;PAPMI
	
	s myCurDate=60449
	
	;建立账户与卡的对照关系
	f  s myAccRowID=$o(^DHCACDi("AccM",0,"OCDate",myCurDate,myAccRowID))  q:(myAccRowID="")!(+myrtn'=0)  d
	.;^DHCACD("AccM",{AccM_RowID})
	.q:($d(^DHCACD("AccM",myAccRowID))=10)
	.s myPAPMIDR=$p(^DHCACD("AccM",myAccRowID),"^",2)
	.s myAccNODR=myAccRowID
	.s myCardNo=$p(^DHCACD("AccM",myAccRowID),"^",4)
	.s myIDCardNO=$p(^DHCACD("AccM",myAccRowID),"^",18)
	.s myPAPMINo=$p(^DHCACD("AccM",myAccRowID),"^",3)
	.s myDate=$p(^DHCACD("AccM",myAccRowID),"^",5)
	.s myTime=$p(^DHCACD("AccM",myAccRowID),"^",6)
	.s myUserDR=$p(^DHCACD("AccM",myAccRowID),"^",7)
	.s myActFlag="N"
	.s myDateFrom=$p(^DHCACD("AccM",myAccRowID),"^",5)
	.;
	.;^DHCCARDi("CF",0,"PAPMIDR",{CF_PAPMI_DR},{CF_RowID})
	.s myCFRowID=0
	.s myCFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",myPAPMIDR, myCFRowID))
	.w !,myCardNo
	.i myCFRowID="" d
	..w !, myAccRowID
	..b   ;myCFRowID=""
	.k PLIST
	.s myrtn=##class(web.UDHCCardRef).SELECT(myCFRowID)
	.q:(+myrtn)
	.q:(PLIST(4)'="")		;交验码<>""  out
	.s PLIST(2)=myAccNODR
	.;s PLIST(3)=""
	.;s PLIST(4)=""
	.s PLIST(5)=myPAPMIDR
	.s PLIST(6)=myIDCardNO
	.;s PLIST(7)=""
	.s PLIST(8)=myDate
	.s PLIST(9)=myTime
	.s PLIST(10)=myUserDR
	.s PLIST(11)="N"
	.s PLIST(12)=myDateFrom
	.s myrtn=##class(web.UDHCCardRef).UPDATE(myCFRowID)
	.s ^DHCCardBackTMP20060703(myCardNo)=myCardNo_"^"_myCFRowID
	.q:(+myrtn)
	.;Inser State
	.k PLIST
	.s PLIST(0)=myCFRowID
	.s PLIST(3)=myDate
	.s PLIST(4)=myTime
	.s PLIST(5)="N"
	.s PLIST(6)=myUserDR
	.s myrtn=##class(web.UDHCCardStatusChange).INSERT()
	.s myACStatRowID=PLIST(1)
	.;s $p(^DHCCARD("CF",+myACStatRowID,"CSC",$p(myACStatRowID,"||",2)),"^",3)="N"
	.
	.;b	;myrtn
	
	b   ;tro
	
	i +myrtn=0 d
	.tcommit
	e  d 
	.tro
	
	q 0
}

}
