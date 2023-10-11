/*
 * @Descripttion: ������-���ý���-��ҳǩ
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
 * @description: �򿪱�
 * @param {*} node
 */
function openRecord(node) {
    if (!EpisodeID) {
        $.messager.alert($g('����ʾ'), $g('����ѡ���ߵľ����¼��'), 'info');
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
 * @description: ����Tab
 * @param {object} node
 */
function addRecordTab(node) {
    var tabUrl = buildCspName(node.cspName) + '?EpisodeID=' + EpisodeID + '&AuthorityFlag=' + AuthorityFlag + '&ModelId=' + node.id;
    if (node.ejectFlag) {
        // ����չʾ������
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
 * @description: ͨ��node��node.label��������Tab����
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
 * @description: ͨ��index����Tab����
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
 * @description: ����iframe
 */
function createFrame(frameId, tabUrl) {
    var iframe = '<iframe id="' + frameId + '" scrolling="auto" width="100%" height="100%" frameborder="0" src="' + buildMWTokenUrl(tabUrl) + '"></iframe>';
    return iframe;
}

/**
 * @description: ��ҳǩѡ���¼�
 * @param {*} title
 * @param {*} index
 */
function onRecordTabSelect(title, index) {
   // �������չ�����л�ҳǩ��Ҫǿ��ˢ��ҳ�棬�����޷������¼�����
    var mwin = ("undefined" != typeof window.websys_getMenuWin_origin) ? websys_getMenuWin_origin() : websys_getMenuWin();
    var screens = (typeof websys_getMWScreens == 'function') && (websys_getMWScreens()) ? websys_getMWScreens().screens : [];
    if ((mwin.DisableSecondScreen == false) && ((screens.length > 1) || ((screens.length == 1) && (screens[0].PrimaryScreen == true))) && (typeof websys_emit == 'function')) {
        updateRecordTabByIndex(index, true);
    } else {
        updateRecordTabByIndex(index, false);
    }
}

/**
 * @description: ��ҳǰȡ��ѡ���¼�
 * @param {*} title
 * @param {*} index
 */
function onRecordTabUnSelect(title, index) {
    var target = this;
    var idcolse = true;
    return idcolse;
}

/**
 * @description: ��ҳ�ر��¼�
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
            $.messager.defaults.ok = "ȷ��";
            $.messager.defaults.cancel = "ȡ��";
            $.messager.confirm($g('��ʾ'), $g('���޸ģ��Ƿ񱣴�?ѡ��ȡ��ֱ�ӹرգ�ѡ��ȷ���Զ����档'), function (r) {
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
        // ���ں�
        if (typeof extendScreenPatient == 'function') {
	        extendScreenPatient();
	    }
    } else {
	    // ���ں�
	    if (typeof extendScreenPatient == 'function') {
	        extendScreenPatient();
	    }
        return true;
    }
    return false;	// prevent from closing
}

/**
 * @description: ҳǩ�Ҽ��˵���ʾ
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
 * @description: ˢ��
 */
function refreshCurrentTab() {
    var tab = $('#recordTabs').tabs('getSelected');
    var index = $('#recordTabs').tabs('getTabIndex', tab);
    updateRecordTabByIndex(index, true);
}

/**
 * @description ��Ĭ�ϵĵ���
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
 * @description: �ر�ѡ�е�ҳǩ
 */
function closeCurrentTab() {
    var tab = $('#recordTabs').tabs('getSelected');
    var index = $('#recordTabs').tabs('getTabIndex', tab);
    $('#recordTabs').tabs('close', index);
}

/**
 * @description: �ر����
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
 * @description: �ر��Ҳ�
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
 * @description: �ر�����
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
 * @description: ȫ���ر�
 */
function closeAllTabs() {
    $('.tabs-header span').each(function (i, n) {
        var t = $(n).text();
        $('#recordTabs').tabs('close', t);
    });
}

/**
 * @description: �˳� */
function exit() {
    $('#menu').menu('hide'); menu('hide');
}

/**
 * @description: ��ҳǩ�Ҽ��˵������¼�
 */
function listenRecordTabEvents() {
    // ˫���ر�TABѡ� 
    $('.tabs-header').bind('dblclick', closeCurrentTab);

    // Ϊѡ����Ҽ�
    $('.tabs-header').bind('contextmenu', showRecordTabMenu);

    //ˢ��
    $('#menu-tabupdate').bind('click', refreshCurrentTab);

    //�رյ�ǰ
    $('#menu-tabclose').bind('click', closeCurrentTab);

    //�رյ�ǰ����TAB
    $('#menu-tabcloseleft').bind('click', closePrevTabs);

    //�رյ�ǰ�Ҳ��TAB
    $('#menu-tabcloseright').bind('click', closeNextTabs);

    //�رճ���ǰ֮���TAB
    $('#menu-tabcloseother').bind('click', closeOthers);

    //ȫ���ر�
    $('#menu-tabcloseall').bind('click', closeAllTabs);

    //�˳�
    $("#menu-exit").bind('click', exit);
}