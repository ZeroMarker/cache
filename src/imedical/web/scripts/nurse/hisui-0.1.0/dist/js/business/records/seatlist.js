/*
 * @Descripttion: ������-���ý���-�����б�
 * @Author: yaojining

/**
 * @description: �����б�ҳ�����
 */
function requestPatient() {
    if ($('#patientTree').length < 1) {
        return;
    }
    if ((GV) && (!$.isEmptyObject(GV.SwitchInfo))) {
		loadPatPage();
	} else {
		$cm({
			ClassName: 'NurMp.Service.Switch.Config',
			MethodName: 'GetSwitchValues',
			HospitalID: session['LOGON.HOSPID'],
			LocID: session['LOGON.CTLOCID'],
			GroupID: session['LOGON.GROUPID']
		}, function (switchInfo) {
			GV.SwitchInfo = switchInfo.Main;
		    loadPatPage();
		});
	} 
}

/**
 * @description: ��ʼ��ҳ��
 */
function loadPatPage() {
    initPatCondition();
    initPatientTree();
    listenPatEvents();
}

/**
 * @description: ��ѯ������ʼ��
 */
function initPatCondition() {
}

/**
 * @description: ������ζ���
 * @return {object}
 */
function buildPatParameter() {
    return {
        EpisodeID: EpisodeID || '',
        LocID: session['LOGON.CTLOCID'],
        SearchInfo: $('#wardPatientSearchBox').searchbox('getValue'),
        LangID: session['LOGON.LANGID'],
        UserID: session['LOGON.USERID'],
        GroupID: session['LOGON.GROUPID'],
    }
}

/**
 * @description: ���ز����б�
 */
function initPatientTree() {
    // ��ѡ
    $('#patientTree').tree({
        lines: true,
        loader: function (param, success, error) {
            var parameter = buildPatParameter();
            $cm({
                ClassName: 'NurMp.Service.Patient.List',
                MethodName: 'GetSeatPatients',
                Param: JSON.stringify(parameter)
            }, function (data) {
                var addIDAndText = function (node) {
                    if (node.id === EpisodeID) {
                        node.checked = true;
                    }
                    if (node.children) {
                        node.children.forEach(addIDAndText);
                    }
                }
                data.forEach(addIDAndText);
                success(data);
            });
        },
        onLoadSuccess: onPatTreeLoadSuccess,
        onClick: onClickPatient,
        onContextMenu: onPatTreeMenu
    });
}


/**
 * @description: tree���سɹ���Ĵ���
 * @param {*} node
 * @param {*} data
 */
function onPatTreeLoadSuccess(node, data) {
    if (!!EpisodeID) {
        var selNode = $('#patientTree').tree('find', EpisodeID);
        if (!!selNode) {
            $('#patientTree').tree('select', selNode.target);
            if (PatCheckFlag == 1) {
                $('#patientTree').tree('check', selNode.target);
            }
        }
    }
    if (typeof updateStep == 'function') {
        updateStep('patlist');
    }
    // �Զ��岡���б������ɺ�Ľӿڷ���
    if (typeof(refreshTempTree) == 'function') {
        customPatTreeLoadSuccess(node, data);
    }
}

/**
 * @description: ����б��в����¼�
 * @param {object} node
 */
function onClickPatient(node) {
    if (!node.episodeID) {
        return false;
    }
    passPatientToMenu(node);
    EpisodeID = node.episodeID;
    // �Զ��������˽ڵ�Ľӿڷ���
    if (typeof(customClickPatient) == 'function') {
        customClickPatient(node);
    }
    // ���ں�
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}

/**
 * @description: ��ѡ�б��в����¼�
 * @param {object} node
 * @param {bool} checked
 */
 function onCheckPatient(node, checked) {
    if (!node.episodeID) {
        return false;
    }
    // �Զ����ѡ���˽ڵ�Ľӿڷ���
    if (typeof(customCheckPatient) == 'function') {
        customCheckPatient(node, checked);
    }
    // ���ں�
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}
/**
 * @description: �Ҽ��˵�
 * @param {*} event
 * @param {*} node
 */
function onPatTreeMenu(event, node) {
    // �Զ��������˽ڵ���Ҽ��˵��ӿڷ���
    if (typeof(customPatTreeMenu) == 'function') {
        customPatTreeMenu(event, node);
    }
}

/**
 * @description: ��ʼ�������б��Ҽ��˵�
 */
function initPatTreeMenu(node) {
    $('#menuTree').empty();
    $('#menuTree').menu('appendItem', {
        id: 'menuPlaceFile',
        text: $g('һ���鵵'),
        iconCls: 'icon-knw-submit',
        handler: function () {
            confirm(function () {
                placeFile(node);
            }, $g("ȷ���� <b style='color:red;'>" + node.name + "</b> �Ĳ����鵵��"));
        }
    });
}

/**
 * @description: һ���鵵
 * @param {object} node
 */
function placeFile(node) {
    $m({
        ClassName: 'NurMp.Service.Patient.List',
        MethodName: 'placeFile',
        EpisodeID: node.episodeID,
        UserID: session['LOGON.USERID']
    }, function (message) {
        if (message == '1') {
            $.messager.popover({ msg: $g('�ύ�ɹ���'), type: 'info' });
            $('#patientTree').tree('reload');
        } else if (message == '0') {
            $.messager.popover({ msg: $g('�ύʧ�ܣ�'), type: 'error' });
        } else {
            $.messager.popover({ msg: message, type: 'error' });
        }
    });
}

/**
 * @description: �¼�����
 */
function listenPatEvents() {
    if ($('#wardPatientSearchBox').length > 0) {
        $('#wardPatientSearchBox').searchbox({
            searcher: function (value) {
                $('#patientTree').tree('reload');
            }
        });
    }
}