/**
 * ģ��:     �ٹ�ҩƷ�����Ƶ�
 * ��д����: 2020-09-18
 * ��д��:   yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var PATNOLEN = PHA_COM.PatNoLength();
var GridCmbInci;
$(function () {
    InitGridDict();
    InitDict();
    InitGrid();
    InitEvent();
    InitPivasSettings();
    InitBtnEvent();
    SetDisabled('1^0^0^0^1^1^0');
});

function InitBtnEvent() {
    $('#btnAddi').on('click', AddNewRow);
    $('#btnSave').on('click', SaveTDP);
    $('#btnDelete').on('click', DeleteTDP);
    $('#btnDeletei').on('click', Deletei);
    $('#btnFind').on('click', QuerygridTmpDrugMain);
    $('#btnClear').on('click', Clear);
    $('#btnComp').on('click', CompTDP);
    $('#btnCancleComp').on('click', CanCelCompTDP);
    $('#btnPrint').on('click', PrintTDP);
}

function SetDisabled(NumStr) {
    var NumArr = NumStr.split('^');
    var len = NumArr.length;
    var numi = '';
    var BtmArr = [
        '#btnSave',
        '#btnComp',
        '#btnCancleComp',
        '#btnDelete',
        '#btnAddi',
        '#btnDeletei',
    ];
    for (i = 0; i < len; i++) {
        numi = NumArr[i];
        if (i == 6) {
            if (numi == 1) $('#CheckComp').checkbox('setValue', true);
            //��ɹ�ѡ�����Ϊ1ʱ��ѡ
            else $('#CheckComp').checkbox('setValue', false);
        } else {
            if (numi == 1) {
                $(BtmArr[i]).removeClass('l-btn-disabled');
                $(BtmArr[i]).css('pointer-events', '');
            } else {
                $(BtmArr[i]).addClass('l-btn-disabled');
                $(BtmArr[i]).css('pointer-events', 'none');
            }
        }
    }
}
function Clear(){
	 ClearMian();
	 ClearDetail();
	 SetDisabled('1^0^0^0^1^1^0');
}

function ClearMian() {
	$('#gridTmpDrugMain').datagrid('clearSelections');
}

function ClearDetail() {
	
    $('#TextCreateDate').val('');
    $('#TextTDPNO').val('');
    $('#TextReason').val('');
    //$('#cmbTmpDrugUseType').combobox('setValue', 'LOC');
    //$('#cmbTmpDrugUseTypeVal').combobox('clear');
    //var url = PHA_STORE.NameByPamino("").url;
    // $('#cmbTmpDrugUseTypeVal').combobox('reload',url);
    InitDict();
    $('#gridTmpDrugDetail').datagrid('clear');
    $('#gridTmpDrugDetail').datagrid('clearSelections');
   
}

function QuerygridTmpDrugMain() {
    $('#gridTmpDrugMain').datagrid('query', {
        StDate: $('#dateStart').datebox('getValue'),
        EdDate: $('#dateEnd').datebox('getValue'),
        User: SessionUser,
        Hosp:SessionHosp
    });
}

function QuerygridTmpDrugDetail(TDP) {
	$('#gridTmpDrugDetail').datagrid('clearSelections');
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
            QuerygridTmpDrugMain(); //�Զ���ѯ�����б�
        }
    );
}

function InitEvent() {
    $('#cmbTmpDrugUseType').combobox({
	    editable:false,
        onChange: function (value) {
            var url = '',
                placeholder = '';
            if (value != 'PAT') {
                if (value == 'LOC') {
                    url = PHA_STORE.DocLoc().url;
                    placeholder = 'ҽ������...';
                } else if (value == 'DOC') {
                    url = PHA_STORE.Doctor().url;
                    placeholder = 'ʹ��ҽ��...';
                }
                if (!url) return;
                PHA.ComboBox('cmbTmpDrugUseTypeVal', {
                    url: url,
                    width: 250,
                    placeholder: placeholder,
                });
            }

            if (value == 'PAT') {
                url = PHA_STORE.NameByPamino().url;
                placeholder = '�����������ǼǺ�...';
                PHA.ComboBox('cmbTmpDrugUseTypeVal', {
                    url: url,
                    width: 250,
                    placeholder: placeholder,
                    onChange: function (newValue) {
                        if (newValue != null && newValue !== '') {
	                        if($('#cmbTmpDrugUseType').combobox("getValue")!="PAT") return;
                            var pamino = $('#cmbTmpDrugUseTypeVal').combobox('getText');
                            var paminoLen = pamino.length;
                            if (pamino.indexOf(' ') < 0 && pamino && paminoLen == PATNOLEN) {
                                //ѡ����ϸ֮���ѿո����ж���ѡ�д�����change�¼�
                                url = PHA_STORE.NameByPamino(pamino).url;
                                $('#cmbTmpDrugUseTypeVal').combobox('reload', url);
                            }
                        }
                    },
                });
            }
        },
    });
}

function InitDict() {
    //ʹ�÷�Χ
    PHA.ComboBox('cmbTmpDrugUseType', {
        url: PHA_STORE.TmpDrugUseType().url,
        width: 162,
        onLoadSuccess: function (arr) {
            //$('#cmbTmpDrugUseType').combobox('setValue', 'PAT');
            if (arr.length > 0) {
                $('#cmbTmpDrugUseType').combobox('setValue',arr[0].RowId);
            }
                        
        },
    });
}

function InitGridDict() {
}

function CheckInciExist(inci,Index)
{
	var gridDatas = $('#gridTmpDrugDetail').datagrid('getData');
    var gridDataLen = gridDatas.rows.length;
    var paramsStr = '';
    for (var i = 0; i < gridDataLen; i++) {
	    if (i==Index) continue;
        var iData = gridDatas.rows[i];
        var tmpInci = iData.inci || '';
        //alert(tmpInci+"$"+inci+"$"+Index+"$"+i)
        if (tmpInci==inci) return true
    }
    return false
}


function InciShowTop(InciDr) {
    var options = {
        panelWidth: '500',
        required: false,
    };
    options = $.extend({}, PHA_STORE.INCItmForTmp('Y', InciDr), options);
    GridCmbInci = PHA.EditGrid.ComboGrid(options, {
        lnkField: 'inci',
        lnkGrid: 'gridTmpDrugDetail',
        lnkQName: 'InciDr',
    });
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
                mode: 'remote',
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
                        var retData = $.cm(
                            {
                                ClassName: 'PHA.IN.TDP.Data',
                                MethodName: 'GetUpDateData4Row',
                                inci: inci,
                            },false
                        );
                        $('#gridTmpDrugDetail').datagrid('updateRowData', {
                            index: gridRowIdex,
                            row: retData
                        });

                        /*       
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

                        */
						return;
					}
				})),
                formatter: function (value, row, index) {
                    return row.inciDesc;
                },
            },
            {
                field: 'tmpDesc',
                title: $g('ҩƷ����<font color ="red">(δά��)</font>'),
                width: 232,
                sortable: 'true',
                editor: PHA_GridEditor.ValidateBox({})
            },
            {
                field: 'spec',
                title: '���',
                width: 150,
                editor: PHA_GridEditor.ValidateBox({})
            },
            {
                field: 'qty',
                title: '��������',
                width: 100,
                editor: PHA_GridEditor.NumberBox({required: true})
            },
            {
                field: 'uom',
                title: '��λ',
                width: 100,
                descField: 'uomDesc',
                editor: PHA_GridEditor.ComboBox({
	                qLen: 0,
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.CTUOMWithInci().url,
					onBeforeLoad: function (param) {
						var curRowData = PHA_GridEditor.CurRowData('gridTmpDrugDetail' );
						
						param.InciDr = curRowData.inci || "" ;
					}
				}),
                formatter: function (value, row, index) {
                    return row.uomDesc;
                },
            },
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
            { field: 'inciDesc', title: 'ҩƷ����', width: 225, hidden: true },
            { field: 'uomDesc', title: '��λ����', width: 225, hidden: true },
            { field: 'manfDesc', title: '������ҵ����', width: 225, hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurch.Query',
            QueryName: 'SelectTmpDrug',
            TDPRowId: '',
        },
        idField: 'TDPi',
        isAutoShowPanel: true,
        editFieldSort: ['inci', 'tmpDesc', 'spec', 'qty','uom','manf'],
        columns: columns,
        toolbar: '#gridTmpDrugDetailBar',
        exportXls: false,
        onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridTmpDrugDetail",
				index: index,
				field: field
			});
		},
        onClickRow: function (rowIndex, rowData) {},
    };
    //DHCPHA_HUI_COM.Grid.Init('gridTmpDrugDetail', dataGridOption);
    PHA.Grid('gridTmpDrugDetail', dataGridOption);
}

