/// 名称 : DHCMed.DCEns.LIS.BTTestCode
/// 说明 : 检验项目
Class DHCMed.DCEns.LIS.BTTestCode Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "TestCode";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property Code As %String(MAXLEN = 32767, XMLNAME = "Code");

/// 名称
Property CName As %String(MAXLEN = 32767, XMLNAME = "CName");

/// 医院代码
Property HospCode As %String(MAXLEN = 32767, XMLNAME = "HospCode");

/// 全称
Property LName As %String(MAXLEN = 32767, XMLNAME = "LName");

/// 英文名称
Property EName As %String(MAXLEN = 32767, XMLNAME = "EName");

/// 英文简称
Property Synonym As %String(MAXLEN = 32767, XMLNAME = "Synonym");

/// 单位
Property Units As %String(MAXLEN = 32767, XMLNAME = "Units");

/// 结果格式（N数值、S选择字典、X）
Property ResultFormat As %String(MAXLEN = 32767, XMLNAME = "ResultFormat");

/// 精确度（几位小数）
Property Precision As %String(MAXLEN = 32767, XMLNAME = "Precision");

/// 缩写码（检索标准码）
Property SCode As %String(MAXLEN = 32767, XMLNAME = "SCode");

/// 检验组套
Property TestSetCode As %String(MAXLEN = 32767, XMLNAME = "TestSetCode");

/// 检验组套
Property TestSetDesc As %String(MAXLEN = 32767, XMLNAME = "TestSetDesc");

/// 索引码
Property XCode As %String(MAXLEN = 32767, XMLNAME = "XCode");

/// 是否有效
Property Active As %String(MAXLEN = 32767, XMLNAME = "Active");

}
