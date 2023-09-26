/// creator:	yunhaibao
/// createdate: 2018-11-06
/// description:门诊日消耗统计-输出
Class web.DHCOUTPHA.RXB.Display Extends %RegisteredObject
{

/// description:easyui输出
/// w ##class(web.DHCOUTPHA.RXB.Display).EuiGetRXBStat("1","100","","","308|@|2018-12-01|@|2018-12-07|@|51|@||@||@||@|N|@||@|00:00|@|23:59|@|","")
ClassMethod EuiGetRXBStat(page, rows, sort, order, InputStr, Pid = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.RXB.Display","EuiGetRXBStat")=$lb(page, rows, sort, order, InputStr, Pid )
	s $zt="ThrowEuiGetRXBStat"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:InputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	i Pid="" d
	.d ##class(web.DHCOUTPHA.RXB.Global).Kill()
	.s retData=##class(web.DHCOUTPHA.RXB.Query).GetRXBStat(InputStr)
	.s pid=$p(retData,"^",1)
	e  s pid=Pid
	q:(pid="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s Sp=$p(InputStr,"|@|",7)
	// 排序
	k EuiGetRXBStatData
	s qcName="web.DHCOUTPHA.RXB.Query"
	s sortNum="",sortType=""
	s sortNum="",sortType=""
	s sortNum=5
	i sort'="" d
	.i sort="qty" s sortNum=1,sortType="Number"
	.e  i sort="spAmt" s sortNum=2,sortType="Number"
	.e  i sort="rpAmt" s sortNum=3,sortType="Number"
	.e  i sort="incCode" s sortNum=5,sortType="String"
	.e  i sort="incDesc" s sortNum=6,sortType="String"
	.e  i sort="manfDesc" s sortNum=7,sortType="String"
	.e  i sort="rp" s sortNum=8,sortType="Number"
	.e  i sort="sp" s sortNum=9,sortType="Number"
	.e  i sort="uomDesc" s sortNum=10,sortType="String"
	.e  s sortNum=5
	s (spAmtTotal,rpAmtTotal)=0
	s record=0
	s incIndex=""
	f  s incIndex=$o(^TMP("DHCST",qcName,"GetRXBStat",pid,incIndex)) q:incIndex=""  d
	.s priceIndex=""
	.f  s priceIndex=$o(^TMP("DHCST",qcName,"GetRXBStat",pid,incIndex,priceIndex)) q:priceIndex=""  d
	..s totalData=^TMP("DHCST",qcName,"GetRXBStat",pid,incIndex,priceIndex)
	..//qty_"^"_spAmt_"^"_rpAmt_"^"_incId_"^"_incCode_"^"_incDesc_"^"_manfDesc_"^"_rp_"^"_sp_"^"_uomDesc_"^"_pid
	..s incId=$p(totalData,"^",4)
	..s incDesc=$p(totalData,"^",6)
	..s incCode=$p(totalData,"^",5)
	..s manfDesc=$p(totalData,"^",7)
	..s rp=$p(totalData,"^",8)
	..s sp=$p(totalData,"^",9)
	..s qty=$p(totalData,"^",1)
	..q:qty=0
	..s spAmt=$p(totalData,"^",2)
	..s rpAmt=$p(totalData,"^",3)
	..s bUomId=$p(^INCI(incId,1),"^",10)
	..// 转换数量
	..s outPhUomId=$p(^INCI(incId,1),"^",12)
	..i outPhUomId'="" d
	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(outPhUomId,bUomId)
	...s uomId=outPhUomId
	..e  d
	...s pUomId=$p(^INCI(incId,3),"^",6)
	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(pUomId,bUomId)
	...s uomId=pUomId
	..s qty=qty/fac
	..s sp=sp*fac
	..s rp=rp*fac
	..q:(Sp'="")&&(sp<Sp)
	..s uomDesc=$p($g(^CT("UOM",uomId)),"^",2)
	..s $p(totalData,"^",1)=qty
	..s $p(totalData,"^",8)=rp
	..s $p(totalData,"^",9)=sp
	..s $p(totalData,"^",10)=uomDesc
	..s spAmtTotal=spAmtTotal+spAmt
	..s rpAmtTotal=rpAmtTotal+rpAmt
	..s sortData=$p(totalData,"^",sortNum)
	..i sortData="" d
	...i sortType="Number" s sortData=0
	...e  s sortData="ZSTRING"
	..s record=record+1
	..s EuiGetRXBStatData(sortData,record)=totalData
	s colNameStr1="qty^spAmt^rpAmt^incId^incCode"
	s colNameStr2="incDesc^manfDesc^rp^sp^uomDesc"
	s colNameStr3="pid"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3
	i $zcvt(order,"U")="DESC" s order=-1
	e  s order=1
	s count=0
	s sortIndex=""
	f  s sortIndex=$o(EuiGetRXBStatData(sortIndex),order) q:sortIndex=""  d
	.s record=""
	.f  s record=$o(EuiGetRXBStatData(sortIndex,record),order) q:record=""  d
	..s count=count+1
	..q:count<StartRow
	..q:count>EndRow
	..s colDataStr=EuiGetRXBStatData(sortIndex,record)
	..s $p(colDataStr,"^",1)=$$AddZero($p(colDataStr,"^",1))
	..s $p(colDataStr,"^",2)=$$AddZero($p(colDataStr,"^",2))
	..s $p(colDataStr,"^",3)=$$AddZero($p(colDataStr,"^",3))
	..s $p(colDataStr,"^",8)=$$AddZero($p(colDataStr,"^",8))
	..s $p(colDataStr,"^",9)=$$AddZero($p(colDataStr,"^",9))
	..i count=1 d
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	..e  d
	...w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	i $d(colDataStr) d
	.w "],""total"":"""_count_""","
	.s colDataStr=""
	.s $p(colDataStr,"^",10)=""
	.s $p(colDataStr,"^",5)="总计"
	.s $p(colDataStr,"^",2)=spAmtTotal
	.s $p(colDataStr,"^",3)=rpAmtTotal
	.w """footer"":["
	.w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.w "]}" 
	 e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetRXBStat
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
AddZero(number)
	q:$F(number,".")=0 number
	q:(number'<1)||(number'>-1) number
	s newnumber=$fn(number,"",$l($p(number,".",2)))
	q newnumber
}

}
