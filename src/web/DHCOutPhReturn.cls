Import sqluser

Class web.DHCOutPhReturn Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCOutPhReturn).DoReturn(99,578,"100000006||1",2,100000008,"","","100000006||1^1^3^50^1")
ClassMethod DoReturn(ctloc As %Library.String = "", userid As %Library.String = "", phditm As %Library.String = "", rfr As %Library.String = "", newprt As %Library.String = "", winpos As %Library.String = "", reqrow As %Library.String = "", RetInf As %Library.String = "")
{
    s currdate=$p($h,",",1)
	s currtime=$p($h,",",2) 
	s sysdate=$zd(currdate,3)
	s curryear=$p(sysdate,"-",1)
	s phd="",itm=""
	s phd=$p(phditm,"||",1)
	s itm=$p(phditm,"||",2)
	s phl="",retmain="0",su=0,retrow=""
    s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
   
    s phlocp=$p(^DHCPHDISP(phd,1),"^",1) //add wyx 2014-11-10
    s phllocpdr=$p(^DHCPHLOC(phlocp),"^",2)
    s phlocpdesc=$p(^CTLOC(phllocpdr),"^",2)
    s othlocretflag=$p(^DHCPHLOC(phl),"^",8) //是否可以跨科室退药
    q:(phl'=phlocp)&(othlocretflag'="Y") -6
    
    s newprt=+$p(^DHCPHDISP(phd),"^",2)
    i newprt'=0 s newprt=..GetNewPrtFrOld(newprt)
    s orditem=$p(^DHCPHDI(phd,"PHDI",itm),"^",5)
    i +newprt=0 s newprt=##class(PHA.FACE.IN.Com).GetLastInvByOE(orditem)  //如果是先发药后收费,退药时再补一次最新发票id liangqiang 2014-01-16 和yyx沟通
	s prtdr=""
	s prtdr=+$p(^DHCPHDISP(phd),"^",2)
	s inv=""
	s:prtdr'=0 inv=$p(^DHCINVPRT(prtdr),"^",14)
    s php="",retphp=""
	f  s php=$o(^DHCPHPERi("USR",userid,php)) q:php=""  d
	  .s phpl=$p(^DHCPHPER(php),"^",3)
	  .q:phpl'=phl
	  .s retphp=php
    i retphp="" q -1
    s reted=$o(^DHCPHRTIi(orditem,"ORDI",""))
    s OEFlag=$p($g(^OEORD(+orditem,"I",$p(orditem,"||",2),"DHC")),"^",16)
    q:(OEFlag="Y")&(reted'="") -7 //门诊配液退过一次药的不允许再
    TSTART
    
    &sql(insert into sqluser.dhc_phreturn(phret_date,phret_inv,phret_phl_dr,phret_phd_dr,phret_prt_dr,phret_php_dr,
	      phret_rfr_dr,phret_time,phret_newprt_dr,phret_type,phret_req_dr)  values(:currdate,:inv,:phl,:phd,:prtdr,:retphp,:rfr,:currtime,:newprt,:winpos,:reqrow))
	i SQLCODE'=0  TRo 
	i SQLCODE'=0 q -2
	s retrow=+$g(%ROWID)
	i reqrow'=""  d
	   .&sql(update dhc_phrequest set phreq_retflag='1' where phreq_rowid=:reqrow) 
	   .i SQLCODE'=0 s retmain="-1"
	i retmain="-1" TRo 
	i retmain="-1" q -3
	s retline=0,lt=0
	s retline=$l(RetInf,"&")
	S TmpListData=""
	for lt=1:1:retline q:(retmain'=0)  d
	  .s retitmstr="",phditm="",retqty="",retmoney=0,retunit="",retsub="",reqcode=""
	  .s retitmstr=$p(RetInf,"&",lt)
	  .s phditm=$p(retitmstr,"^",1)
	  .s retqty=$p(retitmstr,"^",2)
	  .s retmoney=$p(retitmstr,"^",3)
	  .s retunit=$p(retitmstr,"^",4)
	  .s retsub=$p(retitmstr,"^",5)
	  .s phdlbrowid=$p(retitmstr,"^",6)
	  .s retmain=..DoRetItm(retrow,phditm,retqty,retmoney,retunit,retsub,reqrow,phdlbrowid)
	  .I TmpListData="" S TmpListData=phditm
	  .E  S TmpListData=TmpListData_"^"_phditm
    i retmain'=0 TRo
    q:retmain=-1011 retmain	// 退药数大于发药数
    i retmain'=0 q -4
	TCOMMIT
	D ..InvokeStopExec(TmpListData,userid) //调用停止执行记录 2014-08-26 bianshuai
 q retrow
}

ClassMethod DoRetItm(retrow As %Library.String = "", phditm As %Library.String = "", retqty As %Library.String = "", retmoney As %Library.String = "", retunit As %Library.String = "", sub As %Library.String = "", reqrow As %Library.String = "", phdlbrowid = "")
{
	
	s currdate=$p($h,",",1)
	s currtime=$p($h,",",2)
	s phdId=$p(phdlbrowid,"||",1)
	s phdSubId=$p(phdlbrowid,"||",2)
	s phdLbId=$p(phdlbrowid,"||",3)
	s phl=+$p(^DHCPHRET(retrow),"^",7)
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s php=+$p(^DHCPHRET(retrow),"^",8)
	s user="",oeori=""
	s user=+$p(^DHCPHPER(php),"^",5)
	s oeori=$p(^DHCPHDI(phdId,"PHDI",phdSubId),"^",5)
	s invprt=##class(PHA.FACE.IN.Com).GetLastInvByOE(oeori)
	s ord="",ordi=""
	s ord=$p(oeori,"||",1)
	s ordi=$p(oeori,"||",2)
	s inclb=$p(^DHCPHDI(phdId,"PHDI",phdSubId,"INCLB",phdLbId),"^",3)
	s currdate=""
	s currdate=$p($h,",",1)
	s inci=+inclb
	q:inci=0 -1
	s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
 	s phcUomId=$p(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),2),"^",4)
 	q:phcUomId="" -2
	s basuom="",newqty=0,newunit=""
	s basuom=+$p(^INCI(inci,1),"^",10)
	;药房发药单位或者门诊发药单位转换为基本单位
	s outdispuomdr=+$p(^INCI(inci,1),"^",12)
	s dispuomdr=$p($g(^OEORD(ord,"I",ordi,"DHC")),"^",13)
	i (dispuomdr'="")&&(dispuomdr'=outdispuomdr)&&(dispuomdr'=basuom) d
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,basuom)
	e  d
	.i outdispuomdr'=0  d 
	..s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(outdispuomdr,basuom)
	.e  d
	..s confac=1
	.
	i retunit=basuom  d
	.s newqty=retqty
	.s newunit=retunit
	e  d
	.s newqty=retqty*confac
	.s newunit=basuom
	s dispQty=+$p(^DHCPHDI(phdId,"PHDI",phdSubId,"INCLB",phdLbId),"^",1)
	s retedQty=+$p(^DHCPHDI(phdId,"PHDI",phdSubId,"INCLB",phdLbId),"^",2)
	s newRetedQty=retedQty+newqty
	q:newRetedQty>dispQty -1011	// 退药数量不能大于发药数,返回负数不好
	s sp=+$p(^DHCPHDI(phdId,"PHDI",phdSubId,"INCLB",phdLbId),"^",7)
	s retmoney=newqty*sp
	s rp=+$p(^DHCPHDI(phdId,"PHDI",phdSubId,"INCLB",phdLbId),"^",5)
	s rpamt=newqty*rp
	s inclb=$p(^DHCPHDI(phdId,"PHDI",phdSubId,"INCLB",phdLbId),"^",3)
	//发药批次表价格可能是不同的进价，这样会导致发药进价与退药进价有差异
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locdr)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
	s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
	s StkTypeDesc=$P(CatGrpStr,"^",4)
	s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"   
	s retmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(retmoney,Perv,"FmtSA",1)
	s rpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(rpamt,Perv,"FmtRA",1)
	s dispprt=##class(PHA.FACE.IN.Com).GetLastInvByOE(oeori)
	s sub=$o(^DHCPHRTI(retrow,"RTI",""),-1)+1 //yunhaibao20161008,sub 的rowid修正为自增
	&sql(insert into sqluser.dhc_phretitm(phrti_phret_parref,phrti_amount,phrti_childsub,
	phrti_oeori_dr,phrti_retqty,phrti_unit_dr,PHRTI_PRICE,PHRTI_PHDI_DR,PHRTI_Rp,
	PHRTI_RpAmt,PHRTI_INCLB_DR,PHRTI_PHDIC_DR,PHRTI_INV)
	values(:retrow,:retmoney,:sub,:oeori,:newqty,:newunit,:sp,:phditm,:rp,
	:rpamt,:inclb,:phdlbrowid,:dispprt))
	i SQLCODE'=0 q -3
	;修改申请子表中的退药数量
	i reqrow'=""  d
	.s reqsub="" 
	.f  s reqsub=$o(^DHCPHREQ(reqrow,"I",reqsub))  q:reqsub=""   d
	..s reqphdirow=""
	..s reqphdirow=$P(^DHCPHREQ(reqrow,"I",reqsub),"^",10)
	..q:reqphdirow'=phdlbrowid
	..s $P(^DHCPHREQ(reqrow,"I",reqsub),"^",5)=newqty
	.
	;新医嘱改造退药打包主表也是存一条
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1) 
	s dspstatus=$p($g(^DHCOEDISQTY(dspId)),"^",7)
	s dspType=$p($g(^DHCOEDISQTY(dspId)),"^",13)
	s dspPoiner=$p($g(^DHCOEDISQTY(dspId)),"^",14)
	s retstr=""
	i (dspstatus="R")&&(dspType="H")&&(+dspPoiner'=0) d
	.i +retrow=+dspPoiner s retstr=0_"^"_dspId
	i retstr="" d
	.s rdspqty=$p(^DHCOEDISQTY(dspId),"^",5)
	.s rdspunit=$p(^DHCOEDISQTY(dspId),"^",6)
	.s retstr=##CLASS(web.DHCOutPhDisp).InsertDHCOEDisp(oeori,0,phcUomId, retrow_"||"_sub,"R","H",user)
	s retval=$p(retstr,"^",1)
	i retval'=0 q -4
	;插入打包子表记录！hulihua
	s retdsp=$p(retstr,"^",2)
	s DspbStr=retdsp_"^"_inclb_"^"_newqty_"^"_sp_"^"_rp_"^"_inci_"^R"
	s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
	s InsSQLCODE=$p(RetIns,"^",1)
	i InsSQLCODE'=0 q -5
	s retdspbatch=$p(RetIns,"^",2)
	s retitmid=retrow_"||"_sub
	&sql(UPDATE sqluser.dhc_phretitm SET PHRTI_DSPB_DR=:retdspbatch WHERE PHRTI_ROWID=:retitmid)
	i SQLCODE'=0 q -6
	s retval=##class(web.DHCOutPhModCZ).ModPhReturn(retrow,sub,user,phdlbrowid)
	i retval'=0 q -7
	;应计费组要求按照药学项基本单位回写打包主表数量(协定方只写付数)
	s err=0
 	s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14) 	;处方号
 	s CheckXDPresc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckCMXDPTCom(prescno)
 	i CheckXDPresc=3  d											;协定方
	.s rdspqty=+$p(^DHCOEDISQTY(dspId),"^",5)
	.s $p(^DHCOEDISQTY(retdsp),"^",2)=rdspqty
 	.s $p(^DHCOEDISQTY(retdsp),"^",5)=rdspqty
 	.s $p(^DHCOEDISQTY(retdsp),"^",11)=rdspqty
	e  d
 	.s uom=$p(^INCI(inci,1),"^",10)
 	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,phcUomId)
 	.s:fac="" err=-8
 	.q:fac="" 
 	.s rdspqty=newqty*fac
 	.s $p(^DHCOEDISQTY(retdsp),"^",2)=+$p($G(^DHCOEDISQTY(retdsp)),"^",2)+rdspqty
 	.s $p(^DHCOEDISQTY(retdsp),"^",5)=+$p($G(^DHCOEDISQTY(retdsp)),"^",5)+rdspqty
 	.s $p(^DHCOEDISQTY(retdsp),"^",11)=+$p($G(^DHCOEDISQTY(retdsp)),"^",11)+rdspqty
	q:err'=0 err
	q 0
}

ClassMethod CheckReturn(prt As %Library.String = "")
{
   q 0
}

ClassMethod UpdatPhdinclb(phdi As %Library.String = "", mqty As %Library.String = "")
{
	s mqty=$g(mqty)
	s phd=$p(phdi,"||",1)
	s phditm=$p(phdi,"||",1)
	s phdic=""
	k ^S
	f  s phdic=$o(^DHCPHDI(phd,"PHDI",phditm,"INCLB",phdic)) q:(phdic="")!(mqty=0)  d
	.s phinclb="",phqty=0,phretqty=0,^S=^DHCPHDI(phd,"PHDI",phditm,"INCLB",phdic)
	.s phqty=+$p(^S,"^",1),phretqty=+$p(^S,"^",2),phinclb=$p(^S,"^",3)
	.i (phqty-phretqty)'<mqty  d
	..s $p(^S,"^",2)=$p(^S,"^",2)+mqty
	..s mqty=0
	.e  d
	..s $p(^S,"^",2)=phqty
	..s mqty=mqty-phqty+phretqty
	q 0
}

