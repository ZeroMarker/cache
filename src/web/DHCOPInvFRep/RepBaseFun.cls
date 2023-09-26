/// 报表体系公共函数
Class web.DHCOPInvFRep.RepBaseFun Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 37;

ClassMethod GetReportsPath()
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).GetReportsPath()
	s Version=1
	s PathToReports=$list(^websys.ConfigurationD(Version),69)
	q PathToReports
}

ClassMethod DateFormat(strDate, sType, toType)
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).DateFormat("08/12/2005",4,3)
	;w ##class(web.DHCOPInvFRep.RepBaseFun).DateFormat("11/12/2006",1,3)
	;w ##class(web.DHCOPInvFRep.RepBaseFun).DateFormat("2005-12-08",3,4)	
	;11/12/2006
	q:strDate="" $zd(+$h,toType)
	s date=$zdh(strDate,sType)
	s date=$zd(date,toType)
	q date
}

ClassMethod ReadPrintData(jid, index)
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).ReadPrintData("5","")
	s myRowData=""
	
	i jid'="" d
	.s myIndex=$o(^TMPOPPrintOut(jid,index))
	.i myIndex'="" d
	..s myRowData=myIndex_"^"_$g(^TMPOPPrintOut(jid,myIndex))
	
	q myRowData
}

ClassMethod DelPrintData(jid)
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).DelPrintData(2)
	i jid'="" d
	.k ^TMPOPPrintOut(jid)
	
	q 0
}

ClassMethod GetRowNum(JID)
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).GetRowNum(5)
	s num=$o(^TMPOPPrintOut(JID,""),-1)
	q num
}

/// 格式化病人登记号 8 位
ClassMethod FormatPatNo(PatNo As %String) As %String
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).FormatPatNo(2)
	q:PatNo="" ""
 	s PatNo=$e("00000000",1,8-$l(PatNo))_PatNo
 	s PatNo=$zcvt(PatNo,"U")
 	Quit PatNo
}

/// 处理 $J 不稳定
ClassMethod GetPageJID(TMPJID As %String = "") As %String
{
	n (TMPJID)
	;w ##class(web.DHCOPInvFRep.RepBaseFun).GetPageJID(2)
	i TMPJID'="" k ^TMPOPPrintOut(TMPJID)
	s jid=$I(^TMPOPPrintOut)
	Quit jid
}

/// 根据查询的进程号获得输出的表头名称
ClassMethod GetPageTableTitle(TMPJID As %String = "") As %String
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).GetPageTableTitle(2)
	Quit:TMPJID="" ""
	Quit $g(^TMPOPPrintOut(TMPJID,"HeadTitle"))
}

ClassMethod GetTPatCat(TMPJID As %String = "") As %String
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).GetTPatCat(2)
	Quit:TMPJID="" ""
	Quit $g(^TMPOPPrintOut(TMPJID,"PatCat"))
}

ClassMethod GetTPMCat(TMPJID As %String = "") As %String
{
	;w ##class(web.DHCOPInvFRep.RepBaseFun).GetTPatCat(2)
	Quit:TMPJID="" ""
	Quit $g(^TMPOPPrintOut(TMPJID,"PMCat"))
}

}
