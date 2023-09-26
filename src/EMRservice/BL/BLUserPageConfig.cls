Class EMRservice.BL.BLUserPageConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		获取住院病历-导航页面病历目录视图显示数据
/// Creator:	Lina
/// CreateDate:	2016-12-26
/// OutPut:		json格式的病历目录视图显示数据
/// Debug: 		w ##Class(EMRservice.BL.BLUserPageConfig).GetViewDisplayData()
ClassMethod GetViewDisplayData() As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s ViewDisplayType =""
	for
	{
		s ViewDisplayType = $o(^DHCEMRM.CategoryViewDisplayI("IdxViewDisplayType"," "_ViewDisplayType))
		q:(ViewDisplayType = "")
		s ViewDisplayType = $tr(ViewDisplayType," ","")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.CategoryViewDisplayI("IdxViewDisplayType"," "_ViewDisplayType,rowId))
			q:(rowId = "")
			s objView = ##class(EMRmeta.CategoryViewDisplay).%OpenId(rowId)
			q:(objView = "")
			d:(json.Size '= 0) json.Write(",")
			d json.Write("{")
			d json.Write("""value"":"""_objView.ViewDisplayId_"""")
			d json.Write(",""name"":"""_objView.ViewDisplayDesc_"""")
			d json.Write("}")
		}
	}
	q json
}

/// Desc:		获取住院病历-导航页面病历目录的视图显示配置
/// Creator:	Lina
/// CreateDate:	2016-12-22
/// InPut:		AUserID 用户ID
/// 			AUserLocID 用户科室ID
/// OutPut:		viewDisplayValue 视图显示值
/// Debug: 		w ##Class(EMRservice.BL.BLUserPageConfig).GetViewDisplayConfig("359","6")
ClassMethod GetViewDisplayConfig(AUserID As %String, AUserLocID As %String) As %String
{
	s viewDisplayValue = ""
	q:(AUserID = "")||(AUserLocID = "") viewDisplayValue
	s rowId = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	q:(rowId = "") viewDisplayValue
	s objUser = ##class(EMRmeta.UserPageConfig).%OpenId(rowId)
	q:(objUser = "") viewDisplayValue
	s viewDisplayValue = objUser.ViewDisplay
	k objUser
	q viewDisplayValue
}

/// Desc:		保存住院病历-导航页面病历目录的视图显示配置
/// Creator:	Lina
/// CreateDate:	2016-12-22
/// InPut:		AUserID 用户ID
/// 			AUserName 用户名
/// 			AUserLocID 用户科室ID
/// 			ASelectedItem 选中的视图值
/// OutPut:		result 成功:rowID,失败:0 
/// Debug: 		w ##Class(EMRservice.BL.BLUserPageConfig).SaveViewDisplayConfig("359","孙凤霞","6","LargePicShow")
ClassMethod SaveViewDisplayConfig(AUserID As %String, AUserName As %String, AUserLocID As %String, ASelectedItem As %String) As %String
{
	s result = 0
	q:(AUserID = "")||(AUserName = "")||(AUserLocID = "")||(ASelectedItem = "") result
	s rowId = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	if (rowId '= "")
	{
		s objUser = ##class(EMRmeta.UserPageConfig).%OpenId(rowId)
	}else
	{
		s objUser = ##class(EMRmeta.UserPageConfig).%New()
	}
	s objUser.LoginUserID = AUserID
	s objUser.LoginUserName = AUserName
	s objUser.LoginUserLocID = AUserLocID
	s objUser.ViewDisplay = ASelectedItem
	s $zt = "UserPageConfigErrorHandler"
	s sc = objUser.%Save()
	if ($$$ISOK(sc))
	{
		s result = objUser.%Id()
	}
	k objUser
	q result
	 
UserPageConfigErrorHandler
    q result
}

/// Desc:		获取住院病历-资源区页签查询按钮的配置
/// Creator:	Lina
/// CreateDate:	2017-1-4
/// InPut:		AUserID 用户ID
/// 			AUserLocID 用户科室ID
/// OutPut:		json 用户资源区页签配置值
/// Debug: 		w ##Class(EMRservice.BL.BLUserPageConfig).GetResourceConfig("359","6")
ClassMethod GetResourceConfig(AUserID As %String, AUserLocID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AUserID = "")||(AUserLocID = "") json
	s rowId = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	q:(rowId = "") json
	s objUser = ##class(EMRmeta.UserPageConfig).%OpenId(rowId)
	q:(objUser = "") json
	d json.Write("{")
	d json.Write("""Lis"":"""_objUser.LisRadio_"""")
	d json.Write(",""Pacs"":"""_objUser.PacsRadio_"""")
	d json.Write("}")
	k objUser
	q json
}

/// Desc:		保存住院病历-资源区页签查询按钮的配置
/// Creator:	Lina
/// CreateDate:	2016-12-22
/// InPut:		AUserID 用户ID
/// 			AUserLocID 用户科室ID
/// 			AResourceConfig 查询按钮配置
///             ATabID 资源区页签TabID
/// OutPut:		result 成功:rowID,失败:0 
/// Debug: 		w ##Class(EMRservice.BL.BLUserPageConfig).SaveResourceConfig("359","6","Pacs","{""Pacs"":""currentEpisode""}")
ClassMethod SaveResourceConfig(AUserID As %String, AUserLocID As %String, ATabID As %String, AResourceConfig As %String) As %String
{
	s result = 0
	q:(AUserID = "")||(AUserLocID = "")||(ATabID = "") result
	s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(AUserID)
	s data = ##Class(%GlobalBinaryStream).%New()
	d data.Write(AResourceConfig)
	q:(data.Size <= 0) result
	s objJson = ##Class(EMRservice.Parser.Json).%New()
	s array = objJson.Deserialize(data)
	s rowId = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	if (rowId '= "")
	{
		s cmdObj = "objUser = ##class(EMRmeta.UserPageConfig).%OpenId("_rowId_")"	
		s @cmdObj
		
	}else
	{
		s cmdObj = "objUser = ##class(EMRmeta.UserPageConfig).%New()"
		s @cmdObj
	}
	s cmdPropety = "objUser.LoginUserID ="_AUserID
	s @cmdPropety
	s cmdPropety = "objUser.LoginUserName ="""_userName_""""
	s @cmdPropety
	s cmdPropety = "objUser.LoginUserLocID ="_AUserLocID
	s @cmdPropety
	s key = ""
	for 
	{
		s value = array.GetNext(.key)
		q:(key = "")
		continue:(key '= ATabID)
		continue:(value = "")
		s cmdPropety = "objUser."_key_"Radio = """_value_""""
		s @cmdPropety
	}
	s $zt = "ResourceConfigErrorHandler"
	s cmdObjSave = "scobj = objUser.%Save()"
	s @cmdObjSave
	if ($$$ISOK(@"scobj"))
	{
		s cmdGetId = "result = objUser.%Id()"
		s @cmdGetId
		s result = @"result"
	}
	k objUser
	q result
	 
ResourceConfigErrorHandler
    q result
}

/// ##Class(EMRservice.BL.BLUserPageConfig).GetOPDisplay(AUserID, AUserLocID)
ClassMethod GetOPDisplay(AUserID, AUserLocID As %String) As %String
{
	s ret = ##Class(EMRservice.SystemParameter).GetOPWidth()
	s id = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	q:(id = "") ret
	s obj = ##class(EMRmeta.UserPageConfig).%OpenId(id)
	q:(obj = "") ret
	q obj.OPDisplay
}

/// EMRservice.BL.BLUserPageConfig
ClassMethod SetOPDisplay(AUserID, AUserLocID, AOPDisplay As %String) As %String
{
	s id = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(AUserID)
	if (id = "")
	{
		s obj = ##class(EMRmeta.UserPageConfig).%New()
		s obj.LoginUserID=AUserID
		s obj.LoginUserLocID=AUserLocID
		s obj.OPDisplay	= AOPDisplay
		s obj.LoginUserName=userName
		d obj.%Save()		
	}
	else
	{
		s obj = ##class(EMRmeta.UserPageConfig).%OpenId(id)
		s obj.OPDisplay	= AOPDisplay
		d obj.%Save()
	}
	q ""
}

/// Desc:		查询门诊病历缩放比例
/// Creator:	Zhangxy
/// CreateDate:	2021/11/2
/// InPut:		AUserID 用户ID
/// 			AUserLocID 用户科室ID
ClassMethod GetOPScaling(AUserID, AUserLocID) As %String
{
	s ret = ##Class(EMRservice.SystemParameter).GetOPWidth()
	s id = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	q:(id = "") ret
	s obj = ##class(EMRmeta.UserPageConfig).%OpenId(id)
	q:(obj = "") ret
	q obj.OPScaling
}

/// Desc:		保存门诊病历缩放比例
/// Creator:	Zhangxy
/// CreateDate:	2021/11/2
/// InPut:		AUserID 用户ID
/// 			AUserLocID 用户科室ID
/// 			AOPScaling 缩放比例
ClassMethod SetOPScaling(AUserID, AUserLocID, AOPScaling As %String) As %String
{
	s id = $o(^DHCEMRM.UserPageConfigI("LoginUserIDIndex"," "_AUserID," "_AUserLocID,""))
	s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(AUserID)
	if (id = "")
	{
		s obj = ##class(EMRmeta.UserPageConfig).%New()
		s obj.LoginUserID=AUserID
		s obj.LoginUserLocID=AUserLocID
		s obj.OPScaling	= AOPScaling
		s obj.LoginUserName=userName
		d obj.%Save()		
	}
	else
	{
		s obj = ##class(EMRmeta.UserPageConfig).%OpenId(id)
		s obj.OPScaling	= AOPScaling
		d obj.%Save()
	}
	q "ok"
}

}
