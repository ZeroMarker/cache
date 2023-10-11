//初始化页面
function InitDocument(tempParam)
{  
	//判断上一个文档是后加载完成
	if (loadFalg ) 
	{
		changeFlag = false;
		return;
	}
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
		if ((tempParam.pdfDocType || "") =="PDF") {
        		if (!doPDF(tempParam)) return;
        	}else{
		if (!doOpen(tempParam)) return; 
	}
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
				setReadOnly(true,"",true);
			}
		}
		else
		{
			lockinfo = "";
			setlockdocument("");
		}
	}
	var strParam = JSON.stringify(tempParam);
	param = JSON.parse(strParam);
	
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
	else if (pluginType == undefined)
	{
		return false;
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
	if ((param != "")&&(tempParam.categoryId == param.categoryId)&&(param.isMutex == "1")&&(tempParam.isMutex == "1")&&(id != "0"))
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
			loadDocument(tempParam,"sync"); 
			if (tempParam.actionType == "CREATE")
			{
				focusDocument("GuideDocument","","First");
			}
			else
			{
				createDocument(tempParam);	
				//病历创建成功会给param赋值病历ID,需要赋值给tempParam,否则会被覆盖
				if (param.id != "" ) {
					tempParam.id = param.id;
				}else {
					tempParam.id = "";
				}
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
				var defaultLoadId = getDefaultLoadId(tempParam.emrDocId,userLocID,tempParam.templateId);
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
function getDefaultLoadId(templateCategoryId,locID,templateID)
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
					"p2":locID,
					"p3":"",
					"p4":templateID
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
	else if (pluginType == undefined)
	{
		return false;
	}
	else
	{
		parentWin.$.messager.alert("提示信息","插件创建失败");
		return false;
	}
	if ((param != "")&&(checkDocument(tempParam.id).result == "OK")&&(!param.reLoad))
	{
		focusDocument(tempParam.id,"","First");
		changeFlag = false;
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

	//$("#containerGrid").css("display","none");		
	//$("#containerWord").css("display","block");
	document.getElementById("containerGrid").style.display="none";
	document.getElementById("containerWord").style.display="block";
	var iword = pluginword()
	if(iword==null || iword.innerHTML== undefined || !iwordFlag)
	{
		document.getElementById("containerGrid").innerHTML = "";
		var objString = "<object id='pluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
		if (!pluginword()||!pluginword().valid)
		{
			setUpPlug();
			return;
		} 
		pluginAdd();
		var ret = pluginword().initWindow("iEditor");
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
		//iword = true; 
		iwordFlag = true;
		igridFlag = false;                            	
		setRunEMRParams();
	}
	return result;
}

//创建gird编辑器
function girdDoc(tempParam)
{
	var result = true;
	//$("#containerWord").css("display","none");
	//$("#containerGrid").css("display","block");
	document.getElementById("containerGrid").style.display="block";
	document.getElementById("containerWord").style.display="none";
	var igrid = plugingrid()
	if(igrid==null || igrid.innerHTML== undefined || !igridFlag)
	{
		document.getElementById("containerWord").innerHTML = "";
		var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerGrid").innerHTML = objString;  
		if (!plugingrid()||!plugingrid().valid)
		{
			setUpPlug();
			return;
		}  
		pluginAdd(); 
		var ret = plugingrid().initWindow("iGridEditor");
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
		//igrid = true; 
		igridFlag = true;
		iwordFlag = false;
		setRunEMRParams();
	}
	return result;
}
//安装插件提示
function setUpPlug (){
	var iframeContent = "<iframe id='iframeDownloadPlugin' scrolling='auto' frameborder='0' src='emr.record.downloadplugin.csp?PluginUrl=" +base64encode(utf16to8(encodeURI(pluginUrl)))+"&openWay=editor"+"&MWToken="+getMWToken()+"' style='width:290px; height:140px; display:block;'></iframe>";
	createModalDialog("downloadPluginDialog",emrTrans("下载插件"),310,180,"iframeDownloadPlugin",iframeContent,setUpPlugCallBack,"");
};

function setUpPlugCallBack(returnValue,arr)
{
	if (returnValue)
	{
		window.location.reload();
	}
}

function pluginword()
{
	return document.getElementById("pluginWord");
}
function plugingrid()
{
	return document.getElementById("pluginGrid");
}
//查找插件
function plugin() {
	if(pluginType == "DOC")
	{
		return pluginword();
	}
	else
	{
		return plugingrid();
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
function setReadOnly(flag,instanceIds,lockDocFlag,sync)
{
	var argJson = "";
	if (instanceIds == "")
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag,"lockDoc":lockDocFlag}};
	}
	else
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag,"lockDoc":lockDocFlag,"InstanceID":instanceIds}};
	}
	if(sync){
		cmdSyncExecute(argJson);
	}else{
		cmdDoExecute(argJson);	
	}
	
}

//设置患者信息
function setPatientInfo()
{
	var argParams = {"DiseaseID":"0","PatientID":patientID,"EpisodeID":episodeID,"UserCode":userCode,"SessionID":sessionID,
	               "UserID":userID,"UserName":userName,"SsgroupID":ssgroupID,"UserLocID":userLocID,"IPAddress":ipAddress,"HospitalID":hospitalID};
    var argJson = {action: "SET_PATIENT_INFO",args:argParams};
    cmdDoExecute(argJson);
	var userLevel = "";
	var userInfo = getUserInfo();
	if (userInfo != "")
	{
		userLevel = userInfo.UserLevel;
	}
    //设置当前操作者信息
    setCurrentRevisor(userID,userName,ipAddress,userLevel);
    setQualityColor();
}

//设置调用的产品模块的信息
function setProductSource(tempParam)
{
    var argJson = {action: "SET_PATIENT_INFO",args:{"ProductSourceType":productSourceType,"ProductSourceCode":productSourceCode}};
    cmdDoExecute(argJson);
	
}

//添加或修改病种数据
function setDiseaseData()
{
	var diseaseID = ""; 
	if (diseaseID == "undefined") diseaseID ="";
	var argJson = {action: "SET_PATIENT_INFO",args:{"DiseaseID":diseaseID}};
	cmdDoExecute(argJson);
}
//创建病历
function createDocument(tempParam)
{
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
		if (tempParam.titleName != undefined && tempParam.dateTime != undefined)
		{
			strJson.args.TitleName = tempParam.titleName;
			strJson.args.HappenDateTime = tempParam.dateTime;
		}
		if (tempParam.titlePrefix != undefined)
		{
			strJson.args.TitlePrefix = tempParam.titlePrefix;
		}
		if (typeof(tempParam.doctorID) != "undefined")
		{
			strJson.args.DoctorID = tempParam.doctorID;
		}
	}
	else if (tempParam.actionType == "CREATEBYPERSONAL")
	{
		if ((tempParam.titleCode != undefined)&&(tempParam.titleCode != ""))
		{
			var strJson = {action:"CREATE_DOCUMENT_BY_TITLE",args:{"AsLoad":"false","params":{"action":"CREATE_PERSONAL_TEMPLATE","PersonalTemplateID":tempParam.exampleId},"TitleCode":tempParam.titleCode}};	
			if (tempParam.titleName != undefined && tempParam.dateTime != undefined)
			{
				strJson.args.TitleName = tempParam.titleName;
				strJson.args.HappenDateTime = tempParam.dateTime;
			}
			if (tempParam.titlePrefix != undefined)
			{
				strJson.args.TitlePrefix = tempParam.titlePrefix;
			}
			if (typeof(tempParam.doctorID) != "undefined")
			{
				strJson.args.DoctorID = tempParam.doctorID;
			}
		}
		else
		{
			if ((args.event != undefined)&&(args.event.EventType == "Operation"))
			{
				var strJson = {action:"CREATE_DOCUMENT",args:{"AsLoad":"false","Title": {"DisplayName": tempParam.text},"params":{"action":"CREATE_PERSONAL_TEMPLATE","PersonalTemplateID":tempParam.exampleId,"event":{"EventType":"Operation","EventID":args.event.EventID}}}};
			}
			else
			{
				var strJson = {action:"CREATE_DOCUMENT",args:{"AsLoad":"false","Title": {"DisplayName": tempParam.text},"params":{"action":"CREATE_PERSONAL_TEMPLATE","PersonalTemplateID":tempParam.exampleId}}};		
			}		
		}
	}
	else 
	{
		var strJson = {action:"CREATE_DOCUMENT",args:{"params":args,"Title":{"DisplayName":tempParam.text}}};
	}
	if (createStatus)
	{
		strJson.args.LoadMode = createStatus.LoadMode;
		strJson.args.IsStream = createStatus.IsStream;
	}
	strJson.args.UserTemplateCode = tempParam.userTemplateCode;
	setSysMenuDoingSth(emrTrans('病历创建中...'));
	cmdDoExecute(strJson);
	
	//修复通过事件创建病历后插入相关内容到指定章节
	if (tempParam.insert)
	{
		focusDocument("",tempParam.insert.path,"Last");
		insertText(tempParam.insert.content);
	}
	//创建病历调用CDSS
	var instance = getDocumentContext();
	tempParam.id = instance.InstanceID;
	cdssParam(tempParam,'Create');
}

//加载文档
function loadDocument(tempParam,loadType)
{
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 
	setProductSource(tempParam);
	setPatientInfo();	                          
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var status = tempParam["status"];
    var loadMode = "ALL";
    if ((loadDocMode.TitleCode != "")||(loadDocMode.RecordConfig != ""))
    {
        loadMode = "BATCH";
    }
	setSysMenuDoingSth(emrTrans('病历加载中...'));
	//加载文档
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":status,"LoadDocMode":loadMode,"DateTime":tempParam["dateTime"]||""},InstanceID:tempParam["id"],actionType:tempParam["actionType"]}};
    if(loadType=="sync")
    {
        var commandJson = cmdSyncExecute(argJson);
        //加载完成，清除头菜单锁定
        setSysMenuDoingSth('');
        if (commandJson["result"] == "OK")
        {
            loadFalg = false;
            changeFlag = false;
            var isMutex = (tempParam["isMutex"]=="1")?true:false;
            var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
            if (loadMode != "ALL")
            {
                var lastInstanceID = getLastInstanceData(getLastInstanceID().InstanceID);
                if (lastInstanceID != ""){
                    //病程部分加载到最后一份病历，设置引导框
                    if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox);
                }else{
                    //病程部分加载时，需要通过设置引导框来告知插件标题信息
                    if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,false);
                }
            }else{
                //病程全部加载设置引导框
                if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
            }
        }else{
            setMessage('文档同步加载失败','warning');
        }
	}else{
		cmdDoExecute(argJson); 
	} 
	
	if (status == "DELETE")
	{
		setReadOnly(true,[tempParam["id"]],true);
		setToolBarStatus("disable");
	}
	
	//打开病历 增加定位功能。
	if ((tempParam["path"]!=undefined)&&(tempParam["path"]!=""))
	{
		focusDocument("",tempParam["path"],"First");	
	}
	//加载病历调用CDSS
	cdssParam(tempParam,"Save");
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
	var hasTemplate = GetHasUserTemplate(emrDocId);
	if (isGuideBox && createStatus.LoadMode == "UserTemplate" && hasTemplate)
	{
		argJson.args.GuideDocumentMode = "Template";
	}
	cmdDoExecute(argJson);
}

