/*
 * @Descripttion: ������-���˲�ѯ
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
 * @description: ����
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
 * @description: �Զ���ģ�����¼�
 * @param {object} node
 */
function customClickTemplate(node) {
    GV.SelModeNode = node;
    $('#SearchBtn').click();
}

/**
* @description: ��ȡ��Ժ״̬
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
 * @description: ��ʼ�����˱��
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
            { field: 'PatName', title: '����', width: 120 },
            { field: 'BedCode', title: '����', width: 100 },
            { field: 'RegNo', title: '�ǼǺ�', width: 180 },
            { field: 'WardDesc', title: '����', width: 200 },
            { field: 'LocDesc', title: '����', width: 200 },
            { field: 'VisitDesc', title: '״̬', width: 80 },
            { field: 'RecordUrl', title: '����', width: 44, formatter: formatRecordUrl },
            { field: 'AdmId', title: '�����', width: 200, hidden: true }
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
 * @description: ˢ�²���Grid
 */
function reloadPatientGrid() {
    if (!GV.SelModeNode) {
        $.messager.alert($g('��ʾ'), $g('��ѡ��һ��ģ�壡'));
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
 * @description: ��������
 * @param {*} value
 * @param {*} row
 * @param {*} index
 * @return {*} a
 */
function formatRecordUrl(value, row, index) {
    return '<a href="#" class="icon icon-paper" onclick="openRecord(\'' + GV.SelModeNode.cspName + '\',\'' + row.AdmId + '\',\'' + GV.SelModeNode.text + '\',\'' + index + '\')">&nbsp&nbsp&nbsp&nbsp</a>'
}

/**
 * @description: ����
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
 * @description: �¼�����
 */
function listenEvents() {
    $('#SearchBtn').bind('click', reloadPatientGrid);
    $("input[name='ckStatus']").checkbox({
        onCheckChange: function (e, value) {
            reloadPatientGrid();
        }
    });
}