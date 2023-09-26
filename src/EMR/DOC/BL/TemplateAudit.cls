/// 名称:EMR.DOC.BL.TemplateAudit
/// 描述:通用文档管理模块 Document(Doc) 文档审核管理
/// 编写者：zhangxl
/// 编写日期: 2021-09-16
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TemplateAudit Extends EMR.DOC.COM.ActionBase
{

/// Desc:       文档审核(包括审核成功与不成功)
/// Creator:    zhangxl
/// CreateDate: 2021-9-16
/// Table:      CF.EMR.DOC.TemplateVersion 文档版本表;CF.EMR.DOC.TemplateAudit 文档审核表
/// Input:      argArray  	命令参数 {"action":"AUDIT_TEMPLATE","params":{"templateIds":"259^262","status":"1","remark":"不通过意见"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AuditTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Status = argInJson.params.status	 //使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
	s Remark = argInJson.params.remark   // 审核不通过的原因；审核通过可为空
	s IDStr = argInJson.params.templateIds	
    s strRes = ##Class(EMR.DOC.BL.TemplateAudit).AuditTemplateJson(Status,Remark,IDStr)
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

/// Desc:      文档审核
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      IDStr   文档id
///             Status  审核状态
///             Remark  审核不通过意见
/// OutPut:     返回数据 成功,
/// Debug:      w ##Class(EMR.DOC.BL.TemplateAudit).AuditTemplateJson(Status,Remark,IDStr)
ClassMethod AuditTemplateJson(Status As %String, Remark As %String, IDStr As %String)
{
	s Result = "-1"
	q:($g(IDStr) = "") Result
	S IDCount =$L(IDStr,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s TemplateID = $p(IDStr,"^",I)
		s obj = ##Class(CF.EMR.DOC.TemplateVersion).%OpenId(TemplateID)
		q:(obj = "")
		q:(obj.Template = "")
		
		//文档最新发布版本号改变
		s objTemplate = obj.Template
		if (Status="2")
		{
			s objTemplate.TempPublishVersion=obj.%Id()
		}	
		if ('objTemplate.%Save())
		{
			s Result = 0
			q 
		}	
		//版本状态改变
		s obj.Status =Status
		if ('obj.%Save())
		{
			s Result = 0
			q 
		}	
		//文档审核表修改
		s rowId=""
		s rowId = $o(^CF.EMR.DOC.TemplateAuditI("IdxTemplateVersion",TemplateID,""))
    	if (rowId = "")
      	{
          	s objAudit = ##Class(CF.EMR.DOC.TemplateAudit).%New()
          	s objAudit.TemplateVersion =obj
     	 }
   		 else
      	{
          	s objAudit = ##Class(CF.EMR.DOC.TemplateAudit).%OpenId(rowId)
     	 }
		
		s objAudit.Remark =Remark
		s objAudit.Status =Status
		s objAudit.AuditDate = $ZDATE($p($HOROLOG,",",1),3)_" "_$ZTIME($p($HOROLOG,",",2))
		if '(objAudit.%Save() )
		{
			s Result = 0
			q 
		}
	}
	if (Result = 0)
	{
		 TROLLBACK
		 q 0
	}
	TCOMMIT
	s Result = "1"
	q Result
OPRecordError
	Trollback
    q -1_"^"_$zerror
OPError
    q -1_"^"_$zerror
}

/// Desc:       根据审核状态获取相应的文档数据
/// Creator:    zhangxl
/// CreateDate: 2021-9-27
/// Table:      CF.EMR.DOC.TemplateVersion 实例表;CF.EMR.DOC.TemplateCategory 
/// Input:      argArray  	命令参数 {"action":"GET_AUDIT_TEMPLATE","params":{"status":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetAuditTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"	
	s strStatus = argInJson.params.status		
    s strRes = ##Class(EMR.DOC.BL.TemplateAudit).GetAuditTemplateJson(strStatus,.argOutData)
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

/// Desc:      根据审核状态获取相应的文档数据
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      strStatus 为空，表示获取所有的文档数据
///             strStatus 不为空，表示获取strStatus状态下的文档数据
/// OutPut:     返回数据 成功：argOutData
/// Debug:      w ##Class(EMR.DOC.BL.TemplateAudit).GetAuditTemplateJson(strStatus,.argOutData)
ClassMethod GetAuditTemplateJson(strStatus As %String = "", ByRef argOutData As %GlobalBinaryStream)
{
	s jsonArr = ##class(%DynamicArray).%New()
	s strTemID = ""
	for {
		s strTemID = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",strTemID))
		q:(strTemID = "")	
		s strVerNum = ""
		for {
			s strVerNum = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",strTemID,strVerNum))
			q:(strVerNum = "")
			s arowID = ""
			for {
				s arowID = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",strTemID,strVerNum,arowID))
				q:(arowID = "")
				s objTemVersion = ##Class(CF.EMR.DOC.TemplateVersion).%OpenId(arowID)
				if (strStatus) {
					continue:(objTemVersion.Status'= strStatus)
				} else {
					continue:(objTemVersion.Status= "0")
				    continue:(objTemVersion.Status= "1")
			    	continue:(objTemVersion.Status= "5")	
				}
				continue:(objTemVersion = "")
				;continue:(objTemVersion.Status'= strStatus)
				continue:(objTemVersion.Template = "")
				s objTemplate = objTemVersion.Template
				s strTemplateID = objTemVersion.Template.%Id()
				;s objTemplate = ##Class(CF.EMR.DOC.Template).%OpenId(strTemplateID)
				q:(objTemplate = "")
				s jsonItem  = ##class(%DynamicObject).%New()
				s jsonItem.key = arowID
				s jsonItem.name = objTemplate.Name
				continue:(objTemplate.DocumentType = "")
				s objType = objTemplate.DocumentType
				s strType = objTemplate.DocumentType.%Id()
				;s objType = ##Class(CT.EMR.DOC.TemplateTypes).%OpenId(strType)
				s jsonItem.type = objType.Code
				s jsonItem.template = strTemplateID
				s jsonItem.number = $tr(strVerNum," ")
				s jsonItem.Status = objTemVersion.Status
				if ( objTemVersion.Status = "2" ) {
					s jsonItem.audit = "已审核"	
				}
				if ( objTemVersion.Status = "3" ) {
					s jsonItem.audit = "待审核"	
				}
				if ( objTemVersion.Status = "4" ) {
					s jsonItem.audit = "已审核"	
				}
				s TempLastVersion = objTemplate.TempLastVersion
				S objc = objTemplate.TemplateCategory	
				continue:(objc = "")			
				s key = objTemplate.TemplateCategory.%Id()
				s jsonItem.path = objTemplate.Name
				
	 			do
	 			{ 
					s objTemplateCate = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(key)
					q:(objTemplateCate = "")
					s key = objTemplateCate.ParentID
					s jsonItem.path = objTemplateCate.Name _"/"_jsonItem.path
	 			} 
	 			while (key '="0" )
	 			
	 			d jsonArr.%Push(jsonItem)
	 			;s strRes = "1"	 
			   }
		   }
	    }
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       取消文档审核申请
/// Creator:    huhao
/// CreateDate: 2022-8-17
/// Table:		CF.EMR.DOC.TemplateAudit
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod CancelTemplateAudit(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"	
	s id=..GetIDByKey(argInJson.params.id)
	s type=argInJson.params.type
    s strRes = ##Class(EMR.DOC.BL.TemplateAudit).CancelAudit(id,type)
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

ClassMethod CancelAudit(id As %String, type As %String) As %String
{
	q:id="" "-1^版本ID不能为空"
	//取消科室模板版本审核
	if (type="IT")
	{
		;s locObj=##class(CF.EMR.DOC.LocTemplate).%OpenId(id)
		;s locversion=locObj.TempLastVersion
		;s rowid=""
		;s rowid=$o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",id,locversion,rowid))
		s locversionObj=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(id)
		q:locversionObj="" "-1^不存在取消申请的版本信息"
		s locversionObj.Status="1"
		d locversionObj.%Save()
		s strRes="1"

		
	}
	//取消通用模板版本审核
	elseif (type="DT")
	{
		;s docObj=##class(CF.EMR.DOC.Template).%OpenId(id)
		;s docversion=docObj.TempLastVersion
		;s docid=""
		;s docid=$o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",id,docversion,docid))
		s docversionObj=##class(CF.EMR.DOC.TemplateVersion).%OpenId(id)
		q:docversionObj="" "-1^不存在取消申请的版本信息"
		s docversionObj.Status="1"
		d docversionObj.%Save()
		s strRes="1"
	}
	else
	{
		q "-1^请检查文档类型"
	}
	q strRes
}

/// Desc:       获取通用文档审核树
/// Creator:    huhao
/// CreateDate: 2022/8/16
/// Table:		
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetAuditTemplateTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"	
	s UserCode = argInJson.params.userCode
	s DataTypes="TEMPLATE"
	s type="ALL"
	;s type = argInJson.params.type
	;s:type="" type="ALL"
	s state=argInJson.params.status
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.TemplateAudit).GetAuditTemplateTreeJson(state,UserCode,DataTypes,type,roleCode,.argOutData)
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

// 获取文档审核树根目录

ClassMethod GetAuditTemplateTreeJson(state As %String, argUserCode As %String, argDataTypes As %String, argType As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
#;	s userObj = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(userObj="") "-101"
#;	q:(userObj.RoleID="") "-102"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"
	
	s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(roleCode)
	q:(productArray.%Size()=0) "-103"
	s strRes = "1"
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.TemplateCTypes where Code = "Root")
	q:(rootID="") strRes
	set iter = productArray.%GetIterator()
	while iter.%GetNext(.key , .objProduct ) {
		s ProductID = objProduct.%Id()
		// 获取根节点 structType为Root product为ProductID的节点
	    s jsonRoot  = ##class(%DynamicObject).%New()
	    
	    s cateID=""
	    &sql(select ID into :cateID from CF_EMR_DOC.TemplateCategory where Product = :ProductID and StructType = :rootID)
	    continue:(cateID="")
	    s objRoot=##class(CF.EMR.DOC.TemplateCategory).%OpenId(cateID)
        s jsonRoot.key =cateID_"||RT"
        s jsonRoot.title =objRoot.Name
        s jsonRoot.description=objRoot.Description
        s jsonRoot.emrName=objRoot.EMRName
   		s jsonRoot.type = "RT"
		s jsonCategory = ##class(%DynamicArray).%New()
		s DataTypes = $zcvt(argDataTypes,"U")
		d ##Class(EMR.DOC.BL.TemplateAudit).GetJsonCategroyByID(state,cateID,ProductID,RoleID,DataTypes,argType,.jsonCategory)
		s jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

// 获取文档审核树子目录

ClassMethod GetJsonCategroyByID(state As %String, aParentId As %String, aProductID As %String, aRoleID As %String, DataTypes As %String, Type As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemCID = ""
	for {
		//目录ID
		s rowTemCID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxProParentId",aProductID," "_aParentId,rowTemCID))
		q:(rowTemCID = "")		
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(rowTemCID)
	    continue:(objTemCat="")
	    s jsonTemCat  = ##class(%DynamicObject).%New()
	    s productObj = ##class(CT.EMR.DOC.Products).%OpenId(aProductID)
	    //节点类型
	    s objType=##class(CF.EMR.DOC.TemplateCTypes).%OpenId(objTemCat.StructType.%Id())
	    s strType=""
	    if (objType.Code="Classification")
	    {//业务活动记录分类
		    s strType="CT"
		}
		elseif (objType.Code="Record")
		{//业务活动记录
			s strType="LF"
		}
	    elseif (objType.Code="Category")
		{//目录
			s strType="CG"
		}
	    s jsonTemCat.key = rowTemCID_"||"_strType
	    s jsonTemCat.title = objTemCat.Name
	    
	   
	    if (objType.Code="Record")
	    {
		    s jsonTemCat.isMutex=objTemCat.Title.IsMutex
		}
	    
	    s jsonTemCat.emrName=objTemCat.EMRName
	    s jsonTemCat.type = strType
	    s jsonTemCat.description = objTemCat.Description
	    //判断是否有授权数据
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,DataTypes,"CG",rowTemCID)
		continue:(Permission<="0")
		s jsonTemCat.permission = Permission
		;s jsonTemCat.isLeaf = "true"
		;s:(objTemCat.ResChildCount>0) jsonTemCat.isLeaf = "false"
	    s jsonTemCat.sequence = objTemCat.Sequence
	    
		s jsonCateNew = ##class(%DynamicArray).%New()
		//如果子节点为模板则ResChildCount不为0
		if (objTemCat.ResChildCount=0)
		{
			s result = ##Class(EMR.DOC.BL.TemplateAudit).GetJsonCategroyByID(state,rowTemCID,aProductID,aRoleID,DataTypes,Type,.jsonCateNew)
		}
		else
		{	
			//根据目录获取模板数据
			if ((Type="")||(Type="ALL")||(Type="LF")){
				
				s result = ##Class(EMR.DOC.BL.TemplateAudit).GetJsonTempalteByCID(rowTemCID,state,aProductID,aRoleID,DataTypes,Type,.jsonCateNew)
			}
		}
		continue:(jsonCateNew.%Size()=0)
		s:(jsonCateNew.%Size()>0) jsonTemCat.children = jsonCateNew
		d jsonCategory.%Push(jsonTemCat)	
	}
	q res
}

/// Desc:       获取模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.TemplateAudit)GetJsonTempalteByCID(0,1,1,)
ClassMethod GetJsonTempalteByCID(aParentId As %String, state As %String, aProductid As %String, aRoleID As %String, DataTypes As %String, Type As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemID = ""
	for {
		s rowTemID = $o(^CF.EMR.DOC.TemplateI("IdxProCategory",aProductid,aParentId,rowTemID))
		q:(rowTemID = "")				
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(rowTemID)
	    continue:(objTem="")
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s productObj = ##class(CT.EMR.DOC.Products).%OpenId(aProductid)
	    s jsonTem.key = rowTemID_"||DT"
	    s jsonTem.title = objTem.Name
	    s jsonTem.GUID = objTem.GUID
	    s jsonTem.type = "DT"
	    s jsonTem.emrName=objTem.EMRName
	    s jsonTem.description = objTem.Description
	    s jsonTem.chartItemType = objTem.ChartItemType
	    s jsonTem.documentType = objTem.DocumentType.Code
	    s jsonTem.lastVersion = objTem.TempLastVersion
	    
	    s status=""
	    &sql(select Status into status from CF_EMR_DOC.TemplateVersion where Template =:rowTemID and TepmplateVersionNumber =:objTem.TempLastVersion)
	    s jsonTem.lastStatus=status
	    //获取版式信息
	    if (objTem.HFFormat'=""){
			s jsonTem.HFFormat =  objTem.HFFormat.%Id()_"||LF"
			s jsonTem.HFFormatName = objTem.HFFormat.Name    
		}
	    s jsonTem.sequence = rowTemID
	    
	 	//获取版本信息===================================================
		s versionarray = ##Class(EMR.DOC.BL.TemplateAudit).GetTemplateVersionsJson(state,rowTemID)
		s jsonTem.children = versionarray

		//版本信息为空不记录目录开始遍历下一条记录
		continue:versionarray=""
	 	
		d jsonCategory.%Push(jsonTem)	
	}
	q res
}

/// 获取版本信息
ClassMethod GetTemplateVersionsJson(state As %String, tmpId As %String) As %String
{
	s versionarray = ##class(%DynamicArray).%New()
	s flag=""
	q:tmpId="" "-1^模板ID不能为空"
	s tmpObj=##class(CF.EMR.DOC.Template).%OpenId(tmpId)
	s name=tmpObj.Name
	s rowid="",status=""
	if (state="")
	{
		for
		{
			s rowid=$o(^CF.EMR.DOC.TemplateVersionI("IdxTemplate",tmpId,rowid))
			q:rowid=""
			s versionObj=##class(CF.EMR.DOC.TemplateVersion).%OpenId(rowid)
			continue:((versionObj.Status'=2)&&(versionObj.Status'=3))
			s flag="1"
			s obj=##class(%DynamicObject).%New()
			s status=$o(^EMR.DB.DocumentDataI("IdxTemplateVStatus",tmpId,rowid,status))
			s obj.initdata=status
			s obj.type="vs"
			s obj.key=rowid
			s obj.title=name_" V"_versionObj.TepmplateVersionNumber_".0"
			s obj.status=versionObj.Status
			d versionarray.%Push(obj)
		}
	}
	else
	{
		for
		{
			s rowid=$o(^CF.EMR.DOC.TemplateVersionI("IdxTemplate",tmpId,rowid))
			q:rowid=""
			s versionObj=##class(CF.EMR.DOC.TemplateVersion).%OpenId(rowid)
			continue:versionObj.Status'=state
			s flag="1"
			s obj=##class(%DynamicObject).%New()
			s status=$o(^EMR.DB.DocumentDataI("IdxTemplateVStatus",tmpId,rowid,status))
			s obj.initdata=status
			s obj.type="vs"
			s obj.key=rowid
			s obj.title=name_" V"_versionObj.TepmplateVersionNumber_".0"
			s obj.status=versionObj.Status
			d versionarray.%Push(obj)
		}
	}
	if (flag="1")
	{q versionarray}
	else
	{q ""}
}

/// Desc:       取消发布通用接口
/// Creator:    huhao
/// CreateDate: 2023/03/06
/// Table:
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod CancelPublish(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=..GetIDByKey(argInJson.params.id)
	s type=..GetTypeByKey(argInJson.params.id)
	s strRes = ##class(EMR.DOC.BL.TemplateAudit).Cancel(id,type)
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

ClassMethod Cancel(id As %String, type As %String) As %String
{
	s strRes="1"
	q:id="" "-1^id不能为空"
	q:type="" "-1^类型不能为空"
	TSTART 
	if (type="DT")
	{
		s obj=##class(CF.EMR.DOC.TemplateVersion).%OpenId(id)
		q:obj="" "-1^模板版本不存在"
		s obj.Status="1"
		if ('obj.%Save())
		{
			s strRes="-1"
		}
		s tmpObj=obj.Template
		s VersionId=$o(^CF.EMR.DOC.TemplateVersionI("IdxTemplate",obj.Template.%Id(),id),-1)
		s:VersionId="" VersionId=0
		s tmpObj.TempPublishVersion=VersionId
		if ('tmpObj.%Save())
		{
			s strRes="-1"
		}
		
	}
	elseif (type="IT")
	{
		s obj=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(id)
		q:obj="" "-1^科室模板版本不存在"
		s obj.Status="1"
		if ('obj.%Save())
		{
			s strRes="-1"
		}
		s LoctmpObj=obj.Template
		s VersionId=$o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateId",obj.Template.%Id(),id),-1)
		s:VersionId="" VersionId=0
		s LoctmpObj.TempPublishVersion=VersionId
		if ('LoctmpObj.%Save())
		{
			s strRes="-1"
		}
	}
	else
	{
		s strRes="-1^类型有误"
	}
	if (strRes'="1")
	{
		TROLLBACK
		q "-1^取消发布失败"
	}
	else
	{
		TCOMMIT
		q strRes
	}
}

}
