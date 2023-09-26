/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityQuery
/// * Description:	质控检查条件服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityQuery Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityQueryInfo";

///  *****************************************************
///  功能：获取所有质控检查条件
///  *****************************************************
ClassMethod SelectAllQualityQueries() As EPRservice.dataset.Quality.EQualityQueryDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.Quality.EQualityQueryDataset).%New()
	d result.SetArgs()
	q result
}

///  *****************************************************
///  功能：创建新质控检查方法
///  *****************************************************
ClassMethod CreateQualityQuery(AQuery As EPRservice.entity.Quality.EQualityQuery) As %String [ WebMethod ]
{
	TSTART
	s objChkQuery = ##class(EPRmeta.Quality.QualityQuery).%New()
	q:(objChkQuery = "") "ERROR"
	 
	s flag = ##class(EPRmeta.Quality.QualityQuery).CheckCodeUnique(AQuery.Code) 
 	if '(flag = 0)
 	{ 
 		q "-1"
 	} 
	s objChkQuery.Code = AQuery.Code
	s objChkQuery.Name = AQuery.Name
	s objChkQuery.QueryEx = AQuery.QueryEx
	s objChkQuery.IsActive = AQuery.IsActive
	s objChkQuery.ResumeText = AQuery.ResumeText

 	if '(objChkQuery.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objChkQuery.%Id()
}

///  *****************************************************
///  功能：根据ID删除质控检查条件
///  入参：AId为质控检查条件表QualityQuery的ID
///  *****************************************************
ClassMethod DeleteQualityQueryById(AId As %String) As %Boolean [ WebMethod ]
{
	TSTART
 	s objChkQuery = ##class(EPRmeta.Quality.QualityQuery).%OpenId(AId)
	q:(objChkQuery ="") 0 

 	if '(objChkQuery.%DeleteId(AId))
 	{
 		TROLLBACK
 		q 0
 	} 
 	TCOMMIT
 	q 1
}

///  *****************************************************
///  功能：更新质控检查方法
///  *****************************************************
ClassMethod UpdateQualityQuery(AQuery As EPRservice.entity.Quality.EQualityQuery) As %String [ WebMethod ]
{
	TSTART
	s objChkQuery = ##class(EPRmeta.Quality.QualityQuery).%OpenId(AQuery.ID)
	q:(objChkQuery = "") "ERROR"
	
	s objChkQuery.Name = AQuery.Name
	s objChkQuery.QueryEx = AQuery.QueryEx
	s objChkQuery.IsActive = AQuery.IsActive
	s objChkQuery.ResumeText = AQuery.ResumeText
	
	if '(objChkQuery.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

}