//是否有用户模板
function GetHasUserTemplate(docId)
{
	var result = false;
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"HasUserTemplate",
			"p1":userLocID,
			"p2":docId
		},
		success: function(d) {
			if (d == "1") result = true;
		},
		error : function(d) { 
			alert("GetHasUserTemplate error");
		}
	});
	return result;
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
function signDocument(instanceId,type,signLevel,userId,userName,Image,actionType,description,headerImage,fingerImage,path,isZoom)
{
	var signPrefix = false;
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSignRole",
			"Method":"GetSignPrefixFlag",
			"p1":signLevel	
		},
		success: function(d) {
		    if (d == "1") signPrefix = true;
		},
		error : function(d) { alert("GetSignPrefixFlag error");}
	});
	var imageZoomRatio = getImageZoomRatio(userId);
    //患者签名不传图片行高，通过编辑器系统参数设置
    if (signLevel == "Patient") imageZoomRatio = "";
    //增加参数控制是否压缩图片，患者批注时不压缩图片
    if ((typeof(isZoom) == "undefined")||(isZoom === "")) var isZoom = true;
	var argJson = {action:"SIGN_DOCUMENT",args:{"InstanceID":instanceId,"Type":type,"SignatureLevel":signLevel,"actionType":actionType,"AddSignPrefix":signPrefix,"Authenticator":{"Id":userId,"Name":userName,"Image":Image,"Description":description, "HeaderImage":headerImage,"FingerImage":fingerImage,"SignImageZoomRatio":imageZoomRatio,"IsZoom":isZoom},"Path":path || "","params":{}}}
	return cmdSyncExecute(argJson);
}
//获取活动文档上下文
function getDocumentContext(instanceId)
{
	var argJson = {action:"GET_DOCUMENT_CONTEXT",args:{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//刷新权限后获取活动文档上下文
function getContextPrivilege(instanceId)
{
    var argJson = {action:"UPDATE_PRIVILEGE",args:{"InstanceID":instanceId}};
    cmdSyncExecute(argJson);
    
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
function markRequiredObject(items)
{
	var strJson = {action:"MARK_REQUIRED_OBJECTS",args:{"Mark":"True","items":items}};
	return cmdSyncExecute(strJson);
}

//取刷新绑定数据
function reloadBinddata(autoRefresh,syncDialogVisible,silentRefresh)
{
	dataObjStr = autoRefresh;
	if (typeof(param) == "undefined" || param.id == "GuideDocument") return;
	if (getReadOnlyStatus().ReadOnly == "True") return; //文档只读状态，不发绑定数据的命令
	if (syncDialogVisible == "true" || autoRefresh == "false")
	{
		var argJson = {"action":"REFRESH_REFERENCEDATA","args":{"InstanceID":"","InterfaceStyle":"Web","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible,"SilentRefresh":silentRefresh,"DisplayNullValueItem":"false"}};
		cmdDoExecute(argJson);
		//基础平台日志
		setOperationLog(param,"EMR.BinddataReload");
	}
}

//导出文档
function exportDocument()
{
	if (!param || param.id == "GuideDocument")
	{
		setMessage('请选中要导出的文档!','forbid');
		return;
	}
	var modifyStatus = getModifyStatus(param.id);
	if (modifyStatus.Modified == "True")
	{
		setMessage('病历内容有改变，请保存后再导出','forbid');
		return;
	}
	else
	{
		var argJson = {"action":"SAVE_LOCAL_DOCUMENT","args":{}};
		cmdDoExecute(argJson);
	}	
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
function updateInstanceData(actiontype,instanceID,path,value,other) {
    var strJson = {action: "UPDATE_INSTANCE_DATA",args: {"actionType":actiontype,"InstanceID":instanceID,"Path":path,"Value":value,"Other":other}};
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
    //当开启病程分阶段加载时，判断当前病历是否加载完全
    if (loadDocMode.TitleCode != "")
    {
        if (!IsAppedDocument()) return;
    }
	var pOperateDate = "";
	var pOperateTime = "";
	var documentContext = getDocumentContext("");
	if ((typeof(documentContext.status.POperateDate)!="undefined")&&(typeof(documentContext.status.POperateTime)!="undefined"))
	{
		pOperateDate = documentContext.status.POperateDate;
		pOperateTime = documentContext.status.POperateTime;
	}
	var argJson = {action:"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT","LastOperateDate":pOperateDate,"LastOperateTime":pOperateTime}}};
	cmdDoExecute(argJson);		
}

//当开启分阶段加载时，判断当前是否加载到相同DocID的最后一份病历
function IsAppedDocument()
{
    if ((param.pluginType == "GRID")||(param.chartItemType == "Single")) {
        return true;
    }
    var lastInstanceID = getLastInstanceID().InstanceID;
    var tempParam = getLastInstanceData(lastInstanceID);
    if (tempParam == "")
    {
        var text = '当前病历未显示全，需要追加显示到最后一份病历才能保存，是否确认追加病历?';
        if (!confirm(text)) return false;
        parentWin.$.messager.progress({
            title: "提示",
            msg: '正在追加病历',
            text: '病历加载中....'
        });
        var appendResult = appedDocument(lastInstanceID);
        if (appendResult.result == "ERROR")
        {
            setMessage('追加显示文档失败!','warning');
            return false;
        }
        //设置引导框
        var isMutex = (param["isMutex"]=="1")?true:false;
        var isGuideBox = (param["isLeadframe"] == "1")?true:false;
        if(!checkCreatePrivilege(param,false)) setDocTempalte(param["emrDocId"],isMutex,isGuideBox); 
        parentWin.$.messager.progress("close");
    }
    return true;
}

//在instanceId病历后，追加病历
function appedDocument(instanceId)
{
    var argJson = {"action":"LOAD_DOCUMENT","args":{"params":{"status":"NORMAL","LoadDocMode":"APPEND"},"InstanceID":instanceId,"actionType":"LOAD"}};
    return cmdSyncExecute(argJson);
}

///失效签名
function cmdRevokeSignedDocument(signatureLevel,instanceId,signUserID)
{
	var pOperateDate = "";
	var pOperateTime = "";
    var OperatorID = "";
    if (signUserID)  OperatorID = signUserID;	
	var documentContext = getDocumentContext("");
	if ((typeof(documentContext.status.POperateDate)!="undefined")&&(typeof(documentContext.status.POperateTime)!="undefined"))
	{
		pOperateDate = documentContext.status.POperateDate;
		pOperateTime = documentContext.status.POperateTime;
	}
	var argJson = {"action":"REVOKE_SIGNED_DOCUMENT","args":{"SignatureLevel":signatureLevel,"InstanceID":instanceId,"params":{"OperatorID":OperatorID,"LastOperateDate":pOperateDate,"LastOperateTime":pOperateTime}}};
	return cmdSyncExecute(argJson);
}

//获取失效签名文档信息
function cmdRevokeSignerInfo(signatureLevel,instanceId)
{
	var argJson = {"action":"GET_REVOKE_SIGNER_INFO","args":{"SignatureLevel":signatureLevel,"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//保存签名文档及相关操作
function saveSignDocument(instanceId,signUserId,signLevel,signId,digest,type,path,actionType)
{
	var pOperateDate = "";
	var pOperateTime = "";
	var documentContext = getDocumentContext("");
	if ((typeof(documentContext.status.POperateDate)!="undefined")&&(typeof(documentContext.status.POperateTime)!="undefined"))
	{
		pOperateDate = documentContext.status.POperateDate;
		pOperateTime = documentContext.status.POperateTime;
	}
	var argJson = {action:"SAVE_SIGNED_DOCUMENT",args:{params:{"action":"SAVE_SIGNED_DOCUMENT","SignUserID":signUserId,"SignID":signId,"SignLevel":signLevel,"Digest":digest,"Type":type,"Path":path,"ActionType":actionType,"LastOperateDate":pOperateDate,"LastOperateTime":pOperateTime},"InstanceID":instanceId}};
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
	var pOperateDate = "";
	var pOperateTime = "";
	var documentContext = getDocumentContext("");
	if ((typeof(documentContext.status.POperateDate)!="undefined")&&(typeof(documentContext.status.POperateTime)!="undefined"))
	{
		pOperateDate = documentContext.status.POperateDate;
		pOperateTime = documentContext.status.POperateTime;
	}
	var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel},"LastOperateDate":pOperateDate,"LastOperateTime":pOperateTime}}};
	return cmdSyncExecute(argJson);
}

//按章节保存
function saveSection(param)
{
	var argJson = {"action":"SAVE_SECTION","args":{"params":{"CategoryID":param.CategoryID,"UserID":param.UserID,"Name":param.Name,"action":"SAVE_INSTANCE_SECTION"}}};
	return cmdSyncExecute(argJson);
}

//获取范围内InstanceID
function getInstanceID()
{
	var strJson = {"action":"GET_PRINT_DOC_INSTANCEID_LIST",args:{}};
	return cmdSyncExecute(strJson);
}

//打印文档
function printDocument()
{
	var modifyStatus = getModifyStatus("");
	if (modifyStatus.Modified == "True")
	{
		var displayName = "";
		if ((typeof(modifyStatus.InstanceID) != "undefined")&&(modifyStatus.InstanceID.length>0))
		{
			for (i=0;i<modifyStatus.InstanceID.length;i++ )
			{
				var documentContext = getContextPrivilege(modifyStatus.InstanceID[i]);
				
				//增加判定如果无保存权限，则退出保存检查
				if (documentContext.privelege.canSave != "1") return;
				
				if (displayName != "") {displayName = displayName + " "}
				displayName = displayName + documentContext.Title.NewDisplayName;
			}
		}
		if (displayName == "") {displayName = "文档"}
	
		var text = displayName + '正在编辑，请保存后打印，是否保存？';
		parentWin.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				saveDocument();
				printDocumentContent();
			}
		});
	} 
	else
	{
		printDocumentContent();
	}
}

function printDocumentContent()
{
	if (getModifyStatus("").Modified == "True")
	{
		return;
	}
	
	//获得需要打印范围内的所有InstanceID
	var allInstanceID = getInstanceID();

	//质控
	var qualityResult = qualityPrintDocument(allInstanceID);
	if (qualityResult) return;
	var printFlag = "0"	
	//取文档信息
	var documentContext = getDocumentContext("");
	if(documentContext.status.curStatus == "")
	{
		setMessage('当前病历的状态无法进行打印!','warning');
		return;
	}	
	if (documentContext.status.curAction == "print")
	{
		printFlag = "1"
		var text = emrTrans('病历 "')+ param.text + emrTrans('"已打印，是否确认继续打印！');
		parentWin.$.messager.confirm(emrTrans("操作提示"), text, function (data) { 
			if(!data) 
			{
				return;
			}
			else
			{
                //病案首页采集页打印
                var collectMedicalRecordConfig = isMedicalRecord(param.emrDocId);
                if (collectMedicalRecordConfig){
                    createModalDialog("printDialog","打印",window.screen.width-1000,window.screen.height-300,"iframePrint","<iframe id='iframePrint' scrolling='auto' frameborder='0' src='emr.ip.collectmedicalrecord.csp?DialogID=printDialog&Action=print&CollectMedicalRecordConfig="+collectMedicalRecordConfig+"&MWToken="+getMWToken()+"' style='width:100%;height:100%;display:block;'></iframe>","","");
                }else{
		       	//打印
                    setPrintInfo("true");
                    setSysMenuDoingSth(emrTrans('病历打印中...'));
				//增加单页病历是否补空白控制FirstNeedChangePage，从SystemParameter获取 默认false 
				var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print","FirstNeedChangePage":FirstNeedChangePageFlag}}; 
 				cmdDoExecute(argJson); 
			}
			}
		});
	}
	if(printFlag =="0")
	{
        //病案首页采集页打印
        var collectMedicalRecordConfig = isMedicalRecord(param.emrDocId);
        if (collectMedicalRecordConfig){
            createModalDialog("printDialog","打印",window.screen.width-1000,window.screen.height-300,"iframePrint","<iframe id='iframePrint' scrolling='auto' frameborder='0' src='emr.ip.collectmedicalrecord.csp?DialogID=printDialog&Action=print&CollectMedicalRecordConfig="+collectMedicalRecordConfig+"&MWToken="+getMWToken()+"' style='width:100%;height:100%;display:block;'></iframe>","","");
        }else{
		//打印
            setPrintInfo("true");
            setSysMenuDoingSth(emrTrans('病历打印中...'));
		//增加单页病历是否补空白控制FirstNeedChangePage，从SystemParameter获取 默认false 
		var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print","FirstNeedChangePage":FirstNeedChangePageFlag}}; 
 		cmdDoExecute(argJson);
	}
	}
}

//是否为病案首页
function isMedicalRecord(emrDocId){
    var rtn = "";
    $.each(emrDocIDs, function(index,val){
        if (emrDocId == val.split("||")[0] ){
            rtn = val;
            return false;
        }
    });
    return rtn;
}

//单独打印文档
function printOneDocument()
{
	if (getModifyStatus("").Modified == "True")
	{
		var text = '文档正在编辑，请保存后打印，是否保存？';
		parentWin.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				saveDocument();
				printOneDocumentContent();
			}
		});
	} 
	else
	{
		printOneDocumentContent();
	}
	
}

function printOneDocumentContent()
{
	if (getModifyStatus("").Modified == "True")
	{
		return;
	}
	
	//取文档信息
    var documentContext = getContextPrivilege("");
    if (documentContext.InstanceID == "")
    {
        alert('请单击选择要打印的病历！');
        return;
    }
    //实例打印权限
    if (documentContext.privelege.canPrint==0) return;
	var qualityResult = qualityPrintDocument("");
	if (qualityResult) return;
	if(documentContext.status.curStatus == "")
	{
		setMessage('当前病历的状态无法进行打印!','warning');
		return;
	}	
	var printFlag = "0"
	if (documentContext.status.curAction == "print")
	{
		printFlag = "1"
		var text = emrTrans('病历 "')+ param.text + emrTrans('"已打印，是否确认继续打印！');
		parentWin.$.messager.confirm(emrTrans("操作提示"), text, function (data) { 
			if(!data) 
			{
				return;
			}
			else
			{
				//打印
				setPrintInfo("true");
    			createModalDialog("printDialog","打印","284","115","iframePrint","<iframe id='iframePrint' scrolling='auto' frameborder='0' src='emr.interface.print.csp?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID + "&InsID=" + documentContext.InstanceID + "&IPAddress=" + ipAddress + "&IsPrintDirectly=N"+"&MWToken="+getMWToken()+"' style='width:280px; height:75px; display:block;'></iframe>","","")
    			setPrintInfo("false");
			}
		});
	}
	if(printFlag == "0")
	{
		//打印
		setPrintInfo("true");
    	createModalDialog("printDialog","打印","284","115","iframePrint","<iframe id='iframePrint' scrolling='auto' frameborder='0' src='emr.interface.print.csp?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID + "&InsID=" + documentContext.InstanceID + "&IPAddress=" + ipAddress + "&IsPrintDirectly=N"+"&MWToken="+getMWToken()+"' style='width:280px; height:75px; display:block;'></iframe>","","")
    	setPrintInfo("false");
	}
}

//自动续打文档
function autoPrintDocument(){
	if (getModifyStatus("").Modified == "True")
	{
		var text = '文档正在编辑，请保存后打印，是否保存？';
		parentWin.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				saveDocument();
				autoPrintDocumentContent();
			}
		});
	} 
	else
	{
		autoPrintDocumentContent();
	}
	
}

function autoPrintDocumentContent()
{
	if (getModifyStatus("").Modified == "True")
	{
		return;
	}
	//取文档信息
	var documentContext = getDocumentContext("");
	if(documentContext.status.curStatus == "")
	{
		setMessage('当前病历的状态无法进行打印!','warning');
		return;
	}	
	//打印
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.PrintRecord",
				"Method":"GetInstanceNextId",
				"p1":documentContext.InstanceID
			},
			success: function(d) {
				if(d== 0){
					parentWin.$.messager.alert("提示","病历已全部打印，无可续打病历");
					return;
				}else{
					var allInstanceID = getInstanceID();
					if(!printInstanceIds){
						var printInstanceIds = {
							items:[]
						};
					}
					//for循环取未打印的病程记录instanceId
					for(var i=0;i<allInstanceID.items.length;i++)
					{
						if(d == allInstanceID.items[i].InstanceID)
						{
							printInstanceIds.items = allInstanceID.items.slice(i);
							break;
						}
					}
					//质控
					var qualityResult = qualityPrintDocument(printInstanceIds);
					if (qualityResult) return; 
					setPrintInfo("true");
					var argJson = {action:"AUTO_CONTINUE_PRINT",args:{"InstanceID":d}}; 
 					cmdDoExecute(argJson);
				}
			},
		error : function(d) { alert("GetSummery error");}
	});
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
					"OutputType":"Stream",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"QualityInterfaceCheck",			
					"p1":episodeId,
					"p2":eventType,
					"p3":templateId,
					"p4":instanceId
				},
			success: function(d) {
				if (d != "") result = jQuery.parseJSON(d);
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}

