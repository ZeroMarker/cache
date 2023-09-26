Ext.QuickTips.init();

function getCenterTabPanel() {
    var nTabPanel = new Ext.TabPanel({
        id: 'centerTabPanel',
        border: false,
        activeTab: 0,
        minTabWidth: 120,
        resizeTabs: true,
        deferredRender: false,
        enableTabScroll: false,
        defaults: { autoScroll: false },
        draggable: false,
        listeners: {
            beforeremove: function(tabPanel, tab) {
                // debugger;
                if (htNodes.containsKey(tab.id)) {
                    return shiftCurrentTab(tab, true);
                }
            },
            beforetabchange: function(tabPanel, newTab, curTab) {
                // debugger;
                if (curTab && curTab.id.indexOf("tabPortal") == -1) {
                    return shiftCurrentTab(curTab, false);
                }
                return true;
            },
            tabchange: function(tabpanel, tab) {
                // debugger;
                var tabID = tab.id;
                if (tabID.indexOf('tabEPRList') >= 0) {
                    setEPRTreeNode(tabID);
                } else if (tabID.indexOf('tabEdit') >= 0) {
                    setEPRTreeNode(tabID);
                } else if (tabID.indexOf('tabListEdit') >= 0) {
                    // debugger;
                    var tmpIndex = tabID.indexOf("And");
                    var prtIndex = tabID.lastIndexOf("And");
                    var templateDocID = tabID.substring(11, tmpIndex);
                    var prtTemplateDocID = tabID.substring(tmpIndex + 3, prtIndex);
                    var eprNum = tabID.substring(prtIndex + 3);
                    var parTabID = String.format("tabEPRList{0}And{1}", templateDocID, prtTemplateDocID);
                }
            }
        },
        items: [{
            id: 'tabPortal',
            border: false,
            title: '欢迎页面',
            layout: 'fit',
            html: '<iframe id="tabPortalFrame" style="width:100%; height:100%" src="" ></iframe>',
            closable: false
        }]
    });
    return nTabPanel;
}

// 唯一模板操作添加快捷键【保存(F7)、提交(F8)、打印(F9)】
function addEPREditShortCut(iframeID) {
    if (frames[iframeID] != null) {
        var map = new Ext.KeyMap(Ext.getDoc(), {
            key: 118, // F7
            fn: function() {
				
                frames['centerTab'].frames[iframeID].save();
            },
            scope: this
        });

        var map = new Ext.KeyMap(Ext.getDoc(), {
            key: 119, // F8
            fn: function() {
                frames['centerTab'].frames[iframeID].commit();
            },
            scope: this
        });

        map.addBinding({
            key: 120, // F9
            fn: function() {
                frames['centerTab'].frames[iframeID].print();
            },
            scope: this
        });
    }
}

// 历次模板操作添加快捷键【新建(F2)、打印(F9)】
function addEPRListShortCut(iframeID) {
    if (frames[iframeID] != null) {
        var map = new Ext.KeyMap(Ext.getDoc(), {
            key: 113, // F2
            fn: function() {
                // Ext.Msg.alert('KEY MAP', 'tree页面You just hit F7');
                frames['centerTab'].frames[iframeID].newList();
            },
            scope: this
        });

        map.addBinding({
            key: 120, // F9
            fn: function() {
                frames['centerTab'].frames[iframeID].print();
            },
            scope: this
        });
    }
}

//Add by LiangWeixi 用于删除可重复模板后移除对应页签
function removeEprListEdit(templateDocID, prtDocID, eprNum) {
    //var tabPanel = frames["centerTab"].Ext.getCmp("centerTabPanel");
	var tabPanel = Ext.getCmp('centerTabPanel');
    //var iframeID = String.format("iframe{0}And{1}", prtDocID, eprNum);
    var clsTabID = String.format("tabListEdit{0}And{1}And{2}", templateDocID, prtDocID, eprNum);
    //parent.frmMainContent.getEl().mask('载入数据,请稍候...', 'x-mask-loading');
	tabPanel.remove(clsTabID)
    //tabPanel.setActiveTab(newTabID);
}

