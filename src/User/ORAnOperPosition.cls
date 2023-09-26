/// Operation Position(1013)
Class User.ORAnOperPosition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_An_Oper_Position, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OPPOSChildsub [ IdKey, PrimaryKey, Unique ];

/// OR_Anaest_Operation Parent Reference
Relationship OPPOSParRef As ORAnaestOperation [ Cardinality = parent, Inverse = ChildORAnOperPosition, Required, SqlFieldName = OPPOS_ParRef ];

/// Childsub
Property OPPOSChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ANA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"OP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"POS",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OPPOS_Childsub ];

/// Position Des Ref to ORCPOS
Property OPPOSPositionDR As ORCOperPosition [ Required, SqlColumnNumber = 3, SqlFieldName = OPPOS_Position_DR ];

/// Start Time
Property OPPOSStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = OPPOS_StartTime ];

/// End Time
Property OPPOSEndTime As %Time [ SqlColumnNumber = 5, SqlFieldName = OPPOS_EndTime ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnOperPosition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperPosition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnOperPosition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperPosition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnOperPosition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperPosition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnOperPosition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperPosition","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnOperPosition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperPosition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OPPOS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPPOS_Position_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPPOS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>OPPOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"POS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OPPOS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OPPOS_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnOperPositionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
