/// creator:	yunhaibao
/// createdate: 2018-10-25
/// description:病区发退药输出数据
Class web.DHCINPHA.DispRetStat.Display Extends %RegisteredObject
{

/// description: 病区汇总
/// w ##class(web.DHCINPHA.DispRetStat.Display).EuiGetWardStat("1","100","","","2018-01-01|@|2018-09-09|@|98")
ClassMethod EuiGetWardStat(page, rows, sort, order, InputStr, Pid = "")
{
	s ^TMPDHCSTPARAMS("web.DHCINPHA.DispRetStat.Display","EuiGetWardStat")=$lb(page, rows,sort,order, InputStr,Pid)
	s $zt="ThrowEuiGetWardStat"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:InputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	i Pid="" d
	.d ##class(web.DHCINPHA.DispRetStat.Global).Kill()
	.s retData=##class(web.DHCINPHA.DispRetStat.Query).GetDispRetData(InputStr)
	.s pid=$p(retData,"^",1)
	e  s pid=Pid
	q:(pid="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	// 排序
	k EuiGetWardStatData
	s qcName="web.DHCINPHA.DispRetStat.Query"
	s sortNum="",sortType=""
	i sort'="" d
	.i sort="Ward" s sortNum=3
	.e  i sort="PhaDispAmt" s sortNum=1,sortType="Number"
	.e  i sort="PhaRetAmt" s sortNum=2,sortType="Number"
	.e  i sort="PhaDispSum" s sortNum=4,sortType="Number"
	s (dispSpAmtTotal,retSpAmtTotal,totalSpAmtTotal)=0
	s record=0
	s sortIndex=""
	f  s sortIndex=$o(^TMP("DHCST",qcName,"GetDispRetData","WardStat",pid,sortIndex)) q:sortIndex=""  d
	.s wardLocId=""
	.f  s wardLocId=$o(^TMP("DHCST",qcName,"GetDispRetData","WardStat",pid,sortIndex,wardLocId)) q:wardLocId=""  d
	..s totalData=^TMP("DHCST",qcName,"GetDispRetData","WardStat",pid,sortIndex,wardLocId)
	..s dispSpAmt=$zabs($p(totalData,"^",1))
	..s retSpAmt=$zabs($p(totalData,"^",2))
	..s totalSpAmt=dispSpAmt-retSpAmt
	..s $p(totalData,"^",4)=totalSpAmt
	..s $p(totalData,"^",1)=dispSpAmt
	..s $p(totalData,"^",2)=retSpAmt
	..s dispSpAmtTotal=dispSpAmtTotal+dispSpAmt
	..s retSpAmtTotal=retSpAmtTotal+retSpAmt
	..// dispamt,retamt,warddesc
	..i sortNum="" s sortData=sortIndex
	..e  s sortData=$p(totalData,"^",sortNum)
	..i sortData="" d
	...i sortType="Number" s sortData=0
	...e  s sortData="ZSTRING"
	..s record=record+1
	..s EuiGetWardStatData(sortData,record)=totalData
	s totalSpAmtTotal=dispSpAmtTotal-retSpAmtTotal
	s colNameStr1="Ward^PhaDispAmt^PhaRetAmt^PhaDispSum^ProcessID"
	s colNameStr2="WardRowid"
	s colNameStr=colNameStr1_"^"_colNameStr2
	i $zcvt(order,"U")="DESC" s order=-1
	e  s order=1
	s count=0
	s sortIndex=""
	f  s sortIndex=$o(EuiGetWardStatData(sortIndex),order) q:sortIndex=""  d
	.s record=""
	.f  s record=$o(EuiGetWardStatData(sortIndex,record),order) q:record=""  d
	..s count=count+1
	..q:count<StartRow
	..q:count>EndRow
	..s wardData=EuiGetWardStatData(sortIndex,record)
	..s dispSpAmt=$fn($p(wardData,"^",1),"N")
	..s retSpAmt=$fn($p(wardData,"^",2),"N")
	..s totalSpAmt=$fn($p(wardData,"^",4),"N")
	..s wardDesc=$p(wardData,"^",3)
	..s wardLocId=$p(wardData,"^",5)
	..s colDataStr=wardDesc_"^"_dispSpAmt_"^"_retSpAmt_"^"_totalSpAmt_"^"_pid_"^"_wardLocId
	..i count=StartRow d
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	..e  d
	...w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	i $d(colDataStr) d
	.w "],""total"":"""_count_""","
	.s colDataStr="总计"_"^"_$fn(dispSpAmtTotal,"N")_"^"_$fn(retSpAmtTotal,"N")_"^"_$fn(totalSpAmtTotal,"N")_"^"_pid_"^"_""
	.w """footer"":["
	.w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.w "]}" 
	 e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetWardStat
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

/// description: 发退药汇总明细
/// w ##class(web.DHCINPHA.DispRetStat.Display).EuiGetWardDetail("1","100","D20181030P11","247")
ClassMethod EuiGetWardDetail(page, rows, Pid, WardLocId)
{
	s ^TMPDHCSTPARAMS("web.DHCINPHA.DispRetStat.Display","ThrowEuiGetWardDetail")=$lb(page, rows, Pid, WardLocId)
	q:(Pid="")||(WardLocId="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s qcName="web.DHCINPHA.DispRetStat.Query"
	q:'$d(^TMP("DHCST",qcName,"GetDispRetData","WardStatDetail",Pid,WardLocId)) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s $zt="ThrowEuiGetWardDetail"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	k EuiGetWardDetailData
	s total=0
	s dtIndex=""
	f  s dtIndex=$o(^TMP("DHCST",qcName,"GetDispRetData","WardStatDetail",Pid,WardLocId,dtIndex)) q:dtIndex=""  d
	.s pointIndex=""
	.f  s pointIndex=$o(^TMP("DHCST",qcName,"GetDispRetData","WardStatDetail",Pid,WardLocId,dtIndex,pointIndex)) q:pointIndex=""  d
	..s incId=""
	..f  s incId=$o(^TMP("DHCST",qcName,"GetDispRetData","WardStatDetail",Pid,WardLocId,dtIndex,pointIndex,incId)) q:incId=""  d
	...s total=total+1
	...q:total<StartRow
	...q:total>EndRow
	...s detailData=^TMP("DHCST",qcName,"GetDispRetData","WardStatDetail",Pid,WardLocId,dtIndex,pointIndex,incId)
	...//spAmt_"^"_qty_"^"_intrDate_"^"_intrTime_"^"_pointer_"^"_intrType
	...s spAmt=$p(detailData,"^",1)
	...s qty=$p(detailData,"^",2)
	...i $p(qty,".",2)>6 s qty=$fn(qty,"",3)
	...s spAmt=$fn($zabs(spAmt),"N")
	...s qty=$fn($zabs(qty),"N")
	...s intrDate=$p(detailData,"^",3)
	...s intrDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(intrDate)
	...s intrTime=$p(detailData,"^",4)
	...s intrTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(intrTime)
	...s pointerMain=+$p(detailData,"^",5)
	...s intrType=$p(detailData,"^",6)
	...s typeDesc=$s(intrType="P":"发药",1:"退药")
	...s incDesc=$p(^INCI(incId,1),"^",2)
	...s incCode=$p(^INCI(incId,1),"^",1)
	...s uomId=$p(^INCI(incId,1),"^",10)
	...s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2)
	...i intrType="P" s intrNo=$p($g(^DHCPHAC(pointerMain)),"^",14)
	...e  i intrType="Y" s intrNo=$p(^PHARET(pointerMain),"^",7)
	...s colDataStr1=intrDateHtml_"^"_intrTimeHtml_"^"_typeDesc_"^"_incCode_"^"_incDesc
	...s colDataStr2=qty_"^"_uomDesc_"^"_spAmt_"^"_intrNo
	...s colDataStr=colDataStr1_"^"_colDataStr2
	...s EuiGetWardDetailData(total)=colDataStr
	s colNameStr1="RetDate^RetTime^IssueType^Code^Desc"
	s colNameStr2="RetQty^Uom^RetAmt^IntrNo"
	s colNameStr=colNameStr1_"^"_colNameStr2
	s count=0
	s outputI=""
	f  s outputI=$o(EuiGetWardDetailData(outputI)) q:outputI=""  d
	.s colDataStr=EuiGetWardDetailData(outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k EuiGetWardDetailData
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetWardDetail
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

}
