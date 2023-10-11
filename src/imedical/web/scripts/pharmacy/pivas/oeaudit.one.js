/**
 * ģ��: 	 �����������
 * ��д����: 2019-07-24
 * ��д��:   yunhaibao
 */
/** �˽��治����ǰ�˲�������, ���������� */
PHA_SYS_SET = undefined; 
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var PivasWayCode = tkMakeServerCall('web.DHCSTPIVAS.Common', 'PivasWayCode');
var FormulaId = '';
var NeedScroll = '1';

$(function () {
    $('.newScroll').mCustomScrollbar({
        theme: 'inset-2-dark',
        scrollInertia: 100,
        mouseWheel: {
            scrollAmount: 100 // ������
        }
    });
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitTreePat();
    InitGridOrdItem();
    InitGridOrderDrugs();
    InitTreeGridReason();
    InitTPN();
    InitMedHistory();
    InitMedInfo();
    $('#btnFind').on('click', function () {
        $('#gridWard').datagrid('clear');
        $('#treePat').tree('loadData', []);
        if (Get.CurTab() == 'pat') {
            QueryPat();
        } else {
            Query();
        }
    });
    $('#btnFindDetail').on('click', QueryDetail);
    $('#btnAuditOk').on('click', function () {
        // ���ͨ��
        AuditOk('SHTG');
    });
    $('#btnAuditNo').on('click', function () {
        AuditNoShow('SHJJ');
    });
    $('#btnPhaRemark').on('click', function () {
        // ҩʦ��ע
        AuditRemarkShow();
    });
    $('#btnWinAuditRemark').on('click', function () {
        AuditRemark();
    });
    $('#btnCancelAudit').on('click', CancelAudit);
    $('#btnAnalyPresc').on('click', AnalyPresc); //������ҩ-Ԥ��
    $('#btnPrBroswer').on('click', PrbrowserHandeler);
    //$("#btnRemark").on("click", SaveRemark);
    $('#txtPatNo').searchbox({
        prompt: $g('������ǼǺ�...'),
        width: 250,
        searcher: function () {
            var patNo = $('#txtPatNo').searchbox('getValue');
            patNo = PIVAS.FmtPatNo(patNo);
            $('#txtPatNo').searchbox('setValue', patNo);
            QueryPat();
        }
    });
    $('#btnAuditRecord').on('click', AuditRecordLog);
    $('.pivas-full').on('click', function (e) {
        $(e.target).attr('src').indexOf('cancel') > 0 ? PIVAS.ExitFull() : PIVAS.FullScreen();
        $('.pivas-full').toggle();
    });
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
    $('.js-btn-toggle').on('click', function () {
        $('.js-btn-toggle').toggle();
        $(this)[0].id === 'btnCollapseAll' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');
    });
    $('#kwMore').keywords({
        singleSelect: true,
        onClick: function (v) {
            var panelHeight = 600;
            $('#divTPN').hide();
            $('#divMedHistory').hide();
            $('#divMedInfo').hide();
            var titleID = v.id;
            if (titleID == 'kwMoreTPN') {
                $('#divTPN').show();
                $('#divTPNGrid').height(panelHeight);
                $('#gridTPN').datagrid('resize');
                LoadTPN();
            } else if (titleID == 'kwMoreHistory') {
                $('#divMedHistory').show();
                $('#divMedHistoryGrid').height(panelHeight);
                $('#gridMedHistory').datagrid('resize');
                LoadMedHistory();
            } else if (titleID == 'kwMoreHelp') {
                $('#divMedInfo').show();
                $('#divMedInfoGrid').height(panelHeight);
                $('#gridMedInfo').datagrid('resize');
                LoadMedInfo();
            }
        },
        items: [
            {
                id: 'kwMoreHelp',
                text: $g('��˸���')
            },
            {
                id: 'kwMoreTPN',
                text: $g('TPNָ��')
            },
            {
                id: 'kwMoreHistory',
                text: $g('���λ�����ҩ')
            }
        ]
    });
    $('#kwMore').keywords('select', 'kwMoreHelp');
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    // ���״̬
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPassStat',
            Type: 'PassStat'
        },
        {
            editable: false
        }
    );
    $('#cmbPassStat').combobox('setValue', 1);
    // ��˽��
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPassResult',
            Type: 'PassResult'
        },
        {
            editable: false
        }
    );
    $('#cmbPassResult').combobox('setValue', '');
    // ��ʿ���
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbNurAudit',
            Type: 'NurseResult'
        },
        {
            editable: false
        }
    );
    $('#cmbNurAudit').combobox('setValue', 1);
    // ��Һ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaCat',
            Type: 'PivaCat'
        },
        {}
    );
    // ������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLocGrp',
            Type: 'LocGrp'
        },
        {}
    );
    // ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWard',
            Type: 'Ward'
        },
        {}
    );
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPriority',
            Type: 'Priority'
        },
        {
            width: 150
        }
    );
    // ��������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWorkType',
            Type: 'PIVAWorkType'
        },
        {}
    );
    // ҩƷ
    PIVAS.ComboGrid.Init(
        {
            Id: 'cmgIncItm',
            Type: 'IncItm'
        },
        {
            width: 260
        }
    );
}

