/// 名称:	EMR.DOC.BL.SpecharsCategory
/// 描述:	特殊字符分组类
/// 编写者：zhangxl
/// 编写日期: 2021-9-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.SpecharsCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       创建分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"CREATE_SPECHARS_CATEGORY","params":{"name":"自定义"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CreateSpecharsCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strNAME = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.SpecharsCategory).CreateSpecharsCategoryJson(strNAME)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内容不能为空",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       创建分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.TextKBCategory).CreateSpecharsCategoryJson(.argOutData)
ClassMethod CreateSpecharsCategoryJson(strNAME As %String)
{
	s strRes ="-100"
	q:(strNAME="") "-200"
	s obj=##class(CF.EMR.DOC.SpecharsCategory).%New()
	s obj.CategoryCode=strNAME
	s obj.CategoryDesc=strNAME
	s obj.Sequence = $case($d(^CF.EMR.DOC.SpecharsCategoryD)>0,0:1,:^CF.EMR.DOC.SpecharsCategoryD+1)
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{		
		 q obj.%Id()
	}
	else
	{
		 q strRes
	}
}

/// Desc:       更新分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数  {"action":"UPDATE_SPECHARS_CATEGORY","params":{"id":1,"name":"%"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateSpecharsCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strID = argInJson.params.id
	s strNAME = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.SpecharsCategory).UpdateSpecharsCategoryJson(strID,strNAME)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内容不能为空",2)	
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID未查到",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       更新分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.TextKBCategory).UpdateSpecharsCategoryJson(strID,strNAME)
ClassMethod UpdateSpecharsCategoryJson(strID As %String, strNAME As %String)
{
	s strRes ="-100"
	q:(strID="") "-200"
	q:(strNAME="") "-300"
	s obj=##class(CF.EMR.DOC.SpecharsCategory).%OpenId(strID)
	q:(obj="") "-301"	
	s obj.CategoryCode=strNAME
	s obj.CategoryDesc=strNAME
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{		
		 q obj.%Id()
	}
	else
	{
		 q strRes
	}
}

/// Desc:       删除分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"DELETE_SPECHARS_CATEGORY","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteSpecharsCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.SpecharsCategory).DeleteSpecharsCategoryJson(strID)
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败","2")
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到分组目录","2")
	}
	elseif(strRes = "-301")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","分组目录存在字符，删除失败","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       删除分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.TextKBCategory).DeleteSpecharsCategoryJson()
ClassMethod DeleteSpecharsCategoryJson(strID As %String)
{
	s strRes = "-100"
	q:(strID="") "-200"
    s obj = ##Class(CF.EMR.DOC.SpecharsCategory).%OpenId(strID)
	q:(obj="") "-300"
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.Spechars WHERE Category = :strID )
 	q:(count>0) "-301"
	s sc = ##Class(CF.EMR.DOC.SpecharsCategory).%DeleteId(strID)
    q "1"
}

/// Desc:       获取所有分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"GET_ALL_CATEGORY","params":{},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.SpecharsCategory).GetAllCategoryJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取所有分组
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.SpecharsCategory).GetAllCategoryJson(.argOutData)
ClassMethod GetAllCategoryJson(ByRef argOutData As %GlobalBinaryStream)
{
	s seq =""
	s jsonArr = ##class(%DynamicArray).%New()
	for
	{
		s seq = $o(^CF.EMR.DOC.SpecharsCategoryI("IdxSequence",seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^CF.EMR.DOC.SpecharsCategoryI("IdxSequence",seq,rowId))
			q:(rowId = "")
			s obj = ##Class(CF.EMR.DOC.SpecharsCategory).%OpenId(rowId)
			continue:(obj = "")
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.id= rowId
			s jsonItem.CategoryCode= obj.CategoryCode
			s jsonItem.CategoryDesc= obj.CategoryDesc
			s jsonItem.Sequence= obj.Sequence
			d jsonArr.%Push(jsonItem)
		}
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取分组下的所有字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"GET_SPECHARS_BYCATEGORY","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSpecharsByCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.SpecharsCategory).GetSpecharsByCategoryJson(strID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取单个分组下的所有字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.SpecharsCategory).GetSpecharsByCategoryJson(.argOutData)
ClassMethod GetSpecharsByCategoryJson(strID As %String, ByRef argOutData As %GlobalBinaryStream)
{
	
	s jsonArr = ##class(%DynamicArray).%New()
    s jsonRoot  = ##class(%DynamicObject).%New()
    s objCate = ##class(CF.EMR.DOC.SpecharsCategory).%OpenId(strID)
    q:(objCate="") "-100"
    s jsonRoot.id =strID
    s jsonRoot.Sequence=objCate.Sequence
    s jsonRoot.CategoryCode=objCate.CategoryCode
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.SpecharsCategory).GetJsonCategroyByID(strID,jsonRoot,.jsonCategory)	
	s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
	d jsonArr.%Push(jsonRoot)
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取特殊符号数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.TextKBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(id As %String, jsonRoot As %DynamicArray, ByRef jsonCategory As %DynamicArray) As %String
{
	s seq =""
	s jsonArr = ##class(%DynamicArray).%New()
	for
	{
		s seq = $o(^CF.EMR.DOC.SpecharsI("IdxCategorySequence",id,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^CF.EMR.DOC.SpecharsI("IdxCategorySequence",id,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(CF.EMR.DOC.Spechars).%OpenId(rowId)
			continue:(obj = "")
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.id= rowId
			s jsonItem.CharCode= obj.CharCode
			s jsonItem.Sequence= obj.Sequence
			d jsonCategory.%Push(jsonItem)
		}
	}
	s strRes = "1"
	q strRes
}

}
