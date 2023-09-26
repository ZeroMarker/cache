Class epr.Chart Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1684;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Name";

Parameter SQLDESCRIPTION = "Name";

Parameter SQLROWID = "ID";

/// This field stores the information, in the following format in a List.
/// itemID,itemType,Rows,Sequence
Property ChartSettings As list Of epr.ChartItem;

Property Name As %String(COLLATION = "ALPHAUP", TRUNCATE = 1);

Property Student As %Library.Boolean;

Property IsHistoryPage As %Library.Boolean;

Property DisplayConsultBanner As %Library.Boolean;

Property ChartColour As %Library.String(TRUNCATE = 1);

Property TextColour As %Library.String(TRUNCATE = 1);

Property SELChartColour As %Library.String(TRUNCATE = 1);

Property SELTextColour As %Library.String(TRUNCATE = 1);

/// 2017-3-23 wanghc 增加类方法配置 返回json 可定义页签color,count,disable
Property StyleClassMethodName As %Library.String;

/// 2019-12-02 wanghc 增加工能按钮 RefBtn,CopyBtn
Property TButtons As %String;

/// Index for property Name
Index NameIndex On Name;

/// ab 24.03.06 58654
/// by wuqk 2011-06-05
ClassMethod CopyChart(ID As %String = "", Name As %String = "")
{
}

ClassMethod CanMarkAsRead(EpisodeID As %Library.String, userid As %Library.String, OrderID As %Library.String = "") As %Library.String
{
}

ClassMethod CanMarkItemAsRead(OrderID As %Library.String = "", GroupID As %Library.String = "") As %Library.String
{
}

ClassMethod ItemsFindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemsFindFetch ]
{
}

ClassMethod ItemsFindExecute(ByRef QHandle As %Library.Binary, ChartID As %Library.String) As %Library.Status
{
}

ClassMethod ItemsFindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemsFindExecute ]
{
}

/// by wuqk 2011-05-31
ClassMethod UnreadResults(episodeid As %Library.String, mradm As %Library.String, ByRef unread As %Library.List) As %Library.Boolean
{
}

ClassMethod UnreadResultsInChart(ChartID As %Library.String, ByRef unread As %Library.List) As %Library.Boolean
{
}

/// KM Feb-2001
/// by wuqk 2011-06-01
ClassMethod chartSettingsDelete(ChartID As %String, itemIdx As %String)
{
}

/// KM 20-Feb-2001
ClassMethod chartSettingsInsert(ByRef cs As %Library.List, ItemID As %Library.String, ItemType As %Library.String)
{
}

/// KM 7-Mar-2001: Called from both epr.chart.csp AND epr.eprgraph.csp
ClassMethod chartSettingsSelect(ByRef itmLIST As %Library.List, ByRef params As %Library.String, cs As %Library.String)
{
}

/// d ##class(epr.Chart).TestChartSetting()
ClassMethod TestChartSetting()
{
}

/// set para=""
/// d ##class(epr.Chart).ChartItemParas(para)
ClassMethod ChartItemParas()
{
}

/// d ##class(ext.epr.Chart).GetItemData("OP",1)
ClassMethod GetItemData(type, id)
{
}

/// KM 13-Mar-2001
ClassMethod chartSettingsSort(ByRef obj As %Library.String, ChartID As %Library.String = "")
{
}

/// do ##class(epr.Chart).testShowItem()
ClassMethod testShowItem()
{
}

/// chartSettingsSelect->ChartDisplay7
/// by wuqk 2011-06-02
ClassMethod ChartDisplay7()
{
}

ClassMethod ChartItemDisplay()
{
}

/// YC - epr.chart.csp got too big. Moved half the code to this method.
/// by wuqk 2011-05-31 get grom P5 epr.chart.csp
ClassMethod ChartDisplay()
{
}

/// KM 4-Oct-2001: Called from the class methods websysBeforeSave() for any saves which 
/// may reload the EPR Chart Page after an update.
/// by wuqk 2011-06-05 
/// 从原环境上测试发现所有chart均返回"epr.chart.csp"
ClassMethod getEPRChartPage(ChartID As %Library.String) As %Library.String
{
}

/// KM 7-Nov-2001: Called From epr.ChartItem.Edit component
/// by wuqk 2011-06-05 暂无数据，无法测试
ClassMethod getGraph(ChartID As %Library.String, ItemID As %Library.String, Type As %Library.String)
{
}

/// AI 01-Jul-2002: Called From epr.ChartHeading.Edit component
/// by wuqk 2011-06-05
ClassMethod getHeading(ChartID As %Library.String, ItemID As %Library.String, Type As %Library.String, delim As %Library.String = {$c(13,10)}) As %Library.String
{
}

/// by wuqk 2011-06-05
ClassMethod getExpression(ChartID As %Library.String, ItemID As %Library.String, Type As %Library.String) As %Library.String
{
}

