Import SQLUser

/// 门诊费用复制
Class web.udhcOPRefEditCopy Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// /此类主要的目的?
/// /对于退费的统一数据操作?增删改等?同时在类方法中提供事务?
/// /此类的更改主要针对于合肥的门诊卡消费退费
/// w ##class(web.udhcOPRefEditCopy).RefundReceipt(176399,5,"A","17||11^17||12",8.4,8,1,6,1)
ClassMethod RefundReceipt(INVPRTRowid As %String, rUser As %String, sFlag As %String, StopOrdStr As %String, NInvPay As %String, gloc As %String, RebillFlag As %String, ULoadLocDR As %String, RPayModeDR As %String, NewInsType As %String, myExpStr As %String) As %String
{
	//1.写票据负单
	//2.更新原来的票据
	//3.同时写负担的票据帐单连接表
	//;对于合肥版本：如果原来的小票是发票就发送PINVFlag="Y"
	//;如果原先是小票而不是发票，只是被集中打印发票操作过，PINVFlag="N"
	;ULoadLocDR  用户登录的科室
	;RPayModeDR  退费的支付模式
	s NewInsType=$g(NewInsType)
	n (INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR, NewInsType,myExpStr)
	
	s ^TMP("RefundReceipt")=$lb(INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR, NewInsType,myExpStr)
	
	s $ZT="ERROR^DHCSSERR"
	
	s IPAdm=$p(myExpStr,"^",1)  ;住院就诊
	s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)
	s myPINVFlag=""
	i (myINVNo'="") d
	.s myPINVFlag="Y"			;需要发票的支持
	
	;验证票据
	;s ReceiptNo=##class(web.DHCBillCons).GetreceipNO(rUser)
	/*
	s myFairType=$p($g(^DHCINVPRT(INVPRTRowid)),"^",34)
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
	
	s StopOrdStr=""
	;根据发票rowid取要退的医嘱的串
	s InvLinkDr=0
	f  s InvLinkDr=$o(^DHCBCI(0,"INV",INVPRTRowid,InvLinkDr)) q:(InvLinkDr="")  d
	.s Bill=$p(^DHCBCI(InvLinkDr),"^",2)
	.q:'$d(^DHCPB(Bill))
	.s Ord=0
	.f  s Ord=$o(^DHCPB(Bill,"O",Ord)) q:(Ord="")  d
	..q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	..s OEOrdRowID=$p(^DHCPB(Bill,"O",Ord),"^",4)
	..i (StopOrdStr="")  s StopOrdStr=OEOrdRowID
	..e  s StopOrdStr=StopOrdStr_"^"_OEOrdRowID

	s stopnum=$l(StopOrdStr,"^")   ;做账单，防止有未处理的医嘱
	s num=0
	f num=1:1:stopnum d
	.s StopOrderid=$p(StopOrdStr,"^",num)
	.s OEORDID=+StopOrderid
	.s OPAdm=$p(^OEORD(OEORDID),"^",1)
	.s err=##class(web.UDHCJFBILL).BILL(OPAdm, "")
	
	s retvalue=""
	
	s rtn=0	
	
	d ..UpdateAdmForCancle(INVPRTRowid,rUser)
	
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	
	;更新原来的票据  , myCurDate, myCurTime
	i (rtn=0) s rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid,rUser,sFlag)
	
	;写票据负单
	i (rtn=0) s parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, rUser, sFlag, myCurDate, myCurTime)
	s rtn=$p(parkvalue,"^",1)
	s parkinvrowid=$p(parkvalue,"^",2)
	
	s paadminfo=""
	;写负帐单
	s conRowid=0
	f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:((conRowid="")||(rtn'=0))  d
	.s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	.s paadminfo=paadminfo_adm_"^"
	.s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	.s ret=##class(web.UDHCJFPBCANCEL).PBCancel(adm,Billno,rUser,"")
	.s celret=$p(ret,"^",1)
	.i (celret'=0)  s rtn=1
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
	;INVPRTRowid,  parkinvrowid
	;(OldINVRowID, ParkINVRowID, AccPLDR, PayModeDR , ExpStr 
	;OldINVRowID, ParkINVRowID, PayRecLocDR, PayModeDR, UserDR, ExpStr
	
	s myDTStr=myCurDate_"^"_myCurTime
	if (+rtn=0) s rtn=##class(web.UDHCINVPRT).INVPRTPayModeCancel(INVPRTRowid, parkinvrowid, ULoadLocDR, RPayModeDR ,rUser,myDTStr)
	
	;停止医嘱
	;if (+rtn=0) s rtn=##class(web.UDHCOEORDOP).UpdateOrderStat(StopOrdStr,INVPRTRowid,rUser)
		
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
	d ..RefundReceipt(INVPRTRowid, rUser,sFlag,StopOrdStr,NInvPay,gloc,RebillFlag, ULoadLocDR, RPayModeDR)
}

///  实现门诊转住院费用的发票批量选择
/// 入参：登记号PatientNO As %String,就诊卡号CardNo，sFlag="INV"，StartDate As %String, EndDate As %String,INVFlag="",发票状态INVStatus="",结算标记INVFootFlag="",支付方式fairType=""
/// d ##class(%ResultSet).RunQuery("web.udhcOPRefEditCopy","udhcOPRefEditFind",65009,65009,"0000000037","","PRT","")
Query udhcOPRefEditFind(StartDate As %String, EndDate As %String, PatientNO As %String, CardNo As %String, sFlag As %String, IPAdm As %String = "") As websys.Query(ROWSPEC = "num:%String,PrtRowid:%String,PrtNO:%String,PapmiNo:%String,PapmiName:%String,Acount:%String,SsusrName:%String,PRTDate:%String,sTime:%String,TotSum:%String, myPayMode:%String, TabFlag:%String, AdmDeptDesc:%String,Tjob:%String,TDspStatus:%String")
{
}

ClassMethod udhcOPRefEditFindExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, PatientNO As %String, CardNo As %String, sFlag As %String, IPAdm As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((StartDate="")||(EndDate="")) quit $$$OK
	if ((PatientNO="")&&(CardNo="")) quit $$$OK
	kill ^TMP("OPQUERY12",$j)
	if (sFlag="") set sFlag="INV"
	set no=1

	set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	;根据就诊取院区
	set IpHospitol=""
	if (IPAdm'="") set IpHospitol=##class(web.UDHCHospitalGroup).GetHospitalByAdm(IPAdm)
	set myPAPMIStr=""
	if (CardNo'="") set myPAPMIStr=##class(web.DHCBL.CARD.UCardRefInfo).GetPAPMIBunchByCardNo(CardNo)
	if (PatientNO'="") set PatientNO=##class(web.DHCOPCashier).FormatPatientNo(PatientNO)

	set (INVFlag,INVStatus,INVFootFlag,fairType,currentPayMode,gLocDR)=""
	
	;f PRTDate=StartDate:1:EndDate  d
	f PRTDate=EndDate:-1:StartDate  d
	.q:(sFlag="API")
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",PRTDate,PrtRowid),-1) q:(PrtRowid="")  d
	..s FairType=$p($g(^DHCINVPRT(PrtRowid)),"^",34)
	..q:(FairType'="F")
	..s OpHospitol=$p($g(^DHCINVPRT(PrtRowid)),"^",39)
	..q:((IpHospitol'="")&&(OpHospitol'=IpHospitol))
	..s Abortflag=0, refundflag=0, handflag=0
	..s PrtUsrDR=$p($g(^DHCINVPRT(PrtRowid)),"^",21)
	..s PrtUsr=""
	..s myPrtUserName=""
	..i (PrtUsrDR'="") d
	...s PrtUsr=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",1)
	...s myPrtUserName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	..s SsusrName=""
	..if (PrtUsrDR'="")  d
	...s SsusrName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2) //收费员
	..s PrtNO=$p($g(^DHCINVPRT(PrtRowid)),"^",14)       
	..s myapi=$p($g(^DHCINVPRT(PrtRowid)),"^",4)
	..i (myapi'="") d
	...s PrtNO=$p($g(^DHCINVPRTAP(myapi)),"^",6)  //发票号
	..//q:(PrtNO'=ReceipNO)&&(ReceipNO'="")
	..s PapmiNo="",PapmiName=""
	..s PrtPapmiDR=$p($g(^DHCINVPRT(PrtRowid)),"^",15)
	..q:((CardNo'="")&&(("^"_myPAPMIStr_"^")'[("^"_PrtPapmiDR_"^")))
	..i PrtPapmiDR'=""  d
	...s PapmiNo=$p($g(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	...s PapmiName=$p($g(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	..q:(PapmiNo'=PatientNO)&(PatientNO'="")
	..;q:(PapmiName'=PatientName)&(PatientName'="")
	..s Acount=$fn(+$p($g(^DHCINVPRT(PrtRowid)),"^",16),"",2)
	..s TotSum=$fn(+$p($g(^DHCINVPRT(PrtRowid)),"^",1),"",2)
	..s Flag=$p($g(^DHCINVPRT(PrtRowid)),"^",8)
	..s Handin=$p($g(^DHCINVPRT(PrtRowid)),"^",10)
	..s sTime=$p($g(^DHCINVPRT(PrtRowid)),"^",20)
	..s myInvDR=$p($g(^DHCINVPRT(PrtRowid)),"^",13)
	..q:((PrtNO="")&(myInvDR="")&&(sFlag="INV"))			;查询发票时, 正常的支付小条退出
	..;对于账户支付的小条,查询
	..q:((sFlag="APP")&(PrtNO'="")&(myInvDR=""))
	..s myInvNo=$p($g(^DHCINVPRT(PrtRowid)),"^",14)
	..s DspStatus=..GetDrugDisFlag(PrtRowid)
	..;start modify by tangtao 2010-09-01
	..s IPMRowid="0", myPayMode="",Bank="",BankCardNo="",BankDr="",BankCardStr=""
	..f  s IPMRowid=$o(^DHCINVPRT(PrtRowid,"P",IPMRowid)) q:IPMRowid=""  d
	...s PayModeDr=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",1)
	...q:(+PayModeDr=0)
	...s IPMAmt=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",3)
	...q:(+IPMAmt=0)
	...s BankDr=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",2)
	...s BankCardNo=$p(^DHCINVPRT(PrtRowid,"P",IPMRowid),"^",10)
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
	..q:(myPayMode'[currentPayModeStr)
    ..;end
	..q:((myInvDR'="")&&(myInvNo=""))
	..q:((INVFlag'="")&(INVFlag'=Flag))
	..q:Flag="A"    ;s Abortflag=1
	..q:Flag="S"    ;s refundflag=1
	..q:(INVStatus'="")&(INVStatus'=Flag)
	..i Handin="Y"  s handflag=1
	..s myHandin=Handin
	..i myHandin="" s myHandin="N"
	..q:(INVFootFlag'="")&(INVFootFlag'=myHandin)
	..s PRTParkDate=""
	..s sParkTime=""
	..s ParkUserName=""
	..s TabFlag="PRT"
	..s myYBPaySum=+$p($g(^DHCINVPRT(PrtRowid)),"^",31)
	..s myYBPaySum=$fn(myYBPaySum,"",2)
	..s myAllRefundUser=$p($g(^DHCINVPRT(PrtRowid)),"^",25)		;$p($g(^DHCINVPRT(PrtRowid)),"^",31)
	..s myAuditFlag="C"
	..s myBillConINVDR=$o(^DHCBCI(0,"INV",PrtRowid,0))
	..s myAdmDR=$p(^DHCBCI(myBillConINVDR),"^",3)
	..S AdmDept=$p($g(^PAADM(myAdmDR)),"^",4)
	..;q:(CurrAdmLoc'="")&(CurrAdmLoc'=AdmDept)
	..s AdmDeptDesc=""
	..i (AdmDept'="") s AdmDeptDesc=$p($g(^CTLOC(AdmDept)),"^",2)
	..;查找OE_OrdItem表的Doctor
	..s AdmDocName=##class(web.UDHCOEORDOPIF).ReadDOCByPRTRowID(PrtRowid,"")
	..i (AdmDeptDesc["-") s AdmDeptDesc=$p(AdmDeptDesc,"-",2)
	..;q:(AuditFlag'="")&(AuditFlag'=myAuditFlag)&(AuditFlag'="ALL")&(myOEMixFlag="")
	..s myaccpinvdr=$p($g(^DHCINVPRT(PrtRowid)),"^",4)
	..q:(myaccpinvdr'="")
	..s OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)
	..s OldInvNo=""
	..i (OldInvDr'="") s OldInvNo=$p($g(^DHCINVPRT(OldInvDr)),"^",14)
	..d OutputRowINVQUERY1
	
	f PRTDate=EndDate:-1:StartDate  d
	.q:(sFlag'="API")
	.q:'$d(^DHCINVPRTAPi(0,"Date",PRTDate))
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRTAPi(0,"Date",PRTDate,PrtRowid),-1) q:PrtRowid=""  d
	..s Abortflag=0,refundflag=0,handflag=0
	..s PrtUsrDR=$p($g(^DHCINVPRTAP(PrtRowid)),"^",5)	;;User Invitial
	..s PrtUsr=""
	..s myPrtUserName=""
	..i PrtUsrDR'="" d
	...s PrtUsr=$p(^SSU("SSUSR",PrtUsrDR),"^",1)
	...s myPrtUserName=$p(^SSU("SSUSR",PrtUsrDR),"^",2)
	..s SsusrName=""
	..i PrtUsrDR'=""  d
	...s SsusrName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	..s PrtNO=$p($g(^DHCINVPRTAP(PrtRowid)),"^",6)
	..;q:(PrtNO'=ReceipNO)&(ReceipNO'="")
	..s PapmiNo="",PapmiName=""
	..s PrtPapmiDR=$p($g(^DHCINVPRTAP(PrtRowid)),"^",11)
	..q:((CardNo'="")&&(("^"_myPAPMIStr_"^")'[("^"_PrtPapmiDR_"^")))
	..i (PrtPapmiDR'="")  d
	...s PapmiNo=$P($g(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	...s PapmiName=$P($g(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	..q:(PapmiNo'=PatientNO)&(PatientNO'="")
	..;q:(PapmiName'=PatientName)&(PatientName'="")
	..s Acount=$fn(+$p($g(^DHCINVPRTAP(PrtRowid)),"^",13),"",2)
	..s TotSum=$fn(+$p($g(^DHCINVPRTAP(PrtRowid)),"^",1),"",2)
	..s Flag=$p($g(^DHCINVPRTAP(PrtRowid)),"^",2)
	..;s Handin=$p($g(^DHCINVPRTAP(PrtRowid)),"^",10)
	..s myCheckDate=$p($g(^DHCINVPRTAP(PrtRowid)),"^",7)
	..s sTime=$p($g(^DHCINVPRTAP(PrtRowid)),"^",4)
	..s myInvDR=$p($g(^DHCINVPRTAP(PrtRowid)),"^",10)
	..q:((PrtNO="")&(myInvDR=""))			;被作废的小票退出
	..s myInvNo=$p($g(^DHCINVPRTAP(PrtRowid)),"^",6)
	..s myPayMode=""
	..s myPMSub="0"
	..f  s myPMSub=$o(^DHCINVPRTAP(PrtRowid,"P",myPMSub)) q:(myPMSub="")  d
	...s myPMDR=$p($g(^DHCINVPRTAP(PrtRowid,"P",myPMSub)),"^",1)
	...s myPMAmt=$p(^DHCINVPRTAP(PrtRowid,"P",myPMSub),"^",3)
	...q:((+myPMDR=0)||(+myPMAmt=0))
	...s PayMode=$p(^CT("CTPM",myPMDR),"^",2)
	...i myPayMode="" s myPayMode=PayMode_":"_myPMAmt
	...e  s myPayMode=myPayMode_" "_PayMode_":"_myPMAmt
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
	..s myYBPaySum=$p($g(^DHCINVPRTAP(PrtRowid)),"^",17)	;API_SelfYBPay
	..s myYBPaySum=$fn(myYBPaySum,"",2)
	..s AdmDocName=""
	..s AdmDeptDesc=""
	..s ACPRowid="0"
	..f  s ACPRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",PrtRowid,ACPRowid)) q:ACPRowid=""  d
	...s PrtRowid1=$p(^DHCINVPRTCAP(ACPRowid),"^",1)
	...;增加处方科室和处方医生  专门针对大同来做
	...s myBillConINVDR=$o(^DHCBCI(0,"INV",PrtRowid1,0))
	...s myAdmDR=$p(^DHCBCI(myBillConINVDR),"^",3)
	...S AdmDept=$p($g(^PAADM(myAdmDR)),"^",4)
	...i AdmDept'="" s AdmDeptDesc=$p($g(^CTLOC(AdmDept)),"^",2)
	...;查找OE_OrdItem表的Doctor
	...s AdmDocName=##class(web.UDHCOEORDOPIF).ReadDOCByPRTRowID(PrtRowid1,"")
	...i (AdmDeptDesc["-") s AdmDeptDesc=$p(AdmDeptDesc,"-",2)
	..s Bank=""
	..s BankCardNo=""
	..s DspStatus=..GetDrugDisFlagAPI(PrtRowid)
	..d OutputRowINVQUERY1
	
	d OutputRowData
	set qHandle=$lb(0,repid,0)
	quit $$$OK
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
	.s PRTDate=##class(websys.Conversions).DateLogicalToHtml(PRTDate)
	.s sTime=$p(^TMP("OPQUERY12",$j,"OP",no),"^",11)
	.s sTime=##class(websys.Conversions).TimeLogicalToHtml(sTime,1)
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
	.s DspStatus=$p(^TMP("OPQUERY12",$j,"OP",no),"^",24)
	.d OutputRowINVQUERY
	k ^TMP("OPQUERY12",$j,"OP")
	q
OutputRowINVQUERY
	set Data=$lb(no,PrtRowid,PrtNO,PapmiNo,PapmiName,Acount,SsusrName,PRTDate,sTime,TotSum,myPayMode,TabFlag,AdmDeptDesc,$j,$g(DspStatus))
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
OutputRowINVQUERY1
    i (PrtNO="") d
	.s ^TMP("OPQUERY12",$j,"OP",no)=PrtRowid_"^"_PrtNO_"^"_PapmiNo_"^"_PapmiName_"^"_Acount_"^"_Abortflag_"^"_refundflag_"^"_handflag_"^"_SsusrName_"^"_PRTDate_"^"_sTime_"^"_PRTParkDate_"^"_sParkTime_"^"_ParkUserName_"^"_TotSum_"^"_myPayMode_"^"_TabFlag_"^"_myYBPaySum_"^"_AdmDeptDesc_"^"_AdmDocName_"^"_$g(OldInvNo)_"^"_Bank_"^"_BankCardNo_"^"_DspStatus
	.s no=no+1
	e  d
    .s ^TMP("OPQUERY12",$j,"OP",PrtNO)=PrtRowid_"^"_PrtNO_"^"_PapmiNo_"^"_PapmiName_"^"_Acount_"^"_Abortflag_"^"_refundflag_"^"_handflag_"^"_SsusrName_"^"_PRTDate_"^"_sTime_"^"_PRTParkDate_"^"_sParkTime_"^"_ParkUserName_"^"_TotSum_"^"_myPayMode_"^"_TabFlag_"^"_myYBPaySum_"^"_AdmDeptDesc_"^"_AdmDocName_"^"_$g(OldInvNo)_"^"_Bank_"^"_BankCardNo_"^"_DspStatus
    q
}

/// 1.写票据负单
/// 2.更新原来的票据
/// 3.同时写负担的票据帐单连接表
/// 对于合肥版本：如果原来的小票是发票就发送PINVFlag="Y"
/// 如果原先是小票而不是发票，只是被集中打印发票操作过，PINVFlag="N"
/// w ##class(web.udhcOPRefEditCopy).RefundReceiptnew("2221568", 1, "S",5,13,175439)
ClassMethod RefundReceiptnew(INVPRTRowidstr As %String, rUser As %String, sFlag As %String, ULoadLocDR As %String, RPayModeDR As %String, myExpStr As %String) As %String
{
	n (INVPRTRowidstr, rUser, sFlag, ULoadLocDR, RPayModeDR, myExpStr)
	
	s ^TMPRef("RefundReceiptnew")=$lb(INVPRTRowidstr, rUser, sFlag, ULoadLocDR, RPayModeDR, myExpStr)
	
	s $ZT="ERROR^DHCSSERR"
	d ##class(web.udhcOPRefEdit).tb()
	s rtn=0	
	q:(INVPRTRowidstr="") rtn
	s myCurDate=+$h
	s myCurTime=$p($h,",",2)
	s IPAdm=$p(myExpStr,"^",1)  ;住院就诊
	
	s retvalue=""
	
	s len=$l(INVPRTRowidstr,"^")
	f i=1:1:len d
	.s INVPRTRowid=$p(INVPRTRowidstr,"^",i)
	.q:(+INVPRTRowid=0)
	.d ..UpdateAdmForCancle(INVPRTRowid, rUser)
	.;更新原来的票据  , myCurDate, myCurTime
	.i (rtn=0) s rtn=##class(web.UDHCINVPRT).INVPRTPark(INVPRTRowid, rUser, sFlag)
	.;更新原来的票据
	.i (rtn=0) s parkvalue=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, rUser, sFlag, myCurDate, myCurTime)
	.s rtn=$p(parkvalue,"^",1)
    .;写票据负单
	.s parkinvrowid=$p(parkvalue,"^",2)
	.;写负帐单
	.s paadminfo=""
	.s conRowid=0 
	.f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:((conRowid="")||(rtn'=0))  d
	..s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	..s paadminfo=paadminfo_adm_"^"
	..s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	..s ret=##class(web.UDHCJFPBCANCEL).PBCancel(adm, Billno, rUser, "")
	..s celret=$p(ret,"^",1)
	..i (celret'=0)  s rtn=1
	..q:rtn	 	;退出这层循环?
	..s rebillnorid=$p(ret,"^",2)
	..;写连接表
	..&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR)
	      values (:adm,:parkinvrowid,:rebillnorid))
	..s rtn=SQLCODE
	..q:SQLCODE
	.;写负单的支付方式  Input Para :废单RowID，负单RowID	
	.s myDTStr=myCurDate_"^"_myCurTime
	.i (+rtn=0) s rtn=##class(web.UDHCINVPRT).INVPRTPayModeCancel(INVPRTRowid, parkinvrowid, ULoadLocDR, RPayModeDR ,rUser,myDTStr)
	.;写负单的支付方式
	.;根据发票rowid取要退的医嘱的串
	.s InvLinkDr="",StopOrdStr=""
	.f  s InvLinkDr=$o(^DHCBCI(0,"INV",INVPRTRowid,InvLinkDr)) q:(InvLinkDr="")  d
	..s Bill=$p(^DHCBCI(InvLinkDr),"^",2)
	..q:'$d(^DHCPB(Bill))
	..s Ord=0
	..f  s Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	...q:($d(^DHCPB(Bill,"O",Ord))=10)		;zhao防止错误?
	...s OEOrdRowID=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...i (StopOrdStr="")  s StopOrdStr=OEOrdRowID
	...e  s StopOrdStr=StopOrdStr_"^"_OEOrdRowID	
	.;停止医嘱
	.;关联门诊与住院就诊
	.k ^TMP("OPBILL",$j)
	.s stopnum=$l(StopOrdStr,"^")
	.s num=0
	.f num=1:1:stopnum d
	..s StopOrderid=$p(StopOrdStr,"^",num)
	..&sql(update oe_orditem set oeori_billed='TB' where oeori_rowid=:StopOrderid)
	..s isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(StopOrderid)
	..i (isAppRepFlag="Y") d
	...s rtn=..UpdateAppRepTarItm(StopOrderid)	;更新新版申请单中间表的账单状态
	..e  d
	...s rtn=##class(appcom.OEOrdItem).MigrateOPExec(StopOrderid)
	..s OEORDID=+StopOrderid
	..s OPAdm=$p(^OEORD(OEORDID),"^",1)
	..;s ^TMP("OPBILL",$j,OPAdm)=""
	..s ^TMP("OPBILL",$j,OPAdm,StopOrderid)=""             //update by zhl 20110316
	..s ^DHCOPIPADMCON("OPADMORDER","OPAdm",OPAdm,StopOrderid)=""
	.s OPAdm="",n=0
	.f  s OPAdm=$o(^TMP("OPBILL",$j,OPAdm)) q:OPAdm=""  d
	..;s ^TMP("OPAdm",IPAdm,OPAdm)=""                       //update by zhl 20110316
	..s ^DHCOPIPADMCON("OPAdm",IPAdm,OPAdm)=""
	..s stopord=""
	..f  s stopord=$o(^TMP("OPBILL",$j,OPAdm,stopord))   q:stopord=""   d
	...q:(stopord="")||($p(^OEORD(+stopord,"I",$p(stopord,"||",2),3),"^",5)'="TB")
	...s ^DHCOPIPADMCON("OPADMORDER",IPAdm,stopord)=""                      //update by zhl 20110316 
	.k ^TMP("OPBILL",$j)                                                  

	i (+rtn=0) d
	.d ##class(web.udhcOPRefEdit).tc()
	e  d
	.TRollBack
	
	q rtn
}

/// Creator:Lid
/// CreatDate:2017-04-13
/// Desc:急诊转住院时，更新新版申请单中间表的账单状态
/// 		注：新版申请单不支持部分转住院  --2017-04-13
/// Debug: w ##class().UpdateAppRepTarItm()
ClassMethod UpdateAppRepTarItm(oeitm)
{
	new (oeitm)
	set err=0
	set newStatus="TB"
	set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRepFlag="Y") {
		set itmDr=0
		for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:((itmDr="")||(err'=0))  do
		.set artiDr=0
		.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:((artiDr="")||(err'=0))  do
		..set tmp=$g(^DHCAPREPTA(artiDr))
		..quit:(tmp="")
		..set billStatus=$p(tmp,"^",9)  ;账单状态
		..set billpoint=$p(tmp,"^",1)
		..set type=$p(tmp,"^",3)
		..set oeoriexec=$p(tmp,"^",10)	;ARTI_OrdExec
		..quit:(billStatus'="P")
		..&sql(update DHC_AppRepTarItm set ARTI_Billed=:newStatus where ARTI_RowId=:artiDr)
		..set err=SQLCODE
		..quit:(err'=0)
		..;更新执行记录表rowid
		..&SQL(update SQLUser.OE_OrdExec set OEORE_Billed=:newStatus where OEORE_RowId=:oeoriexec)
		..set err=SQLCODE
	}
	
	quit err
}

/// w ##class(web.udhcOPRefEditCopy).TEST("445793")
ClassMethod TEST(INVPRTRowid)
{
	s InvLinkDr="0",StopOrdStr=""
	f  s InvLinkDr=$o(^DHCBCI(0,"INV",INVPRTRowid,InvLinkDr)) q:(InvLinkDr="")  d
	.s Bill=$p(^DHCBCI(InvLinkDr),"^",2)
	.q:'$d(^DHCPB(Bill))
	.s Ord=0 
	.f  s Ord=$o(^DHCPB(Bill,"O",Ord)) q:(Ord="")  d
	..q:($d(^DHCPB(Bill,"O",Ord))=10)		;;zhao防止错误?
	..s OEOrdRowID=$p(^DHCPB(Bill,"O",Ord),"^",4)
	..i (StopOrdStr="")  s StopOrdStr=OEOrdRowID
	..e  s StopOrdStr=StopOrdStr_"^"_OEOrdRowID
	
	q StopOrdStr
}

/// add  by  duchangjiu 20110520  门诊并帐住院，并入错误。取消
/// 入参：要取消的病人的admid；正确的病人admid
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
	s num=0
	q:inipadm="" 0
	q:$d(^DHCOPIPADMCON("OPADMORDER",inipadm))=0 0
	s stopord=""
	f  s stopord=$o(^DHCOPIPADMCON("OPADMORDER",inipadm,stopord)) q:stopord=""  d
	.&sql(update oe_orditem set oeori_billed='TB' where oeori_rowid=:stopord)
	.IF SQLCODE=0 S num=num+1
	q num
}

Query QueryIPAdm(PatNo As %String) As websys.Query(ROWSPEC = "rowid:%String,admno:%String,papno:%String,papname:%String,admdate:%String,admtime:%String,admdept:%String,admward:%String,admbed:%String,admstatus:%String,admid:%String")
{
}

ClassMethod QueryIPAdmExecute(ByRef qHandle As %Binary, PatNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
    If $g(PatNo)=""  Quit $$$OK
	s papmiid=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	
	s rowid="0"
	f  s rowid=$o(^PAPERdr(papmiid,"ADM","I",rowid))  q:rowid=""  d
	.q:($d(^PAPER(papmiid))=0)
	.s admstatus=$p(^PAADM(rowid),"^",20)
	.;q:admstatus="D"
	.s billflag=$p(^PAADM(rowid),"^",45)
	.q:billflag="Y"
	.&sql(select papmi_no,papmi_name into :papno,:papname from pa_patmas where papmi_rowid=:papmiid)
	.s papno=$p(papno,$c(1))
	.s papname=$p(papname,$c(1))
	.s admno=$p(^PAADM(rowid),"^",81)
	.s admdate=$p(^PAADM(rowid),"^",6)
	.i admdate'=""  s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	.s admtime=$p(^PAADM(rowid),"^",7)
	.i admtime'=""  s admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime,1)
	.s admdeptid=$p(^PAADM(rowid),"^",4)
	.q:($d(^CTLOC(admdeptid))=0)
	.s admdept=$p(^CTLOC(admdeptid),"^",2)
	.i admdept'=""  d
	..i $f(admdept,"-")'=0  d
	...s admdept=$p(admdept,"-",2)
	.s admwardid=$p(^PAADM(rowid),"^",70)
	.q:$g(admwardid)="" 
	.q:($d(^PAWARD(admwardid))=0)
	.s admward=$p(^PAWARD(admwardid),"^",2)
	.i admward'=""  d
	..i $f(admward,"-")'=0  d
	...s admward=$p(admward,"-",2)
	.s admbedid=$p(^PAADM(rowid),"^",73)
	.s admbed=""
	.i admbedid'=""  d
	..i $f(admbedid,"||")'=0  d
	...s admbed1=$p(admbedid,"||",1)
	...s admbed2=$p(admbedid,"||",2)
	...i (admbed1'="")&(admbed2'="")  d
	....i $d(^PAWARD(admbed1,"BED",admbed2))'=0  d
	.....s admbed=$p(^PAWARD(admbed1,"BED",admbed2),"^",1)
	.i admstatus="A"  s admstatus="在院"
	.i admstatus="C"  s admstatus="取消住院"
	.i admstatus="D"  s admstatus="出院"
	.d OutputRowAdm
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAdm
	set Data=$lb(rowid,admno,papno,papname,admdate,admtime,admdept,admward,admbed,admstatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query QueryIPAdmByMedicare(PatMed As %String) As websys.Query(ROWSPEC = "rowid:%String,admno:%String,papno:%String,papname:%String,admdate:%String,admtime:%String,admdept:%String,admward:%String,admbed:%String,admstatus:%String,admid:%String")
{
}

ClassMethod QueryIPAdmByMedicareExecute(ByRef qHandle As %Binary, PatMed As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
    If $g(PatMed)=""  Quit $$$OK
	;Set papmiid=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	Set papmiid=##Class(web.DHCWMRService).IGetPatIDByMrNo(PatMed, "")
	If (papmiid="") Quit $$$OK
	
	s rowid="0"
	f  s rowid=$o(^PAPERdr(papmiid,"ADM","I",rowid))  q:rowid=""  d
	.q:($d(^PAPER(papmiid))=0)
	.&sql(select papmi_no,papmi_name into :papno,:papname from pa_patmas where papmi_rowid=:papmiid)
	.s papno=$p(papno,$c(1))
	.s papname=$p(papname,$c(1))
	.s admno=$p(^PAADM(rowid),"^",81)
	.s billflag=$p(^PAADM(rowid),"^",45)
	.q:billflag="Y"
	.s admdate=$p(^PAADM(rowid),"^",6)
	.i admdate'=""  s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	.s admtime=$p(^PAADM(rowid),"^",7)
	.i admtime'=""  s admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime,1)
	.s admdeptid=$p(^PAADM(rowid),"^",4)
	.q:($d(^CTLOC(admdeptid))=0)
	.s admdept=$p(^CTLOC(admdeptid),"^",2)
	.i admdept'=""  d
	..i $f(admdept,"-")'=0  d
	...s admdept=$p(admdept,"-",2)
	.s admwardid=$p(^PAADM(rowid),"^",70)
	.q:$g(admwardid)="" 
	.q:($d(^PAWARD(admwardid))=0)
	.s admward=$p(^PAWARD(admwardid),"^",2)
	.i admward'=""  d
	..i $f(admward,"-")'=0  d
	...s admward=$p(admward,"-",2)
	.s admbedid=$p(^PAADM(rowid),"^",73)
	.s admbed=""
	.i admbedid'=""  d
	..i $f(admbedid,"||")'=0  d
	...s admbed1=$p(admbedid,"||",1)
	...s admbed2=$p(admbedid,"||",2)
	...i (admbed1'="")&(admbed2'="")  d
	....i $d(^PAWARD(admbed1,"BED",admbed2))'=0  d
	.....s admbed=$p(^PAWARD(admbed1,"BED",admbed2),"^",1)
	.s admstatus=$p(^PAADM(rowid),"^",20)
	.i admstatus="A"  s admstatus="在院"
	.i admstatus="C"  s admstatus="取消住院"
	.i admstatus="D"  s admstatus="出院"
	.d OutputRowAdm1
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAdm1   
	set Data=$lb(rowid,admno,papno,papname,admdate,admtime,admdept,admward,admbed,admstatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// wangjian
/// 2015-03-31
/// 根据集中打印发票id取发药状态
ClassMethod GetDrugDisFlagAPI(APIRowId)
{
	n (APIRowId)
	s DspStatus="正常"
	s ApPrtRowid=0
	f  s ApPrtRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowId,ApPrtRowid)) q:((ApPrtRowid="")||(DspStatus'="正常"))  d
	.s PrtRowid=$p(^DHCINVPRTCAP(ApPrtRowid),"^",1)
	.s DspStatus=..GetDrugDisFlag(PrtRowid)
	q DspStatus
}

/// 判断发票是否有未发药医嘱;或者退药但未退费的医嘱
/// 判断门诊检验检查医嘱是否已执行，未执行不可转住院
/// w ##class(web.udhcOPRefEditCopy).GetDrugDisFlag(215073)
ClassMethod GetDrugDisFlag(myINVRowID)
{
	n (myINVRowID)
	s DspStatus="正常"
	s hospitalDR=$p(^DHCINVPRT(myINVRowID),"^",39)
	s conRowid=0
	f  s conRowid=$o(^DHCBCI(0,"INV",myINVRowID,conRowid)) q:(conRowid="")||(DspStatus'="正常")  d
	.s bill=$p($g(^DHCBCI(conRowid)),"^",2)
	.s PBOChildsub=0
	.f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:(PBOChildsub="")||(DspStatus'="正常")  d
	..q:($d(^DHCPB(bill,"O",PBOChildsub))=10)
	..s arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3)    ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s oeori=$p(^DHCPB(bill,"O",PBOChildsub),"^",4)
	..s arcgrp=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)          ;子类
	..s catgrp=$p($g(^ARC("IC",arcgrp)),"^",8)                           ;大类             
	..s ordCateType=$p($g(^ARC("IC",arcgrp)),"^",7)                      ;医嘱类型
    ..s ServerMaterial=$p($g(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),7)),"^",6)   ;
    ..s matDispGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(oeori, hospitalDR)
	..i (ordCateType="R") d
	...s OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4)       ;DHC_PatBillOrder->PBO_OEORI_DR
	...s OEORIStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
	...s DspStatus=..GetDispensingStat(OEORI)
	...i DspStatus="TC" s DspStatus="未发药"
	...i DspStatus="PC" s DspStatus="部分发药"
	...i ((DspStatus="R")||(DspStatus="PR")) s DspStatus="有退药未退费"
	...;i DspStatus="PR" s DspStatus="有退药未退费"
	...i (DspStatus="C") s DspStatus="正常"
	..e  i ((ordCateType="L")||(ServerMaterial="S")||(ServerMaterial="Service")) d
	...s itemstat=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
	...s itemstatcode=$p(^OEC("OSTAT",itemstat),"^",1)
	...s itemstatdesc=$p(^OEC("OSTAT",itemstat),"^",2)
	...i (itemstatcode="E") s DspStatus="正常"
	...e  s DspStatus="检验或检查医嘱非执行状态"
	...s isPartExec=##class(web.udhcOPRefund).IsPartExecut2(oeori)
	...i (isPartExec=0) s DspStatus="未执行"
	...i (isPartExec=1) s DspStatus="部分执行"
	...i (isPartExec=2) s DspStatus="正常"
	...s isPartRef=##class(web.DHCOPBillOERefundQty).IsPartRefund(oeori)
	...i (isPartRef=0) s DspStatus="部分退费"
	..e  d
	...i (matDispGrant="Y") d
	....s matDspQty=##class(web.DHCOPBillRefundRequest).GetMatDispQty(oeori)
	....s dspQty=$p(matDspQty,"^",1)      //发放数量
	....s retQty=$p(matDspQty,"^",2)      //退回数量
	....i (+dspQty=0) s DspStatus="未发"
	....i (+retQty'=0) s DspStatus="退回"
	....i ((+dspQty'=0)&&(+retQty=0)) s DspStatus="正常"
	...e  d
	....s isPartRef=##class(web.DHCOPBillOERefundQty).IsPartRefund(oeori)
	....i (isPartRef=0) s DspStatus="部分退费"
	....e  s DspStatus="正常"

	q DspStatus
}

/// wangjian
/// 2015-03-31
/// 判断医嘱发药状态
/// w ##class(web.udhcOPRefEditCopy).GetDispensingStat("168||15")
ClassMethod GetDispensingStat(oeitm As %String) As %String
{
	new (oeitm)
	set dspStat=##class(PHA.FACE.OUT.Com).GetDispensingStat(oeitm)
	quit dspStat
}

/// w ##class(web.udhcOPRefEditCopy).JudgeAlreadyRefund("197918^197919^197920^197921^197922^197923","16")
ClassMethod JudgeAlreadyRefund(INVPRTRowidstr, myExpStr)
{
	s rtn=0,notstr=""
	q:INVPRTRowidstr="" rtn
	s IPAdm=$p(myExpStr,"^",1)  ;住院就诊
	s len=$l(INVPRTRowidstr,"^")
	f i=1:1:len d
	.s INVPRTRowid=""
	.s INVPRTRowid=$p(INVPRTRowidstr,"^",i)
	.q:INVPRTRowid=""
	.s conRowid=0 
	.f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:(conRowid="")  d
	..s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	..s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	..i $d(^DHCOPIPADMCON("OPADMORDER","OPAdm",adm)) d
	...s tIPAdm=""
	...f  s tIPAdm=$o(^DHCOPIPADMCON("OPAdm",tIPAdm)) q:(tIPAdm="")  d
	....s tOPAdm=""
	....f  s tOPAdm=$o(^DHCOPIPADMCON("OPAdm",tIPAdm,tOPAdm)) q:(tOPAdm="")  d
	.....q:(tOPAdm'=adm)
	.....i (tIPAdm'=IPAdm) d
	......i (notstr="") s notstr=INVPRTRowid
	......e  s notstr=notstr_","_INVPRTRowid
	
	q:(notstr'="") "1^"_notstr
	
	q "0^"
}

/// 验证检查申请单是否全部执行
/// 0:部分执行或未执行，1：全部执行或不包含新版申请单医嘱
/// w ##class(web.udhcOPRefEditCopy).CheckAppRepExec("215063")
ClassMethod CheckAppRepExec(prtRowIdStr)
{
	new (prtRowIdStr)
	set str=""
	set len=$l(prtRowIdStr,"^")
	for i=1:1:len do
	.set prtRowId=$p(prtRowIdStr,"^",i)
	.set conRowid=0 
	.for  set conRowid=$o(^DHCBCI(0,"INV",prtRowId,conRowid)) quit:conRowid=""  do
    ..set bill=$p($g(^DHCBCI(conRowid)),"^",2)
    ..set sub=0
    ..for  set sub=$o(^DHCPB(bill,"O",sub)) quit:sub=""  do
    ...set oeitm=$p(^DHCPB(bill,"O",sub),"^",4)
    ...set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	...;quit:isAppRepFlag'="Y"
   	...set arcim=$p(^DHCPB(bill,"O",sub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
    ...set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)   ;名称
    ...set isPartExec=##class(web.udhcOPRefund).IsPartExecut(oeitm)
    ...if isPartExec=0 do
    ....if (str="") set str=arcimDesc_"("_oeitm_")"
    ....else  set str=str_","_arcimDesc_"("_oeitm_")"
    ;
    if (str'="") do
    .set rtn=0_"^"_str_",没有全部执行，不能转住院."
    else  do
    .set rtn=1_"^"
	;
    quit rtn
}

/// 验证医嘱是否部分退费
/// 0:部分退费，1：没有退费
/// w ##class(web.udhcOPRefEditCopy).CheckPartRefund("215063")
ClassMethod CheckPartRefund(prtRowIdStr)
{
	new (prtRowIdStr)
	set str=""
	set len=$l(prtRowIdStr,"^")
	for i=1:1:len do
	.set prtRowId=$p(prtRowIdStr,"^",i)
	.set conRowid=0 
	.for  set conRowid=$o(^DHCBCI(0,"INV",prtRowId,conRowid)) quit:conRowid=""  do
    ..set bill=$p($g(^DHCBCI(conRowid)),"^",2)
    ..set sub=0  
    ..for  set sub=$o(^DHCPB(bill,"O",sub)) quit:sub=""  do
    ...set oeitm=$p(^DHCPB(bill,"O",sub),"^",4)
   	...set arcim=$p(^DHCPB(bill,"O",sub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
    ...set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)   ;名称
    ...set isPartRef=##class(web.DHCOPBillOERefundQty).IsPartRefund(oeitm)
    ...if (isPartRef=0) do
    ....if (str="") set str=arcimDesc_"("_oeitm_")"
    ....else  set str=str_","_arcimDesc_"("_oeitm_")"
    ;
    if (str'="") do
    .set rtn=0_"^"_str_",部分退费，不能转住院."
    else  do
    .set rtn=1_"^"
	;
    quit rtn
}

}
