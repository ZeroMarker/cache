/// Creator:李得原
/// CreateDate:20190927
/// Desc:全局化词表引用表
Class User.MKBGlobalReference Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBGR_Rowid, SqlTableName = MKB_GlobalReference ]
{

/// 发起引用，主动引用标识
Property InitiativeFlag As %String(DISPLAYLIST = ",知识库表,术语库表,术语库公有属性,术语库私有属性,术语库属性内容表,ICD2.0,数据处理工厂", MAXLEN = 6, SELECTIVITY = "%14.286", VALUELIST = ",TB,T,PTP,NPTP,D,ICDCon,ICDSD") [ Required, SqlFieldName = MKB_InitiativeFlag ];

/// 发起引用词的ID
Property InitiativeID As %String [ Required, SqlFieldName = MKB_InitiativeID ];

/// 被引用词的ID
Property PassiveID As %String [ Required, SqlFieldName = MKB_PassiveID ];

/// 被引用词的名称列表ID
Property PassiveAliasID As %String [ SqlFieldName = MKB_PassiveAliasID ];

Index AllIndex On (InitiativeFlag As Exact, InitiativeID As Exact, PassiveID As Exact);

Index InverAllIndex On (PassiveID As Exact, InitiativeFlag As Exact, InitiativeID As Exact);

Index PassiveAliasIndex On (PassiveID As Exact, PassiveAliasID As Exact, InitiativeFlag As Exact, InitiativeID As Exact);

Storage Default
{
<Data name="MKBGlobalReferenceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InitiativeFlag</Value>
</Value>
<Value name="3">
<Value>InitiativeID</Value>
</Value>
<Value name="4">
<Value>PassiveID</Value>
</Value>
<Value name="5">
<Value>PassiveAliasID</Value>
</Value>
</Data>
<DataLocation>^User.MKBGlobalReferenceD</DataLocation>
<DefaultData>MKBGlobalReferenceDefaultData</DefaultData>
<IdLocation>^User.MKBGlobalReferenceD</IdLocation>
<IndexLocation>^User.MKBGlobalReferenceI</IndexLocation>
<StreamLocation>^User.MKBGlobalReferenceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
