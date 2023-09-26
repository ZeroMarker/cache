/// 医嘱项
Class DHCCL.Config.Arcim Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Arcim ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property Abbreviation As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property ChgUnitFact As %Float [ SqlColumnNumber = 5 ];

Property ArcimCat As DHCCL.Config.ArcimCat [ SqlColumnNumber = 6 ];

Property DrugForm As %String [ SqlColumnNumber = 7 ];

Property GenericDesc As %String [ SqlColumnNumber = 8 ];

Property ShortDesc As %String [ SqlColumnNumber = 9 ];

Property DefPriority As DHCCL.Code.OrderPriority [ SqlColumnNumber = 10 ];

Property ActiveDate As %Date [ SqlColumnNumber = 11 ];

Property ActiveTime As %Time [ SqlColumnNumber = 12 ];

Property ExpireDate As %Date [ SqlColumnNumber = 13 ];

Property ExpireTime As %Time [ SqlColumnNumber = 14 ];

Property ExternalID As %String [ SqlColumnNumber = 15 ];

Index ArcimCat On ArcimCat;

Index Code On Code [ Unique ];

Storage Default
{
<Data name="ArcimDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Abbreviation</Value>
</Value>
<Value name="4">
<Value>ChgUnitFact</Value>
</Value>
<Value name="5">
<Value>ArcimCat</Value>
</Value>
<Value name="6">
<Value>DrugForm</Value>
</Value>
<Value name="7">
<Value>GenericDesc</Value>
</Value>
<Value name="8">
<Value>ShortDesc</Value>
</Value>
<Value name="9">
<Value>DefPriority</Value>
</Value>
<Value name="10">
<Value>ActiveDate</Value>
</Value>
<Value name="11">
<Value>ActiveTime</Value>
</Value>
<Value name="12">
<Value>ExpireDate</Value>
</Value>
<Value name="13">
<Value>ExpireTime</Value>
</Value>
<Value name="14">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.ArcimD</DataLocation>
<DefaultData>ArcimDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.ArcimD</IdLocation>
<IndexLocation>^DHCCL.Config.ArcimI</IndexLocation>
<StreamLocation>^DHCCL.Config.ArcimS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
