Class User.DHCRBResourceTR Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = REST_RowId, SqlTableName = DHC_RBResourceTR, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RESTRowId [ IdKey, PrimaryKey, Unique ];

/// RES RowID
Property RESTRowId As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ InitialExpression = {$i(^RB("REST",0))}, Required, SqlFieldName = REST_RowId ];

/// REST_Resource_DR
Property RESTResourceDR As User.DHCRBResource [ SqlColumnNumber = 2, SqlFieldName = REST_Resource_DR ];

/// REST_TimeRange_DR
Property RESTTimeRangeDR As User.DHCTimeRange [ SqlColumnNumber = 3, SqlFieldName = REST_TimeRange_DR ];

/// REST_AddLoad  正号限额
Property RESTLoad As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = REST_Load ];

/// REST_AppLoad  预约限额
Property RESTAppLoad As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = REST_AppLoad ];

/// REST_AppStartNum  预约起始号
Property RESTAppStartNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = REST_AppStartNum ];

/// REST_AutoLoad  自助机挂号限额
Property RESTAutoLoad As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = REST_AutoLoad ];

/// REST_ExtLoad  外部挂号限额
Property RESTExtLoad As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = REST_ExtLoad ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="REST_AppLoad">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REST_AppStartNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REST_AutoLoad">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REST_ExtLoad">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REST_Load">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REST_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REST_TimeRange_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"REST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REST_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexResourceDr">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>REST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REST_Resource_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REST_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBResourceTRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
