// g_CA_Flag表示版本信息，0为 证书管理工具2.0版本，1为证书管理工具1.X版本
var g_CA_Flag = 0;
// ///define object /////////////////////////////////
try {
    //debugger;
    //throw new Error("仅使用secx2.4版本");
    if (window.ActiveXObject) {
        document.writeln("<OBJECT classid=\"CLSID:3F367B74-92D9-4C5E-AB93-234F8A91D5E6\" height=1 id=XTXAPP  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
        document.writeln("</OBJECT>");
        XTXAPP.SOF_GetVersion();
    } else {
        documentwriteln("<embed id=XTXAPP0 type=application/x-xtx-axhost clsid={3F367B74-92D9-4C5E-AB93-234F8A91D5E6} event_OnUsbkeyChange=OnUsbKeyChange width=1 height=1 />");
        XTXAPP = document.getElementById("XTXAPP0");
        XTXAPP.SOF_GetVersion();
    }

} catch (e) {
    try {
        var oUtil = new ActiveXObject("BJCASecCOM.Util");
        g_CA_Flag = 1;
    } catch (e) {
        alert("没有正确安装证书应用环境或者证书应用环境已经损坏！");
    }
    // 正式上线后打开注释内容，提醒客户安装证书应用环境
    // alert("没有正确安装证书应用环境或者证书应用环境已经损坏！");
}

try {
    document.writeln("<OBJECT classid=\"CLSID:3BC3C868-95B5-47ED-8686-E0E3E94EF366\" height=1 id=picobj  style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
    document.writeln("</OBJECT>");
} catch (e) {
    alert("没有安装签章控件!");
}

// ///组件接口转换为脚本接口////////////////////////

function getUserList2() {
    //debugger;
    try {
        if (g_CA_Flag == 0) {
            var strUserList = XTXAPP.SOF_GetUserList();
            return strUserList; ;

        } else if (g_CA_Flag == 1) {

            return oUtil.getUserList2();
        }
        return "";
    } catch (e) {
    }
}

function HashData(InData) {
    try {

        return picobj.Hash(InData);

    } catch (e) {
    }

}
