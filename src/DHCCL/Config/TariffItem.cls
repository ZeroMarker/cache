/// 价表项目
Class DHCCL.Config.TariffItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = TariffItem ]
{

/// 收费编码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 收费项名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 单价
Property Price As %Float [ SqlColumnNumber = 4 ];

/// 单位
Property Uom As DHCCL.Config.Uom [ SqlColumnNumber = 5 ];

/// 生效日期
Property ActiveDate As %Date [ SqlColumnNumber = 6 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 激活标志
Property ActiveFlag As %String [ SqlColumnNumber = 8 ];

Index Code On Code [ Unique ];

Index Desc On Description;

Storage Default
{
<Data name="TariffItemDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Price</Value>
</Value>
<Value name="4">
<Value>Uom</Value>
</Value>
<Value name="5">
<Value>ActiveDate</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>ActiveFlag</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.TariffItemD</DataLocation>
<DefaultData>TariffItemDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.TariffItemD</IdLocation>
<IndexLocation>^DHCCL.Config.TariffItemI</IndexLocation>
<StreamLocation>^DHCCL.Config.TariffItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
