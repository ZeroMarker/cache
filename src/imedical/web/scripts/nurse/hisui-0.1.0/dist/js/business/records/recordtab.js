/*
 * @Descripttion: 护理病历-公用界面-表单页签
 * @Author: yaojining
 */

function initRecordTab() {
    $('#recordTabs').tabs({
        onSelect: onRecordTabSelect,
        onUnselect: onRecordTabUnSelect,
        onBeforeClose: onRecordTabBeforeClose
    });
    if (($('#patientTree').length == 0) && ($('#tempAccordion').length == 0) && (!!DefaultCode)) {
        openDefaultRecord();
    } else {
        if (typeof updateStep == 'function') {
            updateStep('recordtab');
        }
    }
    listenRecordTabEvents();
    
}

/**
 * @description: 打开表单
 * @param {*} node
 */
function openRecord(node) {
    if (!EpisodeID) {
        $.messager.alert($g('简单提示'), $g('请先选择患者的就诊记录！'), 'info');
        return;
    }
    if (!!node.cspName) {
        if ($('#recordTabs').tabs('exists', node.text)) {
            updateRecordTabByNode(node);
        } else {
            addRecordTab(node);
        }
        if (($('#windowMore').length > 0) && (!$('#windowMore').parent().is(':hidden'))) {
            $('#windowMore').window('close');
        }
    }
    if (typeof updateStep == 'function') {
        updateStep('recordtab');
    }
}

/**
 * @description: 增加Tab
 * @param {object} node
 */
function addRecordTab(node) {
    var tabUrl = buildCspName(node.cspName) + '?EpisodeID=' + EpisodeID + '&AuthorityFlag=' + AuthorityFlag + '&ModelId=' + node.id;
    if (node.ejectFlag) {
        // 弹窗展示病历表单
        recordDialog(node, tabUrl);
    } else {
        $('#recordTabs').tabs('add', {
            title: node.text,
            content: createFrame("iframetab" + node.cspName.toLowerCase(), tabUrl),
            fit: true,
            closable: true,
            episodeId: EpisodeID
        });
    }
}

/**
 * @description: 通过node和node.label描述更新Tab内容
 * @param {object} node
 */
function updateRecordTabByNode(node) {
    $('#recordTabs').tabs('select', node.text);
    var currTab = $('#recordTabs').tabs('getSelected');
    if (!currTab) {
        return false;
    }
    var tabUrl = $(currTab.panel('options').content).attr('src');
    if (!!tabUrl && currTab.panel('options').title != 'Home') {
        $('#recordTabs').tabs('update', {
            tab: currTab,
            options: {
                content: createFrame('iframetab' + node.cspName.toLowerCase(), tabUrl)
            }
        });
    }
}

/**
 * @description: 通过index更新Tab内容
 * @param {string} index
 * @param {bool} forceReresh
 */
function updateRecordTabByIndex(index, forceReresh) {
    var currTab = $('#recordTabs').tabs('getTab', index);
    if (!currTab) {
        return false;
    }
    var src = $(currTab.panel('options').content).attr('src');
    var jsonUrl = serilizeURL(src);
    if ((forceReresh) || ((!forceReresh) && (jsonUrl['EpisodeID'] != EpisodeID))) {
        var tabUrl = jsonUrl['csp'] + ".csp?EpisodeID=" + EpisodeID + "&AuthorityFlag=" + AuthorityFlag + "&ModelId=" + jsonUrl["ModelId"];
        $('#recordTabs').tabs('update', {
            tab: currTab,
            options: {
                content: createFrame('iframetab' + jsonUrl['emrcode'].toLowerCase(), tabUrl)
            }
        });
    }
}

/**
 * @description: 创建iframe
 */
function createFrame(frameId, tabUrl) {
    var iframe = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + buildMWTokenUrl(tabUrl) + '"></iframe>';
    return iframe;
}

/**
 * @description: 表单页签选中事件
 * @param {*} title
 * @param {*} index
 */
function onRecordTabSelect(title, index) {
   // 如果是扩展屏，切换页签需要强制刷新页面，否则无法进行事件监听
    var mwin = ("undefined" != typeof window.websys_getMenuWin_origin) ? websys_getMenuWin_origin() : websys_getMenuWin();
    var screens = (typeof websys_getMWScreens == 'function') && (websys_getMWScreens()) ? websys_getMWScreens().screens : [];
    if ((mwin.DisableSecondScreen == false) && ((screens.length > 1) || ((screens.length == 1) && (screens[0].PrimaryScreen == true))) && (typeof websys_emit == 'function')) {
        updateRecordTabByIndex(index, true);
    } else {
        updateRecordTabByIndex(index, false);
    }
}

/**
 * @description: 表单页前取消选中事件
 * @param {*} title
 * @param {*} index
 */
function onRecordTabUnSelect(title, index) {
    var target = this;
    var idcolse = true;
    return idcolse;
}

/**
 * @description: 表单页关闭事件
 * @param {*} title
 * @param {*} index
 */
