/// 名称:	EMR.DOC.BL.Glossary
/// 描述:	通用文档管理模块 Document(Doc) 术语集业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.Glossary Extends EMR.DOC.COM.ActionBase
{

/// Desc:       添加术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"ADD_GLOSSARY_GLOSSARY","params":{"internalID":"HDSD00.03","name":"EMR03门急诊处方","description":"门急诊处方","parentID":"1","glossaryType":"TG","metaID":"",},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.Glossary).%New()
	s argDTO.InternalID = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID =..GetIDByKey(argInJson.params.id)
	s argDTO.GlossaryType = argInJson.params.glossaryType
	s argDTO.MetaID = ..GetIDByKey(argInJson.params.metaID)
    s strRes = ##Class(EMR.DOC.BL.Glossary).AddGlossaryJson(argDTO)
    //失败:-100 添加失败,-101 更新目录子节点数失败， -200 目录ID不能为空，-201 内部标识符不能为空，-202 术语类型数据有误，-203 数据元标识符有误, -300 未查到目录， -400 内部标识符已存在
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","更新目录子节点数失败",2)	
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内部标识符不能为空",2)	
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","术语类型数据有误",2)	
	}
	elseif (strRes = "-203")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据元标识符有误",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","根据目录ID未查到目录",2)	
	}
	elseif (strRes = "-400")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内部标识符已存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_GLOSSARY_GLOSSARY","params":{"id":"379","internalID":"HDSD00.03","name":"EMR03门急诊处方","description":"门急诊处方","parentID":"1","glossaryType":"TG""metaID":"",},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.Glossary).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.InternalID = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Description = argInJson.params.description
	;s argDTO.ParentID =..GetIDByKey(argInJson.params.parentID)
	s argDTO.GlossaryType = argInJson.params.glossaryType
	s argDTO.MetaID = argInJson.params.metaID
    s strRes = ##Class(EMR.DOC.BL.Glossary).UpGlossaryJson(argDTO)
    //失败:-100 更新失败, -200 ID不能为空，-201 内部标识符不能为空，-202 目录ID不能为空,-203 数据元标识符有误, -300 未查到目录，-301 更新术语和模板关联关系失败， -400 内部标识符已存在
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)	
	}
	elseif (strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","内部标识符不能为空",2)	
	}
	elseif (strRes = "-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-203")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据元标识符有误",2)	
	}
	elseif (strRes = "-300")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)	
	}
	elseif (strRes = "-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新术语和模板关联关系失败",2)	
	}
	elseif (strRes = "-400")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","内部标识符已存在",2)	
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DEL_GLOSSARY_GLOSSARY","params":{"id":"380"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.Glossary).DelGlossaryJson(strID)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到术语,-301 更新目录子节点数失败	,-500 包含子节点不能删除
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败","2")
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到术语","2")
	}
	elseif(strRes = "-301")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","更新目录子节点数失败","2")
	}
	elseif(strRes = "-500")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","包含子节点不能删除","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 获取术语集测试数据 （模拟）
