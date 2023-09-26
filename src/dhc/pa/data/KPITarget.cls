Class dhc.pa.data.KPITarget Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPITarget_rowid, SqlTableName = KPITarget ]
{

//指标名称

Property KPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 2, SqlFieldName = KPITarget_KPIDr ];

//目标类型名称

Property TargetName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = KPITarget_Name ];

//目标类型的代码(1-同期,2-年均值，3-排序法)

Property TargetCode As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = KPITarget_Code ];

//年数 n年同期平均;n年平均

Property Coefficient As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = KPITarget_Coefficient ];

//增减率 

Property ChangeNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = KPITarget_ChangeNum ];

//作废标志 

Property CancelFlag As %Library.String [ SqlColumnNumber = 7, SqlFieldName = KPITarget_CancelFlag ];

Index IndexTarget On (TargetCode As Exact, KPIDr As Exact);

Index IndexTargetKpiDr On KPIDr As Exact;

Storage Default
{
<Data name="KPITargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPIDr</Value>
</Value>
<Value name="3">
<Value>TargetName</Value>
</Value>
<Value name="4">
<Value>TargetCode</Value>
</Value>
<Value name="5">
<Value>Coefficient</Value>
</Value>
<Value name="6">
<Value>ChangeNum</Value>
</Value>
<Value name="7">
<Value>CancelFlag</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPAKPITargetD</DataLocation>
<DefaultData>KPITargetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPAKPITargetD</IdLocation>
<IndexLocation>^DHCCJXPAKPITargetI</IndexLocation>
<StreamLocation>^dhc.pa.data.KPITargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