function removeSamePrtDocIDTab(oldPrtDocID) {
    // debugger;
    var tabPanel = Ext.getCmp("centerTabPanel");
    var tabEndIndex = tabPanel.items.items.length - 1;
    if (tabEndIndex < 0) {	return;}
    
    for (var i = tabEndIndex; i >= 0; i--) {
        var currentTab = tabPanel.items.items[i];
        if (currentTab.id.indexOf("tabEdit") >= 0) {
            var tabID = currentTab.id;
            var prtIndex = tabID.indexOf("And");
            var templateDocID = tabID.substring(7, prtIndex);
            var prtTemplateDocID = tabID.substring(prtIndex + 3);
            if (prtTemplateDocID == oldPrtDocID) {
                tabPanel.remove(currentTab);
                if (htNodes.containsKey(tabID)) {
                    htNodes.remove(tabID);
                }
            }
        }
    }
}

function setEPRTreeNode(tabID) {
    // debugger;
    if (htNodes.containsKey(tabID)) {
        var node = htNodes.get(tabID);
        parent.selectTreeNode = node;
        var tree = parent.Ext.getCmp('myTree');

        tree.fireEvent('click', node, null);

        if (tabID.indexOf('tabEdit') >= 0) {
            var prtIndex = tabID.indexOf("And");
            var templateDocID = tabID.substring(7, prtIndex);
            var prtTemplateDocID = tabID.substring(prtIndex + 3);
            var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
            if (frames[iframeID].refresh) {
                frames[iframeID].refresh(episodeID, patientID, templateDocID, prtTemplateDocID);
            }
        } else if (tabID.indexOf('tabEPRList') >= 0) {
            var prtIndex = tabID.indexOf("And");
            var templateDocID = tabID.substring(10, prtIndex);
            var prtTemplateDocID = tabID.substring(prtIndex + 3);
            var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
            if (frames[iframeID].refresh) {
                frames[iframeID].refresh();
            }
        }
    }
}

function window.confirm(tabName) 
{ 

	execScript("n = MsgBox('是否将更改保存到【"+   tabName   + " 】记录中',3+32,'关闭提示') ", "vbscript" );
	return(n);
} 
function shiftCurrentTab(tab, isNeedDelete) {
    var result = true;
    var tabID = tab.id;
    var tabName = tab.title;

    if (tabID.indexOf('tabEdit') >= 0) {
        var prtIndex = tabID.indexOf("And");
        var templateDocID = tabID.substring(7, prtIndex);
        var prtTemplateDocID = tabID.substring(prtIndex + 3);
        var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
        var centerTabDetial = frames[iframeID];
        if (centerTabDetial) {
            var dll = centerTabDetial.frames['epreditordll'];
            if (null != dll) {
                var eprform = dll.document.getElementById('eprform');
                if (eprform) {
                    var changed = eprform.IsValueChanged();
                    if (changed) {
                        var status = window.confirm(tabName);
						// 是-6 否-7 取消-2
                        if (status==2) {
                            result = false;
                        } 
						else if (status==7)
						{
                            if (isNeedDelete) {
                                htNodes.remove(tabID);
                            } else {
                                eprform.ResetUnitState();
                            }
                            result = true;
                        }else{
							// 执行保存函数
							saveincenterTab(tab)
                            if (isNeedDelete) {
                                htNodes.remove(tabID);
                            } else {
                                eprform.ResetUnitState();
                            }
                            result = true;
                        }
                    }
                }
            }
        }
    } else if (tabID.indexOf('tabListEdit') >= 0) {
        // debugger;
        var tmpIndex = tabID.indexOf("And");
        var prtIndex = tabID.lastIndexOf("And");
        var templateDocID = tabID.substring(11, tmpIndex);
        var prtTemplateDocID = tabID.substring(tmpIndex + 3, prtIndex);
        var eprNum = tabID.substring(prtIndex + 3);
        var iframeID = String.format("iframe{0}And{1}", prtTemplateDocID, eprNum);
        var centerTabListDetial = frames[iframeID];
        if (centerTabListDetial) {
            var dll = centerTabListDetial.frames['eprlisteditordll'];
            if (null != dll) {
                var eprform = dll.document.getElementById('eprlistedit');
                if (eprform) {
                    var changed = eprform.IsValueChanged();
                    if (changed) {
                        var status = window.confirm(tabName);
                        if (status==2) {
                            result = false;
                        } 
						else if (status==7)
                        {
                            if (isNeedDelete) {
                                htNodes.remove(tabID);
                            } else {
                                eprform.ResetUnitState();
                            }
                            result = true;
                        }
						else 
						{
							// 执行保存函数
							saveincenterTab(tab)
                            if (isNeedDelete) {
                                htNodes.remove(tabID);
                            } else {
                                eprform.ResetUnitState();
                            }
                            result = true;
                        }
                    }
                }
            }
        }
    }
    return result;
}
// 保存

