//初始化页面
function InitDocument(tempParam)
{  
	//判断上一个文档是后加载完成
	if (loadFalg ) return;
    
    //更新状态
	initStatus();
	
	//权限检查
	if (tempParam.actionType == "LOAD")
	{
		if (checkLoadPrivilege(tempParam,true)) return;      //加载病历权限
	}
	else
	{
		if(checkCreatePrivilege(tempParam,true)) return;     //创建病历权限
	}
	
	//解锁,保存提醒
	if (param != "")
	{	
		if (savePrompt("") == "cancel") return;           //提醒保存病历
		if (isEnableEditMultiRecord == "false")
		{
			unLockAllInstance(userID,episodeID,param.emrDocId);
		}
		else
		{
			if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
			{         
				unLock(lockinfo.LockID);                        //解锁
			}
		}
	}
	

	if ((param.status != tempParam.status)||(tempParam.status == "DELETE"))
	{
		param = "";
	}
    
	if (tempParam.actionType=="LOAD")
	{
		if (!doOpen(tempParam)) return; 
		
	}
	else
	{
		if (!doCreate(tempParam)) return; 	
	}
	if (isEnableEditMultiRecord != "false")
	{
		if (checkActionPrivilege(tempParam).canSave == "1")
		{
			//病历加锁
			if (!(param != "" && param.emrDocId == tempParam.emrDocId))
			{
				lockDocument(tempParam);
			}
		
			//读写设置
			if (lockinfo != "" && lockinfo.openMode == "ReadOnly")
			{
				setReadOnly(true,"");
			}
		}
	}
	param = tempParam;
}

function doCreate(tempParam)
{
	var result = true;
	pluginType = tempParam.pluginType
	//加载编辑器
	if (pluginType == "DOC")
	{
		if (!wordDoc(tempParam)) return false;
	}
	else if (pluginType == "GRID")
	{
		if (!girdDoc(tempParam)) return false;
	}
	else
	{
		setMessage("插件创建失败");
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

//单文档创建
function doSignleCreate(tempParam)
{
	var result = false;
	id = IsExitInstance(tempParam.emrDocId,tempParam.templateId);
	if (id != "0" && tempParam.chartItemType == "Single")
	{
		setMessage('已经创建该类型病历,不能再次创建!','forbid');
		return result;	
	}
	if ((param != "")&&(tempParam.emrDocId == param.emrDocId)&&(tempParam.chartItemType == "Single"))
	{
		setMessage('该类型病历正在创建,不能多次创建!','forbid');
		return result;		
	}
	if ((param != "")&&(tempParam.categoryId == param.categoryId)&&(param.isMutex == "1")&&(tempParam.isMutex == "1"))
	{
		setMessage('已经创建该类型病历,不能再次创建!','forbid');
		return result;
	}
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam);
	setProductSource(tempParam);
	setPatientInfo(); 	                          
	var isMutex = (tempParam.isMutex=="1")?true:false;	
	var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
	setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //设置引导框
	createDocument(tempParam);
	result = true;
	return result;
}

///多文档加载
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
			if (getModifyStatus("").Modified == "True")
		 	{
		 	 	eventQuerySaveDocument();
		 	 	return false;
		 	}
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
				createDocument(tempParam);	
			}
		}
		else
		{
			if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 
			setProductSource(tempParam);
			setPatientInfo();	                          
			var isMutex = (tempParam.isMutex=="1")?true:false;	
			var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
			setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //设置引导框	
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

//获取多文档加载未创建时默认加载的titleCode
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

///打开文档
function doOpen(tempParam)
{
	var result = true;
	pluginType = tempParam["pluginType"];        	
	if (pluginType == "DOC")
	{
		if (!wordDoc(tempParam)) return false;
	}
	else if (pluginType == "GRID")
	{
		if (!girdDoc(tempParam)) return false;
	}
	else
	{
		alert("插件创建失败");
		return false;
	}
	if ((param != "")&&(param.emrDocId == tempParam.emrDocId) && ((param.characteristic != "0") || (param.id == tempParam.id)))
	{
		focusDocument(tempParam.id,"","First");
	}
	else
	{
		loadDocument(tempParam); 
	}
	return result;
}
///文档是否已经被创建
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
			"Class":"EMRservice.BL.BLInstanceData",
			"Method":"IsHasInstance",
			"p1":episodeID,
			"p2":templateId,
			"p3":emrDocId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { alert("查数据出错");}
	});
	return result;		
}

//创建word编辑器
function wordDoc(tempParam)
{
	var result = true;
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
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
		if (!$("#pluginWord")[0]||!$("#pluginWord")[0].valid)
		{
			setUpPlug();
			return;
		} 
		pluginAdd();
		var ret = $("#pluginWord")[0].initWindow("iEditor");
		if (!ret)
		{
			setMessage('创建编辑器失败!','warning');
			result = false;
			return result;
		}              
		var nectresult = setConnect();
		if (nectresult != "" && nectresult.result != "OK")
		{
			setMessage('数据库连接失败!','warning');
			result = false;
			return result;
		} 
		SetDefaultFontStyle();
		iword = true;                             	
		$("#containerGrid").css("display","none");
		setRunEMRParams();
	}
	return result;
}

//创建gird编辑器
function girdDoc(tempParam)
{
	var result = true;
	parent.$('.tooledit').css("display","none");  //隐藏工具条
	$("#containerWord").css("display","none");
	$("#containerGrid").css("display","block");
	if (!igrid)
	{
		var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerGrid").innerHTML = objString;  
		if (!$("#pluginGrid")[0]||!$("#pluginGrid")[0].valid)
		{
			setUpPlug();
			return;
		}  
		pluginAdd(); 
		var ret = $("#pluginGrid")[0].initWindow("iGridEditor");
		if (!ret)
		{
			setMessage('创建编辑器失败!','warning');
			result = false;
			return result;
		}              
		var nectresult = setConnect();
		if (nectresult != "" && nectresult.result != "OK")
		{
			
			setMessage('数据库连接失败!','warning');
			result = false;
			return result;
		}	                      
		igrid = true; 
		setRunEMRParams();
	}
	return result;
}
//安装插件提示
function setUpPlug (){
	var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl=" +pluginUrl,"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
	if (result)
	{
		window.location.reload();
	}
};

//查找插件
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
//挂接插件\事件监听
function pluginAdd() {	
	addEvent(plugin(), 'onFailure', function(command){
		alert(command);
	});
    addEvent(plugin(), 'onExecute', function(command){
	   var commandJson = jQuery.parseJSON(command);
	   eventDispatch(commandJson);
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

//异步执行execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//同步执行execute
function cmdSyncExecute(argJson){
	var result = plugin().syncExecute(JSON.stringify(argJson));
	try
	{
		result = jQuery.parseJSON(result);
	}
	catch(err)
	{
		result = "";
	}
	return result;
}

//建立数据库连接
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

//设置默认字体
function SetDefaultFontStyle(){
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
}

//设置工作环境
function setWorkEnvironment(tempParam)
{
	//清空文档
	var argJson = {action:"CLEAN_DOCUMENT",args:""};
	cmdDoExecute(argJson);
	//设置工作空间上下文
	argJson = {action:"SET_WORKSPACE_CONTEXT",args:tempParam["chartItemType"]};
	cmdDoExecute(argJson);
	//设置书写状态
	argJson = {action:"SET_NOTE_STATE",args:"Edit"};
	cmdDoExecute(argJson);
	//设置文字只读颜色
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"0000ff"}};
	cmdDoExecute(argJson);	
}

//设置只读
function setReadOnly(flag,instanceIds)
{
	var argJson = "";
	if (instanceIds == "")
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag,"InstanceID":[""]}};
	}
	else
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag,"InstanceID":[instanceIds]}};
	}
	cmdDoExecute(argJson);
	//文档只读则不能保存，解锁后恢复文档保存权限
	if (flag==false)
	{
		//取文档信息
		var documentContext = getDocumentContext("");
		//设置当前文档是否可保存
		if(documentContext.privelege.canSave == 1)
		{
			parent.setSaveStatus('enable');
		}
	}
}

//设置患者信息
function setPatientInfo()
{
	var diseaseID = parent.$('#disease').combo('getValue');  //add by niucaicai 2016-09-02
	if (diseaseID == "undefined") diseaseID ="";
	var argParams = {"PatientID":patientID,"EpisodeID":episodeID,"UserCode":userCode,"SessionID":sessionID,
	               "UserID":userID,"UserName":userName,"SsgroupID":ssgroupID,"UserLocID":userLocID,
	               "DiseaseID":diseaseID,"IPAddress":ipAddress};
    var argJson = {action: "SET_PATIENT_INFO",args:argParams};
    cmdDoExecute(argJson);
    var userLevel = getUserInfo().UserLevel;
    //设置当前操作者信息
    setCurrentRevisor(userID,userName,ipAddress,userLevel);
    setQualityColor();
}

