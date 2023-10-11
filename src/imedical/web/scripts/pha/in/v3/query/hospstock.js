/**
 * ����:   ȫԺ����ѯ
 * ��д��:  pushuangcai
 * ��д����: 2022-03-07
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.hospstock.csp';
PHA_COM.App.Name = $g('ȫԺ����ѯ');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
    hospId: session['LOGON.HOSPID'],
    groupId: session['LOGON.GROUPID'],
    userId: session['LOGON.USERID'],
    locId: session['LOGON.CTLOCID']
};
var ParamProp = PHA_COM.ParamProp(PHA_COM.App.AppName);

$(function () {
    InitComponent(); // ҳ�����
    QUE_FORM.InitComponents(); // ������� component.js
    InitEvents();

    InitGridIncItmLoc();
    InitGridIncItm();
    InitGridIncib();
    InitDefVal();
    PHA_COM.SetPanel('#tabMain', $g('ȫԺ����ѯ'));

    InitInclbWin(); // ��ʼ������ InclbWindow.js
    AddMoreConditon();
});

function Query() {
    var formData = QUE_FORM.GetFormData();
    if (formData === null) {
        return;
    }
    formData.hosp = PHA_COM.VAR.hospId;
    var btKwArr = $('#btFilterKw').keywords('getSelected');
    for (var i = 0; i < btKwArr.length; i++) {
        formData[btKwArr[i].id] = true;
    }

    var $selTabs = $('#mainTabs').tabs('getSelected');
    var selIndex = $('#mainTabs').tabs('getTabIndex', $selTabs);
    if (selIndex === 0) {
        $('#gridIncItmLoc').datagrid('options').url = PHA.$URL;
        $('#gridIncItmLoc').datagrid('query', {
            pJsonStr: JSON.stringify(formData)
        });
    } else if (selIndex === 1) {
        $('#gridIncItm').datagrid('options').url = PHA.$URL;
        $('#gridIncItm').datagrid('query', {
            pJsonStr: JSON.stringify(formData)
        });
    } else if (selIndex === 2) {
        $('#gridIncib').datagrid('options').url = PHA.$URL;
        $('#gridIncib').datagrid('query', {
            pJsonStr: JSON.stringify(formData)
        });
    }
}

/**
 * ����
 */
function Clear() {
    QUE_FORM.ClearFormData();
    $('#gridIncItmLoc').datagrid('clear');
    $('#gridIncItm').datagrid('clear');
    $('#gridIncib').datagrid('clear');
    $('#gridIncLocBat').datagrid('clear');
    InitDefVal();
}

/**
 * �󶨰�ť�¼�
 */
function InitEvents() {
    PHA_EVENT.Bind('#btnFind', 'click', Query);
    PHA_EVENT.Bind('#btnClear', 'click', Clear);
}

/**
 * ��ʼ���������
 */
function InitComponent() {
    $('#btFilterKw').keywords({
        onClick: function (v) {
            Query();
        },
        singleSelect: false,
        items: [{ text: '�����޿������', id: 'NotEmptyFlag', selected: true }]
    });
}

function InitDefVal() {
    $('#date').datebox('setValue', PHA_UTIL.SysDate('t'));
    PHA.SetComboVal('scg', '');
}

/**
 * ���ҿ�����񣬵������е������ҿ�����δ��ڣ������λ���
 */
