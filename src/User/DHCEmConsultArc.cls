Class User.DHCEmConsultArc Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmConsultArc ]
{

/// 子表ID
Property ECParRefDr As User.DHCEmConsultItm;

/// 医嘱项ID
Property ECArcDr As User.ARCItmMast;

/// 子表索引
Index IndexPar On ECParRefDr;

Storage Default
{
<Data name="DHCEmConsultArcDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECParRefDr</Value>
</Value>
<Value name="3">
<Value>ECArcDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmConsultArcD</DataLocation>
<DefaultData>DHCEmConsultArcDefaultData</DefaultData>
<IdLocation>^User.DHCEmConsultArcD</IdLocation>
<IndexLocation>^User.DHCEmConsultArcI</IndexLocation>
<StreamLocation>^User.DHCEmConsultArcS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
