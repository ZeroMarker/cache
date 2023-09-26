Class web.DHCENS.STBLL.ORDER.MODEL.LISItemSenResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "LIS_ItemSenResult";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 结果ID
Property LISISRResultID As %Library.String(MAXLEN = 30, XMLNAME = "LISISR_ResultID");

/// 抗生素代码
Property LISISRAntibioticsCode As %Library.String(MAXLEN = 20, XMLNAME = "LISISR_AntibioticsCode");

/// 结果值
Property LISISRResult As %Library.String(MAXLEN = 20, XMLNAME = "LISISR_Result");

/// 药敏结果
Property LISISRSensitivityCode As %Library.String(MAXLEN = 100, XMLNAME = "LISISR_SensitivityCode");

/// I折点范围
Property LISISRIRanges As %Library.String(MAXLEN = 20, XMLNAME = "LISISR_IRanges");

/// S折点范围
Property LISISRSRanges As %Library.String(MAXLEN = 20, XMLNAME = "LISISR_SRanges");

/// R折点范围
Property LISISRRRanges As %Library.String(MAXLEN = 20, XMLNAME = "LISISR_RRanges");

/// 显示序号
Property LISISRShowSeq As %Library.Integer(XMLNAME = "LISISR_ShowSeq");

}
