Ext.QuickTips.init();
Ext.form.Field.prototype.msgTarget = 'qtip';
// 替换图片文件地址为本地
Ext.ns("FW.CommonMethod");

//显示确认消息
FW.CommonMethod.ShowConfirmMessage = function(messageInfor, callbackFunction) {
    Ext.MessageBox.show({
        title: "确认信息",
        msg: messageInfor,
        width: 400,
        fn: callbackFunction,
        buttons: Ext.MessageBox.OKCANCEL,
        icon: Ext.MessageBox.QUESTION
    });
}

//显示消息
FW.CommonMethod.ShowMessage = function(messageType, messageInfor, url) {
    var messageTitle;
    var msgIcon;
    if (messageType == "E") {
        messageTitle = "错误信息";
        msgIcon = Ext.MessageBox.ERROR;
    }
    else if (messageType == "I") {
        messageTitle = "提示信息";
        msgIcon = Ext.MessageBox.INFO;
    }
    else if (messageType == "W") {
        messageTitle = "警告信息";
        msgIcon = Ext.MessageBox.WARNING;
    }

    Ext.MessageBox.show({
        title: messageTitle,
        msg: messageInfor,
        width: 400,
        buttons: Ext.MessageBox.OK,
        icon: msgIcon
    });
}
    

//发送请求
 FW.CommonMethod.DoRequest= function(url, actionParams, HandleResult,nameSpace) {
    var conn = new Ext.data.Connection();
    conn.request({
        url: url,
        params: actionParams,
        method: 'post',
        scope: nameSpace,
        callback: HandleResult
    });
}

FW.CommonMethod.SubmitForm = function(frmName, actionParams, grdName, winName) {
	if (!Ext.getCmp(frmName).getForm().isValid()) {
        return;
    }
    Ext.getCmp(frmName).getForm().submit({
        waitTitle: '提示',
        waitMsg: '正在提交数据请稍后...',
        url: accessURL,
        params: actionParams,
        success: function(form, action) {
            if (winName) {
                Ext.getCmp(winName).close();
            }
            FW.CommonMethod.ShowMessage("I", "操作成功！");
            if (grdName) {
                Ext.getCmp(grdName).store.reload();
            }
        },
        failure: function(form, action) {
            FW.CommonMethod.ShowMessage("E", "操作失败！");
        }
    });
}