//��ʼ�������б�
function InitGridWard() {
    //����columns
    var columns = [
        [
            {
                field: 'select',
                checkbox: true
            },
            {
                field: 'ward',
                title: 'ward',
                hidden: true
            },
            {
                field: 'wardDesc',
                title: '����',
                width: 250
            },
            {
                field: 'cnt',
                title: '�ϼ�',
                width: 50
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        fitColumns: true,
        fit: true,
        //rownumbers: false,
        columns: columns,
        queryOnSelect: false,
        toolbar: [],
        onClickRow: function (rowIndex, rowData) {
            CurWardID = rowData.ward;
            CurAdm = '';
        },
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {
            $('#gridOrdItem').datagrid('clear');
            $(this).datagrid('uncheckAll');
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == 'wardDesc') {
                $(this).datagrid('options').queryOnSelect = true;
            }
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid('options').queryOnSelect == true) {
                $(this).datagrid('options').queryOnSelect = false;
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid('options').queryOnSelect == true) {
                $(this).datagrid('options').queryOnSelect = false;
                QueryDetail();
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridWard', dataGridOption);
}

function InitTreePat() {
    $('#treePat').tree({
        formatter: function (node) {
            if (node.children) {
                return '<div style="line-height:35px;font-weight:bold">' + node.text + '</div>';
            } else {
                var data = node.text;
                var htmlArr = [];
                htmlArr.push('<div style="line-height:35px;">');
                htmlArr.push('	<div class="pivas-tree-pat" style="width:50px;overflow:hidden">' + '<span style="visibility:hidden">1</span>' + data.bedNo + '</div>');
                htmlArr.push('	<div class="pivas-tree-pat" style="width:100px;padding-left:5px;overflow:hidden">' + data.patNo + '</div>');
                htmlArr.push('	<div class="pivas-tree-pat" style="width:60px;padding-left:5px;overflow:hidden">' + data.patName + '</div>');
                htmlArr.push('	<div class="pivas-tree-pat" style="width:40px;text-align:right;font-weight:bold">' + data.cnt + '</div>');
                htmlArr.push('</div>');
                return htmlArr.join('');
            }
        },
        lines: true,
        autoNodeHeight: true,
        onClick: function (node) {
            QueryDetail();
        },
        onLoadSuccess: function () {
            $('#btnCollapseAll').css('display') === 'none' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');
        }
    });
}

function QueryPat() {
    var pJson = Get.QueryParams();
    pJson.patNo = $('#txtPatNo').searchbox('getValue');
    var rowsData = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            MethodName: 'GetPatTreeData',
            rows: 9999,
            page: 1,
            pJsonStr: JSON.stringify(pJson)
        },
        false
    );

    setTimeout(function () {
        $('#treePat').tree('loadData', rowsData);
    }, 100);
}

//��ʼ����ϸ�б�
function InitGridOrdItem() {
    //����columns
    var columns = [
        [
            {
                field: 'passResult',
                title: '������˽��',
                width: 50,
                align: 'left',
                hidden: true
            },
            {
                field: 'msgId',
                title: 'msgId',
                width: 100,
                hidden: true
            },
            {
                field: 'tipsType',
                title: '����',
                width: 45,
                halign: 'left',
                align: 'center',
                hidden: false,
                formatter: function (value, row, index) {
                    if (value == 'normal') {
                        // ���� #16BBA2
                        return '<img src = "../scripts/pharmacy/images/warning0.gif" style="width:15px">';
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-ok.png" >';
                    } else if (value == 'warn') {
                        // ��ʾ #FF6356
                        return '<img src = "../scripts/pharmacy/images/warning1.gif" >';
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-warn.png" >';
                    } else if (value == 'forbid') {
                        //���� black
                        return '<img src = "../scripts/pharmacy/images/warning2.gif" >';
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-error.png" >';
                    }
                    return '';
                }
            },
            {
                field: 'warnInfo',
                title: '״̬',
                width: 75,
                align: 'center',
                formatter: function (value, row, index) {
                    var retArr = [];
                    if (row.passResultDesc != '') {
                        retArr.push(row.passResultDesc);
                    }
                    if (row.phaOrdRemark != '') {
                        retArr.push(row.phaOrdRemark);
                    }
                    if (row.nurSeeDesc.indexOf('�ܾ�') >= 0) {
                        retArr.push('��ʿ�ܾ�');
                    } else {
                        if (row.nurSeeFlag === 'N') {
                            retArr.push('��ʿ' + row.nurSeeDesc);
                        }
                    }
                    return retArr.join('<br>');
                },
                styler: function (value, row, index) {
                    var passResult = row.passResult;

                    if (passResult == 'Y') {
                        return { class: 'pha-pivas-state-pass' };
                    } else if (passResult == 'N' || passResult == 'NY') {
                        return { class: 'pha-pivas-state-refuse' };
                    } else if (passResult == 'NA') {
                        return { class: 'pha-pivas-state-appleal' };
                    } else if (row.nurSeeDesc.indexOf('�ܾ�') >= 0) {
                        return { class: 'pha-pivas-state-refuse' };
                    }
                }
            },
            {
                field: 'pivaCatDesc',
                title: '����',
                width: 45,
                styler: function (value, row, index) {
                    return 'font-weight:bold;font-size:16px;';
                }
            },

            {
                field: 'drugsArr',
                title: 'ҽ��',
                width: 1500
            },
            {
                field: 'wardLocDesc',
                title: '����',
                width: 150,
                hidden: true
            },
            {
                field: 'bedNo',
                title: '����',
                width: 50,
                hidden: true
            },
            {
                field: 'patName',
                title: '����',
                width: 75,
                hidden: true
            },
            {
                field: 'patSex',
                title: '�Ա�',
                width: 45,
                align: 'center',
                hidden: true
            },
            {
                field: 'patAge',
                title: '����',
                width: 45,
                hidden: true
            },
            {
                field: 'surfaceArea',
                title: '������',
                width: 75,
                hidden: true
            },
            {
                field: 'mOeori',
                title: '��ҽ��Id',
                width: 100,
                hidden: true
            },
            {
                field: 'adm',
                title: '����Id',
                width: 100,
                hidden: true
            },
            {
                field: 'analysisData',
                title: '�������',
                width: 200,
                hidden: true
            },
            {
                field: 'dateMOeori',
                title: '��ҽ��Id+����',
                width: 200,
                hidden: true
            },
            {
                field: 'wardPat',
                title: '�������߷���',
                width: 200,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        fitColumns: false,
        singleSelect: true,
        rownumbers: true,
        columns: columns,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        toolbar: '#gridOrdItemBar',
        loadFilter: PIVAS.Grid.LoadFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            ClearOrderDetail();
            var rowsData = $('#gridOrdItem').datagrid('getRows');
            if (NeedScroll == 1) {
                $(this).datagrid('scrollTo', 0);
            }
            NeedScroll = 1;
        },
        onClickRow: function (rowIndex, rowData) {
            ShowOrderDetail(rowData.mOeori);
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == 'tipsType') {
                PHA_PASS.PDSS.ShowMsg({
                    msgId: $(this).datagrid('getRows')[rowIndex].msgId
                });
            }
        },
        onDblClickCell: function (rowIndex, field, value) {
            if (field != 'incDesc') {
                return;
            }
            var rowData = $(this).datagrid('getRows')[rowIndex];
            if (PIVAS.VAR.PASS == 'DHC') {
                return;
                /// ����֪ʶ��˵�����д
                var userInfo = SessionUser + '^' + SessionLoc + '^' + SessionGroup;
                var incDesc = rowData.incDesc;
                DHCSTPHCMPASS.MedicineTips({
                    Oeori: rowData.oeori,
                    UserInfo: userInfo,
                    IncDesc: incDesc
                });
            }
        },
        groupField: 'wardPat',
        view: groupview,
        groupFormatter: function (value, rows) {
            var rowData = rows[0];
            // ���˻�����Ϣ / ҽ����Ϣ /
            var viewDiv = '';
            var patDiv = '';
            var ordDiv = '';
            var wardDiv = '';
            patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
            // patDiv += '<div >' + rowData.patNo + '</div>';
            // patDiv += '<div>/</div>';
            patDiv += '<div style="width:80px">' + rowData.patName + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patSex + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patAge + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patNo + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div style="width:40px">' + rowData.bedNo + '</div>';
            patDiv += '</div>';
            wardDiv += '<div id="grpViewWard" class="grpViewWard">';
            wardDiv += '<div>' + rowData.wardLocDesc + '</div>';
            wardDiv += '</div>';
            viewDiv += '<div id="grpViewBase" class="grpViewBase">' + wardDiv + patDiv + '</div>';
            return viewDiv;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrdItem', dataGridOption);
}

function LoadAuditReasonTree() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            MethodName: 'GetAuditReasonTreeStore',
            Params: '',
            HospId: session['LOGON.HOSPID']
        },
        function (data) {
            $('#treeReason').tree('loadData', data);
        }
    );
}
function InitTreeGridReason() {
    $('#treeReason').tree({
        lines: true,
        autoNodeHeight: true,
        lines: true,
        checkbox: true,
        onSelect: function (node) {},
        onLoadSuccess: function (node, data) {}
    });
}

