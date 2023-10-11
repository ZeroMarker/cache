/**
 * ����:	 סԺҩ�� - סԺҩ������ά��
 * ��д��:	 yunhaibao
 * ��д����: 2020-10-27
 */

$(function () {
    InitDict();
    InitGridLoc();
    InitGridLocDispType();
    InitGridLocArcCat();

    $('#btnAdd').on('click', function () {
        Clear();
        $('#gridLoc').datagrid('addNewRow', {
            editField: 'loc'
        });
    });
    $('#btnSave').on('click', Save);
    $('#btnDelete').on('click', Delete);
    $('#btnSavePhaLocation').on('click', SavePhaLocation);

    InitHosp();

    setTimeout(function () {
        Query();
        console.log($($('.js-data-detail')[0]).height());
        $('#lyDetail')
            .layout('panel', 'north')
            .panel('resize', { height: $($('.js-data-detail')[0]).height() + 65 });
        $('#lyDetail').layout('resize');
    }, 10);
});

function Clear() {
    PHA.DomData('.js-data-detail', {
        doType: 'clear'
    });
    $('#resFlag').switchbox('setValue', false);
    $('#dispDefaultFlag').keywords('clearAllSelected');
    $('#gridLocDispType').datagrid('clear');
    $('#gridLocArcCat').datagrid('clear');
}
function InitDict() {
    $('#dispDefaultFlag').keywords({
        singleSelect: false,
        items: [
            { text: '����ҽ��', id: 2 },
            { text: '��ʱҽ��', id: 1 }
        ]
    });
}

