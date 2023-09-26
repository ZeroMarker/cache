Class User.DHCAppTreeAdd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TRA_RowID, SqlTableName = DHC_AppTreeAdd, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPTREELINK As User.DHCAppTreeLink [ Cardinality = children, Inverse = TRAAddParRef ];

/// 代码  TRA_Code
Property TRACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TRA_Code ];

/// 描述  TRA_Desc
Property TRADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TRA_Desc ];

/// 级别  TRA_Level
Property TRALevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TRA_Level ];

/// 上一级的rowid  TRA_LastRowid
Property TRALastRowid As User.DHCAppTreeAdd [ SqlColumnNumber = 5, SqlFieldName = TRA_LastRowid ];

/// 集团化医院  TRA_Hosp_Dr
Property TRAHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = TRA_Hosp_Dr ];

/// 顺序号  TRA_OrdNum
Property TRAOrdNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TRA_OrdNum ];

/// 别名  TRA_Alias
Property TRAAlias As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TRA_Alias ];

/// 保存对象  TRA_SaveAs
Property TRASaveAs As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TRA_SaveAs ];

/// 对应的id  TRA_Pointer
Property TRAPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TRA_Pointer ];

/// 类型  TRA_Type
Property TRAType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TRA_Type ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTRA)</SqlIdExpression>
<SQLMap name="IndexAlias">
<Global>^DHCAPPTRA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_Alias}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({TRA_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLastRowid">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LastRowid"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_LastRowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLevDesc">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LevDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_Level}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdNum">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_OrdNum}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSaveAs">
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SaveAs"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRA_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRA_LastRowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRA_OrdNum}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TRA_Alias">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRA_LastRowid">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRA_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRA_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TRA_SaveAs">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRA_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCAPPTRA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TRA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TRA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTreeAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
