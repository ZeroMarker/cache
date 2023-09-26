/// creator:lulin
/// createdate:2019-12-15
/// description:系统自动获取数据-其他
Class DHCNS.Config.NsAutoData Extends %Persistent
{

Relationship ChildSub As DHCNS.Config.NsAutoDataSub [ Cardinality = children, Inverse = Parref ];

/// 病区
Property WardDR As %Integer [ SqlColumnNumber = 2, SqlFieldName = WardDR ];

/// 时间某天
Property DataDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DataTime ];

/// 数据
Property Value As %String [ SqlColumnNumber = 4, SqlFieldName = Value ];

/// 指标外键元素
Property IndexDR As %Integer [ SqlColumnNumber = 5, SqlFieldName = IndexDR ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = UpdateDate ];

Index Index On (IndexDR, WardDR, DataDate);

Storage Default
{
<Data name="NsAutoDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>DataDate</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>IndexDR</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoDataD</DataLocation>
<DefaultData>NsAutoDataDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsAutoDataD</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoDataI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
