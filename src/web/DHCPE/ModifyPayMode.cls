Import SQLUser

Class web.DHCPE.ModifyPayMode Extends %RegisteredObject
{

/// d ##Class(%ResultSet).RunQuery("web.DHCPE.ModifyPayMode","FindOldPayMode","AD00002916")
Query FindOldPayMode(InvID As %String = "") As websys.Query(ROWSPEC = "ARCCPayModeDR:%String,PayModeID:%String,PayInfo:%String")
{
}

ClassMethod FindOldPayModeExecute(ByRef qHandle As %Binary, InvID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    //s InvID=$O(^DHCPEINVPRT(0,"INV",InvNo,0))
	q:InvID="" 
	s ARRCP=$p(^DHCPEINVPRT(InvID),"^",4)
	s PayModeInfo=""
	s Sub=0
	f  s Sub=$O(^ARRCP(ARRCP,"PAYM",Sub)) q:Sub=""  d
	.S ARCCPayModeDR=ARRCP_"||"_Sub
	.s PayModeID=$P(^ARRCP(ARRCP,"PAYM",Sub),"^",1)
	.s PayMode=$P(^CT("CTPM",PayModeID),"^",2)
	.s Amt=$P(^ARRCP(ARRCP,"PAYM",Sub),"^",3)
	.i ((Amt[".")&&(Amt'="")) d
	..i $p(Amt,".",1)="" s Amt=0_Amt
	.s PayInfo=PayMode_"  "_$fn(Amt,",",2)
	.s ^CacheTemp(repid,ind)=$lb(ARCCPayModeDR,PayModeID,PayInfo)
	.s ind=ind+1
    
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCPE.ModifyPayMode).GetInvInfoByInvNo(51644001,"")
ClassMethod GetInvInfoByInvNo(InvNo, Type, UserID)
{
	s ID=$O(^DHCPEINVPRT(0,"INV",InvNo,0))
	q:ID="" "NoData"
	s InvName=$G(^DHCPEDataEx("InvName",ID))
	i Type="R"{
		s ID=$O(^DHCPEINVPRT(0,"REF",ID,0))
		q:ID="" "NoRefData"
	}
	s ReportID=$P(^DHCPEINVPRT(ID),"^",13)
	q:ReportID'="" "HadReport"
	s CurUserID=$P(^DHCPEINVPRT(ID),"^",10)
	q:CurUserID'=UserID "UserNotOne"
	s Amount=$P(^DHCPEINVPRT(ID),"^",7)
	s paadm=$p(^DHCPEINVPRT(ID),"^",2)	
	s patid=$p($g(^PAADM(paadm)),"^",1)
	s PatName=$p($g(^PAPER(patid,"ALL")),"^",1)
	i InvName'="" s PatName=PatName_"("_InvName_")"
	s ARRCP=$p(^DHCPEINVPRT(ID),"^",4)
	s PayModeInfo=""
	s Sub=0
	f  s Sub=$O(^ARRCP(ARRCP,"PAYM",Sub)) q:Sub=""  d
	.s PayModeID=$P(^ARRCP(ARRCP,"PAYM",Sub),"^",1)
	.s PayMode=$P(^CT("CTPM",PayModeID),"^",2)
	.s Amt=$P(^ARRCP(ARRCP,"PAYM",Sub),"^",3)
	.s OneInfo=ARRCP_"||"_Sub_$C(2)_PayMode_" "_Amt
	.i PayModeInfo="" d
	..s PayModeInfo=OneInfo
	.e  d
	..s PayModeInfo=PayModeInfo_$C(1)_OneInfo
	i ((Amount[".")&&(Amount'="")) d
	.i $p(Amount,".",1)="" s Amount=0_Amount
	q PatName_"^"_$fn(Amount,",",2)_"^"_PayModeInfo
}

ClassMethod Update(ARCCPayModeDR, PayModeDR, No)
{
	s OldPayMode=$P(^ARRCP(+ARCCPayModeDR,"PAYM",$P(ARCCPayModeDR,"||",2)),"^",1)
	&sql(update AR_RcptPayMode set PAYM_PayMode_DR=:PayModeDR,PAYM_CardChequeNo=:No where PAYM_RowID=:ARCCPayModeDR)
	i SQLCODE=0{
		s Sub=$i(^DHCPEDataEx("DHCPEInvPrt","ModifyPayMode",ARCCPayModeDR))
		s ^DHCPEDataEx("DHCPEInvPrt","ModifyPayMode",ARCCPayModeDR,Sub)=OldPayMode_"^"_PayModeDR
	}
	q SQLCODE
}

ClassMethod GetOldPaymode(ARCCPayModeDR)
{
	q:ARCCPayModeDR'["||" ""
	q:'$d(^ARRCP(+ARCCPayModeDR,"PAYM")) ""
	s OldPayMode=$P(^ARRCP(+ARCCPayModeDR,"PAYM",$P(ARCCPayModeDR,"||",2)),"^",1)
	q OldPayMode
}

ClassMethod IsExtPayMode(PayModeDR)
{
	s payCode=$P(^CT("CTPM",PayModeDR),"^",1)
	q $G(^DHCPESetting("DHCPE","ExtPayModeCode"))[("^"_payCode_"^")
}

}
