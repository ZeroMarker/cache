/// Cache 数据库的接口定义, 单独写的代码+规则
Class web.DHCBL.CIDefine.CICacheTypeDefine Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 根据医嘱串RowID排程
ClassMethod SetRBApptScheduleByOEORDStr(OEORDStr As %String, SFlag As %String) As %String
{
	;SFlag  计费标志
	;s ret=##class(web.DHCBL.CIDefine.CICacheTypeDefine).SetRBApptScheduleByOEORDStr(OrderItemRowId,Type)
	s myrtn=0
	
	q:(OEORDStr="") myrtn
	
	s mylen=$l(OEORDStr,"^")
	f myIdx=1:1:mylen  d
	.s myPRTRowID=$p(OEORDStr,"^",myIdx)
	.q:(myPRTRowID="")
	.s myrtn=##class(web.DHCOEOrdItem).UpdateEQASByOrderItem(myPRTRowID,SFlag)
	
	q myrtn
}

}