//设置调用的产品模块的信息
function setProductSource(tempParam)
{
	if (typeof(tempParam.productSource) != "undefined")
	{
		productSourceCode = tempParam.productSource.fromCode;
		productSourceType = tempParam.productSource.fromType;
	}
	else
	{
		productSourceCode = "";
		productSourceType = "EMR";
	}
    var argJson = {action: "SET_PATIENT_INFO",args:{"ProductSourceType":productSourceType,"ProductSourceCode":productSourceCode}};
    cmdDoExecute(argJson);
	
}

//添加或修改病种数据
function setDiseaseData()
{
	var diseaseID = parent.$('#disease').combo('getValue');  //add by niucaicai 2016-09-02
	if (diseaseID == "undefined") diseaseID ="";
	var argJson = {action: "SET_PATIENT_INFO",args:{"DiseaseID":diseaseID}};
	cmdDoExecute(argJson);
}
var _paramNow={};
//创建病历
function createDocument(tempParam)
{
	_paramNow = tempParam;
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var args = "";
	if (tempParam.args) args = tempParam.args;
		
	if (tempParam.actionType == "QUOTATION")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_INSTANCE",args:{"params":args,"InstanceID":tempParam.pInstanceId,"Title":{"DisplayName":tempParam.text}}};
	}
	else if (tempParam.actionType == "CREATEBYEXAMPLE")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_INSTANCE",args:{"params":{"CreateMode":"ReplaceSection","ExampleInstanceID":tempParam.exampleId,SectionList:tempParam.sectionList}}};		
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
	
	//修复通过事件创建病历后插入相关内容到指定章节
	if (tempParam.insert)
	{
		focusDocument("",tempParam.insert.path,"Last");
		insertText(tempParam.insert.content);
	}
	
}

//加载文档
function loadDocument(tempParam)
{
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 
	setProductSource(tempParam);
	setPatientInfo();	                          
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var status = tempParam["status"];
	//加载文档
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":status},InstanceID:tempParam["id"],actionType:tempParam["actionType"]}};
	cmdDoExecute(argJson); 
	
	if (status == "DELETE")
	{
		setReadOnly(true,[tempParam["id"]]);
		parent.setToolBarStatus("disable");
	}
	else
	{
		//设置引导框
		var isMutex = (tempParam["isMutex"]=="1")?true:false;
		var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
		if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
	} 
	_paramNow = tempParam;
	if(parent.cdssTool != undefined&&parent.cdssLock=="Y"){
		parent.cdssTool.getData(_paramNow,"Save");
	}
}

//加载本地文档
function cmdLoadLocalDocument()
{
	var argJson = {action : "LOAD_LOCAL_DOCUMENT", args:{path:""}};
	cmdDoExecute(argJson);
}


//设置创建模板
function setDocTempalte(emrDocId,isMutex,isGuideBox)
{
	var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox,"KBLoadMode":"Replace"}};
	cmdDoExecute(argJson);
}

//插入知识库结点
function appendComposite(kbNodeID)
{
    var argJson = {action:"APPEND_COMPOSITE_ADVANCED",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
    cmdDoExecute(argJson);               
}	

//替换知识库结点
function replaceComposite(kbNodeID)
{
   var argJson = {action:"REPLACE_COMPOSITE",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
   cmdDoExecute(argJson);  
}

//判断当前光标在文档中的位置	
function getElementContext(position)
{
   var argJson = {action:"GET_ELEMENT_CONTEXT",args:{"Type":position}};
   var result = plugin().syncExecute(JSON.stringify(argJson))
   return result;
}

//插入文本
function insertText(text)
{
	var argJson = {action:"INSERT_TEXT_BLOCK",args:text};
	cmdDoExecute(argJson); 
}

//插入带格式文本
function insertStyleText(text)
{ 
	var argJson = {action:"INSERT_STYLE_TEXT_BLOCK",args:text};
	cmdDoExecute(argJson); 
}

//定位文档
function focusDocument(instanceId,path,actionType)
{
	var argJson = {action:"FOCUS_ELEMENT",args:{"InstanceID":instanceId,"Path":path,"actionType":actionType}}
	cmdDoExecute(argJson);
}
//签名
function signDocument(instanceId,type,signLevel,userId,userName,Image,actionType,description,headerImage,fingerImage)
{
	var argJson = {action:"SIGN_DOCUMENT",args:{"InstanceID":instanceId,"Type":type,"SignatureLevel":signLevel,"actionType":actionType,"Authenticator":{"Id":userId,"Name":userName,"Image":Image,"Description":description, "HeaderImage":headerImage,"FingerImage":fingerImage},"params":{}}}
	return cmdSyncExecute(argJson);
}
//获取活动文档上下文
function getDocumentContext(instanceId)
{
	var argJson = {action:"GET_DOCUMENT_CONTEXT",args:{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}
//请求目录大纲
function getOutLine()
{
	var argJson = {"action":"GET_DOCUMENT_OUTLINE","args":""}
	cmdDoExecute(argJson);
}

//获取文档是否被修改过
function getModifyStatus(instanceId)
{
	var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//同步运行脚本
function runSyncScript(scripts) {
    var strJson = {action:"RUN_SCRIPT",args:{Script:scripts}};
    return cmdSyncExecute(strJson);
}

//标注必填项
function markRequiredObject()
{
	var strJson = {action:"MARK_REQUIRED_OBJECTS",args:{"Mark":"True"}};
	return cmdSyncExecute(strJson);
}

//刷新绑定数据
function reloadBinddata(autoRefresh,syncDialogVisible,silentRefresh)
{
	if (typeof(param) == "undefined" || param.id == "GuideDocument") return;
	
	var argJson = {"action":"REFRESH_REFERENCEDATA","args":{"InstanceID":"","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible,"SilentRefresh":silentRefresh}};
	cmdDoExecute(argJson);
	
	//基础平台日志
	setOperationLog(param,"EMR.BinddataReload");
	
}

//导出文档
function exportDocument()
{
	if (!param || param.id == "GuideDocument")
	{
		setMessage('请选中要导出的文档!','forbid');
		return;
	}
	var argJson = {"action":"SAVE_LOCAL_DOCUMENT","args":{}};
	cmdDoExecute(argJson);	
}

//设置文档参数
function setDocumentParam(id,actionType,params)
{
	var argJson = {"action":"SET_DOCUMENT_PARAMS","args":{"InstanceID":id,"actionType":actionType,"params":params}};
	cmdDoExecute(argJson);
}

//设置留痕基本信息
function setCurrentRevisor(userID,userName,ip,userLevel)
{
	if (isSetCurrentRevisorIP == "N") ip=""
	var argJson = {"action":"SET_CURRENT_REVISOR","args":{"Id":userID, "Name":userName,"IP":ip,"Level":userLevel}};
	cmdDoExecute(argJson);		
}

//设置开启关闭留痕
function setRevisionState(InstanceId,status)
{
	var argJson = {action:"SET_REVISION_STATE", args:{"InstanceID":InstanceId,"Mark":status}};
	return cmdSyncExecute(argJson);
}

//显示留痕
function viewRevision(status)
{
	var argJson = {action:"SET_REVISION_VISIBLE",args: {"Visible":status}}
	cmdDoExecute(argJson);
}

//设置ASR语音识别状态
function setASRVoiceStatus(status,productName)
{
	var argJson = {action:"SET_ASR_VOICE_STATE",args:{"Open":status,"ProductName":productName}};
	cmdDoExecute(argJson);
}

//修改或追加单元内容
function updateInstanceData(actiontype,instanceID,path,value) {
    var strJson = {action: "UPDATE_INSTANCE_DATA",args: {"actionType":actiontype,"InstanceID":instanceID,"Path":path,"Value":value}};
    cmdDoExecute(strJson);
}

//插入牙位图
function insertTooth(toothImageType,returnValue)
{
	if (toothImageType == "new")
	{
		var strJson = {action:"INSERT_TEETH_IMAGE",args:returnValue};
	}
	else if (toothImageType == "open")
	{
		var strJson = {action:"REPLACE_TEETH_IMAGE",args:returnValue};
	}

	//var strJson = eval("("+tempStrJson+")");
	/*
	var strJson = {
		action:"INSERT_TEETH_IMAGE",
		args:{
			"InstanceID":"",
			"ShowMode":"恒牙",
			"UpLeftAreaTeeth":[
				{"ToothCode":"AUL.1","ToothValue":"1","ToothSurfaceValue":"P,L","ToothSurfaceItems":
					[
						{"Code":"AUL.1.P","Value":"上颌左侧中切牙腭侧","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.1.L","Value":"上颌左侧中切牙舌侧","ScriptMode":"SuperScript/SubScript"}
					]
				},
				{"ToothCode":"AUL.2","ToothValue":"2","ToothSurfaceValue":"P,L,B,D,O,M,I,R,T","ToothSurfaceItems":
					[
						{"Code":"AUL.2.P","Value":"上颌左侧侧切牙腭侧","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.L","Value":"上颌左侧侧切牙舌侧","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.B","Value":"上颌左侧侧切牙颊侧","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.D","Value":"上颌左侧侧切牙远中面","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.O","Value":"上颌左侧侧切牙牙合面","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.M","Value":"上颌左侧侧切牙近中面","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.I","Value":"上颌左侧侧切牙切缘","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.R","Value":"上颌左侧侧切牙根","ScriptMode":"SuperScript/SubScript"},
						{"Code":"AUL.2.T","Value":"上颌左侧侧切牙冠","ScriptMode":"SuperScript/SubScript"}
					]
				}
			],
			"UpRightAreaTeeth":"",
			"DownLeftAreaTeeth":"",
			"DownRightAreaTeeth":""
		}
	};
	alert(strJson);
	*/
	cmdDoExecute(strJson);
}

//保存文档
function cmdsaveDocument()
{
	var argJson = {action:"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT"}}};
	cmdDoExecute(argJson);		
}

///失效签名
function cmdRevokeSignedDocument(signatureLevel,instanceId)
{
	var argJson = {"action":"REVOKE_SIGNED_DOCUMENT","args":{"SignatureLevel":signatureLevel,"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//保存签名文档及相关操作
function saveSignDocument(instanceId,signUserId,signLevel,signId,digest,type,path,actionType)
{
	var argJson = {action:"SAVE_SIGNED_DOCUMENT",args:{params:{"action":"SAVE_SIGNED_DOCUMENT","SignUserID":signUserId,"SignID":signId,"SignLevel":signLevel,"Digest":digest,"Type":type,"Path":path,"ActionType":actionType},"InstanceID":instanceId}}
	cmdDoExecute(argJson);
}

//回滚签名
function unsignDocument()
{
	var argJson = {action:"UNSIGN_DOCUMENT",args:{}}
	cmdDoExecute(argJson);	
}

//撤销签名
function revokeSignElement(signProperty)
{
	var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel}}}};
	return cmdSyncExecute(argJson);
}

//按章节保存
function saveSection(param)
{
	var argJson = {"action":"SAVE_SECTION","args":{"params":{"CategoryID":param.CategoryID,"UserID":param.UserID,"Name":param.Name,"action":"SAVE_INSTANCE_SECTION"}}};
	return cmdSyncExecute(argJson);
}

//打印文档
function printDocument()
{
	if (getModifyStatus("").Modified == "True")
	{
		var text = '文档正在编辑，请保存后打印，是否保存？';
		//判断客户端浏览器IE及其版本
		if ($.browser.msie && $.browser.version == '6.0')
		{
			returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}else
		{
			returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}
		if (returnValues == "save")
		{
			saveDocument();
		}
		else
		{
			return;
		}
	} 
	var qualityResult = qualityPrintDocument();
	if (qualityResult) return; 
	//取文档信息
	var documentContext = getDocumentContext("");
	if ((documentContext.status != undefined)&&(documentContext.status.curAction == "print"))
	{
		var text = '病历 "'+ param.text + '"已打印，是否确认继续打印！';
		var Values = "";
		if ($.browser.msie && $.browser.version == '6.0')
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}else
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}
		if (Values == "cancel") return;
	}
	//打印
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print"}}; 
 	cmdDoExecute(argJson);	
}

//质控
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

//保存文档
function saveDocument()
{
	var flag = "save"
	//取文档信息
	var documentContext = getDocumentContext("");
	var modifyResult = getModifyStatus("");
	//判断病历被修改且上一次操作是打印,则弹出病历已打印的提醒框
	if ((documentContext.status.curAction == "print")&&(modifyResult.Modified == "True"))
	{
		var text = '病历 "' +param.text + '" 已打印，是否确认保存修改！';
		var Values = "";
		if ($.browser.msie && $.browser.version == '6.0')
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}else
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}
		if (Values == "cancel") return;
	}
	var escapeRevokeSignDocIDArray = new Array(); 
	escapeRevokeSignDocIDArray = escapeRevokeSignDocID.split("^");
	if ((isRevokeSign == "Y")&&($.inArray(param.emrDocId,escapeRevokeSignDocIDArray) == -1))
	{
		if (revokeSignedDocument(modifyResult)) flag = "revoke";
	}
	else
	{
		cmdsaveDocument();
	}
	return flag;
}

