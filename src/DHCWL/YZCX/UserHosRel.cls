/// 用户分院关系表
/// DHCWL_YZCX.DHCWLYZCXUserHosRel d ##class(DHCWL.YZCX.UserHosRel).%BuildIndices()
Class DHCWL.YZCX.UserHosRel Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLYZCXUserHosRel ]
{

/// 关联用户配置表 DHCWL.YZCX.HosCon
Property UHRUserDr As DHCWL.YZCX.HosCon [ SqlColumnNumber = 2, SqlFieldName = UHR_User_Dr ];

/// 关联病区表
Property UHRHospDr As User.CTHospital [ SqlColumnNumber = 3, SqlFieldName = UHR_Hosp_Dr ];

/// 创建时间  HosCon_CUDate 
Property UHRCUDate As %Date [ SqlColumnNumber = 4, SqlFieldName = UHR_CUDate ];

Index User On UHRUserDr;

Index Hosp On UHRHospDr;

Index UserHos On (UHRUserDr, UHRHospDr);

Storage Default
{
<Data name="UserHosRelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UHRUserDr</Value>
</Value>
<Value name="3">
<Value>UHRHospDr</Value>
</Value>
<Value name="4">
<Value>UHRCUDate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.YZCX.UserHosRelD</DataLocation>
<DefaultData>UserHosRelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.YZCX.UserHosRelD</IdLocation>
<IndexLocation>^DHCWL.YZCX.UserHosRelI</IndexLocation>
<StreamLocation>^DHCWL.YZCX.UserHosRelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
