Class EPRservice.dataset.EKBNodeInUseDataset Extends %XML.DataSet [ ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.BLKBNodeFind";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EKBNodeInUseDataset";

Parameter QUERYNAME = "SELECTInUseBYPARENTID";

Storage Default
{
<Data name="EKBNodeInUseDatasetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice6EC.EKBNodeInUse702D</DataLocation>
<DefaultData>EKBNodeInUseDatasetDefaultData</DefaultData>
<IdLocation>^EPRservice6EC.EKBNodeInUse702D</IdLocation>
<IndexLocation>^EPRservice6EC.EKBNodeInUse702I</IndexLocation>
<StreamLocation>^EPRservice6EC.EKBNodeInUse702S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
