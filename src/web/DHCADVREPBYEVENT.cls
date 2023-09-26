Import sqluser

Class web.DHCADVREPBYEVENT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 按事件类型数量
/// Creator:     yangyongtao
/// CreateDate:  2017-09-26  
/// Input:  	 开始日期^结束日期"12","1","2017-01-01^2017-09-26"
/// Output:   	 护理^院感^医疗^信息安全^药品^工程安全^食品安全^行政及其他^输血^器械^生物安全^职业暴露^公共设施^治安消防^不良反应报告总数
/// Others:		 d ##class(web.DHCADVREPBYEVENT).StatisticReport("10","1","2017-01-01^2017-09-30")
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
	
	F  S typeCode=$o(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,typeCode)) Q:typeCode=""  D
	.S Numall=$p(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,typeCode),"^",3)
	.S ListData=$g(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,typeCode))
	.S ^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,+Numall,typeCode)=ListData
	.S Numalls=Numalls+Numall
	.S h=h+1
	S ^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,"-100","合计")="合计"_"^"_"报告数量"_"^"_Numalls
	
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	S ListTitle="name^group^value^code"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h+1) //输出json前缀串
	//W "["
	S count=""
	S index=""
	F  S count=$o(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,count),-1) Q:count=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,count,index)) Q:index=""  D
	..S ListData=$g(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,count,index))
	..Q:$p(ListData,"^",3)=0
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

/// Description: 按事件类型数量
/// Creator:     yangyongtao
/// CreateDate:  2017-09-26  
/// Input:  	 开始日期^结束日期"12","1","2017-01-01^2017-09-26" LgParam：人员^科室^安全组^医院
/// Output:   	 护理^院感^医疗^信息安全^药品^工程安全^食品安全^行政及其他^输血^器械^生物安全^职业暴露^公共设施^治安消防^不良反应报告总数
/// Others:		 d ##class(web.DHCADVREPBYEVENT).StaRep("2018-01-02^2018-03-10^^^")
ClassMethod StaRep(params As %String, pid As %String, LgParam) As %String
{
	N (params,pid,%session,LgParam)
	S StDate=$p(params,"^",1)     //开始日期
	S EndDate=$p(params,"^",2)    //结束日期
	S UserId=$p(LgParam,"^",1)     //用户ID
	S LocId=$p(LgParam,"^",2)      //科室ID
	S GroupId=$p(LgParam,"^",3)    //安全组ID
	s HospId=$p(LgParam,"^",4) 	   //医院ID
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",LgParam)
	S:QUERYDATE="1" DateNode="OccurDate"
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)  //$zdh(StDate,3)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)   //$zdh(EndDate,3)
	S Repnum=0
	S NUM=1
	S typeID="0"
	F  S typeID=$o(^DHCMEDADREVT(typeID))  Q:typeID=""  D
	.Q:'(($d(^DHCADVQUS(0,"RepType",typeID,1,GroupId)))||($d(^DHCADVQUS(0,"RepType",typeID,2,LocId)))||($d(^DHCADVQUS(0,"RepType",typeID,3,UserId))))
	.S typeCode=$p(^DHCMEDADREVT(typeID),"^",1)
	.S type=$p(^DHCMEDADREVT(typeID),"^",2)
	.S CH=""
	.F  S CH=$o(^DHCMEDADREVTI(typeID,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(typeID,"MADREVI",CH),"^",1) //代码
	..S Desc=$p(^DHCMEDADREVTI(typeID,"MADREVI",CH),"^",2) //描述
	..Q:Code'["adv"
	..Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(Code)))  ;去除不是表单的类型
	..Q:(Code'="")&&(##class(web.DHCADVFormName).CheckFormName(Code,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S Desc=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEventItm","MADREVIDesc","",Desc)
	..S ^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,Code)=Desc_"^"_"报告数量"_"^"_Repnum_"^"_Code
	.Q:typeCode'["adv"
	.Q:($d(^DHCMEDADREVTI(typeID,"MADREVI")))  ;去除带有子元素的类型
	.Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(typeCode)))  ;去除不是表单的类型
	.Q:(typeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(typeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	.S type=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEvent","MADREVDesc","",type)
	.S ^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,typeCode)=type_"^"_"报告数量"_"^"_Repnum_"^"_typeCode
	F date=StDate:1:EndDate D
	.S RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,DateNode,date,RepID)) q:RepID=""  d
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") typeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") typeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..Q:(typeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(typeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..I (RepTypeDr'="")&&(RepTypeDr'["||") D
	...S type=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	...s type=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEvent","MADREVDesc","",type)
	..I (RepTypeDr'="")&&(RepTypeDr["||")  D
	...S type=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	...s type=##class(web.DHCADVCOMMON).GetTransDesc("User.DHCMedAdrRepEventItm","MADREVIDesc","",type)
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..S RepCancelflag=""
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..;Q:RepStausDr=""  ;2018-01-11  统计所有填写的报告
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..s RepHospID="",LogHospID="" //hxy 2020-02-18 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..s:LocId'="" LogHospID=$p($g(^CTLOC(+LocId)),"^",22)
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(LogHospID'="")&(LogHospID'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..;Q:(LocId'="")&&(LocId'=RepLocDr)
	..S GroupDesc="",flag="",Secuflag="",SecuLocflag=""
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S:UserId'="" flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:(flag'="")&&(flag'=1)
	..D ..RepTmp(typeCode,type,NUM,pid)
	Q ""
}

/// Description: 临时global
/// Creator:     yangyongtao
/// CreateDate:  2017-09-26  
/// Input:  	 报告类型代码^报告类型^报告数量^pid
ClassMethod RepTmp(typeCode As %String, type As %String, Num As %String, pid As %String) As %String
{
	N (typeCode,type,Num,pid)
	s index=typeCode
	i $D(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,index)) D
	.S $p(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,index),"^",3)=$p(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,index),"^",3)+Num
	E  S ^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,index)=type_"^"_"报告数量"_"^"_Num_"^"_typeCode
	Q ""
}

/// Description: 按事件类型数量分析
/// Creator:     yangyongtao
/// CreateDate:  2017-09-26  
/// Input:  	 开始日期^结束日期"12","1","2017-01-01^2017-09-26"
/// Output:   	 护理^院感^医疗^信息安全^药品^工程安全^食品安全^行政及其他^输血^器械^生物安全^职业暴露^公共设施^治安消防^不良反应报告总数
/// Others:		 d ##class(web.DHCADVREPBYEVENT).AnalysisReport("2017-01-01^2021-12-31^13922^113^29")
ClassMethod AnalysisReport(params As %String, LgParam As %String) As %String
{
	N (params,%session,LgParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	D ..killTmpGlobal(pid)
	d ..StaRep(params,pid,LgParam)
	S typeCode=""
	S Numall=0
	F  S typeCode=$o(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,typeCode)) Q:typeCode=""  D
	.S Numall=$p(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,typeCode),"^",3)
	.S ListData=$g(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,typeCode))
	.S ^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,+Numall,typeCode)=ListData
	
	S ListTitle="name^group^value"
	W "["
	S Num=0
	S count=""
	S index=""
	F  S count=$o(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,count),-1) Q:count=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,count,index)) Q:index=""  D
	..S ListData=$g(^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid,count,index))
	..Q:$p(ListData,"^",3)=0
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
	k ^TMP("DHCADV","web.DHCADVREPBYEVENT","QueryReportStat",pid)
}

}
