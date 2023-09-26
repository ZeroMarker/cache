Class User.DHCDocReAdmRulesLoc Extends (%Persistent, User.Abstract)
{

/// 规则id
Property RARLRule As User.DHCDocReAdmRulesSet [ SqlColumnNumber = 2, SqlFieldName = RARL_Rule ];

/// 规则绑定科室
Property RARLLoc As CTLoc [ SqlColumnNumber = 3, SqlFieldName = RARL_Loc ];

/// 院区
Property RARHospDr As CTHospital [ SqlColumnNumber = 4, SqlFieldName = RARL_HospDr ];

Storage Default
{
<Data name="DHCDocReAdmRulesLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RARLRule</Value>
</Value>
<Value name="3">
<Value>RARLLoc</Value>
</Value>
<Value name="4">
<Value>RARHospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocReAdmRulesLocD</DataLocation>
<DefaultData>DHCDocReAdmRulesLocDefaultData</DefaultData>
<IdLocation>^User.DHCDocReAdmRulesLocD</IdLocation>
<IndexLocation>^User.DHCDocReAdmRulesLocI</IndexLocation>
<StreamLocation>^User.DHCDocReAdmRulesLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
