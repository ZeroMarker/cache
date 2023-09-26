Class web.DHCINPHA.WardIncStat.Global Extends %RegisteredObject
{

/// description: 清除临时global
/// d ##class(web.DHCINPHA.WardIncStat.Global).Kill(pid)
ClassMethod Kill(Pid = "")
{
	i Pid'="" d
	.k ^TMP("DHCST","web.DHCINPHA.WardIncStat.Query","GetWardPatIncData",Pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.WardIncStat.Query","GetWardPatIncData",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.WardIncStat.Query","GetWardPatIncData",pid)
	q ""
}

/// description: 是否允许根据日期删除临时global
/// return:		 Y(允许)
ClassMethod CheckPid(Pid)
{
	q:Pid="" ""
	s ret=""
	i ($e(Pid,1)="D")&&($e(Pid,10)="P")&&($e(Pid,2,9)<$zd((+$h-1),8)) s ret="Y"
	q ret
}

}
