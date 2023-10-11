$(function () {
    if (documentID){
        loadDocument();
    }
});

function loadDocument(){
    var args = {
        action: "LOAD_DOCUMENT",
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
    if (!document.getElementById("bsBrowseEditor").innerHTML || switchPluginType){
        currentPluginType = pluginType;
        EmrEditor.initEditor({
            rootID: "#bsBrowseEditor",
            product: product,
            patInfo: patInfo,
            parameters:{
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
        EmrEditor.execute(args);
        /*var commandJson = EmrEditor.syncExecute({action:"IS_LOADED",params:{documentID:documentID},product: product});
        if ("fail" === commandJson.result){
            $.messager.alert("发生错误", "判断当前病历是否已加载失败！", "error");
            console.log(commandJson);
        }else{
            if (commandJson.params){
                EmrEditor.syncExecute({action:"SET_POINT",params:{documentID:documentID,position:"start"},product: product});
            }else{
                EmrEditor.execute(args);
            }
        }*/
    }
}

var editorEvent = {
    eventloadglobalparameters: function(commandJson){
        if ("fail" === commandJson.result){
            console.log(commandJson);
        }
    },
    eventloaddocument: function(commandJson){
        if ("fail" === commandJson.result){
            $.messager.alert("发生错误", "加载病历失败！", "error");
            $("#bsBrowseEditor").css("display","none");
            console.log(commandJson);
            return;
        }
        var display = $("#bsBrowseEditor").css("display");
        if ("none" === display){
            $("#bsBrowseEditor").css("display","block");
        }
        if (autoPrint == "Y"){
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
                        silent: 1
                    }
                },
                callBack: callBack,
                product: product
            });
        }
    },
    eventPrintDocument: function(commandJson){
        if (autoPrint == "Y"){
            returnValue = commandJson;
            if (dialogID){
                parent.closeDialog(dialogID);
            }
        }
    }
};
