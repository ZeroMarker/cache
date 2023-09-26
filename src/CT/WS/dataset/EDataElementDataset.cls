Class CT.WS.dataset.EDataElementDataset Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "CT.WS.DataElement";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EDataElementDataset";

Parameter QUERYNAME = "SelectAllByCategoryID";

Storage Default
{
<Data name="EDataElementDatasetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.WS.dataset.EDataElemen9A67D</DataLocation>
<DefaultData>EDataElementDatasetDefaultData</DefaultData>
<IdLocation>^CT.WS.dataset.EDataElemen9A67D</IdLocation>
<IndexLocation>^CT.WS.dataset.EDataElemen9A67I</IndexLocation>
<StreamLocation>^CT.WS.dataset.EDataElemen9A67S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
