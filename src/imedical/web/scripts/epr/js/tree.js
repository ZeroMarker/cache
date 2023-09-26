function createPatTypeStore() {
    var patTypeStore = new Ext.data.SimpleStore({
        id: 'patTypeStore',
        fields: ["retrunValue", "displayText", "show"],
        proxy: new Ext.data.HttpProxy({ url: '../web.eprajax.amdpattypemanager.cls?EpisodeID=' + episodeID + '&AppType=List' })
    })
    patTypeStore.load();
    patTypeStore.on('load', function(store, record) {
        for (var i = 0; i < store.data.length; i++) {
            if (record[i].data.show == "1") {
                Ext.getCmp("cmbCondition").setValue(record[i].data.retrunValue);
                break;
            }
        }
    });
    return patTypeStore;
}

var patTypeStore = createPatTypeStore();

var treeTbar = [
    '病历: ',
    {
        id: 'cmbCondition',
        xtype: 'combo',
        store: patTypeStore,
        listWidth: 170,
        resizable: false,
        valueField: "retrunValue",
        displayField: "displayText",
        mode: 'local',
        width: 150,
        forceSelection: true,
        emptyText: '请选择',
        editable: false,
        triggerAction: 'all',
        fieldLabel: '',
        value: '',
        listeners:
		{
		    'select': function(combobox, record, index) {
		        Ext.Ajax.request({
		            url: '../web.eprajax.amdpattypemanager.cls',
		            timeout: timedOut,
		            params: { EpisodeID: episodeID, AppType: 'Select', PatType: record.data.retrunValue },
		            success: function(response, opts) {
		                var obj = eval(response.responseText);
		                if (obj == true) {
		                    frames['centerTab'].hideTab();
		                    tree.root.reload();
		                }
		                else {
		                    alert('保存病人类型失败');
		                }
		            },
		            failure: function(response, opts) {
		                var obj = response.statusText;
		                alert(obj);
		            }
		        });
		    }
		}
    }
];



function checkTreeBar() {
    var treeTbarItem = new Ext.ux.ComboBoxTree({
        id: 'cbxRangeTree',
        name: 'cbxRangeTree',
        //xtype: 'combotree',
        width: 150,
        listWidth: 170,
        emptyText: '请选择',
        anchor: '90%',
        tree: new Ext.tree.TreePanel({
            id: 'comboTree',
            name: 'comboTree',
            width: 298,
            anchor: '100%',
            loader: new Ext.tree.TreeLoader({
                dataUrl: '../web.eprajax.amddiagnosmanager.cls?EpisodeID=' + episodeID + '&CurAction=Tree'
            }),
            root: rootNode,
            rootVisible: false,
            listeners: {
                'load': function() {
                    Ext.getCmp('comboTree').expandAll();
                },
                'click': function(node, e) {
                    if (node.attributes['leaf'] == "true") {
                        Ext.Ajax.request({
                            url: '../web.eprajax.amddiagnosmanager.cls',
                            timeout: timedOut,
                            params: { EpisodeID: episodeID, CurAction: 'Select', KBDiagnos: node.id },
                            success: function(response, opts) {
                                var obj = eval(response.responseText);
                                if (obj != true) {
                                    alert('保存病人类型失败');
                                }
                                Ext.getCmp('cbxRangeTree').setValue(node.attributes['text']);
                                Ext.getCmp('cbxRangeTree').collapse();
                            },
                            failure: function(response, opts) {
                                var obj = response.statusText;
                                alert(obj);
                            }
                        });
                    }
                }
            }
        })
    });

    loadInitDiagnos();

    return treeTbarItem;
}

function loadInitDiagnos() {
    Ext.Ajax.request({
        url: '../web.eprajax.amddiagnosmanager.cls',
        timeout: timedOut,
        params: { EpisodeID: episodeID, CurAction: 'Get' },
        success: function(response, opts) {
            Ext.getCmp('cbxRangeTree').setValue(response.responseText);
        },
        failure: function(response, opts) {
            alert(response.responseText);
        }
    });
}

var rootNode = new Ext.tree.AsyncTreeNode({
    text: '请选择',
    nodeType: 'async',
    draggable: false,
    id: "RT0"
});

var treeTbarItem = checkTreeBar();
var treeTbar2 = new Ext.Toolbar({
    id: 'treeTbar2',
    items: [
        '病种: ',
        treeTbarItem
    ]
});  	  	  



