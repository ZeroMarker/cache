/// ygcg
Class User.DHCSpecModelList Extends (%Persistent, User.Abstract) [ SqlRowIdName = SMList_RowId, SqlTableName = DHC_SpecModelList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SMListChildSub [ IdKey, PrimaryKey, Unique ];

Relationship SMListMPCLogParRef As User.DHCMatPurCatalog [ Cardinality = parent, Inverse = ChildDHCSpecModelList, Required, SqlFieldName = SMList_MPCLog_ParRef ];

Property SMListChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCMatPurCataLog($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"SMList",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SMList_ChildSub ];

/// 产品ID
Property SMListGoodsId As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SMList_GoodsId ];

/// 规格
Property SMListOutLookc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SMList_OutLookc ];

/// 型号
Property SMListGoodsType As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SMList_GoodsType ];

/// 子码ID
Property SMListSubCodeId As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SMList_SubCodeId ];

Property SMListINCIDR As User.INCItm [ SqlColumnNumber = 7, SqlFieldName = SMList_INCI_DR ];

/// 子码ID
Property SMListHospitalId As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SMList_HospitalId ];

/// 最小计量单位
Property SMListMinUnitMeasure As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SMList_MinUnitMeasure ];

/// 最小销售包装单位
Property SMListMinUnitSale As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = SMList_MinUnitSale ];

/// 最小包装转换比
Property SMListMinUnitPackage As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = SMList_MinUnitPackage ];

/// 最小计量单位价
Property SMListMinUnitPrice As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = SMList_MinUnitPrice ];

/// 采购限价
Property SMListPrice As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = SMList_Price ];

/// 议价
Property SMListPurchasePrice As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = SMList_PurchasePrice ];

/// 投 标 企 业 编 号
Property SMListCompanyIdTb As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = SMList_CompanyIdTb ];

/// 投标企业
Property SMListCompanyNameTb As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = SMList_CompanyNameTb ];

/// 医疗器械唯一标识（UDI）-DI 码
Property SMListDICode As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = SMList_DICode ];

/// 添加日期
Property SMListAddDate As %Library.Date [ SqlColumnNumber = 18, SqlFieldName = SMList_AddDate ];

/// 添加时间
Property SMListAddTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = SMList_AddTime ];

/// 变更日期
Property SMListLastUpdateDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = SMList_LastUpdateDate ];

/// 变更时间
Property SMListLastUpdateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = SMList_LastUpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SMList_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMList_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMList_CompanyIdTb">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMList_CompanyNameTb">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMList_DICode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMList_GoodsId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMList_GoodsType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMList_HospitalId">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMList_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMList_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMList_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMList_MinUnitMeasure">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMList_MinUnitPackage">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMList_MinUnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMList_MinUnitSale">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMList_OutLookc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMList_Price">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMList_PurchasePrice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMList_SubCodeId">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMatPurCataLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MatPurCatalog.MatPurCatalog_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SMList_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_MatPurCatalog.MatPurCatalog_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SMList"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMList_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCMatPurCataLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MatPurCatalog.MatPurCatalog_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SMList_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMList_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_MatPurCatalog.MatPurCatalog_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SMList_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubCode">
<Global>^DHCMatPurCataLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MatPurCatalog.MatPurCatalog_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SMList_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SubCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMList_SubCodeId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_MatPurCatalog.MatPurCatalog_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SMList_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SMList_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSpecModelListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
