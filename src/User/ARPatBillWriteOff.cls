/// AR PatBill WriteOff(1932)
Class User.ARPatBillWriteOff Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillWriteOff, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On WOChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_PatientBill Parent Reference
Relationship WOParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillWriteOff, Required, SqlFieldName = WO_ParRef ];

/// Childsub
Property WOChildsub As %Float [ InitialExpression = {$i(^ARPBL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"WO",0))}, SqlColumnNumber = 2, SqlFieldName = WO_Childsub ];

/// Date
Property WODate As %Date [ SqlColumnNumber = 3, SqlFieldName = WO_Date ];

/// Time
Property WOTime As %Time [ SqlColumnNumber = 4, SqlFieldName = WO_Time ];

/// Amount
Property WOAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = WO_Amount ];

/// Des Ref Reason
Property WOReasonWODR As ARCReasonWriteOff [ SqlColumnNumber = 6, SqlFieldName = WO_ReasonWO_DR ];

/// Transfer to Pat Bill
Property WOTransferPatBill As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = WO_TransferPatBill ];

/// Cheque Number
Property WOChequeNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = WO_ChequeNumber ];

/// Comments
Property WOComments As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = WO_Comments ];

/// Des Ref UpdateUser
Property WOUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = WO_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property WOUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = WO_UpdateUserHospital_DR ];

/// Update Date
Property WOUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = WO_UpdateDate ];

/// Update Time
Property WOUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = WO_UpdateTime ];

/// AuxInsType
Property WOAuxInsType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = WO_AuxInsType ];

/// GLPostFlag
Property WOGLPostFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = WO_GLPostFlag ];

/// Des Ref GLBatch
Property WOGLBatchDR As GLBatch [ SqlColumnNumber = 16, SqlFieldName = WO_GLBatch_DR ];

/// Des Ref AccountingPeriod
Property WOAccountingPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 17, SqlFieldName = WO_AccountingPeriod_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillWriteOff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillWriteOff","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillWriteOff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillWriteOff","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillWriteOff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillWriteOff","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillWriteOff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillWriteOff","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillWriteOff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillWriteOff","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="WO_AccountingPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WO_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WO_AuxInsType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WO_ChequeNumber">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WO_Comments">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WO_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WO_GLBatch_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WO_GLPostFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WO_ReasonWO_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WO_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WO_TransferPatBill">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WO_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WO_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WO_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccPer">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WOAccPer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WO_AccountingPeriod_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WO_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WODate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WO_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WO_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WO_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillWriteOffS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
