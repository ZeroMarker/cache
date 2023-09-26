var iword = false;
var igrid = false;
var seq = 0;
$(function(){	
	load();	
});


//ȡ����Ŀ¼
function load()
{
	wordDoc();
}

//����word�༭��
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
	//���ù�������
	setWorkEnvironment(); 
    SetDefaultFontStyle();
	openDocument();
}

//��װ�����ʾ
function setUpPlug()
{
	var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl="+pluginUrl,"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
	if (result)
	{
		window.location.reload();
	}
}

//�ҽӲ��\�¼�����
function pluginAdd() {
	addEvent(plugin(), 'onFailure', function(command){alert(command);});
    addEvent(plugin(), 'onExecute', function(command){
	    var obj = JSON.parse(command);
	    eventDispatch(obj);		
	});
}
//��Ӽ����¼�
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
//���Ҳ��
function plugin() {
	return $("#browspluginWord")[0];
}

//�첽ִ��execute
function cmdDoExecute(argJson)
{
	plugin().execute(JSON.stringify(argJson));
};

//ͬ��ִ��
function cmdSyncExecute(argJson)
{
	return plugin().syncExecute(JSON.stringify(argJson));
};

//���ü��ػ���
function setWorkEnvironment()
{
	
	//���ù�������
	var strJson = {"action":"SET_WORKSPACE_CONTEXT","args":"Multiple"};
	cmdDoExecute(strJson);
	
	setPatientInfo()
	
	//������д״̬
	argJson = {action:"SET_NOTE_STATE",args:"Edit"};
	cmdDoExecute(argJson);	
	//��������ֻ����ɫ
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"000000"}};
	cmdDoExecute(argJson);
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
	var argJson = {action:"SET_NET_CONNECT",args:netConnect};
	cmdDoExecute(argJson);	
}

//���ò�����Ϣ
function setPatientInfo()
{
	///var argParams = {"PatientID":patientId,"EpisodeID":episodeId,"UserID":userId};
	
	var argParams = {"DiseaseID":"0","PatientID":patientId,"EpisodeID":episodeId,"UserCode":userCode,"UserID":userID,"UserName":userName,"SsgroupID":ssgroupID,"UserLocID":userLocID,"IPAddress":ipAddress};
    
    debugger;
	var argJson = {"action": "SET_PATIENT_INFO","args":argParams};
    cmdDoExecute(argJson);
    
}


//�����ĵ�
function openDocument()
{

	//����ĵ�
	var argJson = {action:"CLEAN_DOCUMENT",args:""};
	cmdDoExecute(argJson);
	
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"LoadType":"episode","PatientID":patientId,"EpisodeID":episodeId,"LocID":userLocID},InstanceID:"1||1",actionType:"LOAD"}};
	cmdDoExecute(argJson);	
}

//��ӡ�ĵ�
function printDocument()
{
	
	
	var instanceIDs = "";
	
	$.ajax({
		type: 'Post',
		dataType: 'text',
		url: '../EMRservice.Ajax.common.cls',
		async: false,
		cache: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLOPInterfaceService",
			"Method":"GetInstanceIDByEpisodeID",
			"p1":episodeId
		},
		success: function (ret) {
			//����ʵ������
			
			instanceIDs = ret.split("^");
			
		},
		error: function (ret) {
			alert('get ');
		}
	});
	
	for (var i=0;i<instanceIDs.length;i++) 
	{
		
		//����ĵ�
		var argJson = {action:"CLEAN_DOCUMENT",args:""};
		cmdDoExecute(argJson);
	
		instanceID=instanceIDs[i];
		
		var argJson = {action:"LOAD_DOCUMENT",args:{params:{"LoadType":"","PatientID":patientId,"EpisodeID":episodeId,"LocID":userLocID},InstanceID:instanceID,actionType:"LOAD"}};
		cmdDoExecute(argJson);
		
		var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print"}}; 
		cmdDoExecute(argJson); 
		
		
	}
	
	//���¼��ػز���
	openDocument()
	
}

function initEditor(editor)
{
	var argJson = {"action":"CLIENT_INIT_MODULE","args":{"Name":editor}};
	cmdDoExecute(argJson);
}

//����Ĭ������
function SetDefaultFontStyle(){
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
}

///�¼��ɷ�
function eventDispatch(obj)
{
	if (obj.action == "eventLoadDocument")
	{
		eventLoadDocument();
	}
	
}

//��ӡ����
function eventLoadDocument()
{
	argJson = {action:"SET_READONLY", args:{"ReadOnly":true}};
	cmdDoExecute(argJson);	
}


//�رմ���
function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}