/**
 * �ɹ��ƻ� - �����ƻ� - ��������
 * @creator �ƺ���
 */
//  PHA_SYS_SET = undefined; // ������

$(function () {
    if(self.frameElement.parentElement.id == "pha_in_v3_plan_createbyconsume_win"){
        $("#mainDiv-cons").css('background-color', 'white');
    }
    var biz = {
        data: {
            lastReqLoc: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-30'),
                    endDate: PHA_UTIL.GetDate('t'),
                    bizRange: ['P,PH', 'Y,YH', 'F,FH', 'H,HH', 'T', 'K'],
                    loc: session['LOGON.CTLOCID'],
                    reqLoc: session['LOGON.CTLOCID'],
                    needDays: '30',
                    roundType: 'PurchUom',
                    roundPercent: '0.5'
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
            switch (key) {
                case 'aspID':
                    break;
                case 'status':
                    if (data === '') {
                        this.data[key] = 'SAVE';
                    }
                    ControlOperation();
                    break;
                default:
                    break;
            }
        }
    };
    var components = PLAN_COMPONENTS();
    var com = PLAN_COM;
    var settings = com.GetSettings();
    components('Loc', 'loc');
    components('Loc', 'reqLoc');
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('StkCat', 'stkCat', {
        qParams: {
            CatGrpId: PHA_UX.Get('stkCatGrp', '')
        },
        width: 300
    });
    components('StkCatGrp', 'stkCatGrp', {
        onHidePanel: function () {
            $('#stkCat').combobox('clear').combobox('reload');
        },
        width: 300
    });
    components('BizRange', 'bizRange');
    components('LimitRange', 'limitRange', {
        width: 300,
        onHidePanel: function () {
            var lastlastReqLoc = $('#reqLoc').combobox('getValue')
            if(lastlastReqLoc != "") biz.setData('lastReqLoc', lastlastReqLoc);
            if (IsHospConsume()) {               
                biz.setData('lastReqLoc', $('#reqLoc').combobox('getValue'));
                $('#reqLoc').combobox('clear');
                $('#reqLoc').combobox('disable');
                PHA.DataPha.Set('reqLoc', { required: false });
            } else {
                $('#reqLoc').combobox('enable');
                $('#reqLoc').combobox('setValue', biz.getData('lastReqLoc'));
                PHA.DataPha.Set('reqLoc', { required: true });
            }
            PHA.SetRequired($('#reqLoc'));
        }
    });
    components('RoundPercent', 'roundPercent');
    components('RoundType', 'roundType');

    InitGridPlan();
    PHA_EVENT.Bind('#btnSetQty2Advice', 'click', function (e) {
        // var btnID = $(e.target).closest('[id]').attr('id');
        var firstRows = $('#gridPlan').datagrid('getData').firstRows || [];
        firstRows.forEach(function (ele, index) {
            if (ele.qty === '' || ele.qty === undefined) {
                ele.qty = ele.adviceQty;
            }
        });

        $('#gridPlan').datagrid('loadData', {
            total: firstRows.length,
            rows: firstRows
        });
    });
    PHA_EVENT.Bind('#btnSetQty2Zero', 'click', function (e) {
        var firstRows = $('#gridPlan').datagrid('getData').firstRows || [];
        firstRows.forEach(function (ele, index) {
            if (ele.qty === '' || ele.qty === undefined) {
                ele.qty = 0;
            }
        });
        $('#gridPlan').datagrid('loadData', {
            total: firstRows.length,
            rows: firstRows
        });
    });
    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get');
        if (qJson === undefined) {
            return;
        }
        $('#gridPlan').datagrid('clearChecked');
        com.LoadData('gridPlan', {
            pJson: JSON.stringify(qJson),
            pMethodName: 'GetDataRows4Consume',
            pPlug: ''
        });
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridPlan').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        Save();
    });
    PHA_EVENT.Bind('#btnCopyGo', 'click', function () {
        CopyGo();
    });
    PHA_EVENT.Bind('#btnCheckAll', 'click', function (e) {
        $('#gridPlan').datagrid('checkAll');
    });
    PHA_EVENT.Bind('#btnUnCheckAll', 'click', function (e) {
        $('#gridPlan').datagrid('uncheckAll');
    });
    PHA_EVENT.Bind('#btnDelete', 'click', function () {
        var $grid = $('#gridPlan');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '���ȹ�ѡ��Ҫɾ��������');
            return;
        }
        PHA.Confirm('��ʾ', '��ȷ��ɾ��' + checkedRows.length + '����¼��?', function () {
            var rows = $grid.datagrid('getRows');
           	for (i=checkedRows.length - 1;i>=0;i--){
	           	const chkit = checkedRows[i];
                var rowIndex = rows.indexOf(chkit);
                $grid.datagrid('deleteRow', rowIndex);
            }
        });
    });
    function IsHospConsume() {
        return $('#limitRange').combobox('getValues').indexOf('HospConsume') < 0 ? false : true;
    }
    function CopyGo() {
        if (!PHA_GridEditor.End('gridPlan')) {
            return;
        }
        var mainObj = {
            planID: '',
            mainRowID: '',
            loc: $('#loc').combobox('getValue') || '',
            remarks: '�������ĸ����Ƶ�'
        };
        var reqLoc = $('#reqLoc').combobox('getValue');
        if (IsHospConsume()) {
            reqLoc = '';
        }
        var rows = [];
        var count = $('#gridPlan').datagrid('getRows').length;
        if(count){
	        for (const it of $('#gridPlan').datagrid('getData').firstRows) {
	            if (it.check === 'Y') {
	                rows.push({
	                    inci: it.inci,
	                    qty: it.qty,
	                    uom: it.uom,
	                    vendor: it.vendor,
	                    manf: it.manf,
	                    rp: it.rp,
	                    sp: it.sp,
	                    adviceQty: it.adviceQty,
	                    reqLoc: reqLoc,
	                    consumeQty: it.consumeQty
	                });
	            }
	        }
        }
        if (rows.length === 0) {
            components('Pop', '���ȹ�ѡ��¼');
            return;
        }

        var data4copy = {
            main: mainObj,
            rows: rows
        };

        PHA.Confirm('��ʾ', '��ȷ�ϸ��ƹ�ѡ��¼���Ƶ�������</br>���������Ƶ���������޸�</br>��ע�⼰ʱ����', function () {
            com.Invoke('GenerateCreateData', data4copy, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    PHA_COM.TOP.Set('pha.in.v3.plan.create.csp_copy', retData);
                    if (top.$('#pha_in_v3_plan_createbyconsume_win').html()) {
                        top.$('#pha_in_v3_plan_createbyconsume_win').window('close');
                    } else {
                        PHA_COM.GotoMenu({
                            title: '�ɹ��ƻ��Ƶ�',
                            url: 'pha.in.v3.plan.create.csp'
                        });
                    }
                }
            });
        });
    }
    function Save() {
        if (!PHA_GridEditor.EndCheck('gridPlan')) {
            return;
        }
        var mainObj = {
            planID: '',
            mainRowID: '',
            loc: $('#loc').combobox('getValue') || ''
        };
        var reqLoc = $('#reqLoc').combobox('getValue');
        if (IsHospConsume()) {
            reqLoc = '';
        }
        var rows = [],
            row4save = [];
        for (const it of $('#gridPlan').datagrid('getData').rows) {
            if (it.qty !== '' && it.qty !== undefined) {
                var row4save = {
                    inci: it.inci,
                    qty: it.qty,
                    uom: it.uom,
                    vendor: it.vendor,
                    manf: it.manf,
                    rp: it.rp,
                    sp: it.sp,
                    adviceQty: it.adviceQty,
                    reqLoc: reqLoc,
                    consumeQty: it.consumeQty
                };

                rows.push(row4save);
            }
        }

        if (rows.length === 0) {
            components('Pop', '����¼������');
            return;
        }
        PHA.Confirm('��ʾ', 'ȷ�ϱ�����', function () {
            var data4save = {
                main: mainObj,
                rows: rows
            };

            com.Invoke('HandleSave', data4save, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    com.Top.Set('planID', retData.data);
                    window.location.href = 'pha.in.v3.plan.create.csp';
                }
            });
        });
    }

    /**
     * ���±������
     * @param {string} field    ��
     * @param {*}      data     �е�����, �༭ʱ��
     * @param {*}      rowData  ����ǰ��������
     * @param {*}      rowIndex ��
     */
    function HandleGridRow(field, data, rowData, rowIndex) {
        // 'uom', data, rowData, gridRowIndex
        if (field === 'uom') {
            var dataUom = data.RowId;
            if (dataUom === rowData.uom) {
                // û��
                return;
            }
            var qtyFuncName = '';
            var priceFunName = '';
            if (dataUom === rowData.pUom) {
                qtyFuncName = 'divide';
                priceFunName = 'multiply';
            } else {
                qtyFuncName = 'multiply';
                priceFunName = 'divide';
            }
            var updateRow = {
                locQty: _[qtyFuncName](rowData.locQty, rowData.fac),
                maxQty: _[qtyFuncName](rowData.maxQty, rowData.fac),
                minQty: _[qtyFuncName](rowData.minQty, rowData.fac),
                repQty: _[qtyFuncName](rowData.repQty, rowData.fac),
                adviceQty: _[qtyFuncName](rowData.adviceQty, rowData.fac),
                rp: _[priceFunName](rowData.rp, rowData.fac)
            };
            // $.extend(rowData, updateRow);
            setTimeout(function () {
                $('#gridPlan').datagrid('updateRow', {
                    index: rowIndex,
                    row: updateRow
                });
            }, 0);
        }
    }
    // ********************************** //
    // *************init***************** //
    // ********************************** //
    function InitGridPlan() {
        var frozenColumns = [
            [
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'gOperate',
                    title: '����',
                    width: 40,
                    align: 'center',
                    formatter: function () {
                        var retArr = [];
                        retArr.push('<span class="pha-grid-a icon icon-cancel js-pha-grid-delete" title="ɾ��"></span>');
                        return retArr.join('');
                    }
                },
                {
                    field: 'inci',
                    title: 'inci',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'inciCode',
                    title: 'ҩƷ����',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 200,
                    sortable: true
                },

                {
                    field: 'qty',
                    title: '�ɹ�����',
                    width: 75,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        required: false,
                        onBeforeNext: function (data, rowData, rowIndex) {
                            HandleGridRow('qty', data, rowData, rowIndex);
                            return true;
                        }
                    })
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'uom',
                    title: '��λ',
                    width: 75,
                    descField: 'uomDesc',
                    formatter: function (value, row, index) {
                        return row[this.descField];
                    }
                    // ,
                    // editor: PHA_GridEditor.ComboBox({
                    //     required: true,
                    //     tipPosition: 'top',
                    //     loadRemote: true,
                    //     panelHeight: 'auto',
                    //     url: PHA_STORE.CTUOMWithInci().url,
                    //     onBeforeLoad: function (param) {
                    //         var curRowData = PHA_GridEditor.CurRowData('gridPlan');
                    //         param.InciDr = curRowData.inci || '';
                    //     },
                    //     onBeforeNext: function (data, rowData, rowIndex) {
                    //         HandleGridRow('uom', data, rowData, rowIndex);
                    //         return true;
                    //     }
                    // })
                },
                {
                    field: 'adviceQty',
                    title: '��������',
                    width: 75,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'consumeQty',
                    title: '��������',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'avgConsumeQty',
                    title: '�վ���������',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 150,
                    sortable: true
                },
                {
                    field: 'vendorDesc',
                    title: '��Ӫ��ҵ',
                    width: 150,
                    sortable: true
                },
                {
                    field: 'carrierDesc',
                    title: '������ҵ',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'rp',
                    title: '����',
                    width: 75,
                    align: 'right',
                    sortable: true
                },

                {
                    field: 'locQty',
                    title: '�ɹ����ҿ��',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'reqLocQty',
                    title: '�깺���ҿ��',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'hospQty',
                    title: 'ȫԺ���',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'repQty',
                    title: '��׼���',
                    width: 75,
                    align: 'right'
                },
                {
                    field: 'maxQty',
                    title: '�������',
                    width: 75,
                    align: 'right'
                },
                {
                    field: 'minQty',
                    title: '�������',
                    width: 75,
                    align: 'right'
                },

                {
                    field: 'repLev',
                    title: '������׼',
                    width: 75,
                    align: 'right'
                },
                {
                    field: 'packSpec',
                    title: '���װ���',
                    width: 100
                }
            ]
        ];
        var dataGridOption = {
            url: null,
            pageSize: 30,
            pageList: [30, 200, 500, 1000, 2000, 10000],
            pagination: true,
            frozenColumns: frozenColumns,
            columns: columns,
            toolbar: '#gridPlanBar',
            enableDnd: false,
            fitColumns: false,
            exportXls: false,
            singleSelect: false,
            rownumbers: true,
            view: scrollview,
            onClickCell: function (index, field, value) {
                if (field !== 'qty') {
                    return;
                }
                $('#gridPlan').datagrid('uncheckRow', index);
                PHA_GridEditor.Edit({
                    gridID: 'gridPlan',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            },
            onLoadSuccess: function (data) {
                var $grid = $(this);
                $grid.datagrid('options').checking = true;
                $grid.datagrid('options').selectOnCheck = false;
                var row0Data = data.rows[0];
                if (row0Data) {
                    var firstRows = $grid.datagrid('getData').firstRows;
                    var showTargets = $('[datagrid-row-index]');
                    for (var i = 0, length = showTargets.length; i < length; i++) {
                        var ele = showTargets[i];
                        var showIndex = $(ele).attr('datagrid-row-index');
                        var showIndexRowData = firstRows[showIndex];
                        if (showIndexRowData.check === 'Y') {
                            $grid.datagrid('checkRow', showIndex);
                        } else {
                            $grid.datagrid('uncheckRow', showIndex);
                        }
                    }
                } else {
                }
                $grid.datagrid('loaded');
                $grid.datagrid('options').selectOnCheck = true;
                $('.datagrid-row-checked').addClass('datagrid-row-selected');
                $grid.datagrid('options').checking = false;
            },
            onCheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                $(this).datagrid('getData').firstRows[rowIndex].check = 'Y';
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                $(this).datagrid('getData').firstRows[rowIndex].check = 'N';
            },
            onCheckAll: function () {
                if ($(this).datagrid('getData').firstRows) {
                    $(this)
                        .datagrid('getData')
                        .firstRows.forEach(function (ele) {
                            ele.check = 'Y';
                        });
                }
            },
            onUncheckAll: function () {
                if ($(this).datagrid('getData').firstRows) {
                    $(this)
                        .datagrid('getData')
                        .firstRows.forEach(function (ele) {
                            ele.check = 'N';
                        });
                }
            }
        };
        PHA.Grid('gridPlan', $.extend(dataGridOption, {}));
        var eventClassArr = ['pha-grid-a icon icon-cancel js-pha-grid-delete'];
        PHA.GridEvent('gridPlan', 'click', eventClassArr, function (rowIndex, rowData, className) {
            if (className.indexOf('js-pha-grid-delete') >= 0) {
                $('#gridPlan').datagrid('deleteRow', rowIndex);
            }
        });
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        // �Ȳ��Ǻ�, �����ú�������
        $.extend(biz.getData('defaultData')[0], settings.DefaultData);

        PHA.SetRequired($('#qCondition [data-pha]'));
        $('#limitRange').combobox({ width: $('#limitRange').closest('td').next().position().left - $('#limitRange').closest('td').position().left - 10 });
        $('#bizRange').combobox({ width: $('#bizRange').closest('td').next().position().left - $('#bizRange').closest('td').position().left - 10 });
        PHA.SetVals(biz.getData('defaultData'));
        com.SetPage('pha.in.v3.plan.createbyconsume.csp');
    }, 0);
});