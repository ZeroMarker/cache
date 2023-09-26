/// Local Tariff Price
Class User.DHCTarItemPrice Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TP_RowId, SqlTableName = DHC_TarItemPrice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On TPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_TarItem Parent Reference
Relationship TPTARIParRef As User.DHCTarItem [ Cardinality = parent, Inverse = ChildDHCTarItemPrice, Required, SqlFieldName = TP_TARI_ParRef ];

/// TP_ChildSub
Property TPChildSub As %Library.Float [ InitialExpression = {$i(^DHCTARI($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"P",0))}, Required, SqlColumnNumber = 2, SqlFieldName = TP_ChildSub ];

// Property TPChildSub As %Library.Float [ InitialExpression = {$i(^DHCTARI($p(%d(0),$c(1),1),"P",0))}, Required, SqlColumnNumber = 2, SqlFieldName = TP_ChildSub ];

/// TP_StartDate
Property TPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = TP_StartDate ];

/// TP_EndDate
Property TPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = TP_EndDate ];

/// TP_Price
Property TPPrice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = TP_Price ];

/// TP_LimitedPrice
Property TPLimitedPrice As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = TP_LimitedPrice ];

/// TP_PayorRate
Property TPPayorRate As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = TP_PayorRate ];

/// TP_UpdateUser
Property TPUpdateUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = TP_UpdateUser ];

/// TP_UpdateDate
Property TPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = TP_UpdateDate ];

/// TP_UpdateTime
Property TPUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = TP_UpdateTime ];

/// TP_AdjustNo
Property TPAdjustNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TP_AdjustNo ];

/// TP_DiscRate
Property TPDiscRate As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = TP_DiscRate ];

/// TP_PatInsType
Property TPPatInsType As User.PACAdmReason [ SqlColumnNumber = 13, SqlFieldName = TP_PatInsType ];

/// TP_AlterPrice1
Property TPAlterPrice1 As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = TP_AlterPrice1 ];

/// TP_AlterPrice2
Property TPAlterPrice2 As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = TP_AlterPrice2 ];

/// TP_Hospital_DR
Property TPHospitalDR As User.CTHospital [ SqlColumnNumber = 16, SqlFieldName = TP_Hospital_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="INDEXAdjustNo">
<Global>^DHCTARIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_TarItem.TARI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADJ"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{TP_AdjustNo}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TP_TARI_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXItemTypeStt">
<Global>^DHCTARIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_TarItem.TARI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"TARI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_TarItem.TARI_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TP_PatInsType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TP_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXStartDate">
<Global>^DHCTARIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_TarItem.TARI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"STT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{TP_StartDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TP_TARI_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXTypeItemStt">
<Global>^DHCTARIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_TarItem.TARI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{TP_PatInsType}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TP_TARI_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TP_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^DHCTARIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_TarItem.TARI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>TP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HospInsType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_TarItem.TARI_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TP_PatInsType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TP_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TP_StartDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="TarPriceMaster">
<Data name="TP_AdjustNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TP_AlterPrice1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TP_AlterPrice2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TP_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TP_DiscRate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TP_LimitedPrice">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TP_PatInsType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TP_PayorRate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TP_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TP_TARI_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TP_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCTARI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_TarItem.TARI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_TarItem.TARI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexupdate">
<Global>^DHCTARIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_TarItem.TARI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Update"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TP_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_TarItem.TARI_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCTarItemPriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
