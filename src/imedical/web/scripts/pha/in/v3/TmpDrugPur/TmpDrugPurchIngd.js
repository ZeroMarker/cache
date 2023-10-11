/**
 * ģ��:     �ٹ�ҩƷ����Ƶ�
 * ��д����: 2020-09-18
 * ��д��:   yangsj
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
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����״̬��', type: 'alert' });
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

// ��ʼ��Ĭ������
function InitDict() {
	//���״̬
    PHA.ComboBox('cmbAuditStatus', {
        url: PHA_STORE.TmpDurgAuditStatus('ALL').url,
    });
    // ���״̬
    PHA.ComboBox('cmbIngdStatus', {
        url: PHA_STORE.TmpDurgIngdStatus().url,
    });
    // ���ⷿ
    PHA.ComboBox('cmbIngdLoc', {
        url: PHA_STORE.DHCSTLoc('R').url,
    });
    PHA.ComboBox('cmbIngdLocMian', {
        url: PHA_STORE.DHCSTLoc('R').url,
    });
    // ��Ӫ��ҵ
    PHA.ComboBox('vendorId', {
        url: PHA_STORE.APCVendor().url,
    });
    PHA.ComboBox('vendorIdMian', {
        url: PHA_STORE.APCVendor().url,
    });
    
    //����
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
    //���״̬
    var ProcessId = tkMakeServerCall(
        'PHA.IN.TmpDrugPurIngd.Query',
        'GetIngdProcessID',
        SessionHosp,
        '���'
    );
    if (ProcessId != '') $('#cmbAuditStatus').combobox('setValue', ProcessId);
    //���״̬
    $('#cmbIngdStatus').combobox('setValue', 'δ���');
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
            { field: 'scgDesc', title: '����', align: 'center', width: 55 },
            {
                field: 'statusi',
                title: '��ϸ״̬',
                align: 'center',
                width: 80,
                //formatter: Statuiformatter,
                styler:StatuiStyler,
            },
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
                title: $g('ҩƷ����<font color ="red">(δά��)</font>'),
                width: 232,
                sortable: 'true',
            },
            { field: 'spec', title: '���', width: 100 },
            { field: 'qty', title: '��������', width: 70 },
            { field: 'RecQty', title: '�������', width: 70 },
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
						param.InciDr = curRowData. inci||"" ;
					}
				}),
                formatter: function (value, row, index) {
                    return row.uomDesc;
                }
            },
            //{ field: 'uom', title: 'uom', width: 60,hidden: true },
            { field: 'uomDesc', title: '��λ', width: 60 ,hidden: true},
            {
                field: 'manf',
                title: '������ҵ',
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
            { field: 'scg', title: '����ID', width: 225, hidden: true },
            { field: 'inciDesc', title: 'ҩƷ����', width: 225, hidden: true },
            { field: 'manfDesc', title: '������ҵ����', width: 225, hidden: true },
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
    if (statusi == '��Ᵽ��') return "<div style='background-color:yellow;'>" + statusi + '</div>';
    if (statusi == '������')
        return "<div style='background-color:red;color:white'>" + statusi + '</div>';
}

function StatuiStyler(value, row, index)
{
     switch (value) {
         case '��Ᵽ��':
             colorStyle = 'background:#f1c516;color:white;';
             break;
         case '������':
             colorStyle = 'background:#ee4f38;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break;
     }
     return colorStyle;
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
            { field: 'gridMainSelect', checkbox: true },
            //TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc
            { field: 'TDP', title: 'TDP', width: 225, hidden: true },
            { field: 'TDPNo', title: '����', width: 170 },
            { field: 'CreatorName', title: '������', width: 70 },
            { field: 'Date', title: '��������', width: 100 },
            { field: 'Time', title: '����ʱ��', width: 80 },
            { field: 'TypeDese', title: 'ʹ������', width: 80 },
            { field: 'TypeValueDesc', title: 'ʹ������ֵ', width: 150 },
            { field: 'lastStateDesc', title: '���״̬', width: 100 },
            { field: 'IngdStatus', title: '���״̬', width: 200 },
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
        PHA.Popover({ showType: 'show', msg: '����༭���Ƿ��б�����δ��д����λ/������ҵ', type: 'alert' });
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
		
		if (inci == '' && tmpDesc == '') {
            PHA.Popover({ showType: 'show', msg: '����ѡ��ҩƷ����¼��ҩƷ����', type: 'alert' });
            return;
        }
        if (uom == '' || qty == '' || spec == '' || manf == '') {
            PHA.Popover({ showType: 'show', msg: '��λ/����/���/������ҵ������Ϊ�գ�������ϸ����', type: 'alert' });
            return;
        }
		
        var params =
            TDPi + '^' + inci + '^' + tmpDesc + '^' + uom + '^' + qty + '^' + spec + '^' + manf;
        // �������
        if (params.replace(/\^/g, '') == '') continue;
        
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

function SaveIngdMian() {
    var IngdLoc = $('#cmbIngdLocMian').combobox('getValue');
    if (IngdLoc == '') {
        $('#cmbIngdLocMian').combobox('showPanel');
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����ⷿ��', type: 'alert' });
        return;
    }
    var vendorId = $('#vendorIdMian').combobox('getValue');
    if (vendorId == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ����Ӫ��ҵ��', type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ����뵥��', type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: '����ɹ�', type: 'success' });
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
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����ⷿ��', type: 'alert' });
        return;
    }
    var vendorId = $('#vendorId').combobox('getValue');
    if (vendorId == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ����Ӫ��ҵ��', type: 'alert' });
        return;
    }
    var MainInfo = IngdLoc + '^' + SessionUser + '^' + SessionHosp + '^' + vendorId;

    var params = '',
        TDPiRowIdStr = '';
    var gridChecked = $('#gridTmpDrugDetail').datagrid('getChecked');
    var CheckedLen = gridChecked.length;
    if (CheckedLen == 0) {
        PHA.Popover({ showType: 'show', msg: '��ѡ����Ҫ�������ϸ', type: 'alert' });
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
                msg: '��ѡ����δά����������ϸ������ά���ٱ�����⣡',
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
            msg: '��ѡ���˲��ɱ������ϸ��������ϸ״̬',
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
        PHA.Popover({ showType: 'show', msg: '����ɹ�', type: 'success' });
        window.location.href = 'dhcst.ingdrec.csp?Rowid=' + retArr[0] + '&QueryFlag=1';
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
        return;
    }*/
}

function HandleRet(ret){
	var retArr = ret.split('^');
	if (retArr[0] >= 0) {
        PHA.Popover({ showType: 'show', msg: '����ɹ�', type: 'success' });
        //window.location.href = 'dhcst.ingdrec.csp Rowid=' + retArr[0] + '&QueryFlag=1';
        var recId = retArr[2];
        if (!top.PHA_IN_REC) {
	        top.PHA_IN_REC = {};
	    }
	    top.PHA_IN_REC["recID"] = recId;
	    PHA_COM.GotoMenu({
	        title: '����Ƶ�',
	        url: 'pha.in.v3.rec.create.csp'
	    });
        
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
        return;
    }
}