///���ǼǺŲ�ѯ�����б�
function GetPatAdmList() {
    var patNo = $('#txtPatNo').val();
    patNo = PIVAS.FmtPatNo(patNo);
    $('#txtPatNo').val(patNo);
    $('#gridAdm').datagrid('query', {
        inputParams: patNo + '^' + session['LOGON.HOSPID']
    });
}

///��ѯ
function Query() {
    var pJson = Get.QueryParams();
    $('#gridWard').datagrid('options').url = $URL;
    $('#gridWard').datagrid('query', {
        ClassName: 'web.DHCSTPIVAS.OeAudit',
        QueryName: 'WardData',
        pJsonStr: JSON.stringify(pJson),
        rows: 9999
    });
}

///��ѯҽ��
function QueryDetail() {
    var pJson = Get.QueryParams();
    var wardArr = Get.WardChecked();
    var adm = Get.AdmSelected();
    if (wardArr.length === 0 && adm === '') {
        $('#gridOrdItem').datagrid('clear');
        return;
    }
    pJson.wardStr = wardArr.join(',');
    pJson.adm = adm;

    var $grid = $('#gridOrdItem');
    PIVAS.Grid.PageHandler($grid);
    $grid.datagrid('loading');
    var rowsData = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            QueryName: 'OrderData',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999,
            page: 1
        },
        false
    );
    setTimeout(function () {
        $grid.datagrid('loadData', rowsData);
    }, 100);
}

