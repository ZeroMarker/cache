var g_objParam = {};
var g_tmpParam ={};
var g_loadFlag = false;
//初始化页面
function InitDocument(tempParam)
{
	g_tmpParam = tempParam;  
	//判断上一个文档是后加载完成
	if (g_loadFlag ) return;
	//解锁,保存提醒
	if (g_objParam.length >0)
	{	
		if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
		{         
			unLock(lockinfo.LockID);                        //解锁
		}
	}

	if ((g_objParam.status != tempParam.status)||(tempParam.status == "DELETE"))
	{
		g_objParam = {};
	}
    
	if (tempParam.actionType=="LOAD")
	{
		if (!doOpen(tempParam)) return; 
		
	}
	else
	{
		if (!doCreate(tempParam)) return; 	
	}
	var strParam = JSON.stringify(tempParam);
	param = JSON.parse(strParam);
	
}

///打开文档
function doOpen(tempParam)
{
	var result = true;
	pluginType = tempParam["pluginType"];        	
	if (pluginType == "DOC")
	{
		if (!wordDoc(tempParam,pluginUrl,setDefaultFontStyle)) return false;
	}
	else if (pluginType == "GRID")
	{
		if (!girdDoc(tempParam,pluginUrl)) return false;
	}
	else
	{
		top.$.messager.alert("提示信息", "插件创建失败!", 'info');
		return false;
	}
	if ((g_objParam.length > 0)&&(g_objParam.emrDocId == tempParam.emrDocId) && ((g_objParam.characteristic != "0") || (g_objParam.id == tempParam.id)))
	{
		cmdFocusDocument(tempParam.id,"","Last");
	}
	else
	{
		loadDocument(tempParam); 
	}
	return result;
}

//加载文档
function loadDocument(tempParam)
{
	if (tempParam.pluginType == "DOC") cmdSetWorkEnvironment(tempParam); 
	cmdSetPatientInfo(pInfo);	                          
	if (g_objParam.emrDocId != tempParam.emrDocId) g_loadFlag = true;
	var status = tempParam["status"];
	//加载文档
	cmdLoadDocument(tempParam["id"],status,tempParam["actionType"]);	
	if (status == "DELETE")
	{
		cmdSetReadOnly(true,[tempParam["id"]]);
	}
	else
	{
		//设置引导框
		var isMutex = (tempParam["isMutex"]=="1")?true:false;
		var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
		if(!privilege.getCreatePrivilege(tempParam,false,pInfo)) cmdSetDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
	} 
}


//文档加载成功事件
function eventLoadDocument(commandJson)
{
	g_loadFlag = false;
	g_objParam =  g_tmpParam;
	cmdSetReadOnly("",true);
}

//将是否显示绑定数据提示框状态存入表中
function eventRefreshReferenceData(commandJson)
{
}

//判断知识库是否替换成功
function eventReplaceView(commandJson)
{
}

//文档导出
function eventSaveLocalDocument(commandJson)
{
}

//文档改变事件
function eventDocumentChanged(commandJson)
{
}

//章节改变事件
function eventSectionChanged(commandJson)
{
}
//保存事件监听
function eventSaveDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
	    if (commandJson["args"]["params"]["result"] == "OK")
	    { 
			//取文档信息
			p_objParam.id = commandJson["args"]["params"]["InstanceID"];
			var documentContext = cmdGetDocumentContext(p_objParam.id);
			if (documentContext.result == "ERROR") return;		    			
			top.$.messager.alert("提示信息", "数据保存成功!", 'info');
			//质控
			qualitySaveDocument();
	   		//保存日志(基础平台组)
			setOperationLog(p_objParam,"EMR.Save");
	    }
	}
	else if (commandJson["args"]["result"] == "ERROR")
	{
		if (commandJson["args"]["params"]["status"] == "0")
	    {
		    top.$.messager.alert("提示信息", "病历已存在!", 'info');
		}
		else
		{
	    	top.$.messager.alert("提示信息", "保存失败!", 'info');
	    }
	}
	else if (commandJson["args"]["result"] == "INVALID")
    {
	    top.$.messager.alert("提示信息", "病历存在非法字符，不能保存", 'info');
	     
    }
	else if (commandJson["args"]["result"] != "NONE")
	{
		top.$.messager.alert("提示信息", "文档没有发生改变!", 'info');
	}
}
//创建文档事件
function eventCreateDocument(commandJson)
{
}

