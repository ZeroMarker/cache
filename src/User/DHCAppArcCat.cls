Class User.DHCAppArcCat Extends (%Persistent, User.Abstract) [ SqlRowIdName = AC_RowID, SqlTableName = DHC_AppArcCat, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPCATLINKORD As User.DHCAppCatLinkOrd [ Cardinality = children, Inverse = ACCatParRef ];

/// 分类代码 AC_CatCode
Property ACCatCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = AC_CatCode ];

/// 分类描述 AC_CatDesc
Property ACCatDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = AC_CatDesc ];

/// 医嘱子类 AC_OrdCat_Dr
Property ACOrdCatDr As User.ARCItemCat [ SqlColumnNumber = 4, SqlFieldName = AC_OrdCat_Dr ];

/// 集团化医院 AC_Hosp_Dr
Property ACHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AC_Hosp_Dr ];

Relationship ChildDHCAPPCATLINKPART As User.DHCAppCatLinkPart [ Cardinality = children, Inverse = ACLPCatParRef ];

Relationship ChildDHCAPPCATLINKOPT As User.DHCAppCatLinkOpt [ Cardinality = children, Inverse = ALOOptParRef ];

Relationship ChildDHCAppCatLinkArcItm As User.DHCAppCatLinkArcItm [ Cardinality = children, Inverse = ACCatArcItmParRef ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPARCCA)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AC_CatCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AC_CatDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCatDr">
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_OrdCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="AC_CatCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AC_CatDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AC_OrdCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
