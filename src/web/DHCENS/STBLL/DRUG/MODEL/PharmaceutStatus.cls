Class web.DHCENS.STBLL.DRUG.MODEL.PharmaceutStatus Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "PharmaceutStatus";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 处方日期
Property PRESCDATE As %String(TRUNCATE = 1, XMLNAME = "PRESC_DATE");

/// 处方号
Property PRESCNO As %String(TRUNCATE = 1, XMLNAME = "PRESC_NO");

/// 发票号
Property INVOICENO As %String(TRUNCATE = 1, XMLNAME = "INVOICE_NO");

/// 药房科室代码
Property DISPENSARY As %String(TRUNCATE = 1, XMLNAME = "DISPENSARY");

}