///撤销签名
function revokeSignedDocument(modifyResult)
{
	var result = false;
	var noSign = false;
	if (modifyResult.Modified == "False") checkRequiredCell();
	for (var i=0;i<modifyResult.InstanceID.length;i++)
	{
		var instanceId = modifyResult.InstanceID[i];
		var documentContext = getDocumentContext(instanceId);
		var userLevel = getUserInfo().UserLevel;
		if (revokeStatus()!= "Superior") userLevel = "";
		var revokeResult = cmdRevokeSignedDocument(userLevel,instanceId);
		if (revokeResult.result == "ERROR")
		{
			setMessage('失效文档失败!','warning');
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

			//设置当前文档操作权限
			setPrivelege(tmpDocContext);
		    //当前文档状态
		    setStatus(tmpDocContext);

			//修改文档目录
			modifyInstanceTree(tmpDocContext);
			setMessage('数据保存成功,签名已失效!','alert');
			
			//启用病历信息订阅与发布
			if (Observer == "Y") GetObserverData();

			//质控
			qualitySaveDocument();
			getNewMenu();
			//保存日志(基础平台组)
			setOperationLog(param,"EMR.Save");	
		}	
	}
	if (noSign)
	{
		cmdsaveDocument();
	}
    return result; 
}

///当前用户信息
function getUserInfo()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":userCode,
			"p2":"",
			"p3":userLocID
		},
		success: function(d) {
			if (d != "")
			{
				result = eval("("+d+")");
				if (signLogic == "Custom")
				{
					var temp =  getEpisodeThreeDoctor(result);
					if (temp.flag == 1)
					{
						result = temp.userInfo;
					}
				}
			}
		},
		error: function(d) {alert("error");}
	});	
	return result;	
}

//是否调用签名失效
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

