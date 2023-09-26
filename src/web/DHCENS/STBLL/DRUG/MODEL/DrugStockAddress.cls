Class web.DHCENS.STBLL.DRUG.MODEL.DrugStockAddress Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "DrugStockAddress";

/// 科室代码
Property DeptCode As %Library.String(MAXLEN = 50, XMLNAME = "DeptCode");

/// 科室描述
Property DeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "DeptDesc");

/// 药品代码
Property DrugCode As %Library.String(MAXLEN = 100, XMLNAME = "DrugCode");

/// 药品描述
Property DrugDesc As %Library.String(MAXLEN = 100, XMLNAME = "DrugDesc");

/// 药品描述
Property Address As %Library.String(MAXLEN = 100, XMLNAME = "Address");

/// 住院标识 1 住院 0 门急诊
Property TypeCode As %Library.String(MAXLEN = 1, XMLNAME = "TypeCode");

}
