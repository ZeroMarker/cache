/*
 *Description:����ҩƷ��Ϣά��
 */
var HospId = session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var groupId = session['LOGON.GROUPID'];
var locId = session['LOGON.CTLOCID'];
var INCITM_RowId = "";
var INCIL = "";
var APPName = "DHCSTLOCITMSTK"
var ParamProp = PHA_COM.ParamProp(APPName)

$(function () {
    InitDict(); // ��ʼ�������ֵ�
    InitGrid(); // ��ʼ��grid
    InitConditionFold();    //�����۵�
    
    //ҩ������
    PHA_UX.ComboBox.Loc('cmbPhaLoc', {
	    onChange: function (newVal, oldVal) {
            
            LoadStkBinAndMagGrp();
            cleanGrid();
        }
    });
    
    if (locktype === 'all') {
        $('#cmbLockStore').combobox('setValue', 'A');
        setTimeout(function () { queryIncil(); }, 500);
    }
	
});

//�����۵�
function InitConditionFold(){
    $('.pha-con-more-less').toggle();
    $('.pha-con-more-less-link').toggle();
	$('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-con-more-less-link').toggle();
        $('#lyBody').layout('resize');
        $('#gridIncil').datagrid('getPanel').panel('resize');
    });
}

function InitDict() {
	$('#startDate').datebox('setValue', 't');
    $('#endDate').datebox('setValue', 't');
    PHA_UX.ComboBox.Loc('phaLoc', {});

    //����
    PHA_UX.ComboBox.StkCatGrp('cmbStkGroup', {
		qParams: {
			LocId: PHA_UX.Get('cmbPhaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
		,
		onChange: function (newVal, oldVal) {
            InitIncItmGrid(newVal);
        }
	});
 
   PHA_UX.ComboBox.StkCatGrp('stkGroup', {
		qParams: {
			LocId: PHA_UX.Get('phaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
	/* ������ */
	PHA_UX.ComboBox.StkCat('cmbStkCat', {
        qParams: {
            CatGrpId: PHA_UX.Get('cmbStkGroup')
        }
    });
    
    PHA.ComboBox('cmbIfHaveStore', {
        panelHeight: 'auto',
        editable: false,
        data: [{
                RowId: '0',
                Description: $g('ȫ��')
            }, {
                RowId: '1',
                Description: $g('���Ϊ��')
            }, {
                RowId: '2',
                Description: $g('���Ϊ��')
            }, {
                RowId: '3',
                Description: $g('���Ϊ��')
            }
        ],
    });
    PHA.ComboBox('cmbLockStore', {
        panelHeight: 'auto',
        editable: false,
        data: [{
                RowId: 'A',
                Description: $g('����/סԺ')
            }, {
                RowId: 'O',
                Description: $g('����')
            }, {
                RowId: 'I',
                Description: $g('סԺ')
            }
        ],
    });

    //ҩƷ����combogrid
    var opts = $.extend({width: '160'}, PHA_STORE.INCItmForLoc('Y',locId,"",""), {
    });
    PHA.ComboGrid('cmbgridInci', opts);
  
    //���һ�λ
    PHA_UX.ComboBox.StkBinComb('cmbStkBinStore', {
		qParams: {
			LocId: PHA_UX.Get('cmbPhaLoc', session['LOGON.CTLOCID']),
		}
	});
	
	
    // �����̵���
    PHA.ComboBox('cmbLocMagStore', {
        url: PHA_STORE.LocManGrp(locId).url,
    });
     // ����״̬
    PHA.ComboBox('cmbUseState', {
        panelHeight: 'auto',
        editable: false,
        data: [
            {
                RowId: 'ALL',
                Description: $g('ȫ��'),
            },
            {
                RowId: 'USE',
                Description: $g('����'),
            },
            {
                RowId: 'NOTUSE',
                Description: $g('������'),
            },
        ],
    });
    
    
    
    ///-----��������---------------
    //�Ƿ��п��
    PHA.ComboBox('cmbIfHaveStorei', {
        panelHeight: 'auto',
        width: 100,
        editable: false,
        data: [{
                RowId: 0,
                Description: $g('ȫ��'),
            }, {
                RowId: 1,
                Description: $g('�п��'),
            }, {
                RowId: 2,
                Description: $g('�޿��'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
    $('#cmbIfHaveStorei').combobox('setValue', "1");
    //�Ƿ��п��
    PHA.ComboBox('cmbIncilbState', {
        panelHeight: 'auto',
        width: 100,
        editable: false,
        data: [{
                RowId: 0,
                Description: $g('ȫ��'),
            }, {
                RowId: 1,
                Description: $g('����'),
            }, {
                RowId: 2,
                Description: $g('������'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });

    PHA.ComboBox('cmbIncilArcState', {
        panelHeight: 'auto',
        width: 100,
        editable: false,
        data: [{
                RowId: 0,
                Description: $g('ȫ��'),
            }, {
                RowId: 1,
                Description: $g('����'),
            }, {
                RowId: 2,
                Description: $g('������'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
    
    GridCmbUomFlag = PHA.EditGrid.ComboBox(
        {
            tipPosition: 'top',
            data : [{
                RowId: 'Y',
                Description: $g('��')
            },
            {
                RowId: 'N',
                Description: $g('��')
            },
            {
                RowId: '',
                Description: $g('Ĭ��')
            }]
        }
    );
    
    InitIncItmGrid();
}

// ��λ���̵���Ϳ�������
function LoadStkBinAndMagGrp() {
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    $('#cmbLocMagStore').combobox('reload', PHA_STORE.LocManGrp(Loc).url);
    $('#cmbLocMagStore').combobox('setValue', "");

}
// ҩƷ��ѯ���ܿ��Һ���������� ��Ҫ������ѯ
function InitIncItmGrid(newScg) {
	newScg = newScg || '';
    var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
    var StkGroup = newScg ? newScg : $('#cmbStkGroup').combobox('getValue') || '';
    var opts = $.extend({width: '160'}, PHA_STORE.INCItmForLoc('Y', Loc, userId, StkGroup), {});
    PHA.ComboGrid('cmbgridInci', opts);
    /* ������ */
	PHA_UX.ComboBox.StkCat('cmbStkCat', {
        qParams: {
            CatGrpId: newScg
        }
    });
}

function InitGrid() {
    InitGridIncil();
    InitgridIncilb();
    InitgridDispUom();
    InitgridStkBin();
}

function InitGridIncil() {
	
	var inciLmgEditor = PHA.EditGrid.ComboBox({
    tipPosition: "top",
    url: PHA_STORE.LocManGrp("").url,
    onBeforeLoad: function (param) {
        param.Loc = $('#cmbPhaLoc').combobox('getValue');
    }
    });

    var columns = [
        [ {
                field: 'spec',
                title: '���',
                align: 'left',
                width: 50
            }, {
                field: 'manf',
                title: '������ҵ',
                align: 'left',
                width: 100
            }, {
                field: 'pUom',
                title: 'pUom',
                align: 'center',
                width: 100,
                hidden: true
            }, {
                field: 'pUomDesc',
                title: '��װ��λ',
                align: 'center',
                width: 80
            }, {
                field: 'bUom',
                title: 'bUom',
                align: 'center',
                width: 100,
                hidden: true
            }, {
                field: 'bUomDesc',
                title: '������λ',
                align: 'center',
                width: 80
            },{
                field: 'sp',
                title: '��װ�۸�(�ۼ�)',
                align: 'right',
                width: 100
            }, {
                field: 'maxQty',
                title: '<font color=blue>'+$g("�������")+'</font>',
                align: 'right',
                width: 100,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'minQty',
                title: '<font color=blue>'+$g("�������")+'</font>',
                align: 'right',
                width: 100,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'stkQty',
                title: '�����',
                align: 'right',
                width: 100,
                sortable:true
            }, {
                field: 'avaQty',
                title: '���ÿ��',
                align: 'right',
                width: 100,
                sortable:true
            }, {
                field: 'repQty',
                title: '<font color=blue>'+$g("��׼���")+'</font>',
                align: 'right',
                width: 80,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'repLev',
                title: '<font color=blue>'+$g("������׼")+'</font>',
                align: 'right',
                width: 80,
                editor: {
                    type: 'numberbox'
                }
            }, {
                field: 'incsb',
                title: 'incsb',
                align: 'left',
                width: 100,
                hidden: true
            }, {
                field: 'spStkBin',
                title: '���û�λ',
                align: 'left',
                width: 150,
                hidden: true
            }, {
                field: 'phcpoCode',
                title: '���Ʒ���',
                align: 'left',
                width: 100
            }, {
                field: 'inciLmg',
                title: '<font color=blue>'+$g("�̵���")+'</font>',
                align: 'left',
                width: 100,
                descField: "inciLmgDesc",
                editor: inciLmgEditor,
                formatter: function (value, row, index) {
                    return row.inciLmgDesc
                }
            }, {
                field: 'lockFlag',
                title: '<font color=blue>'+$g("�������")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'InLockFlag',
                title: '<font color=blue>'+$g("סԺ����")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'pivaflag',
                title: '<font color=blue>'+$g("��Һ�����־")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'manFlag',
                title: '<font color=blue>'+$g("����ҩ��־")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: '1',
                        off: '0'
                    }
                },
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }, {
                field: 'planFlag',
                title: '<font color=blue>'+$g("�Զ��ɹ���־")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'pivaflag',
                title: '<font color=blue>'+$g("�Ƿ���Һ��־")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'drugsendflag',
                title: '<font color=blue>'+$g("��ҩ����־")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'drugpackflag',
                title: '<font color=blue>'+$g("�ְ�����־")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'NotUseFlag',
                title: '������',
                align: 'center',
                width: 80,
                formatter:Checkformatter,
                sortable:true
            },{
                field: 'inPhPack',
                title: '<font color=blue>'+$g("סԺ������װ")+'</font>',
                align: 'center',
                width: 80,
                editor: {
                    type: 'checkbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter:Checkformatter
            }, {
                field: 'outPhPack',
                title: '<font color=blue>'+$g("ȡҩ/��Ժ��ҩ�ɷ�������λ")+'</font>',
                align: 'left',
                width: 180,
                descField: "outPhPackDesc",
                editor: GridCmbUomFlag,
                formatter: function (value, row, index) {
                    return row.outPhPackDesc
                }
            }, {
                field: 'lockUser',
                title: '������',
                align: 'left',
                width: 80
            }, {
                field: 'lockDate',
                title: '��������',
                align: 'left',
                width: 125
            }, {
                field: 'lockTime',
                title: '����ʱ��',
                align: 'left',
                width: 100
            }
        ],
    ];
    
    var frozenColumns = [
        [
            {
                field: 'incil',
                title: 'incil',
                align: 'left',
                width: 50,
                hidden: true
            }, {
                field: 'inci',
                title: 'inci',
                align: 'left',
                width: 50,
                hidden: true
            }, {
                field: 'inciCode',
                title: '����',
                align: 'left',
                sortable: true,
                width: 100,
                sortable:true
            }, {
                field: 'inciDesc',
                title: '����',
                align: 'left',
                sortable: true,
                width: 150,
                sortable:true
            }
        ],
    ];

    var dataGridOption = {
        rownumbers: true,
        pagination: true,
        gridSave:true,
        toolbar: '#gridIncilBar',
        nowrap: true,
        idField: 'Incil',
        columns: columns,
        exportXls: true,
        frozenColumns: frozenColumns,
        striped: true,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.INCItmLoc.Query',
            QueryName: 'LocItm',
            HospId: HospId,
            params: '',
            sortName: '',
            sortOrder: ''
        },
        onLoadSuccess: function (data) {
            $('#gridInclb').datagrid('clearSelections');
            $('#gridInclb').datagrid('clear');
            $('#gridDispUom').datagrid('clearSelections');
            $('#gridDispUom').datagrid('clear');
            $('#gridStkBin').datagrid('clearSelections');
            $('#gridStkBin').datagrid('clear');
        },
        onDblClickRow: function (rowIndex, rowData) {
            $('#gridIncil').datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        },
        onSelect: function (rowIndex, rowData) {
            INCIL = rowData.incil;
            INCITM_RowId = rowData.inci;
            queryInclb(INCIL);
            QueryItmSktBin(INCIL);
            QueryDispUom(INCITM_RowId)
        },
        onBeforeLoad:function(param){
	    	$(this).datagrid("clearSelections");
	    },
	    onSortColumn:function(sort, order){
			   
		}
    };
    PHA.Grid('gridIncil', dataGridOption);
}

function Checkformatter(value, row, index) {
    if (value == 'Y') {
        return PHA_COM.Fmt.Grid.Yes.Chinese;
    } else {
        return PHA_COM.Fmt.Grid.No.Chinese;
    }
}

//��ʼ�����α��
function InitgridIncilb() {
    var columns = [
        [{
                field: 'Inclb',
                title: 'Inclb',
                align: 'center',
                width: 100,
                hidden: true
            }, {
                field: 'arcUseFlag',
                title: 'ҽ������',
                align: 'center',
                width: 100,
                formatter: ArcStatusFormatter
            }, {
                field: 'stkUseFlag',
                title: '������',
                align: 'center',
                width: 100,
                formatter: StkStatusFormatter
            }, {
                field: 'BatNo',
                title: '����',
                align: 'left',
                width: 100
            }, {
                field: 'ExpDate',
                title: 'Ч��',
                align: 'left',
                width: 150,
                styler: StatuiStyler,
            }, {
                field: 'QtyUom',
                title: '���',
                align: 'right',
                width: 100
            }, {
                field: 'DirtyQtyUom',
                title: 'ռ��',
                align: 'right',
                width: 100
            }, {
                field: 'AvaQtyUom',
                title: '����',
                align: 'right',
                width: 100
            }, {
                field: 'InclbResQtyUom',
                title: '��;',
                align: 'right',
                width: 100
            }, {
                field: 'BRp',
                title: '����(����)',
                align: 'right',
                width: 100
            }, {
                field: 'PRp',
                title: '����(��װ)',
                align: 'right',
                width: 100
            }, {
                field: 'BSp',
                title: '�ۼ�(����)',
                align: 'right',
                width: 100
            }, {
                field: 'PSp',
                title: '�ۼ�(��װ)',
                align: 'right',
                width: 100
            }, {
                field: 'PVenDesc',
                title: '��Ӫ��ҵ',
                align: 'left',
                width: 150
            }, {
                field: 'PManf',
                title: '������ҵ',
                align: 'left',
                width: 150
            }, {
                field: 'LockUser',
                title: '������',
                align: 'left',
                width: 80
            }, {
                field: 'LockDate',
                title: '����ʱ��',
                align: 'left',
                width: 180
            },
        ],
    ];
    var dataGridOption = {
        toolbar: '#gridInclbBar',
        gridSave: false,
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        striped: true,
        nowrap: false,
        idField: 'Inclb',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'LocItmStkBatch',
            Incil: '',
            ParamsJson: '',
            ExpDateWarnDays: ''
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxarc').switchbox();
            $('.hisui-switchboxstk').switchbox();
        },
        onSelect: function (rowIndex, rowData) {},
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'notuseflag',
                });
            }
        },
    };
    PHA.Grid('gridInclb', dataGridOption);
}

function StatuiStyler(value, row, index) {
    var ExpStatus = row.ExpStatus
        switch (ExpStatus) {
        case 'WARN':
            colorStyle = 'background:#FF6565;color:white;';
            break;
        case 'OVERDUE':
            colorStyle = 'background:gray;color:white;';
            break;
        default:
            colorStyle = 'background:white;color:black;';
            break;
        }
        return colorStyle;
}

//�Զ�ҽ��������и�ʽ
function ArcStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y')
        notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateArc(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>');
}
//�Զ�ҽ��������и�ʽ
function StkStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y')
        notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateStk(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>');
}
//�޸�ҽ������״̬
function UpdateArc(objVal, Inclb, IndexString, value) {
    if (objVal)
        objVal = 'Y';
    else
        objVal = 'N';
    $.cm({
        ClassName: 'PHA.IN.LocItmStk.Save',
        MethodName: 'UpdateArcState',
        Inclb: Inclb,
        ArcUseFlag: objVal,
        User: userId,
    },
        function (retData) {
        if (!retData) {
            PHA.Popover({
                showType: 'show',
                msg: '�޸�ҽ������״̬�ɹ�',
                type: 'success'
            });
            queryInclb();
        } else
            PHA.Popover({
                showType: 'show',
                msg: '�޸�ҽ������״̬ʧ�ܣ� ��������' + retData.desc,
                type: 'alert',
            });
    });
}
//�޸Ŀ�����״̬
function UpdateStk(objVal, Inclb, IndexString, value) {
    if (objVal)
        objVal = 'Y';
    else
        objVal = 'N';
    $.cm({
        ClassName: 'PHA.IN.LocItmStk.Save',
        MethodName: 'UpdateStkState',
        Inclb: Inclb,
        StkUseFlag: objVal,
        User: userId,
    },
        function (retData) {
        if (!retData) {
            PHA.Popover({
                showType: 'show',
                msg: '�޸Ŀ�����״̬�ɹ�',
                type: 'success'
            });
            queryInclb();
        } else
            PHA.Popover({
                showType: 'show',
                msg: '�޸Ŀ�����״̬ʧ�ܣ� ��������' + retData.desc,
                type: 'alert',
            });
    });
}
//��ѯ����ҩƷ��Ϣ
function queryIncil() {
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    var Params = GetMainParams();
    $('#gridIncil').datagrid('query', {
        HospId: HospId,
        params: Params
    });
}
//��ѯ��������
function queryInclb(Incil) {
    if (!Incil) {
        var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
        var Incil = '';
        if (gridSelect)
            Incil = gridSelect.incil;
    }
    if (!Incil)
        return;
    var ParamsJson = JSON.stringify(GetBatchParamsJson());
    $('#gridInclb').datagrid('query', {
        Incil: Incil,
        ExpDateWarnDays: ParamProp.ExpDateWarnDays,
        ParamsJson: ParamsJson,
    });
}

function cleanGrid(){
	$('#gridIncil').datagrid('clearSelections');
    $('#gridIncil').datagrid('clear');
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    $('#gridDispUom').datagrid('clearSelections');
    $('#gridDispUom').datagrid('clear');
    $('#gridStkBin').datagrid('clearSelections');
    $('#gridStkBin').datagrid('clear');
}

//���
function clean() {
    $('#cmbPhaLoc').combobox('setValue', locId);
    $('#cmbStkCat').combobox('clear');
    $('#cmbIfHaveStore').combobox('clear');
    $('#cmbgridInci').combogrid('clear');
    $('#cmbImportFlag').combobox('clear');
    $('#cmbLockStore').combobox('clear')
	$('#cmbStkBinStore').combobox('clear')
	$('#cmbLocMagStore').combobox('clear')
    $('#cmbUseState').combobox('clear');
    $('#cmbIfHaveStorei').combobox('setValue', "1");
    $('#cmbIncilbState').combobox('setValue', "0");
    $('#cmbIncilArcState').combobox('setValue', "0");

    $('#gridIncil').datagrid('clearSelections');
    $('#gridIncil').datagrid('clear');
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    $('#gridDispUom').datagrid('clearSelections');
    $('#gridDispUom').datagrid('clear');
    $('#gridStkBin').datagrid('clearSelections');
    $('#gridStkBin').datagrid('clear');

}
//main��ѯ����
function GetMainParams() {
    var PhaLoc = $('#cmbPhaLoc').combobox('getValue') || '';
    var LockType = $('#cmbLockStore').combobox('getValue') || '';
    var StkGroup = $('#cmbStkGroup').combobox('getValue') || '';
    var StkCat = $('#cmbStkCat').combobox('getValue') || '';
    var IfHaveStore = $('#cmbIfHaveStore').combobox('getValue') || '';

    var Inci = $('#cmbgridInci').combogrid('getValue') || '';
    var StkBin = $('#cmbStkBinStore').combobox('getValue') || '';
    var LocMagGrp = $('#cmbLocMagStore').combobox('getValue') || '';
    var UseState = $('#cmbUseState').combobox('getValue') || '';

    var RetParams = PhaLoc + "^" + userId + "^" + groupId + "^" + LockType + "^" + StkGroup + "^" + StkCat;
    RetParams = RetParams  + "^" + IfHaveStore + "^" + Inci + "^" + StkBin + "^" + LocMagGrp + "^" + UseState;
    return RetParams
}
//���β�ѯ����
function GetBatchParamsJson() {
    return {
        StkDate: "",
        IfHaveStorei: $('#cmbIfHaveStorei').combobox('getValue') || '',
        IncilbState: $('#cmbIncilbState').combobox('getValue') || '',
        IncilbArcState: $('#cmbIncilArcState').combobox('getValue') || '',
    };
}
//��ҩ��λά��
function InitgridDispUom() {
    var ilduLoc = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: "top",
        url: PHA_STORE.Pharmacy().url
    });
    var ilduUom = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: "top",
        url: PHA_STORE.Url + "ClassName=PHA.IN.DHCIncilDispUom.Query&QueryName=InciUOM",
        onBeforeLoad: function (param) {
            param.QText = param.q;
            param.InciId = INCITM_RowId; ;
        }
    });
    var columns = [
        [{
                field: "ilduId",
                title: 'ilduId',
                width: 50,
                hidden: true
            }, {
                field: "ilduLoc",
                title: 'ҩ��',
                width: 200,
                descField: "ilduLocDesc",
                editor: ilduLoc,
                hidden: true,
                formatter: function (value, row, index) {
                    return row.ilduLocDesc
                }
            }, {
                field: "ilduLocDesc",
                title: 'ҩ������',
                width: 200,
                align: "left",
                hidden: true
            }, {
                field: "ilduUom",
                title: '��λ',
                width: 200,
                descField: "ilduUomDesc",
                editor: ilduUom,
                formatter: function (value, row, index) {
                    return row.ilduUomDesc
                }
            }, {
                field: "ilduActive",
                title: '����',
                align: "center",
                width: 120,
                editor: {
                    type: 'icheckbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter: function (value, row, index) {
                    if (value == "Y") {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }, {
                field: "ilduStDate",
                title: '��ʼ����',
                width: 220,
                align: "left",
                editor: {
                    type: "datebox"
                }
            }, {
                field: "ilduEdDate",
                title: '��������',
                width: 220,
                align: "left",
                editor: {
                    type: "datebox"
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DHCIncilDispUom.Query',
            QueryName: 'DHCIncilDispUom',
            InciId: INCITM_RowId
        },
        onBeforeLoad: function (param) {
            param.PhLoc = $('#cmbPhaLoc').combobox('getValue');
        },
        pagination: false,
        columns: columns,
        gridSave: false,
        fitColumns: true,
        autoRowHeight: true,
        toolbar: [{
                iconCls: 'icon-add',
                text: '����',
                handler: function () {
                    var Row = $('#gridIncil').datagrid('getSelected');
                    if (Row === null) {
                        PHA.Popover({
                            showType: "show",
                            msg: "��ѡ��Ҫ��ӵ�λ��ҩƷ�б�",
                            type: 'alert'
                        });
                        return;
                    }
                    INCITM_RowId = Row.inci
                    if (INCITM_RowId == "") {
                        PHA.Popover({
                            msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
                            type: 'alert'
                        });
                        return;
                    }
                    var loc = $('#cmbPhaLoc').combobox('getValue')
                    $("#gridDispUom").datagrid('addNewRow', {
	                    editField: "ilduLoc",
	                    defaultRow: {
	                        ilduActive: "Y",
	                        ilduLoc: loc
	                    }
                	});
               }
            }, {
                iconCls: 'icon-save',
                text: '����',
                handler: function () {
                    var $grid = $("#gridDispUom");
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: "������ɱ�����",
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: "û����Ҫ���������",
                            type: 'alert'
                        });
                        return;
                    }
                    var inputStrArr = [];
                    for (var i = 0; i < gridChangeLen; i++) {
                        var iData = gridChanges[i];
                        if ($grid.datagrid('getRowIndex', iData) < 0) {
                            continue;
                        }
                        var params = (iData.ilduId || "") + "^" + (iData.ilduLoc || "") + "^" + (iData.ilduUom || "") + "^" + (iData.ilduActive || "") + "^" + (iData.ilduStDate || "") + "^" + (iData.ilduEdDate || "");
                        inputStrArr.push(params)
                    }
                    var inputStr = inputStrArr.join("!!");
                    var saveRet = $.cm({
                        ClassName: "PHA.IN.DHCIncilDispUom.Save",
                        MethodName: "SaveMulti",
                        InciId: INCITM_RowId,
                        MultiDataStr: inputStr,
                        dataType: "text"
                    }, false);
                    var saveArr = saveRet.split('^');
                    var saveVal = saveArr[0];
                    var saveInfo = saveArr[1];
                    if (saveVal < 0) {
                        PHA.Alert('��ʾ', saveInfo, saveVal);
                    } else {
                        PHA.Popover({
                            msg: "����ɹ�",
                            type: 'success',
                            timeout: 1000
                        });
                        $grid.datagrid("reload");
                    }
                }
            }, {
                iconCls: 'icon-cancel',
                text: 'ɾ��',
                handler: function () {
                    var $grid = $("#gridDispUom");
                    var gridSelect = $grid.datagrid("getSelected") || "";
                    if (gridSelect == "") {
                        PHA.Popover({
                            msg: "����ѡ����Ҫɾ���ļ�¼",
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm("ɾ����ʾ", "��ȷ��ɾ����?", function () {
                        var ilduId = gridSelect.ilduId || "";
                        var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
                        if (ilduId != "") {
                            var saveRet = $.cm({
                                ClassName: "PHA.IN.DHCIncilDispUom.Save",
                                MethodName: "Delete",
                                IlduId: ilduId,
                                dataType: "text"
                            }, false);
                            var saveArr = saveRet.split('^');
                            var saveVal = saveArr[0];
                            var saveInfo = saveArr[1];
                            if (saveVal < 0) {
                                PHA.Alert('��ʾ', saveInfo, saveVal);
                                return;
                            } else {
                                PHA.Popover({
                                    msg: "ɾ���ɹ�",
                                    type: 'success',
                                    timeout: 1000
                                });
                            }
                        }
                        $grid.datagrid("deleteRow", rowIndex);
                    });
                }
            }
        ],
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid("endEditing");
        },
        onDblClickCell: function (rowIndex, field, value) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        }
    };
    PHA.Grid("gridDispUom", dataGridOption);
}
//��ѯҩƷ��λ
function QueryDispUom(Inci) {
    if (!Inci) {
        return
    }
    var LocId = $('#cmbPhaLoc').combobox('getValue') || '';
    if (LocId == "") {
        PHA.Popover({
            msg: "��ѡ��ҩ��",
            type: 'error',
            timeout: 1000
        });
        return;
    }
    $('#gridDispUom').datagrid('query', {
        InciId: Inci,
        PhLoc: LocId
    });
}
//��λά��
function InitgridStkBin() 
{    
    var columns = [
        [ 
        	{
                field: 'incil',
                title: 'incil',
                align: 'center',
                width: 100,
                hidden: true
            },{
                field: 'sbiId',
                title: 'sbiId',
                align: 'center',
                width: 100,
                hidden: true
            },{
	            field: 'sbId',
                title: '��λ',
                width: 200,
                descField: 'sbDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					loadRemote: true,
					
					url: PHA_IN_STORE.StkBinComb('').url,
					onBeforeLoad: function (param) {
						var locId = $("#cmbPhaLoc").combobox('getValue');
						param.LocId = locId || '' ;
					}
				}),
                formatter: function (value, row, index) {
                    return row.sbDesc;
                }
	        }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        toolbar: '#gridStkBinBar',
        singleSelect: false,
        gridSave:false,
        columns: columns,
        fitColumns: false,
        pagination: false,
        queryParams: {
            ClassName: "PHA.IN.INCItmLoc.Query",
            QueryName: "QuerySbByIncil",
            Incil: ''
        },
        rownumbers: true,
        onSelect: function (rowIndex, rowData) {},
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck('gridStkBin')) return;
        },
	    onDblClickRow: function (rowIndex, rowData) {
		    if (!PHA_GridEditor.EndCheck('gridStkBin')) return;
		    var sbiId = rowData.sbiId;
		    if(!sbiId){
				PHA_GridEditor.Edit({
					gridID : 'gridStkBin',
					index  : rowIndex,
					field  : 'sbId',
					forceEnd : true
				});
		    }
		}
    }
    PHA.Grid("gridStkBin", dataGridOption);
}

//��ѯҩƷ��λ
function QueryItmSktBin(incil) {
    if (!incil) return;
    $('#gridStkBin').datagrid('query', {
        incil: incil
    });
}
//��λά������������
//����
function AddStkBin() {
	var Row = $('#gridIncil').datagrid('getSelected');
    if (Row === null) {
        PHA.Popover({
            showType: "show",
            msg: "��ѡ��Ҫ��ӻ�λ��ҩƷ�б�",
            type: 'alert'
        });
        return;
    }
    incil = Row.incil

    PHA_GridEditor.Add({
		gridID: 'gridStkBin',
		field: 'sbId',
		data:{
			incil : incil
		}
	});
}
//����
function SaveStkBin() {
    if (INCIL == "") {
        return;
    }
    var $grid = $("#gridStkBin");
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: "������ɱ�����",
            type: 'alert'
        });
        return;
    }
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: "û����Ҫ���������",
            type: 'alert'
        });
        return;
    }
    var pJson = {
	    locId : $("#cmbPhaLoc").combobox('getValue'),
	    incil : INCIL,
	    rows  : gridChanges
    }
    $cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "SaveIncilSb",
        jsonParams: JSON.stringify(pJson),
        dataType: "text"
    }, function (ret) {
        if (ret == "0") {
            PHA.Popover({
                msg: "����ɹ���",
                type: 'success',
                timeout: 1000
            });
            $('#gridStkBin').datagrid('reload')
            //$('#gridIncil').datagrid('reload');
        } else {
            PHA.Alert("��ʾ", ret.split("^")[1], "error")
        }
    })
}
//ɾ��
function DelStkBin() {
    var Selected = $("#gridStkBin").datagrid('getSelected');
    if (!Selected) {
        PHA.Popover({
            msg: "����ѡ��Ҫɾ�������ݣ�",
            type: 'error',
            timeout: 1000
        });
        return;
    }
    var sbiId = Selected.sbiId;
    if (!sbiId){
	 	var rowIndex = $('#gridStkBin').datagrid('getRowIndex', Selected);
        $('#gridStkBin').datagrid('deleteRow', rowIndex); 
        return;  
    }
    
    $cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "DeleteIncilSb",
        sbiId: sbiId,
        dataType: "text"
    }, function (ret) {
        if (ret == 0) {
            PHA.Popover({
                msg: "ɾ���ɹ���",
                type: 'success',
                timeout: 1000
            });
            $('#gridStkBin').datagrid('reload');
            //$('#gridIncil').datagrid('reload');
        } else {
            PHA.Alert("��ʾ", ret.split("^")[1], "error")
        }
    })
}

