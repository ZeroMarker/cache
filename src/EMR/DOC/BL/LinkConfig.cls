/// 名称:		EMR.DOC.BL.ResourceConfig
/// 描述:		链接单元公共字典集配置方法类
/// 编写者:		huhao
/// 编写日期: 	2022-10-21
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.LinkConfig Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取链接单元字典集配置项
/// Creator:    huhao
/// CreateDate: 2022/10/27
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetLinkConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s name=argInJson.params.Name
	s product=argInJson.params.Product
	s code=argInJson.params.Code
	
	s strRes = ##class(EMR.DOC.BL.LinkConfig).GetLinkData(name,code,product,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       获取链接单元字典集配置项
/// Creator:    huhao
/// CreateDate: 2022/10/27
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:       	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetLinkData(name As %String, code As %String, product As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="-1^没有对应数据",rowId=""
	s resArr=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowId=$o(^CF.EMR.DOC.LinkConfigD(rowId))
		q:rowId=""
		s obj=##class(CF.EMR.DOC.LinkConfig).%OpenId(rowId)
		if (product'="")
		{
			continue:(obj.Product.ProductName'=product)
		}
		continue:(obj.Name'[name)
		continue:(obj.Code'[code)
		s resObj.key=rowId
		S resObj.Code=obj.Code
		s resObj.IsDirectOpen=obj.IsDirectOpen
		s resObj.Method=obj.Method
		s resObj.Name=obj.Name
		s resObj.Product=obj.Product.ProductName
		s resObj.Scheme=obj.Scheme
		s resObj.Src=obj.Src
		d resArr.%Push(resObj)
		s strRes="1"
	}
	d resArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       新增链接单元配置项
/// Creator:    huhao
/// CreateDate: 2022/10/27
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod AddLinkConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO=##class(EMR.DOC.DTO.LinkConfig).%New()
	s argDTO.Code=argInJson.params.Code
	s argDTO.IsDirectOpen=argInJson.params.IsDirectOpen
	s argDTO.Method=argInJson.params.Method
	s argDTO.Name=argInJson.params.Name
	s argDTO.Product=argInJson.params.Product
	s argDTO.Scheme=argInJson.params.Scheme
	s argDTO.Src=argInJson.params.Src
	s strRes = ##class(EMR.DOC.BL.LinkConfig).AddLinkData(argDTO,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       新增链接单元配置项
/// Creator:    huhao
/// CreateDate: 2022/10/27
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:      argDTO 链接单元dto对象 	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod AddLinkData(argDto As EMR.DOC.DTO.LinkConfig, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="1",rowId=""
	Q:argDto.Code="" "-1^code不能为空"
	s rowId=$o(^CF.EMR.DOC.LinkConfigI("IdxCode"," "_$zcvt(argDto.Code,"U"),rowId))
	q:rowId'="" "-1^已存在同名链接单元配置"
	s prcObj=##class(CT.EMR.DOC.Products).%OpenId(argDto.Product)
	q:prcObj="" "-1^项目标识有误"
	s obj=##class(CF.EMR.DOC.LinkConfig).%New()
	s obj.Code=argDto.Code
	s obj.IsDirectOpen=argDto.IsDirectOpen
	s obj.Method=argDto.Method
	s obj.Name=argDto.Name
	s obj.Product=##class(CT.EMR.DOC.Products).%OpenId(argDto.Product)
	s obj.Scheme=argDto.Scheme
	s obj.Src=argDto.Src
	d obj.%Save()
	q strRes
}

/// Desc:       更新链接单元配置项
/// Creator:    huhao
/// CreateDate: 2022/10/27
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpdateLinkConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s id=argInJson.params.Id
	s argDTO=##class(EMR.DOC.DTO.LinkConfig).%New()
	s argDTO.Code=argInJson.params.Code
	s argDTO.IsDirectOpen=argInJson.params.IsDirectOpen
	s argDTO.Method=argInJson.params.Method
	s argDTO.Name=argInJson.params.Name
	s argDTO.Product=argInJson.params.Product
	s argDTO.Scheme=argInJson.params.Scheme
	s argDTO.Src=argInJson.params.Src

	
	s strRes = ##class(EMR.DOC.BL.LinkConfig).UpdateLinkData(argDTO,id,.argInData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       更新链接单元配置项
/// Creator:    huhao
/// CreateDate: 2022/10/28
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:      argDto链接单元参数对象  id配置项ID  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpdateLinkData(argDTO As EMR.DOC.DTO.LinkConfig, Id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="1",rowId=""
	s obj=##class(CF.EMR.DOC.LinkConfig).%OpenId(Id)
	q:obj="" "-1^请检查id"
	if (obj.Code=argDTO.Code)
	{
		s obj.Code=argDTO.Code
	}
	else
	{
		s rowId=$o(^CF.EMR.DOC.LinkConfigI("IdxCode"," "_$zcvt(argDTO.Code,"U"),rowId))
		q:rowId'="" "-1^code重复"
		s obj.Code=argDTO.Code
	}
	s obj.IsDirectOpen=argDTO.IsDirectOpen
	s obj.Method=argDTO.Method
	s obj.Name=argDTO.Name
	s obj.Product=##class(CT.EMR.DOC.Products).%OpenId(argDTO.Product)
	s obj.Scheme=argDTO.Scheme
	s obj.Src=argDTO.Src
	d obj.%Save()
	q strRes
}

/// Desc:       删除链接单元配置项
/// Creator:    huhao
/// CreateDate: 2022/10/28
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod DeleteLinkConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.Id
	s strRes = ##class(EMR.DOC.BL.LinkConfig).DeleteLinkData(id,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       删除链接单元配置项
/// Creator:    huhao
/// CreateDate: 2022/10/28
/// Table:		CF.EMR.DOC.LinkConfig
/// Input:      id 链接单元配置项id  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod DeleteLinkData(id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:id="" "-1^未传入id"
	s obj=##class(CF.EMR.DOC.LinkConfig).%OpenId(id)
	q:obj="" "-1^配置项不存在"
	s sc = ##class(CF.EMR.DOC.LinkConfig).%DeleteId(id)
	if '(sc)
	{
		q "-1^删除失败"
	}

	q "1"
}

}
