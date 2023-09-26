var selectedNode = null;
var helper = Ext.DomHelper;

function doSearch() {
    var admitType = Ext.getCmp('cboAdmType').getValue();
    var argDiagnosDesc = Ext.getCmp('txtArgDiagnosDesc').getValue();

    Ext.getCmp('episodeGrid').getEl().mask('数据重新加载中，请稍等', 'x-mask-loading');
    var store = Ext.getCmp('episodeGrid').getStore();
    var url = '../web.eprajax.episodeListGrid.cls?patientID=' + patientID + '&admType=' + admitType + '&argDiagnosDesc=' + escape(argDiagnosDesc);
    store.proxy.conn.url = url;
    //store.load();
	store.load({ params: { start: 0, limit: 5} });

    store.on('load', function(store, record) {
        Ext.getCmp('episodeGrid').getEl().unmask();
    });

    store.on('loadexception', function() {
        Ext.getCmp('episodeGrid').getEl().unmask();
    });
}

function doConfirm() {
    var refTree = Ext.getCmp("eprRefTree");
    refTree.root.reload();
	//add by YHY 2013-12-11 默认展开选中树节点 
	refTree.root.expand(false, true, nodeExpandCallBack);	
}

function doWholeReference() {
    var selectedNodes = tree.getChecked();
    var selectedLeafNodes = getAllLeafNodes(selectedNodes);
    if (selectedLeafNodes.length == 0) {
		if (check()) {
			Ext.Msg.alert("提示信息", "此次就诊已经保存 或 引用病历模版不一致，不能引用!");
		}
		else {
			Ext.Msg.alert("提示信息", "请先从左侧病历引用树上选择要引用的病历模板!");
		}
        return;
    }

    Ext.getCmp("eprRefTree").disable();
    Ext.getCmp("btnBatchReference").disable();
    Ext.getCmp("btnWholeReference").disable();

    //debugger;
    var hint = "正在引用患者" + patientName + "于" + chkAdmDate + " " + chkAdmTime + "就诊的病历...";
    var divReference = Ext.get("divReference");
    divReference.dom.innerHTML = "";
    divReference.mask(hint, 'x-mask-loading')

    setTimeout("exeWholeReference()", 500);
}

function exeWholeReference() {
    //debugger;
    var divReference = Ext.get("divReference");
    var selectedNodes = tree.getChecked();
    var selectedLeafNodes = getAllLeafNodes(selectedNodes);
    var list = helper.append("divReference", { tag: "UL", id: "ulTemplate", cls: "navbar" });
    var scheme = '<a id="{id}" onclick="popTemplate(' + '\'{id}\',\'{text}预览\',\'{eprDocID}\');"' + '>{text}</a>';
    var liTemplate = helper.createTemplate({ tag: "LI", id: "{id}", html: scheme });
    try {
        Ext.each(selectedLeafNodes, function(node) {
            //debugger;
            var curCateogryID = node.attributes.categoryID;
            var curCategoryName = node.attributes.categoryName;
            var curCategoryType = node.attributes.categoryType;
            var curTemplateID = node.attributes.templateID;
            var curPrtTemplateID = node.attributes.prtTemplateID;
            var curTemplateDocID = node.attributes.templateDocID;
            var curPrtTemplateDocID = node.attributes.prtTemplateDocID;
            if (!isPageRefresh && curTemplateDocID == templateDocID) { isPageRefresh = true; }
            var newInstanceID = doBackendReference(node.id, curCateogryID, curCategoryName, curCategoryType, curTemplateID, curPrtTemplateID, curTemplateDocID, curPrtTemplateDocID);
            if (newInstanceID != "") {
                liTemplate.append(list, { id: newInstanceID, text: node.text, eprDocID: curTemplateDocID });
            } else {
                Ext.Msg.alert("[" + curCategoryName + "]引用失败！");
                divReference.unmask();
                return;
            }
        });

        //重新加载左侧病历引用树
        doConfirm();

        //刷新日志列表
        Ext.getCmp('refLogGrid').getEl().mask('数据重新加载中，请稍等', 'x-mask-loading');
        var store = Ext.getCmp('refLogGrid').getStore();
        var url = '../web.eprajax.reference.refjournal.cls?EpisodeID=' + episodeID + '&RefType=' + refType + "&UserID" + userID;
        store.proxy.conn.url = url;
        store.load();

        store.on('load', function(store, record) {
            Ext.getCmp('refLogGrid').getEl().unmask();
        });

        store.on('loadexception', function() {
            Ext.getCmp('refLogGrid').getEl().unmask();
        });
    } catch (e) {
        //debugger;
        alert(e.message);
    } finally {
        //重新启用按钮
        Ext.getCmp("eprRefTree").enable();
        Ext.getCmp("btnBatchReference").enable();
        Ext.getCmp("btnWholeReference").enable();

        isNeedRefresh = true;
        divReference.unmask();
    }
}

