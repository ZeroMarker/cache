Import SQLUser

Class web.udhcOPRefund20070803Back Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 222;

/// /2007-08-03 作的备份
ClassMethod CancelReceipt(INVPRTRowid As %String, cUser As %String)
{
	d ##class(web.udhcOPBill).tb()
	s success=0
	s cdate=+$h
	s ctime=$p($h,",",2)
	;&sql(update DHC_INVPRT set PRT_CancelDate=:cdate,PRT_CancelTime=:ctime,PRT_Flag="A"
	;     where PRT_Rowid=:INVPRTRowid)
	i SQLCODE'=0  d
	.s success=-1
	.Trollback
	q:success=-1
	s PHARowid=0 f  s PHARowid=$o(^DHCPHARi("PRT",INVPRTRowid,PHARowid)) q:PHARowid=""  d
	.i $p(^DHCPHARW(PHARowid),"^",6)'="1"  d
	..b
	..s $p(^DHCPHARW(PHARowid),"^",7)="1"
	s PRTAcount=$p(^DHCINVPRT(INVPRTRowid),"^",1)
	s ARRCPDR=$p(^DHCINVPRT(INVPRTRowid),"^",2)
	s PAPMIDR=$p(^DHCINVPRT(INVPRTRowid),"^",15)
	s PRTUsr=$p(^DHCINVPRT(INVPRTRowid),"^",21)
	s PRTAcount=-PRTAcount
	&sql(insert into DHC_INVPRT(PRT_Acount,PRT_ARRCP_DR,PRT_Date,PRT_Flag,PRT_initInv_DR,PRT_PAPMI_DR,PRT_UseINVType,PRT_Time,PRT_Usr)
	       values(:PRTAcount,:ARRCPDR,:cdate,'A',:INVPRTRowid,:PAPMIDR,'OutPatient',:ctime,:PRTUsr))
	i SQLCODE=0  d
	.s RERowid=$g(%ROWID)
	e  d
	.s success=-1
	.Trollback
	q:success=-1
	s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:conRowid=""  d
	.s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	.s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	.s ret=##class(web.UDHCJFPBCANCEL).PBCancel(adm,Billno,cUser,"")
	.s celret=$p(ret,"^",1)
	.i celret'=0  d 
	..s success=-1
	..Trollback
	.e  d 
	..s rebillno=$p(ret,"^",2)
	..&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR)
	      values (:adm,:RERowid,:rebillno))
	..i SQLCODE'=0  d
	...Trollback
	...s success=-1
	d ##class(web.udhcOPBill).tc()
 q success
}