// ������
function AddNewRow() {
   // $('#gridTmpDrugDetail').datagrid('addNewRow', {
   //     editField: 'inci',
   // });
    
    PHA_GridEditor.Add({
		gridID: 'gridTmpDrugDetail',
		field: 'inci',
		rowData: {
			//TDPi,inci,inciDesc,tmpDesc,spec,qty,uom,uomDesc,manf,manfDesc
			TDPi: "",
			inci:  "",
			inciDesc:  "",
			spec:  "",
			qty:  "",
			uom:  "",
			uomDesc:  "",
			manf: "",
			manfDesc: ""
		}
	});
	PHA_GridEditor.Show("gridTmpDrugDetail")
    
}

function InitTmpDrugMian() {
    var columns = [
        [
            //TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc
            { field: 'TDP', title: 'TDP', width: 225, hidden: true },
            { field: 'TDPNo', title: '����', width: 150 },
            { field: 'DataInfo', title: '������Ϣ', width: 250 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        height: '50px',
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurch.Query',
            QueryName: 'QueryTmpDrug',
            StDate: $('#dateStart').datebox('getValue'),
            EdDate: $('#dateEnd').datebox('getValue'),
            User: SessionUser,
            Hosp:SessionHosp
        },
        idField: 'TDP',
        fitColumns: true,
        exportXls: false,
        fit: true,
        columns: columns,
        toolbar: '#gridTmpDrugMainBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SetDetailInfo(rowData.TDP);
            }
        },
    };
    PHA.Grid('gridTmpDrugMain', dataGridOption);
}

