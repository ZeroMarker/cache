/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生交班本科室表
Class User.DHCDocPassWorkBCLoc Extends (%Persistent, User.Abstract)
{

Relationship BLParRef As User.DHCDocPassWorkBCMain [ Cardinality = parent, Inverse = ChildLoc, Required, SqlFieldName = BL_ParRef ];

/// 科室
Property BLLoc As CTLoc [ SqlColumnNumber = 2, SqlFieldName = BL_Loc ];

Index BLLoc On BLLoc;

Storage Default
{
<Data name="DHCDocPassWorkBCLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BLLoc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildLoc")</DataLocation>
<DefaultData>DHCDocPassWorkBCLocDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkBCMainC("ChildLoc")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkBCLocI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkBCLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
