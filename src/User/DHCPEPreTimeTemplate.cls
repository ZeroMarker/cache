Class User.DHCPEPreTimeTemplate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock, SqlTableName = DHC_PE_PreTimeTemplate ]
{

Parameter ClassName = "User.DHCPEPreTimeTemplate";

Relationship PTTParRef As User.DHCPEPreTemplate [ Cardinality = parent, Inverse = PTTimeChild ];

/// 开始时间
Property PTTStartTime As %Library.Time [ Required, SqlFieldName = PTT_StartTime ];

/// 结束时间
Property PTTEndTime As %Library.Time [ Required, SqlFieldName = PTT_EndTime ];

/// 数量
Property PTTNum As %Integer [ SqlFieldName = PTT_Num ];

/// 数量_男
Property PTTNumMale As %Integer [ SqlFieldName = PTT_Num_Male ];

/// 数量_女
Property PTTNumFemale As %Integer [ SqlFieldName = PTT_Num_Female ];

Storage Default
{
<Data name="DHCPEPreTimeTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PTTStartTime</Value>
</Value>
<Value name="3">
<Value>PTTEndTime</Value>
</Value>
<Value name="4">
<Value>PTTNum</Value>
</Value>
<Value name="5">
<Value>PTTNumMale</Value>
</Value>
<Value name="6">
<Value>PTTNumFemale</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PTTimeChild")</DataLocation>
<DefaultData>DHCPEPreTimeTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreTemplateC("PTTimeChild")</IdLocation>
<IndexLocation>^User.DHCPEPreTimeTemplateI</IndexLocation>
<StreamLocation>^User.DHCPEPreTimeTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
