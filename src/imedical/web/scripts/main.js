// 下面的tools,在css中有修改
var tools = [{
			id : 'gear',
			qtip : '还原',
			handler : function() {
				var mainsouth = Ext.getCmp("mainSouth");
				if (mainsouth.getState().collapsed) {
					return;
				}
				mainsouth.setHeight(280);
				mainsouth.afterExpand();
			}
		}, {
			id : 'maximize',
			qtip : '最大',
			handler : function(e, target, panel) {
				var mainsouth = Ext.getCmp("mainSouth");
				if (mainsouth.getState().collapsed) {
					return;
				}
				mainsouth.setHeight(560);
				mainsouth.afterExpand();
			}
		}];

var treeBbar = [{
			id : 'btnFinishRecord',
			cls : 'x-btn-text-icon',
			text : '生成PDF',
			height : 20,
			pressed : false,
			disabled : true,
			icon : '../scripts/epr/Pics/PDF.ico',
			handler : function() {
				FinishRecord(episodeID,userID);
			}
		}, ' ',{
			id : 'btnToSection',
			cls : 'x-btn-text-icon',
			text : '病历转移',
			height : 20,
			pressed : false,
			icon : '../scripts/epr/Pics/sltPrint.gif',
			handler : function() {
				setDllVisibility("hidden");
				toSection(episodeID);
			}
		}, ' ', {
			id : 'btnAppoint',
			cls : 'x-btn-text-icon',
			text : '病历授权',
			height : 20,
			pressed : false,
			disabled : true,
			icon : '../scripts/epr/Pics/appoint.png',
			handler : function() {
				setDllVisibility("hidden");
				var win = new Ext.Window({
					id : 'appointWin',
					layout : 'fit', // 自动适应Window大小
					width : 950,
					height : 600,
					title : '病历授权',
					animateTarget : 'btnAppoint',
					// raggable: true, //不可拖动
					modal : true, // 遮挡后面的页面
					resizable : true, // 重置窗口大小
					html : '<iframe id="frmAppoint" style="width:100%; height:100%" src="epr.newfw.actionappointlist.csp?PatientID='
							+ patientID
							+ '&EpisodeID='
							+ episodeID
							+ '"></iframe>'
				});

				win.on('close', function() {
							setDllVisibility("visible");
						});

				win.show();
				// alert(patientID);
			}
		}];
function ncctest(){
	setDllVisibility("hidden");
}
function setDllVisibility(status) {
	// debugger;
	var tabPanel = frames["centerTab"].Ext.getCmp("centerTabPanel");
	if (tabPanel) {
		var length = tabPanel.items.length;
		for (var i = 1; i <= length - 1; i++) {
			var tab = tabPanel.items.items[i];
			if (tab) {
				var tabID = tab.id;
				if (tabID.indexOf("tabEdit") >= 0) {
					var prtIndex = tabID.indexOf("And");
					var templateDocID = tabID.substring(7, prtIndex);
					var prtTemplateDocID = tabID.substring(prtIndex + 3);
					var iframeID = String.format("iframe{0}And{1}",
							templateDocID, prtTemplateDocID);
					frames["centerTab"].frames[iframeID].frames['epreditordll']
							.setVisibility(status)
				} else if (tabID.indexOf("tabListEdit") >= 0) {
					var tmpIndex = tabID.indexOf("And");
					var prtIndex = tabID.lastIndexOf("And");
					var templateDocID = tabID.substring(11, tmpIndex);
					var prtTemplateDocID = tabID.substring(tmpIndex + 3,
							prtIndex);
					var eprNum = tabID.substring(prtIndex + 3);
					var iframeID = String.format("iframe{0}And{1}",
							prtTemplateDocID, eprNum);
					frames["centerTab"].frames[iframeID].frames['eprlisteditordll']
							.setVisibility(status)
				}
			}
		}
	}
}

// 验证tree的宽度 //add by zhuj on 2009-12-1
var re = /^[0-9]*[1-9][0-9]*$/;
var isNum = re.test(treeWidth);
if (!isNum || treeWidth == '') {
	treeWidth = 190;
}
if (isNum) {
	// 宽度小于50按50来处理
	if (treeWidth < 50) {
		treeWidth = 50;
	}
}

