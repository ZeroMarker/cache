Import SQLUser

/// 门诊护士执行:打印等
Class web.DHCNurOPExec Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 83;

ClassMethod InsertPHDisp(prtId As %Library.String = "", phlId As %Library.String = "", phwId As %Library.String = "", pyPhpId As %Library.String = "", fyPhpId As %Library.String = "", prescNo As %Library.String = "", phwpos As %Library.String = "", oeoreId As %Library.String)
{
	s curDate=$p($h,",",1)
	s curTime=$p($h,",",2)
	s ctlocId=+$p(^DHCPHLOC(phlId),"^",1)
	s papmidr=$p(^DHCINVPRT(prtId),"^",15)
	s phaId="",phaNoUse="",phaFinFlag=""
	f  s phaId=$o(^DHCPHARi("PRT",prtId,phaId)) q:phaId=""  d
	   .s curPhlId=+$p(^DHCPHARW(phaId),"^",3)  ;PHA_PHL_DR
	   .q:curPhlId'=phlId
	   .s phaPrescNo=""
	   .s phaPrescNo=$p(^DHCPHARW(phaId),"^",16)  ;Pha_PrescNo
	   .q:phaPrescNo'=prescNo
	   .s phaNoUse=$p(^DHCPHARW(phaId),"^",7)  ;PHA_NOUSER,无用户是作废的
	   .//s phaFinFlag=$p(^DHCPHARW(phaId),"^",6)  ;PHA_FINFLAG,完成,发药第一次置1  //ypz rem
	   .s $p(^DHCPHARW(phaId),"^",6)=1  //ypz
    i phaNoUse="1" q -1
    //i phaFinFlag="1" q -2  //ypz rem
	&sql(insert into SQLUSER.dhc_phdispen(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_php_pydr,phd_php_fydr,phd_phl_dr,
	         phd_phw_dr,phd_pydate,phd_fydate,phd_pytime,phd_fytime,phd_prescno,phd_pattype)
	     values(:prtdate,:prtId,:papmidr,:pyPhpId,:fyPhpId,:phlId,:phwId,:curDate,:curDate,:curTime,:curTime,:prescNo,:phwpos))
	i SQLCODE q 200
	s curPhaId=+$g(%ROWID)
    //s ^ypzTmp(200)=curPhaId
	
	/*s phaId=""
	f  s phaId=$o(^DHCPHARi("PRT",prtId,phaId)) q:phaId=""  d
	   .s phldr=""
	   .s phldr=+$p(^DHCPHARW(phaId),"^",3)
	   .q:phldr'=phlId
	   .q:+$p(^DHCPHARW(phaId),"^",4)'=phwId
	   .s phaPrescNo=""
	   .s phaPrescNo=$p(^DHCPHARW(phaId),"^",16)
	   .q:phaPrescNo'=prescNo
	   .s $p(^DHCPHARW(phaId),"^",8)="1"
	   .s $p(^DHCPHARW(phaId),"^",11)=curDate
	   .s bci="0"
	   .f  s bci=$o(^DHCBCI(0,"INV",prtId,bci)) q:(bci="")!(bci="0")  d
	     ..s patbill=""
	     ..s patbill=+$p(^DHCBCI(bci),"^",2)
	     ..s patbillsub="0"
	     ..s m=0
	     ..f  s patbillsub=$o(^DHCPB(patbill,"O",patbillsub)) q:(patbillsub="")!(patbillsub="0")  d
	        ...s orditm="",oeordId="",oeoriSub="",dispflag="",invprescno=""
	        ...s orditm=$p(^DHCPB(patbill,"O",patbillsub),"^",4)
	        ...s oeordId=$p(orditm,"||",1),oeoriSub=$p(orditm,"||",2)
	        ...s recplocdr=""
	        ...s recplocdr=+$p(^OEORD(oeordId,"I",oeoriSub,3),"^",6)
	        ...q:recplocdr=""
	        ...q:recplocdr'=ctlocId 
	        ...s dispflag=$p($g(^OEORD(oeordId,"I",oeoriSub,6)),"^",7)
	        ...s invprescno=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",14)
	        ...q:invprescno=""
	        ...q:invprescno'=prescNo
	        ...s qty=0,money=0
	        ...s qty=+$p(^DHCPB(patbill,"O",patbillsub),"^",5)
	        ...s money=+$p(^DHCPB(patbill,"O",patbillsub),"^",8)
	        ...q:(dispflag="1")
	        ...s m=m+1
	  	    ...&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_qty,phdi_payamount,phdi_oeori_dr) 
	             values(:curPhaId,:m,:qty,:money,:orditm))*/ //ypz rem
	//ypz begin
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	
	s oeoriId=oeordId_"||"_oeoriSub
	s pbId=0,pboSub=""
	s pbId=$o(^DHCPBi(0,"OEORI",oeoriId,""))
	q:pbId="" -2
	q:$p(^DHCPB(pbId),"^",16)'="P" -2
	s pboSub=$o(^DHCPBi(0,"OEORI",oeoriId,pbId,""))
	q:pboSub="" -2

	s dispFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,6)),"^",7)
	
	s qty=+$p(^DHCPB(pbId,"O",pboSub),"^",5)
	q:qty=0 0
	s totalAmount=+$p(^DHCPB(pbId,"O",pboSub),"^",8)
	
	s tmpOreSub=0,totalTimes=0
	f  s tmpOreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",tmpOreSub)) q:tmpOreSub=""  d
	    .s totalTimes=totalTimes+1	
	q:totalTimes=0 0
	s execQty=qty/totalTimes
	s execAmount=totalAmount/totalTimes
	//q:(dispFlag="1") "-1"  //rollback??  //ypz 060903
	s pbdiSub=1,oeoriId=oeordId_"||"_oeoriSub
	&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_qty,phdi_payamount,phdi_oeori_dr,PHDI_Oeore_Dr) 
	             values(:curPhaId,:pbdiSub,:execQty,:execAmount,:oeoriId,:oeoreId))
    //s ^ypzTmp(202)=SQLCODE //w " //upd SQLCODE="_SQLCODE
 //ypz end
 q SQLCODE
}

