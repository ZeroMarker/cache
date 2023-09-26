Class CHSS.ReportCommunityPYCCount Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ReportCommunityPYCCount ]
{

//体检统计表   按体检日期和录入日期创建的 临时表

Property CommunityCode As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property Date As %Date(FORMAT = 1) [ SqlColumnNumber = 3 ];

/// 按体检日期
Property CheckCount As %Integer [ SqlColumnNumber = 4 ];

/// 按录入日期
Property FillCount As %Integer [ SqlColumnNumber = 5 ];

Index CommunityAndDateIndex On (CommunityCode, Date);

Index CommunityCodeIndex On CommunityCode;

Storage Default
{
<Data name="ReportCommunityPYCCountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommunityCode</Value>
</Value>
<Value name="3">
<Value>Date</Value>
</Value>
<Value name="4">
<Value>FamilyCount</Value>
</Value>
<Value name="5">
<Value>PersonCount</Value>
</Value>
<Value name="6">
<Value>CheckCount</Value>
</Value>
<Value name="7">
<Value>FillCount</Value>
</Value>
</Data>
<DataLocation>^CHSS.ReportCommunityPYCCountD</DataLocation>
<DefaultData>ReportCommunityPYCCountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.ReportCommunityPYCCountD</IdLocation>
<IndexLocation>^CHSS.ReportCommunityPYCCountI</IndexLocation>
<StreamLocation>^CHSS.ReportCommunityPYCCountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