ClassMethod GUserName(userid As %Library.String = "")
{
	s username=""
	i userid="" q username
	s username=$p(^SSU("SSUSR",userid),"^",2)
	q username
}

ClassMethod GSysDate()
{
 	q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"OP")
}

ClassMethod DeleteReturn(retrow As %Library.String = "")
{
	&Sql(delete from sqluser.dhc_phreturn where phret_rowid=:retrow)
	q SQLCODE
}

ClassMethod UpdatePhWin(itmjs As %Library.String = "", itmjsex As %Library.String = "", ctloc As %Library.String = "", pyusr As %Library.String = "", phw As %Library.String = "", fydr As %Library.String = "")
{
   s phl="",ret=""
   s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
   s locdesc=$p(^CTLOC(ctloc),"^",2)
   s pydr="",pyname=""
   s pydr=$o(^DHCPHPERi("USR",pyusr,""))
   i (phl="")!(pydr="") s ret="" 
   e  d 
     .s count=0
     .&sql(select count(phwp_rowid) into :count from sqluser.dhc_phwper
       where phwp_phl_dr=:phl and phwp_phw_dr=:phw)
     .i count=0 d
        ..&sql(insert into sqluser.dhc_phwper(phwp_phl_dr,phwp_doflag,phwp_phw_dr,phwp_php_pydr,phwp_php_fydr)
          values(:phl,'0',:phw,:pydr,:fydr))
     .s pyname=$p(^DHCPHPER(pydr),"^",2)
     .
     .s ret=locdesc_"^"_phl_"^"_phw_"^"_pyname_"^"_fydr
 s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod QueryPRTClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryPRTExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryPRTExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CDate As %Library.String = "", CPmiNo As %Library.String = "", CDateEnd As %String = "", EMFlag = "") As %Status
{
	 ;w ##class(%ResultSet).RunQuery("web.DHCOutPhReturn","QueryPRT","233","","0000009383")
  	  Set repid=$I(^CacheTemp)
	  s ind=1
	  i CPmiNo=""  Set QHandle=$lb(0,repid,0)	Quit $$$OK
	  d ClearTmp
	  s phl="",stdate="",enddate=""
	  s ctloc=$g(ctloc)
	  s HospId=$p($g(^CTLOC(+ctloc)),"^",22)
	  i ctloc'="" s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	  s basphl="",basloc="",othlocretflag="" ; 跨科室退药,yunhaibao20161017
	  i phl'="" d
	  .s othlocretflag=$p($G(^DHCPHLOC(phl)),"^",8)
	  .s basphl=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phl)
	  i basphl'="" s basloc=+$p(^DHCPHLOC(basphl),"^",1)
	  i CDate'="" s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDate)
	  e  s stdate=CDate
	  i CDateEnd'="" s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	  e  s enddate=CDateEnd
	  s pmi="",m=0,pername="",lzero=""
      s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
      i pmi="" Set QHandle=$lb(0,repid,0)	Quit $$$OK
      s pername=$p(^PAPER(pmi,"ALL"),"^",1)
    
      s phd="0"
      f  s phd=$o(^DHCPHDISPi("PAPMI",pmi,phd)) q:(phd="")!(phd="0")   d
      .s prt="",phdphl="",newprt=""
      .q:'$d(^DHCPHDISP(phd))
      .s prt=+$p(^DHCPHDISP(phd),"^",2)
      .q:(EMFlag=1)&&(prt'=0)  //非发票缴费
      .s phdphl=+$p(^DHCPHDISP(phd,1),"^",1)
      .s phdbasphl=""
      .s phdbasphl=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phdphl)
      .q:(phdbasphl'=basphl)&(basphl'="")&(othlocretflag'="Y")
      .s phlctlocdr=$p(^DHCPHLOC(phdphl),"^",1)
      .s ctlochospdr=+$p($g(^CTLOC(+phlctlocdr)),"^",22)
      .q:(+HospId'=0)&&(+HospId'=ctlochospdr) ; 按院区过滤
      .//q:'$d(^DHCINVPRT(prt))
      .s fyflag=$p(^DHCPHDISP(phd),"^",4)
      .q:fyflag'="1"
      .s newprt=$$GetNewPrt(prt)
      .i newprt=""  s newprt=prt
      .s prtdate="",phdl="",prescno=""
      .i +newprt'=0 s prtdate=+$p(^DHCINVPRT(newprt),"^",5)
      .q:(enddate="")&(prtdate'=stdate)&(stdate'="")&(prtdate'="")  //enddate等于空时按一个日期过滤,否则按时间段过滤
      .q:(enddate'="")&&(stdate'="")&&(prtdate'="")&&((prtdate<stdate)||(prtdate>enddate))
      .s phdsub="",ph=0
      .f  s phdsub=$o(^DHCPHDI(phd,"PHDI",phdsub)) q:(phdsub="")!(ph=1)  d
      ..s dispqty=0,retqty=0,cyqty=0
      ..s dispqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
      ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",6)
      ..s oeori=$p(^DHCPHDI(phd,"PHDI",phdsub),"^",5)
      ..q:##class(web.DHCOutPhCommon).PrtOPToIP(oeori)=1
      ..s cyqty=dispqty-retqty
      ..;q:retqty'=0
      ..q:cyqty<=0
      ..s ph=ph+1
      .q:ph=0
      .i prtdate'="" s prtdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtdate)
      .s prescno=$p(^DHCPHDISP(phd,2),"^",1)
      .s prtinv=""
      .i +newprt'=0 s prtinv=$p(^DHCINVPRT(newprt),"^",14)
      .i prtinv="" d
      ..i +newprt'=0 d
      ...s ACCPINVID=""
      ...s ACCPINVID=$p(^DHCINVPRT(newprt),"^",4)
      ...q:ACCPINVID=""
      ...s prtinv=$p($g(^DHCINVPRTAP(ACCPINVID)),"^",6)
      .s oldInvNo=""
      .i +prt'=0 s oldInvNo=$p(^DHCINVPRT(prt),"^",14)
      .i oldInvNo="" d
      ..i +prt'=0 d
      ...s ACCPINVID=""
      ...s ACCPINVID=$p(^DHCINVPRT(prt),"^",4)
      ...q:ACCPINVID=""
      ...s oldInvNo=$p($g(^DHCINVPRTAP(ACCPINVID)),"^",6)
      .///多次生成欠药单发药,过滤重复记录
      .s indexstr=pername_"^"_prtdate_"^"_prt_"^"_prescno_"^"_newprt
      .q:$D(^TMP("OutPhRetQueryPrt",$j,indexstr))
      .s ^TMP("OutPhRetQueryPrt",$j,indexstr)=""
      .i prtinv="" s prtinv=0
      .i oldInvNo=""  s oldInvNo=0
	  .set Data=$lb(prtinv,pername,prtdate,prt,prescno,newprt,oldInvNo)
 	  .Set ^CacheTemp(repid,ind)=Data	
 	  .Set ind=ind+1
      d ClearTmp
 	  Set QHandle=$lb(0,repid,0)
	  Quit $$$OK
GetNewPrt(prt)
	s nprt="0",gnprt=""
	s lprt="",lprt=prt
	f  s nprt=$o(^DHCINVPRT(0,"OldINV",lprt,nprt)) q:(nprt="")!(nprt="0")  d
	  .s lprt=nprt                                                                                                        
	  .s gnprt=nprt
    i (gnprt="")!(gnprt="0") s gnprt=prt
    quit gnprt
ClearTmp
    k ^TMP("OutPhRetQueryPrt",$j)
    q
}

ClassMethod QueryPRTFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPRTExecute ]
{
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryPRT(ctloc As %String, CDate As %String, CPmiNo As %String, CDateEnd As %String = "", EMFlag = "") As %Query(ROWSPEC = "新收据:%String,姓名:%String,日期:%String,ID:%String,处方:%String,新ID:%String,原收据:%String")
{
}

/// w ##class(web.DHCOutPhReturn).GetRetInf(100000004)
ClassMethod GetRetInf(reqrow)
{
     
	s curryear="",currdate=$zd(+$h,3)
	s ret=""
	s curryear=$p(currdate,"-",1)
	s flag=""
	s flag=$p(^DHCPHREQ(reqrow),"^",11)
	i flag="1" q ""
	s prescno=$p(^DHCPHREQ(reqrow),"^",8)
	s queid=+$o(^PAQUE1(0,"PrescNo",prescno,""))
 	s cyflag=$s($d(^PAQUE1(queid,"DHC")):"Y",1:"")
	s reqitm=""
	f  s reqitm=$o(^DHCPHREQ(reqrow,"I",reqitm)) q:reqitm=""  d
	.s reqitmrowid=reqrow_"||"_reqitm
	.s phdlbrowid=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",10)
	.s reqqty=+$p(^DHCPHREQ(reqrow,"I",reqitm),"^",4)
	.s phdrow=+phdlbrowid
	.s phdch=$p(phdlbrowid,"||",2)
	.s phdsub=$p(phdlbrowid,"||",3)
	.s phditm=phdrow_"||"_phdch
	.s chowflag=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",6)
	.q:chowflag=1
	.s dspbatchid=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",11)
	.s inclb=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",12)
	.s inci=+inclb 
	.s incbatdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.s batcode=$p( ^INCI($p(incbatdr,"||",1),"IB",$p(incbatdr,"||",2)),"^",1)
	.s stklocdr=$p(^INCI(inci,"IL",$p(inclb,"||",2)),"^",1)
	.s prt=+$p(^DHCPHDISP(phdrow),"^",2)
	.s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdch),"^",5)
	.q:##class(web.DHCOutPhCommon).PrtOPToIP(orditm)=1
	.i phdlbrowid'="" d
	..s reqprice=$p(^DHCPHDI(phdrow,"PHDI",phdch,"INCLB",phdsub),"^",7)
	.e  d
	..s billfalg=$p(^OEORD(ord,"I",itm,3),"^",5)
	..i billfalg'="P" d
	...s dspdate=##CLASS(web.DHCOutPhDisp).getDspDate(orditm)
	...i dspdate="" s dspdate=+$h
	...s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(stklocdr)
	...s hospdr=$p(HospString,"^",1)
	...s reqprice=##class(web.DHCSTPRICE).GetSp(+inci,+dspdate,"",hospdr,"")	//zhouyg 20150113
	..e  d
	...s reqprice=$p(##CLASS(web.DHCOutPhCommon).GetDspBatPrice(orditm,dspbatchid),"^",1)
	..
	.s basuom=+$p(^INCI(inci,1),"^",10)
	.;以下为基本单位
	.s qty=+$p(^DHCPHDI(phdrow,"PHDI",phdch,"INCLB",phdsub),"^",1)
	.s retqty=+##class(web.DHCOutPhCommon).GetRetedQtyByPhdLb(phdlbrowid)
	.s retqty=$p(retqty,$c(1),1)
	.s qty=qty-retqty
	.s ord=$p(orditm,"||",1)
	.s itm=$p(orditm,"||",2) 
	.;转换为门诊发药单位或药房发药单位 hulihua
	.s outdispuomdr=+$p(^INCI(inci,1),"^",12)
	.s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13) 
	.i (dispuomdr'="")&&(dispuomdr'=outdispuomdr)&&(dispuomdr'=basuom)  d	//药房发药单位
	..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,basuom)
	..s phuomid=dispuomdr
	.e  d
	..i outdispuomdr'=0  d												//门诊发药单位
	...s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(outdispuomdr,basuom)
	...s phuomid=outdispuomdr
	..e  d																	//基本单位
	...s Fac=1
	...s phuomid=basuom
	..
	.s qty=qty/Fac
	.s disreqqty=reqqty/Fac
	.s disprice=reqprice*Fac
	.s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	.;计算价格
	.s dispqty=qty
	.s dispmoney=dispqty*disprice
	.s reqmoney=disreqqty*disprice
	.i basuom=dispuomdr s fmtFlag=2
	.e  s fmtFlag=1
	.;格式化参数
	.s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(stklocdr)
	.s HospID=$p(CustStr,"^",5)
	.s CustID=$p(CustStr,"^",1)
	.s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
	.s StkTypeDesc=$P(CatGrpStr,"^",4)
    .s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	.s disprice=##Class(web.DHCSTCOMMPARA).GetNumbDec(disprice,Perv,"FmtSP",fmtFlag) 
	.s reqmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(reqmoney,Perv,"FmtSA",1)
	.s dispmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(dispmoney,Perv,"FmtSA",1)
	.s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s phgg=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	.s refuseFlag=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",8)
	.s refusereason=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",9)
	.i refusereason'="" s refusereason=$p($g(^PHRREFUSE(refusereason)),"^",2)
	.s itmAddId=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	.i itmAddId'="" d
	..s cantRetReasonId=$p(^DHCITMINFO(itmAddId),"^",46)
	..s cantRetReason=$p($g(^DHCRFRETREASON(+cantRetReasonId)),"^",2)
	.e  s cantRetReason=""
	.s retinfo=incidesc_"^"_phuomdesc_"^"_disprice_"^"_dispqty_"^"_dispmoney_"^"_disreqqty_"^"_reqmoney_"^"_phditm_"^"_phuomid_"^"_phgg_"^"_seqno_"^"_batcode_"^"_reqitmrowid_"^"_refusereason_"^"_phdlbrowid_"^"_dspbatchid_"^"_cantRetReason_"^"_cyflag_"^"_refuseFlag
	.i ret="" s ret=retinfo
	.e  s ret=ret_$c(1)_retinfo
	
	s reqitm=""
	f  s reqitm=$o(^DHCPHREQ(reqrow,"I",reqitm)) q:reqitm=""  d
	.s reqitmrowid=reqrow_"||"_reqitm
	.s phditm="",phdrow="",phdsub="",reqqty=0,reqprice=0,reqmoney=0,price=0
	.s phditm=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",1)
	.s reqqty=+$p(^DHCPHREQ(reqrow,"I",reqitm),"^",4)
	.s chowflag=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",6)
	.s retbatno=$g(^DHCPHREQ(reqrow,"I",reqitm,"retbatno"))
	.q:chowflag'="1"   
	.//欠药记录
	.s batcode=""
	.s phow=$p(phditm,"||",1)
	.s phowsub=$p(phditm,"||",2)
	.q:$p(^DHCPHOW(phow,"I",phowsub),"^",4)'="1"
	.s orditm="",ord="",itm="",prt=""
	.s orditm=$p(^DHCPHOW(phow,"I",phowsub),"^",1)
	.q:##class(web.DHCOutPhCommon).PrtOPToIP(orditm)=1
	.s prt=+$p(^DHCPHOW(phow),"^",7)
	.s stklocdr=$p(^DHCPHOW(phow),"^",2)
	.s ord=$p(orditm,"||",1)
	.s itm=$p(orditm,"||",2)
	.s reqprice=##CLASS(web.DHCOutPhDisp).GetBasPrice(prt,orditm)
	.s ord=$p(orditm,"||",1)
	.s itm=$p(orditm,"||",2)
	.s itmmast="",itmmastver="",itmmastid=""
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	.s phuomid="",phuomdesc=""
	.s itmmastid=$p(itmmast,"||",1)
	.s itmmastver=$p(itmmast,"||",2)
	.s phuomid="",phuomdesc="",phdesc="",basuom=""
	.s phuomid=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.s inci="",incode=""
	.s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	.q:inci=""
	.s inci=$p(inci,$c(1),1)
	.s basuom=+$p(^INCI(inci,1),"^",10)
	.s qty=0,retqty=0,phgg=""
	.s phgg=##class(web.DHCSTKUTIL).GetSpec(inci)  
	.s seqno=""
	.s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
	.s qty=$p(^DHCPHOW(phow,"I",phowsub),"^",2)
	.s curconfact=1,dispqty=0,dispmoney=0
	.s curconfact=##class(web.DHCST.Common.UtilCommon).UOMFac(phuomid,basuom)
	.s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	.i dispuomdr'="" d
	..s curconfact=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,basuom)
	..s phuomid=dispuomdr
	.
	.s price=reqprice ////基本单位价格 *curconfact
	.s reqmoney=reqqty*price
	.s dispqty=qty/curconfact
	.s disreqqty=reqqty/curconfact
	.s dispmoney=qty*price
	.s disprice=price*curconfact
	.s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(stklocdr)
	.s HospID=$p(CustStr,"^",5)
	.s CustID=$p(CustStr,"^",1)
	.s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
	.s StkTypeDesc=$P(CatGrpStr,"^",4)
	.s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	.s reqmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(reqmoney,Perv,"FmtSA",1)
	.s dispmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(dispmoney,Perv,"FmtSA",1)
	.s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	.s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	.s refusereason=$p(^DHCPHREQ(reqrow,"I",reqitm),"^",9)
	.i refusereason'="" s refusereason=$p($g(^PHRREFUSE(refusereason)),"^",2)
	.s retinfo=phdesc_"^"_phuomdesc_"^"_disprice_"^"_dispqty_"^"_dispmoney_"^"_disreqqty_"^"_reqmoney_"^"_phditm_"^"_phuomid_"^"_phgg_"^"_seqno_"^"_"欠药"_"^"_reqitmrowid_"^"_refusereason
	.i ret="" s ret=retinfo
	.e  s ret=ret_$c(1)_retinfo

	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhReturn","QueryRetPh","316","","O181108000006","")