//文档保存质控
function qualitySaveDocument()
{
	var result = false;
	result = checkRequiredCell();
	if (result == true) 
	{
		setMessage('有未完成项目,请检查!','forbid');
		return result;
	}
	//打散数据质控
	var eventType = "Save^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			var strQualityData = strQualityData.replace(new RegExp(';','gm'),'\n')
			alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

//签名质控
function qualitySignDocument()
{
	var result = false;
	result = checkRequiredCell();
	if (result == true) 
	{
		setMessage('有未完成项目不能签名,请处理!','forbid');
		return result;
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
			var strQualityData = strQualityData.replace(new RegExp(';','gm'),'\n')
			alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

//打印质控
function qualityPrintDocument()
{
	var result =  false;
	result = checkRequiredCell();
	if (result == true) 
	{
		setMessage('有未完成项目不能打印,请处理','forbid');
		return result;
	}
	//病历质控
	var eventType = "Print^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			var strQualityData = strQualityData.replace(new RegExp(';','gm'),'\n')
			alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

///检查必填项
function checkRequiredCell()
{
	var result =  false;
	if ((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
	{
		//脚本检查
		var resultMarkRequired = markRequiredObject();
		if (resultMarkRequired.MarkCount>0) result = true;
	}
	return result;
}

// 打开签名窗口
function audit(signProperty)
{
	var qualityResult = qualitySignDocument();
	if (qualityResult) return; 
	var documentContext = getDocumentContext("");
    var canRevokCheck = documentContext.privelege.canRevokCheck;
    if (pluginType != "GRID") canRevokCheck =0;
    var tmpInstanceId = signProperty.InstanceID;
    var openFlag = episodeType=="O"?"0":"1";
   	if (signProperty.OriSignatureLevel.toUpperCase() == 'PATIENT') 
   	{
		var argEditor = {
			instanceId: tmpInstanceId,
			signDocument: signDocument,
			saveSignedDocument: saveSignDocument,
            unSignedDocument: unsignDocument,
            episodeID:episodeID,
			//signProperty: signProperty
			actionType: (function () {
			    if (signProperty.Authenticator.length>0) {
					return 'Replace';
				}
				else {
					return 'Append';
				}	
			})()
		};
		handSign.sign(argEditor);
		return;
	}
	if ('1' == CAServicvice) 
	{
		var signParam = {"topwin":window.parent,"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		if (CAVersion == "2")
		{
			var ca_key = window.parent.ca_key;
            
            if (ca_key.SignType == "UKEY"){
                var returnValues = window.showModalDialog("emr.record.signca.csp?UserName="+userName+"&UserID="+userID+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID,signParam,"dialogHeight:200px;dialogWidth:300px;resizable:yes;status:no");
            } else {
                var certObj = ca_key.LoginForm({forceLogin:false,hisUserID:userID});
                if ((certObj.retCode == "0")&&(certObj.hisUserID != "")) {
                    var userInfo = ajaxLoginCA(certObj,ca_key.VenderCode,ca_key.SignType);
                    if (userInfo != "") {
                        returnValues = '{"action":"sign","userInfo":'+userInfo+'}';
                    }
                }
            }
			
			returnValues = returnValues||"";
		}
		else
		{
			var returnValues = window.showModalDialog("emr.record.signca.csp?UserName="+userName+"&UserID="+userID+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID,signParam,"dialogHeight:200px;dialogWidth:300px;resizable:yes;status:no");
		}
		if (returnValues != "" && returnValues != undefined)
		{
			returnValues = eval("("+returnValues+")");
			userInfo = returnValues.userInfo;
            if (userInfo == "") 
            {
                return;
            }
			if ((userInfo.UserLevel == "")&&(userInfo.UserPos == "")&&(signProperty.OriSignatureLevel !== "All"))
			{
				setMessage('请先维护用户级别','forbid');
				return;	
			}
			if (returnValues.action == "sign")
			{
				if (userInfo.Type == "Graph" && userInfo.Image == "")
				{
					setMessage('签名图片未维护，请维护','forbid');
					return;
				}	
				if (CAVersion == "2")
				{
                    if (ca_key.SignType == "UKEY"){
						caSign(signProperty,userInfo,tmpInstanceId);
					} else {
                        caSignMobile(signProperty,userInfo,tmpInstanceId,certObj);
                    }
				}
				else
				{
					caSign(signProperty,userInfo,tmpInstanceId);
				}
			}
			else if (returnValues.action == "revoke")
			{
				if (userInfo.UserID != signProperty.Id)
				{
					setMessage('非本人签名,不能撤销','forbid');
					return;
				}
				var ret = revokeSignElement(signProperty);
				if (ret.result == "OK")
				{
					setMessage('撤销成功','alert');
				}
				else
				{
					setMessage('撤销失败','warning');
				}
			}	
		}
	}
	else
	{
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var returnValues = window.showModalDialog("emr.record.sign.csp?UserName="+userName+"&UserCode="+userCode+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID,signParam,"dialogHeight:220px;dialogWidth:300px;resizable:yes;status:no");
		if (returnValues != "" && returnValues != undefined)
		{
			returnValues = eval("("+returnValues+")");
			userInfo = returnValues.userInfo;	
			if ((userInfo.UserLevel == "")&&(userInfo.UserPos == "")&&(signProperty.OriSignatureLevel !== "All"))
			{
				setMessage('请先维护用户级别','forbid');
				return;	
			}		
			if (returnValues.action == "sign")
			{
				if (userInfo.Type == "Graph" && userInfo.Image == "")
				{
					setMessage('签名图片未维护，请维护','forbid');
					return;
				}
				checkSign(signProperty,userInfo,tmpInstanceId,documentContext);	
			}
			else if (returnValues.action == "revoke")
			{
				if (userInfo.UserID != signProperty.Id)
				{
					setMessage('非本人签名,不能撤销','forbid');
					return;
				}
				var ret = revokeSignElement(signProperty);
				if (ret.result == "OK")
				{
					setMessage('撤销成功','alert');
				}
				else
				{
					setMessage('撤销失败','warning');
				}
			}
			
		}
	}
}

//登录，返回用户名，和签名图片
function ajaxLoginCA(certObj,venderCode,signType) {
    var loginInfo = '';
    
	var strServerRan = "";
	var UserSignedData = "";
	
	var cert = certObj.signCert;
    var UsrCertCode = certObj.userCertCode;
    var certificateNo = certObj.certNo;
	var hisUserID = certObj.hisUserID;
	$.ajax({
        type: 'post',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
        		"OutputType":"String",
				"Class":"EMRservice.BL.BLEMRSign",
				"Method":"CALogin",
				"p1":strServerRan,
				"p2":UsrCertCode,
            	"p3":UserSignedData,
            	"p4":certificateNo,
            	"p5":cert,
            	"p6":userLocID,
            	"p7":"inpatient",
            	"p8":episodeID,
            	"p9":signType,
            	"p91":venderCode
        },
        success: function(ret) 
        {
            if (ret && ret.Err) 
            {
                alert(ret.Err);
            } 
            else
            {
	            loginInfo = ret;
	        }
        },
        error: function(ret) {}
    });
    
    return JSON.stringify(loginInfo);
}

//数字签名
function caSign(signProperty,userInfo,instanceId)
{
	//权限检查
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;

	//开始签名
	var cert = parent.GetSignCert(parent.strKey);
    var UsrCertCode = parent.GetUniqueID(cert);
    if (!UsrCertCode || '' == UsrCertCode) return '用户唯一标示为空！';
    if (CAVersion == "2")
	{
		var certNo = parent.GetCertNo(parent.strKey);
	}
	else
	{
		var certNo = ""
	}
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    alert('签名原文为空！');
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
			"p3":signInfo.Digest,
			"p4":certNo
        },
        success: function(ret) {
            if (ret && ret.Err) 
            {
                unsignDocument();
                setMessage(ret.Err,'forbid');
            } 
            else 
            {
                saveSignDocument(instanceId,userInfo.UserID,signlevel,ret.SignID,signInfo.Digest,"CA",signInfo.Path,actionType)
				//签名成功后，判断是否需要发送消息给Portal系统
				if (IsSetToPortal == "Y")
				{
					setInfoToPortal(userInfo.UserID);
				}
            }
        },
        error: function(ret) {alert(ret);}
    });
}

//数字签名
function caSignMobile(signProperty,userInfo,instanceId,certObj)
{
	//权限检查
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;

	//开始签名
	var cert = parent.GetSignCert(certObj.certContainer);
    var UsrCertCode = parent.GetUniqueID(cert);
    if (!UsrCertCode || '' == UsrCertCode) return '用户唯一标示为空！';
    
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    alert('签名原文为空！');
	    return ;
	}
    var signValue = parent.SignedData(signInfo.Digest,certObj.certContainer,episodeID);
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
			"p3":signInfo.Digest,
			"p4":certObj.certNo
        },
        success: function(ret) {
            if (ret && ret.Err) 
            {
                unsignDocument();
                setMessage(ret.Err,'forbid');
            } 
            else 
            {
                saveSignDocument(instanceId,userInfo.UserID,signlevel,ret.SignID,signInfo.Digest,"CA",signInfo.Path,actionType)
				//签名成功后，判断是否需要发送消息给Portal系统
				if (IsSetToPortal == "Y")
				{
					setInfoToPortal(userInfo.UserID);
				}
            }
        },
        error: function(ret) {alert(ret);}
    });
}

//系统签名
function checkSign(signProperty,userInfo,instanceId,documentContext)
{
	//权限检查
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;	
	if ((actionType == "Append" && documentContext.privelege.canCheck == 0) || (actionType == "Replace" && documentContext.privelege.canReCheck == 0))
	{
		setMessage("没有权限签名",'forbid');
		return
	}
	
	//开始签名
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");
	if (signInfo.result == "OK")
	{
		saveSignDocument(instanceId,userInfo.UserID,signlevel,"","","SYS",signInfo.Path,actionType);
		
		//签名成功后，判断是否需要发送消息给Portal系统
		if (IsSetToPortal == "Y")
		{
			setInfoToPortal(userInfo.UserID);
		}
	}
	else
	{
		setMessage('签名失败','warning');
	}		
}

///取为患者设定的三级医师
function getEpisodeThreeDoctor(userInfo)
{
	var result = {};
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetThreeLevelDoctor",
			"p1":episodeID
        },
        success: function(ret) {
            if (ret == "")
            {
	            result.flag = "0";
	            result.message = "没维护三级医师";
	            return result;
	        } 
			for (var i=0;i<ret.length;i++)
			{
				if (ret[i].Id == userInfo.UserID) 
				{
					userInfo.UserLevel = ret[i].level;
					userInfo.LevelDesc = ret[i].desc;
					result.flag = "1";
					result.message = "";
					result.userInfo = userInfo;
					break;
				}
			}
			if (result.flag ==undefined || result.flag != "1")
			{
				result.flag = "0";
				result.message = "该用户不是该患者的责任医师,无权限签名";
			}

        },
        error: function(ret) {alert(ret);}
    });
    return result;	
}

