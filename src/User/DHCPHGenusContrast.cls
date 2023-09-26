/// 名称：菌属对照表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-10 
Class User.DHCPHGenusContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHG_RowId, SqlTableName = DHC_PHGenusContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHGENUSCON

Property PHGGenusCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHG_GenusCode ];

Property PHGGenusDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHG_GenusDesc ];

Property PHGHisGenusCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHG_HisGenusCode ];

Property PHGHisGenusDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHG_HisGenusDesc ];

Property PHGHospDr As %String [ SqlColumnNumber = 6, SqlFieldName = PHG_Hosp_Dr ];

Property PHGSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PHG_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHGENUSCON(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHGENUSCON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHG_GenusCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHG_HisGenusCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="HisCodeIndex">
<Global>^DHCPHGENUSCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHG_HisGenusCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHG_GenusCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHG_GenusDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHG_HisGenusCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHG_HisGenusDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHG_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHG_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHGENUSCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHGenusContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
