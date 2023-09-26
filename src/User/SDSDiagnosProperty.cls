/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断子表-属性及属性内容
/// Table：User.SDSDiagnosProperty
Class User.SDSDiagnosProperty Extends (%Persistent, User.Abstract) [ SqlTableName = SDS_DiagnosProperty ]
{

Relationship ParRefDiagnos As User.SDSDiagnos [ Cardinality = parent, Inverse = ChildProperty ];

/// 指向术语属性,仅维护诊断模板中的属性
Property SDSPropertyDR As MKBTermProperty [ SqlColumnNumber = 2, SqlFieldName = SDS_Property_DR ];

/// 术语属性内容id
Property SDSProDetail As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = SDS_ProDetail ];

/// 标识,区分内容为属性内容id还是术语id
Property SDSFlag As %String(DISPLAYLIST = ",属性内容,术语", VALUELIST = ",D,T") [ SqlColumnNumber = 4, SqlFieldName = SDS_Flag ];

Index ChildIndex On (ParRefDiagnos As Exact, SDSPropertyDR As Exact, SDSProDetail As Exact);

Storage Default
{
<Data name="SDSDiagnosPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDSPropertyDR</Value>
</Value>
<Value name="3">
<Value>SDSProDetail</Value>
</Value>
<Value name="4">
<Value>SDSFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildProperty")</DataLocation>
<DefaultData>SDSDiagnosPropertyDefaultData</DefaultData>
<IdLocation>^User.SDSDiagnosC("ChildProperty")</IdLocation>
<IndexLocation>^User.SDSDiagnosPropertyI</IndexLocation>
<StreamLocation>^User.SDSDiagnosPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