//检查签名权限脚本
function checkPrivilege(userInfo,signProperty)
{
	var result = {"flag":false,"ationtype":""};
	if (signLogic == "Custom")
	{
		var tempResult = getEpisodeThreeDoctor(userInfo);
		if (tempResult.flag !== "1") 
		{
			setMessage(tempResult.message,'forbid');
	   		return result;	
		}
		else
		{
			userInfo = tempResult.userInfo; 
		}
	}	
	var count = signProperty.Authenticator.length;
	if ((count >0) && (signProperty.Id == userInfo.UserID) && (isEnableSelectUserLevel != "Y"))
	{
		result = {"flag":false,"ationtype":""};
		setMessage('已签名,不必再签','forbid');
	    return result;
	}
	
	var signArray = ["All","QCDoc","QCNurse","ChargeNurse","student","intern","Refresher","Coder"];
	
	if ($.inArray(signProperty.OriSignatureLevel, signArray) != -1)
	{
		if (count>0)
		{
			//改签
			if (confirm("已签名，是否改签")==true)
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
			//签名
			 result = {"flag":true,"ationtype":"Append"};
		}
	}
	else if (signProperty.OriSignatureLevel == "Check")
	{
		if (count <=0)
		{
			//签名
			result = {"flag":true,"ationtype":"Append"};
		}
		else
		{
			if (userInfo.UserLevel == "student")
			{
				if (count == 1 && signProperty.SignatureLevel == "student")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
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
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
	
			}
			else if (userInfo.UserLevel == "intern")
			{
				if (count == 1 && signProperty.SignatureLevel == "intern")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
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
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
	
			}	
			else if (userInfo.UserLevel == "Resident")
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["Attending","ViceChief","Chief"]) != -1)
					{
						flag = 1
						break;
					} 
				}
				
				if (flag == 1)
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
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
					//签名
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if (signProperty.SignatureLevel == "Resident")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
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
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
			}
			else if (userInfo.UserLevel == "Attending")
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["ViceChief","Chief"]) != -1)
					{
						flag = 1
						break;
					} 
				}
				
				if (flag == 1)
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
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
					//签名
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if (signProperty.SignatureLevel == "Attending")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
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
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
			}			
			else if ($.inArray(userInfo.UserLevel,["Chief","ViceChief"]) != -1)
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["Chief","ViceChief"]) != -1)
					{
						flag = 1
						break;
					} 
				}
				if (flag != 1)
				{
					//签名
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if ($.inArray(signProperty.SignatureLevel,["Chief","ViceChief"]) != -1)
				{
					//改签
					if (confirm("已签名，是否改签")==true)
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
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}				
			}
		}
	}
	else if(signProperty.OriSignatureLevel == "Resident")
	{
		//住院医师签名可签上级
		if ($.inArray(userInfo.UserLevel,["Chief","ViceChief","Attending","Resident"]) != -1)
		{
			if (count <=0)
			{
				//签名
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//改签
				if (confirm("已签名，是否改签")==true)
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
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("无权限签名","forbid");			
		}
	}
	else if (signProperty.OriSignatureLevel == "Attending")
	{
		//住治医师签名可签上级
		if ($.inArray(userInfo.UserLevel,["Attending","ViceChief","Chief"]) != -1)
		{
			if (count <=0)
			{
				//签名
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//改签
				if (confirm("已签名，是否改签")==true)
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
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("无权限签名","forbid");			
		}	
	}
	else if ($.inArray(signProperty.OriSignatureLevel,["ViceChief","Chief"]) != -1)
	{
		//主任副主任可签
		if ($.inArray(userInfo.UserLevel,["ViceChief","Chief"]) != -1)
		{
			if (count <=0)
			{
				//签名
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//改签
				if (confirm("已签名，是否改签")==true)
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
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("无权限签名","forbid");			
		}		
	}
	else 
	{
		if (signProperty.OriSignatureLevel != userInfo.UserLevel && signProperty.OriSignatureLevel != userInfo.UserPos)
		{
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("签名身份不符，无权限签名","forbid");
		}
		else if (count > 0)
		{
			//改签
			if (confirm("已签名，是否改签")==true)
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
			//签名
			result = {"flag":true,"ationtype":"Append"};		
		}
	}
	return result;	
}

//设置权限
function setPrivelege(documentText)
{
	if (documentText == null) return;
	if (documentText.result == "ERROR") return;
	if (documentText.status.curStatus == "deleted") return;
	
	var privelegeJson = {"action":"setToolbar","status":documentText.privelege};
	parent.eventDispatch(privelegeJson);
	
	//判断文档是否只读，只读则使文档不能保存
	if (getReadOnlyStatus().ReadOnly == "True")
	{
		parent.setSaveStatus('disable');
	}
	
	if (documentText.privelege.canSave == "0")
	{
		setReadOnly(true,[documentText.InstanceID]);
	}
	else
	{
		if (documentText.privelege.canRevise == "-1" && documentText.status.signStatus == "1")
		{
			if (setRevisionState(documentText.InstanceID,true).result != "OK") alert("开启留痕失败");
		}
		else if (documentText.privelege.canRevise == "1")
		{
			if (setRevisionState(documentText.InstanceID,true).result != "OK") alert("开启留痕失败");
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

//设置状态
function setStatus(documentText)
{
	if (documentText == null) return;
	if (documentText.result == "ERROR") return;
	curStatus = documentText.status.curStatus;			
}

//删除病历
function deleteDocument()
{
	var documentContext = getDocumentContext("");
	if (documentContext.result == "ERROR")
	{
		setMessage('请先选中文档再删除!','warning');
		return;
	}
	var instanceId = documentContext.InstanceID;
	var titleName = documentContext.Title.DisplayName;
	var status = documentContext.status.curStatus;	
	if (status == undefined)
	{
		setMessage('请先选中文档再删除!','warning');
		return;
	}
	var tipMsg = "是否确定删除 "+titleName+"?";
	var flag= false;
	if (isFavoriteRecord(instanceId) != "0")
	{
		flag = true;
		tipMsg = titleName+" 曾经被收藏过,是否确定删除？";
		if (!window.confirm(tipMsg)) return;
	}
	//签名状态提醒
	if ((status != "finished")&&(status != "")&&(status != "deleted"))
	{
		flag = true;
		tipMsg = titleName+" 已经签名,是否确定删除？";
		if (!window.confirm(tipMsg)) return;
	}
	//普通删除提醒
	if (!flag)
	{
		if (!window.confirm(tipMsg)) return;
	}
	if (isDeleteVerification == "Y")
	{
		var creatorMessage = getCreatorMessage(instanceId);
		if (creatorMessage != "")
		{
			if ((creatorMessage[0].creatorID != "")&&(creatorMessage[0].creatorName != ""))
			{	
				var result = window.showModalDialog("emr.userverification.delete.csp?UserID="+creatorMessage[0].creatorID+"&UserName="+creatorMessage[0].creatorName,"","dialogHeight:200px;dialogWidth:180px;resizable:no;status:no");
				if ((result == "")||(typeof(result) == "undefined")) 
				{
					return;
				}
				else if(result == "0")
				{
					alert("密码验证失败");
					return;
				}
			}
		}
	}
	if (param.IsActive != "N") param.IsActive = "N";
	var json = {action:"DELETE_DOCUMENT",args:{"InstanceID":instanceId}};
	cmdDoExecute(json);	
}

//提示当前病历是否被收藏
function isFavoriteRecord(instanceId)
{
	var result = "0";
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
			if (data != "0")
			{
				result = data;
			}
		 }
	});
	return result;	
}

//取消收藏的病历
function CancelFavRecrod(favInfoId,instanceId)
{
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=CancelFavRecrod&FavInfoID="+favInfoId+"&EpisodeID="+episodeID+"&InstanceID="+instanceId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data === "0")
        	{
		        alert("取消收藏的病历失败!");
		    }
        } 
    });
}


//获取当前病历创建者code和name
function getCreatorMessage(instanceId)
{
	var result = "";
	$.ajax({
		type: "GET",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRLogs",
			"Method":"GetCreatorMessage",
			"p1":instanceId
		},
		success: function (data){
			if (data != "")
			{
				result = eval("["+data+"]");
			}
		 }
	});
	return result;	
}

