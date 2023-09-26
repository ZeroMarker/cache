/// 描述: 知识库关键表字典表
/// 编写者：谷雪萍
/// 编写日期: 2017-03-23
Class User.DHCPHKeyWord Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHKW_RowId, SqlTableName = DHC_PHKeyWord, StorageStrategy = SQLStorage ]
{

// ^DHCPHKW

Property PHKWCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHKW_Code ];

Property PHKWDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHKW_Desc ];

Property PHKWActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHKW_ActiveFlag ];

Property PHKWSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHKW_SysFlag ];

Property PHKWTypeFlag As %String(DISPLAYLIST = ",症状体征,治疗手术", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 6, SqlFieldName = PHKW_TypeFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHKW(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHKWi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHKW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHKW_TypeFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({PHKW_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHKW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="PHKW_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHKW_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHKW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHKW_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHKW_TypeFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHKW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHKW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHKW_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHKWi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHKW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHKW_TypeFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({PHKW_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHKW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="TypeIndex">
<Global>^DHCPHKWi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHKW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHKW_TypeFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHKW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHKW_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHKeyWordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