ClassMethod UpdatePyd(itmjs As %Library.String = "", itmjsex As %Library.String = "", prtId As %Library.String = "", phlId As %Library.String = "", pPhpId As %Library.String = "", fPhpId As %Library.String = "", prescNo As %Library.String = "", sPhpId As %Library.String = "", oeoreId As %Library.String = "")
{
	s curDate=$p($h,",",1),curTime=$p($h,",",2)
	s ctlocId=+$P(^DHCPHLOC(phlId),"^",1)
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phlId),"^",6)
	i cyflag="1"  d
	  .s pyPhpId=sPhpId,fyPhpId=pPhpId,shPhpId=fPhpId
	e  d
	  .s pyPhpId=pPhpId,fyPhpId=fPhpId,shPhpId=sPhpId
	s userId=+$p(^DHCPHPER(pyPhpId),"^",5)
	s phdId=""
	f  s phdId=$o(^DHCPHDISPi("PRT",phlId,prtId,phdId)) q:phdId=""  d
	  .s phdPrescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	  .q:phdPrescNo'=prescNo
	  .s phdiSub=""
	  .f  s phdiSub=$o(^DHCPHDI(phdId,"PHDI",phdiSub)) q:phdiSub=""  d
	    ..s curOreId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",11) //ypz
	    ..q:curOreId'=oeoreId  //ypz 按执行走
        ..s qty=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",4)
	    ..s retQty=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",6)
	    ..i retQty=qty q
	    ..s $p(^DHCPHDISP(phdId,1),"^",6)="1"  //配药标志
	    ..//s $p(^DHCPHDISP(phdId,1),"^",7)=curTime //ypz rem 
	    ..//s $p(^DHCPHDISP(phdId,1),"^",3)=pyPhpId
	    ..//s $p(^DHCPHDISP(phdId,1),"^",2)=fyPhpId
	    ..//s $p(^DHCPHDISP(phdId,1),"^",16)=shPhpId
	    ..s oeoriId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",5)
	    ..s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	    ..s phcduId="" s phcduId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
	    ..i phcduId'=0  s phcduFactor=+$p(^PHCDU(phcduId),"^",2)
	    ..i cyflag="1"  d
	      ...s $p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",9)=phcduFactor
	    ..s itmmast=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2) 
	    ..s purUomId=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),8),"^",14)
	    ..s inciId=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	    ..q:inciId=""
	    ..s basUomId=+$p(^INCI(inciId,1),"^",10)
	    ..s padiId=phdId_"||"_phdiSub
	    ..s gclb=0
	    ..k ^TMPGETCLB($j)
	    ..d ##CLASS(web.DHCOutPhDisp).GInclb(inciId,qty,ctlocId)
	    ..d ##CLASS(web.DHCOutPhDisp).InsertPhdisItmClb(padiId)
	    ..d ##CLASS(web.DHCOutPhModCZ).ModPhdispitm(padiId,userId)
   	s phaId=""
   	f  s phaId=$o(^DHCPHARi("PRT",prtId,phaId)) q:phaId=""  d
	   .s phldr=+$p(^DHCPHARW(phaId),"^",3)
	   .q:phldr'=phlId
	   .s phaPrescNo=""
	   .s phaPrescNo=$p(^DHCPHARW(phaId),"^",16)
	   .q:phaPrescNo'=prescNo
	   .s $p(^DHCPHARW(phaId),"^",6)="1"
   q 0
}

