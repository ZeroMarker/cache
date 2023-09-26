/// Description: 客户端版本管理
/// FileName: web.DHCPE.ClientManager.cls
/// Creator: wangguoying
/// Date: 2023-02-10
Class web.DHCPE.ClientManager Extends %RegisteredObject
{

/// 应用程序代码
Parameter APPCODE = "DHCPESrvCient";

/// 安装文件代码
Parameter INSTALLCODE = "INSTALL";

/// 文件地址
Parameter FILEPATHCODE = "FILEPATH";

/// 版本号代码
Parameter VERSIONCODE = "VERSION";

/// Description：获取文件下载路径
/// Input：  
///                Type：INSTALL：安装 UPDATE：更新
/// Return：       [{url:下载路径}]
/// Creator：     wangguoying
/// CreateDate：  2023-02-10
/// Debug: w ##class(web.DHCPE.ClientManager).GetDownloadUrl("INSTALL")
ClassMethod GetDownloadUrl(Type)
{
    Set arr = []
    Set appId=$ORDER(^DHCPESettingsApp(0,"Code",..#APPCODE,0))
    Quit:appId="" "[]"
    Set paramId=$ORDER(^DHCPESettingsParam(0,"APPCode",appId,..#FILEPATHCODE,""))
    Set path = $PIECE(^DHCPESettingsParam(paramId),"^",4)
    Quit:paramId="" "[]"
    Set id = ""
    For{
        Set id = $ORDER(^DHCPESettingsValue(0,"ParamDr",paramId,"Type","C",id))  
        Quit:id=""
        Set typeVal = $PIECE(^DHCPESettingsValue(id),"^",3)
        Continue:typeVal'=Type
        Set value = $PIECE(^DHCPESettingsValue(id),"^",4)
        Set obj = {}
        Set obj.url = path_value
        Set obj.fileName = value
        Do arr.%Push(obj)
    }
    Quit arr.%ToJSON()
}

/// Description：获取客户端最新版本号
/// Input：  
/// Return：      版本号
/// Creator：     wangguoying
/// CreateDate：  2023-02-10
/// Debug: w ##class(web.DHCPE.ClientManager).GetVersion()
ClassMethod GetVersion()
{
    Quit ##class(web.DHCPE.Settings.Param).GetParamDefualt(..#APPCODE,..#VERSIONCODE)
}

/// Description：获取客户端版本信息
/// Input：  
/// Return：      版本号
/// Creator：     wangguoying
/// CreateDate：  2023-02-11
/// Debug: w ##class(web.DHCPE.ClientManager).GetVersionInfo()
ClassMethod GetVersionInfo(Param = "")
{
    Set $ZTRAP = "GetVersionInfoErr"
    Set obj = {}
    Set obj.code = 0
    Set obj.version = ##class(web.DHCPE.Settings.Param).GetParamDefualt(..#APPCODE,..#VERSIONCODE)
    Set obj.installUrl = ..GetDownloadUrl("INSTALL")
    Set obj.upgradeUrl = ..GetDownloadUrl("UPDATE")
    Quit obj.%ToJSON()
GetVersionInfoErr
    Set $ZTRAP = ""
    Set obj = {"code":-200,"msg":($ZERROR)}
    Quit obj.%ToJSON()
}

}
