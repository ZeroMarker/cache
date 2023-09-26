/// Creator:石萧伟
/// CreatDate:2019-07-18
/// Description：工厂注册
/// Table：User.MKBStructuredBase
Class User.MKBStructuredBase Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_StructuredBase ]
{

/// 标题
Property MKBSTBDesc As %String(MAXLEN = "") [ SqlFieldName = MKBSTB_Desc ];

/// ICD知识库指向
Property MKBSTBICDDr As User.MKBTerm [ SqlFieldName = MKBSTB_ICD_Dr ];

/// 结构化模块知识库指向
Property MKBSTBStrDr As User.MKBTerm [ SqlFieldName = MKBSTB_Str_Dr ];

/// 当前医院 （不用了）
Property MKBSTBFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlFieldName = MKBSTB_Flag ];

/// 数据来源配置项	配置项1,配置项2
Property MKBSTBSource As %String(MAXLEN = "") [ SqlFieldName = MKBSTB_Source ];

/// 是否录入非标ICD诊断(弃用)
Property MKBSTBNonstandardFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlFieldName = MKBSTB_NonstandardFlag ];

/// 实际科室指向
Property MKBSTBLocDr As User.MKBTerm [ SqlFieldName = MKBSTB_Loc_Dr ];

/// 标识，区分手术和诊断工厂
Property MKBSTBODFlag As %String(MAXLEN = "") [ SqlFieldName = MKBSTB_ODFlag ];

/// 描述索引
Index DescIndex On MKBSTBDesc [ Unique ];

/// 当前医院索引
Index FlagIndex On MKBSTBFlag;

Storage Default
{
<Data name="MKBStructuredBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSTBDesc</Value>
</Value>
<Value name="3">
<Value>MKBSTBICDDr</Value>
</Value>
<Value name="4">
<Value>MKBSTBStrDr</Value>
</Value>
<Value name="5">
<Value>MKBSTBFlag</Value>
</Value>
<Value name="6">
<Value>MKBSTBSource</Value>
</Value>
<Value name="7">
<Value>MKBSTBNonstandardFlag</Value>
</Value>
<Value name="8">
<Value>MKBSTBLocDr</Value>
</Value>
<Value name="9">
<Value>MKBSTBODFlag</Value>
</Value>
</Data>
<DataLocation>^User.MKBStructuredBaseD</DataLocation>
<DefaultData>MKBStructuredBaseDefaultData</DefaultData>
<IdLocation>^User.MKBStructuredBaseD</IdLocation>
<IndexLocation>^User.MKBStructuredBaseI</IndexLocation>
<StreamLocation>^User.MKBStructuredBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
