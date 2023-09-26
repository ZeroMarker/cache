Class User.DHCWLAccount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACC_Rowid, SqlTableName = DHCWLAccount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ACC_StartDate
Property ACCStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = ACC_StartDate ];

/// ACC_EndDate
Property ACCEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ACC_EndDate ];

/// ACC_LastPeriod
Property ACCLastPeriod As User.DHCWLAccount [ SqlColumnNumber = 4, SqlFieldName = ACC_LastPeriod ];

/// ACC_Stat_Dr
Property ACCStatDr As User.DHCWLStat [ SqlColumnNumber = 5, SqlFieldName = ACC_Stat_Dr ];

/// ACC_Flag
Property ACCFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ACC_Flag ];

/// ACC_CreaterDate
Property ACCCreaterDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ACC_CreaterDate ];

/// ACC_CreateTime
Property ACCCreateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = ACC_CreateTime ];

/// ACC_Name
Property ACCName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ACC_Name ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWLACCOUNT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ACC_CreaterDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ACC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACC_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACC_LastPeriod">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACC_Name">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ACC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACC_Stat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCWLACCOUNT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ACC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexaccname">
<Global>^DHCWLACCOUNT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACC_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLAccountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
