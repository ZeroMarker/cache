/// Creator:李欣
/// CreateDate:20180504
/// Desc:医用知识库引用表
Class User.MKBReference Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBR_RowId, SqlTableName = MKB_Reference ]
{

/// 引用发起者标识(DISPLAYLIST = ",术语库表,术语库属性表,术语库扩展属性表,术语表,术语属性表,术语扩展属性表,属性内容表,映射注册表,映射字段表,映射明细表,数据处理工厂子表,HISICD对照子表,结构化诊断表,结构化诊断子表,各版本ICD对照,各版本ICD对照子表", MAXLEN = 3, SELECTIVITY = "%14.286", VALUELIST = ",B,BP,BE,T,P,E,D,MB,MF,MD,SDR,ICD,SDS,SDSP,ICDX,ICDXR") 
Property MKBROriginalFlag As %String [ Required, SqlColumnNumber = 2, SqlFieldName = MKBR_OriginalFlag ];

/// 引用发起者RowId
Property MKBROriginalID As %String [ Required, SqlColumnNumber = 3, SqlFieldName = MKBR_OriginalID ];

/// 引用作用者/引用受体/被引用者 标识(DISPLAYLIST = ",术语库表,术语库属性表,术语库扩展属性表,术语表,术语属性表,术语扩展属性表,属性内容表,文献管理表,评估表,映射注册表,数据处理工厂表,各版本ICD对照", MAXLEN = 3, SELECTIVITY = "%14.286", VALUELIST = ",B,BP,BE,T,P,E,D,DOC,ASS,MB,SD,ICDXR") 
Property MKBRReferFlag As %String [ Required, SqlColumnNumber = 4, SqlFieldName = MKBR_ReferFlag ];

/// 引用作用者/引用受体/被引用者 RowId
Property MKBRReferID As %String [ Required, SqlColumnNumber = 5, SqlFieldName = MKBR_ReferID ];

Index OriginalIndex On (MKBROriginalFlag As Exact, MKBROriginalID As Exact);

Index ReferIndex On (MKBRReferFlag As Exact, MKBRReferID As Exact);

Index AllIndex On (MKBROriginalFlag As Exact, MKBROriginalID As Exact, MKBRReferFlag As Exact, MKBRReferID As Exact);

Index InverAllIndex On (MKBRReferFlag As Exact, MKBRReferID As Exact, MKBROriginalFlag As Exact, MKBROriginalID As Exact);

Storage Default
{
<Data name="MKBReferenceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBROriginalFlag</Value>
</Value>
<Value name="3">
<Value>MKBROriginalID</Value>
</Value>
<Value name="4">
<Value>MKBRReferFlag</Value>
</Value>
<Value name="5">
<Value>MKBRReferID</Value>
</Value>
</Data>
<DataLocation>^User.MKBReferenceD</DataLocation>
<DefaultData>MKBReferenceDefaultData</DefaultData>
<IdLocation>^User.MKBReferenceD</IdLocation>
<IndexLocation>^User.MKBReferenceI</IndexLocation>
<StreamLocation>^User.MKBReferenceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
