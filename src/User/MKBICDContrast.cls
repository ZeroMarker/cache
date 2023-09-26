/// Description： ICD诊断结构化数据
/// Creator：李得原
/// Date： 2019-05-17
Class User.MKBICDContrast Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_ICDContrast ]
{

Relationship MKBICDContrastResult As User.MKBICDContrastResult [ Cardinality = children, Inverse = MKBICDContrast, SqlColumnNumber = 2 ];

/// ICD诊断code
Property MKBICDConCode As %String [ SqlFieldName = MKB_ICDConCode ];

/// ICD描述
Property MKBICDConDesc As %String(MAXLEN = "") [ SqlFieldName = MKB_ICDConDesc ];

/// ICD主要编码
Property MKBICDConNumber As %String [ SqlFieldName = MKB_ICDConNumber ];

/// ICD扩展编码
Property MKBICDConExtendNumber As %String [ SqlFieldName = MKB_ICDConExtendNumber ];

/// ICD来源标识
Property MKBICDDiaSource As %String [ SqlFieldName = MKB_ICDDiaSource ];

/// ICD类别
Property MKBICDConType As %String [ SqlFieldName = MKB_ICDConType ];

/// ICD录入选项
Property MKBICDConOption As %String [ SqlFieldName = MKB_ICDConOption ];

/// 匹配到的参考中心词
Property MKBICDConCenterWordID As %String [ SqlFieldName = MKB_ICDConCenterWordID ];

/// 国际码指向Term表
Property MKBICDTermDr As User.MKBTerm [ SqlFieldName = MKB_ICDTermDr ];

/// 国际码标记
Property MKBICDRemark As %String(DISPLAYLIST = ",可匹配,不匹配,无匹配,待匹配", VALUELIST = ",Y,F,N,W") [ SqlFieldName = MKB_ICDRemark ];

/// 分词结果
Property MKBICDConSegmentation As %String(MAXLEN = "") [ SqlFieldName = MKB_ICDConSegmentation ];

/// 是否处理
Property MKBICDConStatus As %String(DISPLAYLIST = ",已处理,未处理,放弃处理,预处理,上报", VALUELIST = ",Y,N,G,P,R") [ SqlFieldName = MKB_ICDConStatus ];

/// 操作时间
Property MKBICDConDate As %Date [ SqlFieldName = MKB_ICDConDate ];

/// 操作人
Property MKBICDConUpdateUser As User.SSUser [ SqlFieldName = MKB_ICDConUpdateUser ];

/// 备用
Property MKBICDOther As %String [ SqlFieldName = MKB_ICDOther ];

/// 标识有没有结构化，1为结构化
Property MKBICDChildStructFlag As %String [ SqlFieldName = MKB_ICDChildStructFlag ];

/// 初始ICD
Property MKBICDInitialICD As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlFieldName = MKB_ICDInitialICD ];

/// 诊断1 2 3之间的关系 AND OR
Property MKBICDResultRelation As %String [ SqlFieldName = MKB_ICDResultRelation ];

Index DescIndex On MKBICDConDesc;

Index NumberIndex On MKBICDConNumber;

Index SegmIndex On MKBICDConSegmentation As Exact;

Index StructIndex On MKBICDChildStructFlag As Exact;

Index InitialICDIndex On MKBICDInitialICD As Exact;

Storage Default
{
<Data name="MKBICDContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBICDConCode</Value>
</Value>
<Value name="3">
<Value>MKBICDConDesc</Value>
</Value>
<Value name="4">
<Value>MKBICDConNumber</Value>
</Value>
<Value name="5">
<Value>MKBICDConExtendNumber</Value>
</Value>
<Value name="6">
<Value>MKBICDDiaSource</Value>
</Value>
<Value name="7">
<Value>MKBICDConType</Value>
</Value>
<Value name="8">
<Value>MKBICDConOption</Value>
</Value>
<Value name="9">
<Value>MKBICDConCenterWordID</Value>
</Value>
<Value name="10">
<Value>MKBICDTermDr</Value>
</Value>
<Value name="11">
<Value>MKBICDRemark</Value>
</Value>
<Value name="12">
<Value>MKBICDConSegmentation</Value>
</Value>
<Value name="13">
<Value>MKBICDConStatus</Value>
</Value>
<Value name="14">
<Value>MKBICDConDate</Value>
</Value>
<Value name="15">
<Value>MKBICDConUpdateUser</Value>
</Value>
<Value name="16">
<Value>MKBICDOther</Value>
</Value>
<Value name="17">
<Value>MKBICDInitialICD</Value>
</Value>
<Value name="18">
<Value>MKBICDChildStructFlag</Value>
</Value>
<Value name="19">
<Value>MKBICDResultRelation</Value>
</Value>
</Data>
<DataLocation>^User.MKBICDContrastD</DataLocation>
<DefaultData>MKBICDContrastDefaultData</DefaultData>
<IdLocation>^User.MKBICDContrastD</IdLocation>
<IndexLocation>^User.MKBICDContrastI</IndexLocation>
<StreamLocation>^User.MKBICDContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
