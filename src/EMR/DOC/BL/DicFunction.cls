/// 名称:	EMR.DOC.BL.DicFunction
/// 描述:	通用文档管理模块 Document(Doc) 功能字典表
/// 编写者:	yejian
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.DicFunction Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取所有功能操作
/// Creator:    yejian
/// CreateDate: 2021-3-11
/// Input:      argArray  命令参数 {"params":{"action":"GET_RBAC_DICFUNCTION","args":{}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACDicFunction(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.DicFunction).GetRBACDicFunctionJson(argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取功能操作数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取所有功能操作
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argParentCode 父节点编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DicFunction).GetRBACDicFunctionJson(argOutData)
/// 			d jArrMeun.%ToJSON(argOutData)
ClassMethod GetRBACDicFunctionJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s rowID = ""
    s jsonMenuDoc  = ##class(%DynamicObject).%New()
    s jsonMenuDoc.key ="0"
    s jsonMenuDoc.title ="系统功能项"
    s jsonMenuDoc.type ="RT"
    s jArrMenu = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.DicFunction).GetRBACDicFunctionDatas("MENU",.jArrMenu)
    s jsonMenuDoc.children = jArrMenu
    d jsonMenuDoc.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取所有功能操作
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argParentCode 父节点编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			s jArrMeun = ##class(%DynamicArray).%New()
///             w ##class(EMR.DOC.BL.DicFunction).GetRBACDicFunctionJson("MENU",jArrMeun)
/// 			d jArrMeun.%ToJSON(argOutData)
ClassMethod GetRBACDicFunctionDatas(argParentCode As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s rowID = ""
	for {
		s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(argParentCode,"U"),rowID))
		q:(rowID = "")				
		s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
        continue:(obj="")
        s jsonMenuDoc  = ##class(%DynamicObject).%New()
        s jsonMenuDoc.key =rowID
        s jsonMenuDoc.code =obj.FuncCode
        s jsonMenuDoc.title =obj.FuncName
        s jsonMenuDoc.type =obj.Type.Code
        s jsonMenuDoc.parentCode = obj.ParentCode
        s jsonMenuDoc.parentId = obj.ParentID
        s jsonMenuDoc.sequence = obj.Sequence
		s arrItem = ##class(%DynamicArray).%New()
		s result =  ##Class(EMR.DOC.BL.DicFunction).GetRBACDicFunctionDatas(obj.FuncCode,.arrItem)
		//Items数据存在，才显示Items
		if (arrItem.%Size()>0)
		{
			s jsonMenuDoc.children =arrItem
		}
		d jsonArr.%Push(jsonMenuDoc)
	}
	q strRes
}

}
