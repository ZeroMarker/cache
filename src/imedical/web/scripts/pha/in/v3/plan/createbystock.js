/**
 * �ɹ��ƻ� - �����ƻ� - ���ݿ��
 * @creator     �ƺ���
 */
// PHA_SYS_SET = undefined; // ������

$(function () {
    if(self.frameElement.parentElement.id == "pha_in_v3_plan_createbystock_win"){
        $("#mainDiv-stock").css('background-color', 'white');
    }
    var biz = {
        data: {
            history: [],
            defaultData: [
                {
                    loc: session['LOGON.CTLOCID'],
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
        }
    };
    var components = PLAN_COMPONENTS();
    var com = PLAN_COM;
    var settings = com.GetSettings();

    components('Loc', 'loc');
    components('StkCat', 'stkCat', {
        qParams: {
            CatGrpId: PHA_UX.Get('stkCatGrp', '')
        }
    });
    components('StkCatGrp', 'stkCatGrp', {
        onHidePanel: function () {
            $('#stkCat').combobox('clear').combobox('reload');
        }
    });
    components('RoundPercent', 'roundPercent');
    components('CommonRange', 'commonRange');
    components('RoundType', 'roundType');
    InitGrid();

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        $('#gridPlan').datagrid('clearChecked');
        com.LoadData('gridPlan', {
            pJson: JSON.stringify(com.Condition('#qCondition', 'get')),
            pMethodName: 'GetDataRows4Stock'
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
    PHA_EVENT.Bind('#btnDelete', 'click', function () {
        var $grid = $('#gridPlan');
        var checkedRows = PHA_COM.ScrollGrid.GetChecked('#gridPlan');
        if (checkedRows.length === 0) {
            components('Pop', '���ȹ�ѡ��Ҫɾ��������');
            return;
        }

        PHA.Confirm('��ʾ', '��ȷ��ɾ��' + checkedRows.length + '����¼��?', function () {
            var rows = $grid.datagrid('getData').firstRows;
            for (i=checkedRows.length - 1;i>=0;i--){
	           	const chkit = checkedRows[i];
                var rowIndex = rows.indexOf(chkit);
                $grid.datagrid('deleteRow', rowIndex);
            }
        });
    });

    PHA_EVENT.Bind('#btnSetQty2Advice', 'click', function (e) {
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
    PHA_EVENT.Bind('#btnCheckAll', 'click', function (e) {
        $('#gridPlan').datagrid('checkAll');
    });
    PHA_EVENT.Bind('#btnUnCheckAll', 'click', function (e) {
        $('#gridPlan').datagrid('uncheckAll');
    });
    function CopyGo() {
        if (!PHA_GridEditor.End('gridPlan')) {
            return;
        }
        var mainObj = {
            planID: '',
            mainRowID: '',
            loc: $('#loc').combobox('getValue') || '',
            remarks: '���ݱ�׼��渨���Ƶ�'
        };
        var rows = [];
        var count = $('#gridPlan').datagrid('getRows').length;
        if(count){
	        for (const it of $('#gridPlan').datagrid('getData').firstRows) {
	            if (it.check === 'Y') {
	                rows.push({ inci: it.inci, qty: it.qty, uom: it.uom, adviceQty: it.adviceQty });
	            }
	        }
        }
        if (rows.length === 0) {
            components('Pop', '����ѡ���¼');
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
                    if (top.$('#pha_in_v3_plan_createbystock_win').html()) {
                        top.$('#pha_in_v3_plan_createbystock_win').window('close');
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
        if (!PHA_GridEditor.End('gridPlan')) {
            return;
        }

        var mainObj = {
            planID: '',
            mainRowID: '',
            loc: $('#loc').combobox('getValue') || ''
        };
        var rows = [];
        for (const it of $('#gridPlan').datagrid('getData').rows) {
            if (it.qty !== '' && it.qty !== undefined) {
                rows.push({ inci: it.inci, qty: it.qty, uom: it.uom, vendor: it.vendor, manf: it.manf, rp: it.rp, sp: it.sp, adviceQty: it.adviceQty });
            }
        }

        if (rows.length === 0) {
            components('Pop', '����¼������');
            return;
        }

        var data4save = {
            main: mainObj,
            rows: rows
        };
        PHA.Confirm('��ʾ', 'ȷ�ϱ�����', function () {
            com.Invoke('HandleSave4Stock', data4save, function (retData) {
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
    function InitGrid() {
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
                    hidden: true
                },
                {
                    field: 'inciCode',
                    title: '����',
                    width: 100
                },
                {
                    field: 'inciDesc',
                    title: '����',
                    width: 200
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
                    align: 'right'
                },
                {
                    field: 'needOriginQty',
                    title: '��������',
                    width: 75,
                    align: 'right'
                },

                {
                    field: 'vendorDesc',
                    title: '��Ӫ��ҵ',
                    width: 150
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 150
                },
                {
                    field: 'carrierDesc',
                    title: '������ҵ',
                    width: 100
                },
                {
                    field: 'rp',
                    title: '����',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'repQty',
                    title: '��׼���',
                    width: 75,
                    align: 'right'
                },
                {
                    field: 'locQty',
                    title: '�ɹ����ҿ��',
                    width: 75,
                    align: 'right',
                    styler: function () {
                        return 'font-weight:bold;';
                    }
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
            pageSize: 200,
            pageList: [30, 200, 500, 1000, 10000],
            pagination: true,
            pageNumber: 1,
            frozenColumns: frozenColumns,
            columns: columns,
            toolbar: '#gridPlanBar',
            enableDnd: false,
            fitColumns: false,
            exportXls: false,
            singleSelect: false,
            // selectOnCheck:false,
            // checkOnSelect:false,
            view: scrollview,
            rownumbers: true,
            showComCol: true,
            shiftCheck: true,
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
        PHA.Grid('gridPlan', dataGridOption);
        var eventClassArr = ['pha-grid-a icon icon-cancel js-pha-grid-delete'];
        PHA.GridEvent('gridPlan', 'click', eventClassArr, function (rowIndex, rowData, className) {
            if (className.indexOf('js-pha-grid-delete') >= 0) {
                $('#gridPlan').datagrid('deleteRow', rowIndex);
                // $.popconfirm({
                //     content: '��ȷ��ɾ��һ����¼��?',
                //     handler: {
                //         confirm: function () {
                //             $('#gridPlan').datagrid('deleteRow', rowIndex);
                //         }
                //     }
                // });
            }
        });
    }

    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        SetDefaults();
        com.SetPage('pha.in.v3.plan.createbystock.csp');
        $('#stkCat').combobox({ width: $('#stkCat').closest('td').next().position().left - $('#stkCat').closest('td').position().left - 10 });
    }, 0);
});