/// ��ȡ����
function QueryParams(queryType) {
    var wardIdStr = '';
    var startDate = $('#dateStart').datebox('getValue'); // ��ʼ����
    var endDate = $('#dateEnd').datebox('getValue'); // ��ֹ����
    var startTime = $('#timeStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    var endTime = $('#timeEnd').timespinner('getValue'); // ��ҩ����ʱ��
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // ������
    var pivaCat = $('#cmbPivaCat').combobox('getValue') || ''; // ��Һ����
    var passStat = $('#cmbPassStat').combobox('getValue') || ''; // ���״̬
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; // ��˽��
    var nurAudit = $('#cmbNurAudit').combobox('getValue') || ''; // ��ʿ���
    var priority = $('#cmbPriority').combobox('getValue') || ''; // ҽ�����ȼ�
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // ������
    var admId = '';
    // ���Ϊ��ѯ��ϸ,��wardIdȡѡ���Id
    var tabTitle = $('#tabsOne').tabs('getSelected').panel('options').title;
    if (queryType == 'QueryDetail') {
        if (tabTitle == $g('�����б�')) {
            var wardChecked = $('#gridWard').datagrid('getChecked');
            if (wardChecked == '') {
                $('#gridOrdItem').datagrid('clear');
                return '';
            }
            for (var i = 0; i < wardChecked.length; i++) {
                if (wardIdStr == '') {
                    wardIdStr = wardChecked[i].wardId;
                } else {
                    wardIdStr = wardIdStr + ',' + wardChecked[i].wardId;
                }
            }
            /*
             var wardSelect = $('#gridWard').datagrid('getSelected');
             if (wardSelect == null) {
                 $.messager.popover({msg:"��ѡ����",type:'alert'});
                 return "";
             }
             wardIdStr = wardSelect.wardId;*/
            //admId = admSelected.admId;
        } else if (tabTitle == $g('���ǼǺ�')) {
            var admSelected = $('#gridAdm').datagrid('getSelected');
            if (admSelected == null) {
                $.messager.popover({
                    msg: $g('��ѡ������¼'),
                    type: 'alert'
                });
                return '';
            }
            wardIdStr = '';
            admId = admSelected.admId;
        }
    } else {
        wardIdStr = $('#cmbWard').combobox('getValue') || '';
    }
    var incId = $('#cmgIncItm').combobox('getValue') || '';
    var SkinFlag = $('#chkSkinFlag').checkbox('getValue');
    if (SkinFlag == false) {
        var SkinFlag = 0;
    } else {
        var SkinFlag = 1;
    }
    var NoFeeAuditFlag = $('#chkNoFeeAuditFlag').checkbox('getValue');
    if (NoFeeAuditFlag == false) {
        var NoFeeAuditFlag = 0;
    } else {
        var NoFeeAuditFlag = 1;
    }
    var params = startDate + '^' + endDate + '^' + startTime + '^' + endTime + '^' + SessionLoc + '^' + admId + '^' + wardIdStr + '^' + pivaCat + '^' + passStat + '^' + passResult;
    params += '^' + nurAudit + '^' + priority + '^' + incId + '^' + locGrpId + '^' + SkinFlag + '^' + NoFeeAuditFlag + '^' + startTime + '^' + endTime;
    return params;
}

/// �������ͨ��
function AuditOk(passType) {
    var dateMOeoriStr = GetDateMainOeoriStr();
    var warnMsg = '';
    if (dateMOeoriStr == '') {
        warnMsg = $g('��ѡ���¼');
    } else {
        var gridSel = $('#gridOrdItem').datagrid('getSelected');
        warnMsg = ValidAudit(gridSel);
    }
    if (warnMsg !== '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: warnMsg,
            type: 'alert'
        });
        return;
    }

    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            MethodName: 'PivasPass',
            dateMOeoriStr: dateMOeoriStr,
            userId: SessionUser,
            passType: passType
        },
        function (passRet) {
            PIVAS.Progress.Close();
            var passRetArr = passRet.split('^');
            var passVal = passRetArr[0];
            var passInfo = passRetArr[1];
            if (passVal == 0) {
                //$.messager.alert('��ʾ','���ͨ��!','info');
            } else {
                $.messager.alert($g('��ʾ'), $g(passInfo), 'warning');
                return;
            }
            NeedScroll = '';
            // ��reload,����ֱ��updateRow,��������޸İ�
            UpdateOrdItemRow();
        }
    );
}

