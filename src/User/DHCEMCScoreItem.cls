Class User.DHCEMCScoreItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EMCScoreItem, StorageStrategy = SQLStorage ]
{

/// 关联表ID   EC_ParRef_Dr
Property ECParRefDr As User.DHCEMCScore [ SqlColumnNumber = 2, SqlFieldName = EC_ParRef_Dr ];

/// 元素ID  EC_key
Property ECkey As %String [ SqlColumnNumber = 3, SqlFieldName = EC_key ];

/// 元素值  EC_Val
Property ECVal As %String [ SqlColumnNumber = 4, SqlFieldName = EC_Val ];

/// 元素类型  EC_Type
Property ECType As %String [ SqlColumnNumber = 5, SqlFieldName = EC_Type ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCSI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_Val">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_key">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCSI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexScore">
<Global>^DHCEMCSI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Score"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEMCScoreItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
