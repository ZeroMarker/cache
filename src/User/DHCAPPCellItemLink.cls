Class User.DHCAPPCellItemLink Extends %Persistent [ SqlTableName = DHC_APPCellItemLink, StorageStrategy = DHCAPPCellItemLink ]
{

/// 项目大类型
Property APPCellMastItem As User.DHCAppPisDicItem [ SqlColumnNumber = 2, SqlFieldName = APP_CellMastItem ];

/// 项目明细^DHCAPPCellItemLink
Property APPCellItem As User.DHCAppPisDicItem [ SqlColumnNumber = 3, SqlFieldName = APP_CellItem ];

/// 项目明细^DHCAPPCellItemLink
Property APPHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = APP_HospDr ];

Storage DHCAPPCellItemLink
{
<SqlIdExpression>$i(^DHCAPPCellItemLink(0))</SqlIdExpression>
<SQLMap name="IndexCellItem">
<Global>^DHCAPPCellItemLinki</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Mast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APP_CellMastItem}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MastMap">
<Data name="APP_CellItem">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APP_CellMastItem">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APP_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPCellItemLink</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCAPPCellItemLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
