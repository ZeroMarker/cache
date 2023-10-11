/*
 * @Descripttion: 护理病历-公用界面-病人列表
 * @Author: yaojining

/**
 * @description: 病人列表页面入口
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
 * @description: 初始化页面
 */
function loadPatPage() {
    initPatCondition();
    initPatientTree();
    listenPatEvents();
}

/**
 * @description: 查询条件初始化
 */
function initPatCondition() {
}

/**
 * @description: 创建入参对象
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
 * @description: 加载病人列表
 */
function initPatientTree() {
    // 单选
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
 * @description: tree加载成功后的处理
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
    // 自定义病人列表加载完成后的接口方法
    if (typeof(refreshTempTree) == 'function') {
        customPatTreeLoadSuccess(node, data);
    }
}

/**
 * @description: 点击列表中病人事件
 * @param {object} node
 */
function onClickPatient(node) {
    if (!node.episodeID) {
        return false;
    }
    passPatientToMenu(node);
    EpisodeID = node.episodeID;
    // 自定义点击病人节点的接口方法
    if (typeof(customClickPatient) == 'function') {
        customClickPatient(node);
    }
    // 超融合
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}

/**
 * @description: 多选列表中病人事件
 * @param {object} node
 * @param {bool} checked
 */
 function onCheckPatient(node, checked) {
    if (!node.episodeID) {
        return false;
    }
    // 自定义多选病人节点的接口方法
    if (typeof(customCheckPatient) == 'function') {
        customCheckPatient(node, checked);
    }
    // 超融合
    if (typeof extendScreenPatient == 'function') {
        extendScreenPatient();
    }
}
/**
 * @description: 右键菜单
 * @param {*} event
 * @param {*} node
 */
function onPatTreeMenu(event, node) {
    // 自定义点击病人节点的右键菜单接口方法
    if (typeof(customPatTreeMenu) == 'function') {
        customPatTreeMenu(event, node);
    }
}

/**
 * @description: 初始化病人列表右键菜单
 */
function initPatTreeMenu(node) {
    $('#menuTree').empty();
    $('#menuTree').menu('appendItem', {
        id: 'menuPlaceFile',
        text: $g('一键归档'),
        iconCls: 'icon-knw-submit',
        handler: function () {
            confirm(function () {
                placeFile(node);
            }, $g("确定将 <b style='color:red;'>" + node.name + "</b> 的病历归档吗？"));
        }
    });
}

/**
 * @description: 一键归档
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
            $.messager.popover({ msg: $g('提交成功！'), type: 'info' });
            $('#patientTree').tree('reload');
        } else if (message == '0') {
            $.messager.popover({ msg: $g('提交失败！'), type: 'error' });
        } else {
            $.messager.popover({ msg: message, type: 'error' });
        }
    });
}

/**
 * @description: 事件监听
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