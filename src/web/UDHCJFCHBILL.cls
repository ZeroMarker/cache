Import SQLUser

Class web.UDHCJFCHBILL Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 16;

ClassMethod dispensing(price, qty, oeitm)
{
	
	n (price,qty,PLIST,oeitm)
	s patshare=$g(PLIST(10)),insshare=$g(PLIST(11))
	s rqty=0
	s l1="" f  s l1=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",l1)) q:l1=""  d
	.s l2="" f  s l2=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",l1,"D",l2)) q:l2=""  d
	..s DisROW=^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",l1,"D",l2)
	..s rqty=rqty+$p(DisROW,"^",7)  ;return qty
	s patshare=-(price*rqty)
	s insshare=-(price*rqty)
	;s:+PLIST(10)'=0 PLIST(10)=PLIST(10)-patshare
	;s:+PLIST(11)'=0 PLIST(11)=PLIST(11)-insshare
	;w !,"return qty: "_$g(rqty)
	q patshare_"^"_insshare_"^"_rqty
}

ClassMethod dispensingo(price, qty, oeitm)
{
	n (price,qty,PLIST,oeitm)
	s patshare=$g(PLIST(10)),insshare=$g(PLIST(11))
	s rqty=0
	s packstatus="N"      
	s l1="" f  s l1=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",l1)) q:l1=""  d
	.i +$d(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",l1,"D"))=0 q
	.s l2="" f  s l2=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",l1,"D",l2)) q:l2=""  d
	..s packstatus="Y"
	..s DisROW=^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",l1,"D",l2)
	..s pstat=$p(DisROW,"^",6)
	..;i pstat="P" s rqty=rqty+$p(DisROW,"^",1)  ;return qty
	..i pstat="C" s rqty=rqty+$p(DisROW,"^",7)  ;return qty 
	s patshare=-(price*rqty)
	s insshare=-(price*rqty)
	;s ^SMLdiso(oeitm)=rqty
	if packstatus="N" s rqty="NP" 
	q patshare_"^"_insshare_"^"_rqty
}

}
