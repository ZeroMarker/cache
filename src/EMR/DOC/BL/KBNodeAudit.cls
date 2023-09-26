/// 名称:	EMR.DOC.BL.KBNodeAudit
/// 描述:	文档片段审核业务类
/// 编写者：huhao
/// 编写日期: 2022-09-19
/// 产品组：电子病历产品组
Class EMR.DOC.BL.KBNodeAudit Extends EMR.DOC.COM.ActionBase
{

/// Desc:       文档片段审核状态变更
/// Creator:    huhao
/// CreateDate: 2022-9-19
/// Table:		CF.EMR.DOC.KBNode
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpdateKBNodeAudit(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s idGroup = argInJson.params.id
	s status = argInJson.params.status
	s remark=argInJson.params.remark
	s userCode=argInJson.params.userCode
	s IP=argInJson.params.IP
   	s strRes = ##class(EMR.DOC.BL.KBNodeAudit).Audit(idGroup,status,remark,userCode,IP,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","审核失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       批量审核文档片段
/// Creator:    huhao
/// CreateDate: 2022-09-19
/// Table:		
/// Input:      idGroup 模板id构成的数组，status 节点状态，remark 驳回申请原因， usercode 用户编码， ip 用户IP地址	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod Audit(idGroup As %DynamicArray, status As %String, remark As %String, usercode As %String, ip As %String, ByRef argOutData As %DynamicObject) As %String
{
	s strRes=""
	s count=idGroup.%Size()
	for i=0:1:(count-1)
	{
		s id=idGroup.%Get(i)
		s strRes= ##class(EMR.DOC.BL.KBNodeAudit).ChangeAudit(id,status,remark,usercode,ip)
	}
	q strRes
}

/// Desc:       单个文档片段审核
/// Creator:    huhao
/// CreateDate: 2022-9-19
/// Table:		CF.EMR.DOC.KBNodeAudit，CF.EMR.DOC.KBNodeStatusMLog，CF.EMR.DOC.KBNode
/// Input:      id 模板id，status 节点状态，remark 驳回申请原因， usercode 用户编码， ip 用户IP地址 	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod ChangeAudit(id As %String, status As %String, remark As %String, usercode As %String, ip As %String) As %String
{
	s strRes="",auditId=""
	s rowid=..GetIDByKey(id)
	q:rowid="" "-1^id不能为空"
	s type=..GetTypeByKey(id)
	q:type'="IT" "-1^请传入正确的节点ID"
	s obj=##class(CF.EMR.DOC.KBNode).%OpenId(rowid)
	TSTART
	s obj.Status=status
	d obj.%Save()
		
	&sql(select id into :auditId from CF_EMR_DOC.KBNodeAudit where KBNode=:rowid)
	if (auditId="")
	{
		s AuditObj=##class(CF.EMR.DOC.KBNodeAudit).%New()
		s AuditObj.Status=status
		s AuditObj.Remark=remark
		s AuditObj.KBNode=##class(CF.EMR.DOC.KBNode).%OpenId(rowid)
		s AuditObj.CreateID=usercode
		s AuditObj.OperateMachineIP=ip
		s AuditObj.CreateDate=$Piece($NOW(),",",1) 
		s AuditObj.CreateTime=$Piece($NOW(),",",2) 
		s sc = AuditObj.%Save()
		if ('$$$ISOK(sc))
		{
			s strRes="-1^保存出错"
			TROLLBACK
		}
		d addlog
	}
	else
	{
		s AuditObj=##class(CF.EMR.DOC.KBNodeAudit).%OpenId(auditId)
		s AuditObj.Status=status
		s AuditObj.Remark=remark
		s AuditObj.CreateID=usercode
		s AuditObj.OperateMachineIP=ip
		s AuditObj.ApplicationDate=$Piece($NOW(),",",1)  
		s AuditObj.ApplicationTime=$Piece($NOW(),",",2)  
		s sc = AuditObj.%Save()
		if ('$$$ISOK(sc))
		{
			s strRes="-1^保存出错"
			TROLLBACK
		}
		d addlog
	}
	s strRes="1"
		
	TCOMMIT
	q strRes
	
addlog
	s logObj=##class(CF.EMR.DOC.KBNodeStatusMLog).%New()
	s logObj.CreateDate=$Piece($NOW(),",",1) 
	s logObj.CreateID=usercode
	s logObj.CreateTime=$Piece($NOW(),",",2) 
	s logObj.KBNode=##class(CF.EMR.DOC.KBNode).%OpenId(rowid)
	s logObj.ModifyDate=$Piece($NOW(),",",1) 
	s logObj.ModifyID=usercode
	s logObj.ModifyTime=$Piece($NOW(),",",2) 
	s logObj.OperateMachineIP=ip
	s logObj.Remark=remark
	s logObj.Status=status
	d logObj.%Save()
}

/// Desc:       获取文档片段审核目录树
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"GET_KB_TREE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAuditKBNodeTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s DataTypes = "KB"
	s Status=argInJson.params.status
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.KBNodeAudit).GetKBTreeJson(UserCode,DataTypes,Status,roleCode,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取文档片段目录tree
/// Creator:    duan
/// CreateDate: 2021-05-06
/// Input:      argUserCode 用户Code
/// Output:     成功：1 失败：-101 用户不存在  -102 用户没有关联角色 -103 角色没有维护项目标识
/// 							  -200 userCode参数未传
/// debug:  q ##Class(EMR.DOC.BL.KBCategory).GetKBTreeJson("YS01")
ClassMethod GetKBTreeJson(argUserCode As %String, argDataTypes As %String, Status As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(roleCode="") "-200"
#;	s userObj = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(userObj="") "-101"
#;	q:(userObj.RoleID="") "-102"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"

	s RoleID = RoleID
	s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(roleCode)
	q:(productArray.%Size()=0) "-103"
	s jsonArr = ##class(%DynamicArray).%New()
	s strRes = "1"
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.KBCategoryTypes where Code = "Root")
	q:(rootID="") strRes
	set iter = productArray.%GetIterator()
	while iter.%GetNext(.key , .objProduct ) {
		s ProductID = objProduct.%Id()
        s jsonRoot  = ##class(%DynamicObject).%New()
        s cateID=""
	    &sql(select ID into :cateID from CF_EMR_DOC.KBCategory where Product = :ProductID and KBCategoryTypes = :rootID)
	    continue:(cateID="")
	    s objRoot=##class(CF.EMR.DOC.KBCategory).%OpenId(cateID)
        s jsonRoot.key =cateID_"||RT"
        s jsonRoot.title =objRoot.Name
        s jsonRoot.code ="root"
        s jsonRoot.permission = 1
        s jsonRoot.type = "RT"
        s jsonRoot.description = objRoot.Description
		s jsonCategory = ##class(%DynamicArray).%New()
		s argDataTypes = $ZCVT(argDataTypes,"U")
		d ##Class(EMR.DOC.BL.KBNodeAudit).GetJsonCategroyByPID(cateID,ProductID,RoleID,argDataTypes,"RT",Status,.jsonCategory)
		s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取业务模型目录数据
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, aProductID As %String, aRoleID As %String, aDataTypes As %String, flag As %String, Status As %String, ByRef jsonCategory As %DynamicArray, aKey As %String = "", level As %String)
{
	s res = "1"
	s rowCID = "",Sequence=""
	for 
	{
		s Sequence=$o(^CF.EMR.DOC.KBCategoryI("IdxProParentSeqId",aProductID," "_aParentId,Sequence))
		q:Sequence=""
		for
		{
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxProParentSeqId",aProductID," "_aParentId,Sequence,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s type=""
	    if (objCat.KBCategoryTypes.Code="Category")
	    {
		    s type="CG"
		}
		elseif (objCat.KBCategoryTypes.Code="Document")
		{
			s type="DT"
		}
		elseif (objCat.KBCategoryTypes.Code="Section")
		{
			s type="ST"
		}
		elseif (objCat.KBCategoryTypes.Code="KBTree")
		{
			s type="KT"
		}
		s flag=##class(CF.EMR.DOC.KBCategory).%OpenId(objCat.ParentID).KBCategoryTypes.Code
		
	    s jsonCat  = ##class(%DynamicObject).%New()
	    if ((flag="Section")&&(type="KT"))
	    {
		    s jsonCat.level=1
		}
	    elseif ((flag="KBTree")&&(type="KT")&&(level=1))
	    {
		    s jsonCat.level=2
		}
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    if (type="DT")
	    {
		    s BDMCategory = ""
		    s:(objCat.BDMCategory'="") BDMCategory =objCat.BDMCategory.%Id()_"||DT"
			s jsonCat.BDMCategory = BDMCategory  
		}
		if (type="KT")
		{
			s jsonCat.ctLoc=objCat.CTLoc
			s jsonCat.disease=objCat.Disease
		}
	    s jsonCat.description = objCat.Description
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,aDataTypes,objCat.KBCategoryTypes.Code,rowCID)
		s jsonCat.permission = Permission
	    continue:Permission<=0
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if ((type="KT")&&(objCat.ResChildCount'=0))
		{
			// 通过KBTRee获取node节点
			s result = ##Class(EMR.DOC.BL.KBNodeAudit).GetKBNodeJsonByPID(rowCID,aProductID,aRoleID,aDataTypes,Status,.jsonCateNew,jsonCat.key)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		else
		{
			s result = ##Class(EMR.DOC.BL.KBNodeAudit).GetJsonCategroyByPID(rowCID,aProductID,aRoleID,aDataTypes,flag,Status,.jsonCateNew,jsonCat.key,jsonCat.level)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		continue:jsonCateNew.%Size()=0
		d jsonCategory.%Push(jsonCat)	

		}
	}
	q res
}

/// Desc:       获取文档片段
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(1,"")
ClassMethod GetKBNodeJsonByPID(aParentId As %String, aProductID As %String, aRoleID As %String, aDataTypes As %String, Status As %String, ByRef jsonCategory As %DynamicArray, aKey As %String = "") As %String
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
	    if (Status="")
	    {
		    continue:(objKBNode.Status'=2)&&(objKBNode.Status'=3)
		}
		else
		{
	    	continue:objKBNode.Status'=Status
		}
	    s jsonSim.status = objKBNode.Status_""
	   	s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,aDataTypes,"IT",rowNID)
		s jsonSim.permission = Permission
	    continue:Permission<=0
		d jsonCategory.%Push(jsonSim)	
	}
	q res
}

}
