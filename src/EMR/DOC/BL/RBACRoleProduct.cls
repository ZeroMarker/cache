/// 名称:	EMR.DOC.BL.RBACRoleProduct
/// 描述:	通用文档管理模块 Document(Doc) 角色项目标识逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RBACRoleProduct Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据角色获取已经关联项目标识
/// Creator:    yejian
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"params":{"action":"GET_RBAC_ROLEPRODUCT","args":{"RoleID":"2"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACRoleProduct(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s RoleID = argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.RBACRoleProduct).GetRBACRoleProductJson(RoleID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","roleId参数不能为空",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","角色不存在",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       批量更新角色关联项目标识
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {"params":{"action":"UP_RBAC_ROLEPRODUCT","args":{"RoleID":"2","ProductIDS":["1","2"]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息 成功<string> 1 失败 <string> -1
///            	argOutData    返回数据
ClassMethod UpRBACRoleProduct(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s RoleID = argInJson.params.safeGroupId
	s ProductIDS = argInJson.params.productIDS
	if (argInJson.params.%GetTypeOf("productIDS")'="array")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","productIDS参数必须是数组",2)
	}
    s strRes = ##Class(EMR.DOC.BL.RBACRoleProduct).UpRBACRoleProductJson(RoleID,ProductIDS,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","roleId参数不能为空",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新项目标识失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据角色获取已经关联项目标识
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACRoleProduct).GetRBACRoleProductJson("1",.argOutData)
ClassMethod GetRBACRoleProductJson(strRoleID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(strRoleID="") "-200"
	s jArrRProduc = ##class(%DynamicArray).%New()
	if (strRoleID = "SuperAdmin"){
		//超级管理员
		s productArr = ##class(%DynamicArray).%New()
		s strRes = ##Class(EMR.DOC.BL.Products).GetProductDatasJson(productArr)
		q:strRes'="1"
		set iter = productArr.%GetIterator()
		while iter.%GetNext(.key , .product ) {
	   		s ID = product.id
	   		d jArrRProduc.%Push(ID)
		}
	}
	else{
		s RoleID =##class(EMR.DOC.BL.RBACRole).GetRoleByCode(strRoleID)
		s roleObj = ##class(CF.EMR.DOC.RBACRole).%OpenId(RoleID)
		q:(roleObj="") "-301"
		s strRowID = ""
		for {
			s strRowID = $o(^CF.EMR.DOC.RBACRoleProductI("IdxRole",RoleID,strRowID))
			q:(strRowID = "")			
			s objRProduct = ##Class(CF.EMR.DOC.RBACRoleProduct).%OpenId(strRowID)
        	continue:(objRProduct="")
       		s ID = objRProduct.Product.%Id()
        	d jArrRProduc.%Push(ID)
		}
	}
	d jArrRProduc.%ToJSON(argOutData)

	q strRes
}

/// Desc:       批量更新角色关联项目标识
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			s strJson = "[""1"",""2""]"
///   			set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
///             w ##class(EMR.DOC.BL.RBACRoleProduct).UpRBACRoleProductJson("1",objJson,argOutData)
ClassMethod UpRBACRoleProductJson(strRoleID As %String, jarrProductIDS As %DynamicArray, ByRef argOutData As %GlobalBinaryStream)
{
	s strRes = "-101"
	q:((strRoleID = "")) "-200"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(strRoleID)
	TSTART
	&sql(DELETE  FROM CF_EMR_DOC.RBACRoleProduct WHERE RoleID = :RoleID )
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q "-101"
	}
	s strMark = "1"
	s intProductSize = jarrProductIDS.%Size()
	for i=0:1:(intProductSize-1)
	{
		s jItem = jarrProductIDS.%Get(i)
		s strPID = jItem
		s objRoleProduct = ##class(CF.EMR.DOC.RBACRoleProduct).%New()
		s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(RoleID)
		if (objRole = "") 
		{
			s strMark="-1"
			q
		}
		s objProduct = ##class(CT.EMR.DOC.Products).%OpenId(strPID)
		if (objProduct = "") 
		{
			s strMark="-1"
			q
		}
		s objRoleProduct.RoleID = objRole
		s objRoleProduct.Product = objProduct
		s sc = objRoleProduct.%Save()
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
			q
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

ClassMethod GetProductArrayByRoleCode(roleCode) As %String
{
	s productArray = ##class(%DynamicArray).%New()
	q:(roleCode="") 
	if (roleCode = "SuperAdmin")
	{
		s ProductID = ""
		for 
		{
			s ProductID = $o(^CT.EMR.DOC.ProductsD(ProductID))
			q:(ProductID = "")			
			s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
	        continue:(objProduct="")

	        d productArray.%Push(objProduct)
		}

	}
	else
	{
		s roleID = ##Class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
		q:roleID=""
		s rowId = ""
		for 
		{
			s rowId = $o(^CF.EMR.DOC.RBACRoleProductI("IdxRole",roleID,rowId))
			q:(rowId = "")		
			s objRProduct = ##Class(CF.EMR.DOC.RBACRoleProduct).%OpenId(rowId)
	    	continue:(objRProduct="")
	    	s objProduct = objRProduct.Product
	    	d productArray.%Push(objProduct)
		}
	}
	q productArray
}

}
