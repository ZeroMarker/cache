/// 名称:	EMR.DOC.BL.DPCategory
/// 描述:	个人短语业务逻辑(门诊、住院)
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DPCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取个人短语目录树
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_DPCATEGORY","params":{"userID":"10209","userLocID":"60"}}
/// 			userLocID 科室ID，userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDPCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.DPData).%New()
	s objItem.Product = argInJson.product
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.UserID = argInJson.params.userID
	s objItem.Langid = $case(argInJson.params.langID,"":20,:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.DPCategory).GetDPCategoryJson(objItem,.argOutData)
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

/// Desc:       获取个人短语目录tree
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod GetDPCategoryJson(aItem As EMR.DOC.DTO.DPData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.UserID="") "-1^用ID不能为空"
	s jsonArr = ##class(%DynamicArray).%New()
    s jsonCat  = ##class(%DynamicObject).%New()
	s dpBaseName = ##Class(EMR.DOC.COM.Translation).Get("EMRTrans","个人短语")
    s jsonCat.id = "0"
    s jsonCat.text = dpBaseName
    s jsonCat.type = "DPTreeBase"
    s jsonCat.state = "open"
    s hasNode = $o(^CF.EMR.DOC.DPCategoryI("IdxPUIDValidSeq",0,aItem.UserID," Y",""))
    s isLeaf= $case(hasNode,"":"Y",:"N")
    s jsonCat.isLeaf = isLeaf
    s:(hasNode="") jsonCat.iconCls="tree-folder"
    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(dpBaseName,4,"")
	s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(dpBaseName,3,"")
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.DPCategory).GetJsonCategroyByPID("0",aItem,.jsonCategory)
	s:(jsonCategory.%Size()>0) jsonCat.children = jsonCategory
	d jsonArr.%Push(jsonCat)
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取个人短语目录tree
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     
/// Debug:	q ##Class(EMR.DOC.BL.DPCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, aItem As EMR.DOC.DTO.DPData, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s treeSeq = ""
	for {
		s treeSeq = $o(^CF.EMR.DOC.DPCategoryI("IdxPUIDValidSeq",aParentId,aItem.UserID," Y",treeSeq))
		q:(treeSeq = "")		
		s rowCID = $o(^CF.EMR.DOC.DPCategoryI("IdxPUIDValidSeq",aParentId,aItem.UserID," Y",treeSeq,""))		
		s objCat = ##Class(CF.EMR.DOC.DPCategory).%OpenId(rowCID)
	    continue:(objCat="")||(objCat.IsValid="N")
	    s personalDPUserID = "",isLeaf= "",dpState="",state="",iconCls="",contentID=""
	    if (objCat.Type ="DPNode")
	    {
		   s nodeID = $o(^CF.EMR.DOC.DPContentI("IdxCategoryID",rowCID,""))
		   continue:(nodeID="")
		   s objNode = ##class(CF.EMR.DOC.DPContent).%OpenId(nodeID)
		   s personalDPUserID =objNode.UserID.%Id()
		   s dpState = "1"
		   s contentID = nodeID
	    }
	    else
	    {
		    s hasCNode = $o(^CF.EMR.DOC.DPCategoryI("IdxPUIDValidSeq",rowCID,aItem.UserID," Y",""))
		    s isLeaf= $case(hasCNode,"":"Y",:"N")
		    s:(hasCNode="") iconCls="tree-folder"
		    s state = "open"
	    }
	    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.DPCategory","Name",objCat.Name,aItem.Langid)
		s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.id = rowCID
	    s jsonCat.text = strName
	    s jsonCat.type = objCat.Type
	    s:(state'="") jsonCat.state = state
	    s:(iconCls'="") jsonCat.iconCls=iconCls
	    s:(personalDPUserID'="") jsonCat.personalDPUserID = personalDPUserID
	    s:(isLeaf'="") jsonCat.isLeaf = isLeaf
	    s:(dpState'="") jsonCat.dpState = dpState
	    s:(contentID'="") jsonCat.contentID = contentID
	    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
		s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
		s jsonCateNew = ##class(%DynamicArray).%New()
		s result = ##Class(EMR.DOC.BL.DPCategory).GetJsonCategroyByPID(rowCID,aItem,.jsonCateNew)
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew	
		
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取个人短语数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"LOAD_DPDATA","params":{"id":"1"}}
/// 			id 目录ID，name 短语名称
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadDPData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s contentID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.DPCategory).LoadDPDataJson(contentID,.argOutData)
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

/// Desc:       获取个人短语数据
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aContentID 短语ID
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod LoadDPDataJson(aContentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aContentID="") "-1^短语ID不能为空"
	s objItem = ##class(CF.EMR.DOC.DPContent).%OpenId(aContentID)
	q:(objItem="") "-1^短语ID获取短语失败"
	if (objItem.Content.IsNull()=1){
		d argOutData.Write(..#NONE)
	}
	else 
	{
		d objItem.Content.Rewind()
		while (objItem.Content.AtEnd = 0)
		{
			s tmpOut = objItem.Content.Read(30000)
			s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
			d argOutData.Write(tmpUtf8)
		}
	}
	q strRes
Error
    q -1_"^"_$zerror
}

/// Desc:       创建个人短语
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"CREATE_DPDATA","params":{"parentID":"1","userID":"10209","name":"短语名称","type":"DPTree"}}
/// 			parentID 目录ID，userID 用户ID，name 短语名称，type:类型
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CreateDPData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.DPData).%New()
	s objItem.ParentID = argInJson.params.parentID
	s objItem.Product = argInJson.product
	s objItem.Name = argInJson.params.name
	s objItem.UserID = argInJson.params.userID
	s objItem.Type = argInJson.params.type
    s strRes = ##Class(EMR.DOC.BL.DPCategory).CreateDPDataJson(objItem,.argOutData)
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

/// Desc:       创建个人短语
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod CreateDPDataJson(aItem As EMR.DOC.DTO.DPData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.UserID="") "-1^用ID不能为空"
	s objUser=##class(User.SSUser).%OpenId(aItem.UserID,0)
	q:(objUser="") "-1^获取用户失败"
	Tstart
	s objc = ##class(CF.EMR.DOC.DPCategory).%New()
    s objc.Name = aItem.Name
    s objc.Type = aItem.Type
    s objc.ParentID = aItem.ParentID
    s objc.UserID = objUser
    s objc.IsValid = "Y"
    s objc.Sequence = $case($d(^CF.EMR.DOC.DPCategoryD)>0,0:1,:^CF.EMR.DOC.DPCategoryD+1)
    s sc = objc.%Save()
    if ($$$ISERR(sc))
	{
		Trollback
		q "-1^创建个人短语节点失败"
	}
	if (aItem.Type ="DPNode")
	{
		s obj = ##class(CF.EMR.DOC.DPContent).%New()
	    s obj.CategoryID = objc
	    s obj.UserID = objUser
	    s obj.CreateDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
	    s obj.AuditID = objUser
	    s obj.AuditDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
	    s obj.Status = "2"
	    s sc = obj.%Save()
	    if ($$$ISERR(sc))
		{
			Trollback
			q "-1^保存个人短语失败"
		}
		//个人短语默认值设置
		s sourceCode = obj.%Id()
		s initData ={"type":"fragment","attrs":{"code":"","sourceCode":""},"children":[{"type":"paragraph","children":[{"type":"line","children":[{"text":" "}]}]}]}
	    s initData.attrs.sourceCode=sourceCode
	    s strData = $zcvt(initData.%ToJSON(),"I","UTF8")
	    d obj.Content.Write(strData)
	     s sc = obj.%Save()
	    if ($$$ISERR(sc))
		{
			Trollback
			q "-1^保存个人短语失败"
		}
	}
	TCOMMIT
    s personalDPUserID = "",isLeaf= "Y",dpState="",state="open",contentID=""
    if (aItem.Type ="DPNode")
    {
	   s personalDPUserID =obj.UserID.%Id()
	   s isLeaf=""
	   s dpState = "1"
	   s contentID = obj.%Id()
	   s state=""
    }
    s strName = ##Class(EMR.DOC.COM.Translation).Get("EMRTrans",aItem.Name)
    s jsonArr = ##class(%DynamicArray).%New()
    s jsonCat  = ##class(%DynamicObject).%New()
    s jsonCat.id = objc.%Id()
    s jsonCat.text = strName
    s jsonCat.type = objc.Type
    s:(state'="") jsonCat.state = state
    s:(state'="") jsonCat.iconCls="tree-folder"
    s:(personalDPUserID'="") jsonCat.personalDPUserID = personalDPUserID
    s:(isLeaf'="") jsonCat.isLeaf = isLeaf
    s:(dpState'="") jsonCat.dpState = dpState
    s:(contentID'="") jsonCat.contentID= contentID
    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
	s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
	d jsonArr.%Push(jsonCat)
	d jsonArr.%ToJSON(argOutData)
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       更新目录名称
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"UP_DPCATENAME","params":{"id":"1","name":"短语名称"}}
/// 			id 目录ID，name 短语名称
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpDPCateName(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.DPData).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.Name = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.DPCategory).UpDPCateNameJson(objItem,.argOutData)
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

/// Desc:       更新目录名称
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod UpDPCateNameJson(aItem As EMR.DOC.DTO.DPData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^节点ID不能为空"
	q:(aItem.Name="") "-1^节点名称不能为空"
	s objc = ##class(CF.EMR.DOC.DPCategory).%OpenId(aItem.ID)
    s objc.Name = aItem.Name
    s sc = objc.%Save()
    q:($$$ISERR(sc)) "-1^更新目录名称失败"
	d argOutData.Write("""1""")
	q strRes
Error
    q -1_"^"_$zerror
}

/// Desc:       停用个人短语
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"STOP_DPDATA","params":{"id":"1","isValid":"N"}}
/// 			id 目录ID，name 短语名称
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod StopDPData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.DPData).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.IsValid = argInJson.params.isValid
    s strRes = ##Class(EMR.DOC.BL.DPCategory).StopDPDataJson(objItem,.argOutData)
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

/// Desc:       停用个人短语
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod StopDPDataJson(aItem As EMR.DOC.DTO.DPData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^节点ID不能为空"
	q:(aItem.IsValid="") "-1^节点状态不能为空"
	s objc = ##class(CF.EMR.DOC.DPCategory).%OpenId(aItem.ID)
    s objc.IsValid = aItem.IsValid
    s sc = objc.%Save()
    q:($$$ISERR(sc)) "-1^更新短语状态失败"
	d argOutData.Write("""1""")
	q strRes
Error
    q -1_"^"_$zerror
}

/// Desc:       个人短语排序
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"SWAP_DPSEQUENCE","params":{"id1":"1","id2":"2"}}
/// 			id1 ID1，id2 ID2
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SwapDPSequence(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id1 = argInJson.params.id1
	s id2 = argInJson.params.id2
    s strRes = ##Class(EMR.DOC.BL.DPCategory).SwapDPSequenceJson(id1,id2,.argOutData)
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

/// Desc:       个人短语排序
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      id1 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod SwapDPSequenceJson(id1 As %String, id2 As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(id1="")||(id2="") "-1^ID不能为空"
	
    s objNextCategory = ##class(CF.EMR.DOC.DPCategory).%OpenId(id1)
    s objSelectCategory = ##class(CF.EMR.DOC.DPCategory).%OpenId(id2)
    q:((objNextCategory = "")||(objSelectCategory = "")) "-1^通过ID获取短语失败"
    s TempSequence = objNextCategory.Sequence
    s objNextCategory.Sequence = objSelectCategory.Sequence
    s objSelectCategory.Sequence = TempSequence
    Tstart
    s scResult = objNextCategory.%Save() 
    s scResultSele = objSelectCategory.%Save() 
    if $$$ISERR(scResult)
    {
        Trollback
        q "-1^更新个人短语顺序失败"
    }
    if $$$ISERR(objSelectCategory)
    {
        Trollback
        q "-1^更新个人短语顺序失败"
    }
    TCOMMIT
    d argOutData.Write("""1""")
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       保存短语
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"SAVE_DPDATA","params":{"id":"2","state":"2"}}
/// 			id id, name 名称，description 描述，isValid 是否生效
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveDPData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.DPData).%New()
	;s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.ContentID = argInJson.params.id
	s objItem.Status = argInJson.params.state
    s strRes = ##Class(EMR.DOC.BL.DPCategory).SaveDPDataJson(objItem,argInData,.argOutData)
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

/// Desc:       保存短语
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod SaveDPDataJson(aItem As EMR.DOC.DTO.DPData, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ContentID="") "-1^ID不能为空"
   	;s obj = ##class(CF.EMR.DOC.DPCategory).%OpenId(aItem.ID)
    ;q:(obj = "") "-1^根据ID获取对象失败"
    ;s obj.Description = aItem.Description
    ;s obj.Name = aItem.Name
    ;s obj.IsValid = aItem.IsValid
    s objContent = ##class(CF.EMR.DOC.DPContent).%OpenId(aItem.ContentID)
    s objContent.Status = "2"
    q:(objContent = "") "-1^根据ID获取对象失败"
    d objContent.Content.CopyFrom(argInData)
    TStart
    /*
    s scResult = obj.%Save()
    if ($$$ISERR(scResult))
    {
        TROLLBACK
        q "-1^保存短语节点失败"
    }
    */
    s sc = objContent.%Save() 
    if ($$$ISERR(sc))
    {
        TROLLBACK
        q "-1^保存短语内容失败"
    }
    TCOMMIT            
    k objContent
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       更新短语节点目录
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.DPCategory 个人短语目录表,CF.EMR.DOC.DPContent 个人短语表
/// Input:      argInJson  命令参数 {"product":"OP","action":"UP_DPCATEGORYID","params":{"id":"1","categoryID":"2"}}
/// 			id 目录ID，name 短语名称
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UPDPCategoryID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.DPData).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.ParentID = argInJson.params.categoryID
    s strRes = ##Class(EMR.DOC.BL.DPCategory).UPDPCategoryIDJson(objItem,.argOutData)
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

/// Desc:       更新短语节点目录
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.DPCategory).GetDPTreeJson("YS01")
ClassMethod UPDPCategoryIDJson(aItem As EMR.DOC.DTO.DPData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^节点ID不能为空"
	q:(aItem.ParentID="") "-1^节点目录ID不能为空"
	s objc = ##class(CF.EMR.DOC.DPCategory).%OpenId(aItem.ID)
    s objc.ParentID = aItem.ParentID
    s sc = objc.%Save()
    q:($$$ISERR(sc)) "-1^更新短语目录失败"
	d argOutData.Write("""1""")
	q strRes
Error
    q -1_"^"_$zerror
}

}
