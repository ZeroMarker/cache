Class DHCEPRFS.Entity.EMRItem Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 归档病历项目名称
Property Name As %String(TRUNCATE = 1);

/// 归档病历项目编码
Property Code As %String(TRUNCATE = 1);

/// 归档病历项目描述
Property Description As %String(TRUNCATE = 1);

/// 归档病历子类ID
Property MRSubCategoryID As %String(TRUNCATE = 1);

/// 归档病历项目类型(可以与集中打印类型一致)
Property Type As %String(TRUNCATE = 1);

/// 归档病历项目类型参数配置(比如电子病历的打印模板ID,参数格式可以自定义)
Property TypeParams As %String(TRUNCATE = 1);

/// 媒体类型，为空表示PDF文档，OTHER表示不分类，MP3，MP4等
Property MediaType As %String(TRUNCATE = 1);

}
