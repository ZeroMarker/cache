Import sqluser

Class web.DHCADVSTATALLREPBYMON Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 不良事件全部月统计
/// Creator:     yangyongtao
/// CreateDate:  2016-03-14 
/// Input:  	 开始日期^结束日期^报告类型"
/// Output:   	 月份^器械的数量^器械的总数量
/// Others:		 d ##class(web.DHCADVSTATALLREPBYMON).StatAllRepByMon("3","1","2016-06-30^2016-07-02^")
ClassMethod StatAllRepByMon(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
    s Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s StDate=$p(params,"^",1)    //开始日期
	s EndDate=$p(params,"^",2)   //结束日期 
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)  //$zdh(StDate,3)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)  //$zdh(EndDate,3)
	S TypeEvent=$p(params,"^",3)
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //月份器械类型数量统计初始化
	f dd=StDate:1:EndDate d
	.
	.;用药差错
	.if (TypeCode="drugerr")||(TypeCode="") d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
    ...S StatusID=$p(^DHCADVMEDSAR(MedsrID),"^",18) //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCADVMEDSAR(MedsrID),"^",20) //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	...s CreateDate=$p(^DHCADVMEDSAR(MedsrID),"^",2)   //获取报告日期
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...S Numalls=Numalls+1
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  d
	....s h=h+1  
	....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_"报告数量"_"^"_Num
	.
	.;输血
	.if (TypeCode="blood")||(TypeCode="")  d
	..s MedsrID="0"
	..f  S MedsrID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCBLDADVRPT(MedsrID),"^",46)   //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCBLDADVRPT(MedsrID),"^",47)  //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)      //类型Desc
	...s CreateDate=$p(^DHCBLDADVRPT(MedsrID),"^",4)   //获取报告日期
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...S Numalls=Numalls+1
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  d
	....s h=h+1  
	....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_"报告数量"_"^"_Num
	.
	.;器械
	.if (TypeCode="material")||(TypeCode="")  d
	..s MedsrID="0"
	..f  S MedsrID=$o(^DHCMATADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMATADRR(MedsrID),"^",41)   //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCMATADRR(MedsrID),"^",46)   //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	...s CreateDate=$p(^DHCMATADRR(MedsrID),"^",39)   //获取报告日期
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...S Numalls=Numalls+1
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  d
	....s h=h+1  
	....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_"报告数量"_"^"_Num
	.
	.;药品
	.if (TypeCode="drug")||(TypeCode="") d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCADVDRUGREP(MedsrID),"^",48)  //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCADVDRUGREP(MedsrID),"^",49)  //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)     //类型Desc
	...s CreateDate=$p(^DHCADVDRUGREP(MedsrID),"^",51)   //获取报告日期
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...S Numalls=Numalls+1
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  d
	....s h=h+1  
	....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_"报告数量"_"^"_Num
	.
	.;医疗
	.if (TypeCode="med")||(TypeCode="") d
	..s MedsrID="0"    
	..f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(typecode'="med")
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)    //类型Desc
	...s CreateDate=$p(^DHCMEDADRR(MedsrID),"^",25)   //获取报告日期
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...S Numalls=Numalls+1
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  d
	....s h=h+1  
	....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_"报告数量"_"^"_Num
    .
    .;输血不良事件
	.if (TypeCode="bldevent")||(TypeCode="") d
	..s MedsrID="0"    
	..f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1) //类型Code
	...Q:(typecode'="bldevent")
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)  //类型Desc
	...s CreateDate=$p(^DHCMEDADRR(MedsrID),"^",25)   //获取报告日期
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...S Numalls=Numalls+1
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  d
	....s h=h+1  
	....S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_"报告数量"_"^"_Num
    ..
    .
	S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,10000,100)="合计:"_"^"_"报告数量"_"^"_Numalls
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S Title="name^group^value"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串
	s year=""
	s month=""
	f  s year=$o(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,year)) q:year=""  d
	.f  s month=$o(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,year,month)) q:month=""  d
	..s mdate=$g(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,year,month))
	..s count = count+1
	..q:(count<Start)||(count>End)
	..I count=Start d
	...w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	..e  d
	...w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description: 不良事件全部月统计分析
