/*
 * @Descripttion: 护理病历-病人查询
 * @Author: yaojining
 */
var GV = {
    BaseFlag: true,
    SelModeNode: null,
    TransPage: 'nur.emr.business.stat.patient.csp',
    Steps: ['templist']
};

$(function () {
    if (typeof updateStyle == 'function') {
		updateStyle();
	}
    initCondition();
    if (typeof requestTemplate == 'function') {
        requestTemplate();
    } else {
        if (typeof updateStep == 'function') {
            updateStep('templist');
        }
    }
    initPatientGrid();
    listenEvents();
});

/**
 * @description: 条件
 */
function initCondition() {
    var serverDateTime = getServerDateTime('Y-M-D');
    $('#StartDate').dateboxq('setValue', serverDateTime.date);
    $('#StartTime').timespinner('setValue', '00:00');
    $('#EndDate').dateboxq('setValue', serverDateTime.date);
    $('#EndTime').timespinner('setValue', '23:59');

    $('#WardCombo').combobox({
        url: $URL + '?ClassName=NurMp.Common.Base.Loc&MethodName=GetWards&HospitalID=' + session['LOGON.HOSPID'],
        valueField: 'id',
        textField: 'desc',
        panelHeight: 400,
        value: session['LOGON.WARDID'],
        defaultFilter: 6,
        onSelect: function (record) {
            reloadPatientGrid();
        }
    });
}

/**
 * @description: 自定义模板点击事件
 * @param {object} node
 */
function customClickTemplate(node) {
    GV.SelModeNode = node;
    $('#SearchBtn').click();
}

/**
* @description: 获取在院状态
*/
function getCkStatus() {
    var status = '';
    $("input[name='ckStatus']").each(function (index, obj) {
        if (obj.checked) {
            status = !!status ? status + ',' + obj.value : obj.value;
        }
    });
    return status;
}

/**
 * @description: 初始化病人表格
 */
function initPatientGrid() {
    var callBackFun = arguments.length > 0 ? arguments[0] : '';
    $('#PatientGrid').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'NurMp.Service.Patient.List',
            QueryName: 'FindRecordPatient',
            Guid: '',
            StartDate: $('#StartDate').dateboxq('getValue'),
            StartTime: $('#StartTime').timespinner('getValue'),
            EndDate: $('#EndDate').dateboxq('getValue'),
            EndTime: $('#EndTime').timespinner('getValue'),
            WardID: $('#WardCombo').combogrid('getValue'),
            VisitStatus: getCkStatus()
        },
        columns: [[
            { field: 'PatName', title: '姓名', width: 120 },
            { field: 'BedCode', title: '床号', width: 100 },
            { field: 'RegNo', title: '登记号', width: 180 },
            { field: 'WardDesc', title: '病区', width: 200 },
            { field: 'LocDesc', title: '科室', width: 200 },
            { field: 'VisitDesc', title: '状态', width: 80 },
            { field: 'RecordUrl', title: '病历', width: 44, formatter: formatRecordUrl },
            { field: 'AdmId', title: '就诊号', width: 200, hidden: true }
        ]],
        rownumbers: true,
        singleSelect: true,
        pagination: true,
        pageSize: 18,
        pageList: [18, 50, 100],
        onLoadSuccess: function (data) {
            if (typeof callBackFun == 'function') {
                callBackFun();
            }
        }
    });
}

/**
 * @description: 刷新病人Grid
 */
function reloadPatientGrid() {
    if (!GV.SelModeNode) {
        $.messager.alert($g('提示'), $g('请选择一个模板！'));
        return;
    }
    var guid = GV.SelModeNode.guid;
    if ((!!GV.SelModeNode.linkModel) && (!!GV.SelModeNode.linkModel.childGuid)) {
        guid = GV.SelModeNode.linkModel.childGuid;
    }
    $('#PatientGrid').datagrid('reload', {
        ClassName: 'NurMp.Service.Patient.List',
        QueryName: 'FindRecordPatient',
        Guid: guid,
        StartDate: $('#StartDate').dateboxq('getValue'),
        StartTime: $('#StartTime').timespinner('getValue'),
        EndDate: $('#EndDate').dateboxq('getValue'),
        EndTime: $('#EndTime').timespinner('getValue'),
        WardID: $('#WardCombo').combobox('getValue'),
        VisitStatus: getCkStatus()
    });
}

/**
 * @description: 病历链接
 * @param {*} value
 * @param {*} row
 * @param {*} index
 * @return {*} a
 */
function formatRecordUrl(value, row, index) {
    return '<a href="#" class="icon icon-paper" onclick="openRecord(\'' + GV.SelModeNode.cspName + '\',\'' + row.AdmId + '\',\'' + GV.SelModeNode.text + '\',\'' + index + '\')">&nbsp&nbsp&nbsp&nbsp</a>'
}

/**
 * @description: 描述
 * @param {*} emrCode
 * @param {*} episodeId
 * @param {*} title
 * @param {*} index
 */
function openRecord(emrCode, episodeId, title, index) {
    $('#PatientGrid').datagrid('selectRow', index);
    EpisodeID = episodeId;
    var url = buildCspName(emrCode) + '?EpisodeID=' + EpisodeID;
    $('#dialogRecord').dialog({
        title: title,
        iconCls: 'icon-w-find',
        width: $(window).width() * (dgRecordWidth.replace('%', '') / 100),
        height: $(window).height() * (dgRecordHeight.replace('%', '') / 100),
        content: "<iframe id='iframeRecord' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
        modal: true
    }).dialog('open');
}

/**
 * @description: 事件监听
 */
function listenEvents() {
    $('#SearchBtn').bind('click', reloadPatientGrid);
    $("input[name='ckStatus']").checkbox({
        onCheckChange: function (e, value) {
            reloadPatientGrid();
        }
    });
}