ClassMethod CheckPhDispRet(orditm As %String)
{
	;##class(web.udhcOPRefund).CheckPhDispRet("")
	n (orditm)
	s tt=0,exe="",ord="",itm="",purqty=0,con=1,basqty=0
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s itmmast="",itmmastid="",itmmastver=""
	s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
	s itmmastid=$p(itmmast,"||",1)
	s itmmastver=$p(itmmast,"||",2)
	s inci="",basuom="",puruom=""
	s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	s basuom=+$p(^INCI(inci,1),"^",10)
	s puruom=+$p(^INCI(inci,3),"^",6)
	s conrow=""
	i puruom'=basuom  d
	.s conrow=$o(^CT("CTCF",0,"UOM",puruom,basuom,conrow))
	.s con=+$p(^CT("CTCF",conrow),"^",3)
	e  s con=1
	s exe=0
	s statu=""
	b
	f  s exe=$o(^OEORD(ord,"I",itm,"X",exe)) q:((exe="")!(statu["C"))  d
	.s dsp=0
	.f  s dsp=$o(^OEORD(ord,"I",itm,"X",exe,"D",dsp)) q:(dsp="")!(statu["C")!(dsp=0)  d 
	..s retqty=0,status="",conqty=0
	..s statu=$p($g(^OEORD(ord,"I",itm,"X",exe,"D",dsp)),"^",6)
	..q:statu'["C"
	..s tt=tt+1
	..s retqty=+$p($g(^OEORD(ord,"I",itm,"X",exe,"D",dsp)),"^",7)
	..i retqty=""  s retqty=0 
	..s basqty=basqty+retqty
	s ret=0
	;i (tt>0)&(purqty=0) d  s ret=1
	i (statu="C") d  s ret=1
	q ret
}

ClassMethod GetOrderbyReceipIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderbyReceipIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrderbyReceipIDExecute(ByRef qHandle As %Binary, ReceipRowid As %String, AuditFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	d ResetVariables
	
	;增加发票RowID
	;d ##class(%ResultSet).RunQuery("web.udhcOPRefund","GetOrderbyReceipID","3989","")
	;AuditFlag审批标志
	;=""  默认查询所有的
	;s ^TMPDD=ReceipRowid
	;在此编写算法计算必须要退的医嘱项目selflag=1
	;Executflag  应该表示为?执行医嘱标志?(只要医嘱被执行过?药品和费用项目等)
	;
	
	i ReceipRowid="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",ReceipRowid,conRowid)) q:conRowid=""  d
	.;b
	.s bill=$p($g(^DHCBCI(conRowid)),"^",2)
	.s selflag=1
	.s confac=""
	.s PBOChildsub=0  f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:PBOChildsub=""  d
	..s Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2) ;名称
	..s OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
	..s myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(ReceipRowid, OEORI, "")
	..;myAuditFlag, myAuditCheckDis, myAuditSelFlag
	..s myAuditFlag=$p(myrtn,"^",1)     ;判断是否审批
	..s myAuditCheckDis=$p(myrtn,"^",2)		;判断选择项目是否Disable
	..s myAuditSelFlag=$p(myrtn,"^",3)		;判断选择项目是否被选中
	..s Executflag=0
	..s OrderUnitPrice=$p(^DHCPB(bill,"O",PBOChildsub),"^",7)	;PBO_UnitPrice
	..s Billreturnqty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)		;PBO_RefundQty
	..s OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)		;PBO_BillQty
	..s returnqty=0
	..s confac=##class(web.DHCOPCashier).GetUomConvFactor(Arcim)
	..i +confac=0  s confac=1
	..s OrderBillQty=(OrderBillQty+Billreturnqty)/confac
	..;
	..;s PatSum=OrderUnitPrice*OrderBillQty
	..s PatSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
	..s PatSum=$fn(PatSum,"",2)
	..s myRefSum=PatSum		;;
	..s recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	..s recdepdesc=$p($g(^CTLOC(recdepcode)),"^",2)
	..i $l(recdepdesc,"-")>1 d  s recdepdesc=$p(recdepdesc,"-",2)
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..i ARCOrdType="R"  d
	...;s Executflag=..CheckPhDispRet(OEORI)
	...s Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)
	...;此处的部分退药?有个小Bug
	...s returnqty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)		;PBO_RefundQty
	...s returnqty=+$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",23) ;医嘱退药数量
	...;在门诊药房
	...;DHC_PHRetItm		;;
	...;^DHCPHRETi("NEWPRT",{PHRET_NEWPRT_DR},{PHRET_PHL_DR},{PHRET_ROWID})
	...;s ^TMPReceipt=ReceipRowid_"^"_OEORI
	...s returnqty=##class(web.udhcOPPHARWIN).ReadRefundQty(ReceipRowid,OEORI)
	...;增加的护士站，退药判断；
	...s oeordId=$p(OEORI,"||",1),oeoriSub=$p(OEORI,"||",2)
	...s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    ...s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
	...s itemstat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	...s statcode=""
	...i itemstat'="" d
	....s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
    ...i ((ARCOrdType="R")&(phlId'="")&(statcode'="D")) d
    ....;对于药物，非停止医嘱，符合护士站虚发药的
    ....s ActiveFlag=+$p($g(^DHCPHLOC(phlId)),"^",7)
    ....i ActiveFlag=1 d
    .....s returnqty=+$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",23) ;医嘱退药数量
	...; end
	...s confac=##class(web.DHCOPCashier).GetUomConvFactor(Arcim)
	...i +confac=0  s confac=1
	...s returnqty=returnqty/confac
	...i Executflag=0 d  
	....;药物医嘱?没有发药的
	....s selflag=0
	...e  d
	....;药物医嘱?已经发药的?Executflag=1
	....s selflag=0
	....;已经退药的
	....i +returnqty'=0 d  
	.....i OrderBillQty=returnqty d
	......s selflag=1		;;全部退
	.....e  d
	......s selflag=1		;;部分退
	.....;s selflag=1
	.....;s myRefSum=$fn($fn((myRefSum/OrderBillQty),"",6)*returnqty,"",2)
	.....i +PatSum'=0  d
	......s myRefSum=OrderUnitPrice*confac*returnqty
	......s myRefSum=$fn(myRefSum+0.0000001,"",2)
	..e  d
	...s OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
	...s OrdStatdesc=$p(^OEC("OSTAT",OrdStat),"^",2)
	...i ($p(^OEC("OSTAT",OrdStat),"^",1)="E") d
	....;被执行的非药物医嘱?
	....s Executflag=1
	....s selflag=0
	...e  d
	....;没有被执行的非药物医嘱?
	....s Executflag=0
	....s selflag=0
	...;i OrdStat="6"  s Executflag=1 
	..i (+selflag=1)&(+Executflag=1) d
	...s myAuditSelFlag=1
	..Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum, myAuditFlag, myAuditCheckDis, myAuditSelFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	s (selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum, myAuditFlag, myAuditCheckDis, myAuditSelFlag)=""
	s selflag=0
	;医嘱执行数量 对于药物医嘱指发药数量
	s OEORDExecQty=0
	
	quit
}

