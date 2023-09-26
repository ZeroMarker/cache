Class web.DHCMedOPRMCommonFunc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
/DHCMedOPRMLine和DHCMedOPRMPie公用方法
/通过ctlocRowID获取SVG图标题日期和部门字符串
*/
ClassMethod GetCtlocDesc(ctlocRowID)
{
  	s day=$zd($h,3)								//当前时间
	i (ctlocRowID="") d
	.s depName=" 全院 " 						//如果ctlocRowID为空，标题部门为" 全院 " 
	e  d
	.s depFullName=$p($g(^CTLOC(ctlocRowID)),"^",2)
	.s depName=" "_$p(depFullName,"-",2)_" " 	//若ctlocRowID不为空，取得部门名称
	s dateDepStr=day_" "_depName_" "
	q dateDepStr
}

/*
/构造Xi每条曲线数据字符串方法，返回每条线数据组成的字符串
/参数说明 formula：计算公式，格式“A1-A2^C”;beforeXStr:X前的Code的字符串，“^”分隔，iPoints：每条线上点数
/调试语句：d ##class(web.DHCMedOPRMCommonFunc).BuildXLines("D1-D2^E","A1^A2^B^C^D1^D2^E^F^G^H^I^J","40")
*/
ClassMethod BuildXLines(formula, beforeXStr, iPoints)
{
	;w !,"CodeStrr="_formula_";beforeXStr="_beforeXStr_";iPoints="_iPoints
	s plusCodeStr=$p(formula,"-",1)				//将“-”前字符串取出，作为加数字符串
	s minusCodeStr=$p(formula,"-",2)			//将“-”后字符串取出，作为减数字符串
	
	s plusCodeLen=$l(plusCodeStr,"^")			//加数字符串长度（加数个数）
	f i=1:1:plusCodeLen d
	.s plus(i)=$p(plusCodeStr,"^",i)			//将每个加数字符分离出来，放入plus(i)数组中，如plus(1)=“A1”
	
	s minusCodeLen=$l(minusCodeStr,"^")			//减数字符串长度（减数个数）
	f i=1:1:minusCodeLen d
	.s minus(i)=$p(minusCodeStr,"^",i)			//将每个减数字符分离出来，放入minus(i)数组中，如minus(1)=“A2”
	
	s beforeXLen=$l(beforeXStr,"^")				//X前字母个数（X前线的条数）
	
	f i=1:1:beforeXLen  d
	.s tempCode=$p(beforeXStr,"^",i)			//将beforeXStr中每个Code取出
	.s dataLineStr(tempCode)=$g(^CacheTemp("MedOPRMLine",$j,tempCode)) //将^CacheTemp中对应Code节点的数据取出，赋值给dataLineStr数组
	
	s tempWaitLine=""
	
	//根据曲线上点的个数进行循环，计算X线数据各点数值
	f i=1:1:+iPoints   d
	.s tempXiVal=0								//tempXiVal存储计算中各点的数值，初始设为0
	.f j=1:1:plusCodeLen  d
	..s plusCode=plus(j)						//对加数字符长度进行循环
	..s tempValue=$p(dataLineStr(plusCode),$c(3),i) //将dataLineStr数组中对应Code点的值取出
	..s tempXiVal=tempXiVal+tempValue			//将取出的点值tempValue加到tempXiVal中
	.f k=1:1:minusCodeLen  d
	..s minusCode=minus(k)						//对减数字符长度进行循环
	..s tempValue=$p(dataLineStr(minusCode),$c(3),i) //将dataLineStr数组中对应Code点的值取出
	..s tempXiVal=tempXiVal-tempValue			//将取出的点值tempValue从tempXiVal中减去
	.s tempWaitLine=tempWaitLine_tempXiVal_$c(3) //将计算结束的tempXiVal拼接到新的曲线字符串tempWaitLine中
	s tempWaitLine=$e(tempWaitLine,1,$l(tempWaitLine)-1)
	q tempWaitLine
}

/*
/通过Rowid获取门诊业务描述
*/
ClassMethod GetDesc(StatusDr)
{
    s StatusDesc=""
    q:'$d(^DHCMEDADMS(StatusDr)) StatusDesc
    s StatusDesc=$p($g(^DHCMEDADMS(StatusDr)),"^",2)
    q StatusDesc
}

/*
/通过Rowid获取门诊业务代码
*/
ClassMethod GetCode(StatusDr)
{
    s StatusCode=""
    q:'$d(^DHCMEDADMS(StatusDr)) StatusCode
    s StatusCode=$p($g(^DHCMEDADMS(StatusDr)),"^",1)
    q StatusCode
}

