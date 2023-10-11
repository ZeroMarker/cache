//��ʼ��ҳ��
function InitDocument(tempParam)
{  
	//�ж���һ���ĵ��Ǻ�������
	if (loadFalg ) return;
    
    //����״̬
	initStatus();
	
	//Ȩ�޼��
	if (tempParam.actionType == "LOAD")
	{
		if (checkLoadPrivilege(tempParam,true)) return;      //����ҩ��Ȩ��
	}
	else
	{
		if(checkCreatePrivilege(tempParam,true)) return;     //����ҩ��Ȩ��
	}
	
	//����,��������
	if (param != "")
	{	
		if (savePrompt("") == "cancel") return;           //���ѱ���ҩ��
		if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
		{         
			unLock(lockinfo.LockID);                        //����
		}
	}
	

	if ((param.status != tempParam.status)||(tempParam.status == "DELETE"))
	{
		param = "";
	}
    
	if (tempParam.actionType=="LOAD")
	{
		doOpen(tempParam); 
		
	}
	else
	{
		if (!doCreate(tempParam)) return; 	
	}
	
	//ҩ������
	if (!(param != "" && param.emrDocId == tempParam.emrDocId))
	{
		lockDocument(tempParam);
	}
	
	//��д����
	if (lockinfo != "" && lockinfo.openMode == "ReadOnly")
	{
		setReadOnly(true,"");
	}
	param = tempParam;
}

function doCreate(tempParam)
{
	var result = false;
	pluginType = tempParam.pluginType
	//���ر༭��
	if (pluginType == "DOC")
	{
		wordDoc(tempParam);
	}
	else if (pluginType == "GRID")
	{
		girdDoc(tempParam);
	}
	else
	{
		alert("�������ʧ��");
		return false;
	}
	if (tempParam.isLeadframe != "1")
	{
		result = doSignleCreate(tempParam);
	}
	else
	{
		result = doMultiplyCreate(tempParam);
	}
	return result;	
}

//���ĵ�����
function doSignleCreate(tempParam)
{
	var result = false;
	id = IsExitInstance(tempParam.emrDocId,tempParam.templateId);
	if (id != "0" && tempParam.chartItemType == "Single")
	{
		setMessage('�Ѿ������������ĵ�,�����ٴδ���!','forbid');
		return result;	
	}
	if ((param != "")&&(tempParam.emrDocId == param.emrDocId)&&(tempParam.chartItemType == "Single"))
	{
		setMessage('�������ĵ����ڴ���,���ܶ�δ���!','forbid');
		return result;		
	}
	if ((param != "")&&(tempParam.categoryId == param.categoryId)&&(param.isMutex == "1")&&(tempParam.isMutex == "1"))
	{
		setMessage('�Ѿ������������ĵ�,�����ٴδ���!','forbid');
		return result;
	}
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 	                          
	setPatientInfo(tempParam); 
	var isMutex = (tempParam.isMutex=="1")?true:false;	
	var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
	setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //����������
	createDocument(tempParam);
	result = true;
	return result;
}

///���ĵ�����
function doMultiplyCreate(tempParam)
{
	var result = false;
	if ((param != "")&&(tempParam.emrDocId == param.emrDocId))
	{
		if (tempParam.actionType == "CREATE")
		{
			focusDocument("GuideDocument","","First");
		}
		else
		{
			 createDocument(tempParam);		
		}
	}
	else
	{
		id = IsExitInstance(tempParam.emrDocId,tempParam.templateId);
		if (id != "0")
		{
			tempParam.id = id;
			loadDocument(tempParam); 
			if (tempParam.actionType == "CREATE")
			{
				focusDocument("GuideDocument","","First");
			}
			else
			{
				if (getModifyStatus().Modified == "True")
		 		{
		 	 		eventQuerySaveDocument();
		 	 		return false;
		 		}
				createDocument(tempParam);	
			}
		}
		else
		{
			if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 	                          
			setPatientInfo(tempParam); 
			var isMutex = (tempParam.isMutex=="1")?true:false;	
			var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
			setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //����������	
			if (tempParam.actionType == "CREATE")
			{
				var defaultLoadId = getDefaultLoadId(tempParam.emrDocId,userLocID);
				if (defaultLoadId == "")
				{
					focusDocument("GuideDocument","","First");
				}
				else
				{
					tempParam.actionType = "CREATEBYTITLE";
					tempParam.titleCode = defaultLoadId;
					createDocument(tempParam);
				}
			}
			else
			{
				createDocument(tempParam);	
			}		
		}
	}
	result = true;
	return result;
}

//��ȡ���ĵ�����δ����ʱĬ�ϼ��ص�titleCode
function getDefaultLoadId(templateCategoryId,locID)
{
	var defaultLoadId = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLTitleConfig",
					"Method":"GetDefaultLoadTitleCode",			
					"p1":templateCategoryId,
					"p2":locID
				},
			success : function(d) {
	           		defaultLoadId = d;
			},
			error : function(d) { alert("GetDefaultLoadTitleCode error");}
		});	
	return defaultLoadId;
}

///���ĵ�
function doOpen(tempParam)
{
	pluginType = tempParam["pluginType"];        	
	if (pluginType == "DOC")
	{
		wordDoc(tempParam);
	}
	else if (pluginType == "GRID")
	{
		girdDoc(tempParam);
	}
	else
	{
		alert("�������ʧ��");
		return;
	}
	if ((param != "")&&(param.emrDocId == tempParam.emrDocId) && ((param.characteristic != "0") || (param.id == tempParam.id)))
	{
		focusDocument(tempParam.id,"","Last");
	}
	else
	{
		loadDocument(tempParam); 
	}
}
///�ĵ��Ƿ��Ѿ�������
function IsExitInstance(emrDocId,templateId)
{
	var result = "0";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"web.DHCCM.EMRservice.BL.BLInstanceData",
			"Method":"IsHasInstance",
			"p1":episodeID,
			"p2":templateId,
			"p3":emrDocId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { alert("�����ݳ���");}
	});
	return result;		
}

//����word�༭��
function wordDoc(tempParam)
{
	parent.$('.tooledit').css("display","block");
	if(iword)
	{
		$("#containerGrid").css("display","none");
	}
	$("#containerWord").css("display","block");
	if (!iword)
	{
		var objString = "<object id='pluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalPHCM'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
		if (!$("#pluginWord")[0]||!$("#pluginWord")[0].valid)
		{
			setUpPlug();
		} 
		pluginAdd();
		$("#pluginWord")[0].initWindow("iEditor")               
		setConnect();  
		SetDefaultFontStyle();
		iword = true;                             	
		$("#containerGrid").css("display","none");
	}
}

//����gird�༭��
function girdDoc(tempParam)
{
	parent.$('.tooledit').css("display","none");  //���ع�����
	$("#containerWord").css("display","none");
	$("#containerGrid").css("display","block");
	if(!igrid)
	{
		var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalPHCM'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerGrid").innerHTML = objString;  
		if (!$("#pluginGrid")[0]||!$("#pluginGrid")[0].valid)
		{
			setUpPlug();
		}  
		pluginAdd();                        
		$("#pluginGrid")[0].initWindow("iGridEditor");  //�������༭��
		setConnect();
		igrid = true;                         //������ͼ
	}
}
//��װ�����ʾ
function setUpPlug (){
	var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl=" +pluginUrl+"&MWToken="+websys_getMWToken(),"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
	if (result)
	{
		window.location.reload();
	}
};

