/// creator:	yunhaibao
/// createdate: 2018-10-19
/// description:住院发药涉及的所有global说明以及清除
Class web.DHCINPHA.Disp.Global Extends %RegisteredObject
{

/// description: 病区查询-输出，输出后已K
/// d ##class(web.DHCINPHA.Disp.Global).KillGetDispWardCats(newPid)
ClassMethod KillGetDispWardCats(Pid = "")
{
	i Pid'="" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",Pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid)
	q ""
}

/// description: 明细汇总查询-输出,输出后已K
ClassMethod KillJqDispOutput(Pid = "")
{
	i Pid'="" d
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmData",Pid)
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","OeoriData",Pid)
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","IncData",Pid)
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",Pid)
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispDetail","OutPut",Pid)
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","OutPut",Pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmData",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmData",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","OeoriData",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","OeoriData",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","IncData",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","IncData",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","OutPut",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","OutPut",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispDetail","OutPut",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispDetail","OutPut",pid)
	q ""
}

/// description: 明细与汇总,分页会从临时global遍历(注意入参!)
/// d ##class(web.DHCINPHA.Disp.Query).KillCollDispData()
ClassMethod KillCollDispData(Pid = "")
{
	i Pid'="" d
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispTotal",Pid)
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispDetail",Pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispTotal",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispTotal",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispDetail",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispDetail",pid)
	q ""
}

/// description: 发药保存,遍历此global,以及保存过程涉及的其他
ClassMethod KillSaveData(Pid = "")
{
	i Pid'="" d
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid)		// 保存遍历
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",Pid)	// 取消勾选存储
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",Pid)		// 欠费数据
	.k ^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmOweFee",Pid)		// 欠费数据
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmOweFee",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmOweFee",pid)
	q ""
}

/// description: 重新查询明细时K
ClassMethod KillQuerySave(Pid)
{
	d ..KillSaveData(Pid)
	d ..KillCollDispData(Pid)
	q ""
}

/// description: 病区记录的临时发药类别
ClassMethod KillSetTmpWardCats(Pid)
{
	i Pid'="" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SetTmpWardCats",Pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SetTmpWardCats",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SetTmpWardCats",pid)
	q ""
}

/// description: 清除库存不足的临时global
ClassMethod KillSaveDataNoStock(Pid)
{
	i Pid'="" k ^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid)
	s pid=""
	f  s pid=$o(^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",pid)) q:pid=""  d
	.i ..CheckPid(pid)="Y" k ^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",pid)
	q ""
}

/// description: 随时可运行,全K
ClassMethod KillAnyTime()
{
	d ..KillGetDispWardCats()
	d ..KillSaveData()
	d ..KillCollDispData()
	d ..KillJqDispOutput()
	q ""
}

/// description: 是否允许根据日期删除临时global
/// return:		 Y(允许)
/// w ##class(web.DHCINPHA.Disp.Global).CheckPid("D20181022P123")
ClassMethod CheckPid(Pid)
{
	q:Pid="" ""
	s ret=""
	i ($e(Pid,1)="D")&&($e(Pid,10)="P")&&($e(Pid,2,9)<$zd((+$h-1),8)) s ret="Y"
	q ret
}

}