function saveincenterTab(tab) {

    var tabID = tab.id;
	if (tabID.indexOf('tabEdit') >= 0) {
        var prtIndex = tabID.indexOf("And");
        var templateDocID = tabID.substring(7, prtIndex);
        var prtTemplateDocID = tabID.substring(prtIndex + 3);
        var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
        var centerTabDetial = frames[iframeID];
		centerTabDetial.window.save();
        
	}
	else if (tabID.indexOf('tabListEdit') >= 0) {
		
		var tmpIndex = tabID.indexOf("And");
        var prtIndex = tabID.lastIndexOf("And");
        var templateDocID = tabID.substring(11, tmpIndex);
        var prtTemplateDocID = tabID.substring(tmpIndex + 3, prtIndex);
        var eprNum = tabID.substring(prtIndex + 3);
        var iframeID = String.format("iframe{0}And{1}", prtTemplateDocID, eprNum);
        var centerTabListDetial = frames[iframeID];
        centerTabListDetial.window.save();
	}
}










// 防止内存泄露,目前不用
function gbg(contentIframe) {
    // contentIframe.document.write("");
    contentIframe.src = "javascript:false";
    contentIframe.removeNode(true);
    // contentIframe.parentNode.removeChild(contentIframe);
    contentIframe.document.clear();
    contentIframe = null;
    CollectGarbage();
}

// 隐藏TabList
function hideTab() {
    hideTabList();
    hideTabEdit();
    var tab = Ext.getCmp('centerTabPanel');
    isShowHelpQuality();
}

// 隐藏TabList和TabListEdit
function hideTabList() {
    var tabPanel = Ext.getCmp('centerTabPanel');
    
    // 判断tabeprlist是否存在,若存在则直接隐藏
    var tabList = tabPanel.getActiveTab();
    if (tabList) {
        tabPanel.hideTabStripItem(tabList);
    }
    
    // 判断tabeprlistedit是否存在,若存在则直接隐藏
    var tabListEdit = Ext.getCmp('tabEprListEdit');
    if (tabListEdit) {
        tabPanel.hideTabStripItem(tabListEdit);
        if (frames['centerTabListDetial'].closeInterval) {
            frames['centerTabListDetial'].closeInterval();
        }
    }
}

// 隐藏TabEdit
function hideTabEdit() {
    var tab = Ext.getCmp('centerTabPanel');
    var tabEdit = Ext.getCmp('tabEprEdit');

    // 判断tabEprEdit是否存在,若存在则直接隐藏
    if (tabEdit) {
        tab.hideTabStripItem(tabEdit);
        if (frames['centerTabDetial'].closeInterval) {
            frames['centerTabDetial'].closeInterval();
        }
    }
}

// 病历是否被锁定
var isCategoryChapterLocked = false;

