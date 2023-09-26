Class User.DHCMDTGroupICD Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MG_RowID, SqlTableName = DHC_MDTGroupICD ]
{

/// 分组指针  MG_Group_Dr
Property MGGroupDr As User.DHCMDTGroup [ SqlColumnNumber = 2, SqlFieldName = MG_Group_Dr ];

/// 癌种  MG_CType 
Property MGICDDr As User.MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = MG_ICD_Dr ];

Index IndexParef On MGGroupDr;

Index IndexICD On MGICDDr;

Storage Default
{
<Data name="DHCMDTGroupICDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MGGroupDr</Value>
</Value>
<Value name="3">
<Value>MGICDDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMDTGroupICDD</DataLocation>
<DefaultData>DHCMDTGroupICDDefaultData</DefaultData>
<IdLocation>^User.DHCMDTGroupICDD</IdLocation>
<IndexLocation>^User.DHCMDTGroupICDI</IndexLocation>
<StreamLocation>^User.DHCMDTGroupICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
