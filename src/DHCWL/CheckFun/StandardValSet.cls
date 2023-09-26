/// 考核标准值设置表
/// DHCWL_CheckFun.DHCWLStandardValSet d ##class(DHCWL.CheckFun.StandardValSet).%BuildIndices()
Class DHCWL.CheckFun.StandardValSet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLStandardValSet ]
{

/// 关联考核方案表  StandardValSet_Set_Dr
Property StandardValSetSetDr As DHCWL.CheckFun.CheckSet [ SqlColumnNumber = 2, SqlFieldName = StandardValSet_Set_Dr ];

/// 关联考核指标表  StandardValSet_KPI_Dr
Property StandardValSetKPIDr As DHCWL.CheckFun.CheckKPI [ SqlColumnNumber = 3, SqlFieldName = StandardValSet_KPI_Dr ];

/// 标准值          StandardValSet_Value
Property StandardValSetValue As %String [ SqlColumnNumber = 4, SqlFieldName = StandardValSet_Value ];

/// 生效日期        StandardValSet_Date
Property StandardValSetDate As %String [ SqlColumnNumber = 5, SqlFieldName = StandardValSet_Date ];

/// 更新日期        StandardValSet_UpdateDate
Property StandardValSetUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = StandardValSet_UpdateDate ];

/// 更新用户        StandardValSet_UpdateUser
Property StandardValSetUpdateUser As %String [ SqlColumnNumber = 7, SqlFieldName = StandardValSet_UpdateUser ];

Index Set On StandardValSetSetDr As AlphaUp;

Index KPI On StandardValSetKPIDr As AlphaUp;

Index Date On StandardValSetDate;

Index SetKPI On (StandardValSetSetDr, StandardValSetKPIDr);

Index SetKPIDate On (StandardValSetSetDr, StandardValSetKPIDr, StandardValSetDate);

Index UpdateDate On StandardValSetUpdateDate;

Index UpdateUser On StandardValSetUpdateUser;

Index SetDateKPI On (StandardValSetSetDr, StandardValSetDate, StandardValSetKPIDr);

Storage Default
{
<Data name="StandardValSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StandardValSetSetDr</Value>
</Value>
<Value name="3">
<Value>StandardValSetKPIDr</Value>
</Value>
<Value name="4">
<Value>StandardValSetValue</Value>
</Value>
<Value name="5">
<Value>StandardValSetDate</Value>
</Value>
<Value name="6">
<Value>StandardValSetUpdateDate</Value>
</Value>
<Value name="7">
<Value>StandardValSetUpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CheckFun.StandardValSetD</DataLocation>
<DefaultData>StandardValSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CheckFun.StandardValSetD</IdLocation>
<IndexLocation>^DHCWL.CheckFun.StandardValSetI</IndexLocation>
<StreamLocation>^DHCWL.CheckFun.StandardValSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
