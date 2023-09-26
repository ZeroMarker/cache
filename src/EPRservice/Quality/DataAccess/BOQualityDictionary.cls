/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityDictionary
/// * Description:	质控基础字典服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityDictionary Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityDicInfo";

///  *****************************************************
///  功能：获取所有质控基础字典
///  *****************************************************
ClassMethod SelectAllQualityDics() As EPRservice.dataset.Quality.EQualityDicDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.Quality.EQualityDicDataset).%New()
	q result
}

///  *****************************************************
///  功能：根据基础字典ID获取基础字典对象
///  *****************************************************
ClassMethod GetQualityDicByID(AID As %String) As EPRservice.entity.Quality.EQualityDic [ WebMethod ]
{
	q:(AID = "") ""
	s objDictionary = ##class(EPRmeta.Quality.QualityDictionary).%OpenId(AID)
	q:(objDictionary = "") ""
	
	s Result = ##class(EPRservice.entity.Quality.EQualityDic).%New()
	s Result.ID = objDictionary.%Id()
	s Result.Code = objDictionary.Code
	s Result.ParentId = objDictionary.ParentId
	s Result.Name = objDictionary.Name
	s Result.IsActive = objDictionary.IsActive
	s Result.ResumeText = objDictionary.ResumeText
	s objDictionary=""
	
 	q Result
}

///  *****************************************************
///  功能：根据基础字典代码获取基础字典对象
///  *****************************************************
/// do ##Class(EPRservice.Quality.DataAccess.BOQualityDictionary).GetQualityDicByCode("OrderType")
ClassMethod GetQualityDicByCode(ACode As %String) As EPRservice.entity.Quality.EQualityDic [ WebMethod ]
{
	s dicID = $O(^DHCEPRM.QualityDicI("IdxCode",ACode,""))
 	q:dicID="" ""
    
	s dic= ##class(EPRmeta.Quality.QualityDictionary).%OpenId(dicID) //$G(^DHCEPRM.QualityDicD(dicID))

	s objQualityDic = ##class(EPRservice.entity.Quality.EQualityDic).%New()
	s objQualityDic.ID = dicID
	s objQualityDic.Code = dic.Code  //$LIST(dic,1)
	s objQualityDic.ParentId = dic.ParentId  //$LIST(dic,2)
	s objQualityDic.Name = dic.Name  //$LIST(dic,3)
	s objQualityDic.IsActive = dic.IsActive  //$LIST(dic,4)
	s objQualityDic.ResumeText = dic.ResumeText  //$LIST(dic,5)
	
 	q objQualityDic
}

///  *****************************************************
///  功能：创建基础字典项目
///  *****************************************************
ClassMethod CreateQualityDic(ADictionary As EPRservice.entity.Quality.EQualityDic) As %String [ WebMethod ]
{
	TSTART
	s objDictionary = ##Class(EPRmeta.Quality.QualityDictionary).%New()
	
	s objDictionary.ParentId = ADictionary.ParentId
	s objDictionary.Code = ADictionary.Code
	s objDictionary.Name = ADictionary.Name
	s objDictionary.IsActive = ADictionary.IsActive
	s objDictionary.ResumeText = ADictionary.ResumeText

 	if '(objDictionary.%Save())
 	{
 		TROLLBACK
 		Quit "0"
 	} 
 	TCOMMIT
 	q objDictionary.%Id()
}

///  *****************************************************
///  功能：修改基础字典项目
///  ***************************************************** 
ClassMethod UpdateQualityDic(ADictionary As EPRservice.entity.Quality.EQualityDic) As %String [ WebMethod ]
{
	TStart
	s objDictionary = ##Class(EPRmeta.Quality.QualityDictionary).%OpenId(ADictionary.ID)
	
	s objDictionary.ParentId = ADictionary.ParentId
	s objDictionary.Code = ADictionary.Code
	s objDictionary.Name = ADictionary.Name
	s objDictionary.IsActive = ADictionary.IsActive
	s objDictionary.ResumeText = ADictionary.ResumeText
	
	if '(objDictionary.%Save())
 	{
 		TRollBack
 		q "0"
 	} 
 	TCommit
 	q objDictionary.%Id()
}

///  *****************************************************
///  功能：删除基础字典项目
///  ***************************************************** 
ClassMethod DeleteQualityDic(AQuaDictionaryId As %String) As %String [ WebMethod ]
{
	s flag = ##class(EPRmeta.Quality.QualityDictionary).DeleteQualityDictionary(AQuaDictionaryId)
	q flag
}

/// Desc:根据code取其子节点
/// Creator:Candyxu
/// CreateDate:2012-11-27
/// Input:PCode
ClassMethod GetDicByParentID(pCode As %String) As EPRservice.dataset.Quality.EQualityGradeItemDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.Quality.EQualityGradeItemDataset).%New()
	d result.SetArgs(pCode)
	q result
}

}
