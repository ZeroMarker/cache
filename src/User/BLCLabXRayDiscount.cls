/// BLC Lab/X Ray Discount
Class User.BLCLabXRayDiscount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_LabXRayDiscount, StorageStrategy = SQLStorage ]
{

/// Des Ref BillSubGrp_DR
Property LABXBillSubGrpDR As ARCBillSub [ SqlColumnNumber = 7, SqlFieldName = LABX_BillSubGrp_DR ];

/// Date From
Property LABXDateFrom As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = LABX_DateFrom ];

/// Date To
Property LABXDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = LABX_DateTo ];

/// EpisodeType
Property LABXEpisodeType As %String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,HealthPromotion", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",I,O,E,H") [ SqlColumnNumber = 9, SqlFieldName = LABX_EpisodeType ];

/// From X test
Property LABXFromXtest As %Float [ SqlColumnNumber = 4, SqlFieldName = LABX_FromXtest ];

/// Des Ref HospClass
Property LABXHospClassDR As BLCHospitalClass [ SqlColumnNumber = 10, SqlFieldName = LABX_HospClass_DR ];

/// Des Ref InsType_DR
Property LABXInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 8, SqlFieldName = LABX_InsType_DR ];

/// % Discount
Property LABXPerc As %Float [ SqlColumnNumber = 6, SqlFieldName = LABX_Perc ];

/// To X test
Property LABXToXtest As %Float [ SqlColumnNumber = 5, SqlFieldName = LABX_ToXtest ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCLabXRayDiscount).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLabXRayDiscount","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCLabXRayDiscount).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLabXRayDiscount","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCLabXRayDiscount).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLabXRayDiscount","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCLabXRayDiscount).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLabXRayDiscount","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCLabXRayDiscount).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLabXRayDiscount","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="LABXBillSubGrpDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LABXDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LABXDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LABXEpisodeType">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="LABXFromXtest">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LABXHospClassDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LABXInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LABXPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LABXToXtest">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("LABX",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LABX_BillSubGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LABX_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LABX_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LABX_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LABX_FromXtest">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LABX_HospClass_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LABX_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LABX_Perc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LABX_ToXtest">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LABX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LABX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LABX_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LABX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LABX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$p({LABX_BillSubGrp_DR},"||")</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LABX_InsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LABX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeBillGrp">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>LABX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LABX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LABX_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LABX_BillSubGrp_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LABX_DateTo}+1</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LABX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LABX_RowId</SqlRowIdName>
<StreamLocation>^User.BLCLabXRayDiscountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
