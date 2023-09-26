//是否可以打印
function setBtnPrintEnabled()
{
	//如果不能打印,返回
	if(canPrint != '1')
	{
		return;
	}
	//如果没有开启,返回
	if (printAfterCommit != '1')
	{
		return;
	}
	if (currState == 'unfinished' || currState == 'finished' || currState == '')
	{
		Ext.getCmp('btnPrint').disable();
	}
	else
	{
		Ext.getCmp('btnPrint').enable();
	}			
}

//ajax从后台取权限	add bu zhuj on 2009-12-4
function getPower()
{
	Ext.Ajax.request({			
		url: '../web.eprajax.ajaxGetPower.cls',
		timeout: timedOut,
		params: { episodeID: episodeID, printTemplateDocId: printTemplateDocId, templateDocId: templateDocId, EPRNum: EPRNum, patientID: pateintID},
		success: function(response, opts) {
			var obj = eval('[{' + response.responseText + '}]');
			canView = obj[0].canView;
			canSave = obj[0].canSave;
			canPrint = obj[0].canPrint;
			canCommit = obj[0].canCommit;
			canSwitch = obj[0].canSwitch;
			canSwitchTemplate = obj[0].canSwitchTemplate;
			canChiefCheck = obj[0].canChiefCheck;
			canAttendingCheck = obj[0].canAttendingCheck;
			printAfterCommit = obj[0].printAfterCommit;
			setPower();
		},
		failure: function(response, opts) {				
			var obj = "获取权限列表错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;				
			alert(obj);
		}
	});
}

//保存
function save(isConfirm)
{
	//保存操作
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	eprform.PrnTemplateDocID = printTemplateDocId;
	eprform.TemplateDocID = templateDocId;
	
	if (isConfirm == '')
	{
		var saveState = eprform.SaveClick();
	}
	else
	{
		var saveState = eprform.SaveClick(isConfirm);
	}
	
	if (saveState != true)
	{
		alert('保存失败!');
		return;		
	}
	
	//提示是否保存的信息状态
	isSave = true;
	
	/*
	//设置tree的图标		add by zhuj on 2009-12-15
	parent.parent.selectTreeNode.getUI().getIconEl().src = '../scripts/epr/Pics/saveSingle.gif';
	parent.parent.selectTreeNode.getUI().removeClass('tree-unsave');
	parent.parent.selectTreeNode.getUI().addClass('tree-save');
	*/
	
	var obj = eprform.StatusAfterSaveNewFrameWork;
	
	//设置病历当前状态
	currState = obj.split('^')[3];
				
	//修改状态
	divState.innerHTML = obj.split('^')[1];
				
	//打印类型
	var printType = '';
	
	for (var i = 0; i < eprform.childNodes.length; i++)
	{
		if (eprform.childNodes[i].name == 'ChartItemType')
		{
			printType = eprform.childNodes[i].value;
		}	
	}
	
	
	
	//获得logID
	var logID = obj.split('^')[2];
	
	if(EPRNum == '1')
	{
		var objEprform = frames['epreditordll'].document.getElementById('eprform');
		objEprform.InvokePreviewService(pateintID, episodeID, logID, bindPrnTemplateID, printType,  "", userID, printTemplateDocId);		
	}
	//setBtnPrintEnabled();		//add by zhuj on 2009-11-17
	//重新取得权限并设置
	getPower();
	
	
	
} 



//更新
function update()
{		
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	var printState = eprform.RefreshClick();
	
} 

//打印
function print()
{
	if (currState == 'unfinished' || currState == '')
	{
		alert('未"完成"的病历不能打印!');
		return;	
	}
	
	//判断ID是否为空,若为空,则直接返回
	if (bindPrnTemplateID == "")
	{
		Ext.getCmp('btnPrint').disable();
		alert("打印模板ID为空,不能进行打印操作!");
		return;
	}
	
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	var printState = eprform.PrintClick(bindPrnTemplateID, printTemplateDocId);
	
	//判断打印是否成功
	if (printState != true)
	{
		return;
	}
	//写日志
	printLog();
} 

