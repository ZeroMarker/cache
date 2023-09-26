Class User.DHCPEHomeTimeTeam Extends %Persistent [ SqlTableName = DHC_PE_HomeTimeTeam ]
{

Relationship HTTParRef As User.DHCPEPreHomeTimeInfo [ Cardinality = parent, Inverse = PHTTeam ];

/// 分组
Property HTTPTeamDR As User.DHCPEPreGTeam [ Required, SqlColumnNumber = 2, SqlFieldName = HTT_PTeam_DR ];

/// 数量_男
Property HTTNumMale As %Integer [ SqlColumnNumber = 3, SqlFieldName = HTT_Num_Male ];

/// 数量_女
Property HTTNumFemale As %Integer [ SqlColumnNumber = 4, SqlFieldName = HTT_Num_Female ];

/// 标志位  同一标志位的记录共享限额
Property HTTTag As %String(COLLATION = "EXACT", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HTT_Tag ];

Index IndOfParTeam On (HTTParRef, HTTPTeamDR) [ Unique ];

Storage Default
{
<Data name="DHCPEHomeTimeTeamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HTTPTeamDR</Value>
</Value>
<Value name="3">
<Value>HTTNumMale</Value>
</Value>
<Value name="4">
<Value>HTTNumFemale</Value>
</Value>
<Value name="5">
<Value>HTTTag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PHTTeam")</DataLocation>
<DefaultData>DHCPEHomeTimeTeamDefaultData</DefaultData>
<IdLocation>^User.DHCPEPreHomeTimeInfoC("PHTTeam")</IdLocation>
<IndexLocation>^User.DHCPEHomeTimeTeamI</IndexLocation>
<StreamLocation>^User.DHCPEHomeTimeTeamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
