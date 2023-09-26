Import SQLUser

Class web.UDHCJFPBADJUST Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 73;

ClassMethod PBADJUST(PBO, Qty, User)
{
	n (PBO,Qty,User)
	;
    s PBO=$g(PBO)
	q:PBO="" 100
	q:Qty="" 100
	q:+Qty<0 100
	;q:+$g(Qty)=0 100
	s PB=+PBO,ORD=$p(PBO,"||",2)
	s ADM=$p(^DHCPB(PB),"^",1)
	s OEITM=$p(^DHCPB(PB,"O",ORD),"^",4)
	
	s err=..BILLC(ADM,User,PBO,OEITM,Qty)
    q 0
}

ClassMethod BILLC(adm, billuser, PBO, OEITM, Qty)
{
	n (adm,billuser,PBO,OEITM,Qty)
	;
    q:$g(adm)="" 0
	s billuser=$g(billuser)
	s adm=$p(adm,$c(1))
	s billver=$p($g(^CF("SM",1)),"^",12)
	s Conf=$o(^DHCTarC("CF",""))
    k ^TMP("IB",$j)
    ;Get Patient Admission Details
  
	s err=$$select^MVBPAADM(adm) q:err err
	
	i $d(PLIST) m PAADM=PLIST
	s pat=$g(PAADM(3))      ;paadm's PAADM_PAPMI_DR
	s admdep=$p($g(PAADM(5)),$c(1))   ;paadm's PAADM_DepCode_DR
	s admdate=$p($g(PAADM(7)),$c(1))  ;paadm's PAADM_AdmDate
	s admdisdate=$p($g(PAADM(22)),$c(1))  ;paadm's PAADM_DischgDate
	s admdoc=$p($g(PAADM(12)),$c(1))   ;paadm;s PAADM_AdmDocCodeDR
    s admtype=$p($g(PAADM(9)),$c(1))    ;paadm's PAADM_Type
	s pattype=$p($g(PAADM(180)),$c(1))  ;paadm's PAADM_Epissubtype_DR 
	s instype=$p($g(PAADM(181)),$c(1))  ;paadm's PAADM_AdmReason_DR
	
	;Get Patient Details
	s err=$$select^MVBPAPMI(pat) q:err err
	i $d(PLIST) m PAPMI=PLIST
	;get person details
	s err=$$select^MVBPAPER(pat) q:err err
	i $d(PLIST) m PAPER=PLIST 
	s age=$g(PAPER(12))
    s OrdFrom=+$H,OrdEnd=0

    ;Calculate Order        
	s Count=..ORDERS(OEITM)
	
    ;Insert DHC_PatientBill
	d ..PBORD(Count,adm)
    k ^TMP("IB",$j)
	; 
    q 0
}

ClassMethod ORDERS(OEITM)
{
	s Count=0
    s billver=$p($g(^CF("SM",1)),"^",12)
	;s err=$$select^MVBOEIT0(OEITM) 
	&sql(select * into :PLIST() from oe_orditem where oeori_rowid=:OEITM)

    ;Get Order details
	s oeitm=$g(PLIST(1))
	s arcim=$p($g(PLIST(4)),$c(1))
	s billfl=$p($g(PLIST(76)),$c(1))
	;
    s arccode=$p(^ARCIM(+arcim,1,1),"^",1) ;ARC_ItmMast.ARCIM_Code
	s dcdat=$p(PLIST(34),$c(1))            ;OEORI_XDate
	s dctim=$p(PLIST(48),$c(1))            ;OEORI_XTime
	s stdat=$p(PLIST(17),$c(1))            ;OEORI_SttDat
	s sttim=$p(PLIST(18),$c(1))            ;OEORI_SttTim
	s orddate=$p(PLIST(81),$c(1))          ;OEORI_Date
	s prior=$p(PLIST(23),$c(1)),priorcode=$p($g(^OECPR(+prior)),"^")
	s packqty=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",4)
	s uom=$p($g(PLIST(28)),$c(1))
	s drgform=$p(PLIST(4),$c(1),10)
	s dur=$p(PLIST(35),$c(1))              ;OEORI_Durat_DR
	i $g(dur)="",$p(PLIST(4),$c(1),7)="Drug","STAT"'[priorcode d
	.s dur=$p(^PHCD(+drgform,"DF",$p(drgform,"||",2),1),"^",8)
	s freq=$p(PLIST(25),$c(1))             ;OEORI_PHFreq_DR
	s instr=$p(PLIST(27),$c(1))            ;OEORI_Instr_DR
	s billuom=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),8)),"^",14)      ;UOM
	s:+billuom'=0 buomcod=$p($g(^CT("UOM",billuom)),"^")
	s buomcod=$zcvt($g(buomcod),"U")
	s stat=$g(PLIST(10)),statcode=$p($g(^OEC("OSTAT",+stat)),"^")
	;
    s rv=##class(UDHCJFBILL).billgrp(arcim)                          
	s blgrp=$p(rv,"^",1),blsub=$p(rv,"^",2)        ;Bill Group Code, Sub Group Code
	s arcgrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)          ;子类
	s catgrp=$p(^ARC("IC",arcgrp),"^",8)                           ;大类             
	s ordCateType=$p(^ARC("IC",arcgrp),"^",7)                      ;医嘱类型
	s consdoc=$p($g(PLIST(68)),$c(1))
	s oeent=$g(PLIST(3)),arcos=$p($g(PLIST(86)),$c(1)),mainoeent=$g(PLIST(139))
	s oeprice=$p($g(PLIST(79)),$c(1)),admins=$p($g(PLIST(78)),$c(1))
	s ordergrp=$p($g(PLIST(114)),$c(1))
	s oeunipr=$p($g(PLIST(46)),$c(1))                              ;unit price in order entry
	s linkto=$p($g(PLIST(52)),$c(1))
	;
    s BillDate=+$H
	s BillTime=$p($H,",",2)
	;
    ;store order data to golbal ^TMP("IB",$j)
	i $d(PLIST) m ^TMP("IB",$j,"ORDER",oeitm)=PLIST
	s price=##class(UDHCJFBILL).GetItem(adm,pattype,instype,oeitm,arcim,stdat,prior,instr,linkto,oeprice,BillDate,BillTime)
	s ^TMP("IB",$j,"ORDER",oeitm,"PRICE")=price
	s ^TMP("IB",$j,"ORDER",oeitm,"QTY")=Qty
	;
    i orddate<OrdFrom s OrdFrom=orddate
	i orddate>OrdEnd s OrdEnd=orddate
	s Count=Count+1
	;
   q Count
}

ClassMethod PBORD(Count, adm)
{
	i Count'>0 q
	;
    s Tot=0,TotDisc=0,TotIns=0,TotPat=0
	s $ZT="ERROR^DHCSSERR" d ..tb()
	s ORD=""
	f  s ORD=$o(^TMP("IB",$j,"ORDER",ORD)) q:ORD=""  d
	.s err=##class(UDHCJFBILL).PBOADD(PBO,ORD,billuser)
	.s err0=##class(UDHCJFBILL).PBCHG(err,.Tot,.TotDisc,.TotIns,.TotPat)
	s err=##class(UDHCJFBILL).PBUPD(+PBO,billuser,Tot,TotDisc,TotIns,TotPat,+admdate,+admdisdate,instype,pattype,OrdFrom,OrdEnd)
	d ..tc()
	;
    q
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
	i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