//事件派发
function eventDispatch(commandJson)
{
	if(commandJson["action"] == "eventMRSetView")                   
	{
		//创建网格视图完毕加载网格文档
	    eventCreatorReportorView();
	}
	else if(commandJson["action"] == "eventDocumentChanged")        
	{
		//文档改变
		eventDocumentChanged(commandJson);
	}
	else if(commandJson["action"] == "eventSectionChanged")          
	{ 
		//章节改变
		eventSectionChanged(commandJson);
	}
	else if (commandJson["action"] == "eventSaveDocument")      
	{
		//保存监听
		eventSaveDocument(commandJson);
	}
	else if (commandJson["action"] == "eventQuerySaveDocument")
	{
		//提示用户保存文档
		eventQuerySaveDocument();
	}
	else if (commandJson["action"] == "eventGetDocumentOutline")
	{
		//获得文档大纲
		eventGetDocumentOutline(commandJson);
	}	
	else if(commandJson["action"] == "eventCreateDocument")
	{
		//创建文档后事件
		eventCreateDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSaveSignedDocument")
	{
		//文档签名
		eventSaveSignedDocument(commandJson);
	}
	else if(commandJson["action"] == "eventDeleteDocument")
	{
		eventDeleteDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSave")
	{
		//ctrl+s保存事件
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
		//判断知识库是否替换成功
		eventReplaceView(commandJson);
	}
	else if (commandJson["action"] == "eventRefreshReferenceData")
	{
		//刷新引用数据
		eventRefreshReferenceData(commandJson);
	}
	else if(commandJson["action"] == "eventHyperLink")
	{
		//连接单元
		eventHyperLink(commandJson);
	}
	else if(commandJson["action"] == "eventUpdateInstanceData")
	{
		eventUpdateInstanceData(commandJson);
	}
	else if(commandJson["action"] == "eventInsertTeethImage")
	{
		//双击牙位图图片单元，弹出牙位图选择窗口
		eventInsertTeethImage(commandJson);
	}
	else if(commandJson["action"] == "eventRequestTeeth")
	{
		//双击牙位图图片单元，弹出牙位图选择窗口
		eventRequestTeeth(commandJson);
	}
	else if(commandJson["action"] == "eventReplaceTeethImage")
	{
		//双击牙位图图片单元，弹出牙位图选择窗口修改牙位信息后，重新插入牙位图图片
		eventReplaceTeethImage(commandJson);
	}
	else if(commandJson["action"] == "eventRequestImgData")
	{
		eventRequestImgData(commandJson);
	}
    else if(commandJson["action"] == "Event_EMR_HrartBeat_Status")
	{
        //根据编辑器活跃状态判断是否调用平台接口防止锁屏
        if (commandJson["args"]["Status"] == "Active") 
        {
	        if ((typeof websys_getMenuWin != "undefined")&&(typeof websys_getMenuWin().lockScreenOpt != "undefined")&&(typeof websys_getMenuWin().lockScreenOpt.userOperation!="undefined"))
	    	{
		    	websys_getMenuWin().lockScreenOpt.userOperation();
		    }     
	    }
    }
    	else if(commandJson["action"] == "Event_Title_Superior_Doctor")
	{
		eventTitleSuperiorDoctor(commandJson);
	}else if(commandJson["action"] == "eventRequestKnowledgeBase"){
		eventRequestKnowledgeBase(commandJson);
	}
}
//ctrl+k 快捷键请求
function eventRequestKnowledgeBase(commandJson){
	//快捷键请求惠每
	if(parent.cdssTool != undefined && parent.cdssLock=="Y"){
		parent.cdssTool.getData(_paramNow,"Save");
	}
}
//将病程记录中所选的医师信息记录下来
function eventTitleSuperiorDoctor(commandJson)
{
	if ((commandJson["args"]["DoctorID"] == "")||(commandJson["args"]["InstanceID"] == "")) return;
	jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : true,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLRecordTitleSuperiorDoctor",
				"Method":"AddTitleSuperiorDoctor",			
				"p1":commandJson["args"]["DoctorID"],
				"p2":commandJson["args"]["DoctorLevelCode"],
				"p3":commandJson["args"]["DoctorLevelDescription"],
				"p4":commandJson["args"]["DoctorName"],
				"p5":commandJson["args"]["InstanceID"]
			}
	});	
}

//将是否显示绑定数据提示框状态存入表中
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
		
		if (pageType == "INSU")
		{
			saveDocument();
		}
	}
}

//判断知识库是否替换成功
function eventReplaceView(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		setMessage('知识库替换成功!','alert');
	}
	else
	{
		setMessage('知识库替换失败!','warning');
	}
}

//文档导出
function eventSaveLocalDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		//基础平台组审计和日志记录
		setOperationLog(param,"EMR.Export.Save");	
	}
}

//文档改变事件
function eventDocumentChanged(commandJson)
{
	unlockSpecial();
	isEditMultiRecord(commandJson);
	//更新当前实例文档ID
	param.id = commandJson["args"]["InstanceID"]; 
	param.text = commandJson["args"]["Title"]["DisplayName"];
	//更新当前标题
	titleCode = commandJson["args"]["Title"]["Code"];
	//取文档信息
	var documentContext = getDocumentContext(param.id);
	//设置当前文档操作权限
	setPrivelege(documentContext);
    //当前文档状态
    setStatus(documentContext);
	//选中当前文档目录
	setSelectRecordColor(param.id);
	lockSpecial(documentContext);
}

//章节改变事件
function eventSectionChanged(commandJson)
{
	//var diseaseID = parent.$("#disease").find("option:selected").val();
	/*
	// 由于父页面中的病种树采用zTree形式的树，所以不在使用此方法获取病种树选中节点的ID  modify by niucaicai 2016-04-28
	var diseaseTree = parent.$('#disease').combotree('tree');
	var diseaseNode = diseaseTree.tree('getSelected');
	var diseaseID = diseaseNode.attributes.rowID;
	*/
	var diseaseID = parent.$('#disease').combo('getValue');  //add by niucaicai 2016-09-02
	if (diseaseID == "undefined") diseaseID ="";
	//刷新知识库
    var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:commandJson["args"]["BindKBBaseID"],"titleCode":titleCode,"diseaseID":diseaseID};
    parent.eventDispatch(paramJson);
    //定位章节
    var path = commandJson["args"]["InstanceID"]+"_"+commandJson["args"]["Path"];
    if (path == "") return;
    //focusOutLine(path);	
}
//保存事件监听
function eventSaveDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
	    if (commandJson["args"]["params"]["result"] == "OK")
	    { 
			//取文档信息
			param.id = commandJson["args"]["params"]["InstanceID"];
			var documentContext = getDocumentContext(param.id);
			if (documentContext.result == "ERROR") return;
			
			//设置当前文档操作权限
			setPrivelege(documentContext);
		    //当前文档状态
		    setStatus(documentContext);
		    
			//修改危急值事件的IsActive字段
			modifyCriticalEventValue(commandJson["action"]);
			
			//修改文档目录
			modifyInstanceTree(documentContext);
			setMessage('数据保存成功!','alert');
			//启用病历信息订阅与发布
			if (Observer == "Y")
			{
				GetObserverData();
			}
			//质控
			qualitySaveDocument();
			getNewMenu();
			if (typeof (param.args) != "undefined" && typeof (param.args.event.EventID) != "undefined" && param.args.event.EventID !="")
	   		{
		   		parent.getEvent();
		   	} 
			if(parent.cdssTool != undefined && parent.cdssLock=="Y"){
				parent.cdssTool.getData(_paramNow,"Save");
			}
			//入院记录-临床路径的入径判断
			getClinicPath(param);
	   		//保存日志(基础平台组)
			setOperationLog(param,"EMR.Save");
	    }
	}
	else if (commandJson["args"]["result"] == "ERROR")
	{
		if ((commandJson["args"]["params"]["desc"]!="")&&(typeof(commandJson["args"]["params"]["desc"])!="undefined"))
		{
			setMessage(commandJson["args"]["params"]["desc"],'forbid');
		}
		else
		{
			setMessage('保存失败','warning');
		}
	}
	else if (commandJson["args"]["result"] != "NONE")
	{
		setMessage('文档没有发生改变','warning');
	}
}

//同步患者基本信息选项卡列表
function GetObserverData()
{
	var returnValues = "";
	//获取电子病历信息同步选项卡数据
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
			alert("同步信息获取失败!");
        }, 
        success: function (d)
        {
        	if (d != "")
        	{
	        	var data = eval("["+d+"]");
	        	$.each(data, function(index, item){
		        	if (item.Type == "PaPatMas")
		        	{
			        	var array = {
				        	"data":item.children,
							"patientID":patientID,
							"userID":userID
						};
						returnValues = window.showModalDialog("emr.observerdata.csp",array,"dialogWidth:607px;dialogHeight:313px;resizable:yes;center:yes;status:no;");
					}else if (item.Type == "WMRInfection")
					{
						$.each(item.children, function(childindex, childitem){
							//传染病上报
							ReportWMRInfection(childitem.ActionInfo);
						});
					}else if (item.Type == "NosocomialInfection")
					{
						$.each(item.children, function(childindex, childitem){
							//院内感染
							ReportWMRInfection(childitem.ActionInfo);
						});
					}
        		});
	        }
        } 
    });
    if (returnValues)
	{
		parent.$("#patientInfo").empty();
		parent.getPatinentInfo();
		window.setTimeout("setMessage('同步数据项数据保存成功!','alert')",messageScheme['alert']);
	}
}
// 传染病上报,院内感染界面
function ReportWMRInfection(reportInfectionUrl)
{
	if (reportInfectionUrl == "") return;
	
	var c1 = String.fromCharCode(1);
	var arrReportInfection = reportInfectionUrl.split(c1);
	if (arrReportInfection[0] == "0")
	{
		alert(arrReportInfection[1]);
	}
	else if (arrReportInfection[0] == "1")
	{
		if (!window.confirm(arrReportInfection[1])) return;
		var c2 = String.fromCharCode(2);
		var arrReportInfectionUrl = arrReportInfection[2].split(c2);
		for (var i=0; i<arrReportInfectionUrl.length; i++)
		{
			if (arrReportInfectionUrl[i] == "") continue;
			try
			{
				if (arrReportInfectionUrl[i].indexOf('dhchai.ir.inf.report.csp')>-1){
					window.showModalDialog(arrReportInfectionUrl[i],"","dialogHeight:800px;dialogWidth:1280px;resizable:yes;center:yes;status:no;");
				}
				else if (arrReportInfectionUrl[i].indexOf('dhcma.rd.report.csp')>-1){
					window.showModalDialog(arrReportInfectionUrl[i],"","dialogHeight:800px;dialogWidth:1280px;resizable:yes;center:yes;status:no;");
				}  else {
					window.showModalDialog(arrReportInfectionUrl[i],"","dialogHeight:800px;dialogWidth:800px;resizable:yes;center:yes;status:no;");
				}
			}catch(e)
			{
				alert(e.message);
			}
		}
  }
}

