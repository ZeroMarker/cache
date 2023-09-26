/// 通过不同方式获取医嘱RowID的方式，这个与服务有关系
Class web.DHCBL.CIDefine.OEORIDefine Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 根据发票串获取医嘱串
ClassMethod GetOEORIStrByINVPRTStr(PRTRowIDStr As %String, SFlag As %String) As %String
{
	;w ##class(web.DHCBL.CIDefine.OEORIDefine).GetOEORIStrByINVPRTStr()
	s myOEORIStr=""
	
	s myPRTRowID=0
	s mylen=$l(PRTRowIDStr,"^")
	f myIdx=1:1:mylen d
	.s myPRTRowID=$p(PRTRowIDStr,"^", myIdx)
	.q:(myPRTRowID="")
	.q:(+myPRTRowID=0)
	.s myOEORIStr =myOEORIStr_..GetOEORIStrByPRTRowID(myPRTRowID, SFlag)
	
	q myOEORIStr
}

/// 根据发票获取医嘱串RowID
/// 如果是退费，只获取退费的医嘱串
/// 永远是当前操作的发票
/// 收费时： 新生成的发票RowID
/// 退费时： 要退的发票RowID
ClassMethod GetOEORIStrByPRTRowID(PRTRowID As %String, SFlag As %String) As %String
{
	;w ##class(web.DHCBL.CIDefine.OEORIDefine).GetOEORIStrByPRTRowID(157,0)
	;SFlag=0  收费
	;SFlag=1  退费
	
	s myOEORIStr=""
	
	q:PRTRowID="" myOEORIStr
	
	i (+SFlag'=0) d
	.;^DHCINVPRT(0,"OldINV",{PRT_OldINV_DR},{PRT_Rowid})
	.s myNewPRTRowID=$o(^DHCINVPRT(0,"OldINV",PRTRowID,0))
	
	s myBCIRowID=0
	f  s myBCIRowID=$o(^DHCBCI(0,"INV", PRTRowID, myBCIRowID)) q:((myBCIRowID=""))  d
	.s myPBRowID=$p(^DHCBCI(myBCIRowID),"^", 2)
	.s mySub=0
	.for  s mySub=$o(^DHCPB(myPBRowID,"O",mySub))  q:(mySub="")  d
	..q:($d(^DHCPB(myPBRowID,"O",mySub))=10)
	..s myOEORIDR=$p(^DHCPB(myPBRowID,"O",mySub), "^", 4)
	..s myFindFlag=0
	..i (+SFlag'=0) d
	...s myFindFlag=##class(web.DHCBL.CIDefine.TypeDefine).CheckORDFindFromNewPRT(myNewPRTRowID,myOEORIDR)
	..b	;
	..q:(+SFlag'=0)&&(+myFindFlag'=0)
	..s myOEORIStr=myOEORIStr_myOEORIDR_"^"
	
	q myOEORIStr
}

}
