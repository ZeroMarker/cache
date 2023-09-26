/// 名称: 动态查询数据 
/// 描述: 用于自定义查询返回数据
/// 编写者：LingChen
/// 编写日期: 2011-01-26
Class EPRservice.dataset.QueryDynTableDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.dao.DQueryDynTable";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/QueryDynTableDataSet";

Parameter QUERYNAME = "QueryByConfig";

Storage Default
{
<Data name="QueryDynTableDataSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice6EC.QueryDynTabl7CFD</DataLocation>
<DefaultData>QueryDynTableDataSetDefaultData</DefaultData>
<IdLocation>^EPRservice6EC.QueryDynTabl7CFD</IdLocation>
<IndexLocation>^EPRservice6EC.QueryDynTabl7CFI</IndexLocation>
<StreamLocation>^EPRservice6EC.QueryDynTabl7CFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
