/// description: PC端配液扫描执行
Class web.DHCSTPIVAS.ScanExecute Extends %RegisteredObject
{

/// creator: 	yunhaibao
/// createdate: 2018-03-16
/// description:确认执行
/// input:		条码,用户id,预执行状态标识,单号
/// return: 	string
/// others:		锁及事务在Execute处理数据中
/// w ##class(web.DHCSTPIVAS.ScanExecute).SaveData("571||248||2","711","80",101,"")
ClassMethod SaveData(barCode, userId, psNumber, locId, pogsNo)
{
	//q 0_"|$|"_##class(web.DHCSTPIVAS.PrintCom).GetPrintLabel(27)_"|$|"_14
	s retJson=""
 	s exeRet=##class(web.DHCSTPIVAS.DataHandler).ExecuteByBarCode(barCode, psNumber, userId,locId,pogsNo)
 	q:$p(exeRet,"^",1)'=0 $p(exeRet,"^",1)_"|$|"_$p(exeRet,"^",2)
 	s mOeore=$replace(barCode,"-","||")
 	s mDsp=$o(^DHCOEDISQTY(0,"OEORE",mOeore,""))
 	s grpNo=$p(^DHCOEDISQTY(mDsp),"^",4)
 	s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
 	s labelData=##class(web.DHCSTPIVAS.PrintCom).GetPrintLabel(pogId)
	s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
 	q "0|$|"_labelData_"|$|"_wardId
}

/// creator:    yunhaibao
/// createdate: 2018-03-22
/// description:对应扫描执行,扫描成功后调用后台查询合计数
/// w ##class(web.DHCSTPIVAS.ScanExecute).JsGetScanWardData("101^^2018-04-16^2018-04-18^2018-04-16^2018-04-18^30^^^^^^^^^3,54,56,6,8,9,12,14")
ClassMethod JsGetScanWardData(inputStr, wardId = "")
{
	i wardId'="" s $p(inputStr,"^",2)=wardId
	s collRet=##class(web.DHCSTPIVAS.Execute).CollectExecuteData(inputStr,"JsGetScanWardData")
	s pid=$p(collRet,"^",1)
	s count=+$p(collRet,"^",2)
	q:(pid="")||(count=0) "[]"
	s retJson=""
	s title="wardId^wardDesc^total"
	s record=0
	s wardId=""
	f  s wardId=$o(^||TMP("DHCST","web.DHCSTPIVAS.Execute","CollectExecuteData","JsGetScanWardData",pid,wardId)) q:wardId=""  d
	.s total=+$g(^||TMP("DHCST","web.DHCSTPIVAS.Execute","CollectExecuteData","JsGetScanWardData",pid,wardId))
	.s wardDesc=$p(^PAWARD(wardId),"^",2)
	.s wardDesc=##class(web.DHCSTPIVAS.Common).SubString(wardDesc,20)
	.s data=wardId_"^"_wardDesc_"^"_total
	.s record=record+1
	.i record=1 s retJson=##class(web.DHCSTJQUERYCOMMON).getJsonData(title,data,"^")
	.e  s retJson=retJson_","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,data,"^")
	d ..KillJsGetScanWardData(pid)
	q "["_retJson_"]"
}

/// description: 清除汇总合计数据
ClassMethod KillJsGetScanWardData(pid)
{
	q:pid="" ""
	k ^||TMP("DHCST","web.DHCSTPIVAS.Execute","CollectExecuteData","JsGetScanWardData",pid)
	q ""
}

}
