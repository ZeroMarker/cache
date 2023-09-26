Class web.DHCSTPHCMFUNLIBITM Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取函数项目表达式
/// w ##class(web.DHCSTPHCMFUNLIBITM).CheckDrugExist("CheckDrugExist")
ClassMethod CheckDrugExist(code) As %String
{
	New (code,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	/*
	s phflr=$o(^DHCPHFULITM(0,"Code",code,"")) 
	q:phflr="" 1
	s activeflag=$p(^DHCPHFULITM(phflr),"^",6)
	q:activeflag'="Y" 1
	s fundr=+$p(^DHCPHFULITM(phflr),"^",3)
	q:fundr=0 1
	s functions=$p($g(^DHCPHFULIB(fundr)),"^",3)	
	s fun=$p(functions,"(",1)_"("_$p(functions,"(",2)	
	s arguments=$p(^DHCPHFULITM(phflr),"^",4)
	s x="s ret="_fun_"("""_arguments_""")"
   
	x x
	s ret=%ExtraData
	q ret
	
	*/
	
	s thr=""
	f  s thr=$o(^DHCPHFUTHE(0,"Code",code,thr)) q:thr=""  d
	.s sub=""
	.f  s sub=$o(^DHCPHFUTHE(thr,"I",sub)) q:sub=""  d
	..s thri=thr_"||"_sub
	..s itmr=""
	..f  s itmr=$o(^DHCPHFULITM(0,"Theme",thri,itmr)) q:itmr=""  d
	...s fundr=+$p(^DHCPHFULITM(itmr),"^",3)
	...q:fundr=0 
	...s functions=$p($g(^DHCPHFULIB(fundr)),"^",3)	
	...s fun=$p(functions,"(",1)_"("_$p(functions,"(",2)	
	...s arguments=$p(^DHCPHFULITM(itmr),"^",4)
	...s x="s ret="_fun_"("""_arguments_""")"
    ...x x
	s ret=%ExtraData
	q ret
}

/// 检查医嘱项是否存在,
/// w ##class(web.DHCSTPHCMFUNLIBITM).GetNumByArcID(argInput)
/// 返回1-存在
ClassMethod GetNumByArcIDOLD(argInput As %String) As %String
{
	
	New (argInput,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	
	s argStDate=%argStDate
	s argEndDate=%argEndDate
	s argArcitmStr=argInput
   
	s OrderID=$o(^OEORD(0,"Adm",%EpisodeID,""))

	s ret=0
	s %ExtraData=""  //初始化 %ExtraData bianshuai 2014-09-22
	Quit:OrderID="" 0
	f date=argStDate:1:argEndDate d
	.s cnt=$l(argArcitmStr,",")
	.f x=1:1:cnt d
	..s drgdr=$p(argArcitmStr,",",x)
	..s code=$p(^PHCD(+drgdr,1),"^",1)
	..s arc=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	..q:arc=""
	..s sub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),arc,""))
	..q:sub=""
	..s arcitm=arc_"||"_sub
    ..s chl=$o(^OEORDi(0,"ARCIM",OrderID,arcitm,date,""))
    ..q:chl=""
    ..s ret=1
   
    s %ExtraData=ret
    q ret
}

/// w ##Class(web.DHCSTPHCMFUNLIBITM).Test()
ClassMethod Test() As %String
{
	s %EpisodeID="76"
	s %argStDate="62468"
	s %argEndDate="63368"
	//s fun=##class(web.DHCSTPHCMFUNLIBITM).GetFunLibItm("CheckDrugExist")
	
	//x fun
	//s a=%ExtraData
	//q a
	
	w ##class(web.DHCSTPHCMFUNLIBITM).CheckLabItmExist("CheckLabItmByArcID")
	
	q ""
}

/// 检测lis项目
/// w ##class(web.DHCSTPHCMFUNLIBITM).CheckLabItmResult("CheckLabItmByArcID")
/// 返回空-检验合格,　非空-检验不合格
ClassMethod CheckLabItmResult(code) As %String
{
	
	New (code,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	s phflr=$o(^DHCPHFULITM(0,"Code",code,"")) 
	q:phflr="" 1
	s activeflag=$p(^DHCPHFULITM(phflr),"^",6)
	q:activeflag'="Y" 1
	s fundr=+$p(^DHCPHFULITM(phflr),"^",3)
	q:fundr=0 1
	s functions=$p($g(^DHCPHFULIB(fundr)),"^",3)	
	s fun=$p(functions,"(",1)_"("_$p(functions,"(",2)	
	s arguments=$p(^DHCPHFULITM(phflr),"^",4)
	s x="s ret="_fun_"("""_arguments_""")"
	x x
	
	s ret=%ExtraData
	
	q ret
}

/// 获取检验结果 by 时间
/// qunianpeng
/// w ##class(web.DHCSTPHCMFUNLIBITM).CheckLabItmByArcID(医嘱项ID)	 ///A0090^1^10
/// w ##class(web.DHCSTPHCMFUNLIBITM).CheckLabItmByArcIDOLD("A0001^1^10")
ClassMethod CheckLabItmByArcIDOld(argInput) As %String
{
	New (argInput,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	s h=0
	s %ExtraData=""
	s OrderID=$o(^OEORD(0,"Adm",%EpisodeID,""))
	q:OrderID="" ""
	s StDate=""
	f  s StDate=$o(^OEORDi(0,"StDt",StDate)) q:StDate=""  d		//通过医嘱项ID 取到病人的检验结果
	.s SubID=""
	.f  s SubID=$o(^OEORDi(0,"StDt",StDate,OrderID,SubID)) q:SubID=""  d  
	..Set LabTestSetRow=$p($g(^OEORD(+OrderID,"I",SubID,3)),"^",35)
	..q:(LabTestSetRow="")
	..	//报告信息
	..s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),2)
	..s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),3)
	..q:'$l(VisitNumberDR)
	..s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	..q:'$l(WorkGroupMachineDR)
	..s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	..s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	..q:'$l(OrderNo)
	..s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
 	..q:'$l(ReportDR)
 	..q:$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)'=3
 	..s TestCodeDR="" 
 	..f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	...Q:'$d(^dbo.BTTestSetLayoutI("IndexTestCode",TestCodeDR,TestSetDR,WorkGroupDR))
 	...s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	...s ItemCode=$lg(TestCodeData,2)    //检验项目代码
	...s ItemDesc=$lg(TestCodeData,3)    //检验项目描述
	...s TCSync=$lg(TestCodeData,7)
 	...s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
 	...q:'$l(ResultDR)
 	...s ResultData=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	...s ItemResult=$lg(ResultData,5)  //结果
	...s ItemUnit=$lg(ResultData,11)   //检验项目的单位
	...s AbnorFlag=$lg(ResultData,9)   //异常标记
	...s ItmRange=$lg(ResultData,12)   //参考范围
	...;s RangL=$p(RefRanges,"-",1)  //低值	
	...;s RangH=$p(RefRanges,"-",2)  //高值
	...s str=ItemCode_"^"_ItemDesc_"^"_ItemResult_"^"_ItemUnit_"^"_AbnorFlag_"^"_ItmRange  ;_"^"_RangL_"_"_RangH
	...s h=h+1
	...s ^TempLabItemRes(0,"LabItemResult",OrderID,h)=str    			
   
    s ArcimID=$p(argInput,"^",1)	//取监测的检验指标
    s min=$p(argInput,"^",2)
    s max=$p(argInput,"^",3)
    s LabResult=""
    s TempIndex=0
    f  s TempIndex=$o(^TempLabItemRes(0,"LabItemResult",OrderID,TempIndex)) q:TempIndex=""  d
    .s ItemCode=$p(^TempLabItemRes(0,"LabItemResult",OrderID,TempIndex),"^",1)
    .q:ItemCode'=ArcimID	//在检验结果中取出监测的检验指标
    .s ItemDesc=$p(^TempLabItemRes(0,"LabItemResult",OrderID,TempIndex),"^",2)
    .s ItemResult=$p(^TempLabItemRes(0,"LabItemResult",OrderID,TempIndex),"^",3)
    .q:'((ItemResult>min)&(ItemResult<max))	//取出结果不在监控范围的指标
	.s LabResult=ItemDesc

	q "Lab^^^"_LabResult
	;s %ExtraData=1 //LabResult  //暂时不需要返回结果  bianshuai 2014-09-22
}

/// 获取检验项目的描述，结果，单位，异常值，参考范围信息，英文缩写
/// [Previously private]
ClassMethod GetTestCodeResultOLD(LabNo As %String, TC As %String, Result As %String) As %String
{
	New (LabNo,TC,Result)
	Set return=""
	Quit:TC="" return
	Quit:'$d(^TTAB("TC",TC)) return
	
	Set ItemName=$p(^TTAB("TC",TC),"\",1)        //项目名称
	Set ItemDate=$p(^TEPI(LabNo),"\",10)
	Set Synonym=$p(^TTAB("TC",TC),"\",12)        //英文缩写
	Set ItemUnits=..GetTCUnitByDate(TC,ItemDate) //项目单位
	Set ItemType=$p(^TTAB("TC",TC),"\",3)        //输出数据类型
	Set ItemResult=Result
	If ItemType="V" {         //微生物 Micro Pathogen||V
		If ItemResult'="" {
			set xItemResult=ItemResult
			set xItemResult=$ZCVT($g(xItemResult),"U")
			set xItemResult=$tr(xItemResult," ","")
			Set:$d(^TTAB("BUG",xItemResult)) ItemResult=$p($g(^TTAB("BUG",xItemResult)),"\",1)
		}
	}
	If ItemType["N" {         //??
		Set Decimal=$e(ItemType,2)
		Set:Decimal="" Decimal="0"
		Set ItemResult=$$CheckResDecimal(ItemResult,Decimal)
	}
	If ItemType["S" {         //Standard Comment标准意见
		If ItemResult'="" {
			Set:$d(^TTAB("TC",TC,2,ItemResult,1)) ItemResult=$p($g(^TTAB("TC",TC,2,ItemResult,1)),"\",1)
		}
	}
	If ItemType="B2" {        //血型结果
		If ItemResult'="" {
			Set:$d(^TTAB("BB-BG",ItemResult)) ItemResult=$p($g(^TTAB("BB-BG",ItemResult)),"\",1)
		}
	}
	
	Set ResFlag=..GetAbnorFlag(TC ,ItemResult)  //异常标志
	Set RefRanges=..GetTCRanges(TC)             //参考范围
	//Set RefRanges=$tr(RefRanges,$C(1),"~")      //参考范围高低值之间用“~”分隔
	Set:'$l(RefRanges) RefRanges=..GetMultiScope(TC)
	Set $p(return,$c(2),1)=TC
	Set $p(return,$c(2),2)=ItemName
	Set $p(return,$c(2),3)=$tr(ItemResult,$c(13,10),"")
	Set $p(return,$c(2),4)=ItemUnits
	Set $p(return,$c(2),5)=ResFlag
	Set $p(return,$c(2),6)=RefRanges
	Set $p(return,$c(2),7)=Synonym
	Quit return
	
CheckResDecimal(res,dec)
	Set res=$Get(res),dec=+$Get(dec)
	Set ret=""
	If res="" Quit ret
	If dec="" Quit ret
	Set flag=""
	If ($Extract(res)="<")!($Extract(res)=">") s flag=$Extract(res),res=$TRanslate(res,"<>")
	Set res=+res
	Set ret=$fn(res,"",dec)
	Quit flag_ret
}

/// 获取检验项目的异常标记
/// TestCode:检验项代码，TCResult:检验结果，TCRanges：检验项范围值（默认为空）
/// [Previously private]
ClassMethod GetAbnorFlag(TestCode As %String, TCResult As %String, TCRanges As %String = "") As %String
{
	Set FormatFlag=""
	//Set currNS=$znspace
	Set:$Data(^TTAB("TC",TestCode))'=0 FormatFlag=$Piece(^TTAB("TC",TestCode),"\",3)
	Quit:FormatFlag=""!TCResult=""!TestCode="" ""
	Set:TCRanges="" PType="0",TCRanges=..GetTCRanges(TestCode, "","", "", PType, "", "", "", "1","")
	Set:'$l(TCRanges) TCRanges=..GetMultiScope(TestCode)
	Set AbnorFlag=$Select(FormatFlag["N":$$GetAbnorFlagByNum(TCResult,TCRanges),FormatFlag["S":$$GetAbnorFlagByStCommen(TestCode,TCResult),FormatFlag["X":$$GetAbnorFlagByFreeText(TestCode,TCResult),1:"")
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
	Set TCResult=$tr(TCResult,"><")
	;
	/*
	Set $znspace="LABDATA"
	Set lowflag=$p(^CF("LAB",1),"^",18),highflag=$p(^CF("LAB",1),"^",19)
	s rangsta=$p(^CF("LAB",1),"^",16),rangend=$p(^CF("LAB",1),"^",17)
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    s iBelowBColor=$P(^CF("LAB",1,"COLOUR",12),"^",1)
    s iBelowFcolor=$P(^CF("LAB",1,"COLOUR",12),"^",2)
    ;
    s iUnAcceptBColor=$P(^CF("LAB",1,"COLOUR",2),"^",1)
    s iUnAcceptFColor=$P(^CF("LAB",1,"COLOUR",2),"^",2)
    s iPanicColor=$P($tr(^CF("LAB",1,"COLOUR",15),$c(13,10)),"^",11)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    i TCRanges="" q retvalue_$c(28)_retranges_$c(28)_retcolor_$c(28)_retflag
	 
	i TCRanges="" q retvalue_$c(28)_retflag
	
	;---------add 20070914  修改范围值的显示
	i reslow="",reshigh="" d 
	.s retranges="" 
	i "<>"[$e(reslow) d ;($e(reslow,1)="<")!($e(reslow,1)=">") d
	.s retranges=rangsta_reslow_rangend
	e  d
	.s retranges=rangsta_reslow_"-"_reshigh_rangend
	;-----------
	*/
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
	..i TCResult>lowvalue s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="U" q
	;Panic check
	s rang=resPaniclow_resPanichigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resPaniclow s retvalue=lowflag,retflag="M" q
	..i TCResult>resPanichigh s retvalue=highflag,retflag="M" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="M" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
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
	i '$l(TCResult) q $c(28,28,28)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    ;s ^aareflag=TestCode_":"_TCResult
    i $d(^TTAB("TC",TestCode,2,TCResult)) d
    .s retflag=$p(^TTAB("TC",TestCode,2,TCResult),"\",1)
    .i retflag="A" s retvalue="*"
    q retvalue_$c(28)_retflag
    //q retflag
    
	;文本类型
GetAbnorFlagByFreeText(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    s temstr=""
    s std="" f  s std=$o(^TTAB("TC",TestCode,2,std)) q:std=""  d
    .i $p(^TTAB("TC",TestCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),TCResult[$g(^TTAB("TC",TestCode,2,std,1)) ,retvalue="*",retflag="A"
    q retvalue_$c(28)_retflag
    // q retflag
    
res(rang) ; check < >
 i rang[">" s rang=$tr(rang,">")+.00000001
 i rang["<" s rang=$tr(rang,"<")-.00000001
 q rang
}

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别,Pregn:怀孕(0),PatientType:病人类型(0\0-IN),Date:日期,Cond:临床条件(0),Loc:0,mi:1\2,Weeks:周(0)
/// [Previously private]
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Pregn As %String = "", PatientType As %String = "0", Date As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "1", Weeks As %Integer = "") As %String
{
 Set (j,x,xf,age0,type,exist,result,format)=""
 Set result=""
 Set tc=$g(TestCode),age=$g(Age),spec=$g(Species),pregn=$g(Pregn),ptype=$g(PatientType),date=$g(Date),cond=$g(Cond),loc=$g(Loc),mi=$g(mi),weeks=$g(Weeks)
 ;
 If '$l(age) Set age=0
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
 ..s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))
 ..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 .s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 .i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
  //w !,"@Debug Start-------------------------------------",!
  //w "result:"_result
  //w !,"@Debug End---------------------------------------",!
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

/// 检验项目结果多范围值的获取
/// [Previously private]
ClassMethod GetMultiScope(ItemCode, LabNo, date) As %String
{
   
   ;先判断有没有临床条件?若有临床条件则不需要返回多范围了
   s ItemCode=$g(ItemCode),LabNo=$g(LabNo),date=$g(date)
   ;s conditions=""    ?????  Liuzf-20090422
   ;s conditions=$P($g(^TEPI(LabNo,0)),"\",17)  ???? Liuzf-20090422
   ;i conditions'="" q ""        ???? Liuzf-20090422
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
   ...i $l(temH) s temrange=^TTAB("CLC",clc)_"("_$j(temL,3,2)_"-"_$j(temH,3,2)_")"
   ...i '$l(temH) s temrange=^TTAB("CLC",clc)_"("_temL_")"
   ...;s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   ...i (num#2)=0 d
   ....s Scopy=Scopy_temrange_$c(10,13)
   ...e  d
   ....s Scopy=Scopy_temrange_$c(32)
   ...s num=num+1
   q Scopy
}

/// 根据日期获取检验项目的单位 //$$Units^DHCCTTCU(TC,recdate) ;
/// [Previously private]
ClassMethod GetTCUnitByDate(tc, date) As %String
{
  ;table CT_TestCodePrevUnits
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s date=date+1
  s last=$o(^TTAB("TC",tc,6,""),-1)
  q:($Data(^TTAB("TC",tc))'=1)&($Data(^TTAB("TC",tc))'=11) ""
  s unit=$p(^TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^TTAB("TC",tc,6,date)) q $p(^TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^TTAB("TC",tc,6,last),"\",1)
}

/// Descript:监测项目并执行函数  bianshuai 2014-09-22
/// w ##class(web.DHCSTPHCMFUNLIBITM).ExecMonitorLibFun(thri)
ClassMethod ExecMonitorLibFun(thri) As %String
{
	N (thri,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	S quitflag=0
	S ret=""
	S itmr=""
	F  S itmr=$o(^DHCPHFULITM(0,"Theme",thri,itmr)) Q:(itmr="")||(quitflag=1)  D
	.S activeflag=$p(^DHCPHFULITM(itmr),"^",6)
	.Q:activeflag'="Y"   //是否激活
	.S fundr=+$p(^DHCPHFULITM(itmr),"^",3)
	.Q:fundr=0           //函数是否为空
	.S functions=$p($g(^DHCPHFULIB(fundr)),"^",3)	
	.S fun=$p(functions,"(",1)_"("_$p(functions,"(",2)	
	.S arguments=$p(^DHCPHFULITM(itmr),"^",4)
	.S x="s ret="_fun_"("""_arguments_""")"
    .X x
	.S ret=%ExtraData
	.S:ret'=1 quitflag=1
	Q ret
}

/// Descript:检查医嘱项是否存在
/// w ##class(web.DHCSTPHCMFUNLIBITM).GetNumByArcID()
ClassMethod GetNumByArcID(arguments As %String) As %String
{
	n (arguments,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	s argStDate=%argStDate
	s argEndDate=%argEndDate
  
	s ord=$o(^OEORD(0,"Adm",%EpisodeID,""))
	q:ord="" ""
	
	s itmmastid=$p(arguments,"^",1)
	s monItmList=""
	//f dd=argStDate:1:argEndDate d
    s chl=$o(^OEORDi(0,"ARCIM",ord,itmmastid,+($H-1),""))
    q:chl="" ""
    s oeori=ord_"||"_chl
    s orddate=$p($g(^OEORD(+ord,"I",chl,3)),"^",7) //医嘱日期
    //q:orddate'=+$h ""
	s arcitmcode=$p(^ARCIM(+itmmastid,$p(itmmastid,"||",2),1),"^",1) //医嘱项代码
	s arcitmdesc=$p(^ARCIM(+itmmastid,$p(itmmastid,"||",2),1),"^",2) //医嘱项名称
    s monItmList="Arc"_"^"_itmmastid_"^^"_arcitmcode_$C(2)_arcitmdesc_"^"_oeori	//qunianpeng 2017/9/20  存医嘱id
    
    q monItmList
}

/// Descript:获取检验结果
ClassMethod CheckLabItmByArcID(arguments) As %String
{
	n (arguments,%argStDate,%argEndDate,%EpisodeID)
	s monItmList=""
	s ord=$o(^OEORD(0,"Adm",%EpisodeID,""))
	q:ord="" ""

    s TestCode=$p(arguments,"^",1)  //指标代码
    s min=$p(arguments,"^",2) 		//上限
    s max=$p(arguments,"^",3) 		//下限
    
    s itm=""
    f  s itm=$o(^OEORD(ord,"I",itm))  q:itm=""  d
    .s orditm=ord_"||"_itm
    .Q:'$d(^OEORD(ord,"I",itm,1))
    .;s orddate=$p($g(^OEORD(ord,"I",itm,1)),"^",9) //医嘱开始日期
    .;q:orddate'=+($H-1)
    .s itmmastid=$p(^OEORD(ord,"I",itm,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.s LabTestSetRow=$p($g(^OEORD(ord,"I",itm,3)),"^",35)
	.s LabResult=..GetTestCodeResult(LabTestSetRow,TestCode)
	.Q:LabResult=""
	.s ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
	.s ItemResult=$p(LabResult,$c(2),3)  //结果
	.s ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
	.s AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
    .q:(min'="")&(ItemResult'<min)&(ItemResult'>max)
    .i monItmList="" d
    ..s monItmList="Lab"_"^"_itmmastid_"^"_ItemResult_"^"_LabResult_"^"_orditm
    .e  s monItmList=monItmList_"!!"_"Lab"_"^"_itmmastid_"^"_ItemResult_"^"_LabResult_"^"_orditm
    q monItmList
}

// w ##class(web.DHCSTPHCMFUNLIBITM).GetTestCodeResult(617,"L0044")

/// Descript:获取检验结果
ClassMethod GetTestCodeResult(LabTestSetRow As %String, TestCode As %String) As %String
{
	n (LabTestSetRow, TestCode)
	Q:LabTestSetRow="" ""
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),2)
	s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),3)
	Q:'$l(VisitNumberDR) ""
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	Q:'$l(WorkGroupMachineDR) ""
	s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	Q:'$l(OrderNo) ""
	s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
 	Q:'$l(ReportDR) ""
 	Q:$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)'=3 ""
 	s return=""
 	s TestCodeDR="" 
 	f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	.;Q:'$d(^dbo.BTTestSetLayoutI("IndexTestCode",TestCodeDR,TestSetDR,WorkGroupDR))
 	.s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
 	.s ItemCode=$lg(TestCodeData,2)    //检验项目代码
 	.Q:TestCode'=ItemCode
	.s ItemDesc=$lg(TestCodeData,3)    //检验项目描述
	.s TCSync=$lg(TestCodeData,7)
 	.s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
 	.q:'$l(ResultDR)
 	.s ResultData=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	.s ItemResult=$lg(ResultData,5)  //结果
	.s ItemUnit=$lg(ResultData,11)   //检验项目的单位
	.s AbnorFlag=$lg(ResultData,9)   //异常标记
	.s ItmRange=$lg(ResultData,12)   //参考范围
	.s return=ItemCode_$c(2)_ItemDesc_$c(2)_ItemResult_$c(2)_ItemUnit_$c(2)_AbnorFlag_$c(2)_ItmRange
	Q return
}

/// Descript:判断病人当天是否手术
ClassMethod CheckPatIfOpToday(arguments) As %String
{
	n (arguments,%EpisodeID)
	s monItmList=""
	s opArrdr=""
	f  s opArrdr=$o(^DHCANOPArrange(0,"Adm",%EpisodeID,opArrdr)) q:(opArrdr="")||(monItmList'="")  d
	.s StartDate=$p(^DHCANOPArrange(opArrdr),"^",14) //手术开始日期
	.q:StartDate'=(+$H-1)
	.//q:StartDate<(+$H-3)
	.s monItmList="Oper^^^手术^"
	q monItmList
}

}
