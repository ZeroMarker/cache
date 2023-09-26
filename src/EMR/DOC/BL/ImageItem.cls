Class EMR.DOC.BL.ImageItem Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取图片实例
/// Creator:    yejian
/// CreateDate: 2020-12-7 
/// Input:      argArray  命令参数 {"action":"GET_IMAGE_ENTITY", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetImageEntity(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s key = argInJson.params.id
	s searchText = argInJson.params.searchValue
	
	if (searchText = "") {
		s strRes = ##Class(EMR.DOC.BL.ImageItem).GetImageEntityJson(key,.argOutData)
	}else {
		s strRes = ##Class(EMR.DOC.BL.ImageItem).GetImageEntitySearch(searchText,.argOutData)
	}
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR",$zerror)
}

/// Desc:       获取图片实例
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetImageEntityJson(id As %String, ByRef argOutData As %GlobalBinaryStream) As EMR.DOC.DTO.ImageEItem
{
	s strRes = "1"
	q:(id = "") -101
	d argOutData.Write("[")
	
	s rowId = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(id)
	s num = rowId.ImageCount
	
	s step = 1
	s seq = ""
	s objStrem = ##Class(%GlobalBinaryStream).%New()
	for {
		s seq =  $o(^CF.EMR.DOC.ImageItemI("IdxCategoryBySequence"," "_id, seq))		
		q:(seq = "")
		s rowID = ""
		for {
			
			s rowID = $o(^CF.EMR.DOC.ImageItemI("IdxCategoryBySequence"," "_id,seq,rowID))		
			q:(rowID = "")
			s objItem = ##Class(CF.EMR.DOC.ImageItem).%OpenId(rowID)
			continue:((objItem="") || (objItem.IsExist = "0") )
			d objStrem.Write("{")
			d objStrem.Write("""key"":"""_objItem.Code_""",")
			d objStrem.Write("""ID"":"""_objItem.%Id()_""",")
			d objStrem.Write("""name"":"""_objItem.Name_""",")
			d objStrem.Write("""ImageType"":"""_objItem.ImageType_""",")
			d objStrem.Write("""Description"":"""_objItem.Description_""",")
			d objStrem.Write("""IsPublish"":"""_objItem.IsPublish_""",")
			d objStrem.Write("""src"":""")
			d objStrem.CopyFrom(objItem.ImageData)
			if (step = num ) {
				d objStrem.Write("""}")
			}else{
				d objStrem.Write("""},")
			}
			
			s step = step + 1
		}
	}
	d objStrem.Rewind()
	while (objStrem.AtEnd = 0) {
		s value = objStrem.Read(3000)
		d argOutData.Write(value)
	}
			
	d argOutData.Write("]")
	q strRes
}

/// Desc:       根据查询条件获取图片实例
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetImageEntitySearch(id As %String, ByRef argOutData As %GlobalBinaryStream) As EMR.DOC.DTO.ImageEItem
{
	s strRes = "1"
	q:(id = "") -101
	d argOutData.Write("[")
	s rowId = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(id)
	
	&sql(SELECT COUNT(*) FROM CF_EMR_DOC.ImageItem WHERE ImageType LIKE :id)
	s num = rowId.ImageCount
	
	s objStrem = ##Class(%GlobalBinaryStream).%New()
	s step = 1
	s seq = ""
	for {
			s rowID = $o(^CF.EMR.DOC.ImageItemD(rowID))		
			q:(rowID = "")
			s objItem = ##Class(CF.EMR.DOC.ImageItem).%OpenId(rowID)
			continue:((objItem="") || (objItem.IsExist = "0")|| ($find(obj.ImageType,SearchText) = 0) )
			d objStrem.Write("{")
			d objStrem.Write("""key"":"""_objItem.Code_""",")
			d objStrem.Write("""ID"":"""_objItem.%Id()_""",")
			d objStrem.Write("""name"":"""_objItem.Name_""",")
			d objStrem.Write("""ImageType"":"""_objItem.ImageType_""",")
			d objStrem.Write("""Description"":"""_objItem.Description_""",")
			d objStrem.Write("""IsPublish"":"""_objItem.IsPublish_""",")
			d objStrem.Write("""src"":""")
			d objStrem.CopyFrom(objItem.ImageData)
			
			if (step = num ) {
				d objStrem.Write("""}")
			}else{
				d objStrem.Write("""},")
			}
			d objStrem.Rewind()
			while (objStrem.AtEnd = 0) {
				s value = objStrem.Read(3000)
				d argOutData.Write(value)
			}
			s step = step + 1
			
	}
	d argOutData.Write("]")
	q strRes
}

/// Desc:       添加图片实例
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_IMAGE_ENTITY","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddImageEntity(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ##Class(EMR.DOC.BL.ImageItem).AddImageEntityJson(argInJson,argInData)
    
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

/// Description:   添加图片实例
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddImageEntityJson(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream) As %String
{
	s Code = argInJson.params.Code
	q:(Code= "") "-1^code不能为空"
	s CodeId=""
	&sql(select id into :CodeId from CF_EMR_DOC.ImageItem where Code=:Code and IsExist=1)
	q:CodeId'="" "-1^Code值重复"
	s Name = argInJson.params.Name
	q:(Name= "") "-1^图片名不能为空"
	s CategoryID = argInJson.params.CategoryID
	q:(CategoryID= "") "-1^目录ID不能为空"
	
	s params = argInJson.params
	
	 
	s objImage = ""
	s objImage = $o(^CF.EMR.DOC.ImageItemI("IdxCode"," "_$ZCVT(Code,"U"),objImage))
	s obj = ##Class(CF.EMR.DOC.ImageItem).%OpenId(objImage)
	q:((obj '= "") && (obj.IsExist = "1")) -105
	
	s seq = ""
	s seq = $o(^CF.EMR.DOC.ImageCategoryI("IdxCode"," "_$ZCVT(Code,"U"),seq))
	s objCategory = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(seq)
	q:((objCategory '= "") && (objCategory.IsExist = 1)) -105
	
	s catObj = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(CategoryID)
	q:(catObj = "") "-1^目录不存在"
	
	TSTART
	s objCat = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(CategoryID)
	s objCat.ImageCount = objCat.ImageCount + 1
	s fag=objCat.%Save()
	if ('$$$ISOK(fag))
	{
		TROLLBACK
		q "-1^目录节点数修改失败"
	}

	s ObjImage=##class(CF.EMR.DOC.ImageItem).%New()
		
	s ObjImage.Code = params.Code
	s ObjImage.Name = params.Name	
	s ObjImage.Description = params.Description
	s ObjImage.CategoryID = params.CategoryID
	s ObjImage.IsPublish = params.IsPublish
	s ObjImage.ImageType = params.ImageType
	s ObjImage.IsExist = 1 
	
	
	if (argInData.IsNull()'=1) {
		d ObjImage.ImageData.CopyFrom(argInData)
	}
	
	s sc = ObjImage.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1^保存失败"
	}
	TCOMMIT
	s ObjImage.Sequence=ObjImage.%Id()
	d ObjImage.%Save()
	q 1
}

/// Desc:       修改图片实例
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_IMAGE_ENTITY","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateImageEntity(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##Class(EMR.DOC.BL.ImageItem).UpdateImageEntityJson(argInJson,argInData)
    
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

/// Description:   修改图片实例
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod UpdateImageEntityJson(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream) As %String
{
	s Code = argInJson.params.Code
	q:(Code= "") "-1^目录名不能为空"
	s Name = argInJson.params.Name
	q:(Name= "") "-1^图片名不能为空"
	s id = argInJson.params.id
	q:(id= "") "-1^id不能为空"
	
	s params = argInJson.params
	
	 
	s objImage = ""
	s objImage = $o(^CF.EMR.DOC.ImageItemI("IdxCode"," "_$ZCVT(Code,"U"),objImage))
	s obj = ##Class(CF.EMR.DOC.ImageItem).%OpenId(objImage)
	q:((obj '= "") && (obj.IsExist = "0")) "-1^编码不能重复"
	
	s seq = ""
	s seq = $o(^CF.EMR.DOC.ImageCategoryI("IdxCode"," "_$ZCVT(Code,"U"),seq))
	s objCategory = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(seq)
	q:((objCategory '= "") && (objCategory.IsExist = 1)) "-1^编码不能重复"
	
	TSTART
	s ObjImage=##class(CF.EMR.DOC.ImageItem).%OpenId(id)
	q:(ObjImage = "") "-1^图片不存在"
	
	s ObjImage.Code = params.Code
	s ObjImage.Name = params.Name	
	s ObjImage.Description = params.Description
	s ObjImage.IsPublish = params.IsPublish
	;s ObjImage.Sequence = params.Sequence
	
	
	if (params.update = 1) {
		s ObjImage.ImageType = params.ImageType
		if (argInData.IsNull()'=1) {
			d ObjImage.ImageData.CopyFrom(argInData)
		}
	}
	s sc = ObjImage.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1^保存失败"
	}
	TCOMMIT
	q 1
}

/// Desc:     删除图片实例
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_IMAGE_ENTITY","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteImageEntity(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

    s arrIDS = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.ImageItem).DeleteImageEntityJson(arrIDS)
    d argOutData.Write(strRes)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入用户ID数组",2)
	}else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除关联模板失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 删除图片实例
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteImageEntityJson(arrIDs As %DynamicArray)
{
	
	s strRes ="-1"
	q:(arrIDs.%Size()=0) strRes
	TSTART
	s strRes = "-2"
	s strMark = "1"
	s intIDSize = arrIDs.%Size()
	for i=0:1:(intIDSize-1)
	{
		s jItem = arrIDs.%Get(i)
		s strID = jItem
		s objUsers = ##class(CF.EMR.DOC.ImageItem).%OpenId(strID)
		if (objUsers="") 
		{
			s strMark="-1"
			q
		}
		s objCat = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(objUsers.CategoryID)
		s objCat.ImageCount = objCat.ImageCount - 1
		s fag = objCat.%Save()
		if ('$$$ISOK(fag))
		{
			s strMark="-1"
			q
		}

		s objUsers.IsExist = 0
		s sc = objUsers.%Save()
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
			q
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// Desc:       图片排序
/// Creator:    huhao
/// CreateDate: 2022/11/07
/// Table:		CF.EMR.DOC.ImageItem
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod ImagCGSort(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s option=argInJson.params.operation
	s id=argInJson.params.id
	s strRes = ##class(EMR.DOC.BL.ImageItem).sort(option,id)
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
	s Oldobj=##class(CF.EMR.DOC.ImageItem).%OpenId(id)
	s parentId=Oldobj.CategoryID
	s midelSeq=Oldobj.Sequence
	if (option="up")
	{
		s seq=$o(^CF.EMR.DOC.ImageItemI("IdxCGSeq"," "_parentId,1,midelSeq),-1)
		q:seq="" "-1^无法上移"
		s rowId=$o(^CF.EMR.DOC.ImageItemI("IdxCGSeq"," "_parentId,1,seq,rowId))
		s Newobj=##class(CF.EMR.DOC.ImageItem).%OpenId(rowId)
		s Oldobj.Sequence=Newobj.Sequence
		s Newobj.Sequence=midelSeq
		d Newobj.%Save()
		d Oldobj.%Save()
		q "1"
	}
	elseif(option="down")
	{
		s seq=$o(^CF.EMR.DOC.ImageItemI("IdxCGSeq"," "_parentId,1,midelSeq))
		q:seq="" "-1^无法下移"
		s rowId=$o(^CF.EMR.DOC.ImageItemI("IdxCGSeq"," "_parentId,1,seq,rowId))
		s Newobj=##class(CF.EMR.DOC.ImageItem).%OpenId(rowId)
		s Oldobj.Sequence=Newobj.Sequence
		s Newobj.Sequence=midelSeq
		d Newobj.%Save()
		d Oldobj.%Save()
		q "1"

	}
	else{ q "-1^操作参数有误"}
}

/// Desc:       获取单个图片实例
/// Creator:    huhao
/// CreateDate: 2023-1-17
/// Table:		CF.EMR.DOC.ImageItem
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetSignImgEntity(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Id=argInJson.params.id
	
	s strRes = ##class(EMR.DOC.BL.ImageItem).GetSigleImg(Id,.argOutData)
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

ClassMethod GetSigleImg(id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(id = "") "-1^Id不能为空"
	
	s objStrem = ##Class(%GlobalBinaryStream).%New()
	s objItem = ##Class(CF.EMR.DOC.ImageItem).%OpenId(id)
	q:((objItem="")||(objItem.IsExist="0")) "-1^图片实例不存在"
	d objStrem.Write("{")
	d objStrem.Write("""key"":"""_objItem.Code_""",")
	d objStrem.Write("""ID"":"""_objItem.%Id()_""",")
	d objStrem.Write("""name"":"""_objItem.Name_""",")
	d objStrem.Write("""ImageType"":"""_objItem.ImageType_""",")
			
	d objStrem.Write("""src"":""")
	d objStrem.CopyFrom(objItem.ImageData)
			
	d objStrem.Write("""}")
	d objStrem.Rewind()
	while (objStrem.AtEnd = 0) {
		s value = objStrem.Read(3000)
		d argOutData.Write(value)
	}
			
	q strRes
}

}
