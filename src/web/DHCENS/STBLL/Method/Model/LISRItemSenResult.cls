Class web.DHCENS.STBLL.Method.Model.LISRItemSenResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "LISRItemSenResult";

/// 抗生素代码
Property LISISRAntibioticsCode As %String(MAXLEN = 20);

/// 抗生素名称
Property LISISRAntibioticsDesc As %Library.String(MAXLEN = 50);

/// 药敏结果值 
Property LISISRResult As %Library.String(MAXLEN = 20);

/// 药敏结果代码
Property LISISRSensitivityCode As %Library.String(MAXLEN = 100);

/// 药敏结果名称
Property LISISRSensitivityDesc As %Library.String(MAXLEN = 200);

/// I折点范围
Property LISISRIRanges As %Library.String(MAXLEN = 20);

/// S折点范围
Property LISISRSRanges As %Library.String(MAXLEN = 20);

/// R折点范围
Property LISISRRRanges As %String(MAXLEN = 20);

/// 显示序号
Property LISISRShowSeq As %Library.String(MAXLEN = 50);

/// 试验方法 
Property LISISRMethod As %Library.String(MAXLEN = 50);

/// 建议
Property LISISRSuggestion As %Library.String(MAXLEN = 100);

/// 药敏结果标志
Property LISISRFlag As %Library.String(MAXLEN = 20);

/// 抗生素级别ID
Property LISISRAntibioticsClassID As %Library.String(MAXLEN = 20);

/// 抗生素级别名称
Property LISISRAntibioticsClassDesc As %Library.String(MAXLEN = 50);

}
