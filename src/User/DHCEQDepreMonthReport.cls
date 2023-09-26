Class User.DHCEQDepreMonthReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMR_RowID, SqlTableName = DHC_EQDepreMonthReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DMR_MonthStr
Property DMRMonthStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DMR_MonthStr ];

/// DMR_StartDate
Property DMRStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DMR_StartDate ];

/// DMR_EndDate
Property DMREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DMR_EndDate ];

/// DMR_MakeDate
Property DMRMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DMR_MakeDate ];

/// DMR_ResponsibleUserDR
Property DMRResponsibleUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DMR_ResponsibleUserDR ];

/// DMR_MakeUserDR
Property DMRMakeUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DMR_MakeUserDR ];

/// DMR_EquipTypes
Property DMREquipTypes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DMR_EquipTypes ];

/// DMR_Hold3
Property DMRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DMR_Hold3 ];

/// DMR_Hold4
Property DMRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DMR_Hold4 ];

/// DMR_Hold5
Property DMRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DMR_Hold5 ];

/// DMR_Hold1
Property DMRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DMR_Hold1 ];

/// DMR_Hold2
Property DMRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DMR_Hold2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDepreMonthReport("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DMR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DMR_EquipTypes">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DMR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DMR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DMR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DMR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DMR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DMR_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DMR_MakeUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DMR_MonthStr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMR_ResponsibleUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DMR_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQDepreMonthReport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DMR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMonth">
<Global>^DHCEQDepreMonthReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Month"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMR_MonthStr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DMR_EquipTypes}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDepreMonthReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
