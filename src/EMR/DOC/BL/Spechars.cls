/// 名称:	EMR.DOC.BL.Spechars
/// 描述:	特殊字符类
/// 编写者：zhangxl
/// 编写日期: 2021-9-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.Spechars Extends EMR.DOC.COM.ActionBase
{

/// Desc:       创建字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"CREATE_SPECHARS","params":{"category":"0","name":"&&&"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CreateSpechars(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Category = argInJson.params.category
	s strNAME = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.Spechars).CreateSpecharsJson(Category,strNAME)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组ID不能为空",2)	
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

/// Desc:       创建字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.Spechars).CreateSpecharsJson()
ClassMethod CreateSpecharsJson(Category As %String, strNAME As %String)
{
	s strRes ="-100"	
	q:(Category="") "-200"
	q:(strNAME="") "-300"	
	s objCategory=##class(CF.EMR.DOC.SpecharsCategory).%OpenId(Category)
	q:(objCategory="") "-301"	
	s obj=##class(CF.EMR.DOC.Spechars).%New()
	s obj.Category = objCategory
	s obj.CharCode=strNAME
	s obj.CharDesc=strNAME
	s obj.Sequence = $case($d(^CF.EMR.DOC.SpecharsD)>0,0:1,:^CF.EMR.DOC.SpecharsD+1)
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

/// Desc:       更新字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"UPDATE_SPECHARS","params":{"id":1,"name":"%"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateSpechars(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strID = argInJson.params.id
	s strNAME = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.Spechars).UpdateSpecharsJson(strID,strNAME)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)	
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

/// Desc:       更新字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.Spechars).UpdateSpecharsJson(strID,strNAME)
ClassMethod UpdateSpecharsJson(strID As %String, strNAME As %String) As %String
{
	
	s strRes ="-100"	
	q:(strID="") "-200"
	q:(strNAME="") "-300"	
	s obj=##class(CF.EMR.DOC.Spechars).%OpenId(strID)
	q:(obj="") "-301"	
	s obj.CharCode=strNAME
	s obj.CharDesc=strNAME
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

/// Desc:       删除字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数{"action":"DELETE_SPECHARS","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteSpechars(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.Spechars).DeleteSpecharsJson(strID)
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
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到目录","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       删除字符
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// OutPut:     
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.Spechars).DeleteSpecharsJson(strID)
ClassMethod DeleteSpecharsJson(strID As %String) As %String
{
	s strRes = "-100"
	q:(strID="") "-200"
    s obj = ##Class(CF.EMR.DOC.Spechars).%OpenId(strID)
	q:(obj="") "-300"
	s sc = ##class(CF.EMR.DOC.Spechars).%DeleteId(strID)
    q "1"
}

/// Desc:       获取特殊符号
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_DATEFORMAT","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSpechars(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.Spechars).GetSpecharsJson(LangID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取特殊符号
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:   
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Spechars).GeDateFormatJson(.obj)
ClassMethod GetSpecharsJson(aLangID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s arrJson = ##class(%DynamicArray).%New()
	s seq = ""
	for
	{
		s seq = $o(^CF.EMR.DOC.SpecharsCategoryI("IdxSequence",seq))
		q:(seq = "")
		s catagoryId = ""
		for
		{
			s catagoryId = $o(^CF.EMR.DOC.SpecharsCategoryI("IdxSequence",seq,catagoryId)) 
			q:(catagoryId = "")
			s objCagagory = ##Class(CF.EMR.DOC.SpecharsCategory).%OpenId(catagoryId)
			continue:(objCagagory = "")
			s cateName =  ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.Spechars","CategoryDesc",objCagagory.CategoryDesc,aLangID)
			s jsonCat = ##class(%DynamicObject).%New()
			s jsonCat.Code =objCagagory.CategoryCode
			s jsonCat.Desc=cateName
			s jsonValues = ##class(%DynamicArray).%New()
			s cseq = ""
			for 
			{
				s cseq = $o(^CF.EMR.DOC.SpecharsI("IdxCategorySequence",catagoryId,cseq))
				q:(cseq = "")
				s rowId = ""
				for
				{
					s rowId = $o(^CF.EMR.DOC.SpecharsI("IdxCategorySequence",catagoryId,cseq,rowId))
					q:(rowId = "")
					s objSpechars = ##Class(CF.EMR.DOC.Spechars).%OpenId(rowId)
					continue:(objSpechars = "")
					continue:(objSpechars.CharDesc = """")
					s jsonItem = ##class(%DynamicObject).%New()
					s jsonItem.Code =$ZSTRIP(objSpechars.CharCode,"*C")
					s jsonItem.Desc =$ZSTRIP(objSpechars.CharDesc,"*C")
					d jsonValues.%Push(jsonItem)
				}
			}
			s jsonCat.Values = jsonValues
		}
		d arrJson.%Push(jsonCat)
	}
	d arrJson.%ToJSON(argOutData)
	q strRes
}

}
