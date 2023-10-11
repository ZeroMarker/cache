/*
 * @Descripttion: 护理病历-公用界面-弹窗
 * @Author: yaojining
 */

function initDialog() {
    if (typeof updateStep == 'function') {
        updateStep('dialog');
    }
    listenDialogEvents();
}

/**
 * @description: 弹框显示护理病历
 * @param {*} node
 * @param {*} url
 */
function recordDialog(node, url) {
    $('#dialogRecord').dialog({
        title: node.label,
        width: $(window).width() - 20,
        height: $(window).height() - 5,
        cache: false,
        content: createFrame('iframediag' + node.cspName.toLowerCase(), url),
        modal: true,
        onClose: function () {
            if (typeof (refreshTempTree) == 'function') {
                refreshTempTree();
            }
        }
    });
    $('#dialogRecord').dialog('open');
}

/**
 * @description: 打开引用弹窗
 * @param {Array} arrtab
 */
function openDgRefer(arrtab) {
    if (($('#dialogRefer').length == 0) || (arrtab.length == 0)) {
        return false;
    }
    // 样式设置
    $cm({
        ClassName: 'NurMp.Common.Logic.Handler',
        MethodName: 'Find',
        ClsName: 'CF.NUR.EMR.ReferView',
        TableName: 'Nur_IP_ReferTab',
        HospId: session['LOGON.HOSPID']
    }, function (viewSetting) {
        var tabwidth = '50%';
        var listwidth= '50%';
        if ((!$.isEmptyObject(viewSetting)) && (viewSetting.status > -1) && (!!viewSetting.data)) {
            if (!!viewSetting.data.RVPanelTab) {
                tabwidth = viewSetting.data.RVPanelTab + '%';
            }
            if (!!viewSetting.data.RVTabList) {
                listwidth = viewSetting.data.RVTabList + '%';
            }
        }
        var url = 'nur.hisui.nurseRefer.comm.csp?EpisodeID=' + EpisodeID + '&Tabs=' + arrtab + '&TabWidth=' + tabwidth + '&ListWidth=' + listwidth + '&ModelId=' + GetQueryString('ModelId');
		// 超融合
		var mwin = ("undefined" != typeof window.websys_getMenuWin_origin) ? websys_getMenuWin_origin() : websys_getMenuWin();
        var screens = (typeof websys_getMWScreens == 'function') && (websys_getMWScreens()) ? websys_getMWScreens().screens : [];
		if ((mwin.DisableSecondScreen == false) && ((screens.length > 1) || ((screens.length == 1) && (screens[0].PrimaryScreen == true))) && (typeof websys_emit == 'function')) {
			var opt = { EpisodeID:EpisodeID, Tabs:arrtab, TabWidth:tabwidth, ListWidth:listwidth, ModelId:GetQueryString('ModelId'), VerFlag: '1'};
        	websys_emit("onOpenRecordRefer", opt);
			return false;
        } else {
			url = buildMWTokenUrl(url);
			$('#dialogRefer').dialog({
				title: '引用',
				iconCls: 'icon-w-pen-paper',
				width: $(window).width() * (referWidth.replace('%', '') / 100),
				height: $(window).height() * (referHeight.replace('%', '') / 100),
				content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
				modal: true,
				buttons: [{
					text: '关闭',
					handler: closeDgRefer
				}, {
					text: '清屏',
					handler: clearDgRefer
				}, {
					text: '引用',
					handler: sureDgRefer
				}]
			}).dialog('open');
		}
    });
}

/**
 * @description: 扩展屏打开引用弹窗
 * @param {Object} opt
 */
function openExtendDgRefer(opt) {
	websys_emit("onOpenRecordRefer", opt);
}

/**
 * @description: 获取右键引用子页面的window对象
 * @return {String} 
 */
function getReferWindow() {
    return $('#iframeRefer')[0].contentWindow;
}

/**
 * @description: 关闭引用窗口
 */
function closeDgRefer() {
    $('#dialogRefer').dialog('close');
}

/**
 * @description: 清屏引用窗口
 */
function clearDgRefer() {
    getReferWindow().clearView();
}

function test() {
    getReferWindow().insertContent('测试插入');
}

/**
 * @description: 获取病历表单的window对象
 * @return {String} recordWindow
 */
function getRecordWindow() {
    var ifTabModel = $('#dialogRecord').parent().is(':hidden');
    if (ifTabModel) {
        var tab = $('#recordTabs').tabs('getSelected');
        var recordWindow = tab.contents()[0].contentWindow;
        while (recordWindow.length > 0) {
            recordWindow = recordWindow[0];
        }
    } else {
        var childFrames = $('#dialogRecord').contents().find('iframe');
        if (childFrames.length > 0) {
            var recordWindow = $('#dialogRecord').contents().find('iframe')[0].contentWindow;
            while (!!recordWindow.frames[0]) {
                recordWindow = recordWindow.frames[0];
            }
        } else {
            recordWindow = window;
        }

    }
    return recordWindow;
}

/**
 * @description: 获取右键特殊符号子页面的window对象
 * @return {String} 
 */
function getCharWindow() {
    return $('#iframeChars')[0].contentWindow;
}

/**
 * @description: 点击引用
 */
function sureDgRefer() {
    // 获取预览值
    var str = getReferWindow().getEditorContent();
    if (!str) {
        $.messager.alert('提示', $g('没有要引用的内容！'));
        return;
    }
    getRecordWindow().writeInto(str, closeDgRefer);
}

/**
 * @description: 打开特殊符号窗口
 */
function openDgChar() {
    var url = buildMWTokenUrl('nur.hisui.nurseReferChars.csp');
    $('#dialogSpecialChar').dialog({
        title: '特殊符号',
        width: $(window).width() * (charWidth.replace('%', '') / 100),
        height: $(window).height() * (charHeight.replace('%', '') / 100),
        cache: false,
        content: "<iframe id='iframeChars' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true,
        buttons: [{
            text: '关闭',
            handler: closeCharHandler
        }, {
            text: '确定',
            handler: sureReferCharsHandler
        }]
    }).dialog("open");
}

/**
 * @description: 引用特殊符号
 */
function sureReferCharsHandler() {
    var editContent = '';
    $('#iframeChars').contents().find("#kwChars li[class*=selected]").each(function () {
        var self = $(this);
        editContent = !!editContent ? editContent + self.text() : self.text();
    });
    getRecordWindow().writeChars(editContent, closeCharHandler);
    curElement = null;
}

/**
 * @description: 关闭特殊符号dialog
 */
function closeCharHandler() {
    if ($('#dialogSpecialChar').length != 0) {
        $('#dialogSpecialChar').dialog('close');
    }
}

/**
 * @description: 表单页签右键菜单操作事件
 */
function listenDialogEvents() {
    //关闭引用弹窗
    $('#btnClose').bind('click', closeDgRefer);

    //引用弹窗清屏
    $('#btnClear').bind('click', clearDgRefer);

    //确定引用
    $('#btnRefer').bind('click', sureDgRefer);
}
