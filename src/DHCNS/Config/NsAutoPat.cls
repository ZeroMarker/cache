/// creator:lulin
/// createdate:2020-02-19
/// description:系统自动获取患者相关信息表
Class DHCNS.Config.NsAutoPat Extends %Persistent
{

// 病区、日期、数据、类型（总数/床日数/白天新收/夜班新收/白班转入/夜班转入/白班转出/夜班转出）

Relationship ChildSub As DHCNS.Config.NsAutoPatSub [ Cardinality = children, Inverse = Parref ];

/// 病区
Property WardDR As %Integer [ SqlColumnNumber = 2, SqlFieldName = WardDR ];

/// 时间某天
Property DataDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DataTime ];

/// 数据
Property Value As %String [ SqlColumnNumber = 4, SqlFieldName = Value ];

/// 指标类型:S:总数,B:床日数,DN:白天新收,NN:夜班新收,DT:白班转入,NT:夜班转入,DO:白班转出,NO:夜班转出,24:24h重返,48:48h重返
Property IndexDR As %String [ SqlColumnNumber = 5, SqlFieldName = IndexDR ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = UpdateDate ];

Index Index On (IndexDR, WardDR, DataDate);

Storage Default
{
<Data name="NsAutoPatDefaultData">
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
<DataLocation>^DHCNS.Config.NsAutoPatD</DataLocation>
<DefaultData>NsAutoPatDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsAutoPatD</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoPatI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
