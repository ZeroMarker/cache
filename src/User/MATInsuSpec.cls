/// 医保医用耗材分类与代码-规格
Class User.MATInsuSpec Extends (%Persistent, User.Abstract) [ SqlRowIdName = MATIS_RowId, SqlTableName = MAT_InsuSpec ]
{

/// 规格Code(医保代码+规格流水号,27位, 对应good_id)
Property MATISSpecCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = MATIS_SpecCode ];

/// 国家医保耗材编码
Property MATISInsuCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = MATIS_InsuCode ];

/// 规格流水号
Property MATISSerialNo As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = MATIS_SerialNo ];

/// 规格(和国家医保耗材数据的good_id对应)
Property MATISSpec As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = MATIS_Spec ];

/// 型号
Property MATISModel As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = MATIS_Model ];

/// DI码
Property MATISDICode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = MATIS_DICode ];

/// 国家医保数据中的product_id
Property MATISProductId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = MATIS_ProductId ];

/// 国家医保数据中的good_id
Property MATISGoodId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = MATIS_GoodId ];

Index MATISInsuCode On MATISInsuCode As Exact;

Index MATISSpecCode On MATISSpecCode As Exact;

Index MATISProductId On MATISProductId As Exact;

Index MATISGoodId On MATISGoodId As Exact;

Storage Default
{
<Data name="MATInsuSpecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATISSpecCode</Value>
</Value>
<Value name="3">
<Value>MATISInsuCode</Value>
</Value>
<Value name="4">
<Value>MATISSerialNo</Value>
</Value>
<Value name="5">
<Value>MATISSpec</Value>
</Value>
<Value name="6">
<Value>MATISModel</Value>
</Value>
<Value name="7">
<Value>MATISDICode</Value>
</Value>
<Value name="8">
<Value>MATISProductId</Value>
</Value>
<Value name="9">
<Value>MATISGoodId</Value>
</Value>
</Data>
<DataLocation>^User.MATInsuSpecD</DataLocation>
<DefaultData>MATInsuSpecDefaultData</DefaultData>
<IdLocation>^User.MATInsuSpecD</IdLocation>
<IndexLocation>^User.MATInsuSpecI</IndexLocation>
<SqlRowIdName>MATIS_RowId</SqlRowIdName>
<StreamLocation>^User.MATInsuSpecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
