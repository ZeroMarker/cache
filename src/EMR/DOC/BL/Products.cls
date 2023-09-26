/// 名称:	EMR.DOC.BL.Products
/// 描述:	通用文档管理模块 Document(Doc) 项目标识逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.Products Extends EMR.DOC.COM.ActionBase
{

/// Desc: 初始化数据
/// Creator:yejian
/// CreateDate:2020-12-14
/// Debug:d ##Class(EMR.DOC.BL.Products).InitData()
ClassMethod InitData()
{
	d ##Class(EMR.DOC.BL.Products).AddData("DOC","通用")
	d ##Class(EMR.DOC.BL.Products).AddData("IP","住院")
	d ##Class(EMR.DOC.BL.Products).AddData("OP","门急诊")
}

/// Desc:       获取所有项目标识
/// Creator:    yejian
/// CreateDate: 2021-3-11
/// Input:      argArray  命令参数 {"params":{"action":"GET_PRODUCT_DATA","args":{}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetProductDatas(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s jArrProduc = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.Products).GetProductDatasJson(jArrProduc)
	if (strRes = "1")
	{ 
		d jArrProduc.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取所有项目标识
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.Products).GetProductDatasJson(.argOutData)
ClassMethod GetProductDatasJson(ByRef jArrProduc As %DynamicArray) As %String
{
	s strRes = "1"
	s ProductID = ""
	for {
		s ProductID = $o(^CT.EMR.DOC.ProductsD(ProductID))
		q:(ProductID = "")			
		s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
        continue:(objProduct="")
        s jsonProduct  = ##class(%DynamicObject).%New()
        s jsonProduct.id = ProductID
        s jsonProduct.key = ProductID
        s jsonProduct.productCode =objProduct.ProductCode
        s jsonProduct.productName =objProduct.ProductName

        d jArrProduc.%Push(jsonProduct)
	}
	q strRes
}

/// Desc:添加数据
/// Creator:yejian
/// CreateDate:2018-2-28
/// Input: AName 名称
///       AType 类型
ClassMethod AddData(ACode As %String, AName As %String) As %String
{
	s result = ""
	q:(ACode = "")||(AName = "") result
	s rowId = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(ACode,"u"),""))
	/// code判定是否重复
	if (rowId = "")
	{
		s obj = ##Class(CT.EMR.DOC.Products).%New()
	}
	else
	{
		s obj = ##Class(CT.EMR.DOC.Products).%OpenId(rowId)
	}
	s obj.ProductCode = ACode
	s obj.ProductName = AName
	s sc = obj.%Save()
	// 新增文档设计根节点
	d ##class(EMR.DOC.BL.TemplateCategory).AddRootCategoryJson(obj.%Id(),AName,"")
    // 新增文档版式根节点
	d ##class(EMR.DOC.BL.HFFormat).AddRootCategoryJson(obj.%Id(),AName,"")
	// 新增文档片段根节点
	d ##class(EMR.DOC.BL.KBCategory).AddRootCategoryJson(obj.%Id(),AName,"")
	// 新增业务数据模型根节点
	d ##class(EMR.DOC.BL.BDMCategory).AddRootCategoryJson(obj.%Id(),AName,"")
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       添加项目标识
/// Creator:    Ning
/// CreateDate: 2021-07-13
/// Input:      argArray  	命令参数 {"action":"ADD_PRODUCT_DATA","params":{ProductCode："",ProductName:"" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddProductData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s result = ""
	s ACode = argInJson.params.productCode
	s AName= argInJson.params.productName
	q:(ACode = "")||(AName = "") ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	s rowId = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(ACode,"u"),""))
	/// code判定项目是否存在
	if (rowId = "")
	{
		s obj = ##Class(CT.EMR.DOC.Products).%New()
		s obj.ProductCode = ACode
	    s obj.ProductName = AName
	    s sc = obj.%Save()
	    s:($$$ISOK(sc)) result = "1"
	    // 新增文档设计根节点
	    d ##class(EMR.DOC.BL.TemplateCategory).AddRootCategoryJson(obj.%Id(),AName,"")
	    // 新增文档版式根节点
	    d ##class(EMR.DOC.BL.HFFormat).AddRootCategoryJson(obj.%Id(),AName,"")
	    // 新增文档片段根节点
	    d ##class(EMR.DOC.BL.KBCategory).AddRootCategoryJson(obj.%Id(),AName,"")
	    // 新增业务数据模型根节点
	    d ##class(EMR.DOC.BL.BDMCategory).AddRootCategoryJson(obj.%Id(),AName,"")
	    q result
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","Code值重复",2)
	}
Error
	Trollback
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新项目标识
/// Creator:    Ning
/// CreateDate: 2021-07-13
/// Input:      argArray  	命令参数 {"action":"UP_PRODUCT_DATA","params":{ProductCode："",ProductName:"" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpProductData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s result = ""
	s ACode = argInJson.params.productCode
	s AName= argInJson.params.productName
	q:(ACode = "")||(AName = "") ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	s rowId = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(ACode,"u"),""))
	/// code判定是否重复
	if (rowId = "")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","项目标识不存在",2)
	}
	else
	{
		s obj = ##Class(CT.EMR.DOC.Products).%OpenId(rowId)
		s obj.ProductCode = ACode
	    s obj.ProductName = AName
	    s sc = obj.%Save()
	    s:($$$ISOK(sc)) result = "1"
	    q result
	}
