Class User.DHCPEPreHomeTimeInfo Extends %Persistent [ SqlTableName = DHC_PE_HomeTimeInfo ]
{

Relationship PHTParRef As User.DHCPEPreHomeInfo [ Cardinality = parent, Inverse = PGTimeInfo ];

Relationship PHTTeam As User.DHCPEHomeTimeTeam [ Cardinality = children, Inverse = HTTParRef ];

/// 开始时间
Property PHStartTime As %Library.Time [ Required, SqlFieldName = PH_StartTime ];

/// 结束时间
Property PHEndTime As %Library.Time [ Required, SqlFieldName = PH_EndTime ];

/// 数量_男
Property PHNumMale As %Integer [ SqlFieldName = PH_Num_Male ];

/// 数量_女
Property PHNumFemale As %Integer [ SqlFieldName = PH_Num_Female ];

Index IndOfSTime On (PHTParRef, PHStartTime) [ Unique ];

Storage Default
{
<Data name="DHCPEPreHomeTimeInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PHStartTime</Value>
</Value>
<Value name="3">
<Value>PHEndTime</Value>
</Value>
<Value name="4">
<Value>PHNumMale</Value>
</Value>
<Value name="5">
<Value>PHNumFemale</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PGTimeInfo")</DataLocation>
<DefaultData>DHCPEPreHomeTimeInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreHomeInfoC("PGTimeInfo")</IdLocation>
<IndexLocation>^User.DHCPEPreHomeTimeInfoI</IndexLocation>
<StreamLocation>^User.DHCPEPreHomeTimeInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
