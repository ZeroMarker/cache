/// 名称: User.PACPatientSource
/// 描述: 病人管理-患者来源
/// 编写者：钟荣枫
/// 编写日期: 2020-04-03
Class User.PACPatientSource Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PAC_PatientSource, StorageStrategy = SQLStorage ]
{

/// 代码
Property PSCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PS_Code ];

/// 描述
Property PSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PS_Desc ];

/// 开始日期
Property PSDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PS_DateFrom ];

/// 结束日期
Property PSDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PS_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("Source",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PS_RowId</SqlRowIdName>
<StreamLocation>^User.PACPatientSourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
