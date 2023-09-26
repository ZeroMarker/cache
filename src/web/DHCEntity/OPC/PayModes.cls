/// 报表的支付集合
Class web.DHCEntity.OPC.PayModes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 作废的支付模式
Property ParkPayMode As list Of ReportsPayMode;

/// 支付模式
Property PayMode As list Of ReportsPayMode;

/// 红冲的支付模式
Property RefPayMode As list Of ReportsPayMode;

/// 转换支付模式对象
Method TransPayMode(OperatedObj As web.DHCEntity.OPC.ReportsInfo) As %Status
{
	d ..Clear()
	
	s myCount=OperatedObj.PayMode.Count()
	f myIdx=1:1:myCount d
	.s myCurPayMode=OperatedObj.PayMode.GetAt(myIdx)
	.d ..PayMode.Insert(myCurPayMode)
	.s myCurParkPayMode=OperatedObj.ParkPayMode.GetAt(myIdx)
	.d ..ParkPayMode.Insert(myCurParkPayMode)
	.s myCurRefPayMode=OperatedObj.RefPayMode.GetAt(myIdx)
	.d ..RefPayMode.Insert(myCurRefPayMode)
}

Method Clear()
{
	;k ..PayMode
	;k ..ParkPayMode
	;k ..RefPayMode
}

}