Query QueryRetPh(ctloc As %String, CPrt As %String, CPrescNo As %String, CurrReqNo As %String) As websys.Query(ROWSPEC = "TPhdesc:%String,TPhUom:%String,TPrice:%String,TDispQty:%String,TDispMoney:%String,TRetQty:%String,TRetMoney:%String,TPhdItm:%String,TPhUomid:%String,TPhgg:%String,TSeqNo:%String,TIncDispBatCode:%String,TCPrt:%String,TIncRetBatCode:%String,TPhdLbRowId:%String,TDodisBatch:%String,TCantRetReason:%String,TCyFlag:%String")
{
}

ClassMethod QueryRetPhExecute(ByRef QHandle As %Binary, ctloc As %Library.String, CPrt As %Library.String = "", CPrescNo As %Library.String = "", CurrReqNo As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set QHandle=$lb(0,repid,0)
	Set ind=1
	i CPrescNo="" Set QHandle=$lb(0,repid,0) Quit $$$OK
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(ctloc)
	s CustID=$p(CustStr,"^",1)
	i ctloc'="" d
	.s phlloc=$o(^DHCPHLOCi("LOC",ctloc,""))
	.s othlocretflag=$p($g(^DHCPHLOC(+phlloc)),"^",8) ; 跨科室退药
	e  s othlocretflag=""
	s phl=""
	s pmi="",m=0,pername="",lzero=""
	s phd="",prt=""
	s prt=CPrt   
	s phdi="",fyflag=""
	s phd="",exit="",retphd=""
	f  s phd=$o(^DHCPHDISPi("PRESCNO",CPrescNo,phd)) q:(phd="")||(exit'="")  d
	.s phl=$p(^DHCPHDISP(phd,1),"^",1)
	.s tmplocdr=$p(^DHCPHLOC(phl),"^",1)
	.q:(tmplocdr'=ctloc)&(othlocretflag'="Y") 
	.s prescno=$p(^DHCPHDISP(phd,2),"^",1)
	.q:prescno'=CPrescNo
	.s fyflag=$p(^DHCPHDISP(phd),"^",4)
	.q:fyflag'=1
	.s queid=+$o(^PAQUE1(0,"PrescNo",prescno,""))
 	.s cyflag=$s($d(^PAQUE1(queid,"DHC")):"Y",1:"")
	.s phdi=""
	.f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
	..s oeori=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
	..q:##class(web.DHCOutPhCommon).PrtOPToIP(oeori)=1
	..s locstr=##class(web.DHCOutPhCommon).GetOrdDocLoc(oeori)
	..s ctlocdesc=$p(locstr,"^",2)
	..s ord=+oeori
	..s itm=$p(oeori,"||",2)
	..s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
	..s billfalg=$p(^OEORD(ord,"I",itm,3),"^",5)
	..s phalocdr=$p(^OEORD(ord,"I",itm,3),"^",6) 
	..s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(phalocdr)
	..s hospdr=$p(HospString,"^",1)
	..s phdirow=""
	..s phdirow=phd_"||"_phdi
	..s inclb="",phdclb=0,batcode=""
	..f  s phdclb=$o(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb)) q:(phdclb="")  d
	...s phdLbRowId=phd_"||"_phdi_"||"_phdclb
	...s inclb=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",3)
	...s inci=+inclb
	...s qty=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",1)
	...s retqty=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",2)
	...s qty=qty-retqty
	...q:qty'>0
	...s dodisBatch=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",9)
	...//退药直接取发药金额,yunhaibao,20181102
	...//i billfalg'="P" d
	...//.s price=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",7)
	...//e  d
	...//.s ordpriceinfo=##class(web.DHCOutPhCommon).GetDspBatPrice(oeori,dodisBatch) 
	...//.s price=$p(ordpriceinfo,"^",1) 
	...s price=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",7)
    ...s getSpInc=$s(inclb'="":inclb,1:inci)
    ...s:price=0 price=##class(web.DHCSTPRICE).GetSp(getSpInc,+$h,"",hospdr,"","")	//没发票的需要按最新进价
	...s incbatdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	...s batcode=$p(^INCI($p(incbatdr,"||",1),"IB",$p(incbatdr,"||",2)),"^",1)
	...;转换为门诊发药单位或药房发药单位 hulihua  
	...s basuom=+$p(^INCI(inci,1),"^",10)
	...s outdispuomdr=+$p(^INCI(inci,1),"^",12)
	...s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	...i (dispuomdr'="")&&(dispuomdr'=outdispuomdr)&&(dispuomdr'=basuom) d 	//药房发药单位
	....s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,basuom)
	....s newunit=dispuomdr
	...e  d
	....i outdispuomdr'=0 d												//门诊发药单位
	.....s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(outdispuomdr,basuom) 												
	.....s newunit=outdispuomdr
	....e  d
	.....s Fac=1											  				//基本单位
	.....s newunit=basuom
	....
	...;
	...s newunitdesc=$p($g(^CT("UOM",newunit)),"^",2) 
	...s newqty=qty/Fac
	...i (newqty<1)&&($p(newqty,".",1)="") s newqty=0_newqty
	...s newprice=price*Fac
	...//格式化售价
	...S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inci)
	...S StkTypeDesc=$P(CatGrpStr,"^",4)
	...S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	...i basuom=newunit s fmtFlag=2
	...e  s fmtFlag=1
	...s newprice=##Class(web.DHCSTCOMMPARA).GetNumbDec(newprice,Perv,"FmtSP",fmtFlag)
	...s dispmoney=newprice*newqty
	...s dispmoney=##Class(web.DHCSTCOMMPARA).GetNumbDec(dispmoney,Perv,"FmtSA",1)
	...s incidesc=$p(^INCI(inci,1),"^",2)
	...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	...s itmAddId=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	...i itmAddId'="" d
	....s cantRetReasonId=$p(^DHCITMINFO(itmAddId),"^",46)
	....s cantRetReason=$p($g(^DHCRFRETREASON(+cantRetReasonId)),"^",2)
	...e  s cantRetReason=""
	...s newretqty=$s(cyflag="Y":newqty,1:"") 
	...i (newretqty<1)&&($p(newretqty,".",1)="") s newretqty=0_newretqty 
	...s retmoney=$s(cyflag="Y":dispmoney,1:"")
	...s Data=$lb(incidesc,newunitdesc,newprice,newqty,dispmoney,newretqty,retmoney,phdirow,newunit,Spec,seqno,batcode,CPrt,batcode,phdLbRowId,dodisBatch,cantRetReason,cyflag)
	...S ^CacheTemp(repid,ind)=Data	
	...S ind=ind+1
	..
	.
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

Query QueryReturnPh() As websys.Query(ROWSPEC = "TPhdesc:%String,TPhUom:%String,TPrice:%String,TDispQty:%String,TDispMoney:%String,TRetQty:%String,TRetMoney:%String,TPhdItm:%String,TPhUomid:%String")
{
}

ClassMethod QueryReturnPhExecute(ByRef QHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	s phdesc="",phuomdesc="",getqty="",retqty="",phdirow="",newunitdesc="",newprice="",newunit=""
	s Data=$lb(phdesc,newunitdesc,newprice,getqty,dispmoney,"","",phdirow,newunit)
	S ^CacheTemp(repid,ind)=Data	
	S ind=ind+1
	s phdesc="",phuomdesc="",qty=0,retqty=0,phdirow=""

	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

Query QueryRetReas() As websys.Query(ROWSPEC = "CRetReason:%String,CRetReasonid:%String")
{
}

ClassMethod QueryRetReasExecute(ByRef QHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	s irr=""
	f  s irr=$o(^DHCINVOPREFR(irr)) q:irr=""  d
	.q:irr=0
	.s irrdesc=$p(^DHCINVOPREFR(irr),"^",2)  ///描述
	.set Data=$lb(irrdesc,irr)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1

	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GPatName(itmjs As %Library.String = "", itmjsex As %Library.String = "", pmino As %Library.String = "")
{
   q:pmino="" ""
   s pmi=""	,pername="",ret="",perage="",age=""
   Set Config=##Class(websys.Configuration).%OpenId(1)
   Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
   Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
   Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
   ZN MEDDATA                                  ;切换到所希望的NameSpace,
   s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pmino),""))
   zn CurrentNS
   i pmi="" s ret=""
   s sysdate=$p($h,",",1)
   i pmi'=""  d
   .s pername=$p(^PAPER(pmi,"ALL"),"^",1)
   .s perage=$p(^PAPER(pmi,"ALL"),"^",6)
   .s cydate=sysdate-perage
   .i cydate<365 s age=cydate_"天"
   .else  s age=cydate/365,age=$p(age,".",1),age=age_"岁"
   .s ret=pername_"^"_age
   s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
   &javascript<#(retval)#>
  q ret
}

