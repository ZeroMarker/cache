/// Description： 手术对照结构化数据
/// Creator：张云越
/// Date： 2019-10-22
Class User.MKBOperationContrast Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_OperationContrast ]
{

Relationship MKBOperationResult As User.MKBOperationResult [ Cardinality = children, Inverse = MKBOperationContrast, SqlColumnNumber = 2 ];

/// 手术诊断code
Property MKBOperationConCode As %String [ SqlFieldName = MKB_OperConCode ];

/// 手术描述
Property MKBOperationConDesc As %String(MAXLEN = "") [ SqlFieldName = MKB_OperConDesc ];

/// 手术主要编码
Property MKBOperationConNumber As %String [ SqlFieldName = MKB_OperConNumber ];

/// 手术扩展编码
Property MKBOperationConExtendNumber As %String [ SqlFieldName = MKB_OperConExtendNumber ];

/// 手术来源标识 北京临床-ICD9手术分类临床版(A) 国家标准版-ICD9字典库2011(B)
/// 国家临床1.1-手术操作分类代码(C) 国家临床2.0-手术操作分类代码(D)
Property MKBOperationDiaSource As %String [ SqlFieldName = MKB_OperDiaSource ];

/// 手术类别
Property MKBOperationConType As %String [ SqlFieldName = MKB_OperConType ];

/// 手术录入选项
Property MKBOperationConOption As %String [ SqlFieldName = MKB_OperConOption ];

/// 匹配到的参考中心词
Property MKBOperationConCenterWordID As %String [ SqlFieldName = MKB_OperConCenterWordID ];

/// 国际码指向Term表
Property MKBOperationTermDr As User.MKBTerm [ SqlFieldName = MKB_OperTermDr ];

/// 国际码标记
Property MKBOperationRemark As %String(DISPLAYLIST = ",可匹配,不匹配,无匹配,待匹配", VALUELIST = ",Y,F,N,W") [ SqlFieldName = MKB_OperRemark ];

/// 分词结果
Property MKBOperationConSegmentation As %String(MAXLEN = "") [ SqlFieldName = MKB_OperConSegmentation ];

/// 是否处理
Property MKBOperationConStatus As %String(DISPLAYLIST = ",已处理,未处理,放弃处理,预处理,上报", VALUELIST = ",Y,N,G,P,R") [ SqlFieldName = MKB_OperConStatus ];

/// 操作时间
Property MKBOperationConDate As %Date [ SqlFieldName = MKB_OperConDate ];

/// 操作人
Property MKBOperationConUpdateUser As User.SSUser [ SqlFieldName = MKB_OperConUpdateUser ];

/// 备用
Property MKBOperationOther As %String [ SqlFieldName = MKB_OperOther ];

/// 标识有没有结构化，1为结构化
Property MKBOperationChildStructFlag As %String [ SqlFieldName = MKB_OperChildStructFlag ];

/// 初始编码
Property MKBOperationInitialICD As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlFieldName = MKB_OperInitialICD ];

/// 诊断1 2 3之间的关系 AND OR
Property MKBOperationResultRelation As %String [ SqlFieldName = MKB_OperResultRelation ];

Index DescIndex On MKBOperationConDesc;

Index NumberIndex On MKBOperationConNumber;

Index SegmIndex On MKBOperationConSegmentation As Exact;

Index StructIndex On MKBOperationChildStructFlag As Exact;

Storage Default
{
<Data name="MKBOperationContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBOperationConCode</Value>
</Value>
<Value name="3">
<Value>MKBOperationConDesc</Value>
</Value>
<Value name="4">
<Value>MKBOperationConNumber</Value>
</Value>
<Value name="5">
<Value>MKBOperationConExtendNumber</Value>
</Value>
<Value name="6">
<Value>MKBOperationDiaSource</Value>
</Value>
<Value name="7">
<Value>MKBOperationConType</Value>
</Value>
<Value name="8">
<Value>MKBOperationConOption</Value>
</Value>
<Value name="9">
<Value>MKBOperationConCenterWordID</Value>
</Value>
<Value name="10">
<Value>MKBOperationTermDr</Value>
</Value>
<Value name="11">
<Value>MKBOperationRemark</Value>
</Value>
<Value name="12">
<Value>MKBOperationConSegmentation</Value>
</Value>
<Value name="13">
<Value>MKBOperationConStatus</Value>
</Value>
<Value name="14">
<Value>MKBOperationConDate</Value>
</Value>
<Value name="15">
<Value>MKBOperationConUpdateUser</Value>
</Value>
<Value name="16">
<Value>MKBOperationOther</Value>
</Value>
<Value name="17">
<Value>MKBOperationChildStructFlag</Value>
</Value>
<Value name="18">
<Value>MKBOperationInitialICD</Value>
</Value>
<Value name="19">
<Value>MKBOperationResultRelation</Value>
</Value>
</Data>
<DataLocation>^User.MKBOperationContrastD</DataLocation>
<DefaultData>MKBOperationContrastDefaultData</DefaultData>
<IdLocation>^User.MKBOperationContrastD</IdLocation>
<IndexLocation>^User.MKBOperationContrastI</IndexLocation>
<StreamLocation>^User.MKBOperationContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
