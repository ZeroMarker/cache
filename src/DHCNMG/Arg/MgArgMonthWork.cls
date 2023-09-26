/// Creator:gzj
/// Date:2018-07-20
/// Decriptions:护士月报工作量登记表父表
Class DHCNMG.Arg.MgArgMonthWork Extends %Persistent [ Owner = {dhpm1} ]
{

Relationship ChildSub As DHCNMG.Arg.MgArgMonthWorkSub [ Cardinality = children, Inverse = Parref ];

/// 月报日期（取数据按月份提取）
Property WorkMonth As %Date [ SqlColumnNumber = 2, SqlFieldName = Work_Month ];

/// 病区
Property WorkWard As %String [ SqlColumnNumber = 3, SqlFieldName = Work_Ward ];

/// 状态 【保存N 护理组长提交G 提交Y 驳回B】
Property RecStatus As %String [ SqlColumnNumber = 4, SqlFieldName = Rec_Status ];

/// 本月科室检查不足方面
Property WardQuestion As %String(MAXLEN = 2000) [ SqlColumnNumber = 5, SqlFieldName = Ward_Question ];

/// 科室改进措施
Property WardMeasure As %String(MAXLEN = 2000) [ SqlColumnNumber = 6, SqlFieldName = Ward_Measure ];

/// 检查者
Property CheckUsers As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Check_Users ];

/// 护士长
Property NurHeader As %String [ SqlColumnNumber = 8, SqlFieldName = Nur_Header ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 9, SqlFieldName = Create_Date ];

/// 有效标识【保存、提交、驳回都为Y  删除为N】
Property Status As %String [ SqlColumnNumber = 10, SqlFieldName = Status ];

/// 创建者
Property CreateUser As %String [ SqlColumnNumber = 11, SqlFieldName = Create_User ];

/// 提交人
Property SubmitUser As %String [ SqlColumnNumber = 12, SqlFieldName = Submit_User ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Submit_Date ];

/// 驳回内容
Property BackContent As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Back_Content ];

/// 驳回人
Property BackUser As %String [ SqlColumnNumber = 15, SqlFieldName = Back_User ];

/// 驳回日期
Property BackDate As %Date [ SqlColumnNumber = 16, SqlFieldName = Back_Date ];

/// 驳回时间
Property BackTime As %Time [ SqlColumnNumber = 17, SqlFieldName = Back_Time ];

Index status On (Status, WorkMonth, WorkWard);

Storage Default
{
<Data name="MgArgMonthWorkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkMonth</Value>
</Value>
<Value name="3">
<Value>WorkWard</Value>
</Value>
<Value name="4">
<Value>RecStatus</Value>
</Value>
<Value name="5">
<Value>WardQuestion</Value>
</Value>
<Value name="6">
<Value>WardMeasure</Value>
</Value>
<Value name="7">
<Value>CheckUsers</Value>
</Value>
<Value name="8">
<Value>NurHeader</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>CreateUser</Value>
</Value>
<Value name="12">
<Value>SubmitUser</Value>
</Value>
<Value name="13">
<Value>SubmitDate</Value>
</Value>
<Value name="14">
<Value>BackContent</Value>
</Value>
<Value name="15">
<Value>BackUser</Value>
</Value>
<Value name="16">
<Value>BackDate</Value>
</Value>
<Value name="17">
<Value>BackTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArgMonthWorkD</DataLocation>
<DefaultData>MgArgMonthWorkDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgArgMonthWorkD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArgMonthWorkI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArgMonthWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
