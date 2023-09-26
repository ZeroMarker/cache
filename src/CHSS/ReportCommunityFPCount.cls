Class CHSS.ReportCommunityFPCount Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ReportCommunityFPCount ]
{

//家庭档案 个人档案  创建数量 临时表

Property CommunityCode As %String(MAXLEN = 100, TRUNCATE = 1);

//其中 DateOfRegister为0 即 1840-12-31 为总数

Property DateOfRegister As %Date(FORMAT = 1);

Property FamilyCount As %Integer;

Property PersonCount As %Integer;

Index CommunityAndDateIndex On (CommunityCode, DateOfRegister);

Index CommunityCodeIndex On CommunityCode;

Storage Default
{
<Data name="ReportCommunityFPCountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommunityCode</Value>
</Value>
<Value name="3">
<Value>DateOfInput</Value>
</Value>
<Value name="4">
<Value>FamilyCount</Value>
</Value>
<Value name="5">
<Value>PersonCount</Value>
</Value>
<Value name="6">
<Value>DateOfRegister</Value>
</Value>
</Data>
<DataLocation>^CHSS.ReportCommunityFPCountD</DataLocation>
<DefaultData>ReportCommunityFPCountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.ReportCommunityFPCountD</IdLocation>
<IndexLocation>^CHSS.ReportCommunityFPCountI</IndexLocation>
<StreamLocation>^CHSS.ReportCommunityFPCountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