//���Ҳ��
function plugin() {
	if(pluginType == "DOC")
	{
		return $("#pluginWord")[0];
	}
	else
	{
		return $("#pluginGrid")[0];
	}
}
//�ҽӲ��\�¼�����
function pluginAdd() {	
	addEvent(plugin(), 'onFailure', function(command){
		alert(command);
	});
    addEvent(plugin(), 'onExecute', function(command){
	   var commandJson = jQuery.parseJSON(command);
	   eventDispatch(commandJson);
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

//�첽ִ��execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//ͬ��ִ��execute
function cmdSyncExecute(argJson){
	var result = plugin().syncExecute(JSON.stringify(argJson));
	return jQuery.parseJSON(result);
}

//�������ݿ�����
function setConnect(){
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
	return cmdSyncExecute(strJson);
}

//����Ĭ������
function SetDefaultFontStyle(){
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
}

//���ù�������
function setWorkEnvironment(tempParam)
{
	//����ĵ�
	var argJson = {action:"CLEAN_DOCUMENT",args:""};
	cmdDoExecute(argJson);
	//���ù����ռ�������
	argJson = {action:"SET_WORKSPACE_CONTEXT",args:tempParam["chartItemType"]};
	cmdDoExecute(argJson);
	//������д״̬
	argJson = {action:"SET_NOTE_STATE",args:"Edit"};
	cmdDoExecute(argJson);
	//��������ֻ����ɫ
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"0000ff"}};
	cmdDoExecute(argJson);	
}

//����ֻ��
function setReadOnly(flag,instanceIds)
{
	var argJson = "";
	if (instanceIds == "")
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag}};
	}
	else
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag,"InstanceID":instanceIds}};
	}
	cmdDoExecute(argJson);
	
}

//���û�����Ϣ
function setPatientInfo(tempParam)
{
	var diseaseID = parent.$('#disease').combotree('getValue');  //add by niucaicai 2016-04-28
	if (diseaseID == "undefined") diseaseID ="";
	var argParams = {"PatientID":patientID,"EpisodeID":episodeID,"UserCode":userCode,
	               "UserID":userID,"UserName":userName,"SsgroupID":ssgroupID,"UserLocID":userLocID,
	               "DiseaseID":diseaseID,"IPAddress":ipAddress,"PluginType":tempParam.pluginType,"ChartItemType":tempParam.chartItemType};
    var argJson = {action: "SET_PATIENT_INFO",args:argParams};
    cmdDoExecute(argJson);
    //���õ�ǰ��������Ϣ
    setCurrentRevisor();
}

//��ӻ��޸Ĳ�������
function setDiseaseData()
{
	var diseaseID = parent.$('#disease').combotree('getValue');  //add by niucaicai 2016-04-28
	if (diseaseID == "undefined") diseaseID ="";
	var argJson = {action: "SET_PATIENT_INFO",args:{"DiseaseID":diseaseID}};
	cmdDoExecute(argJson);
}

//����ҩ��
function createDocument(tempParam)
{
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var args = "";
	if (tempParam.args) args = tempParam.args;
		
	if (tempParam.actionType == "QUOTATION")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_INSTANCE",args:{"params":args,"InstanceID":tempParam.pInstanceId,"Title":{"DisplayName":tempParam.text}}};
	}
	else if (tempParam.actionType == "CREATEBYTITLE")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_TITLE",args:{"params":args,"TitleCode":tempParam.titleCode}};	
	}
	else 
	{
		var strJson = {action:"CREATE_DOCUMENT",args:{"params":args,"Title":{"DisplayName":tempParam.text}}};
	}
	cmdDoExecute(strJson);
}

//�����ĵ�
function loadDocument(tempParam)
{
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 	                          
	setPatientInfo(tempParam);
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var status = tempParam["status"];
	//�����ĵ�
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":status},InstanceID:tempParam["id"],actionType:tempParam["actionType"]}};
	cmdDoExecute(argJson); 
	
	if (status == "DELETE")
	{
		setReadOnly(true,[tempParam["id"]]);
	}
	else
	{
		//����������
		var isMutex = (tempParam["isMutex"]=="1")?true:false;
		var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
		if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
	} 
	focusDocument(tempParam.id,"","First");
}

//���ر����ĵ�
function cmdLoadLocalDocument()
{
	var argJson = {action : "LOAD_LOCAL_DOCUMENT", args:{path:""}};
	cmdDoExecute(argJson);
}


//���ô���ģ��
function setDocTempalte(emrDocId,isMutex,isGuideBox)
{
	var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox}};
	cmdDoExecute(argJson);
}

