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
		alert("插件创建失败");
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
			$.messager.alert("提示信息", "数据保存成功!", 'info');
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
		    $.messager.alert("提示信息", "病历已存在!", 'info');
		}
		else
		{
	    	$.messager.alert("提示信息", "保存失败!", 'info');
	    }
	}
	
	else if (commandJson["args"]["result"] == "INVALID")
    {
	    $.messager.alert("提示信息", "病历存在非法字符，不能保存。", 'info');
    }
    
	else if (commandJson["args"]["result"] != "NONE")
	{
		$.messager.alert("提示信息", "文档没有发生改变!", 'info');
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
		$.messager.alert("提示信息", "数据签名成功!", 'info');
		
		//基础平台组审计和日志记录
		setOperationLog(g_objParam,"EMR.Sign.OK");
    }
	else
	{
		$.messager.alert("提示信息", "签名失败或级别不符!", 'info');
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
		$.messager.alert("提示信息", "病历被修改过,不可以签名!", 'info');
		return;
     }
	 var signProperty = commandJson.args;
	 audit(signProperty);
}

///检查必填项
function checkRequiredCell()
{
	var result =  false;
	//脚本检查
	var resultMarkRequired = cmdMarkRequiredObject();
	if (resultMarkRequired.MarkCount>0) result = true;
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

//签名质控
function qualitySignDocument()
{
	var result = false;
	result = checkRequiredCell();
	if (result == true) 
	{
		$.messager.alert("提示信息", "有未完成项目不能签名,请处理!", 'info');
		return result;
	}	
	var eventType = "Commit^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,p_objParam.id,p_objParam.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
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

// 打开签名窗口
function audit(signProperty)
{
	var qualityResult = qualitySignDocument();
	if (qualityResult) return; 
	var documentContext = cmdGetDocumentContext("");
    var canRevokCheck = documentContext.privelege.canRevokCheck;
    if (pluginType != "GRID") canRevokCheck =0;
    var tmpInstanceId = signProperty.InstanceID;
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
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
		var usernameStr = base64encode(utf16to8(encodeURI(pInfo.userName)))
		//showCAsignDialog("CA签名","375","270","<iframe id='iframeSignCA' scrolling='no' frameborder='0' src='emr.ip.signca.csp?UserName="+usernameStr+"&UserID="+pInfo.userID+"&OpenFlag="+pInfo.openFlag+"&UserLocID="+pInfo.userLocID+"&EpisodeID="+pInfo.episodeID+"&SignParamStr="+signParamStr+"&openWay=sign' style='width:355px; height:230px; display:block;overflow:hidden;'></iframe>",signProperty,tmpInstanceId)
		var iframeContent = "<iframe id='iframeSignCA' scrolling='auto' frameborder='0' src='emr.ip.signca.csp?UserName="+usernameStr+"&UserID="+pInfo.userID+"&OpenFlag="+pInfo.openFlag+"&UserLocID="+pInfo.userLocID+"&EpisodeID="+pInfo.episodeID+"&SignParamStr="+signParamStr+"&openWay=sign' style='width:355px; height:230px; display:block;overflow:hidden;'></iframe>"
		var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId}
		createModalDialog("CASignDialog","CA签名","360","285","iframeSignCA",iframeContent,signCACallBack,arr)
		
	}
	else
	{
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var signParamStr = base64encode(utf16to8(escape(JSON.stringify(signParam))));
		var usernameStr = base64encode(utf16to8(encodeURI(pInfo.userName)))
		//var returnValues = window.showModalDialog("emr.ip.sign.csp?UserName="+pInfo.userName+"&UserCode="+pInfo.userCode+"&OpenFlag="+openFlag+"&UserLocID="+pInfo.userLocID,signParam,"dialogHeight:255px;dialogWidth:400px;resizable:yes;status:no");
		//showSignDialog("签名窗口","375","285","<iframe id='iframeSign' scrolling='no' frameborder='0' src='emr.ip.sign.csp?UserName="+usernameStr+"&UserCode="+pInfo.userCode+"&OpenFlag="+pInfo.openFlag+"&UserLocID="+pInfo.userLocID+"&EpisodeID="+pInfo.episodeID+"&SignParamStr="+signParamStr+"&openWay=sign' style='width:355px; height:245px; display:block;overflow:hidden;'></iframe>",signProperty,tmpInstanceId,documentContext);
		
		var iframeContent = "<iframe id='iframeSign' scrolling='auto' frameborder='0' src='emr.ip.sign.csp?UserName="+usernameStr+"&UserCode="+pInfo.userCode+"&OpenFlag="+pInfo.openFlag+"&UserLocID="+pInfo.userLocID+"&EpisodeID="+pInfo.episodeID+"&SignParamStr="+signParamStr+"&openWay=sign' style='width:360px; height:245px; display:block;overflow:hidden;'></iframe>"
		var arr = {"signProperty":signProperty,"tmpInstanceId":tmpInstanceId,"documentContext":documentContext}
		createModalDialog("SignDialog","系统签名","385","285","iframeSign",iframeContent,signCallBack,arr)
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
		if ((userInfo.UserLevel == "")&&(userInfo.UserPos == ""))
		{
			$.messager.alert("提示信息", "请先维护用户级别!", 'info');
			return;	
		}		
		if (returnValues.action == "sign")
		{
			if (userInfo.Type == "Graph" && userInfo.Image == "")
			{
				$.messager.alert("提示信息", "签名图片未维护，请维护!", 'info');
				return;
			}
				checkSign(signProperty,userInfo,tmpInstanceId,documentContext);	
		}
		else if (returnValues.action == "revoke")
		{
			if (userInfo.UserID != signProperty.Id)
			{
				$.messager.alert("提示信息", "非本人签名,不能撤销!", 'info');
				return;
			}
			var ret = revokeSignElement(signProperty);
			if (ret.result == "OK")
			{
				$.messager.alert("提示信息", "撤销成功!", 'info');
			}
			else
			{
				$.messager.alert("提示信息", "撤销失败!", 'info');
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
		if ((userInfo.UserLevel == "")&&(userInfo.UserPos == ""))
		{
			$.messager.alert("提示信息", "请先维护用户级别!", 'info');
			return;	
		}
		if (returnValues.action == "sign")
		{
			if (userInfo.Type == "Graph" && userInfo.Image == "")
			{
				$.messager.alert("提示信息", "签名图片未维护，请维护!", 'info');
				return;
			}	
			caSign(signProperty,userInfo,tmpInstanceId);
		}
		else if (returnValues.action == "revoke")
		{
			if (userInfo.UserID != signProperty.Id)
			{
				$.messager.alert("提示信息", "非本人签名,不能撤销!", 'info');
				return;
			}
			var ret = cmdRevokeSignElement(signProperty);
			if (ret.result == "OK")
			{
				$.messager.alert("提示信息", "撤销成功!", 'info');
			}
			else
			{
				$.messager.alert("提示信息", "撤销失败!", 'info');
			}
		}	
	} 		
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
    
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = cmdSignDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    $.messager.alert("提示信息", "签名原文为空!", 'info');
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
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;	
	if ((actionType == "Append" && documentContext.privelege.canCheck == 0) || (actionType == "Replace" && documentContext.privelege.canReCheck == 0))
	{
		$.messager.alert("提示信息", "没有权限签名!", 'info');
		return
	}
	
	//开始签名
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = cmdSignDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");
	if (signInfo.result == "OK")
	{
		cmdSaveSignDocument(instanceId,userInfo.UserID,signlevel,"","","SYS",signInfo.Path,actionType);
	}
	else
	{
		$.messager.alert("提示信息", "签名失败!", 'info');
	}		
}

//检查签名权限脚本
function checkPrivilege(userInfo,signProperty)
{
	var result = {"flag":false,"ationtype":""};	
	var count = signProperty.Authenticator.length;
	if (count >0 && signProperty.Id == userInfo.UserID)
	{
		result = {"flag":false,"ationtype":""};
		$.messager.alert("提示信息", "已签名,不必再签!", 'info');
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
					$.messager.alert("提示信息", "无权限签名!", 'info');
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
					$.messager.alert("提示信息", "无权限签名!", 'info');
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
					$.messager.alert("提示信息", "无权限签名!", 'info');
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
					$.messager.alert("提示信息", "无权限签名!", 'info');
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
					$.messager.alert("提示信息", "无权限签名!", 'info');
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
					$.messager.alert("提示信息", "无权限签名!", 'info');
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
					$.messager.alert("提示信息", "无权限签名!", 'info');
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
			$.messager.alert("提示信息", "无权限签名!", 'info');			
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
			$.messager.alert("提示信息", "无权限签名!", 'info');			
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
			$.messager.alert("提示信息", "无权限签名!", 'info');
		}		
	}
	else 
	{
		if (signProperty.OriSignatureLevel != userInfo.UserLevel && signProperty.OriSignatureLevel != userInfo.UserPos)
		{
			//无权限签
			result = {"flag":false,"ationtype":""};
			$.messager.alert("提示信息", "签名身份不符，无权限签名!", 'info');
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

//撤销签名
function revokeSignElement(signProperty)
{
	var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel}}}};
	return cmdSyncExecute(argJson);
}
