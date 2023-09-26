Class web.DHCSTPCHCOLLS4 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
ClassMethod HandleTrak(incil)
{
 ;n inci,ch,lbch,inclb
 ;n lbqty,dhclbqty,adjqty,pkqty,lpkqty
 ;n ADJI,incicode,incidesc
 n (incil)
 ;
 s inci=+incil,ch=$P(incil,"||",2)
 s $p(^INCI(inci,"IL",ch),"^",10)=0
 s lbch=0
 s i=0,j=0
 w "."_incil
 f  s lbch=$O(^INCI(inci,"IL",ch,"LB",lbch)) q:lbch=""  d
 .s inclb=incil_"||"_lbch
 .s lbqty=$P(^INCI(inci,"IL",ch,"LB",lbch),"^",2)
 .s dhclbqty=##class(web.DHCSTSTKQTY).CurQtyINCLB(inclb)
 .s pkqty="0",pkqty=..GetPkInclbQty("P",+$h-2,+$h,inclb)
 .s lpkqty=lbqty+pkqty
 .i +lpkqty'=dhclbqty  d
 . . i +dhclbqty<0 s dhclbqty=0
 . . s adjqty=dhclbqty-lpkqty
 . . i (adjqty<0)&(-adjqty>lbqty) s adjqty=-lbqty
 . . w adjqty_" \ "
 . . s err=..MakeUpStk(inclb,adjqty)
 . . i $g(err)'=0 d
 . . . s j=j+1
 . . . s incicode=$P(^INCI(inci,1),"^",1)
 . . . s incidesc=$P(^INCI(inci,1),"^",2)
 . . . s ^TMP($j,"INSERTITEM",j)="Insert Item Err: " _inclb_"^"_incicode_"^"_incidesc_"^"_adjqty
 q i
}

ClassMethod MakeUpStk(inclb, bqty) As %String
{
 ; Makeup the Medtrak-stock qty with the DHC-stock qty
 n (inclb,bqty)
 q:(inclb="")!(bqty="") -1
 s inci=$p(inclb,"||",1),ch=$p(inclb,"||",2),lb=$p(inclb,"||",3)
 q:$g(ch)="" -1
 q:$g(lb)="" -1
 s curLbQty=0
 s curLbQty=$p(^INCI(inci,"IL",ch,"LB",lb),"^",2)
 i (bqty+curLbQty)<0 d
 . s ret=..UPDINV1(inclb,-curLbQty)
 e  d
 . s ret=..UPDINV1(inclb,bqty)
 q 0
}

ClassMethod GetPkInclbQty(type, frdate, todate, inclb)
{
 ;s type="P",frdate=+$h-2,todate=$h,locdr="1359",inci="173"
 n intr,date,pointer,dstatus,ord,orditm,ex,dsp,tinclb,stype
 n qty,rqty,inci
 s date=frdate-1,num=0,rqty=0,inci=$p(inclb,"||",1)
 f  s date=$o(^INTR(0,"INCI",inci,date)) q:(date>todate)!(date="")  d
 . s intr=""    ;,rqty=0
 . f  s intr=$o(^INTR(0,"INCI",inci,date,intr)) q:intr=""  d
 .. s stype=""
 .. s stype=$p(^INTR(intr),"^",1) q:stype'=type
 .. s tinclb="",tinclb=$p(^INTR(intr),"^",7) q:tinclb'=inclb
 .. s pointer=""
 .. s pointer=$p(^INTR(intr),"^",9)
 .. s ord="",orditm="",ex="",dsp=""
 .. s ord=$p(pointer,"||",1),orditm=$p(pointer,"||",2),ex=$p(pointer,"||",3),dsp=$p(pointer,"||",4)
 .. q:(ord="")!(orditm="")!(ex="")!(dsp="")
 .. s oeflag="",oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",orditm,1),"^",13)),"^",1) ;医嘱核实?未核实?停止状态
 .. q:oeflag="D"
 .. q:'$d(^OEORD(ord,"I",orditm,"X",ex,"D",dsp))
 .. s dstatus=""
 .. s dstatus=$p(^OEORD(ord,"I",orditm,"X",ex,"D",dsp),"^",6)
 .. q:$g(dstatus)'="P"   ;只取打包的  
 .. s qty=$p(^OEORD(ord,"I",orditm,"X",ex,"D",dsp),"^",1)        ;发药数量
 .. s rqty=rqty+qty
 q rqty
}

ClassMethod UPDINV1(IMILROW, QTY)
{
  ;UPDATE INVENTORY (only quantity without price)
 N (IMILROW,QTY)
 ; Return 1 if OK, 0 if not OK
 S IMILROW=$P(IMILROW,$C(1))
 S QTY=$P(QTY,$C(1))
 S IM=$P(IMILROW,"||",1)
 Q:IM="" 0
 L +^INCI(IM):10
 E  Q 0
 S IMREC=$g(^INCI(IM,1))
 S IMILREC=$g(^INCI(IM,"IL",$P(IMILROW,"||",2)))
 S IMLBREC=$g(^INCI(IM,"IL",$P(IMILROW,"||",2),"LB",$P(IMILROW,"||",3)))
 S IMQTY=$P(IMREC,"^",4)
 S IMILQTY=$P(IMILREC,"^",3)
 S IMLBQTY=$P(IMLBREC,"^",2)
 S $P(IMLBREC,"^",2)=IMLBQTY+QTY
 S $P(IMILREC,"^",3)=IMILQTY+QTY
 S $P(IMREC,"^",4)=IMQTY+QTY
 S ^INCI(IM,1)=IMREC
 S ^INCI(IM,"IL",$P(IMILROW,"||",2))=IMILREC
 S ^INCI(IM,"IL",$P(IMILROW,"||",2),"LB",$P(IMILROW,"||",3))=IMLBREC
 L -^INCI(IM)
 q 1
}
*/
}