//提交
function commit()
{
	//判断是否未完成
	if (currState == 'unfinished' || currState == '')
	{
		alert('当前病历尚未完成,不能进行提交操作!');
		return;	
	}
	//判断是否已经提交
	if (currState == 'commited')
	{
		alert('当前病历已经提交,不需重复提交!');
		return;	
	}
	//判断是否已经审核
	if (currState == 'attendingChecked' || currState == 'chiefChecked')
	{
		alert('当前病历已经审核,不需重复提交!');
		return;	
	}
	//判断是否已经归档
	if (currState == 'archieved')
	{
		alert('当前病历已经归档交,不需重复提交!');
		return;	
	}
	/*
	if (currState != 'finished')
	{
		alert('只能提交当前状态为"完成"的病历!');
		return;	
	}
	*/
	var commit = confirm('您确定要提交病历吗?');
	if (commit)
	{
		var eprform = frames['epreditordll'].document.getElementById('eprform');
		var state = eprform.CommitClick();
		if (state == true)	
		{
			commitedLog();
		}
	}
} 

//切换模板
function sltTemplate()
{
	var eprform = frames['epreditordll'];
	eprform.setVisibility('hidden');
	
	var selectNode = parent.parent.selectParentNode;
	parent.parent.templateSelect(selectNode, episodeID);
}

//主任医生审核
function chiefCheck()
{
	if (currState != 'commited' && currState != 'attendingChecked')
	{
		alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
		return;	
	}
	eprAudit('Chief');
} 

//主治医生审核
function attendingCheck()
{
	if (currState != 'commited')
	{
		alert('只能审核当前状态为"提交"的病历!');
		return;	
	}		
	eprAudit('Attending');
} 

//更新模板
function updateTemplate()
{
	if (necessaryTemplate == "-1")
	{
		alert('获取是否是必填模板失败.');
		return;
	}
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	eprform.PrnTemplateDocID = printTemplateDocId;
	eprform.TemplateDocID = templateDocId;
	
	
	if (necessaryTemplate == "1")
	{
		var printState = eprform.TemplateClick('refreshNecessary');
	}
	else if (necessaryTemplate == "0")
	{
		var printState = eprform.TemplateClick('refreshUnnecessary');
	}
	var obj = eprform.StatusAfterSaveNewFrameWork;
	
	if (obj != 'UnChanged')
	{
	/*
		//设置tree的图标		add by zhuj on 2009-12-15
		parent.parent.selectTreeNode.getUI().getIconEl().src = '../scripts/epr/Pics/unSaveSingle.gif';
		parent.parent.selectTreeNode.getUI().removeClass('tree-save');
		parent.parent.selectTreeNode.getUI().addClass('tree-unsave');
		
		if (necessaryTemplate == "1")
		{
			//parent.parent.selectParentNode.getUI().getIconEl().src = '../scripts/epr/Pics/unSaveSingle.gif';
			parent.parent.selectParentNode.getUI().removeClass('tree-commit');
			parent.parent.selectParentNode.getUI().addClass('tree-uncommit');
			
		}
		*/
		
		//设置病历当前状态
		currState = obj.split('^')[3];
		//修改状态
		divState.innerHTML = obj.split('^')[1];
		//执行打印按钮权限
		getPower();			//add by zhuj on 2009-12-4
	}
	
}

//-----------------------------------






///add by zhuj on 2009-7-28
///打印
function printLog()
{
	Ext.Ajax.request({			
		url: '../web.eprajax.logs.print.cls',
		timeout: timedOut,
		params: { EpisodeID: episodeID, EPRDocID: printTemplateDocId, templateDocId: templateDocId, EPRNum: EPRNum},
		success: function(response, opts) {
			var obj = response.responseText;
			if (obj.split('^')[0] == "success")
			{
				divState.innerHTML = obj.split('^')[1];
				getPower();			//add by zhuj on 2009-12-4
			}
			else if (obj == "sessionTimedOut")
			{
				alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
			}
			else
			{
				alert("写入日志错误!错误原因:" + obj);
			}
		},
		failure: function(response, opts) {				
			var obj = "写入日志错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;				
			alert(obj);
		}
	});
}	

