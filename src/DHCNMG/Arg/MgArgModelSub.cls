/// creator:xbl
/// createdate:20170829
/// description:排班模板明细
Class DHCNMG.Arg.MgArgModelSub Extends %Persistent
{

/// 排班记录 
Property ArrangeDR As DHCNMG.Arg.MgArgModel [ SqlColumnNumber = 2, SqlFieldName = Arrange_DR ];

/// 排班行记录
Property ArgRow As %Integer [ SqlColumnNumber = 3, SqlFieldName = Arg_Row ];

/// 日期
Property ArgWeek As %Integer [ SqlColumnNumber = 4, SqlFieldName = Arg_Week ];

/// 班次类型
Property ArgType As %String [ SqlColumnNumber = 5, SqlFieldName = Arg_Type ];

/// 班次id
Property ArgCode As %String [ SqlColumnNumber = 6, SqlFieldName = Arg_Code ];

/// 开始时间
Property ArgStTime1 As %Time [ SqlColumnNumber = 7, SqlFieldName = Arg_StTime1 ];

/// 结束时间
Property ArgEndTime1 As %Time [ SqlColumnNumber = 8, SqlFieldName = Arg_EndTime1 ];

/// 开始时间
Property ArgStTime2 As %Time [ SqlColumnNumber = 9, SqlFieldName = Arg_StTime2 ];

/// 结束时间
Property ArgEndTime2 As %Time [ SqlColumnNumber = 11, SqlFieldName = Arg_EndTime2 ];

/// 开始时间
Property ArgStTime3 As %Time [ SqlColumnNumber = 12, SqlFieldName = Arg_StTime3 ];

/// 结束时间
Property ArgEndTime3 As %Time [ SqlColumnNumber = 13, SqlFieldName = Arg_EndTime3 ];

/// 备注
Property ArgRemark As %String [ SqlColumnNumber = 14, SqlFieldName = Arg_Remark ];

/// 负责床位信息
Property ArgBeds As %String [ SqlColumnNumber = 15, SqlFieldName = Arg_Beds ];

Storage Default
{
<Data name="MgArgModelSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeDR</Value>
</Value>
<Value name="3">
<Value>ArgRow</Value>
</Value>
<Value name="4">
<Value>ArgWeek</Value>
</Value>
<Value name="5">
<Value>ArgType</Value>
</Value>
<Value name="6">
<Value>ArgCode</Value>
</Value>
<Value name="7">
<Value>ArgStTime1</Value>
</Value>
<Value name="8">
<Value>ArgEndTime1</Value>
</Value>
<Value name="9">
<Value>ArgStTime2</Value>
</Value>
<Value name="10">
<Value>ArgEndTime2</Value>
</Value>
<Value name="11">
<Value>ArgStTime3</Value>
</Value>
<Value name="12">
<Value>ArgEndTime3</Value>
</Value>
<Value name="13">
<Value>ArgRemark</Value>
</Value>
<Value name="14">
<Value>ArgBeds</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArgModelSubD</DataLocation>
<DefaultData>MgArgModelSubDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgArgModelSubD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArgModelSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArgModelSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
