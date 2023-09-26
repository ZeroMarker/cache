/// creator:	yunhaibao
/// createdate: 2018-10-26
/// description:病区发药特定查询输出
Class web.DHCINPHA.WardIncStat.Display Extends %RegisteredObject
{

/// description: 发退药汇总明细
/// w ##class(web.DHCINPHA.WardIncStat.Display).EuiGetWardPatInc("1","100","26/01/2018|@|26/09/2018|@|00:00|@|23:59|@||@||@|中西医结合一科护理单元|@|98|@||@||@|","")
ClassMethod EuiGetWardPatInc(page, rows, InputStr, Pid = "")
{
	s ^TMPDHCSTPARAMS("web.DHCINPHA.WardIncStat.Display","EuiGetWardPatInc")=$lb(page, rows,InputStr, Pid)
	q:(Pid="")&&(InputStr="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s qcName="web.DHCINPHA.WardIncStat.Query"
	s $zt="ThrowEuiGetWardPatInc"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	i Pid="" d
	.d ##class(web.DHCINPHA.DispRetStat.Global).Kill()
	.s retData=##class(web.DHCINPHA.WardIncStat.Query).GetWardPatIncData(InputStr)
	.s pid=$p(retData,"^",1)
	e  s pid=Pid
	q:(pid="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	k EuiGetWardPatIncData
	s spAmtTotal=0
	s total=0
	s sortIndex=""
	f  s sortIndex=$o(^TMP("DHCST",qcName,"GetWardPatIncData",pid,sortIndex)) q:sortIndex=""  d
	.s incId=""
	.f  s incId=$o(^TMP("DHCST",qcName,"GetWardPatIncData",pid,sortIndex,incId)) q:incId=""  d
	..s detailData=^TMP("DHCST",qcName,"GetWardPatIncData",pid,sortIndex,incId)
	..s spAmtTotal=spAmtTotal+$p(detailData,"^",1)
	..s total=total+1
	..q:total<StartRow
	..q:total>EndRow
	..//spAmt_"^"_qty_"^"_patNo_"^"_patName
	..s spAmt=$p(detailData,"^",1)
	..s qty=$p(detailData,"^",2)
	..i $p(qty,".",2)>6 s qty=$fn(qty,"",3)
	..s spAmt=$fn($zabs(spAmt),"N")
	..s qty=$fn($zabs(qty),"N")
	..s patNo=$p(detailData,"^",3)
	..s patName=$p(detailData,"^",4)
	..s incDesc=$p(^INCI(incId,1),"^",2)
	..s incCode=$p(^INCI(incId,1),"^",1)
	..s uomId=$p(^INCI(incId,1),"^",10)
	..s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2)
	..s colDataStr1=patNo_"^"_patName_"^"_incCode_"^"_incDesc_"^"_qty
	..s colDataStr2=uomDesc_"^"_spAmt_"^"_pid
	..s colDataStr=colDataStr1_"^"_colDataStr2
	..s EuiGetWardPatIncData(total)=colDataStr
	s colNameStr1="patNo^patName^incCode^incDesc^qty"
	s colNameStr2="uomDesc^spAmt^pid"
	s colNameStr=colNameStr1_"^"_colNameStr2
	k colDataStr
	s count=0
	s outputI=""
	f  s outputI=$o(EuiGetWardPatIncData(outputI)) q:outputI=""  d
	.s count=count+1
	.s colDataStr=EuiGetWardPatIncData(outputI)
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k EuiGetWardPatIncData
	i $d(colDataStr) d
	.w "],""total"":"""_total_""","
	.s colDataStr=""
	.s $p(colDataStr,"^",8)=""
	.s $p(colDataStr,"^",1)="总计"
	.s $p(colDataStr,"^",7)=$zabs(spAmtTotal)
	.w """footer"":["
	.w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.w "]}" 
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetWardPatInc
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

}