//文档签名事件
function eventSaveSignedDocument(commandJson)
{
	if ((commandJson["args"]["result"] == "OK")&&(commandJson["args"]["params"]["result"] == "OK")) 
	{
		//取文档信息
		var documentContext = cmdGetDocumentContext(commandJson["args"]["params"]["InstanceID"]);
		top.$.messager.alert("提示信息", "数据签名成功!", 'info');
		
		//基础平台组审计和日志记录
		setOperationLog(g_objParam,"EMR.Sign.OK");
    }
	else
	{
		top.$.messager.alert("提示信息", "签名失败或级别不符!", 'info');
		cmdUnsignDocument();
	}
}

//删除文档
function eventDeleteDocument(commandJson)
{
}

//设置字体样式
function eventCaretContext(commandJson)
{
}

function eventSave(commandJson)
{
}


///签名
function eventRequestSign(commandJson)
{
	 if (cmdGetModifyStatus().Modified == "True")
	 {
		top.$.messager.alert("提示信息", "病历被修改过,不可以签名!", 'info');
		return;
     }
	 var signProperty = commandJson.args;
	 audit(signProperty);
}

///检查必填项
function checkRequiredCell()
{
	var result =  false;
	if((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
	{
		//脚本检查
		var resultMarkRequired = cmdMarkRequiredObject();
		if (resultMarkRequired.MarkCount>0) result = true;
	}
	return result;
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

//签名质控
function qualitySignDocument()
{
	var result = false;
	result = checkRequiredCell();
	if (result == true) 
	{
		top.$.messager.alert("提示信息", "有未完成项目不能签名,请处理!", 'info');
		return result;
	}
	var ssgroupID = pInfo.ssgroupID;
	var userLocID = pInfo.userLocID;	
	var eventType = "Commit^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(pInfo.episodeID,g_objParam.id,g_objParam.templateId,eventType)
	
	var total = +qualityData.total;
	if (total > 0)
	{
		//alert(strQualityData);
		var controlType = qualityData.controlType;
		var url="dhc.emr.quality.runtimequalitylist.csp?EpisodeID="+pInfo.episodeID+"&EventType="+eventType+"&TemplateID="+param.templateId+"&key="+qualityData.key
		window.open(url,'quality','width:98%, height:98%,border:0,margin:0px,padding:5px,overflow:hidden;'); 
		if (total > 0&&controlType == "0") 
		{
			result = true;
			return result;
		}
	}
	
	return result;	
}

// 打开签名窗口
function audit(signProperty)
{
	var qualityResult = qualitySignDocument();
	if (qualityResult) return; 
	var documentContext = cmdGetDocumentContext("");
    var canRevokCheck = documentContext.privelege.canRevokCheck;
    if (pluginType != "GRID") canRevokCheck =0;
    var tmpInstanceId = signProperty.InstanceID;
    if (typeof(tmpInstanceId) == "undefined") tmpInstanceId = documentContext.InstanceID;
    var openFlag = pInfo.episodeType=="O"?"0":"1";
   	if (signProperty.OriSignatureLevel.toUpperCase() == 'PATIENT') 
   	{
		var argEditor = {
			instanceId: tmpInstanceId,
			signDocument: cmdSignDocument,
			saveSignedDocument: cmdSaveSignDocument
		};
		handSign.sign(argEditor);
		return;
	}
	if ('1' == CAServicvice) 
	{
		if (CAVersion == "2")
		{
			var ca_key = parent.window.ca_key;
            if ((ca_key.SignType == "UKEY")||(ca_key.SignType == "FACE")){
                var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name,"oriSignatureLevel":signProperty.OriSignatureLevel};
				var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
				var usernameStr = base64encode(utf16to8(encodeURI(pInfo.userName)))
				var iframeContent = "<iframe id='iframeSignCA' scrolling='auto' frameborder='0' src='emr.ip.signca.csp?UserName="+usernameStr+"&UserID="+pInfo.userID+"&OpenFlag="+pInfo.openFlag+"&UserLocID="+pInfo.userLocID+"&EpisodeID="+pInfo.episodeID+"&SignParamStr="+signParamStr+"&openWay=sign"+"&MWToken="+getMWToken()+"' style='width:355px; height:230px; display:block;overflow:hidden;'></iframe>"
				var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
				createModalDialog("CASignDialog","CA签名","360","285","iframeSignCA",iframeContent,signCACallBack,arr)
	        } else {
                var src = "emr.ip.signca.phone.csp?episodeID="+pInfo.episodeID+"&canRevokCheck="+canRevokCheck+"&oriSignatureLevel="+signProperty.OriSignatureLevel+"&venderCode="+ca_key.VenderCode+"&signType="+ca_key.SignType+"&product=EMR&cellName="+base64encode(utf16to8(encodeURI(signProperty.Name)))+"&MWToken="+getMWToken();
				var iframeContent = "<iframe id='iframeLoginQrcode' scrolling='no' frameborder='0' src='"+src+"' style='width:749px; height:712px; display:block;overflow:hidden;'></iframe>"
				var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
				createModalDialog("loginQrcode","CA签名","750","750","iframeLoginQrcode",iframeContent,signCACallBack,arr)
	        }
		}
		else
		{
            var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name,"oriSignatureLevel":signProperty.OriSignatureLevel};
			var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
			var usernameStr = base64encode(utf16to8(encodeURI(pInfo.userName)))
			var iframeContent = "<iframe id='iframeSignCA' scrolling='auto' frameborder='0' src='emr.ip.signca.csp?UserName="+usernameStr+"&UserID="+pInfo.userID+"&OpenFlag="+pInfo.openFlag+"&UserLocID="+pInfo.userLocID+"&EpisodeID="+pInfo.episodeID+"&SignParamStr="+signParamStr+"&openWay=sign"+"&MWToken="+getMWToken()+"' style='width:355px; height:230px; display:block;overflow:hidden;'></iframe>"
			var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
			createModalDialog("CASignDialog","CA签名","360","285","iframeSignCA",iframeContent,signCACallBack,arr)
		}
	}
	else
	{
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name,"oriSignatureLevel":signProperty.OriSignatureLevel};
		var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
		var usernameStr = base64encode(utf16to8(encodeURI(pInfo.userName)))
		
		var iframeContent = "<iframe id='iframeSign' scrolling='auto' frameborder='0' src='emr.ip.sign.csp?UserName="+usernameStr+"&UserCode="+pInfo.userCode+"&OpenFlag="+pInfo.openFlag+"&UserLocID="+pInfo.userLocID+"&EpisodeID="+pInfo.episodeID+"&SignParamStr="+signParamStr+"&openWay=sign"+"&MWToken="+getMWToken()+"' style='width:360px; height:245px; display:block;overflow:hidden;'></iframe>"
		var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId,"documentContext":documentContext}
		createModalDialog("SignDialog","系统签名","385","285","iframeSign",iframeContent,signCallBack,arr)
	}
}

