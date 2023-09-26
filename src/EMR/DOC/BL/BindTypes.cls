/// 名称:	EMR.DOC.BL.BindTypes
/// 描述:	通用文档管理模块 Document(Doc) 数据集查询类型业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BindTypes Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取数据集查询类型
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_DATA_BINDQUERYTYPES","params":{"productCode":"OEP"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataBindQueryTypes(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode = argInJson.params.productCode
    s strRes = ##Class(EMR.DOC.BL.BindTypes).GetDataBindQueryTypesJson(ProductCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入项目标识",2)
	}
	elseif(strRes = "-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","项目标识记录为空，检查参数",2)
	}
	else
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取数据集查询类型JSON
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aProductCode	项目标识
/// OutPut:     成功 1 失败 -200 项目标识Code未传
///                         -301 项目标识对象不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindTypes).GetDataBindQueryTypesJson("DOC",.argOutData)
ClassMethod GetDataBindQueryTypesJson(aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(aProductCode="") "-200"
	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(aProductCode,"U"),""))
	q:(ProductID="") "-301"
    s jsonArr = ##class(%DynamicArray).%New()
 	s strBTCode = ""
	for {
		s strBTCode = $o(^CF.EMR.DOC.BindTypesI("IdxProductCode",ProductID,strBTCode))
		q:(strBTCode = "")			
		s strBRowID = ""
		for {
			s strBRowID = $o(^CF.EMR.DOC.BindTypesI("IdxProductCode",ProductID,strBTCode,strBRowID))
			q:(strBRowID = "")			
			s objBindType = ##Class(CF.EMR.DOC.BindTypes).%OpenId(strBRowID)
	        continue:(objBindType="")
	       	s jsonBindType  = ##class(%DynamicObject).%New()
		    s jsonBindType.id =strBRowID
		    s jsonBindType.productCode =aProductCode
		    s jsonBindType.description = objBindType.Description
		    s jsonBindType.code =objBindType.Code
		    s jsonBindType.name =objBindType.Name
			d jsonArr.%Push(jsonBindType)
		}
	}
	
	d jsonArr.%ToJSON(argOutData)

	q "1"
}

/// Desc:       添加数据集类型
/// Creator:    yejian
/// CreateDate: 2020-07-16
/// Input:      argArray  命令参数 {"action":"ADD_DATA_BINDTYPES", "params":{"productCode":"OEP","code":"TestID","name":"测试ID",description:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDataBindTypes(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoBindTypesValues = ##class(%DynamicObject).%New()
	s dtoBindTypesValues.Product = argInJson.params.productCode
	s dtoBindTypesValues.Code = argInJson.params.code
	s dtoBindTypesValues.Name = argInJson.params.name
	s dtoBindTypesValues.Description = argInJson.params.description
    s strRes = ##Class(EMR.DOC.BL.BindTypes).AddDataBindTypesJson(dtoBindTypesValues,.argOutData)
	if (strRes >0)
	{ 
		q "1"
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","检查必填项",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","项目标识不存在，检查参数",2)
	}
	elseif(strRes="-400")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","code值重复",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       添加数据集类型
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDTOItem  数据集对象
/// OutPut:     成功 1 失败 -102 操作数据失败
/// 							-200 必填项（code,name,product）未传
///                         -301 项目标识对象不存在 
///                         -400 code唯一性校验失败
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindTypes).AddDataBindTypesJson()
ClassMethod AddDataBindTypesJson(aDTOItem As EMR.DOC.DTO.BindParameterValues, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-102"
	q:((aDTOItem = "")||(aDTOItem.Code="")||(aDTOItem.Name="")||(aDTOItem.Product="")) "-200"
	s objProduct = ##Class(EMR.DOC.BL.Products).GetProductByCode(aDTOItem.Product)
	if (objProduct="")
	{
		q "-301"
	}
	//Code唯一性
	s rowId = $O(^CF.EMR.DOC.BindTypesI("IdxProductCode",objProduct.%Id()," "_$ZCVT(aDTOItem.Code,"U"),""))
	q:(rowId'="") "-400"
	s strProductID = objProduct.%Id()
	
	s obj = ##class(CF.EMR.DOC.BindTypes).%New()
	s obj.Product = objProduct
	s obj.Code = aDTOItem.Code
	s obj.Name = aDTOItem.Name
	s obj.Description=aDTOItem.Description

	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		q strRes
	}
	s strRes = obj.%Id()
	q strRes
}

