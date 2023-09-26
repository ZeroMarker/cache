Class CT.WS.BO.BODataElementValuesCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataElementValuesCategoryInfo";

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		判断标示符是否存在
/// Input：		aGlossaryID：Id,aEntifier: 数据元标示符
/// Return：	string
/// w ##Class(EPRservice.BODataElementValuesCategory).CheckEntifier("55","55")
ClassMethod CheckEntifier(aDEVCategoryID As %String, aDECVMID As %String) As %String [ WebMethod ]
{
	q:(aDECVMID="")||(aDECVMID=$C(0)) "内部标识符不能为空"
	 
	s id = $O(^DHCCTWS.DataElementValuesCategoryI("IdxDECVMID"," "_aDECVMID,""))
	if (id = "")
	{
		//内部标识符不存在, OK
		q ""
	}
	else
	{
		if (id = aDEVCategoryID)
		{
			//内部标识符存在且属于当前范畴, OK
			q ""
		}
		else
		{
			s obj = ##Class(CT.WS.DataElementValuesCategory).%OpenId(id)
			q "内部标识符与["_obj.Name_"]冲突!"
		}
	}
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		创建数据值域代码范畴
/// Table：		CT.WS.DataElementValues，CT.WS.DataElementValuesCategory
/// Input：		aDataElementValuesCategory 数据元实体对象
/// Return：	数据元Id	
ClassMethod CreateDEValuesCategory(aEDEValuesCategory As CT.WS.entity.EDataElementValuesCategory) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查值域代码范畴DECVMID是否唯一
	s existed = ##Class(CT.WS.DataElementValuesCategory).SelectByDECVMID(aEDEValuesCategory.DECVMID)
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objDEValuesCategory = ##Class(CT.WS.DataElementValuesCategory).%New()
	q:(objDEValuesCategory = "") ret
	
	s objDEValuesCategory.DECVMID  = aEDEValuesCategory.DECVMID 
	s objDEValuesCategory.CategoryID = aEDEValuesCategory.CategoryID
	s objDEValuesCategory.CreateDate = $piece($HOROLOG,",",1)
	s objDEValuesCategory.CreateTime = $piece($HOROLOG,",",2)
	s objDEValuesCategory.LastModifyDate = $piece($HOROLOG,",",1)
	s objDEValuesCategory.LastModifyTime = $piece($HOROLOG,",",2)
	s objDEValuesCategory.PerName   = aEDEValuesCategory.PerName 
	s objDEValuesCategory.Name = aEDEValuesCategory.Name
	s objDEValuesCategory.Description  = aEDEValuesCategory.Description
	
	if ('objDEValuesCategory.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objDEValuesCategory.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		删除数据值域代码范畴
/// Table：		CT.WS.DataElementValues，CT.WS.DataElementValuesCategory
/// Input：		aDataElementValuesID：要删除的值域代码Id
/// Return：	"0":删除失败	"1":删除成功	
ClassMethod DeleteDEValuesCategory(aDataElementValuesID As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:($d(aDataElementValuesID) = "") ret
	
	s objDEValuesCategory = ##Class(CT.WS.DataElementValuesCategory).%OpenId(aDataElementValuesID)
	q:(objDEValuesCategory = "") ret

	TSTART
	
	// 删除Glossary
	s isSucceed = ##Class(CT.WS.DataElementValuesCategory).%DeleteId(aDataElementValuesID)
	if ('isSucceed)
	{
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = 1
	q ret
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		查询某个值域代码范畴
/// Input：		aDECVMID：值域代码标示符
/// Return：	EPRservice.dataset.EDataElementValuesCategoryDataset 值域代码集dataset
/// Debug:		w ##Class(EPRservice.BODataElementValuesCategory).SelectAllDEValuesCategoryByDECVMID(2)
ClassMethod SelectAllDEValuesCateByDECVMID(aDECVMID) As EPRservice.dataset.EDataElementValuesCategoryDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EDataElementValuesCategoryDataset).%New()
	Do result.SetArgs(aDECVMID)
	
	quit result
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		查询某个值域代码范畴
/// Input：		aDECVMID：值域代码标示符
/// Return：	EPRservice.dataset.EDataElementValuesCategoryDataset 值域代码集dataset
/// Debug:		w ##Class(EPRservice.BODataElementValuesCategory).SelectAllDEVCategoryByCateID(2)
ClassMethod SelectAllDEVCategoryByCateID(aCategoryID) As EPRservice.dataset.EDEVCategoryByCategoryIDDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EDEVCategoryByCategoryIDDataset).%New()
	Do result.SetArgs(aCategoryID)
	
	quit result
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		由某个值域代码范畴ID获得值域代码范畴对象
/// Input：		aDEValuesCategoryId：值域代码范畴Id
/// Return：	CT.WS.entity.EDataElementValuesCategory：值域代码范畴实体对象
ClassMethod SelectDEValuesCategoryById(aDEValuesCategoryId As %String) As CT.WS.entity.EDataElementValuesCategory [ WebMethod ]
{
	s objDEValuesCategory = ##Class(CT.WS.DataElementValuesCategory).%OpenId(aDEValuesCategoryId)
	q:(objDEValuesCategory = "") ""
	
	s objEDEValuesCategory = ##Class(CT.WS.entity.EDataElementValuesCategory).%New()
	q:(objEDEValuesCategory = "") ""

	s objEDEValuesCategory.ID = objDEValuesCategory.%Id()
	s objEDEValuesCategory.CreateDate = objDEValuesCategory.CreateDate
	s objEDEValuesCategory.CreateTime =  objDEValuesCategory.CreateTime
	s objEDEValuesCategory.LastModifyDate =objDEValuesCategory.LastModifyDate
	s objEDEValuesCategory.LastModifyTime = objDEValuesCategory.LastModifyTime
	s objEDEValuesCategory.DECVMID   = objDEValuesCategory.DECVMID  
	s objEDEValuesCategory.Name = objDEValuesCategory.Name
	s objEDEValuesCategory.PerName   = objDEValuesCategory.PerName  
	s objEDEValuesCategory.Description   = objDEValuesCategory.Description  
	
	q objEDEValuesCategory
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		更新值域代码范畴
/// Input：		aEDataElementValues：值域代码范畴实体对象
/// Return：	"0": 更新失败,  "1": 更新成功
ClassMethod UpdateEDEValuesCategory(aEDEValuesCategory As CT.WS.entity.EDataElementValuesCategory) As %String [ WebMethod ]
{
	s ret = 0
	s objDEValuesCategory = ##Class(CT.WS.DataElementValuesCategory).%OpenId(aEDEValuesCategory.ID)
	q:(objDEValuesCategory = "") ret

	TSTART
	
	// 更新objDataElementValues信息	
	s objDEValuesCategory.CreateDate = aEDEValuesCategory.CreateDate
	s objDEValuesCategory.CreateTime = aEDEValuesCategory.CreateTime
	s objDEValuesCategory.LastModifyDate = $piece($HOROLOG,",",1)
	s objDEValuesCategory.LastModifyTime = $piece($HOROLOG,",",2)
	s objDEValuesCategory.DECVMID  = aEDEValuesCategory.DECVMID 
	s objDEValuesCategory.Name = aEDEValuesCategory.Name
	s objDEValuesCategory.PerName  = aEDEValuesCategory.PerName 
	s objDEValuesCategory.Description  = aEDEValuesCategory.Description 

	
	if ('objDEValuesCategory.%Save())
	{
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = 1
	q ret
}

}
