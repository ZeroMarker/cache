/// 基础数据平台-临床知识库-通用名检验属性表
Class User.DHCLisGenPro Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = LGP_RowId, SqlTableName = DHC_LisGenPro, StorageStrategy = SQLStorage ]
{

// ^DHCLISGP

Property LGPGenDr As User.DHCPHExtGeneric [ SqlColumnNumber = 2, SqlFieldName = LGP_Gen_Dr ];

Property LGPStCode As %String [ SqlColumnNumber = 3, SqlFieldName = LGP_StCode ];

Property LGPCatDr As User.DHCPHLibCat [ SqlColumnNumber = 4, SqlFieldName = LGP_Cat_Dr ];

Property LGPSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LGP_SysFlag ];

Property LGPOTFlag As %String(DISPLAYLIST = ",TS,TC", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",TS,TC") [ SqlColumnNumber = 6, SqlFieldName = LGP_OTFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLISGP(0))</SqlIdExpression>
<SQLMap name="IndexCat">
<Global>^DHCLISGPi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LGP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LGP_Cat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LGP_Gen_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LGP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGen">
<Global>^DHCLISGPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LGP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({LGP_Gen_Dr})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LGP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStCode">
<Global>^DHCLISGPi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LGP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({LGP_StCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LGP_Gen_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LGP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LGP_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LGP_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LGP_OTFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LGP_StCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LGP_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCLISGP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LGP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LGP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LGP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLisGenProS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
