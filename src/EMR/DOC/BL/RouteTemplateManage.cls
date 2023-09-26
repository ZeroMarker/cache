/// 名称:	EMR.DOC.BL.RouteTemplateManage
/// 描述:	通用文档管理模块 Document(Doc) 通用文档管理逻辑类（NEW）
/// 编写者:	zhanzgheyi
/// 编写日期: 	2020-12-16
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RouteTemplateManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据用户获取菜单权限
/// Creator:    zhangzheyi
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
	q:((roleCode="")||(argParentCode="")) strRes
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"
    s strRoleID =RoleID
	s seq = ""
	s strRes = "-301"
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",argParentCode,seq))
		q:(seq = "")	
		s rowID = ""		
			for {
				s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",argParentCode,seq,rowID))
				q:(rowID = "")		
				
				s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
		        continue:(obj="") 
		        s strRes = "1"	
		        s jsonMenuDoc  = ##class(%DynamicObject).%New()
		       	
		       	
		        s jsonMenuDoc.name =obj.FuncName
		        s jsonMenuDoc.icon =obj.Icon
		        s jsonMenuDoc.path = obj.Path
		        s jsonMenuDoc.component = obj.Component
		        s jsonMenuDoc.Code=obj.FuncCode
		        s jsonMenuDoc.Type=obj.Type.Code
		        s jsonMenuDoc.Perms=obj.Perms
		        s jsonMenuDoc.ParentId=obj.ParentID
		        
		        s key =obj.%Id()
				
				//添加操作授权数据
				if (roleCode '="SuperAdmin"){
					/*非超级管理员权限校验*/
					s Permission =##Class(EMR.DOC.BL.RBACOperPermission).GetRoutingOperPermission(strRoleID,rowID)
					continue:(Permission="1")
				}
				s arrItem = ##class(%DynamicArray).%New()
				s result =  ##Class(EMR.DOC.BL.RouteTemplateManage).GetEMRSystemMenuJson(argUserCode,key,roleCode,.arrItem)
				if (arrItem.%Size() >0) {
					s jsonMenuDoc.routes = arrItem
				}
					
				d jsonArr.%Push(jsonMenuDoc)
			}
	}
	q strRes
}

/// Desc:   获取菜单列表
/// Creator:    zhanzgheyi
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     1 获取数据成功
/// Debug:     
ClassMethod GetChildrenMenuJson(ParentId As %Integer, ByRef jsonArr As %DynamicArray) As %String
{
	
	s strRes = "101"
	s seq = ""
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for {
			s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
	        continue:(obj="") 	
	        s strRes = "1"
	        
	        s jsonMenuDoc  = ##class(%DynamicObject).%New()
	        s jsonMenuDoc.key =obj.%Id()
	        s jsonMenuDoc.name =obj.MenuName
		    s jsonMenuDoc.icon =obj.Icon
		    s jsonMenuDoc.path = obj.Path
		    s jsonMenuDoc.component = obj.Component
	        
	        s arrItem = ##class(%DynamicArray).%New()
			s list = ..GetChildrenMenuJson(jsonMenuDoc.key,.arrItem)
		    if (list '= "101") {
			    s jsonMenuDoc.routes = list
			 }
			 	
			d jsonArr.%Push(jsonMenuDoc)
		}
	}
	q:(jsonArr.%Size()'>0) strRes
}

}
