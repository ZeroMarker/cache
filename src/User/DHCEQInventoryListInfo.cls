Class User.DHCEQInventoryListInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ILI_RowID, SqlTableName = DHC_EQInventoryListInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ILI_Hold1
Property ILIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ILI_Hold1 ];

/// ILI_Hold2
Property ILIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ILI_Hold2 ];

/// ILI_Hold3
Property ILIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ILI_Hold3 ];

/// ILI_Hold4
Property ILIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ILI_Hold4 ];

/// ILI_Hold5
Property ILIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ILI_Hold5 ];

/// ILI_InvalidFlag
Property ILIInvalidFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ILI_InvalidFlag ];

/// ILI_InventoryListDR
Property ILIInventoryListDR As User.DHCEQInventoryList [ SqlColumnNumber = 2, SqlFieldName = ILI_InventoryListDR ];

/// ILI_KeeperDR
Property ILIKeeperDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ILI_KeeperDR ];

/// ILI_LeaveFactoryNo
Property ILILeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ILI_LeaveFactoryNo ];

/// ILI_LocationDR
Property ILILocationDR As User.DHCEQCLocation [ SqlColumnNumber = 4, SqlFieldName = ILI_LocationDR ];

/// ILI_UpdateDate
Property ILIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = ILI_UpdateDate ];

/// ILI_UpdateTime
Property ILIUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = ILI_UpdateTime ];

/// ILI_UpdateUserDR
Property ILIUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ILI_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInventoryListInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ILI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ILI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ILI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ILI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ILI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ILI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ILI_InventoryListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ILI_KeeperDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILI_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ILI_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ILI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ILI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ILI_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQInventoryListInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ILI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInventoryList">
<Global>^DHCEQInventoryListInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IList"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ILI_InventoryListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ILI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInventoryListInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
