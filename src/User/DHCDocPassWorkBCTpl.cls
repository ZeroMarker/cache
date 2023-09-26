/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 医生交班本模板表
Class User.DHCDocPassWorkBCTpl Extends (%Persistent, User.Abstract)
{

Relationship TPLParRef As User.DHCDocPassWorkBCMain [ Cardinality = parent, Inverse = ChildTPL, Required, SqlFieldName = TPL_ParRef ];

/// URL
Property TPLURL As %String [ SqlColumnNumber = 2, SqlFieldName = TPL_URL ];

/// 描述
Property TPLName As %String [ SqlColumnNumber = 3, SqlFieldName = TPL_Name ];

/// 激活
Property TPLActive As %String [ SqlColumnNumber = 4, SqlFieldName = TPL_Active ];

/// 打印模板
Property TPLRpx As %String [ SqlColumnNumber = 5, SqlFieldName = TPL_Rpx ];

Index TPLURL On TPLURL As Exact;

Storage Default
{
<Data name="DHCDocPassWorkBCTplDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TPLURL</Value>
</Value>
<Value name="3">
<Value>TPLName</Value>
</Value>
<Value name="4">
<Value>TPLActive</Value>
</Value>
<Value name="5">
<Value>TPLRpx</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildTPL")</DataLocation>
<DefaultData>DHCDocPassWorkBCTplDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkBCMainC("ChildTPL")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkBCTplI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkBCTplS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
