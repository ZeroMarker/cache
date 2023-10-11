/**
 * 住院药房 - 发药类别维护
 * @author yunhaibao
 * @since  2020-11-02
 */
PHA_COM.App.Csp = 'pha.ip.v4.dispcat.csp';
PHA_COM.App.Name = 'IP.DISPCAT';
PHA_COM.App.Load = '';
$(function () {
    InitDict();
    InitHosp();
    InitGridDispCat();
    InitGridDispCatItm();
    InitGridArcCat();
    InitEvents();
});

function InitDict() {
    PHAIP_DISPCAT_PrtCode = PHA.EditGrid.ComboBox({
        panelHeight: 'auto',
        editable: true,
        multiple:true,
        editable:false,
        rowStyle:'checkbox',
        data: [
            { RowId: 'PrintKFYBag', Description: $g('打印长期口服药袋') },
            { RowId: 'ControlPrintOutGroupByPat', Description: $g('按患者打印明细') }
        ]
    });
}
// 事件
function InitEvents() {
    $('#btnAdd').on('click', function () {
        Clear();
        $('#gridDispCat').datagrid('addNewRow', {
            editField: 'code',
            defaultRow: {
                rowID: ''
            }
        });
    });
    $('#btnSave').on('click', Save);
    $('#btnFind').on('click', Query);
    $('#btnDel').on('click', Delete);
}

function InitGridDispCat() {
    var EG_CheckBox = {
        type: 'icheckbox',
        options: {
            on: '1',
            off: '0'
        }
    };

    var columns = [
        [
            {
                field: 'rowID',
                title: '类别ID',
                hidden: true,
                width: 100
            },
            {
                field: 'code',
                title: '代码',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'desc',
                title: '名称',
                width: 150,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'resFlag',
                title: '冲减退药',
                width: 100,
                align: 'center',
                formatter: FormatterCheck,
                editor: EG_CheckBox
            },
            {
                field: 'autoReqFlag',
                title: '自动建立退药申请',
                width: 150,
                align: 'center',
                formatter: FormatterCheck,
                editor: EG_CheckBox
            },
            {
                field: 'previewFlag',
                title: '预览打印',
                width: 100,
                align: 'center',
                formatter: FormatterCheck,
                editor: EG_CheckBox
            },
            {
                field: 'prtDetail',
                title: '打印明细',
                width: 100,
                align: 'center',
                formatter: FormatterCheck,
                editor: EG_CheckBox
            },
            {
                field: 'prtTotal',
                title: '打印汇总',
                width: 100,
                align: 'center',
                formatter: FormatterCheck,
                editor: EG_CheckBox
            },
            {
                field: 'prtResFlag',
                title: '打印冲减退药单',
                width: 150,
                align: 'center',
                formatter: FormatterCheck,
                editor: EG_CheckBox
            },
            {
                field: 'prtNoStock',
                title: '打印库存不足单',
                width: 150,
                align: 'center',
                formatter: FormatterCheck,
                editor: EG_CheckBox
            },
            {
                field: 'prtCode',
                title: '打印扩展',
                width: $('#panelDispCat').width() - 1128,
                editor: PHAIP_DISPCAT_PrtCode,
                formatter: function (value, row, index) {
                    value = value||'';
                    var descArr = GetDescInArray(PHAIP_DISPCAT_PrtCode.options.data, value.split(','));
                    return descArr;
                }
            }
            // ,
            // {
            //     field: 'prtCode',
            //     title: '打印函数',
            //     width: $('#panelDispCat').width() - 1128,
            //     editor: {
            //         type: 'validatebox'
            //     }
            // }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IP.DispCat.Query',
            QueryName: 'DispCat',
            pJsonStr: JSON.stringify({ hosp: PHA_COM.Session.HOSPID }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: null,
        toolbar: '#gridDispCatBar',
        enableDnd: false,
        fitColumns: false,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            QueryItm();
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'code'
                });
            }
        },
        onLoadSuccess: function () {
            Clear();
        }
    };

    PHA.Grid('gridDispCat', dataGridOption);

    function FormatterCheck(value, row, index) {
        if (value === 'Y' || value === '1') {
            return PHA_COM.Fmt.Grid.Yes.Chinese;
        } else {
            // return ''
            return PHA_COM.Fmt.Grid.No.Chinese;
        }
    }
}

