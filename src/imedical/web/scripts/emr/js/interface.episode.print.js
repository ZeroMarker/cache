var iword = false;
var igrid = false;
var seq = 0;
$(function(){	
	load();	
});


//ȡ����Ŀ¼
function load()
{
    if (versionID == "4"){
        EmrEditor.initEditor({
            rootID: "#containerWord",
            product: product,
            patInfo: {
                episodeID: episodeId,
                userID: userID,
                userName: userName,
                userLocID: userLocID,
                ssgroupID: ssgroupID,
                ipAddress: ipAddress,
                pmdType: pmdType,
                pmdCode: pmdCode
            },
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
            pluginType: "WORD",
            editorEvent: editorEvent,
            commandJson: {
                action: "LOAD_DOCUMENT_BYEPISODEID",
                params: {
                    episodeID: episodeId,
                    userLocID: userLocID,
                    ssgroupID: ssgroupID,
                    order: "",
                    status: "Sign"
                },
                type: {
                    serial: "2"
                },
                product: product
            }
        });
    }else{
        wordDoc();
    }
}

var editorEvent = {
    eventloadglobalparameters: function(commandJson){
        if ("fail" === commandJson.result){
            console.log(commandJson);
        }
    },
    eventLoadDocumentByEpisodeID: function(commandJson){
        if ("fail" === commandJson.result){
            alert("���ز���ʧ�ܣ�");
            $("#containerWord").css("display","none");
            return;
        }
        var display = $("#containerWord").css("display");
        if ("none" === display){
            $("#containerWord").css("display","block");
        }
        printDocumentID = commandJson.params.documentID;
        if (PrintFlag == "Y") {
            printDocument();
        }
    }
};

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
	if (PrintFlag=="Y") {
		printDocument();
	}
}

//��ӡ�ĵ�
function printDocument()
{
    if (versionID == "4"){
        if (printDocumentID.length > 0){
            var commandJson = EmrEditor.syncExecute({
                action:"PRINT_DOCUMENT",
                params: {
                    documentID: printDocumentID
                },
                product: product
            });
            if ("fail" === commandJson.result){
                console.log(commandJson);
                alert("��������", "��ӡʧ��");
                return;
            }
            /*��¼��ӡ��־
            var data = {
                action: "PRINT_ENCDOCUMENT",
                param: {
                    documentID: printDocumentID,
                    userID: userID,
                    userLocID: userLocID,
                    ipAddress: ipAddress,
                    pmdType: pmdType,
                    pmdCode: pmdCode
                },
                product: product
            };
            ajaxGETCommon(data, function(ret){
                if (PrintFlag === "Y"){
                    parent.closedialog();
                }
            }, function (error) {
                alert("�������� printDcoument error:"+error);
            }, false);*/
            if (PrintFlag === "Y"){
                parent.closedialog();
            }
        }
        return;
    }
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
		
		//�ش���Ϣ;
		setPatientInfo();
		
		var argJson = {action:"LOAD_DOCUMENT",args:{params:{"LoadType":"","PatientID":patientId,"EpisodeID":episodeId,"LocID":userLocID},InstanceID:instanceID,actionType:"LOAD"}};
		cmdDoExecute(argJson);
        var printActionType = "Print";
        if (PrintFlag=="Y") {
            printActionType = "PrintDirectly";
        }
		var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":printActionType}};
		cmdDoExecute(argJson); 
		
		
	}
	if (PrintFlag=="Y") {
		parent.closedialog();
	}else{
		//���¼��ػز���
		openDocument();
	}
	
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

function ajaxGETCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls",
        async: isAsync,
        cache: false,
        data: {"paramdata":JSON.stringify(data)},
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        alert("��������ʧ����ʾ��"+ret.errorMessage);
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }
            }else{
                alert("ajaxGETCommon:����ʧ�ܣ�"+JSON.stringify(ret));
            }
        },
        error: function (ret) {
            if (!onError) {
                alert("�����������ajaxGETCommon error:"+JSON.stringify(ret));
            }else {
                onError(ret);
            }
        }
    });
}
