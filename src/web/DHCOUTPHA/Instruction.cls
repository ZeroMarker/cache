Import sqluser

/// creator:yunhaibao
/// createdate:20160624
/// descirpiton:门诊药房打印标签用法维护
Class web.DHCOUTPHA.Instruction Extends %RegisteredObject [ ProcedureBlock ]
{

//creator:yunhaibao

//createdate:20160623

//description:门诊打印标签用法记录

//w ##class(web.DHCOUTPHA.Instruction).jsQueryLocInstruction(1,11,"100")

ClassMethod jsQueryLocInstruction(page, rows, params)
{

	s locdr=$p(params,"^",1)
	s instr=$p(params,"^",2)
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=..NewPid()
    s $zt="ErrorjsQueryLocInstruction"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhCode:QueryPrintKF")
	s sc=result.Execute(locdr,instr)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.s retvalue=result.%GetData(i)
		.i retvalue["-" s retvalue=$p(retvalue,"-",2)
		.i ret="" s ret=retvalue
		.e   s ret=ret_"^"_retvalue
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.Instruction","jsQueryLocInstruction",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Instruction","jsQueryLocInstruction",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Instruction","jsQueryLocInstruction",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Instruction","jsQueryLocInstruction",pid)
	q ""
ErrorjsQueryLocInstruction
	k ^TMP("DHCST","web.DHCOUTPHA.Instruction","jsQueryLocInstruction",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCOUTPHA.Instruction"))
}

}
