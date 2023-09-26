//add by zhuj on 2009-7-27
//创建审核弹出窗口,用来输入用户名和密码
Ext.QuickTips.init();
function eprAudit(userLevel, docEprNumList)
{
    if (Ext.getCmp("winLogin"))
    {
         return;
     }
    var auditform = new Ext.FormPanel(
    {
        layout : "form",   
        id : "frmAuditList",   
        width : 220,   
        height : 130,   
        frame : true,   
        labelAlign : 'right',
        buttonAlign : 'center', 
        textdAlign : 'right',     
        labelWidth : 60,                            
        items : [
                    { xtype : "textfield", fieldLabel : "用户名", allowBlank : false, blankText : "用户名不可以为空!", id : "userName", width : 140 }, 
                    { xtype : "textfield", fieldLabel : "密码", inputType : "password", allowBlank : false, blankText : "密码不可以为空!", id : "pwd", width : 140 }                            
                ],

        buttons: [
                    { id : "btnConfirm", text : '确定', tooltip : '确定', handler : ajaxLogin },
                    { text : '取消', tooltip : '取消', handler : cancel }
                 ]
    });    
    
    var win = new Ext.Window(
    {
        footer : true,
        resizable : false,
        id : 'winLogin',
        title : '身份验证',
        width : 250,
        height : 130,
        //iconCls : 'logout',
        minimizable : false,
        maximizable : false,                
        shim : false,
        animCollapse : false,
        constrainHeader : true,
        layout : 'fit',
        modal : true,
        listeners : 
               {
                   'close' : function()
                   {
                       //窗体关闭时将dll显示
                          document.frames["eprlisteditordll"].setVisibility("visible");                                
                   }
               },  
        items : auditform,
        bbar: new Ext.Toolbar
        ({
            id : "bbar",
            height: 20
        })
    });
    
    //登陆按钮事件
    function ajaxLogin()
    {
        if (!auditform.form.isValid())
        {
            return;
        }
        //
        
        var bbar = Ext.getDom("bbar");
        bbar.innerHTML = "";

        var userName = Ext.getCmp("userName").getValue();
        var pwd = Ext.getCmp("pwd").getValue();
        Ext.get("winLogin").mask('操作中...', 'x-mask-loading');
        Ext.Ajax.request({
            url: '../web.eprajax.logs.updateMultiple.cls',
            timeout: parent.parent.timedOut,
            params: { episodeID: episodeID, EPRDocIDs: docEprNumList,EPRNum: EPRNum, userName: userName, pwd: pwd, userLevel: userLevel},
            success: function(response, opts) 
            {
                var obj = response.responseText;
                Ext.get("winLogin").unmask();
                if (obj == "LoginValidFail") 
                {
                    bbar.innerHTML = '<div style="font-weight:bold;">用户名或密码错误!</div>';
                }
                else if (obj == "CheckLevelFail") 
                {
                    bbar.innerHTML = '<div style="font-weight:bold;">医师级别与进行的操作不一致!</div>';
                }
                else if (obj.split('^')[0] == "success") 
                {
                    currState = obj.split('^')[2];
                    divState.innerHTML = obj.split('^')[1];  
                    win.close();
                    getPower();
                    
                    var objEprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
                    var logID = obj.split('^')[3];
                    invokeMultiPreview(objEprform, EPRNum, pateintID, episodeID, logID,
                            bindPrnTemplateID, "Multiple", instanceDataID, userID, printTemplateDocId);
                }
                else if (obj == "sessionTimedOut")
                {
                    alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
                }
                else 
                {
                    alert("操作失败!错误原因:" + obj);
                    //bbar.innerHTML = '<div style="font-weight:bold;">日志记录失败!</div>';
                }
            },
            failure: function(response, opts) {
                Ext.get("winLogin").unmask();
                var obj = "操作失败,错误代码:" + response.status + "," + "错误信息:" + response.statusText;
                alert(obj);
            }
        });
        
    }

    //取消按钮事件
    function cancel()
    {
        win.close();
    }
    

    
    win.on("show", function(){ initFocus(); });
    function initFocus()
    {
        var f = Ext.get("userName");
        f.focus.defer(100, f);
    }
    //Ext.get("eprform").hide();
    //将dll隐藏
    document.frames["eprlisteditordll"].setVisibility("hidden");
    win.show();    
    win.setHeight(155);
    Ext.getCmp("bbar").addText("");
    Ext.get("pwd").addKeyListener(
        { key: [10, 13] },
        function() {
            Ext.get("btnConfirm").focus();
            ajaxLogin();});
    //Ext.getCmp("userName").focus();    
}