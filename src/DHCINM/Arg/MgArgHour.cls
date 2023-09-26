/// Creater:wangpf
/// Descriptions:初始化积假设置
/// Date:2020-08-04
Class DHCINM.Arg.MgArgHour Extends %Persistent
{

/// 排班人
Property ArgPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Arg_Person ];

/// 生效日期
Property ArgDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Arg_Date ];

/// 积假
Property ArgHour As %String [ SqlColumnNumber = 4, SqlFieldName = Arg_Hour ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 5, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = Create_Time ];

Index Date On (ArgDate, ArgPer);

Index Per On (ArgPer, ArgDate);

Storage Default
{
<Data name="MgArgHourDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArgPer</Value>
</Value>
<Value name="3">
<Value>ArgDate</Value>
</Value>
<Value name="4">
<Value>ArgHour</Value>
</Value>
<Value name="5">
<Value>Creator</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgArgHourD</DataLocation>
<DefaultData>MgArgHourDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgArgHourD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgArgHourI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgArgHourS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
