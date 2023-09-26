/// 基础数据平台-临床知识库-用法对照表
Class User.DHCPHInstContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHICT_RowId, SqlTableName = DHC_PHInstContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHINSTCON

Property PHICTInstCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHICT_InstCode ];

Property PHICTInstDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHICT_InstDesc ];

Property PHICTHisInstCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHICT_HisInstCode ];

Property PHICTHisInstDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHICT_HisInstDesc ];

Property PHICTHospDr As %String [ SqlColumnNumber = 6, SqlFieldName = PHICT_Hosp_Dr ];

Property PHICTSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHICT_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHINSTCON(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHINSTCON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHICT_InstCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHICT_HisInstCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHICT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisCode">
<Global>^DHCPHINSTCON</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHICT_HisInstCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHICT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHICT_HisInstCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHICT_HisInstDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHICT_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHICT_InstCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHICT_InstDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHICT_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHINSTCON</Global>
<Subscript name="1">
<Expression>{PHICT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHICT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHInstContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
