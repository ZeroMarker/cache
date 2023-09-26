/// 科室/病区-房间分配
/// 2013-6-4 by lisen
/// 2013-9-9 modified by chenying
Class web.Entity.CT.PACWardRoom Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACWardRoom";

/// ROOM_ParRef
Property ROOMParRef As %String;

/// ROOM_RowId
Property ROOMRowId As %String;

/// ROOM_Room_DR
Property ROOMRoomDR As %String;

/// ROOM_DateFrom
Property ROOMDateFrom As %String;

/// ROOM_DateTo
Property ROOMDateTo As %String;

Property ROOMPositionLeft As %String;

Property ROOMPositionTop As %String;

Property ROOMPositionHeight As %String;

Property ROOMPositionWidth As %String;

}
