Class User.PHAIPReqTypeItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = PRTI_RowID, SqlTableName = PHAIP_ReqTypeItm ]
{

Relationship ReqTypeItmParRef As User.PHAIPReqType [ Cardinality = parent, Inverse = ChildReqTypeItm, SqlFieldName = ReqTypeItm_ParRef ];

Index PRTISDGDR On PRTISDGDR As Exact;

/// 发药类别指向
Property PRTISDGDR As User.DHCStkDrugGroup [ Required, SqlColumnNumber = 2, SqlFieldName = PRTI_SDG_DR ];

Storage Default
{
<Data name="PHAIPReqTypeItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PRTISDGDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>PHAIPReqTypeItmDefaultData</DefaultData>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>^CF.PHA.IP.ReqTypei</IndexLocation>
<StreamLocation>^CF.PHA.IP.ReqTypes</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
