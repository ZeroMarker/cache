Class User.DHCEQCheckResult Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CR_RowID, SqlTableName = DHC_EQCheckResult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CR_Date
Property CRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = CR_Date ];

/// CR_EndMonth
Property CREndMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CR_EndMonth ];

/// CR_Hold1
Property CRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CR_Hold1 ];

/// CR_Hold2
Property CRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CR_Hold2 ];

/// CR_Hold3
Property CRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CR_Hold3 ];

/// CR_Hold4
Property CRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CR_Hold4 ];

/// CR_Hold5
Property CRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CR_Hold5 ];

/// CR_QueryName
Property CRQueryName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CR_QueryName ];

/// CR_QueryPara
Property CRQueryPara As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CR_QueryPara ];

/// CR_SourceName
Property CRSourceName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CR_SourceName ];

/// CR_SourceType
Property CRSourceType As %Library.String(DISPLAYLIST = ",任务结果,报表结果", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 2, SqlFieldName = CR_SourceType ];

/// CR_Status
Property CRStatus As %Library.String(DISPLAYLIST = ",正常,异常", MAXLEN = 2, SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 9, SqlFieldName = CR_Status ];

/// CR_StrMonth
Property CRStrMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CR_StrMonth ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheckResult("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CR_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CR_EndMonth">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CR_QueryName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CR_QueryPara">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CR_SourceName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CR_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CR_StrMonth">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCheckResult</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQCheckResult</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeMonth">
<Global>^DHCEQCheckResult</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CR_SourceName}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
