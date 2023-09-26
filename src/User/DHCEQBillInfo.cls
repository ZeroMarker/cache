Class User.DHCEQBillInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BI_RowID, SqlTableName = DHC_EQBillInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BI_SourceType
Property BISourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BI_SourceType ];

/// BI_SourceID
Property BISourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BI_SourceID ];

/// BI_EquipTypeDR
Property BIEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 4, SqlFieldName = BI_EquipTypeDR ];

/// BI_StatCatDR
Property BIStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 5, SqlFieldName = BI_StatCatDR ];

/// BI_OriginDR
Property BIOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 6, SqlFieldName = BI_OriginDR ];

/// BI_LocDR
Property BILocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BI_LocDR ];

/// BI_Hold1
Property BIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BI_Hold1 ];

/// BI_Hold2
Property BIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BI_Hold2 ];

/// BI_Hold3
Property BIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BI_Hold3 ];

/// BI_Hold4
Property BIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BI_Hold4 ];

/// BI_Hold5
Property BIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBillInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BI_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BI_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BI_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BI_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQBillInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQBillInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BI_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BI_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBillInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
