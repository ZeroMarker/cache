/// 名称:	EMR.DOC.BL.TemplateManage
/// 描述:	通用文档管理模块 Document(Doc) 通用文档管理逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-16
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.TemplateManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       文档目录管理模块统一添加接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"ADD_DOC_TEMPLATE","params":{"id":"173||CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Add(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	// 父节点id 类型
	s type = ..GetTypeByKey(argInJson.params.id)
	;s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	s childType = argInJson.params.childType
	
	
	// 如果节点类型不是DT（文档），那么都是新增目录项目
	
	if (childType'="DT")
	{
		
		d ##Class(EMR.DOC.BL.TemplateCategory).AddTemplateCategory(argInJson,argInData,argOutMessage,argOutData)

	}
#;	// 新增目录
#;	if ((type="RT")||((type="CG")&&(childType="CG")))
#;	{
#;		d ##Class(EMR.DOC.BL.TemplateCategory).AddTemplateCategory(argInJson,argInData,argOutMessage,argOutData)
#;	}
	// 新增文档
	else
	{
		d ##Class(EMR.DOC.BL.Template).AddTemplate(argInJson,argInData,argOutMessage,argOutData)
	}
#;	// 新增版本
#;	elseif(type="LF")
#;	{
#;		d ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion(argInJson,argInData,argOutMessage,argOutData)
#;	}
	q "1"
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       文档目录管理模块统一更新接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"UPDATE_DOC_TEMPLATE","params":{"id":"173||CG"...},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Update(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	;s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type'="DT")
	{
		d ##Class(EMR.DOC.BL.TemplateCategory).UpTemplateCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		d ##Class(EMR.DOC.BL.Template).UpTemplate(argInJson,argInData,argOutMessage,argOutData)
	}
#;	else
#;	{
#;		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
#;	}
	q "1"
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       文档目录管理模块统一删除接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"DELETE_DOC_TEMPLATE","params":{"id":"173||CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Delete(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="IT")
	{
		d ##Class(EMR.DOC.BL.TemplateVersion).DelTemplateVersion(argInJson,argInData,argOutMessage,argOutData)
	} elseif (type="DT")
	{
		d ##Class(EMR.DOC.BL.Template).DelTemplate(argInJson,argInData,argOutMessage,argOutData)
		
	}
	
	else
	{
		d ##Class(EMR.DOC.BL.TemplateCategory).DelTemplateCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	
#;	else
#;	{
#;		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
#;	}
	q "1"
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据用户获取菜单权限
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_EMRSYSTEM_MENU","args":{"UserCode":"YS01"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetEMRSystemMenu(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
	s jArrMeun = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.TemplateManage).GetEMRSystemMenuJson(UserCode,"MENU",roleCode,.jArrMeun)
    d jArrMeun.%ToJSON(argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage
	}elseif(strRes="-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}elseif(strRes="-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色,没有权限",2)
	}elseif(strRes="-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","用户Code未传",2)
	}elseif(strRes="-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","菜单数据为空，检查数据源",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误00",2)
	}
Error
	 q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取文档管理模块tab页签
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_MENU_DOC","args":{"ParentCode":"Menu_Doc","UserCode":"YS01"}},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetMenuDoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s ParentCode = argInJson.params.parentCode
    s strRes = ##Class(EMR.DOC.BL.TemplateManage).GetMenuDocJson(UserCode,ParentCode,.argOutData)
	if (strRes = "1")
	{ 
	   q ..SetOutMessage(argOutMessage,"OK")
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","该用户无通用文档管理功能授权",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据用户获取菜单权限
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     1 获取数据成功
///  			-101 用户不存在 -102 用户没有维护角色
/// 			-200 入参为空  				
///            -301 没有菜单数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			s jArrMeun = ##class(%DynamicArray).%New()
///             w ##class(EMR.DOC.BL.TemplateManage).GetEMRSystemMenuJson("YS01","MENU",jArrMeun)
/// 			d jArrMeun.%ToJSON(argOutData)
ClassMethod GetEMRSystemMenuJson(argUserCode As %String, argParentCode As %String, roleCode As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "-200"
	q:((argUserCode="")||(argParentCode="")) strRes
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"
    s strRoleID = RoleID
	s rowID = ""
	s strRes = "-301"
	for {
		s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(argParentCode,"U"),rowID))
		q:(rowID = "")		
		
		s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
        continue:(obj="")
        s strRes = "1"	
        s jsonMenuDoc  = ##class(%DynamicObject).%New()
        s jsonMenuDoc.key =obj.FuncCode
        s jsonMenuDoc.name =obj.FuncName
        s jsonMenuDoc.type =obj.Type.Code
        s jsonMenuDoc.parentCode = obj.ParentCode
        s jsonMenuDoc.parentId = obj.ParentID
        s jsonMenuDoc.sequence = obj.Sequence
		
		//添加操作授权数据
		if (roleCode '="SuperAdmin"){
			/*非超级管理员权限校验*/
			s Permission =##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowID)
			continue:(Permission="1")
		}
		if (obj.Type.Code="funcGroup")
		{
			s arrItem = ##class(%DynamicArray).%New()
			s result =  ##Class(EMR.DOC.BL.TemplateManage).GetEMRSystemMenuJson(argUserCode,obj.FuncCode,roleCode,.arrItem)
			s jsonMenuDoc.item =arrItem
		}
		d jsonArr.%Push(jsonMenuDoc)
	}
	q strRes
}

/// Desc:      
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.TemplateManage).GetMenuDocJson("YS01","Menu_Doc",argOutData)
ClassMethod GetMenuDocJson(argUserCode As %String, argParentCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArr = ##class(%DynamicArray).%New()
	
	s rowID = ""
	for {
		s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(argParentCode,"U"),rowID))
		q:(rowID = "")				
		s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
        continue:(obj="")
        s jsonMenuDoc  = ##class(%DynamicObject).%New()
        s jsonMenuDoc.key =obj.FuncCode
        s jsonMenuDoc.name =obj.FuncName
        s jsonMenuDoc.sequence = obj.Sequence
      	s strRowID = $o(^CF.EMR.DOC.RBACUserI("IdxUser"," "_$zcvt(argUserCode,"U"),""))
		q:(strRowID="")
		s strRes = "1"
		s objUser = ##Class(CF.EMR.DOC.RBACUser).%OpenId(strRowID)
        continue:(objUser="")
        s strRoleID = objUser.RoleID.%Id()
		//添加操作授权数据
		s jsonArrOperPermission = ##class(%DynamicArray).%New()
		if (objUser.IsAdmin="0"){
			s Permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowID)
			continue:(Permission="1")
		}
		d jsonArr.%Push(jsonMenuDoc)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