//����֪ʶ����
function appendComposite(kbNodeID)
{
   var argJson = {action:"APPEND_COMPOSITE",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
   cmdDoExecute(argJson);               
}	

//�滻֪ʶ����
function replaceComposite(kbNodeID)
{
   var argJson = {action:"REPLACE_COMPOSITE",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
   cmdDoExecute(argJson);  
}

//�жϵ�ǰ������ĵ��е�λ��	
function getElementContext(position)
{
   var argJson = {action:"GET_ELEMENT_CONTEXT",args:{"Type":position}};
   var result = plugin().syncExecute(JSON.stringify(argJson))
   return result;
}

//�����ı�
function insertText(text)
{
	var argJson = {action:"INSERT_TEXT_BLOCK",args:text};
	cmdDoExecute(argJson); 
}
//��λ�ĵ�
function focusDocument(instanceId,path,actionType)
{
	var argJson = {action:"FOCUS_ELEMENT",args:{"InstanceID":instanceId,"Path":path,"actionType":actionType}}
	cmdDoExecute(argJson);
}
//ǩ��
function signDocument(instanceId,type,signLevel,userId,userName,Image,actionType,description)
{
	var argJson = {action:"SIGN_DOCUMENT",args:{"InstanceID":instanceId,"Type":type,"SignatureLevel":signLevel,"actionType":actionType,"Authenticator":{"Id":userId,"Name":userName,"Image":Image,"Description":description},"params":{}}}
	return cmdSyncExecute(argJson);
}
//��ȡ��ĵ�������
function getDocumentContext(instanceId)
{
	var argJson = {action:"GET_DOCUMENT_CONTEXT",args:{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}
//����Ŀ¼���
function getOutLine()
{
	var argJson = {"action":"GET_DOCUMENT_OUTLINE","args":""}
	cmdDoExecute(argJson);
}

//��ȡ�ĵ��Ƿ��޸Ĺ�
function getModifyStatus()
{
	var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:""};
	return cmdSyncExecute(argJson);
}

//ͬ�����нű�
function runSyncScript(scripts) {
    var strJson = {action:"RUN_SCRIPT",args:{Script:scripts}};
    return cmdSyncExecute(strJson);
}

//��ע������
function markRequiredObject()
{
	var strJson = {action:"MARK_REQUIRED_OBJECTS",args:{"Mark":"True"}};
	return cmdSyncExecute(strJson);
}

//ˢ�°�����
function reloadBinddata(autoRefresh,syncDialogVisible)
{
	if (!param || param.id == "GuideDocument") return;
	
	var argJson = {"action":"REFRESH_REFERENCEDATA","args":{"InstanceID":"","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible}};
	cmdDoExecute(argJson);
	
	//����ƽ̨��־
	setOperationLog(param,"EMR.BinddataReload");
	
}

//�����ĵ�
function exportDocument()
{
	if (!param || param.id == "GuideDocument")
	{
		setMessage('��ѡ��Ҫ�������ĵ�!','forbid');
		return;
	}
	var argJson = {"action":"SAVE_LOCAL_DOCUMENT","args":{}};
	cmdDoExecute(argJson);	
}

//�����ĵ�����
function setDocumentParam(id,actionType,params)
{
	var argJson = {"action":"SET_DOCUMENT_PARAMS","args":{"InstanceID":id,"actionType":actionType,"params":params}};
	cmdDoExecute(argJson);
}

//�������ۻ�����Ϣ
function setCurrentRevisor()
{
	var argJson = {"action":"SET_CURRENT_REVISOR","args":{"Id":userID, "Name":userName,"IP":ipAddress}};
	cmdDoExecute(argJson);
}

//���ÿ����ر�����
function setRevisionState(InstanceId,status)
{
	var argJson = {action:"SET_REVISION_STATE", args:{"InstanceID":InstanceId,"Mark":status}};
	return cmdSyncExecute(argJson);
}

//��ʾ����
function viewRevision(status)
{
	var argJson = {action:"SET_REVISION_VISIBLE",args: {"Visible":status}}
	cmdDoExecute(argJson);
}

//����ASR����ʶ��״̬
function setASRVoiceStatus(status)
{
	var argJson = {action:"SET_ASR_VOICE_STATE",args:{"Open":status}};
	cmdDoExecute(argJson);
}

//�޸Ļ�׷�ӵ�Ԫ����
function updateInstanceData(actiontype,instanceID,path,value) {
    var strJson = {action: "UPDATE_INSTANCE_DATA",args: {"actionType":actiontype,"InstanceID":instanceID,"Path":path,"Value":value}};
    cmdDoExecute(strJson);
}

//�����ĵ�
function cmdsaveDocument()
{
	var argJson = {action:"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT"}}};
	cmdDoExecute(argJson);		
}

///ʧЧǩ��
function cmdRevokeSignedDocument(signatureLevel,instanceId)
{
	var argJson = {"action":"REVOKE_SIGNED_DOCUMENT","args":{"SignatureLevel":signatureLevel,"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//����ǩ���ĵ�����ز���
function saveSignDocument(instanceId,signUserId,signLevel,signId,digest,type,path,actionType)
{
	var argJson = {action:"SAVE_SIGNED_DOCUMENT",args:{params:{"action":"SAVE_SIGNED_DOCUMENT","SignUserID":signUserId,"SignID":signId,"SignLevel":signLevel,"Digest":digest,"Type":type,"Path":path,"ActionType":actionType},"InstanceID":instanceId}}
	cmdDoExecute(argJson);
}

//�ع�ǩ��
function unsignDocument()
{
	var argJson = {action:"UNSIGN_DOCUMENT",args:{}}
	cmdDoExecute(argJson);	
}

//����ǩ��
function revokeSignElement(signProperty)
{
	var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel}}}};
	return cmdSyncExecute(argJson);
}

//��ӡ�ĵ�
function printDocument()
{
	if (getModifyStatus().Modified == "True")
	{
		alert("�ĵ����ڱ༭���뱣����ӡ");
		return;
	}
	var qualityResult = qualityPrintDocument();
	if (qualityResult) return; 
	//��ӡ
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print"}}; 
 	cmdDoExecute(argJson);	
}

//�ʿ�
function qualityCheck(episodeId,instanceId,templateId,eventType)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"QualityInterfaceCheck",			
					"p1":episodeId,
					"p2":eventType,
					"p3":templateId,
					"p4":instanceId
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}

//�����ĵ�
function saveDocument()
{
	var flag = "save"
	//ȡ�ĵ���Ϣ
	var documentContext = getDocumentContext("");
	var modifyResult = getModifyStatus();
	//�ж�ҩ�����޸�����һ�β����Ǵ�ӡ,�򵯳������Ѵ�ӡ�����ѿ�
	if ((documentContext.status.curAction == "print")&&(modifyResult.Modified == "True"))
	{
		var text = 'ҩ�� "' +param.text + '" �Ѵ�ӡ���Ƿ�ȷ�ϱ����޸ģ�';
		var returnValues = window.showModalDialog("emr.printprompt.csp?MWToken="+websys_getMWToken(),text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		if (returnValues == "cancel") return;
	}
	if (revokeSignedDocument(modifyResult))
	{
		flag = "revoke";
	} 
	return flag;
}

///����ǩ��
function revokeSignedDocument(modifyResult)
{
	var result = false;
	var noSign = false;
	if (modifyResult.Modified == "Flase") return result;
	for (var i=0;i<modifyResult.InstanceID.length;i++)
	{
		var instanceId = modifyResult.InstanceID[i];
		var documentContext = getDocumentContext(instanceId);
		var userLevel = getUserInfo().UserLevel;
		if (documentContext.status.signStatus == 1)
		{
			if (revokeStatus()!= "Superior") userLevel = "";
			var revokeResult = cmdRevokeSignedDocument(userLevel,instanceId);
			if (revokeResult.result == "ERROR")
			{
				setMessage('ʧЧ�ĵ�ʧ��!','warning');
				noSign = false;
				break;
			}
			else
			{
				if( typeof(revokeResult.Authenticator) == "undefined" || revokeResult.Authenticator.length<=0) 
				{
					noSign = true;
					continue;	
				}
				result = true;
				var tmpDocContext = getDocumentContext(instanceId);
				if (tmpDocContext.result == "ERROR") return;

				//���õ�ǰ�ĵ�����Ȩ��
				setPrivelege(tmpDocContext);
			    //��ǰ�ĵ�״̬
			    setStatus(tmpDocContext);

				//�޸��ĵ�Ŀ¼
				modifyInstanceTree(tmpDocContext);
				setMessage('���ݱ���ɹ�,ǩ����ʧЧ!','alert');
				//����ҩ����Ϣ�����뷢��
				if (Observer == "Y") GetObserverData();

				//�ʿ�
				//qualitySaveDocument();	// qunianpeng 2018/3/26 ע���ʿ�
				getNewMenu();
				//������־(����ƽ̨��)
				setOperationLog(param,"EMR.Save");	
			}	
		}
		else
		{
			noSign = true;
		}
	}
	if (noSign)
	{
		cmdsaveDocument();
	}
    return result; 
}

///��ǰ�û���Ϣ
function getUserInfo()
{
	var reuslt = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			//"Class":"EMRservice.BL.BLEMRSign", qunianpeng 2018/3/14 ʹ�������Լ���
			"Class":"web.DHCCM.EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":userCode,
			"p2":""
		},
		success: function(d) {
			reuslt = eval("("+d+")");
		},
		error: function(d) {alert("error");}
	});	
	return reuslt;	
}

//�Ƿ����ǩ��ʧЧ
function revokeStatus()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.SystemParameter",
			"Method":"GetRevokeStatus"
		},
		success: function(d) {
			result = d;
		},
		error: function(d) {alert("error");}
	});	
	return result;	
}