// add by loo on 2010-4-16
// 病人信息
function setPatientInfo() {
	var splitor = '&nbsp|&nbsp';
	var htmlStr = '&nbsp<span class="spanColorLeft">登记号:</span> <span class="spanColor">'
			+ pInfo[0].papmiNo + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">病案号:</span><span class="spanColor">'
			+ pInfo[0].ipRecordNo + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">床号:</span><span class="spanColor">'
			+ pInfo[0].disBed + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">姓名:</span> <span class="spanColor">'
			+ pInfo[0].name + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">性别:</span> <span class="spanColor">'
			+ pInfo[0].gender + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">年龄:</span> <span class="spanColor">'
			+ pInfo[0].age + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">付费方式:</span><span class="spanColor">'
			+ pInfo[0].payType + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">入院日期:</span> <span class="spanColor">'
			+ pInfo[0].admDate + '</span>';
	htmlStr += splitor
			+ '<span class="spanColorLeft">诊断:</span> <span class="spanColor">'
			+ pInfo[0].mainDiagnos + '</span>';

	var pInfoDiv = document.getElementById('pInfoDiv');
	pInfoDiv.innerHTML = htmlStr;
	if (fontSize == "pt") {
		fontSize = "9pt"
	}
	jQuery(".spanColorLeft").css("fontSize", fontSize);
	jQuery(".spanColor").css("fontSize", fontSize);
}

var frmMainContent = new Ext.Viewport({
	id : 'mainViewPort',
	shim : false,
	animCollapse : false,
	constrainHeader : true,
	margins : '0 0 0 0',
	layout : 'border',
	border : false,
	items : [
		{
			id : 'westTree',
			region : 'west',
			layout : 'accordion',
			title : '病历列表',
			width : treeWidth,
			split : true,
			collapsible : true,
			bbar : treeBbar,
			items : [
				{
					// contentEl:'currentDocs',
					autoLoad : {
						scripts : true,
						scope : this,
						url : "epr.newfw.tree.csp",
						callback : function() {
						}
					},
					title : '本次病历',
					border : false,
					iconCls : 'nav'
				}
			]
		}, 
		{
			region : 'center',
			layout : "border",
			id : "mainCenter",
			items : [
				{
					border : false,
					id : 'mainpInfo',
					region : 'north',
					height : 20,
					autoScroll: true,  //add by niucaicai 2012-06-29  解决“患者信息超出页面后不显示”问题
					html : '<div id="pInfoDivParent"><div id="pInfoDiv"></div></div>'
				}, 
				{
					border : false,
					tools : tools,
					id : 'mainSouth',
					region : 'south',
					title : ' ',
					split : true,
					collapsible : true,
					collapsed : true,
					titleCollapse : false,
					layout : 'fit',
					height : 280,
					html : '<iframe id ="southTab" style="width:100%; height:100%" src="epr.newfw.southtab.csp?episodeID='
							+ episodeID
							+ '&patientID='
							+ patientID
							+ '&templateDocId='
							+ templateDocId
							+ '&printTemplateDocId='
							+ printTemplateDocId
							+ '" ></iframe>'
				}, 
				{
					border : false,
					region : 'center',
					layout : 'fit',
					html : '<iframe id ="centerTab" style="width:100%; height:100%;" src="epr.newfw.centertab.csp?episodeID='
							+ episodeID
							+ '&patientID='
							+ patientID
							+ '&templateDocId='
							+ templateDocId
							+ '&printTemplateDocId='
							+ printTemplateDocId
							+ '" ></iframe>'
				}
			]
		}
	]
});

// 增加southTitle
var mainsouthcollapsed = document.getElementById('mainSouth-xcollapsed'); // 找到下面的元素
var titleInfo = document.createElement("div");
titleInfo.id = 'southTitleInfo';
titleInfo.style.fontSize = 12;
// titleInfo.innerHTML = '&nbsp医嘱/化验/病历浏览';
titleInfo.style.position = 'absolute';
titleInfo.style.top = 4;
titleInfo.style.color = '565f6d';
titleInfo.style.fontWeight = 'bold';
mainsouthcollapsed.appendChild(titleInfo);

