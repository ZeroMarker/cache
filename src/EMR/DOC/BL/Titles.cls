/// 名称:	EMR.DOC.BL.Titles
/// 描述:	模板标题维护 标题表
/// 编写者：Ningyanghong
/// 编写日期: 2021-9-28
/// 产品组：电子病历产品组
Class EMR.DOC.BL.Titles Extends EMR.DOC.COM.ActionBase
{

/// Desc:       保存标题信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"SAVE_SCHEMEITEM_SSGROUP","params":{"id":"68^67","locStr":"259^262","title":"11111"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateTitle(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID =argInJson.params.id
	
	s objDataFontStyle= ##class(%DynamicObject).%New()
	s objDataFontStyle.fontSize=argInJson.params.datefontSize
	s objDataFontStyle.bold=argInJson.params.datefontStyle
	s objDataFontStyle.fontFamily=argInJson.params.datefontFamily
	s objDataFontStyle.color=argInJson.params.datecolor
	
	s objTitleFontStyle= ##class(%DynamicObject).%New()
	s objTitleFontStyle.fontSize=argInJson.params.titlefontSize
	s objTitleFontStyle.bold=argInJson.params.titlefontStyle
	s objTitleFontStyle.fontFamily=argInJson.params.titlefontFamily
	s objTitleFontStyle.color=argInJson.params.titlecolor
	
	s objtitleConfig=##class(EMR.DOC.DTO.Titles).%New()
	s objtitleConfig.DateFontStyle=objDataFontStyle.%ToJSON()
	s objtitleConfig.DateReadonly=argInJson.params.dateReadonly
	s objtitleConfig.Datevisible=argInJson.params.dateVisible
	s objtitleConfig.DateAlign=argInJson.params.dateAlign
	s objtitleConfig.DefaultCreate=argInJson.params.defaultCreate
	s objtitleConfig.DoctorLevel=argInJson.params.doctorLevel
	s objtitleConfig.EventCode=argInJson.params.eventCode
	s objtitleConfig.IncludeDoctorLevel=argInJson.params.includeDoctorLevel
	s objtitleConfig.IncludeDoctorName=argInJson.params.includeDoctorName
	s objtitleConfig.IsLeadframe=argInJson.params.isLeadframe
	s objtitleConfig.IsMutex=argInJson.params.isMutex
	s objtitleConfig.LineBreak=argInJson.params.lineBreak
	s objtitleConfig.PageBreak=argInJson.params.pageBreak
	s objtitleConfig.PageBreakOdd=argInJson.params.PageBreakOdd
	s objtitleConfig.Serial=argInJson.params.serial
	s objtitleConfig.TitleAlign=argInJson.params.titleAlign
	s objtitleConfig.TitleBeforeDate=argInJson.params.titleBeforeDate
	s objtitleConfig.TitleFontStyle=objTitleFontStyle.%ToJSON()
	s objtitleConfig.TitleFormat=argInJson.params.titleFormat
	s objtitleConfig.TitleReadonly=argInJson.params.titleReadonly
	s objtitleConfig.Titlevisible=argInJson.params.titleVisible
	s objtitleConfig.UniqueCreate=argInJson.params.uniqueCreate
	

	
	s strRes=##class(EMR.DOC.BL.Titles).SaveConfig(ID,objtitleConfig)
	if (strRes = "1")
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
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       保存标题信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"SAVE_SCHEMEITEM_SSGROUP","params":{"id":"68^67","locStr":"259^262","title":"11111"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveConfig(id As %String, objCon As EMR.DOC.DTO.Titles)
{
	
	if (rowId="")
	{
		// 新增
		s objconfig= ##class(CF.EMR.DOC.Titles).%New()
		s objconfig.DateAlign=objCon.DateAlign
		s objconfig.DateFontStyle=objCon.DateFontStyle
		s objconfig.DateReadonly=objCon.DateReadonly
		s objconfig.Datevisible=objCon.Datevisible
		s objconfig.DefaultCreate=objCon.DefaultCreate
		s objconfig.DoctorLevel=objCon.DoctorLevel
		s objconfig.EventCode=objCon.EventCode
		s objconfig.IncludeDoctorLevel=objCon.IncludeDoctorLevel
		s objconfig.IncludeDoctorName=objCon.IncludeDoctorName
		s objconfig.IsLeadframe=objCon.IsLeadframe
		s objconfig.IsMutex=objCon.IsMutex
		s objconfig.LineBreak=objCon.LineBreak
		s objconfig.PageBreak=objCon.PageBreak
		s objconfig.PageBreakOdd=objCon.PageBreakOdd
		s objconfig.Serial=objCon.Serial
		s objconfig.TitleAlign=objCon.TitleAlign
		s objconfig.TitleBeforeDate=objCon.TitleBeforeDate
		s objconfig.TitleFontStyle=objCon.TitleFontStyle
		s objconfig.TitleFormat=objCon.TitleFormat
		s objconfig.TitleReadonly=objCon.TitleReadonly
		s objconfig.Titlevisible=objCon.Titlevisible
		s objconfig.UniqueCreate=objCon.UniqueCreate
		
		s sc=objconfig.%Save()
		if ($$$ISOK(sc))
		{
			s strRes="1"
			q strRes
		}
		
	}else
	{
		// 修改
		s objconfig= ##class(CF.EMR.DOC.Titles).%OpenId(id)
		s objconfig.DateAlign=objCon.DateAlign
		s objconfig.DateFontStyle=objCon.DateFontStyle
		s objconfig.DateReadonly=objCon.DateReadonly
		s objconfig.Datevisible=objCon.Datevisible
		s objconfig.DefaultCreate=objCon.DefaultCreate
		s objconfig.DoctorLevel=objCon.DoctorLevel
		s objconfig.EventCode=objCon.EventCode
		s objconfig.IncludeDoctorLevel=objCon.IncludeDoctorLevel
		s objconfig.IncludeDoctorName=objCon.IncludeDoctorName
		s objconfig.IsLeadframe=objCon.IsLeadframe
		s objconfig.IsMutex=objCon.IsMutex
		s objconfig.LineBreak=objCon.LineBreak
		s objconfig.PageBreak=objCon.PageBreak
		s objconfig.PageBreakOdd=objCon.PageBreakOdd
		s objconfig.Serial=objCon.Serial
		s objconfig.TitleAlign=objCon.TitleAlign
		s objconfig.TitleBeforeDate=objCon.TitleBeforeDate
		s objconfig.TitleFontStyle=objCon.TitleFontStyle
		s objconfig.TitleFormat=objCon.TitleFormat
		s objconfig.TitleReadonly=objCon.TitleReadonly
		s objconfig.Titlevisible=objCon.Titlevisible
		s objconfig.UniqueCreate=objCon.UniqueCreate
		if ($$$ISOK(sc))
		{
			s strRes="1"
			q strRes
		}
	}
}

/// Desc:       获取标题信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"SAVE_SCHEMEITEM_SSGROUP","params":{"id":"68^67","locStr":"259^262","title":"11111"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTitle(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=..GetIDByKey(argInJson.params.id)
	
	s res=##class(EMR.DOC.BL.Titles).getConfig(id,.argOutData)
	if (res = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	elseif (res = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","业务活动记录不存在",2)	
	}else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取标题信息
/// Creator:    huhao
/// CreateDate: 2023/02/21
/// Input:      argArray  命令参数 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod getConfig(id As %String, argOutData As %GlobalBinaryStream) As %DynamicObject
{
	s objTitle=##class(%DynamicObject).%New()
	s objCol=##class(CF.EMR.DOC.Titles).%OpenId(id)
	q:objCol=""
	s objTitle.titleAlign=objCol.TitleAlign
	s objTitle.dateAlign=objCol.DateAlign
	s objTitle.pageBreak=objCol.PageBreak
	s objTitle.pageBreakOdd=objCol.PageBreakOdd
	s objTitle.uniqueCreate=objCol.UniqueCreate
	s objTitle.lineBreak=objCol.LineBreak
	s objTitle.eventCode=objCol.EventCode
	s objTitle.includeDoctorLevel=objCol.IncludeDoctorLevel
	s objTitle.includeDoctorName=objCol.IncludeDoctorName
	s objTitle.dateFormat=objCol.DateFormat
	s objTitle.doctorLevel=objCol.DoctorLevel
	s objTitle.dateReadonly=objCol.DateReadonly
	s objTitle.titleReadonly=objCol.TitleReadonly
	s objTitle.datevisible=objCol.Datevisible
	s objTitle.titlevisible=objCol.Titlevisible
	s objTitle.isMutex=objCol.IsMutex
	s objTitle.isLeadframe=objCol.IsLeadframe
	s objTitle.defaultCreate=objCol.DefaultCreate
	s objTitle.titleBeforeDate=objCol.TitleBeforeDate
	s objTitle.serial=objCol.Serial
	
	if (objCol.TitleFontStyle'="")
	{
		s objJson = ##class(%DynamicAbstractObject).%FromJSON(objCol.TitleFontStyle)
		s objTitle.titleFontStyle=objJson.bold
		s objTitle.titleFontSize=objJson.fontSize
		s objTitle.titleFontFamily=objJson.fontFamily
		s objTitle.titleColor=objJson.color
	}
	if (objCol.DateFontStyle'="")
	{
		s objJson = ##class(%DynamicAbstractObject).%FromJSON(objCol.DateFontStyle)
		s objTitle.dateFontStyle=objJson.bold
		s objTitle.dateFontSize=objJson.fontSize
		s objTitle.dateFontFamily=objJson.fontFamily
		s objTitle.dateColor=objJson.color
	}
	d objTitle.%ToJSON(argOutData)
	q "1"
}

}
