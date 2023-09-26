/// 名称 : DHCMed.DCEns.LIS.LabResultSen
/// 说明 : 药敏结果
Class DHCMed.DCEns.LIS.LabResultSen Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "TSRSen";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 抗生素代码
Property AntibioticsCode As %String(MAXLEN = 32767, XMLNAME = "AntibioticsCode");

/// 抗生素名称
Property AntibioticsDesc As %String(MAXLEN = 32767, XMLNAME = "AntibioticsDesc");

/// 药敏结果代码
Property SensitivityCode As %String(MAXLEN = 32767, XMLNAME = "SensitivityCode");

/// 药敏结果名称
Property SensitivityDesc As %String(MAXLEN = 32767, XMLNAME = "SensitivityDesc");

}