function ValidAudit(rowData) {
    var passResult = rowData.passResult;
    if (passResult == 'N') {
        return $g('��ѡ��ļ�¼Ϊ�ܾ�״̬');
    } else if (passResult == 'NY') {
        return $g('��ѡ��ļ�¼Ϊ�ܾ�״̬,��ҽ���ѽ���');
    } else if (passResult == 'Y') {
        return $g('��ѡ��ļ�¼�Ѿ�Ϊͨ��״̬');
    }
    if (rowData.nurSeeFlag == 'N') {
        return $g('��ѡ��ļ�¼��ʿ') + rowData.nurSeeDesc;
    }
    return '';
}

/// ������˾ܾ�����
function AuditNoShow(passType) {
    if (PivasWayCode == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('����ά���������ԭ��'),
            type: 'alert'
        });
        return;
    }
    var dateMOeoriStr = GetDateMainOeoriStr();
    var warnMsg = '';
    if (dateMOeoriStr == '') {
        warnMsg = $g('��ѡ���¼');
    } else {
        var gridSel = $('#gridOrdItem').datagrid('getSelected');
        warnMsg = ValidAudit(gridSel);
    }
    if (warnMsg !== '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: warnMsg,
            type: 'alert'
        });
        return;
    }
    $('#reasonSelectDiv').window({
        title: '��˾ܾ�ԭ��ѡ��'
    });
    $('#reasonSelectDiv').dialog('open');
    LoadAuditReasonTree();
}

/// �ܾ�
function AuditNo() {
    var winTitle = $('#reasonSelectDiv').panel('options').title;
    var passType = 'SHJJ';
    var checkedNodes = $('#treeReason').tree('getChecked');
    if (checkedNodes.length == 0) {
        $.messager.alert('��ʾ', $g('��ѡ��ԭ��'), 'warning');
        return '';
    }
    var reasonStr = '';
    for (var nI = 0; nI < checkedNodes.length; nI++) {
        var reasonId = checkedNodes[nI].id;
        if (reasonId == 0) {
            continue;
        }
        // ֻҪҶ�ӽڵ�
        if (checkedNodes[nI].isLeaf === 'Y') {
            reasonStr = reasonStr == '' ? reasonId : reasonStr + '!!' + reasonId;
        }
    }
    var reasonNotes = $('#txtReasonNotes').val();
    var reasonData = reasonStr + '|@|' + reasonNotes;
    var dateMOeoriStr = GetDateMainOeoriStr();
    // ͬ��,��������
    var passRet = tkMakeServerCall('web.DHCSTPIVAS.OeAudit', 'PivasPass', dateMOeoriStr, SessionUser, passType, reasonData);
    var passRetArr = passRet.split('^');
    var passVal = passRetArr[0];
    var passInfo = passRetArr[1];
    $('#txtReasonNotes').val('');
    if (passVal == 0) {
        $('#reasonSelectDiv').dialog('close');
    } else {
        $.messager.alert($g('��ʾ'), $g(passInfo), 'warning');
        return;
    }
    NeedScroll = '';
    UpdateOrdItemRow();
}

///ȡ���������
function CancelAudit() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected');
    var warnMsg = '';
    if (gridSelect == null) {
        warnMsg = $g('��ѡ���¼');
    } else {
        var passResult = gridSelect.passResult;
        if (passResult == '') {
            warnMsg = $g('��ѡ��ļ�¼��δ���,����Ҫȡ��');
        } else if (passResult == 'NA') {
            warnMsg = $g('��ѡ��ļ�¼Ϊҽ������״̬,�޷�ȡ��');
        } else if (passResult == 'NY') {
            warnMsg = $g('��ѡ��ļ�¼Ϊҽ������״̬,�޷�ȡ��');
        }
        if (gridSelect.nurSeeFlag == 'N') {
            warnMsg = $g('��ѡ��ļ�¼��ʿ') + gridSelect.nurSeeDesc;
        }
    }
    if (warnMsg !== '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: warnMsg,
            type: 'alert'
        });
        return;
    }
    var conditionHtml = $g('��ȷ��ȡ�����?');
    $.messager.confirm($g('��ܰ��ʾ'), conditionHtml, function (r) {
        if (r) {
            var dateMOeori = gridSelect.dateMOeori;
            var cancelRet = tkMakeServerCall('web.DHCSTPIVAS.OeAudit', 'CancelPivasPass', dateMOeori, SessionUser);
            var cancelRetArr = cancelRet.split('^');
            var cancelVal = cancelRetArr[0] || '';
            if (cancelVal == '-1') {
                $.messager.alert($g('��ʾ'), cancelRetArr[1], 'warning');
                return;
            }
            NeedScroll = '';
            UpdateOrdItemRow();
        }
    });
}

