/// BLC DRG Tariff(1472)
Class User.BLCDRGTariff Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_DRG_Tariff, StorageStrategy = SQLStorage ]
{

/// Des Ref DRG
Property TARDRGDR As MRCDRGCodes [ SqlColumnNumber = 2, SqlFieldName = TAR_DRG_DR ];

/// Date From
Property TARDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = TAR_DateFrom ];

/// Des Ref DRG Type
Property TARDRGTypeDR As MRCDRGType [ SqlColumnNumber = 4, SqlFieldName = TAR_DRGType_DR ];

/// Kind
Property TARKind As %String(DISPLAYLIST = ",Surgery,Medicine,Other", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",S,M,O") [ SqlColumnNumber = 5, SqlFieldName = TAR_Kind ];

/// Normal Tariff
Property TARNormalTariff As %Float [ SqlColumnNumber = 6, SqlFieldName = TAR_NormalTariff ];

/// One Day Tariff
Property TAROneDayTariff As %Float [ SqlColumnNumber = 7, SqlFieldName = TAR_OneDayTariff ];

/// Day Hospital Tariff
Property TARDayHospitalTariff As %Float [ SqlColumnNumber = 8, SqlFieldName = TAR_DayHospitalTariff ];

/// Limit Day
Property TARLimitDay As %Float [ SqlColumnNumber = 9, SqlFieldName = TAR_LimitDay ];

/// Extra Tariff Per Day
Property TARExtraTariffPerDay As %Float [ SqlColumnNumber = 10, SqlFieldName = TAR_ExtraTariffPerDay ];

/// Reabilitation Tariff
Property TARReabilitationTariff As %Float [ SqlColumnNumber = 11, SqlFieldName = TAR_ReabilitationTariff ];

/// Reabilitaion Limit Day
Property TARReabilitaionLimitDay As %Float [ SqlColumnNumber = 12, SqlFieldName = TAR_ReabilitaionLimitDay ];

/// Reabilitaion Extra Tariff Per Day
Property TARReabilitaionExtraTariffPerDa As %Float [ SqlColumnNumber = 13, SqlFieldName = TAR_ReabilitaionExtraTariffPerDay ];

/// Des Ref Class1
Property TARClass1DR As BLCDRGClass1 [ SqlColumnNumber = 14, SqlFieldName = TAR_Class1_DR ];

/// Des Ref Class2
Property TARClass2DR As BLCDRGClass2 [ SqlColumnNumber = 15, SqlFieldName = TAR_Class2_DR ];

/// Des Ref Class3
Property TARClass3DR As BLCDRGClass3 [ SqlColumnNumber = 16, SqlFieldName = TAR_Class3_DR ];

/// Med Target
Property TARMedTarget As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = TAR_MedTarget ];

/// SameDay/OneDay
Property TARSameDayOneDay As %String(DISPLAYLIST = ",SameDay,OneDay", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",S,O") [ SqlColumnNumber = 18, SqlFieldName = TAR_SameDayOneDay ];

/// Des Ref Version
Property TARVersionDR As MRCDRGVersion [ SqlColumnNumber = 19, SqlFieldName = TAR_Version_DR ];

/// Des Ref DRGCategory
Property TARDRGCategoryDR As MRCDRGCategory [ SqlColumnNumber = 20, SqlFieldName = TAR_DRGCategory_DR ];

/// Des Ref CostWeightEdition
Property TARCostWeightEditionDR As MRCCostWeightEdition [ SqlColumnNumber = 21, SqlFieldName = TAR_CostWeightEdition_DR ];

/// Des Ref HospDRGCateg
Property TARHospDRGCategDR As CTHospitalDRGCategory [ SqlColumnNumber = 22, SqlFieldName = TAR_HospDRGCateg_DR ];

/// Extra High Trim Point
Property TARExtraHighTrimPoint As %Float [ SqlColumnNumber = 23, SqlFieldName = TAR_ExtraHighTrimPoint ];

/// HITH Outlier
Property TARHITHOutlier As %Float [ SqlColumnNumber = 24, SqlFieldName = TAR_HITH_Outlier ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCDRGTariff).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCDRGTariff","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCDRGTariff).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCDRGTariff","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCDRGTariff).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCDRGTariff","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCDRGTariff).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCDRGTariff","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCDRGTariff).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCDRGTariff","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BLC("DRGTAR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TAR_Class1_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TAR_Class2_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TAR_Class3_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TAR_CostWeightEdition_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TAR_DRGCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TAR_DRGType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TAR_DRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TAR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TAR_DayHospitalTariff">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TAR_ExtraHighTrimPoint">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TAR_ExtraTariffPerDay">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TAR_HITH_Outlier">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="TAR_HospDRGCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TAR_Kind">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TAR_LimitDay">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TAR_MedTarget">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TAR_NormalTariff">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TAR_OneDayTariff">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TAR_ReabilitaionExtraTariffPerDay">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TAR_ReabilitaionLimitDay">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TAR_ReabilitationTariff">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TAR_SameDayOneDay">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TAR_Version_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGTAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TAR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDRGDate">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGTAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TAR_DRG_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TAR_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TAR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TAR_RowId</SqlRowIdName>
<StreamLocation>^User.BLCDRGTariffS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
