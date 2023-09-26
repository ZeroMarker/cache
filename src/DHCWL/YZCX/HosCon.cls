/// 用户表
/// DHCWL_YZCX.DHCWLYZCXHosCon d ##class(DHCWL.YZCX.HosCon).%BuildIndices()
Class DHCWL.YZCX.HosCon Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLYZCXHosCon ]
{

/// 关联用户 HosCon_User_Dr
Property HosConUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = HosCon_User_Dr ];

/// 创建时间  HosCon_CUDate 
Property HosConCUDate As %Date [ SqlColumnNumber = 3, SqlFieldName = HosCon_CUDate ];

Index User On HosConUserDr;

Storage Default
{
<Data name="HosConDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HosConUserDr</Value>
</Value>
<Value name="3">
<Value>HosConCUDate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.YZCX.HosConD</DataLocation>
<DefaultData>HosConDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.YZCX.HosConD</IdLocation>
<IndexLocation>^DHCWL.YZCX.HosConI</IndexLocation>
<StreamLocation>^DHCWL.YZCX.HosConS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
