/// 名称:	EMR.DOC.BL.ToothPosition
/// 描述:	牙位图
/// 编写者：zhangxl
/// 编写日期: 2021-10-11
/// 产品组：电子病历产品组
Class EMR.DOC.BL.ToothPosition Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取当前牙位表示法
/// Creator:    zhangxl
/// CreateDate: 2021-10-11
/// Input:      argArray  	命令参数 {"action":"GET_TOOTH_REPRESENTATION","params":{},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 
ClassMethod GetToothRepresentation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.ToothPosition).GetToothRepresentationJson(.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取当前牙位表示法
/// Creator:    zhangxl
/// CreateDate: 2021-10-11
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             W ##Class(EMR.DOC.BL.ToothPosition).SetQuadrantDatasJson(.argOutData)
ClassMethod GetToothRepresentationJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = ""
	s jsonArr = ##class(%DynamicArray).%New()
	s ToothCode = ""
	s ToothCode = $o(^CF.EMR.DOC.ToothRtationI("IdxStatusCode"," 1",ToothCode))
	q:(ToothCode="") strRes
	s rowID = $o(^CF.EMR.DOC.ToothRtationI("IdxStatusCode"," 1",$ZCVT(ToothCode,"U"),""))
	q:(rowID="") strRes
	s objTooth=##class(CF.EMR.DOC.ToothRepresentation).%OpenId(rowID)
	s jsonItem  = ##class(%DynamicObject).%New()
	s jsonItem.ID = objTooth.%Id()
	s jsonItem.ToothCode = objTooth.ToothCode
	s jsonItem.ToothName = objTooth.ToothName
	s jsonItem.Status = objTooth.Status
	d jsonArr.%Push(jsonItem)
    d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc: 初始化牙位表示法相关数据
/// Creator:zhangxl
/// CreateDate:2021-10-27
/// Debug:d ##Class(EMR.DOC.BL.ToothPosition).InitData()
ClassMethod InitData()
{
		//FDI：FDI牙位表示法,PALMER：帕尔默牙位表示法,UNIVERSAL：通用记录表示法,GB/T9938-2013：牙科学牙位和口腔区域的标示法
		d ##Class(EMR.DOC.BL.ToothPosition).AddData("FDI","FDI牙位表示法",1)
		d ##Class(EMR.DOC.BL.ToothPosition).AddData("PALMER","帕尔默牙位表示法",0)	
		d ##Class(EMR.DOC.BL.ToothPosition).AddData("UNIVERSAL","通用记录表示法",0)
		d ##Class(EMR.DOC.BL.ToothPosition).AddData("GB/T9938-2013","牙科学牙位和口腔区域的标示法",0)
}

/// Desc:添加牙位表示法
/// Creator:zhangxl
/// CreateDate:2021-10-28
/// Input: ACode 编码
///       AName 名称
///       AStatus 状态
ClassMethod AddData(ACode As %String, AName As %String, AStatus As %String) As %String
{
		s result = ""
		q:(ACode = "")||(AName = "")||(AStatus = "") result
		s rowId = $o(^CF.EMR.DOC.ToothRtationI("IdxCode"," "_$zcvt(ACode,"u"),""))
		if (rowId = "")
		{
			s obj = ##Class(CF.EMR.DOC.ToothRepresentation).%New()
		}
		else
		{
			s obj = ##Class(CF.EMR.DOC.ToothRepresentation).%OpenId(rowId)
		}
		s obj.ToothCode = ACode
		s obj.ToothName = AName
		s obj.Status = AStatus
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:       更新牙位表示法
/// Creator:    zhangxl
/// CreateDate: 2021-10-11
/// Input:      argArray  	命令参数 {"action":"UPDATE_TOOTH_REPRESENTATION","params":{"toothCode":"FDI"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 
ClassMethod UpdateToothRepresentation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s toothCODE = argInJson.params.toothCode
    s strRes = ##Class(EMR.DOC.BL.ToothPosition).UpdateToothRepresentationJson(toothCODE)
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
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新牙位表示法
/// Creator:    zhangxl
/// CreateDate: 2021-10-11
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             W ##Class(EMR.DOC.BL.ToothPosition).UpdateToothRepresentationJson(.argOutData)
ClassMethod UpdateToothRepresentationJson(toothCODE As %String)
{
	s res ="1"
	s ToothCode = ""
	for {
		s ToothCode = $o(^CF.EMR.DOC.ToothRtationI("IdxCode",ToothCode))
		q:(ToothCode="")
		s rowID = $o(^CF.EMR.DOC.ToothRtationI("IdxCode",ToothCode,""))
		q:(rowID="")
		set objTooth=##class(CF.EMR.DOC.ToothRepresentation).%OpenId(rowID)
		q:(objTooth="")
		if (objTooth.ToothCode = toothCODE)
		{
			s objTooth.Status = "1"
		}
		else
		{
			s objTooth.Status = "0"
		}
		s sc = objTooth.%Save()
		if ('$$$ISOK(sc))
		{		
			 s res = "-1"
			 q
		}
	}
	q res
}

/// Desc:       批量更新牙位象限
/// Creator:    zhangxl
/// CreateDate: 2021-10-11
/// Input:      argArray  	命令参数 {"action":"UPDATE_ALLTOOTH_QUA","params":"","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 
ClassMethod UpdateAllToothQua(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.ToothPosition).UpdateAllToothQuaJson(.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       批量更新牙位象限
/// Creator:    zhangxl
/// CreateDate: 2021-10-11
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             W ##Class(EMR.DOC.BL.ToothPosition).UpdateAllToothQuaJson(.argOutData)
ClassMethod UpdateAllToothQuaJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s result = "1"
	s objCruTooth = ##Class(EMR.DOC.BL.ToothPosition).GetCurToothRepresentation()
	if ((objCruTooth="")||(objCruTooth.ToothCode=""))
	{
		d ##Class(EMR.DOC.BL.ToothPosition).InitData()
		s objCruTooth = ##Class(EMR.DOC.BL.ToothPosition).GetCurToothRepresentation()
	}
	s ToothPCode = ""
	for {
		s ToothPCode = $o(^CF.EMR.DOC.ToothPositionI("IdxCode",ToothPCode))
		q:(ToothPCode="")
		s rowID = $o(^CF.EMR.DOC.ToothPositionI("IdxCode",ToothPCode,""))
		q:(rowID="")
		set objTooth=##class(CF.EMR.DOC.ToothPosition).%OpenId(rowID)
		q:(objTooth="")
		s objTooth.ToothPQuadrant = ##Class(EMR.DOC.BL.ToothPosition).GetToothPQuadrant(objTooth.ToothPCode,objCruTooth.ToothCode)
		s sc = objTooth.%Save()
		if ('$$$ISOK(sc)) 
		{
			s result = "-1"
			q
		}
	}		
	q result
}

/// 获取当前使用的牙位表示法
/// Creator:zhangxl
/// CreateDate:2021-10-27
/// Debug:d ##Class(EMR.DOC.BL.ToothPosition).GetCurToothRepresentation()
ClassMethod GetCurToothRepresentation()
{
	set Result = ##class(EMR.DOC.DTO.ToothPosition).%New()
	s ToothCode = ""
	s ToothCode = $o(^CF.EMR.DOC.ToothRtationI("IdxStatusCode"," 1",ToothCode))
	q:(ToothCode="") Result
	s rowID = $o(^CF.EMR.DOC.ToothRtationI("IdxStatusCode"," 1",ToothCode,""))
	q:(rowID="") Result
	set objTooth=##class(CF.EMR.DOC.ToothRepresentation).%OpenId(rowID)
	set Result.ID = objTooth.%Id()
	set Result.ToothCode = objTooth.ToothCode
	set Result.ToothName = objTooth.ToothName
	set Result.Status = objTooth.Status
	Quit Result
}

}
