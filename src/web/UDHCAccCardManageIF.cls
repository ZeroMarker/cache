Import SQLUser

Class web.UDHCAccCardManageIF Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 202;

ClassMethod getpatinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", regno As %Library.String = "", patientid As %Library.String = "", cardno As %Library.String = "", cardverify As %Library.String = "", idno As %Library.String = "")
{
}

ClassMethod regnocon(regno1 As %String) As %String
{
	q:regno1=""
	s reglen=$l(regno1)
	f i=reglen:1:7  d
	.s regno1="0"_regno1
    q regno1
}

ClassMethod getcardbypapmi(papmi As %Library.String) As %Library.String
{
	q:papmi="" "-301"
	s bPAPMI="1"
	s cfrowid="0"
	f  s cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,cfrowid))  q:cfrowid=""  d
 	.s ActiveFlag=$p(^DHCCARD("CF",cfrowid),"^",10)
 	.q:(ActiveFlag'="N")&(ActiveFlag'="S")
 	.s bPAPMI="-302"
	q bPAPMI
}

ClassMethod grantcard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "") As %String
{
	s $ZT="ERROR^DHCSSERR"
	
	;需求更改；如果卡被回收，可以发卡
	
	d ##Class(web.UDHCCardRef).tb()
	s rtn=..grantcardNEW(str)
	
	i $p(rtn,"^",1)=0  d 
	.d ##Class(web.UDHCCardRef).tc()
	e  d  
	.TROLLBACK
	
	q rtn
}

ClassMethod grantcardNEW(CardInfo As %Library.String = "", ExpStr As %String) As %String
{
	n (CardInfo, ExpStr)
	s rtn=0
	
	
	q ren_"^"_securityno
}

ClassMethod grantcardUpdate(str As %Library.String = "") As %String
{
	n (str)
	//RegNoObj.value+"^"+PatientID+"^"+IDCardNo1Obj.value+"^"+CardNoObj.value+"^"+CardVerify
	//+"^"+""+"^"+""+"^"+Guser+"^"+computername+"^"+CardID+"^"+mySecrityNo
	//str=RegNo_"^"_papmi_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_DateFrom_"^"_DateTo_"^"_user_"^"_IP_"^"_CardID
 	s papmi=$p(str,"^",2)
 	q:papmi="" "-301^"
 	s ren=..getcardbypapmi(papmi)
 	q:ren'="1" ren_"^"
 	s cardno=$p(str,"^",4)
 	q:cardno="" "-303^"
 	s cardid=$p(str,"^",10)
 	q:cardid="" "-303^"
 	q:'$d(^DHCCARD("CF",cardid)) "-303^"
 	//q:$d(^DHCCARDi("CF",0,"CardNo",cardno)) "-304^"
 	k PLIST
 	s ren=""
 	
 	s securityno=$p(str,"^",11)				;CF_SecurityNO
	
 	s securityno1=##class(web.UDHCAccEnrypt).Encrypt(securityno)
 	s PLIST(3)=$p(str,"^",4)			;CF_CardNo
 	s PLIST(4)=securityno1				;CF_SecurityNO
 	s PLIST(5)=$p(str,"^",2)			; CF_PAPMI_DR
 	s PLIST(6)=$p(str,"^",3)			;
 	s PLIST(7)=$p(str,"^",1)
 	s PLIST(8)=+$H
 	s PLIST(9)=$p($H,",",2)
 	s PLIST(10)=$p(str,"^",8)
 	s PLIST(11)="N"
 	s datefrom=$p(str,"^",6)
 	s dateto=$p(str,"^",7)
 	i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	i dateto["/"  s PLIST(13)=$zdh(dateto,4)
 	i datefrom=""  s PLIST(12)=+$H
 	//s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
	
	s ren=##Class(web.UDHCCardRef).UPDATE(cardid)
	i ren=0  d  s ren=..CardStatusRecord(cardid,"N",$p(str,"^",8),$p(str,"^",9),"")
 	
	q ren_"^"_securityno
}

ClassMethod exchangecard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "", RLinfo As %String = "") As %String
{
	s $ZT="ERROR^DHCSSERR" 
 	d ##Class(web.UDHCCardRef).tb()
 	
 	s rtn=..exchangecardNEW(str,RLinfo)
 	
 	;写入状态
	
	i ($p(rtn,"^",1)=0)  d 
	.d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	
	q rtn
}

