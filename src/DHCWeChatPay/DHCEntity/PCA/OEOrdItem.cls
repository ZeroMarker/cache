Class DHCWeChatPay.DHCEntity.PCA.OEOrdItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 医嘱项名称
Property ArcmiDesc As %String(TRUNCATE = 1);

/// 单价
Property Price As %Float;

/// 数量
Property Qty As %Float;

/// 单位
Property UOM As %String(TRUNCATE = 1);

/// 总金额
Property TotalAmount As %Float;

/// 自付金额
Property PatientShareAmt As %Float;

/// 折扣金额
Property DiscAmount As %Float;

/// 记账金额
Property PayorShareAmt As %Float;

Property Amt As %Float;

}
