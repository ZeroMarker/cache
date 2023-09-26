Class User.MKBStructuredDataProLoc Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_StructuredDataProLoc ]
{

/// 子表指向父表字段
Relationship MKBSDStructData As User.MKBStructuredData [ Cardinality = parent, Inverse = MKBSDStructProLoc ];

/// 科室名
Property MKBSDProLoc As %String(MAXLEN = "") [ SqlFieldName = MKBSD_ProLoc ];

/// 科室索引
Index ProLocIndex On (MKBSDProLoc, MKBSDStructData);

Storage Default
{
<Data name="MKBStructuredDataProLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSDProLoc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MKBSDStructProLoc")</DataLocation>
<DefaultData>MKBStructuredDataProLocDefaultData</DefaultData>
<IdLocation>^User.MKBStructuredDataC("MKBSDStructProLoc")</IdLocation>
<IndexLocation>^User.MKBStructuredDataProLocI</IndexLocation>
<StreamLocation>^User.MKBStructuredDataProLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
