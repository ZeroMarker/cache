/// Order Categ ReceiveLocation(1279)
Class User.OECOrdCatRecLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OEC_OrdCatRecLoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RLChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_OrderCategory Parent Reference
Relationship RLParRef As OECOrderCategory [ Cardinality = parent, Inverse = ChildOECOrdCatRecLoc, Required, SqlFieldName = RL_ParRef ];

/// Childsub
Property RLChildsub As %Float [ InitialExpression = {$i(^OEC("ORCAT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RL",0))}, SqlColumnNumber = 2, SqlFieldName = RL_Childsub ];

/// Receive Location_DR
Property RLRecLocDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = RL_RecLoc_DR ];

/// OrderLocation_DR
Property RLOrdLocDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = RL_OrdLoc_DR ];

/// Function
Property RLFunction As %String(DISPLAYLIST = ",Execute,Cashier,Processing", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Execute,Cashier,Processing") [ Required, SqlColumnNumber = 5, SqlFieldName = RL_Function ];

/// DefaultFlag
Property RLDefaultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RL_DefaultFlag ];

/// Time From
Property RLTimeFrom As %Time [ SqlColumnNumber = 7, SqlFieldName = RL_TimeFrom ];

/// Time To
Property RLTimeTo As %Time [ SqlColumnNumber = 8, SqlFieldName = RL_TimeTo ];

/// CT Hospital DR
Property RLCTHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = RL_CTHospitalDR ];

/// Date From
Property RLDateFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = RL_DateFrom ];

/// Date To
Property RLDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = RL_DateTo ];

/// Des Ref OrderPriority
Property RLOrderPriorityDR As OECPriority [ SqlColumnNumber = 12, SqlFieldName = RL_OrderPriority_DR ];

/// DaysOfTheWeek
Property RLDaysOfTheWeek As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = RL_DaysOfTheWeek ];

/// zrf 2021-8-19  就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
Property RLClinicType As %String(MAXLEN = "") [ SqlColumnNumber = 14, SqlFieldName = RL_ClinicType ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECOrdCatRecLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatRecLoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECOrdCatRecLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatRecLoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECOrdCatRecLoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatRecLoc","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECOrdCatRecLoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatRecLoc","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatRecLoc","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECOrdCatRecLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatRecLoc","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RL_CTHospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RL_ClinicType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RL_DaysOfTheWeek">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RL_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RL_Function">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RL_OrdLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RL_OrderPriority_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RL_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RL_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RL_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_OrderCategory.ORCAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_OrderCategory.ORCAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RL_RowId</SqlRowIdName>
<StreamLocation>^User.OECOrdCatRecLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