ClassMethod DoReturn(ctlocId As %Library.String = "", userId As %Library.String = "", phdiId As %Library.String = "", rfr As %Library.String = "", newprt As %Library.String = "", winpos As %Library.String = "", userInit As %Library.String = "")
{
    s curDate=$p($h,",",1),curTime=$p($h,",",2) 
	s shPhpId=""
	i userInit'="" d
	    .s shUsrId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userInit),""))
        .s shPhpId=$o(^DHCPHPERi("USR",shUsrId,"")) //审核人
	s phdId=$p(phdiId,"||",1),phdiSub=$p(phdiId,"||",2)
	s retStr="0"
    s phlId=$o(^DHCPHLOCi("LOC",ctlocId,""))
	s prtId=+$p(^DHCPHDISP(phdId),"^",2)
	s invNo=$p(^DHCINVPRT(prtId),"^",14)
    s phpId=$o(^DHCPHPERi("USR",userId,""))
    i phpId="" q retStr
    &sql(insert into sqluser.dhc_phreturn(phret_date,phret_inv,phret_phl_dr,phret_phd_dr,phret_prt_dr,phret_php_dr, 
	      phret_rfr_dr,phret_time,phret_newprt_dr,phret_type,phret_shphp_dr)  values(:curDate,:invNo,:phlId,:phdId,:prtId,:phpId,:rfr,:curTime,:newprt,:winpos,:shPhpId))
	i SQLCODE'=0  s retStr="0"
	e  s retStr=+$g(%ROWID)
 q retStr
}