function InitGridDispCatItm() {
    var columns = [
        [
            {
                field: 'rowID',
                title: 'rowID',
                hidden: true,
                width: 100
            },
            {
                field: 'arcCatDesc',
                title: '医嘱子类',
                width: 200
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        exportXls: false,
        pagination: false,
        columns: columns,
        fitColumns: true,
        toolbar: [],
        loadMsg: null,
        loadingMessage: null,
        onDblClickRow: function (rowIndex, rowData) {
            SaveItm(rowData);
        },
        onLoadSuccess: function () {
            SwitchHandler();
        }
    };
    PHA.Grid('gridDispCatItm', dataGridOption);
}
function SwitchHandler() {
    $('td[field="wholeFlag"] .hisui-switchbox').switchbox({
        onClass: 'success',
        offClass: 'gray',
        onText: '是',
        offText: '否',
        size: 'small',
        animated: true,
        onSwitchChange: UpdateItm
    });
}
function UpdateItm(event, obj) {
    var $target = $(event.target);
    var $tr = $target.closest('tr');
    var field = $(event.target).closest('td').attr('field');
    var rowIndex = $tr.attr('datagrid-row-index');
    var rowData = $('#gridDispCatItm').datagrid('getRows')[rowIndex];
    var rowID = $tr.find('[field="rowID"]').text();

    var data = {
        rowID: rowID
    };
    data.wholeFlag = obj.value === true ? 'Y' : 'N';

    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.DispCat.Save',
            pMethodName: 'UpdateItmHandler',
            pJsonStr: JSON.stringify([data])
        },
        function (retJson) {
            if (retJson.success === 'N') {
                var msg = PHAIP_COM.DataApi.Msg(retJson);
                PHA.Alert('提示', msg, 'warning');
            } else {
                PHA.Popover({
                    msg: '设置成功',
                    type: 'success',
                    timeout: 500
                });
            }
            $('#gridDispCatItm').datagrid('reload');
        }
    );
}
function InitGridArcCat() {
    var columns = [
        [
            {
                field: 'arcCatObj1',
                title: '医嘱子类',
                width: 220,
                formatter: Formatter
            },
            {
                field: 'arcCatObj2',
                title: '医嘱子类',
                width: 220,
                formatter: Formatter
            },
            {
                field: 'arcCatObj3',
                title: '医嘱子类',
                width: 220,
                formatter: Formatter
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        toolbar: [],
        enableDnd: false,
        exportXls: false,
        loadMsg: null,
        loadingMessage: null,
        fitColumns: true,
        onDblClickCell: function (index, field, value) {
            var dispCat = Get.DispCat();
            var valJson = JSON.parse(value);
            var msgInfo = '';
            if (dispCat === '') {
                msgInfo = '请先保存发药类别';
            } else if (valJson.dispCatDesc !== '') {
                msgInfo = '医嘱子类已关联发药类别, 请先取消对应关联';
            } else if (valJson.arcCat === '') {
                return;
            }
            if (msgInfo !== '') {
                PHA.Popover({
                    msg: msgInfo,
                    type: 'alert'
                });
                return;
            }
            var data = {
                parRef: dispCat,
                rowID: '',
                arcCat: valJson.arcCat
            };
            SaveItm(data);
        },
        onLoadSuccess: function () {
            $(this).datagrid('enableCellSelecting');
        }
    };

    PHA.Grid('gridArcCat', dataGridOption);

    function Formatter(value, row, index) {
        var jsonData = JSON.parse(value);
        var arcCatDesc = jsonData.arcCatDesc;
        if (arcCatDesc === '') {
            return '';
        }
        var dispCatDesc = jsonData.dispCatDesc;

        var htmlArr = [];
        htmlArr.push('<div class="pha-arccat">');
        htmlArr.push('  <div style="width:50%">' + arcCatDesc + '</div>');
        if (dispCatDesc !== '') {
            htmlArr.push('  <div style="width:20%;"><div class="pha-contain pha-include">关联</div></div>');
            htmlArr.push('  <div style="width:30%">' + dispCatDesc + '</div>');
        } else {
            htmlArr.push('  <div style="width:40%;"><div class="pha-contain pha-exclude">未关联</div></div>');
        }

        htmlArr.push('</div');
        return htmlArr.join('');
    }
}

function Query() {
    $('#gridDispCat').datagrid('query', {
        ClassName: 'PHA.IP.DispCat.Query',
        QueryName: 'DispCat',
        pJsonStr: JSON.stringify({ hosp: PHA_COM.Session.HOSPID }),
        rows: 999
    });
}

function Delete() {
    var gridSelect = $('#gridDispCat').datagrid('getSelected');
    if (gridSelect === null) {
        PHA.Popover({
            msg: '请先选中需要删除的发药类别',
            type: 'alert'
        });
        return '';
    }
    var rowID = gridSelect.rowID || '';
    var rowIndex = $('#gridDispCat').datagrid('getRowIndex', gridSelect);
    var msgHtmlArr = [];

    msgHtmlArr.push('<div>您正在操作 <span style="color:red;font-weight:bold">删除 核心数据</span></div>');
    msgHtmlArr.push('<div>请确保该发药类别尚未下医嘱</div>');
    msgHtmlArr.push('<div>请谨慎操作</div>');

    PHA.ConfirmPrompt(
        '删除提示',
        msgHtmlArr.join(''),
        function () {
            if (rowID !== '') {
                var dataArr = [];
                dataArr.push({
                    rowID: rowID,
                    hosp: PHA_COM.Session.HOSPID
                });
                var retJson = $.cm(
                    {
                        ClassName: 'PHA.IP.Data.Api',
                        MethodName: 'HandleInAll',
                        pClassName: 'PHA.IP.DispCat.Save',
                        pMethodName: 'DeleteHandler',
                        pJsonStr: JSON.stringify(dataArr)
                    },
                    false
                );
                if (retJson.success === 'N') {
                    var msg = PHAIP_COM.DataApi.Msg(retJson);
                    PHA.Alert('提示', msg, 'warning');
                    return;
                }
            }
            PHA.Popover({
                msg: '删除成功',
                type: 'success'
            });
            $('#gridDispCat').datagrid('deleteRow', rowIndex);
            Clear();
        },
        '删除'
    );
}

function Save() {
    var $grid = $('#gridDispCat');
    if ($grid.datagrid('endEditing') === false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }

    var repeatObj = $grid.datagrid('checkRepeat', [['code'], ['desc']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '第' + (repeatObj.pos + 1) + '、' + (repeatObj.repeatPos + 1) + '行:' + repeatObj.titleArr.join('、') + '重复',
            type: 'alert'
        });
        return;
    }

    var dataArr = [];
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($grid.datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        iData.hosp = PHA_COM.Session.HOSPID;
        dataArr.push(iData);
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.DispCat.Save',
            pMethodName: 'SaveHandler',
            pJsonStr: JSON.stringify(dataArr)
        },
        false
    );
    if (retJson.success === 'N') {
        var msg = PHAIP_COM.DataApi.Msg(retJson);
        PHA.Alert('提示', msg, 'warning');
    } else {
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
        $grid.datagrid('reload');
    }
}
function SaveItm(rowData) {
    var rowID = rowData.rowID;
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.DispCat.Save',
            pMethodName: 'SaveItmHandler',
            pJsonStr: JSON.stringify([
                {
                    rowID: rowID,
                    parRef: rowData.parRef || '',
                    arcCat: rowData.arcCat || '',
                    hosp: PHA_COM.Session.HOSPID
                }
            ])
        },
        false
    );
    if (retJson.success === 'N') {
        PHA.Alert('提示', retJson.message, 'warning');
    } else {
        PHA.Popover({
            msg: (rowID !== '' ? '取消' : '') + '关联成功',
            type: 'success',
            timeout: 500
        });
    }
    $('#gridDispCatItm').datagrid('reload');
    $('#gridArcCat').datagrid('reload');
}

