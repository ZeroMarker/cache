/// 站点项目组合表
Class User.DHCPEStationOrder Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STORD_RowId, SqlTableName = DHC_PE_StationOrder, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEStationOrder";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On STORDChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPEStationOrderLoc As User.DHCPEStationOrderLoc [ Cardinality = children, Inverse = STORDLParRef ];

/// DHC_PE_Station Parent Reference
Relationship STORDParRef As User.DHCPEStation [ Cardinality = parent, Inverse = ChildDHCPEStationOrder, Required, SqlFieldName = STORD_ParRef ];

/// STORD_ChildSub
Property STORDChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ InitialExpression = {$i(^DHCPEST($p(%d(0),$c(1),1),"O",0))}, Required, SqlColumnNumber = 3, SqlFieldName = STORD_ChildSub ];

/// 医嘱项 指向ARC_ItmMast
Property STORDARCIMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = STORD_ARCIM_DR ];

/// 【作废】就餐标志（餐前、餐后、不限）
Property STORDDiet As %Library.String(DISPLAYLIST = ",Preprandial,Postprandial,NoLimited", MAXLEN = 12, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",PRE,POST,N") [ SqlColumnNumber = 5, SqlFieldName = STORD_Diet ];

/// 【作废】医嘱套
Property STORDARCOSDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = STORD_ARCOS_DR ];

/// 【作废】报告格式（Normal普通、Cat多层、Lis检验、Ris检查）
Property STORDReportFormat As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = STORD_ReportFormat ];

/// 【作废】注意事项
Property STORDNotice As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = STORD_Notice ];

/// 【作废】自动回传结果
Property STORDAutoReturn As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = STORD_AutoReturn ];

/// 【作废】医生顺序
Property STORDSort As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = STORD_Sort ];

/// / 医嘱商品名
Property STORDSaleDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = STORD_Sale_Desc ];

/// 作废标记
Property STORDNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = STORD_NoActive ];

/// 更新日期
Property STORDUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = STORD_UpdateDate ];

/// 更新时间
Property STORDUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = STORD_UpdateTime ];

/// 更信人 指向SS_User
Property STORDUpdateUserDR As %String [ SqlColumnNumber = 15, SqlFieldName = STORD_UpdateUserDR ];

/// 【新加】站点（在项目更改站点时用，如果此字段有值，以此字段为准）
Property STORDStationDR As User.DHCPEStation [ SqlColumnNumber = 16, SqlFieldName = STORD_StationDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPESTORD">
<Data name="STORD_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STORD_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STORD_AutoReturn">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STORD_Diet">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STORD_NoActive">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STORD_Notice">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STORD_ReportFormat">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STORD_Sale_Desc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STORD_Sort">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STORD_StationDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="STORD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STORD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="STORD_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>STORD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STORD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^DHCPEST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>STORD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STORD_ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STORD_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{STORD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^DHCPEST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>STORD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STORD_ARCOS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STORD_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{STORD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEStationOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