function InitGridIncItmLoc() {
    var frozenColumns = [
        [
            {
                field: 'inciCode',
                title: 'ҩƷ����',
                width: 100,
                hidden: true
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 200,
                hidden: true
            },
            {
                field: 'spec',
                title: '���',
                width: 100,
                hidden: true
            },
            {
                field: 'locID',
                title: '����id',
                width: 100,
                hidden: true
            },
            {
                field: 'locDesc',
                title: '����',
                width: 200,
                hidden: false,
                align: 'center'
            }
        ]
    ];

    var columns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'incil',
                title: 'incil',
                width: 100,
                hidden: true
            },
            {
                field: 'qtyWithUom',
                title: '���',
                width: 150,
                hidden: true,
                align: 'right',
                formatter: gridIncItmLocQtyFormatter
            },
            {
                field: 'pQty',
                title: '���(���)',
                width: 120,
                hidden: false,
                align: 'right',
                formatter: gridIncItmLocQtyFormatter
            },
            {
                field: 'pUomDesc',
                title: '��ⵥλ',
                width: 80,
                hidden: false
            },
            {
                field: 'bQty',
                title: '���(����)',
                width: 120,
                hidden: false,
                align: 'right',
                formatter: gridIncItmLocQtyFormatter
            },
            {
                field: 'bUomDesc',
                title: '������λ',
                width: 80,
                hidden: false
            },
            {
                field: 'avaQtyWithUom',
                title: '���ÿ��',
                width: 150,
                hidden: false,
                align: 'right'
            },
            {
                title: '����(���)',
                field: 'TPRp',
                width: 90,
                align: 'right'
            },
            {
                title: '�ۼ�(���)',
                field: 'TPSp',
                width: 90,
                align: 'right'
            },
            {
                title: '����(����)',
                field: 'TBRp',
                width: 90,
                align: 'right'
            },
            {
                title: '�ۼ�(����)',
                field: 'TBSp',
                width: 90,
                align: 'right'
            },
            {
                title: '���۽��',
                field: 'TRpAmt',
                width: 150,
                align: 'right'
            },
            {
                title: '�ۼ۽��',
                field: 'TSpAmt',
                width: 150,
                align: 'right'
            },
            {
                title: '��λ',
                field: 'stkBin',
                width: 100
            },
            {
                title: '������',
                field: 'notUseFlag',
                width: 70,
                align: 'center',
                formatter: QUE_COM.Grid.Formatter.YesOrNo()
            },
            {
                title: '����ҽ������',
                field: 'insuCode',
                width: 100
            },
            {
                title: '����ҽ������',
                field: 'insuName',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        queryParams: {
            pClassName: 'PHA.IN.Query.Api',
            pMethodName: 'LocItmStkAll'
        },
        iconCls: 'icon-paper',
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        exportXls: false,
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        frozenColumns: frozenColumns,
        showFooter: true,
        pagination: true,
        singleSelect: true,
        pageList: [10, 30, 50, 100],
        pageSize: 10,
        groupField: 'inci',
        view: groupview,
        groupFormatter: function (value, rows) {
            return (
                '' +
                rows[0].inciDesc +
                '</b>' +
                '<font style="font-weight:100;">&ensp; | &ensp;' +
                $g('����') +
                '��' +
                rows[0].inciCode +
                '&ensp;|&ensp;' +
                $g('���') +
                '��' +
                rows[0].inciSpec +
                '&ensp;|&ensp;' +
                $g('����ͨ����') +
                '��' +
                rows[0].geneName +
                '&ensp;|&ensp;' +
                $g('����') +
                '��' +
                rows[0].phcFormDesc +
                '</font>'
            );
        }
    };
    PHA.Grid('gridIncItmLoc', dataGridOption);
    QUE_COM.ComGridEvent('gridIncItmLoc');
}

/**
 * ������񣬰���������ȫԺ���
 */
