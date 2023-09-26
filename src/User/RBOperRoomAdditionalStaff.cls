/// Oper Room Additional Staff (2534)
Class User.RBOperRoomAdditionalStaff Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperRoomAdditionalStaff, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RBOPASChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_OperatingRoom Parent Reference
Relationship RBOPASParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperRoomAdditionalStaff, Required, SqlFieldName = RBOPAS_ParRef ];

/// Childsub
Property RBOPASChildsub As %Float [ InitialExpression = {$i(^RBOP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RBOPAS",0))}, SqlColumnNumber = 2, SqlFieldName = RBOPAS_Childsub ];

/// Care Provider Type
Property RBOPASCareProvType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RBOPAS_CareProvType ];

/// Des Ref CT_CareProv
Property RBOPASCareProvDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = RBOPAS_CareProv_DR ];

/// Des Ref ORC_Operation 
Property RBOPASOperationDR As ORCOperation [ SqlColumnNumber = 5, SqlFieldName = RBOPAS_Operation_DR ];

/// Des Ref PAC_StatePPP
Property RBOPASStatePPPDR As PACStatePPP [ SqlColumnNumber = 6, SqlFieldName = RBOPAS_StatePPP_DR ];

/// Start Date
Property RBOPASStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = RBOPAS_StartDate ];

/// Start Time
Property RBOPASStartTime As %Time [ SqlColumnNumber = 8, SqlFieldName = RBOPAS_StartTime ];

/// End Date
Property RBOPASEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = RBOPAS_EndDate ];

/// End Time
Property RBOPASEndTime As %Time [ SqlColumnNumber = 10, SqlFieldName = RBOPAS_EndTime ];

/// DR CTLoc
Property RBOPASCPLocationDR As CTLoc [ SqlColumnNumber = 11, SqlFieldName = RBOPAS_CPLocation_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBOperRoomAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomAdditionalStaff","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBOperRoomAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomAdditionalStaff","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBOperRoomAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomAdditionalStaff","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBOperRoomAdditionalStaff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomAdditionalStaff","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBOperRoomAdditionalStaff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperRoomAdditionalStaff","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RBOPAS_CPLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RBOPAS_CareProvType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBOPAS_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RBOPAS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RBOPAS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RBOPAS_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RBOPAS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RBOPAS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RBOPAS_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^RBOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RBOPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"RBOPAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOPAS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCareProvType">
<Global>^RBOPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RBOPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CareProvType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBOPAS_CareProvType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RBOPAS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBOPAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCareProvider">
<Global>^RBOPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RBOPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CareProv"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBOPAS_CareProv_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RBOPAS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBOPAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOperation">
<Global>^RBOPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RBOPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Operation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBOPAS_Operation_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RBOPAS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBOPAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProcedure">
<Global>^RBOPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RBOPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StatePPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBOPAS_StatePPP_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"RBOPAS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBOPAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RBOPAS_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperRoomAdditionalStaffS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