// 创建EprEdit
function createEprEdit(patientID, episodeID, templateDocID, prtTemplateDocID, node) {
    // debugger;
    var tabPanel = Ext.getCmp('centerTabPanel');
    var curTabID = String.format("tabEdit{0}And{1}", templateDocID, prtTemplateDocID);

    var tabEPREdit = Ext.getCmp(curTabID);
    var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
    var frameUrl = 'epr.newfw.centertabdetial.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocID + '&printTemplateDocId=' + prtTemplateDocID;

    // 第一次创建
    if (!tabEPREdit) {
        parent.frmMainContent.getEl().mask('载入数据,请稍候...', 'x-mask-loading');
        
        // debugger;
        var curTabIndex = 0;
        if (tabPanel.items.length > ShowCenterTabCount) {
            var replaceTab = getReplaceTab();
            if (replaceTab) {
                curTabIndex = tabPanel.items.findIndex('id', replaceTab.id);
                tabPanel.remove(replaceTab.id);
                htNodes.remove(replaceTab.id);                
            }
        }
        htNodes.add(curTabID, node);
        addEPREditShortCut(iframeID);

        if (curTabIndex > 0) {
            tabPanel.insert(curTabIndex, {
                id: curTabID,
                title: node.text,
                border: false,
                layout: 'fit',
                tabTip: node.text,
                html: '<iframe id="' + iframeID + '" style="width:100%; height:100%" src=' + frameUrl + '></iframe>',
                closable: true
            }).show();
        } else {
            tabPanel.add({
                id: curTabID,
                title: node.text,
                border: false,
                layout: 'fit',
                tabTip: node.text,
                html: '<iframe id="' + iframeID + '" style="width:100%; height:100%" src=' + frameUrl + '></iframe>',
                closable: true
            }).show();
        }
    } else {
        // debugger;
        // 判断同步加载是否完成,若未完成则直接返回
        if (frames[iframeID] == null) {
            alert(String.format("正在加载页面,请稍后操作!加载中代码: frames[{0}] is null", iframeID));
        } else {
            if (frames[iframeID].syncLoadEnd == true) {
                // alert('正在加载页面,请稍后操作!加载中代码:syncLoadEnd is false');
                // 激活当前tab
                tabPanel.setActiveTab(curTabID);
            } else {
                ajaxCreateEprEdit(patientID, episodeID, templateDocID, prtTemplateDocID);
                frames[iframeID].syncLoadEnd = true;
            }
        }
    }
}

function getReplaceTab() {
    var tabPanel = Ext.getCmp('centerTabPanel');
    var replaceTab = tabPanel.getActiveTab();
    var curTabIndex = tabPanel.items.findIndex('id', replaceTab.id);
    // debugger;
    for (var i = tabPanel.items.items.length - 1; i > 0; i--) {
        var curTab = tabPanel.items.items[i];
        if (curTab.id.indexOf("tabEPRList") < 0) {
            replaceTab = curTab;
            break;
        }
    }
    return replaceTab; 
}

