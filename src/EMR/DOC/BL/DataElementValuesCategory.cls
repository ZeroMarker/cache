/// 名称:	EMR.DOC.BL.DataElementValuesCategory
/// 描述:	通用文档管理模块 Document(Doc) 术语集数据元值目录业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DataElementValuesCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取元值类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_DATAELEMENT_ITEMVALUES","params":"","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataElementItemValues(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = ..GetIDByKey(argInJson.params.id)
	/// OutPut:     成功 1 失败 -200 数据元ID未传  -301 数据元记录不存在 -302 数据元目录ID不存在
    s strRes = ##Class(EMR.DOC.BL.DataElementValuesCategory).GetDataElementItemValuesJson(ID,.argOutData)
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes=-200)
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据元ID未传",2)
	}
	elseif(strRes=-301)
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据元记录不存在",2)
	}
	elseif(strRes=-302)
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据元目录ID不存在",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取元值数据类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_DATAELEMENT_FORMATVAVALUES","params":"","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataElementFormatValues(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.DataElementValuesCategory).GetDataElementFormatValuesJson(.argOutData)
	if (strRes = "1")
	{ 
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

/// Desc:       获取元素值类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aID  数据元ID，
/// OutPut:     成功 1 失败 -200 数据元ID未传  -301 数据元记录不存在 -302 数据元目录ID不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DataElementValuesCategory).GetGlossaryBindVTypesJson(argOutData)
ClassMethod GetDataElementItemValuesJson(aID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = 1
	s jsonArr = ##class(%DynamicArray).%New()
	q:aID="" -200
	s ObjDataElement = ##class(CF.EMR.DOC.DataElement).%OpenId(aID)
	q:ObjDataElement="" -301
	s CategoryID = ObjDataElement.Category.%Id()
	q:CategoryID="" -302
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.DEVCategoryI("IdxCategoryID",CategoryID,rowID))
		q:(rowID="")
		s obj = ##Class(CF.EMR.DOC.DataElementValuesCategory).%OpenId(rowID)
        continue:(obj="")
        ;s jsonItem  = ##class(%DynamicObject).%New()
        ;s jsonItem.decvmID =$Case(obj.DECVMID, "":"",:obj.DECVMID)
		d jsonArr.%Push(obj.DECVMID)
	}
	d jsonArr.%ToJSON(argOutData)

	q 1
}

/// Desc:       获取元素值类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DataElementValuesCategory).GetDataElementFormatValuesJson(argOutData)
ClassMethod GetDataElementFormatValuesJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s jsonArr = ["S","S1","S2","S3","L","N","D","DT","T","BY"]

	d jsonArr.%ToJSON(argOutData)

	q strRes
}

}
