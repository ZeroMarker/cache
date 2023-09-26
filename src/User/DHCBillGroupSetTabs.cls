Class User.DHCBillGroupSetTabs Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GT_RowID, SqlTableName = DHC_BillGroupSetTabs, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GT_GroupSet_DR
Property GTGroupSetDR As User.DHCOPGroupSettings [ SqlColumnNumber = 2, SqlFieldName = GT_GroupSet_DR ];

/// GT_Tabs_DR
Property GTTabsDR As User.DHCBillTabs [ SqlColumnNumber = 3, SqlFieldName = GT_Tabs_DR ];

/// GT_DefaultFlag
Property GTDefaultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GT_DefaultFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBILLGROUPSETTABS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GT_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GT_GroupSet_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GT_Tabs_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCBILLGROUPSETTABS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroupSetDR">
<Global>^DHCBILLGROUPSETTABSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GROUPSETDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GT_GroupSet_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroupTabs">
<Global>^DHCBILLGROUPSETTABSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GROUPTABS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GT_GroupSet_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GT_Tabs_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillGroupSetTabsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