//后台处理引用
function doBackendReference(oldInstanceID, curCateogryID, curCategoryName, curCategoryType, curTemplateID, curPrtTemplateID, curTemplateDocID, curPrtTemplateDocID) {
    //debugger;
    var newInstanceID = ""
    var eprform = frames['frameWholeTemplate'].eprform;
    if (eprform) {
        eprform.Revisionable = false;
        eprform.Browsable = true;
        eprform.ChartItemID = curTemplateDocID;
        eprform.ProfileID = curTemplateDocID;
        eprform.PrnTemplateDocID = curPrtTemplateDocID;
        eprform.TemplateDocID = curTemplateDocID;
        eprform.ReplaceInstanceData(oldInstanceID);
        var status = eprform.SaveClick(true, "reference");
        if (status) {
            if (!isTreeRefresh) { isTreeRefresh = true; }
            newInstanceID = eprform.GetRefInstanceID(episodeID, curTemplateID);
            var obj = eprform.StatusAfterSaveNewFrameWork;
            var newLogID = obj.split('^')[2];

            eprform.InvokePreviewService(patientID, episodeID, newLogID, curPrtTemplateID, "Single", "", userID, curPrtTemplateDocID);
        }
    }
    return newInstanceID;
}

function popTemplate(curInstanceID,curTitle,curTemplateDocID) {
    var frameUrl = 'dhc.epr.ref.loadtemplate.csp?Refresh=0&LoadType=Single&EpisodeID=' + episodeID + '&InstanceID=' + curInstanceID + "&TemplateDocID=" + curTemplateDocID;
    var iframeScript = '<iframe id="framePreview" style="width:100%;height:100%;" src="' + frameUrl + '"></iframe>';
    var win = new Ext.Window({
        id: 'winPreview',
        layout: 'fit',
        width: 960,
        height: 500,
        title: curTitle,
        plain: true,
        modal: true,
        closable: true,
        resizable: false,
        html: iframeScript,
        bbar: ["->",{
            text: '关闭',
            cls: 'x-btn-text-icon',
            icon: '../scripts/epr/Pics/btnClose.gif',
            pressed: false,
            handler: function(win){
                var curWindow = Ext.getCmp("winPreview"); 
                if (curWindow){
                    curWindow.close();
                }
            }
        }]
    }).show();
}

function doBatchReference() {
    //debugger;
    var selectedNodes = tree.getChecked();
    var selectedLeafNodes = getAllLeafNodes(selectedNodes);
    if (selectedLeafNodes.length == 0) {
		if (check()) {
			Ext.Msg.alert("提示信息", "此次就诊已经保存 或 引用病历模版不一致，不能引用!");
		}
		else {
			Ext.Msg.alert("提示信息", "请先从左侧病历引用树上选择要引用的病历范围!");
		}
        return;
    }
    
    Ext.getCmp("eprRefTree").disable();
    Ext.getCmp("btnBatchReference").disable();
    Ext.getCmp("btnWholeReference").disable();

    selectedNode = selectedLeafNodes[0];
    
    loadTemplate(episodeID, selectedNode, selectedLeafNodes);
}