/// KM 7-Nov-2001: Called From epr.ChartItem.Edit component
ClassMethod insertGraph(ChartID As %Library.String, ItemID As %Library.String)
{
}

/// AI 01-Jul-2002: Called From epr.ChartHeading.Edit component
/// by wuqk 2011-06-07
ClassMethod insertHeading(ChartID As %Library.String, ItemID As %Library.String)
{
}

/// by wuqk 2011-06-07
ClassMethod insertExpression(ChartID As %Library.String, ItemID As %Library.String)
{
}

/// KM 13-Mar-2001: Called From epr.Chart.Edit component
/// by wuqk 2011-06-05
ClassMethod websysSave(compref As %Library.String, ChartID As %Library.String)
{
}

Query Find(name As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "id,name:%String")
{
SELECT ID, Name
FROM epr.Chart
WHERE (Name %STARTSWITH :name)
}

/// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
/// by wuqk 2011-06-01
Query ItemsFind(ChartID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "index,ItemID:%String,ItemType:%String,ItemDesc:%String,DisplayHeader:%Boolean,DisplayAddButton:%Boolean,Sequence:%String,Rows:%Integer,graph:%String,heading:%String,HeadingDisplay:%String,Collapse:%Library.Boolean,ColumnWidth:%Library.Integer,AcrossEpisodes:%Boolean,OnlyMarkedForDSReport:%Boolean")
{
}

Query VBFindLE(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Description:%Library.String")
{
SELECT	ID, Name
FROM	epr.Chart
WHERE	(Name %STARTSWITH :desc)
ORDER	BY Name
}

/// by wuqk 2011-06-02
/// ;Create neccessary variables for calling the OrderProfile Query.
ClassMethod setOP()
{
}

/// by wuqk 2011-06-02
/// ;Create neccessary variables for calling the ResultProfile Query.
ClassMethod setRP()
{
}

/// by wuqk 2011-06-02
/// ;Create ALL neccessary variables for calling the Lab Profile Query.
ClassMethod setLP()
{
}

/// by wuqk 2011-06-02
/// ;Lab Episode Profile Query.
ClassMethod setLG()
{
}

/// by wuqk 2011-06-02
/// ;Lab Cumulative Profile Results.
ClassMethod setLC()
{
}

/// by wuqk 2011-06-02
/// ;Log 29736 - AI - 08-01-2004 : Observation Group is now an Observation Profile, which contains/references an Observation Group.
/// ; Observation Profile
ClassMethod setBP()
{
}

/// by wuqk 2011-06-02
/// ;DHCEPR Profile
ClassMethod setDH()
{
}

/// by wuqk 2011-06-02
/// ;Tabular Profile Results.
ClassMethod setLT()
{
}

/// by wuqk 2011-06-02
/// ;Lab Profile Query.
ClassMethod setBT()
{
}

/// by wuqk 2011-06-02
/// ;Questionnaire Profile
ClassMethod setQP()
{
}

/// by wuqk 2011-06-02
/// ;Log 50669 YC - Time Line as Chart
/// ;Time Line Profile
ClassMethod setTL()
{
}

/// by wuqk 2011-06-02
/// ;Reset the questionnaire variables if calling from an EPR page (to distinguish from an 'QP' query)
ClassMethod setEP()
{
}

/// by wuqk 2011-06-02
/// ;Do NOT re-show the form if it was already shown for the specific Profiles.
ClassMethod setElse()
{
}

/// @params ChartBookID 图表组epr.ChartBook->RowId
/// @params PatientId   病人PA_Patient->RowId
/// @params EpisodeId   就诊PA_Adm->RowId
/// @params mradm		就诊MR_Adm->RowId
/// 图表组【图表样式】解析方法
ClassMethod GetPatChartInfo(ChartBookID, PatientId, EpisodeId, mradm)
{
}

Storage Default
{
<Data name="ChartDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>FramesList</Value>
</Value>
<Value name="3">
<Value>ChartSettings</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="6">
<Value>Student</Value>
</Value>
<Value name="7">
<Value>IsHistoryPage</Value>
</Value>
<Value name="8">
<Value>TabColour</Value>
</Value>
<Value name="9">
<Value>ChartColour</Value>
</Value>
<Value name="10">
<Value>TextColour</Value>
</Value>
<Value name="11">
<Value>SELChartColour</Value>
</Value>
<Value name="12">
<Value>SELTextColour</Value>
</Value>
<Value name="13">
<Value>DisplayConsultBanner</Value>
</Value>
<Value name="14">
<Value>StyleClassMethodName</Value>
</Value>
<Value name="15">
<Value>TButtons</Value>
</Value>
</Data>
<DataLocation>^ooChartD</DataLocation>
<DefaultData>ChartDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ooChartD</IdLocation>
<IndexLocation>^ooChartI</IndexLocation>
<StreamLocation>^epr.ChartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
