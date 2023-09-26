/// Desc:用户配置逻辑
/// Creaotr:Donglulu
/// CreateDate:2017-11-3
Class EMRservice.BL.BLUserConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:     Donglulu
/// CreateDate:  2017-11-3	
/// Desc:        取EMRmeta.UserConfig 配置
/// Input:       AUserID，ALocID，AType配置类型
/// OutPut:      AConfig 个性配置值
/// Debug:       w ##Class(EMRservice.BL.BLUserConfig).GetConfig(230,6,"SHOWTYPE")	
ClassMethod GetConfig(AUserID As %String, ALocID As %String, AType As %String) As %String
{
	s config = "LIST"
	q:(AUserID = "")||(ALocID = "")||(AType = "") config
	
	s flag = ##Class(EMRservice.BL.BLUserConfig).GetCloseConfig(AType)
	q:(flag = "1") config
	
	s rowId = $o(^DHCEMRM.UserConfigI("UserLocTypeIndex"," "_AUserID," "_ALocID," "_$zcvt(AType,"U"),""))
	q:(rowId = "") config
	s objConfig = ##Class(EMRmeta.UserConfig).%OpenId(rowId)
	q:(objConfig = "") config
	s config = $zcvt(objConfig.Config,"U")
	q config
}

/// Desc:       添加用户配置数据
/// Creator:    Donglulu
/// CreateDate: 2017-11-3
/// Input:      AUserID
///             ALocID
///             AType
///             AConfig
/// Debug:      w ##Class(EMRservice.BL.BLUserConfig).AddData(230,6,"SHOWTYPE","WRITING")
ClassMethod AddData(AUserID As %String, ALocID As %String, AType As %String, AConfig As %String) As %String
{
	s result = 0
	q:(AUserID = "")||(ALocID = "")||(AType = "")||(AConfig = "") result
	s rowId = $o(^DHCEMRM.UserConfigI("UserLocTypeIndex"," "_AUserID," "_ALocID," "_$zcvt(AType,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(EMRmeta.UserConfig).%New()
		s obj.UserID = AUserID
		s obj.LocID = ALocID
		s obj.Type = $zcvt(AType,"U")
	}
	else
	{
		s obj = ##Class(EMRmeta.UserConfig).%OpenId(rowId)
	}

	s obj.Config = $zcvt(AConfig,"U")
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

/// Creator:     Donglulu
/// CreateDate:  2020-8-18	
/// Desc:        判断用户是否屏蔽某项用户个性化配置
/// Input:       AType配置类型
/// OutPut:      0 未屏蔽，1屏蔽
/// Debug:       w ##Class(EMRservice.BL.BLUserConfig).GetCloseConfig("Revision")	
ClassMethod GetCloseConfig(AType As %String) As %String
{
	s flag = "0"
	
	s closeUserConfigType = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("CloseUserConfigType","")
	q:(closeUserConfigType = "") flag

	s count=$l(closeUserConfigType, "^")
	f i=1:1:count 
	{
		s closeType = $p(closeUserConfigType, "^", i)
		q:(closeType = "")
		if ($zcvt(closeType,"U") = $zcvt(AType,"U"))
		{
			s flag = "1"
			q
		}
	}
	
	q flag
}

}
