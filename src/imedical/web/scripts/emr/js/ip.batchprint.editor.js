var iword = false;
var igrid = false;
//创建word编辑器
function wordDoc()
{
    if (!iword)
    {
        var objString = "<object id='browspluginWord' type='application/x-iemrplugin' style='width:0px;height:0px;padding:0px;'>"
        objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
        objString = objString + "<param name='product' value='GlobalEMR'/>";
        objString = objString + "</object>";
        document.getElementById("containerWord").innerHTML = objString;
        if (!pluginword()||!pluginword().valid)
        {
            setUpPlug();
        } 
        pluginAdd(); 
        pluginword().initWindow("iEmrClient");
        initEditor("iEditor");
        setConnect();
        iword = true;
    }
    //设置工作环境
    setWorkEnvironment();
    SetDefaultFontStyle();
    openDocument();
    setPatientInfo();
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
//创建gird编辑器
function girdDoc()
{
    if(!igrid)
    {
        var objString = "<object id='browspluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
        objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
        objString = objString + "<param name='product' value='GlobalEMR'/>";
        objString = objString + "</object>";   
        document.getElementById("containerGrid").innerHTML = objString;
        if (!plugingrid()||!plugingrid().valid)
        {
            setUpPlug();
        } 
        pluginAdd();
        plugingrid().initWindow("iEmrClient");
        initEditor("iGridEditor");
        setConnect();
        igrid = true;
    }
    setWorkEnvironment();
    //病案首页采集页打印
    var emrDocId = isMedicalRecord(envVar.BatchPrintList[0].emrDocId);
    if (emrDocId){
        getTempCateData(emrDocId.split("||")[1]);
    }else{
        openDocument();
    }
    setPatientInfo();
}

//是否为病案首页
function isMedicalRecord(emrDocId){
    var rtn = "";
    $.each(collectMedicalRecordConfig, function(index,val){
        if (emrDocId == val.split("||")[0] ){
            rtn = val;
            return false;
        }
    });
    return rtn;
}

//获取模板数据
function getTempCateData(tempDocID){
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType": "Stream",
            "Class": "EMRservice.BL.BLClientCategory",
            "Method": "GetTempCateJsonByDocID",
            "p1": tempDocID,
            "p2": envVar.BatchPrintList[0].id
        },
        success: function(d) {
            if (d != "") {
                tempParam = JSON.parse(d);
                doCreate();
            }
        },
        error: function() { 
            alert("getTempCateData error");
        }
    });
}

//创建
function doCreate(){
    var isMutex = (tempParam.isMutex=="1")?true:false;
    var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
    setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox);
    createDocument();
}

//设置创建模板
function setDocTempalte(emrDocId,isMutex,isGuideBox)
{
    var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox,"KBLoadMode":"Replace"}};
    cmdDoShellExecute(argJson);
}

//创建病历
function createDocument()
{
    var strJson = {action:"CREATE_DOCUMENT",args:{"params":{"TemplateID":tempParam.templateId,"TemplateVersion":tempParam.templateVersion},"Title":{"DisplayName":tempParam.text}}};
    cmdDoShellExecute(strJson);
}

function pluginword()
{
    return document.getElementById("browspluginWord");
}
function plugingrid()
{
    return document.getElementById("browspluginGrid");
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
    var param = envVar.BatchPrintList[0];
    if(param.pluginType == "DOC")
    {
        return pluginword();
    }else
    {
        return plugingrid();
    }
}

//异步执行execute
function cmdDoExecute(argJson)
{
    plugin().execute(JSON.stringify(argJson));
};

function cmdDoShellExecute(argJson)
{
    var argJson = {"action":"CLIENT_SHELL","args":argJson};
    plugin().execute(JSON.stringify(argJson));
}

//同步执行
function cmdSyncExecute(argJson)
{
    return plugin().syncExecute(JSON.stringify(argJson));
};

function cmdSyncShellExecute(argJson)
{
    var argJson = {"action":"CLIENT_SHELL","args":argJson};
    return plugin().syncExecute(JSON.stringify(argJson));
};
//设置加载环境
function setWorkEnvironment()
{
    
    //设置工作环境
    var strJson = {"action":"SET_WORKSPACE_CONTEXT","args": envVar.BatchPrintList[0].chartItemType};
    cmdDoShellExecute(strJson);
    
    //设置患者信息
    setPatientInfo();
    
    //设置书写状态
    argJson = {action:"SET_NOTE_STATE",args:"Browse"};
    cmdDoShellExecute(argJson);
}

