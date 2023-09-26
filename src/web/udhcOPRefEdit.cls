Import SQLUser

Class web.udhcOPRefEdit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 60;

/// /此类主要的目的?
/// /对于退费的统一数据操作?增删改等?同时在类方法中提供事务?
/// /
/// /ClassMethod RefundReceipt(itmjs As %Library.String = "", itmjsex As %Library.String = "", INVPRTRowid As %String, rUser As %String)
ClassMethod RefundReceipt(INVPRTRowid As %String, rUser As %String, sFlag As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String) As %String
{
	
	//1.写票据负单
	//2.更新原来的票据
	//3.同时写负担的票据帐单连接表
	//^TMPRef=::9937::A::::0.25::47::1
	//w ##class(web.udhcOPRefEdit).RefundReceipt("1312","9937","A","4062||1","0.25","47","1")
	;ULoadLocDR  用户登录的科室
	;RPayModeDR  退费的支付模式
	;INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR
	n (INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR)
	
	s ^TMPRef=INVPRTRowid_"::"_rUser_"::"_sFlag_"::"_StopOrdStr_"::"_NInvPay_"::"_gloc_"::"_RebillFlag
	s $ZT="ERROR^DHCSSERR"
	
	;验证票据
	s ReceiptNo=##class(web.DHCBillCons).GetreceipNO(rUser)
	if ((ReceiptNo="")&&(RebillFlag="1")){
		quit 101	;没有票据?
	}
	
	;验证发票有了变化
	s myrtn=##class(web.UDHCOEORDOPIF).CheckOEORDChangeStatus(INVPRTRowid, StopOrdStr, "")
	
	q:(+myrtn) myrtn
	
	
	d ##class(web.udhcOPRefEdit).tb()
	
	s retvalue=""
	
	s rtn=0	

	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	;更新原来的票据
	if rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid,rUser,sFlag, myCurDate, myCurTime)
	
	b  ;更新原来的票据
	
	;
	if rtn=0 d  s parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid,rUser,sFlag)
	s rtn=$p(parkvalue,"^",1)
	
	b	;写票据负单
	
	s parkinvrowid=$p(parkvalue,"^",2)
	s paadminfo=""
	;写负帐单
	s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:((conRowid="")||(rtn'=0))  d
	.s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	.s paadminfo=paadminfo_adm_"^"
	.s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	.s ret=##class(web.UDHCJFPBCANCEL).PBCancel(adm,Billno,rUser,"")
	.s celret=$p(ret,"^",1)
	.i celret'=0  d  s rtn=1
	.q:rtn	 	;;退出这层循环?
	.s rebillnorid=$p(ret,"^",2)
	.;写连接表
	.;parkinvrowid,rebillnorid   负票?负单RowID
	.&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR)
	      values (:adm,:parkinvrowid,:rebillnorid))
	.s rtn=SQLCODE
	.q:SQLCODE
	
	b  ;写负帐单
	
	;写负单的支付方式  Input Para :废单RowID，负单RowID
	;INVPRTRowid ,  parkinvrowid
	;(OldINVRowID , ParkINVRowID , AccPLDR , PayModeDR , ExpStr 
	;OldINVRowID, ParkINVRowID, PayRecLocDR, PayModeDR, UserDR, ExpStr
	s myDTStr=myCurDate_"^"_myCurTime
	if +rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPayModeCancel(INVPRTRowid, parkinvrowid, ULoadLocDR, RPayModeDR ,rUser,myDTStr)
	
	b  ;写负单的支付方式
	
	;停止医嘱
	if +rtn=0 d  s rtn=##class(web.UDHCOEORDOP).UpdateOrderStat(StopOrdStr,INVPRTRowid,rUser)
	
	b ;停止医嘱
	
	;重新计费
	;##class(web.DHCOPINVCons).OPBillCharge(Paadminfo, Userid, UnBillOrdStr, Instype, PatPaySum, Payinfo, gloc)
	;获取费别
	s Instype=""
	s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:((conRowid="")||(Instype'=""))  d
	.;s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	.;s paadminfo=paadminfo_adm_"^"
	.s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	.s pbdrowid=0
	.f  s pbdrowid=$o(^DHCPB(Billno,"O",pbdrowid)) q:(pbdrowid="")  d
	..q:($D(^DHCPB(Billno,"O",pbdrowid))=10)
	..s orditmid=$p(^DHCPB(Billno,"O",pbdrowid),"^",4)
	..;;;OEORI_BBExtCode
	..s Instype=$p(^OEORD(+orditmid,"I",$p(orditmid,"||",2),11),"^",18)
	
	;;获取原来的支付方式
	s Payinfo=""	;;zhaocz  获取不到因为他的外键是PA_PatMas
	s ctpayrid=""
	f  s ctpayrid=$o(^CT("CTPM",ctpayrid)) q:ctpayrid=""  d
	.s ctpaydesc=$p(^CT("CTPM",ctpayrid),"^",2)
	.i ctpaydesc="现金" d
	..s Payinfo=ctpayrid_"^"
	
	;判断是否有收费?同时还有可能是?有未结算得医±?
	;:求出当前的医嘱串
	
	;退费中,=1 生成新的票据;
	if ((RebillFlag="1")&&(+rtn=0)) d
	.;求出不在票据中,未结算的医嘱RowID  
	.;2005-11-15增加严格?把非本票据内的OEORI_RowID都加到字符串中?
	.s unordrid=##class(web.UDHCOEORDOP).ReadUnINVOrdStr(INVPRTRowid)
	.if ((rtn=0)) d  
		..s retvalue=##class(web.DHCOPINVCons).OPBillCharge(paadminfo,rUser,unordrid,Instype, NInvPay, Payinfo, gloc ,"1", INVPRTRowid)
		..s rtn=$p(retvalue,"^",1)
	.;退费过程中的写发药接口,在此过程中,只有一张票据RowID
	.i (rtn=0) d
	..s newrowid=$p(retvalue,"^",2)
	..s rtn=##class(web.udhcOPPHARWIN).InsertNewInv(INVPRTRowid,newrowid)
	
	
	i +rtn=0 d
		.d ##class(web.udhcOPRefEdit).tc()
	e  d
		.TRollBack
	
	;返回票据RowID
	i retvalue'="" d
		.s rtn=retvalue
	
	q rtn
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 n SQLCODE
 TCOMMIT  s SQLCODE=$zu(34)
 q
}

}