ClassMethod GetLocDescFrID(ctloc)
{
 s desc=""
 s desc=$p(^CTLOC(ctloc),"^",2)
 i desc["-" s desc=$p(desc,"-",2)
 q desc
}

ClassMethod QueryDepClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryDepExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryDepExecute(ByRef QHandle As %Binary, input As %Library.String = "") As %Status
{
  
	Set repid=$I(^CacheTemp)
	s ind=1
	;i input="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s input=$g(input)
	s input=$ZCVT(input,"U") 
	s ctloc=0
	f  s ctloc=$o(^CTLOC(ctloc)) q:ctloc=""  d
	  .s ctlocdesc="",loctype=""
	  .s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
	  .s ctlocdesc=$ZCVT(ctlocdesc,"U")
	  .q:ctlocdesc'[input
	  .set Data=$lb(ctlocdesc,ctloc)
	  .Set ^CacheTemp(repid,ind)=Data
	  .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryDepFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDepExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryDep(input As %String) As %Query(ROWSPEC = "科室:%String,ID:%String")
{
}

ClassMethod QueryDoctorClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryDoctorExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryDoctorExecute(ByRef QHandle As %Binary, CDoctorName As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;i CDepCode="" S QHandle=$lb(0,repid,0)	Quit $$$OK 
	s ctcarvp=0
	f  s ctcarvp=$o(^CTPCP(ctcarvp)) q:(ctcarvp="")!(ctcarvp="0")  d
	  .s ctcardesc="",loctype="",ctloc=""
	  .;s ctloc=+$p(^CTPCP(ctcarvp,3),"^",3)
	  .;q:ctloc'=CDepCode
	  .s ctcardesc=$p(^CTPCP(ctcarvp,1),"^",2)
	  .q:(ctcardesc'[CDoctorName)&(CDoctorName'="")
	  .set Data=$lb(ctcardesc,ctcarvp)
	  .Set ^CacheTemp(repid,ind)=Data
	  .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryDoctorFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDoctorExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryDoctor(CDoctorName As %String) As %Query(ROWSPEC = "医生:%String,ID:%String")
{
}

ClassMethod RetMoney(ctloc As %String = "", userid As %String, groupid As %String, newprt As %String, retrow As %String, card As %String)
{
	s ret=""
	s card=""
	i card=""  q 100
	s Flag="",PrtFlag="",InvNo="",PayMode="",InvMoney=0,retmoney=0,retorditm=""
	s Flag=$p(^DHCINVPRT(newprt),"^",8)
    s PrtFlag=$p(^DHCINVPRT(newprt),"^",3)
    s InvNo=$p(^DHCINVPRT(newprt),"^",14)
    s InvMoney=+$p(^DHCINVPRT(newprt),"^",16)
    s MoneyFlag="",ChYMoney=0
    s retsub=""
    f  s retsub=$o(^DHCPHRTI(retrow,"RTI",retsub)) q:retsub=""  d
      .s submoney=0,orditm=""
      .s submoney=+$p(^DHCPHRTI(retrow,"RTI",retsub),"^",1)
      .s orditm=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",2)
      .s retmoney=retmoney+submoney
      .i retorditm=""  s retorditm=orditm
      .e  s retorditm=retorditm_"^"_orditm
    i InvMoney-retmoney<0.02  s MoneyFlag="0"
    e  s MoneyFlag="1"
    s ChYMoney=InvMoney-retmoney
    i ChYMoney<0.02 s ChYMoney=0
    s retcode=""
    if ((InvNo="") & (Flag="N") & (PrtFlag'="P"))  d
      .s PayMode=$p(^DHCINVPRT(newprt,"P",1),"^")
      .s retcode=##class(web.udhcOPRefEditIF).RefundReceipt(newprt,userid,"S",retorditm,ChYMoney,groupid,MoneyFlag,ctloc,PayMode)
      .i retcode=""  s ret=300
      .e  d
        ..s ret=$p(retcode,"^",1)
        ..i ret="" s ret=300
    e  q 200
	
    q ret
}

ClassMethod CheckIncBat(phditm, batcode)
{
	  
	  q:phditm="" ""
	  s phd=$p(phditm,"||",1)
	  s phloc=+$p(^DHCPHDISP(phd,1),"^",1)
	  s loc=+$p(^DHCPHLOC(phloc),"^",1)
	  s phdsub=$p(phditm,"||",2)
	  s sysdate=+$h
	  s orditm=$p(^DHCPHDI(phd,"PHDI",phdsub),"^",5)
	  s ord="",itm=""
	  s ord=$p(orditm,"||",1)
	  s itm=$p(orditm,"||",2)
	  s itmmast="",inc=""
	  s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)   
	  s inc=$o(^INCI(0,"ARCIM_DR",+itmmast,""))
	  s incloc=$o(^INCI("IL_LOC",loc,inc,""))   
	  s incbat="0",retValue=0
	  f  s incbat=$o(^INCI(inc,"IB",incbat)) q:(incbat="")!(incbat="0")  d
	  .s itmbat=""
	  .s itmbat=$p(^INCI(inc,"IB",incbat),"^",1)
	  .q:itmbat'=batcode
	  .s itmcib=""
	  .s itmcib=inc_"||"_incbat
	  .s clb="",inclb=""
	  .f  s clb=$o(^INCI("LB_IB",itmcib,inc,incloc,clb)) q:clb=""  d
	  ..s inclb=inc_"||"_incloc_"||"_clb
	  .s ingdrec=""
	  .s cibrow=""
	  .s cibrow=..GetValue(inclb)
	  .q:cibrow=""
	  .;s ingdrec=$o(^INGRI("GRI_INCIB",cibrow,""))
	  .q:'$d(^DHCINGR(0,"GRI_INCIB",cibrow)) 
	  .s ingdrec=$o(^DHCINGR(0,"GRI_INCIB",cibrow,"")) 
	  .s ingrdate=""
	  .;s ingrdate=+$p(^INGR(ingdrec),"^",4)
	  .s ingrdate=+$p(^DHCINGR(ingdrec),"^",4)
	  .;q:(sysdate-ingrdate)>365
	  .s ingdri=""
	  .;f  s ingri=$o(^INGRI("GRI_INCIB",cibrow,ingdrec,ingdri)) q:(ingdri="")!(ret'=0)  d 
	  .f  s ingdri=$o(^DHCINGR(0,"GRI_INCIB",cibrow,ingdrec,ingdri)) q:(ingdri="")!(retValue'=0)  d 
	  ..s xqdate=""
	  ..;s xqdate=+$p(^INGR(ingdrec,"GRI",ingri),"^",9)
	  ..s xqdate=+$p(^DHCINGR(ingdrec,"GRI",ingdri),"^",9)
	  ..s xqdate=sysdate+3
	  ..i xqdate<sysdate  d
	  ...s retValue=3 ;效期已过
	  ..;e  i (xpdate-sysdate)<183  d
	  ..;.s ret=2 ;效期快到了
	  ..e  s retValue=$zd(xqdate,3) ;正常退药
	  //b
	  q retValue
}

ClassMethod GetRetReas(reqrow)
{
	s reasid="",reasdesc=""
	s reasid=+$p(^DHCPHREQ(reqrow),"^",13)
	//i reasid'=0 s reasdesc=$p(^BLC("RFR",reasid),"^",2)
	i reasid'=0 s reasdesc=$p(^DHCINVOPREFR(reasid),"^",2) ///取退费原因表 bianshuai 2015-12-17
	s ret=reasid_"^"_reasdesc
	q ret
}

ClassMethod GetValue(inclb)
{
   s ret=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
        Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
        Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
        Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
        ZN MEDDATA                                  ;切换到所希望的NameSpace,
      s ret=$$CIBrow^at299(inclb)     
         ZN CurrentNS 
      q ret
}

/// w ##class(web.DHCOutPhReturn).GetReqNo(309,"0000000282")
ClassMethod GetReqNo(loc, pmino)
{
	q:pmino="" ""
  	s pmidr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pmino),""))
  	i pmidr="" q ""
  	s sysdate=+$h
  	s reqdate=""
  	s phl=$o(^DHCPHLOCi("LOC",loc,""))
  	s lochospid=$p($g(^CTLOC(+loc)),"^",22)
  	s basphloc=""
  	s basphloc=##class(web.DHCOutPhAdd).GetBasLoc(phl)
  	s othlocretflag=$p(^DHCPHLOC(phl),"^",8) //
  	s ret=""
  	f reqdate=sysdate-30:1:sysdate  d
  	  .s reqrow=""
  	  .f  s reqrow=$o(^DHCPHREQi("PAPMI",pmidr,reqdate,reqrow)) q:reqrow=""  d
  	  ..s reqcode="",curr=1
  	  ..s zfflag=$p(^DHCPHREQ(reqrow),"^",1)
  	  ..q:zfflag="1"
  	  ..s reqcode=$p(^DHCPHREQ(reqrow),"^",2)
  	  ..s retflag=$p(^DHCPHREQ(reqrow),"^",11)
	  ..q:retflag="1"
  	  ..s retloc=$p(^DHCPHREQ(reqrow),"^",3)
  	  ..s retlochospid=$p($g(^CTLOC(+retloc)),"^",22)
  	  ..q:lochospid'=retlochospid
  	  ..q:(retloc'=loc)&(retloc'="")&(othlocretflag'="Y") //跨科室退药
  	  ..i reqdate=sysdate  s curr=1
  	  ..s invno=""
  	  ..//s newprt=+$p(^DHCPHREQ(reqrow),"^",5)
  	  ..//取医嘱最新的发票ID
  	  ..s lastReqCh=$o(^DHCPHREQ(reqrow,"I",""),-1)
  	  ..s dspBatId=$p(^DHCPHREQ(reqrow,"I",lastReqCh),"^",11)
  	  ..s oeori=$p(^DHCOEDISQTY(+dspBatId),"^",1)
  	  ..s newprt=##class(PHA.FACE.IN.Com).GetLastInvByOE(oeori)
  	  ..i newprt'="" d
  	  ...s prtflag=$p($g(^DHCINVPRT(newprt)),"^",8)
  	  ..e  s prtflag=""
  	  ..q:(prtflag="A")!(prtflag="S")	//zhouyg 2016-07-13 发票作废的
  	  ..i newprt'="" s invno=$p(^DHCINVPRT(newprt),"^",14)
  	  ..e  s invno=""
  	  ..s prescno=$p(^DHCPHREQ(reqrow),"^",8)
  	  ..s data=reqcode_"^"_reqrow_"^"_curr_"^"_invno_"^"_prescno
  	  ..i ret="" s ret=data
  	  ..e  s ret=ret_"&"_data
  	 q ret
}

ClassMethod QueryRequestClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryRequestExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 急诊留观退药申请,仅押金模式,其他模式走退费申请
/// w ##class(%ResultSet).RunQuery("web.DHCOutPhReturn","QueryRequest","","E181203000017")
ClassMethod QueryRequestExecute(ByRef QHandle As %Binary, CPrtInv = "", CPresc) As %Status
{
	Set repid=$I(^CacheTemp)
	Set QHandle=$lb(0,repid,0)
	s ind=1
	q:CPresc="" $$$OK
	s ordId=$o(^OEORD(0,"PrescNo",CPresc,""))
	q:ordId="" $$$OK
	s itmId=$o(^OEORD(0,"PrescNo",CPresc,ordId))
	q:itmId="" $$$OK
	s recLocId=$p($g(^OEORD(ordId,"I",itmId,3)),"^",6)
	s hospId=$P($g(^CTLOC(+recLocId)),"^",22)

	s payMode=##class(PHA.FACE.IN.Com).IStayPayModeByEpisodeID(hospId)	
	q:payMode=0 $$$OK
	s phdrow=""
	f  s phdrow=$o(^DHCPHDISPi("PRESCNO",CPresc,phdrow)) q:phdrow=""  d
	.d getdata
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK  
getdata   
	// 过滤-未发药
	s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	q:fyflag'="1"
	s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)
	s queid=+$o(^PAQUE1(0,"PrescNo",prescno,""))
 	s cyFlag=$s($d(^PAQUE1(queid,"DHC")):"Y",1:"")
	s phdsub=0
	f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:phdsub=""  d
	.s phditm=phdrow_"||"_phdsub
	.s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	.s ord=$p(orditm,"||",1)
	.s itm=$p(orditm,"||",2)
	.q:(payMode=1)&&($p($g(^OEORD(ord,"I",itm,"DHC")),"^",17)'="1")
	.s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(orditm),"^",1)
	.q:(oeoriStatCode="V")||(oeoriStatCode="E")
	.s phalocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	.s RecLoc=phalocdr
	.s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(RecLoc)
	.s hospdr=$p(HospString,"^",1)
	.s RecLocDesc=$p(^CTLOC(phalocdr),"^",2)
	.s phditmlb=0
	.f  s phditmlb=$o(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phditmlb)) q:phditmlb=""  d
	..s phditmlbdata=^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phditmlb)
	..s phditmlbid=phdrow_"||"_phdsub_"||"_phditmlb
	..s dispqty=+$p(phditmlbdata,"^",1) 
	..s retqty=+$p(phditmlbdata,"^",2) 
	..s inclb=$p(phditmlbdata,"^",3) 
	..s inci=+inclb
	..// 过滤-已退大于发药
	..q:retqty>=dispqty
	..s phdqty=dispqty-retqty
	..// 退药申请记录
	..s reqqty=0
	..s phreq=0
	..f  s phreq=$o(^DHCPHREQi("PHDSUB",phditmlbid,phreq)) q:phreq=""  d
	...s reqData=^DHCPHREQ(phreq)
	...s reqCancel=$p(reqData,"^",1)
	...q:reqCancel=1	// 什么标志?
	...s retFlag=$p(reqData,"^",11)
	...// 过滤-已退
	...q:(retFlag'=0)&&(retFlag'="")
	...s phreqsub=0
	...f  s phreqsub=$o(^DHCPHREQi("PHDSUB",phditmlbid,phreq,phreqsub)) q:phreqsub=""  d
	....s lreqqty=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",4)
	....s reqqty=reqqty+lreqqty
	..s baseprice=$p(phditmlbdata,"^",7)
	..s inclb=$p(phditmlbdata,"^",3) 
    ..s inci=+inclb
    ..s getSpInc=$s(inclb'="":inclb,1:inci)
    ..s:baseprice=0 baseprice=##class(web.DHCSTPRICE).GetSp(getSpInc,+$h,"",hospdr,"","")	//没发票的需要按最新进价
	..s phdqty=phdqty-reqqty
	..q:phdqty<=0
	..s dispUomId=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	..i dispUomId="" d
	...s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(inci,phdqty)
	..e  d
	...s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(inci,phdqty,dispUomId)
	..s confac=$p(fmtQtyUomStr,"^",3)
	..s phuomid=$p(fmtQtyUomStr,"^",2)
	..s scrqty=$p(fmtQtyUomStr,"^",1)
	..s scrprice=baseprice*confac
	..s phuomdesc=$p(^CT("UOM",phuomid),"^",2)
	..s invNo="",prtinv=""
	..s scrprice=$fn(scrprice,"",4)
	..s invNo=""
	..s phdesc=$p(^INCI(inci,1),"^",2)
	..s itmAddId=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	..i itmAddId'="" d
	...s cantRetReasonId=$p(^DHCITMINFO(itmAddId),"^",46)
	...s cantRetReason=$p($g(^DHCRFRETREASON(+cantRetReasonId)),"^",2)
	..e  s cantRetReason=""
	..set Data=$lb(RecLocDesc,RecLoc,phdrow,prescno,invNo,allprt,prt,phditmlbid,phdesc,scrqty,scrprice,"","",phuomdesc,cantRetReason,cyFlag)
	..Set ^CacheTemp(repid,ind)=Data
	..Set ind=ind+1
	q
}

ClassMethod QueryRequestFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRequestExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryRequest(CPrtInv As %String, CPresc) As %Query(ROWSPEC = "TPhLocDesc:%String,TPhLoc:%String,TPhdRowid:%String,TPrescNo:%String,TPrtInv:%String,TPrt:%String,TNewPrt:%String,TPhdSub:%String,TPhDesc:%String,TPhQty:%String,TPhPrice:%String,TReqQty:%String,TReqMoney:%String,TPhUomDesc:%String,TCantRetReason:%String,TCyFlag:%String")
{
}

ClassMethod GetFYPrt(newprt)
{
	s retprt="0",jprt=1,dp=0
	while(jprt'=0)
	{
	  s dspflag=""
	  
	  s dspflag=##class(web.DHCOutPhReturn).CheckDisp(newprt)
	 
	  i dspflag'=0  d
	    .s ^DHCTMPPRTDSP($j,newprt)=newprt
	    .s dp=dp+1
	  s jprt=+$p(^DHCINVPRT(newprt),"^",29)
	  i jprt'=0 s newprt=jprt,retprt=jprt	
	}
	;i retprt="0" s retprt=newprt
    ;retprt
  q dp
}

ClassMethod CheckInsRequest(recloc, phd, nprt, prescno, phditm, qty, reason, userid, over)
{
  s phdrow="",dispitm="",dispqty=0,retqty=0,resqty=0,orditm="",ord="",itm=""
  s phdrow=$p(phditm,"||",1)
  s dispitm=$p(phditm,"||",2)
  s dispqty=+$p(^DHCPHDI(phdrow,"PHDI",dispitm),"^",4)
  s retqty=+$p(^DHCPHDI(phdrow,"PHDI",dispitm),"^",6)
  s orditm=$p(^DHCPHDI(phdrow,"PHDI",dispitm),"^",5)
  s ord=$p(orditm,"||",1)
  s itm=$p(orditm,"||",2)
  s itmmast="",itmmastid="",itmmastver=""
  s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
  s itmmastid=$p(itmmast,"||",1)
  s itmmastver=$p(itmmast,"||",2)
  s inci=""
  s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
  s phdesc=""
  s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
  s baseprice=0,phuomid="",basuom="",phuomdesc=""
  s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
  s basuom=+$p(^INCI(inci,1),"^",10)
  s confac="",yreqqty=0
  s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(phuomid,basuom)
  s resqty=dispqty-retqty
  s hreqqty=0
  s reqrow=""
  f  s reqrow=$o(^DHCPHREQi("DISP",phd,reqrow)) q:reqrow=""  d
  .s reqsub=""
  .f  s reqsub=$o(^DHCPHREQ(reqrow,"I",reqsub)) q:reqsub=""  d
  ..s qtyreq=0,reqphditm=""
  ..s reqphditm=$p(^DHCPHREQ(reqrow,"I",reqsub),"^",1)
  ..q:reqphditm'=phditm
  ..s retflag=$p(^DHCPHREQ(reqrow),"^",11)
  ..q:retflag="1"
  ..s qtyreq=+$p(^DHCPHREQ(reqrow,"I",reqsub),"^",4)
  ..s hreqqty=hreqqty+qtyreq
  
  //i (qty+hreqqty)*confac>resqty q -1
  ;add by xiaohe
  s ret=0    
  s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
  i dispuomdr'="" d
  .s dispconfac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,basuom)
  .s qty=qty*dispconfac
  
  i (qty+hreqqty)>resqty q -1

  
  q 0
}

/// input: AppType(不为空则数量对应发药单位,否则为基本单位)
/// w ##class(web.DHCOutPhReturn).InsertPhRequest("310","10","","E181225000022","10||4||1","36","23","4634","1","","","OUTPH") 
ClassMethod InsertPhRequest(recloc, phd, nprt, prescno, phditm, qty, reason, userid, over, staus = "", InsRowID = "", AppType = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhReturn","InsertPhRequest",phditm)=$lb(recloc, phd, nprt, prescno, phditm, qty, reason, userid, over, staus , InsRowID,AppType)
	s ReqCode=0
	s sysdate=+$h
	s systime=$p($h,",",2)
	s curryear="",currdate=""
	s currdate=$zd(sysdate,3)
	s curryear=$p(currdate,"-",1)
	///mdoify 2014-06-10 欠药改为用标志传输，“0”为欠药，1为“不欠药”
	s chowflag="0"
	i staus=0 d
	.// 欠药未发部分
	.s chowflag="1"
	.s pmi=$p(^DHCPHOW(phd),"^",9)
	.s oeori=$p(^DHCPHOW(phd,"I",$p(phditm,"||",2)),"^",1)
	e  d
	.s pmi=$p(^DHCPHDISP(phd),"^",7)
	.s oeori=$p(^DHCPHDI($p(phditm,"||",1),"PHDI",$p(phditm,"||",2)),"^",5)
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	s phd=+phditm
	s phchl=$p(phditm,"||",2)
	s lb=$p(phditm,"||",3)
	s phdItmId=phd_"||"_phchl
	s phdItmLbId=""
	i chowflag=0 d
	.s inclb=$p(^DHCPHDI(phd,"PHDI",phchl,"INCLB",lb),"^",3)
	.s inci=+inclb
	.s dspb=$p(^DHCPHDI(phd,"PHDI",phchl,"INCLB",lb),"^",9)
	.s phdItmLbId=phd_"||"_phchl_"||"_lb
	e  d
	.s inci=$p(^DHCPHOW(phd,"I",$p(phditm,"||",2)),"^",5)
	.s dspb=$p(^DHCPHOW(phd,"I",$p(phditm,"||",2)),"^",6)
	.s inclb=""
	s basuom=+$p(^INCI(inci,1),"^",10)
	s phuomid=+$p(^INCI(inci,1),"^",12)

	i AppType'="" d
	.i dispuomdr'="" d
	..s dispconfac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,basuom)
	..s qty=qty*dispconfac
	.e  d
	..s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(phuomid,basuom)
	..s qty=qty*confac  
	s prtValue=nprt
	i prtValue="" s prtValue=0
	i $d(^DHCTMPRequest(userid,recloc,phd,prtValue)) d
	.s phreqrow=""
	.f  s phreqrow=$o(^DHCPHREQi("DISP",phd,phreqrow),-1) q:(phreqrow="")!(ReqCode'=0)  d
	..s newprt="",reqdate=""
	..s newprt=+$p(^DHCPHREQ(phreqrow),"^",5)
	..q:(nprt'="")&&(newprt'=nprt)
	..s reqdate=+$p(^DHCPHREQ(phreqrow),"^",4)
	..q:reqdate'=sysdate
	..s ReqCode=$p(^DHCPHREQ(phreqrow),"^",2)
	..s phreqsub="",sub=0
	..f  s phreqsub=$o(^DHCPHREQ(phreqrow,"I",phreqsub)) q:phreqsub=""  d
	...s sub=sub+1
	..s sub=sub+1
	..&sql(insert into sqluser.dhc_phreqitem(phreqi_phreq_parref,phreqi_child,phreqi_phdi_dr,
	phreqi_reqqty,PHReqi_ChowFlag,PHReqi_RefundReqMark,PHReqi_PHDIC_DR,PHReqi_DSPB_DR,PHReqi_INCLB_DR)
	values(:phreqrow,:sub,:phdItmId,:qty,:chowflag,:InsRowID,:phdItmLbId,:dspb,:inclb))
	..s:staus="0" $p(^DHCPHOW(+phditm,"I",$p(phditm,"||",2)),"^",4)="1"
	e  d
	.s ^DHCTMPRequest(userid,recloc,phd,prtValue)=phditm_"^"_qty_"^"_reason  
	.&sql(select phreqc_code into :ReqCode from dhc_phreqcode where phreqc_year=:curryear)
	.i +ReqCode=0  d
	..&sql(insert into sqluser.dhc_phreqcode(phreqc_year,phreqc_code)
	values(:curryear,1))
	.e  d
	..&sql(update dhc_phreqcode set phreqc_code=phreqc_code+1 where phreqc_year=:curryear)
	.s ReqCode=+ReqCode+1
	.&sql(insert into dhc_phrequest(phreq_ctloc_dr,phreq_code,phreq_date,phreq_newprt_dr,phreq_papmi_dr,
	phreq_phd_dr,phreq_prescno,phreq_retreason,phreq_time,phreq_usr,phreq_year)
	values(:recloc,:ReqCode,:sysdate,:nprt,:pmi,:phd,:prescno,:reason,:systime,:userid,:curryear))
	.s phreqrow=""
	.s phreqrow=$g(%ROWID)
	.&sql(insert into dhc_phreqitem(phreqi_phreq_parref,phreqi_child,
	phreqi_phdi_dr,phreqi_reqqty,PHReqi_ChowFlag,PHReqi_RefundReqMark,PHReqi_PHDIC_DR,PHReqi_DSPB_DR,PHReqi_INCLB_DR)
	values(:phreqrow,1,:phdItmId,:qty,:chowflag,:InsRowID,:phdItmLbId,:dspb,:inclb))
	.s:staus="0" $p(^DHCPHOW(+phditm,"I",$p(phditm,"||",2)),"^",4)="1"

	i over="1" d
	.k ^DHCTMPRequest(userid)
	q ReqCode
}

// create : by wyx 2014-01-18

// input : 待打印的申请单号(PHReq_Code)串可能会有重复

// output : 组织的打印的数据的pid

// w ##class(web.DHCOutPhReturn).GetPrtDateInfo("49")

ClassMethod GetPrtDateInfo(printStr)
{
  s cnt=$l(printStr,"^")
  s pid=..NewPid()
  s mnum=0
  s newprintstr=""
  k ^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid)
  f num=1:1:cnt d
  .s reqno=$p(printStr,"^",num)
  .s year=$p($zd(+$h,3),"-",1)
  .s reqid=$o(^DHCPHREQi("Code",year,reqno,""))
  .q:reqid=""
  .q:$d(^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid,"Main",reqid))
  .i newprintstr="" s newprintstr=reqid
  .e  s newprintstr=newprintstr_"^"_reqid
  .s papmi=$p(^DHCPHREQ(reqid),"^",6)
  .s phd=$p(^DHCPHREQ(reqid),"^",7)
  .s reasonid=$p(^DHCPHREQ(reqid),"^",13)
  .s reasdesc=""
  .//i reasonid'="" s reasdesc=$p(^BLC("RFR",reasonid),"^",2)
  .i reasonid'="" s reasdesc=$p(^DHCINVOPREFR(reasonid),"^",2) ///取退费原因表 bianshuai 2015-12-17
  .s prescno=$p(^DHCPHREQ(reqid),"^",8)
  .s newprt=$p(^DHCPHREQ(reqid),"^",5)
  .s newprt=+newprt
  .s patname="",pmino="",prtinv=""
  .i newprt'=0 d
  ..s pmi=+$p(^DHCINVPRT(newprt),"^",15)
  ..s prtinv=+$p(^DHCINVPRT(newprt),"^",14) //发票号
  ..s pmino=$p(^PAPER(pmi,"PAT",1),"^",2) //登记号
  ..s patname=$p(^PAPER(pmi,"ALL"),"^",1)
  .e  d
  ..s pmino=$p(^PAPER(papmi,"PAT",1),"^",1)
  ..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
  .s locdr=$p(^DHCPHREQ(reqid),"^",3) //退药科室
  .s locdesc=""
  .i locdr'="" s locdesc=$p(^CTLOC(locdr),"^",2)
  .s requser=$p(^DHCPHREQ(reqid),"^",17) //退药申请人
  .s requserdesc=""
  .i requser'="" s requserdesc=$p(^SSU("SSUSR",requser),"^",2)
  .s reqdate=$p(^DHCPHREQ(reqid),"^",4) 
  .i reqdate'="" s reqdate=$zd(reqdate,3)
  .s ^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid,"Main",reqid)=patname_"^"_pmino_"^"_prtinv_"^"_reasdesc_"^"_locdesc_"^"_reqno_"^"_requserdesc_"^"_reqdate
  .s mnum=mnum+1
  .s dnum=0
  .s chl=""
  .f  s chl=$o(^DHCPHREQ(reqid,"I",chl)) q:chl=""  d
  ..s reqItmData=^DHCPHREQ(reqid,"I",chl)
  ..s reqItmId=reqid_"||"_chl
  ..s reqqty=$p(reqItmData,"^",4)
  ..s phdItmLbId=$p(reqItmData,"^",10)
  ..s phdId=+phdItmLbId
  ..s phdItm=+$p(phdItmLbId,"||",2)
  ..s phdItmLb=+$p(phdItmLbId,"||",3)
  ..s phdItmLbData=$g(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb))
  ..s orditm=$p($g(^DHCPHDI(phdId,"PHDI",phdItm)),"^",5)
  ..q:orditm=""
  ..s ord=$p(orditm,"||",1) 
  ..s itm=$p(orditm,"||",2)
  ..s inclb=$p(phdItmLbData,"^",3) 
  ..s inci=+inclb
  ..q:inci=""
  ..s phdi=$p(^DHCPHREQ(reqid,"I",chl),"^",1) //发药子表rowid
  ..s dnum=dnum+1
  ..s itmmast="",itmmastid="",itmmastver=""
  ..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
  ..s itmmastid=$p(itmmast,"||",1)
  ..s itmmastver=$p(itmmast,"||",2)
  ..//s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
  ..s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //药品名称
  ..s baseprice=0,phuomid="",basuom="",phuomdesc=""
  ..//s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
  ..s phuomid=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13) 
  ..i phuomid'="" d
  ...s fmtReqQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(+inclb,reqqty,phuomid)
  ..e  d
  ...s fmtReqQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(+inclb,reqqty)
  ..s reqqty=$p(fmtReqQtyUomStr,"^",1)
  ..s phuomid=$p(fmtReqQtyUomStr,"^",2)
  ..s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
  ..i phdi'="" d
  ...s baseprice=##Class(web.DHCOutPhCommon).GetPhdItmSp(phdi)	//zhouyg 20150115
  ..e  d
  ...i newprt=0 d
  ....s dspdate=##class(web.DHCOutPhDisp).getDspDate(orditm)
  ....i dspdate="" s dspdate=+$h
  ....s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(locdr)
  ....s hospdr=$p(HospString,"^",1)
  ....s exStr=orditm_"^"
  ....s baseprice=##class(web.DHCSTPRICE).GetSp(+inci,+dspdate,"",hospdr,"",exStr)	//zhouyg 20150113
  ...e  d
  ....s baseprice=##class(web.DHCOutPhDisp).GetBasPrice(newprt,orditm)
  ....s baseprice=$fn(baseprice,"",4)
  ..s confac=""
  ..//s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
  ..s basuom=+$p(^INCI(inci,1),"^",10)
  ..s confac=$p(fmtReqQtyUomStr,"^",3) //##class(web.DHCST.Common.UtilCommon).UOMFac(phuomid,basuom)
  ..s scrprice=baseprice*confac
  ..i (scrprice<1)&&($p(scrprice,".",1)="") s scrprice=0_scrprice
  ..s reqmoney=reqqty*scrprice
  ..i (reqmoney<1)&&($p(reqmoney,".",1)="") s reqmoney=0_reqmoney
  ..s ^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid,"Main",reqid,"Detail",dnum)=phdesc_"^"_reqqty_"^"_phuomdesc_"^"_scrprice_"^"_reqmoney
  ..
  .
  .	
  q pid_"$"_newprintstr
}

