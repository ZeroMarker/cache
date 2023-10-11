/**
 * @author Administrator
 */
/**
* 刷新树
*/
var simpleModel = tkMakeServerCall('Nur.DHCMGNurseSet','getSet');
var modelFlag = simpleModel.split('^')[3];
modelFlag = modelFlag == 'true' ? true : false;

function initMainTree() {
    var modelTree = Ext.getCmp("modelTree");
    var loader = modelTree.getLoader();
    //loader.dataUrl = '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTreeEmr&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&adm=" + EpisodeID + "&groupSort=" + Ext.getCmp("ckbGroup").getValue()+"&regNo="+regNo;
    loader.dataUrl = "../NurMp.TemplateList.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0" + "&IfAllModel=0" + "&ModelFlag=" + modelFlag;
    loader.load(modelTree.getRootNode(), function () {
        modelTree.expandAll();
    });
}
function CreateTree(treeId, ifAllModel, treeHeight) {
	if (treeId == 'modelTree') {
		var loader = new Ext.tree.TreeLoader({
				dataUrl: "../NurMp.TemplateList.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0" + "&IfAllModel=" + ifAllModel + "&ModelFlag=" + modelFlag
			});
	} else {
		var loader = new Ext.tree.TreeLoader({
			dataUrl: "../NurMp.TemplateList.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0" + "&IfAllModel=" + ifAllModel
		});
	}
    var root = new Ext.tree.AsyncTreeNode({});
    var tree = new Ext.tree.TreePanel({
        id: treeId,
        rootVisible: false,
        autoScroll: true,
        animate: true,
        containerScroll: true,
		containerScroll	: true, // 随自身或父容器的改变而显示或隐藏scroll
        lines: true,
        height: treeHeight,
        width: '100%',
        border: true,
        loader: loader
    });
    var rootNode = new Ext.tree.AsyncTreeNode({
        text: '护理病历',
        nodeType: 'async',
        draggable: false,
        id: "RT0"
    });
    tree.setRootNode(rootNode);
    return tree;
}
function initModelForm() {
    Ext.QuickTips.init();
    var modelTree = CreateTree("modelTree", 0, document.body.offsetHeight * 0.92);
    //北边，标题栏   
    var north_item = new Ext.Panel({
        title: '你的公司公司组织架构',
        region: 'north',
        //contentEl: 'north-div',   
        split: true,
        border: true,
        collapsible: true,
        height: 50,
        minSize: 50,
        maxSize: 120
    });
    //南边，状态栏   
    var parr = "DHCNURXH2^" + EpisodeID + "^CaseMeasureXml^";
    var emrknowurl = "" //"dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID;  
    //alert(emrknowurl)
    var south_item = new Ext.Panel({
        title: '版权所有',
        region: 'south',
        //  contentEl: 'south-div',   
        split: true,
        border: true,
        collapsible: true,
        height: 400,
        minSize: 50,
        html: '<iframe id ="southzsk" name="ddd" style="width:100%; height:100%" src=' + emrknowurl + ' ></iframe>',
        maxSize: 120
    });

    //右边   知识库
    var east_item = new Ext.Panel({
        region: 'east',
        //  el: 'center-center',                   
        title: '知识库',
        split: true,
        collapsible: true,
        titlebar: true,
        collapsedTitle: '内容',
        height: 200,
        width: 200,
        minSize: 100,
        maxSize: 400
    });
    //中间的南边,信息列表   
    var center_south_item = new Ext.Panel({
        region: 'center',
        //  contentEl: 'center-south',   
        html: '<iframe id ="centerTab" style="width:100%; height:100%;" src="" ></iframe>',
        split: true,
        collapsible: true,
        //titlebar: true,   
        autoHeight: true,
        collapsedTitle: '内容'
    });
    //中间   
    var center_item = new Ext.Panel({
        region: 'center',
        layout: 'border',
        autoHeight: true,
        items: [center_south_item]
    });
    //西边，后台管理            
    var west_item = new Ext.Panel({
        id: 'modelPanel',
        title: '护理病历',
        region: 'west',
        //  contentEl: 'west-div',   
        split: true,
        border: true,
        collapsible: true,
        width: '21.3%',
        height: document.body.offsetHeight * 0.1,
        //minSize: 120,   
        //maxSize: 200,   
        layout: "absolute",
        colFlag: false,
        //align:'center',
        layoutConfig: {
            animate: true
        },
        /*
        listeners: {
            collapse: function (p, options) {
                p.colFlag = true;
                doRefresh();
            },
            expand: function (p, options) {
                p.colFlag = false;
                doRefresh();
            }
        },
		*/
        items: [modelTree],
        tbar: {
            items: [{
                text: '刷新',
                xtype: 'button',
                id: 'btnTree',
                style: {
                    marginLeft: '1px',
                    border: '1px solid #80C0E0',
                    fontSize: '14px'
                },
                handler: initMainTree
            }, {
                text: '模板选择',
                xtype: 'button',
                id: 'btnModel',
				hidden: modelFlag,
                style: {
                    marginLeft: '10px',
                    border: '1px solid #80C0E0',
                    fontSize: '14px'
                },
                handler: winSelModel
            }]
        }
    });

    new Ext.Viewport({
        layout: "border",
        items: [
            west_item,
            center_item, {
                xtype: "tabpanel",
                enableTabScroll: true,
                //autoWidth: true,
                minTabWidth: 20,
                resizeTabs: true,
                id: "NurTabpanel",
                region: "center",
                items: []
            }]
    });
}
//自适应
function doRefresh() {
    var colFlag = Ext.getCmp('modelPanel').colFlag;
    var nurtab = Ext.getCmp("NurTabpanel");
    // var tabs = nurtab.items.items;
    // tabs.forEach(function(tab) {
    //     tab.sidebarChange = (tab.sidebarChange==true ? false:true);
    // });
    var tabWidth = window.frames.NurTabpanel.children[0].style.width.replace("px", "");
    var activeTab = nurtab.getActiveTab();
    if ((colFlag == true) && (activeTab.addFlag == false)) {
        var currentTab = activeTab.el.id;
        var frameId = 'iframe' + currentTab;
        var preUrl = document.getElementById(frameId).src;
        document.getElementById(frameId).src = preUrl;
        activeTab.addFlag = true;
    } else if ((colFlag == false) && (activeTab.addFlag == true)) {
        var currentTab = activeTab.el.id;
        var frameId = 'iframe' + currentTab;
        var preUrl = document.getElementById(frameId).src;
        document.getElementById(frameId).src = preUrl;
        activeTab.addFlag = false;
    }
    //activeTab.sidebarChange = false;
}
function initModelValue() {
    var modelTree = Ext.getCmp("modelTree");
    modelTree.expandAll();
    modelTree.on('click', function (node, event) {
        nodeclick(node, event);
        winClose();
        return;
    });
}
function winSelModel() {
    var locModelTree = CreateTree("locModelTree", 2, 605);
    var allModelTree = CreateTree("allModelTree", 1, 605);
    var locModPanel = new Ext.Panel({
        id: 'locModPanel',
        split: true,
        border: true,
        width: 300,
        height: 700,
        layout: "absolute",
        layoutConfig: {
            animate: true
        },
        items: [locModelTree]
    });
    var allModPanel = new Ext.Panel({
        id: 'allModPanel',
        split: true,
        border: true,
        width: 300,
        height: 700,
        layout: "absolute",
        layoutConfig: {
            animate: true
        },
        items: [allModelTree]
    });
    var tabs = new Ext.TabPanel({
        id: 'tabs',
        activeTab: 1,
        items: [{
            id: 'localTab',
            title: '本科模板',
            items: [locModPanel]
        }, {
            id: 'allTab',
            title: '全院模板',
            items: [allModPanel]
        }],
        listeners: {
            'tabchange': function (oldTab, newTab) {
                if (newTab.id == "localTab") {
                    locModelTree.expandAll();
                } else {
                    allModelTree.expandAll();
                }
                this.setActiveTab(newTab.id);
            }
        }
    });
    var winModel = new Ext.Window({
        id: 'winModel',
        title: '选择模板',
        x: 300,
        y: 15,
        width: 300,
        height: 700,
        layout: 'absolute',
        tbar: [{
            xtype: 'textfield',
            border: true,
            id: 'modelSearch',
            fieldFabel: '模板名称',
            width: 200,
            handler: winClose
        }, {
            xtype: 'button',
            text: '搜索',
            handler: initTree,
            style: {
                marginLeft: '20px',
                border: '1px solid #80C0E0',
                borderRadius: '5px',
                fontSize: '14px'
            }
        }],
        items: [tabs]
    });
    winModel.show();
    tabs.setActiveTab("localTab");
    var modelSearch = Ext.getCmp('modelSearch');
    modelSearch.on('specialkey', function (field, e) {
        if (e.getKey() == Ext.EventObject.ENTER) {
            initTree();
        }
    });
    locModelTree.on('click', function (node, event) {
        nodeclick(node, event);
        winModel.close();
        return;
    });
    allModelTree.on('click', function (node, event) {
        nodeclick(node, event);
        winModel.close();
        return;
    });
}
function nodeclick(node, e) {

    var nodetype = node.id
    if (nodetype == "RT0") {
        return
    }
    var wardid = node.parentNode.id;
    if (node.leaf == "ture") {
        var nurtab = Ext.getCmp("NurTabpanel");
        var tabpic = nurtab.getComponent("tabpic"); //图片		
        if (!tabpic) {
            var picitm = {};
            picitm.id = "tabpic";
            picitm.title = "图片预览";
            picitm.closable = true;
            var url = "dhcnuremrcomm.csp?EpisodeID=" + EpisodeID + "&EmrCode=DHCNUREMRPIC"
            picitm.html = '<iframe id="' + "tabpicif" + '" scrolling="yes" frameborder="0" width="100%" height="100%" src="' + url + '"> </iframe>'
            picitm.listeners = {
                activate: function (tab) {
                    document.getElementById("tabpicif").src = url
                }
            }
            //nurtab.add(picitm);
        }
        if ((node.id.indexOf("DHCNURXH_WKHLJL") > -1) || ((node.id.indexOf("DHCNURXH2csddd") > -1))) {
            var fheight = window.screen.height;
            var fwidth = window.screen.width;
            var params = "toolbar=no,location=no,left=10,top=10,directories=no,resizable=yes,width=" + fwidth + ",height=" + fheight
            var lnk = "dhcnuremrcomm.csp?" + "&EmrCode=" + node.id + "&EpisodeID=" + EpisodeID//""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
            var paramsmodel = "dialogWidth:" + fwidth + "px;dialogHeight:" + fheight + "px;center:yes;resizable:no;status:no;scroll:YES;help:no;edge:raised;"
            window.open(lnk, "htm2new", params);
            return;
        }
        if (node.id.indexOf("DHCNURPL_PLAN") > -1) {
            var fwidth = window.screen.availWidth - 10
            var fheight = window.screen.availHeight - 20
            var lnk = "dhcnurplaninput.csp?" + "&EpisodeID=" + EpisodeID;//"&DtId="+DtId+"&ExamId="+ExamId
            //alert(lnk)
            window.open(lnk, "htmsdd", 'left=1,top=1,toolbar=no,location=no,directories=no,resizable=yes,width=' + fwidth + ',height=' + fheight + '');
            return;
        }
        var oItem = {};
        var emrCode = tkMakeServerCall("NurMp.TemplateMenuSub", "getCodeByGuid", nodetype);
        var hlurl = emrCode + ".csp?EpisodeID=" + EpisodeID + "&EmrCode=" + node.id
        //var hlurl="dhc.bdp.ext.sys.csp?BDPMENU=780" //+EpisodeID+"&EmrCode="+node.id
        oItem.id = "tab" + node.id;
        oItem.title = node.text;
        oItem.tabTip = node.text;
        oItem.closable = true;
        oItem.addFlag = false;
        oItem.listeners = {
            activate: function (e) {
                //自定义
                if ((Ext.getCmp('modelPanel').colFlag == true) && (e.addFlag == false)) {
                    var frameId = 'iframe' + e.id;
                    var preUrl = document.getElementById(frameId).src;
                    document.getElementById(frameId).src = preUrl;
                    e.addFlag = true;
                } else if ((Ext.getCmp('modelPanel').colFlag == false) && (e.addFlag == true)) {
                    var frameId = 'iframe' + e.id;
                    var preUrl = document.getElementById(frameId).src;
                    document.getElementById(frameId).src = preUrl;
                    e.addFlag = false;
                }
                //alert(nurtab.getActiveTab().addFlag);
                var seltab = e.id.replace("tab", "")
                tkMakeServerCall("NurEmr.DHCNurActiveTabs", "setactivetab", session['LOGON.CTLOCID'], session['LOGON.USERID'], seltab)  //激活的页签
            },
            beforeclose: function () {
                var seltab = node.id.replace("tab", "")
                //alert(seltab)
                tkMakeServerCall("NurEmr.DHCNurActiveTabs", "deletetab", session['LOGON.CTLOCID'], session['LOGON.USERID'], seltab)  //保存打开的页签

            }
        }
        var frameid = "iframe" + oItem.id;

        oItem.html = '<iframe id="'
            + frameid
            + '" scrolling="yes" frameborder="0" width="100%" height="100%" src="'
            + hlurl + '"> </iframe>'
        nurtab.add(oItem);
        nurtab.setActiveTab("tab" + node.id);
        if (node.id == "DHCNURXH_YBHLJLD") tkMakeServerCall("NurEmr.DHCNurActiveTabs", "Save", session['LOGON.CTLOCID'], session['LOGON.USERID'], node.id + "|" + node.text)  //保存打开的页签
        savelog(EpisodeID, node.id);
        //addblurl()

    }

}
//保存日志
function savelog(adm, code) {
    //alert(adm)
    var ModelName = "DHC.Query.NurseEmr"
    var MoudName = tkMakeServerCall("NurMp.TemplateMenuSub", "getCodeByGuid", code)
    var Condition = "";
    Condition = Condition + '{"EmrCode":"' + MoudName + "(" + code + ")" + '",';
    Condition = Condition + '"episodeID":"' + adm + '",';
    Condition = Condition + '"userName":"' + session['LOGON.USERNAME'] + '",';
    Condition = Condition + '"userID":"' + session['LOGON.USERID'] + '"}';
    var ConditionAndContent = Condition;
    //alert(ConditionAndContent)
    var ret = tkMakeServerCall("web.DHCEventLog", "EventLog", ModelName, ConditionAndContent, ConditionAndContent, "", "Y")  //保存平台组日志
    //alert(ret)
}
function nodeclickold(node, e) {
    var nodetype = node.id
    if (nodetype == "RT0") {
        return
    }
    var wardid = node.parentNode.id;
    if (node.leaf == "ture") {
        var nurtab = Ext.getCmp("NurTabpanel");
        nurtab.resizeTabs = true;
        var tabpic = nurtab.getComponent("tabpic"); //图片		
        if (!tabpic) {
            var picitm = {};
            picitm.id = "tabpic";
            picitm.title = "图片预览";
            picitm.closable = true;
            var url = "dhcnuremrcomm.csp?EpisodeID=" + EpisodeID + "&EmrCode=DHCNUREMRPIC"
            picitm.html = '<iframe id="' + "tabpicif" + '" scrolling="yes" frameborder="0" width="100%" height="100%" src="' + url + '"> </iframe>'
            picitm.listeners = {
                activate: function (tab) {
                    document.getElementById("tabpicif").src = url
                }
            }
            //nurtab.add(picitm);
        }
        var oItem = {};
        var hlurl = "dhcnuremrcomm.csp?EpisodeID=" + EpisodeID + "&EmrCode=" + node.id
        oItem.id = "tab" + node.id;
        oItem.title = node.text;
        oItem.tabTip = node.text;
        oItem.closable = true;
        oItem.listeners = {
            activate: function (tab) {
                var parr = node.id + "^" + EpisodeID + "^CaseMeasureXml^";
                var emrknowurl = "dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr=" + parr + "&EpisodeID=" + EpisodeID;
                //alert(emrknowurl)
                // document.getElementById("southzsk").src= emrknowurl
            }
        }
        var frameid = "iframe" + oItem.id;
        oItem.html = '<iframe id="'
            + frameid
            + '" scrolling="yes" frameborder="0" width="100%" height="100%" src="'
            + hlurl + '"> </iframe>'
        nurtab.add(oItem);
        nurtab.setActiveTab("tab" + node.id);
    }

}
function winClose() {
    if (Ext.getCmp("winModel")) {
        Ext.getCmp("winModel").close();
    }
}
function initTree() {
    var modelName = Ext.getCmp("modelSearch").getValue();
    modelName = tkMakeServerCall("Nur.DHCNurMyInterface", "GetModelWords", modelName);
    //modelName="首次";
    var modelTree = Ext.getCmp("allModelTree");
    var ifAllModel = 1;
    var tabs = Ext.getCmp("tabs");
    if (tabs.getActiveTab().id == "localTab") {
        modelTree = Ext.getCmp("locModelTree");
        ifAllModel = 2;
    }
    var loader = modelTree.getLoader();
    //loader.dataUrl = '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTreeEmr&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&adm=" + EpisodeID + "&groupSort=" + Ext.getCmp("ckbGroup").getValue()+"&regNo="+regNo;
    loader.dataUrl = "../NurMp.TemplateList.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0" + "&IfAllModel=" + ifAllModel + "&SearchCode=" + modelName;
    loader.load(modelTree.getRootNode(), function () {
        modelTree.expandAll();
    });
}
Ext.onReady(function () {
    initModelForm();
    initModelValue();

    var opend = tkMakeServerCall("NurEmr.DHCNurActiveTabs", "getval", session['LOGON.CTLOCID'], session['LOGON.USERID'])
    var arr1 = opend.split("$")

    var nurtab = Ext.getCmp("NurTabpanel");
    if (arr1[0] != "") {
        var arrs = arr1[0].split("^")
        for (var k = 0; k < arrs.length; k++) {
            var itm = arrs[k];
            if (itm == "") continue;
            var arrsub = itm.split("|")
            var acode = arrsub[0];
            var atitle = arrsub[1]
            //alert(acode)
            var hlurl = "dhcnuremrcomm.csp?EpisodeID=" + EpisodeID + "&EmrCode=" + acode
            nurtab.add({
                id: "tab" + acode,
                title: atitle,
                tabTip: atitle,
                closable: true,
                addFlag: false,
                html: '<iframe id="'
                    + "tab" + acode
                    + '" scrolling="yes" frameborder="0" width="99%" height="100%" src="'
                    + hlurl + '"> </iframe>',
                listeners: {
                    activate: function (e) {
                        e.addFlag = true;
                        //alert(e.id)
                        var seltab = e.id.replace("tab", "")
                        tkMakeServerCall("NurEmr.DHCNurActiveTabs", "setactivetab", session['LOGON.CTLOCID'], session['LOGON.USERID'], seltab)  //激活的页签
                    },
                    beforeclose: function (e) {
                        //alert(e.id)
                        var seltab = e.id.replace("tab", "")
                        //alert(seltab)
                        tkMakeServerCall("NurEmr.DHCNurActiveTabs", "deletetab", session['LOGON.CTLOCID'], session['LOGON.USERID'], seltab)  //保存打开的页签								
                    }
                }

            })
            //alert(arr1[1])

        }
        if (arr1[1] != "") {

            var acode = "tab" + arr1[1];
            nurtab.setActiveTab(acode);
        }
    }
});