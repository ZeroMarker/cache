/// 名称:	EMR.DOC.BL.TextKBContent
/// 描述:	专科知识库内容类
/// 编写者：zhangxl
/// 编写日期: 2021-7-30
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TextKBContent Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取知识库内容
/// Creator:    zhangxl
/// CreateDate: 2021-8-2
/// Input:      argArray  命令参数 {"action":"GET_TEXTKB_CONTENT","params":{"id":"35"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTextKBContent(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.TextKBContent).GetTextKBContentJson(strID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取知识库内容
/// Creator:    zhangxl
/// CreateDate: 2021-8-2
/// Input:      argID  ID
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).GetTextKBContentJson(strID)
ClassMethod GetTextKBContentJson(strID As %String, ByRef argOutData As %GlobalBinaryStream)
{
	s result = "0"
	q:(strID = "") result
	s rowId = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryID",strID,""))
	q:(rowId = "") "1"
	s obj = ##Class(CF.EMR.DOC.TextKBContent).%OpenId(rowId)
	d obj.Content.Rewind()
		while (obj.Content.AtEnd = 0)
		{
			s tmpOut = obj.Content.Read(32000)
			s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
			d argOutData.Write(tmpUtf8)
		}
    q "1"
}

/// Desc:       更新知识库内容
/// Creator:    zhangxl
/// CreateDate: 2021-8-6
/// Input:      argArray  	命令参数 {"action":"UP_TEXTKB_CONTENT","params":{"id":"35||IT"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpTextKBContent(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TextKBContent).%New()
	s argDTO.CategoryID = ..GetIDByKey(argInJson.params.id)	
	d argDTO.Content.CopyFrom(argInData)
    s strRes = ##Class(EMR.DOC.BL.TextKBContent).UpTextKBContentJson(argDTO)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:      更新知识库内容
/// Creator:   zhangxl
/// CreateDate:2021-8-6
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).UpTextKBContentJson(argDTO)
ClassMethod UpTextKBContentJson(argDTO As EMR.DOC.DTO.TextKBContent)
{
	
	s result = ""
	if (argDTO.CategoryID = "")
	{
		q "-200"
	} 
    s objCat = ##class(CF.EMR.DOC.TextKBCategory).%OpenId(argDTO.CategoryID)
	s rowId = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryID",argDTO.CategoryID,""))
	s objContent = ""
	if (rowId = "")
	{
		s objContent = ##Class(CF.EMR.DOC.TextKBContent).%New()
		s objContent.Status = "0"
		s objContent.CreateDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
	}
	else
	{
		s objContent = ##Class(CF.EMR.DOC.TextKBContent).%OpenId(rowId)
	}
	s objContent.CategoryID = objCat
	;s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
	d objContent.Content.CopyFrom(argDTO.Content)
	;s objContent.CreateDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
	s sc = objContent.%Save()	
	s:($$$ISOK(sc)) result = "1"
    q result
}

/// Desc:       知识库提交审核
/// Creator:    zhangxl
/// CreateDate: 2021-8-6
/// Input:      argArray  	命令参数 {"action":"SUBMIT_TEXTKB_CONTENT","params":{"id":"35||IT","status":"2"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod SubmitTexKBContent(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TextKBContent).%New()
	s argDTO.CategoryID = ..GetIDByKey(argInJson.params.id)	
	s argDTO.Status = argInJson.params.status
    s strRes = ##Class(EMR.DOC.BL.TextKBContent).SubmitTexKBContentJson(argDTO)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       知识库提交审核
/// Creator:    zhangxl
/// CreateDate: 2021-7-26
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).SubmitTexKBContentJson()
ClassMethod SubmitTexKBContentJson(argDTO As EMR.DOC.DTO.TextKBContent) As %String
{
    s result = ""
    q:(argDTO.CategoryID = "") "-200"
    s rowId = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryID",argDTO.CategoryID,""))
    s objContent = ##Class(CF.EMR.DOC.TextKBContent).%OpenId(rowId)
    s objContent.Status = argDTO.Status
    s sc = objContent.%Save()	
	s:($$$ISOK(sc)) result = "1"
    q result
}