function InitGridLoc() {
    var columns = [
        [
            {
                field: 'phaLoc',
                title: 'phaLoc',
                width: 125,
                hidden: true
            },
            {
                field: 'loc',
                title: '����',
                width: 100,
                descField: 'locDesc',
                editor: PHA.EditGrid.ComboBox({
                    required: true,
                    tipPosition: 'top',
                    url: PHA_STORE.CTLoc().url,
                    defaultFilter: 5,
                    loadFilter: function (rowsData) {
                        var newRowsData = [];
                        var locRowsData = $('#gridLoc').datagrid('getRows');
                        for (var i = 0; i < rowsData.length; i++) {
                            var pushFlag = true;
                            var rowID = rowsData[i].RowId;
                            for (var j = 0; j < locRowsData.length; j++) {
                                var loc = locRowsData[j].loc;
                                if (loc === rowID) {
                                    pushFlag = false;
                                    break;
                                }
                            }
                            if (pushFlag === true) {
                                newRowsData.push(rowsData[i]);
                            }
                        }
                        return newRowsData;
                    }
                }),
                formatter: function (value, row, index) {
                    return row.locDesc;
                }
            },
            {
                field: 'locDesc',
                title: '����',
                width: 100,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IP.Loc.Query',
            QueryName: 'PhaLocation',
            pJsonStr: JSON.stringify({ hosp: PHA_COM.Session.HOSPID }),
            rows: 999
        },
        fitColumns: true,
        toolbar: '#gridLocBar',
        columns: columns,
        pagination: false,
        rownumbers: true,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            QueryDetail();
        },
        onLoadSuccess: function () {
            Clear();
        }
    };
    PHA.Grid('gridLoc', dataGridOption);
}
function InitGridLocArcCat() {
    var columns = [
        [
            {
                field: 'arcCatObj1',
                title: 'ҽ������',
                width: 100,
                styler: Styler,
                formatter: Formatter
            },
            {
                field: 'arcCatObj2',
                title: 'ҽ������',
                width: 100,
                styler: Styler,
                formatter: Formatter
            },
            {
                field: 'arcCatObj3',
                title: 'ҽ������',
                width: 100,
                styler: Styler,
                formatter: Formatter
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: '',
        fitColumns: true,
        toolbar: [],
        columns: columns,
        pagination: false,
        loadMsg: null,
        loadingMessage: null,
        onDblClickCell: function (index, field, value) {
            var phaLoc = Get.PhaLoc();
            if (phaLoc === '') {
                PHA.Popover({
                    msg: '���ȱ���������',
                    type: 'alert'
                });
                return;
            }
            var valJson = JSON.parse(value);
            if (valJson.arcCat === '') {
                return;
            }
            var flag = valJson.flag === 'Y' ? 'N' : 'Y';
            var data = {
                loc: valJson.loc,
                arcCat: valJson.arcCat,
                flag: flag
            };
            var retJson = $.cm(
                {
                    ClassName: 'PHA.IP.Data.Api',
                    MethodName: 'HandleInOne',
                    pClassName: 'PHA.IP.Loc.Save',
                    pMethodName: 'SaveLocArcCatHandler',
                    pJsonStr: JSON.stringify([data])
                },
                false
            );
            if (retJson.success === 'N') {
                var msg = PHAIP_COM.DataApi.Msg(retJson);
                PHA.Alert('��ʾ', msg, 'warning');
            } else {
                PHA.Popover({
                    msg: '���óɹ�',
                    type: 'success',
                    timeout: 500
                });
            }
            $(this).datagrid('reload');
        },
        onLoadSuccess: function () {
            $('#gridLocArcCat').datagrid('enableCellSelecting');
        }
    };
    PHA.Grid('gridLocArcCat', dataGridOption);
    function Styler(value, row, index) {
        var flag = JSON.parse(value).flag;
        if (flag === 'Y') {
            return 'background:#5db95d;color:white;font-weight:bold;';
        }
    }
    function Formatter(value, row, index) {
        return JSON.parse(value).arcCatDesc;
    }
}
function InitGridLocDispType() {
    var columns = [
        [
            {
                field: 'operate',
                title: '����',
                width: 60,
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    if (rowData.locDispType === '') {
                        return '<input type="checkbox"  class="checkbox-f" style="display: none;"><label class="checkbox" title="����" ></label>';
                        // return '<img title="����" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare_yes.png" style="border:0px;cursor:pointer">';
                    } else {
                        return '<input type="checkbox"  class="checkbox-f" style="display: none;"><label class="checkbox checked"  title="ȡ������"></label>';
                        // return '<img title="ȡ������" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare_no.png" style="border:0px;cursor:pointer">';
                    }
                }
            },
            {
                field: 'locDispType',
                title: 'rowID',
                width: 100,
                hidden: true
            },
            {
                field: 'dispType',
                title: '���ID',
                width: 100,
                hidden: true
            },
            {
                field: 'dispTypeCode',
                title: '������',
                width: 100,
                styler: function (value, rowData) {
                    if (rowData.locDispType === '') {
                        return 'opacity: 0.5;';
                    }
                }
            },
            {
                field: 'dispTypeDesc',
                title: '�������',
                width: 125,
                styler: function (value, rowData) {
                    if (rowData.locDispType === '') {
                        return 'opacity: 0.5;';
                    }
                }
            },
            {
                field: 'defaultFlag',
                title: '��ҩĬ�Ϲ�ѡ',
                align: 'center',
                width: 100,
                formatter: function (value, rowData, rowIndex) {
                    var chkValue = value === 'Y' ? true : false;
                    return '<div class="hisui-switchbox" data-options="checked:' + chkValue + '"></div>';
                },
                styler: function (value, rowData) {
                    if (rowData.locDispType === '') {
                        return 'opacity: 0.5;';
                    }
                }
            },
            {
                field: 'permitReqFlag',
                title: '��ҩ����',
                align: 'center',
                width: 100,
                formatter: function (value, rowData, rowIndex) {
                    var chkValue = value === 'Y' ? false : true;
                    return '<div class="hisui-switchbox" data-options="checked:' + chkValue + '"></div>';
                },
                styler: function (value, rowData) {
                    if (rowData.locDispType === '') {
                        return 'opacity: 0.5;';
                    }
                }
            }
        ]
    ];

    var dataGridOption = {
        exportXls: false,
        url: '',
        fitColumns: true,
        toolbar: [],
        columns: columns,
        pagination: false,
        loadMsg: null,
        loadingMessage: null,
        rowStyler: function (index, rowData) {
            if (rowData.locDispType !== '') {
                return 'font-weight:bold';
            }
        },
        onClickRow: function (rowIndex, rowData) {
            // QueryWardLoc();
        },
        onLoadSuccess: function () {
            SwitchHandler();
        }
    };
    PHA.Grid('gridLocDispType', dataGridOption);
}

function SwitchHandler() {
    $('td[field="permitReqFlag"] .hisui-switchbox').switchbox({
        onClass: 'success',
        offClass: 'danger',
        onText: '����',
        offText: '��ֹ',
        size: 'small',
        animated: true,
        onSwitchChange: UpdateLocDispType
    });
    $('td[field="defaultFlag"] .hisui-switchbox').switchbox({
        onClass: 'success',
        offClass: 'gray',
        onText: '��',
        offText: '��',
        size: 'small',
        animated: true,
        onSwitchChange: UpdateLocDispType
    });
    $('td[field="operate"] label')
        .unbind()
        .on('click', function (e) {
            if (this.title.indexOf('ȡ��') >= 0) {
                var dispTypeDesc = $(e.target).closest('tr').find('[field="dispTypeDesc"]').text();
                PHA.Confirm('���ݲ�����ʾ', '��ȷ����' + '<b>��' + dispTypeDesc + '��</b>' + this.title + '��', function () {
                    OperateHandler(e);
                });
            } else {
                OperateHandler(e);
            }
        });

    function OperateHandler(e) {
        var phaLoc = $('#gridLoc').datagrid('getSelected').phaLoc || '';
        var $tr = $(e.target).closest('tr');
        var locDispType = $tr.find('[field="locDispType"]').text();
        var dispType = $tr.find('[field="dispType"]').text();
        var dispTypeDesc = $tr.find('[field="dispTypeDesc"]').text();

        var dataArr = [
            {
                locDispType: locDispType,
                phaLoc: phaLoc,
                dispType: dispType
            }
        ];
        var retJson = $.cm(
            {
                ClassName: 'PHA.IP.Data.Api',
                MethodName: 'HandleInAll',
                pClassName: 'PHA.IP.Loc.Save',
                pMethodName: 'SaveLocDispTypeHandler',
                pJsonStr: JSON.stringify(dataArr)
            },
            function (retJson) {
                if (retJson.success === 'N') {
                    var msg = PHAIP_COM.DataApi.Msg(retJson);
                    PHA.Alert('��ʾ', msg, 'warning');
                } else {
                    PHA.Popover({
                        msg: '���óɹ�',
                        type: 'success',
                        timeout: 500
                    });
                }
                $('#gridLocDispType').datagrid('reload');
            }
        );
    }
}
function UpdateLocDispType(event, obj) {
    var $target = $(event.target);
    var $tr = $target.closest('tr');
    var field = $(event.target).closest('td').attr('field');
    var rowIndex = $tr.attr('datagrid-row-index');
    var rowData = $('#gridLocDispType').datagrid('getRows')[rowIndex];
    var locDispType = $tr.find('[field="locDispType"]').text();

    if (locDispType === '') {
        PHA.Popover({
            msg: 'û�й�����ҩ���, �޷��޸�',
            type: 'alert',
            timeout: 1000
        });
        $('#gridLocDispType').datagrid('reload');
        return;
    }

    var data = {
        locDispType: locDispType
    };
    if (field === 'defaultFlag') {
        data.defaultFlag = obj.value === true ? 'Y' : 'N';
        data.permitReqFlag = rowData.permitReqFlag;
    } else if (field === 'permitReqFlag') {
        data.permitReqFlag = obj.value === true ? 'N' : 'Y';
        data.defaultFlag = rowData.defaultFlag;
    }

    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.Loc.Save',
            pMethodName: 'UpdateLocDispTypeHandler',
            pJsonStr: JSON.stringify([data])
        },
        function (retJson) {
            if (retJson.success === 'N') {
                var msg = PHAIP_COM.DataApi.Msg(retJson);
                PHA.Alert('��ʾ', msg, 'warning');
            } else {
                PHA.Popover({
                    msg: '���óɹ�',
                    type: 'success',
                    timeout: 500
                });
            }
            setTimeout(function () {
                $('#gridLocDispType').datagrid('reload');
            }, 250);
        }
    );
}