ClassMethod DoRetItm(phretId As %Library.String = "", phdiId As %Library.String = "")
{
	s phrtiSub=$o(^DHCPHRTI(phretId,"RTI",""),-1)+1
	s curDate=$p($h,",",1)
	s phdId=$p(phdiId,"||",1),phdiSub=$p(phdiId,"||",2)
	s phpId=+$p(^DHCPHRET(phretId),"^",8)
	s userId=+$p(^DHCPHPER(phpId),"^",5)
	s retAmount=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",3) //ypz same
	s retQty=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",4) //ypz same
	s basUomId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",8) //ypz same
	s oeoreId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",11)  //ypz
	s prtId=+$p(^DHCPHDISP(phdId),"^",2)
	s invNo=$p(^DHCINVPRT(prtId),"^",14)
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=oeordId_"||"_oeoriSub
	////s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)      ;arc_itmmast
	////s arcimSub=$p(itmmast,"||",1),arcimVer=$p(itmmast,"||",2)
	////s inciId=$o(^INCI(0,"ARCIM_DR",arcimSub,inciId))
	////q:inciId=""
	////s phuomId=$p(^ARCIM(arcimSub,arcimVer,8),"^",14)
	////q:phuomId=""
	////s purUomId=+$p(^INCI(inciId,3),"^",6)  //INCI_CTUOM_Purch_DR
	//s basUomId=+$p(^INCI(inciId,1),"^",10)  //INCI_CTUOM_DR
	////s confac=1
	////i purUomId'=basUomId  d
	////    .s ctcfId=$o(^CT("CTCF",0,"UOM",phuomId,basUomId,ctcfId))
	////    .s confac=+$p(^CT("CTCF",ctcfId),"^",3)
	////i retUomId'=basUomId d  //??
	////    .s retQty=retQty*confac
	//s retQty=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",4)
	s $p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",6)=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",6)+retQty
    &sql(insert into sqluser.dhc_phretitm(phrti_phret_parref,phrti_amount,phrti_childsub,phrti_oeori_dr,phrti_retqty,phrti_unit_dr)
	     values(:phretId,:retAmount,:phrtiSub,:oeoriId,:retQty,:basUomId))
	i SQLCODE'=0 q -1
	s err=0
	s bas=1
	s basqty=retQty
	s retReason=$p(^DHCPHRET(phretId),"^",13)
	s lqty=basqty
	s err=##CLASS(DHCOutPhReturn).UpdatPhdinclb(phdiId,basqty)
	//s oeoreSub="0"
	//f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="0")!(oeoreSub="")  d
	//  .s dspSub="0"
	//  .f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")!(dspSub="0")  d
	//    ..s clbqty=0,myqty=0,retQty=0
	//    ..q:lqty=0
	//    ..s dspId=oeordId_"||"_oeoriSub_"||"_oeoreSub_"||"_dspSub
	//    ..s clbqty=+$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",1)
	//    ..s maxRetQty=clbqty-$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",7)
	//    ..q:maxRetQty<1
	//    ..i maxRetQty<lqty s lqty=maxRetQty
	//    ..s err=##CLASS(DHCSTPHARETURN).ReturnDisp(dspId,lqty,retReason)
	s err=##class(web.DHCOutPhModCZ).ModPhReturn(phretId,phrtiSub,userId,phdiId)
 q 0
}

ClassMethod ReturnDispensing(oeoreStr As %Library.String = "")
{
  //??无用户??
	s retReason=""  //????或是给一默认值:1??
	s retStr=""
	s num=$l(oeoreStr,"^")
	f i=1:1:num
	{
		q:(retStr'="")&(retStr'=0)
		s oeoreId=$p(oeoreStr,"^",i)
		q:oeoreStr=""
		s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
		s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
        s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
        q:phlId=""  //not affect
        s execFlag=$p(^DHCPHLOC(phlId),"^",7)
        i execFlag'=1 q  //非执行科室的药房
		s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8) //ypz 060707自备药
    	i oecprId=""  s retStr="无医嘱优先级!" q
    	s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
    	i (oecprDesc["自备药") s retStr="自备药不能退大型制剂!" q

		s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
		s ordStatDesc=""
		i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
		i ordStatDesc["停止" q
		s oeoreSub=0,retTimes=0,totalTimes=0
		f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	   		.s totalTimes=totalTimes+1
	   		.i $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)="" d
	        	..s retTimes=retTimes+1
		i retTimes<1 q 
		s oeoreSub=0
		f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
		    .s dspSub=0
	    	.f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
	        	..s formerRetQty=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",7)
	        	..i formerRetQty>0 s retStr=-1 q //不允许退两次
	        	..s dspStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)
	        	..m ^ypzTmp(24,oeoriSub,oeoreSub,dspSub)=dspStr
	        	..i $p(dspStr,"^",6)="P" s retStr="未发药,请直接去收费处退钱!" q
	        	..s totalQty=+$p(dspStr,"^",1)
	        	..s retQty=totalQty*retTimes/totalTimes
	        	..s maxRetQty=totalQty-formerRetQty
	        	..q:maxRetQty<1
	        	..s dspId=oeordId_"||"_oeoriSub_"||"_oeoreSub_"||"_dspSub
	        	..i maxRetQty<retQty s retQty=maxRetQty
	        	..s err=..ReturnDisp(dspId,retQty,retReason)
	        	..s retStr=SQLCODE
	}
    q retStr
}

