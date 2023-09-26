/// DHCWL_MKPI.DHCWLCreatDataTask  k ^DHCWL.MKPI.CreatDataTaskI  d ##class(DHCWL.MKPI.CreatDataTask).%BuildIndices()
Class DHCWL.MKPI.CreatDataTask Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLCreatDataTask ]
{

/// 指标
Property DTaskKPIDR As DHCWL.MKPI.MKPI [ SqlColumnNumber = 2, SqlFieldName = DTask_KPI_DR ];

/// 区间
Property DTaskSectionDR As DHCWL.MKPI.Section [ SqlColumnNumber = 3, SqlFieldName = DTask_Section_DR ];

/// 执行代码
Property DTaskExcuteCode As %String [ SqlColumnNumber = 4, SqlFieldName = DTask_ExcuteCode ];

/// 激活标记
Property DTaskActiveFlag As %String [ SqlColumnNumber = 5, SqlFieldName = DTask_ActiveFlag ];

/// 执行区间代码
Property DTaskMonthExcuteCode As %String [ SqlColumnNumber = 6, SqlFieldName = DTask_MonthExcuteCode ];

/// 	执行代码Id。V4.1之后不再使用DTaskExcuteCode字段，而将相应的执行代码对应的执行代码表DHCWL_MKPI.MKPI_ExecuteCode的Id存于此。
Property DTaskExcuteCodeDR As DHCWL.MKPI.ExecuteCode [ SqlColumnNumber = 7, SqlFieldName = DTask_ExcuteCode_DR ];

Index KPI On (DTaskKPIDR, DTaskActiveFlag);

Index Section On (DTaskSectionDR, DTaskActiveFlag);

Index SectionKPI On (DTaskSectionDR, DTaskKPIDR, DTaskActiveFlag);

Storage Default
{
<Data name="CreatDataTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DTaskActiveFlag</Value>
</Value>
<Value name="3">
<Value>DTaskExcuteCode</Value>
</Value>
<Value name="4">
<Value>DTaskKPIDR</Value>
</Value>
<Value name="5">
<Value>DTaskSectionDR</Value>
</Value>
<Value name="6">
<Value>DTaskMonthExcuteCode</Value>
</Value>
<Value name="7">
<Value>DTaskExcuteCodeDR</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.CreatDataTaskD</DataLocation>
<DefaultData>CreatDataTaskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.CreatDataTaskD</IdLocation>
<IndexLocation>^DHCWL.MKPI.CreatDataTaskI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.CreatDataTaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
