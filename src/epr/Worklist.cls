Class epr.Worklist Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 258;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Name";

Parameter SQLDESCRIPTION = "Name";

Parameter SQLROWID = "ID";

Property Border As %Library.Boolean;

Property FrameSize1 As %Library.String(TRUNCATE = 1);

Property FrameSize2 As %Library.String(TRUNCATE = 1);

Property FrameSize3 As %Library.String(TRUNCATE = 1);

Property Name As %String(COLLATION = "ALPHAUP", TRUNCATE = 1);

Property Resizeable As %Library.Boolean;

Property Script As %Library.String(TRUNCATE = 1);

Property Style As %Library.String(DISPLAYLIST = ",Left Right,Top Bottom,Top Left Right,Bottom Left Right,All,QUAD", TRUNCATE = 1, VALUELIST = ",LR,TB,TLR,BLR,ALL,QUAD") [ InitialExpression = "LR", Required ];

Property WorklistSettings As list Of epr.WorklistItem;

Index NameIndex On Name;

/// wanghc
/// copies an entire worklist to a new worklist specified by the name
ClassMethod CopyWorklist(compref As %Library.String, WorkID As %Library.String = "", NewWorkName As %Library.String = "")
{
}

ClassMethod ItemsFindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemsFindFetch ]
{
}

ClassMethod ItemsFindExecute(ByRef QHandle As %Library.Binary, WorkID As %Library.String) As %Library.Status
{
}

ClassMethod ItemsFindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemsFindExecute ]
{
}

/// wanghc 自己加的
ClassMethod getStyleValueList(style)
{
}

/// ab 28.06.02
/// build frame array from worklist items to determine which style (frame layout) to use
/// by wanghc 通过WorklistSettings的布局改变style的值
/// 通过相关度来写style
ClassMethod UpdateStyle(WorkID As %Library.String)
{
}

/// wanghc
ClassMethod websysSave(compref As %String, WorkID As %String)
{
}

/// style 传进来没用到
/// wanghc 
ClassMethod workSettingsDelete(WorkID As %String, itemIdx As %String, quad As %Library.String)
{
}

/// wanghc
ClassMethod workSettingsInsert(ByRef ws As %Library.List, ItemID As %Library.String, Frame As %Library.String, Seq As %Library.String = "", LinkOnly As %Library.String = "", HideMenus As %Library.String = "", DisplayHeader As %Library.String = "", LinkNewWindow As %String = "")
{
}

ClassMethod workSettingsSelect(ByRef itmLIST As %Library.List, ws As %Library.String)
{
}

/// wanghc 
/// 2011-09-28 医生坐诊信息调整--》wroklist.name=排班记录维护
/// worklist.frame.csp用到
/// ab 1.7.02
/// selects all the components of a frame for a worklist, in sequence order
/// @param: ws  As epr.Worklist.WorklistSettings
/// @param: frame = "T | B | R | L"
/// itmLIST("A1")="28^^20^DHCApptSchedule.List^websys.default.csp^DHCPAT.WorkItem.ApptScheduleList^排班记录列表^^^^"
/// paramLIST("A1")="^^^^^^^^^^^^^^^^D^^^^^1^^1^^^^^^^^^^^^^^^^^^^^^^^"
ClassMethod workSettingsSelectByFrame(ByRef itmLIST As %Library.List, ws As %Library.String, frame As %Library.String = "L", ByRef paramLIST As %Library.List)
{
}

ClassMethod GetParams(WorkID As %String = "", frame As %Library.String = "L", SeqNum As %String = "") As %String
{
}

ClassMethod workSettingsSort(ByRef obj As %Library.String)
{
}

Query ItemsFind(WorkID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "wid,Frame:%String,DisplayHeader:%Boolean,Sequence:%String,Rows:%Integer,HideMenus:%Boolean,LinkOnly:%Boolean,wdid:%String,wdcomp:%String,wdname:%String,wddesc:%String,wdurl:%String,wpid:%String,wdpcomp:%String,LinkNewWindow:%Boolean,Sequence2:%String")
{
}

Storage Default
{
<Data name="WorklistClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="WorklistDefaultData">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Resizable</Value>
</Value>
<Value name="3">
<Value>Style</Value>
</Value>
<Value name="4">
<Value>Border</Value>
</Value>
<Value name="5">
<Value>WorklistSettings</Value>
</Value>
<Value name="6">
<Value>Resizeable</Value>
</Value>
<Value name="7">
<Value>BottomHeight</Value>
</Value>
<Value name="8">
<Value>LeftWidth</Value>
</Value>
<Value name="9">
<Value>TopHeight</Value>
</Value>
<Value name="10">
<Value>Script</Value>
</Value>
<Value name="11">
<Value>FrameSize1</Value>
</Value>
<Value name="12">
<Value>FrameSize2</Value>
</Value>
<Value name="13">
<Value>FrameSize3</Value>
</Value>
</Data>
<DataLocation>^epr.WorklistD</DataLocation>
<DefaultData>WorklistDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.WorklistD</IdLocation>
<IndexLocation>^epr.WorklistI</IndexLocation>
<StreamLocation>^epr.WorklistS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
