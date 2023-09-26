/// creator:	yunhaibao
/// createdate: 2018-11-05
/// description:门诊配药确认,仅用于传递参数转换格式输出界面
Class web.DHCOUTPHA.Confirm.Display Extends %RegisteredObject
{

/// description: jqGrid 输出
/// w ##class(web.DHCOUTPHA.Confirm.Display).JqGetConfirmPYData("1",30,"O181101000036")
ClassMethod JqGetConfirmPYData(page, rows, InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.Confirm.Display","JqGetConfirmPYData")=$lb(page,rows,InputStr)
	s $zt="ThrowJqGetConfirmPYData"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:InputStr="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCOUTPHA.Confirm.Query).GetConfirmPYData(InputStr)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=1999
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s qcName="web.DHCOUTPHA.Confirm.Query"
	s count=0
	s colNameStr1="incCode^incDesc^qty^uomDesc^dosage"
	s colNameStr2="freqDesc^instrucDesc^duraDesc^docName^patName"
	s colNameStr3="patNo^phdId^encryptLevel^patLevel^sp"
	s colNameStr4="spAmt^prescNo^oeoriStat"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4
	s outputI=""
	f  s outputI=$o(^TMP("DHCST",qcName,"GetConfirmPYData",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^TMP("DHCST",qcName,"GetConfirmPYData",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(total,rows)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^TMP("DHCST",qcName,"GetConfirmPYData",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowJqGetConfirmPYData
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

}
