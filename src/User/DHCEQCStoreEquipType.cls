Class User.DHCEQCStoreEquipType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LEL_RowID, SqlTableName = DHC_EQCStoreEquipType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LEL_StoreLocDR
Property LELStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LEL_StoreLocDR ];

/// LEL_EquipTypeDR .
Property LELEquipTypeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LEL_EquipTypeDR ];

/// LEL_StatCatDR .
Property LELStatCatDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LEL_StatCatDR ];

/// LEL_Remark
Property LELRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LEL_Remark ];

/// LEL_InvalidFlag
Property LELInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = LEL_InvalidFlag ];

/// LEL_Flag
Property LELFlag As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LEL_Flag ];

/// LEL_Hold1
Property LELHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = LEL_Hold1 ];

/// LEL_Hold2
Property LELHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = LEL_Hold2 ];

/// LEL_Hold3
Property LELHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = LEL_Hold3 ];

/// LEL_Hold4
Property LELHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = LEL_Hold4 ];

/// LEL_Hold5
Property LELHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = LEL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCStoreEquipType",0))</SqlIdExpression>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCEQCStoreEquipType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LEL_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LEL_StoreLocDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LEL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LEL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LEL_Flag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LEL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LEL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LEL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LEL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LEL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LEL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LEL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LEL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LEL_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LEL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCStoreEquipType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{LEL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCStoreEquipTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
