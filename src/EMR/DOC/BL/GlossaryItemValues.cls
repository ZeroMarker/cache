/// 名称:EMR.DOC.BL.GlossaryItemValues
/// 描述:通用文档管理模块 Document(Doc) 元素值选项类型业务类
/// 编写者：yejian
/// 编写日期: 2021-1-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.GlossaryItemValues Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取元素值类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"GET_GLOSSARY_BINDVTYPES","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryBindVTypes(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.GlossaryItemValues).GetGlossaryBindVTypesJson(.argOutData)
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

/// Desc:       根据节点type获取取值类型\关联类型
/// Creator:    Ningyanghong
/// CreateDate: 2021-08-12
/// Input:      argArray  命令参数 {"Action":"GET_GLOSSARY_VALUES","params":{"miType":"string"},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryValueTypes(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s miType = argInJson.params.miType
    s strRes = ##Class(EMR.DOC.BL.GlossaryItemValues).GetGlossaryValueTypesJson(miType,.argOutData)
    //失败: -200 节点类型为空, -300 节点类型不存在
	if (strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","节点类型不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","节点类型不存在","2")
	}elseif(strRes="1"){
		q argOutMessage.success = ..#OK
	}elseif(strRes = "-301")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","关联类型不存在","2")
	}else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误","2")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取取值类型JSON
/// Creator:    Ningyanghong
/// CreateDate: 2020-08-12
/// Input:      aType	节点类型
/// OutPut:     成功 1 失败 -200 节点类型未传
///                         -300 节点类型不存在
/// 							-301 关联类型不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod GetGlossaryValueTypesJson(aType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(aType="") "-200"
	s RowID = $o(^CT.EMR.DOC.TemElementTypesI("IdxCode"," "_$zcvt(aType,"U"),""))
	q:(RowID="") "-300"
	// 根据RowID去查找取值类型和关联类型
	s ID = ""
	&sql(SELECT ID into :ID FROM CF_EMR_DOC.GlossaryItemValues WHERE MiType = :RowID )
	q:(ID="") "-301"
	s objItem = ##Class(CF.EMR.DOC.GlossaryItemValues).%OpenId(ID)
	s jsonItem  = ##class(%DynamicObject).%New()
    s itemTypeId =objItem.ItemType.%Id()
    s Code=""
    &sql(SELECT Code into :Code FROM CF_EMR_DOC.GlossaryItemType WHERE ID = :itemTypeId )
    s jsonItem.itemType = Code
    s jsonItem.vTypeItem =##class(%DynamicAbstractObject).%FromJSON(objItem.VTypeItem)
    ;s jsonArr = ##class(%DynamicObject).%New()
	;d jsonArr.%Push(jsonItem)
	d jsonItem.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取元素值类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItemValues).GetGlossaryBindVTypesJson(argOutData)
ClassMethod GetGlossaryBindVTypesJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.GlossaryItemValuesD(rowID))
		q:(rowID = "")				
		s obj = ##Class(CF.EMR.DOC.GlossaryItemValues).%OpenId(rowID)
        continue:(obj="")
        s jsonVTypes  = ##class(%DynamicObject).%New()
        s jsonVTypes.MiType =$Case(obj.MiType, "":"",:obj.MiType.Code)
        s jsonVTypes.ItemType =$Case(obj.ItemType, "":"",:obj.ItemType.Code)
		if (obj.VTypeItem'="")
        {
	        s strItem = ##class(%DynamicAbstractObject).%FromJSON(obj.VTypeItem)
	        s jsonVTypes.VTypeItem = strItem
        }
        else
        {
        	s jsonVTypes.VTypeItem =""
        }
		d jsonArr.%Push(jsonVTypes)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

}