// 异步加载唯一模板数据
function ajaxCreateEprEdit(patientID, episodeID, templateDocID, prtTemplateDocID) {
    var tabPanel = Ext.getCmp('centerTabPanel');
    parent.frmMainContent.getEl().mask('载入数据,请稍候...', 'x-mask-loading');

    var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
    addEPREditShortCut(iframeID);
    frames[iframeID].frames['epreditordll'].setVisibility('hidden');

    Ext.Ajax.request({
        url: '../web.eprajax.ajaxCreateEprEdit.cls',
        timeout: parent.parent.timedOut,
        params: { episodeID: episodeID, patientID: patientID, templateDocId: templateDocID, printTemplateDocId: prtTemplateDocID },
        success: function(response, opts) {
            // debugger;
            if (response.responseText == 'sessionTimedOut') {
                document.getElementById(iframeID).src = 'epr.newfw.sessiontimedout.csp';
                parent.frmMainContent.getEl().unmask();
                return;
            }

            // 设置页面上的相关变量的值
            var obj = eval("[{" + response.responseText + "}]");

            frames[iframeID].canView = obj[0].canView;
            frames[iframeID].canSave = obj[0].canSave;
            frames[iframeID].canPrint = obj[0].canPrint;
            frames[iframeID].canCommit = obj[0].canCommit;
            frames[iframeID].canSwitch = obj[0].canSwitch;
            frames[iframeID].canReference = obj[0].canReference;
            frames[iframeID].canSwitchTemplate = obj[0].canSwitchTemplate;
            frames[iframeID].canChiefCheck = obj[0].canChiefCheck;
            frames[iframeID].canAttendingCheck = obj[0].canAttendingCheck;

            frames[iframeID].templateID = obj[0].bindTemplateID;
            frames[iframeID].printTemplateDocId = prtTemplateDocID;
            frames[iframeID].templateDocId = templateDocID;
            frames[iframeID].bindPrnTemplateID = obj[0].bindPrintTemplateID;
            frames[iframeID].currState = obj[0].currState;
            frames[iframeID].pInfo = obj;
            frames[iframeID].divStateServer = obj[0].divStateServer;
            frames[iframeID].necessaryTemplate = obj[0].necessaryTemplate;
            // frames[iframeID].setPatientInfo(obj);
            frames[iframeID].setEprState(obj[0].divStateServer);
            frames[iframeID].EPRNum = obj[0].EPRNum; 	
            frames[iframeID].printAfterCommit = obj[0].printAfterCommit; 

            // 显示当前tab
            var curTabID = String.format("tabEdit{0}And{1}", templateDocID, prtTemplateDocID);
            tabPanel.unhideTabStripItem(curTabID);
            
            // 激活当前tab
            tabPanel.setActiveTab(curTabID);
            
            // 设置权限
            frames[iframeID].setPower();

            // 设置dll值
            var eprEditDll = frames[iframeID].frames['epreditordll'].document.getElementById("eprform");
            eprEditDll.ChartItemID = templateDocID;
            eprEditDll.ProfileID = templateDocID;
            if (obj[0].canView == "1") {
                eprEditDll.Browsable = "True";
            } else {
                eprEditDll.Browsable = "False";
            }
            
            if (frames[iframeID].revision == 'Y') {
                if (obj[0].currState != "commited" && obj[0].currState != "attendingChecked" && obj[0].currState != "chiefChecked") {
                    eprEditDll.Revisionable = "False";
                }
                else {
                    eprEditDll.Revisionable = "True";
                }
            } else {
                eprEditDll.Revisionable = "False";
            }
            // eprEditDll.InitForm();
            // 取消加载中动画
            parent.frmMainContent.getEl().unmask();
            frames[iframeID].frames['epreditordll'].setVisibility('visible');
            // 异步加载完成
            frames[iframeID].syncLoadEnd = true;
        },
        failure: function(response, opts) {
            var obj = "数据加载失败,请稍后在试,错误代码:" + response.status + "," + "错误信息:" + response.statusText;
            alert(obj);
            parent.frmMainContent.getEl().unmask();
        }
    });
}

// 创建EprList
function createEprList(patientID, episodeID, templateDocID, prtTemplateDocID, node) {
    var tabPanel = Ext.getCmp('centerTabPanel');
    var tabEPRListID = String.format("tabEPRList{0}And{1}", templateDocID, prtTemplateDocID);
    var tabEPRList = Ext.getCmp(tabEPRListID);
    var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
    var frameUrl = 'epr.newfw.centertablist.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocID + '&printTemplateDocId=' + prtTemplateDocID;

    // 第一次创建
    if (!tabEPRList) {
        var activeTabIndex = 0;
        if (tabPanel.items.length > ShowCenterTabCount) {
            var activeTab = tabPanel.getActiveTab();
            activeTabIndex = tabPanel.items.findIndex('id', activeTab.id);
            tabPanel.remove(activeTab.id);
            htNodes.remove(activeTab.id);
        }
        htNodes.add(tabEPRListID, node);
        addEPRListShortCut(iframeID);
        if (activeTabIndex > 0) {
            tabPanel.insert(activeTabIndex, {
                id: tabEPRListID,
                border: false,
                title: node.text,
                layout: 'fit',
                tabTip: node.text,
                html: '<iframe scrolling="auto" marginwidth=0 marginheight=0 id="' + iframeID + '" style="width:100%; height:100%" src=' + frameUrl + '></iframe>',
                closable: true
            }).show();
        } else {
            tabPanel.add({
                id: tabEPRListID,
                border: false,
                title: node.text,
                layout: 'fit',
                tabTip: node.text,
                html: '<iframe scrolling="auto" marginwidth=0 marginheight=0 id="' + iframeID + '" style="width:100%; height:100%" src=' + frameUrl + '></iframe>',
                closable: true
            }).show();
        }
    } else {
        // 若已经创建,同步
        // debugger;
        if (parent.selectGrandpaNode != parent.lastSelectGrandpaNode) {
            if (frames[iframeID] != null) {
                frames[iframeID].syncLoadEnd = false;
            }
            tabPanel.unhideTabStripItem(tabEPRListID);
            document.getElementById(iframeID).src = frameUrl;
            tabPanel.setActiveTab(tabEPRListID);
        }
        // 判断同步加载是否完成,若未完成则直接返回
        if (frames[iframeID] == null) {
            alert(String.format("正在加载页面,请稍后操作!加载中代码: frames[{0}] is null", iframeID));
        } else {
            if (frames[iframeID].syncLoadEnd == true) {
                // alert('正在加载页面,请稍后操作!加载中代码:syncLoadEnd is false');
                tabPanel.unhideTabStripItem(tabEPRListID);
                tabPanel.setActiveTab(tabEPRListID);
            }
            // 异步
            else if (parent.selectGrandpaNode == parent.lastSelectGrandpaNode) {
                frames[iframeID].syncLoadEnd = true;
                ajaxCreateEprList(patientID, episodeID, templateDocID, prtTemplateDocID);
            }
        }
    }
}

