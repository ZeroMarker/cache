Class web.DHCOUTPHA.PrescQuery.Display Extends %RegisteredObject
{

/// description: 获取处方列表
/// w ##class(web.DHCOUTPHA.PrescQuery.Display).EuiGetPrescMain("1","100","","","01/11/2018|@|19/11/2018|@|308|@|0000000008|@|00:00|@|23:59|@||@|","")
ClassMethod EuiGetPrescMain(page, rows, sort, order, InputStr, Pid)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.PrescQuery.Query","EuiGetPrescMain")=$lb(page, rows,sort,order, InputStr,Pid)
	s $zt="ThrowEuiGetPrescMain"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:(InputStr="")&&(Pid="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCOUTPHA.PrescQuery.Query).GetPrescMain(StartRow, EndRow, InputStr,Pid)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="prescNo^patNo^patName^spAmt^pyUserName"
	s colNameStr2="fyUserName^admReasonDesc^docLocDesc^prescRemark^diagDesc"
	s colNameStr3="oeoriDateTime^prtDate^fyDate^prtTime^fyTime"
	s colNameStr4="pid^encryptLevel^patLevel^prescType^winDesc"
	s colNameStr5="prescStat"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4_"^"_colNameStr5
	s cN="web.DHCOUTPHA.PrescQuery.Query"
	s outputI=""
	f  s outputI=$o(^TMP("DHCST",cN,"GetPrescMain",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^TMP("DHCST",cN,"GetPrescMain",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^TMP("DHCST",cN,"GetPrescMain",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetPrescMain
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

/// description: 获取处方明细
/// w ##class(web.DHCOUTPHA.PrescQuery.Display).EuiGetPrescItm("O181019000009")
ClassMethod EuiGetPrescItm(InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.PrescQuery.Query","EuiGetPrescItm")=$lb(InputStr)
	s $zt="ThrowEuiGetPrescItm"
	q:(InputStr="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCOUTPHA.PrescQuery.Query).GetPrescItm(InputStr)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="arcItmDesc^oeoriQty^uomDesc^spAmt^retQty"
	s colNameStr2="freqDesc^instrucDesc^duraDesc^dosage^oeoriStatDesc"
	s colNameStr3="oeoriRemark^docName^dispQty^sp"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3
	s cN="web.DHCOUTPHA.PrescQuery.Query"
	s outputI=""
	f  s outputI=$o(^TMP("DHCST",cN,"GetPrescItm",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^TMP("DHCST",cN,"GetPrescItm",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^TMP("DHCST",cN,"GetPrescItm",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetPrescItm
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

}
