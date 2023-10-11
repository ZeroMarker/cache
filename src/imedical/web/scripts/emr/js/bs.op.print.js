$(function () {
    try {
        if (autoPrint === "Y"){
            $("body").layout("panel","south").panel("resize",{height:1});
            $("body").layout("panel","center").panel("resize",{height:10,width:10});
            $("body").layout("resize");
        }
        $("#btnClose").bind("click", function(){
            if (isPrinting){
                return;
            }
            closeWindow();
        });
        if (documentID){
            browseDocument();
        }
    }catch (e) {
        $.messager.alert("发生错误", "发生错误:" + e.message, "error");
        closeWindow();
    }
});

//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open("", "_self");
    window.close();
}

function browseDocument(){
    var args = {
        action: "BROWSE_DOCUMENT",
        params: {
            documentID: documentID,
            pluginType: pluginType
        },
        type: {
            serial: serial,
            leadframe: leadframe
        },
        product: product
    };
    var switchPluginType = false;
    if (pluginType != currentPluginType){
        switchPluginType = true;
    }
    if (!document.getElementById("bsPrintEditor").innerHTML || switchPluginType){
        currentPluginType = pluginType;
        EmrEditor.initEditor({
            rootID: '#bsPrintEditor',
            product: product,
            patInfo: {
                pmdType: pmdType,
                pmdCode: pmdCode,
                ipAddress: ipAddress,
                creatorName: creatorName
            },
            parameters: {
                status: "browse",
                region: "content",
                revise: {
                    del: {
                        show: "0"
                    },
                    add: {
                        show: "0"
                    },
                    style: {
                        show: "0"
                    }
                }
            },
            pluginType: pluginType,
            MWToken: getMWToken(),
            editorEvent: editorEvent,
            commandJson: args
        });
    }else{
        var commandJson = EmrEditor.syncExecute(args);
        editorEvent.eventbrowsedocument(commandJson);
    }
}

var editorEvent = {
    eventloadglobalparameters: function(commandJson){
        if ("fail" === commandJson.result){
            console.log(commandJson);
        }
    },
    eventbrowsedocument: function(commandJson){
        if ("fail" === commandJson.result){
            $.messager.alert("发生错误", "浏览病历失败！", "error");
            $("#bsPrintEditor").css("display","none");
            console.log(commandJson);
            return;
        }
        var display = $("#bsPrintEditor").css("display");
        if ("none" === display){
            $("#bsPrintEditor").css("display","block");
        }
        printDocumentID = commandJson.params.documentID;
        if (autoPrint === "Y"){
            printDoc();
        }else{
            bindBtnPrint();
        }
    },
    eventPrintDocument: function(commandJson){
        isPrinting = false;
        console.log(commandJson);
        //记录打印日志
        var data = {
            action: "PRINT_DOCUMENT",
            params: {
                documentID: commandJson.args.documentID,
                printType: printType,
                pmdType: pmdType,
                pmdCode: pmdCode,
                ipAddress: ipAddress,
                creatorName: creatorName
            },
            product: product
        };
        ajaxGETCommon(data, function(ret){
            if (ret != "1"){
                $.messager.alert("提示信息", "打印日志保存失败！","error");
                return;
            }
            if (autoClose === "Y"){
                closeWindow();
            }
        }, function (error) {
            $.messager.alert("发生错误", "printDcoument error:"+error, "error");
        }, true);
    }
};

function bindBtnPrint(){
    $("#btnPrint").bind("click", function(){
        isPrinting = true;
        printDoc();
    });
}

function printDoc(){
    if (printDocumentID.length > 0){
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
                    silent: 1,
                    args: {
                        printDocumentID: printDocumentID
                    }
                }
            },
            callBack: callBack,
            product: product
        });
    }
}