// 异步加载历次病程列表界面
function ajaxCreateEprList(patientID, episodeID, templateDocID, prtTemplateDocID) {
    var tabPanel = Ext.getCmp('centerTabPanel');
    var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
    var tabEPRListID = String.format("tabEPRList{0}And{1}", templateDocID, prtTemplateDocID);
    parent.frmMainContent.getEl().mask('载入数据,请稍候...', 'x-mask-loading');

    Ext.Ajax.request({
        url: '../web.eprajax.ajaxCreateEprList.cls',
        timeout: parent.parent.timedOut,
        params: { episodeID: episodeID, patientID: patientID, templateDocId: templateDocID, printTemplateDocId: prtTemplateDocID },
        success: function(response, opts) {
            if (response.responseText == 'sessionTimedOut') {
                document.getElementById(iframeID).src = 'epr.newfw.sessiontimedout.csp';
                parent.frmMainContent.getEl().unmask();
                return;
            }
            // 设置页面上的相关变量的值
            var obj = eval(response.responseText);
            frames[iframeID]._PrtTemplateDocID = prtTemplateDocID;
            frames[iframeID]._TemplateDocID = templateDocID;

            frames[iframeID].canView = obj[0].canView;
            frames[iframeID].canSave = obj[0].canSave;
            frames[iframeID].canPrint = obj[0].canPrint;
            frames[iframeID].canCommit = obj[0].canCommit;
            frames[iframeID].canSwitch = obj[0].canSwitch;
            frames[iframeID].canSwitchTemplate = obj[0].canSwitchTemplate;
            frames[iframeID].canChiefCheck = obj[0].canChiefCheck;
            frames[iframeID].canAttendingCheck = obj[0].canAttendingCheck;
            frames[iframeID].printAfterCommit = obj[0].printAfterCommit;

            frames[iframeID]._ProfileID = obj[0].ProfileID;
            frames[iframeID]._CategoryID = obj[0].CategoryID;
            frames[iframeID]._PageTitle = obj[0].PageTitle;
            frames[iframeID]._CategoryType = obj[0].CategoryType;
            frames[iframeID]._TemplateID = obj[0].TemplateID;
            frames[iframeID]._TemplateName = obj[0].TemplateName;

            frames[iframeID].Ext.getDom('chkSelectAll').nextSibling.innerText = '只显示< ' + frames[iframeID]._PageTitle + ' >';

            // 显示当前tab
            tabPanel.unhideTabStripItem(tabEPRListID);
            
            // 激活当前tab
            tabPanel.setActiveTab(tabEPRListID);
            
            // 设置权限
            frames[iframeID].setPower();

            // 取消加载中动画
            parent.frmMainContent.getEl().unmask();

            // 异步加载完成
            frames[iframeID].syncLoadEnd = true;

            // 加载历次列表
            if (frames[iframeID].Ext.getCmp('chkSelectAll').getValue() == true) {
                frames[iframeID].ajaxAction();
            }
            return;
        },
        failure: function(response, opts) {
            var obj = "数据加载失败,请稍后在试!错误代码:" + response.status + "," + "错误信息:" + response.statusText;
            alert(obj);
            parent.frmMainContent.getEl().unmask();
        }
    });
}

