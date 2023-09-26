/// 日间手术参数配置表
/// 基础数据平台-李可凡
/// 2021-05-08
Class User.ORCDaySurgeryConfig Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSC_RowId, SqlTableName = ORC_DaySurgeryConfig ]
{

/// 代码
Property DSCCode As %String(MAXLEN = "") [ Required, SqlColumnNumber = 2, SqlFieldName = DSC_Code ];

/// 名称
Property DSCName As %String(MAXLEN = "") [ Required, SqlColumnNumber = 3, SqlFieldName = DSC_Name ];

/// 内容
Property DSCContent As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = DSC_Content ];

/// 参数说明
Property DSCExplain As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = DSC_Explain ];

/// 代码索引
Index DSCCodeIndex On DSCCode As Exact;

/// 名称索引
Index DSCNameIndex On DSCName As Exact;

Storage Default
{
<Data name="ORCDaySurgeryConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSCCode</Value>
</Value>
<Value name="3">
<Value>DSCName</Value>
</Value>
<Value name="4">
<Value>DSCContent</Value>
</Value>
<Value name="5">
<Value>DSCExplain</Value>
</Value>
</Data>
<DataLocation>^User.ORCDaySurgeryConfigD</DataLocation>
<DefaultData>ORCDaySurgeryConfigDefaultData</DefaultData>
<IdLocation>^User.ORCDaySurgeryConfigD</IdLocation>
<IndexLocation>^User.ORCDaySurgeryConfigI</IndexLocation>
<StreamLocation>^User.ORCDaySurgeryConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
