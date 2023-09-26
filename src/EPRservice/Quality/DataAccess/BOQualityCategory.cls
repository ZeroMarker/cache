Class EPRservice.Quality.DataAccess.BOQualityCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityCategoryInfo";

/// Function:	Get all quality categories
ClassMethod GetAllCategories() As EPRservice.dataset.Quality.EQualityCategoryDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.EQualityCategoryDataset).%New()
	q result
}

ClassMethod GetCategoryById(ACategoryID As %String) As EPRservice.entity.Quality.EQualityCategory [ WebMethod ]
{
	s objCategory = ##class(EPRmeta.Quality.QualityCategory).%OpenId(ACategoryID)
	q:(objCategory = "") ""
	
	s category = ##Class(EPRservice.entity.Quality.EQualityCategory).%New()
	s category.ID = objCategory.%Id()
	s category.ParentId = objCategory.ParentId
	s category.Name = objCategory.Name
	s category.Score = objCategory.Score
	s category.IsActive = objCategory.IsActive
	s category.ResumeText = objCategory.ResumeText
	
 	q category
}

ClassMethod CreateQualityCategory(ACategory As EPRservice.entity.Quality.EQualityCategory) As %String [ WebMethod ]
{
	TSTART
	s objCategory=##Class(EPRmeta.Quality.QualityCategory).%New()
	q:(objCategory = "") "ERROR"
	
	s objCategory.Name = ACategory.Name	
	s objCategory.Score = ACategory.Score		
	s objCategory.ParentId = ACategory.ParentId					//父节点ID
	s objCategory.IsActive = ACategory.IsActive
	s objCategory.ResumeText = ACategory.ResumeText
 	if '(objCategory.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objCategory.%Id()
}

ClassMethod UpdateQualityCategory(ACategory As EPRservice.entity.Quality.EQualityCategory) As %String [ WebMethod ]
{
	TSTART
	s objCategory = ##class(EPRmeta.Quality.QualityCategory).%OpenId(ACategory.ID)
	q:(objCategory = "") "ERROR"
	 
	s objCategory.Name = ACategory.Name
	s objCategory.ParentId = ACategory.ParentId
	s objCategory.Score = ACategory.Score
	s objCategory.IsActive = ACategory.IsActive
	s objCategory.ResumeText = ACategory.ResumeText

 	if '(objCategory.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

ClassMethod DeleteQualityCategory(ACategoryId As %String) As %String [ WebMethod ]
{
	s flag = ##Class(EPRmeta.Quality.QualityCategory).DeleteQualityCategory(ACategoryId)
	q flag
}

}