//保存文档
function saveDocument(saveType)
{
	var flag = "save"
	//取文档信息
	var documentContext = getDocumentContext("");
	var modifyResult = getModifyStatus("");
	//判断病历被修改且上一次操作是打印,则弹出病历已打印的提醒框
	if ((documentContext.status.curAction == "print")&&(modifyResult.Modified == "True"))
	{
		var text = '病历 "' +param.text + '" 已打印，是否确认保存修改?';
		//if(!confirm(text)) return;
        if (confirm(text)==true)
        {
            flag = saveDocumentCheck(flag,documentContext,modifyResult, saveType);
        }
        else
        {
            return;
        }
        // HISUI的$.messager.confirm弹窗重复套用代码没有执行完就会继续执行
        // 例如对已打印病历进行修改后，点击打印按钮，打印不成功，因为保存没有完成就去打印
		/*parentWin.$.messager.confirm("操作提示", text, function (data) {
				if (!data)
				{   
				   return ;
				}
				else 
				{   
					 flag = saveDocumentCheck(flag,documentContext,modifyResult)
				}
			});*/
	}
	else
	{
		flag = saveDocumentCheck(flag,documentContext,modifyResult, saveType)
	}
	
	return flag;	
}
	
function saveDocumentCheck(flag,documentContext,modifyResult, saveType)
{
	var escapeRevokeSignDocIDArray = new Array(); 
	escapeRevokeSignDocIDArray = escapeRevokeSignDocID.split("^");
	if ((isRevokeSign == "Y")&&($.inArray(param.emrDocId,escapeRevokeSignDocIDArray) == -1))
	{
		if (revokeSignedDocument(modifyResult, saveType)) flag = "revoke";
	}
	else
	{
        if(saveType == "sync")
        {
            cmdSyncSaveDocument();
        }else{
            cmdsaveDocument();
        }
	}
	return flag;
}	

///撤销签名
function revokeSignedDocument(modifyResult, saveType)
{
	var result = false;
	var noSign = false;
	if (modifyResult.Modified == "False") 
	{
		var items = "[{" + param.id + "}]"
		checkRequiredCell(items);
	}
	for (var i=0;i<modifyResult.InstanceID.length;i++)
	{
		var instanceId = modifyResult.InstanceID[i];
		var documentContext = getDocumentContext(instanceId);
		var userLevel = getUserInfo().characterCode;
		var tmpRevokeStatus = revokeStatus();
		if (tmpRevokeStatus == "All") 
		{
			userLevel = "";
		}else if(tmpRevokeStatus == "Patient")
		{
			userLevel = tmpRevokeStatus
		}
		/*
		var revokeInfo = cmdRevokeSignerInfo(userLevel,instanceId);
		if (revokeInfo.result == "ERROR"){
			setMessage('失效文档信息获取失败!','warning');
			noSign = false;
			break;
		}else{
			if((typeof(revokeInfo.Authenticator) != "undefined")&&(revokeInfo.Authenticator.length>0))
			{
				// 有失效签名时给予提示
				var text = '本次保存会使 "' +revokeInfo.HappenDateTime+' '+revokeInfo.Title+ '" 的';
				var name = ""
				$.each(revokeInfo.Authenticator, function(idx, val){
					if (name == ""){
						name = val.Name;
					}else{
						name += "、"+val.Name;
					}
				});
				text += name+'签名失效，是否确认保存修改?'
				if(!confirm(text)) {
					noSign = false;
					break;
				}
			}	
		}*/
		//获取签名摘要和签名元素路径
		var signDatas = GetSigneData(instanceId)
		//设置签名摘要和路径
		if (signDatas!="")
		{
			var digestResult =SetSignDigest(signDatas)
			if (digestResult=="" || digestResult.result == "ERROR")
			{
				setMessage('设置摘要失败!','warning');
				break;
			}
		}
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
			var tmpDocContext = getContextPrivilege(instanceId);
			if (tmpDocContext.result == "ERROR") return;

			//设置当前文档操作权限
			setPrivelege(tmpDocContext);
		    //当前文档状态
		    setStatus(tmpDocContext);
		    //修改文档
			modifyQuicknav(tmpDocContext);
			//刷新菜单
            reloadMenu(instanceId);
			setMessage('数据保存成功,签名已失效!','alert');
			
			//启用病历信息订阅与发布
			if (Observer == "Y") GetObserverData();

			//质控
			qualitySaveDocument();
			//保存日志(基础平台组)
			setOperationLog(param,"EMR.Save");	
		}	
	}
	if (noSign)
	{
        if(saveType == "sync")
        {
            cmdSyncSaveDocument();
        }else{
            cmdsaveDocument();
        }
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
			"p3":userLocID,
			"p4":"",
			"p5":"inpatient",
			"p6":episodeID,
			"p7":"",
			"p8":"",
			"p9":param.id
		},
		success: function(d) {
			if (d != "")
			{
				result = eval("("+d+")");
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
	var items = "[{" + param.id + "}]"
	result = checkRequiredCell(items);
	if (result == true) 
	{
		setMessage('有未完成项目,请检查!','forbid',{top:52});
		//return result;
	}
	//打散数据质控
	var eventType = "Save^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	var selectTitle = resource.$('#resources').tabs('getSelected').panel('options').title;
	if ((qualityData.total > 0)||(selectTitle == emrTrans("质控提示")))
	{
		var controlType = qualityData.ControlType;
		var quality = "<div style='padding:0;margin:0;overflow:hidden;fit:true;width:100%; height:100%;'>"+getQualityIframe(episodeID,eventType,param.templateId,qualityData.key)+"</div>"		        
		addTabs("quality","质控提示",quality,true); 
		if ((qualityData.total > 0)&&(controlType == "0"))
		{
			result = true;
			return result;
		}
	}
	return result;	
}

//签名质控
function qualitySignDocument()
{
	var result = false;
	var items = "[{" + param.id + "}]"
	result = checkRequiredCell(items);
	if (result == true) 
	{
		setMessage('有未完成项目不能签名,请处理!','forbid');
		return result;
	}	
	var eventType = "Commit^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	var selectTitle = resource.$('#resources').tabs('getSelected').panel('options').title;
	if ((qualityData.total > 0)||(selectTitle == emrTrans("质控提示")))
	{
		var controlType = qualityData.ControlType;		
		var quality = getQualityIframe(episodeID,eventType,param.templateId,qualityData.key);
        addTabs("quality","质控提示",quality,true); 
		if ((qualityData.total > 0)&&(controlType == "0")) 
		{
			result = true;
			return result;
		}
	}
	return result;	
}

//打印质控
function qualityPrintDocument(instanceID)
{
	var instanceIDStr = ""
	if(instanceID=="")
	{
		instanceIDStr = param.id;
		var items = "[{" + instanceIDStr + "}]"
	}
	else
	{
		//实例s打印权限
		var printPrivilegeResult = getDocumentsPrivilege(instanceID,"Print")
		if (printPrivilegeResult==false) return true;
		var items = instanceID.items;
		for(var i=0;i<instanceID.items.length;i++)
		{
			instanceIDStr = instanceIDStr + '/' + instanceID.items[i].InstanceID
		}
		instanceIDStr = instanceIDStr.slice(1);
	}
	var result =  false;
	result = checkRequiredCell(items);
	if (result == true) 
	{
		setMessage('有未完成项目不能打印,请处理','forbid');
		return result;
	}
	//病历质控
	var eventType = "Print^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,instanceIDStr,param.templateId,eventType)
	var selectTitle = resource.$('#resources').tabs('getSelected').panel('options').title;
	//质控触犯总数大于0，增加提示窗。
	if ((qualityData.total > 0)||(selectTitle == "质控提示"))
	{
		var controlType = qualityData.ControlType;
		var quality = getQualityIframe(episodeID,eventType,param.templateId,qualityData.key);
		addTabs("quality","质控提示",quality,true); 
		if ((qualityData.total > 0)&&(controlType == "0"))
		{
			result = true;
			return result;
		}
	}
	return result;	
}

//根据是否为病案首页，返回不同的链接
function getQualityIframe(episodeID, eventType, templateId, key)
{
	//病案首页使用dhc.emr.quality.dipdrg.csp
	if ((param.emrDocId != "")&&((param.emrDocId == medicalRecordDocID)||(param.emrDocId == medicalRecordDocIDCN)))
	{
		var qualityUrl = "dhc.emr.quality.dipdrg.csp";			
	}
	//其他使用
	else
	{	
		var qualityUrl = "dhc.emr.quality.timelyquality.csp";
	}
	var qualityIframe = "<iframe id='framclipboard' src='"+qualityUrl+"?EpisodeID="+episodeID+"&EventType="+eventType+"&TemplateID="+templateId+"&key="+key+"&MWToken="+getMWToken()+"' style='width:98%; height:98%;border:0;margin:0px;padding:5px;overflow:hidden;' scrolling=no></iframe>"
	return qualityIframe;
}

///检查必填项
function checkRequiredCell(items)
{
	var result =  false;
	if ((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
	{
		//脚本检查
		var resultMarkRequired = markRequiredObject(items);
		if (resultMarkRequired.MarkCount>0) result = true;
	}
	return result;
}

// 患者签名
function patAudit(signProperty)
{
    var qualityResult = qualitySignDocument();
	if (qualityResult) return; 
	var documentContext = getContextPrivilege("");
    var canReCheck = documentContext.privelege.canPatReCheck;
	var canCheck = documentContext.privelege.canPatCheck
	if ((canCheck == 0)&&(signProperty.Authenticator.length == 0))
	{
		setMessage("没有权限进行患者签名"+documentContext.privelege.cantPatCheckReason,'forbid');
		return;
	}
	else if((canReCheck == 0)&&(signProperty.Authenticator.length > 0))
	{
		setMessage("没有权限进行患者改签"+documentContext.privelege.cantPatReCheckReason,'forbid');
		return;
	}
    
    if (typeof(handSign) == "undefined") {
	    var patCAoffMsg = "未开启患者签名功能，如需开启，请联系系统管理员";
	    if (typeof(patCAOffReason) != "undefined")
	    	var patCAoffMsg = patCAOffReason + patCAoffMsg;	
        setMessage(patCAoffMsg,'forbid');
        return;
    }
    
    var tmpInstanceId = signProperty.InstanceID || documentContext.InstanceID;
   	var actionType = 'Append';
    if (signProperty.Authenticator.length>0) { actionType = 'Replace'; }
    
    var argEditor = {
        signProps:{
            patientID: patientID,
            episodeID: episodeID,
            instanceID: tmpInstanceId,
            signKeyWord: "["+signProperty.Name+"]",
            actionType: actionType
        },
        actionType: actionType,
        episodeID: episodeID,
        userId: userID,
        instanceId: tmpInstanceId,
        dispalyName: documentContext.Title.DisplayName || "",
        path: signProperty.Path,
        signDocument: signDocument,
        saveSignedDocument: saveSignDocument,
        unSignedDocument: unsignDocument,
        canDoPDFSign: canDoPDFSign,
        getSignedPDF: getSignedPDF,
        getPatSignKeyWord: getPatSignKeyWord,
        createToSignPDFBase64: createToSignPDFBase64
    };
    
    if (signProperty.OriSignatureLevel.toUpperCase() == 'PATIENT') 
   	{
		handSign.sign(argEditor);
	}
    else //批注模式，目前暂时只有BJCA提供了
    {	
        //获取单元描述用于患者抄写
        var tarEl = getElementContext("MIElement");
        var descContent = tarEl.Props.Description||"";
        handSign.notationSign(argEditor,descContent); 
    }
    return;
}

// 打开签名窗口
function audit(signProperty)
{
	var qualityResult = qualitySignDocument();
	if (qualityResult) return; 
	var documentContext = getContextPrivilege("");
    var canRevokCheck = documentContext.privelege.canRevokCheck;
    if (isAllRevokeSign == "N")
	{
		if (pluginType != "GRID") canRevokCheck =0;
	}
    var tmpInstanceId = signProperty.InstanceID || documentContext.InstanceID;
    var openFlag = episodeType=="O"?"0":"1";
	if ('1' == CAServicvice) 
	{
		var signParam = {"topwin":window,"canRevokCheck":canRevokCheck,"cellName":signProperty.Name,"oriSignatureLevel":signProperty.OriSignatureLevel};
		
		if (CAVersion == "2")
		{
            var ca_key = window.ca_key;
            
            if ((ca_key.SignType == "UKEY")||(ca_key.SignType == "FACE")){
                var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name,"oriSignatureLevel":signProperty.OriSignatureLevel};
                var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
                var usernameStr = base64encode(utf16to8(encodeURI(userName)))
                var iframeContent = "<iframe id='iframeSignCA' scrolling='no' frameborder='0' src='emr.ip.signca.csp?UserName="+usernameStr+"&UserID="+userID+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID+"&SignParamStr="+signParamStr+"&openWay=editor"+"&MWToken="+getMWToken()+"' style='width:350px; height:245px; display:block;overflow:hidden;'></iframe>"
                var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
                createModalDialog("CASignDialog","CA签名","370","295","iframeSignCA",iframeContent,signCACallBack,arr)
            } else {
                var src = "emr.ip.signca.phone.csp?episodeID="+episodeID+"&canRevokCheck="+canRevokCheck+"&oriSignatureLevel="+signProperty.OriSignatureLevel+"&venderCode="+ca_key.VenderCode+"&signType="+ca_key.SignType+"&product=EMR&cellName="+base64encode(utf16to8(encodeURI(signProperty.Name)))+"&MWToken="+getMWToken();
				var iframeContent = "<iframe id='iframeLoginQrcode' scrolling='no' frameborder='0' src='"+src+"' style='width:749px; height:712px; display:block;overflow:hidden;'></iframe>"
				var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
				createModalDialog("loginQrcode","CA签名","750","750","iframeLoginQrcode",iframeContent,signCACallBack,arr)
            }
		}
		else
		{
			var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name,"oriSignatureLevel":signProperty.OriSignatureLevel};
			var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
			var usernameStr = base64encode(utf16to8(encodeURI(userName)))
			var iframeContent = "<iframe id='iframeSignCA' scrolling='no' frameborder='0' src='emr.ip.signca.csp?UserName="+usernameStr+"&UserID="+userID+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID+"&SignParamStr="+signParamStr+"&openWay=editor"+"&MWToken="+getMWToken()+"' style='width:350px; height:245px; display:block;overflow:hidden;'></iframe>"
			var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
			createModalDialog("CASignDialog","CA签名","370","295","iframeSignCA",iframeContent,signCACallBack,arr)
		}
	}
	else
	{
		//模板上签名单元的签名模式设置为“不验证签名”
		if (signProperty.SignMode.toUpperCase() == 'SILENT')
		{
			openFlag = "0";
		}
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name,"oriSignatureLevel":signProperty.OriSignatureLevel};
		var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
		
		var iframeContent = "<iframe id='iframeSign' scrolling='auto' frameborder='0' src='emr.ip.sign.csp?UserName="+userName+"&UserCode="+userCode+"&OpenFlag="+openFlag+"&UserLocID="+userLocID+"&EpisodeID="+episodeID+"&SignParamStr="+signParamStr+"&openWay=sign"+"&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>"
		var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId,"documentContext":documentContext}
		createModalDialog("SignDialog","系统签名","404","305","iframeSign",iframeContent,signCallBack,arr)
		
	}
}

