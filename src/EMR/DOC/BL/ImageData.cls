/// 名称:	EMR.DOC.BL.ImageData
/// 描述:	医生端图库业务逻辑(门诊、住院)
/// 编写者：yejian
/// 编写日期: 2022-11-14
/// 产品组：电子病历产品组
Class EMR.DOC.BL.ImageData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取图库目录树
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.ImageCategory 图库目录表,CF_EMR_DOC.ImageItem 图库表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_IMAGECATEGORY","params":{"userID":"10209"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetImageCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.ImageData).%New()
	s objItem.Product = argInJson.product
	s objItem.UserID = argInJson.params.userID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.ImageData).GetImageCategoryJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取图库目录tree
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 图库对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.ImageData).GetDPTreeJson("YS01")
ClassMethod GetImageCategoryJson(aItem As EMR.DOC.DTO.ImageData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
    s jsonCat  = ##class(%DynamicObject).%New()
	s dpBaseName = ##Class(EMR.DOC.COM.Translation).Get("EMRTrans","通用图库")
    s jsonCat.id = "0"
    s jsonCat.text = dpBaseName
    s jsonCat.nodetype = "baseItem"
    s hasNode = $o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",0,1,""))
    s jsonCat.state = "open"
    s:(hasNode="") jsonCat.iconCls="tree-folder"
    ;s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(dpBaseName,4,"")
	;s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(dpBaseName,3,"")
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.ImageData).GetJsonCategroyByPID("0",aItem,.jsonCategory)
	s:(jsonCategory.%Size()>0) jsonCat.children = jsonCategory
	d jsonArr.%Push(jsonCat)
	if (aItem.UserID '= "")
	{
		s jsonPer  = ##class(%DynamicObject).%New()
		s perName = ##Class(EMR.DOC.COM.Translation).Get("EMRTrans","个人图库")
	    s jsonPer.id = "person"
	    s jsonPer.text = perName
	    s jsonPer.nodetype = "userItem"
	    ;s jsonPer.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(perName,4,"")
		;s jsonPer.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(perName,3,"")
		d jsonArr.%Push(jsonPer)
	}
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取图库目录tree
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 对象
/// Output:     
/// Debug:	q ##Class(EMR.DOC.BL.ImageData).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, aItem As EMR.DOC.DTO.ImageData, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s treeSeq = ""
	for {
		s treeSeq = $o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",aParentId,1,treeSeq))
		q:(treeSeq = "")		
		s rowCID = $o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",aParentId,1,treeSeq,""))		
		s objCat = ##Class(CF.EMR.DOC.ImageCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s hasCNode = $o(^CF.EMR.DOC.ImageCategoryI("IdxCodeSeq",rowCID,1,""))
	    s strType = $case(aParentId,"0":"commonCategoryID",:"commonItem")
	    
	    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.ImageCategory","Name",objCat.Name,aItem.LangID)
		s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)
		s strDesc = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.ImageCategory","Description",objCat.Description,aItem.LangID)
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.id = rowCID
	    s jsonCat.code = objCat.Code
	    s jsonCat.name=strName
	    s jsonCat.text = strName
	    s jsonCat.desc = strDesc
	    s:(strType="commonCategoryID") jsonCat.state = "open"
	    s:(hasCNode="")&&(strType="commonCategoryID") jsonCat.iconCls="tree-folder"
	    s jsonCat.nodetype = strType
	    ;s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
		;s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
		s jsonCateNew = ##class(%DynamicArray).%New()
		s result = ##Class(EMR.DOC.BL.ImageData).GetJsonCategroyByPID(rowCID,aItem,.jsonCateNew)
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew	
		
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取通用图片节点数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.ImageCategory 图库目录表,CF_EMR_DOC.ImageItem 图库表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_IMAGE_COMMONITEM","params":{"userID":"10209","categoryID":"2"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetImageCommonItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s objItem = ##class(EMR.DOC.DTO.ImageData).%New()
	s objItem.Product = argInJson.product
	s objItem.UserID = argInJson.params.userID
	s objItem.ParentID =  argInJson.params.categoryID
    s strRes = ##Class(EMR.DOC.BL.ImageData).GetImageCommonItemJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取通用图片节点数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 图库对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.ImageData).GetDPTreeJson("YS01")
ClassMethod GetImageCommonItemJson(aItem As EMR.DOC.DTO.ImageData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.ParentID="") "-1^图片目录ID不能为空"
    s aItem.LangID=20
	s jsonArr = ##class(%DynamicArray).%New()
	s treeSeq = ""
	for {
		s treeSeq = $o(^CF.EMR.DOC.ImageItemI("IdxCategoryIDIsPublishSequence"," "_aItem.ParentID,1,treeSeq))
		q:(treeSeq = "")		
		s rowID = $o(^CF.EMR.DOC.ImageItemI("IdxCategoryIDIsPublishSequence"," "_aItem.ParentID,1,treeSeq,""))		
		s objImage = ##Class(CF.EMR.DOC.ImageItem).%OpenId(rowID)
	    continue:(objImage="")||(objImage.IsExist="0")
	    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.ImageItem","Name",objImage.Name,aItem.LangID)
		s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)
		s favoriteFlag = 1
        s userImageID = ""
		s:(aItem.UserID'="") userImageID = $o(^CF.EMR.DOC.UserImageI("IdxUserItemID",aItem.UserID,rowID,""))
		s:(userImageID = "") favoriteFlag = 0
	    s jsonItem  = ##class(%DynamicObject).%New()
	    s jsonItem.code = objImage.Code
	    s jsonItem.itemID = rowID
	    s jsonItem.name=strName
	    s jsonItem.desc = strName
	    s jsonItem.imageType = objImage.ImageType
	   	s jsonItem.favoriteFlag = favoriteFlag
	    ;s jsonItem.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
		;s jsonItem.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
		d jsonArr.%Push(jsonItem)	
	}
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取个人图片节点数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.ImageCategory 图库目录表,CF_EMR_DOC.ImageItem 图库表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_IMAGE_USERITEM","params":{"userID":"10209"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetImageUserItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s objItem = ##class(EMR.DOC.DTO.ImageData).%New()
	s objItem.Product = argInJson.product
	s objItem.UserID = argInJson.params.userID
    s strRes = ##Class(EMR.DOC.BL.ImageData).GetImageUserItemJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取个人图片节点数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 图库对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.ImageData).GetDPTreeJson("YS01")
ClassMethod GetImageUserItemJson(aItem As EMR.DOC.DTO.ImageData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.UserID="") "-1^用户ID不能为空"
    s aItem.LangID=20
	
	s jsonArr = ##class(%DynamicArray).%New()
	s treeSeq = ""
	for {
		s treeSeq = $o(^CF.EMR.DOC.UserImageI("IdxUserSequenceItemID",aItem.UserID,treeSeq),-1)
		q:(treeSeq = "")
		s itemID = ""
		for {
			
			s itemID = $o(^CF.EMR.DOC.UserImageI("IdxUserSequenceItemID",aItem.UserID,treeSeq,itemID))	
			q:(itemID="")	
			s objImage = ##Class(CF.EMR.DOC.ImageItem).%OpenId(itemID)
		    continue:(objImage="")	    
		    s userImageID = $o(^CF.EMR.DOC.UserImageI("IdxUserSequenceItemID",aItem.UserID,treeSeq,itemID,""))	
		    q:(userImageID = "")
		    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.ImageItem","Name",objImage.Name,aItem.LangID)
			s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)

		    s jsonItem  = ##class(%DynamicObject).%New()
		    s jsonItem.code = objImage.Code
		    s jsonItem.itemID = itemID
		    s jsonItem.name=strName
		    s jsonItem.desc = strName
		    s jsonItem.userImageID = userImageID
		    s jsonItem.imageType = objImage.ImageType
			d jsonArr.%Push(jsonItem)	
		}
	}
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取图片数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.ImageCategory 图库目录表,CF_EMR_DOC.ImageItem 图库表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_IMAGEDATA","params":{"itemID":"34"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetImageData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s objItem = ##class(EMR.DOC.DTO.ImageData).%New()
	s objItem.Product = argInJson.product
	s objItem.ID = argInJson.params.itemID
    s strRes = ##Class(EMR.DOC.BL.ImageData).GetImageDataJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取图片数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 图库对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.ImageData).GetDPTreeJson("YS01")
