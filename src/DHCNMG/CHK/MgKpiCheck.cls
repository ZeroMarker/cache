Class DHCNMG.CHK.MgKpiCheck Extends %Persistent
{

Relationship ChildSub As DHCNMG.CHK.MgKpiCheckSub [ Cardinality = children, Inverse = Parref ];

/// 被评组
Property CheckGroupDR As DHCNMG.DB.MgKpiGroup [ Required, SqlColumnNumber = 2, SqlFieldName = Check_GroupDR ];

/// 检查年份
Property CheckYear As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Check_Year ];

/// 检查月份
Property CheckMonth As %String [ Required, SqlColumnNumber = 4, SqlFieldName = Check_Month ];

/// 得分
Property CheckScore As %String [ SqlColumnNumber = 5, SqlFieldName = Check_Score ];

/// 状态 【Y:已评 N:未评】
Property Status As %String(DISPLAYLIST = ",Y,N", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = Status ];

/// 考核Kpi项目【DHCNMG.DB.MgKpiItem】
Property KpiItemDR As DHCNMG.DB.MgKpiItem [ Required, SqlColumnNumber = 7, SqlFieldName = KpiItemDR ];

/// 创建者
Property CreateUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 8, SqlFieldName = Create_User ];

/// 创建日期
Property CreateDate As %Date [ Required, SqlColumnNumber = 9, SqlFieldName = Create_Date ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Submit_Date ];

/// 转换得分
Property CheckTransformScore As %String [ SqlColumnNumber = 11, SqlFieldName = Check_TransformScore ];

Index CheckDate On (CheckGroupDR, CheckYear, CheckMonth);

Index CheckItem On KpiItemDR;

Index CheckStatus On Status;

Storage Default
{
<Data name="MgKpiCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckGroupDR</Value>
</Value>
<Value name="3">
<Value>CheckYear</Value>
</Value>
<Value name="4">
<Value>CheckMonth</Value>
</Value>
<Value name="5">
<Value>CheckScore</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>KpiItemDR</Value>
</Value>
<Value name="8">
<Value>CreateUser</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>SubmitDate</Value>
</Value>
<Value name="11">
<Value>CheckTransformScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgKpiCheckD</DataLocation>
<DefaultData>MgKpiCheckDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgKpiCheckD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgKpiCheckI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgKpiCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
