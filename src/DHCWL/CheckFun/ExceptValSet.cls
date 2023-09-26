/// 考核例外值设置表
/// DHCWL_CheckFun.DHCWLExceptValSet d ##class(DHCWL.CheckFun.ExceptValSet).%BuildIndices()
Class DHCWL.CheckFun.ExceptValSet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLExceptValSet ]
{

/// 关联考核标准值设置表 ExpValSet_Std_Dr
Property ExpValSetStdDr As DHCWL.CheckFun.StandardValSet [ SqlColumnNumber = 2, SqlFieldName = ExpValSet_Std_Dr ];

/// 关联BS维护的考核对象 ExpValSet_Obj_Dr
Property ExpValSetObjDr As %String [ SqlColumnNumber = 3, SqlFieldName = ExpValSet_Obj_Dr ];

/// 例外值               ExpValSet_Value
Property ExpValSetValue As %String [ SqlColumnNumber = 4, SqlFieldName = ExpValSet_Value ];

/// 更新日期             ExpValSet_UpdateDate
Property ExpValSetUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ExpValSet_UpdateDate ];

/// 更新用户             ExpValSet_UpdateUser
Property ExpValSetUpdateUser As %String [ SqlColumnNumber = 6, SqlFieldName = ExpValSet_UpdateUser ];

Index Stand On ExpValSetStdDr As AlphaUp;

Index StandObject On (ExpValSetStdDr, ExpValSetObjDr);

Index UpdateDate On ExpValSetUpdateDate;

Index UpdateUser On ExpValSetUpdateUser;

Storage Default
{
<Data name="ExceptValSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExpValSetStdDr</Value>
</Value>
<Value name="3">
<Value>ExpValSetObjDr</Value>
</Value>
<Value name="4">
<Value>ExpValSetValue</Value>
</Value>
<Value name="5">
<Value>ExpValSetUpdateDate</Value>
</Value>
<Value name="6">
<Value>ExpValSetUpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CheckFun.ExceptValSetD</DataLocation>
<DefaultData>ExceptValSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CheckFun.ExceptValSetD</IdLocation>
<IndexLocation>^DHCWL.CheckFun.ExceptValSetI</IndexLocation>
<StreamLocation>^DHCWL.CheckFun.ExceptValSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
