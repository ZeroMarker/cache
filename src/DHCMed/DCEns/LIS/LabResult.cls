/// 名称 : DHCMed.DCEns.LIS.LabResult
/// 说明 : 检验项目结果
Class DHCMed.DCEns.LIS.LabResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "TSResult";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 检测项目
Property TestCodeCode As %String(MAXLEN = 32767, XMLNAME = "TestCodeCode");

/// 检测项目
Property TestCodeDesc As %String(MAXLEN = 32767, XMLNAME = "TestCodeDesc");

/// 检测结果类型
Property ResultFormat As %String(MAXLEN = 32767, XMLNAME = "ResultFormat");

/// 检测结果
Property Result As %String(MAXLEN = 32767, XMLNAME = "Result");

/// 定性结果
Property TextRes As %String(MAXLEN = 32767, XMLNAME = "TextRes");

/// 结果说明(细菌备注)
Property ResNoes As %String(MAXLEN = 32767, XMLNAME = "ResNoes");

/// 异常提示
Property AbFlag As %String(MAXLEN = 32767, XMLNAME = "AbFlag");

/// 单位
Property Unit As %String(MAXLEN = 32767, XMLNAME = "Unit");

/// 参考范围
Property RefRanges As %String(MAXLEN = 32767, XMLNAME = "RefRanges");

/// 多耐菌标注
Property MDRResult As %String(MAXLEN = 32767, XMLNAME = "MDRResult");

/// 产超广谱β-内酰胺酶(ESBLs)检测结果
Property ESBLsResult As %String(MAXLEN = 32767, XMLNAME = "ESBLsResult");

/// 药敏结果
Property TSRSenInfo As list Of DHCMed.DCEns.LIS.LabResult(XMLNAME = "TSRSenInfo");

}
