/// Room Details             (ROOM,155)
Class User.PACRoom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Room, StorageStrategy = SQLStorage ]
{

/// Room Code
Property ROOMCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ROOM_Code ];

/// Room Description
Property ROOMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ROOM_Desc ];

/// Room Type des ref
Property ROOMRoomTypeDR As PACRoomType [ Required, SqlColumnNumber = 7, SqlFieldName = ROOM_RoomType_DR ];

/// Different Sex Patients in Room
Property ROOMDifferentSexPatients As %String(DISPLAYLIST = ",Does Not Matter,Warning,Not Allowed", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",D,W,N") [ SqlColumnNumber = 8, SqlFieldName = ROOM_DifferentSexPatients ];

/// Query
Property ROOMQuery As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ROOM_Query ];

/// No Of Rows
Property ROOMNoOfRows As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ROOM_NoOfRows ];

/// Incompletes
Property ROOMIncompletes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ROOM_Incompletes ];

/// Date From
Property ROOMDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = ROOM_DateFrom ];

/// Date To
Property ROOMDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = ROOM_DateTo ];

/// Order By Priority
Property ROOMOrderByPriority As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ROOM_OrderByPriority ];

/// Floor DR
Property ROOMFloorDR As User.CTLocBuildingFloor [ SqlColumnNumber = 15, SqlFieldName = ROOM_Floor_DR ];

Index ROOMCodeUnqIdx1 On ROOMCode;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRoom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRoom","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRoom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRoom","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRoom).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRoom","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRoom).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRoom","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRoom).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRoom","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAROOM(0))</SqlIdExpression>
<SQLMap name="DataMasterMapROOM">
<Data name="ROOM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ROOM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ROOM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ROOM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ROOM_DifferentSexPatients">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ROOM_Floor_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ROOM_Incompletes">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ROOM_NoOfRows">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ROOM_OrderByPriority">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ROOM_Query">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ROOM_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAROOM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ROOM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ROOM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAROOM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ROOM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ROOM_Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ROOM_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ROOM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAROOM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ROOM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ROOM_Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ROOM_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ROOM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ROOM_RowID</SqlRowIdName>
<StreamLocation>^User.PACRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
