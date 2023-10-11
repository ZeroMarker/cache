/**
 * 模块:     临购药品入库制单
 * 编写日期: 2020-09-18
 * 编写人:   yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var SessionGroup = session['LOGON.GROUPID'];
var rowId = '';
$(function () {
    InitGridDict();
    InitDict();
    InitGrid();
    InitEvent();
    InitBtnEvent();
});

function InitBtnEvent() {
    $('#btnSave').on('click', SaveTDP);
    $('#btnSaveIngdMian').on('click', SaveIngdMian);
    $('#btnSaveIngdDetail').on('click', SaveIngdDetail);

    $('#btnFind').on('click', QuerygridTmpDrugMain);
    $('#btnClear').on('click', ClearDetail);
}

function ClearDetail() {
    $('#gridTmpDrugDetail').datagrid('clear');
}

function QuerygridTmpDrugMain() {
	ClearDetail();
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
        IngdRecStatus: $('#cmbIngdStatus').combobox('getValue'),
    });
}

function QuerygridTmpDrugDetail() {
    var TDPRowIdStr = '';
    var gridChecked = $('#gridTmpDrugMain').datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        TDPRowIdStr =
            TDPRowIdStr == '' ? gridChecked[i].TDP : TDPRowIdStr + '^' + gridChecked[i].TDP;
    }
    if (TDPRowIdStr == '') 
    {
	    ClearDetail();
	    return;
    }
    $('#gridTmpDrugDetail').datagrid('query', {
        TDPRowIdStr: TDPRowIdStr,
        IngdRecStatus: $('#cmbIngdStatus').combobox('getValue'),
    });
}

function InitEvent() {}

// 初始化默认条件
function InitDict() {
	//审核状态
    PHA.ComboBox('cmbAuditStatus', {
        url: PHA_STORE.TmpDurgAuditStatus('ALL').url,
    });
    // 入库状态
    PHA.ComboBox('cmbIngdStatus', {
        url: PHA_STORE.TmpDurgIngdStatus().url,
    });
    // 入库库房
    PHA.ComboBox('cmbIngdLoc', {
        url: PHA_STORE.DHCSTLoc('R').url,
    });
    PHA.ComboBox('cmbIngdLocMian', {
        url: PHA_STORE.DHCSTLoc('R').url,
    });
    // 经营企业
    PHA.ComboBox('vendorId', {
        url: PHA_STORE.APCVendor().url,
    });
    PHA.ComboBox('vendorIdMian', {
        url: PHA_STORE.APCVendor().url,
    });
    
    //日期
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
    //审核状态
    var ProcessId = tkMakeServerCall(
        'PHA.IN.TmpDrugPurIngd.Query',
        'GetIngdProcessID',
        SessionHosp,
        '入库'
    );
    if (ProcessId != '') $('#cmbAuditStatus').combobox('setValue', ProcessId);
    //入库状态
    $('#cmbIngdStatus').combobox('setValue', '未入库');
}

function InitGridDict() {}

function CheckInciExist(inci,TDPi)
{
	var TDP = TDPi.split("||")[0]
	var gridDatas = $('#gridTmpDrugDetail').datagrid('getData');
    var gridDataLen = gridDatas.rows.length;
    var paramsStr = '';
    for (var i = 0; i < gridDataLen; i++) {
        var iData = gridDatas.rows[i];
        var tmpTDPi = iData.TDPi || '';
        if (TDPi==tmpTDPi) continue;
        var tmpTDP = tmpTDPi.split("||")[0]
        if (tmpTDP!=TDP) continue;
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
            { field: 'gridDetailSelect', checkbox: true },
            { field: 'TDPi', title: 'TDPi', hidden: true },
            { field: 'InciCheck', title: 'InciCheck', hidden: true },
            { field: 'scgDesc', title: '类组', align: 'center', width: 55 },
            {
                field: 'statusi',
                title: '明细状态',
                align: 'center',
                width: 80,
                //formatter: Statuiformatter,
                styler:StatuiStyler,
            },
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
						var inci = cmbRowData . inciId; 
						var inciSpec = tkMakeServerCall("web.DHCST.Common.DrugInfoCommon", "GetSpec", "", inci);
						var puomStr = tkMakeServerCall( "web.DHCST.Common.DrugInfoCommon", "GetIncPuom", inci)
						var puomArr = puomStr .split("^" )
						gridRowData.spec = inciSpec;
						gridRowData.uom = puomArr[0]
						gridRowData. uomDesc = puomArr[1];
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
                sortable: 'true',
            },
            { field: 'spec', title: '规格', width: 100 },
            { field: 'qty', title: '申请数量', width: 70 },
            { field: 'RecQty', title: '入库数量', width: 70 },
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
						param.InciDr = curRowData. inci||"" ;
					}
				}),
                formatter: function (value, row, index) {
                    return row.uomDesc;
                }
            },
            //{ field: 'uom', title: 'uom', width: 60,hidden: true },
            { field: 'uomDesc', title: '单位', width: 60 ,hidden: true},
            {
                field: 'manf',
                title: '生产企业',
                width: 250,
                descField: 'manfDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.PHManufacturer().url
				}),
                formatter: function (value, row, index) {
                    return row.manfDesc;
                },
            },
            { field: 'scg', title: '类组ID', width: 225, hidden: true },
            { field: 'inciDesc', title: '药品名称', width: 225, hidden: true },
            { field: 'manfDesc', title: '生产企业描述', width: 225, hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        singleSelect: false,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurIngd.Query',
            QueryName: 'SelectTmpDrug',
            TDPRowIdStr: '',
            IngdRecStatus: '',
        },
        gridSave: false,
        isAutoShowPanel: true,
        editFieldSort: ['inci','manf'],
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

function Statuiformatter(value, rowData, rowIndex) {
    var statusi = rowData.statusi;
    if (statusi == '入库保存') return "<div style='background-color:yellow;'>" + statusi + '</div>';
    if (statusi == '入库审核')
        return "<div style='background-color:red;color:white'>" + statusi + '</div>';
}

function StatuiStyler(value, row, index)
{
     switch (value) {
         case '入库保存':
             colorStyle = 'background:#f1c516;color:white;';
             break;
         case '入库审核':
             colorStyle = 'background:#ee4f38;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break;
     }
     return colorStyle;
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
            { field: 'gridMainSelect', checkbox: true },
            //TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc
            { field: 'TDP', title: 'TDP', width: 225, hidden: true },
            { field: 'TDPNo', title: '单号', width: 170 },
            { field: 'CreatorName', title: '建单人', width: 70 },
            { field: 'Date', title: '建单日期', width: 100 },
            { field: 'Time', title: '建单时间', width: 80 },
            { field: 'TypeDese', title: '使用类型', width: 80 },
            { field: 'TypeValueDesc', title: '使用类型值', width: 150 },
            { field: 'lastStateDesc', title: '审核状态', width: 100 },
            { field: 'IngdStatus', title: '入库状态', width: 200 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        singleSelect: false,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurIngd.Query',
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
                //QuerygridTmpDrugDetail();
            }
        },
        onLoadSuccess: function (data) {
            /*
            var pageSize = $('#gridTmpDrugMain').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#gridTmpDrugMain').datagrid('selectRow', 0);
                var gridSelect = $('#gridTmpDrugMain').datagrid('getSelected') || '';
			    if (gridSelect) QuerygridTmpDrugDetail();
            }
            */
        },
        onCheck: function (rowIndex, rowData) {
            QuerygridTmpDrugDetail();
        },
        onUncheck: function (rowIndex, rowData) {
            QuerygridTmpDrugDetail();
        },
        onCheckAll: function () {
            QuerygridTmpDrugDetail();
        },
    };
    PHA.Grid('gridTmpDrugMain', dataGridOption);
}