/// creator duan
/// createDate 2021-06-10
/// Input 命令参数 {"action":"GET_INSTANCEGLOSSARY_TEST","params":{"glossaryId":"HDSD0013.114","instancedId":"","episodeId":"","pageSize":"","current":""},"product":"GlobalEMR"}
ClassMethod GetGlossaryInstanceData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s GlossaryID = argInJson.params.glossaryId
	s InstanceID = argInJson.params.instanceId
	s EpisodeID = argInJson.params.episodeId
	s PageSize = argInJson.params.pageSize
	s Current = argInJson.params.current
	///output 成功 1 失败 -201 术语集标识码未传  -202 实例ID未传 -203 就诊号未传
	s res = ##class(EMR.DOC.BL.Glossary).GetGlossaryInstanceDataJson(argOutData,GlossaryID,InstanceID,EpisodeID,PageSize,Current)
	if (res=1)
	{
		q argOutMessage.success = ..#OK
	}
	elseif(res=-201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","术语集标识码未传",2)	
	}
	elseif(res=-202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","实例ID未传",2)	
	}
	elseif(res=-203)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","就诊号未传",2)	
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)	
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 获取术语集测试数据 （模拟）
/// creator duan
/// createDate 2021-06-10
/// Input 命令参数 {"action":"GET_INSTANCEIDS_TEST","params":{},"product":"GlobalEMR"}
ClassMethod GetInstanceIDS(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s EpisodeID = argInJson.params.episodeId
	s res = ##class(EMR.DOC.BL.Glossary).GetInstanceIDSJson(argOutData,EpisodeID)
	if (res=1)
	{
		q argOutMessage.success = ..#OK
	}
	elseif(res=-201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","就诊号未传",2)	
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)	
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据父节点获取术语
/// Creator:    huhao
/// CreateDate: 2022/11/4
/// Table:		CF.EMR.DOC.Glossary
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetGloassary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s parentId=argInJson.params.id
	s strRes = ##class(EMR.DOC.BL.Glossary).GetGlossaryByCGId(parentId,.argOutData)
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

/// Desc:       根据目录获取术语
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.BDMSimpleElements).GetGlossaryByPID(1,1,)
ClassMethod GetGlossaryByCGId(aParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowSID = ""
	s resArr=##class(%DynamicArray).%New()
	for {
		;s rowSID = $o(^CF.EMR.DOC.GlossaryI("IdxCategory",aParentId,rowSID))
		s rowSID = $o(^CF.EMR.DOC.GlossaryI("IdxCategory",aParentId,rowSID))
		q:(rowSID = "")				
		s objGlossary = ##Class(CF.EMR.DOC.Glossary).%OpenId(rowSID)
		continue:(objGlossary.GlossaryType="KG")
	    continue:(objGlossary="")
	    s jsonGlossary  = ##class(%DynamicObject).%New()
	    s jsonGlossary.key = rowSID_"||LF"
	    s jsonGlossary.title = objGlossary.Name
	    s jsonGlossary.internalId = objGlossary.InternalID
	    s jsonGlossary.type = "LF"
	    s jsonGlossary.glossaryType =objGlossary.GlossaryType
	    s jsonGlossary.description = objGlossary.Description
	    s jsonGlossary.meta = ""
	    if (objGlossary.MetaID'="") {
		    s metaObj = ##class(%DynamicObject).%New()
		    s metaObj.metaId = objGlossary.MetaID.%Id()
		    s metaObj.entifier = objGlossary.MetaID.Entifier
		    s jsonGlossary.meta = metaObj
	    }
	    s jsonGlossary.isLeaf = "true"
	   	//ParentID不为空，则子节点为知识库术语
	   	s rowKGID = $o(^CF.EMR.DOC.GlossaryI("IdxParentID"," "_rowSID,""))
	   	if (rowKGID'="")&&(rowKGID'=$c(0))
	   	{
		   	s kbArr = ##class(%DynamicArray).%New()
		   	s strRes =##Class(EMR.DOC.BL.Glossary).GetKBGlossaryByPID(rowSID,.kbArr)
		   	s:(kbArr.%Size()>0) jsonGlossary.children = kbArr
		   	s:(kbArr.%Size()>0) jsonGlossary.isLeaf = 0
	   	}
		d resArr.%Push(jsonGlossary)	
	}
	d resArr.%ToJSON(jsonCategory)
	q res
}

