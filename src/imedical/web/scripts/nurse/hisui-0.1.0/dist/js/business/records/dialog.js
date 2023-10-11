/*
 * @Descripttion: ������-���ý���-����
 * @Author: yaojining
 */

function initDialog() {
    if (typeof updateStep == 'function') {
        updateStep('dialog');
    }
    listenDialogEvents();
}

/**
 * @description: ������ʾ������
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
 * @description: �����õ���
 * @param {Array} arrtab
 */
function openDgRefer(arrtab) {
    if (($('#dialogRefer').length == 0) || (arrtab.length == 0)) {
        return false;
    }
    // ��ʽ����
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
		// ���ں�
		var mwin = ("undefined" != typeof window.websys_getMenuWin_origin) ? websys_getMenuWin_origin() : websys_getMenuWin();
        var screens = (typeof websys_getMWScreens == 'function') && (websys_getMWScreens()) ? websys_getMWScreens().screens : [];
		if ((mwin.DisableSecondScreen == false) && ((screens.length > 1) || ((screens.length == 1) && (screens[0].PrimaryScreen == true))) && (typeof websys_emit == 'function')) {
			var opt = { EpisodeID:EpisodeID, Tabs:arrtab, TabWidth:tabwidth, ListWidth:listwidth, ModelId:GetQueryString('ModelId'), VerFlag: '1'};
        	websys_emit("onOpenRecordRefer", opt);
			return false;
        } else {
			url = buildMWTokenUrl(url);
			$('#dialogRefer').dialog({
				title: '����',
				iconCls: 'icon-w-pen-paper',
				width: $(window).width() * (referWidth.replace('%', '') / 100),
				height: $(window).height() * (referHeight.replace('%', '') / 100),
				content: "<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
				modal: true,
				buttons: [{
					text: '�ر�',
					handler: closeDgRefer
				}, {
					text: '����',
					handler: clearDgRefer
				}, {
					text: '����',
					handler: sureDgRefer
				}]
			}).dialog('open');
		}
    });
}

/**
 * @description: ��չ�������õ���
 * @param {Object} opt
 */
function openExtendDgRefer(opt) {
	websys_emit("onOpenRecordRefer", opt);
}

/**
 * @description: ��ȡ�Ҽ�������ҳ���window����
 * @return {String} 
 */
function getReferWindow() {
    return $('#iframeRefer')[0].contentWindow;
}

/**
 * @description: �ر����ô���
 */
function closeDgRefer() {
    $('#dialogRefer').dialog('close');
}

/**
 * @description: �������ô���
 */
function clearDgRefer() {
    getReferWindow().clearView();
}

function test() {
    getReferWindow().insertContent('���Բ���');
}

/**
 * @description: ��ȡ��������window����
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
 * @description: ��ȡ�Ҽ����������ҳ���window����
 * @return {String} 
 */
function getCharWindow() {
    return $('#iframeChars')[0].contentWindow;
}

/**
 * @description: �������
 */
function sureDgRefer() {
    // ��ȡԤ��ֵ
    var str = getReferWindow().getEditorContent();
    if (!str) {
        $.messager.alert('��ʾ', $g('û��Ҫ���õ����ݣ�'));
        return;
    }
    getRecordWindow().writeInto(str, closeDgRefer);
}

/**
 * @description: ��������Ŵ���
 */
function openDgChar() {
    var url = buildMWTokenUrl('nur.hisui.nurseReferChars.csp');
    $('#dialogSpecialChar').dialog({
        title: '�������',
        width: $(window).width() * (charWidth.replace('%', '') / 100),
        height: $(window).height() * (charHeight.replace('%', '') / 100),
        cache: false,
        content: "<iframe id='iframeChars' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true,
        buttons: [{
            text: '�ر�',
            handler: closeCharHandler
        }, {
            text: 'ȷ��',
            handler: sureReferCharsHandler
        }]
    }).dialog("open");
}

/**
 * @description: �����������
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
 * @description: �ر��������dialog
 */
function closeCharHandler() {
    if ($('#dialogSpecialChar').length != 0) {
        $('#dialogSpecialChar').dialog('close');
    }
}

/**
 * @description: ��ҳǩ�Ҽ��˵������¼�
 */
function listenDialogEvents() {
    //�ر����õ���
    $('#btnClose').bind('click', closeDgRefer);

    //���õ�������
    $('#btnClear').bind('click', clearDgRefer);

    //ȷ������
    $('#btnRefer').bind('click', sureDgRefer);
}
