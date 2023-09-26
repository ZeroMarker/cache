/// PA Ward Details          (WARD,154)
Class User.PACWard Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PAC_Ward, StorageStrategy = SQLStorage ]
{

Relationship ChildPACBed As PACBed [ Cardinality = children, Inverse = BEDWARDParRef ];

Relationship ChildPACWardBedAllocation As PACWardBedAllocation [ Cardinality = children, Inverse = WBALLParRef ];

Relationship ChildPACWardNurseAllocation As PACWardNurseAllocation [ Cardinality = children, Inverse = NURParRef ];

Relationship ChildPACWardRoom As PACWardRoom [ Cardinality = children, Inverse = ROOMParRef ];

Relationship ChildPACWardAvailRestriction As PACWardAvailRestriction [ Cardinality = children, Inverse = AVRParRef ];

Relationship ChildPACWardTransaction As PACWardTransaction [ Cardinality = children, Inverse = TRANSParRef ];

Relationship ChildPACWardAdm As PACWardAdm [ Cardinality = children, Inverse = WADMParRef ];

/// Ward Code //2020-04-26扩展长度15-》100
Property WARDCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = WARD_Code ];

/// Ward Description
Property WARDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = WARD_Desc ];

/// Ward_RoomDR
Property WARDRoomDR As PACRoom [ SqlColumnNumber = 4, SqlFieldName = WARD_RoomDR ];

/// Single Room
Property WARDSingleRoom As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 5, SqlFieldName = WARD_SingleRoom ];

/// Location
Property WARDLocationDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = WARD_LocationDR ];

/// Active Flag
Property WARDActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = WARD_Active ];

/// Inactive Date From
Property WARDInactiveDateFrom As %Date [ SqlColumnNumber = 8, SqlFieldName = WARD_InactiveDateFrom ];

/// Inactive Time From
Property WARDInactiveTimeFrom As %Time [ SqlColumnNumber = 9, SqlFieldName = WARD_InactiveTimeFrom ];

/// Inactive Date To
Property WARDInactiveDateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = WARD_InactiveDateTo ];

/// Inactive Time To
Property WARDInactiveTimeTo As %Time [ SqlColumnNumber = 11, SqlFieldName = WARD_InactiveTimeTo ];

/// View Linked Rooms
Property WARDViewLinkedRooms As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = WARD_ViewLinkedRooms ];

/// View Next Most Urgent
Property WARDViewNextMostUrgent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = WARD_ViewNextMostUrgent ];

/// 新增字段 预住院病区
Property WARDBeforehand As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = WARD_Beforehand ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWard).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWard","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWard).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWard","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWard).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWard","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWard).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWard","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWard).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWard","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("PACWD",0))</SqlIdExpression>
<SQLMap name="DataMasterMapWARD">
<Data name="WARD_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WARD_Beforehand">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WARD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WARD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WARD_InactiveDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WARD_InactiveDateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WARD_InactiveTimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WARD_InactiveTimeTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WARD_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WARD_RoomDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WARD_SingleRoom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WARD_ViewLinkedRooms">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WARD_ViewNextMostUrgent">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WARD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WARD_RowID}</Expression>
<StartValue>1</StartValue>
<StopValue>"A"</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WARD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"WARD_Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({WARD_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WARD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WARD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"WARD_Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({WARD_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WARD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WARD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WARD_LocationDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WARD_LocationDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WARD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WARD_RowID</SqlRowIdName>
<StreamLocation>^User.PACWardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
