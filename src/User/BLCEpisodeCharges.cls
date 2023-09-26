/// BLC Addit Episode Charges(1629)
Class User.BLCEpisodeCharges Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_EpisodeCharges, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ADDARCIMDR As ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = ADD_ARCIM_DR ];

/// Des Ref Bed Type
Property ADDBedTypeDR As PACBedType [ SqlColumnNumber = 4, SqlFieldName = ADD_BedType_DR ];

/// Date From
Property ADDDateFrom As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = ADD_DateFrom ];

/// Date To
Property ADDDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = ADD_DateTo ];

/// Des Ref Episode SubType
Property ADDEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 5, SqlFieldName = ADD_EpisSubType_DR ];

/// Des Ref Room Type
Property ADDRoomTypeDR As PACRoomType [ SqlColumnNumber = 3, SqlFieldName = ADD_RoomType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCEpisodeCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCEpisodeCharges","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCEpisodeCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCEpisodeCharges","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCEpisodeCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCEpisodeCharges","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCEpisodeCharges).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCEpisodeCharges","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCEpisodeCharges).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCEpisodeCharges","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^BLC("ADD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADD_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADD_BedType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADD_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADD_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBedType">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateBedType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADD_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADD_RoomType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADD_BedType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADD_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateEpisType">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateEpisType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADD_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADD_EpisSubType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADD_RoomType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADD_BedType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADD_RowId</SqlRowIdName>
<StreamLocation>^User.BLCEpisodeChargesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
