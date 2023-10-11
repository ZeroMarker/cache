/**
 * Description: 单机设备检查结果上传  IE浏览器用
 * FileName: dhcpe.uploadchkresult.ie.js
 * Creator: wangguoying
 * Date: 2023-03-15
 */

/** 全局变量  控制上传 */
_GV = { IMGNames: [], Uploading: false, Stop: false, timer: null };

function init() {
    init_event();
    setCfg();
    if (!$("#HPNo").validatebox("isValid")) {}
    show_img();
    if ($("#ReadTxt").switchbox("getValue")) {
        read_txt();
    }

}

function read_txt_change(e, obj) {
    obj.value ? read_txt() : "";
}

/**
 * [显示本地图]
 * @Author wangguoying
 * @Date 2023-03-16
 */
function show_img() {
    var imgNames = get_files(".jpg");
    if (imgNames != "") {
        $("#ImgList").empty();
        var imgArr = imgNames.split("^");
        for (var i = 0; i < imgArr.length; i++) {
            var OneImgFile = imgArr[i];
            $("<img src='file://" + $("#H_FilePath").val() + "/" + OneImgFile + "'>").appendTo($("#ImgList"));
        }
    }
}


/**
 * [读取txt内容]  
 * @Author wangguoying
 * @Date 2023-03-15
 */
function read_txt() {
    var fileNames = get_files(".txt"); //读所有txt时，传.txt
    if (fileNames == "") return false;
    var textInfo = ""
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    for (var index = 0; index < fileNames.split("^").length; index++) {
        var f = fso.OpenTextFile($("#H_FilePath").val() + "/" + fileNames.split("^")[index], 1);
        textInfo += f.ReadAll();
    }
    console.log("textInfo=" + textInfo);
    if (textInfo == "") return false;
    var resultInfo = tkMakeServerCall("web.DHCPE.Interface.Main", "GetResultInfo", textInfo, $("#H_LOCID").val(), $("#H_URID").val());
    var ResultArr = resultInfo.split("^");
    $("#HPNo").val(ResultArr[0]);
    $("#ExamResult").val(ResultArr[1]);
    $("#ExamDesc").val(ResultArr[2]);
    hpno_keydown();
}

/**
 * [根据文件后缀名获取文件名称集合]
 * @param    {[String]}    suffix    [文件后缀名，如".jpg""]
 * @return   {[object]}    
 * @Author wangguoying
 * @Date 2023-03-15
 */
function get_files(suffix) {
    var filePath = $("#H_FilePath").val();
    if (filePath == "") return "";
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var f = fso.GetFolder(filePath);
    var fc = new Enumerator(f.Files);
    var FileNameStr = "";
    var i = 0;
    for (; !fc.atEnd(); fc.moveNext()) {
        try {
            var OneFileName = fc.item().Name;
            if (OneFileName.substring(OneFileName.length - suffix.length) === suffix) {
                FileNameStr = FileNameStr == "" ? OneFileName : FileNameStr + "^" + OneFileName;
            }
        } catch (e) {}

    }
    return FileNameStr;
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
 * [上传结果] 
 * @Author wangguoying
 * @Date 2023-03-16
 */
function upload_result() {

    if (_GV.timer) clearInterval(_GV.timer);
    _GV = { IMGNames: [], Uploading: false, Stop: false, timer: null };

    var imgNames = get_files(".jpg");
    if (imgNames == "") {
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
    _GV.IMGNames = imgNames.split("^");
    _GV.timer = setInterval(function() { uploadByCache(OEID, 1, UserID) }, 1000);
}





/**
 * [上传]
 * @Author wangguoying
 * @Date 2022-01-18
 */
function uploadByCache(OEID, DeleteFlag, UserID) {

    var fso = new ActiveXObject("Scripting.FileSystemObject");
    while (_GV.IMGNames.length > 0 && !_GV.Uploading && !_GV.Stop) {
        _GV.Uploading = true;
        var OneImgFile = _GV.IMGNames[0];
        var FileName = $("#H_FilePath").val() + "/" + OneImgFile;
        var formData = new FormData();
        formData.append("action", "GMDIMG");
        formData.append("OEORI", OEID);
        formData.append("IMGType", ".jpg");
        formData.append("DeleteFlag", DeleteFlag);
        formData.append("imageFile", getBlob(FileName));
        formData.append("dataType", "text");
        formData.append("UserID", UserID);
        formData.append("LocID", $("#H_LOCID").val());
        $PE.upload(formData, "text", { title: "提示", msg: "正在上传图片", text: "上传中……"}, function(ret) {
            _GV.Uploading = false;
            if (ret == 0) {
                _GV.IMGNames.shift();
                if (_GV.IMGNames.length == 0) _GV.Stop = true;
                try {
                    fso.DeleteFile(FileName);
                } catch (e) {}
            } else {
                _GV.Stop = true;
                $.messager.alert("上传失败", ret, "error");
                return false;
            }
        }, function(error) {
            _GV.Stop = true;
            $.messager.popover({ type: "error", msg: "上传失败：" + error });
            return false;
        });
    }


    if (_GV.Stop) clearInterval(_GV.timer);

    if (_GV.IMGNames.length == 0) {
        var txtNames = get_files(".txt");
        if (txtNames != "") {
            var txtArr = txtNames.split("^");
            for (var index = 0; index < txtArr.length; index++) {
                var txtName = txtArr[index];
                try {
                    fso.DeleteFile($("#H_FilePath").val() + "/" + txtName);
                } catch (e) {}
            }
        }
        $.messager.alert("提示", "上传成功！", "success", function() {
            parent.open("", "_self", "");
            parent.close();
        });
    }
}



function file2Base64(file) {
    var obj = new ActiveXObject("DHCPEBase64.clsB64");
    return obj.EncodeFile(file);
}

/**
 * [将本地文件转成二进制]  
 * @Author wangguoying
 * @Date 2022-09-27
 */
function getBlob(FilePath) {
    var dataUrl = file2Base64(FilePath).replace(/\s/g, '');;
    var bstr = window.atob(dataUrl)
    var n = bstr.length;
    var u8arr = new Uint8Array(n);
    while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
    }
    return new Blob([u8arr], { type: 'image/jpeg' });
}



$(init);