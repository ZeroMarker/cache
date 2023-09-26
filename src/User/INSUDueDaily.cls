Class User.INSUDueDaily Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDUD_Rowid, SqlTableName = INSU_DueDaily, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDUD_JieFang
Property INDUDJieFang As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = INDUD_JieFang ];

/// INDUD_DaiFang
Property INDUDDaiFang As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INDUD_DaiFang ];

/// INDUD_Balance
Property INDUDBalance As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = INDUD_Balance ];

/// INDUD_Date
Property INDUDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = INDUD_Date ];

/// INDUD_Flag
Property INDUDFlag As %Library.String(DISPLAYLIST = ",Jie,Dai,Ping", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",J,D,P") [ SqlColumnNumber = 6, SqlFieldName = INDUD_Flag ];

/// INDUD_District
Property INDUDDistrict As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INDUD_District ];

/// INDUD_Demo
Property INDUDDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDUD_Demo ];

/// INDUD_BackType
Property INDUDBackType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INDUD_BackType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDUD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INDUD_BackType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDUD_Balance">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDUD_DaiFang">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDUD_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDUD_Demo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDUD_District">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDUD_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDUD_JieFang">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCINDUD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDUD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofBackType">
<Global>^DHCINDUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BackType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDUD_BackType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^DHCINDUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDUD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDistrict">
<Global>^DHCINDUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDUD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"District"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDUD_District}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDueDailyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