/// Desc:       获取数据集查询类型表格数据
/// Creator:    Ning
/// CreateDate: 2021-07-15
/// Input:      argArray  命令参数 {"action":"GET_DATA_BINDTYPES_TABLE","params":{"productCode":"OEP"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBindTypesTable(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode = argInJson.params.productCode
	s current = argInJson.params.current
    s pageSize = argInJson.params.pageSize 
    s name = argInJson.params.name
	s code = argInJson.params.code
    s strRes = ##Class(EMR.DOC.BL.BindTypes).GetBindTypesTableJson(ProductCode,current,pageSize,name,code,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入项目标识",2)
	}
	elseif(strRes = "-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","项目标识记录为空，检查参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加数据集类型表格数据
/// Creator:    Ning
/// CreateDate: 2021-07-15
/// OutPut:     成功 1 失败 -102 操作数据失败
/// 							-200 必填项（code,name,product）未传
///                         -301 项目标识对象不存在 
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindTypes).GetBindTypesTableJson("OEP",1,10,argOutData)
ClassMethod GetBindTypesTableJson(AProductCode As %String, ACurrent As %String, APageSize As %String, AName As %String, ACode As %String, ByRef AOutData As %GlobalBinaryStream)
{
	q:(AProductCode="") "-200"
	s:(ACurrent="") ACurrent=1
	s:(APageSize="") APageSize=10
	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(AProductCode,"U"),""))
	q:(ProductID="") "-301"
	s objResult = ##class(%DynamicObject).%New()
	s start = (ACurrent-1)*APageSize+1
	s end = ACurrent*APageSize
	s count = 0
	// 创建空数组
    s jsonArr = ##class(%DynamicArray).%New()
 	s strRowID = ""
	for {
		// ID匹配
		s strRowID =$o(^CF.EMR.DOC.BindTypesI("IdxProduct",ProductID,strRowID))
		q:(strRowID = "")	
		// 模糊匹配		
		s objBindPValues = ##Class(CF.EMR.DOC.BindTypes).%OpenId(strRowID)
	    continue:((objBindPValues="")||((AName'="")&&'(objBindPValues.Name[AName))||((ACode'="")&&'(objBindPValues.Code[ACode)))
	    s count = count+1
	    continue:((count<start)||(count>end))
	    s jsonBindPValues  = ##class(%DynamicObject).%New()
		s jsonBindPValues.id =strRowID
		s jsonBindPValues.code =objBindPValues.Code
		s jsonBindPValues.name =objBindPValues.Name
		s jsonBindPValues.description =objBindPValues.Description
		d jsonArr.%Push(jsonBindPValues)
	}
	s objResult.current = ACurrent
	s objResult.pageSize = APageSize
	s objResult.total = count
	s objResult.list = jsonArr
	d objResult.%ToJSON(AOutData)

	q "1"
}

/// Desc:       删除数据集查询类型
/// Creator:    Ning
/// CreateDate: 2021-07-19
/// Input:      argArray  命令参数 {"action":"DEL_DATA_BINDTYPES","params":{"id":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DelBindType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.BindTypes).DelBindTypesJson(ID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","类型已使用,不能删除",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}	
	elseif(strRes="-200")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集不存在，检查入参",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除数据集查询类型
/// Creator:    Ning
/// CreateDate: 2021-07-19
/// Input:      aQueryID  数据集ID
/// OutPut:     成功 1 失败 -101 参数已被使用，不能删除 -102 操作数据失败
/// 						-200 必填项（id）未传
///                         -301 数据集对象不存在 
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindTypes).DelBindTypesJson("4",argOutData)
ClassMethod DelBindTypesJson(aID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes ="-102"
	if (aID ="")
	{
		q "-200"
	}
	s strRowID = $o(^CF.EMR.DOC.BindQueryI("IdxBindType",aID,""))
	if (strRowID'="")
	{
		s strRes = "-101"
		d argOutData.Write(strRes)
		q strRes
	}
	s objBindPV = ##class(CF.EMR.DOC.BindTypes).%OpenId(aID)
	if (objBindPV ="")
	{
		q "-301"
	}
	if '(objBindPV.%DeleteId(aID))
	{
		q strRes
	}
	s strRes = "1"
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       更新数据集查询类型
/// Creator:    Ning
/// CreateDate: 2021-07-19
/// Input:      argArray  	命令参数 {"action":"UP_DATA_BINDTYPE","params":{"id":"4","productCode":"OEP","code":"TestID(update)","name":"测试ID(更新)","description":"测试ID（更新）"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpDataBindTypes(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoBindTypes = ##class(EMR.DOC.DTO.BindTypes).%New()
	s dtoBindTypes.ID = argInJson.params.id
	s dtoBindTypes.Code = argInJson.params.code
	s dtoBindTypes.Name = argInJson.params.name
	s dtoBindTypes.Description = argInJson.params.description
    s strRes = ##Class(EMR.DOC.BL.BindTypes).UpDataBindTypesJson(dtoBindTypes,.argOutData)
	if (strRes = "1")
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","检查必填项",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","查询类型不存在，检查参数",2)
	}
	elseif(strRes="-401")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","code唯一性校验失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新数据集查询类型
/// Creator:    Ning
/// CreateDate: 2021-07-19
/// Input:      aDTOItem  数据集对象
/// 			aParams 数据集入参
/// OutPut:     成功 1 失败 -102 操作数据失败
/// 						-200 必填项（id,code,name）未传
///                         -301 查询类型对象不存在 
///                         -401 code唯一性校验失败
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindTypes).UpDataBindTypesJson(aDTOItem,argOutData)
ClassMethod UpDataBindTypesJson(aDTOItem As EMR.DOC.DTO.BindTypes, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-102"
	q:((aDTOItem = "")||(aDTOItem.ID="")||(aDTOItem.Code="")||(aDTOItem.Name="")) "-200"

	s obj = ##class(CF.EMR.DOC.BindTypes).%OpenId(aDTOItem.ID)
	q:(obj = "") "-301"
	s rowID = $o(^CF.EMR.DOC.BindTypesI("IdxProductCode",obj.Product.%Id()," "_$zcvt(aDTOItem.Code,"U"),""))
	if (rowID '= "")&&(rowID '=aDTOItem.ID)
	{
		s strRes = "-401"
		q strRes
	}
	s obj.Code = aDTOItem.Code
	s obj.Name = aDTOItem.Name
	s obj.Description = aDTOItem.Description

	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		q strRes
	}
	s strRes = 1
	q strRes
}

}