//移动扫码签变更实现方式，此方法暂时作废
function mobileSignCallBack(returnValue,arr1,arr2)
{
	var certObj = returnValue || "";
    if ((certObj.retCode == "0")&&(certObj.hisUserID != "")) {
        var userInfo = ajaxLoginCA(certObj,ca_key.VenderCode,ca_key.SignType,arr1.OriSignatureLevel);
        if (userInfo != "") {
            returnValues = '{"action":"sign","userInfo":'+userInfo+'}';
        }
    }
    returnValues = returnValues||"";
    caSignContent(returnValues,arr1,arr2,certObj);		
	
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
	if ((userInfo.UserLevel == "")&&(userInfo.UserPos == "")&&(userInfo.characterCode == ""))
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
		if (pluginType == "GRID")
		{
			var ret = revokeSignElement(signProperty);
			if (ret.result != "OK")
			{
				setMessage('撤销失败','warning');
			}
		}
		else
		{
			var ret = revokeWordSign(userInfo,signProperty,tmpInstanceId);
		}
		
		if (ret.result == "OK")
		{
			var tmpDocContext = getDocumentContext(tmpInstanceId);
			if (tmpDocContext.result == "ERROR") 
			{
				setMessage('获取文档信息失败','alert');
				return;
			}

		    //当前文档状态
		    setStatus(tmpDocContext);
		    //修改文档目录
			modifyQuicknav(tmpDocContext);
			//刷新菜单
            reloadMenu(tmpDocContext.InstanceID);
			
			setMessage('撤销成功','alert');
		}
	}
}

function caSignContent(returnValues,signProperty,tmpInstanceId)
{
	if ((returnValues == "") || (returnValues == undefined)) return;
	
	var returnValues = eval("("+returnValues+")");
	userInfo = returnValues.userInfo;
	if ((userInfo.UserLevel == "")&&(userInfo.UserPos == "")&&(userInfo.characterCode == ""))
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
            var ca_key = window.ca_key;
            if ((ca_key.SignType == "UKEY")||(ca_key.SignType == "FACE")){
                caSign(signProperty,userInfo,tmpInstanceId);
            }else{
	            var certObj = returnValues.cert;
	            ca_key.SetCertInfo(JSON.stringify(certObj));
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
		if (pluginType == "GRID")
		{
			var ret = revokeSignElement(signProperty);
			if (ret.result != "OK")
			{
				setMessage('撤销失败','warning');
			}
		}
		else
		{
			var ret = revokeWordSign(userInfo,signProperty,tmpInstanceId);
		}
			
		if (ret.result == "OK")
		{
			var tmpDocContext = getDocumentContext(tmpInstanceId);
			if (tmpDocContext.result == "ERROR") 
			{
				setMessage('获取文档信息失败','alert');
				return;
			}

		    //当前文档状态
		    setStatus(tmpDocContext);

			//修改文档目录
			modifyQuicknav(tmpDocContext);
			//刷新菜单
            reloadMenu(tmpDocContext.InstanceID);
			
			setMessage('撤销成功','alert');
		}
	}	
}

//Word撤销签名
function revokeWordSign(userInfo,signProperty,instanceId)
{
	var ret = {"result":"ERROR"};
	var userLevel = signProperty.SignatureLevel;
	var userID = signProperty.Id
	var isSuperiorSign = IsSuperiorSign(userLevel,instanceId);
	if (isSuperiorSign == "1")
	{
		setMessage('上级医师已签名，需上级医师撤销后才可撤销签名！','warning');
	}
	else
	{
		ret = cmdRevokeSignedDocument(userLevel,instanceId,userID);
	}
	return ret;
}

//判断
function IsSuperiorSign(userLevel,instanceId)
{
	var result = "0";
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"IsSuperiorSign",
			"p1":userLevel,
			"p2":instanceId
        },
        success: function(ret) {
            result = ret;

        },
        error: function(ret) {alert(ret);}
    });
    return result;	
}

//ca签名模态框
function signCACallBack(returnValue,arr)
{
	var signProperty = {};
	var tmpInstanceId = ""
	if (typeof(arr.signProperty) != "undefined")
	{
		signProperty = arr.signProperty; 
	}
	if (typeof(arr.tmpInstanceId) != "undefined")
	{
		tmpInstanceId = arr.tmpInstanceId;
	}
	caSignContent(returnValue,signProperty,tmpInstanceId)
}

//移动扫码签变更实现方式，此方法暂时作废
//登录，返回用户名，和签名图片
function ajaxLoginCA(certObj,venderCode,signType,oriSignatureLevel) {
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
				"pa":strServerRan,
				"pb":UsrCertCode,
            	"pc":UserSignedData,
            	"pd":certificateNo,
            	"pe":cert,
            	"pf":userLocID,
            	"pg":"inpatient",
            	"ph":episodeID,
            	"pi":signType,
            	"pj":venderCode,
            	"pk":oriSignatureLevel
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
	var checkresult = checkPrivilege(userInfo,signProperty,"caSign",instanceId);
	if(!checkresult.flag) return;

	//开始签名
	var cert = GetSignCert(strKey);
    var UsrCertCode = GetUniqueID(cert,strKey);
    if (!UsrCertCode || '' == UsrCertCode) return '用户唯一标示为空！';
    if (CAVersion == "2")
	{
		var certNo = GetCertNo(strKey);
	}
	else
	{
		var certNo = ""
	}
	var signlevel = userInfo.characterCode;
	var actionType = checkresult.ationtype;
	if (signCTPCPType == "Character")
	{
		//职称描述取签名角色描述
		var CTPCPDesc = userInfo.characterDesc
	}
	else
	{
		//职称描述取真实职称
		var CTPCPDesc = userInfo.CTPCPDesc
	}
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,CTPCPDesc,"","",signProperty.Path);

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    parentWin.$.messager.alert("签名提示", "签名原文为空！",'info');
	    return ;
	}
    var signValue = SignedData(signInfo.Digest,strKey);
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
	var checkresult = checkPrivilege(userInfo,signProperty,"caSignMobile",instanceId);
	if(!checkresult.flag) return;

	//开始签名
	var cert = GetSignCert(certObj.certContainer);
    var UsrCertCode = GetUniqueID(cert,certObj.certContainer);
    if (!UsrCertCode || '' == UsrCertCode) return '用户唯一标示为空！';
    
	var signlevel = userInfo.characterCode;
	var actionType = checkresult.ationtype;
	if (signCTPCPType == "Character")
	{
		//职称描述取签名角色描述
		var CTPCPDesc = userInfo.characterDesc
	}
	else
	{
		//职称描述取真实职称
		var CTPCPDesc = userInfo.CTPCPDesc
	}
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,CTPCPDesc,"","",signProperty.Path);

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    parentWin.$.messager.alert("签名提示", "签名原文为空！",'info');
	    return ;
	}
    
    //获取病历信息传给CA展示
    var recordInfo = GetRecordInfo(instanceId);
	if (recordInfo != "") {
		recordInfo = JSON.stringify(recordInfo);
	}
    
    var signValue = SignedData(signInfo.Digest,certObj.certContainer,episodeID,recordInfo);
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
	var checkresult = checkPrivilege(userInfo,signProperty,"checkSign",instanceId);
	if(!checkresult.flag) return;
	var signlevel = userInfo.characterCode;
	var actionType = checkresult.ationtype;	
	if ((actionType == "Append" && documentContext.privelege.canCheck == 0) || (actionType == "Replace" && documentContext.privelege.canReCheck == 0))
	{
		setMessage("没有权限签名",'forbid');
		return
	}
	if (signCTPCPType == "Character")
	{
		//职称描述取签名角色描述
		var CTPCPDesc = userInfo.characterDesc
	}
	else
	{
		//职称描述取真实职称
		var CTPCPDesc = userInfo.CTPCPDesc
	}
	//开始签名
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,CTPCPDesc,"","",signProperty.Path);
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
		unsignDocument();
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
	            result.message = emrTrans("没维护三级医师");
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
				result.message = emrTrans("该用户不是该患者的责任医师,无权限签名");
			}

        },
        error: function(ret) {alert(ret);}
    });
    return result;	
}

//检查签名权限脚本
function checkPrivilege(userInfo,signProperty,checkType,instanceId)
{
	var result = {"flag":false,"ationtype":""};
	
	var UserID = userInfo.UserID;
	var characterCode = userInfo.characterCode;
	var OriSignatureLevel = signProperty.OriSignatureLevel;
	var SignatureLevel = signProperty.SignatureLevel;
	var Id = signProperty.Id;
	var signedLength = signProperty.Authenticator.length;
	var allSignLevel = getAllSignLevel(signProperty.Authenticator);
	
	$.ajax({
		type: "GET",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"CheckPrivilege",
			"p1":UserID,
			"p2":characterCode,
			"p3":OriSignatureLevel,
			"p4":allSignLevel,
			"p5":Id,
			"p6":signedLength
		},
		success: function (data){
			if (data == "Append")
			{
				//签名
				result = {"flag":true,"ationtype":"Append"};
			}
			else if(data == "Replace")
			{
				setMessage(emrTrans("请联系已签名者撤销后再进行签名"),"forbid");
				//改签
				/*
				if (confirm("已签名，是否改签")==true)
				{
					result = {"flag":true,"ationtype":"Replace"};
				}
				else
				{
					result = {"flag":false,"ationtype":""};
				}	
				*/
			}
			else if(data != "")
			{
				setMessage(data,"forbid");
			}
			else
			{
				setMessage("无权限签名","forbid");
			}
		 }
	});
	
	//是否需要撤销签名
	/*
	if ((isAllRevokeSign.split("^")[0] == "Y")&&(isAllRevokeSign.split("^")[1] == "Y")&&(checkType != "checkSign")&&(UserID == Id))
	{
		var text = '是否需要撤销本人签名？';
		parentWin.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				
				var ret = revokeWordSign(userInfo,signProperty,instanceId);
				if (ret.result == "OK")
				{
					var tmpDocContext = getDocumentContext(instanceId);
					if (tmpDocContext.result == "ERROR") 
					{
						setMessage('获取文档信息失败','alert');
						return;
					}

				    //当前文档状态
				    setStatus(tmpDocContext);

					//修改文档目录
					modifyInstanceTree(tmpDocContext);
					
					setMessage('撤销成功','alert');
				}
				
			}
		});
	}
	*/
	return result;	
}

function getAllSignLevel(authenticator)
{
	var result = "";
	for (var i=0;i<authenticator.length;i++)
	{
		if((authenticator[i].SignatureLevel != undefined)&&(authenticator[i].SignatureLevel != ""))
		{
			if (result != "") {result = result + "^";}
			result = result + authenticator[i].SignatureLevel;
			result = result + "|" + authenticator[i].Id;
		}
	}
	return result;
}

//设置权限
function setPrivelege(documentText,sync)
{
	if (documentText == null) return;
	if (documentText.result == "ERROR") return;
	if (typeof(documentText.status) == "undefined") return;
	if (documentText.status.curStatus == "deleted") return;
	
	//设置工具栏
	setActionPrivilege(documentText.privelege);
	//不在这里面进行设置，挪到initToolbarStatus方法中，在eventload时调用
    //toolbar.initRevision();
	
	//判断文档是否只读，只读则使文档不能保存
	if (getReadOnlyStatus().ReadOnly == "True")
	{
		setSaveStatus('disable');
	}
	
	if (documentText.privelege.canSave == "0")
	{
		setReadOnly(true,[documentText.InstanceID],true,sync);
	}
	else
	{
		if (documentText.privelege.canRevise == "-1" && documentText.status.signStatus == "1")
		{
			if (setRevisionState(documentText.InstanceID,true).result != "OK") parentWin.$.messager.alert("提示信息", "开启留痕失败", 'info');
		}
		else if (documentText.privelege.canRevise == "1")
		{
			if (setRevisionState(documentText.InstanceID,true).result != "OK") parentWin.$.messager.alert("提示信息", "开启留痕失败", 'info');
		}
		else
		{
			if (documentText.InstanceID != "GuideDocument")
			{
				//增加关闭设置留痕流程，兼容grid编辑器切换时导致病历签名状态异常。
				if (setRevisionState(documentText.InstanceID,false).result != "OK") parentWin.$.messager.alert("提示信息", "关闭留痕失败", 'info');
			}
		}
	}	
	///加锁时禁用工具栏
	if (!$("#lock").is(":hidden"))
	{
		setToolBarStatus("disable");
	}
}

//设置状态
function setStatus(documentText)
{
	if (documentText == null) return;
	if (documentText.result == "ERROR") return;
	if (typeof(documentText.status) == "undefined") return;
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
	var happendatetime = documentContext.HappenDateTime;	
	if (status == undefined)
	{
		setMessage('请先选中文档再删除!','warning');
		return;
	}
	var tipMsg = "【"+happendatetime+ " " +titleName+"】" + emrTrans("是否确定删除 ?");
	var flag= false;
	var tipMsg1 = "";
	var tipMsg2 = "";
	var tipMsg3 = "";
	if (isPrintedRecord(instanceId) != "0")
	{
		flag = true;
		tipMsg1 = emrTrans("已经打印");
	} 
	if (isFavoriteRecord(instanceId))
	{
		flag = true;
		tipMsg2 = emrTrans("曾经被收藏过");
	}
	if ((status != "finished")&&(status != "")&&(status != "deleted"))
	{
		flag = true;
		tipMsg3 = emrTrans("已经签名");
	}
	var tipMsg4 = "【"+happendatetime+ " " +titleName+"】"+tipMsg1+" "+tipMsg2+" "+tipMsg3+" "+emrTrans("是否确定删除 ?");
	if(!flag)
	{
		parentWin.$.messager.confirm("操作提示", tipMsg, function (data) {
				if (!data)
				{   
				   return ;
				}
				else 
				{   
					deleteComDocument(instanceId);
				}
			});
	}
	else
	{
		parentWin.$.messager.confirm("提示", tipMsg4, function (data) {
				if (!data)
				{   
				   return ;
				}
				else 
				{   
					deleteComDocument(instanceId);
				}
			});
	}
}

