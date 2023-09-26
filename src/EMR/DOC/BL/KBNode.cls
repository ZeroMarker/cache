/// 名称:	EMR.DOC.BL.KBNode
/// 描述:	通用文档管理模块 Document(Doc) 文档片段 片段节点业务类
/// 编写者：duan
/// 编写日期: 2021-05-08
/// 产品组：电子病历产品组
Class EMR.DOC.BL.KBNode Extends EMR.DOC.COM.ActionBase
{

/// Desc:       添加片段
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_NODE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddNode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s NodeObj = ##class(EMR.DOC.DTO.KBNode).%New()
	s KBTreeID = ..GetIDByKey(argInJson.params.id)
	s NodeObj.Description = argInJson.params.description
	/*
	if (argInData.IsNull()'=1){
		d NodeObj.DocumentData.CopyFrom(argInData)
	}*/
	s NodeObj.KBCategory = KBTreeID
	s NodeObj.Name = argInJson.params.name
	s NodeObj.TextData =argInJson.params.textData
	s NodeObj.Status = 0
	s LogObj = ##class(EMR.DOC.DTO.KBNodeStatusMLog).%New()
	s LogObj.OperateMachineIP = argInJson.params.IP
	s UserCode = argInJson.params.userCode
	s LogObj.CreateID = UserCode
	s LogObj.ModifyID = UserCode
	s roleCode=argInJson.params.safeGroupId
	s childType=argInJson.params.childType
    s strRes = ##Class(EMR.DOC.BL.KBNode).AddNodeJson(NodeObj,LogObj,UserCode,roleCode,childType)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点数据类型不正确，检查参数id",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点下有其他分类节点时不允许新建片段",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加日志失败",2)
	}
	elseif(strRes="-105")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","设置权限失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未获取到章节节点，检查数据源",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新片段信息
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"UPDATE_KB_NODE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateNode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DTONode = ##class(EMR.DOC.DTO.KBNode).%New()
	s NodeID = ..GetIDByKey(argInJson.params.id)
	s DTONode.ID =NodeID
	s DTONode.Description = argInJson.params.description
	d DTONode.DocumentData.CopyFrom(argInData)
	s DTONode.KBCategory = argInJson.params.parentId
	s DTONode.Name = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.KBNode).UpdateNodeJson(DTONode)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数未传",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段NODE类型数据不存在，检查数据源",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未获取到章节节点，检查数据源",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除片段信息
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"DELETE_KB_NODE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteNode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s NodeID = ..GetIDByKey(argInJson.params.id)
	s DTOLog = ##class(EMR.DOC.BL.KBNodeStatusMLog).GetMaxLog(NodeID)
	s DTOLog.OperateMachineIP = argInJson.params.IP
	s DTOLog.ModifyID = argInJson.params.userCode
    s strRes = ##Class(EMR.DOC.BL.KBNode).DeleteNodeJson(NodeID,DTOLog)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","已经审核或发布的片段不允许删除",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加删除日志失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数未传",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","片段节点数据不存在，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       加载片段内容
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_NODE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s KBNodeID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.KBNode).LoadDocumentJson(KBNodeID,argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败,检查参数id",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","片段节点数据不存在，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       保存片段内容
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"SAVE_KB_DOCUMENT","params":{"userCode": "YS01",IP:"",documentData:"",textData:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DTONode = ##class(EMR.DOC.DTO.KBNode).%New()
	s KBNodeID = ..GetIDByKey(argInJson.params.id)
	s DTONode.ID = KBNodeID
	d DTONode.DocumentData.CopyFrom(argInData)
	s DTONode.TextData =argInJson.params.textData
	s DTONode.Status = 1
	s DTOLog = ##class(EMR.DOC.BL.KBNodeStatusMLog).GetMaxLog(KBNodeID)
	s DTOLog.OperateMachineIP = argInJson.params.IP
	s DTOLog.ModifyID = argInJson.params.userCode
	s DTOLog.Remark=argInJson.params.remark
    s strRes = ##Class(EMR.DOC.BL.KBNode).SaveDocumentJson(DTONode,DTOLog)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","已经审核的片段不允许编辑",2)
	}
	
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加日志失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数不能为空",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","片段节点数据不存在，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取文档片段
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(1,"")
ClassMethod GetKBNodeJsonByPID(aParentId As %String, aProductID As %String, aRoleID As %String, aDataTypes As %String, ByRef jsonCategory As %DynamicArray, aKey As %String = "") As %String
{
	s res = "1"
	s rowID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",aParentId,""))
	s:(rowID="") res ="-1"
	s sequence=""
	for {
		s rowNID = ""
		s sequence = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",aParentId,sequence))
		q:sequence=""
		s rowNID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",aParentId,sequence,rowNID))
		q:(rowNID = "")				
		s objKBNode = ##Class(CF.EMR.DOC.KBNode).%OpenId(rowNID)
	    continue:(objKBNode="")
	    s jsonSim  = ##class(%DynamicObject).%New()
	    s jsonSim.key = rowNID_"||IT"
	    s jsonSim.title = objKBNode.Name
	    s jsonSim.type = "IT"
	    s jsonSim.description = objKBNode.Description
	    s jsonSim.product=objKBNode.Product.ProductCode
	    s jsonSim.status = objKBNode.Status_""
	   	s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,aDataTypes,"IT",rowNID)
		s jsonSim.permission = Permission
	    continue:Permission<=0
		
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductID,aRoleID,aDataTypes,"IT",rowNID)
		s jsonSim.checked=checkStatus
		
		d jsonCategory.%Push(jsonSim)	
	}
	q res
}

