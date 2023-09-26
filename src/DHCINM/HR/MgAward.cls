/// 获奖科研
Class DHCINM.HR.MgAward Extends %Persistent
{

/// 人员档案id
Property AwardPerDR As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Award_PerDR ];

/// 科研成果
Property AwardResult As %String [ SqlColumnNumber = 3, SqlFieldName = Award_Result ];

/// 获奖名称
Property AwardTitle As %String [ SqlColumnNumber = 4, SqlFieldName = Award_Title ];

/// 获奖成绩
Property AwardScore As %String [ SqlColumnNumber = 5, SqlFieldName = Award_Score ];

/// 获奖日期(年)
Property AwardDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Award_Date ];

/// 获奖排序
Property AwardRank As %String [ SqlColumnNumber = 7, SqlFieldName = Award_Rank ];

/// 专利名称
Property AwardPatent As %String [ SqlColumnNumber = 8, SqlFieldName = Award_Patent ];

/// 专利类型
Property AwardPatType As %String [ SqlColumnNumber = 9, SqlFieldName = Award_PatType ];

/// 发表论文
Property AwardThesis As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Award_Thesis ];

/// 出版社
Property AwardPublic As %String [ SqlColumnNumber = 11, SqlFieldName = Award_Public ];

/// 版号页码
Property AwardPage As %String [ SqlColumnNumber = 12, SqlFieldName = Award_Page ];

/// 状态
Property AwardStatus As %String [ SqlColumnNumber = 13, SqlFieldName = Award_Status ];

Property AwardUser As %String [ SqlColumnNumber = 14, SqlFieldName = Award_User ];

/// 科研类型
Property AwardType As %String [ SqlColumnNumber = 15, SqlFieldName = Award_Type ];

/// 题目/名称
Property AwardName As %String [ SqlColumnNumber = 16, SqlFieldName = Award_ ];

Index ssid On AwardPerDR;

Index date On (AwardDate, AwardPerDR);

Storage Default
{
<Data name="MgAwardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AwardPerDR</Value>
</Value>
<Value name="3">
<Value>AwardResult</Value>
</Value>
<Value name="4">
<Value>AwardTitle</Value>
</Value>
<Value name="5">
<Value>AwardScore</Value>
</Value>
<Value name="6">
<Value>AwardDate</Value>
</Value>
<Value name="7">
<Value>AwardRank</Value>
</Value>
<Value name="8">
<Value>AwardPatent</Value>
</Value>
<Value name="9">
<Value>AwardPatType</Value>
</Value>
<Value name="10">
<Value>AwardThesis</Value>
</Value>
<Value name="11">
<Value>AwardPublic</Value>
</Value>
<Value name="12">
<Value>AwardPage</Value>
</Value>
<Value name="13">
<Value>AwardStatus</Value>
</Value>
<Value name="14">
<Value>AwardUser</Value>
</Value>
<Value name="15">
<Value>AwardType</Value>
</Value>
<Value name="16">
<Value>AwardName</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgAwardD</DataLocation>
<DefaultData>MgAwardDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgAwardD</IdLocation>
<IndexLocation>^DHCINM.HR.MgAwardI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgAwardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
