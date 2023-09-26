/// 名称：细菌字典表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-10 
Class User.DHCPHBTOrganism Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = BTO_RowId, SqlTableName = DHC_PHBTOrganism, StorageStrategy = SQLStorage ]
{

// ^DHCPHBTORG

Property BTOCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BTO_Code ];

Property BTODesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BTO_Desc ];

Property BTOWhoNet As %String [ SqlColumnNumber = 4, SqlFieldName = BTO_WhoNet ];

Property BTOActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BTO_ActiveFlag ];

Property BTOSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BTO_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHBTORG(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHBTORGi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BTO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BTO_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BTO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHBTORGi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BTO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({BTO_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BTO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="BTO_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BTO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BTO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BTO_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BTO_WhoNet">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHBTORG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BTO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BTO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="WhonetIndex">
<Global>^DHCPHBTORGi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BTO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Whonet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BTO_WhoNet}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BTO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BTO_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHBTOrganismS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