///�����ϸ�����������
function SetDetailInfo(TDP) {
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurch.Query',
            MethodName: 'GetMainInfoByTDPToStr',
            TDP: TDP,
        },
        function (retData) {
            if (retData) {
                //(TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc,reason)
                var InfoArr = retData.split(',');
                $('#TextCreateDate').val(InfoArr[2]);
                $('#TextTDPNO').val(InfoArr[1]);
                $('#cmbTmpDrugUseType').combobox('setValue', InfoArr[6]);
                $('#cmbTmpDrugUseTypeVal').combobox('setValue', InfoArr[8]);
                $('#TextReason').val(InfoArr[12]);

                if (InfoArr[11] == '����') SetDisabled('1^1^0^1^1^1^0');
                else SetDisabled('1^1^0^1^1^1^0');
                QuerygridTmpDrugDetail(TDP);
            }
        }
    );
}

function SaveTDP() {
	
    $('#gridTmpDrugDetail').datagrid('endEditing');
    if($("#gridTmpDrugDetail").datagrid('options').editIndex != undefined) 
    {
        PHA.Popover({ showType: 'show', msg: '����༭���Ƿ��б�����δ��д����������/��λ/������ҵ', type: 'alert' });
        return;
    }
    var gridChanges = $('#gridTmpDrugDetail').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    var RowCount=$('#gridTmpDrugDetail').datagrid('getRows');
    var RowCountLen = RowCount.length;
    var TDPNo = $('#TextTDPNO').val();
    if((TDPNo=="")&&(gridChangeLen==0)||(RowCountLen==0))
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: 'û����Ҫ���������',
            type: 'alert',
        });
        return;
    }
    var UseType = $('#cmbTmpDrugUseType').combobox('getValue');
    var UseTypeVal = $('#cmbTmpDrugUseTypeVal').combobox('getValue');
    var Reason = $('#TextReason').val();

    var MianStr =
        TDPNo +
        '^' +
        SessionUser +
        '^' +
        SessionLoc +
        '^' +
        UseType +
        '^' +
        UseTypeVal +
        '^' +
        Reason;
    if (UseType == '')
    {
	    PHA.Popover({ showType: 'show', msg: 'ʹ�÷�Χ����Ϊ�գ�', type: 'alert' });
        return;
    }
    
    
    if( UseTypeVal == '') {
	    var msgStr=""
	    if (UseType=="LOC") msgStr="ҽ������" 
	    else if(UseType=="DOC") msgStr="ʹ��ҽ��" 
	    else if(UseType=="PAT") msgStr="���˵ǼǺ�"
        PHA.Popover({ showType: 'show', msg: 'ʹ�÷�Χֵ:"'+msgStr+'"����Ϊ�գ�', type: 'alert' });
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
        if(qty<=0) {
			PHA.Popover({ showType: 'show', msg: '���������������0��', type: 'alert' });
            return;
        }

        if (inci == '' && tmpDesc == '') {
            PHA.Popover({ showType: 'show', msg: '����ѡ��ҩƷ����¼��ҩƷ������', type: 'alert' });
            return;
        }
        if (inci == '' && spec == '') {
            PHA.Popover({ showType: 'show', msg: 'ҩƷδά��ʱ����¼����', type: 'alert' });
            return;
        }
        if (uom == '' || qty == ''  || manf == '') {
            PHA.Popover({
                showType: 'show',
                msg: '��������/��λ/������ҵ ������Ϊ�գ�������ϸ����',
                type: 'alert',
            });
            return;
        }
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    /*
    if (paramsStr == '') {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ�������ϸ��', type: 'alert' });
        return;
    }*/

    var saveRet = tkMakeServerCall('PHA.IN.TmpDrugPurch.Save', 'Save', MianStr, paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg: saveInfo, type: 'alert' });
    } else {
	    PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
        QuerygridTmpDrugMain();
        SetDetailInfo(saveRet);
    }
}

