Class web.DHCENS.STBLL.Method.Model.RISRItemResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "RISRItemResult";

/// 检查项目代码
Property RISIRItemCode As %String(MAXLEN = 50);

/// 检查项目名称
Property RISIRItemDesc As %Library.String(MAXLEN = 100);

/// 结果 
Property RISIRResult As %Library.String(MAXLEN = 50);

/// 参考范围
Property RISIRRanges As %Library.String(MAXLEN = 100);

/// 参考值高值
Property RISIRHigh As %Library.String(MAXLEN = 60);

/// 参考值低值
Property RISIRLow As %Library.String(MAXLEN = 60);

/// 参考值单位
Property RISIRUnit As %Library.String(MAXLEN = 50);

}