function SaveTDP() {
    $('#gridTmpDrugDetail').datagrid('endEditing');
    if($("#gridTmpDrugDetail").datagrid('options').editIndex != undefined) 
    {
        PHA.Popover({ showType: 'show', msg: '请检查编辑行是否有必填列未填写：单位/生产企业', type: 'alert' });
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
		
		if (inci == '' && tmpDesc == '') {
            PHA.Popover({ showType: 'show', msg: '必须选中药品或者录入药品描述', type: 'alert' });
            return;
        }
        if (uom == '' || qty == '' || spec == '' || manf == '') {
            PHA.Popover({ showType: 'show', msg: '单位/数量/规格/生产企业都不能为空，请检查明细数据', type: 'alert' });
            return;
        }
		
        var params =
            TDPi + '^' + inci + '^' + tmpDesc + '^' + uom + '^' + qty + '^' + spec + '^' + manf;
        // 检查数据
        if (params.replace(/\^/g, '') == '') continue;
        
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

function SaveIngdMian() {
    var IngdLoc = $('#cmbIngdLocMian').combobox('getValue');
    if (IngdLoc == '') {
        $('#cmbIngdLocMian').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: '请选择一个入库库房！', type: 'alert' });
        return;
    }
    var vendorId = $('#vendorIdMian').combobox('getValue');
    if (vendorId == '') {
        PHA.Popover({ showType: 'show', msg: '请选择一个经营企业！', type: 'alert' });
        return;
    }
    
    var MainInfo = IngdLoc + '^' + SessionUser + '^' + SessionHosp + '^' + vendorId;

    var TDPRowIdStr = '';
    var gridChecked = $('#gridTmpDrugMain').datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        TDPRowIdStr =
            TDPRowIdStr == '' ? gridChecked[i].TDP : TDPRowIdStr + '^' + gridChecked[i].TDP;
    }
    if (TDPRowIdStr == '') {
        PHA.Popover({ showType: 'show', msg: '请选择一张临购申请单！', type: 'alert' });
        return;
    }
    var ret = tkMakeServerCall(
        'PHA.IN.TmpDrugPurIngd.Save',
        'SaveTDPIngdByMian',
        SessionHosp,
        SessionGroup,
        MainInfo,
        TDPRowIdStr
    );
    HandleRet(ret);
    /*
    var retArr = ret.split('^');
    if (retArr[0] > 0) {
        PHA.Popover({ showType: 'show', msg: '保存成功', type: 'success' });
        window.location.href = 'dhcst.ingdrec.csp?Rowid=' + retArr[0] + '&QueryFlag=1';
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
        return;
    }*/
}

