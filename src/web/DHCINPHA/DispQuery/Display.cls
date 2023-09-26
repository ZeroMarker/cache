/// creator:	yunhaibao
/// createdate: 2018-10-24
/// description:住院已发药查询输出数据,仅用于传递参数转换格式输出界面
Class web.DHCINPHA.DispQuery.Display Extends %RegisteredObject
{

/// description: 发药单表格
/// w ##class(web.DHCINPHA.DispQuery.Display).EuiGetPHACollected("1","100","","","24/09/2018|@|24/10/2018|@|98|@||@||@||@|00:00|@|23:59|@||@||@||@||@|")
ClassMethod EuiGetPHACollected(page, rows, sort, order, InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCINPHA.DispQuery.Display","EuiGetPHACollected")=$lb(page, rows,sort,order, InputStr)
	s $zt="ThrowEuiGetPHACollected"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:InputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCINPHA.DispQuery.Query).GetPHACollected(StartRow, EndRow, InputStr)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="Tcoll^TWard^TDispCat^TDateScope^TStatus"
	s colNameStr2="TPrintDate^TPrintTime^TCollectDate^TCollectTime^TOperUser"
	s colNameStr3="TCollectUser^TDispNo^TSendAutoFlag^Tpid"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3
	s outputI=""
	f  s outputI=$o(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollected",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollected",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollected",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetPHACollected
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

/// description: 发药单汇总表格
/// w ##class(web.DHCINPHA.DispQuery.Display).EuiGetPHACollTotal("1","100","","","170","26/12/2019|@|27/12/2019|@|246|@||@||@||@|00:00:00|@|23:59:59|@||@|DHSZHYYZYPHADISP20191226005|@||@||@|")
ClassMethod EuiGetPHACollTotal(page, rows, sort, order, PhacIdStr, InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCINPHA.DispQuery.Display","EuiGetPHACollTotal")=$lb(page, rows, sort, order, PhacIdStr,InputStr)
	s $zt="ThrowEuiGetPHACollTotal"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:PhacIdStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCINPHA.DispQuery.Query).GetPHACollTotal(StartRow, EndRow,PhacIdStr, InputStr)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="Tincicode^Tincidesc^Tqty^Tinciamt^Tgenedesc"
	s colNameStr2="Tphcform^Tspec^Tmanf^Tuom^Tprice"
	s colNameStr3="Tresqty^Tresdata"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3
	s outputI=""
	f  s outputI=$o(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollTotal",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollTotal",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollTotal",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetPHACollTotal
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

/// description: 发药单明细表格
/// w ##class(web.DHCINPHA.DispQuery.Display).EuiGetPHACollDetail("1","100","","","300,301,302,303,304,305,306,307,308,309,310","")
ClassMethod EuiGetPHACollDetail(page, rows, sort, order, PhacIdStr, InputStr)
{
	i rows="" s page=1,rows=99999
	s ^TMPDHCSTPARAMS("web.DHCINPHA.DispQuery.Display","EuiGetPHACollDetail")=$lb(page, rows, sort, order, PhacIdStr,InputStr)
	s $zt="ThrowEuiGetPHACollDetail"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:PhacIdStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCINPHA.DispQuery.Query).GetPHACollDetail(StartRow, EndRow,PhacIdStr, InputStr)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="TAdmLoc^TBedNo^TPaName^TRegNo^TOld"
	s colNameStr2="TOrdItemDesc^TQty^TSalePrice^TStotal^TDispCat"
	s colNameStr3="TDoseQty^TFreq^TPrescno^TInstruction^TJYType"
	s colNameStr4="TDuration^TStatus^TBatchNo^TDiag^TDoctor"
	s colNameStr5="TDoseDate^TEncryptLevel^TPatLevel^TManf^TOeoriDate"
	s colNameStr6="TDoseTimes"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4_"^"_colNameStr5_"^"_colNameStr6
	s outputI=""
	f  s outputI=$o(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollDetail",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollDetail",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollDetail",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetPHACollDetail
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

}