ClassMethod ReturnDisp(oedis, qty, retreason As %String) As %String
{
	q:$g(oedis)="" -1
	s ord=+oedis,itm=$p(oedis,"||",2),exe=$p(oedis,"||",3),dis=$p(oedis,"||",4)
	s s=$g(^OEORD(ord,"I",itm,"X",exe,"D",dis))
	q:s="" -2
	s dispedqty=+$p(s,"^",1)                ;dispensed qty
	s returnedqty=+$p(s,"^",7)              ;returned qty
	s returnable=dispedqty-returnedqty      ;the qty allowed to return
	q:returnable'>0 -3                       ;if returnable is negative then quit
	q:returnable<qty -4    
	;         
	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	;
	s err=$$select^MVBOEDIS(oedis),PLIST(11)=qty+returnedqty
	s err=$$update^MVBOEDIS(oedis)
	;Update OE_OrdItem Which will be used when bill this oeitm
	s oeitm=ord_"||"_itm            ;oe_orditem rowid
	s err=$$select^MVBOEITM(oeitm) 
	s PLIST(91)=qty+returnedqty         ;OEORI_RefundQty
	s PLIST(95)=retreason       ;OEORI_ReasonRefund_DR - 
	s PLIST(96)="Y"          ;OEORI_ReturnToStock
	s err=$$update^MVBOEITM(oeitm) 
	zn oldnamespace  ; Restore the namespace
	
	q 0
}

ClassMethod CompData()
{
	s rowid=0
	f  s rowid=$o(^DHCCardBack(rowid)) q:rowid=""  d
	    .s str=^DHCCardBack(rowid)
	    .//s $p(str,"^",3)=""
	    .s astr=$p(str,"^",1,12)
	    .s str1=$g(^DHCCARD("CF",+rowid+4))
	    .s astr1=$p(str1,"^",1,12)
	    .i astr1="" w astr
	    .i astr'[astr1  w "."  //,str
	    .e  w !,astr,!,astr1
	q 0
}

ClassMethod ProperCareProv(locId, needCtcptType, queryTypeCode, oeoriId)
{
    n (locId,needCtcptType,queryTypeCode,oeoriId)
    q:oeoriId="" -1
    s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
    s linkDoc="N"
    s admId=+^OEORD(oeordId)
    q:admId=0 -2
    q:locId="" -3
	q:queryTypeCode="" -4
	i (needCtcptType'="") {
   		s userId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    	q:userId="" -5
		s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
		q:(ctcpId="") -6
    	s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
		q:(ctcptId="") -7
    	s ctcptType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
		q:(ctcptType'=needCtcptType) -8
	}

	s ctcpLocIdStr=""
	s queryCodeStr=$g(^DHCCLSet("ExecOPMain",queryTypeCode))
	i (queryCodeStr'="") d
	    .f i=1:1:$l(queryCodeStr,"^") d
	        ..s subLocId=$g(^DHCCLSet("ExecOPSub",$p(queryCodeStr,"^",i)))
	        ..q:subLocId=""
	        ..s tmpLocIdStr=##Class(web.DHCCLCom).GetLinkLocId(subLocId)
	        ..i tmpLocIdStr'="" s subLocId=subLocId_"^"_tmpLocIdStr
	        ..i ctcpLocIdStr'="" s ctcpLocIdStr=ctcpLocIdStr_"^"
	        ..s ctcpLocIdStr=ctcpLocIdStr_subLocId
    w ctcpLocIdStr,!
    s admLocId=$p(^PAADM(admId),"^",4)
    i ("^"_ctcpLocIdStr_"^")[("^"_admLocId_"^") s linkDoc="Y" 
    //q:ctcpLocIdStr="" -4 //治疗组未关联科室
	//s wardCtlocId=$p($g(^PAWARD(wardId)),"^",5)
	
	
	
	//s docLocId=""
	//f  s docLocId=$o(^RB("RES",0,"CTPCP",ctcpId,docLocId)) q:docLocId=""  d
	//	.i ("^"_ctcpLocIdStr_"^")[("^"_docLocId_"^") s linkDoc="Y"
 q linkDoc
}

}
