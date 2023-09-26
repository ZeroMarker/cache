/// 基础数据平台-临床知识库-通用名字典
Class User.DHCPHExtGeneric Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEG_RowID, SqlTableName = DHC_PHExtGeneric, StorageStrategy = SQLStorage ]
{

// ^DHCPHEGEN

Property PHEGCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHEG_Code ];

Property PHEGDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHEG_Desc ];

Property PHEGAtc As %String [ SqlColumnNumber = 4, SqlFieldName = PHEG_Atc ];

Property PHEGOTC As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHEG_OTC ];

Property PHEGCatDr As User.SSGroup [ SqlColumnNumber = 6, SqlFieldName = PHEG_Cat_Dr ];

Property PHEGActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHEG_ActiveFlag ];

Property PHEGLibDr As User.DHCPHLibaryLabel [ SqlColumnNumber = 8, SqlFieldName = PHEG_Lib_Dr ];

Property PHEGSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PHEG_SysFlag ];

Property PHEGDataPool As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PHEG_DataPool ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHEGEN(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHEGENi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHEG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEG_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHEGENi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEG_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEG_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHEG_Atc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEG_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHEG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEG_DataPool">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHEG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEG_Lib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHEG_OTC">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHEG_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPHEGEN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEG_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHExtGenericS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