/*
/通过门诊业务代码获取rowid
*/
ClassMethod GetRowId(code)
{
  s RowId=""
    q:'$d(^DHCMEDADMS(0,"CODE",code)) RowId
    s RowId=$o(^DHCMEDADMS(0,"CODE",code,RowId))
    q RowId
}

/*
/获取就诊号列表字符串
*/
ClassMethod GetXAdmList(iDate, xCode)
{
	s ret=""
	if (xCode="X1")
	{
		;X1=A1-A2-C
		s xCodeString="A1^A2^C"
		s ret=..GetDetails(iDate,xCodeString)
		q ret
	}
	elseif (xCode="X2")
	{
		;B-D1
        s xCodeString="B^D1"
		s ret=..GetDetails(iDate,xCodeString)
		q ret
	}elseif (xCode="X3")
	{
		;D1-D2-E
		s xCodeString="D1^D2^E"
		s ret=..GetDetails(iDate,xCodeString)
		q ret
}
}

/*
/GetXAdmList调用的公共方法
/根据GetXAdmList方法中出入的计算规则字符串（如"A1^A2^C"）得到就诊号列表字符串
*/
ClassMethod GetDetails(iDate, xCodeString)
{
	s len=$l(xCodeString,"^")
	;w !,"执行GetDetailsN方法!len="_len
	f i=1:1:len d
	.s code(i)=$p(xCodeString,"^",i)
	.s StatusDr(i)=..GetRowId(code(i))
	.;w !,"code"_i_"="_code(i)
	q:'$d(^DHCMEDADMLOG(0,"DateSP",iDate,StatusDr(1))) ""
	s ListPaadm=""
	s tmpPaadm=""
	f  s tmpPaadm=$o(^DHCMEDADMLOG(0,"DateSP",iDate,StatusDr(1),tmpPaadm)) q:tmpPaadm=""  d
	.q:$d(^DHCMEDADMLOG(0,"AdmStatus",tmpPaadm,StatusDr(2)))
	.q:(len=3)&$d(^DHCMEDADMLOG(0,"AdmStatus",tmpPaadm,StatusDr(3)))
	.s ListPaadm=ListPaadm_tmpPaadm_"^"
	s ListPaadm=$e(ListPaadm,1,$l(ListPaadm)-1)
	;w !,"HDCMedOPRMLine中ListPaadm="_ListPaadm
	q ListPaadm
}

/*
/d ##class(%Library.ResultSet).RunQuery("web.DHCMedOPRMPatInfo","PatInfoQuery","60943","X1")
/查询出就诊状态代码，名称字符串,格式：X1^候诊^Y^X2^等候收费^Y^
*/
ClassMethod GetXiString(startCode As %String, endCode As %String) As %String
{
	s tmpXi=startCode
	s temp=""
	f  s tmpXi=$o(^DHCMEDADMS(0,"CODE",tmpXi)) q:tmpXi=endCode  d
	.s xDr=0
	.s xDr=$o(^DHCMEDADMS(0,"CODE",tmpXi,xDr))
	.s xData=$g(^DHCMEDADMS(+xDr))
	.s temp=temp_xData_$c(1)
	s ret=$e(temp,1,$l(temp)-1)
	q ret
}

/*
/查询出就诊状态代码和名称字符串
*/
ClassMethod GetXCodeNameStr(startCode As %String, endCode As %String) As %String
{
	s xCodeString=""
	s xNameString=""
	s temp=..GetXiString(startCode,endCode)
	s len=$l(temp,$c(1))
	f i=1:1:len  d
	.s tempData(i)=$p(temp,$c(1),i)
	.s xCode(i)=$p(tempData(i),"^",1)
	.s xName(i)=$p(tempData(i),"^",2)
	.s xCodeString=xCodeString_xCode(i)_"^"
	.s xNameString=xNameString_xName(i)_"^"
	s xCodeString=$e(xCodeString,1,$l(xCodeString)-1)
	s xNameString=$e(xNameString,1,$l(xNameString)-1)
	s ret=xCodeString_$c(1)_xNameString
	q ret
}

/*
/计算年龄方法
*/
ClassMethod CalAge(IBirth As %String, IToday As %String) As %String
{
    n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
    . s AgeMth=AgeMth-1
    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
    . q:XToday'=2
    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
    i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
    s $P(AgeYr,"|",12)=AgeYear
    s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
    i $p(AgeYr,"|",12)>0  d
    .s reage=$p(AgeYr,"|",12)_"岁"
    e  d
    .i AgeMth>0 d
    ..s reage=AgeMth_"月"
    .e  d
    ..s reage=AgeDay_"天"
    q reage
}

}
