/// Description： HISICD诊断结构化数据
/// Creator：李得原
/// Date： 2019-03-01
Class User.MKBHISICDContrast Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_HISICDContrast ]
{

Relationship MKBHISICDContrastResult As User.MKBHISICDContrastResult [ Cardinality = children, Inverse = MKBHISICDContrast, SqlColumnNumber = 2 ];

/// HISICD
Property MKBHISICDDr As User.MRCICDDx [ SqlFieldName = MKB_HISICDDr ];

/// ICD
Property MKBHISICD As %String [ SqlFieldName = MKB_HISICD ];

/// ICD中文描述
Property MKBHISICDDesc As %String [ SqlFieldName = MKB_HISICDDesc ];

/// 匹配到的参考中心词
Property MKBHISICDConCenterWordID As User.MKBTerm [ SqlFieldName = MKB_HISICDConCenterWordID ];

/// 国际码指向Term表
Property MKBHISICDTermDr As User.MKBTerm [ SqlFieldName = MKB_HISICDTermDr ];

/// 国际码标记
Property MKBHISICDRemark As %String(DISPLAYLIST = ",可匹配,不匹配,无匹配,待匹配", VALUELIST = ",Y,F,N,W") [ SqlFieldName = MKB_HISICDRemark ];

/// 分词结果
Property MKBHISICDConSegmentation As %String(MAXLEN = "") [ SqlFieldName = MKB_HISICDConSegmentation ];

/// 是否处理
Property MKBHISICDConStatus As %String(DISPLAYLIST = ",已处理,未处理,放弃处理,预处理", VALUELIST = ",Y,N,G,P") [ SqlFieldName = MKB_HISICDConStatus ];

/// 操作时间
Property MKBHISICDConDate As %Date [ SqlFieldName = MKB_HISICDConDate ];

/// 操作人
Property MKBHISICDConUpdateUser As User.SSUser [ SqlFieldName = MKB_HISICDConUpdateUser ];

/// 备用
Property MKBHISICDOther As %String [ SqlFieldName = MKB_HISICDOther ];

/// 初始ICD
Property MKBHISICDInitialICD As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlFieldName = MKB_HISICDInitialICD ];

Index SegmIndex On MKBHISICDConSegmentation As Exact;

Index MRCIndex On MKBHISICDDr As Exact;

Index StatusIndex On MKBHISICDConStatus As Exact;

Storage Default
{
<Data name="MKBHISICDContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBHISICDDr</Value>
</Value>
<Value name="3">
<Value>MKBHISICDConCenterWordID</Value>
</Value>
<Value name="4">
<Value>MKBHISICDTermDr</Value>
</Value>
<Value name="5">
<Value>MKBHISICDRemark</Value>
</Value>
<Value name="6">
<Value>MKBHISICDConSegmentation</Value>
</Value>
<Value name="7">
<Value>MKBHISICDConStatus</Value>
</Value>
<Value name="8">
<Value>MKBHISICDConDate</Value>
</Value>
<Value name="9">
<Value>MKBHISICDConUpdateUser</Value>
</Value>
<Value name="10">
<Value>MKBHISICDOther</Value>
</Value>
<Value name="11">
<Value>MKBHISICDInitialICD</Value>
</Value>
<Value name="12">
<Value>MKBHISICD</Value>
</Value>
<Value name="13">
<Value>MKBHISICDDesc</Value>
</Value>
</Data>
<DataLocation>^User.MKBHISICDContrastD</DataLocation>
<DefaultData>MKBHISICDContrastDefaultData</DefaultData>
<IdLocation>^User.MKBHISICDContrastD</IdLocation>
<IndexLocation>^User.MKBHISICDContrastI</IndexLocation>
<StreamLocation>^User.MKBHISICDContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
