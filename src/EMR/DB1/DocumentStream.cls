/// 名称:	EMR.DB.DocumentStream
/// 描述:	电子病历-实例流数据表
/// 编写者：yejian
/// 编写日期: 2020-9-29
/// 产品组：电子病历产品组
Class EMR.DB1.DocumentStream Extends %Persistent
{

Index IdxMain On DocumentID [ Unique ];

/// 实例表
Property DocumentID As %String [ Required ];

/// 实例数据
Property DocumentData As %GlobalBinaryStream(LOCATION = "^EMR.DB1.DocumentStreamS");

Storage Default
{
<Data name="DocumentStreamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocumentID</Value>
</Value>
<Value name="3">
<Value>DocumentData</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.DocumentStreamD</DataLocation>
<DefaultData>DocumentStreamDefaultData</DefaultData>
<IdLocation>^EMR.DB1.DocumentStreamD</IdLocation>
<IndexLocation>^EMR.DB1.DocumentStreamI</IndexLocation>
<StreamLocation>^EMR.DB1.DocumentStreamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
