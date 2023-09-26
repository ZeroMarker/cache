/// 子类
Class web.DHCEntity.OPC.CatSubs Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 经济核算分类
Property ECCat As list Of ReportsSub;

/// 会计科目分类
Property ACCat As list Of ReportsSub;

/// 门诊项目分类
Property OPCat As list Of ReportsSub;

/// 转换支付模式对象
Method TransPayMode(OperatedObj As web.DHCEntity.OPC.ReportsInfo) As %Status
{
	d ..Clear()
	
	s myCount=OperatedObj.ACCat.Count()
	f myIdx=1:1:myCount d
	.s myCurACCat=OperatedObj.ACCat.GetAt(myIdx)
	.d ..ACCat.Insert(myCurACCat)

	s myCount=OperatedObj.OPCat.Count()
	f myIdx=1:1:myCount d
	.s myCurOPCat=OperatedObj.OPCat.GetAt(myIdx)
	.d ..OPCat.Insert(myCurOPCat)
	
	q $$$OK
}

Method Clear()
{
	;k ..PayMode
	;k ..ParkPayMode
	;k ..RefPayMode
}

}