ClassMethod GetPrtMainInfo(pid, reqid) As %String
{
  s mainstr=^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid,"Main",reqid)	
  s dnum=$o(^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid,"Main",reqid,"Detail",""),-1)	
  q mainstr
}

ClassMethod GetPrtDetailInfo(pid, reqid) As %String
{
 
  s num=""
  s datastr=""
  f  s num=$o(^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid,"Main",reqid,"Detail",num)) q:num=""  d 
  .s data=^TMP("web","DHCOutPhReturn","GetPrtDateInfo",pid,"Main",reqid,"Detail",num)
  .i datastr="" s datastr=data
  .e  s datastr=datastr_","_data
  .
  .
  q datastr
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DHCOutPhReturn"))
}

ClassMethod GetPmiNo(inv)
{
  s prt=""
  s prt=$o(^DHCINVPRT(0,"INV",inv,prt),-1)
  i prt="" q 0
  s pmi=""
  s pmi=+$p(^DHCINVPRT(prt),"^",15)
  s patname="",pmino=""
  s pmino=$p(^PAPER(pmi,"PAT",1),"^",2)
  s patname=$p(^PAPER(pmi,"ALL"),"^",1)
  s sysdate=+$h
  s prtdate=+$P(^DHCINVPRT(prt),"^",5)
  i sysdate-prtdate>2 q -1
  q pmino_"^"_patname
}

