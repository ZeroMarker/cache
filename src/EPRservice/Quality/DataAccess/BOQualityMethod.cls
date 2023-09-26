/// ************************************************************
/// * Class Method:	EPRservice.Quality.DataAccess.BOQualityMethod
/// * Description:	质控检查方法服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityMethod Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityMethodInfo";

///  *****************************************************
///  功能：获取所有质控检查方法
///  *****************************************************
ClassMethod SelectAllQualityMethods() As EPRservice.dataset.Quality.EQualityMethodDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.Quality.EQualityMethodDataset).%New()
	d result.SetArgs()
	q result
}

///  *****************************************************
///  功能：根据ID获取相应质控检查方法
///  入参：质控检查方法表QualityMethod的ID
///  *****************************************************
ClassMethod GetQualityMethodById(AId As %String) As EPRservice.entity.Quality.EQualityMethod [ WebMethod ]
{
	s objChkMethod = ##class(EPRmeta.Quality.QualityMethod).%OpenId(AId)
	q:(objChkMethod = "") ""
	
	s Result = ##class(EPRservice.entity.Quality.EQualityMethod).%New()
	s Result.ID = objChkMethod.%Id()
	s Result.Code = objChkMethod.Code
	s Result.Name = objChkMethod.Name
	s Result.MethodEx = objChkMethod.MethodEx
	s Result.BindParms = objChkMethod.BindParms
	s Result.IsActive = objChkMethod.IsActive
	s Result.ResumeText = objChkMethod.ResumeText
	
 	q Result
}

///  *****************************************************
///  功能：根据ID删除质控检查方法
///  入参：质控检查方法表QualityMethod的ID
///  *****************************************************
ClassMethod DeleteQualityMethodById(AId As %String) As %Boolean [ WebMethod ]
{
	TSTART
 	s objChkMethod = ##class(EPRmeta.Quality.QualityMethod).%OpenId(AId)
	q:(objChkMethod ="") 0 

 	if '(objChkMethod.%DeleteId(AId))
 	{
 		TROLLBACK
 		q 0
 	} 
 	TCOMMIT
 	q 1
}

///  *****************************************************
///  功能：根据质控检查方法IDs删除质控检查方法
///  入参：质控检查方法表QualityMethod的IDs，多个ID以“\”分隔
///  结论：删除成功返回1
///  调试：w ##Class(EPRservice.Quality.DataAccess.BOQualityMethod).DeleteMethodByIDs()
///  *****************************************************
ClassMethod DeleteMethodByIDs(AMethodIDs As %String) As %Boolean [ WebMethod ]
{
	s ret=0
	q:(AMethodIDs="") ret
	
	s flag=1
	TStart
	s MethodIDs=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AMethodIDs,"|")
	for Ind=1:1:$listlength(MethodIDs) {
		s MethodID=$listget(MethodIDs,Ind)
		continue:MethodID=""
		
		s objMethod=##class(EPRmeta.Quality.QualityMethod).%OpenId(MethodID)
		continue:objMethod=""
		
		if '(objMethod.%DeleteId(MethodID))
	 	{
	 		s flag=0
	 		q
	 	} 
	}
	if (flag=1)
	{
		s ret=1
		TCommit	
	}
	else
	{
		TRollBack	
	}
	q ret
}

///  *****************************************************
///  功能：新建质控检查方法
///  *****************************************************
ClassMethod CreateQualityMethod(AMethod As EPRservice.entity.Quality.EQualityMethod) As %String [ WebMethod ]
{
	TSTART
	s objChkMethod = ##class(EPRmeta.Quality.QualityMethod).%New()
	q:(objChkMethod = "") "ERROR"
	 
	s flag = ##class(EPRmeta.Quality.QualityMethod).CheckCodeUnique(AMethod.Code) 
 	if '(flag = 0)
 	{ 
 		q "-1"
 	} 
	s objChkMethod.Code = AMethod.Code
	s objChkMethod.Name = AMethod.Name
	s objChkMethod.MethodEx = AMethod.MethodEx
	s objChkMethod.BindParms = AMethod.BindParms
	s objChkMethod.IsActive = AMethod.IsActive
	s objChkMethod.ResumeText = AMethod.ResumeText

 	if '(objChkMethod.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objChkMethod.%Id()
}

///  *****************************************************
///  功能：更新质控检查方法
///  *****************************************************
ClassMethod UpdateQualityMethod(AMethod As EPRservice.entity.Quality.EQualityMethod) As %String [ WebMethod ]
{
	TSTART
	s objQuaMethod = ##class(EPRmeta.Quality.QualityMethod).%OpenId(AMethod.ID)
	q:(objQuaMethod = "") "ERROR"
	
	s flag=##class(EPRmeta.Quality.QualityMethod).CheckUpdateCodeUnique(AMethod.ID,AMethod.Code)
 	if '(flag=0)
 	{ 
 		q "-1"
 	} 
 	s objQuaMethod.Code = AMethod.Code
	s objQuaMethod.Name = AMethod.Name
	s objQuaMethod.IsActive = AMethod.IsActive
	s objQuaMethod.MethodEx = AMethod.MethodEx
	s objQuaMethod.BindParms = AMethod.BindParms
	s objQuaMethod.ResumeText = AMethod.ResumeText
	
	if '(objQuaMethod.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

}
