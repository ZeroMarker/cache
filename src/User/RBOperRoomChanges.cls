/// RB Oper Room Changes(1566)
Class User.RBOperRoomChanges Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperRoomChanges, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CHChildsub As %Float [ InitialExpression = {$i(^RBOP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CH",0))}, SqlColumnNumber = 2, SqlFieldName = CH_Childsub ];

/// Date
Property CHDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CH_Date ];

/// Des Ref LastUpdateHospital
Property CHLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = CH_LastUpdateHospital_DR ];

/// Des Ref OperDepartment
Property CHOperDepartmentDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = CH_OperDepartment_DR ];

/// Des Ref Operation
Property CHOperationDR As ORCOperation [ SqlColumnNumber = 13, SqlFieldName = CH_Operation_DR ];

/// RB_OperatingRoom Parent Reference
Relationship CHParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperRoomChanges, Required, SqlFieldName = CH_ParRef ];

/// Des Ref ORC Room Book Priority
Property CHPriorityDR As ORCRoomBookPriority [ SqlColumnNumber = 6, SqlFieldName = CH_Priority_DR ];

/// Des Ref Resource
Property CHRBResourceDR As RBResource [ SqlColumnNumber = 5, SqlFieldName = CH_RB_Resource_DR ];

/// Sequence
Property CHSequence As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CH_Sequence ];

/// Status
Property CHStatus As %String(DISPLAYLIST = ",Booked,Cancelled,Closed,Confirmed,Postponed,Done,Requested,Transfer", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",B,X,CL,C,P,D,R,T") [ SqlColumnNumber = 3, SqlFieldName = CH_Status ];

/// Des Ref Surgeon
Property CHSurgeonDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = CH_Surgeon_DR ];

/// Time
Property CHTime As %Time [ SqlColumnNumber = 8, SqlFieldName = CH_Time ];

/// Transaction Date
Property CHTransDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CH_TransDate ];

/// Transaction Time
Property CHTransTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CH_TransTime ];

Index RowIDBasedIDKeyIndex On CHChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 10;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBOperRoomChanges).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomChanges","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBOperRoomChanges).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomChanges","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBOperRoomChanges).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomChanges","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBOperRoomChanges).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomChanges","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBOperRoomChanges).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomChanges","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="CHChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHLastUpdateHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHOperDepartmentDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHOperationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHPriorityDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHRBResourceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHSequence">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHStatus">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="CHSurgeonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHTransDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="CHTransTime">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CH_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CH_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CH_OperDepartment_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CH_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CH_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CH_RB_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CH_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CH_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CH_Surgeon_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CH_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CH_TransDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CH_TransTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^RBOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CH_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperRoomChangesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
