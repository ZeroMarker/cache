Class User.DHCJFUpReport Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UPR_RowId, SqlTableName = DHC_JFUpReport, StorageStrategy = SQLStorage ]
{

/// UPR_PAPMI_DR
Property UPRPAPMIDR As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = UPR_PAPMI_DR ];

/// UPR_Adm_DR
Property UPRAdmDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = UPR_Adm_DR ];

/// UPR_TableName
Property UPRTableName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UPR_TableName ];

/// UPR_ItemName
Property UPRItemName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UPR_ItemName ];

/// UPR_OldValue
Property UPROldValue As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UPR_OldValue ];

/// UPR_NewValue
Property UPRNewValue As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = UPR_NewValue ];

/// UPR_User_DR
Property UPRUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = UPR_User_DR ];

/// UPR_Date
Property UPRDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = UPR_Date ];

/// UPR_Time
Property UPRTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = UPR_Time ];

/// UPR_Flag
Property UPRFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UPR_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFUPR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UPR_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UPR_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UPR_Flag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UPR_ItemName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UPR_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UPR_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UPR_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UPR_TableName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UPR_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UPR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCJFUPR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UPR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexAdm">
<Global>^DHCJFUPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPR_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCJFUPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexFlag">
<Global>^DHCJFUPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPR_Flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPAPMI">
<Global>^DHCJFUPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"papmi"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPR_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexTableName">
<Global>^DHCJFUPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"table"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPR_TableName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUser">
<Global>^DHCJFUPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"user"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPR_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFUpReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