/// Creator:     yangyongtao
/// CreateDate:  2016-03-15 
/// Input:  	 开始日期^结束日期^报告类型"
/// Output:   	 月份^器械的数量^器械的总数量
/// Others:		 d ##class(web.DHCADVSTATALLREPBYMON).AnalysisRepByMon("2016-01-1^2016-03-29^")
ClassMethod AnalysisRepByMon(params As %String) As %String
{
	n (params)
	s ^tll("a")=params
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s StDate=$p(params,"^",1)    //开始日期
	s EndDate=$p(params,"^",2)   //结束日期 
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)  //$zdh(StDate,3)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)  //$zdh(EndDate,3)
	S TypeEvent=$p(params,"^",3)
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	S Numalls=0
    s Num=1
	f dd=StDate:1:EndDate d
	.
	.;用药差错
	.if (TypeCode="drugerr")||(TypeCode="") d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCADVMEDSAR(MedsrID),"^",18) //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCADVMEDSAR(MedsrID),"^",20) //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	...s CreateDate=$p(^DHCADVMEDSAR(MedsrID),"^",2)
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"月"_"^"_"报告数量"_"^"_Num
	.
	.;输血
	.if (TypeCode="blood")||(TypeCode="")  d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCBLDADVRPT(MedsrID),"^",46)   //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCBLDADVRPT(MedsrID),"^",47)  //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)      //类型Desc
	...s CreateDate=$p(^DHCBLDADVRPT(MedsrID),"^",4)
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"月"_"^"_"报告数量"_"^"_Num
	.
	.;器械
	.if (TypeCode="material")||(TypeCode="")  d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCMATADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMATADRR(MedsrID),"^",41)   //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCMATADRR(MedsrID),"^",46)   //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)       //类型Desc
	...s CreateDate=$p(^DHCMATADRR(MedsrID),"^",39)
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"月"_"^"_"报告数量"_"^"_Num
	.
	.;药品
	.if (TypeCode="drug")||(TypeCode="")  d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCADVDRUGREP(MedsrID),"^",48)  //报告状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCADVDRUGREP(MedsrID),"^",49)  //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)     //类型Desc
	...s CreateDate=$p(^DHCADVDRUGREP(MedsrID),"^",51)   //获取报告日期
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"月"_"^"_"报告数量"_"^"_Num
	.
	.;医疗
	.if (TypeCode="bldevent")||(TypeCode="")  d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(typecode'="bldevent")
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)    //类型Desc
	...s CreateDate=$p(^DHCMEDADRR(MedsrID),"^",25)
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"月"_"^"_"报告数量"_"^"_Num
	.
	.;输血不良事件
	.if (TypeCode="med")||(TypeCode="")  d
	..s MedsrID="0"
	..f  s MedsrID=$o(^DHCMEDADRR(0,"CreateDate",dd,MedsrID)) q:MedsrID=""  d  //获取报告ID
	...S StatusID=$p(^DHCMEDADRR(MedsrID),"^",27) //当前状态
	...;Q:StatusID=""
	...S typedr=$p(^DHCMEDADRR(MedsrID),"^",30) //类型ID
	...Q:typedr=""
	...S typecode=$p(^DHCMEDADREVT(typedr),"^",1)  //类型Code
	...Q:(typecode'="med")
	...S type=$p(^DHCMEDADREVT(typedr),"^",2)    //类型Desc
	...s CreateDate=$p(^DHCMEDADRR(MedsrID),"^",25)
	...s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	...S DateFormat = ##class(websys.Conversions).DateFormat()
	...S YearDate="" ,MonthDate=""
	...I DateFormat="1"  D //MDY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	...I DateFormat="3"  D  //YMD
	....I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	....I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ...I DateFormat="4"  D  //DMY
	....I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	....I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	...i $d(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate))  d
	....S $p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	...E  S ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"月"_"^"_"报告数量"_"^"_Num
	..
	.
	///转换数据为Json格式
	S Title="name^group^value"
	W "["    
	S Num=0
	s year=""
    s month=""
	f  s year=$o(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,year)) q:year=""  d
	.f  s month=$o(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,year,month)) q:month=""  d
	..s mdate=$g(^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid,year,month))
	..Q:mdate=""
	..S Num=Num+1
	..I Num=1 D
	...W ##class(web.DHCADVJSONCOMMON).getSisJsonData(Title,mdate)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getSisJsonData(Title,mdate)
	.
	W "]"
	D ..killTmpGlobal(pid)
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	;k ^TMP("DHCADV","web.DHCADVSTATALLREPBYMON","QueryStatAllRepByMon",pid)
}

}
