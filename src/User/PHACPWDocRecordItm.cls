Class User.PHACPWDocRecordItm Extends %Persistent [ SqlTableName = PHACPW_DocRecordItm ]
{

Relationship PCDRIParRef As User.PHACPWDocRecord [ Cardinality = parent, Inverse = ChildPHACPWItm, SqlFieldName = PCDRI_ParRef ];

Property PCDRIRefName As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PCDRI_RefName ];

Property PCDRIRealName As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PCDRI_RealName ];

Property PCDRIRefFilePath As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PCDRI_RefFilePath ];

Storage Default
{
<Data name="PHACPWDocRecordItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCDRIRefName</Value>
</Value>
<Value name="3">
<Value>PCDRIRealName</Value>
</Value>
<Value name="4">
<Value>PCDRIRefFilePath</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>PHACPWDocRecordItmDefaultData</DefaultData>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>^BS.PHA.CPW.DocReci</IndexLocation>
<StreamLocation>^User.PHACPWDocRecordItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
