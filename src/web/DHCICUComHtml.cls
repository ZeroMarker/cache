/// 自定义重症Html标签
/// 用于新版重症菜单调用,与手麻分开
Class web.DHCICUComHtml Extends %RegisteredObject
{

Parameter LibPath = "../scripts/dhcclinic/icu/DHCICUEasyui/";

/// dhcicu:easyui
ClassMethod Easyui()
{
	set debug=0
    set hisuiPath="../scripts/dhcclinic/icu/DHCICUEasyui/lib/hisui/dist/"
    ;write "<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/easyui.css"" />"
    ;write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/icon.css"" />"
    ;write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.min.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.easyui.min.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/easyui-lang-zh_cn.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/dhccl.framework.js"" ></script>"
    
    write "<link rel=""stylesheet"" type=""text/css"" href="""_hisuiPath_"css/hisui.css"" />"
    if (debug)
    {
	    write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery-1.11.3.js"" ></script>"
	    write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.cookie.min.js"" ></script>"
    	write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.hisui.js"" ></script>"
	}
    else
    {
		write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery-1.11.3.min.js"" ></script>"
    	write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.hisui.min.js"" ></script>"    
	}
    write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/iconan.css"" />"
    write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
    write !,"<script type=""text/javascript"" src=""../scripts/websys.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.Constant.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.DateTime.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.Framework.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.SystemConfig.js"" ></script>"
}

/// dhcicu:head
ClassMethod Head()
{
	set locId=%session.Get("LOGON.CTLOCID")
    set deptId=locId
    write !,"<script type=""text/javascript"">"
    write !,"   var session={};"
    write !,"   session.DeptID="""_deptId_""";"
   	write !,"</script>"
}

}