//�ĵ������ʿ�
function qualitySaveDocument()
{
	var result = false;
	if ((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
	{		
		//������У��
		var resultMarkRequired = markRequiredObject();
		if (resultMarkRequired.MarkCount>0)
		{
			setMessage('��δ�����Ŀ,����!','forbid');
			result = true;
			return result;
		}
	}
	//��ɢ�����ʿ�
	var eventType = "Save^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			//alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

//ǩ���ʿ�
function qualitySignDocument()
{
	var result = false;
	if ((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
	{	
		//������У��
		var resultMarkRequired = markRequiredObject();
		if (resultMarkRequired.MarkCount>0)
		{
		 		setMessage('��δ�����Ŀ����ǩ��,�봦��!','forbid');
		 		result = true;
		 		return result;
	 	}
	}
	var eventType = "Commit^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			//alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

//��ӡ�ʿ�
function qualityPrintDocument()
{
	var result =  false;
	if ((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
	{
		//�ű����
		var resultMarkRequired = markRequiredObject();
		if (resultMarkRequired.MarkCount>0)
		{
		 		setMessage('��δ�����Ŀ���ܴ�ӡ,�봦��','forbid');
		 		result = true;
		 		return result;
	 	}
	}
	//ҩ���ʿ�
	var eventType = "Print^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			//alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

// ��ǩ������
function audit(signProperty)
{
	var qualityResult = qualitySignDocument();
	if (qualityResult) return; 
	var documentContext = getDocumentContext("");
    var canRevokCheck = documentContext.privelege.canRevokCheck;
    if (pluginType != "GRID") canRevokCheck =0;
    var tmpInstanceId = signProperty.InstanceID;
    var openFlag = episodeType=="O"?"0":"1";
	if ('1' == CAServicvice) 
	{
		var signParam = {"topwin":window,"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
		var usernameStr = base64encode(utf16to8(encodeURI(userName)))
		var iframeContent = "<iframe id='iframeSignCA' scrolling='auto' frameborder='0' src='emr.ip.signca.csp?MWToken="+websys_getMWToken()+"&UserName="+usernameStr+"&UserID="+userID+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID+"&SignParamStr="+signParamStr+"&openWay=editor' style='width:340px; height:235px; display:block;'></iframe>"
		var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
		createModalDialog("CASignDialog","CAǩ��","360","285","iframeSignCA",iframeContent,signCACallBack,arr)
		
		
	}
	else
	{
		//ģ����ǩ����Ԫ��ǩ��ģʽ����Ϊ������֤ǩ����
		if (signProperty.SignMode.toUpperCase() == 'SILENT')
		{
			openFlag = "0";
		}
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
		
		var iframeContent = "<iframe id='iframeSign' scrolling='auto' frameborder='0' src='dhcpha.clinical.record.sign.csp?MWToken="+websys_getMWToken()+"&UserName="+userName+"&UserCode="+userCode+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID+"&SignParamStr="+signParamStr+"&openWay=sign' style='width:360px; height:255px; display:block;'></iframe>"
		var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId,"documentContext":documentContext}
		createModalDialog("SignDialog","ϵͳǩ��","385","295","iframeSign",iframeContent,signCallBack,arr)
		//var returnValues = websys_createWindow("dhcpha.clinical.record.sign.csp?UserName="+userName+"&UserCode="+userCode+"&OpenFlag="+openFlag,signParam,"dialogHeight:220px;dialogWidth:300px;resizable:yes;status:no");
	}
}

function signCallBack(returnValue,arr)
{
	var returnValues = returnValue;
	if ((returnValues == "")||(typeof(returnValues) == "undefined")) 
	{
		return;
	}
	
	var signProperty = {};
	var tmpInstanceId = "";
	var documentContext = {};
	if (typeof(arr.signProperty) != "undefined")
	{
		signProperty = arr.signProperty; 
	}
	if (typeof(arr.tmpInstanceId) != "undefined") 
	{
		tmpInstanceId = arr.tmpInstanceId;
	}
	if (typeof(arr.documentContext) != "undefined") 
	{
		documentContext = arr.documentContext;
	}

	returnValues = eval("("+returnValues+")");
	userInfo = returnValues.userInfo;			
	if (returnValues.action == "sign")
	{
		if (userInfo.Type == "Graph" && userInfo.Image == "")
		{
			setMessage('ǩ��ͼƬδά������ά��','forbid');
			return;
		}
		checkSign(signProperty,userInfo,tmpInstanceId,documentContext);	
	}
	else if (returnValues.action == "revoke")
	{
		if (userInfo.UserID != signProperty.Id)
		{
			setMessage('�Ǳ���ǩ��,���ܳ���','forbid');
			return;
		}
		var ret = revokeSignElement(signProperty);		
		if (ret.result == "OK")
		{
			setMessage('�����ɹ�','alert');
		}
		else
		{
			setMessage('����ʧ��','warning');
		}
	}
}


//����ǩ��
function caSign(signProperty,userInfo,instanceId)
{
	//Ȩ�޼��
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;

	//��ʼǩ��
	var cert = parent.GetSignCert(parent.strKey);
    var UsrCertCode = parent.GetUniqueID(cert);
    if (!UsrCertCode || '' == UsrCertCode) return '�û�Ψһ��ʾΪ�գ�';
    
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc);

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    alert('ǩ��ԭ��Ϊ�գ�');
	    return ;
	}
    var signValue = parent.SignedData(signInfo.Digest,parent.strKey);
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"Sign",
			"p1":UsrCertCode,
			"p2":signValue,
			"p3":signInfo.Digest
        },
        success: function(ret) {
            if (ret && ret.Err) 
            {
                setMessage(ret.Err,'forbid');
            } 
            else 
            {
                saveSignDocument(instanceId,userInfo.UserID,signlevel,ret.SignID,signInfo.Digest,"CA",signInfo.Path,actionType)
				//ǩ���ɹ����ж��Ƿ���Ҫ������Ϣ��Portalϵͳ
				if (IsSetToPortal == "Y")
				{
					setInfoToPortal(userInfo.UserID);
				}
            }
        },
        error: function(ret) {alert(ret);}
    });
}

//ϵͳǩ��
function checkSign(signProperty,userInfo,instanceId,documentContext)
{
	//Ȩ�޼��
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;	
	if ((actionType == "Append" && documentContext.privelege.canCheck == 0) || (actionType == "Replace" && documentContext.privelege.canReCheck == 0))
	{
		setMessage("û��Ȩ��ǩ��",'forbid');
		return
	}
	
	//��ʼǩ��
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc);
	if (signInfo.result == "OK")
	{
		saveSignDocument(instanceId,userInfo.UserID,signlevel,"","","SYS",signInfo.Path,actionType);

		//ǩ���ɹ����ж��Ƿ���Ҫ������Ϣ��Portalϵͳ
		if (IsSetToPortal == "Y")
		{
			setInfoToPortal(userInfo.UserID);
		}
	}
	else
	{
		setMessage('ǩ��ʧ��','warning');
	}		
}

//���ǩ��Ȩ�޽ű�
function checkPrivilege(userInfo,signProperty)
{
	var result = {"flag":false,"ationtype":""};	
	var count = signProperty.Authenticator.length;
	if (count >0 && signProperty.Id == userInfo.UserID)
	{
		result = {"flag":false,"ationtype":""};
		setMessage('��ǩ��,������ǩ','forbid');
	    return result;
	}
	
	var signArray = ["All","QCDoc","QCNurse","ChargeNurse","student","intern","Refresher","Coder"];
	
	if ($.inArray(signProperty.OriSignatureLevel, signArray) != -1)
	{
		if (count>0)
		{
			//��ǩ
			if (confirm("��ǩ�����Ƿ��ǩ")==true)
			{
				result = {"flag":true,"ationtype":"Replace"};
			}
			else
			{
				result = {"flag":false,"ationtype":""};
			}
		}
		else
		{
			//ǩ��
			 result = {"flag":true,"ationtype":"Append"};
		}
	}
	else if (signProperty.OriSignatureLevel == "Check")
	{
		if (count <=0)
		{
			//ǩ��
			result = {"flag":true,"ationtype":"Append"};
		}
		else
		{
			if (userInfo.UserLevel == "student")
			{
				if (count == 1 && signProperty.SignatureLevel == "student")
				{
					//��ǩ
					if (confirm("��ǩ�����Ƿ��ǩ")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//��Ȩ��ǩ
					result = {"flag":false,"ationtype":""};
					setMessage("��Ȩ��ǩ��","forbid");
				}
	
			}
			else if (userInfo.UserLevel == "intern")
			{
				if (count == 1 && signProperty.SignatureLevel == "intern")
				{
					//��ǩ
					if (confirm("��ǩ�����Ƿ��ǩ")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//��Ȩ��ǩ
					result = {"flag":false,"ationtype":""};
					setMessage("��Ȩ��ǩ��","forbid");
				}
	
			}	
			else if (userInfo.UserLevel == "Resident")
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if (signProperty.Authenticator[i].SignatureLevel == "Attending" || signProperty.Authenticator[i].SignatureLevel == "Chief")
					{
						flag = 1
						break;
					} 
				}
				
				if (flag == 1)
				{
					//��Ȩ��ǩ
					result = {"flag":false,"ationtype":""};
					setMessage("��Ȩ��ǩ��","forbid");
					return result;
				}
				
				flag = 0
				for (var i=0;i<count;i++)
				{
					if (signProperty.Authenticator[i].SignatureLevel == "Resident")
					{
						flag = 1
						break;
					} 
				}
				
				if (flag != 1)
				{
					//ǩ��
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if (signProperty.SignatureLevel == "Resident")
				{
					//��ǩ
					if (confirm("��ǩ�����Ƿ��ǩ")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//��Ȩ��ǩ
					result = {"flag":false,"ationtype":""};
					setMessage("��Ȩ��ǩ��","forbid");
				}
			}
			else if (userInfo.UserLevel == "Attending")
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if (signProperty.Authenticator[i].SignatureLevel == "Chief")
					{
						flag = 1
						break;
					} 
				}
				
				if (flag == 1)
				{
					//��Ȩ��ǩ
					result = {"flag":false,"ationtype":""};
					setMessage("��Ȩ��ǩ��","forbid");
					return result;
				}
				
				flag = 0
				for (var i=0;i<count;i++)
				{
					if (signProperty.Authenticator[i].SignatureLevel == "Attending")
					{
						flag = 1
						break;
					} 
				}
				
				if (flag != 1)
				{
					//ǩ��
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if (signProperty.SignatureLevel == "Attending")
				{
					//��ǩ
					if (confirm("��ǩ�����Ƿ��ǩ")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//��Ȩ��ǩ
					result = {"flag":false,"ationtype":""};
					setMessage("��Ȩ��ǩ��","forbid");
				}
			}
			else if (userInfo.UserLevel == "Chief")
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if (signProperty.Authenticator[i].SignatureLevel == "Chief")
					{
						flag = 1
						break;
					} 
				}
				if (flag != 1)
				{
					//ǩ��
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if (signProperty.SignatureLevel == "Chief")
				{
					//��ǩ
					if (confirm("��ǩ�����Ƿ��ǩ")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//��Ȩ��ǩ
					result = {"flag":false,"ationtype":""};
					setMessage("��Ȩ��ǩ��","forbid");
				}				
			}
		}
	}
	else if(signProperty.OriSignatureLevel == "Resident")
	{
		//סԺҽʦǩ����ǩ�ϼ�
		if ($.inArray(userInfo.UserLevel,["Chief","Attending","Resident"])!= -1)
		{
			if (count <=0)
			{
				//ǩ��
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//��ǩ
				if (confirm("��ǩ�����Ƿ��ǩ")==true)
				{
					result = {"flag":true,"ationtype":"Replace"};
				}
				else
				{
					result = {"flag":false,"ationtype":""};
				}	
			}	
		}
		else
		{
			//��Ȩ��ǩ
			result = {"flag":false,"ationtype":""};
			setMessage("��Ȩ��ǩ��","forbid");			
		}
	}
	else if (signProperty.OriSignatureLevel == "Attending")
	{
		//ס��ҽʦǩ����ǩ�ϼ�
		if ($.inArray(userInfo.UserLevel,["Attending","Chief"])!= -1)
		{
			if (count <=0)
			{
				//ǩ��
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//��ǩ
				if (confirm("��ǩ�����Ƿ��ǩ")==true)
				{
					result = {"flag":true,"ationtype":"Replace"};
				}
				else
				{
					result = {"flag":false,"ationtype":""};
				}	
			}	
		}
		else
		{
			//��Ȩ��ǩ
			result = {"flag":false,"ationtype":""};
			setMessage("��Ȩ��ǩ��","forbid");			
		}	
	}
	else 
	{
		if (signProperty.OriSignatureLevel != userInfo.UserLevel && signProperty.OriSignatureLevel != userInfo.UserPos)
		{
			//��Ȩ��ǩ
			result = {"flag":false,"ationtype":""};
			setMessage("ǩ����ݲ�������Ȩ��ǩ��","forbid");
		}
		else if (count > 0)
		{
			//��ǩ
			if (confirm("��ǩ�����Ƿ��ǩ")==true)
			{
				result = {"flag":true,"ationtype":"Replace"};
			}
			else
			{
				result = {"flag":false,"ationtype":""};
			}
		}
		else
		{
			//ǩ��
			result = {"flag":true,"ationtype":"Append"};		
		}
	}
	return result;	
}


//����Ȩ��
function setPrivelege(documentText)
{
	if (documentText.result == "ERROR") return;
	var privelegeJson = {"action":"setToolbar","status":documentText.privelege};
	parent.eventDispatch(privelegeJson);
	
	if (documentText.privelege.canSave == "0")
	{
		setReadOnly(true,documentText.InstanceID);
	}
	else
	{
		if (documentText.privelege.canRevise == "-1" && documentText.status.signStatus == "1")
		{
			if (setRevisionState("",true).result != "OK") alert("��������ʧ��");
		}
		else if (documentText.privelege.canRevise == "1")
		{
			if (setRevisionState("",true).result != "OK") alert("��������ʧ��");
		}
		if (parent.isViewRevisionCheck() == "true")
		{
			viewRevision(true);
		}
		else
		{
			viewRevision(false);
		}
	}	
}

//����״̬
function setStatus(documentText)
{
	if (documentText.result == "ERROR") return;
	curStatus = documentText.status.curStatus;			
}

//ɾ��ҩ��
function deleteDocument()
{
	var documentContext = getDocumentContext("");
	if (documentContext.result == "ERROR")
	{
		setMessage('����ѡ���ĵ���ɾ��!','warning');
		return;
	}
	var instanceId = documentContext.InstanceID;
	
	var titleName = documentContext.Title.DisplayName;
	var status = documentContext.status.curStatus;	
	var tipMsg = "�Ƿ�ȷ��ɾ�� "+titleName+"?";

	if (window.confirm(tipMsg))
	{
		var json = {action:"DELETE_DOCUMENT",args:{"InstanceID":instanceId}};
		cmdDoExecute(json);
		getFavId(instanceId); //ͬʱɾ����Ӧ���ղ�
	}	
}
//��ʾ��ǰҩ���Ƿ��ղ�
function isFavoriteRecord(instanceId)
{
	var result = false;
	$.ajax({
		type: "GET",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLFavInformation",
			"Method":"SearchFavRecord",
			"p1":patientNo,
			"p2":userID,
			"p3":episodeID,
			"p4":instanceId
		},
		success: function (data){
			if (data == "1")
			{
				result = true;
			}
		 }
	});
	return result;	
}
//�¼��ɷ�
function eventDispatch(commandJson)
{
	
	if(commandJson["action"] == "eventMRSetView")                   
	{
		//����������ͼ��ϼ��������ĵ�
	    eventCreatorReportorView();
	}
	else if(commandJson["action"] == "eventDocumentChanged")        
	{
		//�ĵ��ı�
		eventDocumentChanged(commandJson);
	}
	else if(commandJson["action"] == "eventSectionChanged")          
	{ 
		//�½ڸı�
		eventSectionChanged(commandJson);
	}
	else if (commandJson["action"] == "eventSaveDocument")      
	{
		//�������
		eventSaveDocument(commandJson);
	}
	else if (commandJson["action"] == "eventQuerySaveDocument")
	{
		//��ʾ�û������ĵ�
		eventQuerySaveDocument();
	}
	else if (commandJson["action"] == "eventGetDocumentOutline")
	{
		//����ĵ����
		eventGetDocumentOutline(commandJson);
	}	
	else if(commandJson["action"] == "eventCreateDocument")
	{
		//�����ĵ����¼�
		eventCreateDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSaveSignedDocument")
	{
		//�ĵ�ǩ��
		eventSaveSignedDocument(commandJson);
	}
	else if(commandJson["action"] == "eventDeleteDocument")
	{
		eventDeleteDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSave")
	{
		//ctrl+s�����¼�
		eventSave();
	}
	else if (commandJson["action"] == "eventInsertSummary")
	{
		eventInsertSummary(commandJson);
	}
	else if (commandJson["action"] == "eventCaretContext")
	{
		eventCaretContext(commandJson);
	}
	else if (commandJson["action"] == "eventLoadDocument")
	{
		eventLoadDocument(commandJson);
	}
	else if (commandJson["action"] == "eventPrintDocument")
	{
		eventPrintDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSendCopyCutData")
	{
		eventSendCopyCutData(commandJson);
	}
	else if (commandJson["action"] == "eventSaveLocalDocument")
	{
		eventSaveLocalDocument(commandJson);
	}
	else if (commandJson["action"] == "eventRequestSign")
	{
	
		eventRequestSign(commandJson);
	}
	else if (commandJson["action"] == "eventReplaceComposite")
	{
		//�ж�֪ʶ���Ƿ��滻�ɹ�
		eventReplaceView(commandJson);
	}
	else if (commandJson["action"] == "eventRefreshReferenceData")
	{
		//ˢ����������
		eventRefreshReferenceData(commandJson);
	}
	else if(commandJson["action"] == "eventHyperLink")
	{
		//���ӵ�Ԫ
		eventHyperLink(commandJson);
	}
	else if(commandJson["action"] == "eventUpdateInstanceData")
	{
		eventUpdateInstanceData(commandJson);
	}
}

//���Ƿ���ʾ��������ʾ��״̬�������
function eventRefreshReferenceData(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLRefreshBindData",
					"Method":"InputData",			
					"p1":param.id,
					"p2":commandJson["args"]["SyncDialogVisible"]
				}
		});	
	}
}

//�ж�֪ʶ���Ƿ��滻�ɹ�
function eventReplaceView(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		setMessage('֪ʶ���滻�ɹ�!','alert');
	}
	else
	{
		setMessage('֪ʶ���滻ʧ��!','warning');
	}
}

//�ĵ�����
function eventSaveLocalDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		//����ƽ̨����ƺ���־��¼
		setOperationLog(param,"EMR.Export.Save");	
	}
}

