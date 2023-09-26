Class User.DHCBillTabs Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BT_RowID, SqlTableName = DHC_BillTabs, StorageStrategy = SQLStorage ]
{

/// BT_TabID
Property BTTabID As %Library.String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = BT_TabID ];

/// BT_TabTitle
Property BTTabTitle As %Library.String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = BT_TabTitle ];

/// BT_TabUrl
Property BTTabUrl As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BT_TabUrl ];

/// BT_ActiveFlag
Property BTActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 5, SqlFieldName = BT_ActiveFlag ];

/// BT_BusinessType 业务类型 (OPD:门诊日报, OPC:门诊日报汇总, IPD:住院日报, IPC:住院日报汇总, IPB:住院收费, BOA:第三方对账平台)
Property BTBusinessType As %Library.String(TRUNCATE = 1) [ Required, SqlColumnNumber = 6, SqlFieldName = BT_BusinessType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBILLTABS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BT_BusinessType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BT_TabID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BT_TabTitle">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BT_TabUrl">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCBILLTABS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTabID">
<Global>^DHCBILLTABSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TABID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BT_TabID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCBILLTABSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BT_BusinessType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillTabsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
