var iword = false;
var igrid = false;
var seq = 0;
$(function(){	
	load();	
});


//取病历目录
function load()
{
	wordDoc();
}

//创建word编辑器
function wordDoc()
{
	if (!iword)
	{
		var objString = "<object id='browspluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>"
		objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
		objString = objString + "<param name='product' value='GlobalEMR'/>";
		objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
	    if (!$("#browspluginWord")[0]||!$("#browspluginWord")[0].valid)
		{
			setUpPlug();
		} 
		pluginAdd(); 
		$("#browspluginWord")[0].initWindow("iEditor");
		//initEditor("iEditor");               
		setConnect();  
		iword = true;                             	
	}
	//设置工作环境
	setWorkEnvironment(); 
    SetDefaultFontStyle();
	openDocument();
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
	return $("#browspluginWord")[0];
}

//异步执行execute
function cmdDoExecute(argJson)
{
	plugin().execute(JSON.stringify(argJson));
};

//同步执行
function cmdSyncExecute(argJson)
{
	return plugin().syncExecute(JSON.stringify(argJson));
};

//设置加载环境
function setWorkEnvironment()
{
	
	//设置工作环境
	var strJson = {"action":"SET_WORKSPACE_CONTEXT","args":"Multiple"};
	cmdDoExecute(strJson);
	//设置书写状态
	argJson = {action:"SET_NOTE_STATE",args:"Edit"};
	cmdDoExecute(argJson);	
	//设置文字只读颜色
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"000000"}};
	cmdDoExecute(argJson);
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
			alert('get err');
			if (!onError) {}
			else {
				onError(ret);
			}
		}
	});
	var argJson = {action:"SET_NET_CONNECT",args:netConnect};
	cmdDoExecute(argJson);	
}

//设置病历信息
function setPatientInfo()
{
	var argParams = {"PatientID":patientId,"EpisodeID":episodeId,"UserID":userId};
	var argJson = {"action": "SET_PATIENT_INFO","args":argParams};
    cmdDoExecute(argJson);
}

//加载文档
function openDocument()
{
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"LoadType":"patient","PatientID":patientId,"LocID":locId},InstanceID:"1||1",actionType:"LOAD"}};
	cmdDoExecute(argJson);	
}

//打印文档
function printDocument()
{
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"PrintDirectly"}}; 
	cmdDoExecute(argJson);
}

function initEditor(editor)
{
	var argJson = {"action":"CLIENT_INIT_MODULE","args":{"Name":editor}};
	cmdDoExecute(argJson);
}

//设置默认字体
function SetDefaultFontStyle(){
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
}

///事件派发
function eventDispatch(obj)
{
	if (obj.action == "eventLoadDocument")
	{
		eventLoadDocument();
	}
}

//打印病历
function eventLoadDocument()
{
	argJson = {action:"SET_READONLY", args:{"ReadOnly":true}};
	cmdDoExecute(argJson);	
}

//关闭窗口
function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}