// w ##Class(web.DHCOutPhReturn).GetPrtFrPmi("0000000074")

ClassMethod GetPrtFrPmi(CPmiNo)
{
    
    s pmi="",m=0,pername="",lzero="",ret=""
    i CPmiNo="" q ""
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
    s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
    k ^DHCTMPPHPRT($j)
    s pername=$p(^PAPER(pmi,"ALL"),"^",1)
    s phd="0"
    f  s phd=$o(^DHCPHDISPi("PAPMI",pmi,phd)) q:(phd="")!(phd="0")   d
      .s prt="",phdphl="",newprt=""
      .s prt=+$p(^DHCPHDISP(phd),"^",2)
      .q:prt=0
      .q:'$d(^DHCINVPRT(prt))
      .s fyflag=$p(^DHCPHDISP(phd),"^",4)
      .q:fyflag'="1"
      .s newprt=..GetNewPrtFrOld(prt)
      .i newprt=""  s newprt=prt
      .;
      .s prtdate="",phdl="",prescno=""
      .s prtdate=+$p(^DHCINVPRT(prt),"^",5)
      .s phdsub="",ph=0
      .f  s phdsub=$o(^DHCPHDI(phd,"PHDI",phdsub)) q:(phdsub="")!(ph=1)  d
        ..s dispqty=0,retqty=0,cyqty=0
        ..;
        ..s dispqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
        ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",6)
        ..s cyqty=dispqty-retqty
        ..;q:retqty'=0
        ..q:cyqty=0
        ..s ph=ph+1
      .q:ph=0
      .q:$d(^DHCTMPPHPRT($j,newprt))
      .s ^DHCTMPPHPRT($j,newprt)=prt 
      .s prtdate=$zd(prtdate,3)
      .s prtinv=""
      .s prtinv=$p(^DHCINVPRT(newprt),"^",14)
      .i ret'="" s ret=ret_"^"_newprt_$C(1)_prtinv
      .e  s ret=newprt_$C(1)_prtinv
   q ret
}

ClassMethod GetNewPrtFrOld(prt)
{
	
	s nprt="0",gnprt=""
	s lprt="",lprt=prt
	f  s nprt=$o(^DHCINVPRT(0,"OldINV",lprt,nprt)) q:(nprt="")!(nprt="0")  d
	  .s lprt=nprt                                                                                                        
	  .s gnprt=nprt
    i (gnprt="")!(gnprt="0") s gnprt=prt
    quit gnprt
}

/// 修改:退药原因取计费组退费原因表-DHC_INVOPRefReason 
/// bianshuai 2015-12-17
ClassMethod GetReas()
{
	s ret=""
	s rfr=""
	f  s rfr=$o(^DHCINVOPREFR(rfr)) q:rfr=""  d
	.s rfrdesc=""
	.s rfrdesc=$p(^DHCINVOPREFR(rfr),"^",2)
	.q:rfr=0
	.i ret'="" s ret=ret_"^"_rfr_$C(1)_rfrdesc
	.e  s ret=rfr_$C(1)_rfrdesc
	q ret
}

/// w ##class(web.DHCOutPhReturn).CheckRetQty("16||1||1","7")
ClassMethod CheckRetQty(phdlbrowid, qty)
{
	//s ^hlh($h)=$lb(phdlbrowid, qty)
	s phdrow=$p(phdlbrowid,"||",1)
	s phdsub=$p(phdlbrowid,"||",2)
	s phdlb=$p(phdlbrowid,"||",3)
	s dispqty=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdlb),"^",1)
	s hadretqty=##class(web.DHCOutPhCommon).GetRetedQtyByPhdLb(phdlbrowid)
	s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdlb),"^",3)
	s inci=+inclb
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s phuomid="",dispuomdr=""
	s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	s outdispuomdr=+$p(^INCI(inci,1),"^",12)
	s outdispuomdr=$p(outdispuomdr,$c(1),1)
	s basuom=+$p(^INCI(inci,1),"^",10)
	i (dispuomdr'="")&&(dispuomdr'=outdispuomdr)&&(dispuomdr'=basuom)  d
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuomdr,basuom)
	e  d
	.i outdispuomdr'=0   d
	..s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(outdispuomdr,basuom)
	.e  d
	..s confac=1
	.
	s retqty=qty*confac
	i dispqty<(retqty+hadretqty) q -1
   q 0
}

ClassMethod CheckDisp(np)
{
	s pmi="",gm=0
	s pmi=+$p(^DHCINVPRT(np),"^",15)
	s phdrow=""
	f  s phdrow=$o(^DHCPHDISPi("PAPMI",pmi,phdrow)) q:phdrow=""  d
	  .s phdprt="",phdfyflag=""
	  .s phdprt=+$p(^DHCPHDISP(phdrow),"^",2)
	  .s phdfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	  .q:phdfyflag'="1"
	  .q:phdprt'=np
	  .s gm=gm+1
	q gm
}

/// Description:取发票中该医嘱的退药数量，供计费组调用，所以修改时应注意，如入参和出参有变，请与计费组统一
/// Creator: wangsen ,Liang Qiang
/// Input:OE_OrdItem RowID,当前发票ID
/// Output:某发票中某医嘱的退药数量
/// w ##class(web.DHCOutPhReturn).GetRetOrdQty("2372||10","235981")
ClassMethod GetRetOrdQty(orditm, feedr = "")
{
	  s retrow="",retqty=0,retfreedr=""
	  f  s retrow=$o(^DHCPHRTIi(orditm,"ORDI",retrow)) q:retrow=""  d
	  .s retsub=""
	  .f  s retsub=$o(^DHCPHRTIi(orditm,"ORDI",retrow,retsub)) q:retsub=""  d
	  ..s curretqty=0
	  ..s retfreedr=$p($g(^DHCPHRTI(retrow,"RTI",retsub)),"^",10)	  //改为子表发票id   zhaozhiduan
	  ..q:(feedr'="")&(feedr'=retfreedr) //add by wangsen
	  ..s curretqty=+$p($g(^DHCPHRTI(retrow,"RTI",retsub)),"^",3)	  
	  ..s inci=+$p($g(^DHCPHRTI(retrow,"RTI",retsub)),"^",13)
	  ..s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
 	  ..s phcUomId=$p(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),2),"^",4)
  	  ..s uom=$p(^INCI(inci,1),"^",10)
 	  ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,phcUomId)
 	  ..s curretqty=curretqty*fac
	  ..s retqty=retqty+curretqty
	  .  
	  s phowretqty=..GetPhowRetQty(orditm,feedr)
	  s retqty=retqty+phowretqty
	  q retqty
}

ClassMethod CeckRetPrt(orditm, retitmrow)
{
  s retval=0
  i '$d(^DHCOutPatientRetOrdItem(orditm))  d
    .s retval=0
  e  d
    .s retsubrow=""
    .f  s retsubrow=$o(^DHCOutPatientRetOrdItem(orditm,"PRT",retsubrow)) q:retsubrow=""  d
    ..q:retsubrow'=retitmrow
    ..s prtflag=""
    ..s prtflag=$p(^DHCOutPatientRetOrdItem(orditm,"PRT",retsubrow),"^",1)
    ..i prtflag="1"  s retval=1
  q retval
}

ClassMethod UpdateRetPrt(orditminf)
{
 
   ;退费时写上退药标志
    ;##class(web.DHCOutPhReturn).UpdateRetPrt(orditminf)
   q:orditminf="" 0
    s orditmlen=$l(orditminf,"^")
    for t=1:1:orditmlen
    {
	 s orditm=""
	 s orditm=$p(orditminf,"^",t)
    s retrow="",retqty=0
	f  s retrow=$o(^DHCPHRTIi(orditm,"ORDI",retrow)) q:retrow=""  d
	  .s retsub=""
	  .f  s retsub=$o(^DHCPHRTIi(orditm,"ORDI",retrow,retsub)) q:retsub=""  d
	  ..s curretqty=0
	  ..s curretqty=+$p($g(^DHCPHRTI(retrow,"RTI",retsub)),"^",3)
	  ..s retitmrow=""
	  ..s retitmrow=retrow_"||"_retsub
	  ..s checkretprt=0
	  ..s checkretprt=##class(web.DHCOutPhReturn).CeckRetPrt(orditm,retitmrow)
	  ..q:checkretprt'=0
	  ..s $p(^DHCOutPatientRetOrdItem(orditm,"PRT",retitmrow),"^",1)="1"
    }
   
  q 0
}