//判断入院记录有无符合诊断描述的临床路径
function getClinicPath(param)
{
	$.ajax({ 
		type: "post",
		dataType: "text", 
		url: "../EMRservice.Ajax.common.cls",
		async : false,
		data:{
			"OutputType":"String",
			"Class":"EMRservice.BL.ClinicDiagPath",
			"Method":"GetClinicPath",
			"p1":episodeID,
			"p2":param.emrDocId,
			"p3":param.id
		},
		error: function(d)
		{
			alert("GetClinicPath方法获取失败!");
		},
		success: function (d)
		{
			if(d != "") {
				window.showModalDialog("dhcma.cpw.io.show.csp?1=1" + "&EpisodeID=" + episodeID + "&CPWStr=" + d,"","dialogHeight:800px;dialogWidth:800px;resizable:yes;center:yes;status:no;");
			}
		}
	});
}

//提示用户保存文档
function eventQuerySaveDocument()
{
	setMessage('新建文档保存后才可创建新文档','forbid');
}

//获得文档大纲
function eventGetDocumentOutline(commandJson)
{
	var outLine = commandJson["args"]["Instances"];
	if (outLine == "") return;
}

//创建文档事件
function eventCreateDocument(commandJson)
{
	loadFalg = false;
	if (commandJson["args"]["result"] == "OK")
	{
		param.id = commandJson["args"]["InstanceID"];
		titleCode = commandJson["args"]["Title"]["Code"];
		var diseaseID = parent.$('#disease').combo('getValue');  //add by niucaicai 2016-09-02
		if (diseaseID == "undefined") diseaseID ="";
		var baseId = ""
		if (commandJson["args"]["BindKBBaseID"] != undefined) baseId = commandJson["args"]["BindKBBaseID"]
		var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:baseId,"titleCode":titleCode,"diseaseID":diseaseID};
		    parent.eventDispatch(paramJson);
	    if (param.insert)
	    {
		    focusDocument(args.InstanceID,param.insert.path,"Last");
		    insertText(param.insert.content);
	    }
	}
}

//文档签名事件
function eventSaveSignedDocument(commandJson)
{
	if ((commandJson["args"]["result"] == "OK")&&(commandJson["args"]["params"]["result"] == "OK")) 
	{
		//取文档信息
		var documentContext = getDocumentContext(commandJson["args"]["params"]["InstanceID"]);
		//设置当前文档操作权限
		setPrivelege(documentContext);
		//当前文档状态
		setStatus(documentContext);
		
		//修改文档目录
		modifyInstanceTree(documentContext);
		setMessage('数据签名成功!','alert');
		
		//基础平台组审计和日志记录
		setOperationLog(param,"EMR.Sign.OK");
        
        //请求上级签名是否成功
        if (commandJson["args"]["params"]["MessageFlag"] == "0")
        {
	       setMessage('请求上级签名失败!请检查','warning'); 
	    }
	}
	else
	{
		if ((typeof(commandJson["args"]["params"]["desc"]) != "undefined")&&(commandJson["args"]["params"]["desc"] != ""))
		{
			setMessage(commandJson["args"]["params"]["desc"],'warning');
		}
		else
		{
			setMessage('签名失败或级别不符!','warning');
		}
		unsignDocument();
	}
}
//签名成功后，发送消息给Portal系统
function setInfoToPortal(UserID)
{
	var signUserID = UserID;
	//alert("signUserID"+signUserID);
	var InstanceId = param.id;
	var categoryId = param.categoryId;
	var templateId = param.templateId;
	var emrDocId = param.emrDocId;
	var chartItemType = param.chartItemType;

	//取文档信息
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

//删除文档
function eventDeleteDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		var instanceId = commandJson["args"]["params"]["InstanceID"];
		var deleteData = deleteTreeItem(instanceId,"InstanceTree");
		//病历状态操作者即当前登录用户userName
		$(deleteData).find("#operator").html(userName); 
		$(deleteData).find("#status").html("已删除");
		
		//修改危急值事件的IsActive字段
		modifyCriticalEventValue(commandJson["action"]);
		
		//修改文档目录
		addDeleteTree(deleteData);

		getNewMenu();

		setMessage('病历删除成功!','alert');
		
		//当前病历是否被收藏
		if (isFavoriteRecord(instanceId) != "0")
		{
			var favInfoId = isFavoriteRecord(instanceId);
			CancelFavRecrod(favInfoId,instanceId);
			//记录用户(整理收藏.查看病历.取消病历收藏)行为
			AddActionLog(userID,userLocID,"FavoritesView.RecordView.Record.UnFavorite","");
		}
		if(parent.cdssTool != undefined && parent.cdssLock =="Y"){
			parent.cdssTool.getData(_paramNow,"Delete");
		}		
		//基础平台组审计和日志记录
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
//快捷键保存
function eventSave()
{
	if (getModifyStatus("").Modified != "True") return;
	var documentContext = getDocumentContext("");
	if (documentContext.result != "OK") return;
	//判断文档是否只读，只读则使文档不能保存
	if (getReadOnlyStatus().ReadOnly == "True") return;
	if (documentContext.privelege.canSave != "1") return;
    saveDocument();
}

//插入备注
function eventInsertSummary(commandJson)
{
	$('#memo').window('open');
	$('#memoText').val(commandJson.args.Value);
}

//设置字体样式
function eventCaretContext(commandJson)
{
	if (commandJson.args.FONT_FAMILY)
	{
		parent.$('#font').find('option[value="'+commandJson.args.FONT_FAMILY+'"]').attr("selected",true); 
	}
}

//文档加载成功事件
function eventLoadDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		loadFalg = false;
		
		//获取当前病历只读状态
		var readOnlyStatus = getReadOnlyStatus().ReadOnly;
		var documentContext = getDocumentContext("");
		if((pluginType=="GRID") &&(readOnlyStatus == "False")){
			//静默刷新
			silentRefreshReferenceData(commandJson.args.InstanceID ?commandJson.args.InstanceID:documentContext.InstanceID);
		}else if (readOnlyStatus == "False")
		{
			//自动触发绑定数据同步
			refreshReferenceData(commandJson.args.InstanceID ?commandJson.args.InstanceID:documentContext.InstanceID,"true")
		}
	}
	else
	{
		parent.setToolBarStatus("disable");
		setMessage('文档加载失败','warning');
	}
}
//静默刷新方法
function silentRefreshReferenceData(instanceID){
	var strJson={action:"SILENT_REFRESH_REFERENCEDATA", "args": {"InstanceID":instanceID}};
		cmdSyncExecute(strJson);
}
//获取当前病历只读状态
function getReadOnlyStatus()
{
	var strJson = {action:"GET_READONLY",args:{}};
	return cmdSyncExecute(strJson);
}

//病历加载完成后触发绑定数据同步
function refreshReferenceData(InstanceID,autoRefresh)
{
	if (InstanceID == "") return;
	if ((autoRefresh == "true")&&(pageType == "INSU"))
	{
		var syncDialogVisible = "false";
		var silentRefresh = "true";
	}
	else
	{
		var syncDialogVisible = "true";
		var silentRefresh = "false";
	}
	//获取是否显示同步提示框状态
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
						syncDialogVisible = "true";
					}
					else if(d == "False")
					{
						syncDialogVisible = "false";
					}
					reloadBinddata(autoRefresh,syncDialogVisible,silentRefresh);
			   }
			}
		});	
}

//文档打印事件
function eventPrintDocument(commandJson)
{
	if (commandJson["args"].result == "OK")
	{
		if (commandJson["args"].params.result == "OK")
		{
			//取文档信息
			var documentContext = getDocumentContext("");
			//设置当前文档操作权限
			setPrivelege(documentContext);
			//当前文档状态
			setStatus(documentContext);
	
			var lis = $("#InstanceTree li[id='"+param["id"]+"']");
			var docId = lis.attr("emrDocId");
			if (docId != "")
			{
				//判断是否打印病案首页成功后，对外提供访问出院患者列表
				getMedicalRecordDocID(docId);
			}
			//修改病历操作记录明细的显示颜色
			modifyWestListFlag();
			//基础平台组审计和日志记录
			setOperationLog(param,"EMR.Print.OK");
		}else if(commandJson["args"].params.result == "ERROR")
		{
			setMessage('打印日志未记录,请检查网络连接!','warning');
		}
	}else if(commandJson["args"].result == "ERROR")
	{
		setMessage('打印操作未记录,请检查网络连接!','warning');
	}
}

//复制剪切
function eventSendCopyCutData(commandJson)
{
	//刷新知识库
    var paramJson = {"action":"sendCopyCutData","content":commandJson.args.Value};
    parent.eventDispatch(paramJson);

}

