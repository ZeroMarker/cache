Class DHCBILL.SelfPay.Entity.AutoPayInputInfo.Res.OEOrdItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

// Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

// =1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

// =0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

// Parameter XMLSEQUENCE = 0;

Property InsuType As %String(TRUNCATE = 1);

Property OEOrdId As %String(TRUNCATE = 1);

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

/// 规格
Property Unit As %Float;

}
