/// 名称:	EMR.DOC.BL.ResourceConfig
/// 描述:	资源区字典集配置方法类
/// 编写者:	huhao
/// 编写日期: 	2022-10-21
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.ResourceConfig Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取资源区配置数据
/// Creator:    huhao
/// CreateDate: 2022/10/21
/// Table:		CF.EMR.DOC.Resource
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetResourceData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s title=argInJson.params.Title
	s product=argInJson.params.Product
	s name=argInJson.params.Name
	
	s strRes = ##class(EMR.DOC.BL.ResourceConfig).GetResData(title,product,name,.argOutData)
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

/// Desc:       获取资源区配置数据
/// Creator:    huhao
/// CreateDate: 2022/10/21
/// Table:		CF.EMR.DOC.Resource
/// Input:        	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetResData(title As %String, product As %String, name As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="-1^没有对应数据",rowid=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowid=$o(^CF.EMR.DOC.ResourceD(rowid))
		s obj=##class(CF.EMR.DOC.Resource).%OpenId(rowid)
		q:obj=""
		if (product'="")
		{
			continue:(obj.Product.ProductName'=product)
		}
		continue:(obj.Name'[name)
		continue:(obj.Title'[title)
		s resObj.key=rowid
		s resObj.Product=obj.Product.ProductName
		s resObj.Name=obj.Name
		s resObj.RefreshOnSelect=obj.RefreshOnSelect
		s resObj.Scrolling=obj.Scrolling
		s resObj.Zoom=obj.Zoom
		s resObj.Visible=obj.Visible
		s resObj.Href=obj.Href
		s resObj.Content=obj.Content
		s resObj.Frame=obj.Frame
		s resObj.Title=obj.Title
		s resObj.Position=obj.Position
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       新增资源区配置项
/// Creator:    huhao
/// CreateDate: 2022/10/21
/// Table:		CF.EMR.DOC.Resource
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod AddResourceData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDto=##class(EMR.DOC.DTO.Resource).%New()
	s argDto.Content=argInJson.params.Content
	s argDto.Frame=argInJson.params.Frame
	s argDto.Href=argInJson.params.Href
	s argDto.Name=argInJson.params.Name
	s argDto.Product=argInJson.params.Product
	s argDto.RefreshOnSelect=argInJson.params.RefreshOnSelect
	s argDto.Scrolling=argInJson.params.Scrolling
	s argDto.Title=argInJson.params.Title
	s argDto.Visible=argInJson.params.Visible
	s argDto.Zoom=argInJson.params.Zoom

	s strRes = ##class(EMR.DOC.BL.ResourceConfig).AddResData(argDto)
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

/// Desc:       新增资源区配置项
/// Creator:    huhao
/// CreateDate: 2022/10/21
/// Table:		CF.EMR.DOC.Resource
/// Input:      argDto As EMR.DOC.DTO.Resource:资源区表属性dto   	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod AddResData(argDto As EMR.DOC.DTO.Resource) As %String
{
	s strRes="",rowId=""
	s rowId=$o(^CF.EMR.DOC.ResourceI("IdxMain",argDto.Product," "_$zcvt( argDto.Name,"U"),rowId))
	q:rowId'="" "-1^该配置已存在"
	s resObj=##class(CF.EMR.DOC.Resource).%New()
	s resObj.Content=argDto.Content
	s resObj.Frame=argDto.Frame
	s resObj.Href=argDto.Href
	s resObj.Name=argDto.Name
	s resObj.Position=+(^CF.EMR.DOC.ResourceD)+1
	s prtObj=##class(CT.EMR.DOC.Products).%OpenId(argDto.Product)
	q:prtObj="" "-1^产品标识不存在"
	s resObj.Product=prtObj
	s resObj.RefreshOnSelect=argDto.RefreshOnSelect
	s resObj.Scrolling=argDto.Scrolling
	s resObj.Title=argDto.Title
	s resObj.Visible=argDto.Visible
	s resObj.Zoom=argDto.Zoom
	d resObj.%Save()
	q "1"
}

/// Desc:       更新资源区配置项
/// Creator:    huhao
/// CreateDate: 2022/10/21
/// Table:		CF.EMR.DOC.Resource
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpdateResourceData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.Id
	s argDto=##class(EMR.DOC.DTO.Resource).%New()
	s argDto.Content=argInJson.params.Content
	s argDto.Frame=argInJson.params.Frame
	s argDto.Href=argInJson.params.Href
	s argDto.Name=argInJson.params.Name
	s argDto.Position=argInJson.params.Position
	s argDto.Product=argInJson.params.Product
	s argDto.RefreshOnSelect=argInJson.params.RefreshOnSelect
	s argDto.Scrolling=argInJson.params.Scrolling
	s argDto.Title=argInJson.params.Title
	s argDto.Visible=argInJson.params.Visible
	s argDto.Zoom=argInJson.params.Zoom
	s strRes = ##class(EMR.DOC.BL.ResourceConfig).UpdateResData(id,argDto,.argOutData)
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

/// Desc:       更新资源区配置项
/// Creator:    huhao
/// CreateDate: 2022/10/21
/// Table:		CF.EMR.DOC.Resource
/// Input:      id：资源区配置项id
/// 			argDto：resource DTO对象		  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpdateResData(id As %String, argDto As EMR.DOC.DTO.Resource, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="",rowId=""
	q:(id="") "-1^id不能为空"
	s obj=##class(CF.EMR.DOC.Resource).%OpenId(id)
	q:obj="" "-1^不存在该条配置"
	if ((argDto.Name=obj.Name)&&(argDto.Product=obj.Product.%Id())) { 
		s obj.Name=argDto.Name
		s obj.Product=##class(CT.EMR.DOC.Products).%OpenId(argDto.Product)
	}
	else
	{
		s rowId=$o(^CF.EMR.DOC.ResourceI("IdxMain",argDto.Product," "_$zcvt( argDto.Name,"U"),rowId))
		q:rowId'="" "-1^该配置已存在"
		s obj.Name=argDto.Name
		s prtObj=##class(CT.EMR.DOC.Products).%OpenId(argDto.Product)
		q:prtObj="" "-1^产品标识不存在"
		s obj.Product=prtObj

	}
	s obj.Content=argDto.Content
	s obj.Frame=argDto.Frame
	s obj.Href=argDto.Href
	s obj.Position=argDto.Position
	s obj.RefreshOnSelect=argDto.RefreshOnSelect
	s obj.Scrolling=argDto.Scrolling
	s obj.Title=argDto.Title
	s obj.Visible=argDto.Visible
	s obj.Zoom=argDto.Zoom
	d obj.%Save()
	q "1"
}

/// Desc:       删除资源区配置项
/// Creator:    huhao
/// CreateDate: 2022/10/24
/// Table:		CF.EMR.DOC.Resource
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod DeleteResourceData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.Id
	s strRes = ##class(EMR.DOC.BL.ResourceConfig).DeleteResData(id)
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

/// Desc:       删除资源区配置项
/// Creator:    huhao
/// CreateDate: 2022/10/24
/// Table:		CF.EMR.DOC.Resource
/// Input:      Id：删除项ID  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod DeleteResData(Id As %String) As %String
{
	s strRes=""
	s obj=##class(CF.EMR.DOC.Resource).%OpenId(Id)
	q:obj="" "-1^配置项不存在"
	s sc = ##class(CF.EMR.DOC.Resource).%DeleteId(Id)
	if '(sc)
	{
		q "-1^删除失败"
	}

	q "1"
}

}
