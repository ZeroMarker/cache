Class User.DHCEmPatSeatItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SE_RowID, SqlTableName = DHC_EmPatSeatItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SEChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表id SE_The_ParRef	
Relationship SETheParRef As User.DHCEmPatSeat [ Cardinality = parent, Inverse = ChildDHCEMPATSEST, Required, SqlFieldName = SE_The_ParRef ];

/// 子表sub SE_ChildSub	
Property SEChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SE_ChildSub ];

/// 座位代码 SE_Code	
Property SECode As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = SE_Code ];

/// 座位描述 SE_Desc	
Property SEDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = SE_Desc ];

/// 座位类型 SE_Type 【指向User.DHCEmPatSeatCat】
Property SEType As User.DHCEmPatSeatCat [ SqlColumnNumber = 5, SqlFieldName = SE_Type ];

/// 作为使用标志 
Property SEPatDescDr As User.DHCNurSyPatRec [ SqlColumnNumber = 6, SqlFieldName = SE_PatDesc_Dr ];

Storage SQLStorage
{
<SQLMap name="IndexCode">
<Global>^DHCEMPSE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmPatSeat.SE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SE_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmPatSeat.SE_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMPSE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmPatSeat.SE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SE_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmPatSeat.SE_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatRec">
<Global>^DHCEMPSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmPatSeat.SE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NurPatRec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SE_PatDesc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmPatSeat.SE_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEMPSE</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SE_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmPatSeat.SE_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="SE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SE_PatDesc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SE_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMPSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmPatSeat.SE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmPatSeat.SE_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SE_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatSeatItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
