Import SQLUser

/// 门诊费用复制
Class web.udhcOPRefEditCopyNew Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 266;

/// /此类主要的目的?
/// /对于退费的统一数据操作?增删改等?同时在类方法中提供事务?
/// /此类的更改主要针对于合肥的门诊卡消费退费
/// /ClassMethod RefundReceipt(itmjs As %Library.String = "", itmjsex As %Library.String = "", INVPRTRowid As %String, rUser As %String)
ClassMethod RefundReceipt(INVPRTRowid As %String, rUser As %String, sFlag As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String, NewInsType As %String, myExpStr As %String) As %String
{
	
	//1.写票据负单
	//2.更新原来的票据
	//3.同时写负担的票据帐单连接表
	//;对于合肥版本：如果原来的小票是发票就发送PINVFlag="Y"
	//;如果原先是小票而不是发票，只是被集中打印发票操作过，PINVFlag="N"
	//^TMPRef=51050::10033::A::48745||14::45.00::46::1::693::2
	//176399::5::A::::100::93::1::2::1::1"
	//152551::10528::S::78964||1::67.49::46::1::1039::1
	//w ##class(web.udhcOPRefEdit1).RefundReceipt(176399,5,"A","17||11^17||12",8.4,8,1,6,1)
	//176399::5::A::::100::93::1::2::1::1"
	//w ##class(web.udhcOPRefEdit1).RefundReceipt(344280, 5, "S","158775||1^158775||2^158775||3",63.29,7, 1,351,1)
	//w ##class(web.udhcOPRefEdit1).RefundReceipt("51050","10033","A","48745||14",                    "45",  "46","1","693","2")
	;ULoadLocDR  用户登录的科室
	;RPayModeDR  退费的支付模式
	;INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR
	s NewInsType=$g(NewInsType)
	n (INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR, NewInsType,myExpStr)
	
	;s ^TMPRef("T")=INVPRTRowid_"::"_rUser_"::"_sFlag_"::"_StopOrdStr_"::"_NInvPay_"::"_gloc_"::"_RebillFlag_"::"_ULoadLocDR_"::"_RPayModeDR_"::"_NewInsType
	
	s $ZT="ERROR^DHCSSERR"
	
	s IPAdm=$p(myExpStr,"^",1)  ;住院就诊
	s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)
	s myPINVFlag=""
	i myINVNo'="" d
	.s myPINVFlag="Y"			;需要发票的支持
	
	;验证票据
	;s ReceiptNo=##class(web.DHCBillCons).GetreceipNO(rUser)
	/*s myFairType=$p($g(^DHCINVPRT(INVPRTRowid)),"^",34)
	s myINVNoInfo=##class(web.udhcOPBillIF).ReadReceiptNO(rUser, gloc, myFairType)
	s ReceiptNo = $p(myINVNoInfo,"^",2)
	if ((ReceiptNo="")&&(RebillFlag="1")&&(myPINVFlag="Y")){
		;quit 109	;没有票据?
	}
	
	;验证发票有了变化
	s myrtn=##class(web.UDHCOEORDOPIF).CheckOEORDChangeStatus(INVPRTRowid, StopOrdStr, "")
	
	q:(+myrtn) myrtn
	*/
	d ##class(web.udhcOPRefEdit).tb()
	
	s stopnum=$l(StopOrdStr,"^")   ;做账单，防止有未处理的医嘱
	s num=0
	f num=1:1:stopnum d
	.s StopOrderid=$p(StopOrdStr,"^",num)
	.s OEORDID=+StopOrderid
	.s OPAdm=$p(^OEORD(OEORDID),"^",1)
	.s err=##class(web.UDHCJFBILL).BILL(OPAdm,"")
	
	s retvalue=""
	
	s rtn=0	
	
	d ..UpdateAdmForCancle(INVPRTRowid,rUser)
	
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	;更新原来的票据  , myCurDate, myCurTime
	if rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid,rUser,sFlag)
	
	b  ;更新原来的票据
	
	;
	if rtn=0 d  s parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, rUser, sFlag, myCurDate, myCurTime)
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
	.b ;celret
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
	
	;停止医嘱
	;if +rtn=0 d  s rtn=##class(web.UDHCOEORDOP).UpdateOrderStat(StopOrdStr,INVPRTRowid,rUser)
	
	b ;停止医嘱
	
	;关联门诊与住院就诊
	k ^TMP("OPBILL",$j)
	s stopnum=$l(StopOrdStr,"^")
	s num=0
	f num=1:1:stopnum d
	.s StopOrderid=$p(StopOrdStr,"^",num)
	.&sql(update oe_orditem set oeori_billed='TB' where oeori_rowid=:StopOrderid)
	.s OEORDID=+StopOrderid
	.s OPAdm=$p(^OEORD(OEORDID),"^",1)
	.;s ^TMP("OPBILL",$j,OPAdm)=""
	.s ^TMP("OPBILL",$j,OPAdm,StopOrderid)=""    ;;;update by zhl 20110316  hnzl    s ^TMP("OPBILL",$j,OPAdm)=""->s ^TMP("OPBILL",$j,OPAdm,StopOrderid)=""
	
	s OPAdm="",n=0
	f  s OPAdm=$o(^TMP("OPBILL",$j,OPAdm)) q:OPAdm=""  d
	.;s ^TMP("OPAdm",IPAdm,OPAdm)=""                    ;;;update by zhl 20110316  hnzl    start   ;;;;;;;;;;;
	.s ^DHCOPIPADMCON("OPAdm",IPAdm,OPAdm)=""
	.s stopord=""
	.f  s stopord=$o(^TMP("OPBILL",$j,OPAdm,stopord))   q:stopord=""   d
	..q:(stopord="")||($p(^OEORD(+stopord,"I",$p(stopord,"||",2),3),"^",5)'="TB")
	..s ^DHCOPIPADMCON("OPADMORDER",IPAdm,stopord)=""                      ;;;update by zhl 20110316  hnzl    end   ;;;;;;;;;;;
	
	
	k ^TMP("OPBILL",$j)                                                     ;;;update by zhl 20110316  hnzl    end   ;;;;;;;;;;;                                
	/*;重新计费
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
	;;获取负单的支付模式=新正单的支付模式
	s myPayinfo=##class(web.UDHCINVPRT).ReadINVPayMode(parkinvrowid)
	s Payinfo=$p(myPayinfo,$c(2),1)
    s $p(Payinfo,"^",1)=RPayModeDR
	s myAccRowID=$p($p(myPayinfo,$c(2),2),"||",1)
	
	;判断是否有收费?同时还有可能是?有未结算得医嘱?
	;:求出当前的医嘱串
	
	;退费中,=1 生成新的票据;
	;Version=1  ExpStr="gLoc^LoadCTLoc^AccManRowID^AccPWD^CheckNo"
	if ((RebillFlag="1")&&(+rtn=0)) d
	.i Instype="" d  s Instype=##class(web.DHCBillCons).ReadDefInsType()
	.b ;求出不在票据中,未结算的医嘱RowID  
	.;2005-11-15增加严格?把非本票据内的OEORI_RowID都加到字符串中?
	.s unordrid=##class(web.UDHCOEORDOP).ReadUnINVOrdStr(INVPRTRowid)
	.s myRoundSum=##class(web.DHCBillConsIF).OPCRound(NInvPay,"")
	.s myFairType=$p($g(^DHCINVPRT(INVPRTRowid)),"^", 34)		;PRT_FairType
	.s myExpStr=gloc_"^"_ULoadLocDR_"^"_myAccRowID_"^"_myPINVFlag_"^"_myFairType
	.s myExpStr=myExpStr_"^"_myRoundSum_"^0^"_(myRoundSum-NInvPay)
	.if ((rtn=0)) d
		..s retvalue=##class(web.DHCOPINVCons).OPBillCharge(paadminfo,rUser,unordrid,Instype, NInvPay, Payinfo, gloc ,"1", INVPRTRowid, "0", myExpStr)
		..s rtn=$p(retvalue,"^",1)
	.b ;退费过程中的写发药接口,在此过程中,只有一张票据RowID
	.i (rtn=0) d
	..s newrowid=$p(retvalue,"^",2)
	..s rtn=##class(web.udhcOPPHARWIN).InsertNewInv(INVPRTRowid,newrowid)
	..;s ^ll("yf")=StopStr
	..set rtn=##class(web.DHCOutPhReturn).UpdateRetPrt(StopOrdStr) ;yyx 2009-11-06 药房接口 药房更新后放开
    .;yyx 2009-10-13
	.i (rtn=0) d
	..i $g(newrowid)'="" d
	...&sql(update dhc_invprt set prt_instype_dr=:NewInsType where prt_rowid=:newrowid)
	...s rtn=SQLCODE
	*/
	i +rtn=0 d
		.d ##class(web.udhcOPRefEdit).tc()
	e  d
		.TRollBack
	
	q rtn
}

