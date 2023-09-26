/// Order Link to Tariff Item
Class User.DHCOrderLinkTar Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OLT_RowId, SqlTableName = DHC_OrderLinkTar, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Order Item Reference
Property OLTARCIMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = OLT_ARCIM_DR ];

/// Tariff Item Reference
Property OLTTariffDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = OLT_Tariff_DR ];

/// Qty Order to Tariff Item
Property OLTQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = OLT_Qty ];

/// Start Date for Link to Tariff Item
Property OLTStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = OLT_StartDate ];

/// End Date Linked to Tariff Item
Property OLTEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OLT_EndDate ];

/// ARCIM Instruction Reference
Property OLTInstDR As User.PHCInstruc [ SqlColumnNumber = 7, SqlFieldName = OLT_Inst_DR ];

/// Order Item Priority Reference
Property OLTPriorityDR As User.OECPriority [ SqlColumnNumber = 8, SqlFieldName = OLT_Priority_DR ];

/// OLT_BascPriceFlag 是否打折标志 add@20170222  chenying  节点位置 8
Property OLTBascPriceFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = OLT_BascPriceFlag ];

/// OLT_BillOnceFlag 多部位计价一次 add@20170304 chenying  节点位置 9
Property OLTBillOnceFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = OLT_BillOnceFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCOLT(0))</SqlIdExpression>
<SQLMap name="ARCIMTariffMaster">
<Data name="OLT_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OLT_BascPriceFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OLT_BillOnceFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OLT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OLT_Inst_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OLT_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OLT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OLT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OLT_Tariff_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCOLT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OLT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXARCIM">
<Global>^DHCOLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OLT_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OLT_Inst_DR}_"Z"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OLT_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{OLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXARCToTAR">
<Global>^DHCOLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARTTA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OLT_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OLT_Tariff_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OLT_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{OLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXTariffItem">
<Global>^DHCOLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OLT_Tariff_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OLT_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOrderLinkTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
