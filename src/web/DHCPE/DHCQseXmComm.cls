Class web.DHCPE.DHCQseXmComm Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

// 2007/12/03 厦门 qse

ClassMethod ReduDepos(suser, PARowid, myAccMRID, PatSum, RefInvID, locId) As %String
{
 //冲减预交金
	;表示利用门诊预交金卡支付
	;AccManRef^PAPMIDR^InvPrtDR^PAPMINo^BillNo^UserDR^PayDate^PayTime
	;^PayNum^PRecLocD
	//n (suser, PARowid, myPAPMINo, myAccMRID,PatSum)
	 S myHosoDR=$p($g(^DHCPEINVPRT(RefInvID)),"^",26)
	s myPAPMINo=##Class(web.PAPatMas).GetRegistration(PARowid)
	s $p(myAPLInfo,"^",1)=myAccMRID  //   $p(ExpStr,"^",3)		;AccManRef
	s $p(myAPLInfo,"^",2)=PARowid		;PAPMIDR
	//s $p(myAPLInfo,"^",3)=""  //INVRowid		;InvPrtDR	
    s $p(myAPLInfo,"^",3)=RefInvID //INVRowid ;InvPrtDR
	s $p(myAPLInfo,"^",4)=myPAPMINo		;PAPMINo
	//s $p(myAPLInfo,"^",5)=""			;BillNo
	s $p(myAPLInfo,"^",5)="PE"			;业务类型
	s $p(myAPLInfo,"^",6)=suser		;;UserDR
	s $p(myAPLInfo,"^",7)=+$h	;+$h	;PayDate
	s $p(myAPLInfo,"^",8)=$p($h,",",2) ;;PayTime
	s $p(myAPLInfo,"^",9)=PatSum	;;PayNum
	//s $p(myAPLInfo,"^",10)=""			;PRecLocDR
	s $p(myAPLInfo,"^",10)=locId			;PRecLocDR
	s $p(myAPLInfo,"^",11)=""			;费别
	s $p(myAPLInfo,"^",12)=""			;预留字段
	s $p(myAPLInfo,"^",13)=myHosoDR			;院区ID

	s PayMode="CPP"
	s PayModeID=$O(^CT("CTPM",0,"Code",PayMode,0))
	s $p(myAPLInfo,"^",12)=PayModeID
	//s myAccMRID=$p(ExpStr,"^",3)		;AccManRef
	b

	;判断帐户对应的Papmi与传入
	//s myAccPAPMIDR=$p($g(^DHCACD("AccM",myAccMRID)),"^",2)		;AccM_PAPMI_DR
	//i (PARowid'=myAccPAPMIDR) d
	//.s rtn=113		;;帐户与登记号不一致
	//q:(+rtn)
	s myrtn=##class(web.UDHCACPayList).INSPayInfo(myAccMRID,myAPLInfo)
	s rtn=$p(myrtn,"^",1)
	q rtn
}

ClassMethod GetCardBalance(CardId) As %String
{
     
     if CardId'="" s balance=$P(^DHCACD("AccM",CardId),"^",8)
     else  s balance="NULL"
     q $G(balance)
}

// %request.Get("EpisodeID")

ClassMethod GetFromEpisToBalance(EpisodeId) As %String
{
	s PapmiDr=$P(^PAADM(EpisodeId),"^",1)
	s cardid="" s cardid=$O(^DHCACDi("AccM",0,"PAPMI",PapmiDr,cardid))
    s balance=..GetCardBalance(cardid)
    q balance
}

Storage Default
{
<Data name="DHCQseXmCommDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.DHCQseXmCommD</DataLocation>
<DefaultData>DHCQseXmCommDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.DHCQseXmCommD</IdLocation>
<IndexLocation>^web.DHCPE.DHCQseXmCommI</IndexLocation>
<StreamLocation>^web.DHCPE.DHCQseXmCommS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