// 暂时未实现，为将来做接口
var mainsouth = Ext.getCmp('mainSouth');
mainsouth.on("beforeexpand", function() {
		});
mainsouth.on("beforecollapse", function() {
		});

// 检查病历单元是否进行了修改，
function isRPRModified() {
	// debugger;
	var result = [];
	var changed = false;
	var message = "";
	if (frames['centerTab'].isCategoryChapterLocked)
		return result;

	var tabPanel = frames["centerTab"].Ext.getCmp("centerTabPanel");
	if (tabPanel) {
		var length = tabPanel.items.length;
		for (var i = 1; i <= length - 1; i++) {
			var tab = tabPanel.items.items[i];
			if (tab) {
				var tabID = tab.id;
				var tabName = tab.title;
				// debugger;
				if (tabID.indexOf("tabEdit") >= 0) {
					var prtIndex = tabID.indexOf("And");
					var templateDocID = tabID.substring(7, prtIndex);
					var prtTemplateDocID = tabID.substring(prtIndex + 3);
					var iframeID = String.format("iframe{0}And{1}",
							templateDocID, prtTemplateDocID);
					var curFrame = frames['centerTab'].frames[iframeID];
					if (curFrame) {
						var dll = curFrame.frames['epreditordll'];
						if (null != dll) {
							var eprform = dll.document
									.getElementById('eprform');
							changed = eprform.IsValueChanged();
							if (changed) {
								message = tabName;
								break;
							}
						}
					}
				} else if (tabID.indexOf("tabListEdit") >= 0) {
					var tmpIndex = tabID.indexOf("And");
					var prtIndex = tabID.lastIndexOf("And");
					var templateDocID = tabID.substring(11, tmpIndex);
					var prtTemplateDocID = tabID.substring(tmpIndex + 3,
							prtIndex);
					var eprNum = tabID.substring(prtIndex + 3);
					var iframeID = String.format("iframe{0}And{1}",
							prtTemplateDocID, eprNum);
					var curFrame = frames['centerTab'].frames[iframeID];
					if (curFrame) {
						var dll = curFrame.frames['eprlisteditordll'];
						if (null != dll) {
							var eprform = dll.document
									.getElementById('eprlistedit');
							changed = changed || eprform.IsValueChanged();
							if (changed) {
								message = tabName;
								break;
							}
						}
					}
				}
			}
		}
	}
	result[0] = changed;
	result[1] = message;
	return result;
}

// 退出提示
window.onbeforeunload = function() {
	// debugger;
	var n = window.event.screenX - window.screenLeft;
	var b = n > document.documentElement.scrollWidth - 20;
	// 是关闭
	if (b && window.event.clientY < 0 || window.event.altKey) {
		var result = isRPRModified();
		if (result[0]) {
			window.event.returnValue = String.format("【{0}】已经修改。是否放弃修改？",
					result[1]);
		}
	}
	// 是刷新 0
	// 此处因为在关闭之后，同样会调用刷新事件
	// 所以仅仅捕捉刷新事件即可
	else if (event.keyCode == 0 && window.screenLeft != 10008) {
		var result = isRPRModified();
		if (result[0]) {
			window.event.returnValue = String.format("【{0}】已经修改。是否放弃修改？",
					result[1]);
		}
	} else {

	}
}

// 作者：Kumon Xie on 2011-05-08
// 功能：病历引用功能按钮事件（centerTabListDetail中定义按钮，certerTabListDetailMethod中定义方法和入参）
// 目的：为了使遮罩的范围扩大至最外层；
function refMultiple(patientID, admitType, episodeID, templateID,
		templateDocID, prtTemplateID, prtTemplateDocID) {
	setDllVisibility("hidden");
	var win = new Ext.Window({
		id : 'winReference',
		layout : 'fit',
		width : 1000,
		height : 600,
		title : '病历引用',
		plain : true,
		animateTarget : 'btnReference',
		modal : true,
		closable : false,
		resizable : false,
		html : '<iframe id="frmRefMultiple" style="width:100%; height:100%" src="dhc.epr.ref.multireference.csp?PatientID='
				+ patientID
				+ '&AdmitType='
				+ admitType
				+ '&EpisodeID='
				+ episodeID
				+ '&TemplateID='
				+ templateID
				+ '&TemplateDocID='
				+ templateDocID
				+ '&PrintTemplateID='
				+ prtTemplateID
				+ '&PrintTemplateDocID=' + prtTemplateDocID + '"></iframe>'
	});
	win.on('close', function() {
				// 窗体关闭时将dll显示
				setDllVisibility("visible");
			});
	win.show();
}

