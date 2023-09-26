Class User.DHCPRTMainItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MAI_RowID, SqlTableName = DHC_PRTMainItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MAIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MAIParRefDr As User.DHCPRTMain [ Cardinality = parent, Inverse = ChildDHCPRTMAINITEM, Required, SqlFieldName = MAI_ParRef_Dr ];

/// MC_ChildSub
Property MAIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MAI_ChildSub ];

/// 模板内容
Property MAIText As %Library.Text(MAXLEN = 50000) [ SqlColumnNumber = 3, SqlFieldName = MAI_Text ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="MAI_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPRTMA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PRTMain.MA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PRTMain.MA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MAI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPRTMainItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
