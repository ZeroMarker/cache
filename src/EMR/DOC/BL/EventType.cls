Class EMR.DOC.BL.EventType Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取事件类型列表
/// Creator:    ningyanghong
/// CreateDate: 2021-12-31
/// Input:      argArray  命令参数 {"action":"GET_EVENT_TYPE","params":{},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetEventType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EventType).GetAllTypes(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取事件出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取所有类型
/// Creator:    ningyanghong
/// CreateDate: 2021-12-31
/// OutPut:     argOutData 返回数据
///     w ##Class(EMR.DOC.BL.SpecharsCategory).GetAllGroupsJson(.argOutData)
ClassMethod GetAllTypes(ByRef argOutData As %GlobalBinaryStream)
{
	s jArr = ##class(%DynamicArray).%New()
	
	s TypeID = ""
	for {
		s TypeID = $o(^CF.EMR.DOC.EventTypeD(TypeID))
		q:(TypeID = "")			
		s objType = ##Class(CF.EMR.DOC.EventType).%OpenId(TypeID)
        continue:(objType="")
        s jsonType  = ##class(%DynamicObject).%New()
        s jsonType.id = TypeID
        s jsonType.code =objType.TypeCode
        s jsonType.name =objType.TypeDesc

        d jArr.%Push(jsonType)
	}
	d jArr.%ToJSON(argOutData)
	q "1"
}

}
