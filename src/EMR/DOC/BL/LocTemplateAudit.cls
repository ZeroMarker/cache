/// 名称:EMR.DOC.BL.LocTemplateAudit
/// 描述:通用文档管理模块 Document(Doc) 科室文档审核
/// 编写者：zhangxl
/// 编写日期: 2020-07-08
/// 产品组：电子病历产品组
Class EMR.DOC.BL.LocTemplateAudit Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取所有科室数据列表
/// Creator:    zhangxl
/// CreateDate: 2021-8-3
/// Input:      argArray  	命令参数 {"action":"GET_ALL_LOCDATA","params":"","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 
ClassMethod GetAllLocData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.LocTemplateAudit).GetAllLocDataJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取所有科室数据列表
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##Class(EMR.DOC.BL.TextKBLoc).GetAllLocJson(.argOutData)
ClassMethod GetAllLocDataJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s strRes = ""
	s jsonArr = ##class(%DynamicArray).%New()
	
	s strRes = ""
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.TextKBLoc:SelectAllLoc")
	d result.Execute()
	While result.Next() 
	{
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.id =result.GetDataByName("RowId")
     	s jsonItem.key =result.GetDataByName("Des")
     	s jsonItem.Code =result.GetDataByName("Code")
     	s jsonItem.value =result.GetDataByName("Des")
     	s jsonItem.title =result.GetDataByName("Des")
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取所有科室数据
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTextKBConfig","SelectAllLoc")
Query SelectAllLoc() As %SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%String,Code:%String,Des:%String")
{
	SELECT CTLOC_RowId,CTLOC_CODE,upper(CTLOC_Desc) From SQLUser.CT_Loc Where CTLOC_Type='E' or CTLOC_Type='OP' or CTLOC_Type='OR' or CTLOC_Type='EM'  Order By CTLOC_Desc,CTLOC_RowId
}

/// Desc:       科室文档审核(包括审核成功与不成功)
/// Creator:    zhangxl
/// CreateDate: 2021-9-16
/// Table:      CF.EMR.DOC.LocTemplateVersion 实例表
/// Input:      argArray  	命令参数 {"action":"AUDIT_LOCTEMPLATE","params":{"templateIds":"259^262","status":"1","remark":"approve"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AuditLocTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Status = argInJson.params.status	 //使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
	s Remark = argInJson.params.remark
	s IDStr = argInJson.params.templateIds	
    s strRes = ##Class(EMR.DOC.BL.LocTemplateAudit).AuditLocTemplateJson(Status,Remark,IDStr)
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

/// Desc:      审核科室文档
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      IDStr   文档id
///             Status  审核状态
///             Remark  审核不通过意见
/// OutPut:     返回数据 成功
/// Debug:      w ##Class(EMR.DOC.BL.LocTemplateAudit).AuditLocTemplateJson(Status,Remark,IDStr)
ClassMethod AuditLocTemplateJson(Status As %String, Remark As %String, IDStr As %String)
{
	
	s $zt = "OPError"
	s Result = "-1"
	q:($g(IDStr) = "") Result
	S IDCount =$L(IDStr,"^")
	TSTART 
	For I=1:1:IDCount+1
	{
		s TemplateID = $P($p(IDStr,"^",I),"||",1)
		;continue:(TemplateID="")
		;s rowId = $o(^CF.EMR.DOC.TemplateAuditI("IdxTemplateVersion",TemplateID,""))
		s obj = ##Class(CF.EMR.DOC.LocTemplateVersion).%OpenId(TemplateID)
		q:(obj = "")
		s obj.Status =Status
		if '(obj.%Save())
		{
			s Result = 0
			q 
		}
		s LocObj=obj.Template
		if (Status=2)
		{		
			s LocObj.TempPublishVersion=obj.%Id()
		}
		s sc= LocObj.%Save()
		if ($$$ISERR(sc))
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
OPError
    Trollback
    q -1_"^"_$zerror
}

/// Desc:      审核科室文档
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      IDStr   文档id
///             Status  审核状态
///             Remark  审核不通过意见
/// OutPut:     返回数据 成功
/// Debug:      w ##Class(EMR.DOC.BL.LocTemplateAudit).AuditLocTemplateJsonp(Status,Remark,IDStr)
ClassMethod AuditLocTemplateJsonp(Status As %String, Remark As %String, IDStr As %String)
{
	s $zt = "OPError"
	s Result = "-1"
	q:($g(IDStr) = "") Result
	S IDCount =$L(IDStr,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s TemplateID = $p(IDStr,"^",I)
		;continue:(TemplateID="")
		;s rowId = $o(^CF.EMR.DOC.TemplateAuditI("IdxTemplateVersion",TemplateID,""))
		s obj = ##Class(CF.EMR.DOC.LocTemplateVersion).%OpenId(TemplateID)
		q:(obj = "")
		s obj.Status =Status
		if '(obj.%Save())
		{
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
OPError
    Trollback
    q -1_"^"_$zerror
}

/// Desc:       根据审核状态获取相应的科室文档数据
/// Creator:    zhangxl
/// CreateDate: 2021-9-27
/// Table:      CF.EMR.DOC.LocTemplateVersion 实例表;CF.EMR.DOC.TemplateCategory 
/// Input:      argArray  	命令参数 {"action":"GET_AUDIT_LOCTEMPLATE","params":{"status":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetAuditLocTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"	
	s strStatus = argInJson.params.status		
    s strRes = ##Class(EMR.DOC.BL.LocTemplateAudit).GetAuditLocTemplateJson(strStatus,.argOutData)
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
/// Input:      strStatus 
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.TextKBContent).GetAuditKBContentJson(Status,.argOutData)
ClassMethod GetAuditLocTemplateJson(strStatus As %String = "", ByRef argOutData As %GlobalBinaryStream)
{
	s jsonArr = ##class(%DynamicArray).%New()
	s strTemID = ""
	for {
		s strTemID = $o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",strTemID))
		q:(strTemID = "")	
		s strVerNum = ""
		for {
			s strVerNum = $o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",strTemID,strVerNum))
			q:(strVerNum = "")
			s arowID = ""
			for {
				s arowID = $o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",strTemID,strVerNum,arowID))
				q:(arowID = "")
				s objTemVersion = ##Class(CF.EMR.DOC.LocTemplateVersion).%OpenId(arowID)
				if (strStatus) {
					continue:(objTemVersion.Status'= strStatus)
				} else {
					continue:(objTemVersion.Status= "0")
				    continue:(objTemVersion.Status= "1")
			    	continue:(objTemVersion.Status= "5")	
				}
				continue:(objTemVersion = "")
				continue:(objTemVersion.Template = "")
				s strLocTemplateID = objTemVersion.Template.%Id()
				s objLocTemplate = ##Class(CF.EMR.DOC.LocTemplate).%OpenId(strLocTemplateID)
				q:(objLocTemplate = "")
				s jsonItem  = ##class(%DynamicObject).%New()
				s jsonItem.key = arowID
				s jsonItem.name = objLocTemplate.Name
				s jsonItem.status = objTemVersion.Status
				if ( objTemVersion.Status = "2" ) {
					s jsonItem.audit = "已审核"	
				}
				if ( objTemVersion.Status = "3" ) {
					s jsonItem.audit = "待审核"	
				}
				if ( objTemVersion.Status = "4" ) {
					s jsonItem.audit = "已审核"	
				}
				continue:(objLocTemplate.TemplateID = "")
				s templateID = objLocTemplate.TemplateID.%Id()
				s jsonItem.templateID = templateID
				s jsonItem.LocTemplateID = strLocTemplateID
				s ruleID = ""
				s ruleID = $o(^CF.EMR.DOC.LocTemplateRulesI("TemplateIDIdx",templateID,""))
				
				if (ruleID = "")
          		{
          			s jsonItem.loc = ""
     			 }
  				  else
     			 {
         			 s objTemplateRules = ##Class(CF.EMR.DOC.LocTemplateRules).%OpenId(ruleID)
         			 continue:(objTemplateRules = "")
				     s jsonItem.loc = objTemplateRules.RuleItemDesc
         			 
      			}

				s objTemplate = ##Class(CF.EMR.DOC.Template).%OpenId(templateID)
				q:(objTemplate = "")
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
			   }
		   }
	    }
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取所有科室文档审核数据
/// Creator:    zhangxl
/// CreateDate: 2021-9-27
/// Input:      argArray  	命令参数 {"action":"GET_ALL_LOCTEMPLATE","params":{},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetAllLocTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"			
    s strRes = ##Class(EMR.DOC.BL.LocTemplateAudit).GetAllLocTemplateJson(.argOutData)
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

/// Desc:       获取所有文档审核数据
/// Creator:   zhangxl
/// CreateDate:2021-9-17
/// Input:      strStatus 
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空
/// Debug:    
ClassMethod GetAllLocTemplateJson(ByRef argOutData As %GlobalBinaryStream)
{
	s jsonArr = ##class(%DynamicArray).%New()
	s strTemID = ""
	for {
		s strTemID = $o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",strTemID))
		q:(strTemID = "")	
		s strVerNum = ""
		for {
			s strVerNum = $o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",strTemID,strVerNum))
			q:(strVerNum = "")
			s arowID = ""
			for {
				s arowID = $o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",strTemID,strVerNum,arowID))
				q:(arowID = "")
				s objTemVersion = ##Class(CF.EMR.DOC.LocTemplateVersion).%OpenId(arowID)
				continue:(objTemVersion = "")
				continue:(objTemVersion.Status = "0") 
				continue:(objTemVersion.Status = "1") 
				continue:(objTemVersion.Status = "5") 
				continue:(objTemVersion.Template = "")
				s strLocTemplateID = objTemVersion.Template.%Id()
				s objLocTemplate = ##Class(CF.EMR.DOC.LocTemplate).%OpenId(strLocTemplateID)
				q:(objLocTemplate = "")
				s jsonItem  = ##class(%DynamicObject).%New()
				s jsonItem.key = arowID
				s jsonItem.name = objLocTemplate.Name
				s jsonItem.status = objTemVersion.Status
				if ( objTemVersion.Status = "2" ) {
					s jsonItem.audit = "已审核"	
				}
				if ( objTemVersion.Status = "3" ) {
					s jsonItem.audit = "待审核"	
				}
				if ( objTemVersion.Status = "4" ) {
					s jsonItem.audit = "已审核"	
				}
				;s jsonItem.createDate = $zcvt(objTemVersion.EffectiveDate,"U")
				continue:(objLocTemplate.TemplateID = "")
				s templateID = objLocTemplate.TemplateID.%Id()
				s jsonItem.templateID = templateID
				s jsonItem.LocTemplateID = strLocTemplateID
				s ruleID = ""
				s ruleID = $o(^CF.EMR.DOC.LocTemplateRulesI("TemplateIDIdx",templateID,""))
				
				if (ruleID = "")
          		{
          			s jsonItem.loc = ""
     			 }
  				  else
     			 {
         			 s objTemplateRules = ##Class(CF.EMR.DOC.LocTemplateRules).%OpenId(ruleID)
         			 continue:(objTemplateRules = "")
				     s jsonItem.loc = objTemplateRules.RuleItemDesc
         			 
      			}

				s objTemplate = ##Class(CF.EMR.DOC.Template).%OpenId(templateID)
				q:(objTemplate = "")
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
			   }
		   }
	    }
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取科室文档审核树
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
	s state=argInJson.params.status
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.LocTemplateAudit).GetAuditTemplateTreeJson(UserCode,DataTypes,state,roleCode,.argOutData)
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

ClassMethod GetAuditTemplateTreeJson(argUserCode As %String, argDataTypes As %String, state As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
#;	s userObj = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(userObj="") "-101"
#;	q:(userObj.RoleID="") "-102"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"
	
	s RoleID = RoleID
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
		d ##Class(EMR.DOC.BL.LocTemplateAudit).GetJsonCategroyByID(cateID,ProductID,RoleID,DataTypes,state,.jsonCategory)
		s jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

// 获取文档审核树子目录

ClassMethod GetJsonCategroyByID(aParentId As %String, aProductID As %String, aRoleID As %String, DataTypes As %String, state As %String, ByRef jsonCategory As %DynamicArray) As %String
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
			s result = ##Class(EMR.DOC.BL.LocTemplateAudit).GetJsonCategroyByID(rowTemCID,aProductID,aRoleID,DataTypes,state,.jsonCateNew)
		}
		else
		{	
				
			s result = ##Class(EMR.DOC.BL.LocTemplateAudit).GetJsonTempalteByCID(rowTemCID,aProductID,state,.jsonCateNew)
		}
		
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
/// Output:     q ##Class(EMR.DOC.BL.Template).GetJsonTempalteByCIwD(0,1,1,)
ClassMethod GetJsonTempalteByCID(aParentId As %String, aProductid As %String, state As %String, ByRef jsonCategory As %DynamicArray) As %String
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
	    
	 	
	 	s categoryArr = ##class(%DynamicArray).%New()
		d ##Class(EMR.DOC.BL.LocTemplateAudit).getCategoryByTemplateID(rowTemID,state,.categoryArr)
		s jsonTem.children = categoryArr
	 	
		d jsonCategory.%Push(jsonTem)	
	}
	q res
}

// 获取科室文档目录

ClassMethod getCategoryByTemplateID(templateID As %String, state As %String, category As %DynamicArray) As %String
{
	// 未传入ID
	s res="-101"
	q:(templateID="") res
	s res="-102"
	s count=""
	&sql(select count(*) into :count from CF_EMR_DOC.Template where ID=:templateID)
	q:(count=0) res	
	s result=##class(%ResultSet).%New("EMR.DOC.BL.LocTemplateCategory:GetCategoryDataByTemplateID")
	d result.Execute(templateID)
	While result.Next() 
	{
		s jsonItem = ##class(%DynamicObject).%New()
		s rowID=result.GetDataByName("ID")
     	s jsonItem.key =rowID_"||LC"
     	s jsonItem.type="LC"
     	s childCount=result.GetDataByName("ResChildCount")
     	S jsonItem.description=result.GetDataByName("Description")
     	
     	
     	s jsonItem.title=result.GetDataByName("Name")
     	s jsonItem.emrName=result.GetDataByName("EMRName")
     	
     	s jsonCategory = ##class(%DynamicArray).%New()
    	if (childCount=0)
    	{
	    		
			d ##Class(EMR.DOC.BL.LocTemplateAudit).getCategoryByTemplateID(rowID,state,.jsonCategory)
			
		}else
		{
			// 获取模板节点
			d ##Class(EMR.DOC.BL.LocTemplateAudit).GetJsonTemplateByID(rowID,state,.jsonCategory)
			
		}
			s:(jsonCategory.%Size()>0) jsonItem.children = jsonCategory
		
		
		// 除去子节点
     	s parentID =result.GetDataByName("ParentID") 
     	continue:(parentID'="")
     	d category.%Push(jsonItem)
	}
	
	// 没有目录子节点 获取模板数据
	;if (category.%Size()=0)
	;{
		s resultTem=##class(%ResultSet).%New("EMR.DOC.BL.LocTemplateCategory:GetTemplateDataByTemplateID")
		d resultTem.Execute(templateID)
		
		While resultTem.Next() 
		{
			s jsonItem = ##class(%DynamicObject).%New()
			s rowID=resultTem.GetDataByName("ID")
			s objLocTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(rowID)
			s jsonItem.key =rowID_"||IT"
     		s jsonItem.type="IT"
     		s parent=resultTem.GetDataByName("LocTemplateCategory")
     		
     		S jsonItem.description=resultTem.GetDataByName("Description")
     		s jsonItem.title=resultTem.GetDataByName("Name")
     		s jsonItem.template=objLocTem.TemplateID.%Id()_"||DT"
     		
     		s jsonItem.emrName=resultTem.GetDataByName("EMRName")
     		s jsonItem.disease=resultTem.GetDataByName("Disease")
     		s versionNumber=resultTem.GetDataByName("TempLastVersion")
     		s status=""
			&sql(select Status into :status from CF_EMR_DOC.LocTemplateVersion where TepmplateVersionNumber = :versionNumber and Template =:rowID)
			s jsonItem.lastStatus=status
			s arr=##class(%DynamicArray).%New()
			d ##class(EMR.DOC.BL.LocTemplateAudit).GetLocTemplateVersion(rowID,state,templateID,.arr)
			s jsonItem.children=arr
			continue:(parent'="")
     		d category.%Push(jsonItem)
		}
	;}
	;d category.%Push(jsonArr)
	;d jsonArr.%ToJSON(argOutData)
	q "1"
}

// 获取科室模板

ClassMethod GetJsonTemplateByID(aParentId As %String, state As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	q:(aParentId="") 
	
	s rowID="",seq=""
	for 
	{
		s seq=$o(^CF.EMR.DOC.LocTemplateI("IdxSortCatSeq",aParentId,seq))
		q:seq=""
		for
		{
		s rowID = $o(^CF.EMR.DOC.LocTemplateI("IdxSortCatSeq",aParentId,seq,rowID))
		q:(rowID="")
		s objtem=##class(CF.EMR.DOC.LocTemplate).%OpenId(rowID)
		
		s jsonItem = ##class(%DynamicObject).%New()
			s jsonItem.key =rowID_"||IT"
     		s jsonItem.type="IT"
     		s jsonItem.description=objtem.Description
     		s jsonItem.title=objtem.Name
     		s jsonItem.template=objtem.TemplateID.%Id()_"||DT"
     		s jsonItem.emrName=objtem.EMRName
     		 if (objtem.Disease'="")
				{
					s jsonItem.disease=objtem.Disease.%Id()_"||D"
				}
				else
				{
					s jsonItem.disease=""
				}
     		s versionNumber=objtem.TempLastVersion
     		s status=""
			&sql(select Status into :status from CF_EMR_DOC.LocTemplateVersion where TepmplateVersionNumber = :versionNumber and Template =:rowID)
			s jsonItem.lastStatus=status
			s locversion=##class(%DynamicArray).%New()
			s strRes=##class(EMR.DOC.BL.LocTemplateAudit).GetLocTemplateVersion(rowID,state,jsonItem.template,.locversion)
			if (strRes="1")
			{
				s jsonItem.children=locversion
			}
			d jsonCategory.%Push(jsonItem)
		}
	}
	
	q "1"
}

// 获取科室模板版本

ClassMethod GetLocTemplateVersion(templateId As %String, state As %String, ParentTmpId As %String, ByRef LocVersion As %DynamicArray) As %String
{
	q:templateId="" ""
	s rowId="",res="",versionId=""
	for
	{
		s resobj=##class(%DynamicObject).%New()
		s versionId=$o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",templateId,versionId))
		q:versionId=""
		for
		{
			s rowId=$o(^CF.EMR.DOC.LocTemplateVersionI("IdxTemplateVersion",templateId,versionId,rowId))
			q:rowId=""
			s obj=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(rowId)
			continue:(((obj.Status'="2")||(obj.Template=""))&&(obj.Status'="3"))
			IF (state'="")
			{
				continue:obj.Status'=state
			}
			s resobj.key=rowId
			;s resobj.key=rowId_"||IT"
			s resobj.title=##class(CF.EMR.DOC.LocTemplate).%OpenId(templateId).Name_" V"_obj.TepmplateVersionNumber_".0"
			s resobj.type="LOC"
			s resobj.Template=ParentTmpId
			s resobj.Status=obj.Status
			d LocVersion.%Push(resobj)
			s res="1"
		}
	}
	q res
}

}