function deleteComDocument(instanceId)
{
	var creatorMessage = getCreatorMessage(instanceId);
	//开启删除输入密码功能时，创建的病历获取不到相关创建信息，导致无法删除的BUG问题，需要在代码里对UnSave状态病历删除时给予判断
	if ((isDeleteVerification == "Y")&&(creatorMessage[0].status != "UNSAVE")&&(creatorMessage[0].ispasswordState == "0"))
	{
		if (creatorMessage != "")
		{
			if ((creatorMessage[0].creatorID != "")&&(creatorMessage[0].creatorName != ""))
			{	
				var arr = {"instanceId":instanceId};
				createModalDialog("deleteDialog","删除","265","250","iframeDelete","<iframe id='iframeDelete' scrolling='auto' frameborder='0' src='emr.ip.userverification.delete.csp?UserID="+creatorMessage[0].creatorID+"&UserName="+base64encode(utf16to8(encodeURI(creatorMessage[0].creatorName)))+"&MWToken="+getMWToken()+"' style='width:255px; height:210px; display:block;'></iframe>",deleteCallBacke,arr)
			}
		}
	}else
	{
		if (param.IsActive != "N") param.IsActive = "N";
		//当开启分阶段加载时，判断当前病历是否加载完全
		if (loadDocMode.TitleCode != "")
		{
			if (!IsAppedDocument()) return;
		}
		var json = {action:"DELETE_DOCUMENT",args:{"InstanceID":instanceId}};
		cmdDoExecute(json);
	}	
}

//删除病历模态框
function deleteCallBacke(returnValue,arr)
{
	if ((returnValue == "")||(typeof(returnValue) == "undefined")) 
	{
		return;
	}
	else if(returnValue == "0")
	{
		parentWin.$.messager.alert("提示信息", "密码验证失败");
		return;
	}
	if (param.IsActive != "N") param.IsActive = "N";
    //当开启分阶段加载时，判断当前病历是否加载完全
    if (loadDocMode.TitleCode != "")
    {
        if (!IsAppedDocument()) return;
    }
	var json = {action:"DELETE_DOCUMENT",args:{"InstanceID":arr.instanceId}};
	cmdDoExecute(json);
}

//提示当前病例是否被收藏
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
			"p1":"",
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

//弹出病历已打印的提醒框
function isPrintedRecord(instanceId)
{
	var result = "0";
	$.ajax({
		type: "GET",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRLogs",
			"Method":"RecHasAction",
			"p1":episodeID,
			"p2":instanceId,
			"p3":"Print"
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
			"p1":instanceId,
			"p2":userID
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
		eventCreateDocumentReframe(commandJson);
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
		eventCreateDocumentReframe(commandJson);
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
		//刷新引用数据，记录下次是否弹出（插件弹出）
		eventRefreshReferenceData(commandJson);
	}
	else if (commandJson["action"] == "eventDiffentReferenceData")
	{
		//数据同步时取数据返回事件（前端弹出）
		eventDiffentReferenceData(commandJson);
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
	else if(commandJson["action"] == "eventRequestTemplate")
	{
		eventRequestTemplate(commandJson);
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
            //根据编辑器活跃状态判断是否页面系统失效
            if(eventEMRHrartBeatStatus())
            {
                setMessage('页面系统失效，请重新登录!','forbid');
            }
        }
    }
	else if(commandJson["action"] == "Event_Title_Superior_Doctor")
	{
		eventTitleSuperiorDoctor(commandJson);
	}
	else if(commandJson["action"] == "eventRequestUpdateTitleInfo")
	{
		//请求更新标题数据
		eventRequestUpdateTitleInfo(commandJson);
	}	//自动续打
	else if(commandJson["action"] == "eventAutoContinuePrint"){
		eventAutoContinuePrint(commandJson);
	}else if(commandJson["action"] == "eventCreateDocumentReframe"){
		//处理病历空白
		eventCreateDocumentReframe(commandJson);
	}else if(commandJson["action"] == "eventRequestKnowledgeBase")
	{
		//ctrl+k快捷键
		eventRequestKnowledgeBase(commandJson);
	}else if(commandJson["action"] == "eventSearchCdssBase")
	{
		//查看知识库
		eventSearchCdssBase(commandJson);
	}
    else if(commandJson["action"] == "eventModifyTitleTime")
    {
        //按条目加载病程时修改病程记录标题时间
        eventModifyTitleTime(commandJson);
    }
    else if(commandJson["action"] == "eventRequestDoc")
    {
        //按条目加载病程，滚动病历滚动轴，请求病历追加事件
        eventRequestDoc(commandJson);
    }
	else if(commandJson["action"] == "eventDocModify")
	{
		//发送文档修改事件
		eventDocModify(commandJson);
	}
	else if(commandJson["action"] == "eventInsertSymbol")
	{
		//打开特殊字符窗口
		eventInsertSymbol(commandJson);
	}		
}

function eventInsertSymbol(commandJson)
{
	var tempFrame = "<iframe id='iframeSpechars' scrolling='auto' frameborder='0' src='emr.ip.tool.spechars.csp'"+"&MWToken="+getMWToken()+ " style='width:510px; height:428px; display:block;'></iframe>";
	createModalDialog("dialogSpechars","特殊字符","514","468","iframeSpechars",tempFrame,insertStyleText,"");

}

function eventCreateDocumentReframe(commandJson)
{
		var panelWidth=$("#main").layout("panel","center").panel('options').width+1;
		var panelHeight=$("#main").layout("panel","center").panel('options').height+1;
		$("#main").layout("panel","center").panel('resize',{
			width:panelWidth,
			height:panelHeight
		})
}

//取绑定数据后异步事件
function eventRefreshReferenceData(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		updataRefreshBindData(commandJson["args"]["SyncDialogVisible"]);
	}
}

function updataRefreshBindData(SyncDialogVisible)
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
			"p2":SyncDialogVisible
		}
	});	
}

var dataObjStr = "true";	//此参数在“dataObjStr = commandJson.args;”之前用作记录是否手动打开；之后用作插件返回的数据。
//前端弹绑定数据的异步事件
function eventDiffentReferenceData(commandJson)
{
	//没有需要同步的数据，并且不是手动打开，不进行弹窗;参数dataObjStr记录了是否手动，false是手动
	if ((commandJson["args"]["Items"].length == 0)&&(dataObjStr == "true")) return;
	if (commandJson["args"]["result"] == "OK")
	{
		var autoRefresh = dataObjStr;	//false:手动
		dataObjStr = {
			Items:[],
			total:0
		};
		dataObjNullStr={
			total:0
		}
		var InstanceID = getLastInstanceID().InstanceID;
		jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLRefreshDataHidden",
					"Method":"GetAllCodeByInstanceID",	
					"p1":InstanceID
				},
			success : function(d) {
				var Codes = d.split("^");
				var sameCodeCount = 0;	//用来存储插件返回的同步数据和勾选不需要显示的同步数据相同的条数
				for (var i=0;i<commandJson["args"]["Items"].length;i++)
				{
					if((commandJson["args"]["Items"][i].OldValue == "-")&&(commandJson["args"]["Items"][i].NewValue == ""))
					continue;
					if(Codes.indexOf(commandJson["args"]["Items"][i].Code) !== -1) {
						sameCodeCount++;
					} else {
						if (commandJson["args"]["Items"][i].NewValue == "") dataObjNullStr.total++;
					}
					dataObjStr.total++;
					dataObjStr.Items.push(commandJson["args"]["Items"][i]);
				}
				if (autoRefresh == "true")	//非手动
				{
					//需要同步的数据都是不需要显示的数据||需要同步的数据来源值都是空值||(不需要显示的+来源值空值)=需要同步的数据
					if ((sameCodeCount == dataObjStr.total)||(dataObjNullStr.total == dataObjStr.total)||((sameCodeCount+dataObjNullStr.total) == dataObjStr.total)) return;
				}
				window.parentWin.dataObjStr = dataObjStr;
				dataObjStr = "true";
				var tempFrame = "<iframe id='iframeSynData' scrolling='auto' frameborder='0' src='emr.ip.datasyn.csp?InstanceID="+InstanceID+"&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
				createModalDialogTop("dialogSynData","数据同步","600","550","iframeSynData",tempFrame,synDataCallback,"");
			}
		});	
	}	
}

//同步数据回调
function synDataCallback(returnValue,arr)
{
	//console.log(returnValue);
 	if (returnValue.updataStr !== undefined)
	{
		var instanceID = getDocumentContext().InstanceID;
		updateInstanceData("Replace",instanceID,"","",returnValue.updataStr);
	}
/* 	if (returnValue.checkStatu !== undefined)
	{
		updataRefreshBindData(returnValue.checkStatu);
	} */
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
	//刷新菜单
    reloadMenu(documentContext.InstanceID);
	lockSpecial(documentContext);
}

//章节改变事件
function eventSectionChanged(commandJson)
{
	var length = $('#newMain').layout('panel','east').length;
    if(length>0)
    {
	   	//刷新知识库
    	var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:commandJson["args"]["BindKBBaseID"],"titleCode":titleCode,"diseaseID":""};
    	resource.eventReflashKBNode(paramJson);
    	//定位章节
    	var path = commandJson["args"]["InstanceID"]+"_"+commandJson["args"]["Path"];
    	if (path == "") return;
    	//focusOutLine(path);
	}	
}
//保存事件监听
function eventSaveDocument(commandJson)
{
	setSysMenuDoingSth("");
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
			modifyQuicknav(documentContext);
						
			setMessage('数据保存成功!','alert');
			//启用病历信息订阅与发布
			if (Observer == "Y")
			{
				GetObserverData();
			}
			//刷新菜单
            reloadMenu(documentContext.InstanceID);
			//质控
			qualitySaveDocument();
			if (typeof (param.args) != "undefined" && typeof (param.args.event) !="undefined" && param.args.event != "")
	   		{
		   		getEvent();
		   	}	

	   		//保存日志(基础平台组)
			setOperationLog(param,"EMR.Save");
			//保存调用CDSS		
			cdssParam(param,"Save");
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
	
	else if (commandJson["args"]["result"] == "INVALID")
    {
		setMessage('病历存在非法字符，不能保存。','warning'); 
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
			parentWin.$.messager.alert("简单提示", "同步信息获取失败!");
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
						var arrayStr = base64encode(utf16to8(escape(JSON.stringify(array))));
						createModalDialog("observerDialog","同步患者基本信息","617","323","iframeObserver","<iframe id='iframeObserver' scrolling='auto' frameborder='0' src='emr.observerdata.csp?ArrayStr="+arrayStr+"&openWay=editor"+"&MWToken="+getMWToken()+"' style='width:607px; height:313px; display:block;'></iframe>",observerCallBack,"")
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
    
}

//同步患者基本信息模态框
function observerCallBack(returnValue,arr)
{
	if (returnValue)
	{
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
		parentWin.$.messager.alert("提示信息", arrReportInfection[1]);
	}
	else if (arrReportInfection[0] == "1")
	{
		if (!window.confirm(arrReportInfection[1])) return;
		var c2 = String.fromCharCode(2);
		var arrReportInfectionUrl = arrReportInfection[2].split(c2);
		for (var i=0; i<arrReportInfectionUrl.length; i++)
		{
			if (arrReportInfectionUrl[i] == "") continue;
			try{
	        createModalDialog("infectionDialog","传染病上报","810","810","iframeInfection","<iframe id='iframeInfection' scrolling='auto' frameborder='0' src='arrReportInfectionUrl[i]"+"&MWToken="+getMWToken()+"' style='width:800px; height:800px; display:block;'></iframe>","","")
	    }catch(e){
	        parentWin.$.messager.alert("提示信息", e.message);
	    }
  	}
  }
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
	setSysMenuDoingSth();
	loadFalg = false;
	if (commandJson["args"]["result"] == "OK")
	{
		//param初始为空，需要重新定义为对象进行赋值
		if (param != ""){
			param.id = commandJson["args"]["InstanceID"];
		}else{
			param = {"id": commandJson["args"]["InstanceID"]};
		}
		titleCode = commandJson["args"]["Title"]["Code"];
		var baseId = ""
		if (commandJson["args"]["BindKBBaseID"] != undefined) baseId = commandJson["args"]["BindKBBaseID"]
		var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:baseId,"titleCode":titleCode};
		var length = $('#newMain').layout('panel','east').length;
    	if(length>0)
    	{
	    	resource.eventReflashKBNode(paramJson);
		}
	    if (param.insert)
	    {
		    focusDocument(args.InstanceID,param.insert.path,"Last");
		    insertText(param.insert.content);
	    }
		//初始化工具栏状态 2019.8.20 990004
	    initToolbarStatus();
	}
    //切换成病历目录形态
    if ("undefined" != typeof parent.parent.EPRCATE85){
        if ("undefined" != typeof parent.parent.EPRCATE85.isEprCategory){
            if (!parent.parent.EPRCATE85.isEprCategory()){
                parent.parent.switchToolHandler();
            }
        }
    }
    //增加文档加载完成校验变更情况
    if (getModifyStatus("").Modified == "True")
	{
		eventDocModifyFront("True");
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
		modifyQuicknav(documentContext);
		setMessage('数据签名成功!','alert');
		//刷新菜单
        reloadMenu(documentContext.InstanceID);
		
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
		
		//修改危急值事件的IsActive字段
		modifyCriticalEventValue(commandJson["action"]);
		
		//刷新菜单
        reloadMenu(instanceId);
		if(showNav == "Y")
	    {
		   var deleteData = deleteTreeItem(instanceId,"InstanceTree");
		   //修改文档目录
		   addDeleteTree(deleteData);
		}
		setMessage('病历删除成功!','alert');
		//基础平台组审计和日志记录
		setOperationLog(param,"EMR.Delete.OK");
		//删除调用CDSS		
		cdssParam(param,"Delete");	
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
	var documentContext = getDocumentContext("");
	if ((!documentContext)||(!documentContext.InstanceID)) {
		getNav();
	}
}
//快捷键保存
function eventSave()
{
	if (getModifyStatus("").Modified != "True") return;
	var documentContext = getContextPrivilege("");
	if (documentContext.result != "OK") return;
	//判断文档是否只读，只读则使文档不能保存
	if (getReadOnlyStatus().ReadOnly == "True") return;
	if (documentContext.privelege.canSave != "1") return;
    saveDocument();
}

//插入备注
function eventInsertSummary(commandJson)
{
	var paramSummary = {"memoText":commandJson.args.Value,"instanceId":param.id};
	var paramSummaryStr = base64encode(utf16to8(escape(JSON.stringify(paramSummary))));
	createModalDialog("memoDialog","插入备注","490","350","iframeMemo","<iframe id='iframeMemo' scrolling='auto' frameborder='0' src='emr.ip.memo.csp?&paramSummaryStr="+paramSummaryStr+"&MWToken="+getMWToken()+"' style='width:465px; height:310px; display:block;'></iframe>","","")
}

//设置字体样式
function eventCaretContext(commandJson)
{
	
}

//文档加载成功事件
function eventLoadDocument(commandJson)
{
	setSysMenuDoingSth();
	if (commandJson["args"]["result"] == "OK")
	{
		loadFalg = false;
		changeFlag = false;
		$('#layout').layout('expand','west');
        
        var tempParam = getLastInstanceData(getLastInstanceID().InstanceID);
        if (tempParam != "")
        {
            //设置引导框
            var isMutex = (tempParam["isMutex"]=="1")?true:false;
            var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
            if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
        }else{
            //病程部分加载时，需要通过设置引导框来告知插件标题信息
            if ((loadDocMode.TitleCode != "")||(loadDocMode.RecordConfig != "")){
                if (param != ""){
                    var isMutex = (param["isMutex"]=="1")?true:false;
                    if(!checkCreatePrivilege(param,false)) setDocTempalte(param["emrDocId"],isMutex,false);
                }else{
                    tempParam = getInstanceDataByInsID(commandJson.args.InstanceID);
                    var isMutex = (tempParam["isMutex"]=="1")?true:false;
                    if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,false);
                }
            }
        }
		
		//设置按钮状态
		initToolbarStatus();
		var documentContext = getDocumentContext("");
		//获取文档操作权限，设置只读时为同步事件
		setPrivelege(documentContext,true);
		//获取当前病历只读状态
		var readOnlyStatus = getReadOnlyStatus().ReadOnly;
		if((pluginType=="GRID") &&(readOnlyStatus == "False")){
				//静默刷新
			silentRefreshReferenceData(commandJson.args.InstanceID);
		}
		if (readOnlyStatus == "False")
		{
			//自动触发绑定数据同步
			refreshReferenceData(commandJson.args.InstanceID,"true")
		}
		var length = $('#newMain').layout('panel','east').length;
	    if(length>0)
	    {
			if ((resource.$ != undefined)&&(resource.$('#resources').tabs("exists","质控提示")))
			{
				resource.$('#resources').tabs("close","质控提示");
			}
		}
	}
	else
	{
		setToolBarStatus("disable");
		setMessage('文档加载失败','warning');
	}
    //切换成病历目录形态
    if ("undefined" != typeof parent.parent.EPRCATE85){
        if ("undefined" != typeof parent.parent.EPRCATE85.isEprCategory){
            if (!parent.parent.EPRCATE85.isEprCategory()){
                parent.parent.switchToolHandler();
            }
        }
    }
}
//静默刷新方法
function silentRefreshReferenceData(instanceID){
	var strJson={action:"SILENT_REFRESH_REFERENCEDATA", "args": {"InstanceID":instanceID}};
		cmdSyncExecute(strJson);
} 

