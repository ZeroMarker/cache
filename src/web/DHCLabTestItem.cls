Class web.DHCLabTestItem Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

ClassMethod GetTCUnits(TCRowId As %String) As %String
{
	s TCRowId=$g(TCRowId)
	i '$l(TCRowId) q ""
	s labno=$p(TCRowId,"||",1)
	s ts=$p(TCRowId,"||",2)
	s tscnt=$p(TCRowId,"||",3)
	s tc=$p(TCRowId,"||",4)
	s date=$P(^TEPI(labno,1,ts,tscnt),"\",4)
	i '$l(date) s date=+$h
	q ..Units(tc,date)
}

ClassMethod Units(tc As %String, date As %String) As %String
{
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s last=$o(^TTAB("TC",tc,6,""),-1)
  s unit=$p(^TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^TTAB("TC",tc,6,date)) q $p(^TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^TTAB("TC",tc,6,last),"\",1)
}

/// 项目正常参考范围
ClassMethod GetTCRefRanges(TCRowId As %String) As %String
{
	s labno=$p(TCRowId,"||",1)
	s ts=$p(TCRowId,"||",2)
	s tscnt=$p(TCRowId,"||",3)
	s tc=$p(TCRowId,"||",4)
	s date=$P(^TEPI(labno,1,ts,tscnt),"\",4)
	s spec=$p(^TEPI(labno),"\",3)
	s age=$p(^TEPI(labno),"\",25)
	s ptype="0" ;$p(^TEPI(labno),"\",48)
	s cond=$p(^TEPI(labno,0),"\",17)
	s (pregn,loc,mi,weeks)=""
	i '$l(date) s date=+$h
	s retranges=""
	s refranges=..ranges(tc,age,spec,pregn,ptype,date,cond,loc,mi,weeks)
	i '$l(refranges) s retranges=..GetMultiScope(tc,labno,date)
	e  s retranges=$p(refranges,$c(1),1)_"-"_$p(refranges,$c(1),2)
	q retranges
}

/// 项目的所有范围值
ClassMethod GetTCAllRanges(TCRowId As %String) As %String
{
	s labno=$p(TCRowId,"||",1)
	s ts=$p(TCRowId,"||",2)
	s tscnt=$p(TCRowId,"||",3)
	s tc=$p(TCRowId,"||",4)
	s date=$P(^TEPI(labno,1,ts,tscnt),"\",4)
	s spec=$p(^TEPI(labno),"\",3)
	s age=$p(^TEPI(labno),"\",25)
	s ptype="0" ;$p(^TEPI(labno),"\",48)
	s cond=$p(^TEPI(labno,0),"\",17)
	s (pregn,loc,mi,weeks)=""
	i '$l(date) s date=+$h
	s refranges=..ranges(tc,age,spec,pregn,ptype,date,cond,loc,mi,weeks)
	s (NormalRanges,PanicRanges,UnaccRanges)=""
	i $l(refranges){
		s ranges1=refranges
		s reslow=$p(ranges1,$c(1),1),reshigh=$tr($p(ranges1,$c(1),2)," ")
		i $l(reshigh) s NormalRanges=reslow_"-"_reshigh
		i '$l(reshigh) s NormalRanges=reslow
		;panic unaccept
		s resPaniclow=$p(ranges1,$c(1),3),resPanichigh=$tr($p(ranges1,$c(1),4)," ")
		i $l(resPanichigh) s PanicRanges=resPaniclow_"-"_resPanichigh
		i '$l(resPanichigh) s PanicRanges=resPaniclow
		s resUnAcceptlow=$p(ranges1,$c(1),9),resUnAccepthigh=$tr($p(ranges1,$c(1),10)," ")
		i $l(resUnAccepthigh) s UnaccRanges=resUnAcceptlow_"-"_resUnAccepthigh
		i '$l(resUnAccepthigh) s UnaccRanges=resUnAcceptlow
	}
	i '$l(refranges) s NormalRanges=..GetMultiScope(tc,labno,date)
	q NormalRanges_$c(2)_PanicRanges_$c(2)_UnaccRanges
}

/// 项目参考范围
ClassMethod ranges(tc, age, spec, pregn, ptype, date, cond, loc, mi, weeks) As %String
{
	n j,x,xf,age0,type,PLIST,exist,result,format 
	s result=""
 	s tc=$g(tc),age=$g(age),spec=$g(spec),pregn=$g(pregn),ptype=$g(ptype),date=$g(date),cond=$g(cond),loc=$g(loc),mi=$g(mi),weeks=$g(weeks)
	 ;sex age------------------------
 	i age="" s age="0"
 	i $g(spec)="" s spec="M"
 	;--------------------------------
 	s format="" 
 	&sql(select CTTC_ResultFormat into :format from lab.CT_TestCode where CTTC_Code=:tc)
 	s format=$p(format,$c(1))
 	i '$l(date) s date=+$h
 	i '$d(^TTAB("TC",tc,4,date)) s date=$o(^TTAB("TC",tc,4,date),-1)
 	i $l(date) d
 	.f type=ptype,$e(ptype) i $d(^TTAB("TC",tc,4,date,type)) d  q
 	..k xf s x="" f  s x=$o(^TTAB("TC",tc,4,date,type,x)) q:x=""  d
 	...i $l($p(^(x),"\",23)),'$l(age) q
 	...i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
 	...i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
 	...i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
 	...i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
 	...i $l($p(^(x),"\",24)),$p(^(x),"\",24)'=loc q
 	...i $l($p(^(x),"\",25)),'$l(age) q
 	...i $l($p(^(x),"\",25)),weeks<$p($p(^(x),"\",25),"-",1) q
 	...i $l($p(^(x),"\",25)),weeks>$p($p(^(x),"\",25),"-",2) q
 	...s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23)))+(''$l($p(^(x),"\",24)))+(''$l($p(^(x),"\",25))),xf(xf,x)=^(x)
 	..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
 	...s (aaLow,aaHigh,aaPLow,aaPHigh)=""
 	...i $l(mi) s rowid=tc_"||"_date_"||"_type_"||"_x_"||"_mi i '$$select^LVBCTTCG(rowid) d
 	....s aaLow=PLIST(3),aaHigh=PLIST(4),aaPLow=PLIST(5),aaPHigh=PLIST(6)
 	...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 	...i $l(aaLow)!$l(aaHigh) s $p(xx,"\",3)=aaLow,$p(xx,"\",4)=aaHigh
 	...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
 	....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
 	....i 'exist d
 	.....s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 	.....i $l(aaPLow)!$l(aaPHigh) s $p(xx,"\",3)=aaPLow,$p(xx,"\",4)=aaPHigh
 	...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
 	f j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $l(x) d
 	.i ($e(x)="<")!($e(x)=">") d  q
 	..s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))
 	..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 	.s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 	.i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
 	q result
}

ClassMethod GetMultiScope(ItemCode, LabNo, date) As %String
{
	n (ItemCode,LabNo,date)
   	s ItemCode=$g(ItemCode),LabNo=$g(LabNo),date=$g(date)
   	s conditions=""
   	s conditions=$P($g(^TEPI(LabNo,0)),"\",17)
   	i conditions'="" q ""
   	s Scopy=""
   	i '$l(date) s date=+$h
   	i '$d(^TTAB("TC",ItemCode,4,date)) s date=$o(^TTAB("TC",ItemCode,4,date),-1)
   	i $l(date) d
   	.s num=1
   	.s ord="" f  s ord=$o(^TTAB("TC",ItemCode,4,date,0,ord)) q:ord=""  d
   	..i $p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)'="" d
   	...s clc=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)
   	...s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   	...i (num#2)=0 d
   	....s Scopy=Scopy_temrange_$c(10,13)
   	...e  d
   	....s Scopy=Scopy_temrange_$c(32)
   	...s num=num+1
   q Scopy
}

}
