Import sqluser

Class web.DHCADVSTATISTICS Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 不良反应报告统计
/// Creator:     CongYue
/// CreateDate:  2016-03-04  
/// Input:  	 开始日期^结束日期"12","1","2016-02-02^2016-02-02"
/// Output:   	 医疗报告个数^药品报告个数^器械报告个数^用药安全报告个数^输血报告个数^不良反应报告总数
/// Others:		 d ##class(web.DHCADVSTATISTICS).StatisticReport("10","1","2016-01-01^2016-07-11")
ClassMethod StatisticReport(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End = page*rows
    s Start = (page-1)*rows+1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	D ..killTmpGlobal(pid)
	d ..StaRep(params,pid)
	S typeCode=""
	S Numalls=0
	s h=0, Num=0
	
	F  S typeCode=$o(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,typeCode)) Q:typeCode=""  D
	.S Numall=$p(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,typeCode),"^",3)
	.S ListData=$g(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,typeCode))
	.S ^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,+Numall,typeCode)=ListData
	.S Numalls=Numalls+Numall
	.S h=h+1
	S ^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,"-100","合计")="合计"_"^"_"报告数量"_"^"_Numalls
	
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	S ListTitle="name^group^value"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串
	//W "["
	S count=""
	S index=""
	F  S count=$o(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,count),-1) Q:count=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,count,index)) Q:index=""  D
	..S ListData=$g(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,count,index))
	..Q:ListData=""
	..S Num=Num+1
	..q:(Num<Start)||(Num>End)
	..I Num=Start d
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	..
	.
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	//W "]"
	D ..killTmpGlobal(pid)
	Q ""
}

/// Description: 不良反应报告统计
/// Creator:     CongYue
/// CreateDate:  2016-03-04  
/// Input:  	 开始日期^结束日期"12","1","2016-02-02^2016-02-02"
/// Output:   	 医疗报告个数^药品报告个数^器械报告个数^用药安全报告个数^输血报告个数^不良反应报告总数
/// Others:		 d ##class(web.DHCADVSTATISTICS).StaRep("2016-02-02^2016-03-10")
ClassMethod StaRep(params As %String, pid As %String) As %String
{
	N (params,pid)
	S StDate=$p(params,"^",1)       //开始日期
	S EndDate=$p(params,"^",2)      //结束日期
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)  //$zdh(StDate,3)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)   //$zdh(EndDate,3)
	S Repnum=0
	S NUM=1
	S ID=""
	S typeID="0"
	;F  S typeID=$o(^DHCMEDADREVT(typeID))  Q:typeID=""  D
	;.S typeCode=$p(^DHCMEDADREVT(typeID),"^",1)
	;.S type=$p(^DHCMEDADREVT(typeID),"^",2)
	;.S ^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,typeCode)=type_"^"_"报告数量"_"^"_Repnum	
	F dd=StDate:1:EndDate D
	.;医疗
	.F  S ID=$o(^DHCMEDADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCMEDADRR(ID),"^",27) //当前状态
	..q:StatusID=""
	..S typedr=$p(^DHCMEDADRR(ID),"^",30)
	..q:typedr=""
	..S typeCode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..D ..RepTmp(typeCode,type,NUM,pid)
	.;药品
	.F  S ID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCADVDRUGREP(ID),"^",48) //当前状态
	..q:StatusID=""
	..S typedr=$p(^DHCADVDRUGREP(ID),"^",49)
	..q:typedr=""
	..S typeCode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..D ..RepTmp(typeCode,type,NUM,pid)
	.;器械
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCMATADRR(ID),"^",41) //当前状态
	..q:StatusID=""
	..S typedr=$p(^DHCMATADRR(ID),"^",46)
	..q:typedr=""
	..S typeCode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..D ..RepTmp(typeCode,type,NUM,pid)
	.;用药差错
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCADVMEDSAR(ID),"^",18) //当前状态
	..q:StatusID=""
	..S typedr=$p(^DHCADVMEDSAR(ID),"^",20)
	..q:typedr=""
	..S typeCode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..D ..RepTmp(typeCode,type,NUM,pid)
	.;输血
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..S StatusID=$p(^DHCBLDADVRPT(ID),"^",46) //当前状态
	..q:StatusID=""
	..S typedr=$p(^DHCBLDADVRPT(ID),"^",47)
	..q:typedr=""
	..S typeCode=$p(^DHCMEDADREVT(typedr),"^",1)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..D ..RepTmp(typeCode,type,NUM,pid)
	Q ""
}

/// Description: 临时global
/// Creator:     CongYue
/// CreateDate:  2016-03-11  
/// Input:  	 报告类型代码^报告类型^报告数量^pid
ClassMethod RepTmp(typeCode As %String, type As %String, Num As %String, pid As %String) As %String
{
	N (typeCode,type,Num,pid)
	s index=typeCode
	i $D(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,index)) D
	.S $p(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,index),"^",3)=$p(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,index),"^",3)+Num
	E  S ^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,index)=type_"^"_"报告数量"_"^"_Num
	Q ""
}

/// Description: 不良反应报告分析
/// Creator:     CongYue
/// CreateDate:  2016-03-08  
/// Input:  	 开始日期^结束日期"2016-02-02^2016-02-02"
/// Output:   	 医疗报告个数^药品报告个数^器械报告个数^用药安全报告个数^输血报告个数^不良反应报告总数
/// Others:		 d ##class(web.DHCADVSTATISTICS).AnalysisReport("2016-03-01^2016-04-02")
ClassMethod AnalysisReport(params As %String) As %String
{
	N (params)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	D ..killTmpGlobal(pid)
	d ..StaRep(params,pid)
	S typeCode=""
	S Numall=0
	F  S typeCode=$o(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,typeCode)) Q:typeCode=""  D
	.S Numall=$p(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,typeCode),"^",3)
	.S ListData=$g(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,typeCode))
	.S ^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,+Numall,typeCode)=ListData
	
	S ListTitle="name^group^value"
	W "["
	S Num=0
	S count=""
	S index=""
	F  S count=$o(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,count),-1) Q:count=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,count,index)) Q:index=""  D
	..S ListData=$g(^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid,count,index))
	..Q:ListData=""
	..S Num=Num+1
	..I Num=1 D
	...W ##class(web.DHCADVJSONCOMMON).getSisJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getSisJsonData(ListTitle,ListData)
	..
	.
	W "]"
	D ..killTmpGlobal(pid)
	Q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVSTATISTICS","QueryReportStat",pid)
}

}