var Tree = Ext.tree;
var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.categorytreedata.cls?EpisodeID=" + episodeID});
var tree = new Tree.TreePanel({
    el: "currentDocs",
    rootVisible: false,
    autoScroll: false,
    trackMouseOver: false,
    animate: false,
    //enableDD:true,
    containerScroll: true,
    lines: true,
    checkModel: 'cascade',
    autoHeight: true,
    border: false,
    loader: treeLoader,
    id: "myTree",
    //frame: false,
    tbar: treeTbar,
    listeners: {
        'render': function(){
                treeTbar2.render(this.tbar);
        }
    }
});







var root = new Tree.AsyncTreeNode( {
	text : '电子病历',
	nodeType: 'async',
	draggable : false,
	id : "RT0"
});

//用来负责调用上一页、下一页,不建议修改
treeLoader.on("load", function(tree, node, response) {
    //debugger;
    if (isPrevAuto) {
        //debugger;
        isCallBack = true;
        isPrevAuto = false;
        if (node.childNodes.length > 0) {
            findPreviousSibling(node, response);
        } else {
            isCallBack = false;
        }
    }
    if (isNextAuto) {
        isCallBack = true;
        isNextAuto = false;
        if (node.childNodes.length > 0) {
            findNextSibling(node, response);
        } else {
            isCallBack = false;
        }
    }
});

//抛出异常时的处理			 
treeLoader.on("loadexception", function(tree, node, response) {
	var obj = response.responseText;
	alert(obj);
});

//上次点击的节点
var preNode = null; 

function isNeedSave(node) {
    //debugger;
    var result = false;
    if (!frames['centerTab'].isCategoryChapterLocked) {
        var nodeID = node.id;
        var nodeType = nodeID.substring(0, 2);
        var templateDocID = nodeID.substring(2);
        if (nodeType == "TS") {
            //唯一
            var prtTemplateDocID = node.parentNode.id.substring(2);
            var curTabID = String.format("tabEdit{0}And{1}", templateDocID, prtTemplateDocID);
            var curTab = frames["centerTab"].Ext.getCmp("centerTabPanel").getItem(curTabID);
            if (curTab) {
                result = shiftCurrentTab(curTab);
            }
        } else {
            result = true;
        }
    }
    return result;
}


function   window.confirm(tabName) 
{ 

	execScript("n = MsgBox('是否将更改保存到【"+   tabName   + " 】记录中',3+32,'关闭提示') ", "vbscript" );
	return(n);
}
function shiftCurrentTab(tab) {
    var result = true;
    var tabID = tab.id;
    var tabName = tab.title;

    if (tabID.indexOf('tabEdit') >= 0) {
        var prtIndex = tabID.indexOf("And");
        var templateDocID = tabID.substring(7, prtIndex);
        var prtTemplateDocID = tabID.substring(prtIndex + 3);
        var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
        var centerTabDetial = frames["centerTab"].frames[iframeID];
        if (centerTabDetial) {
            var dll = centerTabDetial.frames['epreditordll'];
            if (null != dll) {
                var eprform = dll.document.getElementById('eprform');
                var changed = eprform.IsValueChanged();
                if (changed) {
                    var status = window.confirm(tabName);
                    if (status==2) {
                        result = false;
                    } else if ( status==7)
                    {
						eprform.ResetUnitState();
                        result = true;
                    }else {
						saveintree(tab)
                        eprform.ResetUnitState();
                        result = true;
                    }
                }
            }
        }
    } 
    return result;
}
function saveintree(tab)
{ 

    var tabID = tab.id;
    var prtIndex = tabID.indexOf("And");
    var templateDocID = tabID.substring(7, prtIndex);
    var prtTemplateDocID = tabID.substring(prtIndex + 3);
    var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
    var centerTabDetial = frames["centerTab"].frames[iframeID];
	centerTabDetial.window.save()


}
//上次锁定的病历 add by LingChen 2011-3-11
var lastCategoryChapterID = "";

function lockCategoryChapter(categoryChapterID, categoryChapterName, needLock)
{
    Ext.Ajax.request({
        url: '../web.eprajax.lockCategoryChapter.cls',
        timeout: parent.parent.timedOut,
        params: { EpisodeID: episodeID, CategoryChapterID: categoryChapterID, LastCategoryChapterID: lastCategoryChapterID},
        success: function (response, opts)
        {
            setLockInfo(response.responseText, categoryChapterName);
        },
        failure: function (response, opts)
        {
            var obj = "锁定当前病历错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;
            alert(obj);
        }
    });
    lastCategoryChapterID = categoryChapterID;
}