//�ĵ��ı��¼�
function eventDocumentChanged(commandJson)
{
	isEditMultiRecord(commandJson);
	//���µ�ǰʵ���ĵ�ID
	param.id = commandJson["args"]["InstanceID"]; 
	//���µ�ǰ����
	titleCode = commandJson["args"]["Title"]["Code"];
	//ȡ�ĵ���Ϣ
	var documentContext = getDocumentContext(param.id);
	//���õ�ǰ�ĵ�����Ȩ��
	setPrivelege(documentContext);
    //��ǰ�ĵ�״̬
    setStatus(documentContext);
	//ѡ�е�ǰ�ĵ�Ŀ¼
	setSelectRecordColor(param.id);
}

function isEditMultiRecord(commandJson)
{
	if ((param != "")&&(param.id != "")&&(param.id != commandJson["args"]["InstanceID"]))
	{
		var result = savePrompt(param.id);
		resetModifyState(param.id,"false");
	}
}

//�½ڸı��¼�
function eventSectionChanged(commandJson)
{
	//var diseaseID = parent.$("#disease").find("option:selected").val();
	/*
	// ���ڸ�ҳ���еĲ���������zTree��ʽ���������Բ���ʹ�ô˷�����ȡ������ѡ�нڵ��ID  modify by niucaicai 2016-04-28
	var diseaseTree = parent.$('#disease').combotree('tree');
	var diseaseNode = diseaseTree.tree('getSelected');
	var diseaseID = diseaseNode.attributes.rowID;
	*/
	var diseaseID = parent.$('#disease').combotree('getValue');  //add by niucaicai 2016-04-28
	if (diseaseID == "undefined") diseaseID ="";
	//ˢ��֪ʶ��
    var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:commandJson["args"]["BindKBBaseID"],"titleCode":titleCode,"diseaseID":diseaseID};
    parent.eventDispatch(paramJson);
    //��λ�½�
    var path = commandJson["args"]["InstanceID"]+"_"+commandJson["args"]["Path"];
    if (path == "") return;
    //focusOutLine(path);	
}
//�����¼�����
function eventSaveDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
	    if (commandJson["args"]["params"]["result"] == "OK")
	    { 
			//ȡ�ĵ���Ϣ
			param.id = commandJson["args"]["params"]["InstanceID"];
			var documentContext = getDocumentContext(param.id);
			if (documentContext.result == "ERROR") return;
			
			//���õ�ǰ�ĵ�����Ȩ��
			setPrivelege(documentContext);
		    //��ǰ�ĵ�״̬
		    setStatus(documentContext);
		    
			//�޸�Σ��ֵ�¼���IsActive�ֶ�
			modifyCriticalEventValue(commandJson["action"]);
			
			//�޸��ĵ�Ŀ¼
			modifyInstanceTree(documentContext);
			setMessage('���ݱ���ɹ�!','alert');
			//����ҩ����Ϣ�����뷢��
			if (Observer == "Y")
			{
				GetObserverData();
			}
			//�ʿ�
			//qualitySaveDocument();  qunianpeng 2018/3/14 ע���ʿ�
			//if (param.chartItemType == "Single")
			//{
				getNewMenu();
			//}
	   		//������־(����ƽ̨��)
			setOperationLog(param,"EMR.Save");
			getRecord();			// qunianpeng 2018/3/25 ����ɹ���ˢ��Ŀ¼
	    }
	    else
	    {
		    setMessage('���ݱ���ʧ��!','warning');
		}
	}
	else if (commandJson["args"]["result"] == "ERROR")
	{
	    setMessage('����ʧ��','warning');
	}
	else if (commandJson["args"]["result"] != "NONE")
	{
		setMessage('�ĵ�û�з����ı�','warning');
	}
}

