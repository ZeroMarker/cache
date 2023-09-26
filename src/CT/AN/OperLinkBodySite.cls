/// 手术关联部位
Class CT.AN.OperLinkBodySite Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperLinkBodySite ]
{

/// 手术
Property Operation As %String [ Required, SqlColumnNumber = 2 ];

/// 部位
Property BodySite As %String [ Required, SqlColumnNumber = 3 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5 ];

Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

Index IActive On Active;

Index IOperation On Operation;

Index IBodySite On BodySite;

Storage Default
{
<Data name="OperLinkBodySiteDefaultData">
<Value name="1">
<Value>Operation</Value>
</Value>
<Value name="2">
<Value>BodySite</Value>
</Value>
<Value name="3">
<Value>ActiveDate</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperLinkBodySiteD</DataLocation>
<DefaultData>OperLinkBodySiteDefaultData</DefaultData>
<IdLocation>^CT.AN.OperLinkBodySiteD</IdLocation>
<IndexLocation>^CT.AN.OperLinkBodySiteI</IndexLocation>
<StreamLocation>^CT.AN.OperLinkBodySiteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