function SaveIngdDetail() {
    var IngdLoc = $('#cmbIngdLoc').combobox('getValue');
    if (IngdLoc == '') {
        $('#cmbIngdLoc').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: '请选择一个入库库房！', type: 'alert' });
        return;
    }
    var vendorId = $('#vendorId').combobox('getValue');
    if (vendorId == '') {
        PHA.Popover({ showType: 'show', msg: '请选择一个经营企业！', type: 'alert' });
        return;
    }
    var MainInfo = IngdLoc + '^' + SessionUser + '^' + SessionHosp + '^' + vendorId;

    var params = '',
        TDPiRowIdStr = '';
    var gridChecked = $('#gridTmpDrugDetail').datagrid('getChecked');
    var CheckedLen = gridChecked.length;
    if (CheckedLen == 0) {
        PHA.Popover({ showType: 'show', msg: '请选中需要保存的明细', type: 'alert' });
        return;
    }
    var NotAcorrdFlag = '';
    for (var i = 0; i < CheckedLen; i++) {
        var statusi = gridChecked[i].statusi;
        if (statusi != '') {
            NotAcorrdFlag = 1;
            continue;
        }
        var inci = gridChecked[i].inci;
        if (inci == '') {
            PHA.Popover({
                showType: 'show',
                msg: '您选中了未维护库存项的明细，请先维护再保存入库！',
                type: 'alert',
            });
            return;
        }
        TDPiRowIdStr =
            TDPiRowIdStr == '' ? gridChecked[i].TDPi : TDPiRowIdStr + '^' + gridChecked[i].TDPi;
    }
    if (TDPiRowIdStr == '') {
        PHA.Popover({
            showType: 'show',
            msg: '您选中了不可保存的明细，请检查明细状态',
            type: 'alert',
        });
        return;
    }

    var ret = tkMakeServerCall(
        'PHA.IN.TmpDrugPurIngd.Save',
        'SaveTDPIngd',
        SessionHosp,
        SessionGroup,
        MainInfo,
        TDPiRowIdStr
    );
    HandleRet(ret);
    /*
    var retArr = ret.split('^');
    if (retArr[0] > 0) {
        PHA.Popover({ showType: 'show', msg: '保存成功', type: 'success' });
        window.location.href = 'dhcst.ingdrec.csp?Rowid=' + retArr[0] + '&QueryFlag=1';
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
        return;
    }*/
}

function HandleRet(ret){
	var retArr = ret.split('^');
	if (retArr[0] >= 0) {
        PHA.Popover({ showType: 'show', msg: '保存成功', type: 'success' });
        //window.location.href = 'dhcst.ingdrec.csp Rowid=' + retArr[0] + '&QueryFlag=1';
        var recId = retArr[2];
        if (!top.PHA_IN_REC) {
	        top.PHA_IN_REC = {};
	    }
	    top.PHA_IN_REC["recID"] = recId;
	    PHA_COM.GotoMenu({
	        title: '入库制单',
	        url: 'pha.in.v3.rec.create.csp'
	    });
        
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
        return;
    }
}