/// 专门用来卡支付的退费
ClassMethod AccPayINVRefund(APIRowID As %String, PRTOrdStr As %String, rUser As %String, sFlag As %String, gloc As %String, ULoadLocDR As %String, RPayModeDR As %String, RefPaySum As %String, RebillFlag As %String) As %String
{
	;输入参数：APIRowID, 现在的支付方式RPayModeDR, ULoadLocDR, gloc, rUser,
	;PRTOrdStr=INVPRTRowid_StopOrdStr_NInvPay_RebillFlag
	;RefPaySum界面上显示的退款金额   正数表示退款   负数表示收款
	;57,"51294"_$C(3)_"48993||2"_$C(3)_"1"_$C(3)_"4",1,S,1,639,3,4.00"
	;^TMPAccRef=<<","__"1"_,23294,S,137,1128,3,351.11">>
	;3043,"21969"_$C(3,3)_"1"_$C(3)_"0"_$C(2)_"21970"_$C(3)_"13950||3^13950||4"_$C(3)_"1"_$C(3)_"69.96"_$C(2)_"21973"_$C(3,3)_"1"_$C(3)_"0"_$C(2)_"21976"_$C(3,3)_"1"_$C(3)_"0"_$C(2)_"21981"_$C(3,3)_"1"_$C(3)_"0",23294,A,137,1128,3,69.96,1
	;w ##class(web.udhcOPRefEdit1).AccPayINVRefund("775","2188"_$C(3)_"3240||1"_$C(3)_"0"_$C(3)_"1.00",23294,"A",137,1128,3,"1.00",0)
	
	n (APIRowID, PRTOrdStr, rUser, sFlag, gloc, ULoadLocDR, RPayModeDR, RefPaySum, RebillFlag)
	
	s ^TMPAccRef=(APIRowID_","_PRTOrdStr_","_rUser_","_sFlag_","_gloc_","_ULoadLocDR_","_RPayModeDR_","_RefPaySum_","_RebillFlag)
	;             "945",       "3157"_$C(3)_$C(3)_"1"_$C(3)_"0.00",23294,A,137,1128,"3","0.00","1"
	
	s $ZT="ERROR^DHCSSERR"
	
	
	
	s ReceiptNo=##class(web.DHCBillCons).GetreceipNO(rUser)
	if ((ReceiptNo="")&&(RebillFlag="1")){
		quit 109	;没有票据?
	}
	
	d ##class(web.udhcOPRefEdit).tb()
	
	;1.作废DHC_INVPRT 表中的记录
	;2.作废DHC_AccPayINV表
	;3.写新的DHC_AccPayINV表
	;
	
	s myNewAccRIDStr=""
	s myAPIStr=""
	s myTFRIDSTR=""
	s myNPRTRStr=""
	
	;"1758"_$C(3)_"2995||2"_$C(3)_"1"_$C(3)_"19.00"_$C(2)_"1774"_$C(3,3)_"1"_$C(3)_"0.00"_$C(2)_"1775"_$C(3,3)_"1"_$C(3)_"0.00"
	s rtn=0
	s mylen=$l(PRTOrdStr,$c(2))
	f i=1:1:mylen q:(rtn'=0)  d
	.s myPrtInfo=$p(PRTOrdStr,$c(2),i)
	.s myINVPRTRowid=$p(myPrtInfo,$c(3),1)				;OldPrtRowID
	.s myStopOrdStr=$p(myPrtInfo,$c(3),2)				;需要退费的医嘱串
	.i (myStopOrdStr="") d
	..s myAPIStr=myAPIStr_myINVPRTRowid_"^"
	..s myNPRTRStr=myNPRTRStr_myINVPRTRowid_"^"					;不用退费的DHC_INVPRT串
	.q:(myStopOrdStr="")								;不退费的小票，退出
	.;获取参与退费小票RowID
	.s myTFRIDSTR=myTFRIDSTR_myINVPRTRowid_"^"
	.s myRebillFlag=$p(myPrtInfo,$c(3),3)				;部分退费标志
	.s myPatPaySum=$p(^DHCINVPRT(myINVPRTRowid),"^",16)
	.s myNInvPay=$p(myPrtInfo,$c(3),4)					;新票据的支付额
	.s myNInvPay=$g(myPatPaySum)-$g(myNInvPay)
	.;b	;;RefundSinglePRT
	.s myrtn=..RefundSinglePRT(myINVPRTRowid, rUser,sFlag,myStopOrdStr, myNInvPay, gloc, myRebillFlag, ULoadLocDR, RPayModeDR)
	.;b		;;;;
	.s rtn=+$p(myrtn,"^",1)
	.s myNewPrtRowID=$p(myrtn,"^",2)			;newPrtRowID
	.i (myNewPrtRowID'="") d
	..s myNewAccRIDStr=myNewAccRIDStr_myNewPrtRowID_"^"
	
	s myAPIStr=myAPIStr_"^"_myNewAccRIDStr
	
	;按照帐户直接退钱；放到退费字段中
	;退费方式：卡帐户
	;现金；医保等
	;需要查看废单的支付方式才成；分别写CardPaySum
	;如果帐户已经结算返款按照现金返；
	;把作废的发票支付方式分为：帐户支付，现金，医保，以及退款额
	s CardPaySum=0
	s CashSum=0
	s RefundSum=0
	
	s myInsType=0
	
	if (+rtn=0) d
	.s myrtn=##class(web.UDHCAccPrtPayFoot).CancleAPayINV(APIRowID, rUser, sFlag, myTFRIDSTR, myNPRTRStr)
	.s rtn=+myrtn
	
	s myTMPGID=$i(^DHCTMPACCColPRT)
	
	b		;s myTMPGID=$i(^DHCTMPACCColPRT)
	
	;如果不是全部退，则生成新的发票
	;1。解析
	;2。保存数据
	;把数据分解开
	s myTMPStr=""
	if ((+rtn=0)&(+RebillFlag=1)) d
	.;增加一个Global  ID
	.;w ##class(web.UDHCAccPrtPayFoot).ParPrtToAPINV("1758^1774^1775^",myTMPGID,"")
	.s myrtn=##class(web.UDHCAccPrtPayFoot).ParPrtToAPINV(myAPIStr,myTMPGID,"")
	.s rtn=$p(myrtn,$c(2),1)
	.b		;FootParAPINV
	.q:(+rtn)
	.s myAPIInfo=$p(myrtn,$c(2),2)
	.b			;生成新的发票
	.;生成新的发票
	.;(APINVInfo, UserDR, AccMDR, PAPMIDR, ExpStr)
	.s myAccDR=$p(^DHCINVPRTAP(APIRowID),"^",12)
	.s myPAPMIDR=$p(^DHCINVPRTAP(APIRowID),"^",11)
	.s myExpStr=APIRowID_"^"_gloc
	.s myrtn=##class(web.UDHCAccPrtPayFoot).AccINVPayInsert(myAPIInfo,rUser, myAccDR, myPAPMIDR,myExpStr)
	.s rtn=+$p(myrtn,"^",1)
	.s mylen=$l(myrtn)
	.s myTMPStr=$e(myrtn,3,mylen)
	
	;删除Global
	d ##class(web.UDHCACINVColPrt).KillINVTMP(myTMPGID)
	
	;为了医保提供接口，一张发票作废一定出来一张发票
	s myTMPGID=""
	s myAPINRowID=$p(myTMPStr,"^",1)
	i ((+rtn=0)&(myAPINRowID'="")) d
	.;查看废票是否是医保发票
	.s myOldAPIDR=$p($g(^DHCINVPRTAP(+myAPINRowID)),"^",22)			;API_OldAPINV_DR
	.s myInsDivDR=$p($g(^DHCINVPRTAP(myOldAPIDR)),"^",19)			;API_InsDiv_DR
	.
	.q:(myInsDivDR="")
	.s myTMPGID=$i(^DHCTMPACCColPRT)
	.;^DHCTMPACCColPRT("IP",myTMPGID,费别,1,"PrtRowID",1030)=1030
	.;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID}) 
	.s myACPRowID=0
	.f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",myAPINRowID,myACPRowID)) q:(myACPRowID="")  d
	..s myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..s myINSTypeDR=$p(^DHCINVPRT(myPRTRowID),"^",9)
	..s ^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR,1,"PrtRowID",myPRTRowID)=myPRTRowID
	..s ^DHCTMPACCColPRT("IP",myTMPGID,myINSTypeDR,1,"APIRowID")=myAPINRowID
	
	b	;;;TRO
	
	;s rtn=-1
	
	i +rtn=0 d
		.d ##class(web.udhcOPRefEdit).tc()
	e  d
		.TRollBack
	
	q rtn_$c(2)_myTMPStr_$c(2)_myTMPGID
}

/// 作废一张单个的INVPRT记录
ClassMethod RefundSinglePRT(INVPRTRowid As %String, rUser As %String, sFlag As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String) As %String
{
	n (INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR)
	
	s $ZT="ERROR^DHCSSERR"
	
	;此类方法的维护方式：RefundReceipt方法调试完成后，直接替换就行；
	
	b		;RefundSinglePRT
	
	s retvalue=""
	
	d ..UpdateAdmForCancle(INVPRTRowid,rUser)
	
	s rtn=0	

	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	;更新原来的票据
	if rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid,rUser,sFlag)
	
	b  ;更新原来的票据
	
	;
	if rtn=0 d  s parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid,rUser,sFlag, myCurDate, myCurTime)
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
	if +rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPayModeCancel(INVPRTRowid, parkinvrowid, ULoadLocDR, RPayModeDR ,rUser, myDTStr)
	
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
	;;获取负单的支付模式=新正单的支付模式
	s myPayinfo=##class(web.UDHCINVPRT).ReadINVPayMode(parkinvrowid)
	
	s Payinfo=$p(myPayinfo,$c(2),1)
	s myAccRowID=$p($p(myPayinfo,$c(2),2),"||",1)
	b			;20006
	;判断是否有收费?同时还有可能是?有未结算得医嘱?
	;:求出当前的医嘱串
	
	;退费中,=1 生成新的票据;
	;Version=1  ExpStr="gLoc^LoadCTLoc^AccManRowID^AccPWD^CheckNo"
	if ((RebillFlag="1")&&(+rtn=0)) d
	.;求出不在票据中,未结算的医嘱RowID  
	.;2005-11-15增加严格?把非本票据内的OEORI_RowID都加到字符串中?
	.s unordrid=##class(web.UDHCOEORDOP).ReadUnINVOrdStr(INVPRTRowid)
	.b			;2006 myPINVFlag
	.s myRoundSum=##class(web.DHCBillConsIF).OPCRound(NInvPay,"")
	.s myExpStr=gloc_"^"_ULoadLocDR_"^"_myAccRowID_"^N^F"
	.s myExpStr=myExpStr_"^"_myRoundSum_"^0^"_(myRoundSum-NInvPay)
	.if ((rtn=0)) d
		..s retvalue=##class(web.DHCOPINVCons).OPBillCharge(paadminfo,rUser,unordrid,Instype, NInvPay, Payinfo, gloc ,"1", INVPRTRowid, "0", myExpStr)
		..s rtn=$p(retvalue,"^",1)
	.;退费过程中的写发药接口,在此过程中,只有一张票据RowID
	.i (rtn=0) d
	..s newrowid=$p(retvalue,"^",2)
	..s rtn=##class(web.udhcOPPHARWIN).InsertNewInv(INVPRTRowid,newrowid)

	;返回票据RowID
	i retvalue'="" d
		.s rtn=retvalue
	
	q rtn
}