ClassMethod GetOrderbyReceipIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderbyReceipIDExecute ]
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
	Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRcptinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", INVPRTRowid As %String)
{
	;获取发票信息 DHC_INPVRT表的信息
	;所有的发票都需要审批,可以出现假审批,当时只有=Y  时才能退费
	;。。。。。。
	;w ##class(web.udhcOPRefund).GetRcptinfo("","","3824")
	s myColPFlag=0
	s Refundflag=0
	s DHCINVPRTRDR=""
	
	s flag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",8)
	s PRTAcount=$p($g(^DHCINVPRT(INVPRTRowid)),"^",1)
	s PRTPatPay=$p($g(^DHCINVPRT(INVPRTRowid)),"^",16)
	s PRTUsr=$p($g(^DHCINVPRT(INVPRTRowid)),"^",21)
	s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	s PrtPapmiDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",15)
	s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	s PapmiSex=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",7)
	s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
	s myINSDivDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",30)		;PRT_InsDiv_DR
	s myYBPaySum=+$p($g(^DHCINVPRT(INVPRTRowid)),"^",31)	;PRT_YBPaySum
	s myOPRoundSum=+$p($g(^DHCINVPRT(INVPRTRowid)),"^",37)	;PRT_OPCRoundErr
	s myINSTypeDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",9)		;PRT_InsType_DR
	
	s Verifyflag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",22)			;审批标志
	;判断是否需要审批  医院基本配置表中   
	;myConAppFlag=1    不需要审批
	;myConAppFlag=0    需要审批，默认的值
	;myConAppFlag=2		需要审批到医嘱  需要在审批时，判断
	s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)			;OPFC_AppFlag
	;i +myConAppFlag=1 d
	;.s Verifyflag="Y"
	
	;审批转换到接口类中
	s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(INVPRTRowid,"")
	s Verifyflag=$p(myrtn,"^",1)
	s myMixOE=$p(myrtn,"^",2)				;混合医嘱标志
	;增加一个特殊限制标志   大同
	;此特殊标志，使界面的操作员退自己出的发票失效
	;=Y  表示失效
	;=N  或  ""  表示无效
	s mySpecLFalg=$p($g(myrtn),"^",4)
	
	s DHCINVPRTRDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",6)
	s myINVPayMDR=""
	s myINVPMSub=$o(^DHCINVPRT(INVPRTRowid,"P",0))
	i myINVPMSub'="" d
	.s myINVPayMDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",1)
	.s myAccPLDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",8)		;IPM_AccPL_DR
	.s myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
	.i myPayCode="CPP" d
	..s myAccRowID=+myAccPLDR
	..s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	..s myAccFlag=$p(^DHCACD("AccM",myAccRowID),"^",13)
	..;如果是账户支付，判断是否能够退费；
	..;如果没有打印发票，必须在此退；
	..;N   P
	..;如果已经打印发票，不能退,必须到集中打印发票处退
	..s myPFlag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",3)		;PRT_INVPrintFlag
	..s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)		;PRT_inv
	..i ((myPFlag="P")&&(myINVNo="")) d
	...s myColPFlag=1		;已经集中打印了
	..q:(myAccFlag="N")		;账户正常退出，否则转为现金支付；
	..s myINVPayMDR=myCashPMDR
	..
	b
	i $D(^DHCINVPRT(0,"INITID",INVPRTRowid))'=0  s Refundflag=1
	
	s ret=PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_PRTPatPay_"^"_flag_"^"_Refundflag_"^"_PRTUsr_"^"_DHCINVPRTRDR_"^"_Verifyflag
	s ret=ret_"^"_myINVPayMDR_"^"_myColPFlag_"^"_myConAppFlag_"^"_myMixOE
	s ret=ret_"^"_myINSDivDR
	s ret=ret_"^"_mySpecLFalg_"^"_myYBPaySum
	s ret=ret_"^"_myOPRoundSum
	s ret=ret_"^"_myINSTypeDR
	
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	
	q 0
}