/// �������
function PrbrowserHandeler() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.popover({
            msg: $g('��ѡ���¼'),
            type: 'alert'
        });
        return;
    }
    var adm = gridSelect.adm;
    PIVAS.ViewEMRWindow({}, adm);
}

/// ��ȡѡ�����ҽ����
function GetDateMainOeoriStr() {
    var gridSel = $('#gridOrdItem').datagrid('getSelected') || '';
    if (gridSel == '') {
        return '';
    }
    return gridSel.dateMOeori;
}

function AuditRecordLog() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.popover({
            msg: $g('��ѡ���¼'),
            type: 'alert'
        });
        return;
    }
    var dateMOeori = gridSelect.dateMOeori;
    PIVAS.AuditRecordWindow({
        dateMOeori: dateMOeori
    });
}

/// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'OeAudit'
        },
        function (jsonData) {
            $('#dateStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#timeStart').timespinner('setValue', jsonData.OrdStTime);
            $('#timeEnd').timespinner('setValue', jsonData.OrdEdTime);
            PIVAS.VAR.PASS = jsonData.Pass;
            var FormulaDesc = jsonData.Formula;
            FormulaId = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetDIIIdByDesc', FormulaDesc);
            if (PIVAS.VAR.PASS === 'DHC') {
                PHA_UTIL.LoadJS(['../scripts/dhcnewpro/dhcckb/pdss.js'], function () {});
            }
        }
    );
}

function AnalyPresc() {
    if (PIVAS.VAR.PASS == 'DHC') {
        if ($('#gridOrdItem').datagrid('getRows').length === 0) {
            return;
        }
        $('#gridOrdItem').datagrid('loading');
        setTimeout(function () {
            PHA_PASS.PDSS.Analysis(
                {
                    gridId: 'gridOrdItem',
                    mOeoriField: 'dateMOeori'
                },
                function (retData) {
                    for (var i = 0, length = retData.length; i < length; i++) {
                        var iData = retData[i];
                        $('#gridOrdItem').datagrid('updateRow', {
                            index: iData.index,
                            row: iData.row
                        });
                    }
                    $('#gridOrdItem').datagrid('loaded');
                }
            );
        }, 500);
    } else if (PIVAS.VAR.PASS == 'DT') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('��ͨ�ӿ�δ����,����ϵ��ز�Ʒ����Խӿ�'),
            type: 'alert'
        });
        return;
        StartDaTongDll();
        DaTongPrescAnalyse();
    } else if (PIVAS.VAR.PASS == 'MK') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('�����ӿ�δ����,����ϵ��ز�Ʒ����Խӿ�'),
            type: 'alert'
        });
        return;
        MKPrescAnalyse();
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('�޴����ͺ�����ҩ�ӿ�,����ҩƷϵͳ����->��������->��Һ����->������ҩ����'),
            type: 'alert'
        });
        return;
    }
}

// ��ʾ�Ҳ���ϸ
function ShowOrderDetail(mOeori) {
    $("#lyOrdDetail [id^='oe']").html('');
    var retData = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.OrderInfo',
            MethodName: 'GetOrderJson',
            MOeori: mOeori,
            Loc: SessionLoc
        },
        false
    );
    var orderObj = retData.order;
    $("#lyOrdDetail [id^='oe']").each(function () {
        if (this.id == 'oePIVASRemark') {
            $(this).val(orderObj[this.id] || '');
        } else {
            $(this).html(orderObj[this.id] || '');
        }
    });

    $('#gridOrderDrugs').datagrid('loadData', retData.drugs);
    $('#oeDiag').tooltip({
        content: $('#oeDiag').text(),
        position: 'left',
        showDelay: 500
    });

    // ����Ĭ�Ϲؼ���
    var kwWord = ''; //orderObj.kwWord||"";
    if (kwWord != '') {
        $('#kwMore').keywords('select', kwWord);
    } else {
        var curKW = $('#kwMore').keywords('getSelected');
        if (curKW[0]) {
            var selectID = curKW[0].id;
            $('#kwMore').keywords('select', selectID);
        }
    }
}

function ClearOrderDetail() {
    $("#lyOrdDetail [id^='oe']").text('');
    $("#lyOrdDetail [id^='oe']").val('');
    $('#gridOrderDrugs').datagrid('clear');
    $('#gridMedHistory').datagrid('clear');
    $('#gridTPN').datagrid('clear');
    $('#gridMedInfo').datagrid('clear');
}