//查询病历instanceId是否已显示在编辑器中
function checkDocument(instanceId)
{
	var argJson = {"action":"CHECK_DOCUMENT","args":{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//获取编辑器中显示的最后一份病历ID
function getLastInstanceID()
{
    var argJson = {"action":"GET_LAST_DOCUMENT","args":{}};
    return cmdSyncExecute(argJson);
}

//判断instanceId为相同DocID在后台保存的最后一份病历
function getLastInstanceData(instanceId)
{
    var tempParam = "";
    if (instanceId == "") return tempParam;
    jQuery.ajax({
        type : "GET", 
        dataType : "text",
        url : "../EMRservice.Ajax.common.cls",
        async : false,
        data : {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLInstanceData",
            "Method":"getLastInstanceData",
            "p1":instanceId
        },
        success : function(d) {
            if ( d != "")
            {
                if (d == "UNSAVE") {
                    tempParam = d;
                }else {
                    tempParam = JSON.parse(d);
                }
            }
        }
    });
    return tempParam;
}

//根据病历ID获取病历数据
function getInstanceDataByInsID(instanceId)
{
    var tempParam = "";
    if (instanceId == "") return tempParam;
    jQuery.ajax({
        type : "GET", 
        dataType : "text",
        url : "../EMRservice.Ajax.common.cls",
        async : false,
        data : {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLInstanceData",
            "Method":"getInstanceDataByInsID",
            "p1":instanceId
        },
        success : function(d) {
            if ( d != "")
            {
                tempParam = JSON.parse(d);
            }
        }
    });
    return tempParam;
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
	//if (InstanceID == undefined) InstanceID = getLastInstanceID().InstanceID;
	//if (InstanceID == "") return;
	var syncDialogVisible = "true";
	var silentRefresh = "false";
	reloadBinddata(autoRefresh,syncDialogVisible,silentRefresh);
	
	//获取是否显示同步提示框状态
	/*jQuery.ajax({
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
		});	*/
}

//文档打印事件
function eventPrintDocument(commandJson)
{
	setPrintInfo("false");
	setSysMenuDoingSth();
	if (commandJson["args"].result == "OK")
	{
		if (commandJson["args"].params.result == "OK")
		{
			//取文档信息
			var documentContext = getContextPrivilege("");
			//设置当前文档操作权限
			setPrivelege(documentContext);
			//当前文档状态
			setStatus(documentContext);
	
			//刷新菜单
            reloadMenu(documentContext.InstanceID);
			
			//基础平台组审计和日志记录
			setOperationLog(param,"EMR.Print.OK");
		}else if(commandJson["args"].params.result == "ERROR")
		{
			setMessage('打印日志未记录,请检查网络连接!','warning');
		}
	}else if(commandJson["args"].result == "ERROR")
	{
		//生成PDF不需要记录日志
        if (commandJson["args"].params && (typeof(commandJson["args"].params.IsSavePrintLog)!='undefined') && (commandJson["args"].params.IsSavePrintLog=="False")) {
            return;
        }
		//插件返回值只有2个 
		//OK 打印成功 
		//ERROR，可能为取消打印，或网络原因导致打印失败。
		//修改描述'打印日志未记录,请检查网络连接!' 为‘打印操作未完成’，增加友好度。
		setMessage('打印操作未完成!','warning');
	}
}
//自动续打事件
function eventAutoContinuePrint(commandJson)
{
	setPrintInfo("false");
	if (commandJson["args"].result == "OK")
	{
		if (commandJson["args"].params.result == "OK")
		{
			//取文档信息
			var documentContext = getContextPrivilege("");
			//设置当前文档操作权限
			setPrivelege(documentContext);
			//当前文档状态
			setStatus(documentContext);
	
			//刷新菜单
            reloadMenu(documentContext.InstanceID);
			//基础平台组审计和日志记录
			if(printInstanceIds && printInstanceIds.Items){
				for (var i=0;i<printInstanceIds.Items.length;i++){
				/*获取自动续打的每份病历的信息*/
					var instanceContext = GetRecodeParamByInsID(printInstanceIds.Items[i].InstanceID);
				/*保存日志*/
				//基础平台组审计和日志记录
					setOperationLog(instanceContext,"EMR.AutoPrint.OK");
				}
			}
		}else if(commandJson["args"].params.result == "ERROR")
		{
			setMessage('打印日志未记录,请检查网络连接!','warning');
		}
	}else if(commandJson["args"].result == "ERROR")
	{
		//插件返回值只有2个 
		//OK 打印成功 
		//ERROR，可能为取消打印，或网络原因导致打印失败。
		//修改描述'打印日志未记录,请检查网络连接!' 为‘打印操作未完成’，增加友好度。
		setMessage('打印操作未完成!','warning');
	}	
}
//复制剪切
function eventSendCopyCutData(commandJson)
{
    var length = $('#newMain').layout('panel','east').length;
    if(length>0)
	{
    	//刷新知识库
    	resource.eventDispatch(commandJson);

	}
}

///签名
function eventRequestSign(commandJson)
{
    var documentContext = getContextPrivilege("");
    if (documentContext.result != "OK") return;
    if (documentContext.status.curStatus == "deleted") return;
    if (getModifyStatus("").Modified == "True")
    {
        if (documentContext.privelege.canSave == "0")
        {
            setMessage('文档已修改，需先保存后签名，当前文档您没有权限保存！','forbid');
            return;
        }
	     
        if (saveDocument()=="revoke") {
            var argJson = {action:"GET_SIGNED_INFO",args:{"Path":commandJson.args.Path}};
            var signedInfo = cmdSyncExecute(argJson);
            if (signedInfo.result == 'ERROR'){
                setMessage('获取签名元素信息失败！', 'error');
                return;
            }
            commandJson.args = signedInfo.params;
        }
     }
     
     var signProperty = commandJson.args;
     if ((signProperty.OriSignatureLevel.toUpperCase() == 'PATIENT')||(signProperty.OriSignatureLevel.toUpperCase() == 'NOTATION'))
     {
         patAudit(signProperty)
     }
     else
	 {
        var canCheck = documentContext.privelege.canCheck;
        if (canCheck != "1")
        {
            setMessage('您没有权限签名  ' +documentContext.privelege.cantCheckReason,'forbid');
            return;
        }
	 	audit(signProperty);
	 }
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

///创建病程按钮
function createTemplateBtn()
{
     var modifyStatus = getModifyStatus("");
     if (modifyStatus.Modified == "True")
     {
		var displayName = "";
		if ((typeof(modifyStatus.InstanceID) != "undefined")&&(modifyStatus.InstanceID.length>0))
		{
			for (i=0;i<modifyStatus.InstanceID.length;i++ )
			{
				var documentContext = getDocumentContext(modifyStatus.InstanceID[i]);
				
				//增加判定如果无保存权限，则退出保存检查
				if (documentContext.privelege.canSave != "1") return returnValues;
				
				if (displayName != "") {displayName = displayName + " "}
				displayName = displayName + documentContext.Title.DisplayName;
			}
		}
		
		var text = '病历 "' +displayName + '" 有修改是否保存';
		returnValues = window.confirm(text)
		if (returnValues)
		{
			saveDocument();
		}
		else
		{
			setMessage('已创建的病历需保存后，才允许创建新的病历！', 'error');
			return;	
		}		
	 }
	 eventRequestTemplate("");
	
}
///引用框事件
function eventRequestTemplate(commandJson)
{
	var content = "<iframe id='iframeTempTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+param.emrDocId+"&LocID="+userLocID+"&EpisodeID="+episodeID+"&openWay=editor"+"&MWToken="+getMWToken()+"' style='width:520px; height:620px; display:block;'></iframe>";
	createModalDialog("temptitleDialog","模板选择","525","660","iframeTempTitle",content,templateCallBack,"")
}

//引用框模态框
function templateCallBack(returnValue,arr)
{
	if ((returnValue.titleCode != "")&&(typeof(returnValue.titleCode) != "undefined"))
	{
		var tabParam ={
			"actionType":"CREATEBYTITLE",
			"status":"NORMAL",
			"titleCode":returnValue.titleCode,
			"titleName":returnValue.titleName,
			"dateTime":returnValue.dateTime,
			"userTemplateCode":returnValue.code,
			"titlePrefix":returnValue.titlePrefix,
			"emrDocId":param.emrDocId,
			"templateId":param.templateId
		}; 
		if (typeof(returnValue.doctorID) != "undefined")
		{
			tabParam.doctorID = returnValue.doctorID;
		}
		if ((returnValue.eventID != undefined)&&(returnValue.eventType != undefined)&&(returnValue.eventID != "")&&(returnValue.eventType != ""))
		{
			var argJson = {"event":{"EventID":returnValue.eventID,"EventType":returnValue.eventType}};
			tabParam.args = argJson;
		}
		if ((returnValue.exampleId != undefined)&&(returnValue.exampleId != "")) 
		{
			tabParam.actionType = "CREATEBYPERSONAL";
			tabParam.exampleId = returnValue.exampleId;
		}
		if(checkCreatePrivilege(tabParam,true)) return;
		createDocument(tabParam);
		//自动记录病例操作日志
		CreateDocumentLog(tabParam,"EMR.Record.RecordNav.CreateRecord.Create");
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
var selectedToothObj = "";
var lastrt = "";
//设置上次打开的牙位标识法
function setLastRepresentation(last){
	lastrt = last;
}
function getLastRepresentation(){
	return lastrt;	
}
function openTooth(commandJson)
{
	selectedToothObj = commandJson["args"];
	//var selectedToothObjStr = base64encode(utf16to8(escape(JSON.stringify(selectedToothObj))));
	//showDialogEditorTooth("toolbarPublicDialog","牙位图","1060","475","<iframe id='iframeEditorTooth' scrolling='auto' frameborder='0' src='emr.ip.tool.tooth.csp?selectedToothObjStr="+selectedToothObjStr+"' style='width:1060px; height:475px; display:block;'></iframe>")
	var tempFrame = "<iframe id='iframeTooth' scrolling='auto' frameborder='0' src='emr.ip.tool.toothimg.csp?MWToken="+getMWToken()+"' style='width:100%; height:100%;'></iframe>";
	createModalDialog("toothDialog","牙位图","1145","700","iframeTooth",tempFrame,editorToothCallBack,selectedToothObj);
}
//牙位图回调
 function editorToothCallBack(returnValue,arr)
{
	if (returnValue !== "") insertTooth("open",returnValue);
}
//双击已有牙位图时，获取牙位图数据信息，由子页面牙位图编辑页面调用
function getSelectedToothObj(){
    return selectedToothObj;
}
//由子页面牙位图关闭时调用
function resetSelectedToothObj(){
     selectedToothObj="";
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

//刷新病历文档权限
function updatePrivilege()
{
	var argJson = {"action":"UPDATE_PRIVILEGE","args":{"InstanceID":""}};
	cmdDoExecute(argJson);
}

function applyedit()
{
	if ((param.id == undefined)||(param.id == "")) return;
	if (lockinfo != "" && lockinfo.openMode == "ReadOnly")
	{
		alert("该病历处于锁定状态,不能自动授权!");
		return;
	}
	if (isSuperiorPhysicianSign() == 1) 
	{
		parentWin.$.messager.alert("提示信息", "上级医师已签名，不能自动授权，请通过工具栏的“申请权限”按钮申请权限！", 'info');
		return;
	}
	jQuery.ajax({
			type : "GET",
			dataType : "text",
			url : "../EMRservice.Ajax.AuthAppoint.cls",
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
					var documentContext = getDocumentContext(param.id);
					//设置当前文档操作权限
					setPrivelege(documentContext);
					setReadOnly(false,[param.id],false);
					parentWin.$.messager.alert("提示信息", "申请编辑成功！", 'info');
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

//更改病历修改状态
function resetModifyState(instanceID,state)
{
	var argJson = {action:"RESET_MODIFY_STATE",args:{"InstanceID":instanceID,"State":state}}
	cmdDoExecute(argJson);
}

function eventRequestImgData(commandJson)
{
	var argJson = {action:"EDIT_IMG",args:{}}
	cmdDoExecute(argJson);
}

//只锁正在编辑的病程记录解锁
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
					setReadOnly(false,[param.id],false);
				}
			}
		}
	}
}

//只锁正在编辑的病程记录加锁
function lockSpecial(documentText)
{
	if (isEnableEditMultiRecord == "false")
	{
		if ((documentText != null)&&(documentText.result != "ERROR")&&(documentText.privelege!="")&&(typeof(documentText.privelege)!="undefined"))
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
			setReadOnly(true,[param.id],true);
		}
	}
}

//获取某份实例是否被修改过
function getInstanceModifyStatus(instanceID)
{
	var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:{"InstanceID":instanceID}};
	return cmdSyncExecute(argJson);
}

function isEditMultiRecord(commandJson)
{
	if (isEnableEditMultiRecord == "true") return;
	if ((param != "")&&(param.id != undefined)&&(param.id != "")&&(param.id != commandJson["args"]["InstanceID"]))
	{
		//处理医为浏览器新建病程弹是否保存框的问题
		if (param.id == getDocumentContext().InstanceID) return;
		
		var result = savePrompt(param.id);
		if (result == "unsave")
		{
			resetModifyState(param.id,"false");
		}
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
			"Method":"GetRunEMRParams"
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

//清空文档
function clearDocument()
{
	if (typeof plugin() == "undefined") return;
	param = "";
	loadFalg = false;
	var argJson = {action:"CLEAN_DOCUMENT",args:""};
	cmdDoExecute(argJson);
	// 关闭留痕
	setRevisionState("","false");
}

//获取电子病历编辑活跃状态
function eventEMRHrartBeatStatus()
{
    var result = false;
    jQuery.ajax({
        type : "GET", 
        dataType : "text",
        url : "../EMRservice.Ajax.common.cls",
        async : false,
        data : {
            "OutputType":"String",
            "Class":"EMRservice.SystemParameter",
            "Method":"GetEMRHeartBeatTime"
        },
        success: function(d) {
			var ret= d;
            if (ret.indexOf('<html>') === "0") {
                result = true;
            }
        },
        error : function(d) { alert("GetEMRHeartBeatTime error");}
    });
    return result;
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
		},
		success:function(d)
		{
			silentRefreshReferenceData(commandJson["args"]["InstanceID"]);
		}
	});	
}

//请求更新标题数据
function eventRequestUpdateTitleInfo(commandJson)
{
	if (param == "") return;
	var datetime = commandJson.args.TitleDateTime;
	var eventID = commandJson.args.EventID;
	if (eventID == undefined) {eventID = "";}
	var eventType = commandJson.args.EventType;
	if (eventType == undefined) {eventType = "";}
	var instanceID = commandJson.args.InstanceID;
	if (instanceID == undefined) {instanceID = "";}
	var content = "<iframe id='iframeUpdateTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+param.emrDocId+"&LocID="+userLocID+"&EpisodeID="+episodeID+"&Action=updateTitle"+"&TitleCode="+titleCode+"&DateTime="+escape(datetime)+"&EventID="+eventID+"&EventType="+eventType+"&TitlePrefix="+escape(commandJson.args.TitlePrefix)+"&InstanceID="+instanceID+"&openWay=editor"+"&MWToken="+getMWToken()+"' style='width:500px; height:570px; display:block;'></iframe>";
	createModalDialog("temptitleDialog","更新标题","500","610","iframeUpdateTitle",content,updateTitleCallBack,"")
}

//引用框模态框
function updateTitleCallBack(returnValue,arr)
{
	if ((typeof(returnValue) != "undefined")&&(returnValue.titleCode != "")&&(titleCode == returnValue.titleCode))
	{
		updateTitleInfo(param.id,titleCode,returnValue.titlePrefix,returnValue.titleName,returnValue.dateTime,returnValue.doctorID,returnValue.eventID,returnValue.eventType);
		if (returnValue.isRefresh == "1")
		{
			var instanceID = getDocumentContext().InstanceID; 						
			refreshReferenceData(instanceID,"true");
		}
	}
}

//更新病程标题信息
function updateTitleInfo(instanceID,titleCode,titlePrefix,titleName,titleDateTime,doctorID,eventID,eventType)
{
	var argJson = {action:"UPDATE_TITLEINFO",args:{"InstanceID":instanceID,"TitleCode":titleCode,"TitlePrefix":titlePrefix,"TitleName":titleName,"TitleDateTime":titleDateTime,"DoctorID":doctorID,"EventID":eventID,"EventType":eventType}}
	cmdDoExecute(argJson);
}

function getImageZoomRatio(userId)
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
			"Method":"GetDoctorSignImageRatio",
			"p1":userId
		},
		success : function(d) {
			result = [eval("("+d+")")];
			result = result[0].ip;
		},
		error : function(d) { alert("getImageZoomRatio error");}
	});
	return result;
}