function caSignContent(returnValues,signProperty,tmpInstanceId,certObj)
{
	if ((returnValues == "") || (returnValues == undefined)) return;
	
	var returnValues = eval("("+returnValues+")");
	userInfo = returnValues.userInfo;
	if ((userInfo.UserLevel == "")&&(userInfo.UserPos == "")&&(signProperty.OriSignatureLevel !== "All"))
	{
		top.$.messager.alert("提示信息", "请先维护用户级别!", 'info');
		return;	
	}
	if (returnValues.action == "sign")
	{
		if (userInfo.Type == "Graph" && userInfo.Image == "")
		{
            top.$.messager.alert("提示信息", "签名图片未维护，请维护!", 'info');
			return;
		}
		if (CAVersion == "2")
		{
            var ca_key = parent.window.ca_key;
            if ((ca_key.SignType == "UKEY")||(ca_key.SignType == "FACE")){
                caSign(signProperty,userInfo,tmpInstanceId);
            }else{
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
			top.$.messager.alert("提示信息", "非本人签名,不能撤销!", 'info');
			return;
		}
		var ret = revokeSignElement(signProperty);
		if (ret.result == "OK")
		{
			top.$.messager.alert("提示信息", "撤销成功!", 'info');
		}
		else
		{
			top.$.messager.alert("提示信息", "撤销失败!", 'info');
		}
	}	
}

function signCallBack(returnValue,arr)
{
	var returnValues = returnValue;
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
	
	if (returnValues !== undefined && returnValues != "")
	{
		returnValues = eval("("+returnValues+")");
		userInfo = returnValues.userInfo;	
		if ((userInfo.UserLevel == "")&&(userInfo.UserPos == "")&&(userInfo.characterCode == ""))
		{
			top.$.messager.alert("提示信息", "请先维护用户级别!", 'info');
			return;	
		}		
		if (returnValues.action == "sign")
		{
			if (userInfo.Type == "Graph" && userInfo.Image == "")
			{
				top.$.messager.alert("提示信息", "签名图片未维护，请维护!", 'info');
				return;
			}
				checkSign(signProperty,userInfo,tmpInstanceId,documentContext);	
		}
		else if (returnValues.action == "revoke")
		{
			if (userInfo.UserID != signProperty.Id)
			{
				top.$.messager.alert("提示信息", "非本人签名,不能撤销!", 'info');
				return;
			}
			var ret = revokeSignElement(signProperty);
			if (ret.result == "OK")
			{
				top.$.messager.alert("提示信息", "撤销成功!", 'info');
			}
			else
			{
				top.$.messager.alert("提示信息", "撤销失败!", 'info');
			}
		}	
   	} 
	    	
	
}

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

	var returnValues = returnValue
	if (returnValues != "" && returnValues != undefined)
	{
		returnValues = eval("("+returnValues+")");
		userInfo = returnValues.userInfo;
		if ((userInfo.UserLevel == "")&&(userInfo.UserPos == "")&&(userInfo.characterCode == ""))
		{
			top.$.messager.alert("提示信息", "请先维护用户级别!", 'info');
			return;	
		}
		if (returnValues.action == "sign")
		{
			if (userInfo.Type == "Graph" && userInfo.Image == "")
			{
				top.$.messager.alert("提示信息", "签名图片未维护，请维护!", 'info');
				return;
			}	
            if (CAVersion == "2")
            {
                var ca_key = parent.window.ca_key;
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
				top.$.messager.alert("提示信息", "非本人签名,不能撤销!", 'info');
				return;
			}
			var ret = cmdRevokeSignElement(signProperty);
			if (ret.result == "OK")
			{
				top.$.messager.alert("提示信息", "撤销成功!", 'info');
			}
			else
			{
				top.$.messager.alert("提示信息", "撤销失败!", 'info');
			}
		}	
	} 		
}

