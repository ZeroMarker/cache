Class User.DHCEmConsPreCon Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsPreCon, StorageStrategy = SQLStorage ]
{

/// 工作流Dr EC_WF_Dr
Property ECWFDr As User.DHCEmConsWorkFlow [ SqlColumnNumber = 2, SqlFieldName = EC_WF_Dr ];

/// 表达式 EC_Fun_Dr	
Property ECFunDr As User.DHCEmConsFunction [ SqlColumnNumber = 3, SqlFieldName = EC_Fun_Dr ];

/// 参数 EC_Params
Property ECParams As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EC_Params ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMCONPC)</SqlIdExpression>
<SQLMap name="IndexFunWorkFlow">
<Global>^DHCEMCONPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FunWorkFlow"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Fun_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_WF_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWorkFlow">
<Global>^DHCEMCONPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WorkFlow"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_WF_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="EC_Fun_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_Params">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_WF_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMCONPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsPreConS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