function SaveInci(){    
	$('#gridIncil').datagrid('endEditing');
    var rowData = $("#gridIncil").datagrid('getChanges');
    $cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "Save",
        jsonParams: JSON.stringify(rowData),
        dataType: "text"
    }, function (ret) {
        if (ret == "0") {
            PHA.Popover({
                msg: "����ɹ���",
                type: 'success',
                timeout: 1000
            });
            $('#gridIncil').datagrid('reload')
        } else {
            PHA.Alert("��ʾ", ret.split("^")[1], "error")
        }
    })

 }
//���ݵ���ģ������
function downloadFile(){
	var title={
		locDesc:"��������",
		inciCode:"ҩƷ����",
		inciDesc:"ҩƷ����",
		//stkBin:"��λ����",
		maxQty:"�������",
		minQty:"�������"
	}
	var data=[
		{locDesc:'סԺҩ��', inciCode:"XWY000002",inciDesc:"�������ι೦Һ(����)[133ml]",maxQty:"1000",minQty:"500"},   //stkBin:"����01",
		{locDesc:'סԺҩ��', inciCode:"XWY000003",inciDesc:"���ᶡ���򽺽�(����)[5G]",maxQty:"5000",minQty:"500"},      //stkBin:"����02",
		
	]
	var fileName="����ҩƷ��Ϣ����ģ��.xlsx"
	PHA_COM.ExportFile(title, data, fileName);
}
function uploadData(){
	var options = {
		charset:"tf-8", //'gb2312'
		suffixReg:/^(.xls)|(.xlsx)$/	
	}
	PHA_COM.ImportFile(options,readData)
}
function readData(data){
	var Len = data.length;
	var RowDelim = String.fromCharCode(1);
	var DataStr = "";
	for(var i=0;i<Len;i++){
		var RowData = data[i];
		var LocDesc = RowData.�������� || "";
		var InciCode = RowData.ҩƷ���� || "";
		if(InciCode == ""){
			continue;
		}
		var InciDesc = RowData.ҩƷ���� || "";
        var StkBin = "";                         //RowData.��λ���� || "";
		var MaxQty = RowData.������� || "";
		var MinQty = RowData.������� || "";
		var Detail = LocDesc+"^"+InciCode+"^"+InciDesc+"^"+StkBin+"^"+MaxQty+"^"+MinQty;
		if(DataStr==""){
			DataStr = Detail
		}else{
			DataStr = DataStr + RowDelim + Detail
		}
	}
	if(DataStr == ""){
		PHA.Alert("��ʾ","û����Ҫ���������","error");
		return ;
	}
	$cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "ImportData",
        params: DataStr,
        dataType: "text"
    }, function (ret) {
	    if (ret == "0") {
		    $('#gridIncil').datagrid('reload')
			PHA.Alert("��ʾ","����ɹ���","success")
	    }
    else {
            PHA.Alert("��ʾ", ret.split("^")[1], "error")
        }   
    })	
}

