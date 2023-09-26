Class web.DHCLabTestCode Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别,Pregn:怀孕(0),PatientType:病人类型(0\0-IN),Date:日期,Cond:临床条件(0),Loc:0,mi:1\2,Weeks:周(0)
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Pregn As %String = "", PatientType As %String = "0", Date As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "1", Weeks As %Integer = "") As %String
{
 Set (j,x,xf,age0,type,exist,result,format)=""
 Set result=""
 Set tc=$g(TestCode),age=$g(Age),spec=$g(Species),pregn=$g(Pregn),ptype=$g(PatientType),date=$g(Date),cond=$g(Cond),loc=$g(Loc),mi=$g(mi),weeks=$g(Weeks)
 ;
 If '$l(age) Set age=20
 If '$l(spec) Set spec="M"
 ;;
 Set format=$p($g(^TTAB("TC",tc)),"\",3)
 i '$l(date) s date=+$h
 i '$d(^TTAB("TC",tc,4,date)) s date=$o(^TTAB("TC",tc,4,date),-1)
 i $l(date) d
 .For type=ptype,$e(ptype) i $d(^TTAB("TC",tc,4,date,type)) d  q
 ..k xf s x="" f  s x=$o(^TTAB("TC",tc,4,date,type,x)) q:x=""  d
 ...i $l($p(^(x),"\",23)),'$l(age) q
 ...i $l($p(^(x),"\",23)),$l($p(^(x),"\",23),"-")'>1 Set $p(^(x),"\",23)="0-"_$p(^(x),"\",23) //如果年龄只有最大值，则改为“0-最大值”的格式
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
 ...//i $l(mi) s rowid=tc_"||"_date_"||"_type_"||"_x_"||"_mi i '$$select^LVBCTTCG(rowid) d
 ...//.s aaLow=PLIST(3),aaHigh=PLIST(4),aaPLow=PLIST(5),aaPHigh=PLIST(6)
 ...i $l(mi) d Select 
 ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 ...i $l(aaLow)!$l(aaHigh) s $p(xx,"\",3)=aaLow,$p(xx,"\",4)=aaHigh
 ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
 ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
 ....i 'exist d
 .....s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 .....i $l(aaPLow)!$l(aaPHigh) s $p(xx,"\",3)=aaPLow,$p(xx,"\",4)=aaPHigh
 ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
 For j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $l(x) d
 .i ($e(x)="<")!($e(x)=">") d  q
 ..//s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))   ///20130603 huhm解决参考范围中≤问题
 ..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 .s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 .i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
 Quit result
 
Select
 set tc=$g(tc),date=$g(date), type=$g(type),x=$g(x),mi=$g(mi),ValDeli="\"
 If $Data(^TTAB("TC",tc,4,date,type,x,mi))=0 Quit
 Set rangesAAStr=^TTAB("TC",tc,4,date,type,x,mi)
 Set aaLow=$Piece(rangesAAStr,ValDeli,1)
 Set aaHigh=$Piece(rangesAAStr,ValDeli,2)
 Set aaPLow=$Piece(rangesAAStr,ValDeli,3)
 Set aaPHigh=$Piece(rangesAAStr,ValDeli,4)
 Quit
}

/// 获取检验项目的异常标记
/// TestCode:检验项代码，TCResult:检验结果，TCRanges：检验项范围值（默认为空）
ClassMethod GetAbnorFlag(TestCode As %String, TCResult As %String, TCRanges As %String = "") As %String
{
	Set FormatFlag=""
	//Set currNS=$znspace
	Set:$Data(^TTAB("TC",TestCode))'=0 FormatFlag=$Piece(^TTAB("TC",TestCode),"\",3)
	Quit:FormatFlag=""!TCResult=""!TestCode="" ""
	Set:TCRanges="" PType="0",TCRanges=..GetTCRanges(TestCode, "","", "", PType, "", "", "", "1","")
	s ^TMPTCC(TestCode,1)=TCResult_","_TCRanges
	Set AbnorFlag=$Select(FormatFlag["N":$$GetAbnorFlagByNum(TCResult,TCRanges),FormatFlag["S":$$GetAbnorFlagByStCommen(TestCode,TCResult),FormatFlag["X":$$GetAbnorFlagByFreeText(TestCode,TCResult),1:"")
	If '$l(AbnorFlag) Set AbnorFlag=$c(28)_"N"
	s ^TMPTCC(TestCode,2)=FormatFlag_","_AbnorFlag
	//Set $znspace=currNS
	Quit AbnorFlag
	
	 ;数据型
GetAbnorFlagByNum(TCResult,TCRanges)
	s TCResult=$g(TCResult),TCRanges=$g(TCRanges)
	s (retvalue,retranges,retcolor)=""
	s retflag="N",lowflag="L",highflag="H"
	s reslow=$p(TCRanges,$c(1),1),reshigh=$p(TCRanges,$c(1),2)
	;panic unaccept
	s resPaniclow=$p(TCRanges,$c(1),3),resPanichigh=$p(TCRanges,$c(1),4)
	s resUnAcceptlow=$p(TCRanges,$c(1),9),resUnAccepthigh=$p(TCRanges,$c(1),10)
	;i TCRanges="" q ""
	i $l(TCRanges,$c(10))>1 q retvalue_$c(28)_retflag
	Set TCResult=$$res(TCResult) //$tr(TCResult,"><") 结果中大于号和小于号处理 20120328 huhm
	i TCRanges="" q retvalue_$c(28)_retflag
	i '$ISVALIDNUM(TCResult) q retvalue_$c(28)_retflag
	;UnAccept check
	s rang=resUnAcceptlow_resUnAccepthigh
	i $l(rang) d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resUnAcceptlow s retvalue=lowflag,retflag="U" q
	..i TCResult>resUnAccepthigh s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=lowflag,retflag="U" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=highflag,retflag="U" q
	;Panic check
	s rang=resPaniclow_resPanichigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resPaniclow s retvalue=lowflag,retflag="M" q
	..i TCResult>resPanichigh s retvalue=highflag,retflag="M" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..;i TCResult<lowvalue s retvalue=lowflag,retflag="M" q
	..i TCResult>lowvalue s retvalue=highflag,retflag="M" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..;;i TCResult>highvlaue s retvalue=highflag,retflag="M" q
	..i TCResult<highvlaue s retvalue=lowflag,retflag="M" q
	;normal check
	s rang=reslow_reshigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<reslow s retvalue=lowflag,retflag="L" q
	..i TCResult>reshigh s retvalue=highflag,retflag="H" q
	.i (rang["<") d
	..s lowflag=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowflag s retvalue=highflag,retflag="H" 
	.i (rang[">") d
	..s highflag=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highflag s retvalue=lowflag,retflag="L"	
	q retvalue_$c(28)_retflag
	//q retflag
	
	;标准备注型	
GetAbnorFlagByStCommen(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	i '$l(TCResult) q $c(28)_"N"_$c(28,28)
    s retflag="N",retvalue=""
    i $d(^TTAB("TC",TestCode,2,TCResult)) d
    .s retflag=$p(^TTAB("TC",TestCode,2,TCResult),"\",1)
    .i retflag="A" s retvalue="*"
    .i $p(^TTAB("TC",TestCode,2,TCResult),"\",5)="Y" s retvalue="*",retflag="P"
    i '$l(retflag) s retflag="N"
    q retvalue_$c(28)_retflag
    
	;文本类型
GetAbnorFlagByFreeText(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
    s retflag="N",retvalue=""
    s temstr=""
    s std="" f  s std=$o(^TTAB("TC",TestCode,2,std)) q:(std="")!(retflag="P")  d
    .i $p(^TTAB("TC",TestCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),TCResult[$g(^TTAB("TC",TestCode,2,std,1)) s retvalue="*",retflag="A"
    .i $p(^TTAB("TC",TestCode,2,std),"\",5)="Y" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),itmres=$g(^TTAB("TC",TestCode,2,std,1)) s retvalue="*",retflag="P"
    q retvalue_$c(28)_retflag
    
res(rang) ; check < >
 //20130703 huhm 处理结果中<=,>=
 s rang=$tr(rang,"=")
 //
 i rang[">" s rang=$tr(rang,">")+.00000001
 i rang["<" s rang=$tr(rang,"<")-.00000001
 q rang
}

/// code,name,res,units,ranges
ClassMethod GetTestCodeResult(LabNo As %String, TC As %String, Result As %String, RecDate As %String) As %String
{
	Set retvalue=""
	If '$Data(^TTAB("TC",TC)) Quit retvalue
	Set PatAge=$p(^TEPI(LabNo),"\",25)
	Set PatSpec=$p(^TEPI(LabNo),"\",3)
	Set itmname=$Piece(^TTAB("TC",TC),"\",1)
	Set itmunits=$Piece(^TTAB("TC",TC),"\",2) //$$Units^DHCCTTCU(TC,recdate) ;
	Set itmtype=$Piece(^TTAB("TC",TC),"\",3)
	Set itmres=Result

	If itmtype="V" {  //Micro Pathogen||V 微生物
		Set itemres=Result
		If $Data(^TTAB("BUG",Result)) Set itmres=$Piece(^TTAB("BUG",Result),"\",1)
	}
	If itmtype["N" { //??
		Set decimal=$Extract(itmtype,2)
		If decimal="" Set decimal="0"
		Set itmres=$$CheckResDecimal(Result,decimal)
	}
	///
	If $l(Result),itmtype["S",$Data(^TTAB("TC",TC,2,Result,1)){  //Standard Comment标准意见
		Set itmres=$Piece(^TTAB("TC",TC,2,Result,1),"\",1)
	}
	;血型结果
	If (itmtype="B2"),$l(itmres),$Data(^TTAB("BB-BG",itmres)){
		Set itmres=$Piece(^TTAB("BB-BG",Result),"\",1)
	}
	///参考范围(TestCode, Age , Species, Pregn, PatientType, Date , Cond , Loc, mi, Weeks
	Set RefRanges=..GetTCRanges(TC,PatAge,PatSpec,,,,RecDate)
	Set LRang=$p(RefRanges,$c(1),1)
	Set HRang=$p(RefRanges,$c(1),2)

	If $l(LRang),$l(HRang) Set NormalRanges=LRang_"-"_HRang
	Else  Set NormalRanges=..GetRangeDesc(TC,LRang)  ///20130603 huhm解决参考范围中≤问题

	If '$l(NormalRanges){
		Set NormalRanges=..GetMultiScope(LabNo,TC,RecDate)
	}

	///异常标志
	Set ResFlag=$c(28)_"N"
	Set ResFlag=..GetAbnorFlag(TC,Result,RefRanges)
	
	//得到非数字型项目参考值
	i (itmtype["S")!(itmtype["X") d
	.i $p(^TTAB("TC",TC),"\",7)'="Y" q
	.s NormalRanges=""
	.s stdcode="" f  s stdcode=$o(^TTAB("TC",TC,2,stdcode)) q:stdcode=""  d
	..s flag=$p(^TTAB("TC",TC,2,stdcode),"\",1)
	..i $d(^TTAB("TC",TC,2,stdcode,1)) d
	...i flag="N" s NormalRanges=NormalRanges_$p(^TTAB("TC",TC,2,stdcode,1),"\",1)_"/"
	.s NormalRanges=$p(NormalRanges,"/",1,$l(NormalRanges,"/")-1)
	///实验方法
	s itmmethdr=$p(^TTAB("TC",TC),"\",11),MethodDesc=""
	i itmmethdr'="",$d(^TTAB("METHOD",itmmethdr)) s MethodDesc=$p(^TTAB("METHOD",itmmethdr),"\",1) 	
	
	Set $Piece(retvalue,$Char(2),1)=TC
	Set $Piece(retvalue,$Char(2),2)=itmname
	Set $Piece(retvalue,$Char(2),3)=$TRanslate(itmres,$Char(13,10),"")
	Set $Piece(retvalue,$Char(2),4)=itmunits
	Set $Piece(retvalue,$Char(2),5)=$Piece(ResFlag,$c(28),1)
	Set $Piece(retvalue,$Char(2),6)=NormalRanges //RefRanges
	Set $Piece(retvalue,$Char(2),7)=$Piece(^TTAB("TC",TC),"\",12) //TC Syn
	Set $Piece(retvalue,$Char(2),8)=$Piece(ResFlag,$c(28),2)  //M:Pacnic,U:Unaccept
	Set $Piece(retvalue,$Char(2),9)=MethodDesc
	Quit retvalue
	
  ///得到结果精度
CheckResDecimal(res,dec)
	s res=$g(res),dec=+$g(dec)
	s ret=""
	i res="" q ret
	i dec="" q ret
	s flag=""
    s tres=res
	i ($e(res)="<")!($e(res)=">") s flag=$e(res),res=$tr(res,"<>")
	i ($e(tres,1,2)="<=")!($e(tres,1,2)=">=") s flag=$e(tres,1,2),res=$tr(tres,"<>=")
	i ($e(res)'="-") d ;20081020 liuzf  
	.s res=+res
	.s ret=$fn(res,"",dec)
	e  d
	.s ret=res
	q flag_ret
}

/// 得到项目的临床条件范围
ClassMethod GetMultiScope(LabNo As %String, ItemCode As %String, date As %String) As %String
{
   n (LabNo,ItemCode,date)
   s ItemCode=$g(ItemCode),LabNo=$g(LabNo)
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
   ...s temL=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1)
   ...s temH=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2)
   ...///处理参考范围中≤问题 20130617 huhm
   ...s temrange=^TTAB("CLC",clc)_"("_..GetRangeDesc(ItemCode,temL_"-"_temH)_")"
   ...//i $l(temH) s temrange=^TTAB("CLC",clc)_"("_$j(temL,3,2)_"-"_$j(temH,3,2)_")"
   ...//i '$l(temH) s temrange=^TTAB("CLC",clc)_"("_temL_")"
   ...///
   ...;s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   ...i (num#2)=0 d
   ....s Scopy=Scopy_temrange_$c(10,13)
   ...e  d
   ....s Scopy=Scopy_temrange_$c(32)
   ...s num=num+1
   Quit Scopy
}

/// 得到危急报告说明
ClassMethod GetWarnReportComment(OrderID As %String) As %String
{
	New (OrderID)
	s TSRowId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	i '$l(TSRowId) q ""
	//
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	Set WebNS=$ZUTIL(5)
	zn LabData
	//
	Set LabNo=$p(TSRowId,"||",1)
	Set TS=$p(TSRowId,"||",2)
	Set TSCnt=$p(TSRowId,"||",3)
	s TransDate=$o(^DHCTSTrans(LabNo,TS,TSCnt,""),-1)
	i '$l(TransDate) zn WebNS Quit ""
	s TransTime=$o(^DHCTSTrans(LabNo,TS,TSCnt,TransDate,""),-1)
	i '$l(TransTime) zn WebNS Quit ""
	s TransStr=$g(^DHCTSTrans(LabNo,TS,TSCnt,TransDate,TransTime))
	i '$l(TransStr) zn WebNS Quit ""
	s RetValue=100
	s Status=$p(TransStr,"\",2)
	//警戒报告
	i Status="PNC" s RetValue=0
	//荒诞报告
	i Status="RU" s RetValue=0
	//报告说明
	s TransMemoDr=$p(TransStr,"\",4)
	s TransMemo=""
	if $e(TransMemoDr,1)'="{"{
		s TransMemo=TransMemoDr
	}
	else{
		s TransMemoDr=$p($p(TransMemoDr,"{",2),"}",1)
		i $L(TransMemoDr),$d(^DHCTSTransComment(TransMemoDr)){
			 s TransMemo=$p(^DHCTSTransComment(TransMemoDr),"\",1)
		}
	} 
	zn WebNS
	Quit TransMemo
}

/// Creator：      huhm
/// CreatDate：    20130603
/// Description:： 转换显示的参考范围中的≤,≥问题
/// Table：        
/// Input：        项目代码,参考范围
/// Output：       
/// Return：       显示的参考范围
/// Others：       
ClassMethod GetRangeDesc(tc, ranges)
{
  n (tc,ranges)
  s tc=$g(tc),ranges=$g(ranges)
  s format=$p(^TTAB("TC",tc),"\",3)
  s dec=+$e(format,2,$l(format))
  s Ret=ranges
  s RangeL=$p(ranges,"-",1),RangeH=$p(ranges,"-",2)
  i $e(RangeL,1)="<" d
  .s Range1=$j($e(RangeL,2,$l(RangeL)),0,$e(format,2,4))
  .s Range2=$e(RangeL,2,$l(RangeL))
  .s Ret="≤"_Range1
  .i Range1-Range2=0 s Ret="<"_Range1
  i $e(RangeL,1)=">" d
  .s Range=$j($e(RangeL,2,$l(RangeL)),0,$e(format,2,4))
  .s Ret="≥"_Range
  .i Range-RangeL=0 s Ret=">"_Range  
  q Ret
}

}
