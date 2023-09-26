/// 临床路径阶段
Class User.DHCMRCClinPathWaysEp Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = EP_RowId, SqlTableName = DHC_MRC_ClinPathWaysEp ]
{

Relationship ChildStep As User.DHCMRCClinPathWaysEpStep [ Cardinality = children, Inverse = CPWSParRef ];

/// EPParRef
Relationship EPParRef As User.DHCMRCClinPathWays [ Cardinality = parent, Inverse = ChildEP, SqlFieldName = EP_ParRef ];

/// 阶段描述
Property EPDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EP_Desc ];

/// 阶段序号
Property EPEpisode As %Float [ SqlColumnNumber = 3, SqlFieldName = EP_Episode ];

/// 阶段备注
Property EPNotes As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EP_Notes ];

Index IndexEpisode On (EPParRef As Exact, EPEpisode As Exact);

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPChildsub</Value>
</Value>
<Value name="3">
<Value>EPDesc</Value>
</Value>
<Value name="4">
<Value>EPEpisode</Value>
</Value>
<Value name="5">
<Value>EPNotes</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EP")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("EP")</IdLocation>
<IndexLocation>^DHCMRCi("CPW",0,"EP")</IndexLocation>
<SqlChildSub>EP_Childsub</SqlChildSub>
<SqlRowIdName>EP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPathWaysEpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