function InitGridIncItm() {
    var frozenColumns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: 'ҩƷ����',
                width: 100,
                hidden: false,
                formatter: QUE_COM.Grid.Formatter.InciCode()
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 300,
                hidden: false
            },
            {
                field: 'inciSpec',
                title: '���',
                width: 100,
                hidden: false
            }
        ]
    ];
    var columns = [
        [
            {
                field: 'hospStkUom',
                title: '���',
                width: 150,
                hidden: true,
                align: 'right'
            },
            {
                field: 'pQty',
                title: '���(���)',
                width: 100,
                hidden: false,
                align: 'right'
            },
            {
                field: 'pUomDesc',
                title: '��ⵥλ',
                width: 80,
                hidden: false
            },
            {
                field: 'bQty',
                title: '���(����)',
                width: 100,
                hidden: false,
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '������λ',
                width: 80,
                hidden: false
            },
            {
                field: 'geneName',
                title: '����ͨ����',
                width: 150,
                hidden: false
            },
            {
                field: 'insuCode',
                title: 'ҽ������',
                width: 100,
                hidden: false
            },
            {
                field: 'insuName',
                title: 'ҽ������',
                width: 100,
                hidden: false
            },
            {
                field: 'phcFormDesc',
                title: '����',
                width: 80,
                hidden: false
            },
            {
                field: 'manfName',
                title: '������ҵ(���һ��)',
                width: 300,
                hidden: false
            },
            {
                field: 'vendor',
                title: '��Ӫ��ҵ(���һ��)',
                width: 300,
                hidden: false
            }
        ]
    ];
    var dataGridOption = {
        url: '', //$URL,
        queryParams: {
            pClassName: 'PHA.IN.Query.Api',
            pMethodName: 'IncItmStk'
        },
        iconCls: 'icon-paper',
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        exportXls: false,
        fitColumns: false,
        border: false,
        rownumbers: true,
        fixRowNumber: true,
        frozenColumns: frozenColumns,
        columns: columns,
        showFooter: false,
        pagination: true,
        singleSelect: true
    };
    PHA.Grid('gridIncItm', dataGridOption);
    QUE_COM.ComGridEvent('gridIncItm');
}

/**
 * ���α�񣬵������е������ҿ�����δ��ڣ������һ���
 */
function InitGridIncib() {
    var frozenColumns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'incib',
                title: 'incib',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: 'ҩƷ����',
                width: 100,
                hidden: true
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 200,
                hidden: true
            },
            {
                field: 'spec',
                title: '���',
                width: 100,
                hidden: true
            },
            {
                field: 'batNo',
                title: '����',
                align: 'center',
                width: 150
            }
        ]
    ];
    var columns = [
        [
            {
                field: 'expDate',
                title: 'Ч��',
                align: 'center',
                width: 100,
                styler: QUE_COM.Grid.Styler.ExpDate,
                formatter: QUE_COM.Grid.Formatter.ExpDate()
            },
            {
                field: 'qtyWithUom',
                title: '���',
                width: 150,
                hidden: true,
                align: 'right',
                formatter: gridIncibQtyFormatter
            },
            {
                field: 'pQty',
                title: '���(��ⵥλ)',
                width: 100,
                hidden: false,
                align: 'right',
                formatter: gridIncibQtyFormatter
            },
            {
                field: 'pUomDesc',
                title: '��ⵥλ',
                width: 80,
                hidden: false
            },
            {
                field: 'bQty',
                title: '���(������λ)',
                width: 100,
                hidden: false,
                align: 'right',
                formatter: gridIncibQtyFormatter
            },
            {
                field: 'bUomDesc',
                title: '������λ',
                width: 80,
                hidden: false
            },
            {
                field: 'geneName',
                title: '����ͨ����',
                width: 150,
                hidden: true
            },
            {
                field: 'insuCode',
                title: 'ҽ������',
                width: 100,
                hidden: true
            },
            {
                field: 'insuName',
                title: 'ҽ������',
                width: 100,
                hidden: true
            },
            {
                field: 'phcFormDesc',
                title: '����',
                width: 80,
                hidden: true
            },
            {
                field: 'TBRp',
                title: '����(����)',
                align: 'right',
                width: 100
            },
            {
                field: 'TBSp',
                title: '�ۼ�(����)',
                align: 'right',
                width: 100
            },
            {
                field: 'TPRp',
                title: '����(���)',
                align: 'right',
                width: 100
            },
            {
                field: 'TPSp',
                title: '�ۼ�(���)',
                align: 'right',
                width: 100
            },
            {
                title: '���۽��',
                field: 'TRpAmt',
                width: 150,
                align: 'right'
            },
            {
                title: '�ۼ۽��',
                field: 'TSpAmt',
                width: 150,
                align: 'right'
            },
            {
                field: 'manfName',
                title: '������ҵ',
                width: 220,
                hidden: false
            },
            {
                field: 'vendor',
                title: '��Ӫ��ҵ',
                width: 220,
                hidden: false
            }
        ]
    ];
    var dataGridOption = {
        url: '', //$URL,
        queryParams: {
            pClassName: 'PHA.IN.Query.Api',
            pMethodName: 'IncItmBatStk'
        },
        iconCls: 'icon-paper',
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        exportXls: false,
        fitColumns: false,
        border: false,
        rownumbers: false,
        fixRowNumber: true,
        showFooter: true,
        columns: columns,
        frozenColumns: frozenColumns,
        pagination: true,
        singleSelect: true,
        pageList: [10, 30, 50, 100],
        pageSize: 10,
        groupField: 'inci',
        view: groupview,
        groupFormatter: function (value, rows) {
            return (
                '' +
                rows[0].inciDesc +
                '</b>' +
                '<font style="font-weight:100;">&ensp; | &ensp;' +
                $g('����') +
                '��' +
                rows[0].inciCode +
                '&ensp;|&ensp;' +
                $g('���') +
                '��' +
                rows[0].inciSpec +
                '&ensp;|&ensp;' +
                $g('����ͨ����') +
                '��' +
                rows[0].geneName +
                '&ensp;|&ensp;' +
                $g('����') +
                '��' +
                rows[0].phcFormDesc +
                '</font>'
            );
        }
    };
    PHA.Grid('gridIncib', dataGridOption);
    QUE_COM.ComGridEvent('gridIncib');
}