function creatLimts(){
	$('#creatLimtsConWin').dialog('open');	
}

function saveDataBtn(){
	var startDate = $('#startDate').datebox('getValue'); 	//��ʼ����
	var endDate = $('#endDate').datebox('getValue');  	//��������
	var maxlimt = $("#maxlimts").val();                		//����ϵ��
	var minlimt=  $("#minlimts").val();   					//����ϵ��

	if((maxlimt=="")||(maxlimt==null)||(maxlimt<=0)){
		PHA.Alert('��ʾ', $g("����д��ȷ����ϵ��!"));
		return false;
	}
	if((minlimt=="")||(minlimt==null)||(minlimt<=0)){
		PHA.Alert('��ʾ', $g("����д��ȷ����ϵ��!"));
		return false;
	}
	
	if(minlimt>maxlimt){
		PHA.Alert('��ʾ', $g("����ϵ������С������ϵ��!"));
		return false;
	}
	
	if (startDate == undefined || startDate.length <= 0) {
		PHA.Alert('��ʾ', $g("��ѡ��ʼ����!"));
		return;
	}
	if (endDate == undefined || endDate.length <= 0) {
		PHA.Alert('��ʾ', $g("��ѡ���ֹ����!"));
		return;
	}
	var phaLoc=$("#phaLoc").combobox('getValue');
	if (phaLoc == "" ) {
		PHA.Alert('��ʾ', $g("��ѡ��ҩ������!"));
		return;
	}
	var stkgrp=$("#stkGroup").combobox('getValue');
    if (stkgrp == "" ) {
		PHA.Alert('��ʾ', $g("��ѡ������!"));
		return;
	}
	//ҵ������
	var TransType='';
	var PFlag=($("#PFlag").checkbox('getValue')==true?'P':'');
	var YFlag=($("#YFlag").checkbox('getValue')==true?'Y':'');
	var FFlag=($("#FFlag").checkbox('getValue')==true?'F':'');
	var HFlag=($("#HFlag").checkbox('getValue')==true?'H':'');
	var TFlag=($("#TFlag").checkbox('getValue')==true?'T':'');
	var KFlag=($("#KFlag").checkbox('getValue')==true?'K':'');
	if(PFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+PFlag;
		}else{
			TransType=PFlag;
		}
	}
	if(YFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+YFlag;
		}else{
			TransType=YFlag;
		}
	}
	if(FFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+FFlag;
		}else{
			TransType=FFlag;
		}
	}
	if(HFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+HFlag;
		}else{
			TransType=HFlag;
		}
	}
	if(TFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+TFlag;
		}else{
			TransType=TFlag;
		}
	}
	if(KFlag!=''){
		if(TransType!=''){
			TransType=TransType+','+KFlag;
		}else{
			TransType=KFlag;
		}
	}
	if (TransType == null || TransType.length <= 0) {
		PHA.Alert('��ʾ', $g("��ѡ��ҵ������!"));
		return;
	}
	var inputstr = phaLoc + "^" + startDate + "^" + endDate + "^" + maxlimt + "^" + minlimt;
	inputstr = inputstr + "^" + stkgrp + "^" + TransType;
	$cm({
        ClassName: "PHA.IN.INCItmLoc.Save",
        MethodName: "AutoSetloclimqty",
        inputstr: inputstr,
        dataType: "text"
    }, function (ret) {
	    if(ret == 0){
		    $('#creatLimtsConWin').dialog('close');
	   		$('#gridIncil').datagrid('reload')
    		PHA.Alert("��ʾ", "���ɳɹ���","success")
    		
	    }else{
			PHA.Alert("��ʾ", ret.split("^")[1], "error")  
		}
    })
}
/**
 * �رջỰ��
 */
