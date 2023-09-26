/// Creator:Candyxu
/// CreateDate:2012-08
/// Desc: PhotoScan类型的目录
Class EPRservice.dataset.EPTCategoryByPropertyDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.BLTemplateCategory";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPTCategoryByPropertyDataset";

Parameter QUERYNAME = "GetCategoryByProperty";

}
