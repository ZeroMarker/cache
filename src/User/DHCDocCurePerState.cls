Class User.DHCDocCurePerState Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_DocCurePerState, StorageStrategy = SQLStorage ]
{

Property DDCPSCode As %String [ SqlColumnNumber = 2, SqlFieldName = DDCPS_Code ];

Property DDCPSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = DDCPS_Desc ];

Property DDCPSPriority As %String [ SqlColumnNumber = 4, SqlFieldName = DDCPS_Priority ];

Property DDCPSShowName As %String [ SqlColumnNumber = 5, SqlFieldName = DDCPS_ShowName ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocCurePSi(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="DDCPS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCPS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCPS_Priority">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCPS_ShowName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDocCurePS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DDCPS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DDCPS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocCurePSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DDCPS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCPS_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCPS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDCPS_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCurePerStateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