//加载界面模板
function loadTemplate(episodeID, selectedNode, selectedLeafNodes) {
    var divReference = Ext.get("divReference");
    document.getElementById("divReference").innerHTML = "";
    divReference.mask('载入数据,请稍候...', 'x-mask-loading');
    var eprDocID = selectedNode.attributes.templateDocID;
    var frameUrl = 'dhc.epr.ref.loadtemplate.csp?Refresh=1&LoadType=Single&EpisodeID=' + episodeID + '&InstanceID=' + selectedNode.id + "&TemplateDocID=" + eprDocID;
    var iframeScript = '<iframe id="frameTemplate" style="width:100%;height:410;" src="' + frameUrl + '"></iframe>';
    var buttonText = "下一页";
    if (selectedNode != null && selectedLeafNodes.length == 1) {
        buttonText = "完成";
    }
    var batchRefPanel = new Ext.Panel({
        id: 'pnlBatchReference',
        header: false,
        frame: true,
        collapsible: false,
        items: [
            {
                id: "pnlTemplate",
                autoheight: true,
                html: iframeScript
            }
        ],
        bbar: [
            '->',
	        '-',
	        { id: 'btnRefNextTemplate', text: buttonText, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/pagedown.gif', pressed: false, listeners: { 'click': function() { doRefNextTemplate(selectedNode, selectedLeafNodes); } } }
        ]
    }).render(divReference);

    divReference.unmask();
}

//下一页
function doRefNextTemplate(selectedNode, selectedLeafNodes) {    
    if (selectedNode != null) {
        var selTemplateID = selectedNode.attributes.templateID;
        var selPrtTemplateID = selectedNode.attributes.prtTemplateID;
        var selTemplateDocID = selectedNode.attributes.templateDocID;
        var selPrtTemplateDocID = selectedNode.attributes.prtTemplateDocID;
        doSingleReference(true, selTemplateID, selPrtTemplateID, selTemplateDocID, selPrtTemplateDocID);
        //debugger;
        //找到selectedNode的下一个节点
        var result = findNextSibling(selectedNode, selectedLeafNodes);
        if (result != null) {
            var curIndex = result[0];
            var nextNode = result[1];
            selectedNode = nextNode;
            loadTemplate(episodeID, selectedNode, selectedLeafNodes);
            if (curIndex == selectedLeafNodes.length - 1) {
                Ext.getCmp("btnRefNextTemplate").setText("完成");
            }
        } else {            
            //重新加载左侧病历引用树
            doConfirm();

            //刷新操作日志    
            Ext.getCmp('refLogGrid').getEl().mask('数据重新加载中，请稍等');
            var store = Ext.getCmp('refLogGrid').getStore();
            var url = '../web.eprajax.reference.refjournal.cls?EpisodeID=' + episodeID + '&RefType=' + refType + "&UserID" + userID;
            store.proxy.conn.url = url;
            store.load();

            store.on('load', function(store, record) {
                Ext.getCmp('refLogGrid').getEl().unmask();
            });

            store.on('loadexception', function() {
                Ext.getCmp('refLogGrid').getEl().unmask();
            });

            //启用和禁用按钮
            Ext.getCmp("eprRefTree").enable();
            Ext.getCmp("btnBatchReference").enable();
            Ext.getCmp("btnWholeReference").enable();
            Ext.getCmp("btnRefNextTemplate").disable();

            Ext.Msg.alert("提示信息", "本次病历引用已全部完成!");
        }

        if (!isTreeRefresh) { isTreeRefresh = true; }
    } 
}

//唯一模板引用并生成实例数据
function doSingleReference(isNeedHint,curTemplateID,curPrtTemplateID, curTemplateDocID, curPrtTemplateDocID) {
    var newInstanceID = "";
    //1：后台生成新的实例数据
    var objEPRForm = frames['frameTemplate'].eprform;
    objEPRForm.PrnTemplateDocID = curPrtTemplateDocID;
    objEPRForm.TemplateDocID = curTemplateDocID;
    var status = objEPRForm.SaveClick(true, "reference");
    if (status) {
        newInstanceID = objEPRForm.GetRefInstanceID(episodeID, curTemplateID)
        if (isNeedHint) { alert("引用成功!"); }
    } else {
        alert("引用失败!");
        return newInstanceID;
    }
   
    var obj = objEPRForm.StatusAfterSaveNewFrameWork;
    var newLogID = obj.split('^')[2];

    //2: 生成图片预览
    objEPRForm.InvokePreviewService(patientID, episodeID, newLogID, curPrtTemplateID, "Single", "", userID, curPrtTemplateDocID);

    if (curTemplateDocID == templateDocID && !isPageRefresh) {
        isPageRefresh = true;
    }

    return newInstanceID;
}

//获取有效的叶子节点
function getAllLeafNodes(selectedNodes) {
    var selectedLeafNodes = new Array();
    for (var i = 0; i < selectedNodes.length; i++) {
        var node = selectedNodes[i];
        if (!node.attributes.disabled && node.leaf) {
            selectedLeafNodes.push(node);
        }
    }
    return selectedLeafNodes;
}

//找到selectedNode的下一个节点
function findNextSibling(curNode, selectedLeafNodes) {
    var index = -1;
    var result = [];
    for (var i = 0; i < selectedLeafNodes.length; i++) {
        if (selectedLeafNodes[i] == curNode) {
            index = i + 1;
            break;
        }
    }
    if (index >= selectedLeafNodes.length) {
        return null;
    } else {
        result[0] = index;
        result[1] = selectedLeafNodes[index];
        return result;
    }
}

function doClose(isTreeRefresh,isPageRefresh) {
    //alert("isTreeRefresh=" + isTreeRefresh);
    //alert("isPageRefresh=" + isPageRefresh);
    if (!isTreeRefresh) {
        //debugger;
    }
    var win = parent.Ext.getCmp('winReference');
    win.close(this);
}

function check(){
	var flag = false;
	for (var i = 0; i < rootNode.childNodes.length; i++) {
		var subNode = rootNode.childNodes[i];
		//第二层
		for (var j = 0; j < subNode.childNodes.length; j++) {
			var sub2Node = subNode.childNodes[j];
			//第三层
			for (var k = 0; k < sub2Node.childNodes.length; k++) {
				var leafNode = sub2Node.childNodes[k];
				if (leafNode.attributes.disabled && leafNode.leaf) {
					flag = true;
					break;
				}
			}
			if (flag) break;
		}
		if (flag) break;
	}
	return flag;
}