ClassMethod GetImageDataJson(aItem As EMR.DOC.DTO.ImageData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.ID="") "-1^itemID不能为空"

	s objImage = ##Class(CF.EMR.DOC.ImageItem).%OpenId(aItem.ID)
    q:(objImage="") "-1^根据ID获取图片对象失败"
	d argOutData.Write("""")
	d argOutData.CopyFrom(objImage.ImageData)
	d argOutData.Write("""")
	q strRes
}

/// Desc:       收藏用户图片
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.UserImage 用户图库,CF_EMR_DOC.ImageItem 图库表
/// Input:      argInJson  命令参数 {"product":"OP","action":"ADD_USERIMAGE","params":{"userID":"10209","itemID":"34"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddUserImage(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s objItem = ##class(EMR.DOC.DTO.ImageData).%New()
	s objItem.Product = argInJson.product
	s objItem.ID = argInJson.params.itemID
	s objItem.UserID = argInJson.params.userID
    s strRes = ##Class(EMR.DOC.BL.ImageData).AddUserImageJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取图片数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 图库对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.ImageData).GetDPTreeJson("YS01")
ClassMethod AddUserImageJson(aItem As EMR.DOC.DTO.ImageData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.ID="") "-1^itemID不能为空"
	q:(aItem.UserID="") "-1^用户ID不能为空"
	s objImage = ##Class(CF.EMR.DOC.ImageItem).%OpenId(aItem.ID)
    q:(objImage="") "-1^根据ID获取图片对象失败"
    s objUser=##class(User.SSUser).%OpenId(aItem.UserID,0)
	q:(objUser="") "-1^根据用户ID获取用户失败"
    
	s userImageID = $o(^CF.EMR.DOC.UserImageI("IdxUserItemID",aItem.UserID,aItem.ID,""))	
    if (userImageID = "")
    {
	    s objUserImage = ##Class(CF.EMR.DOC.UserImage).%New()
		s objUserImage.ItemID = objImage
		s objUserImage.UserID = objUser
		s objUserImage.Frequency = 0
		s sc = objUserImage.%Save()
	    q:($$$ISERR(sc)) "-1^收藏图片失败"
		k objUserImage
    }
    else
    {
	    s strRes = 1
    }
	
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       取消收藏用户图片
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.UserImage 用户图库,CF_EMR_DOC.ImageItem 图库表
/// Input:      argInJson  命令参数 {"product":"OP","action":"DELETE_USERIMAGE","params":{"userID":"10209","itemID":"34"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteUserImage(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s objItem = ##class(EMR.DOC.DTO.ImageData).%New()
	s objItem.Product = argInJson.product
	s objItem.ID = argInJson.params.itemID
	s objItem.UserID = argInJson.params.userID
    s strRes = ##Class(EMR.DOC.BL.ImageData).DeleteUserImageJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       取消收藏用户图片
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 图库对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.ImageData).GetDPTreeJson("YS01")
ClassMethod DeleteUserImageJson(aItem As EMR.DOC.DTO.ImageData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.ID="") "-1^itemID不能为空"
	q:(aItem.UserID="") "-1^用户ID不能为空"
    
	s rowId = $o(^CF.EMR.DOC.UserImageI("IdxUserItemID",aItem.UserID,aItem.ID,""))	
	if (rowId '= "") 
	{
		s sc = ##Class(CF.EMR.DOC.UserImage).%DeleteId(rowId)
		q:($$$ISERR(sc)) "-1^取消收藏失败"
	}
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       更新个人图库使用频次
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.UserImage 用户图库,CF_EMR_DOC.ImageItem 图库表
/// Input:      argInJson  命令参数 {"product":"OP","action":"UP_USERIMGFREQ","params":{"userID":"10209","itemID":"34"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpUserIMGFreq(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s objItem = ##class(EMR.DOC.DTO.ImageData).%New()
	s objItem.Product = argInJson.product
	s objItem.ID = argInJson.params.itemID
	s objItem.UserID = argInJson.params.userID
    s strRes = ##Class(EMR.DOC.BL.ImageData).UpUserIMGFreqJson(objItem,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       取消收藏用户图片
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 图库对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.ImageData).GetDPTreeJson("YS01")
ClassMethod UpUserIMGFreqJson(aItem As EMR.DOC.DTO.ImageData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.ID="") "-1^itemID不能为空"
	q:(aItem.UserID="") "-1^用户ID不能为空"
    
	s rowId = $o(^CF.EMR.DOC.UserImageI("IdxUserItemID",aItem.UserID,aItem.ID,""))	
	if (rowId'="")
	{
		s userImage = ##Class(CF.EMR.DOC.UserImage).%OpenId(rowId)
		q:(userImage = "") 
		s userImage.Frequency = userImage.Frequency + 1
		s sc= userImage.%Save()
		q:($$$ISERR(sc)) "-1^更新频次失败"
	}
	d argOutData.Write(strRes)
	q strRes
}

}
