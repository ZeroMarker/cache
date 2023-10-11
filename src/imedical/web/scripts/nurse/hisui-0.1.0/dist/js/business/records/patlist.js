/*
 * @Descripttion: ������-���ý���-�����б�
 * @Author: yaojining
 */

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
    if ($('#wardPatientCondition').length > 0) {
        // �������Ȩ�޿���ʱ��Ĭ����ʾ����
        if (GroupFlag == 'Y') {
            $('#wardPatientCondition').switchbox('setValue', false);
        }
    }
    // ���ڲ�ѯ����Ĭ�ϵ���
    if ($('#pat-st-date').length > 0) {
        $('#pat-st-date').datebox('setValue', 'Today');
    }
    if ($('#pat-ed-date').length > 0) {
        $('#pat-ed-date').datebox('setValue', 'Today');
    }

    //��������
    $('#combotreeFilter').combotree({
        loader: function (param, success, error) {
            $cm({
                ClassName: 'NurMp.Service.Patient.List',
                MethodName: 'GetPatListFilter',
                Parr: '^^' + session['LOGON.HOSPID']
            }, function (data) {
                success(data);
            });
        },
        lines: true,
        panelWidth: 240,
        panelHeight: 320,
        delay: 500,
        onCheck: function (node, checked) {
            setTimeout(function(){
		    	$('#patientTree').tree('reload');
		    },200);
        },
        onSelect: function (node) {
            $('#patientTree').tree('check',node.target);
        },
        multiple: true,
        defaultFilter: 4
    });
}

/**
 * @description: ������ζ���
 * @return {object}
 */
function buildPatParameter() {
    return {
        EpisodeID: EpisodeID,
        WardID: session['LOGON.WARDID'],
        LocID: session['LOGON.CTLOCID'],
        GroupFlag: $('#wardPatientCondition').switchbox('getValue') == true ? 'N' : 'Y',
        BabyFlag: '',
        SearchInfo: $('#wardPatientSearchBox').searchbox('getValue'),
        LangID: session['LOGON.LANGID'],
        UserID: session['LOGON.USERID'],
        StartDate: ShowSearchDate == 1 ? $('#startDate').datebox('getValue') : '',
        EndDate: ShowSearchDate == 1 ? $('#endDate').datebox('getValue') : '',
        GroupID: session['LOGON.GROUPID'],
        ArrayFilter: $('#combotreeFilter').combotree('getValues'),
        TransPage: GV.TransPage
    }
}

/**
 * @description: ���ز����б�
 */
function initPatientTree() {
    if (PatCheckFlag == 1) {
        // ��ѡ
        initCheckPatTree();
        return;
    }
    // ��ѡ
    $('#patientTree').tree({
        lines: true,
        loader: function (param, success, error) {
            var parameter = buildPatParameter();
            $cm({
                ClassName: 'NurMp.Service.Patient.List',
                MethodName: 'getPatients',
                Param: JSON.stringify(parameter)
            }, function (data) {
                var addIDAndText = function (node) {
                    node.id = node.ID;
                    node.text = node.label;
                    if (node.id === EpisodeID) {
                        node.checked = true;
                    }
                    if (node.children) {
                        node.children.forEach(addIDAndText);
                    }
                }
                data.WardPatients.forEach(addIDAndText);
                if (typeof beforeLoadData == 'function') {
                    beforeLoadData(data);
                }
                success(data.WardPatients);
            });
        },
        onLoadSuccess: onPatTreeLoadSuccess,
        onClick: onClickPatient,
        onContextMenu: onPatTreeMenu
    });
}

/**
 * @description: ���ش��ж�ѡ��Ĳ����б�
 */
 function initCheckPatTree() {
    $('#patientTree').tree({
        lines: true,
        loader: function (param, success, error) {
            var parameter = buildPatParameter();
            $cm({
                ClassName: 'NurMp.Service.Patient.List',
                MethodName: 'getPatients',
                Param: JSON.stringify(parameter)
            }, function (data) {
                var addIDAndText = function (node) {
                    node.id = node.ID;
                    node.text = node.label;
                    if (node.id === EpisodeID) {
                        node.checked = true;
                    }
                    if (node.children) {
                        node.children.forEach(addIDAndText);
                    }
                }
                data.WardPatients.forEach(addIDAndText);
                if (typeof beforeLoadData == 'function') {
                    beforeLoadData(data);
                }
                success(data.WardPatients);
            });
        },
        checkbox: true,
        onLoadSuccess: onPatTreeLoadSuccess,
        onCheck: onCheckPatient
    });
}

/**
 * @description: tree���سɹ���Ĵ���
 * @param {object} node
 * @param {object} data
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
    if (typeof customPatTreeLoadSuccess  == 'function') {
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
 function onCheckPatient(node,checked) {
    if (!node.episodeID) {
        return false;
    }
    // �Զ����ѡ���˽ڵ�Ľӿڷ���
    if (typeof(customCheckPatient) == 'function') {
        customCheckPatient(node,checked);
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
 * @description  ѡ��ĳ������
 */
function selectOnePatient(direct, admId) {
    var nextNodeID;
    if (!direct) {
        direct = 1;
    }
    if (!!admId) {
        nextNodeID = admId;

    } else {
        var selNode = $('#patientTree').tree('getSelected');
        var selSortId = selNode.sortId;
        if ((selSortId == 1) && (direct < 0)) {
            selSortId = Object.keys(GV.ArrSort).length + 1;
        }
        var nextSortId = selSortId + direct;
        nextNodeID = GV.ArrSort[1];
        if (!!GV.ArrSort[nextSortId]) {
            nextNodeID = GV.ArrSort[nextSortId];
        }
    }
    var node = $('#patientTree').tree('find', nextNodeID);
    if (node != null) {
        $('#patientTree').tree('select', node.target);
        node.target.click();
    }
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
    if ($('#wardPatientCondition').length > 0) {
        $('#wardPatientCondition').switchbox('options').onSwitchChange = function () {
            $('#patientTree').tree('reload');
        };
    }
}