function closeNewWin(){
	$('#creatLimtsConWin').dialog('close');
}

function UpdateInPhUomWin(){
	$('#updateInPhUomWin').dialog('open');	
	InitGridDispCat();
	InitDictForUomWin();
}

function InitGridDispCat(){
 	var columns = [
    	[
    		{ field: 'tSelect', checkbox: true },
	        { field: 'rowID',	title: '���ID',	hidden: true	},
	        { field: 'code',	title: '����',		align: "left",	width: 100	},
	        { field: 'desc',	title: '����',		align: "left",	width: 100	},
       	]
    ];
        var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IP.DispCat.Query',
            QueryName: 'DispCat',
            pJsonStr: JSON.stringify({ hosp: session['LOGON.HOSPID'] }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: null,
        enableDnd: false,
        fitColumns: false,
        exportXls: false,
        singleSelect: false,
        gridSave:false
    };
    PHA.Grid('gridDispCat', dataGridOption);
}

function InitDictForUomWin(){
	
	PHA.ComboBox('uomComfigVal', {
		        data: []
		    }); 
	PHA.ComboBox('uomComfigDesc', {
		hight:'auto',
        data: [
            { RowId: 'inPhPack', 	Description:  $g('סԺ������װ') },
            { RowId: 'outPhPack',	Description:  $g('ȡҩ/��Ժ��ҩ�ɷ�������λ')  }
        ],
        onSelect: function (newVal, oldVal) {   
			var newId = newVal.RowId;
			var data = [
	            { RowId: 'Y', 	Description:  $g('��')  },
	            { RowId: 'N',	Description:  $g('��')  }
	        ] 
			if(newId == 'outPhPack'){
				data.push({ RowId: '', 	Description:  $g('Ĭ��')  })
			}
			PHA.ComboBox('uomComfigVal', {
		        data: data
		    }); 
����  	}  
    });
}