function QueryItm() {
    var dispCat = Get.DispCat();
    var dispCatCode = $('#gridDispCat').datagrid('getSelected').code;
    if (dispCat === '' || dispCatCode === 'OUT') {
        Clear();
        return;
    }
    $('#gridDispCatItm').datagrid('options').url = $URL;
    $('#gridDispCatItm').datagrid('query', {
        ClassName: 'PHA.IP.DispCat.Query',
        QueryName: 'DispCatItm',
        pJsonStr: JSON.stringify({ dispCat: dispCat }),
        rows: 9999
    });

    $('#gridArcCat').datagrid('options').url = $URL;
    $('#gridArcCat').datagrid('query', {
        ClassName: 'PHA.IP.DispCat.Query',
        QueryName: 'ArcCat',
        pJsonStr: JSON.stringify({ hosp: PHA_COM.Session.HOSPID }),
        rows: 9999
    });
}

var Get = {
    DispCat: function () {
        var gridSelect = $('#gridDispCat').datagrid('getSelected');
        if (gridSelect === null) {
            return '';
        }
        return gridSelect.rowID || '';
    }
};

function Clear() {
    $('#gridDispCatItm').datagrid('clear');
    $('#gridArcCat').datagrid('clear');
}

function InitHosp() {
    var hospComp = GenHospComp('DHCStkDrugGroup');
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        Query();
    };
    var defHosp = $.cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHCStkDrugGroup',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function GetDescInArray(arrData, idArr) {
    var retArr = [];
    if (idArr.length === 0) {
        return [];
    }
    for (var i = 0, length = idArr.length; i < length; i++) {
        for (var j = 0, jLength = arrData.length; j < jLength; j++) {
            if (arrData[j].RowId == idArr[i]) {
                retArr.push(arrData[j].Description);
            }
        }
    }
    return retArr;
}