/// Desc:       审核知识库(包括审核成功与不成功)
/// Creator:    zhangxl
/// CreateDate: 2021-9-16
/// Input:      argArray  	命令参数 {"action":"AUDIT_TEXTKB_CONTENT","params":{"categoryIds":"259^262","status":"1","remark":"approve"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AuditTextKBContent(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TextKBContent).%New()	
	s argDTO.Status = argInJson.params.status	
	s argDTO.Remark = argInJson.params.remark
	s ContentIDStr = argInJson.params.categoryIds	
    s strRes = ##Class(EMR.DOC.BL.TextKBContent).AuditTextKBContentJson(argDTO,ContentIDStr)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:      审核知识库
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      argDTO  目录对象
///             ContentIDStr
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).AuditTextKBContentJson(argDTO,ContentIDStr)
ClassMethod AuditTextKBContentJson(argDTO As EMR.DOC.DTO.TextKBContent, ContentIDStr As %String)
{
	s Result = "-1"
	q:($g(ContentIDStr) = "") Result
	S IDCount =$L(ContentIDStr,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s AContentID = $p(ContentIDStr,"^",I)
		continue:(AContentID="")
		s rowId = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryID",AContentID,""))
		s objContent = ##Class(CF.EMR.DOC.TextKBContent).%OpenId(rowId)
		q:(objContent = "")
		s objContent.Status =argDTO.Status
		if ((argDTO.Remark'="")&&(argDTO.Remark'=$C(0)))
		{
			s objContent.Remark =argDTO.Remark
			s objContent.AuditDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
		}
		if '(objContent.%Save())
		{
			TROLLBACK
			s Result = 0
			q 
		}
	}
	if (Result = 0)
	{
		 TROLLBACK
		 quit 0
	}
	TCOMMIT
	s Result = "1"
	q Result
}

/// Desc:       获取审核状态与审核说明
/// Creator:    zhangxl
/// CreateDate: 2021-10-8
/// Input:      argArray  	命令参数 {"action":"GET_AUDIT_STATE","params":{"id":"35||IT"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetAuditState(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.TextKBContent).GetAuditStateJson(strID,.argOutData)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取审核状态与审核说明
/// Creator:    zhangxl
/// CreateDate: 2021-10-8
/// Input:      argID  ID
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).GetAuditStateJson(strID)
ClassMethod GetAuditStateJson(strID As %String, ByRef argOutData As %GlobalBinaryStream)
{
	s result = "-1"
	q:(strID = "") result
	s jsonArr = ##class(%DynamicArray).%New()
	s rowId = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryID",strID,""))
	;q:(rowId = "") "-1"
	s obj = ##Class(CF.EMR.DOC.TextKBContent).%OpenId(rowId)
    s jsonItem  = ##class(%DynamicObject).%New()
    s jsonItem.status= obj.Status
	s jsonItem.remark= obj.Remark
	d jsonArr.%Push(jsonItem)
	d jsonArr.%ToJSON(argOutData)
    q "1"
}