///add by zhuj on 2009-7-28
///提交
function commitedLog()
{
	Ext.Ajax.request({			
		url: '../web.eprajax.logs.commited.cls',
		timeout : timedOut,
		params: { EpisodeID: episodeID, EPRDocID: printTemplateDocId, templateDocId: templateDocId, EPRNum: EPRNum},
		success: function(response, opts) {
			var obj = response.responseText;
			if (obj.split('^')[0] == "success")
			{
				//设置tree的图标		add by zhuj on 2009-12-15
				if (EPRNum == "1")
				{
					parent.parent.selectParentNode.getUI().removeClass('tree-uncommit');
					parent.parent.selectParentNode.getUI().addClass('tree-commit');
					//var nodeText = parent.parent.selectParentNode.text;
					//parent.parent.selectParentNode.setText(nodeText + "(已提交)");
				}
			
				//设置病历当前状态
				currState = obj.split('^')[2];
				
				//修改状态
				divState.innerHTML = obj.split('^')[1];
				//setBtnPrintEnabled();				//add by zhuj on 2009-11-17
				getPower();			//add by zhuj on 2009-12-4
				
			}
			else if (obj == "sessionTimedOut")
			{
				alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
			}
			else
			{
				alert("写入日志错误!错误原因:" + obj);
			}
			
			
		},
		failure: function(response, opts) {				
			var obj = "写入日志错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;				
			alert(obj);
		}
	});
}

//自动保存
function eprAutoSave()
{
	if (!(canView == "1" && canSave == "1"))
	{
		return;
	}
	save('True');
}

//关闭计时器
function closeInterval()
{
	clearInterval(interval);
}

function setSaveTime()
{
	if (isNaN(autoSaveTime))
	{
		autoSaveTime = -1;
	}
	
	if (autoSaveTime < 1)
	{
		autoSaveTime = -1;
	}
	
	if (autoSaveTime > 0 && autoSaveTime < 60)
	{
		autoSaveTime = 60;
	}
	if (autoSaveTime > 0)
	{
	    interval = setInterval(eprAutoSave, autoSaveTime * 1000);
	}	
}

//病人信息
function setPatientInfo()
{
 	var divInfo = document.getElementById('divInfo'); 	
 	divInfo.innerHTML = '&nbsp<span class="spanColorLeft">登记号:</span> <span class="spanColor">' + pInfo[0].papmiNo + '</span>&nbsp&nbsp|&nbsp&nbsp<span class="spanColorLeft">床号:</span> <span class="spanColor">' + pInfo[0].disBed  + '</span>&nbsp&nbsp|&nbsp&nbsp<span class="spanColorLeft">姓名:</span> <span class="spanColor">' + pInfo[0].name +  '</span>&nbsp&nbsp|&nbsp&nbsp<span class="spanColorLeft">性别:</span> <span class="spanColor">' + pInfo[0].gender +  '</span>&nbsp&nbsp|&nbsp&nbsp' + '<span class="spanColorLeft">年龄:</span> <span class="spanColor">' + pInfo[0].age + '</span>&nbsp&nbsp|&nbsp&nbsp' + '<span class="spanColorLeft">诊断:</span> <span class="spanColor">' + pInfo[0].mainDiagnos +'</span>';
 	if (fontSize == "pt")
 	{ 
 		fontSize = "9pt"
 	}
 	$(".spanColorLeft").css("fontSize", fontSize);
 	$(".spanColor").css("fontSize", fontSize);
}
//病历状态
function setEprState()
{
	var divState = document.getElementById('divState');
 	divState.innerHTML = divStateServer;
}

function setPower()
{
	if(canView == "1" && canSave == "1")
	{ Ext.getCmp('btnSave').enable()}
	else
	{ Ext.getCmp('btnSave').disable()}

	if(canView == "1" && canPrint == "1")
	{ Ext.getCmp('btnPrint').enable()}
	else
	{ Ext.getCmp('btnPrint').disable()}

	if(canView == "1" && canCommit == "1")
	{ Ext.getCmp('btnCommit').enable()}
	else
	{ Ext.getCmp('btnCommit').disable()}

	if(canView == "1" && canSwitch == "1")
	{ Ext.getCmp('btnSltTemplate').enable()}
	else
	{ Ext.getCmp('btnSltTemplate').disable()}
	
	if(canView == "1" && canSwitchTemplate == "1")
	{ Ext.getCmp('btnUpdateTemplate').enable()}
	else
	{ Ext.getCmp('btnUpdateTemplate').disable()}

	if(canView == "1" && canChiefCheck == "1")
	{ Ext.getCmp('btnChiefCheck').enable()}
	else
	{ Ext.getCmp('btnChiefCheck').disable()}

	if(canView == "1" && canAttendingCheck == "1")
	{ Ext.getCmp('btnAttendingCheck').enable()}
	else
	{ Ext.getCmp('btnAttendingCheck').disable()}
	if(canView == "1")
	{ Ext.getCmp('btnUpdateData').enable()}
	else
	{Ext.getCmp('btnUpdateData').disable()}
}