function Save() {
    var $grid = $('#gridLoc');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '������ɱ�����',
            type: 'alert'
        });
        return;
    }
    var gridRows = $grid.datagrid('getRows');

    var dataArr = [];
    for (var i = 0; i < gridRows.length; i++) {
        var rowData = gridRows[i];
        if (rowData.phaLoc || '' !== '') {
            continue;
        }
        var loc = rowData.loc || '';
        if (loc === '') {
            continue;
        }
        var iJson = {
            loc: rowData.loc
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }

    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.IP.Loc.Save',
            pMethodName: 'SaveHandler',
            pJsonStr: JSON.stringify(dataArr)
        },
        false
    );

    if (retJson.success === 'N') {
        PHA.Alert('��ʾ', PHAIP_COM.DataApi.Msg(retJson), 'warning');
    } else {
        PHA.Popover({
            msg: '����ɹ�',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}

function QueryDetail() {
    var loc = Get.Loc();
    if (loc === '') {
        return;
    }
    var pJson = {};
    pJson.loc = loc;

    $('#gridLocDispType').datagrid('options').url = $URL;
    $('#gridLocArcCat').datagrid('options').url = $URL;

    $('#gridLocDispType').datagrid('query', {
        ClassName: 'PHA.IP.Loc.Query',
        QueryName: 'LocDispType',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
    $('#gridLocArcCat').datagrid('query', {
        ClassName: 'PHA.IP.Loc.Query',
        QueryName: 'LocArcCat',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
    QueryPhaLocation();
}
function Query() {
    $('#gridLoc').datagrid('options').url = $URL;

    $('#gridLoc').datagrid('query', {
        ClassName: 'PHA.IP.Loc.Query',
        QueryName: 'PhaLocation',
        pJsonStr: JSON.stringify({ hosp: PHA_COM.Session.HOSPID }),
        rows: 999
    });
}

function Delete() {
    var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ���Ŀ���',
            type: 'alert',
            timeout: 1000
        });
        return;
    }

    PHA.Confirm('ɾ����ʾ', '��ȷ��ɾ����?', function () {
        var rowID = gridSelect.phaLoc || '';
        var rowIndex = $('#gridLoc').datagrid('getRowIndex', gridSelect);
        if (rowID != '') {
            var dataArr = [];
            dataArr.push(rowID);
            var retJson = $.cm(
                {
                    ClassName: 'PHA.IP.Data.Api',
                    MethodName: 'HandleInAll',
                    pClassName: 'PHA.IP.Loc.Save',
                    pMethodName: 'Delete',
                    pJsonStr: JSON.stringify(dataArr)
                },
                false
            );
            if (retJson.success === 'N') {
                PHA.Alert('��ʾ', retJson.message, 'warning');
                return;
            }
        }
        $('#gridLoc').datagrid('deleteRow', rowIndex);
        Clear();
    });
}

function QueryPhaLocation() {
    var phaLoc = Get.PhaLoc();

    $.cm(
        {
            ClassName: 'PHA.IP.Loc.Query',
            MethodName: 'SelectPhaLocation',
            rowID: phaLoc,
            ResultSetType: 'Array'
        },
        function (arrData) {
            PHA.DomData('#js-data-detail', {
                doType: 'clear'
            });
            if (arrData.msg) {
                PHA.Alert('������ʾ', arrData.msg, 'error');
            } else {
                PHA.SetVals(arrData);
                var jsonData = arrData[0];
                $('#resFlag').switchbox('setValue', jsonData.resFlag === 'Y' ? true : false);
                var dispDefaultFlag = jsonData.dispDefaultFlag;
                $('#dispDefaultFlag').keywords('clearAllSelected');
                if (dispDefaultFlag === '0' || dispDefaultFlag === '1') {
                    $('#dispDefaultFlag').keywords('select', parseInt(dispDefaultFlag) + 1);
                } else if (dispDefaultFlag === '2') {
                    $('#dispDefaultFlag').keywords('select', 1);
                    $('#dispDefaultFlag').keywords('select', 2);
                }
            }
        },
        function () {}
    );
}
function SavePhaLocation() {
    var phaLoc = Get.PhaLoc();
    if (phaLoc === '') {
        PHA.Popover({
            msg: '����ѡ�����',
            type: 'alert'
        });
        return;
    }
    var valsArr = PHA.DomData('.js-data-detail', {
        doType: 'save',
        retType: 'Json'
    });

    valsArr[0].dispDefaultFlag = Get.DispDefaultFlag();
    valsArr[0].resFlag = $('#resFlag').switchbox('getValue');
    valsArr[0].phaLoc = phaLoc;

    var valsStr = valsArr.join('^');
    if (valsStr == '') {
        return;
    }

    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.Loc.Save',
            pMethodName: 'SavePhaLoctionHandler',
            pJsonStr: JSON.stringify(valsArr)
        },
        false
    );

    if (retJson.success === 'N') {
        var msg = PHAIP_COM.DataApi.Msg(retJson);
        PHA.Alert('��ʾ', msg, 'warning');
        return;
    }
    PHA.Popover({
        msg: '����ɹ�',
        type: 'success'
    });

    QueryDetail();
}

function InitHosp() {
    var hospComp = GenHospComp('PHA-IP-LocConfig', '', { width: 245 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        $('#gridLoc').datagrid('getColumnOption', 'loc').editor.options.url = PHA_STORE.CTLoc().url;
        Query();
    };
}

var Get = {
    PhaLoc: function () {
        var sel = $('#gridLoc').datagrid('getSelected') || '';
        if (sel === '') {
            return '';
        }
        return sel.phaLoc || '';
    },
    Loc: function () {
        var sel = $('#gridLoc').datagrid('getSelected') || '';
        if (sel === '') {
            return '';
        }
        return sel.loc || '';
    },
    DispDefaultFlag: function () {
        var dispDefaultData = $('#dispDefaultFlag').keywords('getSelected');
        if (dispDefaultData.length === 2) {
            return 2;
        } else if (dispDefaultData.length === 1) {
            return dispDefaultData[0].id - 1;
        }
        return '';
    }
};
