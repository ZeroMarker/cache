Class User.MATPackage Extends (%Persistent, User.Abstract) [ SqlRowIdName = MATP_RowId, SqlTableName = MAT_Package ]
{

Relationship ChildDHCMATPackageTrans As User.DHCMATPackageTrans [ Cardinality = children, Inverse = DMPTParref ];

/// 条码发货单子表ID
Property MATPDetailSubId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = MATP_DetailSubId ];

/// 平台打包条码ID
Property MATPPackageId As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = MATP_PackageId ];

Property MATFPPackageSmall As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = MATFP_PackageSmall ];

Property MATFPPackageMedium As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = MATFP_PackageMedium ];

Property MATFPPackageBig As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = MATFP_PackageBig ];

/// 新增库存项Id
Property MATPIncId As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = MATP_IncId ];

Property MATPINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 8, SqlFieldName = MATP_INCLB_DR ];

/// 操作日期
Property MATPDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = MATP_Date ];

/// 操作时间
Property MATPTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MATP_Time ];

Property MATPCTUOMDr As CTUOM [ Required, SqlColumnNumber = 11, SqlFieldName = MATP_CTUOM_Dr ];

Index PackageSmall On MATFPPackageSmall As Exact;

Index PackageMedium On MATFPPackageMedium As Exact;

Index PackageBig On MATFPPackageBig As Exact;

Index IndexInclb On MATPINCLBDR As Exact;

Index IndexInci On MATPIncId As Exact;

Index IndexDetailSubId On MATPDetailSubId As Exact;

Index Indexdate On MATPDate As Exact;

Storage Default
{
<Data name="MATPackageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATPDetailSubId</Value>
</Value>
<Value name="3">
<Value>MATPPackageId</Value>
</Value>
<Value name="4">
<Value>MATFPPackageSmall</Value>
</Value>
<Value name="5">
<Value>MATFPPackageMedium</Value>
</Value>
<Value name="6">
<Value>MATFPPackageBig</Value>
</Value>
<Value name="7">
<Value>MATPIncId</Value>
</Value>
<Value name="8">
<Value>MATPINCLBDR</Value>
</Value>
<Value name="9">
<Value>MATPDate</Value>
</Value>
<Value name="10">
<Value>MATPTime</Value>
</Value>
<Value name="11">
<Value>MATPCTUOMDr</Value>
</Value>
</Data>
<DataLocation>^User.MATPackageD</DataLocation>
<DefaultData>MATPackageDefaultData</DefaultData>
<IdLocation>^User.MATPackageD</IdLocation>
<IndexLocation>^User.MATPackageI</IndexLocation>
<SqlRowIdName>MATP_RowId</SqlRowIdName>
<StreamLocation>^User.MATPackageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
