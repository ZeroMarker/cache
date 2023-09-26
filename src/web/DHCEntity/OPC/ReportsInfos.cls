/// ReportsInfo的集合类
Class web.DHCEntity.OPC.ReportsInfos Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property RepInfos As list Of ReportsInfo;

Property SelRepInfo As ReportsInfo;

Method SetUserRepsByUser(UserDR As %String = "") As %Status
{
	s myBFind =0
	s mySelIdx=0
	s myCount=..RepInfos.Count()
	f i=1:1:myCount  q:(+myBFind)  d
	.s ..SelRepInfo=..RepInfos.GetAt(i)
	.i UserDR=..SelRepInfo.UserDR d
	..s myBFind=1
	..s mySelIdx=i
	
	i (+myBFind=0) d
	.s ..SelRepInfo=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	.s ..SelRepInfo.UserDR = UserDR
	.d ..RepInfos.Insert(..SelRepInfo)
	e  d
	.s ..SelRepInfo=..RepInfos.GetAt(mySelIdx)
	
	Q $$$OK
}

}