// 新建可重复模板记录
function createEprListEdit(patientID, episodeID, categoryID, categoryType, chartItemID, profileID, templateID, templateName, templateDocID, eprListNo) 
{
    var prtDocID = chartItemID.substring(2);
    var lstTitle = "新建" + templateName;
    var iframeID = String.format("iframe{0}And{1}", prtDocID, eprListNo);
    var frameUrl = 'epr.newfw.centertablistdetial.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID + '&TemplateID=' + templateID + '&CategoryID=' + categoryID + '&CategoryType=' + categoryType + '&ChartItemID=' + chartItemID + '&ProfileID=' + profileID + '&TemplateDocID=' + templateDocID;
    var iframeScript = '<iframe id="'+iframeID + '" style="width:100%; height:100%" src="' + frameUrl + '" ></iframe>';
    initEprListEdit(frameUrl, iframeScript,templateDocID, prtDocID, eprListNo, lstTitle);
}

// 打开可重复模板记录
function OpenRecordClickHandler(episodeID, categoryID, profileID, instanceID, eprNum, chartID, patientID, logRowID,templateDocID, prtDocID, lstTitle, happenDate) 
{
    // debugger;
    var iframeID = String.format("iframe{0}And{1}", prtDocID, eprNum);
	var frameUrl = 'epr.newfw.centertablistdetial.csp?EpisodeID=' + episodeID + '&CategoryID=' + categoryID + '&ProfileID=' + profileID + '&InstanceDataID=' + instanceID + '&State=old&EPRNum=' + eprNum + '&ChartItemID=' + chartID  + '&PatientID=' + patientID + '&LogRowID=' + logRowID + '&prtDocID=' + prtDocID + '&TemplateDocID=' + templateDocID;
	var iframeScript = '<iframe id="' + iframeID + '" style="width:100%; height:100%" src="' + frameUrl + '" ></iframe>';
	initEprListEdit(frameUrl, iframeScript, templateDocID, prtDocID, eprNum, lstTitle, happenDate);
}

function initEprListEdit(frameUrl, iframeScript, templateDocID, prtDocID, eprNum, lstTitle, happenDate) {
    var tabPanel = Ext.getCmp('centerTabPanel');
    var iframeID = String.format("iframe{0}And{1}", prtDocID, eprNum);
    var newTabID = String.format("tabListEdit{0}And{1}And{2}", templateDocID, prtDocID, eprNum);
    
    var tabEPRListEdit = Ext.getCmp(newTabID);
    if (!tabEPRListEdit) {
        if (tabPanel.items.length > ShowCenterTabCount) {
            var removingTab = getRemovingTab();
            if (removingTab) {
                tabPanel.remove(removingTab.id);
            }
        }
        htNodes.add(newTabID, null);
        addEPRListShortCut(iframeID);
        parent.frmMainContent.getEl().mask('载入数据,请稍候...', 'x-mask-loading');
        
        var curTabTip = lstTitle;
        var curTabTitle = lstTitle;
        if (happenDate != null) {
            curTabTip = String.format("{0},{1}", lstTitle, happenDate);
            curTabTitle = String.format("{0}{1}", lstTitle, happenDate.substring(5));
        }
        tabPanel.add({
            id: newTabID,
            border: false,
            title: curTabTitle,
            layout: 'fit',
            html: iframeScript,
            tabTip: curTabTip,
            closable: true
        });
    } else {
        tabPanel.unhideTabStripItem(tabEPRListEdit);
        frames[iframeID].document.body.innerText = '加载中……';
        document.getElementById(iframeID).src = frameUrl;
    }

    tabPanel.setActiveTab(newTabID);
}

function getRemovingTab() {
    var tabPanel = Ext.getCmp('centerTabPanel');
    var activeTab = tabPanel.getActiveTab();
    var curTabIndex = tabPanel.items.findIndex('id', activeTab.id);
    var removingTab = curTabIndex > 1 ? tabPanel.items.items[curTabIndex - 1] : tabPanel.items.items[curTabIndex + 1];
    // debugger;
    for (var i = tabPanel.items.items.length-1; i > 0; i--) {
        var curTab = tabPanel.items.items[i];
        if (curTab.id.indexOf("tabEPRList") < 0) {
            removingTab = curTab;
            break;
        }
    }
    return removingTab;    
}