//ͬ�����߻�����Ϣѡ��б�
function GetObserverData()
{
	var returnValues = "";
	//��ȡ����ҩ����Ϣͬ��ѡ�����
	$.ajax({ 
        type: "post",
		dataType: "text", 
        url: "../EMRservice.Ajax.common.cls",
        async : false,
        data:{
			"OutputType":"Stream",
			"Class":"EMRservice.Observer.BOUpdateData",
			"Method":"ObserverUpData",
			"p1":episodeID,
			"p2":patientID,
			"p3":userID,
			"p4":param.templateId,
			"p5":"SAVE"
		}, 
		error: function(d)
		{
			alert("ͬ����Ϣ��ȡʧ��!");
        }, 
        success: function (d)
        {
        	if (d != "")
        	{
	        	var data = eval("["+d+"]");
	        	var array = {
		        	"data":data,
					"patientID":patientID,
					"userID":userID
				};
	        	returnValues = window.showModalDialog("emr.observerdata.csp?MWToken="+websys_getMWToken(),array,"dialogWidth:607px;dialogHeight:313px;resizable:yes;center:yes;status:no");
	        }
        } 
    });
    if (returnValues)
	{
		parent.$("#patientInfo").empty();
		parent.getPatinentInfo();
		window.setTimeout("setMessage('ͬ�����������ݱ���ɹ�!','alert')",messageScheme['alert']);
	}
}

