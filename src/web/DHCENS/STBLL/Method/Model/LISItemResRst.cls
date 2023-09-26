Class web.DHCENS.STBLL.Method.Model.LISItemResRst Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "LISItemResRst";

/// 耐药项目代码
Property LISIRRItemCode As %String(MAXLEN = 50);

/// 耐药项目名称
Property LISIRRItemDesc As %Library.String(MAXLEN = 100);

/// 耐药性结果 
Property LISIRRResult As %Library.String(MAXLEN = 60);

/// 序号
Property LISIRRShowSeq As %Library.String(MAXLEN = 15);

}