/// Desc:      文档目录排序，节点模板排序 
/// Creator:    huhao
/// CreateDate: 2022-7-12
/// Table:		CF.EMR.DOC.TemplateCategory
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod SortCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=..GetIDByKey(argInJson.params.id)
	s type=..GetTypeByKey(argInJson.params.id)
	s operation=argInJson.params.operation
   	s strRes = ##class(EMR.DOC.BL.TemplateManage).sort(id,type,operation,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","顺序变更失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod sort(id As %String, type As %String, operation As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	if ((type="LF")||(type="CG")||(type="CT"))
	{
		if (operation="mi_up")
		{
			s rowId=id
			s obj=##class(CF.EMR.DOC.TemplateCategory).%OpenId(id)
			s parentId=obj.ParentID
			s product=obj.Product.%Id()
			s oldsequence=obj.Sequence,a=obj.Sequence
			for
			{
				s ProductId="",NrowId=""
				s oldsequence=$o(^CF.EMR.DOC.TemplateCategoryI("IdxPidSeq"," "_parentId,oldsequence),-1)
				q:oldsequence=""
				s NrowId=$o(^CF.EMR.DOC.TemplateCategoryI("IdxPidSeq"," "_parentId,oldsequence,NrowId))
				&sql(select Product into ProductId from CF_EMR_DOC.TemplateCategory where ID=:NrowId)
				s sobj=##class(CT.EMR.DOC.Products).%OpenId(ProductId)
				q:((sobj'="")&&(oldsequence'=""))
			}
			s getObj=##class(CF.EMR.DOC.TemplateCategory).%OpenId(NrowId)
			q:getObj="" "-1^已为最上层无法上移"
			s newsequence=getObj.Sequence
			s obj.Sequence=newsequence
			s getObj.Sequence=a
			d obj.%Save()
			d getObj.%Save()
			s strRes="1"
		}
		elseif (operation="mi_down")
		{
			s rowId=id
			s obj=##class(CF.EMR.DOC.TemplateCategory).%OpenId(id)
			s parentId=obj.ParentID
			s product=obj.Product.%Id()
			s oldsequence=obj.Sequence,a=obj.Sequence
			for
			{
				s ProductId="",NrowId=""
				s oldsequence=$o(^CF.EMR.DOC.TemplateCategoryI("IdxPidSeq"," "_parentId,oldsequence))
				q:oldsequence=""
				s NrowId=$o(^CF.EMR.DOC.TemplateCategoryI("IdxPidSeq"," "_parentId,oldsequence,NrowId))
				&sql(select Product into ProductId from CF_EMR_DOC.TemplateCategory where ID=:NrowId)
				s sobj=##class(CT.EMR.DOC.Products).%OpenId(ProductId)
				q:((sobj'="")&&(oldsequence'=""))
			}
			s getObj=##class(CF.EMR.DOC.TemplateCategory).%OpenId(NrowId)
			q:getObj="" "-1^已为最下层无法下移"
			s newsequence=getObj.Sequence
			s obj.Sequence=newsequence
			s getObj.Sequence=a
			d obj.%Save()
			d getObj.%Save()
			s strRes="1"
		}
		else
		{
			q "-1^未检测到相关操作参数"
		}
	}
	elseif((type="DT"))
	{
		if (operation="mi_up")
		{
			s rowid=id
			s sobj=##class(CF.EMR.DOC.Template).%OpenId(id)
			s tempcg=sobj.TemplateCategory.%Id()
			s tempprt=sobj.Product.%Id()
			s oSequence=sobj.Sequence,aSeq=sobj.Sequence,bSeq=sobj.Sequence
			s bSeq=$o(^CF.EMR.DOC.TemplateI("IdxProCatSeq",tempprt,tempcg,bSeq),-1)
			q:bSeq="" "-1^无法上移"
			s sId=""
			s sId=$o(^CF.EMR.DOC.TemplateI("IdxProCatSeq",tempprt,tempcg,bSeq,sId))
			s nobj=##class(CF.EMR.DOC.Template).%OpenId(sId)
			s sobj.Sequence=nobj.Sequence
			s nobj.Sequence=aSeq
			d sobj.%Save()
			d nobj.%Save()
			s strRes="1"
		}
		elseif (operation="mi_down")
		{
			s rowid=id
			s sobj=##class(CF.EMR.DOC.Template).%OpenId(id)
			s tempcg=sobj.TemplateCategory.%Id()
			s tempprt=sobj.Product.%Id()
			s oSequence=sobj.Sequence,aSeq=sobj.Sequence,bSeq=sobj.Sequence
			s bSeq=$o(^CF.EMR.DOC.TemplateI("IdxProCatSeq",tempprt,tempcg,bSeq))
			q:bSeq="" "-1^无法下移"
			s sId=""
			s sId=$o(^CF.EMR.DOC.TemplateI("IdxProCatSeq",tempprt,tempcg,bSeq,sId))
			s nobj=##class(CF.EMR.DOC.Template).%OpenId(sId)
			s sobj.Sequence=nobj.Sequence
			s nobj.Sequence=aSeq
			d sobj.%Save()
			d nobj.%Save()
			s strRes="1"
		}
		else
		{
			q "-1^未检测到相关操作参数"
		}
	}
	
	q strRes
}

}
