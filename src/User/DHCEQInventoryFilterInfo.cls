Class User.DHCEQInventoryFilterInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IFI_RowID, SqlTableName = DHC_EQInventoryFilterInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IFI_InventoryDR
Property IFIInventoryDR As User.DHCEQInventory [ SqlColumnNumber = 2, SqlFieldName = IFI_InventoryDR ];

/// IFI_InventoryCondition
Property IFIInventoryCondition As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IFI_InventoryCondition ];

/// IFI_Value
Property IFIValue As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IFI_Value ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInventoryFilterInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IFI_InventoryCondition">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IFI_InventoryDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IFI_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQInventoryFilterInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IFI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IFI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInventory">
<Global>^DHCEQInventoryFilterInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IFI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Inventory"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IFI_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IFI_InventoryCondition}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IFI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInventoryFilterInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