/// Desc:       根据目录获取术语
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.BDMSimpleElements).GetGlossaryByPID(1,1,)
ClassMethod GetGlossaryByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowSID = ""
	for {
		;s rowSID = $o(^CF.EMR.DOC.GlossaryI("IdxCategory",aParentId,rowSID))
		s rowSID = $o(^CF.EMR.DOC.GlossaryI("IdxCategory",aParentId,rowSID))
		q:(rowSID = "")				
		s objGlossary = ##Class(CF.EMR.DOC.Glossary).%OpenId(rowSID)
	    continue:(objGlossary="")
	    s jsonGlossary  = ##class(%DynamicObject).%New()
	    s jsonGlossary.key = rowSID_"||LF"
	    s jsonGlossary.title = objGlossary.Name
	    s jsonGlossary.internalId = objGlossary.InternalID
	    s jsonGlossary.type = "LF"
	    s jsonGlossary.glossaryType ="TG"
	    s jsonGlossary.description = objGlossary.Description
	    s jsonGlossary.meta = ""
	    if (objGlossary.MetaID'="") {
		    s metaObj = ##class(%DynamicObject).%New()
		    s metaObj.metaId = objGlossary.MetaID.%Id()
		    s metaObj.entifier = objGlossary.MetaID.Entifier
		    s jsonGlossary.meta = metaObj
	    }
	    s jsonGlossary.isLeaf = 1
	   	//ParentID不为空，则子节点为知识库术语
	   	s rowKGID = $o(^CF.EMR.DOC.GlossaryI("IdxParentID"," "_rowSID,""))
	   	if (rowKGID'="")&&(rowKGID'=$c(0))
	   	{
		   	s kbArr = ##class(%DynamicArray).%New()
		   	s strRes =##Class(EMR.DOC.BL.Glossary).GetKBGlossaryByPID(rowSID,.kbArr)
		   	s:(kbArr.%Size()>0) jsonGlossary.children = kbArr
		   	s:(kbArr.%Size()>0) jsonGlossary.isLeaf = 0
	   	}
		d jsonCategory.%Push(jsonGlossary)	
	}
	q res
}

/// Desc:       根据目录获取知识库术语
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.BDMSimpleElements).GetGlossaryByPID(1,1,)
ClassMethod GetKBGlossaryByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowSID = ""
	for {
		s rowSID = $o(^CF.EMR.DOC.GlossaryI("IdxParentID"," "_aParentId,rowSID))
		q:(rowSID = "")				
		s objGlossary = ##Class(CF.EMR.DOC.Glossary).%OpenId(rowSID)
	    continue:(objGlossary="")
	    s jsonGlossary  = ##class(%DynamicObject).%New()
	    s jsonGlossary.key = rowSID_"||KG"
	    s jsonGlossary.title = objGlossary.Name
	    s jsonGlossary.internalID = objGlossary.InternalID
	    s jsonGlossary.type = "IT"
	    s jsonGlossary.glossaryType ="KG"
	    s jsonGlossary.description = objGlossary.Description
	    s metaObj = ##class(%DynamicObject).%New()
	    if (objGlossary.MetaID'= ""){
			s metaObj.metaId = objGlossary.MetaID.%Id()
	    	s metaObj.entifier = objGlossary.MetaID.Entifier
		}
	    s jsonGlossary.meta = metaObj
		d jsonCategory.%Push(jsonGlossary)	
	}
	q res
}

