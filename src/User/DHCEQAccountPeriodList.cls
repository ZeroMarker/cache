Class User.DHCEQAccountPeriodList Extends %Persistent [ SqlRowIdName = APL_RowID, SqlTableName = DHC_EQAccountPeriodList, StorageStrategy = SQLStorage ]
{

/// APL_AccountPeriodDR
Property APLAccountPeriodDR As User.DHCEQAccountPeriod [ SqlColumnNumber = 2, SqlFieldName = APL_AccountPeriodDR ];

/// APL_BussType	//21:入库、22:转移   23:减少   34报废、  51设备调帐  52 设备  99：数据调整
Property APLBussType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = APL_BussType ];

/// APL_BussID
Property APLBussID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = APL_BussID ];

/// APL_Hold1
Property APLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = APL_Hold1 ];

/// APL_Hold2
Property APLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = APL_Hold2 ];

/// APL_Hold3
Property APLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = APL_Hold3 ];

/// APL_Hold4
Property APLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = APL_Hold4 ];

/// APL_Hold5
Property APLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = APL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAccountPeriodList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="APL_AccountPeriodDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APL_BussID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APL_BussType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQAccountPeriodList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>APL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{APL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQAccountPeriodList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>APL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BussID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{APL_AccountPeriodDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{APL_BussType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{APL_BussID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQAccountPeriodListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
