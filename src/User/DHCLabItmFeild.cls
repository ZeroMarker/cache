/// 基础数据平台-临床知识库-检验条目字典
Class User.DHCLabItmFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHLF_RowId, SqlTableName = DHC_LabItmFeild, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

// ^DHCLABIF

Relationship ChildDHCLabItmResult As User.DHCLabItmResult [ Cardinality = children, Inverse = PHLFIParRefDr ];

Relationship ChildDHCLabItmVal As User.DHCLabItmVal [ Cardinality = children, Inverse = PHLFIParRefDr ];

Property PHLFCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHLF_Code ];

Property PHLFDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PHLF_Desc ];

Property PHLFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHLF_ActiveFlag ];

Property PHLFSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHLF_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLABIF(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHLF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLF_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCLABIF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PHLF_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHLF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCLABIF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHLF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHLF_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCLABIF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHLF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHLF_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHLF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLabItmFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