ClassMethod exchangecardNEW(str As %Library.String = "", RLinfo As %String = "") As %String
{
	n (str,RLinfo)
	//str=CardID_"^"_CardNo_"^"_SecurityNO_"^"_user_"^"_IP_"^"_oldcardstatus
 	s newcardid=""
 	s CardID=$p(str,"^",1)
 	s CardNo=$p(str,"^",2)
 	s SecurityNO=$p(str,"^",3)
 	q:(CardID="")!(CardNo="") "100^"
 	
 	s RegNo=$p(^DHCCARD("CF",CardID),"^",6)
 	
 	s SecurityNO=$p(str,"^",7)
 	s SecurityNO1=##class(web.UDHCAccEnrypt).Encrypt(SecurityNO)
 	s ren=##Class(web.UDHCCardRef).SELECT(CardID)
 	q:ren'=0 "100^"
 	m mPLIST=PLIST
 	s cardflag=$p(^DHCCARD("CF",CardID),"^",10)
 	//s CardReqSuspend=##Class(web.UDHCAccManageCLS).getCardReqSuspend()
 	s SDateDiff=##Class(web.UDHCAccManageCLS).getSDateDiff()
 	q:('$d(^DHCCARD("CF",CardID,"CSC")))&(cardflag="S") "-310^"
 	s RLdiff=0
 	i cardflag="S"  d
 	.s pscsub=$o(^DHCCARD("CF",CardID,"CSC",""),-1)
 	.s RLdate=$p(^DHCCARD("CF",CardID,"CSC",pscsub),"^",1)
 	.s RLdiff=+$H-RLdate
 	s rday=SDateDiff-RLdiff
 	q:(RLdiff<SDateDiff)&(cardflag="S") "-311^"_rday
 	
 	//s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s ren=..CardStatusChange(CardID,$p(str,"^",6),$p(str,"^",4),$p(str,"^",5),"")
	
 	q:ren'=0 ren_"^"
 	i cardflag="S" d
 	.s accid=$p(^DHCCARD("CF",CardID),"^",1)
 	.q:accid=""
 	.s accstatus=$p(^DHCACD("AccM",accid),"^",13)
 	.q:accstatus'="S"
 	.s ren=##Class(web.UDHCAccManageCLS).AccountStatusChange(accid,"S","N",$p(str,"^",4),$p(str,"^",5),RLinfo)
 	
 	q:ren'=0 ren_"^111"
 	k PLIST
 	m PLIST=mPLIST
 	k PLIST(1),PLIST(14),PLIST(15),PLIST(16)
 	s PLIST(3)=CardNo
 	s PLIST(4)=SecurityNO1
 	s PLIST(8)=+$H
 	s PLIST(9)=$p($H,",",2)
 	s PLIST(10)=$p(str,"^",4)
 	s PLIST(11)="N"
 	;s datefrom=$p(str,"^",6)
 	;s dateto=$p(str,"^",7)
 	;i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	;i dateto["/"  s PLIST(13)=$zdh(dateto,4)
 	
	s ren=##Class(web.UDHCCardRef).INSERT()
	
	i ren=0  d  
	.s newcardid=myRowID
	.s ren=..CardStatusRecord(myRowID,"N",$p(str,"^",4),$p(str,"^",5),RLinfo)
	//i ren=0  d ##Class(web.UDHCCardRef).tc()
	//e  TROLLBACK
 	
	q ren_"^"_SecurityNO_"^"_newcardid_"^"_CardNo
}

ClassMethod reportlosscard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "", RLinfo As %String = "") As %String
{
	s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s rtn=..reportlosscardNEW(str,RLinfo)
 	i rtn=0  d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	q rtn
}

ClassMethod reportlosscardNEW(str As %Library.String = "", RLinfo As %String = "") As %String
{
 	n (str,RLinfo)
 	//str=CardID_"^"_user_"^"_IP
 	s CardID=$p(str,"^",1)
 	s user=$p(str,"^",2)
 	s IP=$p(str,"^",3)
 	q:CardID="" "100"
 	q:'$d(^DHCCARD("CF",CardID)) "100"
 	s cardstatus=$p(^DHCCARD("CF",CardID),"^",10)
 	q:cardstatus'="N" "100"
 	//s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s ren=..CardStatusChange(CardID,"S",user,IP,RLinfo)
 	q:ren'=0 ren
 	s accid=$p(^DHCCARD("CF",CardID),"^",1)
 	q:accid="" "100"
 	s accstatus=$p(^DHCACD("AccM",accid),"^",13)
 	q:accstatus'="N" "100"
 	s ren=##Class(web.UDHCAccManageCLS).AccountStatusChange(accid,"N","S",user,IP,RLinfo)
	q ren
}

ClassMethod refundcard(itmjs As %Library.String = "", itmjsex As %Library.String = "", str As %Library.String = "") As %String
{
	s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
 	s rtn=..refundcardNEW(str)
 	i rtn=0  d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	q rtn
}

ClassMethod refundcardNEW(str As %Library.String = "") As %String
{
 	n (str)
 	//str=CardID_"^"_user_"^"_IP
 	s CardID=$p(str,"^",1)
 	s user=$p(str,"^",2)
 	s IP=$p(str,"^",3)
 	q:CardID="" "100"
 	q:'$d(^DHCCARD("CF",CardID)) "100"
 	s cardstatus=$p(^DHCCARD("CF",CardID),"^",10)
 	q:cardstatus'="N" "100"
 	s accid=$p(^DHCCARD("CF",CardID),"^",1)
 	s accstatus=""
 	i accid'=""  s accstatus=$p(^DHCACD("AccM",accid),"^",13)
 	q:(accid'="")&(accstatus'="F") "notfoot" 	
 	s ren=..CardStatusChange(CardID,"R",user,IP,"")
	q ren
}

ClassMethod CardStatusChange(cfrowid As %String, status As %String, userid As %String, IP As %String, RLinfo As %String) As %String
{
	;w ##class(web.UDHCAccCardManage).CardStatusChange(cfrowid, status, userid , IP , RLinfo)
	k PLIST
 	s PLIST(11)=status
 	s PLIST(14)=+$H
	s PLIST(15)=$p($H,",",2)
	s PLIST(16)=userid
	s ren=##Class(web.UDHCCardRef).UPDATE(cfrowid)
	i ren=0  d  s ren=..CardStatusRecord(cfrowid,status,userid,IP,RLinfo)
	q ren
}

ClassMethod CardStatusRecord(cfrowid As %String, status As %String, userid As %String, IP As %String, RLinfo As %String) As %String
{
	k PLIST
	s PLIST(0)=cfrowid
	s PLIST(3)=+$H
	s PLIST(4)=$p($H,",",2)
	s PLIST(5)=status
	s PLIST(6)=userid
	s PLIST(7)=IP
	i RLinfo'=""  d
	.s PLIST(13)=$p(RLinfo,"^",1)
	.s PLIST(14)=$p(RLinfo,"^",2)
	.s PLIST(15)=$p(RLinfo,"^",3)
	.s PLIST(16)=$p(RLinfo,"^",4)
	.s PLIST(17)=$p(RLinfo,"^",5)
	.s PLIST(18)=$p(RLinfo,"^",6)
	.s PLIST(19)=$p(RLinfo,"^",7)
	s ren=##Class(web.UDHCCardStatusChange).INSERT()

	q ren
}

ClassMethod ReadACardByPANo(CardNo As %String) As %String
{
	;通过卡号获取校验码
	;w ##class(web.UDHCAccCardManage).ReadACardByPANo("")
	s mySecrityNo=""
	s PAPMINo=""
	
	q:(CardNo="") ""
	
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	s myCFRowID=0
	f  s myCFRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo, myCFRowID)) q:(myCFRowID="")  d
	.q:($d(^DHCCARD("CF",myCFRowID))=10)
	.s myCardFlag=$p($g(^DHCCARD("CF",myCFRowID)),"^",10)			;ActiveFlag
	.q:myCardFlag'="N"
	.s mySecrityNo=$p($g(^DHCCARD("CF",myCFRowID)),"^",3)			;CF_SecurityNO
	.s PAPMINo=$p($g(^DHCCARD("CF",myCFRowID)),"^",6)			;CF_PAPMINo
	
	s mySecrityNo=##class(web.UDHCAccEnrypt).Decrypt(mySecrityNo)
	
	q mySecrityNo_"^"_PAPMINo
}

}
