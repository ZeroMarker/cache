/**
 * Description: 单机设备检查结果上传  非IE浏览器用
 * FileName: dhcpe.uploadchkresult.js
 * Creator: wangguoying
 * Date: 2023-03-15
 */
_GV = { txtContent: "", ImgList: [], txtList: [] };

function init() {
    init_event();
    setCfg();
    if (!$("#HPNo").validatebox("isValid")) {}
    setTimeout(show_img, 100);
    if ($("#ReadTxt").switchbox("getValue")) {
        setTimeout(read_txt, 100);
    }
}

/**
 * [显示本地图]
 */
function show_img() {
    var param = {
        business: "PUBLICSRV",
        method: "getFilePaths",
        dir: $("#H_FilePath").val(),
        suffix: ".jpg",
        origin: "show_img"
    }
    $PESocket.sendMsg(JSON.stringify(param), peSoceket_onMsg);
}


/**
 * [客户端回调]
 * @Author wangguoying
 * @Date 2023-03-17
 */
function peSoceket_onMsg(param, event) {
    var retObj = JSON.parse(event.data);
    var request = JSON.parse(retObj.receiveParam);
    if (request.business == "VERSIONINFO") return; //版本信息 
    if (retObj.code == "0") {
        if (request.business == "PUBLICSRV") {
            switch (request.method) {
                case "getFilePaths": //图片或txt
                    if (request.origin == "show_img") return show_img_callback(retObj);
                    if (request.origin == "read_txt") return read_txt_callback(retObj);
                    break;
                case "getImgBase64":
                    show_base64(retObj.body);
                    break;
                case "readFile":
                    readFile_callback(request, retObj.body);
                    break;
                default:
                    break;
            }
        } else if (request.business == "UPLOAD") {
            upload_callback(request);
        }
    } else {
        $.messager.progress("close");
        $.messager.alert("客户端返回信息", retObj.msg, "error");
        return false;
    }
}

/**
 * [读取本地txt回调]   
 * @Author wangguoying
 * @Date 2023-03-17
 */
function readFile_callback(request, txt) {
    if (txt != "") _GV.txtContent += txt;
    if (request.isLast == 1) { //txt全部读完
        var textInfo = $.trim(_GV.txtContent);
        //alert("textInfo=" + textInfo);
        if (textInfo == "") return false;
        var resultInfo = tkMakeServerCall("web.DHCPE.Interface.Main", "GetResultInfo", textInfo, $("#H_LOCID").val(), $("#H_URID").val());
        var ResultArr = resultInfo.split("^");
        $("#HPNo").val(ResultArr[0]);
        $("#ExamResult").val(ResultArr[1]);
        $("#ExamDesc").val(ResultArr[2]);
        hpno_keydown();
    }
}


/**
 * [客户端 查询图片集合回调]
 * @param    {[Object]}    retObj    [客户端回调Data]
 * @Author wangguoying
 * @Date 2023-03-17
 */
function show_img_callback(retObj) {
    if (retObj.body.length > 0) {
        _GV.ImgList = retObj.body;
        retObj.body.forEach(ele => {
            var param = {
                business: "PUBLICSRV",
                method: "getImgBase64",
                filePath: ele,
                origin: "show_img_callback"
            }
            $PESocket.sendMsg(JSON.stringify(param), peSoceket_onMsg);
        });
    }
}


function read_txt_callback(retObj) {
    if (retObj.body.length > 0) {
        _GV.txtList = retObj.body;
        for (let index = 0; index < retObj.body.length; index++) {
            var isLast = index == retObj.body.length - 1 ? 1 : 0;
            var param = {
                business: "PUBLICSRV",
                method: "readFile",
                filePath: _GV.txtList[index],
                charSet: "utf-8",
                isLast: isLast,
                origin: "read_txt_callback"
            }
            $PESocket.sendMsg(JSON.stringify(param), peSoceket_onMsg);
        }
    }
}


function show_base64(base64) {
    if (base64 != "") {
        if (document.getElementById("NoImg")) $("#NoImg").remove();
        $("<img src='data:image/jpg;base64," + base64 + "'>").appendTo($("#ImgList"));
    }
}

function read_txt_change(e, obj) {
    obj.value ? read_txt() : "";
}
/**
 * [Dom元素监听事件]
 * @Author wangguoying
 * @Date 2023-03-15
 */
function init_event() {
    $("#HPNo").on("keydown", function(e) {
        if (e.keyCode == 13) {
            hpno_keydown();
        }
    });
    $("#BUpload").on("click", function(e) {
        upload_result();
    });
}


