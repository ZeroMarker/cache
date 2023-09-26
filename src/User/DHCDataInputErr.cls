Class User.DHCDataInputErr Extends (%Persistent, User.Abstract) [ SqlRowIdName = DataInputErr_RowId, SqlTableName = DHC_DataInputErr, StorageStrategy = SQLStorage ]
{

/// DataInputErr_Date
Property DataInputErrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DataInputErr_Date ];

/// DataInputErr_Time
Property DataInputErrTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = DataInputErr_Time ];

/// DataInputErr_No
Property DataInputErrNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DataInputErr_No ];

/// DataInputErr_Desc
Property DataInputErrDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DataInputErr_Desc ];

Storage SQLStorage
{
<ExtentSize>1250</ExtentSize>
<SqlIdExpression>$i(^DHCDATAINPUTERR)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DataInputErr_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DataInputErr_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DataInputErr_No">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DataInputErr_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDATAINPUTERR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataInputErr_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DataInputErr_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DataInputErr_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDataInputErrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCDATAINPUTERR)
	s oldI = +$g(^mdata("DHCDataInputErr"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCDATAINPUTERR = maxI
	s ^mdata("DHCDataInputErr") = maxI
}

Parameter EXTENTSIZE = 1250;

}
