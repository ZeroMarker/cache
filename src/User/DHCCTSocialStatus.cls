Class User.DHCCTSocialStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdPrivate, SqlTableName = DHC_CTSocialStatus, StorageStrategy = StorageSQL ]
{

Index RowIDBasedIDKeyIndex On SSRowId [ IdKey, PrimaryKey, Unique ];

Property SSExcludeCheckFee As %String(TRUNCATE = 1) [ SqlFieldName = SS_ExcludeCheckFee ];

Property SSExcludeRegFee As %String(TRUNCATE = 1) [ SqlFieldName = SS_ExcludeRegFee ];

/// RowID
Property SSRowId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlFieldName = SS_RowId ];

Storage StorageSQL
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("SS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SS_ExcludeCheckFee">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="SS_ExcludeRegFee">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCTSocialStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
