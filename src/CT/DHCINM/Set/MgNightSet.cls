/// Creater:wangpf
/// Descriptions:质控排班设置
/// Date:2022-05-13
Class CT.DHCINM.Set.MgNightSet Extends %Persistent
{

/// 质控类型
Property Qual As CT.DHCINM.Set.MgSysParamSub [ SqlColumnNumber = 2, SqlFieldName = Qual ];

/// 节假日
Property Holiday As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Holiday ];

/// 星期
Property Week As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Week ];

/// 优先级
Property Sort As %String [ SqlColumnNumber = 5, SqlFieldName = Sort ];

/// 排除
Property Exclude As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Exclude ];

Index Type On Qual;

Index Sort On Sort;

Storage Default
{
<Data name="MgNightSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Qual</Value>
</Value>
<Value name="3">
<Value>Holiday</Value>
</Value>
<Value name="4">
<Value>Week</Value>
</Value>
<Value name="5">
<Value>Sort</Value>
</Value>
<Value name="6">
<Value>Exclude</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgNightSetD</DataLocation>
<DefaultData>MgNightSetDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.Set.MgNightSetD</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgNightSetI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgNightSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
