Class User.DHCEmDailyWorkLoadItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmDailyWorkLoadItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EMChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_EmDailyWorkLoad Parent Reference EM_ParRef_Dr
Relationship EMParRefDr As User.DHCEmDailyWorkLoad [ Cardinality = parent, Inverse = ChildDHCEmDAILYWORKLOADITEM, Required, SqlFieldName = EM_ParRef_Dr ];

/// EM_ChildSub
Property EMChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = EM_ChildSub ];

/// 项目ID  EM_Item_Dr
Property EMItemDr As User.DHCEmConsDicItem [ SqlColumnNumber = 3, SqlFieldName = EM_Item_Dr ];

/// 项目值  EM_ItemVal
Property EMItemVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EM_ItemVal ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="EM_ItemVal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMDWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmDailyWorkLoad.EM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmDailyWorkLoad.EM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCEMDWL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmDailyWorkLoad.EM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_Item_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmDailyWorkLoad.EM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDailyWorkLoadItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