/// Desc:       分类上添加片段
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      NodeDTO 片段DTO对象
/// Output:     成功：1 失败：     -101 数据操作失败 -102 分类节点数据类型不正确 -103 分类节点下有其他分类节点时不允许新建片段 -104新建日志失败 -105 设置权限失败
///             				   -200 必填项校验失败
/// 								-301 分类节点数据不存在，检查参数id -302 片段类型数据不存在，检查数据源 -303 章节节点没取到
ClassMethod AddNodeJson(NodeDTO As EMR.DOC.DTO.KBNode, LogDTO As EMR.DOC.DTO.KBNodeStatusMLog, AUserCode As %String, roleCode As %String, type As %String) As %String
{
	q:((NodeDTO="")||(NodeDTO.KBCategory="")||(NodeDTO.Name="")) "-200"	
	TSTART
	s NodeObj = ##class(CF.EMR.DOC.KBNode).%New()
	s KBCategoryObj = ##class(CF.EMR.DOC.KBCategory).%OpenId(NodeDTO.KBCategory)
	q:(KBCategoryObj="") "-301"
	q:($ZCVT(KBCategoryObj.KBCategoryTypes.Code,"U")'="KBTREE") "-102"
	/*分类下为分类节点的时候不允许新建片段*/
	s count = 0
	&SQL(select Count(*) into :count from CF_EMR_DOC.KBCategory where ParentID = :NodeDTO.KBCategory)
	q:(count>0) "-103"

	s SectionID = ..GetSectionID(NodeDTO.KBCategory)
	q:(SectionID=0) "-30"
	s ObjSection = ##class(CF.EMR.DOC.KBCategory).%OpenId(SectionID)
	q:(ObjSection="") "-303"
	s NodeObj.SectionID = ObjSection
	
	s NodeObj.Description = NodeDTO.Description
	s NodeObj.Name = NodeDTO.Name
	s NodeObj.Product = KBCategoryObj.Product
	s NodeObj.Status = NodeDTO.Status
	s NodeObj.TextData = NodeDTO.TextData
	/*
	if (NodeDTO.DocumentData.IsNull()'=1){
		d NodeObj.DocumentData.CopyFrom(NodeDTO.DocumentData)	
	}
	*/
	s NodeObj.Sequence = $g(^CF.EMR.DOC.KBNodeD)+1
	s NodeObj.EffectiveDate = $ZDATEH($ZDATE($h))
	s NodeObj.EffectiveTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	
	s GUID = ##class(%SYSTEM.Util).CreateGUID()
	s NodeObj.GUID = GUID
	
	s NodeObj.Description = NodeDTO.Description
	
	s NodeObj.KBCategory = KBCategoryObj
	s ResChildCount = 0
	s:(KBCategoryObj.ResChildCount>0) ResChildCount=KBCategoryObj.ResChildCount
	s KBCategoryObj.ResChildCount = ResChildCount+1
	if '(KBCategoryObj.%Save())
	{
		TROLLBACK 
		q "-101"
	}
	if '(NodeObj.%Save())
	{
	 	TROLLBACK 
		q "-101"
	}
	s sourceCode=NodeObj.%Id()
	s initData ={"type":"fragment","attrs":{"code":"","sourceCode":""},"children":[{"type":"paragraph","children":[{"type":"line","children":[{"text":" "}]}]}]}
	s initData.attrs.sourceCode=sourceCode
	s strData = $zcvt(initData.%ToJSON(),"I","UTF8")
	d NodeObj.DocumentData.Write(strData)
	if '(NodeObj.%Save())
	{
		TROLLBACK
		q "-101"	
	}
	//添加数据权限
	s strRes = NodeObj.%Id()
	s ProductID = ""
	s:(NodeObj.Product'="") ProductID=NodeObj.Product.%Id()
	s role = ##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	s RoleID =""
	s:(role'="") RoleID=role
	s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(RoleID,strRes,"KB",type,NodeObj.Name,ProductID)
	if (isOk'="1"){
		TROLLBACK
		s strRes = isOk
		q strRes
	}
	//新建日志
	s LogDTO.KBNode = NodeObj.%Id()
	s LogDTO.Status = NodeObj.Status
	s LogDTO.CreateDate = $ZDATEH($ZDATE($h))
 	s LogDTO.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s LogDTO.ModifyDate = $ZDATEH($ZDATE($h))
	s LogDTO.Remark="新建片段"
	s LogDTO.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s strMRes = ##Class(EMR.DOC.BL.KBNodeStatusMLog).AddMLog(LogDTO)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-104"
	}
	TCOMMIT
	q "1"
}

// desc 获取分类节点挂载的章节ID

ClassMethod GetSectionID(KBTreeID As %String = "")
{
	q:KBTreeID="" 0
	s SectionID = 0 
	s ParentObj = ##class(CF.EMR.DOC.KBCategory).%OpenId(KBTreeID)
	q:(ParentObj="") 0
	if ($ZCVT(ParentObj.KBCategoryTypes.Code,"U")="SECTION")
	{
		s SectionID =  ParentObj.%Id()	
	}
	elseif($ZCVT(ParentObj.KBCategoryTypes.Code,"U")="KBTREE"){
		s SectionID = ..GetSectionID(ParentObj.ParentID)
	}
	else
	{
		s SectionID = 0	
	}
	q SectionID
}

/// Desc:       更新片段节点
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      NodeDTO 片段DTO对象
/// Output:     成功：1 失败：     -101 数据操作失败 -102 分类节点数据类型不正确 -103 分类节点下有其他分类节点时不允许新建片段 -104新建日志失败
///             				   -200 必填项校验失败
/// 
ClassMethod UpdateNodeJson(NodeDTO As EMR.DOC.DTO.KBNode) As %String
{
	q:((NodeDTO="")||(NodeDTO.ID="")||(NodeDTO.Name="")) "-200"
	TSTART
	s ObjNode = ##class(CF.EMR.DOC.KBNode).%OpenId(NodeDTO.ID)
	q:(ObjNode="") "-301"
	if ((NodeDTO.KBCategory'="")&(NodeDTO.KBCategory'=ObjNode.KBCategory.%Id()))
	{
		//剪切
		s ObjKBTree = ##class(CF.EMR.DOC.KBCategory).%OpenId(NodeDTO.KBCategory)
		q:(ObjKBTree="") "-302"
		s sectionID = ..GetSectionID(NodeDTO.KBCategory)
		q:(sectionID=0) "-303"
		s ObjOldKBTree = ##class(CF.EMR.DOC.KBCategory).%OpenId(ObjNode.KBCategory.%Id())
		s ObjOldKBTree.ResChildCount = ObjOldKBTree.ResChildCount-1
		if ('(ObjOldKBTree.%Save()))
		{
			TROLLBACK
			q "-101"	
		}
		s resChildCount = 0
		s:(ObjKBTree.ResChildCount>0) resChildCount = ObjKBTree.ResChildCount
		s ObjKBTree.ResChildCount = resChildCount+1
		if ('(ObjKBTree.%Save()))
		{
			TROLLBACK
			q "-101"	
		}
		s ObjNode.KBCategory = ObjKBTree
		s ObjNode.SectionID = sectionID
		s ObjNode.Product = ObjKBTree.Product 
	}
	// d ObjNode.DocumentData.CopyFrom(NodeDTO.DocumentData)
	s ObjNode.Name = NodeDTO.Name
	s ObjNode.Description = NodeDTO.Description
	if ('(ObjNode.%Save()=1))
	{
		TROLLBACK
		q "-101"	
	}
	TCOMMIT
	q "1"
}

/// Desc:       删除片段节点
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      NodeDTO 片段DTO对象
/// Output:     成功：1 失败：     -101 数据操作失败 -102 片段状态不允许删除 -103 添加删除日志失败
///             				   -200 必填项校验失败
/// 							   -301 片段节点不存在 
ClassMethod DeleteNodeJson(ANodeID As %String, AMLog As EMR.DOC.DTO.KBNodeStatusMLog)
{
	q:(ANodeID="") "-200"
	TSTART
	s ObjNode = ##class(CF.EMR.DOC.KBNode).%OpenId(ANodeID)
	q:(ObjNode="") "-301"
	
	//0 新建 1 保存 5 审核不通过  允许删除 
	q:((ObjNode.Status'=0)&(ObjNode.Status'=1)&(ObjNode.Status'=5)) "-102"
	
	//删除片段
	&SQL(DELETE  FROM CF_EMR_DOC.KBNode WHERE ID = :ANodeID)
	if ((SQLCODE'=0)&&(SQLCODE'=100))
	{
		TROLLBACK
		q "-101"
	}
	// 更改ResChildCount
	s ObjParent = ObjNode.KBCategory
	s ObjParent.ResChildCount = ObjParent.ResChildCount-1
	if ('(ObjParent.%Save()=1))
	{
		TROLLBACK
		q "-101"	
	}
	//添加删除日志
	s AMLog.Status = "-1"
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.Remark="删除片段"

	s strMRes = ##Class(EMR.DOC.BL.KBNodeStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-103"
	}
	TCOMMIT
	q "1"
}

/// Desc:       加载片段内容
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:     ANodeID 片段节点ID
/// Output:     成功：1 失败：     -200 必填项校验失败
/// 							   -301 片段节点不存在
/// debug : s AOutData = ##class(%GlobalBinaryStream).%New()
/// debug : ##Class(EMR.DOC.BL.KBNode).LoadDocumentJson(14,AOutData)
ClassMethod LoadDocumentJson(ANodeID As %String, ByRef AOutData As %GlobalBinaryStream)
{
	q:(ANodeID="") "-200"
	s ObjNode = ##class(CF.EMR.DOC.KBNode).%OpenId(ANodeID)
	q:(ObjNode="") "-301"
	if (ObjNode.DocumentData.IsNull()=1){
		d AOutData.Write(..#NONE)
	}else {
		d ObjNode.DocumentData.Rewind()
		while (ObjNode.DocumentData.AtEnd = 0)
		{
			s tmpOut = ObjNode.DocumentData.Read(30000)
			s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")

			d AOutData.Write(tmpUtf8)
		}
		
	}
	q "1"
}

/// Desc:       保存片段内容
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:     ANodeID 片段节点ID
/// Output:     成功：1 失败：     -101保存失败 -102 已经审核的片段不允许再次编辑 -103 保存日志失败
/// 							   -200 必填项校验失败
/// 							   -301 片段节点不存在
ClassMethod SaveDocumentJson(NodeDTO As EMR.DOC.DTO.KBNode, LogDTO As EMR.DOC.DTO.KBNodeStatusMLog)
{
	q:((NodeDTO="")||(NodeDTO.ID="")) "-200"	
	TSTART
	s ObjKBNode = ##class(CF.EMR.DOC.KBNode).%OpenId(NodeDTO.ID)
	if (ObjKBNode="") 
	{
		TROLLBACK
		q "-301"
	}
	if ((ObjKBNode.Status'="0")&(ObjKBNode.Status'="1")&(ObjKBNode.Status'=5)) {
		TROLLBACK	
		q "-102" 
	}
	s ObjKBNode.Status = NodeDTO.Status || 1
	s ObjKBNode.TextData = NodeDTO.TextData
	d ObjKBNode.DocumentData.CopyFrom(NodeDTO.DocumentData)
	if '(ObjKBNode.%Save())
	{
		TROLLBACK 
		q "-101"
	}
	//新建日志
	s LogDTO.Status = ObjKBNode.Status
	s LogDTO.ModifyDate = $ZDATEH($ZDATE($h))
	s LogDTO.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s strMRes = ##Class(EMR.DOC.BL.KBNodeStatusMLog).AddMLog(LogDTO)
	if (strMRes="-1")
	{
		TROLLBACK
		q "-103"	
	}
	TCOMMIT
	q "1"
}

}
