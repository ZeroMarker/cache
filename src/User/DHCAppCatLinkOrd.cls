Class User.DHCAppCatLinkOrd Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AC_RowID, SqlTableName = DHC_AppCatLinkOrd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ACChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppArcCat Parent Reference AC_Cat_ParRef
Relationship ACCatParRef As User.DHCAppArcCat [ Cardinality = parent, Inverse = ChildDHCAPPCATLINKORD, Required, SqlFieldName = AC_Cat_ParRef ];

/// AC_ChildSub
Property ACChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AC_ChildSub ];

/// 医嘱子类id  AC_OrdCat_Dr 
Property ACOrdCatDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = AC_OrdCat_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="Indexcat">
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppArcCat.AC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_OrdCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="AC_OrdCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppArcCat.AC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppCatLinkOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
