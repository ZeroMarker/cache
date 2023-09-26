var VistualPath = "/CSM";
var localstr = location.protocol + "//" + location.host + location.port + VistualPath;

function AjaxInvoke(url, data, type, succcallback, async) {
    if (data == null || data.length < 1) {
        $.ajax({
            type: type,
            dataType: "json",
            url: url,
            async: async,
            success: function (d) {
                alert("success");
                alert(d.responseText);
                alert(eval(d.responseText));
                result = eval(d.responseText);
                alert(result);
            },
            error: function (d) {
                alert("error");
                alert(d.responseText);
            }
        });
    } else {
        $.ajax({
            type: type,
            dataType: "json",
            url: url,
            data: data,
            async: async,
            success: function (d) {
                alert("success");
                alert(d.responseText);
                alert(eval(d.responseText));
                result = eval(d.responseText);
                alert(result);
            },
                error: function (d) {
                //alert("data-error");
                alert(d.responseText);
                result = eval(d.responseText);
            }
        });
    }
}

function AjaxReturn(url, data, type, async) {
    var result;
    if (data == null || data.length < 1) {
        $.ajax({
            type: type,
            dataType: "json",
            url: url,
            async: async,
            success: function(d) {
                alert("success");
                alert(d.responseText);
                alert(eval(d.responseText));
                result = eval(d.responseText);
                alert(result);
            },
            error: function(d) {
                alert("error");
                alert(d.responseText);
            }
        });
    } else {
        $.ajax({
            type: type,
            dataType: "json",
            url: url,
            data: data,
            async: async,
            success: function(d) {
                alert("data-success");
                alert(d.responseText);
                alert(eval(d.responseText));
                result = eval(d.responseText);
                alert(result);
            },
            error: function(d) {
                //alert("data-error");
                //alert(d.responseText);
                result = eval(d.responseText);
            }
        });
    }

    return result;
}

/*
 * 验证的方法，普通的值验证方式，使用同步的方式进行 对于需要判断区间或者对比的数据，可以都封装到data中去 参数说明：obj 调用的和消息关联的节点，
 * url：验证方法的地址 data 验证的数据的值 async： 是否是异步验证
 */
function AjaxValidate(obj, url, data, async) {
    $(obj).nextAll(":not(div)").remove();  //这里需要注意，日期控件使用div包裹，这里不能清除。验证的提示请使用span包裹不要使用div
    $(obj).parent().append("<span class='pl10'><img src='"+localstr+"/Content/Images/loading.gif' /><label style='padding-left:5px'> 正在发送验证请求...</label></span>");
    $.ajax({
        type: "POST",
        dataType: "json",
        async: async,
        url: url,
        data: data,
        success: function (d) {
            $(obj).nextAll(":not(div)").remove(); //这里需要注意，日期控件使用div包裹，这里不能清除。验证的提示请使用span包裹不要使用div
            if (!d.Result) {
                if (d.Message == "DHCSYSTEMERROR") {
                    window.open("MessagesWebControls.do/SystemMessage/DHCSYSTEMERROR", "mainFrame");
                } else if (d.Message == "DHCNOAUTHORIZATE") {
                    window.open("MessagesWebControls.do/SystemMessage/DHCNOAUTHORIZATE", "mainFrame");
                } else {
                    $(obj).parent().append("<span style='color:red;' class='pl10'><img src='" + localstr + "/Content/Images/VFail.gif' /><label style='padding-left:5px'>" + d.Message + "</label></span>");
                    $(obj).attr("IsValid", false);
                }
            } else {
                $(obj).parent().append("<span class='pl10'><img src='" + localstr + "/Content/Images/VPass.gif' /><label style='padding-left:5px'> 验证通过 </label></span>");
                $(obj).attr("IsValid", true);
            }
        },
        error: function (d) {
            $(obj).nextAll(":not(div)").remove(); //这里需要注意，日期控件使用div包裹，这里不能清除。验证的提示请使用span包裹不要使用div
            if (d.responseText.indexOf("用户登录") != -1) {
                window.open("Login.do", "_self");
            } else {
                $(obj).parent().append("<span style='color:red' class='pl10'><img src='" + localstr + "/Content/Images/VFail.gif' /><label style='padding-left:5px'>网络请求失败！</label></span>");
            }
        }
    });
}

