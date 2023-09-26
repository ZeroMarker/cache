/// PAC Ward Room(1546)
Class User.PACWardRoom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WardRoom, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ROOMChildSub [ IdKey, PrimaryKey, Unique ];

/// PAC_Ward Parent Reference
Relationship ROOMParRef As PACWard [ Cardinality = parent, Inverse = ChildPACWardRoom, Required, SqlFieldName = ROOM_ParRef ];

/// ChildSub
Property ROOMChildSub As %Float [ InitialExpression = {$i(^PAWARD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ROOM",0))}, SqlColumnNumber = 2, SqlFieldName = ROOM_ChildSub ];

/// Des Ref Room
Property ROOMRoomDR As PACRoom [ SqlColumnNumber = 3, SqlFieldName = ROOM_Room_DR ];

/// Position Left
Property ROOMPositionLeft As %Float [ SqlColumnNumber = 4, SqlFieldName = ROOM_PositionLeft ];

/// Position Top
Property ROOMPositionTop As %Float [ SqlColumnNumber = 5, SqlFieldName = ROOM_PositionTop ];

/// Position Width
Property ROOMPositionWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = ROOM_PositionWidth ];

/// Position Height
Property ROOMPositionHeight As %Float [ SqlColumnNumber = 7, SqlFieldName = ROOM_PositionHeight ];

/// Accommodation Type DR
Property ROOMAccommodationTypeDR As PACAccomodationType [ SqlColumnNumber = 8, SqlFieldName = ROOM_AccommodationTypeDR ];

/// Date From
Property ROOMDateFrom As %Date [ SqlColumnNumber = 9, SqlFieldName = ROOM_DateFrom ];

/// Date To
Property ROOMDateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = ROOM_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWardRoom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardRoom","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWardRoom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardRoom","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWardRoom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardRoom","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWardRoom).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardRoom","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWardRoom).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardRoom","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ROOM_AccommodationTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ROOM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ROOM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ROOM_PositionHeight">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ROOM_PositionLeft">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ROOM_PositionTop">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ROOM_PositionWidth">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ROOM_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ROOM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ROOM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ROOM_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRoom">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ROOM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ROOM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Room"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ROOM_Room_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ROOM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ROOM_RowId</SqlRowIdName>
<StreamLocation>^User.PACWardRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
