var loadFalg = false;
var loadContainer = "";

//加载文档
function loadDocument(tempParam)
{
    var privileges = getPrivilege("BrowsePrivilege",tempParam.id);
    if (privileges.canView == "0")
    {
        $("#promptMessage").css("display","block");
        $("#promptMessage").html('您没有权限查看 "'+tempParam.text+'"');
        return;
    }
    else
    {
        $("#promptMessage").css("display","none");
    }
    if ((param != "") && (tempParam.emrDocId == param.emrDocId) && (tempParam.characteristic == "1"))
    {
       focusDocument(tempParam.id,"","First");
       param = tempParam;
    }
    else
    {
        //判断上一个文档是后加载完成
        if (loadFalg) 
        {
            loadContainer = tempParam;
            return;
        }
        loadContainer = "";
        loadFalg = true;
        param = tempParam;
        switch (param.pluginType)
        {
            case "DOC":
                wordDoc();
                break;
            case "GRID":
                girdDoc();
                break;
        }
    }
    setDataToLog("EMR.Browse");
}

///创建编辑器//////////////////////////////////////////////////////////////////////////////////////
//创建word编辑器
function wordDoc()
{
    if(iword)
    {
        $("#containerGrid").css("display","none");
    }
    $("#containerWord").css("display","block");
    if (!iword)
    {
        var objString = "<object id='browspluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>"
        objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
        objString = objString + "<param name='product' value='GlobalEMR'/>";
        objString = objString + "</object>";
        document.getElementById("containerWord").innerHTML = objString;
        if (!$("#browspluginWord")[0].initWindow)
        {
            setUpPlug();
        } 
        pluginAdd(); 
        $("#browspluginWord")[0].initWindow("iEditor");
        init();
        iword = true;
    }
    //设置工作环境
    setWorkEnvironment(); 
    openDocument();
    setReadOnly();
}

//创建gird编辑器
function girdDoc()
{
    $("#containerWord").css("display","none");
    $("#containerGrid").css("display","block");
    if(!igrid)
    {
        var objString = "<object id='browspluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
        objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
        objString = objString + "<param name='product' value='GlobalEMR'/>";
        objString = objString + "</object>";
        document.getElementById("containerGrid").innerHTML = objString;
        if (!$("#browspluginGrid")[0].initWindow)
        {
            setUpPlug();
        } 
        pluginAdd();
        $("#browspluginGrid")[0].initWindow("iGridEditor");  //创建表格编辑器
        init();
        igrid = true;
    }
    setWorkEnvironment();
    openDocument();
    setReadOnly();
}
//加载文档
function openDocument()
{
    if (param.status == "BROWSE")
    {
        getPrivateDomains(param.id,ssgroupID,"VIEW");
    }
    var argJson = {action:"LOAD_DOCUMENT",args:{params:{"LoadType":"CategoryBrowse","EpisodeIDs":episodeIDs,"DocID":param.emrDocId,"status":param.status},InstanceID:param.id,actionType:"LOAD"}};
    cmdDoExecute(argJson);
}

//设置只读
function setReadOnly()
{
    argJson = {action:"SET_READONLY",args:{"ReadOnly":true}}
    cmdDoExecute(argJson);
}

//安装插件提示
function setUpPlug()
{
    var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl="+pluginUrl,"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
    if (result)
    {
        window.location.reload();
    }
}
//挂接插件\事件监听
function pluginAdd() {
    addEvent(plugin(), 'onFailure', function(command){alert(command);});
    addEvent(plugin(), 'onExecute', function(command){
        var obj = JSON.parse(command);
        eventDispatch(obj);
    });
}

//添加监听事件
function addEvent(obj, name, func)
{
    if (obj.attachEvent) 
    {
        obj.attachEvent("on"+name, func);
    }  
    else 
    {
        obj.addEventListener(name, func, false); 
    }
}

//查找插件
function plugin() {
    if(param.pluginType == "DOC")
    {
        return $("#browspluginWord")[0];
    }else
    {
        return $("#browspluginGrid")[0];
    }
}

//异步执行execute
function cmdDoExecute(argJson){
    plugin().execute(JSON.stringify(argJson));
};

//同步执行
function cmdSyncExecute(argJson){
    return plugin().syncExecute(JSON.stringify(argJson));
};
function init()
{
    //建立数据连接
    setConnect();
    //设置文字只读颜色
    var argJson = {action:"SET_READONLY_COLOR",args:{"color":"#000000"}};
    cmdDoExecute(argJson);
}
//设置加载环境
function setWorkEnvironment()
{
    //清空文档
    var argJson = {action:"CLEAN_DOCUMENT",args:""};
    cmdDoExecute(argJson);
    //设置工作环境
    var argJson = {"action":"SET_WORKSPACE_CONTEXT","args": param.chartItemType};
    cmdDoExecute(argJson);
    //设置书写状态
    var argJson = {action:"SET_NOTE_STATE",args:"Browse"};
    cmdDoExecute(argJson);
    //设置默认字体
    var argJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
    cmdDoExecute(argJson);
    //设置参数
    var argJson = {action: "SET_PATIENT_INFO",args:{"PatientID":patientID,"EpisodeID":episodeID,"UserID":userID,"UserName":userName,"userLocID":userLocID,"SsgroupID":ssgroupID,"IPAddress":ipAddress}};
    cmdDoExecute(argJson);
}

