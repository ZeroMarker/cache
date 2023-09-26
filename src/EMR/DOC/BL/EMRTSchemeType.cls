/// 名称:	EMR.DOC.BL.EMRTSchemeType
/// 描述:	展现方案类型表 业务类
/// 编写者：Ningyanghong
/// 编写日期: 2021-9-29
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTSchemeType Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取展现方案类型
/// Creator:    ningyanghong
/// CreateDate: 2021-9-29
/// Input:     
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData :{  
/// 								"id":"1", // 展现方案类型id
/// 								"code":"Archiving", //展现方案类型code值
/// 								"name":"病历归档方案", //展现方案类型名称
/// 						 }
ClassMethod GetSchemeTypeData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeType).GetSchemeTypeDataJson(argOutData)
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

/// Desc:       获取方案类型
/// Creator:    ningyanghong
/// CreateDate: 2021-09-29
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeType).GetSchemeTypeDataJson(.argOutData)
ClassMethod GetSchemeTypeDataJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s TypeID = ""
	s jArrType = ##class(%DynamicArray).%New()
	for {
		s TypeID = $o(^CF.EMR.DOC.EMRTSchemeTypeD(TypeID))
		q:(TypeID = "")			
		s objType = ##Class(CF.EMR.DOC.EMRTSchemeType).%OpenId(TypeID)
        continue:(objType="")
        s jsonType = ##class(%DynamicObject).%New()
        s jsonType.id = TypeID
        s jsonType.code =objType.Code
        s jsonType.name =objType.Name

        d jArrType.%Push(jsonType)
	}
	d jArrType.%ToJSON(argOutData)
	q strRes
}

}
