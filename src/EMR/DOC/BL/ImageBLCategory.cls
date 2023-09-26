Class EMR.DOC.BL.ImageBLCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       图库目录查询
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_SEARCH_IMAGECATEGORY", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSearchImageCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s searchText = argInJson.params.searchValue
	s jArryMeun = ##class(%DynamicArray).%New()
	
	if (searchText = "") {
		s strRes = ##Class(EMR.DOC.BL.ImageBLCategory).GetSearchImageCategoryJson(0,.jArryMeun)
	}else {
		s strRes = ##Class(EMR.DOC.BL.ImageBLCategory).GetSearchImgBySearch(searchText,.jArryMeun)
	}
  
	if (strRes = "1")
	{ 	
		d jArryMeun.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表名不能为空",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       图库目录查询
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchImageCategoryJson(ParentId As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s seq = ""
	for {
		s seq = $o(^CF.EMR.DOC.ImageCategoryI("IdxParentIDSequence",ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CF.EMR.DOC.ImageCategoryI("IdxParentIDSequence",ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0") )
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.ID = obj.%Id()	
        	s jsonItem.key = obj.Code
        	s jsonItem.Description = obj.Description
        	s jsonItem.ImageCount = obj.ImageCount  	   
        	s jsonItem.title = obj.Name
        	s jsonItem.Type = obj.Type
        	s jsonItem.Sequence = obj.Sequence
        	
        	s arrItem = ##class(%DynamicArray).%New()
			s result = ##class(EMR.DOC.BL.ImageBLCategory).GetSearchImageCategoryJson(jsonItem.ID,.arrItem)
			if (arrItem.%Size() >0) {
					s jsonItem.children = arrItem
			}
			if (obj.ImageCount > 0){
	        	s imageArry = ##class(%DynamicArray).%New()
	        	s imagItem = ##class(EMR.DOC.BL.ImageBLCategory).GetSearchImageItemJson(jsonItem.ID,.imageArry)
	        	s jsonItem.children = imageArry
	        }
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

/// Desc:       图片目录查询
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchImageItemJson(ParentId As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s seq = ""
	for {
		s seq = $o(^CF.EMR.DOC.ImageItemI("IdxCategoryBySequence"," "_ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CF.EMR.DOC.ImageItemI("IdxCategoryBySequence"," "_ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CF.EMR.DOC.ImageItem).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0") )
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.ID= obj.%Id()	
        	s jsonItem.key = obj.Code
        	s jsonItem.title = obj.Name
        	s jsonItem.Description = obj.Description
        	s jsonItem.CategoryID= obj.CategoryID
        	s jsonItem.IsPublish = obj.IsPublish
        	s jsonItem.Sequence = obj.Sequence
           	s jsonItem.Type = "CN"
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

/// Desc:       根据条件查询图片
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchImgBySearch(SearchText As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s rowID = ""
	for {
			s rowID = $o(^CF.EMR.DOC.ImageItemD(rowID))
			q:(rowID = "")		
			s obj = ##Class(CF.EMR.DOC.ImageItem).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0") || ($find(obj.ImageType,SearchText) = 0) )
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.ID= obj.%Id()	
        	s jsonItem.key = obj.Code
        	s jsonItem.title = obj.Name
        	s jsonItem.Description = obj.Description
        	s jsonItem.CategoryID= obj.CategoryID
        	s jsonItem.IsPublish = obj.IsPublish
        	s jsonItem.Sequence = obj.Sequence
           	s jsonItem.Type = "CN"
			d jsonArr.%Push(jsonItem)
	}
	q strRes
}

/// Desc:       添加图片目录
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_IMAGE_CATEGORY","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddImageCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##Class(EMR.DOC.BL.ImageBLCategory).AddImageCategoryJson(argInJson,.argOutData)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Description:   添加图片目录
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddImageCategoryJson(argInJson As %DynamicAbstractObject, Properties As %String) As %String
{
	s name = argInJson.params.Name
	q:(name= "") "-1^目录名不能为空"
	s type = argInJson.params.Type
	q:(type= "") "-1^目录类型不能为空"
	s Code = argInJson.params.Code
	q:(Code= "") "-1^编码不能为空"
	s params = argInJson.params
	
	s rowId = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(params.ParentID)
	q:(rowId = "") "-1^父节点不存在"
	 
	s seq = ""
	s seq = $o(^CF.EMR.DOC.ImageCategoryI("IdxCode"," "_$ZCVT(Code,"U"),seq))
	s obj = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(seq)
	q:((obj '= "") && (obj.IsExist = 1)) "-1^编码不能重复"
	
	s objImage = ""
	s objImage = $o(^CF.EMR.DOC.ImageItemI("IdxCode"," "_$ZCVT(Code,"U"),objImage))
	s obj = ##Class(CF.EMR.DOC.ImageItem).%OpenId(objImage)
	q:((obj '= "") && (obj.IsExist = 1)) "-1^编码不能重复"
	
	TSTART
	s ObjImage=##class(CF.EMR.DOC.ImageCategory).%New()
		
	s ObjImage.Code = params.Code
	s ObjImage.ParentID = params.ParentID	
	s ObjImage.Name = params.Name
	s ObjImage.Type = params.Type
	s ObjImage.Description = params.Description
	s ObjImage.ImageCount=0
	s ObjImage.Sequence = +(^CF.EMR.DOC.ImageCategoryD)+1
	s ObjImage.IsExist = 1    

	s sc = ObjImage.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -106
	}
	TCOMMIT
	q 1
}

/// Desc:     删除目录
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_IMAGE_CATEGORY","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteImageCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = argInJson.params.key
    s strRes = ##Class(EMR.DOC.BL.ImageBLCategory).DeleteImageCategoryJson(ID)
	 ///output 成功 1 失败 -201 参数未传 -101 删除失败 -102 数据不存在
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
	elseif (strRes = -102)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据不存在",2)	
	}
	elseif (strRes = -103)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录下有图片不可删除",2)	
	}
	elseif (strRes = -201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","参数id未传",2)	
	}
	else
	{  
	     q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 删除目录
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteImageCategoryJson(aID As %String)
{
	q:(aID="") -201
	TSTART
	s ObjMap = ##class(CF.EMR.DOC.ImageCategory).%OpenId(aID)
	if (ObjMap.ImageCount'=0) {q "-103"}
	q:(ObjMap="") -102
	s sc=##class(CF.EMR.DOC.ImageCategory).%DeleteId(aID)
	;s ObjMap.IsExist = "0"
	;s sc = ObjMap.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}	
	TCOMMIT
	q 1
}

/// Desc:       更新目录数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_IMAGE_CATEGORY","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateImagCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.ImageBLCategory).UpdateImagCategoryJson(argInJson,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新目录数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:    
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod UpdateImagCategoryJson(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s id= argInJson.params.key
	q:(id= "") "-1^id不能为空"
	s type= argInJson.params.Type
	q:(type= "") "-1^类型不存在"
	s Code= argInJson.params.Code
	q:(Code= "") "-1^编码不能为空"
	
	q:(id = 1) "-1^根节点目录不允许修改"
	
	s params = argInJson.params
	
	s seq = $o(^CF.EMR.DOC.ImageCategoryI("IdxCode"," "_$ZCVT(Code,"U"),id))
	s obj = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(seq)
	q:((seq '= "") && (obj.IsExist = "1")) "-1^编码不能重复"
	
	/*
	s objImage = ""
	s objImage = $o(^CF.EMR.DOC.ImageItemI("IdxCode"," "_$ZCVT(Code,"U"),objImage))
	s obj = ##Class(CF.EMR.DOC.ImageItem).%OpenId(objImage)
	q:((obj '= "") && (obj.IsExist = 1)) "-1^编码不能重复"
	*/
	
	TSTART
	s ObjImage=##class(CF.EMR.DOC.ImageCategory).%OpenId(id)
	if ('ObjImage)
		{
		q "-1^目录不存在"
	}
    
    s ObjImage.Code = params.Code	
	s ObjImage.Name = params.Name
	s ObjImage.Description = params.Description
	;s ObjImage.Sequence = params.Sequence
 	s sc = ObjImage.%Save()
 	
 	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1^保存失败"
	}
	TCOMMIT
	q 1
}

/// Desc:       图库目录排序
/// Creator:    huhao
/// CreateDate: 2022/11/04
/// Table:		CF.EMR.DOC.ImageCategory
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod ImagCGSort(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s option=argInJson.params.operation
	s id=argInJson.params.id
	s strRes = ##class(EMR.DOC.BL.ImageBLCategory).sort(option,id)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod sort(option As %String, id As %String) As %String
{
	q:option="" "-1^操作不能为空"
	q:id="" "-1^id不能为空"
	s strRes="",rowId=""
	s Oldobj=##class(CF.EMR.DOC.ImageCategory).%OpenId(id)
	s parentId=Oldobj.ParentID
	s midelSeq=Oldobj.Sequence
	if (option="up")
	{
		s seq=$o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",parentId,1,midelSeq),-1)
		q:seq="" "-1^无法上移"
		s rowId=$o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",parentId,1,seq,rowId))
		s Newobj=##class(CF.EMR.DOC.ImageCategory).%OpenId(rowId)
		s Oldobj.Sequence=Newobj.Sequence
		s Newobj.Sequence=midelSeq
		d Newobj.%Save()
		d Oldobj.%Save()
		q "1"
	}
	elseif(option="down")
	{
		s seq=$o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",parentId,1,midelSeq))
		q:seq="" "-1^无法下移"
		s rowId=$o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",parentId,1,seq,rowId))
		s Newobj=##class(CF.EMR.DOC.ImageCategory).%OpenId(rowId)
		s Oldobj.Sequence=Newobj.Sequence
		s Newobj.Sequence=midelSeq
		d Newobj.%Save()
		d Oldobj.%Save()
		q "1"

	}
	else{ q "-1^操作参数有误"}
}

}
