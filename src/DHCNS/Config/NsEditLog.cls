/// creator:lulin
/// createdate:2019-12-16
/// description:敏感指标修改日志
Class DHCNS.Config.NsEditLog Extends %Persistent
{

// 模板外键

Property ModelId As %Integer [ SqlColumnNumber = 2, SqlFieldName = ModelId ];

// 模板名称

Property ModelDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ModelDesc ];

// 指标代码：第一个字符E:元素，I:指标目前默认全部为E

Property IndexId As %String [ SqlColumnNumber = 4, SqlFieldName = IndexId ];

// 指标描述

Property IndexDesc As %String [ SqlColumnNumber = 5, SqlFieldName = IndexDesc ];

// 数据对应时间

Property DataTime As %String [ SqlColumnNumber = 6, SqlFieldName = DataTime ];

// 原值

Property OldValue As %String [ SqlColumnNumber = 7, SqlFieldName = OldValue ];

// 新值

Property NewValue As %String [ SqlColumnNumber = 8, SqlFieldName = NewValue ];

// 修改人

Property Updator As %String [ SqlColumnNumber = 9, SqlFieldName = Updator ];

// 修改日期

Property UpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = UpdateDate ];

// 病区

Property WardDR As %Integer [ SqlColumnNumber = 11, SqlFieldName = WardDR ];

// 频率

Property Rate As %String [ SqlColumnNumber = 12, SqlFieldName = Rate ];

Index model On ModelId;

Index Index On (WardDR, ModelId, IndexId);

Storage Default
{
<Data name="NsEditLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelId</Value>
</Value>
<Value name="3">
<Value>ModelDesc</Value>
</Value>
<Value name="4">
<Value>IndexId</Value>
</Value>
<Value name="5">
<Value>IndexDesc</Value>
</Value>
<Value name="6">
<Value>DataTime</Value>
</Value>
<Value name="7">
<Value>OldValue</Value>
</Value>
<Value name="8">
<Value>NewValue</Value>
</Value>
<Value name="9">
<Value>Updator</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>WardDR</Value>
</Value>
<Value name="12">
<Value>Rate</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsEditLogD</DataLocation>
<DefaultData>NsEditLogDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsEditLogD</IdLocation>
<IndexLocation>^DHCNS.Config.NsEditLogI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsEditLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
