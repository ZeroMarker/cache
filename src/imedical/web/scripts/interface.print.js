var iword = false;
var igrid = false;
var param = "";
var params = new Array();
var seq = 0;
$(function(){	
	init(episodeId,catalogId);	
});

function init(episodeId,catalogId)
{
	$.ajax({
		type: "POST",
		dataType: 'json',
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		cache: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.HISInterface.CentralizedPrint",
			"Method":"GetLoadRecordParam",
			"p1":episodeId,
			"p2":catalogId
		},
		success: function(d){
			if ((d != null)&&(d != ""))
			{
				params = d;
				if (params.length >0) load(params[seq]);	
			}
			
		},
		error : function(d) { alert(" error");}
	});		
}

//取病历目录
function load(data)
{
    param = data;
	if (param.pluginType == "DOC")
	{
		wordDoc();
	}
	else if (param.pluginType == "GRID")
	{
		girdDoc();
	}	
}


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
	    if (!$("#browspluginWord")[0].initWindow)
		{
			setUpPlug();
		} 
		pluginAdd(); 
		$("#browspluginWord")[0].initWindow("iEmrClient");
		initEditor("iEditor");               
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
	    if (!$("#browspluginGrid")[0].initWindow)
		{
			setUpPlug();
		} 
		pluginAdd();                            
		//$("#browspluginGrid")[0].initWindow("iGridEditor");  //创建表格编辑器
		$("#browspluginGrid")[0].initWindow("iEmrClient");
		initEditor("iGridEditor");
		setConnect();
		igrid = true;                         //创建视图
	}
	setWorkEnvironment();
	openDocument();	
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
	var strJson = {"action":"SET_WORKSPACE_CONTEXT","args": param.chartItemType};
	cmdDoShellExecute(strJson);
	//设置书写状态
	argJson = {action:"SET_NOTE_STATE",args:"Browse"};
	cmdDoShellExecute(argJson);	
}

function setConnect()
{
	var netConnect = "";
	$.ajax({
		type: 'Post',
		dataType: 'text',
		url: '../EMRservice.Ajax.common.cls',
		async: false,
		cache: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetNetConnectJson"
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
	cmdDoShellExecute(strJson);	
}

//设置病历信息
function setPatientInfo()
{
	var argParams = {"PatientID":patientId,"EpisodeID":episodeId,"UserID":userId};
	var argJson = {"action": "SET_PATIENT_INFO","args":argParams};
    cmdDoShellExecute(argJson);
}

//加载文档
function openDocument()
{
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":"BROWSE"},InstanceID:param.id,actionType:"LOAD"}};
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
	cmdDoExecute(strJson);
}

///事件派发
function eventDispatch(obj)
{
	if (obj.action == "eventLoadDocument")
	{
		eventLoadDocument();
	}
	else if (obj.action == "eventPrintDocument")
	{
		seq = seq + 1;
		if (seq < params.length)
		{
			load(params[seq]);
		}
		else
		{
			try
			{
				parent.printNext();
			}
			catch(err)
			{
				closeWindow();
			}
		}
	}
}

//打印病历
function eventLoadDocument()
{
	printDocument();
}

//关闭窗口
function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}