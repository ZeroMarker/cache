/// 基础数据平台-临床知识库-检查部位字典
Class User.DHCPHExtPart Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHEP_RowId, SqlTableName = DHC_PHExtPart, StorageStrategy = SQLStorage ]
{

// ^DHCPHEPA

Parameter EXTENTSIZE = 250;

/// PHEP_Code
Property PHEPCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHEP_Code ];

/// PHEP_Desc
Property PHEPDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHEP_Desc ];

/// PHEP_AcitveFlag
Property PHEPAcitveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHEP_ActiveFlag ];

/// PHEP_SysFlag
Property PHEPSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHEP_SysFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHEPA(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHEPA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEP_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHEPA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEP_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="PHEP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEP_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHEPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