/// Desc:       添加术语目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败,-101 更新目录子节点数失败， -200 目录ID不能为空，-201 内部标识符不能为空，-202 术语类型数据有误，-203 数据元标识符有误
/// 						  -300 未查到目录， -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.Glossary).AddGlossaryJson()
ClassMethod AddGlossaryJson(argDTO As EMR.DOC.DTO.Glossary) As %String
{
	s strRes ="-100"
	TSTART
	
	if (argDTO.ParentID = "")
	{
		TROLLBACK
		q "-200"
	} 
	if (argDTO.InternalID = "")
	{
		TROLLBACK
		q "-201"
	}
	if (argDTO.GlossaryType '= "TG")&&(argDTO.GlossaryType '= "KG")
	{
		TROLLBACK
		q "-202"
	}
	s argDTO.GUID =##class(%SYSTEM.Util).CreateGUID()
	s argDTO.CreateDate = $ZDATEH($ZDATE($h))
 	s argDTO.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s argDTO.LastModifyDate = $ZDATEH($ZDATE($h))
	s argDTO.LastModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	
	s obj = ##class(CF.EMR.DOC.Glossary).%New()
	s intParentID = +(argDTO.ParentID)
	s strInternalID = $zcvt(argDTO.InternalID,"U")
	if (argDTO.GlossaryType = "TG")
	{	
		s intParentID = +(argDTO.ParentID)
		s objGlossaryCategory = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(intParentID)
		if (intParentID'=0)&&(objGlossaryCategory="")
		{
			TROLLBACK
			q "-300"
		}
		//模板目录子节点数+1
		s objGlossaryCategory.ResChildCount = +(objGlossaryCategory.ResChildCount) + 1
		if '(objGlossaryCategory.%Save())
		{
			TROLLBACK
			q "-102"
		} 
		s obj.GlossaryCategory = objGlossaryCategory
		;s obj.ParentID = argDTO.ParentID
	}
	elseif(argDTO.GlossaryType = "KG")
	{
		s objPGlossary = ##class(CF.EMR.DOC.Glossary).%OpenId(argDTO.ParentID)
		if (objPGlossary="")
		{
			TROLLBACK
			q "-300"
		}
		;s obj.GlossaryCategory = objPGlossary.GlossaryCategory	
		s obj.GlossaryCategory = objPGlossary.GlossaryCategory
		s obj.ParentID = argDTO.ParentID
	}
	if (argDTO.MetaID'="")
	{
		s objDataElement = ##class(CF.EMR.DOC.DataElement).%OpenId(argDTO.MetaID)	
		if (objDataElement="")
		{
			TROLLBACK
			q "-203"
		}
		s obj.MetaID = objDataElement
	}
	s intCategroyID = obj.GlossaryCategory.%Id()
	s isHas = $o(^CF.EMR.DOC.GlossaryI("IdxCategoryIDInternalID",intCategroyID," "_strInternalID,""))

	
	if (isHas'="")
	{
		TROLLBACK
		q "-400"
	} 
	s obj.InternalID = argDTO.InternalID
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.GlossaryType = argDTO.GlossaryType
	s obj.CreateDate = argDTO.CreateDate
	s obj.CreateTime = argDTO.CreateTime
	s obj.LastModifyDate = argDTO.LastModifyDate
	s obj.LastModifyTime = argDTO.LastModifyTime
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		q obj.%Id()
	}
	else
	{
		TROLLBACK
		 q strRes
	}
}

/// Desc:       更新目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 内部标识符不能为空，-202 目录ID不能为空，-203 数据元标识符有误
/// 						  -300 未查到目录，-301 更新术语和模板关联关系失败， -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.Glossary).UpBDMCategoryJson()
ClassMethod UpGlossaryJson(argDTO As EMR.DOC.DTO.Glossary) As %String
{
	s strRes = "-100"
	TSTART
	if (argDTO.ID="")
	{
		TROLLBACK
		q "-200"
	}
	if (argDTO.InternalID = "")
	{
		TROLLBACK
		q "-201"
	}
	if (argDTO.GlossaryType '= "TG")&&(argDTO.GlossaryType '= "KG")
	{
		TROLLBACK
		q "-202"
	}
	s argDTO.LastModifyDate = $ZDATEH($ZDATE($h))
	s argDTO.LastModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	
	s obj = ##class(CF.EMR.DOC.Glossary).%OpenId(argDTO.ID)
	if (obj="")
	{
		TROLLBACK
		q "-200"
	} 
	s strInternalID = $zcvt(argDTO.InternalID,"U")
	s intParentID =obj.GlossaryCategory.%Id()
	s intCategroyID = intParentID
	if (argDTO.GlossaryType = "TG")
	{	
		s intParentID =obj.GlossaryCategory.%Id()
		s objGlossaryCategory = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(intParentID)
		if (intParentID'=0)&&(objGlossaryCategory="")
		{
			TROLLBACK
			q "-300"
		}
	}
	elseif(argDTO.GlossaryType = "KG")
	{
		s objPGlossary = ##class(CF.EMR.DOC.Glossary).%OpenId(intParentID)
		if (objPGlossary="")
		{
			TROLLBACK
			q "-300"
		}
		s intCategroyID= objPGlossary.GlossaryCategory.%Id()
		;s obj.GlossaryCategory = objPGlossary.GlossaryCategory
		;s obj.ParentID = argDTO.ParentID
	}
	
	if (argDTO.MetaID'="")
	{	
	; 传入的MetaID 需要去除 竖线以及后面部分，才可以查询
		s MetaID = ..GetIDByKey(argDTO.MetaID)
		s objDataElement = ##class(CF.EMR.DOC.DataElement).%OpenId(MetaID)	
		if (objDataElement="")
		{
			TROLLBACK
			q "-203"
		}
		s obj.MetaID = objDataElement
	}
	else
	{
		s obj.MetaID=""
	}
	s isHas = $o(^CF.EMR.DOC.GlossaryI("IdxCategoryIDInternalID",intCategroyID," "_strInternalID,""))
	if (isHas'="")&&(isHas'=argDTO.ID)
	{
		TROLLBACK
		q "-400"
	} 
	s obj.InternalID = argDTO.InternalID
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.GlossaryType = argDTO.GlossaryType
	s obj.LastModifyDate = argDTO.LastModifyDate
	s obj.LastModifyTime = argDTO.LastModifyTime
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		q obj.%Id()
	}
	else
	{
		TROLLBACK
		 q strRes
	}
}

/// Desc:       删除术语目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到术语,-301 更新目录子节点数失败	,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.Glossary).DelBDMCategoryJson("1")
ClassMethod DelGlossaryJson(aID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if (aID="")
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.Glossary).%OpenId(aID)
	if (obj="")  
	{
		TROLLBACK
		q "-300"
	}
	

	s strNodesCount = 0
	&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.Glossary c WHERE c.ParentID = :aID)
	if (strNodesCount>0)
	{
		TROLLBACK
		q "-500"
	}
	s strInternalID = obj.InternalID
	if (obj.GlossaryType="TG")
	{
		s objCategory = obj.GlossaryCategory
		s objCategory.ResChildCount = objCategory.ResChildCount-1
		if '(objCategory.%Save())
		{
			TROLLBACK
			q "-301"
		}
	}
	&sql(DELETE FROM CF_EMR_DOC.GlossaryItem i WHERE i.GlossaryID = :aID)
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q strRes
	}
	s sc = ##class(CF.EMR.DOC.Glossary).%DeleteId(aID)
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	q "1"
}

