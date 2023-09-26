Import sqluser

/// Description: 不良事件
/// Creator:     yangyongtao
/// CreateDate:  2017-09-15 
Class web.DHCADVREPBYQAU Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 不良事件按季度统计
/// Creator:     yangyongtao
/// CreateDate:  2017-09-15 
/// Input:  	 年份^报告类型^季度"
/// Output:   	 季度^器械的数量^器械的总数量
/// Others:		 d ##class(web.DHCADVREPBYQAU).QueryRepByQau("12","1","2017")
ClassMethod QueryRepByQau(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
    s Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s DateYear=$p(params,"^",1) //年份
	S TypeEvent=$p(params,"^",2) //类型
	S SeasonType=$p(params,"^",3) //季度
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	s h=0,count=0
	S Numalls=1  //合计初始化
    s Num=1       //月份器械类型数量统计初始化
	i SeasonType=""  s SeasonType="1,2,3,4"
    f SeasonLength=1:1:$l(SeasonType,",") d
    .s Season=$p(SeasonType,",",SeasonLength)
    .I Season=1  s StDate=DateYear_"-01-01"  s EndDate=DateYear_"-03-31"  
    .I Season=2  s StDate=DateYear_"-04-01"  s EndDate=DateYear_"-06-30" 
    .I Season=3  s StDate=DateYear_"-07-01"  s EndDate=DateYear_"-09-30"  
    .I Season=4  s StDate=DateYear_"-10-01"  s EndDate=DateYear_"-12-31"  
	.s StDate=$zdh(StDate,3)
	.s EndDate=$zdh(EndDate,3)
	.f date=StDate:1:EndDate d
	
	..;不良事件类型统计
	..s RepID=""
	..f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	...S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	...S:RepTypeDr'="" RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	...Q:(TypeCode'="")&(TypeCode'=RepTypeCode)
	...S:RepTypeDr'="" RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	...S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	...Q:RepStausDr="" 
	...i $d(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season))  d
	....S $p(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season),"^",3)+1
	....S Numalls=Numalls+1
	...E  d
	....s h=h+1  
	....S ^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season)=Season_"^"_"报告数量"_"^"_Num


	S ^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,100)="合计:"_"^"_"报告数量"_"^"_Numalls
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	///转换数据为Json格式
	S Title="name^group^value"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description: 不良事件按季度统计分析
/// Creator:     yangyongtao
/// CreateDate:  2017-09-15 
/// Input:  	 年份^报告类型^季度"
/// Output:   	 季度^器械的数量^器械的总数量
/// Others:		 d ##class(web.DHCADVREPBYQAU).AnalysisRepByQau("2017^^")
ClassMethod AnalysisRepByQau(params As %String) As %String
{
	n (params)
    S pid=##class(web.DHCADVCOMMON).NewPid()  //调用计数器类并给其赋值
    d ..killTmpGlobal(pid) //k掉临时global
    s DateYear=$p(params,"^",1) //年份
	S TypeEvent=$p(params,"^",2) //类型
	S SeasonType=$p(params,"^",3) //季度
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	s h=0,count=0
	S Numalls=0   //合计初始化
    s Num=1       //月份器械类型数量统计初始化
	i SeasonType=""  s SeasonType="1,2,3,4"
    f SeasonLength=1:1:$l(SeasonType,",") d
    .s Season=$p(SeasonType,",",SeasonLength)
    .q:Season="" 
    .I Season=1  s StDate=DateYear_"-01-01"  s EndDate=DateYear_"-03-31"  
    .I Season=2  s StDate=DateYear_"-04-01"  s EndDate=DateYear_"-06-30" 
    .I Season=3  s StDate=DateYear_"-07-01"  s EndDate=DateYear_"-09-30"  
    .I Season=4  s StDate=DateYear_"-10-01"  s EndDate=DateYear_"-12-31"  
	.s StDate=$zdh(StDate,3)
	.s EndDate=$zdh(EndDate,3)
	.f date=StDate:1:EndDate d
	
	..;不良事件类型统计
	..s RepID=""
	..f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	...S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	...S:RepTypeDr'="" RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	...Q:(TypeCode'="")&(TypeCode'=RepTypeCode)
	...S:RepTypeDr'="" RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	...S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	...Q:RepStausDr="" 
	...i $d(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season))  d
	....S $p(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season),"^",3)=$p(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season),"^",3)+1
	...E  S ^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,Season)="第"_Season_"季度"_"^"_"报告数量"_"^"_Num
	
	///转换数据为Json格式
	S Title="name^group^value"
	W "["    
	S Num=0
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryRepByQau",pid,index))
	.Q:mdate=""
	.S Num=Num+1
	.I Num=1 D
	..W ##class(web.DHCADVJSONCOMMON).getSisJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getSisJsonData(Title,mdate)
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
/// d ##class(%ResultSet).RunQuery("web.DHCADVREPBYQAU","GetRepType")
Query GetRepType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select MADREV_RowID as id, MADREV_Desc as name from DHC_MedAdrRepEvent
}