/**
 * ��ʽ��ȫԺҩƷ���ο����������
 */
function gridIncibQtyFormatter(value, rowData, rowIndex) {
    if (typeof value === 'undefined' || value === '') {
        return '';
    }
    if ((value === 0)||(!rowData.incib)) {
        return value;
    }
    var retValue = '<a title="' + $g('����鿴��������') + '" onclick="GetLcbtDetail(\'gridIncib\')"';
    retValue += 'class="pha-grid-a js-grid-pQty">' + value + '</a>';
    return retValue;
}

/**
 * ��ʽ��ȫԺ���ҿ����������
 */
function gridIncItmLocQtyFormatter(value, rowData, rowIndex) {
    if (typeof value === 'undefined' || value === '') {
        return '';
    }
    if ((value === 0)||(!rowData.incil)) {
        return value;
    }

    var retValue = '<a title="' + $g('����鿴��������') + '" onclick="GetLcbtDetail(\'gridIncItmLoc\')"';
    retValue += 'class="pha-grid-a js-grid-pQty">' + value + '</a>';
    return retValue;
}

/**
 * �е���¼�����Ϊ����֮��PHA.GridEvent�����ã���
 */
function GetLcbtDetail(gridId) {
    var $target = $(event.target);
    var className = $target.attr('class');
    if (className === 'pha-grid-a js-grid-pQty') {
        var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
        if (rowIndex) {
            var rowData = $('#' + gridId).datagrid('getRows')[rowIndex];
            if (gridId === 'gridIncib') {
                var wOpts = {
                    title: rowData.inciDesc + '��' + rowData.batNo + '��',
                    incib: rowData.incib,
                    queryBy: 'Bat'
                };
            } else {
                var wOpts = {
                    title: rowData.inciDesc + '��' + rowData.locDesc + '��',
                    incil: rowData.incil,
                    queryBy: 'Loc'
                };
            }
            OpenInclbWindow(wOpts);
        }
    }
}

function AddMoreConditon() {
    var $tr = $('#hospstock-morecon table tbody');
    $('#con-form-toggle tbody').append($tr.html());
    $tr.remove();
    PHA.ComboBox('mainLoc', {
        placeholder: '����...',
        url: PHA_STORE.CTLoc().url,
        onHidePanel: function () {
            $('#subLoc').combobox('reload');
        }
    });
    PHA.ComboBox('subLoc', {
        placeholder: '�ӿ���...',
        multiple: true,
        rowStyle: 'checkbox',
        mode: 'remote',
        hoverShow: true,
        url: PHA_STORE.BaseDrugLoc().url,
        onBeforeLoad: function (param) {
            try {
                param.QText = param.q;
                param.MainLocID = $('#mainLoc').combobox('getValue');
            } catch (e) {}
        }
    });
    $('#onlySubLocFlag').checkbox({
        label: '����ѯ�ӿ���'
    });
    //PHA.CheckBox('onlySubLocFlag',{})
}
