/// ARC ItemPrice Italy(1420)
Class User.ARCItemPriceItaly Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemPriceItaly, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ITPChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItmMast Parent Reference
Relationship ITPParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemPriceItaly, Required, SqlFieldName = ITP_ParRef ];

/// Childsub
Property ITPChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ITP",0))}, SqlColumnNumber = 2, SqlFieldName = ITP_Childsub ];

/// Date From
Property ITPDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = ITP_DateFrom ];

/// Date To
Property ITPDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = ITP_DateTo ];

/// Des Ref Tariff
Property ITPTariffDR As ARCTariff [ SqlColumnNumber = 5, SqlFieldName = ITP_Tariff_DR ];

/// Price
Property ITPPrice As %Float [ Required, SqlColumnNumber = 6, SqlFieldName = ITP_Price ];

/// Account Code
Property ITPAccoutCode As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ITP_AccoutCode ];

/// Des Ref Currency
Property ITPCurrencyDR As CTCurrency [ SqlColumnNumber = 8, SqlFieldName = ITP_Currency_DR ];

/// Payor Share
Property ITPPayorShare As %Float [ SqlColumnNumber = 9, SqlFieldName = ITP_PayorShare ];

/// UrgentFee
Property ITPUrgentFee As %Float [ SqlColumnNumber = 10, SqlFieldName = ITP_UrgentFee ];

/// ITP_UrgentFeeRate
Property ITPUrgentFeeRate As %Float [ SqlColumnNumber = 11, SqlFieldName = ITP_UrgentFeeRate ];

/// Des Ref BedType
Property ITPBedTypeDR As PACBedType [ SqlColumnNumber = 12, SqlFieldName = ITP_BedType_DR ];

/// Des Ref InsType
Property ITPInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 13, SqlFieldName = ITP_InsType_DR ];

/// Hospital dr
Property ITPHospitalDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = ITP_HospitalDR ];

/// Episode Type
Property ITPEpisodeType As %String(DISPLAYLIST = ",Emergency,HealthPromotion,InPatient,OutPatient", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",E,H,I,O") [ SqlColumnNumber = 15, SqlFieldName = ITP_EpisodeType ];

/// ExcludeVAT
Property ITPExcludeVAT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = ITP_ExcludeVAT ];

/// Des Ref EpisBill
Property ITPEpisBillDR As ARCEpisodicBilling [ SqlColumnNumber = 17, SqlFieldName = ITP_EpisBill_DR ];

/// Des Ref Location
Property ITPLocationDR As CTLoc [ SqlColumnNumber = 18, SqlFieldName = ITP_Location_DR ];

/// Des Ref Speciality
Property ITPSpecialityDR As CTSpec [ SqlColumnNumber = 19, SqlFieldName = ITP_Speciality_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceItaly).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPriceItaly","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceItaly).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPriceItaly","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemPriceItaly).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPriceItaly","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemPriceItaly).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPriceItaly","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPriceItaly","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemPriceItaly).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemPriceItaly","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITP_AccoutCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITP_BedType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ITP_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITP_EpisBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ITP_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ITP_ExcludeVAT">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ITP_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ITP_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITP_Location_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ITP_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITP_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITP_Speciality_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ITP_Tariff_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITP_UrgentFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ITP_UrgentFeeRate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>ITP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTariff">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>ITP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITP_Tariff_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITP_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITP_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemPriceItalyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
