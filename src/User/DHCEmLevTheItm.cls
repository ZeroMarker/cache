Class User.DHCEmLevTheItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = LTI_RowID, SqlTableName = DHC_EmLevTheItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LTIChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表id LTI_The_ParRef	
Relationship LTITheParRef As User.DHCEmLevTheme [ Cardinality = parent, Inverse = ChildDHCEMLEVTHEITM, Required, SqlFieldName = LTI_The_ParRef ];

/// 子表sub LTI_ChildSub	
Property LTIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LTI_ChildSub ];

/// 分级 LTI_Lev	
Property LTILev As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = LTI_Lev ];

/// 表达式 LTI_Desc	
Property LTIDesc As User.DHCEmLevExpress [ SqlColumnNumber = 4, SqlFieldName = LTI_Desc ];

/// 是否可用 LTI_ActiveFlag	
Property LTIActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LTI_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexDesc">
<Global>^DHCEMLTH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmLevTheme.LTH_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LTIDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LTI_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmLevTheme.LTH_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLev">
<Global>^DHCEMLTH</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Lev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LTI_ActiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LTI_Lev}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_EmLevTheme.LTH_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="LTI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LTI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LTI_Lev">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMLTH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmLevTheme.LTH_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmLevTheme.LTH_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"L"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LTI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmLevTheItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
