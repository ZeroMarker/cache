/// Floorplan view
Class epr.FPView Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 134;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "FPVCode";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

Property FPVCode As %Library.String(TRUNCATE = 1);

Property FPVDesc As %Library.String(TRUNCATE = 1);

Property FPVItem As list Of epr.FPViewItem;

Property FPVViewLinkedRooms As %Library.Boolean;

Property FPVViewNextMostUrgent As %Boolean;

Property FPVWard As User.PACWard;

/// Index for property FPVWard
Index FPVWardIndex On FPVWard;

/// returns the position of an item in the serialobject which has the bed/room id passed in
/// 
/// called by FindForFloorplan query, and PACBed.List component ("pos")
/// by wuqk 2011-07-09
ClassMethod FindItemByID(ViewID As %Library.String = "", id As %Library.String = "", roomid As %Library.String = "", ByRef positions As %Library.String = "") As %Library.String
{
}

/// by wuqk 2011-07-09
ClassMethod GetLinkedRooms(WardID As %Library.String = "", ViewID As %Library.String = "", page As %Library.String = "", LinkedWardID As %Library.String = "") As %Library.Boolean
{
}

/// by wuqk 2011-07-09
ClassMethod ShowNextMostUrgent(WardID As %Library.String = "", ViewID As %Library.String = "") As %Library.Boolean
{
}

/// returns a list of view id's for a ward
/// also writes the links for the floorplan if 'page' is passed
ClassMethod GetOtherViews(WardID As %Library.String = "", page As %Library.String = "") As %Library.String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean, ViewID As %Library.String = "") As %Boolean
{
}

/// by wuqk 2011-07-09
ClassMethod websysSavePositions(compref As %Library.String, id As %Library.String, ViewID As %Library.String = "")
{
}

/// ab 27.02.06  58179
ClassMethod GetNextMostUrgentFP(LocID As %String = "", QueryType As %String = "") As %String
{
}

/// d ##class(%ResultSet).RunQuery("epr.FPView","FindForFloorplan",5,"")
ClassMethod FindForFloorplanExecute(ByRef qHandle As %Binary, WardID, ViewID) As %Status
{
}

ClassMethod FindForFloorplanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindForFloorplanExecute ]
{
}

ClassMethod FindForFloorplanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindForFloorplanExecute ]
{
}

Query FindForFloorplan(WardID, ViewID) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,BEDCode,ROOMDesc,WardRoomID,PositionLeft,PositionTop,PositionWidth,PositionHeight,ActiveFlag,QueryType,Rows,UnavailReason,BEDIcon,BEDTypeDesc,Incompletes,RoomType")
{
}

/// 自定义测试数据用
/// d ##class(epr.FPView).getFPViewItems(WardID, ViewID)
ClassMethod getFPViewItems(WardID, ViewID)
{
}

/// 自定义测试数据用
/// s a=##class(epr.FPView).getbed(93)
ClassMethod getbed(ward) As %String
{
}

Storage Default
{
<Data name="FPViewClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="FPViewDefaultData">
<Value name="1">
<Value>FPVCode</Value>
</Value>
<Value name="2">
<Value>FPVDesc</Value>
</Value>
<Value name="3">
<Value>FPVWard</Value>
</Value>
<Value name="4">
<Value>FPVItem</Value>
</Value>
<Value name="5"/>
<Value name="6">
<Value>FPVViewLinkedRooms</Value>
</Value>
<Value name="7">
<Value>FPVViewNextMostUrgent</Value>
</Value>
</Data>
<DataLocation>^epr.FPViewD</DataLocation>
<DefaultData>FPViewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.FPViewD</IdLocation>
<IndexLocation>^epr.FPViewI</IndexLocation>
<StreamLocation>^epr.FPViewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