function setConnect()
{
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
            alert('getNetConnectJson err');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
    var strJson = {action:"SET_NET_CONNECT",args:netConnect};
    cmdDoShellExecute(strJson);
}

//设置病历信息
function setPatientInfo()
{
    var productSource = {};
    productSource.FromCode = "";
    productSource.FromType = productSourceType;
    var argParams = {"PatientID":patientID,"EpisodeID":episodeID,"UserID":userID,"UserLocID":userLocID,"IPAddress":ipAddress,"ProductSource":productSource};
    var argJson = {"action": "SET_PATIENT_INFO","args":argParams};
    cmdDoShellExecute(argJson);
}

//加载文档
function openDocument()
{
    cleanDocument();
    var isLoadOne = envVar.BatchPrintList[0].isLeadframe=="1"?"N":"Y";
    var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":"BROWSE","isLoadOne":isLoadOne},InstanceID:envVar.BatchPrintList[0].id,actionType:"LOAD"}};
    cmdDoShellExecute(argJson);
}

//加载病历之前，先清空文档
function cleanDocument()
{
    var argJson = {"action":"CLEAN_DOCUMENT","args":""};
    cmdDoShellExecute(argJson);
}

//打印文档
function printDocument()
{
    if (isPrintDirectly == "Y") {
        var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"PrintDirectly"}}; 
    } else {
        var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print"}}; 
    }
    cmdDoShellExecute(argJson);
}

function initEditor(editor)
{
    var argJson = {"action":"CLIENT_INIT_MODULE","args":{"Name":editor}};
    cmdDoExecute(argJson);
}

//设置默认字体
function SetDefaultFontStyle(){
    var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
    cmdDoShellExecute(strJson);
}

///事件派发
function eventDispatch(obj)
{
    if (obj.action == "eventLoadDocument")
    {
        eventLoadDocument();
    }
    else if (obj.action == "eventCreateDocument")
    {
        eventCreateDocument(obj);
    }
    else if (obj.action == "eventPrintDocument")
    {
        if(obj["args"].result == "OK"){
            if(obj["args"].params.result == "OK"){
                if (typeof(parent.reloadMenu) == "function")
                {
                    parent.reloadMenu(envVar.BatchPrintList[0]["id"]);
                }
                if(typeof setOperationLog == "function"){
                    //基础平台组审计和日志记录
                    var paramContext = GetRecodeParamByInsID(envVar.BatchPrintList[0]["id"]);
                    setOperationLog(paramContext,"EMR.OnePrint.OK");
                }
            }
        }
        envVar.BatchPrintList.shift();
        var length = envVar.BatchPrintList.length;
        if (length == 0) {
            envVar.InsIDCount = 0;
            setPrintInfo("false");
            return doAfterBatchPrint();
        }
        batchPrintDocument();
    }
}

//打印病历
function eventLoadDocument()
{
    printDocument();
}

//创建文档事件
function eventCreateDocument(commandJson)
{
    if (commandJson["args"]["result"] == "OK")
    {
        var argJson = {"action":"PREVIEW_DOCUMENT","args":{"Preview":true}};
        cmdDoShellExecute(argJson);
        argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print","InstanceID":envVar.BatchPrintList[0]["id"],"params":{"TemplateID":tempParam.templateId,"TemplateVersion":tempParam.templateVersion}}};
        if (isPrintDirectly == "Y") {
            argJson.args.actionType = "PrintDirectly";
        }
        cmdDoShellExecute(argJson);
    }
}

/*根据实例ID获取实例详细信息*/
function GetRecodeParamByInsID(insID) {
    var result = "";
    jQuery.ajax({
            type: "GET", 
            dataType: "text",
            url: "../EMRservice.Ajax.common.cls",
            async: false,
            data: {
                "OutputType":"String",
                "Class":"EMRservice.Ajax.opInterface",
                "Method":"GetRecodeParamByInsID",
                "p1":insID
            },success: function(d) {
                result = eval("("+d+")");
            },error: function(d) {
                alert("GetRecodeParamByInsID error");
            }
        });
    return result;
}