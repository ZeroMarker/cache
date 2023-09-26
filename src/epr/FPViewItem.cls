/// Floorplan item (bed/room)
Class epr.FPViewItem Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Property FPIBedDR As User.PACBed;

Property FPIPositionHeight As %Library.String(TRUNCATE = 1);

Property FPIPositionLeft As %Library.String(TRUNCATE = 1);

Property FPIPositionTop As %Library.String(TRUNCATE = 1);

Property FPIPositionWidth As %Library.String(TRUNCATE = 1);

Property FPIWardRoomDR As User.PACWardRoom;

Index BedIndex On FPIBedDR;

Storage Default
{
<Data name="FPViewItemState">
<Value name="1">
<Value>FPIPositionHeight</Value>
</Value>
<Value name="2">
<Value>FPIPositionLeft</Value>
</Value>
<Value name="3">
<Value>FPIPositionTop</Value>
</Value>
<Value name="4">
<Value>FPIPositionWidth</Value>
</Value>
<Value name="5">
<Value>FPIBedDR</Value>
</Value>
<Value name="6">
<Value>FPIWardRoomDR</Value>
</Value>
</Data>
<State>FPViewItemState</State>
<StreamLocation>^epr.FPViewItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
