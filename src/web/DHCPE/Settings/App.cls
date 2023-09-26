Class web.DHCPE.Settings.App Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询App
/// Author:WZH 20210914
/// Param:appCode:app编码
/// Debugger:d ##class(%ResultSet).RunQuery("web.DHCPE.Settings.App","SearchApp")
Query SearchApp(appCode = "") As websys.Query(ROWSPEC = "SARowId:%String,SACode:%String,SADesc:%String")
{
}

ClassMethod SearchAppExecute(ByRef qHandle As %Binary, appCode = "") As %Status
{
    Set repid=$INCREMENT(^CacheTemp)
    Set ind=1

    Set SA=0
    For  Set SA=$ORDER(^DHCPESettingsApp(SA)) Quit:(SA="")  Do
    .Set SAData=$GET(^DHCPESettingsApp(SA))
    .Set Code=$PIECE(SAData,"^",1)
    .Quit:(appCode'="")&&(Code'[appCode)
    .Set Desc=$PIECE(SAData,"^",2)
    .Set Data=$LISTBUILD(SA,Code,Desc)
    .Do OutPutRow

    Set qHandle=$LISTBUILD(0,repid,0)
 	Quit $$$OK

OutPutRow
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// 新增应用 成功返回id 失败返回错误信息
/// Author:WZH 20210914
/// Param:SACode:应用编码 NotNull
/// Param:SADesc:应用名称
/// Debugger:w ##class(web.DHCPE.Settings.App).AddApp()
ClassMethod AddApp(SACode = "", SADesc = "")
{
        
    Quit:(SACode="") "-1^入参不能为空"
    Set $ZTRAP="AddAppError"

    Set myObj=##class(User.DHCPESettingsApp).%New()
    Set myObj.SACode=SACode
    Set myObj.SADesc=SADesc

    Set sc=myObj.%Save()
    If $$$ISERR(sc) {
	    Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
    }

    Quit myObj.%Id()

AddAppError
    Set $ZTRAP=""
    Quit "-200^"_$ZERROR
}

/// 更改应用 成功返回0 失败返回错误信息
/// Author:WZH 20210914
/// Param:SARowId:应用Id NotNull
/// Param:SACode:应用编码 NotNull
/// Param:SADesc:应用名称
/// Debugger:w ##class(web.DHCPE.Settings.App).UpdateApp()
ClassMethod UpdateApp(SARowId = "", SACode = "", SADesc = "") As %Status
{
    Quit:(SARowId="")||(SACode="") "-1^入参不能为空"
    Set $ZTRAP="UpdateAppError"
    Set myObj=##class(User.DHCPESettingsApp).%OpenId(SARowId)
    Set myObj.SACode=SACode
    Set myObj.SADesc=SADesc
    Set sc=myObj.%Save()
    If $$$ISERR(sc) {
	    Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
    }
    Quit 0

UpdateAppError
    Set $ZTRAP=""
    Quit "-200^"_$ZERROR
}

/// 删除应用 返回SQLCODE 0成功 其它失败
/// Author:WZH 20210914
/// Param:SAId:应用id NotNull
/// Debugger:w ##class(web.DHCPE.Settings.App).DeleteApp()
ClassMethod DeleteApp(SAId = "") As %Status
{
    Quit:(SAId="") "-1^入参不能为空"
    Tstart
    Set SQLCODE=##class(web.DHCPE.Settings.Param).DeleteParamByAppId(SAId)
    If SQLCODE'=0{
        Trollback
        Quit SQLCODE
    }
    &SQl(DELETE FROM SQLUSER.DHC_PE_SettingsApp WHERE SA_RowId=:SAId)
    If SQLCODE'=0{
        Trollback
        Quit SQLCODE
    }
    Tcommit

    Quit SQLCODE
}

/// Description：添加DataGrid拓展库 
/// Input:   	
/// Return:		
/// Creator:	wangguoying
/// CreateDate:	2022-07-21
/// Debug: w ##class(web.DHCPE.Settings.App).AddGirdExtLib()
ClassMethod AddGirdExtLib()
{
	Quit:$DATA(^DHCPESettingsApp(0,"Code","GridExtLib")) "-1^配置信息已存在"
	Set $ZTRAP = "AddGirdExtLibErr"
	Tstart
	Write "/*************生成APP*************/",!
	Set appId = ..AddApp("GridExtLib","DataGird工具拓展包")
	If +appId<=0  Trollback  Quit appId
	Write "/*************生成Param----CSS*************/",!
	Set paramCSS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"CSS","CSS")
	If +paramCSS<=0  Trollback  Quit paramCSS
	Write "/*************生成CSS Value*************/",!
	Set css = ##class(web.DHCPE.Settings.Value).AddValue(paramCSS,"C","C","../scripts/dhcpe/easyui-extensions/datagrid/jeasyui.extensions.datagrid.css")
	If +css<=0  Trollback  Quit css
	Set css = ##class(web.DHCPE.Settings.Value).AddValue(paramCSS,"C","C","../scripts/dhcpe/xlsx-style/dist/index.min.css")
	If +css<=0  Trollback  Quit css
	Set css = ##class(web.DHCPE.Settings.Value).AddValue(paramCSS,"C","C","../scripts/dhcpe/css/dhcpe.min.css")
	If +css<=0  Trollback  Quit css
	Write "/*************生成Param----JavaScript*************/",!
	Set paramJS = ##class(web.DHCPE.Settings.Param).AddParam(appId,"JS","JavaScript")
	If +paramJS<=0  Trollback  Quit paramJS
	Write "/*************生成JavaScript Value*************/",!
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","C","../scripts/dhcpe/easyui-extensions/jquery.jdirk.js")
	If +js<=0  Trollback  Quit js
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","C","../scripts/dhcpe/easyui-extensions/menu/jeasyui.extensions.menu.js")
	If +js<=0  Trollback  Quit js
	Set css = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","C","../scripts/dhcpe/easyui-extensions/datagrid/jeasyui.extensions.datagrid.getColumnInfo.js")
	If +js<=0  Trollback  Quit js
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","C","../scripts/dhcpe/easyui-extensions/datagrid/jeasyui.extensions.datagrid.columnToggle.js")
	If +js<=0  Trollback  Quit js
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","C","../scripts/dhcpe/easyui-extensions/datagrid/datagrid-dnd.js")
	If +js<=0  Trollback  Quit js
	Set css = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","utf-8","../scripts/dhcpe/xlsx-style/dist/xlsx.full.min.js")
	If +js<=0  Trollback  Quit js
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","C","../scripts/DHCPEExcelTool.js")
	If +js<=0  Trollback  Quit js
	Set js = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","C","../scripts/dhcpe/dhcpe.extend.js")
	If +js<=0  Trollback  Quit js
	Set css = ##class(web.DHCPE.Settings.Value).AddValue(paramJS,"C","utf-8","../scripts/dhcpe/dhcpe.min.js")
	If +js<=0  Trollback  Quit js
	Tcommit
	Write "/*************SUCCESS*************/",!
	Quit 0
AddGirdExtLibErr
	Set $ZTRAP = ""
	Trollback
	Quit "-100^"_$ZERROR
}

}
