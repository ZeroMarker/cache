/// 名称:	CT.EMR.DOC.TemToolButtons
/// 描述:	文档工具栏按钮数据
/// 编写者：yejian
/// 编写日期: 2020-9-24
/// 产品组
Class CT.EMR.DOC.TemToolButtons Extends %Persistent
{

Index IdxCode On Code;

Index IdxDocTypesSeq On (DocTypes, Sequence);

/// 编码
Property Code As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 提示信息()
Property ToolTip As %String(TRUNCATE = 1);

/// 文档类型(DOC/KB/HFF)
Property DocTypes As %String(TRUNCATE = 1);

/// 图标名称
Property ImageName As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Storage Default
{
<Data name="TemToolButtonsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ToolTip</Value>
</Value>
<Value name="5">
<Value>DocTypes</Value>
</Value>
<Value name="6">
<Value>ImageName</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.TemToolButtonsD</DataLocation>
<DefaultData>TemToolButtonsDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.TemToolButtonsD</IdLocation>
<IndexLocation>^CT.EMR.DOC.TemToolButtonsI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.TemToolButtonsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
