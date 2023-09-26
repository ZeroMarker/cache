/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityParams
/// * Description:	质控常量参数服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityParams Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityParamsInfo";

///  *****************************************************
///  功能：获取所有质控常量参数
///  *****************************************************
ClassMethod SelectAllConstParms() As EPRservice.dataset.Quality.EQualityParamsDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.Quality.EQualityParamsDataset).%New()
	d result.SetArgs()
	q result
}

///  *****************************************************
///  功能：根据参数代码获取所有质控常量参数信息
///  *****************************************************
ClassMethod GetParamByCode(ACode As %String) As EPRservice.entity.Quality.EQualityParam [ WebMethod ]
{
	s param = ##Class(EPRservice.entity.Quality.EQualityParam).%New()
	
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode",ACode,""))
	q:(ParamID = "") param
	s objParam = ##Class(EPRmeta.Quality.QualityParams).%OpenId(ParamID)
	q:(objParam = "") param
	
	s param.ID = objParam.%Id()
	s param.Code = objParam.Code
	s param.Name = objParam.Name
	s param.BindValue = objParam.BindValue
	s param.IsActive = objParam.IsActive
	s param.ResumeText = objParam.ResumeText
	
	q param
}

///  *****************************************************
///  功能：创建常量参数
///  *****************************************************
ClassMethod CreateConstParms(AParam As EPRservice.entity.Quality.EQualityParam) As %String [ WebMethod ]
{
	TSTART
	s objQualityParam = ##class(EPRmeta.Quality.QualityParams).%New()
	q:(objQualityParam = "") "ERROR"
	 
	s flag = ##class(EPRmeta.Quality.QualityParams).CheckCodeUnique(AParam.Code) 
 	if '(flag = 0)
 	{ 
 		Quit "-1"
 	} 
	s objQualityParam.Code = AParam.Code
	s objQualityParam.Name = AParam.Name
	s objQualityParam.BindValue = AParam.BindValue
	s objQualityParam.IsActive = AParam.IsActive
	s objQualityParam.ResumeText = AParam.ResumeText

 	if '(objQualityParam.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objQualityParam.%Id()
}

///  *****************************************************
///  功能：根据ID删除质控常量参数
///  入参：AId为质控常量参数表QualityParams的ID
///  *****************************************************
ClassMethod DeleteQualityParamById(AId As %String) As %Boolean [ WebMethod ]
{
	TSTART
 	s objQualityParam = ##class(EPRmeta.Quality.QualityParams).%OpenId(AId)
	q:(objQualityParam ="") 0 

 	if '(objQualityParam.%DeleteId(AId))
 	{
 		TROLLBACK
 		q 0
 	} 
 	TCOMMIT
 	q 1
}

///  *****************************************************
///  功能：更新质控常量参数
///  *****************************************************
ClassMethod UpdateQualityParam(AParam As EPRservice.entity.Quality.EQualityParam) As %String [ WebMethod ]
{
	TSTART
	s objQualityParam = ##class(EPRmeta.Quality.QualityParams).%OpenId(AParam.ID)
	q:(objQualityParam = "") "ERROR"
	
	s flag=##class(EPRmeta.Quality.QualityParams).CheckUpdateCodeUnique(AParam.ID,AParam.Code)
 	if '(flag=0)
 	{ 
 		q "-1"
 	} 
 	s objQualityParam.Code = AParam.Code
	s objQualityParam.Name = AParam.Name
	s objQualityParam.BindValue = AParam.BindValue
	s objQualityParam.IsActive = AParam.IsActive
	s objQualityParam.ResumeText = AParam.ResumeText
	
	if '(objQualityParam.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

/// desc:根据公共函数code取其value
/// Creator: Candyxu
/// Createdate:2013-02-27
/// Input: 公共函数code
/// OutPut:公共函数value值
/// debuge:w ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("MRSSGroup")
ClassMethod GetValuebyCode(ACode As %String) As %String
{
	s result = ""
	q:($d(^DHCEPRM.QualityParamsI("IdxCode",ACode))= 0) result
	s RowID = $o(^DHCEPRM.QualityParamsI("IdxCode",ACode,""))
    if (RowID '= "")
    {
	    s obj = ##Class(EPRmeta.Quality.QualityParams).%OpenId(RowID)
	    s:(obj '= "") result = obj.BindValue
	    s obj = ""
	}
	q result
}

/// desc:根据公共函数code取其value
/// Creator: Candyxu
/// Createdate:2013-02-27
/// Input: 公共函数code
/// OutPut:公共函数value值
/// debuge:w ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("MRSSGroup")
ClassMethod GetValuebyCodeNew(ACode As %String) As %String
{
	s result = ""
	q:($d(^CT.MA.QC.QualityParamsI("IdxCode",ACode))= 0) result
	s RowID = $o(^CT.MA.QC.QualityParamsI("IdxCode",ACode,""))
    if (RowID '= "")
    {
	    s obj = ##Class(CT.MA.QC.QualityParams).%OpenId(RowID)
	    s:(obj '= "") result = obj.BindValue
	    s obj = ""
	}
	q result
}

/// 环节质控评价界面是否显示留痕按钮
/// ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetShowRevisionFlag(Action,AQuaSetPage)
ClassMethod GetShowRevisionFlag(Action As %String, AQuaSetPage As %String)
{
	s flag=1
	q:(Action="")||(AQuaSetPage="") flag
	q:(Action'="A") flag
	s:(Action="A")&&(AQuaSetPage=2) flag=0
	q flag
}

}
