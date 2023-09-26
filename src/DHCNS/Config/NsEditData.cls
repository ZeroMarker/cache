/// creator:lulin
/// createdate:2019-12-15
/// description:用户填报数据
Class DHCNS.Config.NsEditData Extends %Persistent
{

/// 病区
Property WardDR As %Integer [ SqlColumnNumber = 2, SqlFieldName = WardDR ];

/// 时间（某天yyyy-MM-dd、月yyyy-MM、季yyyy-QQ,周yyyy-WW(本年度第几周),半年yyyy-HH(上半年01,下半年02),年:yyyy）
Property DataTime As %String [ SqlColumnNumber = 3, SqlFieldName = DataTime ];

/// 数据
Property Value As %String [ SqlColumnNumber = 4, SqlFieldName = Value ];

/// 指标外键第一个字符E:元素，I:指标，目前默认全部未E
Property IndexDR As %String [ SqlColumnNumber = 5, SqlFieldName = IndexDR ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 6, SqlFieldName = Remark ];

/// 最后填写时间
Property UpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = UpdateDate ];

/// 最后填写人
Property Updator As %String [ SqlColumnNumber = 8, SqlFieldName = Updator ];

/// 相关模板ID
Property ModelID As %Integer [ SqlColumnNumber = 9, SqlFieldName = ModelID ];

/// 数据日期
Property DataDay As %Date [ SqlColumnNumber = 10, SqlFieldName = DataDay ];

Index Index On (IndexDR, WardDR, DataTime);

Index Model On (ModelID, WardDR, DataTime);

Index IndexDay On (IndexDR, WardDR, DataDay);

Index ModelDay On (ModelID, WardDR, DataDay);

Storage Default
{
<Data name="NsEditDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>DataTime</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>IndexDR</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>Updator</Value>
</Value>
<Value name="9">
<Value>ModelID</Value>
</Value>
<Value name="10">
<Value>DataDay</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsEditDataD</DataLocation>
<DefaultData>NsEditDataDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsEditDataD</IdLocation>
<IndexLocation>^DHCNS.Config.NsEditDataI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsEditDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