Error
	Trollback
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除项目标识
/// Creator:    Ning
/// CreateDate: 2021-07-14
/// Input:      argArray  	命令参数 {"action":"DEL_PRODUCT_DATA","params":{ProductCode："" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功："1",失败：-1
ClassMethod DelProductData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ACode = argInJson.params.productCode
	s result=##class(EMR.DOC.BL.Products).delProduct(ACode)
	if (result="1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif (result["-1^")
	{
		s strErr = $p(result,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	;Trollback
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

ClassMethod delProduct(ACode As %String) As %String
{
	q:(ACode = "") "-1^必填项校验失败"
	s rowId = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(ACode,"u"),""))
	if (rowId = "")
	{
		q "-1^项目标识不存在"
	}
	else
	{
		/// 判定是否有数据集绑定项目
		s id = $o(^CF.EMR.DOC.BindQueryI("IdxProduct",rowId,""))
		/// 业务数据模型
		s BDMid = $o(^CF.EMR.DOC.BDMCategoryI("IdxProduct",rowId,""))
		/// 文档版式
		s HFFid = $o(^CF.EMR.DOC.HFFormatCategoryI("IdxProduct",rowId,""))
		/// 文档片段
		s KBid = $o(^CF.EMR.DOC.KBCategoryI("IdxProduct",rowId,""))
		/// 文档设计
		s TEMid = $o(^CF.EMR.DOC.TemplateCategoryI("IdxProduct",rowId,""))
		
		if ((id ="")&&(BDMid="")&&(HFFid="")&&(KBid="")&&(TEMid=""))
		{
			/// 执行删除
			s res = ##class(CT.EMR.DOC.Products).%DeleteId(rowId)
			q "1"
		}
		else
		{
			q "-1^项目下有子数据不允许删除"
		}
	}
}

/// Desc:根据项目编码获取项目
/// Creator:yejian
/// CreateDate:2018-2-28
/// Input: ACode 项目编码
/// OutPut:    	CT.EMR.DOC.Products 项目
/// Debug:      w ##Class(EMR.DOC.BL.Products).GetProductByCode("DOC") 
ClassMethod GetProductByCode(ACode As %String) As CT.EMR.DOC.Products
{
	s result = ""
	q:(ACode = "") result
	s rowId = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(ACode,"U"),""))
	q:(rowId = "") result
	s objProduct = ##class(CT.EMR.DOC.Products).%OpenId(rowId)
	q:(objProduct = "") result
	q objProduct
}

/// desc 根据用户Code获取项目标识数组
/// debug w ##Class(EMR.DOC.BL.Products).GetProductArrByUserCode("YS01")
ClassMethod GetProductArrByUserCode(aRoleCode As %String = "") As %DynamicArray
{
	s productArray = ##class(%DynamicArray).%New()
	q:(aRoleCode="") productArray
	//如果传入角色ID，根据传入的角色ID获取项目标识数组
	s roleID = ##Class(EMR.DOC.BL.RBACRole).GetRoleByCode(aRoleCode)
	s strRPRowID = ""
	for {
		s strRPRowID = $o(^CF.EMR.DOC.RBACRoleProductI("IdxRole",roleID,strRPRowID))
		q:(strRPRowID = "")		
		s strRes = "1"	
		s objRProduct = ##Class(CF.EMR.DOC.RBACRoleProduct).%OpenId(strRPRowID)
    	continue:(objRProduct="")
    	s objProduct = objRProduct.Product
    	d productArray.%Push(objProduct)
	}
	q productArray
}

/// desc 根据角色Id获取项目标识数组
/// debug w ##Class(EMR.DOC.BL.Products).GetProductArrByRoleID(1)
ClassMethod GetProductArrByRoleID(ARoleID As %String) As %DynamicArray
{
	s productArray = ##class(%DynamicArray).%New()
	q:(ARoleID="") productArray
	s ObjRole = ##Class(CF.EMR.DOC.RBACRole).%OpenId(ARoleID)
	q:(ObjRole="") productArray
	if (ObjRole.RoleCode="SuperAdmin"){
		s productID = ""
		for{
			s productID = $O(^CT.EMR.DOC.ProductsD(productID))
			q:productID=""
			s strRes = "1"
			s objProduct = ##class(CT.EMR.DOC.Products).%OpenId(productID)
			continue:(objProduct="")
			d productArray.%Push(objProduct)
		}	
	}else{
		s strRPRowID = ""
		for {
			s strRPRowID = $o(^CF.EMR.DOC.RBACRoleProductI("IdxRole",ARoleID,strRPRowID))
			q:(strRPRowID = "")		
			s strRes = "1"	
			s objRProduct = ##Class(CF.EMR.DOC.RBACRoleProduct).%OpenId(strRPRowID)
        	continue:(objRProduct="")
        	s objProduct = objRProduct.Product
        	d productArray.%Push(objProduct)
		}
	}
	q productArray
}

}
