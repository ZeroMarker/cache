/// Descriptions:护士长夜查房排班表
/// Date:2018-04-09
/// Creator:guozj
Class DHCNMG.CHK.MgNurHeadSchdule Extends %Persistent
{

Relationship ChildSub As DHCNMG.CHK.MgNurNightTask [ Cardinality = children, Inverse = Parref ];

/// 排班日期
Property CheckDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Check_Date ];

/// 排班组
Property CheckGroup As %String [ SqlColumnNumber = 3, SqlFieldName = Check_Group ];

/// 检查人【人员表ID,安贞第一位检查人，大内科】
Property CheckPerson As %String [ SqlColumnNumber = 4, SqlFieldName = Check_Person ];

/// 排班人
Property CreateUser As %String [ SqlColumnNumber = 5, SqlFieldName = Create_User ];

/// 排班任务
Property CheckWork As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = CheckWork ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

/// 任务组【排到第几个检查病区分组】
Property TaskGroup As %Integer [ SqlColumnNumber = 9, SqlFieldName = Task_Group ];

/// 检查类型【N：夜巡查 W：周末巡查 H：假期巡查】
Property CheckType As %String [ SqlColumnNumber = 10, SqlFieldName = Check_Type ];

/// 检查病区
Property CheckWards As list Of %String [ SqlColumnNumber = 11, SqlFieldName = Check_Wards ];

/// 检查病区分组名称
Property CheckWardGroup As %String [ SqlColumnNumber = 12, SqlFieldName = Check_WardGroup ];

/// 检查人【人员表ID,安贞第一位检查人，大外科】
Property CheckOPerson As %String [ SqlColumnNumber = 13, SqlFieldName = Check_OPerson ];

/// 检查月【201808,安贞：检测每个月不能同一人】
Property CheckMonth As %Integer [ SqlColumnNumber = 14, SqlFieldName = Check_Month ];

/// 早教班检查病区
Property CheckSpecialWard As %String [ SqlColumnNumber = 15, SqlFieldName = Check_SpecialWard ];

/// 状态【""/"Y":生效，"B":作废】
Property CheckStatus As %String [ SqlColumnNumber = 16, SqlFieldName = Check_Status ];

/// 排班序号
Property CheckCount As %Integer [ SqlColumnNumber = 17, SqlFieldName = Check_Count ];

Index date On CheckDate;

Index Type On (CheckType, CheckDate);

Index Per On (CheckType, CheckMonth, CheckPerson);

Index Oper On (CheckType, CheckMonth, CheckOPerson);

Index PerMonth On (CheckPerson, CheckMonth, CheckType);

Index OperMonth On (CheckOPerson, CheckMonth, CheckType);

Index Month On CheckMonth;

Index DateSpecial On (CheckDate, CheckSpecialWard);

Index sort On (CheckDate, CheckCount);

Storage Default
{
<Data name="MgNurHeadSchduleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckDate</Value>
</Value>
<Value name="3">
<Value>CheckGroup</Value>
</Value>
<Value name="4">
<Value>CheckPerson</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>CheckWork</Value>
</Value>
<Value name="9">
<Value>TaskGroup</Value>
</Value>
<Value name="10">
<Value>CheckType</Value>
</Value>
<Value name="11">
<Value>CheckWards</Value>
</Value>
<Value name="12">
<Value>CheckWardGroup</Value>
</Value>
<Value name="13">
<Value>CheckOPerson</Value>
</Value>
<Value name="14">
<Value>CheckMonth</Value>
</Value>
<Value name="15">
<Value>CheckSpecialWard</Value>
</Value>
<Value name="16">
<Value>CheckStatus</Value>
</Value>
<Value name="17">
<Value>CheckCount</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgNurHeadSchduleD</DataLocation>
<DefaultData>MgNurHeadSchduleDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgNurHeadSchduleD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgNurHeadSchduleI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgNurHeadSchduleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