//数字签名
function caSignMobile(signProperty,userInfo,instanceId,certObj)
{
	//权限检查
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;

	//开始签名
	var cert = parent.GetSignCert(certObj.certContainer);
    var UsrCertCode = parent.GetUniqueID(cert,certObj.certContainer);
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
	var signInfo = cmdSignDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,CTPCPDesc,"","");

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    top.$.messager.alert("签名提示", "签名原文为空！",'info');
	    return ;
	}
    
    //获取病历信息传给CA展示
    var recordInfo = GetRecordInfo(instanceId);
	if (recordInfo != "") {
		recordInfo = JSON.stringify({"subject":recordInfo.subject});
	}
    
    var signValue = parent.SignedData(signInfo.Digest,certObj.certContainer,pInfo.episodeID,recordInfo);
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
                cmdUnsignDocument();
				alert(ret.Err);
            } 
            else 
            {
	            cmdSaveSignDocument(instanceId,userInfo.UserID,signlevel,ret.SignID,signInfo.Digest,"CA",signInfo.Path,actionType)
            }
        },
        error: function(ret) {alert(ret);}
    });
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

//数字签名
function caSign(signProperty,userInfo,instanceId)
{
	//权限检查
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;

	//开始签名
	var cert = parent.GetSignCert(parent.strKey);
    var UsrCertCode = parent.GetUniqueID(cert,parent.strKey);
    if (!UsrCertCode || '' == UsrCertCode) return '用户唯一标示为空！';
    
    if (CAVersion == "2")
	{
		var certNo = parent.GetCertNo(parent.strKey);
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
	var signInfo = cmdSignDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,CTPCPDesc,"","");

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    top.$.messager.alert("提示信息", "签名原文为空!", 'info');
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
	            cmdUnsignDocument();
                alert(ret.Err);
            } 
            else 
            {
                cmdSaveSignDocument(instanceId,userInfo.UserID,signlevel,ret.SignID,signInfo.Digest,"CA",signInfo.Path,actionType)
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
	var signlevel = userInfo.characterCode;
	var actionType = checkresult.ationtype;	
	if ((actionType == "Append" && documentContext.privelege.canCheck == 0) || (actionType == "Replace" && documentContext.privelege.canReCheck == 0))
	{
		top.$.messager.alert("提示信息", "没有权限签名!", 'info');
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
	var signInfo = cmdSignDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,CTPCPDesc,"","");
	if (signInfo.result == "OK")
	{
		cmdSaveSignDocument(instanceId,userInfo.UserID,signlevel,"","","SYS",signInfo.Path,actionType);
	}
	else
	{
		top.$.messager.alert("提示信息", "签名失败!", 'info');
	}		
}

//检查签名权限脚本
function checkPrivilege(userInfo,signProperty)
{
	var result = {"flag":false,"ationtype":""};
	
	var UserID = userInfo.UserID;
	var characterCode = userInfo.characterCode;
	var OriSignatureLevel = signProperty.OriSignatureLevel;
	var SignatureLevel = signProperty.SignatureLevel;
	var Id = signProperty.Id;
	var signedLength = signProperty.Authenticator.length;
	
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
			"p4":SignatureLevel,
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
			else if(data != "")
			{
				top.$.messager.alert("提示信息", data, 'info');
			}
			else
			{
				top.$.messager.alert("提示信息", "无权限签名", 'info');
			}
		 }
	});
	
	return result;	
}

//撤销签名
function revokeSignElement(signProperty)
{
	var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel}}}};
	return cmdSyncExecute(argJson);
}
