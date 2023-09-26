Class User.DHCEQStoreMonthStat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMS_RowID, SqlTableName = DHC_EQStoreMonthStat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SMS_MonthStr
Property SMSMonthStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SMS_MonthStr ];

/// SMS_StartDate
Property SMSStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = SMS_StartDate ];

/// SMS_EndDate
Property SMSEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = SMS_EndDate ];

/// SMS_MakeDate
Property SMSMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = SMS_MakeDate ];

/// SMS_ResponsibleUserDR
Property SMSResponsibleUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SMS_ResponsibleUserDR ];

/// SMS_MakeUserDR
Property SMSMakeUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SMS_MakeUserDR ];

/// SMS_Hold1
Property SMSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SMS_Hold1 ];

/// SMS_Hold2
Property SMSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SMS_Hold2 ];

/// SMS_Hold3
Property SMSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SMS_Hold3 ];

/// SMS_StatCats
Property SMSStatCats As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SMS_StatCats ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQStoreMonthStat("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SMS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMS_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMS_MakeUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMS_MonthStr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMS_ResponsibleUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMS_StatCats">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQStoreMonthStat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SMS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMonthStr">
<Global>^DHCEQStoreMonthStat</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MonthStr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMS_MonthStr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SMS_StatCats}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQStoreMonthStatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