//��ʾ�û������ĵ�
function eventQuerySaveDocument()
{
	setMessage('�½��ĵ������ſɴ������ĵ�','forbid');
}

//����ĵ����
function eventGetDocumentOutline(commandJson)
{
	var outLine = commandJson["args"]["Instances"];
	if (outLine == "") return;
}

//�����ĵ��¼�
function eventCreateDocument(commandJson)
{
	loadFalg = false;
	if (commandJson["args"]["result"] == "OK")
	{
		param.id = commandJson["args"]["InstanceID"];
		titleCode = commandJson["args"]["Title"]["Code"];
		var diseaseID = parent.$('#disease').combotree('getValue');  //add by niucaicai 2016-04-28
		if (diseaseID == "undefined") diseaseID ="";
		var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:commandJson["args"]["BindKBBaseID"],"titleCode":titleCode,"diseaseID":diseaseID};
	    parent.eventDispatch(paramJson);
	    if (param.insert)
	    {
		    focusDocument(args.InstanceID,param.insert.path,"Last");
		    insertText(param.insert.content);
	    }
	}
}

//�ĵ�ǩ���¼�
function eventSaveSignedDocument(commandJson)
{
	if ((commandJson["args"]["result"] == "OK")&&(commandJson["args"]["params"]["result"] == "OK")) 
	{
		//ȡ�ĵ���Ϣ
		var documentContext = getDocumentContext(commandJson["args"]["params"]["InstanceID"]);
		//���õ�ǰ�ĵ�����Ȩ��
		setPrivelege(documentContext);
		//��ǰ�ĵ�״̬
		setStatus(documentContext);
		
		//�޸��ĵ�Ŀ¼
		modifyInstanceTree(documentContext);
		setMessage('����ǩ���ɹ�!','alert');
		
		///dws 2017-01-18 ǩ����ɺ����ͷ�˵�Ȩ�ޣ�ҩ�����ɱ༭��ֻ��
		parent.btnCanNot("disable");
		parent.btnSaveCanNot();
		lockDocument(tempParamLock);
		setReadOnly(true,"");
		//����ƽ̨����ƺ���־��¼
		setOperationLog(param,"EMR.Sign.OK");
		/*
		//ǩ���ɹ����ж��Ƿ���Ҫ������Ϣ��Portalϵͳ  //��ʱ����ִ�д˴�����ȥִ��ǩ��֮ǰ��Ȩ�����
		if (IsSetToPortal == "Y")
		{
			setInfoToPortal(documentContext);
		}
		*/
	}
	else
	{
		setMessage('ǩ��ʧ�ܻ򼶱𲻷�!','warning');
		unsignDocument();
	}
}
//ǩ���ɹ��󣬷�����Ϣ��Portalϵͳ
function setInfoToPortal(UserID)
{
	var signUserID = UserID;
	//alert("signUserID"+signUserID);
	var InstanceId = param.id;
	var categoryId = param.categoryId;
	var templateId = param.templateId;
	var emrDocId = param.emrDocId;
	var chartItemType = param.chartItemType;

	//ȡ�ĵ���Ϣ
	var documentContext = getDocumentContext("");

	var TitleCode = documentContext["Title"]["Code"];
	var TitleDesc = documentContext["Title"]["DisplayName"];
	var curStatus = documentContext["status"]["curStatus"];
	var curStatusDesc = documentContext["status"]["curStatusDesc"];
	var signStatus = documentContext["status"]["signStatus"];

	var canAttendingCheck = documentContext["privelege"]["canAttendingCheck"];
	var canChiefCheck = documentContext["privelege"]["canChiefCheck"];

	$.ajax({ 
		type: "POST", 
		url: "../EMRservice.Ajax.SetDataToPortal.cls", 
		data: "EpisodeID=" + episodeID + "&signUserID="+ signUserID + "&InstanceId=" + InstanceId + "&categoryId=" + categoryId + "&templateId=" + templateId + "&emrDocId=" + emrDocId + "&chartItemType=" + chartItemType + "&TitleCode=" + TitleCode + "&TitleDesc=" + TitleDesc + "&curStatus=" + curStatus + "&curStatusDesc=" + curStatusDesc + "&signStatus=" + signStatus + "&canAttendingCheck=" + canAttendingCheck + "&canChiefCheck=" + canChiefCheck
	});
}

//ɾ���ĵ�
function eventDeleteDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		var instanceId = commandJson["args"]["params"]["InstanceID"];
		var deleteData = deleteTreeItem(instanceId,"InstanceTree");
		$(deleteData).find("#status").html("��ɾ��");
		
		//�޸�Σ��ֵ�¼���IsActive�ֶ�
		modifyCriticalEventValue(commandJson["action"]);
		
		//�޸��ĵ�Ŀ¼
		addDeleteTree(deleteData);

		getNewMenu();

		setMessage('ҩ��ɾ���ɹ�!','alert');
				
		//����ƽ̨����ƺ���־��¼
		setOperationLog(param,"EMR.Delete.OK");
	}
	unLock(lockinfo.LockID);
	if (param.chartItemType == "Single")
	{
		param = "";
	}
	else
	{
		param.id = "";
	}
}
//��ݼ�����
function eventSave()
{
	if (getModifyStatus().Modified != "True") return;
	var documentContext = getDocumentContext("");
	if (documentContext.result != "OK") return;
	if (documentContext.privelege.canSave != "1") return;
    saveDocument();
}