ClassMethod UpdateAllRetItm()
{
	;##class(web.DHCOutPhReturn).UpdateAllRetItm()
   s retrow="",m=0
   f  s retrow=$o(^PHRET(retrow)) q:retrow=""  d
     .s retsub=""
     .f  s retsub=$o(^PHRTI(retrow,"RTI",retsub)) q:retsub=""  d
     ..s retorditm="",retitm=""
     ..s retorditm=$p(^PHRTI(retrow,"RTI",retsub),"^",2)
     ..s retitm=retrow_"||"_retsub
     ..s $p(^DHCOutPatientRetOrdItem(retorditm,"PRT",retitm),"^",1)="1"
     ..s m=m+1
  q m
}

ClassMethod GSysTime()
{
  s sysTime=""
  s sysTime=$zd(+$h,1)
  q sysTime
}

/// 退药时因之前调价产生损益 ,信息插入退药损益表 DHC_RetAspAmount
/// liangqiang 2011-03-19
/// 
ClassMethod InsertRetA(insString As %String) As %String
{
	 q:$g(insString)="" -1
	 s retitmrow=$p(insString,"^",1)
	 s inclb=$p(insString,"^",2)	//inclb
	 s locdr=$p(insString,"^",4)
	 s amount=$p(insString,"^",3)
	 s qty=$p(insString,"^",5)
	 s userdr=$p(insString,"^",6)
	 s retdate=$p(insString,"^",7)
	 s rettime=$p(insString,"^",8)
	 s retprice=$p(insString,"^",9)
	 s retrp=$p(insString,"^",10)
	 s buom=$p(^INCI(+inclb,1),"^",10)
	 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locdr)
     s HospID=$p(CustStr,"^",5)
     s CustID=$p(CustStr,"^",1)
	 s sp=##Class(web.DHCSTPRICE).GetCurSp(inclb,buom,HospID)
	 s phdrp=##Class(web.DHCSTPRICE).GetCurRp(inclb,buom,HospID)
	 q:(retprice=sp)&(phdrp=retrp) 0
	 s adjprice=sp-retprice    ;损益价格
	 s amount=adjprice*qty
	 s adjrp=phdrp-retrp
     s adjrpamt=adjrp*qty
	 
	 s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
     s StkTypeDesc=$P(CatGrpStr,"^",4)
     s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
     s amount=##Class(web.DHCSTCOMMPARA).GetNumbDec(amount,Perv,"FmtSA",1)
     s adjrpamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(adjrpamt,Perv,"FmtRA",1)
     
	 s rettype="H"
	 
	 k PLIST
	 s PLIST(1)=""
	 s PLIST(2)=+inclb
	 s PLIST(3)=locdr
	 s PLIST(4)=adjprice
	 s PLIST(5)=qty
	 s PLIST(6)=amount
	 s PLIST(7)=userdr
	 s PLIST(8)=retdate
	 s PLIST(9)=rettime
	 s PLIST(10)=retitmrow  
	 s PLIST(11)=rettype 
	 s PLIST(12)=adjrp    
	 s PLIST(13)=adjrpamt 
	 
	 &sql(insert into  DHC_RetAspAmount values PLIST())
	 q:SQLCODE'=0 -2
	 q 0
}

/// Description:判断该退药单是否已经生成了月报
/// Creator：   hulihua
/// CreatDate： 2019-04-25
/// Table：     DHC_PHReturn
/// Input：     RetRowid-退药主表ID
/// Output：       
/// Return：	0,未生成；1,已生成	       
/// Others： 
/// Debug:		w ##class(web.DHCOutPhReturn).IfMakeMon("18")
ClassMethod IfMakeMon(RetRowid As %String)
{
	q:RetRowid="" 0
	q:'$d(^DHCPHRET(RetRowid)) 0
	s retPhlId=+$p(^DHCPHRET(RetRowid),"^",7)
	s retLocId=+$p(^DHCPHLOC(retPhlId),"^",1)
	s retDate=+$p(^DHCPHRET(RetRowid),"^",2)		//退药日期
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:retLocId and DHCSM_ToDate>=:retDate)
	q:'SQLCODE 1
	q 0
}

