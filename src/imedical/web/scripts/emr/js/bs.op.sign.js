$(function(){
    init();

    //更改用户
    $('#txtUser').bind("input propertychange",function(){
        clearCheckWindow();
    });
    $('#txtUser').keyup(function(event){
        if(event.keyCode ==13){
            txtUserChange();
            $('#txtPwd').focus();
        }
    });

    $('#txtPwd').keyup(function(event){
        if(event.keyCode ==13){
            checkSure();
        }
    });
    document.getElementById("txtPwd").focus();
    //开始签名
    $("#checkSure").click(function(){
        checkSure();
    });
    
    //取消或关闭签名
    $("#checkCancel").click(function(){
        returnValue = "";
        closeWindow();
    });
    
    //撤销签名
    $("#revokeCheck").click(function(){
        if (getIdentityVerifcation()){
            var userInfo = $("#hiddenUserInfo").val();
            if (userInfo == ""){
                $.messager.alert("提示","用户名或密码错误");
                return;
            }
            returnValue = {action:"revoke",userInfo:JSON.parse(userInfo)};
            closeWindow();
        }
    });
});

function init(){
    if ((signParam.canRevokCheck == "1") && (signParam.id != "")){
        $("#revokeCheck").show();
    }else{
        $("#revokeCheck").hide();
    }
    if (signParam.authenticator.length > 0){
        $("#signCell")[0].innerText = signParam.authenticator[0].name;
    }else{
        $("#signCell")[0].innerText = signParam.cellName;
    }
    $("#divUserName")[0].innerText = emrTrans(userName);
    $("#txtUser").val(userCode);
    txtUserChange(); 
    $('#checkSure').focus();
}

function checkSure(){
    if (getIdentityVerifcation()){
        var userInfo = $("#hiddenUserInfo").val();
        if (userInfo == ""){
            $.messager.alert("提示","用户名或密码错误");
            return;
        }
        userInfo = JSON.parse(userInfo);
        var selectedSignLevel = $('#txtLevel').combobox('getValue');
        var levelData = $("#txtLevel").combobox("getData");
        $.each(levelData,function(index, item){
            if (selectedSignLevel == item.signLevel){
                userInfo.signLevel = item.signLevel;
                userInfo.levelName = item.levelName;
                userInfo.roleLevel = item.roleLevel;
                return false;
            }
        });
        returnValue = {action:"sign",userInfo:userInfo};
        closeWindow();
    }
}

// 用户名改变时，对签名窗口做出布局修改，并显示对应用户姓名；
function txtUserChange(){
    var txtUserCode = $('#txtUser').val();
    var oriSignatureLevel = "";
    if (typeof(signParam.oriSignLevel) != "undefined"){
        oriSignatureLevel = signParam.oriSignLevel;
    }
    var data = {
        action: "GET_SIGN_CHARACTER",
        params:{
            userCode: txtUserCode,
            userLocID: userLocID,
            episodeID: episodeID,
            hospitalID: hospitalID,
            oriSignatureLevel: oriSignatureLevel
        },
        product: product
    };
    ajaxPOSTCommon(data, function(result,errorMessage){
        if (result){
            $("#divUserName")[0].innerText = result.name;
            if (result.levelRange.length > 0){
                setLevelRange(result.levelRange);
            }
        }else{
            $.messager.alert("发生错误", errorMessage, "error",function(){
                closeWindow();
            });
        }
    }, function (error) {
        $.messager.alert("发生错误", "getSignCharacter error:"+error, "error");
    }, false);
}
 
//签名身份验证(后台数据验证)
function getIdentityVerifcation(){
    var rtn = false;
    document.getElementById("checkSure").focus();
    var tmpUserCode = $("#txtUser").val();
    var tmpPassword = $("#txtPwd").val();
    if (tmpPassword == ""){
        $.messager.alert("提示","请输入密码");
        return result;
    }
    var data = {
        action: "GET_USERINFO",
        params:{
            userCode: tmpUserCode,
            password: tmpPassword,
            userLocID: userLocID,
            episodeID: episodeID,
            hospitalID: hospitalID
        },
        product: product
    };
    ajaxPOSTCommon(data, function(result,errorMessage){
        if (result){
            $("#hiddenUserInfo").val(JSON.stringify(result));
            rtn = true;
        }else{
            $.messager.alert("发生错误", errorMessage, "error",function(){
                closeWindow();
            });
        }
    }, function (error) {
        $.messager.alert("发生错误", "getIdentityVerifcation error:"+error, "error");
    }, false);
    return rtn;
}

function setLevelRange(data){
    $("#txtLevel").combobox({
        valueField:"signLevel",
        textField:"levelName",
        width:245,
        panelHeight:120,
        data:data,
        onLoadSuccess:function(d){
            $('#txtLevel').combobox('enable');
        }
    });
}

//清楚签名窗口文本框
function clearCheckWindow(){
    $("#txtPwd").val("");
    $("#txtLevel").val("");
    $("#hiddenUserInfo").val("");
    $('#txtLevel').combobox('loadData', "");
    $('#txtLevel').combobox('setValue', "");
}

function closeWindow(){
    parent.closeDialog(signParam.dialogID);
}

function ajaxPOSTCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify(data),
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        onSuccess("",ret.errorMessage);
                    }else{
                        onSuccess(ret.data,"");
                    }
                }
            }else{
                $.messager.alert("失败", "ajaxPOSTCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxPOSTCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

//国际化改造获取翻译
function emrTrans(value)
{
    if (typeof $g == "function") 
    {
        value = $g(value)
    }
    return value;
}

//封装基础平台websys_getMWToken()方法
function getMWToken()
{
    try{
        if (typeof(websys_getMWToken) != "undefined")
            return websys_getMWToken();
        return "";
    }catch(e) {
        return "";
    }
}