///签名
function eventRequestSign(commandJson)
{
	 if (getModifyStatus("").Modified == "True")
	 {
	     if (saveDocument()=="revoke") return;
     }
	 var signProperty = commandJson.args;
	 audit(signProperty);
}


///连接单元
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
		setMessage('插入成功!','alert');
	}
	else 
	{
		setMessage('插入失败!','warning');
	}
}

//插入新的牙位图
function eventInsertTeethImage(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		setMessage('插入成功!','alert');
	}
	else
	{
		setMessage('插入失败!','warning');
	}
}
//双击牙位图图片，打开编辑页面修改牙位信息后，重新插入牙位图图片
function eventReplaceTeethImage(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		setMessage('插入成功!','alert');
	}
	else
	{
		setMessage('插入失败!','warning');
	}
}
//双击牙位图图片，打开编辑页面
function eventRequestTeeth(commandJson)
{
	openTooth(commandJson);
}

function openTooth(commandJson)
{
	var selectedToothObj = commandJson["args"];
	var returnValue = window.showModalDialog("emr.record.tooth.csp",selectedToothObj,"dialogWidth=940px;dialogheight=420px;status:no;center:yes;minimize:yes;");	
	if (returnValue !== "")
	{
		insertTooth("open",returnValue);
	}
}
$(function(){
	//编辑备注
	$('#memo').window({
		title: "编辑备注",
		width: 400,  
		height: 300,  
		modal: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closed: true	 
	});
	$('#memo').css("display","block");	
	
	//保存备注信息
	$('#memoSure').click(function(){
		var memoText = $('#memoText').val();
		memoText = stringTJson(memoText);
		if (memoText.length > 1000)
		{
			alert("备注内容超出1000字数限制");
		}else{
			$.ajax({ 
	       		type: "post", 
				url: "../EMRservice.Ajax.common.cls", 
				data: {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLInstanceData",
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
						setMessage('备注修改成功!','alert')	
						$('#memo').window('close');
					}
					else
					{
						setMessage('备注修改失败!','warning')	
					}
				} 
			});			
		}		
	});
	
	//取消或关闭编辑备注
	$("#memoCancel").click(function(){
		$('#memo').window('close');	
	});
});

//病历参考
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
		    	title: '病历参考',  
		    	split: true,
		    	content: reference
			});
			$("#framReference").attr("src","emr.record.edit.reference.east.csp");
		
			//基础平台日志
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
		    	title: '病历参考',  
		    	split: true,
		    	content: reference
			});
			$("#framReference").attr("src","emr.record.edit.reference.south.csp");
		
			//基础平台日志
			setOperationLog(param,"EMR.Reference");
		}
		else
		{
			$('#layout').layout('remove','south');
		}
	}
}

//修改危急值事件的IsActive字段
function modifyCriticalEventValue(eventAction)
{
	if (eventAction == "eventSaveDocument")
	{
		//保存事件
		if (param.IsActive == "Y") param.IsActive = "N";
	}else if (eventAction == "eventDeleteDocument")
	{
		//删除事件
		if (param.IsActive != "N") param.IsActive = "N";
	}
}

//设置进入或退出打印预览显示模式
function setPreviewDocumentState(status)
{
	var argJson = {"action":"PREVIEW_DOCUMENT","args":{"Preview":status}};
	cmdDoExecute(argJson);
}

//设置质控颜色
function setQualityColor()
{
	
	var argJson = {"action":"SET_QC_PARAMS","args":{"QCType":"2","QCColor":qulaityColor.QCColor,"RecoverColor":qulaityColor.RecoverColor}};
	cmdDoExecute(argJson);
}

//插入图库
function insertIMG(returnValue)
{
	if (returnValue.ImageId == "") return;
	var argJson = {action:"INSERT_IMG",args:{"ImageType":returnValue.ImageType,"ImageId":returnValue.ImageId}}
	cmdDoExecute(argJson);
}

//插入掌纹
function insertIMGData(returnValue)
{
	if (returnValue.ImageData == "") return;
	var argJson = {action:"INSERT_IMG",args:{"ImageType":returnValue.ImageType,"ImageData":returnValue.ImageData}}
	cmdDoExecute(argJson);
}

//刷新病历文档权限
function updatePrivilege()
{
	var argJson = {"action":"UPDATE_PRIVILEGE","args":{"InstanceID":""}};
	cmdDoExecute(argJson);
}

function applyedit()
{
	if ((param.id == undefined)||(param.id == "")) return;
	if (isSuperiorPhysicianSign() == 1) 
	{
		alert("上级医师已签名，不能自动授权，请申请人工授权！");
		return;
	}
	/*if (getApplyCount() > 3) 
	{
		alert("自动授权已超过三次，请申请人工授权！");
		return;
	}*/
	jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.Appoint.cls",
			async : true,
			data : {
				"Action":"autorequest",
				"EpisodeID":episodeID,
				"RequestCateCharpter":param.id,
				"RequestUserID":userID,
				"RequestDept":userLocID,
				"EPRAction":"save,print",
				"RequestReason":"",
				"BeforeRequestContent":"",
				"AfterRequestContent":""
				},
			success : function(d) {
	           if ( d == "1" ) 
			   {
					updatePrivilege();
					//取文档信息
					var documentContext = getDocumentContext("");
					//设置当前文档操作权限
					setPrivelege(documentContext);
					alert("申请编辑成功！");
					addApplyCount();
			   }
			},
			error : function(d) { alert("apply edit error");}
		});	
}

function isSuperiorPhysicianSign()
{
	var result = 0;
	if ((param.emrDocId == undefined)||(param.emrDocId == "")) return result;
	if ((param.id == undefined)||(param.id == "")) return result;
	strs = param.id.split("||");
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLEMRLogs",
					"Method":"IsSuperiorPhysicianSign",			
					"p1":episodeID,
					"p2":param.emrDocId,
					"p3":strs[1],
					"p4":userID
				},
			success : function(d) {
	           if ( d == 1) 
			   {
					result = 1;
			   }
			},
			error : function(d) { alert("canApplyedit error");}
		});	
	return result;
}

function addApplyCount()
{
	if (userID == "") return;
	if ((param.id == undefined)||(param.id == "")) return;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLApplyEdit",
					"Method":"AddApplyData",			
					"p1":episodeID,
					"p2":param.id,
					"p3":userID
				},
			success : function(d) {
			},
			error : function(d) { }
		});	
}

function getApplyCount()
{
	var count = 0;
	if (userID == "") return;
	if ((param.id == undefined)||(param.id == "")) return;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLApplyEdit",
					"Method":"GetApplyCount",			
					"p1":param.id,
					"p2":userID
				},
			success : function(d) {
				if (d != 0)
				{
					count = d;
				}
			},
			error : function(d) { }
		});	
	return count;
}

function eventRequestImgData(commandJson)
{
	var argJson = {action:"EDIT_IMG",args:{}}
	cmdDoExecute(argJson);
}

//获取某份实例是否被修改过
function getInstanceModifyStatus(instanceID)
{
	var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:{"InstanceID":instanceID}};
	return cmdSyncExecute(argJson);
}

function unlockSpecial()
{
	if (isEnableEditMultiRecord == "false")
	{
		//解锁,保存提醒
		if ((param != "")&&(getInstanceModifyStatus(param.id).Modified != "True"))
		{	
			if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
			{         
				unLock(lockinfo.LockID);                        //解锁
				//读写设置
				if (lockinfo != "" && lockinfo.openMode == "ReadOnly")
				{
					setReadOnly(false,[param.id]);
				}
			}
		}
	}
}

function lockSpecial(documentText)
{
	if (isEnableEditMultiRecord == "false")
	{
		if ((documentText != null)&&(documentText.result != "ERROR")&&(documentText.privelege!=""))
		{
			if (documentText.privelege.canSave == "0") 
			{
				lockinfo = "";
				setlockdocument("");
				return;
			}
		}
		//病历加锁
		lockDocument(param);

		//读写设置
		if (lockinfo != "" && lockinfo.openMode == "ReadOnly")
		{
			setReadOnly(true,[param.id]);
		}
	}
}

function isEditMultiRecord(commandJson)
{
	if (isEnableEditMultiRecord == "true") return;
	if ((param != "")&&(param.id != "")&&(param.id != commandJson["args"]["InstanceID"]))
	{
		var result = savePrompt(param.id);
		resetModifyState(param.id,"false");
	}
}

//设置电子病历运行环境参数
function setRunEMRParams()
{
    $.ajax({
		type: 'GET',
		dataType: 'text',
		url: '../EMRservice.Ajax.common.cls',
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetRunEMRParams",
			"p1":"UnHisui"
		},
		success: function (ret) {
			if (ret != "") {
                result = eval("("+ret+")");
				cmdDoExecute(result);
            }
		},
		error: function (ret) {
			alert('setRunEMRParams error');
		}
	});
}

//更改病历修改状态
function resetModifyState(instanceID,state)
{
	var argJson = {action:"RESET_MODIFY_STATE",args:{"InstanceID":instanceID,"State":state}}
	cmdDoExecute(argJson);
}