function GetSelectDispCat(){
	var itmArr = [];
	var rows = $('#gridDispCat').datagrid('getChecked');
    if (rows.length === 0) return itmArr;
    for (var i=0; i < rows.length; i++) {
        var id = rows[i].rowID || '';
        if (id) itmArr.push(id);
    }
	return itmArr;
}

function UpdateInPhUom(){
	var dispCatArr = GetSelectDispCat();
	if(dispCatArr.length == 0){
		PHA.Msg('alert', '��ѡ��ҩ���');
		return;
	}
	var uomComfigDesc = $('#uomComfigDesc').combobox('getValue') || '';
	if(!uomComfigDesc){
		PHA.Msg('alert', '��ѡ����������');
		return;
	}
	var uomComfigVal = $('#uomComfigVal').combobox('getValue') || '';
	if((uomComfigDesc == 'inPhPack') && (!uomComfigVal)){
		PHA.Msg('alert', '��ѡ������ֵ');
		return;
	}
	var locId = $('#cmbPhaLoc').combobox('getValue') || '';
	var pJson = {
		dispCatArr 		: dispCatArr,
		locId 			: locId,
		uomComfigDesc 	: uomComfigDesc,
		uomComfigVal 	: uomComfigVal
	}
	pJson = JSON.stringify(pJson);
	
	$cm({
	        ClassName: "PHA.IN.INCItmLoc.Save",
	        MethodName: "UpdateIncilUomByDispCat",
	        pJson: pJson,
	        dataType: "text"
	    }, function (ret) {
		    if(ret == 0){
	    		PHA.Alert("��ʾ", "����ɹ���","success")
		    }else{
				PHA.Alert("��ʾ", ret.split("^")[1], "error")  
		}
    });
	
}

function CloseInPhUom(){
	$('#updateInPhUomWin').dialog('close');	
}