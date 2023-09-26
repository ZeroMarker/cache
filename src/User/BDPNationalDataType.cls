/// Function:国家标准数据源类别码表 
/// Creator: sunfengchao
/// CreateDate:2016-4-7
Class User.BDPNationalDataType Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = BDP_StandardRowId, SqlTableName = BDP_NationalDataType, StorageStrategy = SQLStorage ]
{

/// 代码
Property BDPStandardCode As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = BDP_StandardCode ];

/// 描述
Property BDPStandardDesc As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = BDP_StandardDesc ];

/// 拼音码
Property BDPStandardSearchCode As %String [ SqlColumnNumber = 4, SqlFieldName = BDP_StandardSearchCode ];

/// 国家标准编码源值域代码 
Property BDPStandardDomainCode As %String [ SqlColumnNumber = 5, SqlFieldName = BDP_StandardDomainCode ];

/// 国家标准编码源值域名称
Property BDPStandardDomainDesc As %String [ SqlColumnNumber = 6, SqlFieldName = BDP_StandardDomainDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BDPDOMAINTYPE(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^BDPDOMAINTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDP_Standar</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BDP_StandardCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDP_StandardRowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^BDPDOMAINTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDP_Standar</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BDP_StandardDesc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDP_StandardRowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDomainCode">
<Global>^BDPDOMAINTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Field>{BDP_Standa}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DomainCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BDP_StandardDomainCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDP_StandardRowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSearchCode">
<Global>^BDPDOMAINTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>L4</Expression>
<Field>BDP_Standar</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SearchCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BDP_StandardSearchCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BDP_StandardRowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BDP_StandardCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDP_StandardDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDP_StandardDomainCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDP_StandardDomainDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDP_StandardSearchCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BDPDOMAINTYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BDP_Standar</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BDP_StandardRowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>BDP_StandardRowId</SqlRowIdName>
<StreamLocation>^User.BDPNationalDataTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