ClassMethod GetRepROWID(ReceipNO As %String)
{
	s ret=0
	s ReceipNO=ReceipNO
	i $d(DHCINVPRT(0,"INV",ReceipNO))=0  s ret=-1    
	s INVPRTRowid=""  f  s INVPRTRowid=$o(^DHCINVPRT(0,"INV",ReceipNO,INVPRTRowid)) q:INVPRTRowid=""  d
	.s ret=INVPRTRowid
	q ret
}

ClassMethod GetRepROWIDBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", ReceipNO As %String)
{
	s ret=..GetRepROWID(ReceipNO)
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	q ret
}

ClassMethod ReadOrderByAPIRowIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadOrderByAPIRowIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadRcptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadRcptListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReadOrderByAPIRowIDExecute(ByRef qHandle As %Binary, APIRowID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	d ResetVariablesFAPI
	
	;d ##class(%ResultSet).RunQuery("web.udhcOPRefund","ReadOrderByAPIRowID","58")
	
	;在此编写算法计算必须要退的医嘱项目selflag=1
	;能否选择由两个变量决定：1。是否执行，2。是否审批通过
	;Executflag  应该表示为?执行医嘱标志?(只要医嘱被执行过?药品和费用项目等)
	;myAppFlag   表示此医嘱是否经过审批；
	;如果小票没有经过审批，就是退药，也不能退费,即：selflag=0
	
	i APIRowID="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s myIdx=0
	
	s myAConRowID=0
	f  s myAConRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,myAConRowID)) q:(myAConRowID="")  d
	.s ReceipRowid=$p(^DHCINVPRTCAP(myAConRowID),"^",1)					;ACP_INVPRT_DR
	.s myAppFlag=$p(^DHCINVPRT(ReceipRowid),"^",22)					;审批标志
	.s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)			;OPFC_AppFlag
	.s myINVPMSub=$o(^DHCINVPRT(ReceipRowid,"P",0))
	.i myINVPMSub'="" d
	..s myINVPayMDR=$p($g(^DHCINVPRT(ReceipRowid,"P",myINVPMSub)),"^",1)
	..s myAccPLDR=$p($g(^DHCINVPRT(ReceipRowid,"P",myINVPMSub)),"^",8)		;IPM_AccPL_DR
	..q:(myAccPLDR="")
	..s myRecLocDR=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",10)	;
	..s myRecLocdesc=$p($g(^CTLOC(myRecLocDR)),"^",2)
	.;b	;myAConRowID
	.s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",ReceipRowid,conRowid)) q:conRowid=""  d
	..;b
	..s bill=$p($g(^DHCBCI(conRowid)),"^",2)
	..s myPRTDR=$p($g(^DHCBCI(conRowid)),"^",1)
	..s myPayDTime=$zd($p(^DHCINVPRT(myPRTDR),"^",5),3)
	..s myPayDTime=myPayDTime_" "_$zt($p(^DHCINVPRT(myPRTDR),"^",20))
	..s selflag=1
	..s confac=""
	..s PBOChildsub=0  f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:PBOChildsub=""  d
	...s Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	...s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2) ;名称
	...s OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
	...s Executflag=0
	...s OrderUnitPrice=$p(^DHCPB(bill,"O",PBOChildsub),"^",7)	;PBO_UnitPrice
	...s Billreturnqty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)		;PBO_RefundQty
	...s OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)		;PBO_BillQty
	...s returnqty=0
	...s confac=##class(web.DHCOPCashier).GetUomConvFactor(Arcim)
	...i +confac=0  s confac=1
	...s OrderBillQty=(OrderBillQty+Billreturnqty)/confac
	...s myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(ReceipRowid, OEORI, "")
	...s myAppFlag=$p(myrtn,"^",1)			;判断是否审批
	...;s myAuditFlag=$p(myrtn,"^",1)
	...s myAuditCheckDis=$p(myrtn,"^",2)		;判断选择项目是否Disable
	...s myAuditSelFlag=$p(myrtn,"^",3)		;判断选择项目是否被选中
	...;s PatSum=OrderUnitPrice*OrderBillQty
	...s PatSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
	...s PatSum=$fn(PatSum,"",2)
	...s myRefSum=PatSum		;;
	...s myBillNo=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",4)
	...s recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	...s recdepdesc=$p($g(^CTLOC(recdepcode)),"^",2)
	...i $l(recdepdesc,"-")>1 d  s recdepdesc=$p(recdepdesc,"-",2)
	...s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	...s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	...i ARCOrdType="R"  d
	....;s Executflag=..CheckPhDispRet(OEORI)
	....s Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)
	....;此处的部分退药?有个小Bug
	....s returnqty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)		;PBO_RefundQty
	....s returnqty=+$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",23) ;医嘱退药数量
	....;在门诊药房
	....;DHC_PHRetItm		;;
	....;^DHCPHRETi("NEWPRT",{PHRET_NEWPRT_DR},{PHRET_PHL_DR},{PHRET_ROWID})
	....;s ^TMPReceipt=ReceipRowid_"^"_OEORI
	....s returnqty=##class(web.udhcOPPHARWIN).ReadRefundQty(ReceipRowid,OEORI)
	....;增加的护士站，退药判断；
	....s oeordId=$p(OEORI,"||",1),oeoriSub=$p(OEORI,"||",2)
	....s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    ....s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
	....s itemstat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	....s statcode=""
	....i itemstat'="" d
	.....s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
    ....i ((ARCOrdType="R")&(phlId'="")&(statcode'="D")) d
    .....;对于药物，非停止医嘱，符合护士站虚发药的
    .....s ActiveFlag=+$p($g(^DHCPHLOC(phlId)),"^",7)
    .....i ActiveFlag=1 d
    ......s returnqty=+$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",23) ;医嘱退药数量
	....; end
	....s confac=##class(web.DHCOPCashier).GetUomConvFactor(Arcim)
	....i +confac=0  s confac=1
	....s returnqty=returnqty/confac
	....i Executflag=0 d  
	.....;药物医嘱?没有发药的
	.....s selflag=0
	....e  d
	.....;药物医嘱?已经发药的?Executflag=1
	.....s selflag=0
	.....;已经退药的  同时要求审批过的小票
	.....i ((+returnqty'=0)&&(myAppFlag="Y")) d
	......i OrderBillQty=returnqty d
	.......s selflag=1		;;全部退
	......e  d
	.......s selflag=1		;;部分退
	......;s myRefSum=$fn($fn((myRefSum/OrderBillQty),"",6)*returnqty,"",2)
	......i +PatSum'=0 d
	.......s myRefSum=OrderUnitPrice*confac*returnqty				;修改为*
	.......s myRefSum=$fn((myRefSum+0.0000001),"",2)
	...e  d
	....s OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
	....s OrdStatdesc=$p(^OEC("OSTAT",OrdStat),"^",2)
	....
	....i (($p(^OEC("OSTAT",OrdStat),"^",1)="E")) d
	.....;被执行的非药物医嘱?
	.....s Executflag=1
	.....s selflag=0
	....e  d
	.....;没有被执行的非药物医嘱?
	.....s Executflag=0
	.....s selflag=0
	....;i OrdStat="6"  s Executflag=1 
	...i (myAppFlag="Y") d
	....s myAppDesc="审批"
	...e  d
	....s myAppDesc="未审批"
	...;增加审批的其他选项
	...;补充zhaocz2006-06-28
	...i (+selflag=1)&(+Executflag=1) d
	....s myAuditSelFlag="1"
	...Do OutputRowFAPI
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFAPI
	set Data=$lb(selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum, ReceipRowid, myRecLocdesc, ind, myBillNo, myAppFlag, myAppDesc, myAuditCheckDis, myAuditSelFlag, myPayDTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesFAPI
	s (selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum)=""
	s (myRecLocdesc, myBillNo, myAppFlag, myAppDesc)=""
	s (myAuditCheckDis, myAuditSelFlag)=""
	s selflag=0
	s myPayDTime=""
	
	quit
}

ClassMethod RefundReceipt(itmjs As %Library.String = "", itmjsex As %Library.String = "", INVPRTRowid As %String, rUser As %String)
{
	d ##class(web.udhcOPBill).tb()
	s success=0
	s cdate=+$h
	s ctime=$p($h,",",2)
	s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) q:conRowid=""  d
	.s adm=$p($g(^DHCBCI(conRowid)),"^",3)
	.s Billno=$p($g(^DHCBCI(conRowid)),"^",2)
	.s ret=##class(web.UDHCJFPBCANCEL).PBCancel(adm,Billno,cUser,"")
	.s celret=$p(ret,"^",1)
	.i celret'=0  d 
	..s success=-1
	..Trollback
	.e  d 
	..s PHARowid=0 f  s PHARowid=$o(^DHCPHARi(INVPRTRowid,PHARowid)) q:PHARowid=""  d
	..i $p(^DHCPHARW(PHARowid),"^",6)'="1"  d
	...s $p(^DHCPHARW(PHARowid),"^",7)="1"
	..s rebillno=$p(ret,"^",2)
	..s PRTAcount=$p(^DHCINVPRT(INVPRTRowid),"^",1)
	..s ARRCPDR=$p(^DHCINVPRT(INVPRTRowid),"^",2)
	..s PAPMIDR=$p(^DHCINVPRT(INVPRTRowid),"^",15)
	..s PRTAcount=-PRTAcount
	..&sql(insert into DHC_INVPRT(PRT_Acount,PRT_ARRCP_DR,PRT_Date,PRT_Flag,PRT_initInv_DR,PRT_PAPMI_DR,PRT_UseINVType,PRT_Time,PRT_Usr)
	       values(:PRTAcount,:ARRCPDR,:cdate,'S',:INVPRTRowid,:PAPMIDR,'OutPatient',:ctime,:rUser))
	..i SQLCODE=0  d
	...s RERowid=$g(%ROWID)
	...&sql(insert into DHC_BillConINV (DHCBCI_ADMDR,DHCBCI_INVDR,DHCBCI_PatBillDR)
	      values (:adm,:RERowid,:rebillno))
	...i SQLCODE'=0  d
	...Trollback
	...s success=-1
	..e   d
	...Trollback
	...s success=-1
	d ##class(web.udhcOPBill).tc()
 q success
}

ClassMethod ReadOrderByAPIRowIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadOrderByAPIRowIDExecute ]
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
	Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReadRcptListExecute(ByRef qHandle As %Binary, APIRowID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.udhcOPRefund","ReadRcptList","58")
	
	Set repid=$I(^CacheTemp)
	s ind=1
	d ResetVariablesRL
	
	i APIRowID="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s myIdx=0
	
	;序号, SelFlag选择, 支付单号, 操作员, 支付日期, 支付时间, 支付额, 退费医嘱串
	;INVPRTRowID, 费别INSType, 退费金额, 支付地点
	;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})
	s conRowid=0
	f  s conRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,conRowid)) q:(conRowid="")  d
	.s myIdx=myIdx+1
	.d ResetVariablesRL
	.s INVPRTRowid=$p(^DHCINVPRTCAP(conRowid),"^",1)					;ACP_INVPRT_DR
	.s flag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",8)
	.s PRTAcount=$p($g(^DHCINVPRT(INVPRTRowid)),"^",1)
	.s PRTPatPay=$p($g(^DHCINVPRT(INVPRTRowid)),"^",16)
	.s PRTUsr=$p($g(^DHCINVPRT(INVPRTRowid)),"^",21)
	.s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	.s myPrtDate=$p($g(^DHCINVPRT(INVPRTRowid)),"^",5)
	.s myPrtTime=$p($g(^DHCINVPRT(INVPRTRowid)),"^",20)
	.s Verifyflag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",22)
	.s DHCINVPRTRDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",6)
	.s myINVPayMDR=""
	.;只有一种支付方式，如果多种需要修改；
	.s myINVPMSub=$o(^DHCINVPRT(INVPRTRowid,"P",0))
	.i myINVPMSub'="" d
	..s myINVPayMDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",1)
	..s myAccPLDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",8)		;IPM_AccPL_DR
	..q:(myAccPLDR="")
	..;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccPL",{AccPL_Sub})
	..s myBillNo=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",4)		;
	..s myRecLocDR=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",10)	;
	..s myRecLocdesc=$p($g(^CTLOC(myRecLocDR)),"^",2)
	..s myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
	..;卡支付
	..i myPayCode="CPP" d
	...s myAccRowID=+myAccPLDR
	...s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))		;现金支付
	...s myAccFlag=$p(^DHCACD("AccM",myAccRowID),"^",13)
	...s myPFlag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",3)		;PRT_INVPrintFlag
	...s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)		;PRT_inv
	...i ((myPFlag="P")&&(myINVNo="")) d
	....s myColPFlag=1		;已经集中打印了
	...q:(myAccFlag="N")		;账户正常退出，否则转为现金支付；
	...s myINVPayMDR=myCashPMDR
	..Do OutputRowRL
	
	;序号, SelFlag选择, 支付单号, 操作员, 支付日期, 支付时间, 支付额, 退费医嘱串
	;INVPRTRowID, 费别INSType, 退费金额, 支付地点
	;selflag  0  可选   1  不可选
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowRL
	set Data=$lb(myIdx,selflag,myBillNo,UserNo,myPrtDate,myPrtTime,myTolSum,myOEOrdRStr,myInsType,myRefundSum,myRecLocdesc, INVPRTRowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesRL
	s (selflag, myBillNo, UserNo, myPrtDate, myPrtTime, myTolSum, myOEOrdRStr,myInsType, myRefundSum, myRecLocdesc)=""
	s selflag=0
	quit
}

