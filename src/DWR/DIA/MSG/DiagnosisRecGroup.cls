/// 诊断记录分组
Class DWR.DIA.MSG.DiagnosisRecGroup Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "DiagnosisRecGroup";

/// 分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 诊断记录列表
Property DiagnosisRecList As list Of DWR.DIA.MSG.DiagnosisRecord;

}
