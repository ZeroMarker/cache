/**
 * 模块:     临购药品审核
 * 编写日期: 2020-09-18
 * 编写人:   yangsj
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
        PHA.Popover({ showType: 'show', msg: '请选择一个审核状态！', type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: '请选择一张临购申请单！', type: 'alert' });
        return;
    }
    $('#gridTmpDrugDetail').datagrid('query', {
        TDPRowId: TDP,
    });
}

/// 初始化默认条件
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
	   //审核状态
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
                title: $g('药品名称<font color ="green">(已维护)</font>'),
                width: 300,
                descField: 'inciDesc',
                editor: PHA_GridEditor.ComboGrid($.extend({},PHA_STORE.INCItmForTmp('Y'),{
	                qLen: 0,
	            	checkValue: function (val, checkRet) {
						// 验证值
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
								checkRet.msg = '与第' + (i + 1) + '行重复';
								return false;
							}
						}
						return true;
					},
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIdex) {
						// 联动更新
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
                title: $g('药品名称<font color ="red">(未维护)</font>'),
                width: 232,
                sortable: 'true'
            },
            {
                field: 'spec',
                title: '规格',
                width: 100
            },
            {
                field: 'qty',
                title: '数量',
                width: 60
            },
            {
                field: 'uom',
                title: '单位',
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
                title: '生产企业',
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
            { field: 'inciDesc', title: '药品名称', width: 225, hidden: true },
            { field: 'uomDesc', title: '单位描述', width: 225, hidden: true },
            { field: 'manfDesc', title: '生产企业描述', width: 225, hidden: true },
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

// 新增行
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
            { field: 'TDPNo', title: '单号', width: 225 },
            { field: 'CreatorName', title: '建单人', width: 100 },
            { field: 'Date', title: '建单日期', width: 100 },
            { field: 'Time', title: '建单时间', width: 100 },
            { field: 'TypeDese', title: '使用类型', width: 100 },
            { field: 'TypeValueDesc', title: '使用类型值', width: 150 },
            { field: 'lastStateDesc', title: '状态', width: 100 },
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
        PHA.Popover({ showType: 'show', msg: '请检查编辑行是否有必填列未填写:单位/生产企业', type: 'alert' });
        return;
    }
    var gridChanges = $('#gridTmpDrugDetail').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
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
        // 检查数据
        if (params.replace(/\^/g, '') == '') continue;
        if (inci == '' && tmpDesc == '') {
            $.messager.alert('提示', '必须选中药品或者录入药品描述', 'warning');
            return;
        }
        if (uom == '' || qty == '' || spec == '' || manf == '') {
            $.messager.alert('提示', '单位/生产企业都不能为空，请检查明细数据', 'warning');
            return;
        }
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    if (paramsStr == '') {
        PHA.Popover({ showType: 'show', msg: '没有需要保存的明细！', type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: '请选择一张临购申请单！', type: 'alert' });
        return;
    }
    var Status = $('#cmbAuditStatus').combobox('getValue');
    if (Status == '') {
        $('#cmbAuditStatus').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: '请选择一个审核状态！', type: 'alert' });
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
                PHA.Popover({ showType: 'show', msg: '审核成功!', type: 'success' });
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
        PHA.Popover({ showType: 'show', msg: '请选择一张临购申请单！', type: 'alert' });
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
                PHA.Popover({ showType: 'show', msg: '取消审核成功!', type: 'success' });
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