//���뱸ע
function eventInsertSummary(commandJson)
{
	$('#memo').window('open');
	$('#memoText').val(commandJson.args.Value);
}

//����������ʽ
function eventCaretContext(commandJson)
{
	if (commandJson.args.FONT_FAMILY)
	{
		parent.$("#font").combobox('setValue',commandJson.args.FONT_FAMILY);
	}
}

//�ĵ����سɹ��¼�
function eventLoadDocument(commandJson)
{
	loadFalg = false;
	
	//��ȡ��ǰҩ��ֻ��״̬
	var readOnlyStatus = getReadOnlyStatus().ReadOnly;
	if (readOnlyStatus == "False")
	{
		//�Զ�����������ͬ��
		refreshReferenceData(commandJson.args.InstanceID,"true")
	}
}

//��ȡ��ǰҩ��ֻ��״̬
function getReadOnlyStatus()
{
	var strJson = {action:"GET_READONLY",args:{}};
	return cmdSyncExecute(strJson);
}

//ҩ��������ɺ󴥷�������ͬ��
function refreshReferenceData(InstanceID,autoRefresh)
{
	if (InstanceID == "") return;
	//��ȡ�Ƿ���ʾͬ����ʾ��״̬
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLRefreshBindData",
					"Method":"getBindDataSyncDialogVisible",			
					"p1":InstanceID
				},
			success : function(d) {
	           if ( d != "") 
			   {
					if (d == "True")
					{
						reloadBinddata(autoRefresh,"true");
					}
					else if(d == "False")
					{
						reloadBinddata(autoRefresh,"false");
					}
			   }
			}
		});	
}

//�ĵ���ӡ�¼�
function eventPrintDocument(commandJson)
{
	if (commandJson["args"].result == "OK")
	{
		//ȡ�ĵ���Ϣ
		var documentContext = getDocumentContext("");
		//���õ�ǰ�ĵ�����Ȩ��
		setPrivelege(documentContext);
		//��ǰ�ĵ�״̬
		setStatus(documentContext);
		
		//�ж��Ƿ��ӡ������ҳ�ɹ��󣬶����ṩ���ʳ�Ժ�����б�
		var lis = $("#InstanceTree li[id='"+param["id"]+"']");
		var docId = lis.attr("emrDocId");
		getMedicalRecordDocID(docId);
		//�޸�ҩ��������¼��ϸ����ʾ��ɫ
		modifyWestListFlag();
		//����ƽ̨����ƺ���־��¼
		setOperationLog(param,"EMR.Print.OK");
	}
}

//���Ƽ���
function eventSendCopyCutData(commandJson)
{
	//ˢ��֪ʶ��
    var paramJson = {"action":"sendCopyCutData","content":commandJson.args.Value};
    parent.eventDispatch(paramJson);

}

///ǩ��
function eventRequestSign(commandJson)
{
	 if (getModifyStatus().Modified == "True")
	 {
		 var text = '  ǩ��ǰ�����ȱ���ҩ����';
		 returnValues = window.showModalDialog("emr.prompt.csp?MWToken="+websys_getMWToken(),text,"dialogHeight:180px;dialogWidth:350px;resizable:yes;status:no;scroll:no;");
         if (returnValues != "save")
         {
	         return;
	     }
	     if (saveDocument()=="revoke") return;
     }
	 var signProperty = commandJson.args;
	 audit(signProperty);
}


///���ӵ�Ԫ
function eventHyperLink(commandJson)
{
	if (commandJson.args.Url !="")
	{
		getUnitLink(commandJson);
	}
}

function eventUpdateInstanceData(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		setMessage('����ɹ�!','alert');
	}
	else
	{
		setMessage('����ʧ��!','warning');
	}
}

$(function(){
	//�༭��ע
	$('#memo').window({
		title: "�༭��ע",
		width: 400,  
		height: 300,  
		modal: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closed: true	 
	});
	$('#memo').css("display","block");	
	
	//���汸ע��Ϣ
	$('#memoSure').click(function(){
		var memoText = $('#memoText').val();
		memoText = stringTJson(memoText);
		if (memoText.length > 1000)
		{
			alert("��ע���ݳ���1000��������");
		}else{
			$.ajax({ 
	       		type: "post", 
				url: "../EMRservice.Ajax.common.cls", 
				data: {
					"OutputType":"String",
					"Class":"web.DHCCM.EMRservice.BL.BLInstanceData",
					"Method":"SetDocumentMemo",
					"p1":param.id,
					"p2":memoText
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					alert(textStatus); 
				}, 
				success: function (data) { 
					if (data == "1")
					{
						setMessage('��ע�޸ĳɹ�!','alert')	
						$('#memo').window('close');
					}
					else
					{
						setMessage('��ע�޸�ʧ��!','warning')	
					}
				} 
			});			
		}		
	});
	
	//ȡ����رձ༭��ע
	$("#memoCancel").click(function(){
		$('#memo').window('close');	
	});
});

//ҩ���ο�
function reference(action)
{
	if (setRecReferenceLayout == "east")
	{
		if (action=="add")
		{
			window.parent.collapseResourse();
			$('#layout').layout('collapse','west');
			$('#layout').layout('expand','west');
			$('#layout').layout('collapse','west');
			var reference = '<iframe id="framReference"  frameborder="0" src="" style=" width:100%; height:100%;scrolling:no;"></iframe>'
			$('#layout').layout('add',{  
		    	region: 'east', 
		    	width: ($(window).width())*0.45, 
		    	title: 'ҩ���ο�',  
		    	split: true,
		    	content: reference
			});
			$("#framReference").attr("src","dhcpha.clinical.record.edit.reference.east.csp?MWToken="+websys_getMWToken());
		
			//����ƽ̨��־
			setOperationLog(param,"EMR.Reference");
			$.parser.parse(); 
		}
		else
		{
			$('#layout').layout('remove','east');
			$('#layout').layout('expand','west');
		}
	}
	else
	{
		if (action=="add")
		{
			var reference = '<iframe id="framReference"  frameborder="0" src="" style=" width:100%; height:100%;scrolling:no;"></iframe>'
			$('#layout').layout('add',{  
		    	region: 'south', 
		    	height: 250,  
		    	title: 'ҩ���ο�',  
		    	split: true,
		    	content: reference
			});
			$("#framReference").attr("src","dhcpha.clinical.record.edit.reference.south.csp?MWToken="+websys_getMWToken());
		
			//����ƽ̨��־
			setOperationLog(param,"EMR.Reference");
		}
		else
		{
			$('#layout').layout('remove','south');
		}
	}
}

//�޸�Σ��ֵ�¼���IsActive�ֶ�
function modifyCriticalEventValue(eventAction)
{
	if (eventAction == "eventSaveDocument")
	{
		//�����¼�
		if (param.IsActive == "Y") param.IsActive = "N";
	}else if (eventAction == "eventDeleteDocument")
	{
		//ɾ���¼�
		if (param.IsActive != "N") param.IsActive = "N";
	}
}

function getFavId(InstanceId){
	 runClassMethod("web.DHCCM.drugFav","getFavID",{"InstanceId":InstanceId},function(jsonObj){
		JsonObj=jsonObj;
		if(JsonObj==1){
			alert("��ҩ��ģ��Ϊ�ղ�ģ��,��ص��ղ��ѱ�ɾ����");
		}
   },'json',false);
}