function InitGridOrderDrugs() {
    //����columns
    var columns = [
        [
            {
                field: 'oeoriName',
                title: 'ҩƷ����',
                width: 250,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'spec',
                title: '���',
                width: 80
            },
            {
                field: 'dosage',
                title: '����',
                width: 75
            },
            {
                field: 'arcim',
                title: 'ҽ����ID',
                width: 75,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        pagination: false,
        fit: true,
        rownumbers: true,
        columns: columns,
        onSelect: function (rowIndex, rowData) {},
        onLoadSuccess: function (data) {
            var rows = data.rows;
            if (rows) {
                if (rows.length > 0) {
                    //	$(this).datagrid("selectRow",0);
                }
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrderDrugs', dataGridOption);
}

function InitTPN() {
    $('#divTPNGrid').height($('#divMoreCenter').height());
    $('#divTPNGrid').width($('#divMedInfoGrid').width());
    var dataGridOption = {
        url: '',
        border: true,
        fitColumns: true,
        singleSelect: true,
        nowrap: false,
        striped: false,
        pagination: false,
        rownumbers: false,
        columns: [
            [
                {
                    field: 'ingIndItmDesc',
                    title: 'ָ��',
                    width: 100,
                    align: 'left',
                    halign: 'left'
                },
                {
                    field: 'ingIndItmValue',
                    title: 'ֵ',
                    width: 50,
                    align: 'center'
                },
                {
                    field: 'ingIndItmRange',
                    title: '��Χ(~)',
                    width: 75,
                    align: 'left',
                    formatter: function (value, row, index) {
                        return (row.ingIndItmMin || '') + '~' + (row.ingIndItmMax || '');
                    }
                },
                {
                    field: 'ingIndItmOk',
                    title: '����',
                    width: 75,
                    hidden: true
                }
            ]
        ],
        rowStyler: function (index, row) {
            var isOk = row.ingIndItmOk;
            if (isOk == '1') {
                return {
                    class: 'grid-form-high'
                };
            } else if (isOk == '-1') {
                return {
                    class: 'grid-form-low'
                };
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridTPN', dataGridOption);
}

function InitMedHistory() {
    $('#divMedHistoryGrid').width($('#divMedInfoGrid').width());
    var columns = [
        [
            {
                field: 'doseDate',
                title: '����',
                width: 100
            },
            {
                field: 'oeoriInfo',
                title: 'ҽ��',
                width: 333
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        fit: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        border: true,
        singleSelect: true,
        nowrap: false
    };
    DHCPHA_HUI_COM.Grid.Init('gridMedHistory', dataGridOption);
}

function LoadMedHistory() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected') || '';
    if (gridSelect == '') {
        $.messager.popover({
            msg: $g('��ѡ���¼'),
            type: 'alert'
        });
        $('#gridMedHistory').datagrid('clear');
        return;
    }
    $('#gridMedHistory').datagrid('options').url = $URL;
    $('#gridMedHistory').datagrid('load', {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.OrderInfo',
        QueryName: 'MedHistory',
        InputStr: gridSelect.adm + '^' + 'Chemotherapeutic'
    });
}

function LoadTPN() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected') || '';
    if (gridSelect == '') {
        $.messager.popover({
            msg: $g('��ѡ���¼'),
            type: 'alert'
        });
        $('#gridTPN').datagrid('clear');
        return;
    }
    $('#gridTPN').datagrid('options').url = $URL;
    $('#gridTPN').datagrid('load', {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.Formula',
        QueryName: 'OeoriIngrIndItm',
        inputStr: gridSelect.mOeori + '^' + FormulaId
    });
}

function LoadMedInfo() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected') || '';
    if (gridSelect == '') {
        //$.messager.popover({msg:"��ѡ���¼",type:'alert'});
        $('#gridMedInfo').datagrid('clear');
        return;
    }
    $('#gridMedInfo').datagrid('options').url = $URL;
    $('#gridMedInfo').datagrid('load', {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.OrderInfo',
        QueryName: 'OrderMedInfo',
        MOeori: gridSelect.mOeori,
        LocId: session['LOGON.CTLOCID']
    });
}

function InitMedInfo() {
    var columns = [
        [
            {
                field: 'arcimDesc',
                title: 'ҽ������',
                width: 100,
                hidden: true
            },
            {
                field: 'drugInfo',
                title: '������Ϣ',
                width: 430
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        fit: true,
        fitColumns: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        border: true,
        singleSelect: true,
        nowrap: false,
        groupField: 'arcimDesc',
        view: groupview,
        groupFormatter: function (value, rows) {
            // var sameCnt=rows[0].sameCnt;
            // if (sameCnt>1){
            // }
            return value;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridMedInfo', dataGridOption);
}
function AuditRemarkShow() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('��ѡ����Ҫ��ע�ļ�¼'),
            type: 'alert'
        });
        return;
    }
    $('#phaMarkDiv').dialog('open');
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            MethodName: 'GetPivasRemark',
            dateMOeoriStr: gridSelect.dateMOeori
        },
        function (retData) {
            $('#conOrdRemark').val(retData.orderRemark || '');
            $('#conExeRemark').val(retData.executeRemark || '');
            $('#conLabelRemark').val(retData.labelRemark || '');
        }
    );
}
/// ��ע������,��ѡ����,�����ڹ�ѡ�����б�עĳһ��ҽ��
function AuditRemark() {
    var gridSelect = $('#gridOrdItem').datagrid('getSelected');
    var rowIndex = $('#gridOrdItem').datagrid('getRows').indexOf(gridSelect);
    var dateMOeori = gridSelect.dateMOeori;
    var ordRemark = $('#conOrdRemark').val();
    var exeRemark = $('#conExeRemark').val();
    var labelRemark = $('#conLabelRemark').val();
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            MethodName: 'PivasRemark',
            dateMOeoriStr: dateMOeori,
            userId: SessionUser,
            ordRemark: ordRemark,
            exeRemark: exeRemark,
            labelRemark: labelRemark,
            dataType: 'text'
        },
        function (passRet) {
            var passRetArr = passRet.split('^');
            var passVal = passRetArr[0];
            var passInfo = passRetArr[1];
            if (passVal == 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: $g('��ע�ɹ�'),
                    type: 'success'
                });
                UpdateOrdItemRow(rowIndex);

                var markArr = [ordRemark, exeRemark, labelRemark].filter(function (currentValue, index, arr) {
                    return currentValue != '';
                });

                $('#oePhaRemark').text(markArr.join('��'));
                $('#phaMarkDiv').dialog('close');
            } else {
                $.messager.alert($g('��ʾ'), passInfo, 'warning');
            }
        }
    );
}
function UpdateOrdItemRow() {
    var $grid = $('#gridOrdItem');
    var gridSelect = $grid.datagrid('getSelected');
    var rowIndex = $grid.datagrid('getRows').indexOf(gridSelect);
    var dateMOeori = gridSelect.dateMOeori;
    var retRowData = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            MethodName: 'GetRowData',
            dateMOeori: dateMOeori
        },
        false
    );
    $grid.datagrid('updateRow', {
        index: rowIndex,
        row: retRowData
    });
}
var Get = {
    QueryParams: function () {
        var pJson = {};
        pJson.loc = SessionLoc;
        pJson.wardStr = $('#cmbWard').combobox('getValue') || '';
        pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || '';
        pJson.startDate = $('#dateStart').datebox('getValue') || '';
        pJson.endDate = $('#dateEnd').datebox('getValue') || '';
        pJson.startTime = $('#timeStart').timespinner('getValue') || '';
        pJson.endTime = $('#timeEnd').timespinner('getValue') || '';
        pJson.cat = $('#cmbPivaCat').combobox('getValue') || '';
        pJson.workType = $('#cmbWorkType').combobox('getValue') || '';
        pJson.priority = $('#cmbPriority').combobox('getValue') || '';
        pJson.passStat = $('#cmbPassStat').combobox('getValue') || '';
        pJson.passResult = $('#cmbPassResult').combobox('getValue') || '';
        pJson.inci = $('#cmgIncItm').combogrid('getValue') || '';
        pJson.nurAudit = $('#cmbNurAudit').combobox('getValue') || '';
        pJson.phaMark = $('#chkPhaMark').checkbox('getValue') === true ? 'Y' : '';
        pJson.grpView = 'Y';

        return pJson;
    },
    CurTab: function () {
        var tabID = $('#tabsOne').tabs('getSelected').panel('options').id;
        return tabID === 'tabWard' ? 'ward' : 'pat';
    },
    WardChecked: function () {
        var retArr = [];
        if (this.CurTab() === 'pat') {
            return retArr;
        }
        var gridChecked = $('#gridWard').datagrid('getChecked');
        for (var i = 0; i < gridChecked.length; i++) {
            retArr.push(gridChecked[i].ward);
        }
        return retArr;
    },
    AdmSelected: function () {
        var adm = '';
        if (this.CurTab() === 'ward') {
            return adm;
        }
        var treeSel = $('#treePat').tree('getSelected');
        if (treeSel === null) {
            return adm;
        }
        adm = treeSel.text.adm || '';
        return adm;
    },
    PogChecked: function () {
        var retArr = [];
        var origRows = $('#gridOrdExe').datagrid('getData').originalRows;
        if (typeof origRows === 'undefined') {
            return retArr;
        }
        var len = origRows.length;
        for (var i = 0; i < len; i++) {
            var rowData = origRows[i];
            if (rowData.check === 'Y') {
                retArr.push(origRows[i].pog);
            }
        }
        return retArr;
    }
};