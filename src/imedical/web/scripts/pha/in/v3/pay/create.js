/**
 * ������� - �Ƶ�
 * @creator �ƺ���
 */

$(function () {
    /**
     * �ڲ�ȫ��, ���ݱ仯ȫ��ͨ��set��ֵ
     */
    var biz = {
        data: {
            payID: '',
            status: 'SAVE',
            handleStatus: ''
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
            switch (key) {
                case 'payID':
                    Select(data);
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
    /**
     * ��ʼ��
     */
    var components = PAY_COMPONENTS();
    var com = PAY_COM;
    var settings = com.GetSettings();
    components('Loc', 'loc');
    components('No', 'no');
    components('Vendor', 'vendor');
    components('Date', 'needDate');
    components('Banner', 'payBanner');
    components('Remarks', 'remarks');
    components('ItmGrid', 'gridItm', {
        toolbar: '#gridItmBar',
        rownumber: true, // ����ǰ�˲�������, ��ֻ�ǳ���Ĭ��
        pagination: false,
        showFooter: true,
        singleSelect: false,
        data: {
            rows: [],
            footer: [{ bizType: '�ϼ�' }],
            total: 0
        },
        onNextCell: function (index, field, value, isLastRow, isLastCol) {
            if (isLastRow && isLastCol) {
            }
        },
        onClickCell: function (index, field, value) {
            if (CanEdit() === false) {
                return;
            }
            PHA_GridEditor.Edit({
                gridID: 'gridItm',
                index: index,
                field: field,
                forceEnd: true
            });
        },
        onLoadSuccess: function (data) {
            var gridID = this.id;
            $(this).datagrid('clearChecked');
            PHA_GridEditor.End(gridID);
            PHA_COM.SumGridFooter(gridID);
            ControlConditionState()
        }
    });
    /**
     * ע���¼�
     */
    PHA_EVENT.Bind('#btnSelect', 'click', function () {
        components('QueryWindow', 'winQueryPay', {
            callBack: function (payID) {
                biz.setData('payID', payID);
            }
        });
    });
    PHA_EVENT.Bind('#btnBiz', 'click', function (e) {
        components('BizWindow', 'winQueryBiz', {
            callBack: function (payID) {
                biz.setData('payID', payID);
            }
        });
    });
    // ��ѡ
    PHA_EVENT.Bind('#btnDeleteItm', 'click', function () {
        biz.setData('handleStatus', 'DeleteItms');
        DeleteChecked();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        Clean();
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        biz.setData('handleStatus', 'Save');
        Save();
    });
    PHA_EVENT.Bind('#btnFinish', 'click', function () {
        biz.setData('handleStatus', 'Finish');
        Save();
    });
    PHA_EVENT.Bind('#btnFinishCancel', 'click', function () {
        biz.setData('handleStatus', 'FinishCancel');
        Save();
    });

    PHA_EVENT.Bind('#btnDelete', 'click', function (e) {
        Delete();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(biz.getData('payID'))
    })
    /**
     * ���ֺ���
     */
    function Save() {
        var funcName = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (funcName === '') {
            return;
        }
        if (ValidateEditGrid() === false) {
            return;
        }
        var data4Save = GetData4Save();
        PHA.Loading('Show');
        com.Invoke(funcName, data4Save, function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                biz.setData('payID', retData.data);
            }
        });
    }
    function GetData4Save() {
        var mainDataObj = com.Condition('#qCondition', 'get', { doType: 'save' });
        mainDataObj.payID = biz.getData('payID');
        mainDataObj.mainRowID = biz.getData('payID');
        mainDataObj.statusCode = biz.getData('handleStatus');
        var saveJson = {
            main: mainDataObj,
            rows: []
        };
        return saveJson;
    }
    function ValidateEditGrid() {
        return true;
    }
    function Clean() {
        com.Condition('#qCondition', 'clear');
        biz.setData('payID', '');
        biz.setData('status', 'SAVE');
        ControlConditionState()
    }

    function Delete(warnMsg) {
        var payID = biz.getData('payID');
        if (payID === '') {
            components('Pop', 'û����Ҫɾ������Ϣ');
            return;
        }
        PHA.Confirm('��ʾ', warnMsg || '��ȷ��ɾ��������?', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { payID: payID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    $('#btnClean').click();
                }
            });
        });
    }
    function DeleteChecked() {
        var $grid = $('#gridItm');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '�빴ѡ��Ҫɾ���ļ�¼');
            return;
        }
        var payItmArr = [];
        for (const rowData of checkedRows) {
            var payItmID = rowData.payItmID || '';
            if (payItmID !== '') {
                payItmArr.push(com.AppendLogonData({ payItmID: payItmID }));
            }
        }

        PHA.Confirm('��ʾ', '��ȷ��ɾ�� ' + checkedRows.length + ' ����ϸ��?', function () {
            if (payItmArr.length > 0) {
                // һ��������, һ��ûɶ����
                com.InvokeSyn(com.Fmt2ApiMethod('DeleteItms'), { rows: payItmArr }, function (retData) {
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                        return;
                    }
                });
            }
            var rows = $grid.datagrid('getRows');
            for (const chkit of checkedRows) {
                var rowIndex = rows.indexOf(chkit);
                $('#gridItm').datagrid('deleteRow', rowIndex);
            }
            components('Pop', 'ɾ���ɹ�');
            $('#gridItm').datagrid('clearChecked');
            ControlConditionState();
            if ($('#gridItm').datagrid('getRows').length === 0 && biz.getData('payID') !== '') {
                Delete('��ϸ�Ѿ�û�м�¼�����Ƿ�ͬʱɾ���˵��ݣ�');
            }
        });
    }

    function Select(payID) {
        if (payID === '') {
            $('#payBanner').phabanner('reset');
            $('#gridItm').datagrid('clear');
            com.Condition('#qCondition', 'clear');         
            biz.setData('status', 'SAVE');
            SetDefaults()
            return;
        }
        var data = com.GetMainData(payID);
        PHA.SetVals([data]);
        components('Banner', 'payBanner', data);
        biz.setData('status', data.status);
        com.QueryItmGrid('gridItm', { payID: payID });
    }
    function CanEdit() {
        if (biz.getData('status') !== 'SAVE') {
            return false;
        }
        return true;
    }

    function CanDeleteRow() {
        if (CanEdit() === false) {
            return false;
        }
        return true;
    }
    function SetDefaults() {
        var defaultValObj = settings.DefaultValues;
        PHA.SetVals([defaultValObj]);
    }

    function ControlOperation() {
        com.ControlOperation({
            '#btnDelete': {
                disabled: biz.getData('payID') === '' || biz.getData('status') !== 'SAVE'
            },
            '#btnPrint': {
                disabled: biz.getData('payID') === ''
            },
            '#btnDeleteItm': {
                disabled: biz.getData('status') !== 'SAVE'
            },
            '#btnFinish': {
                disabled: biz.getData('payID') === '' || biz.getData('status') !== 'SAVE',
                hide: biz.getData('status') !== 'SAVE'
            },
            '#btnFinishCancel': {
                disabled: biz.getData('status') !== 'COMP',
                hide: biz.getData('status') == 'SAVE'
            },
            '#btnExport': {
                disabled: biz.getData('payID') === ''
            },
            '#btnSave': {
                disabled: biz.getData('status') !== 'SAVE'
            }
        });
    }
    function ControlConditionState() {
        if ($('#gridItm').datagrid('getRows').length > 0) {
            $('#vendor').combobox('disable');
            $('#loc').combobox('disable');
        } else {
            $('#vendor').combobox('enable');
            $('#loc').combobox('enable');
        }
    }
    setTimeout(function () {
        if (settings.Com.StkCatSet === 'N') {
            // PHA.DataPha.Set('stkCatGrp', { required: false });
        }
        SetDefaults();
        ControlOperation();
        PHA.SetRequired($('#qCondition [data-pha]'));
        com.SetPage('pha.in.v3.pay.create.csp');
        // @automatic
 //       $('#btnBiz').trigger('click-i');
//        setTimeout(function () {
//            $('#btnFind-biz').trigger('click-i');
//            setTimeout(function () {
//                $('#datagrid-row-r4-2-0').trigger('click');
//            }, 500);
//        }, 500);
    }, 0);
});