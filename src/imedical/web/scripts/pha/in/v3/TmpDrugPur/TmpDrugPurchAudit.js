/**
 * ģ��:     �ٹ�ҩƷ���
 * ��д����: 2020-09-18
 * ��д��:   yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
$(function () {
    InitGridDict();
    InitDict();
    InitGrid();
    InitEvent();
    InitPivasSettings();
    InitBtnEvent();
});

function InitBtnEvent() {
    $('#btnSave').on('click', SaveTDP);
    $('#btnFind').on('click', QuerygridTmpDrugMain);
    $('#btnClear').on('click', ClearDetail);
    $('#btnAudit').on('click', AuditTDP);
    $('#btnCancleAudit').on('click', CancleAuditTDP);
}

function ClearDetail() {
    $('#gridTmpDrugDetail').datagrid('clear');
}

function QuerygridTmpDrugMain() {
    var Status = $('#cmbAuditStatus').combobox('getValue');
    if (Status == '') {
        $('#cmbAuditStatus').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����״̬��', type: 'alert' });
        return;
    }

    $('#gridTmpDrugMain').datagrid('query', {
        StDate: $('#dateStart').datebox('getValue'),
        EdDate: $('#dateEnd').datebox('getValue'),
        HospId: SessionHosp,
        Status: $('#cmbAuditStatus').combobox('getValue'),
        alreadyFlag: $('#CheckAudit').is(':checked') ? 'Y' : 'N',
    });
}

function QuerygridTmpDrugDetail() {
    var gridSelect = $('#gridTmpDrugMain').datagrid('getSelected') || '';
    var TDP = '';
    if (gridSelect) TDP = gridSelect.TDP;
    if (TDP == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ����뵥��', type: 'alert' });
        return;
    }
    $('#gridTmpDrugDetail').datagrid('query', {
        TDPRowId: TDP,
    });
}

/// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurch.Query',
            MethodName: 'GetDefaultDate',
        },
        function (retData) {
            var DateArr = retData.split('^');
            $('#dateStart').datebox('setValue', DateArr[0]);
            $('#dateEnd').datebox('setValue', DateArr[1]);
        }
    );
}

function InitEvent() {}

function InitDict() {
	   //���״̬
    PHA.ComboBox('cmbAuditStatus', {
        url: PHA_STORE.TmpDurgAuditStatus().url,
    });
}

function InitGridDict() {}

function CheckInciExist(inci,Index)
{
	var gridDatas = $('#gridTmpDrugDetail').datagrid('getData');
    var gridDataLen = gridDatas.rows.length;
    var paramsStr = '';
    for (var i = 0; i < gridDataLen; i++) {
	    if (i==Index) continue;
        var iData = gridDatas.rows[i];
        var tmpInci = iData.inci || '';
        if (tmpInci==inci) return true
    }
    return false
}

function InitGrid() {
    InitTmpDrugDetail();
    InitTmpDrugMian();
}

function InitTmpDrugDetail() {
    var columns = [
        [
            // TDPi,inci,inciDesc,tmpDesc,spec,qty,uom,uomDesc,manf,manfDesc
            { field: 'TDPi', title: 'TDPi', hidden: true },
            { field: 'InciCheck', title: 'InciCheck', hidden: true },
            {
                field: 'inci',
                title: $g('ҩƷ����<font color ="green">(��ά��)</font>'),
                width: 300,
                descField: 'inciDesc',
                editor: PHA_GridEditor.ComboGrid($.extend({},PHA_STORE.INCItmForTmp('Y'),{
	                qLen: 0,
	            	checkValue: function (val, checkRet) {
						// ��ֵ֤
						var dgOpts = $('#gridTmpDrugDetail').datagrid('options');
						var curEidtCell = dgOpts.curEidtCell || {};
						var rowsData = $('#gridTmpDrugDetail').datagrid('getRows');
						for (var i = 0; i < rowsData.length; i++) {
							if (i == curEidtCell.index) {
								continue;
							}
							var iData = rowsData[i];
							if (iData.inci == val) {
								setTimeout(function(){
									var ed = $('#gridTmpDrugDetail').datagrid('getEditor', {
										index: curEidtCell.index,
										field: curEidtCell.field
									});
									$(ed.target).combobox('clear');
									$(ed.target).combobox('setValue', '');
									$(ed.target).combobox('setText', '');
								}, 300);
								checkRet.msg = '���' + (i + 1) + '���ظ�';
								return false;
							}
						}
						return true;
					},
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIdex) {
						// ��������
						var inci = cmbRowData.inciId; 
						var inciSpec = tkMakeServerCall("web.DHCST.Common.DrugInfoCommon", "GetSpec", "", inci);
						var puomStr = tkMakeServerCall( "web.DHCST.Common.DrugInfoCommon", "GetIncPuom", inci)
						var puomArr = puomStr.split("^" )
						gridRowData.spec = inciSpec;
						gridRowData.uom = puomArr[0]
						gridRowData.uomDesc = puomArr[1];
						gridRowData.inci = inci;
						$('#gridTmpDrugDetail').datagrid('updateRowData', {
							index: gridRowIdex,
							row: gridRowData
						});
						return;
					}
				})),
                formatter: function (value, row, index) {
                    return row.inciDesc;
                }
            },
            {
                field: 'tmpDesc',
                title: $g('ҩƷ����<font color ="red">(δά��)</font>'),
                width: 232,
                sortable: 'true'
            },
            {
                field: 'spec',
                title: '���',
                width: 100
            },
            {
                field: 'qty',
                title: '����',
                width: 60
            },
            {
                field: 'uom',
                title: '��λ',
                width: 60,
                descField: 'uomDesc',
                editor: PHA_GridEditor.ComboBox({
	                qLen: 0,
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.CTUOMWithInci().url,
					onBeforeLoad: function (param) {
						var curRowData = PHA_GridEditor.CurRowData('gridTmpDrugDetail' );
						param.InciDr = curRowData.inci||"" ;
					}
				}),
                formatter: function (value, row, index) {
                    return row.uomDesc;
                }
            },
            {
                field: 'manf',
                title: '������ҵ',
                width: 250,
                descField: 'manfDesc',
                editor: PHA_GridEditor.ComboBox({
	                qLen: 0,
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.PHManufacturer().url
				}),
                formatter: function (value, row, index) {
                    return row.manfDesc;
                }
            },
            { field: 'inciDesc', title: 'ҩƷ����', width: 225, hidden: true },
            { field: 'uomDesc', title: '��λ����', width: 225, hidden: true },
            { field: 'manfDesc', title: '������ҵ����', width: 225, hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurch.Query',
            QueryName: 'SelectTmpDrug',
            TDPRowId: '',
        },
        gridSave: false,
        isAutoShowPanel: true,
        editFieldSort: ['inci', 'uom','manf'],
        columns: columns,
        toolbar: '#gridTmpDrugDetailBar',
        onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridTmpDrugDetail",
				index: index,
				field: field
			});
		},
        onClickRow: function (rowIndex, rowData) {},
    };
    PHA.Grid('gridTmpDrugDetail', dataGridOption);
}

// ������
function AddNewRow() {
    $('#gridTmpDrugDetail').datagrid('addNewRow', {
        editField: 'inci',
    });
}

function InitTmpDrugMian() {
    var columns = [
        [
            //TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc
            { field: 'TDP', title: 'TDP', width: 225, hidden: true },
            { field: 'TDPNo', title: '����', width: 225 },
            { field: 'CreatorName', title: '������', width: 100 },
            { field: 'Date', title: '��������', width: 100 },
            { field: 'Time', title: '����ʱ��', width: 100 },
            { field: 'TypeDese', title: 'ʹ������', width: 100 },
            { field: 'TypeValueDesc', title: 'ʹ������ֵ', width: 150 },
            { field: 'lastStateDesc', title: '״̬', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurAudit.Query',
            QueryName: 'QueryTmpDrug',
            StDate: $('#dateStart').datebox('getValue'),
            EdDate: $('#dateEnd').datebox('getValue'),
            HospId: '',
            Status: '',
        },
        columns: columns,
        toolbar: '#gridTmpDrugMainBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                QuerygridTmpDrugDetail();
            }
        },
        onLoadSuccess: function (data) {
            var pageSize = $('#gridTmpDrugMain').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#gridTmpDrugMain').datagrid('selectRow', 0);
                var gridSelect = $('#gridTmpDrugMain').datagrid('getSelected') || '';
                if (gridSelect) QuerygridTmpDrugDetail();
            }
        },
    };
    PHA.Grid('gridTmpDrugMain', dataGridOption);
}

function SaveTDP() {
    $('#gridTmpDrugDetail').datagrid('endEditing');
    if($("#gridTmpDrugDetail").datagrid('options').editIndex != undefined) 
    {
        PHA.Popover({ showType: 'show', msg: '����༭���Ƿ��б�����δ��д:��λ/������ҵ', type: 'alert' });
        return;
    }
    var gridChanges = $('#gridTmpDrugDetail').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: 'û����Ҫ���������',
            type: 'alert',
        });
        return;
    }

    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var TDPi = iData.TDPi || '';
        var inci = iData.inci || '';
        var tmpDesc = iData.tmpDesc || '';
        var uom = iData.uom || '';
        var qty = iData.qty || '';
        var spec = iData.spec || '';
        var manf = iData.manf || '';

        var params =
            TDPi + '^' + inci + '^' + tmpDesc + '^' + uom + '^' + qty + '^' + spec + '^' + manf;
        // �������
        if (params.replace(/\^/g, '') == '') continue;
        if (inci == '' && tmpDesc == '') {
            $.messager.alert('��ʾ', '����ѡ��ҩƷ����¼��ҩƷ����', 'warning');
            return;
        }
        if (uom == '' || qty == '' || spec == '' || manf == '') {
            $.messager.alert('��ʾ', '��λ/������ҵ������Ϊ�գ�������ϸ����', 'warning');
            return;
        }
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    if (paramsStr == '') {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ�������ϸ��', type: 'alert' });
        return;
    }

    var saveRet = tkMakeServerCall('PHA.IN.TmpDrugPurAudit.Save', 'SaveDetail', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg: saveInfo, type: 'alert' });
    } else {
        QuerygridTmpDrugDetail();
    }
}

function AuditTDP() {
    var gridSelect = $('#gridTmpDrugMain').datagrid('getSelected') || '';
    var TDP = '';
    if (gridSelect) TDP = gridSelect.TDP;
    if (TDP == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ����뵥��', type: 'alert' });
        return;
    }
    var Status = $('#cmbAuditStatus').combobox('getValue');
    if (Status == '') {
        $('#cmbAuditStatus').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����״̬��', type: 'alert' });
        return;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurAudit.Save',
            MethodName: 'AuditTDP',
            TDP: TDP,
            Status: Status,
            AuditUser: SessionUser,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: '��˳ɹ�!', type: 'success' });
                QuerygridTmpDrugMain();
                ClearDetail();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: retData,
                    type: 'alert',
                });
        }
    );
}

function CancleAuditTDP() {
    var gridSelect = $('#gridTmpDrugMain').datagrid('getSelected') || '';
    var TDP = '';
    if (gridSelect) TDP = gridSelect.TDP;
    if (TDP == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ����뵥��', type: 'alert' });
        return;
    }

    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurAudit.Save',
            MethodName: 'CancleAuditTDP',
            TDP: TDP,
            AuditUser: SessionUser,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: 'ȡ����˳ɹ�!', type: 'success' });
                QuerygridTmpDrugMain();
                ClearDetail();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: retData,
                    type: 'alert',
                });
        }
    );
}