// 作者：Kumon Xie on 2011-05-08
// 功能：唯一模板病历引用功能按钮事件（centerTabDetail中定义按钮，centerTabDetailMethod中定义方法和入参）
// 目的：为了使遮罩的范围扩大至最外层；
function refSingle(patientID, admitType, episodeID, instanceID, templateID,
		templateDocID, prtTemplateID, prtTemplateDocID) {
	// debugger;
	setDllVisibility("hidden");
	var win = new Ext.Window({
		id : 'winReference',
		layout : 'fit',
		width : 1000,
		height : 600,
		title : '病历引用',
		plain : true,
		animateTarget : 'btnReference',
		modal : true,
		closable : false,
		resizable : false,
		html : '<iframe id="frmRefSingle" style="width:100%; height:100%" src="dhc.epr.ref.singlereference.csp?PatientID='
				+ patientID
				+ '&AdmitType='
				+ admitType
				+ '&EpisodeID='
				+ episodeID
				+ '&InstanceID='
				+ instanceID
				+ '&TemplateID='
				+ templateID
				+ '&TemplateDocID='
				+ templateDocID
				+ '&PrintTemplateID='
				+ prtTemplateID
				+ '&PrintTemplateDocID='
				+ prtTemplateDocID + '"></iframe>',
		listeners : {
			'beforeclose' : function() {
				treeLoader.load(root, function loaded() {
							afterSingleRefClosed(selectGrandpaNode,
									selectParentNode, templateDocID);
						});

				refreshTab(episodeID, patientID, templateDocID,
						prtTemplateDocID);
			},
			'close' : function() {
				// 窗体关闭时将dll显示
				setDllVisibility("visible");
			}
		}
	});
	win.show();
}

function afterSingleRefClosed(selectGrandpaNode, selectParentNode,
		templateDocID) {
	// debugger;
	var cgChildNodes = root.childNodes;
	for (var i = 0; i < cgChildNodes.length; i++) {
		var nodeID = cgChildNodes[i].id;
		if (nodeID == selectGrandpaNode.id) {
			selectGrandpaNode = cgChildNodes[i];
			treeLoader.load(selectGrandpaNode, function loaded() {
				selectGrandpaNode.expand(false, false, function() {
							// debugger;
							var ccChildNodes = selectGrandpaNode.childNodes;
							for (var j = 0; j < ccChildNodes.length; j++) {
								var nodeID = ccChildNodes[j].id;
								if (nodeID == selectParentNode.id) {
									selectParentNode = ccChildNodes[j];
									treeLoader.load(selectParentNode,
											function loaded() {
												selectParentNode.expand(false,
														false, function() {
															resetSelectTreeNode(
																	selectParentNode,
																	templateDocID);
														});
											});
									break;
								}
							}
						});
			});
			break;
		}
	}
}

// 作者：Kumon Xie on 2011-11-23
// 功能：唯一模板病历引用完毕后重新指定左侧树上的选中节点；
function resetSelectTreeNode(selectParentNode, templateDocID) {
	// debugger;
	var childNodes = selectParentNode.childNodes;
	for (var i = 0; i < childNodes.length; i++) {
		var nodeID = childNodes[i].id;
		if (nodeID.substring(2, nodeID.length) == templateDocID) {
			selectTreeNode = childNodes[i];
			break;
		}
	}
}

