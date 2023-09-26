Class web.UDHCOPINVErrCheck Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 27;

ClassMethod CheckAccPayINV(AccPayINVRowID As %String, INVPRTStr As %String) As %String
{
	;AccPayINVRowID  shadow的发票RowID
	;INVPRTStr正式库的INVPRT串
	;w ##class(web.UDHCOPINVErrCheck).CheckAccPayINV()
	;w ##class(web.UDHCOPINVErrCheck).CheckAccPayINV(shadow的发票RowID, 正式库的INVPRT串)
	n (AccPayINVRowID, INVPRTStr)
	;更新集中打印发票机制
	
	;^TMPShadowACCPAYINV
	;1.验证卡支付的状态
	;2.验证金额
	;3.更新AccPayINV和AccPayMode
	;4.更新连接表和DHC_INVPRT表
	
	s myrtn=0
	s myPRTSum=0
	
	s my150PAPMIDR=""
	s myPRTRowID=0
	s mylen=$l(INVPRTStr,"^")
	f i=1:1:mylen  d
	.s myPRTRowID=$p(INVPRTStr,"^",i)
	.q:(myPRTRowID="")
	.s myINVFlag=$p(^DHCINVPRT(PRTRowID),"^",8)
	.s myPrintFlag=$p(^DHCINVPRT(PRTRowID),"^",3)
	.s myPRTSum=+myPRTSum+$p($g(^DHCINVPRT(PRTRowID)),"^",1)
	.i ((myINVFlag'="N")!(myPrintFlag="P")) s myrtn=3
	.i my150PAPMIDR="" d
	..s my150PAPMIDR=$p($g(^DHCINVPRT(PRTRowID)),"^",21)
	.i my150PAPMIDR'=$p($g(^DHCINVPRT(PRTRowID)),"^",21) d
	..s myrtn=4
	
	q:(myrtn=3) "此发票不能被更新发票!"
	
	s myShadowAPISum=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",1)
	
	i +myPRTSum'=+myShadowAPISum d
	.s myrtn=2
	
	q:(myrtn=2) "发票的金额错误,不能更新"
	
	;PAPMIDR 是否一致
	s myShadowPAPMIDR=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",11)	;	
	
	i my150PAPMIDR'=myShadowPAPMIDR d
	.s myrtn=4
	
	q:(myrtn=4) "登记号码不一致!"
	
	s rtn=0
	
	ts
	
	b	;;TS
	k PLIST
	
	;Amount
	s PLIST(2)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",1)	;
	;Flag
	s PLIST(3)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",2)	;
	;Date
	s PLIST(4)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",3)	;
	;Time
	s PLIST(5)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",4)	;
	;PUser_DR
	s PLIST(6)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",5)	;
	;INVNo
	s PLIST(7)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",6)	;
	
	;PAPMI_DR
	s PLIST(12)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",11)	;	
	s myPAPMIDR=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",11)	;	
	s myAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",myPAPMIDR,0))
	;AccMan_DR
	s PLIST(13)=myAccRowID				;$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",12)	;
	;PatientSum
	s PLIST(14)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",13)	;
	;DiscSum
	s PLIST(15)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",14)	;
	;PayorSum
	s PLIST(16)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",15)	;
	;SelfSum
	s PLIST(17)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",16)	;
	;SelfYBSum
	s PLIST(18)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",17)	;
	;RefundSum
	s PLIST(19)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",18)	;
	;InsDiv_DR
	s PLIST(20)=$p(^TMPShadowACCPAYINV(AccPayINVRowID),"^",19)	;
	;INV
	b	;AccPayINV
	
	s APIParRef=""
	s rtn=##class(web.UDHCAccPayINV).INSERT()
	i rtn=0 d
	.s APIParRef=PLIST(1)
	
	s myAPMSub=0
	;^TMPShadowACCPAYINV({DHC_AccPayINV.API_RowID},"P",{APM_Sub})
	
	f  s myAPMSub=$o(^TMPShadowACCPAYINV(AccPayINVRowID,"P",myAPMSub)) q:((myAPMSub="")!(rtn'=0))  d
	.q:$d(^TMPShadowACCPAYINV(AccPayINVRowID,"P",myAPMSub))=10
	.k PLIST
	.s mylen=$l(^TMPShadowACCPAYINV(AccPayINVRowID,"P",myAPMSub),"^")
	.s PLIST(0)=APIParRef
	.f i=1:1:mylen  d
	..s PLIST(i+2)=$p(^TMPShadowACCPAYINV(AccPayINVRowID,"P",myAPMSub),"^",i)
	.s rtn=##class(web.UDHCAccPayINVMode).INSERT()
	
	b	;PayINVMode
	
	i +rtn=0 d
	.s prtlen=$l(INVPRTStr,"^")
	.f j=1:1:prtlen  q:(rtn'=0)  d
	..;ACP_INVPRT_DR^ACP_APINV_DR
	..s myConStr=""
	..q:($p(INVPRTStr,"^",j)="")
	..s myConStr=$p(INVPRTStr,"^",j)_"^"_APIParRef
	..s rtn=##class(web.UDHCACINVColPrt).InsertAINVConPrt(myConStr)
	..q:(+rtn)
	b	;AINVConPRT
	i +rtn=0 d
	.s myrtn=##class(web.UDHCINVPRT).UpdatePrtFlag(INVPRTStr,APIParRef)
	.s rtn=+myrtn
	
	;s mylen=$l(INVPRTStr,"^")
	;f i=1:1:mylen  d
	;.s myPRTRowID=$p(INVPRTStr,"^",i)
	;.q:(myPRTRowID="")
	;.k PLIST
	;.s rtn=##class(web.DHCOPInvoice).SELECT(myPRTRowID)
	;.i +rtn=0 d
	;..s PLIST(17)="P"
	;..s rtn=##class(web.DHCOPInvoice).UPDATE(myPRTRowID)
	
	b		;;TC
	i +rtn=0 d
	.tc
	e  d
	.tro
	
	q "成功!"
}

ClassMethod CheckINVPRT(ShadowRowID As %String, PRTRowID As %String) As %String
{
	;w ##class(web.UDHCOPINVErrCheck).CheckINVPRT(650933,659523)
	;;w ##class(web.UDHCOPINVErrCheck).CheckINVPRT(SHADOW发票RowID, 查到的发票表ROwID)
	;Shadow DHC_INVPRT RowID
	;
	n (ShadowRowID,PRTRowID)
	;更新DHC_INVPRT 表
	s myrtn=0
	
	;^TMP
	;取得发票号码：
	i (ShadowRowID="") s myrtn=2
	i (PRTRowID="")  s myrtn=2
	
	i '$d(^DHCINVPRT(PRTRowID))  s myrtn=2
	
	q:(myrtn=2) "参数错误!"
	
	s myINVFlag=$p(^DHCINVPRT(PRTRowID),"^",8)
	
	s myPrintFlag=$p(^DHCINVPRT(PRTRowID),"^",3)
	
	i ((myINVFlag'="N")!(myPrintFlag="P")) s myrtn=3
	
	q:(myrtn=3) "此发票不能被更新发票!"
	
	;是否为同一个人
	s myShadowPAPMIDR=$p(^TMPShaowINVPRT(ShadowRowID),"^",15)
	s myPAPMIDR=$p(^DHCINVPRT(PRTRowID),"^",15)
	;b	;
	i myShadowPAPMIDR'=myPAPMIDR d
	.s myrtn=4
	
	q:(myrtn=4) "发票的登记号码不一致"
	
	q:(+myrtn'=0) "其他错误"
	
	
	ts
	;b	;;;TS
	k PLIST
	s rtn=##class(web.DHCOPInvoice).SELECT(PRTRowID)
	
	i +rtn=0 d
	.s myShadowINVNo=$p(^TMPShaowINVPRT(ShadowRowID),"^",14)
	.s myUserDR=$p(^TMPShaowINVPRT(ShadowRowID),"^",21)
	.
	.s PLIST(11)=myShadowINVNo
	.s PLIST(17)="P"
	.s PLIST(15)=myUserDR
	.s rtn=##class(web.DHCOPInvoice).UPDATE(PRTRowID)
	
	s mySub=$o(^DHCINVPRT(PRTRowID,"P",0))
	s myPayRowID=$P(^DHCINVPRT(PRTRowID,"P",mySub),"^",8)
	
	i myPayRowID="" d
	.s rtn=1
	
	i +rtn=0 d
	.k PLIST
	.s rtn=##class(web.UDHCAccPayList).SELECT(myPayRowID)
	.s PLIST(7)=myUserDR
	.s rtn=##class(web.UDHCAccPayList).UPDATE(myPayRowID)
	.
	
	s myDesc=""
	;b		;;TC
	
	i +myrtn=0 d
	.tc
	.s myDesc="成功!"
	e  d
	.tro
	.s myDesc="失败!"
	
	q myDesc
}

ClassMethod SetAPIData() As %String
{
	;w ##class(web.UDHCOPINVErrCheck).SetAPIData()
	
	k ^TMPShadowACCPAYINV
	
	
	s myDate=$zdh("2006-12-14",3)
	s myTime=$zth("09:28:41")
	
	&sql(declare tt1 CURSOR for
		select * from SQLUser.DHC_AccPayINV 
		where API_Date=:myDate and API_Time>:myTime)
	
	&sql(open tt1)
	
	f  &sql(FETCH tt1) q:SQLCODE  d
	.s myIdx=myIdx+1
	.s myAPIRowID=$P(PLIST(1),$c(1),1)
	.s ^TMPShadowACCPAYINV(myAPIRowID)=^DHCINVPRTAP(myAPIRowID)
	.;子表
	.s mySub=0
	b	;
	&sql(CLOSE tt1)
	
	s myAPIRowID=0
	f  s myAPIRowID=$o(^TMPShadowACCPAYINV(myAPIRowID))  q:(myAPIRowID="")  d
	.;^DHCINVPRTAP({DHC_AccPayINV.API_RowID},"P",{APM_Sub})
	.s mySub=0
	.f  s mySub=$o(^DHCINVPRTAP(myAPIRowID,"P",mySub))  q:(mySub="")  d
	..s ^TMPShadowACCPAYINV(myAPIRowID,"P", mySub)=^DHCINVPRTAP(myAPIRowID,"P", mySub)
	
	b
	q 0
}

ClassMethod SetINVPRTData() As %String
{
	;w ##class(web.UDHCOPINVErrCheck).SetINVPRTData
	k ^TMPShaowINVPRT
	
	s myDate=$zdh("2006-12-14",3)
	s myTime=$zth("09:28:41")
	
	&sql(declare  tt CURSOR for
		select * into PLIST() from SQLUser.DHC_INVPRT 
		where PRT_Date=:myDate and PRT_Time>:myTime and PRT_inv<>"")
	
	&sql(open tt)
	
	f  &sql(FETCH tt) q:SQLCODE  d
	.s myIdx=myIdx+1
	.s myPRTRowID=$P(PLIST(1),$c(1),1)
	.s ^TMPShaowINVPRT(myPRTRowID)=^DHCINVPRT(myPRTRowID)
	
	&sql(CLOSE tt)
	
	q 0
}

}
