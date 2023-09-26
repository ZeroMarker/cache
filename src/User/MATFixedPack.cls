Class User.MATFixedPack Extends (%Persistent, User.Abstract) [ SqlTableName = MAT_FixedPack ]
{

Relationship ChildMATFixedPackItm As User.MATFixedPackItm [ Cardinality = children, Inverse = MATFPIParRef ];

/// 定数包条码
Property MATFPNo As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = MATFP_No ];

Property MATFPINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = MATFP_INCI_DR ];

/// 数量
Property MATFPQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = MATFP_Qty ];

/// 制作科室
Property MATFPCTLOCDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = MATFP_CTLOC_DR ];

/// 录入人
Property MATFPCreateUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = MATFP_CreateUser ];

/// 录入日期
Property MATFPCreateDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = MATFP_CreateDate ];

/// 录入单时间
Property MATFPCreateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MATFP_CreateTime ];

Storage Default
{
<Data name="MATFixedPackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATFPNo</Value>
</Value>
<Value name="3">
<Value>MATFPINCIDR</Value>
</Value>
<Value name="4">
<Value>MATFPQty</Value>
</Value>
<Value name="5">
<Value>MATFPCTLOCDR</Value>
</Value>
<Value name="6">
<Value>MATFPCreateUser</Value>
</Value>
<Value name="7">
<Value>MATFPCreateDate</Value>
</Value>
<Value name="8">
<Value>MATFPCreateTime</Value>
</Value>
</Data>
<DataLocation>^User.MATFixedPackD</DataLocation>
<IdLocation>^User.MATFixedPackD</IdLocation>
<IndexLocation>^User.MATFixedPackI</IndexLocation>
<SqlRowIdName>MAT_FixedPack</SqlRowIdName>
<StreamLocation>^User.MATFixedPackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