//获取病历是否加载完
function getFinishLoadDocument()
{
	var argJson = {action:"GET_FINISH_LOADDOCUMENT_STATE",args:{"InstanceID":param.id}};
	return cmdSyncExecute(argJson);
}

//获取当前病历是否可切换或编辑器销毁状态
function getBreakState()
{
	var argJson = {action:"GET_BREAKCHAGE_STATE",args:{"InstanceID":""}};
	return cmdSyncExecute(argJson);
}

//没有返回值的模态框
function showDialogNoReturn(dialogId,title,width,height,content)
{
	//新建div在ip.main
	var div = document.createElement('div');
	div.id = dialogId;
	if(parent.document.getElementById(dialogId)==undefined){
		var bo = parent.document.body; //获取body对象.(ip.main)
		bo.insertBefore(div, bo.lastChild);
	}
	//模态框
	parent.$HUI.dialog('#'+dialogId,{  
	    title: title,  
	    width: width,  
	    height: height,
	    content: content,  
	    closed: true,  
	    cache: false, 
	    isTopZindex:true, 
	    modal: true,
	    onClose:function(){
			parent.$HUI.dialog('#'+dialogId).destroy();
		}
	});
	parent.$HUI.dialog('#'+dialogId).open();
}

//判定当前多文档是否有action对应的操作权限
function getDocumentsPrivilege(instanceIDs,action)
{
	var instanceIDStr = ""
	var result=[];
	if(instanceIDs=="")
	{
		return false;
	}
	else
	{
		var items = instanceIDs.items;
		for(var i=0;i<instanceIDs.items.length;i++)
		{
			var tmpInstanceID = instanceIDs.items[i].InstanceID

			var tmpDocumentContext =getDocumentContext(tmpInstanceID);
			if ((action="Print")&&(tmpDocumentContext.privelege.canPrint==0))
			{
				result.push("【"+tmpDocumentContext.Title.NewDisplayName+"】")
				
			}
		}
		
	}
	if (result.length>0)
	{
		var unprintMsg = emrTrans("因")+result.join(",")+emrTrans("，无打印权限，本次打印操作取消");
		setMessage(unprintMsg,'forbid');
		
		return false;
	}
	else
	{
		return true;	
	}
}
//ctrl+K 快捷键事件
function eventRequestKnowledgeBase(commandJson){
	cdssParam(param,"Save");
}
//查看知识库
function eventSearchCdssBase(commandJson){
	if(commandJson.args.Value!=""){
		cdssParam(commandJson.args.Value);
	}
}
//调用第三方CDSS
function cdssParam(tempParam,type){
	//修改为走基础平台对接方案
	var tool = typeof cdsstool != "undefined" ? cdsstool : parent.cdsstool;
	if (typeof tool != "undefined" )
	{
		tool.getData(tempParam,type)
	}
}

//标红定位元素(异步)
function markRequiredObjectsElement(items)
{
	var argJson = {"action":"MARK_REQUIRED_OBJECTS","args":{"Mark":"True","Items":items}};
	cmdDoExecute(argJson);
}

//提供给质控标红定位的接口方法(入参路径以^分隔)
function qualityMarkRequiredObjects(paths)
{
	if (paths == "") {return;}
	
	var items = "["
	var strs = paths.split("^"); 
	for (i=0;i<strs.length;i++ )
	{
		if (strs[i] != "")
		{
			if (items != "[") {items = items + ",";}
			items = items + "{'Path':'";
			items = items + strs[i];
			items = items + "'}";
		}	
	} 	
	items = items + "]";
	if (items == "[]") {return;}
	var result = eval("("+items+")");
	markRequiredObjectsElement(result);
}

//按条目加载病程时修改病程记录标题时间
function eventModifyTitleTime(commandJson)
{
    param.id = commandJson["args"]["InstanceID"];
    saveDocument("sync");
}

//同步保存文档
function cmdSyncSaveDocument()
{
    var pOperateDate = "";
    var pOperateTime = "";
    var documentContext = getDocumentContext("");
    if ((typeof(documentContext.status.POperateDate)!="undefined")&&(typeof(documentContext.status.POperateTime)!="undefined"))
    {
        pOperateDate = documentContext.status.POperateDate;
        pOperateTime = documentContext.status.POperateTime;
    }
    var argJson = {"action":"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT","LastOperateDate":pOperateDate,"LastOperateTime":pOperateTime}}};
    setSyncSaveDocument(cmdSyncExecute(argJson));
    setSysMenuDoingSth("");
}

//同步保存病历监听
function setSyncSaveDocument(commandJson)
{
    if (commandJson["result"] == "OK")
    {
        var documentContext = getDocumentContext(param.id);
        if (documentContext.result == "ERROR")
        {
            setMessage('获取文档信息失败','alert');
            return;
        }
        //设置当前文档操作权限
        setPrivelege(documentContext);
        //当前文档状态
        setStatus(documentContext);
		//修改文档目录
		modifyQuicknav(documentContext);
        setMessage('数据同步保存成功!','alert');
		//刷新菜单
        reloadMenu(documentContext.InstanceID);
        
        //启用病历信息订阅与发布
        if (Observer == "Y") GetObserverData();

        //质控
        qualitySaveDocument();
        if (typeof (param.args) != "undefined" && typeof (param.args.event) !="undefined" && param.args.event != "")
        {
            getEvent();
        }	
        //保存调用CDSS		
        cdssParam(param,"Save");
        //保存日志(基础平台组)
        setOperationLog(param,"EMR.Save");
        
        reloadAllRecord();
    }else{
        setMessage('文档同步保存失败','warning');
    }
}

//加载全部病程
function reloadAllRecord()
{
    var tempParam = param;
    //判断上一个文档是后加载完成
    if (loadFalg) return;
    clearDocument();
    if (!wordDoc(tempParam)) return;
    setWorkEnvironment(tempParam); 
    setPatientInfo();
    loadFalg = true;
    param = tempParam;
    //加载文档
    var argJson = {"action":"LOAD_DOCUMENT","args":{"params":{"status":"NORMAL"},"InstanceID":tempParam["id"],"actionType":"LOAD"}};
    cmdDoExecute(argJson);
}

//按条目加载病程，滚动病历滚动轴，请求病历追加事件
function eventRequestDoc(commandJson)
{
    //判断上一个文档是后加载完成
    if (loadFalg ) return;
    loadFalg = true;
    var loadDocMode = commandJson["args"]["LoadDocMode"];
    var loadDirection = commandJson["args"]["LoadDirection"];
    var batchMode = commandJson["args"]["BatchMode"];
    var instanceID = commandJson["args"]["InstanceID"];
    var argJson = {"action":"LOAD_DOCUMENT","args":{"params":{"status":"NORMAL","LoadDocMode":loadDocMode,"LoadDirection":loadDirection,"BatchMode":batchMode},"InstanceID":instanceID,"actionType":"LOAD"}};
    var rtn = cmdSyncExecute(argJson);
    loadFalg = false;
    if (rtn["result"] == "OK")
    {
        if (loadDirection == "DOWN")
        {
            var tempParam = getLastInstanceData(getLastInstanceID().InstanceID);
            if (tempParam != "")
            {
                //设置引导框
                var isMutex = (tempParam["isMutex"]=="1")?true:false;
                var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
                if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
            }
        }
    }else{
        setMessage('文档同步追加失败','warning');
    }
}

//校验当前病历加载模式，true是分段加载，false不是分段加载
function checkLoadDocMode(){
    var flag = false;
    //退出加载方式校验
    if (pluginType == "DOC")
    {
        if ((loadDocMode.TitleCode != "")||(loadDocMode.RecordConfig != ""))
        {
            var argJson = {action:"GET_BATCH_LOAD_MODE",args:""};
            var commandJson = cmdSyncExecute(argJson);
            if (commandJson["result"] == "OK")
            {
                // IsBatchLoadMode:病程加载模式，true是分段加载，false不是分段加载
                if (commandJson["IsBatchLoadMode"])
                {
                    flag = true;
                }
            }else {
                 setMessage('当前病历加载模式校验失败','warning');
            }
        }
    }
    return flag;
}
/*根据实例ID获取实例详细信息*/
function GetRecodeParamByInsID(insID) {
      var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.Ajax.opInterface",
					"Method":"GetRecodeParamByInsID",			
					"p1":insID
				},
			success : function(d) {
	           		result =eval("("+d+")");
			},
			error : function(d) { alert("GetRecodeParamByInsID error");}
		});	
	return result;
}

//发送文档修改事件{"action":"eventDocModify","args":｛" Modified ":"True/ False"}} Modified：True 文档处于修改状态，False 文档不是修改状态。
function eventDocModify(commandJson)
{
	if (commandJson["args"]["Modified"] == "True")
	{
		//文档进入编辑状态，给平台发消息
        setSysMenuDoingSth(emrTrans('病历正在编辑，是否保存？'));
		//设置保存的回调函数供平台调用
        setDoingSthSureCallback(true);
	}
	else
	{
		//无正在编辑的病历，清空状态
		setSysMenuDoingSth("");
        setDoingSthSureCallback(false);
	}
}