// 作者：Kumon Xie on 2011-11-22
// 功能：删除指定页签；
// 目的：唯一模板病历引用完毕后移除当前打开的节目模板页签；
function refreshTab(episodeID, patientID, templateDocID, prtTemplateDocID) {
	var tabPanel = frames["centerTab"].Ext.getCmp("centerTabPanel");
	if (tabPanel) {
		var tabID = String.format("tabEdit{0}And{1}", templateDocID,
				prtTemplateDocID);
		var iframeID = String.format("iframe{0}And{1}", templateDocID,
				prtTemplateDocID);
		if (frames['centerTab'].frames[iframeID].refresh) {
			frames['centerTab'].frames[iframeID].refresh(episodeID, patientID,
					templateDocID, prtTemplateDocID);
		}
	}
}

function IsCAOn() {
	return "1" == CAStatus
}

function verify(params) {
	params["needLogin"] = "0";
	verifySign(params);
}

// 判断是否插入usbKey
function ExistKey() {
	var flag = getUserList2();
	if (null == flag || "" == flag) {
		alert("请先插入KEY");
		return false;
	} else {
		return true;
	}
}

// 协和医院认证ad帐号
function AdAuthForXieHe(username, psw) {
	if ("XieHe" != HisName)
		return true;

	try {
		var re = DHCAdAuthInterface.AdAuth(username, psw).split('^')
		if (0 == re[0])
			return true;

		alert(re[1]);
		return false;
	} catch (e) {
		alert("AD帐号认证失败！")
		return false;
	}
}


function FinishRecord(episodeID, userID)
{
	var imageButtonYes=new Ext.ux.ImageButton({
            imgPath : '../scripts/epr/Pics/是按钮.gif',
            imgWidth : 53,
            imgHeight : 22,
            tooltip  : '确定生成',//鼠标放上去的提示
            handler : function(btn) {
					Ext.Ajax.request({
						url: '../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls',
						params:{EpisodeID:episodeID,UserID:userID},
						success: function(response, options){
							var ret = response.responseText;
							if (ret ==-1 )
							{
								alert("提交生成PDF失败！");
								return;
							}
							else if (ret == 1)
							{
								alert("提交生成PDF成功！");
								Ext.getCmp('btnFinishRecord').disable();
								return;
							}
						}
					}) 
			
			}
	});
 
 	var imageButtonNo=new Ext.ux.ImageButton({
            imgPath : '../scripts/epr/Pics/否按钮.gif',
            imgWidth : 53,
            imgHeight : 22,
            tooltip  : '关闭',//鼠标放上去的提示
            handler : function(btn) {
                 window.close();
             }
 });
	
 	var window = new Ext.Window({
        width:373,
        height:225,
        closable:false,
        resizable:false,
        draggable:false,
        modal:true,
		frame:false,
		border:0,
		bodyStyle:"background-color:transparent;padding:0",
        layout:'border',
        frame:false,
		items:[{
			region:"center",
			border:0,
			bodyStyle:"background-image:url('../scripts/epr/Pics/弹出框背景.gif');padding:0px 0px 0",
			layout:'border',
			items:[{
				region:"east",
				height:22,
				items:imageButtonYes,
				border:0,
	        	bodyStyle:"background-color:transparent;padding:165px 270px 95px 120" 
			},{
				region:"west",
				height:22,
				items:imageButtonNo,
				border:0,
	        	bodyStyle:"background-color:transparent;padding:165px 170px 95px 220" 			
			},{
				region:"center"
			}]
		}]
    });
    window.show();
	
 /*
	Ext.MessageBox.confirm("注意！","提交生成PDF后将无法修改病历，是否继续？",function(button){ 
        	if (button=='yes')
        	{

			Ext.Ajax.request({
				url: '../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls',
				params:{EpisodeID:episodeID,UserID:userID},
				success: function(response, options){
					var ret = response.responseText;
					if (ret ==-1 )
					{
						alert("提交生成PDF失败！");
						return;
					}
					else if (ret == 1)
					{
						alert("提交生成PDF成功！");
						Ext.getCmp('btnFinishRecord').disable();
						return;
					}
			
				}
			}) 

			}
	})
*/
}

function SetBtnFinishRecord()
{

		Ext.getCmp('btnFinishRecord').enable();
	
}

SetBtnFinishRecord();
