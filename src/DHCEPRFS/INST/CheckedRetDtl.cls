Class DHCEPRFS.INST.CheckedRetDtl Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊表RowID
Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 校验日期
Property CheckDate As %Date [ SqlColumnNumber = 3 ];

/// 校验时间
Property CheckTime As %Time [ SqlColumnNumber = 4 ];

/// 质控类别编码
Property CategoryCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 归档病历项目表ID
Property MRItemID As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 归档病历项目编码
Property MRItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 归档病历项目名称
Property MRItemName As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 校验结果
Property CheckResult As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 质控类别校验时是否必需
Property IsNeeded As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Index IdxCategoryCode On (EpisodeID, CheckDate, CheckTime, CategoryCode);

Index IdxMRItemID On (EpisodeID, CheckDate, CheckTime, MRItemID);

Storage Default
{
<Data name="CheckedRetDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>CheckDate</Value>
</Value>
<Value name="4">
<Value>CheckTime</Value>
</Value>
<Value name="5">
<Value>CategoryCode</Value>
</Value>
<Value name="6">
<Value>MRItemID</Value>
</Value>
<Value name="7">
<Value>MRItemCode</Value>
</Value>
<Value name="8">
<Value>MRItemName</Value>
</Value>
<Value name="9">
<Value>CheckResult</Value>
</Value>
<Value name="10">
<Value>IsNeeded</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CheckedRetDtlD</DataLocation>
<DefaultData>CheckedRetDtlDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CheckedRetDtlD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CheckedRetDtlI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CheckedRetDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
