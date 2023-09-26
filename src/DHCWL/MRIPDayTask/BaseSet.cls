/// DHCWL_MRIPDayTask.BaseSet     d ##class(DHCWL.MRIPDayTask.BaseSet).%BuildIndices()
Class DHCWL.MRIPDayTask.BaseSet Extends %Persistent [ ClassType = persistent, SqlRowIdName = BaseSet_RowID, SqlTableName = BaseSet ]
{

/// 出院时间类型 DOC：医生结算NURSE：护士结算
Property BaseSetDisDateType As %String [ SqlColumnNumber = 2, SqlFieldName = BaseSet_DisDateType ];

/// 科室停任务标志 Y:停止 N：不停止
Property BaseSetDepStopFlag As %String [ SqlColumnNumber = 3, SqlFieldName = BaseSet_DepStopFlag ];

/// 病区停任务标志 Y:停止 N：不停止
Property BaseSetWardStopFlag As %String [ SqlColumnNumber = 4, SqlFieldName = BaseSet_WardStopFlag ];

/// 创建人
Property BaseSetCreator As %String [ SqlColumnNumber = 5, SqlFieldName = BaseSet_Creator ];

/// 操作日期
Property BaseSetUpDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BaseSet_UpDate ];

/// 操作时间
Property BaseSetUpTime As %Time [ SqlColumnNumber = 7, SqlFieldName = BaseSet_UpTime ];

Index UpDateTimeIndex On (BaseSetUpDate, BaseSetUpTime);

Storage Default
{
<Data name="BaseSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BaseSetDisDateType</Value>
</Value>
<Value name="3">
<Value>BaseSetDepStopFlag</Value>
</Value>
<Value name="4">
<Value>BaseSetWardStopFlag</Value>
</Value>
<Value name="5">
<Value>BaseSetCreator</Value>
</Value>
<Value name="6">
<Value>BaseSetUpDate</Value>
</Value>
<Value name="7">
<Value>BaseSetUpTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDayTask.BaseSetD</DataLocation>
<DefaultData>BaseSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDayTask.BaseSetD</IdLocation>
<IndexLocation>^DHCWL.MRIPDayTask.BaseSetI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDayTask.BaseSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
