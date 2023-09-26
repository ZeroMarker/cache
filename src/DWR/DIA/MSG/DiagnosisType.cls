/// 诊断类型
Class DWR.DIA.MSG.DiagnosisType Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "DiagnosisType";

/// 诊断类型ID
Property DiaTypeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 诊断类型代码
Property DiaTypeCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 诊断类型名称
Property DiaTypeName As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="DiagnosisTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiaTypeCode</Value>
</Value>
<Value name="3">
<Value>DiaTypeID</Value>
</Value>
<Value name="4">
<Value>DiaTypeName</Value>
</Value>
</Data>
<DataLocation>^DWR.DIA.MSG.DiagnosisTypeD</DataLocation>
<DefaultData>DiagnosisTypeDefaultData</DefaultData>
<IdLocation>^DWR.DIA.MSG.DiagnosisTypeD</IdLocation>
<IndexLocation>^DWR.DIA.MSG.DiagnosisTypeI</IndexLocation>
<StreamLocation>^DWR.DIA.MSG.DiagnosisTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