//建立数据库连接
function setConnect(){
    var netConnect = "";
	
	var port = window.location.port;
	var protocol = window.location.protocol.split(":")[0];
	
	if (protocol == "http")
	{
		port = port==""?"80":port;
	}
	else if (protocol == "https")
	{
		port = port==""?"443":port;
	}
	
	
    $.ajax({
        type: 'Post',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: false,
        cache: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLSysOption",
            "Method":"GetNetConnectJson",
			"p1":window.location.hostname,
			"p2":port,
			"p3":protocol
        },
        success: function (ret) {

            netConnect = eval("("+ret+")");
        },
        error: function (ret) {
            alert('get err');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
    var strJson = {action:"SET_NET_CONNECT",args:netConnect};
    return cmdSyncExecute(strJson);
}

//定位文档
function focusDocument(instanceId,path,actionType)
{
    var argJson = {action:"FOCUS_ELEMENT",args:{"InstanceID":instanceId,"Path":path,"actionType":actionType}}
    cmdDoExecute(argJson);
}

//隐私保护元素集合
function getPrivateDomains(InstanceId,groupId,operation)
{
    var argJson = {action:"LOAD_PRIVACY_ELEMENTS",args:{"params":{"InstanceID":InstanceId,"SSgroupID":groupId,"Operation":operation}}};
    return cmdSyncExecute(argJson);
}

//打印文档
function printDocument()
{
    var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"PrintDirectly"}}; 
    cmdDoExecute(argJson);
}

///脚本权限
function getPrivilege(type,instanceId)
{
    var result = "0";
    jQuery.ajax({
        type: "GET",
        dataType: "text",
        url: "../EMRservice.Ajax.privilege.cls",
        async: false,
        data: {
            "EpisodeID":  episodeID,
            "PatientID":  patientID,
            "InstanceID": instanceId,
            "Type":       type
        },
        success: function(d) {
            if (d != "") result = eval("("+d+")");
        },
        error : function(d) { alert(type + " error");}
    });
    return result;
}
///事件派发
function eventDispatch(commandJson)
{
    if (commandJson["action"] == "eventLoadDocument")
    {
        eventLoadDocument(commandJson);
    }else if(commandJson["action"] == "eventDocumentChanged")        
    {
        //文档改变
        eventDocumentChanged(commandJson);
    }else if (commandJson["action"] == "eventPrintDocument")
    {
        eventPrintDocument(commandJson);
    }
}

//文档加载成功事件
function eventLoadDocument(commandJson)
{
    loadFalg = false;
    if (commandJson["args"].result == "OK")
    {
        //setReadOnly();
    }
    //加载待加载的文档
    if (loadContainer != "")
    {
        loadDocument(loadContainer);
    }
    focusDocument(commandJson.args.InstanceID,"","First");
}

//文档改变事件
function eventDocumentChanged(commandJson)
{
    //更新当前实例文档ID
    param.id = commandJson["args"]["InstanceID"]; 
    param.text = commandJson["args"]["Title"]["DisplayName"];
    //选中当前文档目录
    selectListRecord(param.id);
}

//打印事件监听
function eventPrintDocument(commandJson) {
    if (commandJson.args.result == 'OK') {
        if (commandJson.args.params.result == "OK") {
            $.messager.popover({msg:'病历打印成功！', type:'success', style:{top:10,right:5}});
            //修改病历目录
            setListPrinted(commandJson.args.params.PrintInstanceIDs);
            
            //基础平台组审计和日志记录
            setDataToLog("EMR.Print.OK");
        }else if(commandJson["args"].params.result == "ERROR")
        {
            $.messager.alert('发生错误', '打印日志未记录,请检查网络连接！', 'warning');
        }
    }else if(commandJson["args"].result == "ERROR")
    {
        //插件返回值只有2个 
        //OK 打印成功 
        //ERROR，可能为取消打印，或网络原因导致打印失败。
        //修改描述'打印日志未记录,请检查网络连接!' 为‘打印操作未完成’，增加友好度。
        $.messager.alert('发生错误', '打印操作未完成！', 'error');
    }
}
    
function setDataToLog(ModelName)
{
    if (IsSetToLog == "Y")
    {
        var Condition = "";
        Condition = Condition + '{"patientID":"' + patientID + '",';
        Condition = Condition + '"episodeID":"' + episodeID + '",';
        Condition = Condition + '"userName":"' + userName + '",';
        Condition = Condition + '"userID":"' + userID + '",';
        Condition = Condition + '"ipAddress":"' + ipAddress + '",';
        Condition = Condition + '"id":"' + param["id"] + '",';
        Condition = Condition + '"pluginType":"' + param["pluginType"] + '",';
        Condition = Condition + '"chartItemType":"' + param["chartItemType"] + '",';
        Condition = Condition + '"emrDocId":"' + param["emrDocId"] + '",';
        Condition = Condition + '"templateId":"' + param["templateId"] + '",';
        Condition = Condition + '"categoryId":"' + param["categoryId"] + '",';
        Condition = Condition + '"isLeadframe":"' + param["isLeadframe"] + '",';
        Condition = Condition + '"isMutex":"' + param["isMutex"] + '",';
        Condition = Condition + '"actionType":"' + param["actionType"] + '",';
        Condition = Condition + '"status":"' + param["status"] + '",';
        Condition = Condition + '"text":"' + param["text"] + '"}';
        var ConditionAndContent = Condition;
        $.ajax({ 
            type: "POST", 
            url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
            data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + ""
        });
    }
}