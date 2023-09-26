/// Desc：对外提供病历html文档
/// Creator: Candy
Class EMRservice.InterfaceService.GetHtmlDoc Extends %RegisteredObject
{

/// Desc:获取文件目录
/// Creator:  Candy
/// Input:    AEpisodId 就诊ID 
///           AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Output:   <Categorys><Category><Name>住院病案首页</Name><InstanceID></InstanceID></Category>……</Categorys>
ClassMethod GetDoctorCategory(AEpisodId As %String, AAppCode As %String) As %GlobalBinaryStream
{
	q ##Class(EMRservice.BL.BLHtmlDoc).GetEncRecordCategory(AEpisodId,"WEBDOC")
}

/// Desc:获取文件目录
/// Creator:  Candy
/// Input:    AEpisodId 就诊ID 
///           AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Output:   <Categorys><Category><Name>住院病案首页</Name><InstanceID></InstanceID></Category>……</Categorys>
ClassMethod GetDoctorCategoryRunning(AEpisodId As %String, AAppCode As %String) As %GlobalBinaryStream
{
	q ##Class(EMRservice.BL.BLHtmlDoc).GetEncRecordCategoryRunning(AEpisodId,"WEBDOC")
}

/// Desc:     获取文件目录
/// Creator:  Candy
/// Input:    AEpisodId 就诊ID 
///           AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Output:   <Categorys><Category><Name>住院病案首页</Name><InstanceID></InstanceID></Category>……</Categorys>
ClassMethod GetPatientCategory(AEpisodId As %String, AAppCode As %String) As %GlobalBinaryStream
{
	q ##Class(EMRservice.BL.BLHtmlDoc).GetEncRecordCategory(AEpisodId,"WEBPAT")
}

/// Desc:获取HTML 文档服务
/// Creator:  Candy
/// Input:    AID  病历目录唯一ID
///           AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Output:   HTML
ClassMethod GetHtmlDoc(AID As %String, AAppCode As %String) As %GlobalBinaryStream
{
	q ##Class(EMRservice.BL.BLHtmlDoc).GetHtmlDocument(AID,AAppCode)
}

/// Desc:     获取文件目录
/// Creator:  Candy
/// Input:    AEpisodId 就诊ID 
///           AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Output:   <Categorys><Category><Name>住院病案首页</Name><InstanceID></InstanceID></Category>……</Categorys>
ClassMethod GetPatientCategoryRunning(AEpisodId As %String, AAppCode As %String) As %GlobalBinaryStream
{
	q ##Class(EMRservice.BL.BLHtmlDoc).GetEncRecordCategoryRunning(AEpisodId,"WEBPAT")
}

/// Desc:获取HTML 文档服务
/// Creator:  Candy
/// Input:    AID  病历目录唯一ID
///           AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Output:   HTML
ClassMethod GetHtmlDocRunning(AID As %String, AAppCode As %String) As %GlobalBinaryStream
{
	q ##Class(EMRservice.BL.BLHtmlDoc).GetHtmlDocumentRunning(AID,AAppCode)
}

}
