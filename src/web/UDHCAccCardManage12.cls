Class web.UDHCAccCardManage12 Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

ClassMethod grantcardNEW(str As %Library.String = "", CardINVRowID As %String) As %String
{
	n (str, CardINVRowID)
	//str=RegNo_"^"_papmi_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_
	//DateFrom_"^"_DateTo_"^"_user_"^"_IP
 	s rtn=0
	
	s papmi=$p(str,"^",2)
	q:papmi="" "-301^"
	;s ren=##class(web.UDHCAccCardManage0).getcardbypapmi(papmi)
	;q:ren'="1" ren_"^"
	s cardno=$p(str,"^",4)
	q:cardno="" "-303^"
	
	;需求更改；如果卡被回收，可以发卡
	;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	s myCardRowID=0
	f  s myCardRowID=$o(^DHCCARDi("CF",0,"CardNo",cardno,myCardRowID)) q:((myCardRowID="")!(+rtn'=0))  d
	.;^DHCCARD("CF",{CF_RowID})
	.s myCardFlag=$p($g(^DHCCARD("CF",myCardRowID)),"^",10)
	.;如果卡是正常或是挂失，不能重发，只能换卡，或补卡
	.;只有卡被作废，回收后能够重发
	.i (myCardFlag="N")!(myCardFlag="S")!(myCardFlag="") d
	..s rtn=-304
	
	q:rtn rtn_"^"
	
	k PLIST
	s ren=""
	s securityno=$p(str,"^",10)
	s securityno1=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s PLIST(3)=$p(str,"^",4)
	s PLIST(4)=securityno1
 	s PLIST(5)=$p(str,"^",2)
 	s PLIST(6)=$p(str,"^",3)
 	s PLIST(7)=$p(str,"^",1)
 	s PLIST(8)=+$H
 	s PLIST(9)=$p($H,",",2)
 	s PLIST(10)=$p(str,"^",8)
 	s PLIST(11)="N"
 	s datefrom=$p(str,"^",6)
 	s dateto=$p(str,"^",7)
 	i datefrom["/"  s PLIST(12)=$zdh(datefrom,4)
 	i dateto["/"  s PLIST(13)=$zdh(dateto,4)
	s PLIST(17)=$p(str,"^",11)
	s PLIST(18)=CardINVRowID
	
	s ren=##Class(web.UDHCCardRef).INSERT()
	
	s myCardRowID=PLIST(1)
	i ren=0  d  s ren=##class(web.UDHCAccCardManage0).CardStatusRecord(myRowID,"N",$p(str,"^",8),$p(str,"^",9),"")
	
	q ren_"^"_securityno_"^"_myCardRowID
}

ClassMethod GetCardFareCost(CardTypeID As %String, CardNo As %String) As %String
{
	n (CardTypeID, CardNo)
	
	s CardAmt=0
	q:((CardTypeID="")||(CardNo="")) CardAmt
	
	s CardID=""
	f  s CardID=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeID,CardNo,CardID),-1) q:(CardID="")  d
	.s CardFlag=$p($g(^DHCCARD("CF",CardID)),"^",10)
	.q:(CardFlag'="N")
	.s CardInvDr=$p($g(^DHCCARD("CF",CardID)),"^",17)
	.q:(CardInvDr="")
	.s CardAmt=+$p($g(^DHCCARDINVPRT(CardInvDr)),"^",3)
	
	s CardAmt=$fn(CardAmt,"",2)
	
	q CardAmt
}

}
