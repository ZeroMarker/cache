Class EMRservice.BL.plugin.DefaultFontStyle Extends %RegisteredObject
{

/// CreateDate: 2020-12-10
/// Desc:       设置当前病历默认字体样式
/// Input:      AHospitalID: 当前登陆院区ID
///             AFontStyle:  字体样式,格式参照系统参数SetDefaultFontStyle
/// return:     "0":失败 "1":成功
/// Debug:      w ##Class(EMRservice.BL.plugin.DefaultFontStyle).insertDefaultFontStyleConfig("2","'fontFamily':'宋体','fontSize':'14pt','lineSpace':'1.5','fontSpace':'0'")
ClassMethod insertDefaultFontStyleConfig(AHospitalID As %String, AFontStyle As %String) As %String
{
    s result = "0"
    q:(AHospitalID = "") result
    s rowID = ""
    s rowID = $o(^DHCEMRM.DefaultFontStyleI("IdxHospitalIDIndex"," "_AHospitalID,rowID))
    if (rowID '= "")
    {
        s objDefaultFontStyle = ##Class(EMRmeta.plugin.DefaultFontStyle).%OpenId(rowID)
        q:(objDefaultFontStyle = "") 
        s objDefaultFontStyle.FontStyle = AFontStyle
    }
    elseif (rowID = "")
    {
        s objDefaultFontStyle = ##Class(EMRmeta.plugin.DefaultFontStyle).%New()
        s objDefaultFontStyle.HospitalID = AHospitalID
        s objDefaultFontStyle.FontStyle = AFontStyle
    }
    s sc = objDefaultFontStyle.%Save()
    if $$$ISOK(sc)
    {
        s result = "1"  
    }
    d objDefaultFontStyle.%Close() 
    k objDefaultFontStyle
    q result
}

/// CreateDate: 2020-12-10
/// Desc:       获取当前病历默认字体样式
/// Input:      AHospitalID: 当前登陆院区ID
/// return:     返回病历默认字体样式
/// Debug:      d ##Class(EMRservice.BL.plugin.DefaultFontStyle).getDefaultFontStyleConfig()
ClassMethod getDefaultFontStyleConfig() As %String
{
    s defaultFontStyle = ""
    // 当前登陆院区ID
    s hospitalID = %session.Get("LOGON.HOSPID")
    s rowID = ""
    s rowID = $o(^DHCEMRM.DefaultFontStyleI("IdxHospitalIDIndex"," "_hospitalID,rowID))
    
    if (rowID '= "")
    {
        s objDefaultFontStyle = ##Class(EMRmeta.plugin.DefaultFontStyle).%OpenId(rowID)
        q:(objDefaultFontStyle = "") 
        s defaultFontStyle = objDefaultFontStyle.FontStyle
    }
    
    k objDefaultFontStyle
    q defaultFontStyle
}

}