/// 取消错误的作废发票
ClassMethod CancleRefundINVPRT(INVPRTRowid As %String, rUser As %String, gloc As %String, ULoadLocDR As %String) As %String
{
	;INVPRTRowid  
	;w ##class(web.udhcOPRefEdit1).CancleRefundINVPRT()
	n (INVPRTRowid, rUser, gloc, ULoadLocDR)
	
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	
	s myINVFlag=$p(^DHCINVPRT(INVPRTRowid),"^",8)
	q:(myINVFlag="N") 117
	
	s myRefundRowID=$o(^DHCINVPRT(0,"InitInvDR", INVPRTRowid,0))
	q:(myRefundRowID="") 115
	
	s myHandFlag=$p(^DHCINVPRT(myRefundRowID),"^",10)
	s myRepHandStatus=$p(^DHCINVPRT(myRefundRowID),"^",61)
	q:(myHandFlag="Y")&&(myRepHandStatus="N") 116
	
	;
	s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)
	s myPINVFlag=""
	i myINVNo'="" d
	.s myPINVFlag="Y"			;需要发票的支持
	
	;验证发票有了变化
	
	q:(+myrtn) myrtn
	
	d ##class(web.udhcOPRefEdit).tb()
	
	s retvalue=""
	
	s rtn=0
	
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	s mysFlag="N"
	if rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid,rUser,mysFlag)
	
	b  ;更新原来的票据
	
	;撤销对帐单的作废
	i +rtn=0 d
	.s myNormalPBRowID=""
	.s myNormalBCIRowID=0
	.f  s myNormalBCIRowID=$o(^DHCBCI(0,"INV",INVPRTRowid, myNormalBCIRowID))  q:(myNormalBCIRowID="")||(+rtn'=0)  d
	..s myNormalPBRowID=$p(^DHCBCI(myNormalBCIRowID),"^", 2)
	..s rtn=##class(web.UDHCJFPB).SELECT(myNormalPBRowID)
	..q:(+rtn)
	..s PLIST(18)=""		;;PB_RefundFlag
	..s rtn=##class(web.UDHCJFPB).UPDATE(myNormalPBRowID)
	..q:(+rtn)
	
	b		;撤销对帐单的作废
	
	if +rtn=0 d  s rtn=##class(web.UDHCOEORDOPIF).CancleStopOrdItemStatus(INVPRTRowid, "")
	
	b	;撤销对停止的医嘱
	;
	;if rtn=0 d  s parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, rUser, sFlag, myCurDate, myCurTime)
	;s rtn=$p(parkvalue,"^",1)
	
	;^DHCINVPRT(0,"InitInvDR",{PRT_initInv_DR},{PRT_Rowid})
	s myRefundRowID=$o(^DHCINVPRT(0,"InitInvDR", INVPRTRowid,0))
	i myRefundRowID="" d  s rtn=115			;
	if +rtn=0 d  s rtn=##class(web.DHCOPInvoice).DELETE(myRefundRowID)
	
	i +rtn=0 d
	.;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	.s myRefPBRowID=""
	.s myRefBCIRowID=0
	.f  s myRefBCIRowID=$o(^DHCBCI(0,"INV",myRefundRowID, myRefBCIRowID))  q:(myRefBCIRowID="")||(+rtn'=0)  d
	..s myRefPBRowID=$p(^DHCBCI(myRefBCIRowID),"^", 2)
	..s rtn=##class(web.UDHCJFPB).DELETE(myRefPBRowID)
	..q:(+rtn)
	..q:(myRefPBRowID="")
	..s rtn=##class(web.DHCBillConINV).DELETE(myRefBCIRowID)
	..q:(+rtn)
	.
	
	b	;删除原发票对应的负票据
	
	s myNewINVRowID=""
	;^DHCINVPRT(0,"OldINV",{PRT_OldINV_DR},{PRT_Rowid})
	s myNewINVRowID=$o(^DHCINVPRT(0,"OldINV",INVPRTRowid,0))
	
	i (+rtn=0)&&(myNewINVRowID'="")  d
	.s rtn=##class(web.UDHCINVPRT).CancleNewPRTINVStatus(myNewINVRowID)
	
	;写负单的支付方式  Input Para :废单RowID，负单RowID
	;INVPRTRowid ,  parkinvrowid
	;(OldINVRowID , ParkINVRowID , AccPLDR , PayModeDR , ExpStr 
	;OldINVRowID, ParkINVRowID, PayRecLocDR, PayModeDR, UserDR, ExpStr
	
	s myDTStr=myCurDate_"^"_myCurTime
	
	b	;;Tro
	
	i +rtn=0 d
		.d ##class(web.udhcOPRefEdit).tc()
	e  d
		.TRollBack
	
	;返回票据RowID
	i retvalue'="" d
		.s rtn=retvalue
	
	q rtn
}

ClassMethod UpdateAdmForCancle(INVPRTRowID As %String, UserDR As %String) As %String
{
	n (INVPRTRowID, UserDR)
	
	s $ZT="ERROR^DHCSSERR"
	
	q 0
	
	s myrtn=0
	s myFairType=$p(^DHCINVPRT(INVPRTRowID),"^",34)		;PRT_FairType
	
	q:(myFairType'="R") 0
	
	s myUserName=$P(^SSU("SSUSR",UserDR),"^",2)
	
	;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	s myBCIRowID=$o(^DHCBCI(0,"INV",INVPRTRowID,0))
	q:(myBCIRowID="") 0
	
	s AdmDR=$p(^DHCBCI(myBCIRowID),"^",3)
	q:(AdmDR="") 0
	
	s myADMStatus=$p(^PAADM(AdmDR),"^",20)
	
	q:(myADMStatus'="A") 0
	
	s vis="C",read="Y",admdate=$P($H,",",1),admtime=$P($H,",",2)  
	&sql(update SQLUser.PA_Adm
	set PAADM_VisitStatus=:vis,
	PAADM_ReadOnly=:read,
	PAADM_UpDateDate=:admdate,
	PAADM_UpDateTime=:admtime,
	PAADM_SocialWorkerName=:myUserName
	where PAADM_RowID=:AdmDR)
	
	q myrtn
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

ClassMethod OPRefundTest()
{
	n (ad)
	;d ##class(web.udhcOPRefEdit1).OPRefundTest()
	;(INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR)
	s INVPRTRowid=$p(^TMPRef,"::",1)
	s rUser=$p(^TMPRef,"::",2)
	s sFlag=$p(^TMPRef,"::",3)
	s StopOrdStr=$p(^TMPRef,"::",4)
	s NInvPay=$p(^TMPRef,"::",5)
	s gloc=$p(^TMPRef,"::",6)
	s RebillFlag=$p(^TMPRef,"::",7)
	s ULoadLocDR=$p(^TMPRef,"::",8)
	s RPayModeDR=$p(^TMPRef,"::",9)
	b	;
	d ..RefundReceipt(INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR)
}

// add  duchangjiu ----20110424  实现门诊转住院费用的发票批量选择

// 入参：登记号PatientNO As %String,就诊卡号CardNo，sFlag="INV"，StartDate As %String, EndDate As %String,INVFlag="",发票状态INVStatus="",结算标记INVFootFlag="",支付方式fairType=""

// **

// **

// **

// ** d ##class(%ResultSet).RunQuery("web.udhcOPRefEditCopy","udhcOPRefEditFind","62193","62193","","00053053")

ClassMethod udhcOPRefEditFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = udhcOPRefEditFindExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod udhcOPRefEditFindExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PatientNO As %String, CardNo As %String) As %Status
{
	 


#;w ##class(%ResultSet).RunQuery(web.udhcOPRefEditCopy,udhcOPRefEditFind,"62798","62798","0000377207","")
#;##class(web.udhcOPRefEditCopy).udhcOPRefEditFindExecute("","62810","62812","0000377212","")
	s ^tmpznudhcOPRefEditFindExecute(StartDate)=StartDate_"^"_EndDate_"^"_PatientNO_"^"_CardNo
	Set repid=$I(^CacheTemp)
	s ind=1
	K ^TMP("OPQUERY12")
	s no=1
	;s ChargeUser=##class(web.UDHCJFCOMMON).UnEscape(ChargeUser)
	;s PatientName=##class(web.UDHCJFCOMMON).UnEscape(PatientName)
    ;w !,sFlag_"^"_ChargeUser_"^"_ReceipNO_"^"_PatientNO_"^"_PatientName_"^"_StartDate_"^"_EndDate_"^"_INVFlag_"^"_INVStatus_"^"_gLocDR_"^"_ChargeUserA_"^"_INVFootFlag_"^"_CardNo_"^"_currentPayMode_"^"_fairType_"^"_CurrAdmLoc
	;, ULoadLocDR As %String 暂时去掉
	;增加查询条件：如果PRT_Inv=""   同时myInvDR=""  的原发票不再查询出来
	;而对于作废或红冲的纪录，需要查询原纪录，来看看是否能够显示此纪录
	;为了能够综合查询，所有的发票
	;sFlag=INV		;票据查询
	;sFlag=ALL		;所有纪录(DHC_INVPRT+DHC_AccPayINV)查询
	;sFlag=PRT		;只查询DHC_INVPRT表所有纪录，而不查询DHC_AccPayINV表
	;sFlag=APP		;只查询DHC_INVPRT表中账户支付的记录
	;sFlag=API		;只查询DHC_AccPayINV表中的纪录
	;			i ((sFlag="PRT")!(sFlag="APP"))
	;			主要是上面这句话控制了查询条件的退出
	;
	;
	;审批标志AuditFlag  只在DHC_INVPRT表中
	;=""  或"ALL"			查询所有的计费记录
	;="A"		;查询审批过的 计费记录
	;="C"		;查询没有审批计费记录DHC_INVPRT
	;s ^TMPDDsFlag=sFlag_"^"_StartDate_"^"_EndDate
	;************************************************************************
	;查询不同状态的发票
	;INVStatus
	;=""  或 ALL   查询所有发票
	;=N				查询正常发票
	;=SA            查询作废或红冲发票
	;************************************************************************
	;增加安全组和登陆科室参数
	;gLocDR  安全组的RowID
	;ULoadLocDR 登陆科室的RowID
	;
	;************************************************************************
	;************************************************************************
	;增加一个结算判断标志
	;INVFootFlag
	;=""  全部发票
	;=Y   表示结算
	;=N			
	;************************************************************************
	
	s ULoadLocDR=$g(ULoadLocDR)
	;s ^TMPAuditFlag=$g(AuditFlag)_"^"_$g(gLocDR)_"^"_$g(ULoadLocDR)_"^"_$g(PatientNO)
#;	s ^TMP("invquery")=StartDate_"^"_EndDate_"^"_PatientNO_"^"_CardNo
#;	w !,^TMP("invquery")
	s myPAPMIStr=""
	i CardNo'=""{
		s myPAPMIStr=##class(web.DHCBL.CARD.UCardRefInfo).GetPAPMIBunchByCardNo(CardNo)
	}
	
	i StartDate="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	i EndDate="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	i ((PatientNO="")&&(CardNo="")) Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s (INVFlag,INVStatus,INVFootFlag,fairType,currentPayMode,gLocDR)=""
#;	s sFlag="INV"
#;	s sFlag="PRT"
	s sFlag="API"    //add by zhn 2012-12-21 取出集中打印方式
	i PatientNO'="" d
	.s PatientNO=##Class(web.DHCOPCashier).FormatPatientNo(PatientNO)
	;f PRTDate=StartDate:1:EndDate  d
	
	
	//加入DHC_INVPRT未打acc发票记录
	f PRTDate=EndDate:-1:StartDate  d
	.q:(sFlag="INV")
	.q:'$D(^DHCINVPRT(0,"Date",PRTDate))
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",PRTDate,PrtRowid),-1) q:PrtRowid=""  d
	..s FairType=$p($G(^DHCINVPRT(PrtRowid)),"^",34)
	..q:FairType'="F"
	..q:(fairType'="")&&(FairType'=fairType)
	..s Abortflag=0,refundflag=0,handflag=0
	..s PrtUsrDR=$p($G(^DHCINVPRT(PrtRowid)),"^",21)	;;User Invitial
	..s PrtUsr=""
	..s myPrtUserName=""
	..i PrtUsrDR'="" d
	...s PrtUsr=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",1)
	...s myPrtUserName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	..;q:((PrtUsr'=ChargeUser)&(ChargeUser'=myPrtUserName))&(ChargeUser'="")
	..;q:(PrtUsr'=ChargeUserA)&(ChargeUserA'="")
	..s SsusrName=""
	..i PrtUsrDR'=""  d
	...s SsusrName=$P($G(^SSU("SSUSR",PrtUsrDR)),"^",2) ;;;;;;;收费员
	..s PrtNO=$p($G(^DHCINVPRT(PrtRowid)),"^",14)       
	..s myapi=$p($G(^DHCINVPRT(PrtRowid)),"^",4)
	..i myapi'="" d
	...s PrtNO=$p($G(^DHCINVPRTAP(myapi)),"^",6)  ;;;;;;;发票号
	...;i PrtNO=202155010020  d
	....;b ;159519
	..;q:(PrtNO'=ReceipNO)&(ReceipNO'="")
	..s PapmiNo="",PapmiName=""
	..s PrtPapmiDR=$p($G(^DHCINVPRT(PrtRowid)),"^",15)
	..;b
	..q:((CardNo'="")&&(("^"_myPAPMIStr_"^")'[("^"_PrtPapmiDR_"^")))
	..;b ;1
	..i PrtPapmiDR'=""  d
	...s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	...s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	..q:(PapmiNo'=PatientNO)&(PatientNO'="")
	..;q:(PapmiName'=PatientName)&(PatientName'="")
	..s Acount=$fn(+$p($G(^DHCINVPRT(PrtRowid)),"^",16),"",2)
	..s TotSum=$fn(+$p($G(^DHCINVPRT(PrtRowid)),"^",1),"",2)
	..s Flag=$p($G(^DHCINVPRT(PrtRowid)),"^",8)
	..s Handin=$p($G(^DHCINVPRT(PrtRowid)),"^",10)
	..s sTime=$p($G(^DHCINVPRT(PrtRowid)),"^",20)
	..s myInvDR=$p($G(^DHCINVPRT(PrtRowid)),"^",13)
	..q:((PrtNO="")&(myInvDR="")&&(sFlag="INV"))			;查询发票时, 正常的支付小条退出
	..;对于账户支付的小条,查询
	..q:((sFlag="APP")&(PrtNO'="")&(myInvDR=""))
	..s myInvNo=$p($G(^DHCINVPRT(PrtRowid)),"^",14)
	..;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	
	..;start modify by tangtao 2010-09-01  zhn这个是查支付方式有什么用？
	..s IPMRowid="",myPayMode="",Bank="",BankCardNo="",BankDr="",BankCardStr=""
	..f  s IPMRowid=$o(^DHCINVPRT(PrtRowid,"P",IPMRowid)) q:IPMRowid=""  d
	...q:IPMRowid=0
	...s PayModeDr=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",1)
	...s IPMAmt=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",3)
	...s BankDr=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",2)
	...s BankCardNo=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",10)
	...q:IPMAmt=""
	...q:PayModeDr=""
	...s PayMode=$p(^CT("CTPM",PayModeDr),"^",2)
	...i myPayMode'="" s myPayMode=myPayMode_" "_PayMode_":"_IPMAmt
	...e  s myPayMode=PayMode_":"_IPMAmt
	...i (BankDr'="") d
	....s Bank=$p(^CMC("CMCBM",BankDr),"^",2)
	....s BankCardStr=Bank_"^"_BankCardNo
	..s Bank=$p(BankCardStr,"^",1)
	..s BankCardNo=$p(BankCardStr,"^",2)
	..i currentPayMode'="" d
	...s currentPayModeStr=$p(^CT("CTPM",currentPayMode),"^",2)
	..e  d
	...s currentPayModeStr=":"
	..q:myPayMode'[currentPayModeStr
    ..;end
 
	..s myVer=##class(web.DHCOPConfig).GetVersion()
	..i +myVer=7 d
	...s myPayMode=""
	...s myPMSub=0
	...f  s myPMSub=$o(^DHCINVPRT(PrtRowid,"P",myPMSub))  q:(myPMSub="")  d
	....s myPMDR=$p($g(^DHCINVPRT(PrtRowid,"P",myPMSub)),"^",1)
	....s myTMPPMSum=$p($g(^DHCINVPRT(PrtRowid,"P",myPMSub)),"^",3)
	....q:(+myTMPPMSum=0)
	....q:(myPMDR="")
	....i myPayMode="" d
	.....s myPayMode=$p($g(^CT("CTPM",myPMDR)),"^",2)
	....e  d
	.....s myPayMode=myPayMode_", "_$p(^CT("CTPM",myPMDR),"^",2)
	..q:((myInvDR'="")&&(myInvNo=""))
	..q:((INVFlag'="")&(INVFlag'=Flag))
	..q:Flag="A"  ;s Abortflag=1     // add by zhn   s Flag=$p($G(^DHCINVPRT(PrtRowid)),"^",8)
	..q:Flag="S"  ;s refundflag=1	//  Flag是Normal||N 正常  Abort||A  作废  Strike||S 冲红
	..q:(INVStatus'="")&(INVStatus'=Flag)
	..i Handin="Y"  s handflag=1
	..s myHandin=Handin
	..i myHandin="" s myHandin="N" //s Handin=$p($G(^DHCINVPRT(PrtRowid)),"^",10)
	..q:(INVFootFlag'="")&(INVFootFlag'=myHandin) //Handin结算标记
	..s PRTParkDate=""
	..s sParkTime=""
	..s ParkUserName=""
	..s TabFlag="PRT"
	..s myYBPaySum=+$p($G(^DHCINVPRT(PrtRowid)),"^",31)
	..s myYBPaySum=$fn(myYBPaySum,"",2)
	..s myAllRefundUser=$p($G(^DHCINVPRT(PrtRowid)),"^",25)		;$p($G(^DHCINVPRT(PrtRowid)),"^",31)
	..s myAuditFlag="C"
	..;gLocDR As %String, ULoadLocDR As %String
	..;接口配置参数
	..s myExpStr=gLocDR_"^"_ULoadLocDR
	..s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(PrtRowid, myExpStr)
	..s myAF=$p(myrtn,"^",1)
	..s myOEMixFlag=$p(myrtn,"^",2)
	..s myINVAuditLimit=$p(myrtn,"^",3)
	..q:(myINVAuditLimit="Y")			;对于安全组受限发票配置
	..i myAF="Y"  d
	...s myAuditFlag="A"
	..;增加处方科室和处方医生  专门针对大同来做
	..s myBillConINVDR=$o(^DHCBCI(0,"INV",PrtRowid,0))
	..s myAdmDR=$p(^DHCBCI(myBillConINVDR),"^",3)
	..S AdmDept=$p($g(^PAADM(myAdmDR)),"^",4)
	..;q:(CurrAdmLoc'="")&(CurrAdmLoc'=AdmDept)
	..s AdmDeptDesc=""
	..i AdmDept'="" S AdmDeptDesc=$p($g(^CTLOC(AdmDept)),"^",2)
	..;查找OE_OrdItem表的Doctor
	..s AdmDocName=##class(web.UDHCOEORDOPIF).ReadDOCByPRTRowID(PrtRowid,"")
	..If AdmDeptDesc["-" Set AdmDeptDesc=$p(AdmDeptDesc,"-",2)
	..;q:(AuditFlag'="")&(AuditFlag'=myAuditFlag)&(AuditFlag'="ALL")&(myOEMixFlag="")
	..s myaccpinvdr=$p($G(^DHCINVPRT(PrtRowid)),"^",4)
	..i myaccpinvdr'=""  d
	...s PrtNO=$p($G(^DHCINVPRTAP(myaccpinvdr)),"^",6)
	..s OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)
	..s OldInvNo=""
	..i OldInvDr'="" s OldInvNo=$p($G(^DHCINVPRT(OldInvDr)),"^",14)
	..Do OutputRowINVQUERY1
	
	;因为审批在DHC_INVPRT
	;i ((AuditFlag'="")&(AuditFlag'="ALL")){
		;Set qHandle=$lb(0,repid,0)	
		;Quit $$$OK
	;}
	
	i ((sFlag="PRT")!(sFlag="APP")){
		d OutputRowData
		Set qHandle=$lb(0,repid,0)	
		Quit $$$OK
	}
	;加入集中打印发票的明细
	
	;f PRTDate=StartDate:1:EndDate  d
	b ;12312312312312312312
	f PRTDate=EndDate:-1:StartDate  d
	.q:'$D(^DHCINVPRTAPi(0,"Date",PRTDate))
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRTAPi(0,"Date",PRTDate,PrtRowid),-1) q:PrtRowid=""  d
	..s Abortflag=0,refundflag=0,handflag=0
	..s PrtUsrDR=$p($G(^DHCINVPRTAP(PrtRowid)),"^",5)	;;User Invitial
	..s PrtUsr=""
	..s myPrtUserName=""
	..i PrtUsrDR'="" d
	...s PrtUsr=$p(^SSU("SSUSR",PrtUsrDR),"^",1)
	...s myPrtUserName=$p(^SSU("SSUSR",PrtUsrDR),"^",2)
	..;q:(PrtUsr'=ChargeUser)&(ChargeUser'="")&(ChargeUser'=myPrtUserName)
	..;q:(PrtUsr'=ChargeUserA)&(ChargeUserA'="")
	..s SsusrName=""
	..i PrtUsrDR'=""  d
	...s SsusrName=$P($G(^SSU("SSUSR",PrtUsrDR)),"^",2)
	..s PrtNO=$p($G(^DHCINVPRTAP(PrtRowid)),"^",6)
	..;q:(PrtNO'=ReceipNO)&(ReceipNO'="")
	..s PapmiNo="",PapmiName=""
	..s PrtPapmiDR=$p($G(^DHCINVPRTAP(PrtRowid)),"^",11)
	..q:((CardNo'="")&&(("^"_myPAPMIStr_"^")'[("^"_PrtPapmiDR_"^")))
	..i PrtPapmiDR'=""  d
	...s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	...s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	..q:(PapmiNo'=PatientNO)&(PatientNO'="")
	..;q:(PapmiName'=PatientName)&(PatientName'="")
	..s Acount=$fn(+$p($G(^DHCINVPRTAP(PrtRowid)),"^",13),"",2)
	..s TotSum=$fn(+$p($G(^DHCINVPRTAP(PrtRowid)),"^",1),"",2)
	..s Flag=$p($G(^DHCINVPRTAP(PrtRowid)),"^",2)
	..;s Handin=$p($G(^DHCINVPRTAP(PrtRowid)),"^",10)
	..s myCheckDate=$p($G(^DHCINVPRTAP(PrtRowid)),"^",7)
	..s sTime=$p($G(^DHCINVPRTAP(PrtRowid)),"^",4)
	..s myInvDR=$p($G(^DHCINVPRTAP(PrtRowid)),"^",10)
	..q:((PrtNO="")&(myInvDR=""))			;被作废的小票退出
	..s myInvNo=$p($G(^DHCINVPRTAP(PrtRowid)),"^",6)
	..;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})  API_AccMan_DR
	..s myPayMode=""
	..s myPMSub=$o(^DHCINVPRTAP(PrtRowid,"P",0))
	..s myPMDR=""
	..s:(myPMSub'="") myPMDR=$p($g(^DHCINVPRTAP(PrtRowid,"P",myPMSub)),"^",1)
	..i myPMDR'="" d
	...s myPayMode=$p(^CT("CTPM",myPMDR),"^",2)
	..q:((myInvDR'="")&&(myInvNo=""))
	..q:Flag="A"  ;s Abortflag=1  --作废的
	..q:Flag="S"  ;s refundflag=1 --红冲的
	..q:(INVStatus'="")&(INVStatus'=Flag)
	..i myCheckDate'=""  s handflag=1
	..s myHandin=""
	..i myCheckDate'="" s myHandin="Y"
	..i myHandin="" s myHandin="N"
	..q:(INVFootFlag'="")&(INVFootFlag'=myHandin)
	..s PRTParkDate=""
	..s sParkTime=""
	..s ParkUserName=""
	..s TabFlag="API"
	..s myYBPaySum=$p($G(^DHCINVPRTAP(PrtRowid)),"^",17)	;API_SelfYBPay
	
	..s AcpRowid=""
	..f  s AcpRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",PrtRowid,AcpRowid)) q:AcpRowid=""  d
	...s InvRowid=$p(^DHCINVPRTCAP(AcpRowid),"^",1)
	...s myBillConINVDR=$o(^DHCBCI(0,"INV",InvRowid,0))
	...s myAdmDR=$p(^DHCBCI(myBillConINVDR),"^",3)
	...S AdmDept=$p($g(^PAADM(myAdmDR)),"^",4)
	...;q:(CurrAdmLoc'="")&(CurrAdmLoc'=AdmDept)
	...s AdmDeptDesc=""
	...i AdmDept'="" S AdmDeptDesci=$p($g(^CTLOC(AdmDept)),"^",2)
	...;查找OE_OrdItem表的Doctor
	...s AdmDocName=##class(web.UDHCOEORDOPIF).ReadDOCByPRTRowID(PrtRowid,"")
	...If AdmDeptDesci["-" Set AdmDeptDesci=$p(AdmDeptDesci,"-",2)
	...s AdmDeptDesc=AdmDeptDesci_"^"_AdmDeptDesc   //如果一张发票有多个就诊科室，则拼起来


	..s myYBPaySum=$fn(myYBPaySum,"",2)
	..;s AdmDocName=""
	..;s AdmDeptDesc=""
	..s Bank=""
	..s BankCardNo=""
	..Do OutputRowINVQUERY1
	
	d OutputRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowData	
	s no=0
	f  s no=$o(^TMP("OPQUERY12",$j,"OP",no)) q:no=""  d
	.s PrtRowid=$p(^TMP("OPQUERY12",$j,"OP",no),"^",1)
	.s PrtNO=$p(^TMP("OPQUERY12",$j,"OP",no),"^",2)
	.s PapmiNo=$p(^TMP("OPQUERY12",$j,"OP",no),"^",3)
	.s PapmiName=$p(^TMP("OPQUERY12",$j,"OP",no),"^",4)
	.s Acount=$p(^TMP("OPQUERY12",$j,"OP",no),"^",5)
	.s Abortflag=$p(^TMP("OPQUERY12",$j,"OP",no),"^",6)
	.s refundflag=$p(^TMP("OPQUERY12",$j,"OP",no),"^",7)
	.s handflag=$p(^TMP("OPQUERY12",$j,"OP",no),"^",8)
	.s SsusrName=$p(^TMP("OPQUERY12",$j,"OP",no),"^",9)
	.s PRTDate=$p(^TMP("OPQUERY12",$j,"OP",no),"^",10)
	.s sTime=$p(^TMP("OPQUERY12",$j,"OP",no),"^",11)
	.s PRTParkDate=$p(^TMP("OPQUERY12",$j,"OP",no),"^",12)
	.s sParkTime=$p(^TMP("OPQUERY12",$j,"OP",no),"^",13)
	.s ParkUserName=$p(^TMP("OPQUERY12",$j,"OP",no),"^",14)
	.s TotSum=$p(^TMP("OPQUERY12",$j,"OP",no),"^",15) 
	.s myPayMode=$p(^TMP("OPQUERY12",$j,"OP",no),"^",16) 
	.s TabFlag=$p(^TMP("OPQUERY12",$j,"OP",no),"^",17) 
	.s myYBPaySum=$p(^TMP("OPQUERY12",$j,"OP",no),"^",18)
	.s AdmDeptDesc=$p(^TMP("OPQUERY12",$j,"OP",no),"^",19)
	.s AdmDocName=$p(^TMP("OPQUERY12",$j,"OP",no),"^",20)
	.s OldInvNo=$p(^TMP("OPQUERY12",$j,"OP",no),"^",21)
	.s Bank=$p(^TMP("OPQUERY12",$j,"OP",no),"^",22)
	.s BankCardNo=$p(^TMP("OPQUERY12",$j,"OP",no),"^",23)
	.d OutputRowINVQUERY
	K ^TMP("OPQUERY12",$j,"OP")
	q
OutputRowINVQUERY
#;    s TabFlag="PRT" 
	;s ^TMP("OPQUERY12",$j,"Export",ind)=$g(PrtRowid)_"^"_$g(PrtNO)_"^"_$g(PapmiNo)_"^"_$g(PapmiName)_"^"_$g(Acount)_"^"_$g(Abortflag)_"^"_$g(refundflag)_"^"_$g(handflag)_"^"_$g(SsusrName)_"^"_$g(PRTDate)_"^"_$g(sTime)_"^"_$g(PRTParkDate)_"^"_$g(sParkTime)_"^"_$g(ParkUserName)_"^"_$g(TotSum)_"^"_$g(myPayMode)_"^"_$g(Bank)_"^"_$g(BankCardNo)_"^"_$g(myYBPaySum)_"^"_$g(AdmDeptDesc)_"^"_$g(AdmDocName)_"^"_$g(OldInvNo)_"^"_$g(TabFlag)
	set Data=$lb(no,PrtRowid,PrtNO,PapmiNo,PapmiName,Acount,SsusrName,PRTDate,sTime,TotSum, myPayMode, TabFlag, AdmDeptDesc,$j,Tdec)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
OutputRowINVQUERY1
	//这个地方设置了no,所以可以在sflag设置为"API“的情况下，查询出PRT的，因为PRT查询写在前面
	//	i ((sFlag="PRT")!(sFlag="APP"))  主要起作用的是下面这段话
	//	d OutputRowData
	//	Set qHandle=$lb(0,repid,0)	
	//	Quit $$$OK
	
    i PrtNO="" d
	.s ^TMP("OPQUERY12",$j,"OP",no)=PrtRowid_"^"_PrtNO_"^"_PapmiNo_"^"_PapmiName_"^"_Acount_"^"_Abortflag_"^"_refundflag_"^"_handflag_"^"_SsusrName_"^"_$zd(PRTDate,3)_"^"_$zt(sTime,1)_"^"_PRTParkDate_"^"_sParkTime_"^"_ParkUserName_"^"_TotSum_"^"_myPayMode_"^"_TabFlag_"^"_myYBPaySum_"^"_AdmDeptDesc_"^"_AdmDocName_"^"_$g(OldInvNo)
	.s no=no+1
	e  d
    .s ^TMP("OPQUERY12",$j,"OP",PrtNO)=PrtRowid_"^"_PrtNO_"^"_PapmiNo_"^"_PapmiName_"^"_Acount_"^"_Abortflag_"^"_refundflag_"^"_handflag_"^"_SsusrName_"^"_$zd(PRTDate,3)_"^"_$zt(sTime,1)_"^"_PRTParkDate_"^"_sParkTime_"^"_ParkUserName_"^"_TotSum_"^"_myPayMode_"^"_TabFlag_"^"_myYBPaySum_"^"_AdmDeptDesc_"^"_AdmDocName_"^"_$g(OldInvNo)_"^"_Bank_"^"_BankCardNo
    q
}

ClassMethod udhcOPRefEditFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = udhcOPRefEditFindExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
	    If ind="" {				// if there are no more rows, finish fetching
    Set AtEnd=1
	    Set Row=""
	    }
    	Else      {		
    	 s RecordSum=$o(^CacheTemp(repid,""),-1)     //新增ㄛ获取总记录数
    s $List(^CacheTemp(repid,ind),1)=RecordSum  //新增ㄛ替换每条记录的第一列数据	
    Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query udhcOPRefEditFind(StartDate As %String, EndDate As %String, PatientNO As %String, CardNo As %String) As %Query(ROWSPEC = "num:%String,PrtRowid:%String,PrtNO:%String,PapmiNo:%String,PapmiName:%String,Acount:%String,SsusrName:%String,PRTDate:%String,sTime:%String,TotSum:%String, myPayMode:%String, TabFlag:%String, AdmDeptDesc:%String,Tjob:%String,Tdec:%String")
{
}

/// add by duchangjiu  20110424
/// 
/// 
/// 入参，发票的rowid串。以"^"分隔
/// 
/// w ##class(web.udhcOPRefEditCopy).RefundReceiptnew("2221568", 1, "S",5,13,175439)
/// 传入参数:
/// tmpstr[0]：发票ID+
/// myUser：结算员ID+
/// RefundFlag：红冲标志+
/// myUserLocID：结算员科室ID+
/// RPayModeDR：退费方式+
/// IPAdmRowID：住院就诊ID
/// INVPRTRowidstr + rUser + sFlag + ULoadLocDR + RPayModeDR + myExpStr
///  d ##class(web.udhcOPRefEditCopy).RefundReceiptnew("264049","1","S","311","13","837130")
ClassMethod RefundReceiptnew(INVPRTRowidstr As %String, rUser As %String, sFlag As %String, ULoadLocDR As %String, RPayModeDR As %String, myExpStr As %String) As %String
{
	
	//1.写票据负单
	//2.更新原来的票据
	//3.同时写负担的票据帐单连接表
	//;对于合肥版本：如果原来的小票是发票就发送PINVFlag="Y"
	//;如果原先是小票而不是发票，只是被集中打印发票操作过，PINVFlag="N"
	//^TMPRef=51050::10033::A::48745||14::45.00::46::1::693::2
	//176399::5::A::::100::93::1::2::1::1"
	//152551::10528::S::78964||1::67.49::46::1::1039::1
	//w ##class(web.udhcOPRefEditCopyNew).RefundReceiptnew("20174","639","S","231","1","711^API")
	//w ##class(web.udhcOPRefEdit1).RefundReceipt(176399,5,"A","17||11^17||12",8.4,8,1,6,1)
	//176399::5::A::::100::93::1::2::1::1"
	//w ##class(web.udhcOPRefEdit1).RefundReceipt(344280, 5, "S","158775||1^158775||2^158775||3",63.29,7, 1,351,1)
	//w ##class(web.udhcOPRefEdit1).RefundReceipt("51050","10033","A","48745||14",                    "45",  "46","1","693","2")
	;ULoadLocDR  用户登录的科室
	;RPayModeDR  退费的支付模式
	;INVPRTRowid, rUser, sFlag, StopOrdStr, NInvPay, gloc, RebillFlag, ULoadLocDR, RPayModeDR
	;s NewInsType=$g(NewInsType)
	n (INVPRTRowidstr, rUser,sFlag, ULoadLocDR, RPayModeDR,myExpStr)
	
	s ^TMPRef("T")=INVPRTRowidstr_"::"_rUser_"::"_sFlag_"::"_ULoadLocDR_"::"_RPayModeDR_"::"_myExpStr
	
	;s $ZT="ERROR^DHCSSERR"
	s rtn=0	
	q:INVPRTRowidstr="" rtn //没有发票rowid的时候quit
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	s IPAdm=$p(myExpStr,"^",1)  ;住院就诊
	s tabflag=$p(myExpStr,"^",2)  ;tabflag
	i tabflag="" s tabflag="PRT"
	s OldAPIRowid=""
	i tabflag="API" d
	.s PrtStr="",OldAPIRowid=INVPRTRowidstr
	.f i=1:1:$l(INVPRTRowidstr) d
	..s INVPRTRowid=""
	..s INVPRTRowid=$p(INVPRTRowidstr,"^",i)
	..q:INVPRTRowid=""
	..q:+$g(INVPRTRowid)=0
	..s ACPRowid=""
	..f  s ACPRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",INVPRTRowid,ACPRowid)) q:ACPRowid=""  d
	...q:ACPRowid=0
	...s PrtRowid=$p(^DHCINVPRTCAP(ACPRowid),"^",1)
	...i PrtStr="" s PrtStr=PrtRowid
	...e  s PrtStr=PrtStr_"^"_PrtRowid
	.i PrtStr'="" s INVPRTRowidstr=PrtStr
	
	;s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)
	;s myPINVFlag=""
	;i myINVNo'="" d
	;.s myPINVFlag="Y"			;需要发票的支持
	
	;验证票据
	;s ReceiptNo=##class(web.DHCBillCons).GetreceipNO(rUser)
	/*s myFairType=$p($g(^DHCINVPRT(INVPRTRowid)),"^",34)
	s myINVNoInfo=##class(web.udhcOPBillIF).ReadReceiptNO(rUser, gloc, myFairType)
	s ReceiptNo = $p(myINVNoInfo,"^",2)
	if ((ReceiptNo="")&&(RebillFlag="1")&&(myPINVFlag="Y")){
		;quit 109	;没有票据?
	}
	
	;验证发票有了变化
	s myrtn=##class(web.UDHCOEORDOPIF).CheckOEORDChangeStatus(INVPRTRowid, StopOrdStr, "")
	
	q:(+myrtn) myrtn
	*/
	d ##class(web.udhcOPRefEdit).tb()
	
	if (OldAPIRowid'="")&(tabflag="API") d
	.f i=1:1:$l(OldAPIRowid,"^") d
	..q:rtn'=0
	..s APIRowID=""
	..s APIRowID=$p(OldAPIRowid,"^",i)
	..q:APIRowID=""
	..;modify hujunbin 14.12.5 添加扩展串
	..s ExpStr="^^^^^"
	..s myrtn=##class(web.UDHCAccPrtPayFoot).CancleAPayINV(APIRowID, rUser, sFlag, "", "",ExpStr)
	..s rtn=+myrtn
	
	s retvalue=""
	
	s len=$l(INVPRTRowidstr,"^")     //按照 ^ 分割符获取字符串长度
	s i=0
	f i=1:1:len d
	.s INVPRTRowid=""
	.s INVPRTRowid=$p(INVPRTRowidstr,"^",i)
	.q:INVPRTRowid=""
	.q:rtn'=0
	.d ..UpdateAdmForCancle(INVPRTRowid,rUser)
	.;更新原来的票据  , myCurDate, myCurTime
	.if rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid,rUser,sFlag)
	.;b  ;更新原来的票据
	.s parkvalue=""
	.if rtn=0 d  s parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, rUser, sFlag, myCurDate, myCurTime)
	.s rtn=$p(parkvalue,"^",1)
    .b ;写票据负单
	.s parkinvrowid=$p(parkvalue,"^",2)
	.s paadminfo=""
	.;写负帐单
	.s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:((conRowid="")||(rtn'=0))  d
	..s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	..s paadminfo=paadminfo_adm_"^"
	..s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	..s ret=##class(web.UDHCJFPBCANCEL).PBCancel(adm,Billno,rUser,"")
	..s celret=$p(ret,"^",1)
	..b ;celret
	..i celret'=0  d  s rtn=1
	..q:rtn	 	;;退出这层循环?
	..s rebillnorid=$p(ret,"^",2)
	..;写连接表
	..;parkinvrowid,rebillnorid   负票?负单RowID
	..&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR)
	      values (:adm,:parkinvrowid,:rebillnorid))
	..s rtn=SQLCODE
	..q:SQLCODE
	.b  ;写负帐单
	.;写负单的支付方式  Input Para :废单RowID，负单RowID
	.;INVPRTRowid ,  parkinvrowid
	.;(OldINVRowID , ParkINVRowID , AccPLDR , PayModeDR , ExpStr 
	.;OldINVRowID, ParkINVRowID, PayRecLocDR, PayModeDR, UserDR, ExpStr
	.s myDTStr=myCurDate_"^"_myCurTime
	.if +rtn=0 d  s rtn=##class(web.UDHCINVPRT).INVPRTPayModeCancel(INVPRTRowid, parkinvrowid, ULoadLocDR, RPayModeDR ,rUser,myDTStr)
	
	.b  ;写负单的支付方式
	.;根据发票rowid取要退的医嘱的串
	.s InvLinkDr="",StopOrdStr=""
	.For  Set InvLinkDr=$o(^DHCBCI(0,"INV",INVPRTRowid,InvLinkDr)) Quit:InvLinkDr=""  Do
	..Set Bill=$p(^DHCBCI(InvLinkDr),"^",2)
	..Quit:'$D(^DHCPB(Bill))
	..Set Ord=0 For  Set Ord=$o(^DHCPB(Bill,"O",Ord)) Quit:Ord=""  Do
	...q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	...s OEOrdRowID=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...i StopOrdStr=""  s StopOrdStr=OEOrdRowID
	...e  s StopOrdStr=StopOrdStr_"^"_OEOrdRowID
	
	.;停止医嘱
	.;if +rtn=0 d  s rtn=##class(web.UDHCOEORDOP).UpdateOrderStat(StopOrdStr,INVPRTRowid,rUser)
	.b ;停止医嘱
	.;关联门诊与住院就诊
	.k ^TMP("OPBILL",$j)
	.s stopnum=$l(StopOrdStr,"^")
	.s num=0
	.f num=1:1:stopnum d
	..s StopOrderid=$p(StopOrdStr,"^",num)
	..&sql(update oe_orditem set oeori_billed='TB' where oeori_rowid=:StopOrderid)
	..s isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(StopOrderid)
	..i isAppRepFlag="Y" d
	...s rtn=##class(web.udhcOPRefEditCopy).UpdateAppRepTarItm(StopOrderid)	;更新新版申请单中间表的账单状态
	..e  d
	...s rtn=##class(appcom.OEOrdItem).MigrateOPExec(StopOrderid)
	..s Ord=+StopOrderid,Itm=$p(StopOrderid,"||",2)
	..s ExecSub=0
	..f  s ExecSub=$o(^OEORD(Ord,"I",Itm,"X",ExecSub)) Quit:ExecSub=""  Do
	...s OEExecRowID=Ord_"||"_Itm_"||"_ExecSub
	...s OEOREBillFlag=$p(^OEORD(Ord,"I",Itm,"X",ExecSub),"^",6)  ;OEORE_Billed
	...&SQL(update oe_ordexec set oeore_billed="TB" where oeore_rowid=:OEExecRowID)
	..;&sql(update oe_orditem set oeori_billed='TB' where oeori_rowid=:StopOrderid)
	..s rtn=rtn+SQLCODE
	..s OEORDID=+StopOrderid
	..s OPAdm=$p(^OEORD(OEORDID),"^",1)
	..;s ^TMP("OPBILL",$j,OPAdm)=""
	..s ^TMP("OPBILL",$j,OPAdm,StopOrderid)=""    ;;;update by zhl 20110316  hnzl    s ^TMP("OPBILL",$j,OPAdm)=""->s ^TMP("OPBILL",$j,OPAdm,StopOrderid)=""
	..s ^DHCOPIPADMCON("OPADMORDER","OPAdm",OPAdm,StopOrderid)=""

	.s OPAdm="",n=0
	.f  s OPAdm=$o(^TMP("OPBILL",$j,OPAdm)) q:OPAdm=""  d
	..;s ^TMP("OPAdm",IPAdm,OPAdm)=""                    ;;;update by zhl 20110316  hnzl    start   ;;;;;;;;;;;
	..s ^DHCOPIPADMCON("OPAdm",IPAdm,OPAdm)=""
	..s stopord=""
	..f  s stopord=$o(^TMP("OPBILL",$j,OPAdm,stopord))   q:stopord=""   d
	...;q:(stopord="")||($p(^OEORD(+stopord,"I",$p(stopord,"||",2),3),"^",5)'="TB")
	...s ^DHCOPIPADMCON("OPADMORDER",IPAdm,stopord)=""                      ;;;update by zhl 20110316  hnzl    end   ;;;;;;;;;;;

	.k ^TMP("OPBILL",$j)                                                     ;;;update by zhl 20110316  hnzl    end   ;;;;;;;;;;;                                

	i +rtn=0 d
		.d ##class(web.udhcOPRefEdit).tc()
	e  d
		.TRollBack
	
	q rtn
}

// w $$class(web.udhcOPRefEditCopy).TEST("445793")

ClassMethod TEST(INVPRTRowid)
{
	s InvLinkDr="",StopOrdStr=""
	For  Set InvLinkDr=$o(^DHCBCI(0,"INV",INVPRTRowid,InvLinkDr)) Quit:InvLinkDr=""  Do
	.Set Bill=$p(^DHCBCI(InvLinkDr),"^",2)
	.Quit:'$D(^DHCPB(Bill))
	.Set Ord=0 For  Set Ord=$o(^DHCPB(Bill,"O",Ord)) Quit:Ord=""  Do
	..q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	..s OEOrdRowID=$p(^DHCPB(Bill,"O",Ord),"^",4)
	..i StopOrdStr=""  s StopOrdStr=OEOrdRowID
	..e  s StopOrdStr=StopOrdStr_"^"_OEOrdRowID
	Q StopOrdStr
}

// add  by  ducahngjiu 20110520  门诊并帐住院，并入错误。取消

// 入参：要取消的病人的admid；正确的病人admid

ClassMethod TESTtransIPADMglobal(inipadm, outipadm)
{
	s num=0
	q:inipadm="" 0
	q:outipadm="" 0
	q:inipadm=outipadm 0
	q:$d(^DHCOPIPADMCON("OPADMORDER",inipadm))=0 0
	q:$d(^DHCOPIPADMCON("OPADMORDER",outipadm))'=0 0
	s stopord=""
	f  s stopord=$o(^DHCOPIPADMCON("OPADMORDER",inipadm,stopord)) q:stopord=""  d
	.s ^DHCOPIPADMCON("OPADMORDER",outipadm,stopord)=""
	.&sql(update oe_orditem set oeori_billed='TB' where oeori_rowid=:stopord)
	.s num=num+1
	k ^DHCOPIPADMCON("OPADMORDER",inipadm)
	q num
}

ClassMethod updateBtoTB(inipadm, newpaadm)
{
	new (inipadm, newpaadm)
	set num=0
	quit:(inipadm="") num
	quit:($d(^DHCOPIPADMCON("OPADMORDER",inipadm))=0) num
	
	set stopord=""
	for  set stopord=$o(^DHCOPIPADMCON("OPADMORDER",inipadm,stopord)) quit:(stopord="")  do
	.&sql(update oe_orditem set oeori_billed='TB' where oeori_rowid=:stopord)
	.if (SQLCODE=0) set num=num+1
	
	quit num
}

ClassMethod GetPapmiInfo(PAPMINo)
{
	new (PAPMINo)
	set PAPMINo=##class(web.DHCOPCashier).FormatPatientNo(PAPMINo)
	set PAPMI=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
	quit:(PAPMI="") "^^"
	set PAName=$p(^PAPER(PAPMI,"ALL"),"^",1)
	quit PAPMI_"^"_PAName_"^"_PAPMINo
}

/// Creator: ZhYW 
/// CreatDate: 2017-10-12
/// Description: 根据发票获取该张发票的医保结算Id以及费别
/// Input：accPInvRowIDStr: DHC_AccPayInv.RowID串
/// Output: 
/// Return: Insu_divide表ID_"^"_费别ID
/// Debug: w ##class(web.udhcOPRefEditCopyNew).GetInsuDivInfo("21876")
ClassMethod GetInsuDivInfo(accPInvRowIDStr As %String) As %String
{
	new (accPInvRowIDStr)
	set rtn=""
	set count=$l(accPInvRowIDStr)
	for i=1:1:count do
	.set accPInvRowID=$p(accPInvRowIDStr,"^",i)
	.quit:(+accPInvRowID=0)
	.set insTypeDR=$p(^DHCINVPRTAP(accPInvRowID),"^",31)
	.set admSource=0
	.set:(+insTypeDR'=0) admSource=$p(^PAC("ADMREA",insTypeDR),"^",9)
	.set accInsuDivDR=$p(^DHCINVPRTAP(accPInvRowID),"^",19)
	.if (+accInsuDivDR'=0) do
	..if (rtn="") do
	...set rtn=accInsuDivDR_"^"_insTypeDR_"^"_admSource
	..else  do
	...set rtn=rtn_$c(2)_accInsuDivDR_"^"_insTypeDR_"^"_admSource
	.else  do
	..//以下为窗口实时医保分解时获取医保结算信息
	..set accPConPrtDR="0"
	..for  set accPConPrtDR=$o(^DHCINVPRTCAPi(0,"APINVDR",accPInvRowID,accPConPrtDR))  quit:(accPConPrtDR="")  do
	...set prtRowID=$p(^DHCINVPRTCAP(accPConPrtDR),"^",1)
	...quit:(+prtRowID=0)
	...set insTypeDR=$p(^DHCINVPRT(prtRowID),"^",9)
	...set admSource=0
	...set:(+insTypeDR'=0) admSource=$p(^PAC("ADMREA",insTypeDR),"^",9)
	...set insuDivDR=$p(^DHCINVPRT(prtRowID),"^",30)
	...quit:(+insuDivDR=0)
	...if (rtn="") do
	....set rtn=insuDivDR_"^"_insTypeDR_"^"_admSource
	...else  do
	....set rtn=rtn_$c(2)_insuDivDR_"^"_insTypeDR_"^"_admSource
	
	quit rtn
}

}