function upload_result() {
    if (_GV.ImgList.length == 0) {
        $.messager.popover({ msg: "没有报告文件，不需要上传！", type: "error" });
        return false;
    }
    var HPNo = $("#HPNo").val(),
        UserCode = $("#OPUserCode").val(),
        ExamDesc = $("#ExamDesc").val(),
        ExamResult = $("#ExamResult").val(),
        ResultInfo = ExamDesc + "^" + ExamResult;
    if (UserCode == "") {
        $.messager.popover({ msg: "员工编号不能为空！", type: "error" });
        return false;
    }
    var UserID = tkMakeServerCall("web.DHCPE.Interface.Main", "GetUserID", UserCode, $("#H_LOCID").val(), $("#H_ArcimID").val());
    if (UserID == "") {
        $.messager.popover({ msg: "员工编号不存在！", type: "error" });
        return false;
    }
    if (HPNo == "") {
        $.messager.popover({ msg: "体检号不能为空！", type: "error" });
        return false;
    }
    var OneBaseInfo = tkMakeServerCall("web.DHCPE.Interface.Main", "GetBaseInfo", HPNo, $("#H_ArcimID").val(), "HPNo", $("#H_LOCID").val());
    if (OneBaseInfo == "NoHP") {
        $.messager.popover({ msg: "体检号不存在！", type: "info" });
        return false;
    } else if (OneBaseInfo == "NoItem") {
        $.messager.popover({ msg: "此体检号没有检查项目", type: "info" });
        return false;
    } else if (OneBaseInfo == "NoPaied") {
        $.messager.popover({ msg: "此检查项目未付费", type: "info" });
        return false;
    } else if (OneBaseInfo == "") {
        $.messager.popover({ msg: "体检号信息有问题，请核实", type: "info" });
        return false;
    }
    var OEID = OneBaseInfo.split("^")[7];
    if ((ExamResult != "") || (ExamDesc != "")) {
        tkMakeServerCall("web.DHCPE.Interface.Main", "SaveResult", HPNo, ResultInfo, UserID, $("#H_ArcimID").val(), ODID, $("#H_LOCID").val());
    }
    $.messager.progress({ title: "提示", msg: "正在上传图片", text: "上传中……" });
    upload_by_client(OEID, UserID);
}

function upload_by_client(OEID, UserID) {
    if (_GV.ImgList.length > 0) {
        var param = tkMakeServerCall("web.DHCPE.Interface.Main", "GetUploadInfo", OEID, ".jpg", $("#H_LOCID").val());
        if (param == "{}") {
            $.messager.popover({ msg: "获取FTP信息失败！", type: "error" });
            return false;
        }
        param = JSON.parse(param);
        param.business = "UPLOAD";
        param.delAftUpload = "1";
        param.OEORI = OEID;
        param.UserID = UserID;
        param.files = _GV.ImgList[0];
        $PESocket.sendMsg(JSON.stringify(param), peSoceket_onMsg);
    }
}

function upload_callback(request) {
    _GV.ImgList.shift();
    var saveRet = tkMakeServerCall("web.DHCPE.Interface.Main", "SaveUploadInfo", request.OEORI, request.UserID, request.path, request.delAftUpload);
    if (_GV.ImgList.length == 0) { //全部上传完毕
        if (_GV.txtList.length > 0) { //删除txt
            var param = {
                business: "PUBLICSRV",
                method: "delLcoalFile",
                filePath: _GV.txtList.join("##")
            }
            $PESocket.sendMsg(JSON.stringify(param), peSoceket_onMsg);
            _GV.txtList = [];
        }
        $.messager.progress("close");
        $.messager.alert("提示", "上传成功！", "success", function() {
            parent.open("", "_self", "");
            parent.close();
        });
    } else { //继续上传
        upload_by_client(request.OEORI, request.UserID);
    }
}

/**
 * [读取本地文本]  
 * @Author wangguoying
 * @Date 2023-03-17
 */
function read_txt() {
    _GV.txtContent = "";
    var param = {
        business: "PUBLICSRV",
        method: "getFilePaths",
        dir: $("#H_FilePath").val(),
        suffix: ".txt",
        origin: "read_txt"
    }
    $PESocket.sendMsg(JSON.stringify(param), peSoceket_onMsg);
}


/**
 * [读取配置信息]
 * @Author wangguoying
 * @Date 2023-03-15
 */
function setCfg() {
    var readTxt = $("#H_LURTextFlag").val();
    $("#ReadTxt").switchbox("setValue", readTxt == "Y");
}



/**
 * [体检号回车事件] 
 * @Author wangguoying
 * @Date 2023-03-15
 */
function hpno_keydown() {
    var HPNo = $("#HPNo").val();
    if (HPNo == "") {
        $.messager.popover({ msg: "体检号不能为空", type: "info" });
        return false;
    }
    var OneBaseInfo = tkMakeServerCall("web.DHCPE.Interface.Main", "GetBaseInfo", HPNo, $("#H_ArcimID").val(), "HPNo", $("#H_LOCID").val());
    if (OneBaseInfo == "NoHP") {
        $.messager.popover({ msg: "体检号不存在！", type: "info" });
        return false;
    } else if (OneBaseInfo == "NoItem") {
        $.messager.popover({ msg: "此体检号没有检查项目", type: "info" });
        return false;
    } else if (OneBaseInfo == "NoPaied") {
        $.messager.popover({ msg: "此检查项目未付费", type: "info" });
        return false;
    } else {
        set_baseinfo(OneBaseInfo);
    }
}

/**
 * [设置体检信息]
 * @param    {[String]}    info    [信息串：RegNo_"^"_MZH_"^"_XM_"^"_XB_"^"_Dob_"^"_height_"^"_weight_"^"_OEID]
 * @return   {[object]}    
 * @Author wangguoying
 * @Date 2023-03-15
 */
function set_baseinfo(info) {
    var arr = info.split("^");
    $("#SexIMG").removeClass().addClass(arr[3] == "男" ? "man" : "woman");
    $("#patName").html(arr[2]);
    $("#sexName").html(arr[3]);
    $("#Dob").html(arr[4]);
    $("#PatNo").html(arr[0]);
}



$(init);