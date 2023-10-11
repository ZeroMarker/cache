function initPnlButton(){
    $('#auditUsrCombo').combobox({
        valueField:'ID',
        textField:'Name',
        panelHeight:"auto"
    });
    initAuditList();
    liveBtnBind();
}

//审核人列表
function initAuditList(){
    var data = {
        action: "GET_SSUSERBYLOCID",
        params:{
            userLocID: patInfo.userLocID,
            userID: patInfo.userID
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(ret){
        if (ret.length > 0){
            $("#auditUsrCombo").combobox({data:ret});
        }
    }, function (error) {
        $.messager.alert("发生错误", "initAuditList error:"+error, "error");
    }, true);
}

function liveBtnBind(){
    var isBtnClicked = false;
    $('#pnlButton a').on('click', function() {
        if (isBtnClicked) {
            return;
        }
        isBtnClicked = true;
        setTimeout(function(){
            isBtnClicked = false;
        }, 2000);

        var fnBtnClick = btnClick[$(this).attr('id')];
        if ('function' == typeof fnBtnClick) {
            fnBtnClick();
        }
        $("#"+$(this).attr('id')).linkbutton('unselect');
    });
    var btnClick = new function() {
        // 审核并打印
        this.btnAuditAndPrint = function() {
            btnClick.btnOpOfficeAudit(true);
        };

        // 审核
        this.btnOpOfficeAudit = function(printFlag) {
            if (envVar.documentID == ""){
                return false;
            }
            var selectedRow = $('#patientListData').datagrid('getSelected');
            if (selectedRow.DocumentID !== envVar.documentID){
                $.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
                return false;
            }
            var insertAuditLog = function(flag) {
                var data = {
                    action: "INSERT_DIAGAUDITLOG",
                    params:{
                        documentID: envVar.documentID,
                        auditUserID: auditUserID,
                        userID: patInfo.userID,
                        status: "checked",
                        ipAddress: patInfo.ipAddress
                    },
                    product: envVar.product
                };
                ajaxGETCommon(data, function(ret){
                    if (ret == "1"){
                        var rowIndex = $('#patientListData').datagrid('getRowIndex',selectedRow);
                        $('#patientListData').datagrid('updateRow',{
                            index: rowIndex,
                            row: {
                                AuditStatus: emrTrans('已审核')
                            }
                        });
                        $.messager.alert("提示信息", "审核成功", 'info');
                        $('#btnPrint').linkbutton('enable');
                        $('#btnRefuse').linkbutton('disable');
                        if (flag){
                            printDocument();
                        }
                    }
                }, function (error) {
                    $.messager.alert("发生错误", "insertAuditLog error:"+error, "error");
                }, false);
            };
            var showAuditLog = function(flag) {
                var data = {
                    action: "GET_DIAGAUDITLOG",
                    params:{
                        documentID: envVar.documentID
                    },
                    product: envVar.product
                };
                ajaxGETCommon(data, function(ret){
                    if (ret.total > 0){
                        var msg = '已审核' + ret.total + '次：<br/>';
                        $.each(ret.auditMessage,function(index,message){
                            //msg += '第'+ (index+1) + '次：' + message + '\r\n';
                            msg += message + '<br/>';
                        });
                        top.$.messager.alert("提示信息", msg, 'info');
                    }
                    insertAuditLog(flag);
                }, function (error) {
                    $.messager.alert("发生错误", "showAuditLog error:"+error, "error");
                }, false);
            };
            //获取审核人ID
            var auditUserID = $('#auditUsrCombo').combobox("getValue");
            if (auditUserID == ""){
                $.messager.alert("提示信息", "未选择审核人", "info");
            }else {
                printFlag = printFlag || false;
                showAuditLog(printFlag);
            }
        };

        // 打印
        this.btnPrint = function() {
            if (envVar.documentID == ""){
                return;
            }
            var selectedRow = $('#patientListData').datagrid('getSelected');
            if (selectedRow.DocumentID !== envVar.documentID){
                $.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
                return;
            }
            printDocument();
        };

        // 拒绝
        this.btnRefuse = function() {
            if (envVar.documentID == ""){
                return;
            }
            var selectedRow = $('#patientListData').datagrid('getSelected');
            if (selectedRow.DocumentID !== envVar.documentID){
                $.messager.alert("提示信息", "左侧列表选中值与右侧病历不是同一记录，不允许进行操作，请重新打开病历", 'info');
                return;
            }
            var insertRefuse = function(){
                var data = {
                    action: "INSERT_DIAGAUDITLOG",
                    params:{
                        documentID: envVar.documentID,
                        auditUserID: auditUserID,
                        userID: patInfo.userID,
                        status: "refused",
                        ipAddress: patInfo.ipAddress
                    },
                    product: envVar.product
                };
                ajaxGETCommon(data, function(ret){
                    if (ret == "1"){
                        var rowIndex = $('#patientListData').datagrid('getRowIndex',selectedRow);
                        $('#patientListData').datagrid('updateRow',{
                            index: rowIndex,
                            row: {
                                AuditStatus: emrTrans('已拒绝')
                            }
                        });
                        $.messager.alert("提示信息", "拒绝成功", 'info');
                        $('#btnAuditAndPrint').linkbutton('disable');
                        $('#btnOpOfficeAudit').linkbutton('disable');
                        $('#btnRefuse').linkbutton('disable');
                    }
                }, function (error) {
                    $.messager.alert("发生错误", "insertRefuse error:"+error, "error");
                }, true);
            };
            var auditUserID = $('#auditUsrCombo').combobox("getValue");
            if (auditUserID == ""){
                $.messager.alert("提示信息", "未选择审核人", "info");
                return;
            }else {
                insertRefuse();
            }
        };

        // 显示留痕
        this.btnViewRevision = function() {
            var viewRevision = function(canViewRevise){
                var reviseValue = sysOption.revise;
                reviseValue.del.show = canViewRevise;
                reviseValue.add.show = canViewRevise;
                reviseValue.style.show = canViewRevise;
                EmrEditor.syncExecute({
                    action:"SET_PARAMETERS",
                    params:{
                        revise: reviseValue,
                        revisePrint: canViewRevise
                    },
                    product: envVar.product
                });
            };
            if ($("#btnViewRevision").text() == emrTrans("显示留痕")) {
                $('#btnViewRevision').linkbutton({
                    text : emrTrans('隐藏留痕')
                });
                viewRevision("1");
            } else {
                $('#btnViewRevision').linkbutton({
                    text : emrTrans('显示留痕')
                });
                viewRevision("0");
            }
        };

        // 病历浏览
        this.btnBrowse = function() {
            var width = window.screen.availWidth - 250;
            var height = window.screen.availHeight - 250;
            createModalDialog("browseModal","病历浏览",width,height,"iframeBrowse",'<iframe id="iframeBrowse" scrolling="auto" frameborder="0" src="websys.chartbook.hisui.csp?PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse&EpisodeID='+patInfo.episodeID+"&product="+envVar.product+"&MWToken="+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
        };
    };
}

function setPnlBtnDisable(flag){
    if (flag){
        //锁定按钮
        $('#btnAuditAndPrint').linkbutton('disable');
        $('#btnOpOfficeAudit').linkbutton('disable');
        $('#btnPrint').linkbutton('disable');
        $('#btnRefuse').linkbutton('disable');
        $('#btnViewRevision').linkbutton('disable');
        $('#btnBrowse').linkbutton('disable');
    }
}

function printDocument(){
    var callBack = {
        response: function(commandJson){
            console.log("print-response:", commandJson);
            var type = commandJson.params.type;
            if (type === "3"){
                $.messager.alert("打印提示", "打印任务正在进行中... ...", "info");
            }
            if (type == "4"){
                var data = commandJson.params.data;
                $.messager.alert("打印提示", "打印传参错误："+data, "info");
            }
        },
        reject: function(commandJson){
            console.log("print-reject:",commandJson);
            if ('undefined' != typeof commandJson.error.errorCode){
                createModalDialog("Web-Print-PluginDialog","下载打印插件",600,600,"Web-Print-PluginFrame",'<iframe id="Web-Print-PluginFrame" scrolling="auto" frameborder="0" src="emr.bs.printplugin.csp?MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
            }else{
                $.messager.alert("发生错误", "打印失败！", "error");
            }
        }
    };
    EmrEditor.syncExecute({
        action: "PRINT_DOCUMENT",
        params: {
            printer: {
                silent: 0
            }
        },
        callBack: callBack,
        product: envVar.product
    });
}