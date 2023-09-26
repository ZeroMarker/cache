/// DHCWL_MRIPDayTask.DisCond    d ##class(DHCWL.MRIPDayTask.DisCond).%BuildIndices()
Class DHCWL.MRIPDayTask.DisCond Extends %Persistent [ ClassType = persistent, SqlRowIdName = DisCond_RowID, SqlTableName = DisCond ]
{

/// 治愈人数串
Property DisCondZYRS As %String [ SqlColumnNumber = 2, SqlFieldName = DisCond_ZYRS ];

/// 好转人数串
Property DisCondHZRS As %String [ SqlColumnNumber = 3, SqlFieldName = DisCond_HZRS ];

/// 未愈人数串
Property DisCondWYRS As %String [ SqlColumnNumber = 4, SqlFieldName = DisCond_WYRS ];

/// 死亡人数串
Property DisCondSWRS As %String [ SqlColumnNumber = 5, SqlFieldName = DisCond_SWRS ];

/// 创建人
Property DisCondCreator As %String [ SqlColumnNumber = 6, SqlFieldName = DisCond_Creator ];

/// 操作日期
Property DisCondUpDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DisCond_UpDate ];

/// 操作时间
Property DisCondUpTime As %Time [ SqlColumnNumber = 8, SqlFieldName = DisCond_UpTime ];

Index UpDateTimeIndex On (DisCondUpDate, DisCondUpTime);

Storage Default
{
<Data name="DisCondDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DisCondZYRS</Value>
</Value>
<Value name="3">
<Value>DisCondHZRS</Value>
</Value>
<Value name="4">
<Value>DisCondWYRS</Value>
</Value>
<Value name="5">
<Value>DisCondSWRS</Value>
</Value>
<Value name="6">
<Value>DisCondCreator</Value>
</Value>
<Value name="7">
<Value>DisCondUpDate</Value>
</Value>
<Value name="8">
<Value>DisCondUpTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDayTask.DisCondD</DataLocation>
<DefaultData>DisCondDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDayTask.DisCondD</IdLocation>
<IndexLocation>^DHCWL.MRIPDayTask.DisCondI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDayTask.DisCondS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