/// Description: 按季度统计不良事件数量
/// Creator:     yangyongtao
/// CreateDate:  2017-09-18 
/// Input:  	 年份^类型^季度  DateYear^TypeEvent^SeasonType
/// Output:   	 季度^数量  Season^Num
/// Others:		 d ##class(web.DHCADVREPBYQAU).GetByQau("12","1","2017^76")
ClassMethod GetByQau(pid As %String, DateYear As %String, TypeEvent As %String, SeasonType As %String) As %String
{
	//N (pid,params) params As %String
	//S ^TMP("YYT")=DateYear_"!!"_TypeEvent_"!!"_SeasonType
	N (pid,DateYear,TypeEvent,SeasonType)
    d ..killTmpGlobal(pid) //k掉临时global
    //s DateYear=$p(params,"^",1) //年份
	//S TypeEvent=$p(params,"^",2) //类型
	//S SeasonType=$p(params,"^",3) //季度
	i TypeEvent'="" d
	.s TypeCode=$p(^DHCMEDADREVT(TypeEvent),"^",1)
	e  d
	.s TypeCode=""
	s h=0,count=0
    s Num=1       //类型数量统计初始化
	i SeasonType=""  s SeasonType="1,2,3,4"
    f SeasonLength=1:1:$l(SeasonType,",") d
    .s Season=$p(SeasonType,",",SeasonLength)
    .I Season=1  s StDate=DateYear_"-01-01"  s EndDate=DateYear_"-03-31"  
    .I Season=2  s StDate=DateYear_"-04-01"  s EndDate=DateYear_"-06-30" 
    .I Season=3  s StDate=DateYear_"-07-01"  s EndDate=DateYear_"-09-30"  
    .I Season=4  s StDate=DateYear_"-10-01"  s EndDate=DateYear_"-12-31"  
	.s StDate=$zdh(StDate,3)
	.s EndDate=$zdh(EndDate,3)
	.f date=StDate:1:EndDate d
	
	..;不良事件类型统计
	..s RepID=""
	..f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	...S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	...S:RepTypeDr'="" RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	...S:RepTypeDr'="" RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	...S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	...Q:(TypeCode'="")&(TypeCode'=RepTypeCode)
	...Q:RepStausDr="" 
	...i $d(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryByQau",pid,Season))  d
	....S $p(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryByQau",pid,Season),"^",2)=$p(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryByQau",pid,Season),"^",2)+1
	...E  d
	....S ^TMP("DHCADV","web.DHCADVREPBYQAU","QueryByQau",pid,Season)=Season_"^"_Num
	
	Q ""
}

///   D ##class(%ResultSet).RunQuery("web.DHCADVREPBYQAU","QueryByQau","2017","","")
Query QueryByQau(DateYear As %String, TypeEvent As %String, SeasonType As %String) As %Query(ROWSPEC = "Season:%String,Num:%Integer") [ SqlProc ]
{
}

ClassMethod QueryByQauExecute(ByRef qHandle As %Binary, DateYear As %String, TypeEvent As %String, SeasonType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	I (DateYear="")  q $$$OK  //||(TypeEvent="")||(SeasonType="")
	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ##Class(web.DHCADVREPBYQAU).GetByQau(pid,DateYear,TypeEvent,SeasonType)
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryByQau",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCADV","web.DHCADVREPBYQAU","QueryByQau",pid,index))
	.q:mdata=""
	.s ListData=$LISTFROMSTRING(mdata,"^")
	.s ^CacheTemp(repid,ind)=ListData	
	.s ind=ind+1
	d ..killTmpGlobal(pid)
	q $$$OK
}

ClassMethod QueryByQauClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByQauExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryByQauFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByQauExecute ]
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
	k ^TMP("DHCADV","web.DHCADVREPBYQAU","QueryByQau",pid)
}

}
