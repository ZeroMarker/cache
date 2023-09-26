/// Creater:wangpf
/// Descriptions:手册审阅
/// Date:2020-07-08
Class DHCINM.HB.MgBookCheck Extends %Persistent
{

/// 审阅年度
Property CheckYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Check_Year ];

/// 审阅管联人员
Property CheckPerson As CF.DHCINM.HR.Persons [ SqlColumnNumber = 3, SqlFieldName = Check_Person ];

/// 审阅项目
Property CheckItem As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Check_Item ];

/// 审阅意见
Property CheckReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Check_Reason ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 6, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

Index YearPer On (CheckYear, CheckPerson);

Storage Default
{
<Data name="MgBookCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckYear</Value>
</Value>
<Value name="3">
<Value>CheckPerson</Value>
</Value>
<Value name="4">
<Value>CheckItem</Value>
</Value>
<Value name="5">
<Value>CheckReason</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgBookCheckD</DataLocation>
<DefaultData>MgBookCheckDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgBookCheckD</IdLocation>
<IndexLocation>^DHCINM.HB.MgBookCheckI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgBookCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
