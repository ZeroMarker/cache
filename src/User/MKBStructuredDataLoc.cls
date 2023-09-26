/// Description： 结构化数据科室频次子表
/// Creator：石萧伟
/// Date： 2019-04-05
Class User.MKBStructuredDataLoc Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_StructuredDataLoc ]
{

/// 子表指向父表字段
Relationship MKBSDStructData As User.MKBStructuredData [ Cardinality = parent, Inverse = MKBSDStructLoc ];

/// 科室名
Property MKBSDLoc As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Loc ];

/// 诊断出现频次
Property MKBSDFrequency As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Frequency ];

/// 科室来源标识
Property MKBSDLocSource As %String(DISPLAYLIST = ",住院,出院,门/急诊", VALUELIST = ",I,L,O") [ SqlFieldName = MKBSD_LocSource ];

Property DiagName As %String;

/// 科室索引
Index LocIndex On (MKBSDLoc, MKBSDStructData);

/// 科室频次父表索引
Index LocFreIndex On (MKBSDLoc As exact, MKBSDFrequency As exact, MKBSDStructData As exact);

Index NewLocIndex On (MKBSDStructData, MKBSDLoc);

Storage Default
{
<Data name="MKBStructuredDataLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSDLoc</Value>
</Value>
<Value name="3">
<Value>MKBSDFrequency</Value>
</Value>
<Value name="4">
<Value>MKBSDLocSource</Value>
</Value>
<Value name="5">
<Value>DiagName</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MKBSDStructLoc")</DataLocation>
<DefaultData>MKBStructuredDataLocDefaultData</DefaultData>
<IdLocation>^User.MKBStructuredDataC("MKBSDStructLoc")</IdLocation>
<IndexLocation>^User.MKBStructuredDataLocI</IndexLocation>
<StreamLocation>^User.MKBStructuredDataLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
