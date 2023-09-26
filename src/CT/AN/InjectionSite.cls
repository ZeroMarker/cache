/// 输液通路
Class CT.AN.InjectionSite Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = InjectionSite ]
{

/// 数据项代码
Property Code As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2 ];

/// 数据项名称
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 图标
Property Legend As CT.AN.Legend [ SqlColumnNumber = 4 ];

/// 颜色
Property Color As %String [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="InjectionSiteDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Legend</Value>
</Value>
<Value name="4">
<Value>Color</Value>
</Value>
</Data>
<DataLocation>^CT.AN.InjectionSiteD</DataLocation>
<DefaultData>InjectionSiteDefaultData</DefaultData>
<IdLocation>^CT.AN.InjectionSiteD</IdLocation>
<IndexLocation>^CT.AN.InjectionSiteI</IndexLocation>
<StreamLocation>^CT.AN.InjectionSiteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
