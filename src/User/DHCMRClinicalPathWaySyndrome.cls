/// Creator		: zhaoyu
/// CreateDate	: 2014-07-02
/// Description	: 临床路径合并症、并发症记录
Class User.DHCMRClinicalPathWaySyndrome Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWS_RowId, SqlTableName = DHC_MR_ClinicalPathWaySyndrome ]
{

/// 出入径记录
Relationship CPWSParRef As User.DHCMRClinicalPathWay [ Cardinality = parent, Inverse = ChildSyndrome ];

/// 合并症 complication
Property CPWSCompl1 As %String(MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = CPWS_Compl1 ];

/// 并发症 complication
Property CPWSCompl2 As %String(MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = CPWS_Compl2 ];

/// 填写人
Property CPWSSyndUser As %String [ SqlColumnNumber = 5, SqlFieldName = CPWS_SyndUser ];

/// 填写日期
Property CPWSSyndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CPWS_SyndDate ];

/// 填写时间
Property CPWSSyndTime As %Time [ SqlColumnNumber = 7, SqlFieldName = CPWS_SyndTime ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWSCompl1</Value>
</Value>
<Value name="3">
<Value>CPWSCompl2</Value>
</Value>
<Value name="4">
<Value>CPWSSyndUser</Value>
</Value>
<Value name="5">
<Value>CPWSSyndDate</Value>
</Value>
<Value name="6">
<Value>CPWSSyndTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SYND")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SYND")</IdLocation>
<IndexLocation>^DHCMRi(0,"SYND")</IndexLocation>
<StreamLocation>^User.DHCMRClinicalPathWaySyndromeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
