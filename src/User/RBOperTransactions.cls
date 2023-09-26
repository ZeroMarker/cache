/// RB Oper Transactions(1551)
Class User.RBOperTransactions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperTransactions, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TRANSChildsub As %Float [ InitialExpression = {$i(^RBOP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRANS",0))}, SqlColumnNumber = 2, SqlFieldName = TRANS_Childsub ];

/// Date
Property TRANSDate As %Date [ SqlColumnNumber = 3, SqlFieldName = TRANS_Date ];

/// Des Ref LastUpdateHospital
Property TRANSLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = TRANS_LastUpdateHospital_DR ];

/// Original Date
Property TRANSOriginalDate As %Date [ SqlColumnNumber = 5, SqlFieldName = TRANS_OriginalDate ];

/// Original Time
Property TRANSOriginalTime As %Time [ SqlColumnNumber = 6, SqlFieldName = TRANS_OriginalTime ];

/// RB_OperatingRoom Parent Reference
Relationship TRANSParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperTransactions, Required, SqlFieldName = TRANS_ParRef ];

/// Reason For Change
Property TRANSReasonForChange As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TRANS_ReasonForChange ];

/// Time
Property TRANSTime As %Time [ SqlColumnNumber = 4, SqlFieldName = TRANS_Time ];

/// Des Ref User
Property TRANSUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = TRANS_User_DR ];

Index RowIDBasedIDKeyIndex On TRANSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBOperTransactions).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperTransactions","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBOperTransactions).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperTransactions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBOperTransactions).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperTransactions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBOperTransactions).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperTransactions","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBOperTransactions).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperTransactions","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TRANS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRANS_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRANS_OriginalDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANS_OriginalTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRANS_ReasonForChange">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRANS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^RBOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TRANS_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperTransactionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
