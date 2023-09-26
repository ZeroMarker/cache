/// BLC Bill Number Setup(1652)
Class User.BLCBillNumberSetup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_BillNumberSetup, StorageStrategy = SQLStorage ]
{

/// Des Ref Hospital
Property NUMHospitalDR As CTHospital [ SqlColumnNumber = 2, SqlFieldName = NUM_Hospital_DR ];

/// Episode Type
Property NUMEpisodeType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,HealthPromotion", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ SqlColumnNumber = 3, SqlFieldName = NUM_EpisodeType ];

/// Des Ref EpisSubtype
Property NUMEpisSubtypeDR As PACEpisodeSubType [ SqlColumnNumber = 4, SqlFieldName = NUM_EpisSubtype_DR ];

/// Way
Property NUMWay As %String(DISPLAYLIST = ",Online,Batch", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",O,B") [ SqlColumnNumber = 5, SqlFieldName = NUM_Way ];

/// Bill/Refund
Property NUMBillRefund As %String(DISPLAYLIST = ",Bill,Refund,Both,Receipt,Deposit", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",B,R,O,C,D") [ SqlColumnNumber = 6, SqlFieldName = NUM_BillRefund ];

/// Value
Property NUMValue As %String(MAXLEN = 2, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = NUM_Value ];

/// Des Ref BillCounter
Property NUMBillCounterDR As BLCBillSequence [ SqlColumnNumber = 8, SqlFieldName = NUM_BillCounter_DR ];

/// Des Ref CTLOC
Property NUMCashierLocationDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = NUM_CashierLocation_DR ];

/// PayorType
Property NUMPayorType As %String(DISPLAYLIST = ",Patient,Payor", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",P,I") [ SqlColumnNumber = 10, SqlFieldName = NUM_PayorType ];

/// DateFrom
Property NUMDateFrom As %Date [ SqlColumnNumber = 11, SqlFieldName = NUM_DateFrom ];

/// DateTo
Property NUMDateTo As %Date [ SqlColumnNumber = 12, SqlFieldName = NUM_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCBillNumberSetup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillNumberSetup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCBillNumberSetup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillNumberSetup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCBillNumberSetup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillNumberSetup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCBillNumberSetup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillNumberSetup","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCBillNumberSetup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillNumberSetup","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCBillNumberSetup","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BLC("NUM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NUM_BillCounter_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NUM_BillRefund">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NUM_CashierLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NUM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NUM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NUM_EpisSubtype_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NUM_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NUM_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NUM_PayorType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NUM_Value">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NUM_Way">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NUM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NUM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NUM_RowId</SqlRowIdName>
<StreamLocation>^User.BLCBillNumberSetupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
