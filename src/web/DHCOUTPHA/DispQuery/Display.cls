Class web.DHCOUTPHA.DispQuery.Display Extends %RegisteredObject
{

/// w ##class(web.DHCOUTPHA.DispQuery.Display).EuiGetDispMain(("1","100","","","2018-11-08|@|2018-11-13|@|310|@||@||@||@||@||@||@|1|@|11:00|@|23:59|@||@||@|","")
ClassMethod EuiGetDispMain(page, rows, sort, order, InputStr, Pid)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.DispQuery.Query","EuiGetDispMain")=$lb(page, rows,sort,order, InputStr,Pid)
	s $zt="ThrowEuiGetDispMain"
	s EndRow=page*rows  			// 结束行
	s StartRow=((page-1)*rows)+1 	// 开始行
	q:(InputStr="")&&(Pid="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCOUTPHA.DispQuery.Query).GetDispMain(StartRow, EndRow, InputStr,Pid)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="phdId^prescNo^patNo^patName^spAmt"
	s colNameStr2="pyUserName^fyUserName^admReasonDesc^docLocDesc^prescRemark"
	s colNameStr3="diagDesc^oeoriDateTime^prtDate^pyDate^fyDate"
	s colNameStr4="prtTime^pyTime^fyTime^phdOweId^pid"
	s colNameStr5="encryptLevel^patLevel"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4_"^"_colNameStr5
	s outputI=""
	f  s outputI=$o(^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispMain",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispMain",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispMain",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetDispMain
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

/// w ##class(web.DHCOUTPHA.DispQuery.Display).EuiGetDispIncDetail()
ClassMethod EuiGetDispIncDetail(InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.DispQuery.Query","EuiGetDispIncDetail")=$lb(InputStr)
	s $zt="ThrowEuiGetDispIncDetail"
	q:(InputStr="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCOUTPHA.DispQuery.Query).GetDispIncDetail(InputStr)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="incDesc^qty^uomDesc^spAmt^retQty"
	s colNameStr2="freqDesc^instrucDesc^duraDesc^dosage^oeoriStatDesc"
	s colNameStr3="stkBinStr^oeoriRemark^docName^dspQty"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3
	s outputI=""
	f  s outputI=$o(^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispIncDetail",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispIncDetail",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispIncDetail",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetDispIncDetail
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

/// w ##class(web.DHCOUTPHA.DispQuery.Display).EuiGetDispIncDetail()
ClassMethod EuiGetDispInclbDetail(InputStr)
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.DispQuery.Query","EuiGetDispInclbDetail")=$lb(InputStr)
	s $zt="ThrowEuiGetDispInclbDetail"
	q:(InputStr="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s retData=##class(web.DHCOUTPHA.DispQuery.Query).GetDispInclbDetail(InputStr)
	q:retData="" ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s newPid=$p(retData,"^",1)
	s total=$p(retData,"^",2)
	q:(newPid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s colNameStr1="incDesc^qty^uomDesc^spAmt^retQty"
	s colNameStr2="batNo^expDate^sp^inclb"
	s colNameStr=colNameStr1_"^"_colNameStr2
	s outputI=""
	f  s outputI=$o(^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispInclbDetail",newPid,outputI)) q:outputI=""  d
	.s colDataStr=^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispInclbDetail",newPid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,colDataStr,"^")
	k ^TMP("DHCST","web.DHCOUTPHA.DispQuery.Query","GetDispInclbDetail",newPid)
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	q ""
ThrowEuiGetDispInclbDetail
	s errRet=$$JsonErrorRecord^DHCSTERROR()
	q ""
}

}