var PatientInfo = "";
function setLockInfo(info, categoryChapterName)
{
    //返回锁定者的信息
    if (info != "") {
        frames['centerTab'].isCategoryChapterLocked = true;
        var str = categoryChapterName +  " 正被编辑：" + info;
        //mainpInfo.style.height = 54;  
        //pInfoDivParent.style.height = 54;
        //pInfoDiv.style.height = 54;
        pInfoDiv.innerHTML = '&nbsp;<SPAN class=spanColorLeft style="FONT-SIZE: 8pt;color:red">' + str + '</span><br/>' + PatientInfo;
    }
    else {
        frames['centerTab'].isCategoryChapterLocked = false; 
        //mainpInfo.style.height = 28;   
        //pInfoDivParent.style.height = 28;
        //pInfoDiv.style.height = 28;
        pInfoDiv.innerHTML = PatientInfo;
    }
}
///end

//判断是否保存
tree.on('beforeclick', function(node, e) {
    //debugger;
    if (!node.isLeaf()) { return true; }
    if (preNode != null) {
        var nodeID = preNode.id;
        var nodeType = nodeID.substring(0, 2);
        var templateDocID = nodeID.substring(2);
        if (nodeType == "TS") {
            //唯一
            if (preNode.parentNode) {
                var prtTemplateDocID = preNode.parentNode.id.substring(2);
                var curTabID = String.format("tabEdit{0}And{1}", templateDocID, prtTemplateDocID);
                var curTab = frames["centerTab"].Ext.getCmp("centerTabPanel").getItem(curTabID);
                if (curTab) {
                    return isNeedSave(preNode);
                }
            }
        }
    }
    return true;
});

tree.on('click', function(node, e) {
    //debugger;
    if (!node.isLeaf()) { return; }
    if (e == null) {
        selectTreeNode = node;
        preNode = selectTreeNode;
        return;
    }

    selectTreeNode = node;
    preNode = selectTreeNode;
    var nodeNote = node.id;

    var parentID = node.parentNode.id;
    printTemplateDocId = parentID.substring(2, parentID.length);
    templateDocId = nodeNote.substring(2, nodeNote.length);

    //设置上次点击的父（爷）节的值
    lastSelectParentNode = selectParentNode;
    lastSelectGrandpaNode = selectGrandpaNode;

    //设置本次点击的父（爷）节的值
    selectParentNode = node.parentNode;
    selectGrandpaNode = node.parentNode.parentNode;

    var nodeID = nodeNote.substring(2, nodeNote.length);
    var nodeType = nodeNote.substring(0, 2);

    //用来记录cookie
    var ccID = node.parentNode.parentNode.id.substring(2, node.parentNode.parentNode.id.length);

    //记录加锁信息 add by LingChen 2011-3-11
    var chapterID = node.parentNode.id.substring(2, node.parentNode.id.length);
    var chapterName = node.parentNode.text;
    lockCategoryChapter(chapterID, chapterName, "1");

    var dt = new Date();
    if (frames['centerTab'].frames['tabPortalFrame'].frames['frameRecentTemplate'] != null) {
        frames['centerTab'].frames['tabPortalFrame'].frames['frameRecentTemplate'].saveRecentTemplate(ccID, selectGrandpaNode.text, printTemplateDocId, selectParentNode.text, templateDocId, node.text, currAuthor, dt.format('Y-m-d H:i'));
    }
    if (nodeType == "TS") {
        //debugger;
        frames['centerTab'].createEprEdit(patientID, episodeID, templateDocId, printTemplateDocId, node);
    }
    else if (nodeType == "TM") {
        frames['centerTab'].createEprList(patientID, episodeID, templateDocId, printTemplateDocId, node);
    }
	else {
		var strPath = node.attributes.Url;
	    frames['centerTab'].createPhotoForm(strPath,templateDocId,printTemplateDocId,node);
	}
});

tree.setRootNode(root);
tree.render();