ClassMethod UpdateOrderStat(Orderstr As %String, uUser As %String)
{
	s StopOrderstr=$p(Orderstr,"!",1)
	s ToBillOrderstr=$p(Orderstr,"!",2)
	s updatedate="",updatetime=""
	s updatedate=$p($h,",",1)
	s updatetime=$p($h,",",2)
	s CTPCPDR=$p(^SSU("SSUSR",uUser),"^",9) 
	i StopOrderstr'=""  d
	.s stopnum=$l(StopOrderstr,"^")
	.f num=1:1:stopnum  d
	..s StopOrderid=$p(StopOrderstr,"^",num)
	..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),1),"^",13)="4"
	..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),2),"^",15)=updatetime
	..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),3),"^",34)=updatedate
	..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),3),"^",29)=CTPCPDR
	..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),8),"^",12)=uUser
	i ToBillOrderstr'=""  d
	.s tobillnum=$l(ToBillOrderstr,"^")
	.f tbnum=1:1:tobillnum  d
	..s ToBillOrderid=$p(ToBillOrderstr,"^",tbnum)
	..s $p(^OEORD(+ToBillOrderid,"I",$p(ToBillOrderid,"||",2),3),"^",5)="TB"
	q 0
}

ClassMethod ReadRcptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadRcptListExecute ]
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
	Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod VerifyRefundRcp(INVPRTRowid As %String, vUser As %String, AuditINfo As %String, OEORDStr As %String, RefReason As %String, RefAudiLocDR As %String) As %String
{
	n (INVPRTRowid, vUser, AuditINfo, OEORDStr, RefReason, RefAudiLocDR)
	
	s $ZT="ERROR^DHCSSERR"
	
	;s ^TMPDDDDDDD=INVPRTRowid_","_vUser_","_AuditINfo_","_OEORDStr_","_RefReason_","_RefAudiLocDR
	;w ##class(web.udhcOPRefund).VerifyRefundRcp(4079,1,"^^^865||9^1^^^^P","865||9","122",1087)
	s myrtn=0
	
	d ..tb()
	
	s vdate=+$h
	s vtime=$p($h,",",2)
	;b	;PRT_AllowRefund='Y',
	&sql(update DHC_INVPRT set PRT_AllowRefund='Y',PRT_AllRefundDate=:vdate,PRT_AllRefundTime=:vtime,PRT_AllRefundUser=:vUser,
		PRT_RefundReason=:RefReason, PRT_RefAuditLoc_DR=:RefAudiLocDR
		where PRT_Rowid=:INVPRTRowid)
	s myrtn=SQLCODE
	
	;RefAuditLocDR, RefundReason
	i (+myrtn=0) d
	.s myrtn=##class(web.UDHCPRTOEAuthIF).SaveAuthInfo(INVPRTRowid,vUser, OEORDStr, AuditINfo,RefAudiLocDR, RefReason, "")
	
	b	;;Tro
	i (+myrtn=0) d
	.d ..tc()
	e  d
	.Trollback
	
	q +myrtn
}

Query GetOrderbyReceipID(ReceipRowid As %String, AuditFlag As %String) As %Query(ROWSPEC = "Tselect:%String,TOrder:%String,TOrderSum:%String,TOrderQty:%String,TRecloc:%String,TReturnQty:%String,TOrderRowid:%String,TExcuteflag:%String,RefSum:%String, AuditFlag:%String, AuditCheckDis:%String, AuditSelFlag:%String")
{
}

/// 利用DHC_AccPayINV表的RowID查询医嘱List
Query ReadOrderByAPIRowID(APIRowID As %String = "") As %Query(ROWSPEC = "Tselect:%String,TOrder:%String,TOrderSum:%String,TOrderQty:%String,TRecloc:%String,TReturnQty:%String,TOrderRowid:%String,TExcuteflag:%String,RefSum:%String,PRTRowID:%String,RecLocdesc:%String,No:%String,BillNo:%String, AppFlag:%String,AppDesc:%String, AuditCheckDis:%String, AuditSelFlag:%String, PayDTime:%String")
{
}

/// 查询支付点
Query ReadRcptList(APIRowID As %String) As %Query(ROWSPEC = "Arg1:%String,Arg2:%String,Arg3:%String,Arg4:%String,Arg5:%String")
{
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
