/// 名称:	EMR.DOC.BL.Tooth
/// 描述:	获取牙位图业务逻辑
/// 编写者：yejian
/// 编写日期: 2023-3-28
/// 产品组：电子病历产品组
Class EMR.DOC.BL.Tooth Extends EMR.DOC.COM.ActionBase
{

/// Desc:      获取牙位信息
/// Creator:    yejian
/// CreateDate: 2023-3-28
/// Table:		CF.EMR.DOC.ToothPosition
/// Input:      argInJson  命令参数 {"action":"GET_TOOTHPOSITION","params":{},"product":"OP"}
/// 			userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetToothPosition(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.Tooth).GetToothPositionJson(strProduct,.argOutData)
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

/// Desc:      获取牙位信息
/// Creator:    yejian
/// CreateDate: 2023-3-28
/// Table:		
/// Input:   	aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Tooth).GetToothPositionJson(.obj)
ClassMethod GetToothPositionJson(aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s $zt = "Error"
	q:(aProduct="") "-1^项目标识不能为空"
	s toothREP = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("toothDefaultREP",aProduct,"FDI")
	s retJson = ##class(%DynamicObject).%New()
	s arrJson = ##class(%DynamicArray).%New()
	s rowID = 0
	for {
		s rowID = $o(^CT.EMR.DOC.ToothREPD(rowID))
		q:(rowID = "")
		s objToothREP = ##class(CT.EMR.DOC.ToothREP).%OpenId(rowID)
		s repJson = ##class(%DynamicObject).%New()
		s repJson.ID = rowID
		s repJson.Code = objToothREP.Code
		s repJson.Status = $case(toothREP,objToothREP.Code:1,:0)
		s repJson.Desc = objToothREP.Name
		s repJson.toothCodeSystem = objToothREP.SystemCode
		s repJson.toothCodeSystemName = objToothREP.SystemName
		s repJson.toothSurfaceCodeSystem = objToothREP.SystemCode
		s repJson.toothSurfaceCodeSystemName = objToothREP.SystemName
		s poJson = ##class(%DynamicObject).%New()
		s rowPID = 0
		for {
			s rowPID = $o(^CF.EMR.DOC.ToothPositionI("IdxToothREP",rowID,rowPID))
			q:(rowPID = "")
			s objToothPosition = ##class(CF.EMR.DOC.ToothPosition).%OpenId(rowPID)
			s toothCode = objToothPosition.Tooth.Code
			s itemJson = ##class(%DynamicObject).%New()
			s itemJson.ToothPDes = objToothPosition.Define
			s itemJson.ToothPQuadrant = objToothPosition.Quadrant
			d poJson.%Set(toothCode,itemJson)
		}
		d repJson.%Set("ToothIdent",poJson)
		d arrJson.%Push(repJson)
	}
	d retJson.%Set("ident",arrJson)
	s retJson.select=toothREP
	d retJson.%ToJSON(argOutData)
    q strRes
Error
	q "-1^获取牙位信息失败"_$zerror
}

/// Desc:      获取牙面信息
/// Creator:    yejian
/// CreateDate: 2023-3-28
/// Table:		CF.EMR.DOC.ToothPosition
/// Input:      argInJson  命令参数 {"action":"GET_TOOTHSURFACE","params":{},"product":"OP"}
/// 			userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData  
ClassMethod GetToothSerface(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.Tooth).GetToothSerfaceJson(strProduct,.argOutData)
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

/// Desc:      获取牙面信息
/// Creator:    yejian
/// CreateDate: 2023-3-28
/// Table:		
/// Input:   	aProduct 项目标识
/// Output:     json数组
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.Tooth).GetToothSerfaceJson(.obj)
ClassMethod GetToothSerfaceJson(aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s $zt = "Error"
	s retJson = ##class(%DynamicObject).%New()
	s toothCode = ""
	for {
		s toothCode = $o(^CT.EMR.DOC.ToothI("IdxCode",toothCode))
		q:(toothCode = "")
		s toothID = $o(^CT.EMR.DOC.ToothI("IdxCode",toothCode,""))
		continue:(toothID = "")
		s objTooth = ##class(CT.EMR.DOC.Tooth).%OpenId(toothID)
		s toothJson = ##class(%DynamicObject).%New()
		s toothJson.ID = toothID
		s toothJson.Code = objTooth.Code
		s toothJson.Desc = $e(objTooth.Code,4,4)
		s toothJson.Define = objTooth.Name
		s toothJson.Quadrant = $e(objTooth.Code,2,2)
		s toothJson.Type = objTooth.Type
		s surfobjJson = ##class(%DynamicObject).%New()
		s surID=""
		for {
			s surID = $o(^CF.EMR.DOC.ToothSurfaceItemI("IdxTooth",toothID,surID))
			q:(surID = "")
			s objToothSur = ##class(CF.EMR.DOC.ToothSurfaceItem).%OpenId(surID)
			s surJson = ##class(%DynamicObject).%New()
			s surJson.ID = surID
			s surJson.ToothPCode = objTooth.Code
			s surJson.ToothSICode = objToothSur.ToothSICode
			s surJson.ToothSIDes = objToothSur.ToothSCode
			s surJson.ToothSIDefine = objToothSur.ToothSIDes
			s surJson.ToothType = objTooth.Type
			s surJson.SurfaceDefine = objToothSur.ToothSDes
			d surfobjJson.%Set(objToothSur.ToothSCode,surJson)
		}
		s toothJson.SurfaceObj=surfobjJson
		d retJson.%Set(objTooth.Code,toothJson)
	}
	d retJson.%ToJSON(argOutData)
    q strRes
Error
	q "-1^获取牙面信息失败"_$zerror
}

}
