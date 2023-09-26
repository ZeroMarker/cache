/// 名称:	EMR.DOC.BL.KBTree
/// 描述:	文档片段目录业务类(门诊、住院)
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.BL.KBTree Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取文档片段目录树
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.KBCategory 文本片段目录表,CF_EMR_DOC.KBNode 文本片段表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_BINDKBNODE","params":{"nodeBaseID":"2","diseaseID":"","episodeID":"1153","userLocID":"60","userID":"10209"}}
/// 			nodeBaseID 片段章节类型ID，diseaseID 病种ID，episodeID 就诊号，userLocID 科室ID，userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBindKBNode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.KBTree).%New()
	s objItem.Product = argInJson.product
	s objItem.KBSectionID = argInJson.params.nodeBaseID
	s objItem.DiseaseID = argInJson.params.diseaseID
	s objItem.EpisodeID = argInJson.params.episodeID
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.UserID = argInJson.params.userID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.KBTree).GetBindKBNodeJson(objItem,.argOutData)
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

/// Desc:       获取文档片段目录tree
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 片段对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.KBTree).GetKBTreeJson("YS01")
ClassMethod GetBindKBNodeJson(aItem As EMR.DOC.DTO.KBTree, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.KBSectionID="") "-1^片段章节类型ID不能为空"
	s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(aItem.KBSectionID)
    q:(objCat="") "-1^"_aItem.KBSectionID_"片段章节数据未获取到"

	//南山人民有个特殊科室-特诊中心,其他科室医师会在这个科室坐诊，需要显示本医师默认登录科室安全组的病例模版和知识库
	s specialLocIds = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("specialLocId",aItem.Product,"")
	if (specialLocIds'="")
	{
		s specialLocIds= "^"_specialLocIds_"^"
		s curLocID = "^"_aItem.UserLocID_"^"
		s:(specialLocIds[curLocID) aItem.UserLocID = $p($g(^SSU("SSUSR",aItem.UserID)),"^",4)
	}
	s aItem.IsCollapse = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("setKnowledgeBaseCollapse",aItem.Product,"1")
	s jsonArr = ##class(%DynamicArray).%New()
    s jsonCat  = ##class(%DynamicObject).%New()
	s kbBaseName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.KBCategory","Name",objCat.Name,aItem.LangID)
	s kbBaseName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(kbBaseName)
    s jsonCat.id = aItem.KBSectionID
    s jsonCat.text = kbBaseName
    s jsonCat.type = "KBBase"
    s jsonCat.state = "open"
    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(kbBaseName,4,"")
	s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(kbBaseName,3,"")
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.KBTree).GetJsonCategroyByPID(aItem.KBSectionID,aItem,.jsonCategory)
	s:(jsonCategory.%Size()>0) jsonCat.children = jsonCategory
	d jsonArr.%Push(jsonCat)
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取业务模型目录数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aParentId 目录ID
/// 			aUserLocID 科室ID
///             jsonCategory 目录json对象
/// Output:     
/// Debug:	q ##Class(EMR.DOC.BL.KBTree).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, aItem As EMR.DOC.DTO.KBTree, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s treeSeq = ""
	for {
		s treeSeq = $o(^CF.EMR.DOC.KBCategoryI("IdxParentIDAndSeq"," "_aParentId,treeSeq))
		q:(treeSeq = "")		
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxParentIDAndSeq"," "_aParentId,treeSeq,""))		
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")||(objCat.CTLoc="")
	    //授权科室过滤
	    s curCTLoc = "^"_objCat.CTLoc_"^"
	    s userLoc ="^"_ aItem.UserLocID_"^"
		continue:('curCTLoc [ userLoc)
	    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.KBCategory","Name",objCat.Name,aItem.LangID)
		s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)
		if (aItem.IsCollapse = "3")
		{
			s treeState= $case($o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",rowCID,"")),"":"open",:"closed")
		}
		else
		{
			s treeState = "closed"
		}
		
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.id = rowCID
	    s jsonCat.text = strName
	    s jsonCat.type = "KBTree"
	    s jsonCat.state = treeState
	    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
		s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if (($ZCVT(objCat.KBCategoryTypes.Code,"U")="KBTREE")&&(objCat.ResChildCount'=0))
		{
			// 通过KBTRee获取node节点
			s result = ##Class(EMR.DOC.BL.KBTree).GetKBNodeJsonByPID(rowCID,aItem,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		else
		{
			s result = ##Class(EMR.DOC.BL.KBTree).GetJsonCategroyByPID(rowCID,aItem,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew	
		}
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取文档片段
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(1,"")
ClassMethod GetKBNodeJsonByPID(aParentId As %String, aItem As EMR.DOC.DTO.KBTree, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",aParentId,""))
	s:(rowID="") res ="-1"
	s sequence=""
	for {
		s rowNID = ""
		s sequence = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",aParentId,sequence))
		q:sequence=""
		s rowNID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",aParentId,sequence,""))
		q:(rowNID = "")				
		s objKBNode = ##Class(CF.EMR.DOC.KBNode).%OpenId(rowNID)
	    continue:(objKBNode="")
	    continue:(objKBNode.Status'="2")
	    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.KBNode","Name",objKBNode.Name,aItem.LangID)
		s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)
	    s jsonSim  = ##class(%DynamicObject).%New()
	    s jsonSim.id = rowNID
	    s jsonSim.text = strName
	    s jsonSim.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
		s jsonSim.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
	    ;s jsonSim.desc = objKBNode.Description
	    s jsonSim.type = "KBNode"
		d jsonCategory.%Push(jsonSim)	
	}
	q res
}

/// Desc:       获取文档片段文本数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.KBCategory 文本片段目录表,CF_EMR_DOC.KBNode 文本片段表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_KBNODETEXT","params":{"id":"12"}}
/// 			id 文档片段ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKBNodeText(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product = argInJson.product
	s kbNodeID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.KBTree).GetKBNodeTextJson(kbNodeID,product,.argOutData)
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

/// Desc:       获取文档片段文本数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aKBNodeID 文档片段id
/// 			aProduct 项目标识
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.KBTree).GetKBTreeJson("YS01")
ClassMethod GetKBNodeTextJson(aKBNodeID As %String, aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aKBNodeID="") "-1^文档片段ID不能为空"
	s objNode = ##Class(CF.EMR.DOC.KBNode).%OpenId(aKBNodeID)
    q:(objNode="") "-1^根据ID获取文档片段失败"
    s TextData = """"_objNode.TextData_""""
    s TextData = $REPLACE(TextData,$C(10),"<br/>")
	d argOutData.Write(TextData)
	q strRes
}

}
