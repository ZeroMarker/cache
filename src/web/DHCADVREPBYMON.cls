Import sqluser

/// Description: 不良事件
/// Creator:     yangyongtao
/// CreateDate:  2017-09-22  
Class web.DHCADVREPBYMON Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 不良事件全部月统计
/// Creator:     yangyongtao
/// CreateDate:  2017-09-20
/// Input:  	 "开始日期^结束日期^报告类型" "LgParam：人员^科室^安全组^医院"
/// Output:   	 月份^数量^总数量
/// Others:		 d ##class(web.DHCADVREPBYMON).StatAllRepByMon("30","1","2017-01-01^2017-12-31^")
ClassMethod StatAllRepByMon(rows As %String, page As %String, params As %String, LgParam As %String = "") As %String
{
	n (rows,page,params,LgParam,%session)
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
	.S:(TypeEvent'["||") TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	.S:(TypeEvent["||") TypeCode=$p(^DHCMEDADREVTI(+TypeEvent,"MADREVI",$p(TypeEvent,"||",2)),"^",1)
	e  d
	.s TypeCode=""
    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //月份类型数量统计初始化
	f date=StDate:1:EndDate d
	
	.;不良事件类型统计
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) q:RepID=""  d
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..Q:(TypeCode'="")&(TypeCode'=RepTypeCode)
	..Q:(RepTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(RepTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..;Q:RepStausDr=""  ;2018-01-11  统计所有填写的报告
	..S RepCancelflag=""
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..s RepHospID="",LogHospID="" //hxy 2020-02-18 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..s:LocId'="" LogHospID=$p($g(^CTLOC(+LocId)),"^",22)
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(LogHospID'="")&(LogHospID'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S GroupDesc="",flag="",Secuflag="",SecuLocflag=""
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S:UserId'="" flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:((flag'="")&&(flag'=1))
	..s CreateDate=$p(^DHCADVMASTER(RepID),"^",4)   //获取报告日期
	..s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	..S DateFormat = ##class(websys.Conversions).DateFormat()
	..S YearDate="" ,MonthDate=""
	..I DateFormat="1"  D //MDY
	...I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	...I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	..I DateFormat="3"  D  //YMD
	...I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	...I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ..I DateFormat="4"  D  //DMY
	...I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	...I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	..q:MonthDate=""
	..S Numalls=Numalls+1
	..i $d(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate))  d
	...S $p(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	..E  d
	...s h=h+1  
	...S ^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_"报告数量"_"^"_Num
	S AllNum=##class(websys.Translation).Get("dhcadv.homepage.csp","合计")

	S ^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,10000,100)=AllNum_":"_"^"_"报告数量"_"^"_Numalls
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S Title="name^group^value"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串
	s year=""
	s month=""
	f  s year=$o(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year)) q:year=""  d
	.f  s month=$o(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year,month)) q:month=""  d
	..s mdate=$g(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year,month))
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
/// Others:		 d ##class(web.DHCADVREPBYMON).AnalysisRepByMon("2016-01-1^2017-09-20^")
ClassMethod AnalysisRepByMon(params As %String, LgParam As %String = "") As %String
{
	n (params,LgParam,%session)
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s StDate=$p(params,"^",1)    //开始日期
	s EndDate=$p(params,"^",2)   //结束日期 
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)  //$zdh(StDate,3)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)  //$zdh(EndDate,3)
	S TypeEvent=$p(params,"^",3)
	i TypeEvent'="" d
	.S:(TypeEvent'["||") TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	.S:(TypeEvent["||") TypeCode=$p(^DHCMEDADREVTI(+TypeEvent,"MADREVI",$p(TypeEvent,"||",2)),"^",1)
	e  d
	.s TypeCode=""
	S Numalls=0
    s Num=1
    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	f date=StDate:1:EndDate d
	.;不良事件类型统计
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) q:RepID=""  d
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..Q:(TypeCode'="")&(TypeCode'=RepTypeCode)
	..Q:(RepTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(RepTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..;Q:RepStausDr=""  ;2018-01-11  统计所有填写的报告
	..S RepCancelflag=""
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y" 
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..s RepHospID="",LogHospID="" //hxy 2020-02-18 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..s:LocId'="" LogHospID=$p($g(^CTLOC(+LocId)),"^",22)
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(LogHospID'="")&(LogHospID'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S GroupDesc="",flag="",Secuflag="",SecuLocflag=""
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S:UserId'="" flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:((flag'="")&&(flag'=1))
	..s CreateDate=$p(^DHCADVMASTER(RepID),"^",4)   //获取报告日期
	..s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	..S DateFormat = ##class(websys.Conversions).DateFormat()
	..S YearDate="" ,MonthDate=""
	..I DateFormat="1"  D //MDY
	...I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	...I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	..I DateFormat="3"  D  //YMD
	...I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	...I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ..I DateFormat="4"  D  //DMY
	...I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	...I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	...q:MonthDate=""
	..S MonthDateDesc=##class(websys.Translation).Get("dhcadv.homepage.csp",+MonthDate_"月")
	..i $d(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate))  d
	...S $p(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate),"^",3)=$p(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate),"^",3)+1
	..E  S ^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate)=MonthDateDesc_"^"_"报告数量"_"^"_Num
	.
	///转换数据为Json格式
	S Title="name^group^value"
	W "["    
	S Num=0
	s year=""
    s month=""
	f  s year=$o(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year)) q:year=""  d
	.f  s month=$o(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year,month)) q:month=""  d
	..s mdate=$g(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year,month))
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

