Class User.DHCMRClinicalPathWayResult Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWR_RowId, SqlTableName = DHC_MR_ClinicalPathWayResult ]
{

Relationship CPWRParRef As User.DHCMRClinicalPathWay [ Cardinality = parent, Inverse = ChildRst, SqlFieldName = CPWR_ParRef ];

/// 保存日期
Property CPWRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CPWR_Date ];

/// 保存时间
Property CPWRTime As %Time [ SqlColumnNumber = 4, SqlFieldName = CPWR_Time ];

/// 保存人 Table:SSUser
Property CPWRUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CPWR_UserDR ];

/// 症状改善
Property CPWRZZGSDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CPWR_ZZGSDR ];

/// 体征改善
Property CPWRTZGSDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CPWR_TZGSDR ];

/// 理化指标
Property CPWRLHZBDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPWR_LHZBDR ];

/// 转归情况
Property CPWRZGQKDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPWR_ZGGSDR ];

/// 症状改善描述
Property CPWRResumeText As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPWR_ResumeText ];

/// 记录key-value模式的评估结果：dicid-value //add by wuqk 2011-09-26 
/// 存储方式 $lb("id1:val1","id2:val2",.....)
Property CPWREvaluations As %String(MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CPWR_Evaluation ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWRDate</Value>
</Value>
<Value name="3">
<Value>CPWRTime</Value>
</Value>
<Value name="4">
<Value>CPWRUserDR</Value>
</Value>
<Value name="5">
<Value>CPWRZZGSDR</Value>
</Value>
<Value name="6">
<Value>CPWRTZGSDR</Value>
</Value>
<Value name="7">
<Value>CPWRLHZBDR</Value>
</Value>
<Value name="8">
<Value>CPWRZGQKDR</Value>
</Value>
<Value name="9">
<Value>CPWRResumeText</Value>
</Value>
<Value name="10">
<Value>CPWREvaluations</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RST")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RST")</IdLocation>
<IndexLocation>^DHCMRi(0,"RST")</IndexLocation>
<SqlChildSub>CPWR_Childsub</SqlChildSub>
<SqlRowIdName>CPWR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRClinicaA74S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