/*
* Ext的MessageBox类(使用该类之前，应该先引用Extjs相关文件)
*/
function MessageBox(message) {
    Ext.Msg.show({
        title: '提示',
        msg: message,
        buttons: { ok: "确定" },
        icon: Ext.MessageBox.INFO
    });
}

/*
* Ext的MessageBox类(使用该类之前，应该先引用Extjs相关文件)
*/
function MessageBoxResult(result, operationMsg) {
    var message;
    if (result.Result) {
        message = operationMsg + "成功";
    }
    else if (result.Message == "DHCNOAUTHORIZATE") {
        message = "您没有权限进行 [" + operationMsg + "] 操作！";
    }
    else {
        message = operationMsg + "失败" + "<br><br>" + unescape(result.Message);
    }

    Ext.Msg.show({
        title: '提示',
        msg: message,
        buttons: { ok: "确定" },
        icon: Ext.MessageBox.INFO
    });
}

/*
* Ext的MessageBoxButton类(使用该类之前，应该先引用Extjs相关文件)
*/
function MessageBoxButton(message, btnText) {
    if (btnText == "") {
        btnText = "确定";
    }
    Ext.Msg.show({
        title: '提示',
        msg: message,
        buttons: { ok: btnText },
        icon: Ext.MessageBox.INFO
    });
}

/*
* Ext的MessageBoxYesNo类(使用该类之前，应该先引用Extjs相关文件)
*/
function MessageBoxYesNoSimple(message, okCallBack, cancelCallBack) {
    Ext.Msg.show({
        title: "提示",
        msg: message,
        buttons: { ok: "确定", cancel: "取消" },
        icon: Ext.MessageBox.INFO,
        fn: function(modelResult, objData) {
            if (modelResult == "ok") {
                if (okCallBack != null) {
                    okCallBack();
                }
            } else {
                if (cancelCallBack != null) {
                    cancelCallBack();
                }
            }
        }
    });
}

function MessageBoxYesNo(title, message, btnOkText, okCallBack, btnCancelText, cancelCallBack) {
    btnOkText = (btnOkText == null || btnOkText == "") ? "确定" : btnOkText;
    btnCancelText = (btnCancelText == null || btnCancelText == "") ? "取消" : btnCancelText;
    Ext.Msg.show({
        title: title,
        msg: message,
        buttons: { ok: btnOkText, cancel: btnCancelText },
        icon: Ext.MessageBox.INFO,
        fn: function(modelResult, objData) {
            if (modelResult == "ok") {
                if (okCallBack != null) {
                    okCallBack;
                }
            } else {
                if (cancelCallBack != null) {
                    cancelCallBack;
                }
            }
        }
    });
}

/*
* Ext的MessageBoxYesNoCancel类(使用该类之前，应该先引用Extjs相关文件)
*/
function MessageBoxYesNoCancelSimple(message, yesCallBack, noCallBack, cancelCallBack) {
    Ext.Msg.show({
        title: "提示",
        msg: message,
        buttons: { yes: "是", no: "否", cancel: "取消" },
        icon: Ext.MessageBox.INFO,
        fn: function(modelResult, objData) {
            if (modelResult == "yes") {
                if (yesCallBack != null) {
                    yesCallBack;
                }
            } else if (modelResult == "no") {
                if (noCallBack != null) {
                    noCallBack;
                }
            } else {
                if (cancelCallBack != null) {
                    cancelCallBack;
                }
            }
        }
    });
}

function MessageBoxYesNoCancel(title, message, btnYesText, yesCallBack, btnNoText, noCallBack, btnCancelText, cancelCallBack) {
    btnYesText = (btnYesText == null || btnYesText == "") ? "是" : btnYesText;
    btnNoText = (btnNoText == null || btnNoText == "") ? "否" : btnNoText;
    btnCancelText = (btnCancelText == null || btnCancelText == "") ? "取消" : btnCancelText;
    Ext.Msg.show({
        title: title,
        msg: message,
        buttons: { yes: btnYesText, no: btnNoText, cancel: btnCancelText },
        icon: Ext.MessageBox.INFO,
        fn: function(modelResult, objData) {
            if (modelResult == "yes") {
                if (yesCallBack != null) {
                    yesCallBack;
                }
            } else if (modelResult == "no") {
                if (noCallBack != null) {
                    noCallBack;
                }
            } else {
                if (cancelCallBack != null) {
                    cancelCallBack;
                }
            }
        }
    });
}