/// 获取报告类型
/// cretor yangyongtao
/// CreateDate:  2017-09-22
/// Input:  	 
/// Output:   	 id:name
/// d ##class(%ResultSet).RunQuery("web.DHCADVREPBYMON","GetRepType")
Query GetRepType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select MADREV_RowID as id, MADREV_Desc as name from DHC_MedAdrRepEvent
}

/// Description: 不良事件全部月统计
/// Creator:     yangyongtao
/// CreateDate:  2016-03-14 
/// Input:  	 开始日期^结束日期^报告类型"
/// Output:   	 月份^器械的数量^器械的总数量
/// Others:		 d ##class(web.DHCADVREPBYMON).StatAllRepByMon("30","1","2017-06-30^2017-11-12^")
ClassMethod GetByMon(pid As %String, StDate As %String, EndDate As %String, TypeEvent As %String) As %String
{
	n (pid,StDate,EndDate,TypeEvent)
    d ..killTmpGlobal(pid) //k掉临时global
    //s StDate=$p(params,"^",1)    //开始日期
	//s EndDate=$p(params,"^",2)   //结束日期 
	s StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)  //$zdh(StDate,3)
	s EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)  //$zdh(EndDate,3)
	//S TypeEvent=$p(params,"^",3)
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //月份类型数量统计初始化
	f date=StDate:1:EndDate d
	
	.;不良事件类型统计
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:RepTypeDr'="" RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..Q:(TypeCode'="")&(TypeCode'=RepTypeCode)
	..S:RepTypeDr'="" RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..;Q:RepStausDr="" ;2018-01-11  统计所有填写的报告 
	..s CreateDate=$p(^DHCADVMASTER(RepID),"^",4)   //获取报告日期
	..s:CreateDate'="" CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate) //$zd(CreateDate,3)
	..S DateFormat = ##class(websys.Conversions).DateFormat()
	..S YearDate="" ,MonthDate=""
	..I DateFormat="1"  D //MDY
	...I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	...I CreateDate["/" S MonthDate=$p(CreateDate,"/",1) //以"-"截取字符，获取月份
	..I DateFormat="3"  D  //YMD
	...I CreateDate["-" S YearDate=$p(CreateDate,"-",1) //以"-"截取字符，获取年份
	...I CreateDate["-" S MonthDate=$p(CreateDate,"-",2) //以"-"截取字符，获取月份
    ..I DateFormat="4"  D  //DMY
	...I CreateDate["/" S YearDate=$p(CreateDate,"/",3) //以"-"截取字符，获取年份
	...I CreateDate["/" S MonthDate=$p(CreateDate,"/",2) //以"-"截取字符，获取月份
	..q:MonthDate=""
	..i $d(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate))  d
	...S $p(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate),"^",2)=$p(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate),"^",2)+1
	..E  d
	...S ^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,+YearDate,+MonthDate)=+MonthDate_"^"_Num
	q ""
}

///   D ##class(%ResultSet).RunQuery("web.DHCADVREPBYMON","QueryByMon","2017-10-01","2017-11-12","")
Query QueryByMon(StDate As %String, EndDate As %String, TypeEvent As %String) As %Query(ROWSPEC = "MonthDate:%String,Num:%Integer") [ SqlProc ]
{
}

ClassMethod QueryByMonExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, TypeEvent As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ##Class(web.DHCADVREPBYMON).GetByMon(pid,StDate,EndDate,TypeEvent)
	S year=""
	f  s year=$o(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year)) q:year=""  d
	.s index=""
	.f  s index=$o(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year,index)) q:index=""  d
	..s mdata=$g(^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid,year,index))
	..q:mdata=""
	..s ListData=$LISTFROMSTRING(mdata,"^")
	..s ^CacheTemp(repid,ind)=ListData	
	..s ind=ind+1
	d ..killTmpGlobal(pid)
	q $$$OK
}

ClassMethod QueryByMonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByMonExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryByMonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByMonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVREPBYMON","QueryRepByMon",pid)
}

