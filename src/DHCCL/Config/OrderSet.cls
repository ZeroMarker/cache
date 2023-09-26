/// 医嘱套
Class DHCCL.Config.OrderSet Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OrderSet ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ActiveDate As %Date [ SqlColumnNumber = 4 ];

Property ExpireDate As %Date [ SqlColumnNumber = 5 ];

Property OrderCategory As DHCCL.Config.OrderCategory [ SqlColumnNumber = 6 ];

Property OrderSubCat As DHCCL.Config.ArcimCat [ SqlColumnNumber = 7 ];

Property Price As %Float [ SqlColumnNumber = 8 ];

Property Priority As DHCCL.Code.OrderPriority [ SqlColumnNumber = 9 ];

Property Frequency As DHCCL.Code.Frequency [ SqlColumnNumber = 10 ];

Property Duration As DHCCL.Code.OrderDuration [ SqlColumnNumber = 11 ];

Property SecureGroup As DHCCL.Code.SecureGroup [ SqlColumnNumber = 12 ];

Property Location As DHCCL.Config.Location [ SqlColumnNumber = 13 ];

Property CreateUser As DHCCL.Config.SecureUser [ SqlColumnNumber = 14 ];

Property UpdateUser As DHCCL.Config.SecureUser [ SqlColumnNumber = 15 ];

Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 16 ];

Property UpdateTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 17 ];

Index Loc On Location;

Index SGroup On SecureGroup;

Index OrdCat On OrderCategory;

Index SubCat On OrderSubCat;

Index Code On Code [ Unique ];

Storage Default
{
<Data name="OrderSetDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ActiveDate</Value>
</Value>
<Value name="4">
<Value>ExpireDate</Value>
</Value>
<Value name="5">
<Value>OrderCategory</Value>
</Value>
<Value name="6">
<Value>OrderSubCat</Value>
</Value>
<Value name="7">
<Value>Price</Value>
</Value>
<Value name="8">
<Value>Priority</Value>
</Value>
<Value name="9">
<Value>Frequency</Value>
</Value>
<Value name="10">
<Value>Duration</Value>
</Value>
<Value name="11">
<Value>SecureGroup</Value>
</Value>
<Value name="12">
<Value>Location</Value>
</Value>
<Value name="13">
<Value>CreateUser</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
<Value name="15">
<Value>UpdateDate</Value>
</Value>
<Value name="16">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.OrderSetD</DataLocation>
<DefaultData>OrderSetDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.OrderSetD</IdLocation>
<IndexLocation>^DHCCL.Config.OrderSetI</IndexLocation>
<StreamLocation>^DHCCL.Config.OrderSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
