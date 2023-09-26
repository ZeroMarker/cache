/// PA Wait List RB(1774)
Class User.PAWaitingListRB Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListRB, StorageStrategy = SQLStorage ]
{

/// Des Ref AuxInsType
Property RBAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 5, SqlFieldName = RB_AuxInsType_DR ];

/// Des Ref Booking Dep
Property RBCTLOCDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = RB_CTLOC_DR ];

/// Childsub
Property RBChildsub As %Float [ InitialExpression = {$i(^PAWL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RB",0))}, SqlColumnNumber = 2, SqlFieldName = RB_Childsub ];

/// Des Ref InsType
Property RBInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = RB_InsType_DR ];

/// Des Ref OEORI
Property RBOEORIDR As OEOrdItem [ SqlColumnNumber = 10, SqlFieldName = RB_OEORI_DR ];

/// PA_WaitingList Parent Reference
Relationship RBParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListRB, Required, SqlFieldName = RB_ParRef ];

/// Des Ref Service
Property RBServiceDR As RBCServices [ SqlColumnNumber = 3, SqlFieldName = RB_Service_DR ];

/// ServiceKey
Property RBServiceKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = RB_ServiceKey ];

/// Des Ref Status
Property RBStatusDR As PACWaitingListStatus [ SqlColumnNumber = 8, SqlFieldName = RB_Status_DR ];

/// Des REf WLType
Property RBTypeDR As PACWaitingListType [ SqlColumnNumber = 9, SqlFieldName = RB_Type_DR ];

Index RowIDBasedIDKeyIndex On RBChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 283;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAWaitingListRB).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRB","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAWaitingListRB).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRB","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAWaitingListRB).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRB","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAWaitingListRB).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRB","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAWaitingListRB).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAWaitingListRB","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>283</ExtentSize>
<Property name="RBAuxInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBOEORIDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBServiceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBServiceKey">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBStatusDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBTypeDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RB_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RB_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RB_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RB_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RB_ServiceKey">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RB_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RB_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RB_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ServiceKey}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceStatus">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SERStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ServiceKey}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SERType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ServiceKey}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Status_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RB_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListRBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
