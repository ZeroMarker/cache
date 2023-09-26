/// 开票头文件参数
Class BILL.EINV.DTO.HTXXA.EInvoiceComDataHeader Extends (%RegisteredObject, %XML.Adaptor)
{

/// 电子票据标签	
/// 格式为“财政电子票据标识–监管机构行政区划代码”。其中，财政电子票据标识为“CZ-EI”；区划代码为2位数字(地区为61)
Property EInvoiceTag As %String(CAPTION = "电子票据标签", XMLPROJECTION = "ELEMENT");

Property EInvoiceID As %String(CAPTION = "电子票据标识", XMLPROJECTION = "ELEMENT");

/// 固定值，1.0财政电子票据规范版本
Property Version As %String(CAPTION = "版本", XMLPROJECTION = "ELEMENT");

}
