Import sqluser

/// Descript:用药错误报告业务类
Class web.DHCSTPHCMDRGMISREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询用药错误报告
/// w ##class(web.DHCSTPHCMADRREPORT).QueryDrgMisuseReport("30","1","")
ClassMethod QueryDrgMisuseReport(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S pid=..NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S StDate=$p(params,"^",1)   //开始日期
	S EndDate=$p(params,"^",2)   //结束日期
	d ..killTmpGlobal(pid)
	
	S StDate=$zdh(StDate,3)
	S EndDate=$zdh(EndDate,3)
	S QuitFlag=0
	S Num=0
	F dd=StDate:1:EndDate D
	.S dgERepID=""
	.F  S dgERepID=$o(^DHCPHDQER(0,"RepDate",dd,dgERepID)) Q:dgERepID=""  D
	..S dgERepLoc=$p(^DHCPHDQER(dgERepID),"^",1)  //报告科室
	..S dgERepDate=$p(^DHCPHDQER(dgERepID),"^",2) //日期
	..I dgERepDate'="" S dgERepDate=$zd(dgERepDate,3)
	..S dgEPatID=$p(^DHCPHADRR(dgERepID),"^",3) //病人ID
	..S dgEPatName=$p(^DHCPHDQER(dgERepID),"^",8) //病人姓名
	..S dgEPatMedNo=$p(^DHCPHADRR(dgERepID),"^",15) //病历号/门诊号
	..S dgEReporter=$p(^DHCPHDQER(dgERepID),"^",30) //报告人
	..S dgERepAuditUser="" //审核人
	..S dgERepAuditDate="" //审核时间
	..S AdrPatNo="",InMedicare=""
	..I dgEPatID'="" d
	...S dgEPatNo=$p(^PAPER(dgEPatID,"PAT",1),"^",1) //登记号
	...S InMedicare=$p($g(^PAPER(dgEPatID,"PAT",3)),"^",4) //病案号
	..S dgERepStatus=""  //当前状态
	..S ListData=dgERepID_"^"_dgEPatNo_"^"_dgEPatName_"^"_dgERepStatus_"^"_dgERepLoc_"^"_dgEReporter_"^"_dgERepDate_"^"_dgERepAuditUser_"^"_dgERepAuditDate
	..
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMDRGMISREPORT","QueryDrgMisuseReport",pid,Num)=ListData
	
	Q:Num="0" ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串

	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMDRGMISREPORT","QueryDrgMisuseReport",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMDRGMISREPORT","QueryDrgMisuseReport",pid,index)
	.S Title="dgERepID^dgEPatNo^dgEPatName^dgERepStatus^dgERepLoc^dgEReporter^dgERepDate^dgERepAudUser^dgERepAudDate"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMDRGMISREPORT","QueryDrgMisuseReport",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMDRGMISREPORT"))
}

}