/// output 成功 1 失败 -201 术语集标识码未传  -202 实例ID未传 -203 就诊号未传
ClassMethod GetGlossaryInstanceDataJson(ByRef AOutData As %GlobalBinaryStream, AGlossaryID As %String, AInstanceID As %String, AEpisodeID As %String, APageSize = "", ACurrent = "")
{
	;q:AGlossaryID="" -201
	;q:AInstanceID="" -202
	;q:AEpisodeID="" -203
	s str="HDSD00.13.01^主诉^发热&HDSD00.13.02^年龄^13&HDSD00.13.03^性别^&HDSD00.13.04^病床号^14&HDSD00.13.05^病案号^2838811&HDSD00.13.06^初步诊断日期^2020-10-11 12:23:19&HDSD00.13.07^就诊科室^内分泌科&HDSD00.13.08^姓名^小罗&HDSD00.13.09^名族^&HDSD00.13.10^国籍^中国&HDSD00.13.11^补充诊断名称^"
	s len = $L(str,"&")
	s result = ##class(%DynamicObject).%New()
	s:APageSize="" APageSize=10
	s:ACurrent="" ACurrent=1
	s start = APageSize*(ACurrent-1)+1
	s end = APageSize*ACurrent
	s resultArray = ##class(%DynamicArray).%New()
	for i=1:1:len
	{
		continue:((i<start)||(i>end))
		s json = ##class(%DynamicObject).%New()
		s line = $P(str,"&",i)
		s json.code = $P(line,"^",1)
		s json.name = $P(line,"^",2)
		s json.value = $P(line,"^",3)
		d resultArray.%Push(json)
	}
	s result.total = len
	s result.pageSize = APageSize
	s result.current = ACurrent
	s result.list = resultArray
	d result.%ToJSON(AOutData)
	q 1
}

ClassMethod GetInstanceIDSJson(ByRef AOutData As %GlobalBinaryStream, AEpisodeID As %String)
{
	q:AEpisodeID="" -201
	s resultArray = ##class(%DynamicArray).%New()
	s str = "123||1^125||1^126||1^133||1"
	s len = 4
	for i=1:1:len
	{
		s line = $P(str,"^",i)
		d resultArray.%Push(line)
	}
	d resultArray.%ToJSON(AOutData)
	q 1
}

/// desc 术语集项检索
/// Debug:      w ##Class(EMR.DOC.BL.Glossary).SearchGlossary()
Query SearchGlossary(aText As %String) As %SQLQuery
{
	SELECT ID FROM CF_EMR_DOC.glossary  WHERE Name LIKE "%"_:aText_"%"
}

}
