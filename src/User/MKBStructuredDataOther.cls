/// Description： 别名/其他描述
/// Creator：石萧伟
/// Date： 2019-04-20
Class User.MKBStructuredDataOther Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_StructuredDataOther ]
{

/// 子表指向父表字段
Relationship MKBSDStructData As User.MKBStructuredData [ Cardinality = parent, Inverse = MKBSDStructOther ];

/// 名称
Property MKBSDOther As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Other ];

/// 备注
Property MKBSDOtherNote As %String(MAXLEN = "") [ SqlFieldName = MKBSD_OtherNote ];

/// 检索码
Property MKBSDOtherCode As %String(MAXLEN = "") [ SqlFieldName = MKBSD_OtherCode ];

/// 标识
Property MKBSDOtherMark As %String(DISPLAYLIST = ",别名,其他描述", VALUELIST = ",AN,OD") [ SqlFieldName = MKBSD_OtherMark ];

Index OtherMark On (MKBSDOtherMark As Exact, MKBSDStructData As Exact);

Storage Default
{
<Data name="MKBStructuredDataOtherDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSDOther</Value>
</Value>
<Value name="3">
<Value>MKBSDOtherNote</Value>
</Value>
<Value name="4">
<Value>MKBSDOtherCode</Value>
</Value>
<Value name="5">
<Value>MKBSDOtherMark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MKBSDStructOther")</DataLocation>
<DefaultData>MKBStructuredDataOtherDefaultData</DefaultData>
<IdLocation>^User.MKBStructuredDataC("MKBSDStructOther")</IdLocation>
<IndexLocation>^User.MKBStructuredDataOtherI</IndexLocation>
<StreamLocation>^User.MKBStructuredDataOtherS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
