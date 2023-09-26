/// creator:lulin
/// createdate:2019-12-04
/// description:元素子表,用于对计算类的元素进行加减计算关联末端元素
Class CT.DHCNS.Config.NsElementSub Extends %Persistent
{

Relationship Parref As CT.DHCNS.Config.NsElement [ Cardinality = parent, Inverse = ChildSub ];

/// 末端元素
Property EndEleDR As CT.DHCNS.Config.NsElement [ SqlColumnNumber = 2, SqlFieldName = EndEleDR ];

/// 方式：Y/"":+或N:-
Property Type As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = Type ];

Index End On (EndEleDR, Parref);

Storage Default
{
<Data name="NsElementSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EndEleDR</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^CT.DHCNS.Config.NsElementSubD</DataLocation>
<DefaultData>NsElementSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^CT.DHCNS.Config.NsElementSubI</IndexLocation>
<StreamLocation>^CT.DHCNS.Config.NsElementSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
