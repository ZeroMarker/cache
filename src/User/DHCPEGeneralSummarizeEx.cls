Class User.DHCPEGeneralSummarizeEx Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_GeneralSummarizeEx ]
{

Parameter ClassName = "User.DHCPEGeneralSummarizeEx";

///  总检结论ID
Property GSEGeneralSummarizeID As User.DHCPEGeneralSummarize [ Required, SqlFieldName = GSE_GeneralSummarizeID ];

///  人员分类
Property GSEConclusionID As User.DHCPEConclusion [ SqlFieldName = GSE_ConclusionID ];

///  目标疾病
Property GSEOMEIllness As User.DHCPEOMEIllness [ SqlFieldName = GSE_OMEIllness ];

/// 诊断标准
Property GSEDCID As User.DHCPEDiagnosticCriteria [ SqlFieldName = GSE_DCID ];

/// 处理意见
Property GSESuggestions As %String(MAXLEN = 1000) [ SqlFieldName = GSE_Suggestions ];

/// 检查结果
Property GSETestResult As %String(MAXLEN = 1000) [ SqlFieldName = GSE_TestResult ];

/// 临床表现
Property GSEClinical As %String(MAXLEN = 1000) [ SqlFieldName = GSE_Clinical ];

/// 职业病史
Property GSEOccupationalHistory As %String(MAXLEN = 200) [ SqlFieldName = GSE_OccupationalHistory ];

/// 操作员
Property GSEUserID As User.SSUser [ SqlFieldName = GSE_UserID ];

/// 操作日期
Property GSEDate As %Date [ Required, SqlFieldName = GSE_Date ];

/// 操作时间
Property GSETime As %Time [ SqlFieldName = GSE_Time ];

/// 描述型结论(职业病结论)
Property GSEConclusionDesc As %String [ SqlFieldName = GSE_ConclusionDesc ];

///  总检结论索引
Index GeneralSummarizeID On GSEGeneralSummarizeID As AlphaUp;

/// 人员分类索引
Index ConclusionIndex On GSEConclusionID;

/// 日期索引
Index GSEDateIndex On GSEDate;

Storage Default
{
<Data name="DHCPEGeneralSummarizeExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GSEGeneralSummarizeID</Value>
</Value>
<Value name="3">
<Value>GSEConclusionID</Value>
</Value>
<Value name="4">
<Value>GSEOMEIllness</Value>
</Value>
<Value name="5">
<Value>GSEDCID</Value>
</Value>
<Value name="6">
<Value>GSESuggestions</Value>
</Value>
<Value name="7">
<Value>GSETestResult</Value>
</Value>
<Value name="8">
<Value>GSEClinical</Value>
</Value>
<Value name="9">
<Value>GSEOccupationalHistory</Value>
</Value>
<Value name="10">
<Value>GSEUserID</Value>
</Value>
<Value name="11">
<Value>GSEDate</Value>
</Value>
<Value name="12">
<Value>GSETime</Value>
</Value>
<Value name="13">
<Value>GSEConclusionDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGeneralSummarizeExD</DataLocation>
<DefaultData>DHCPEGeneralSummarizeExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEGeneralSummarizeExD</IdLocation>
<IndexLocation>^User.DHCPEGeneralSummarizeExI</IndexLocation>
<StreamLocation>^User.DHCPEGeneralSummarizeExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
