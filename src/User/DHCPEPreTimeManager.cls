Class User.DHCPEPreTimeManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock, SqlTableName = DHC_PE_PreTimeManager ]
{

Parameter ClassName = "User.DHCPEPreTimeManager";

Relationship PTMParRef As User.DHCPEPreManager [ Cardinality = parent, Inverse = PMTimeChild ];

/// 开始时间
Property PTMStartTime As %Library.Time [ Required, SqlFieldName = PTM_StartTime ];

/// 结束时间
Property PTMEndTime As %Library.Time [ Required, SqlFieldName = PTM_EndTime ];

/// 数量
Property PTMNum As %Integer [ SqlFieldName = PTM_Num ];

/// 数量_男
Property PTMNumMale As %Integer [ SqlFieldName = PTM_Num_Male ];

/// 数量_女
Property PTMNumFemale As %Integer [ SqlFieldName = PTM_Num_Female ];

Storage Default
{
<Data name="DHCPEPreTimeManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PTMStartTime</Value>
</Value>
<Value name="3">
<Value>PTMEndTime</Value>
</Value>
<Value name="4">
<Value>PTMNum</Value>
</Value>
<Value name="5">
<Value>PTMNumMale</Value>
</Value>
<Value name="6">
<Value>PTMNumFemale</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PMTimeChild")</DataLocation>
<DefaultData>DHCPEPreTimeManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreManagerC("PMTimeChild")</IdLocation>
<IndexLocation>^User.DHCPEPreTimeManagerI</IndexLocation>
<StreamLocation>^User.DHCPEPreTimeManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
