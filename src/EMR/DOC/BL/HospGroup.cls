/// /// 名称：		EMR.DOC.BL.HospGroup
/// /// 描述：		院区分组
/// /// 编写者：	huhao
/// /// 编写时间：	2022-5-6
Class EMR.DOC.BL.HospGroup Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取院区列表
/// Creator:    huhao
/// CreateDate: 2022-5-6
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetPrivGroupList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
   	s strRes = ##class(EMR.DOC.BL.HospGroup).getHospitallist(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       
/// Creator:    huhao
/// CreateDate: 2022-7-8
/// Table:
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod getHospitallist(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s resJson=##class(%DynamicArray).%New()
	s result=##Class(%ResultSet).%New("EMR.DOC.BL.HospGroup:SelectHospitals")
	d result.%Execute()
	while(result.%Next())
	{
		s resObj=##class(%DynamicObject).%New()
		s resObj.key=result.Data("ID")
		s resObj.HosId=result.Data("HosGroupID")
		s resObj.Name=result.Data("Name")
		s resObj.Code=result.Data("Code")
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取所有院区数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     DataSet 返回数据
/// debug d ##class(%ResultSet).RunQuery("EMRservice.BL.BLHospitals","SelectHospitals")
Query SelectHospitals() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,HosGroupID:%String", SELECTMODE = "RUNTIME")
{
	SELECT h.HOSP_RowId,h.HOSP_Code,h.HOSP_Desc,h.HOSP_DefaultHospital_DR FROM SQLUser.CT_Hospital h
	WHERE (h.HOSP_DateTo>=now() AND h.HOSP_DateFrom<=now()) or h.HOSP_DateTo IS NULL OR h.HOSP_DateFrom IS NULL
}

/// Desc:       获取院区分组
/// Creator:    huhao
/// CreateDate: 2022-5-6
/// Input:      argArray  	命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetHospitalGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
   	s strRes = ##class(EMR.DOC.BL.HospGroup).GetGroup(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       获取院区分组类别
/// Creator:    huhao
/// CreateDate: 2022-7-8
/// Table:		SQLUser.CT_Hospital
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetGroup(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s resJson=##class(%DynamicArray).%New()
	s result=##Class(%ResultSet).%New("EMR.DOC.BL.HospGroup:SelectGroup")
	d result.%Execute()
	while(result.%Next())
	{
		s resObj=##class(%DynamicObject).%New()
		s resObj.Key=result.Data("ID")
		s resObj.GroupId=result.Data("GroupID")
		s resObj.Name=result.Data("Name")
		s resObj.Code=result.Data("Code")
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取所有院区数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     DataSet 返回数据
/// debug d ##class(%ResultSet).RunQuery("EMRservice.BL.BLHospitals","SelectGroup")
Query SelectGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,GroupID:%String", SELECTMODE = "RUNTIME")
{
	SELECT h.HOSP_RowId,h.HOSP_Code,h.HOSP_Desc,h.HOSP_DefaultHospital_DR FROM SQLUser.CT_Hospital h
	WHERE ((h.HOSP_DateTo>=now() AND h.HOSP_DateFrom<=now() ) or h.HOSP_DateTo IS NULL OR h.HOSP_DateFrom IS NULL)
	AND HOSP_RowId=HOSP_DefaultHospital_DR
}

}