// 是否显示使用说明和质控提示
function isShowHelpQuality()
{
	var tabPanel = Ext.getCmp('centerTabPanel');
	tabPanel.setActiveTab('tabPortal');
	
	/*
	 * var tab = Ext.getCmp('centerTabPanel'); //判断tabeprlist是否存在??若存在??则直接隐藏
	 * var tabHelp = Ext.getCmp('tabHelp'); var tabEprQuality =
	 * Ext.getCmp('tabEprQuality');
	 * 
	 * //若两个都不是y,则显示帮助文档 if (showHelp != 'Y' && showQuality != 'Y') {
	 * tab.hideTabStripItem(tabEprQuality); tab.setActiveTab('tabHelp');
	 * tab.setActiveTab('tabPortal'); return; }
	 * 
	 * //若两个都是y,则激活帮助文档 if (showHelp == 'Y' && showQuality == 'Y') {
	 * tab.setActiveTab('tabHelp'); tab.setActiveTab('tabPortal'); return; }
	 * 
	 * if (showHelp == 'N') { tab.hideTabStripItem(tabHelp);
	 * tab.setActiveTab('tabEprQuality'); } if (showQuality == 'N') {
	 * tab.hideTabStripItem(tabEprQuality); tab.setActiveTab('tabHelp'); }
	 * tab.setActiveTab('tabPortal');
	 */
}

function getCenterVPort() {
    var centerTabPanel = getCenterTabPanel();
    var frmMainContent = new Ext.Viewport(
    {
        id: 'centerViewPort',
        shim: false,
        animCollapse: false,
        constrainHeader: true,
        margins: '0 0 0 0',
        layout: "border",
        items: [{
            border: false, region: 'center', layout: 'border',
            items: [{
                border: false, region: 'center', layout: 'fit', items: centerTabPanel
            }]
        }]
    });
}

getCenterVPort();
// isShowHelpQuality();
// Ext.getDom("tabHelpFrame").src= '../scripts/epr/help/help.htm';
// Ext.getDom("tabEprQualityFrame").src=
// './epr.newfw.qualityreport.csp?EpisodeID=' + episodeID;
Ext.getDom("tabPortalFrame").src = 'epr.newfw.portal.csp?episodeID=' + episodeID + '&patientID=' + patientID;
// hideTabEdit();
// hideTabList();

// createEprEdit();


//创建图片浏览页面
//Add by Candyxu  知情同意书
function createPhotoForm (strPath,templateDocID,prtTemplateDocID,node)
{
    var tabPanel = Ext.getCmp('centerTabPanel');
	var tabEPRPhotoID = String.format("tabEPRList{0}And{1}", templateDocID, prtTemplateDocID);
	var tabEPRPhoto = Ext.getCmp(tabEPRPhotoID);
	var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
    //debugger;
    var frameUrl = 'epr.newfw.centerphotoform.csp?RemotePath=' + strPath ;
	if (!tabEPRPhoto)
	{
        var curTabIndex = 0;
        if (tabPanel.items.length > ShowCenterTabCount) {
            var replaceTab = getReplaceTab();
            if (replaceTab) {
                curTabIndex = tabPanel.items.findIndex('id', replaceTab.id);
                tabPanel.remove(replaceTab.id);              
            }
        }
        if (curTabIndex > 0) {
            tabPanel.insert(curTabIndex, {
                id: tabEPRPhotoID,
                title: node.text,
                border: false,
                layout: 'fit',
                tabTip: node.text,
                html: '<iframe scrolling="auto" marginwidth=0 marginheight=0 id="' + iframeID + '" style="width:100%; height:100%" src=' + frameUrl + '></iframe>',
                closable: true
            }).show();
        } else {
            tabPanel.add({
                id: tabEPRPhotoID,
                title: node.text,
                border: false,
                layout: 'fit',
                tabTip: node.text,
                html: '<iframe scrolling="auto" marginwidth=0 marginheight=0 id="' + iframeID + '" style="width:100%; height:100%" src=' + frameUrl + '></iframe>',
                closable: true
            }).show();
        } 
    } else 
    {
		tabPanel.setActiveTab(tabEPRPhotoID)
    }

}