//病历加载后,自动打开第一个界面模板,该方法为root节点加载成功后的回调函数
var firstNodeExpandCallBack = function(node) {
    // 保存病人基本信息 add by LingChen 2011-3-11
    var pInfoDiv = document.getElementById('pInfoDiv');
    PatientInfo = pInfoDiv.innerHTML;
    //判断系统参数,若不为Y,则不打开第一个界面模板
    if ((openFristTemplate == 'N')||(openFristTemplate == '')) {
        return;
    }

    if (openFristTemplate == 'Y') {
        //找到第一个孩子节点
        var firstChild = node.firstChild;
        //判断第一个孩子节点是否为空
        if (firstChild != null) {
            //如果已经到了叶子节点,即界面模板,则触发其click事件
            if (firstChild.isLeaf()) {
                frmMainContent.getEl().unmask();
                firstChild.fireEvent('click', firstChild, 'click');
            }
            //如果不是叶子节点,继续将其展开,回调自己
            else {
                firstChild.expand(false, true, firstNodeExpandCallBack);
            }
        } else {
            //关闭进度条
            frmMainContent.getEl().unmask();
        }
        return;
    } else {    
        var nodeExpandCallBack = function(node) {
            var nodeID = node.id;
            var nodeType = nodeID.substring(0, 2);
            //若是第一层节点展开        
            if (nodeType == 'CG' || nodeType == 'CC') {
                var childNodes = node.childNodes;
                for (var j = 0; j < childNodes.length; j++) {
                    var nodeID = childNodes[j].id;
                    if (nodeID.substring(2, nodeID.length) == openFristTemplate.split('#')[1]) {  //630
                        childNodes[j].expand(false, true, nodeExpandCallBack);
                        break;
                    }
                }
            }
            //若是第二层节点展开
            else {
                var childNodes = node.childNodes;
                for (var k = 0; k < childNodes.length; k++) {
                    var nodeID = childNodes[k].id;
                    if (nodeID.substring(2, nodeID.length) == openFristTemplate.split('#')[2]) { 603
                        frmMainContent.getEl().unmask();
                        childNodes[k].fireEvent('click', childNodes[k], 'click');
                        break;
                    }
                }
            }
        }
        var rootChildNodes = node.childNodes;
        for (var i = 0; i < rootChildNodes.length; i++) {
            var nodeID = rootChildNodes[i].id;
            if (nodeID.substring(2, nodeID.length) == openFristTemplate.split('#')[0]) {  //1
                rootChildNodes[i].expand(false, true, nodeExpandCallBack);
                break;
            }
        }
        frmMainContent.getEl().unmask();

    }
}

//增加进度条
if (openFristTemplate == 'Y')
{
	frmMainContent.getEl().mask('正在打开第一个界面模板,请稍候...', 'x-mask-loading');
}

//将根节点展开
root.expand(false, true, firstNodeExpandCallBack);

if(mainDoc.toLowerCase() != userCode.toLowerCase())
{
    //Ext.getCmp("cmbCondition").disable();			//TMS863，要求注释掉
	Ext.getCmp("btnToSection").disable();		
}

if (isAppointActive == '1')
{
    Ext.getCmp("btnAppoint").enable();
}

//打开常用的打印模板
function openCommonTemplate(event,ccID, prtDocID, templateDocID) {
    //debugger;
    var tree = Ext.getCmp('myTree');
    var root = tree.root;
    frmMainContent.getEl().mask('正在打开,请稍候...', 'x-mask-loading');
    //tree节点展开后的回调函数
    var nodeExpandCallBack = function(node) {
        var nodeID = node.id;
        var nodeType = nodeID.substring(0, 2);
        //若是第一层节点展开
        if (nodeType == 'CG' || nodeType == 'CC') {
            var childNodes = node.childNodes;
            for (var j = 0; j < childNodes.length; j++) {
                var nodeID = childNodes[j].id;
                if (nodeID.substring(2, nodeID.length) == prtDocID) {
                    childNodes[j].expand(false, true, nodeExpandCallBack);
                    break;
                }
            }
        }
        //若是第二层节点展开
        else {
            //若templateDocID为空,将自动打开第一个界面模板
            if (templateDocID == '') {
                var firstChild = node.firstChild;
                frmMainContent.getEl().unmask();
                if (firstChild != null) {
                    firstChild.fireEvent('click', firstChild, event);
                }
                return;
            }

            var childNodes = node.childNodes;
            for (var k = 0; k < childNodes.length; k++) {
                var nodeID = childNodes[k].id;
                if (nodeID.substring(2, nodeID.length) == templateDocID) {
                    frmMainContent.getEl().unmask();
                    childNodes[k].fireEvent('click', childNodes[k], event);
                    break;
                }
            }
        }
    }

    var rootChildNodes = root.childNodes;
    for (var i = 0; i < rootChildNodes.length; i++) {
        var nodeID = rootChildNodes[i].id;
        if (nodeID.substring(2, nodeID.length) == ccID) {
            rootChildNodes[i].expand(false, true, nodeExpandCallBack);
            break;
        }
    }
}

function refreshTree() {
    this.getRootNode().reload();
}