/// 获取当前年和月
/// w ##class(web.DHCADVREPBYMON).GetCurrYear()
ClassMethod GetCurrYear()
{
	
	w $zd(+$h,3)
	q ""
}

/// Description: 不良事件按月/季度统计
/// Creator:     yangyongtao
/// CreateDate:  2018-11-24
/// Input:  	 年,事件类型,报告科室,查询类型(MONTH:月,QUART:季)
/// Output:   	 年^数据(明细,合计) Json
/// Others:		 w ##class(web.DHCADVREPBYMON).GetAdvStat("2018,2017,2016,2015","","","MONTH")
/// Others:		 w ##class(web.DHCADVREPBYMON).GetAdvStat("2020","","","MONTH")
ClassMethod GetAdvStat(yearstr As %String, reptype As %String, replocstr As %String, qrytype As %String, params As %String)
{
	n (yearstr,reptype,replocstr,qrytype,params)
	s UserId=$p(params,"^",1)
	s LocId=$p(params,"^",2)
	s GroupId=$p(params,"^",3)
	s LogHospID=$p(params,"^",4) //hxy 2020-02-26 st
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",params)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",params)
	S:QUERYDATE="1" DateNode="OccurDate"
	k ^TMP("web.DHCADVREPBYMON","GetAdvStat")
	s (YearStr,DataStr)=""
	f i=1:1:$l(yearstr,",") d
	.s year=$p(yearstr,",",i)
	.s ^TMP("web.DHCADVREPBYMON","GetAdvStat","YEAR",year)=year
	.s StDate=$zdh(year_"-01-01",3)
	.s EndDate=$zdh(year_"-12-31",3)
	.f date=StDate:1:EndDate d
	..s RepID=""
	..f  s RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) q:RepID=""  d
	...s RepType=$p(^DHCADVMASTER(RepID),"^",2)
	...q:(reptype'="")&&(reptype'=RepType)
	...S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	...s RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	...s RepHospID="",LogHospID="" //hxy 2020-02-26 st
	...s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	...s:LocId'="" LogHospID=$p($g(^CTLOC(+LocId)),"^",22)
	...q:(IFDISTHOSP="1")&(RepHospID'="")&(LogHospID'="")&(LogHospID'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	...q:(replocstr'="")&&((","_replocstr_",")'[(","_RepLocDr_","))
	...S RepList=RepType_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	...S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,params)
	...Q:(flag'="")&&(flag'=1)	
	...s month=$SYSTEM.SQL.MONTH(date)
	...s quart=$SYSTEM.SQL.QUARTER(date)
	...s ^TMP("web.DHCADVREPBYMON","GetAdvStat","COUNT",year)=$g(^TMP("web.DHCADVREPBYMON","GetAdvStat","COUNT",year))+1
	...s ^TMP("web.DHCADVREPBYMON","GetAdvStat","MONTH",year,month)=$g(^TMP("web.DHCADVREPBYMON","GetAdvStat","MONTH",year,month))+1
	...s ^TMP("web.DHCADVREPBYMON","GetAdvStat","QUART",year,quart)=$g(^TMP("web.DHCADVREPBYMON","GetAdvStat","QUART",year,quart))+1
	
	s year=""
	f  s year=$o(^TMP("web.DHCADVREPBYMON","GetAdvStat","YEAR",year)) q:year=""  d
	.s YearStr=$s(YearStr="":year,1:YearStr_"^"_year)
	.i qrytype="MONTH" d
	..s yeardata=""
	..f month=1:1:12 d
	...s monthdata=$g(^TMP("web.DHCADVREPBYMON","GetAdvStat","MONTH",year,month))
	...s:monthdata="" monthdata="0"
	...s yeardata=$s(yeardata="":monthdata,1:yeardata_","_monthdata)
	..s count=$g(^TMP("web.DHCADVREPBYMON","GetAdvStat","COUNT",year))
	..s:count="" count="0"
	..s yeardata=yeardata_","_count
	..s DataStr=$s(DataStr="":yeardata,1:DataStr_"^"_yeardata)
	
	.i qrytype="QUART" d
	..s yeardata=""
	..f quart=1:1:4 d
	...s quartdata=$g(^TMP("web.DHCADVREPBYMON","GetAdvStat","QUART",year,quart))
	...s:quartdata="" quartdata="0"
	...s yeardata=$s(yeardata="":quartdata,1:yeardata_","_quartdata)
	..s count=$g(^TMP("web.DHCADVREPBYMON","GetAdvStat","COUNT",year))
	..s:count="" count="0"
	..s yeardata=yeardata_","_count
	..s DataStr=$s(DataStr="":yeardata,1:DataStr_"^"_yeardata)
	
	w ##class(web.DHCAPPJsonCommon).getJsonData(YearStr,DataStr)
	q ""
}

}