function onRecordTabBeforeClose(title, index) {
    var target = this;
    var targetTab = $('#recordTabs').tabs('getTab', index);
    var iframe = $(targetTab.panel('options').content);
    var src = iframe.attr('src');
    var jsonUrl = serilizeURL(src);
    var frameId = "iframetab" + jsonUrl["emrcode"];
    var t = document.getElementById(frameId);
    var oldwindow = t.contentWindow;
    if (oldwindow.CloseAlertFlag && (typeof oldwindow.FormIsChanged === "function")) {
        var IsChanged = oldwindow.FormIsChanged();
        if (!IsChanged) {
            var opts = $(target).tabs('options');
            var bc = opts.onBeforeClose;
            opts.onBeforeClose = function () { };  // allowed to close now
            $(target).tabs('close', index);
            opts.onBeforeClose = bc;  // restore the event function
        } else {
            var oldOk = $.messager.defaults.ok;
            var oldCancel = $.messager.defaults.cancel;
            $.messager.defaults.ok = "确定";
            $.messager.defaults.cancel = "取消";
            $.messager.confirm($g('提示'), $g('有修改，是否保存?选择取消直接关闭，选择确定自动保存。'), function (r) {
                if (!r) {
                    var opts = $(target).tabs('options');
                    var bc = opts.onBeforeClose;
                    opts.onBeforeClose = function () { };  // allowed to close now
                    $(target).tabs('close', index);
                    opts.onBeforeClose = bc;  // restore the event function
                } else {
                    if (typeof oldwindow.autoSave === "function") {
                        oldwindow.autoSave();
                    }
                }
            });
            $.messager.defaults.ok = oldOk;
            $.messager.defaults.cancel = oldCancel;
        }
        // 超融合
        if (typeof extendScreenPatient == 'function') {
	        extendScreenPatient();
	    }
    } else {
	    // 超融合
	    if (typeof extendScreenPatient == 'function') {
	        extendScreenPatient();
	    }
        return true;
    }
    return false;	// prevent from closing
}

/**
 * @description: 页签右键菜单显示
 * @param {*} e
 */
function showRecordTabMenu(e) {
    e.preventDefault();
    $('#menuTab').menu('show', {
        left: e.pageX,
        top: e.pageY
    });
    var title = e.target.innerText;
    if (title) {
        $('#recordTabs').tabs('select', title);
    }
}

/**
 * @description: 刷新
 */
function refreshCurrentTab() {
    var tab = $('#recordTabs').tabs('getSelected');
    var index = $('#recordTabs').tabs('getTabIndex', tab);
    updateRecordTabByIndex(index, true);
}

/**
 * @description 打开默认的单据
 */
function openDefaultRecord() {
    if (!!DefaultCode) {
        $cm({
            ClassName: 'NurMp.Service.Template.Model',
            MethodName: 'GetModelInfoByID',
            ModelID: DefaultCode
        }, function (modelInfo) {
            if (!$.isEmptyObject(modelInfo)) {
                var node = {
                    id: modelInfo.ModelID,
                    label: modelInfo.EmrName,
                    text: modelInfo.EmrName,
                    cspName: buildCspName(modelInfo.EmrCode),
                    type: 'leaf'
                };
                openRecord(node);
            }
        });
    }
}

/**
 * @description: 关闭选中的页签
 */
function closeCurrentTab() {
    var tab = $('#recordTabs').tabs('getSelected');
    var index = $('#recordTabs').tabs('getTabIndex', tab);
    $('#recordTabs').tabs('close', index);
}

/**
 * @description: 关闭左侧
 */
function closePrevTabs() {
    var prevall = $('.tabs-selected').prevAll();
    if (prevall.length == 0) {
        return false;
    }
    prevall.each(function (i, n) {
        var t = $('a:eq(0) span', $(n)).text();
        $('#recordTabs').tabs('close', t);
    });
}

/**
 * @description: 关闭右侧
 */
function closeNextTabs() {
    var nextall = $('.tabs-selected').nextAll();
    if (nextall.length == 0) {
        return false;
    }
    nextall.each(function (i, n) {
        var t = $('a:eq(0) span', $(n)).text();
        $('#recordTabs').tabs('close', t);
    });
}

/**
 * @description: 关闭其他
 */
function closeOthers() {
    var prevall = $('.tabs-selected').prevAll();
    var nextall = $('.tabs-selected').nextAll();
    if (prevall.length > 0) {
        prevall.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $('#recordTabs').tabs('close', t);
        });
    }
    if (nextall.length > 0) {
        nextall.each(function (i, n) {
            var t = $('a:eq(0) span', $(n)).text();
            $('#recordTabs').tabs('close', t);
        });
    }
}

/**
 * @description: 全部关闭
 */
function closeAllTabs() {
    $('.tabs-header span').each(function (i, n) {
        var t = $(n).text();
        $('#recordTabs').tabs('close', t);
    });
}

/**
 * @description: 退出 */
function exit() {
    $('#menu').menu('hide'); menu('hide');
}

/**
 * @description: 表单页签右键菜单操作事件
 */
function listenRecordTabEvents() {
    // 双击关闭TAB选项卡 
    $('.tabs-header').bind('dblclick', closeCurrentTab);

    // 为选项卡绑定右键
    $('.tabs-header').bind('contextmenu', showRecordTabMenu);

    //刷新
    $('#menu-tabupdate').bind('click', refreshCurrentTab);

    //关闭当前
    $('#menu-tabclose').bind('click', closeCurrentTab);

    //关闭当前左侧的TAB
    $('#menu-tabcloseleft').bind('click', closePrevTabs);

    //关闭当前右侧的TAB
    $('#menu-tabcloseright').bind('click', closeNextTabs);

    //关闭除当前之外的TAB
    $('#menu-tabcloseother').bind('click', closeOthers);

    //全部关闭
    $('#menu-tabcloseall').bind('click', closeAllTabs);

    //退出
    $("#menu-exit").bind('click', exit);
}