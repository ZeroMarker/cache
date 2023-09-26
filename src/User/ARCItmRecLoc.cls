/// ARC Item Receiving Loc  (ARCRL,674)
Class User.ARCItmRecLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ARC_ItmRecLoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (ARCRLARCIMSub, ARCRLSubscript) [ IdKey, PrimaryKey, Unique ];

/// Subscript of ARCIM
Property ARCRLARCIMSub As %Float [ InitialExpression = {$p($g(da115),"||")}, Required, SqlColumnNumber = 2, SqlFieldName = ARCRL_ARCIMSub ];

/// Subscript of ARCRL
Property ARCRLSubscript As %Float [ InitialExpression = {$i(^ARCRL(+%d(2),0))}, Required, SqlColumnNumber = 3, SqlFieldName = ARCRL_Subscript ];

/// Ordering Location
Property ARCRLOrdLocDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = ARCRL_OrdLoc_DR ];

/// Receiving Location
Property ARCRLRecLocDR As CTLoc [ Required, SqlColumnNumber = 5, SqlFieldName = ARCRL_RecLoc_DR ];

/// Des Ref to ARCIM
Property ARCRLARCIMDR As ARCItmMast [ SqlColumnNumber = 6, SqlComputeCode = { s {ARCRL_ARCIM_DR}=$$CO06^at674({ARCRL_ARCIMSub})
}, SqlComputed, SqlFieldName = ARCRL_ARCIM_DR, Transient ];

/// Function
Property ARCRLFunction As %String(DISPLAYLIST = ",Execute,Cashier,Processing", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Execute,Cashier,Processing") [ SqlColumnNumber = 7, SqlFieldName = ARCRL_Function ];

/// Default Flag
Property ARCRLDefaultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ARCRL_DefaultFlag ];

/// Time From
Property ARCRLTimeFrom As %Time [ SqlColumnNumber = 9, SqlFieldName = ARCRL_TimeFrom ];

/// Time To
Property ARCRLTimeTo As %Time [ SqlColumnNumber = 10, SqlFieldName = ARCRL_TimeTo ];

/// CT Hospital DR
Property ARCRLCTHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = ARCRL_CTHospitalDR ];

/// Date From
Property ARCRLDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = ARCRL_DateFrom ];

/// Date To
Property ARCRLDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = ARCRL_DateTo ];

/// Des Ref OrderPriority
Property ARCRLOrderPriorityDR As OECPriority [ SqlColumnNumber = 14, SqlFieldName = ARCRL_OrderPriority_DR ];

/// DaysOfTheWeek
Property ARCRLDaysOfTheWeek As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ARCRL_DaysOfTheWeek ];

/// zrf 2021-8-19  就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
Property ARCRLClinicType As %String [ SqlColumnNumber = 16, SqlFieldName = ARCRL_ClinicType ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItmRecLoc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmRecLoc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItmRecLoc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmRecLoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItmRecLoc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmRecLoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItmRecLoc).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmRecLoc","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItmRecLoc).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmRecLoc","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmRecLoc","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterARCRL">
<Data name="ARCRL_CTHospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARCRL_ClinicType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARCRL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARCRL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARCRL_DaysOfTheWeek">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARCRL_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCRL_Function">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCRL_OrdLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCRL_OrderPriority_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARCRL_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARCRL_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARCRL_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ARCRL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARCRL_ARCIMSub</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARCRL_Subscript</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ARCRL_ARCIMSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{ARCRL_Subscript}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdLocDR">
<Condition>{ARCRL_OrdLoc_DR}'=""</Condition>
<Global>^ARCRL</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARCRL_ARCIMSub</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARCRL_Subscript</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARCRL_ARCIMSub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCRL_OrdLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCRL_Subscript}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCRL_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItmRecLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
