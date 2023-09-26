Class DHCEPRFS.INST.CheckedRetList Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊表RowID
Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 校验日期
Property CheckDate As %Date [ SqlColumnNumber = 3 ];

/// 校验时间
Property CheckTime As %Time [ SqlColumnNumber = 4 ];

/// 质控类别编码
Property CategoryCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 质控类别名称
Property CategoryName As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 校验结果
Property CheckResult As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 是否必需
Property IsNeeded As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 是否显示全部子项目 - Y:显示全部 N:只显示结果为1的项目
Property ShowItemsStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Index IdxEpisodeID On (EpisodeID, CheckDate, CheckTime);

Index IdxCategoryCode On (EpisodeID, CheckDate, CheckTime, CategoryCode);

Storage Default
{
<Data name="CheckedRetListDefaultData">
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
<Value>CategoryName</Value>
</Value>
<Value name="7">
<Value>CheckResult</Value>
</Value>
<Value name="8">
<Value>IsNeeded</Value>
</Value>
<Value name="9">
<Value>ShowItemsStatus</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CheckedRetListD</DataLocation>
<DefaultData>CheckedRetListDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CheckedRetListD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CheckedRetListI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CheckedRetListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
