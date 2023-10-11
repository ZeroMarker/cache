/**
* Description: 体检CA签名
* FileName: dhcpe.cacommon.js
* Creator: wangguoying
* Date: 2022-10-11
*/
var $PECA = {
    enable: true,   //是否启用体检CA签名
    modeCodeArr: ["PEResult", "PEStationCommit", "PEReportAudit", "PEReportAudit"], //签名模块代码  分别对应体检业务调用PESaveCASign中SignType位置索引 0：医生录入 1：科室提交  2：初审  3：复审
    option: {
        logonType: "",     // UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式，其它弹出固定方
        singleLogon: 0,     //0-弹出多页签签名，1-单种签名方式
        forceOpen: ""    //1-强制每次都弹出签名窗口  传空，则取配置
        //isHeaderMenuOpen:true, //是否在头菜单打开签名窗口. 默认 true
        //SignUserCode:txtUser, //期望签名人 HIS工号，会校验证书用户与 HIS工号. 默认空
        //signUserType:"", // 默认空，表示签名用户与当前 HIS用户一致。ALL时不验证用户与证书
        //notLoadCAJs:1, //登录成功后，不向头菜单加载 CA
        //loc:deptDesc, //科室 id或描述，默认当前登录科室
        //groupDesc:groupDesc, //安全组描述，默认当前登录安全组
        //caInSelfWindow:1 //用户登录与切换科室功能， 业务组不用
    }
}

/**
* [CA签名]
* @param    {[String]}    SignType    [0：医生录入 1：科室提交  2：初审  3：复审]
* @param    {[String]}    ExpStr    [医生录入：医嘱ID  科室提交：就诊ID%站点ID  初审/复审：就诊ID]
* @param    {[String]}    Data    [要签名的数据] 
* @param    {[Function]}    CallFunc    [回调函数]   
* @param    {[Object]}    CallParamObj    [回调函数入参]   
* @Author wangguoying
* @Date 2022-10-11
*/
$PECA.CASign = function (SignType, ExpStr, Data, CallFunc, CallParamObj) {
    if (!this.enable) return CallFunc(CallParamObj);
    var opts = this.option;
    opts.modelCode = this.modeCodeArr[SignType];
    dhcsys_getcacert({
	    modelCode:opts.modelCode, /*签名模块中代码*/
        callback: function (certn) {
            if (certn.IsSucc) {
                if (certn.ContainerName == "") {
                    CallFunc(CallParamObj);
                } else {
                    if ("object" == typeof certn) {
                        $PECA.Save(certn, SignType, ExpStr, Data, CallFunc, CallParamObj);
                    }
                }
            } else {
                alert("签名失败！");
                return false;
            }
        }
    }, opts.logonType, opts.singleLogon, opts.forceOpen);
}

/**
* [保存签名数据]
* @param    {[Object]}    certn    CA签名返回对象
* @param    {[String]}    SignType    [0：医生录入 1：科室提交  2：初审  3：复审]
* @param    {[String]}    ExpStr    [医生录入：医嘱ID  科室提交：就诊ID%站点ID  初审/复审：就诊ID]
* @param    {[String]}    Data    [要签名的数据] 
* @param    {[Function]}    CallFunc    [回调函数]   
* @param    {[Object]}    CallParamObj    [回调函数入参]     
* @Author wangguoying
* @Date 2022-10-11
*/
$PECA.Save = function (certn, SignType, ExpStr, Data, CallFunc, CallParamObj) {
    var toSignData = Data != "" ? Data : tkMakeServerCall("web.DHCPE.CA.Main", "GetSignData", SignType, ExpStr);
    var hashData = certn.ca_key.HashData(toSignData);
    var signData = certn.ca_key.SignedData(hashData, certn.ContainerName);
    ExpStr = SignType+"^"+session["LOGON.USERID"]+"^"+ ExpStr; 
    var saveRtn = tkMakeServerCall("web.DHCPE.CA.Main", "SaveCASign", hashData, certn.CAUserCertCode, certn.ContainerName, signData, ExpStr, certn.CACertNo);
    if (saveRtn.split("^")[0] == "1") {
        CallFunc(CallParamObj);
    } else {
        alert("保存签名数据失败！");
        return false;
    }
}
