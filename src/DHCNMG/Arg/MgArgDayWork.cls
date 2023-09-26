/// Creator:llin
/// Date:2018-08-11
/// Decriptions:护士日报工作量登记表
Class DHCNMG.Arg.MgArgDayWork Extends %Persistent [ Owner = {dhpm1} ]
{

/// 代码
Property WorkCode As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Work_Code ];

/// 描述
Property WorkDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Work_Desc ];

/// 日报日期（取数据按日提取）
Property WorkDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Work_Date ];

/// 病区
Property WorkWard As %Integer [ SqlColumnNumber = 5, SqlFieldName = Work_Ward ];

/// 排序
Property WorkSort As %Integer [ SqlColumnNumber = 6, SqlFieldName = Work_Sort ];

/// 数量
Property WorkNum As %String [ SqlColumnNumber = 7, SqlFieldName = Work_Num ];

/// 备注
Property WorkRemark As %String [ SqlColumnNumber = 8, SqlFieldName = Work_Remark ];

Index Ward On (WorkWard, WorkDate, WorkSort);

Index Date On (WorkDate, WorkWard, WorkSort);

Index WardSort On (WorkWard, WorkSort, WorkDate);

Index SortDate On (WorkSort, WorkDate, WorkWard);

Storage Default
{
<Data name="MgArgDayWorkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkCode</Value>
</Value>
<Value name="3">
<Value>WorkDesc</Value>
</Value>
<Value name="4">
<Value>WorkDate</Value>
</Value>
<Value name="5">
<Value>WorkWard</Value>
</Value>
<Value name="6">
<Value>WorkSort</Value>
</Value>
<Value name="7">
<Value>WorkNum</Value>
</Value>
<Value name="8">
<Value>WorkRemark</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArgDayWorkD</DataLocation>
<DefaultData>MgArgDayWorkDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgArgDayWorkD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArgDayWorkI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArgDayWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