/// 在未退费前撤消退药,一个申请仅可退一次
/// liangqiang 2011-03-19
/// w ##class(web.DHCOutPhReturn).CancleReturn(18)
ClassMethod CancleReturn(RetRowid As %String) As %String
{
	q:'$D(^DHCPHRET(RetRowid)) "-1^该条记录已撤销退药,请核对！" 
	s phl=+$p(^DHCPHRET(RetRowid),"^",7)
	s loc=+$p(^DHCPHLOC(phl),"^",1)
	s paramPropStr=##class(PHA.OP.COM.Method).GetParamProp("",loc,"")
	s conCanRetFlag=$p(paramPropStr,"^",3) 
	s RetDate=+$p(^DHCPHRET(RetRowid),"^",2)
	//虽然配置了按照月报，但是该科室从来不用月报则也按当天控制
	q:((conCanRetFlag'=2)||((conCanRetFlag=2)&&('$d(^DHCSM(0,"CTLOC",loc)))))&&(RetDate'=+$h) "-2^非当天的退药记录,不能撤销！"
	q:(conCanRetFlag=2)&&($d(^DHCSM(0,"CTLOC",loc)))&&(..IfMakeMon(RetRowid)=1) "-3^该退药单已经生成了月报,不能撤销！"
	//判断医嘱的退费状态
	s retBillFlag=0
	s retsub=""  
	f  s retsub=$o(^DHCPHRTI(RetRowid,"RTI",retsub))  q:(retsub="")||(retBillFlag'=0)  d
	.s oeori=$p(^DHCPHRTI(RetRowid,"RTI",retsub),"^",2)
	.s admId=$p(^OEORD(+oeori),"^",1)
	.s:##class(web.DHCOutPhCommon).GetAdmStatus(admId)=1 retBillFlag=1
	.q:retBillFlag'=0
	.s admType=$p(^PAADM(admId),"^",2)
	.s payDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(oeori)
	.s billStatus=$p(##class(PHA.FACE.IN.Com).GetOeoriBilled(oeori),"^",2)
	.i payDispFlag'="Y"  d
	..//正常医嘱直接判断退费状态
	..s:billStatus["已退费" retBillFlag=2
	.e  d
	..//先收费后发药按照体检分开判断
	..s payFlag=$p(##class(PHA.FACE.IN.Com).GetOeoriBilled(oeori),"^",1)
	..i admType'="H"  d
	...s:payFlag="P" retBillFlag=3
	..e  d
	...s:payFlag="R" retBillFlag=4
	..
	.q:retBillFlag'=0
	q:retBillFlag=1 "-4^急诊留观患者,已出院结算!"
	q:retBillFlag=2 "-5^该退药单上有明细已退费,不能撤销!"
	q:retBillFlag=3 "-6^该退药单上非体检类先发药后收费的医嘱已做结算，不能撤消!" 
	q:retBillFlag=4 "-7^该体检病人处方已退费，不能撤销！"
	s locdesc=$p(^CTLOC(loc),"^",2)
	s reclocdr=$p(^OEORD(+oeori,"I",$P(oeori,"||",2),3),"^",6) 
	q:(reclocdr'=loc) "-8^跨科室退药不允许撤销！" 
	s pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter()
	TSTART
	Set $ZT="troll"
	l +^CANCLEOUTPHRET(RetRowid):5  e  q -50   ;加锁 
	s ret=0
	s PHDDR=+$p(^DHCPHRET(RetRowid),"^",6)
	s reqrow=$p(^DHCPHRET(RetRowid),"^",17)
	s retsub="" 
	f  s retsub=$o(^DHCPHRTI(RetRowid,"RTI",retsub)) q:(retsub="")||(ret'=0)  d
	.k ^TMPOUTRET("DHCOUTPHA",$this,"CancleReturn",pid,"CANCLERETINCLB")
	.s retitmid=RetRowid_"||"_retsub
	.s Oeordid=$p(^DHCPHRTI(RetRowid,"RTI",retsub),"^",2)
	.s retqty=+$p(^DHCPHRTI(RetRowid,"RTI",retsub),"^",3)
	.s retunitdr=$p(^DHCPHRTI(RetRowid,"RTI",retsub),"^",4)
	.s phdlbrowid=$p(^DHCPHRTI(RetRowid,"RTI",retsub),"^",11)
	.s PHDDR=+phdlbrowid
	.s PHDIT=$p(phdlbrowid,"||",2)
	.s PHDITSUB=$p(phdlbrowid,"||",3)
	.s ^TMPOUTRET("DHCOUTPHA",$this,"CancleReturn",pid,"CANCLERETITM",phdlbrowid)=retqty
	.// 退药子表对应发药孙表,台账唯一
	.s inclb=$p(^DHCPHRTI(RetRowid,"RTI",retsub),"^",13)
	.s retunit=$p($g(^CT("UOM",retunitdr)),"^",2)
	.s intrtype="H" 
	.s hbasretqty=+$p(^DHCPHDI(PHDDR,"PHDI",PHDIT,"INCLB",PHDITSUB),"^",2)
	.s leftbasqty=hbasretqty-retqty
	.// 更新发药孙表退药数量
	.s $p(^DHCPHDI(PHDDR,"PHDI",PHDIT,"INCLB",PHDITSUB),"^",2)=leftbasqty
	.;处理批次库存
	.s ItmCode=$p(^INCI(+inclb,1),"^",1)
	.s incqty=##CLASS(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
	.s ctuom=$p(^INCI(+inclb,1),"^",10)
	.s ctuomdesc=$p(^CT("UOM",ctuom),"^",2) 
	.i incqty<retqty s ret=-10 q
	.s data=""_"^"_""_"^"_inclb_"^"_-retqty_"^"_retunit_"^"_ItmCode_"^"_""_"^"_""_"^"_""_"^"_locdesc_"^"_""_"^"_"1"
	.s err=##class(web.DHCST01).UPDINCI(data,1)
	.i err'=1 s ret=-9 q
	.q:ret'=0
	.;删除打包表
	.s retDspBatchId=$p(^DHCPHRTI(RetRowid,"RTI",retsub),"^",12)
	.s:retDspBatchId="" ret=-201
	.q:ret'=0
	.s retdsp=+retDspBatchId
	.s dsptype=$p(^DHCOEDISQTY(retdsp),"^",13)
	.s:dsptype'="H" ret=-202
	.q:ret'=0
	.s ret=##class(web.DHCSTOEDispBatch).DelDspBatch(retDspBatchId)
	.q:ret'=0
	.s dspsub=$o(^DHCOEDISQTY(retdsp,"I",0))
	.i dspsub="" d
	..&sql(delete from sqluser.dhc_oedispensing where DSP_RowId=:retdsp)
	..s ret=SQLCODE
	.q:ret'=0
	.;删除台帐表
	.s intranstype="H"
	.s intrans=""
	.f  s intrans=$o(^DHCINTR(0,"TypePointer",intranstype,retitmid,intrans)) q:(intrans="")||(ret'=0)  d
	..&sql(delete from sqluser.DHC_Intrans where INTR_RowId=:intrans) 
	..s ret=SQLCODE
	..q:ret'=0
	i ret'=0 TRo
	i ret'=0 d unlock
	q:ret'=0 "-9^批次可用库存不足！"
	;删除退药表
	&sql(delete from sqluser.dhc_phreturn where phret_rowid=:RetRowid)
	i ret'=0 TRo
	i ret'=0 d unlock
	q:ret'=0 "-10^删除退药表失败!"
	///修改退药申请表状态
	i reqrow'="" d
	.s reqsub="0" 
	.f  s reqsub=$o(^DHCPHREQ(reqrow,"I",reqsub)) q:(reqsub="")||(ret'=0)  d
	..s reqphdlbrowid=$P(^DHCPHREQ(reqrow,"I",reqsub),"^",10)
	..q:'$D(^TMPOUTRET("DHCOUTPHA",$this,"CancleReturn",pid,"CANCLERETITM",reqphdlbrowid))
	..s retqty=^TMPOUTRET("DHCOUTPHA",$this,"CancleReturn",pid,"CANCLERETITM",reqphdlbrowid)
	..s oldretqty=$P(^DHCPHREQ(reqrow,"I",reqsub),"^",5)
	..s newqty=oldretqty-retqty 
	..s $P(^DHCPHREQ(reqrow,"I",reqsub),"^",5)=newqty  
	..&sql(update dhc_phrequest set phreq_retflag=NULL where phreq_rowid=:reqrow)
	..i SQLCODE'=0  s ret=-4
	..q:ret'=0
	. 
	i ret'=0 TRo
	i ret'=0 d unlock
	q:ret'=0 "-11^修改退药申请表状态失败！"
	TCOMMIT
	q ret
   
unlock
	k ^TMPOUTRET("DHCOUTPHA",$this,"CancleReturn",pid,"CANCLERETINCLB")
	k ^TMPOUTRET("DHCOUTPHA",$this,"CancleReturn",pid,"CANCLERETITM")
	k ^TMPGETINCLB(pid)
	l -^CANCLEOUTPHRET(RetRowid)
	q 
    
troll
	Set $ZT=""
	TRo
	d unlock
	s ErrorMsg=$ZE
	q ErrorMsg
}

/// 取欠药表未发状态下的已退药数量
/// liangqiang 2011-07-20
/// w ##class(web.DHCOutPhReturn).GetPhowRetQty("98||19","230496")
ClassMethod GetPhowRetQty(orditm, prt) As %String
{
	  s ord=+orditm
	  s itm=$p(orditm,"||",2)
	  s adm=$p(^OEORD(ord),"^",1)
	  s papmi=$p(^PAADM(adm),"^",1)
	  s PrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	  q:PrescNo="" 0
	  s phowqty=0
	  s phow=""
	  f  s phow=$o(^DHCPHOWi(0,"PAPMI",papmi,PrescNo,phow)) q:phow=""  d
	  .s prtdr=$p(^DHCPHOW(phow),"^",13)
	  .b
	  .q:(prt'="")&&(prt'=prtdr)
	  .s status=$p(^DHCPHOW(phow),"^",8)
	  .b //11
	  .q:status=2 //如果欠药单已发药状态,库存已减,不考虑
	  .s phowretdate=$p(^DHCPHOW(phow),"^",10)
	  .q:phowretdate=""
	  .s exit=0
	  .s phowsub=""
	  .f  s phowsub=$o(^DHCPHOW(phow,"I",phowsub)) q:(phowsub="")!(exit=1)  d
	  ..s oeori=$p(^DHCPHOW(phow,"I",phowsub),"^",1)
	  ..i orditm=oeori d
	  ...s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	  ...s dspstate=$p(^DHCOEDISQTY(dsp),"^",7)
	  ...q:dspstate'="C"   //只有欠药单未发,医嘱是发药状态,才返回退药数量,然后可以退费
	  ...s qty=$p(^DHCPHOW(phow,"I",phowsub),"^",2)
	  ...s inci=$p(^DHCPHOW(phow,"I",phowsub),"^",5)
	  ...s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
	  ...q:Phcdf=""
 	  ...s phcUomId=$p(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),2),"^",4)
  	  ...s uom=$p(^INCI(inci,1),"^",10)
 	  ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,phcUomId)
 	  ...s qty=qty*fac
	  ...s phowqty=phowqty+qty
	  ...s exit=1
	  ...
	  ..
	  .
	  q phowqty
}

/// 欠药退药的处理过程
/// liangjiaquan 2014-05-02
ClassMethod DoChowReturn(reqrow As %Library.String = "", userid As %Library.String = "", RetInf As %Library.String = "")
{
	s retdate=$p($h,",",1)
	s rettime=$p($h,",",2) 
	s retuser=$o(^DHCPHPERi("USR",userid,""))
	s reqloc=$P(^DHCPHREQ(reqrow),"^",3)
	S hospital=$p($g(^CTLOC(reqloc)),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(hospital)
	s ret=0
	TSTART
	&sql(update dhc_phrequest set phreq_retflag='1' where phreq_rowid=:reqrow) 
	i SQLCODE'=0  TRo
	i SQLCODE'=0 q -3_"^更新退药申请主表失败"
	s valnum=0
	s retline=$l(RetInf,"&")
	f i=1:1:retline q:ret'=0  d
	  .s retitmstr="",chowsub=""
	  .s retitmstr=$p(RetInf,"&",i)
	  .s chowsub=$p(retitmstr,"^",1)
	  .s phow=+chowsub
	  .s phowsub=$p(chowsub,"||",2)
	  .s owestatus=+$p(^DHCPHOW(phow),"^",8)
	  .i (i=1)&&(owestatus'=0) TRo
	  .s:(i=1)&&(owestatus'=0) ret=-1
	  .q:(i=1)&&(owestatus'=0)                       //欠药单已发药不允许退药
	  .s oweretdate=+$p(^DHCPHOW(phow),"^",10)
	  .i (i=1)&&(oweretdate'=0) TRo
	  .s:(i=1)&&(oweretdate'=0) ret=-2
	  .q:(i=1)&&(oweretdate'=0)					    //欠药单已退药不允许退药
	  .s oweprt=$p(^DHCPHOW(phow),"^",7)
      .s retprt=$$GetNewPrt(oweprt)
	  .s qty=$p(^DHCPHOW(phow,"I",phowsub),"^",2)
	  .s oeori=$p(^DHCPHOW(phow,"I",phowsub),"^",1)
	  .s pointer="O"_phow_"||"_phowsub
	  .s dspBatId=$p(^DHCPHOW(phow,"I",phowsub),"^",6)
	  .s dsp=+dspBatId
	  .s dspstate=$p(^DHCOEDISQTY(dsp),"^",7)
      .i dspstate'="C" TRo
      .s:dspstate'="C" ret=-4
	  .q:dspstate'="C"   //处方医嘱是未发状态,请取消配药单
	  .&sql(update DHC_PHOweList set PHO_RetDate=:retdate,PHO_RetTime=:rettime,PHO_RetUser_Dr=:retuser,PHO_RetPrt_Dr=:retprt where PHO_RowID=:phow)
	  .i SQLCODE'=0 TRo
	  .s:SQLCODE'=0 ret=-5
	  .q:SQLCODE'=0 
	  .s unit=$p(^DHCOEDISQTY(dsp),"^",6)
	  .s dspSub=$p(dspBatId,"||",2)
	  .s inci=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5)
	  .s bUomId=$p(^INCI(inci,1),"^",10)
	  .s facNumber=##class(web.DHCST.Common.UtilCommon).UOMFac(bUomId,unit)
	  .//打包主表数量需转化为药学项基本单位对应的数量
	  .s dspQty=qty*facNumber
	  .s retstr=##CLASS(DHCOutPhDisp).InsertDHCOEDisp(oeori,dspQty,unit,pointer,"R","OW",userid) ;修改类型为OW欠药
	  .s ret=$p(retstr,"^",1)
	  .i ret'=0 TRo
	  .s:ret'=0 ret=-6
	  .q:ret'=0
	  .//插入打包子表记录！hulihua
	  .s retdsp=$p(retstr,"^",2)
	  .s inclb=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",1)
	  .s rp=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",3)
	  .s sp=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",4) 
	  .i RuleFlag=3 d
	  ..s DspbStr=retdsp_"^"_inclb_"^"_qty_"^"_sp_"^"_rp_"^"_inci_"^R"
	  ..s ret=##class(web.DHCST01).UpdInclbResQty(inclb,-qty)
	  .e  d 
	  ..s DspbStr=retdsp_"^^"_qty_"^"_sp_"^"_rp_"^"_inci_"^R"
	  ..s incsub=$o(^INCI("IL_LOC",reqloc,inci,""))
      ..s $p(^INCI(inci,"IL",incsub),"^",10)=$p(^INCI(inci,"IL",incsub),"^",10)-qty
      .i ret'=0 TRo
	  .s:ret'=0 ret=-7
	  .q:ret'=0
	  .s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
	  .s ret=$p(RetIns,"^",1)
	  .i ret'=0 TRo
	  .s:ret'=0 ret=-8
	  .q:ret'=0
	  .s valnum=valnum+1
	  .s $p(^DHCPHOW(phow,"I",phowsub),"^",4)="2"
	  s ErrInfo=""
	  s:ret=-1 ErrInfo="欠药单已发药不允许退药!" 
	  s:ret=-2 ErrInfo="欠药单已退药不允许再次退药!" 
	  s:ret=-4 ErrInfo="处方医嘱是未发状态,请取消配药单!"
	  s:ret=-5 ErrInfo="更新配药子表信息失败!"
	  s:ret=-6 ErrInfo="插入打包表信息失败!"
	  s:ret=-7 ErrInfo="清除在途数失败!"
	  s:ret=-8 ErrInfo="插入打包子表信息失败!"
	  i ret'=0 q ret_"^"_ErrInfo
	  TCOMMIT
	  q ret
	  
	  
GetNewPrt(prt)
    q:prt="" ""
	s nprt="0",gnprt=""
	s lprt=prt
	f  s nprt=$o(^DHCINVPRT(0,"OldINV",lprt,nprt)) q:(nprt="")!(nprt="0")  d
	.s lprt=nprt                                                                                                        
	.s gnprt=nprt
    i (gnprt="")!(gnprt="0") s gnprt=prt
    quit gnprt
}

ClassMethod CreateOutRetLog(pmino, content) As %String
{
	q:pmino="" ""
	s papmi=$o(^PAPERi("PAPMI_PatNo",pmino,""))
	s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("登记号",pmino)
 	s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("姓名^退药原因",content)
 	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	s EncryptCode=$p(EncryptLevelInfo,"^",3)
 	s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPOUTRET",condition,content,EncryptCode)
 	q eventlogret
}

/// Creator:bianshuai
/// CreateDate:2014-08-26 
/// Descript:调用停止执行记录
/// w ##class(web.DHCOutPhReturn).InvokeStopExec("159||4","1")
ClassMethod InvokeStopExec(ListData, userId) As %String
{
	s curdate=+$H
	S Len=$L(ListData,"^")
	F i=1:1:Len D
	.S phditm=$p(ListData,"^",i)
	.S phd=$p(phditm,"||",1)
	.S itm=$p(phditm,"||",2)
    .S orditem=$p(^DHCPHDI(phd,"PHDI",itm),"^",5)
    .//D ##class(web.DHCLCNUREXCUTE).ReturnLiquor(orditem,userId)
    .s dsp=""
    .f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditem,dsp)) q:dsp=""  d
    ..s ordexcrowid=$p(^DHCOEDISQTY(dsp),"^",3)
    ..s status=$p(^DHCOEDISQTY(dsp),"^",7)
    ..i status="TC" d
    ...s ret=##class(appcom.OEOrdExec).UpdateStatus(ordexcrowid,"D",userId,curdate,"","")
    ...
    Q 0
}

/// 获取门诊退药原因
/// yuruiying 2015-11-10
/// Input:invprt的ID和医嘱ID
/// w ##class(web.DHCOutPhReturn).getReturnReason(197006,"24||3")
ClassMethod getReturnReason(prt As %String, oeori As %String) As %String
{
  q:prt="" ""	
  q:'$D(^DHCINVPRT(prt)) ""
  s ord=+oeori
  s itm=$p(oeori,"||",2)
  q:'$D(^OEORD(ord,"I",itm))
  s reason=""
  s retrowid=""
  f  s retrowid=$o(^DHCPHRTIi(oeori,"ORDI",retrowid)) q:retrowid=""  d
  .q:'$D(^DHCPHRET(retrowid))
  .s newprtdr=$p(^DHCPHRET(retrowid),"^",16)
  .q:newprtdr'=prt
  .s phrtisub=""
  .f  s phrtisub=$o(^DHCPHRTIi(oeori,"ORDI",retrowid,phrtisub)) q:phrtisub=""  d
  ..q:'$D(^DHCPHRTI(retrowid,"RTI",phrtisub))
  ..s tmpoeori=$p(^DHCPHRTI(retrowid,"RTI",phrtisub),"^",2)
  ..q:tmpoeori'=oeori
  ..//s reasondr=$p(^DHCPHRTI(retrowid,"RTI",phrtisub),"^",5)
  ..s reasondr=$p(^DHCPHRET(retrowid),"^",13)
  ..//s reason=$p(^BLC("RFR",reasondr),"^",2)
  ..s reason=$p(^DHCINVOPREFR(reasondr),"^",2) ///取退费原因表 bianshuai 2015-12-17
   
  q reason
}

/// description:根据退药申请拒绝
ClassMethod RefuseReason(reason, rowitm) As %String
{
	&SQL(UPDATE DHC_PHREQITEM SET PHReqi_RefuseType='Y',PHReqi_RefuseReason=:reason WHERE PHReqi_Rowid=:rowitm)	
	q SQLCODE
}

/// description:根据退药申请撤销拒绝
ClassMethod CancelRefuseReason(rowitm) As %String
{
	&SQL(UPDATE DHC_PHREQITEM SET PHReqi_RefuseType=null,PHReqi_RefuseReason=null WHERE PHReqi_Rowid=:rowitm)	
	q SQLCODE
}

/// description: 根据处方判断是否存在未退的退药申请
/// return:		 Y(存在)
/// ##class(web.DHCOutPhReturn).CheckPrescHasReq
ClassMethod CheckPrescHasReq(PrescNo)
{
	q:PrescNo="" ""
	s hasFlag=""
	q:'$d(^DHCPHDISPi("PRESCNO",PrescNo)) ""
	s ordId=0
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId)) q:(ordId="")||(hasFlag'="")  d
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:(ordItm="")||(hasFlag'="")  d
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",ordId_"||"_ordItm,""))
	..q:dspId=""
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(hasFlag'="")  d
	...s reqId=0
	...f  s reqId=$o(^DHCPHREQi("DSPB",dspId_"||"_dspSub,reqId)) q:(reqId="")||(hasFlag'="")  d
	....q:$p(^DHCPHREQ(reqId),"^",11)="1"
	....s reqItm=0
	....f  s reqItm=$o(^DHCPHREQi("DSPB",dspId_"||"_dspSub,reqId,reqItm)) q:(reqItm="")||(hasFlag'="")  d
	.....s reqItmData=^DHCPHREQ(reqId,"I",reqItm)
	.....q:$p(reqItmData,"^",5)>=$p(reqItmData,"^",4)
	.....s hasFlag="Y"
	q hasFlag
}

}
