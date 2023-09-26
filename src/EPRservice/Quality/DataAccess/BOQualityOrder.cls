/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityParams
/// * Description:	质控常量参数服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityOrder Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityOrderInfo";

///  *****************************************************
///  功能：获取所有医嘱项目
///  *****************************************************
ClassMethod SelectAllQualityOrders() As EPRservice.dataset.Quality.EQualityOrderDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.EQualityOrderDataset).%New()
	d result.SetArgs()
	q result
}

///  *****************************************************
///  功能：根据ID获取相应质控检查方法
///  入参：质控检查方法表QualityMethod的ID
///  *****************************************************
ClassMethod GetQualityOrderByID(AID As %String) As EPRservice.entity.Quality.EQualityOrder [ WebMethod ]
{
	s objOrder = ##class(EPRmeta.Quality.QualityOrder).%OpenId(AID)
	q:(objOrder = "") ""
	
	s Result = ##class(EPRservice.entity.Quality.EQualityOrder).%New()
	s Result.ID = objOrder.%Id()
	s Result.OrderID = objOrder.OrderID
	s Result.OrderName = objOrder.OrderName
	s Result.DictionaryID = objOrder.DictionaryID
	s Result.IsActive = objOrder.IsActive
	s Result.ResumeText = objOrder.ResumeText
	
 	q Result
}

///  *****************************************************
///  功能：新建医嘱项目
///  *****************************************************
ClassMethod CreateQualityOrder(AOrder As EPRservice.entity.Quality.EQualityOrder) As %String [ WebMethod ]
{
	s ret = 0
	
	s OrderID = AOrder.OrderID
	s DictionaryID = AOrder.DictionaryID
	q:(OrderID = "")||(DictionaryID = "") ret
	
	s RowID = $o(^DHCEPRM.QualityOrderI("IdxOrderDictionaryID"," "_OrderID," "_DictionaryID,""))
	if (+RowID > 0)
	{
		s ret = -1
		q ret
	} 
	
	TSTART
	
	s objOrder = ##Class(EPRmeta.Quality.QualityOrderInfo).%New()
 	 
	s objOrder.OrderID = OrderID
	s objOrder.OrderName = AOrder.OrderName
	s objOrder.DictionaryID = DictionaryID
	s objOrder.IsActive = AOrder.IsActive
	s objOrder.ResumeText = AOrder.ResumeText

 	if '(objOrder.%Save())
 	{
 		TROLLBACK
 	}
 	else
 	{ 
 		TCOMMIT
 		s ret = objOrder.%Id()
 	}
 	q ret
}

///  *****************************************************
///  功能：更新医嘱项目
///  *****************************************************
ClassMethod UpdateQualityOrder(AOrder As EPRservice.entity.Quality.EQualityOrder) As %String [ WebMethod ]
{
	TSTART
	s objOrder = ##Class(EPRmeta.Quality.QualityOrderInfo).%OpenId(AOrder.ID)
	
	s objOrder.OrderID = AOrder.OrderID
	s objOrder.OrderName = AOrder.OrderName
	s objOrder.DictionaryID = AOrder.DictionaryID
	s objOrder.IsActive = AOrder.IsActive
	s objOrder.ResumeText = AOrder.ResumeText
	
	if '(objOrder.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

///  *****************************************************
///  功能：批量删除医嘱项目
///  *****************************************************
/// Debug: w ##Class(EPRservice.Quality.DataAccess.BOQualityOrder).BatchDeleteQualityOrder()
ClassMethod BatchDeleteQualityOrder(AOrderIDs As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:(AOrderIDs = "") ret

	TStart
	
	s flag = 1
	s OrderIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AOrderIDs,"|")
	for Ind = 1:1:$listlength(OrderIDs) 
	{
		s OrderID = $listget(OrderIDs,Ind)
		continue:(OrderID = "")
		
		s objOrder = ##Class(EPRmeta.Quality.QualityOrderInfo).%OpenId(OrderID)
		if '(objOrder.%DeleteId(OrderID))
		{
			TRollBack
			s flag = 0
			q	
		}
	}
	
	if (flag = 1)
	{
		TCommit
		s ret = 1
	}
	q ret
}

}
