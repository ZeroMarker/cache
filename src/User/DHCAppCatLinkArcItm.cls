Class User.DHCAppCatLinkArcItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AC_RowID, SqlTableName = DHC_AppCatLinkArcItm, StorageStrategy = SqlStorage ]
{

/// DHC_AppArcCat Parent Reference AC_CatArcItm_ParRef
Relationship ACCatArcItmParRef As User.DHCAppArcCat [ Cardinality = parent, Inverse = ChildDHCAppCatLinkArcItm, Required, SqlFieldName = AC_CatArcItm_ParRef ];

Index RowIDBasedIDKeyIndex On ACChildSub [ IdKey, PrimaryKey, Unique ];

/// AC_ChildSub
Property ACChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AC_ChildSub ];

/// 医嘱项id  AC_ArcItm_Dr 
Property ACArcItmDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = AC_ArcItm_Dr ];

/// 冰冻标志 AC_FrostFlag 
Property ACFrostFlag As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AC_FrostFlag ];

/// 单独分单标志 AC_SingleFlag
Property ACSingleFlag As %Library.String [ SqlColumnNumber = 5, SqlFieldName = AC_SingleFlag ];

Storage SqlStorage
{
<SQLMap name="IndexArc">
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
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_ArcItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSingFlag">
<Global>^DHCAPARCCA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AppArcCat.AC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SingFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_SingleFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_ArcItm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AppArcCat.AC_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="AC_ArcItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AC_FrostFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AC_SingleFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
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
<Expression>"ArcItm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppCatLinkArcItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