/// Desc:       根据审核状态获取相应的知识库(包括待审核--2、待审核修正--3、已审核--1)
/// Creator:    zhangxl
/// CreateDate: 2021-9-27
/// Input:      argArray  	命令参数 {"action":"GET_AUDIT_KBCONTENT","params":{"status":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetAuditKBContent(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"	
	s strStatus = argInJson.params.status		
    s strRes = ##Class(EMR.DOC.BL.TextKBContent).GetAuditKBContentJson(strStatus,.argOutData)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:      根据审核状态获取相应的知识库
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      strStatus 
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).GetAuditKBContentJson(Status,.argOutData)
ClassMethod GetAuditKBContentJson(strStatus As %String, ByRef argOutData As %GlobalBinaryStream)
{
	s jsonArr = ##class(%DynamicArray).%New()
	s rowID = ""
	for
	{
		s rowID = $o(^CF.EMR.DOC.TextKBCategoryI("IdxType"," LEAF",rowID))
		q:(rowID = "")
		s objCategory = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(rowID)
		continue:(objCategory = "")
		continue:(objCategory.IsValid = "N")
		s rowCID =""
		s rowCID = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryID",rowID,""))

		continue:(rowCID = "")
		s objContent = ##Class(CF.EMR.DOC.TextKBContent).%OpenId(rowCID)
		continue:(objContent = "")
		s jsonItem  = ##class(%DynamicObject).%New()
		s Status = objContent.Status
		continue:(Status '= strStatus)
		s jsonItem.key = rowCID
		s jsonItem.name = objCategory.Name
		s jsonItem.type = objCategory.Type
		s jsonItem.categoryId = objCategory.Sequence
		s jsonItem.status = objContent.Status
		s jsonItem.userId = objContent.UserID
		s jsonItem.createDate = objContent.CreateDate		
		s jsonItem.auditId = objContent.AuditID
		s jsonItem.auditDate = objContent.AuditDate
		s jsonItem.remark = objContent.Remark
		
		s jsonItem.path = objCategory.Name			
		S key = objCategory.ParentID
		do
		{ 
			s objParent = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(key)
			q:(objParent = "")
			s key = objParent.ParentID
			s jsonItem.path = objParent.Name _"/"_jsonItem.path
		} 
		while (key '="0" )
		
		d jsonArr.%Push(jsonItem)	
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取所有审核知识库
/// Creator:    zhangxl
/// CreateDate: 2021-9-27
/// Input:      argArray  	命令参数 {"action":"GET_ALL_KBCONTENT","params":{},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetAllContent(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"			
    s strRes = ##Class(EMR.DOC.BL.TextKBContent).GetAllContentJson(.argOutData)
    if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:      获取所有审核知识库
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      strStatus 
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).GetAuditKBContentJson(Status,.argOutData)
ClassMethod GetAllContentJson(ByRef argOutData As %GlobalBinaryStream)
{
	s jsonArr = ##class(%DynamicArray).%New()
	s rowID = ""
	for
	{
		s rowID = $o(^CF.EMR.DOC.TextKBCategoryI("IdxType"," LEAF",rowID))
		q:(rowID = "")
		s objCategory = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(rowID)
		continue:(objCategory = "")
		continue:(objCategory.IsValid = "N")
		s rowCID =""
		s rowCID = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryID",rowID,""))
		;s rowCID = $o(^CF.EMR.DOC.TextKBContentI("IdxCategoryIDStatus",rowID,strStatus,""))
		continue:(rowCID = "")
		s objContent = ##Class(CF.EMR.DOC.TextKBContent).%OpenId(rowCID)
		continue:(objContent = "")
		s jsonItem  = ##class(%DynamicObject).%New()
		s Status = objContent.Status
		continue:(Status = "")
		s jsonItem.key = rowCID
		s jsonItem.name = objCategory.Name
		s jsonItem.type = objCategory.Type
		s jsonItem.categoryId = objCategory.Sequence
		s jsonItem.status = objContent.Status
		s jsonItem.userId = objContent.UserID
		s jsonItem.createDate = objContent.CreateDate		
		s jsonItem.auditId = objContent.AuditID
		s jsonItem.auditDate = objContent.AuditDate
		s jsonItem.remark = objContent.Remark
		
		s jsonItem.path = objCategory.Name			
		S key = objCategory.ParentID
		do
		{ 
			s objParent = ##Class(CF.EMR.DOC.TextKBCategory).%OpenId(key)
			q:(objParent = "")
			s key = objParent.ParentID
			s jsonItem.path = objParent.Name _"/"_jsonItem.path
		} 
		while (key '="0" )
		
		d jsonArr.%Push(jsonItem)	
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

}
