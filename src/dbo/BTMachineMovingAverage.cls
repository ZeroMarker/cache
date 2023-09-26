/// 仪器移动均值
Class dbo.BTMachineMovingAverage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_MachineMovingAverage, StorageStrategy = Default ]
{

/// Foreign Key FKMachineParameter created via DDL
ForeignKey FKMachineParameter(MachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineParameter ];

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

/// Foreign Key PKBTMACHINEMOVINGAVGRULE created via DDL
ForeignKey PKBTMACHINEMOVINGAVGRULE(MachineMovingAvgRuleDR) References dbo.BTMachineMovingAvgRule(PKBTMACHINEMOVINGAVGRULE) [ SqlName = FK_Rule ];

Index IndexMachine On (MachineDR, TestCodeDR) [ SqlName = Index_Machine, Type = index ];

Index IndexReagNo On (MachineDR, TestCodeDR, ReagNo) [ SqlName = Index_ReagNo, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPMachineMovingAverage On RowID [ PrimaryKey, SqlName = PK_BT_RPMACHINEMOVINGAVERAGE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// TotalNum  
Property TotalNum As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

/// TotalAvg  
Property TotalAvg As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// ConUnderLimit  
Property ConUnderLimit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// ConOverLimit  
Property ConOverLimit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// UnderAvg  
Property UnderAvg As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// OverAvg  
Property OverAvg As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// LowLimit  
Property LowLimit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// HighLimit  
Property HighLimit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// ReagNo  
Property ReagNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 13 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 移动均值规则  
Property MachineMovingAvgRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// RConUnderLimit  
Property RConUnderLimit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// RConOverLimit  
Property RConOverLimit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 17 ];

/// RUnderAvg  
Property RUnderAvg As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

/// ROverAvg  
Property ROverAvg As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 首次接收日期  
Property FirstReciveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 首次接收时间  
Property FirstReciveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="BTMachineMovingAverageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>TotalNum</Value>
</Value>
<Value name="5">
<Value>TotalAvg</Value>
</Value>
<Value name="6">
<Value>ConUnderLimit</Value>
</Value>
<Value name="7">
<Value>ConOverLimit</Value>
</Value>
<Value name="8">
<Value>UnderAvg</Value>
</Value>
<Value name="9">
<Value>OverAvg</Value>
</Value>
<Value name="10">
<Value>LowLimit</Value>
</Value>
<Value name="11">
<Value>HighLimit</Value>
</Value>
<Value name="12">
<Value>ReagNo</Value>
</Value>
<Value name="13">
<Value>Active</Value>
</Value>
<Value name="14">
<Value>MachineMovingAvgRuleDR</Value>
</Value>
<Value name="15">
<Value>RConUnderLimit</Value>
</Value>
<Value name="16">
<Value>RConOverLimit</Value>
</Value>
<Value name="17">
<Value>RUnderAvg</Value>
</Value>
<Value name="18">
<Value>ROverAvg</Value>
</Value>
<Value name="19">
<Value>FirstReciveDate</Value>
</Value>
<Value name="20">
<Value>FirstReciveTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMachineMovingAverageD</DataLocation>
<DefaultData>BTMachineMovingAverageDefaultData</DefaultData>
<IdLocation>^dbo.BTMachineMovingAverageD</IdLocation>
<IndexLocation>^dbo.BTMachineMovingAverageI</IndexLocation>
<StreamLocation>^dbo.BTMachineMovingAverageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