function eventDocModifyFront(status)
{
	if (status == "True")
	{
		//文档进入编辑状态，给平台发消息
        setSysMenuDoingSth(emrTrans('病历正在编辑，是否保存？'));
		//设置保存的回调函数供平台调用
        setDoingSthSureCallback(true);
	}
	else
	{
		//无正在编辑的病历，清空状态
		setSysMenuDoingSth("");
        setDoingSthSureCallback(false);
	}
}
//插入科室短语
function appendDPComposite(DPNodeID)
{
    var argJson = {action:"APPEND_COMPOSITE_ADVANCED",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":DPNodeID,"Type":"DP"}}};
    cmdDoExecute(argJson);
}

function setPrintInfo(flag)
{
	if (flag == "true")
	{
		parentWin.$.messager.progress({
			title: "提示",
			msg: '正在打印病历',
			text: '打印中....'
		});
	}
	else
	{
		parentWin.$.messager.progress("close");
	}
}


//病历信息
function GetRecordInfo(instanceID) {
    var info = '';
    if ('' === instanceID) return '';
	
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.caKeySign.cls",
        async: false,
        cache: false,
        data: {
            func: 'GetRecordInfo',
            InstanceDataID: instanceID
        },
        success: function(ret) {
            if (ret && ret.Err) {
                alert('GetRecordInfo' + ret.Err);
            } else {
                info = ret;
            }
        },
        error: function(err) {
            alert(err.message || err);
        }
    });
    return info;
}

	//病历信息
function canPushSign(instanceID) {
   	
    var result = false;
	
    jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLEMRPushSign",
					"Method":"CanPushSign",			
					"p1":instanceID
				},
			success: function(d) {
					if (d.split("^")[0] == "1"){
						result = true;
					} else if (d.split("^")[0] == "0"){
						alert(d.split("^")[1]);
					} else {
						alert(d);
					}
			},
			error : function(d) { 
				//alert("EMRservice.BL.BLEMRPushSign error");
				alert("0^EMRservice.BL.BLEMRPushSign.CancelPushSign服务异常\r\n" + d);
			}
		});	
		
	return result;	
}

//取消推送签名
function cancelPushSign()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLEMRPushSign",
					"Method":"CancelEMRPushSign",			
					"p1":param.id,
					"p2":userID
				},
			success: function(d) {
					if (d.split("^")[0] == "1"){
						setMessage(d.split("^")[1],'forbid');
					} else if (d.split("^")[0] == "0") {
						setMessage(d.split("^")[1],'forbid');
					} else {
						alert(d);
					}
			},
			error : function(d) { 
				alert("EMRservice.BL.BLEMRPushSign error");
				result = "0^EMRservice.BL.BLEMRPushSign.CancelPushSign服务异常\r\n" + d;
			}
		});		
}

//医生端CA签名：获取推送签名结果
function fetchPushSignResult()
{
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLEMRPushSign",
					"Method":"FetchSignResult",			
					"p1":param.id,
					"p2":userID
				},
			success: function(d) {
					if (d.split("^")[0] == "1"){
						setMessage(d.split("^")[1],'forbid');
					} else if ((d.split("^")[0] == "0")||(d.split("^")[0] == "-1")) {
						setMessage(d.split("^")[1],'forbid');
					} else {
						alert(d);
					}
			},
			error : function(d) { 
				alert("EMRservice.BL.BLEMRPushSign error");
				result = "0^EMRservice.BL.BLEMRPushSign.FetchSignResult服务异常\r\n" + d;
			}
		});		
}

///Desc:[取消pdf送签/获取签名后的PDF]操作后，编辑器需要由显示xml数据变为PDF数据或者由显示PDF数据变为显示xml数据，编辑器重新加载病历
function reLoadDocument(instanceId, pdfDocType) {
	pdfDocType = pdfDocType || "XML";
	
	if (instanceId == "") 
	{
		instanceId = getDocumentContext().InstanceID;	
		if (instanceId == "") return;
	}
	
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetParamByInstanceID",
			"p1":instanceId
		},
		success: function(d) {
			if (pdfDocType != d.pdfDocType) {
				d.actionType = "LOAD";
				d.reLoad = 1;
				InitDocument(d);
				modifyInstanceMenuPDF(instanceId, d.pdfDocType);
			}
		},
		error: function(d) { 
			alert("getInstnaceparam error");
		}
	});
}

function modifyInstanceMenuPDF(instanceId, pdfDocType) {
	reloadMenu(instanceId);
}

/// 是否可以做患者端PDF签名
function canDoPDFSign(episodeID, instanceID) {
	 var canDo = false;
	
	 var argsData = {
            Action: 'CanDoPDFSign',
            episodeId: episodeID,
            instanceId: instanceID
        };
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: argsData,
            success: function (ret) {
	            if (ret == "1") {
	          		canDo = true;
	            } else {
		            //alert(ret);
			    setMessage(ret.split("^")[1],'alert');
	            }
            },
            error: function (err) {
                throw { message : 'CanDoPDFSign error:' + err };
            }
        });
        
     return canDo;
}

/// 获取可以续签的PDF数据
function getSignedPDF(episodeID, instanceID) {
	 var tpdfBase64 = "";
	
	 var argsData = {
            Action: 'getPDFBase64',
            episodeId: episodeID,
            instanceId: instanceID
        };
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: argsData,
            success: function (ret) {
	          	tpdfBase64 = ret
            },
            error: function (err) {
                throw { message : 'getPDFBase64 error:' + err };
            }
        });
        
        return tpdfBase64;
}

/// 获取患者签名关键字
function getPatSignKeyWord(insId, updateFlag) {
	var allKeyWord = '';
	updateFlag = updateFlag || false;
	
	var tname = "";
	var argsData = {
		Action: 'GetBatchSignInfo',
		//patientID: patientID,
		//episodeID: episodeID,
		instanceId: insId
	};
	$.ajax({
		type: 'POST',
		dataType: 'text',
		url: '../EMRservice.Ajax.anySign.cls',
		async: false,
		cache: false,
		data: argsData,
		success: function (ret) {
			//ret = $.parseJSON(ret);
			ret = eval("("+ret+")")
			if(ret.MIString.length) {
				for(var i=0;i<ret.MIString.length;i++) {
					//更新编辑器示例数据
					if (updateFlag) {
						tname = "(" + ret.MIString[i].displayName+')';
						updateInstanceData("Replace","",ret.MIString[i].path,tname);
						if (allKeyWord == "")
						{	allKeyWord = tname; }
						else
						{	allKeyWord = allKeyWord + "," + tname; }
					} else {
						tname = "[" + ret.MIString[i].displayName+']';
						if (allKeyWord == "")
						{	allKeyWord = tname; }
						else
						{	allKeyWord = allKeyWord + "," + tname; }
					}
				}
				if (updateFlag) {
					cmdsaveDocument();
				}
			}
		}
	});
	
	return allKeyWord;
}

/// 生成待签名PDF
function createToSignPDFBase64(insId, isCleanAllItem) {
	 if ((typeof(ca_pdfcreator) == 'undefined')||(ca_pdfcreator == '')) {
		alert("虚拟打印机对象ca_pdfcreator不存在！");
		return "";
	 }
	 
	 isCleanAllItem = isCleanAllItem || false;
	 var argJson = {"action":"PRINT_DOCUMENT", "args":{"actionType":"PrintDirectly","InstanceID":insId,"IsSavePrintLog":"false","IsCleanAll":"False","SignLevel":[{"Level":"patient"}]}};
	 if (isCleanAllItem) {
		 argJson = {"action":"PRINT_DOCUMENT", "args":{"actionType":"PrintDirectly","InstanceID":insId,"IsSavePrintLog":"false"}};
	 }
	 return ca_pdfcreator.genPDFBase64("","",function(){
				cmdDoExecute(argJson);	
	 });
}

/// 患者端CA签名: 患者签名二维码
function getPatPushSignQR() {
	
	var documentContext = getDocumentContext("");
	if ((!documentContext)||(!documentContext.InstanceID)) {
		alert("请选择病历");
	}
	var instid = documentContext.InstanceID;
	
	var argsData = {
            Action: 'getPatPushSignID',
            InstanceID: instid
        };
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: argsData,
            success: function (ret) {
	            if (ret.split("^")[0] == "1") {
		            var patPushSignID = ret.split("^")[1];
		            if (patPushSignID == "") {
		            	setMessage("没有已推送的待签PDF文档",'forbid');
		            } else {
	            		window.showModalDialog("../csp/dhc.certauth.patsign.tosignqr.csp?EpisodeID="+episodeID+"&PatPushSignID="+patPushSignID,"","dialogWidth:450px;dialogHeight:450px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
		            }
	            } else {
		            alert(ret);
	            }
            },
            error: function (err) {
                throw { message : 'getPatPushSignID error:' + err };
            }
        });
	
	
}

/// 患者端CA签名: 取消患者签名（停用，使用患者重签代替）
function cancelPatPushSign() {
	//alert("取消患者推送签名测试");
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLPDFAuditSignLog",
					"Method":"CancelPatPushSign",			
					"p1":param.id,
					"p2":userID
				},
			success: function(d) {
					if (d.split("^")[0] == "1"){
						setMessage(d.split("^")[1],'forbid');
					} else if (d.split("^")[0] == "0") {
						setMessage(d.split("^")[1],'forbid');
					} else {
						alert(d);
					}
			},
			error : function(d) { 
				alert("EMRservice.BL.BLEMRPushSign error");
				result = "0^EMRservice.BL.BLEMRPushSign.CancelPushSign服务异常\r\n" + d;
			}
		});		
}

/// 患者端CA签名: 获取推送签名结果
function fetchPatPushSignResult() {
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLPDFAuditSignLog",
					"Method":"FetchSignResult",			
					"p1":param.id,
					"p2":userID
				},
			success: function(d) {
					if (d.split("^")[0] == "1"){
						reLoadDocument(param.id,param.pdfDocType);
						setMessage(d.split("^")[1],'forbid');
					} else if ((d.split("^")[0] == "0")) {
						reLoadDocument(param.id,param.pdfDocType);
						setMessage(d.split("^")[1],'forbid');
					} else {
						alert(d);
					}
			},
			error : function(d) { 
				alert("EMRservice.BL.BLPDFAuditSignLog.FetchSignResult error");
				result = "0^EMRservice.BL.BLPDFAuditSignLog.FetchSignResult 服务异常\r\n" + d;
			}
		});		
}

/// 患者端CA签名: 患者重签
function invalidPatSignedPDF() {
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLPDFAuditSignLog",
					"Method":"InvalidSignedPDF",			
					"p1":param.id,
					"p2":userID,
                    "p3":ipAddress
				},
			success: function(d) {
					if (d.split("^")[0] == "1"){
						reLoadDocument(param.id,param.pdfDocType);
						setMessage(d.split("^")[1],'forbid');
					} else if (d.split("^")[0] == "0") {
						reLoadDocument(param.id,param.pdfDocType);
						setMessage(d.split("^")[1],'forbid');
					} else {
						alert(d);
					}
			},
			error : function(d) { 
				alert("EMRservice.BL.BLPDFAuditSignLog error");
				result = "0^EMRservice.BL.BLPDFAuditSignLog.InvalidSignedPDF服务异常\r\n" + d;
			}
		});		
}
// 修改文档目录
function modifyQuicknav(documentContext)
{
	if(showNav == "Y")
    {
	   modifyInstanceTree(documentContext); 
	}
}

function verifySigned()
{
	var documentContext = getDocumentContext("");
	if ((!documentContext)||(!documentContext.InstanceID)) {
		alert("请选择病历");
        return;
	}
	var instid = documentContext.InstanceID;
    
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"VerifySignedData",
			"p1":instid
		},
		success: function(ret) {
			var flag = ret.split('^')[0];
            var result = ret.split('^')[1];
            if (flag == "1")
            {
	            setMessage(result,'alert');
            }
            else
            {
	            setMessage(result,'forbid');
	        }			
		},
		error : function(d) { alert("VerifySignedData Error");}
	});
}

//按业务类型刷新绑定数据
function reloadBusinessTypeBinddata(businessType,instanceID,autoRefresh,syncDialogVisible,silentRefresh)
{
	var strJson = { "action": "REFRESH_REFERENCEDATA", "args": {"BusinessType":businessType,"InstanceID":instanceID, "InterfaceStyle":"","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible,"SilentRefresh":silentRefresh,"DisplayNullValueItem":"false"} }
	cmdDoExecute(strJson);
}

function openResourceTab()
{
	var options = {border:false,split:true,id:'resRegion',region:'east'};
	options.width=400;
	$('#newMain').layout('add', options);
	$("#resRegion").append('<iframe id="framResource" src="" frameborder="0" style="width:100%; height:100%;margin:0;padding:0;overflow:hidden"></iframe>')
	initResource();
	resource = document.getElementById("framResource").contentWindow;
}


//获取签名摘要和签名单元路径
function GetSigneData(insID)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.BLEMRSign",
					"Method":"GetSignDigestDatas",
					"p1":insID
				},
			success : function(d) {
	           	if (d != "") result = jQuery.parseJSON(d);
			},
			error : function(d) { alert("GetSignDigestDatas error");}
		});	
	return result;
}

//设置签名摘要和签名单元路径
function SetSignDigest(signDatas)
{
	var argJson = {action:"SET_SIGNED_DIGEST_AND_PATH",args:{"Items": [signDatas]}};
	return cmdSyncExecute(argJson);
}


//Word定位文本位置(异步)
function findTextNextPosition(arginfo)
{
	var argJson = {"action":"SET_QC_POSITION","args":arginfo}
	cmdDoExecute(argJson);
}

//提供给质控定位文本位置接口方法(入参文本信息以^分隔（实例id^章节code^文本内容)
function qualityTextFindNext(textdata)
{
	if (textdata == "") {return;}
	
	
	var arr = textdata.split("^"); 
	if (arr.length != 3) 
	{
		return;
	}
	
	var textInfo = "{"
	textInfo = textInfo+"'InstanceID':'"+arr[0]+"',"
	textInfo = textInfo+"'SectionCode':'"+arr[1]+"',"
	textInfo = textInfo+"'QcText':'"+arr[2]+"'"
		
	textInfo = textInfo + "}";
	textArg = eval("("+textInfo+")");
	findTextNextPosition(textArg);
}