function CompTDP() {
    $('#gridTmpDrugDetail').datagrid('endEditing');
    var RowCount=$('#gridTmpDrugDetail').datagrid('getRows');
    var RowCountLen = RowCount.length;
    if (RowCountLen == 0) {
        PHA.Popover({
            msg: 'û����Ҫ���������',
            type: 'alert',
        });
        return;
    }
    if($("#gridTmpDrugDetail").datagrid('options').editIndex != undefined) 
    {
        PHA.Popover({ showType: 'show', msg: '�б������δ���棬���ȱ������ݣ�', type: 'alert' });
        return;
    }
    var gridChanges = $('#gridTmpDrugDetail').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen > 0) {
        PHA.Popover({
            msg: '�б������δ���棬���ȱ������ݣ�',
            type: 'alert',
        });
        return;
    }
    var TDPNo = $('#TextTDPNO').val();
    if (TDPNo == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ�ҩƷ���뵥', type: 'alert' });
        return;
    }
    /* MaYuqiang 20220601 ����Ժ����ȡ��һ�����̵�id */
    var Status = tkMakeServerCall('PHA.IN.TmpDrugPurch.Save', 'GetTDPStateByDesc', SessionHosp, "���");
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurch.Save',
            MethodName: 'UpdateTDPStaute',
            HospId: SessionHosp,
            TDPNo: TDPNo,
            User: SessionUser,
            Status: Status,
            CancleFlag: '',
        },
        function (retData) {
            if (retData.toString().split('^')[0] > 0) {
                PHA.Popover({ showType: 'show', msg: '��ɳɹ�!', type: 'success' });
                QuerygridTmpDrugMain();
                SetDetailInfo(retData.toString().split('^')[0]);
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: retData,
                    type: 'alert',
                });
        }
    );
}

function CanCelCompTDP() {
    $('#gridTmpDrugDetail').datagrid('endEditing');
    var gridChanges = $('#gridTmpDrugDetail').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen > 0) {
        PHA.Popover({
            msg: '�б������δ���棬���ȱ������ݣ�',
            type: 'alert',
        });
        return;
    }
    var TDPNo = $('#TextTDPNO').val();
    if (TDPNo == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ�ҩƷ���뵥', type: 'alert' });
        return;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurch.Save',
            MethodName: 'UpdateTDPStaute',
            HospId: SessionHosp,
            TDPNo: TDPNo,
            User: SessionUser,
            Status: 1,
            CancleFlag: 'Y',
        },
        function (retData) {
            if (retData.toString().split('^')[0] > 0) {
                PHA.Popover({ showType: 'show', msg: 'ȡ����ɳɹ�!', type: 'success' });
                QuerygridTmpDrugMain();
                SetDetailInfo(retData.toString().split('^')[0]);
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: retData,
                    type: 'alert',
                });
        }
    );
}

function DeleteTDP() {
    var TDPNo = $('#TextTDPNO').val();
    if (TDPNo == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ�ҩƷ���뵥', type: 'alert' });
        return;
    }
    PHA.Confirm('��ʾ', $g('��ȷ��ɾ���ٹ�ҩƷ���뵥:') + TDPNo + '?', function () {
        $.cm(
            {
                ClassName: 'PHA.IN.TmpDrugPurch.Save',
                MethodName: 'DeleteTDP',
                HospId: SessionHosp,
                TDPNo: TDPNo,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: 'ɾ���ɹ�!', type: 'success' });
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
    });
}

function PrintTDP() {
    var TDPNo = $('#TextTDPNO').val();
    if (TDPNo == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ���ٹ�ҩƷ���뵥��', type: 'alert' });
        return;
    }
    PrintTmpDrug(SessionHosp, TDPNo);
}

function Deletei() {
    var gridSelect = $('#gridTmpDrugDetail').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert',
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            var TDPi = gridSelect.TDPi || '';
            if (TDPi == '') {
                var rowIndex = $('#gridTmpDrugDetail').datagrid('getRowIndex', gridSelect);
                $('#gridTmpDrugDetail').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('PHA.IN.TmpDrugPurch.Save', 'DeleteTDPi', TDPi);
                if (delRet != 0) {
                    PHA.Popover({ showType: 'show', msg: delRet, type: 'alert' });
                } else {
                    PHA.Popover({ showType: 'show', msg: 'ɾ����ϸ�ɹ�!', type: 'success' });
                }
                SetDetailInfo(parseInt(TDPi));
            }
        }
    });
}