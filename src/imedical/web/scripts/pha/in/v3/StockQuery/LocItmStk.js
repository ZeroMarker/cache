/// ����ѯ
/// Creator:yangsj
/// CreateDate:2021-02-20

var HosId   = session['LOGON.HOSPID'];
var userId  = session['LOGON.USERID'];
var groupId = session['LOGON.GROUPID'];
var locId   = session['LOGON.CTLOCID'];

var APPName="DHCSTLOCITMSTK"
var ParamProp = PHA_COM.ParamProp(APPName)
var cmbWidth  = 230;
var cmbiWidth = 120;
var arcActiveFlag = ParamProp.ArcActiveFlag == "Y" ? false : true 
var stkActiveFlag = ParamProp.StkActiveFlag == "Y" ? false : true 

$(function () {
    InitDict(); 			// ��ʼ�������ֵ�
    InitGrid(); 			// ��ʼ��grid
    InitBtn(); 				// ��ʼ����ť
    InitEvent(); 			// ��ʼ���¼�
    InitConditionFold();  	//�����۵�
    
});

//�����۵�
function InitConditionFold()
{
	var $lyBody = $('#lyBody');
	$('.pha-con-more-less').toggle();
    $('.pha-con-more-less-link').toggle();
	$lyBody.layout('panel', 'north').panel('resize', { height: 90 });
    $lyBody.layout('resize');
     $('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-con-more-less-link').toggle();
        var tHeight = $('.pha-con-more-less-link').css('display') === 'block' ? 175 : 95;
        $lyBody.layout('panel', 'north').panel('resize', { height: tHeight });
        $lyBody.layout('resize');
    });
}

function InitDict() {
	$('#StkDate').datebox('setValue', 't');
    //ҩ������
    /*
    PHA.ComboBox('cmbPhaLoc', {
        width: cmbWidth,
        url: PHA_STORE.GetGroupDept().url,
        onChange:function (newVal,oldVal) {
	        InitScg();
	        InitIncItmGrid();
        }
    });
    $('#cmbPhaLoc').combobox('setValue', locId);
    */
    PHA_UX.ComboBox.Loc('cmbPhaLoc', {
	    width:cmbWidth,
	    onSelect:function(option){
	       var locId = option.RowId;
	       InitIncItmGrid(locId);
        }
	});
    
    //����
    /*
    PHA.ComboBox('cmbStkGroup', {
        width: cmbWidth,
        onChange:function (newVal,oldVal) {
	        InitIncItmGrid();
	        if(!newVal) newVal=""
	        $('#cmbStkCat').combobox('clear');
        	$('#cmbStkCat').combobox('reload', PHA_STORE.INCStkCat().url + '&CatGrpId=' + newVal+ '&NeedScgFlag=' + "Y"  );
        },
        onLoadSuccess:function(){
	        SetDefaultStkGroup();
	        }
    });
    PHA.ComboBox('cmbStkCat', {
        width: cmbWidth,
        // url: PHA_STORE.INCStkCat().url
    });
    
    */
    
    PHA_UX.ComboBox.StkCatGrp('cmbStkGroup', {
		qParams: {
			width:cmbWidth,
			LocId: PHA_UX.Get('cmbPhaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	PHA_UX.ComboBox.StkCat('cmbStkCat', {
        qParams: {
	        width:cmbWidth,
            CatGrpId: PHA_UX.Get('cmbStkGroup')
        }
    });
    PHA.ComboBox('cmbIfHaveStore', {
        panelHeight: 'auto',
        editable: false,
        width: cmbWidth,
        data: [
            {
                RowId: '0',
                Description: $g('ȫ��'),
            },
            {
                RowId: '1',
                Description: $g('���Ϊ��'),
            },
            {
                RowId: '2',
                Description: $g('���Ϊ��'),
            },
            {
                RowId: '3',
                Description: $g('���Ϊ��'),
            },
        ],
    });
    /*
    //ҩƷ����lookup
    var opts = $.extend({}, PHA_STORE.INCItmForLoc('Y',locId,userId,""), {
        width: cmbWidth,
    });
    PHA.LookUp('cmbgridInci', opts);
    */

    //���ڱ�־
    PHA.ComboBox('cmbImportFlag', {
        panelHeight: 'auto',
        width: cmbWidth,
        data: [
            {
                RowId: $g('����'),
                Description: $g('����'),
            },
            {
                RowId: $g('����'),
                Description: $g('����'),
            },
            {
                RowId: $g('����'),
                Description: $g('����'),
            },
        ],
    });
    //ҩѧ����
    PHA.TriggerBox('genePHCCat', {
        width: cmbWidth,
        handler: function (data) {
            PHA_UX.DHCPHCCat('genePHCCat', {}, function (data) {
                $('#genePHCCat').triggerbox('setValue', data.phcCatDescAll);
                $('#genePHCCat').triggerbox('setValueId', data.phcCatId);
            });
        },
    });
    //ҽ������
    PHA.ComboBox('cmbArcimItemCat', {
        width: cmbWidth,
        mode: 'remote',
        url: PHA_STORE.ARCItemCat().url,
    });
    // ���Ʒ���
    PHA.ComboBox('cmbPoison', {
        width: cmbWidth,
        url: PHA_STORE.PHCPoison().url,
    });
    // ������ҵ
    PHA.ComboBox('cmbManf', {
        width: cmbWidth,
        url: PHA_STORE.PHManufacturer().url,
    });
    // ����
    PHA.ComboBox('cmbForm', {
        width: cmbWidth,
        url: PHA_STORE.PHCForm().url,
    });
    // ҽ����״̬
    PHA.ComboBox('cmbArcStat', {
        panelHeight: 'auto',
        editable: false,
        width: cmbWidth,
        data: [
            {
                RowId: 0,
                Description: $g('ȫ��'),
            },
            {
                RowId: 1,
                Description: $g('ҽ�����ֹ'),
            },
            {
                RowId: 2,
                Description: $g('ҽ��������'),
            },
        ],
    });
    // ����״̬
    PHA.ComboBox('cmbUseState', {
        panelHeight: 'auto',
        editable: false,
        width: cmbWidth,
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
        editable: false,
        width: cmbiWidth,
        data: [
            {
                RowId: 0,
                Description: $g('ȫ��'),
            },
            {
                RowId: 1,
                Description: $g('�п��'),
            },
            {
                RowId: 2,
                Description: $g('�޿��'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
	$('#cmbIfHaveStorei').combobox('setValue',"1");
    //�Ƿ��п��
    PHA.ComboBox('cmbIncilbState', {
        panelHeight: 'auto',
        editable: false,
        width: cmbiWidth,
        data: [
            {
                RowId: 0,
                Description: $g('ȫ��'),
            },
            {
                RowId: 1,
                Description: $g('����'),
            },
            {
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
        editable: false,
        width: cmbiWidth,
        data: [
            {
                RowId: 0,
                Description: $g('ȫ��'),
            },
            {
                RowId: 1,
                Description: $g('����'),
            },
            {
                RowId: 2,
                Description: $g('������'),
            },
        ],
        onSelect: function (data) {
            queryInclb();
        }
    });
    
    
}

// ����Ĭ��ֵ
function SetDefaultStkGroup(){
	var loc = $('#cmbPhaLoc').combobox('getValue') || '';
	var defaultScg = tkMakeServerCall("PHA.STORE.Org","GetDefaultScg",loc,userId)
	$('#cmbStkGroup').combobox('setValue',defaultScg)
	// �������첽��ʽ�ͱ���T_T
	/*
	$.cm({
            ClassName: 'PHA.STORE.Org',
            MethodName: 'GetDefaultScg',
            LocId: loc,
            UserId: userId,
        },
        function (retData) {
            if (retData=="") {
	            $('#cmbStkGroup').combobox('clear');
            } else {
                $('#cmbStkGroup').combobox('setValue',retData)
            }
        });
        */
}

// �����ܿ��ұ仯����
function InitScg()
{
	var Loc = $('#cmbPhaLoc').combobox('getValue') || '';
	$('#cmbStkGroup').combobox('reload', PHA_STORE.LocStkCatGroup().url + '&LocId='+Loc+'&UserId='+userId);
    //$('#cmbStkGroup').combobox('clear');  //�������ʹ��clear���򲻻ᴥ��#cmbStkGroup��onchange�¼���Ҳ�Ͳ��ᴥ��������ļ����¼�
    $('#cmbStkGroup').combobox('setValue',"");
    
}

// ҩƷ��ѯ���ܿ��Һ���������� ��Ҫ������ѯ
function InitIncItmGrid(locId)
{
	//ҩƷ����lookup
    var StkGroup = $('#cmbStkGroup').combobox('getValue') || '';
    var opts = $.extend({}, PHA_STORE.INCItmForLoc('Y',locId, userId, StkGroup), {
        width: cmbWidth,
    });
    PHA.LookUp('cmbgridInci', opts);
}

function InitGrid() {
    InitGridIncil();
    InitgridIncilb();
}

function InitGridIncil() {
    var columns = [
        [
            //Incil,Inci,InciCode,InciDesc,IncsbDesc,PurchCTUomDesc,BaseCTUomDesc,PurStockQty,StockQty,StkQtyUom,SalePrice,SpAmt,LastReailPrice,
            { field: 'IncsbDesc', title: '��λ', align: 'left', width: 80 },
            { field: 'PurStockQty', title: '���(��װ��λ)', align: 'right', width: 100 },
            { field: 'PUomDesc', title: '��װ��λ', align: 'center', width: 100 },
            { field: 'StockQty', title: '���(������λ)', align: 'right', width: 100 },
            { field: 'BUomDesc', title: '������λ', align: 'center', width: 100 },
            { field: 'StkQtyUom', title: '���(��λ)', align: 'right', width: 100 },
            { field: 'DirtyQtyUom', title: 'ռ�ÿ��', align: 'right', width: 100 },
            { field: 'AvaQtyUom', title: '���ÿ��', align: 'right', width: 100 },
            //RpAmt,Spec,ManfDesc,OfficalCode,ManFlag,DirtyQtyUom,AvaQtyUom,ReservedQty,Gene,Form
            { field: 'ReservedQty', title: '��;��', align: 'right', width: 100 },
            { field: 'SalePrice', title: '���ۼ�', align: 'right', width: 100 },
            { field: 'LastReailPrice', title: '���½���', align: 'right', width: 100 },
            { field: 'SpAmt', title: '�ۼ۽��', align: 'right', width: 100 },
            { field: 'RpAmt', title: '���۽��', align: 'right', width: 100 },
            { field: 'Spec', title: '���', align: 'left', width: 80 },
            { field: 'ManfDesc', title: '������ҵ', align: 'left', width: 250 },
            { field: 'Gene', title: '����ͨ����', align: 'left', width: 150 },
            { field: 'Form', title: '����', align: 'left', width: 80 },
            {
                field: 'ManFlag',
                title: '����ҩ',
                align: 'center',
                width: 60,
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return "";
                    }
                },
            },
            { field: 'InsuCode', title: '����ҽ������', align: 'left', width: 100 },
            { field: 'InsuDesc', title: '����ҽ������', align: 'left', width: 100 },
        ],
    ];
    var frozenColumns = [
        [
            { field: 'Incil', 	title: 'Incil', align: 'left', 		width: 100, hidden: true },
            { field: 'opre', 	title: '����', 	align: 'center', 	width: 50 ,formatter:MianOpreFormatter},
            { field: 'InciCode', title: '����', align: 'left',		sortable: true, width: 100 },
            { field: 'InciDesc', title: '����', align: 'left',		sortable: true, width: 300 },
        ],
    ];

    var dataGridOption = {
	    gridSave:true,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridIncilBar',
        nowrap: false,
        idField: 'Incil',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'LocItmStk',
            HospId: '',
            ParamsJson: '',
        },
        onLoadSuccess: function (data) {},
        onSelect: function (rowIndex, rowData) {
            var Incil = rowData.Incil;
            queryInclb(Incil);
        },
    };
    //InitMainOperate(); �ƶ���������ť�ϣ��˷�������
    PHA.Grid('gridIncil', dataGridOption);
}

function InitgridIncilb() {
    var columns = [
        [
            //BatNo,Expire,ExpDate,BRp,PRp,Inclb,DirtyQtyUom,AvaQtyUom,PVenDesc,PManf,notuseflag,BSp,PSp,InclbResQtyUom,LockUser,LockDate,stknotuseflag
            { field: 'Inclb', title: 'Inclb', align: 'center', width: 100, hidden: true },
            { field: 'opre', title: '����', align: 'center', width: 50 ,formatter:DetailOpreFormatter},
            {
                field: 'arcUseFlag',
                title: 'ҽ������',
                align: 'center',
                width: 100,
                formatter: ArcStatusFormatter,
                hidden: arcActiveFlag
            },
            {
                field: 'stkUseFlag',
                title: '������',
                align: 'center',
                width: 100,
                formatter: StkStatusFormatter,
                hidden: stkActiveFlag
            },
            { field: 'BatNo', title: '����', align: 'left', width: 100 },
            { field: 'ExpDate', title: 'Ч��', align: 'left', width: 150 ,styler:StatuiStyler,},
            { field: 'QtyUom', title: '���', align: 'right', width: 100 },
            { field: 'DirtyQtyUom', title: 'ռ��', align: 'right', width: 100 },
            { field: 'AvaQtyUom', title: '����', align: 'right', width: 100 },
            { field: 'InclbResQtyUom', title: '��;', align: 'right', width: 100 },
            { field: 'BRp', title: '����(����)', align: 'right', width: 100 },
            { field: 'PRp', title: '����(��װ)', align: 'right', width: 100 },
            { field: 'BSp', title: '�ۼ�(����)', align: 'right', width: 100 },
            { field: 'PSp', title: '�ۼ�(��װ)', align: 'right', width: 100 },
            { field: 'PVenDesc', title: '��Ӫ��ҵ', align: 'left', width: 150 },
            { field: 'PManf', title: '������ҵ', align: 'left', width: 150 },
            { field: 'LockUser', title: '������', align: 'left', width: 80 },
            { field: 'LockDate', title: '����ʱ��', align: 'left', width: 180 },
        ],
    ];
    var dataGridOption = {
	    toolbar: '#gridInclbBar',
        fit: true,
        gridSave:false,
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        nowrap: false,
        idField: 'Inclb',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'LocItmStkBatch',
            Incil: '',
            ParamsJson: '',
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxarc').switchbox();
            $('.hisui-switchboxstk').switchbox();
        },
        onSelect: function (rowIndex, rowData) {
            /*var DULRowId = rowData.DULRowId;
            $('#gridCom').datagrid('query', {
                inputStr: DULRowId,
            });
            */
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'notuseflag',
                });
            }
        },
    };
    //InitDetailOperate(); �ƶ���������ť�ϣ��˷�������
    PHA.Grid('gridInclb', dataGridOption);
}

function StatuiStyler(value, row, index)
{
	var ExpStatus =row.ExpStatus
     switch (ExpStatus) {
         case 'WARN':
             colorStyle = 'background:#f1c516;color:white;';
             break;
         case 'OVERDUE':
             colorStyle = 'background:#ee4f38;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break;
     }
     return colorStyle;
}


function MianOpreFormatter(value, rowData, rowIndex) {
	var Incil = rowData.Incil;
	var InciDesc = rowData.InciDesc;
	if ((Incil!="")&&(Incil!=undefined))
	return (
       "<a class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-w-find'\" onclick=\"javascript:InitMainOperateNew(event,'"+Incil+"','"+InciDesc+"')\">����</a>"
    ); 
    else  return ("");

}

function DetailOpreFormatter(value, rowData, rowIndex) {
	var Inclb = rowData.Inclb;
	if ((Inclb!="")&&(Inclb!=undefined))
	return (
       "<a class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-w-find'\" onclick=\"javascript:InitDetailOperateNew(event,'"+Inclb+"')\">����</a>"
    ); 

}

//�Զ�ҽ��������и�ʽ
function ArcStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y') notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateArc(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>'
    );
}

//�Զ�ҽ��������и�ʽ
function StkStatusFormatter(value, rowData, rowIndex) {
    var Inclb = rowData.Inclb;
    var IndexString = JSON.stringify(rowIndex);
    var notUseflag = false;
    if (value == 'Y') notUseflag = true;
    return (
        "<div class=\"hisui-switchboxarc\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
        notUseflag +
        ",disabled:false,onSwitchChange:function(e, obj){UpdateStk(obj.value,'" +
        Inclb +
        "'," +
        IndexString +
        ",'" +
        value +
        '\')}"></div>'
    );
}

function UpdateArc(objVal, Inclb, IndexString, value) {
    if (objVal) objVal = 'Y';
    else objVal = 'N';
    $.cm(
        {
            ClassName: 'PHA.IN.LocItmStk.Save',
            MethodName: 'UpdateArcState',
            Inclb: Inclb,
            ArcUseFlag: objVal,
            User: userId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: '�޸�ҽ������״̬�ɹ�', type: 'success' });
                queryInclb();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: '�޸�ҽ������״̬ʧ�ܣ� ��������' + retData.desc,
                    type: 'alert',
                });
        }
    );
}

function UpdateStk(objVal, Inclb, IndexString, value) {
    if (objVal) objVal = 'Y';
    else objVal = 'N';
    $.cm(
        {
            ClassName: 'PHA.IN.LocItmStk.Save',
            MethodName: 'UpdateStkState',
            Inclb: Inclb,
            StkUseFlag: objVal,
            User: userId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: '�޸Ŀ�����״̬�ɹ�', type: 'success' });
                queryInclb();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: '�޸Ŀ�����״̬ʧ�ܣ� ��������' + retData.desc,
                    type: 'alert',
                });
        }
    );
}

function InitBtn() {}
function InitEvent() {}

function queryIncil() {
	$('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    var ParamsJson = JSON.stringify(GetMainParamsJson());
    $('#gridIncil').datagrid('query', {
        HospId: HosId,
        ParamsJson: ParamsJson,
    });
}

function queryInclb(Incil) {
    if (!Incil) {
	    var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
	    var Incil = '';
	    if (gridSelect) Incil = gridSelect.Incil;
    }
    if (!Incil) return;
    var ParamsJson = JSON.stringify(GetBatchParamsJson());
    $('#gridInclb').datagrid('query', {
        Incil: 			 Incil,
        ExpDateWarnDays: ParamProp.ExpDateWarnDays,
        ParamsJson: 	 ParamsJson,
    });
}

function clean() {
	$('#cmbPhaLoc').combobox('setValue', locId);
    $('#StkDate').datebox('setValue', 't');
    SetDefaultStkGroup();
    //$('#cmbStkGroup').combobox('clear');
    $('#cmbStkCat').combobox('clear');
    $('#cmbIfHaveStore').combobox('clear');
    $('#cmbgridInci').lookup('clear');
    $('#cmbImportFlag').combobox('clear');
    $('#genePHCCat').triggerbox('clear');
    $('#cmbArcimItemCat').combobox('clear');
    $('#cmbPoison').combobox('clear');
    $('#cmbManf').combobox('clear');
    $('#cmbForm').combobox('clear');
    $('#cmbArcStat').combobox('setValue',"0");
    $('#cmbUseState').combobox('clear');
    $('#chkManFlag').checkbox('setValue', false);
    $('#chkWithRes').checkbox('setValue', false);
    
    $('#cmbIfHaveStorei').combobox('setValue',"1");
    $('#cmbIncilbState').combobox('setValue',"0");
    $('#cmbIncilArcState').combobox('setValue',"0");
    
    $('#gridIncil').datagrid('clearSelections');
    $('#gridIncil').datagrid('clear');
    $('#gridInclb').datagrid('clearSelections');
    $('#gridInclb').datagrid('clear');
    
}

function GetMainParamsJson() {
    return {
        PhaLoc: $('#cmbPhaLoc').combobox('getValue') || '',
        StkDate: $('#StkDate').datebox('getValue'),
        StkGroup: $('#cmbStkGroup').combobox('getValue') || '',
        StkCat: $('#cmbStkCat').combobox('getValue') || '',
        IfHaveStore: $('#cmbIfHaveStore').combobox('getValue') || '',
        Inci: $('#cmbgridInci').lookup('getValue') || '',
        ImportFlag: $('#cmbImportFlag').combobox('getValue') || '',
        genePHCCat: $('#genePHCCat').triggerbox('getValueId') || '',
        ArcimItemCat: $('#cmbArcimItemCat').combobox('getValue') || '',
        Poison: $('#cmbPoison').combobox('getValue') || '',
        Manf: $('#cmbManf').combobox('getValue') || '',
        Form: $('#cmbForm').combobox('getValue') || '',
        ArcStat: $('#cmbArcStat').combobox('getValue') || '',
        UseState: $('#cmbUseState').combobox('getValue') || '',
        ManFlag: $('#chkManFlag').is(':checked') ? 'Y' : 'N',
        WithRes: $('#chkWithRes').is(':checked') ? 'Y' : 'N',
    };
}

function GetBatchParamsJson() {
    return {
        StkDate: $('#StkDate').datebox('getValue') || '',
        IfHaveStorei: $('#cmbIfHaveStorei').combobox('getValue') || '',
        IncilbState: $('#cmbIncilbState').combobox('getValue') || '',
        IncilbArcState: $('#cmbIncilArcState').combobox('getValue') || '',
    };
}

function InitMainOperate() {
    var menuId = 'mainMenu';
    var gridId = 'gridIncil';
    var gParam = tkMakeServerCall('PHA.IN.LocItmStk.Query', 'GetParamProp', groupId, locId, userId);
    var gParamArr = gParam.split('^');
    var OperateArr = [
        'IntransInfo',
        'ClaerHospRes',
        'ClaerLocRes',
        'ClaerIncilRes',
        'LocStkSyn',
        'IncilStkSyn',
        'HospStkInfo',
        'ResInfo',
    ];
    var OperateArrDesc = [
        '̨����Ϣ��ѯ',
        'ȫԺ��;�����',
        '������;�����',
        '���ҵ�Ʒ��;�����',
        '���ҿ��ͬ��',
        '���ҵ�Ʒ���ͬ��',
        'ȫԺ���ҿ��',
        '��;����ѯ',
    ];
    var OperateLen = OperateArr.length;
    var html =
        '<div id=' +
        menuId +
        ' class="hisui-menu" style=" display: none;">' +
        '<div id=' +
        menuId +
        '_export' +
        '>����</div>';
    for (i = 0; i < OperateLen; i++) {
        if (gParamArr[i] == undefined || gParamArr[i] == 'Y') {
            var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
        }
    }
    html = html + '</div>';
    PHA.onRowContextMenu = function (e, rowIndex, rowData) {
        // �Ҽ�
        var incil = rowData.Incil || '';
        var InciDesc = rowData.InciDesc || '';
        if (incil == '') return;
        e.preventDefault(); //��ֹ����ð��
        if ($('#' + menuId).length > 0) {
            $('#' + menuId).remove();
        }
        $('body').append(html);
        $('#' + menuId).menu();
        $('#' + menuId).menu('show', {
            left: e.pageX,
            top: e.pageY,
        });
        $('#' + menuId + '_export').on('click', function () {
            PHA_COM.ExportGrid(gridId);
        });
        $('#IntransInfo').on('click', function () {
            IntransInfo(incil, InciDesc);
        });
        $('#ClaerHospRes').on('click', function () {
            ClaerHospRes();
        });
        $('#ClaerLocRes').on('click', function () {
            ClaerLocRes();
        });
        $('#ClaerIncilRes').on('click', function () {
            ClaerIncilRes(incil);
        });
        $('#LocStkSyn').on('click', function () {
            LocStkSyn();
        });
        $('#IncilStkSyn').on('click', function () {
            IncilStkSyn(incil);
        });
        $('#HospStkInfo').on('click', function () {
            HospStkInfo(incil, InciDesc);
        });
        $('#ResInfo').on('click', function () {
            ResInfo(incil, InciDesc);
        });
    };
}

function InitMainOperateNew(event,incil, InciDesc) {
    var menuId = 'mainMenu';
    var gridId = 'gridIncil';
    var gParam = tkMakeServerCall('PHA.IN.LocItmStk.Query', 'GetParamProp', groupId, locId, userId);
    var gParamArr = gParam.split('^');
    var OperateArr = [
        'IntransInfo',
        'ClaerHospRes',
        'ClaerLocRes',
        'ClaerIncilRes',
        'LocStkSyn',
        'IncilStkSyn',
        'HospStkInfo',
        'ResInfo',
    ];
    var OperateArrDesc = [
        '̨����Ϣ��ѯ',
        'ȫԺ��;�����',
        '������;�����',
        '���ҵ�Ʒ��;�����',
        '���ҿ��ͬ��',
        '���ҵ�Ʒ���ͬ��',
        'ȫԺ���ҿ��',
        '��;����ѯ',
    ];
    var OperateLen = OperateArr.length;
    var html = '<div id=' +  menuId + ' class="hisui-menu" style=" display: none;">' ;
    for (i = 0; i < OperateLen; i++) {
        if (gParamArr[i] == undefined || gParamArr[i] == 'Y') {
            var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
        }
    }
    html = html + '</div>';
    if ($('#' + menuId).length > 0) {
        $('#' + menuId).remove();
    }
    $('body').append(html);
    $('#' + menuId).menu();
    $('#' + menuId).menu('show', {
        left: event.pageX,
        top: event.pageY,
    });
    $('#IntransInfo').on('click', function () {
        IntransInfo(incil, InciDesc);
    });
    $('#ClaerHospRes').on('click', function () {
        ClaerHospRes();
    });
    $('#ClaerLocRes').on('click', function () {
        ClaerLocRes();
    });
    $('#ClaerIncilRes').on('click', function () {
        ClaerIncilRes(incil);
    });
    $('#LocStkSyn').on('click', function () {
        LocStkSyn();
    });
    $('#IncilStkSyn').on('click', function () {
        IncilStkSyn(incil);
    });
    $('#HospStkInfo').on('click', function () {
        HospStkInfo(incil, InciDesc);
    });
    $('#ResInfo').on('click', function () {
        ResInfo(incil, InciDesc);
    });
  
}

function IntransInfo(incil, InciDesc) {
    $('#IntransInfoInciDesc').text('ҩƷ����: ' + InciDesc);
    $('#IntransInfoIncil').text(incil);
    $('#IntransInfoStDate').datebox('setValue', 't');
    $('#IntransInfoEdDate').datebox('setValue', 't');
    $('#diagIntransInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            { field: 'TrId', 		title: 'TrId', 			align: 'left', 	width: 100, hidden: true },
            { field: 'TrDate', 		title: '����', 			align: 'left', 	width: 150 },
            { field: 'BatExp', 		title: '����Ч��', 		align: 'left', 	width: 200 },
            { field: 'PurUom', 		title: '��λ', 			align: 'center',width: 100 },
            { field: 'Sp', 			title: '�ۼ�', 			align: 'right', width: 100 },
            { field: 'Rp', 			title: '����', 			align: 'right', width: 100 },
            { field: 'EndQtyUom', 	title: '��������', 		align: 'right', width: 100 },
            { field: 'TrQtyUom', 	title: '����', 			align: 'right', width: 100 },
            { field: 'RpAmt', 		title: '���۽��', 		align: 'right', width: 100 },
            { field: 'SpAmt', 		title: '�ۼ۽��', 		align: 'right', width: 100 },
            { field: 'TrNo', 		title: '�����', 		align: 'left', 	width: 200 },
            { field: 'TrAdm', 		title: '������Ϣ', 		align: 'left', 	width: 100 },
            { field: 'TrMsg', 		title: 'ҵ������', 		align: 'center',width: 100 },
            { field: 'EndRpAmt', 	title: '������(����)',align: 'right', width: 100 },
            { field: 'EndSpAmt', 	title: '������(�ۼ�)',align: 'right', width: 100 },
            { field: 'Manf', 		title: '������ҵ', 			align: 'left', 	width: 200 },
            { field: 'OperateUser', title: '������', 		align: 'left', 	width: 100 }
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'IntransInfo',
            INCIL: incil,
            StDate: $('#IntransInfoStDate').datebox('getValue'),
            EdDate: $('#IntransInfoEdDate').datebox('getValue'),
        },
        gridSave: false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagIntransInfoBar',
    };
    PHA.Grid('gridIntransInfo', dataGridOption);
}
function queryIntransInfo() {
    $('#gridIntransInfo').datagrid('query', {
        INCIL: $('#IntransInfoIncil').text(),
        StDate: $('#IntransInfoStDate').datebox('getValue'),
        EdDate: $('#IntransInfoEdDate').datebox('getValue'),
    });
}

function ClaerHospRes() {
	PHA.Confirm('��ʾ', '�Ƿ�Ҫ���ȫԺ��;��?', function () {
	    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'ClrResQtyHosp', HosId);
	    if (ret > 0) {
	        PHA.Popover({ showType: 'show', msg: 'ȫԺ��;������ɹ�', type: 'success' });
	    } else
	        PHA.Popover({
	            showType: 'show',
	            msg: 'ȫԺ��;�����ʧ�ܣ� ��������' + ret,
	            type: 'alert',
	        });
   });
}
function ClaerLocRes() {
	var locId = $('#cmbPhaLoc').combobox('getValue') || '';
	PHA.Confirm('��ʾ', '�Ƿ�Ҫ���������;��?', function () {
	    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'ClrResQtyLoc', locId);
	    if (ret > 0) {
	        PHA.Popover({ showType: 'show', msg: '������;������ɹ�', type: 'success' });
	        queryIncil();
	    } else
	        PHA.Popover({
	            showType: 'show',
	            msg: '������;�����ʧ�ܣ� ��������' + ret,
	            type: 'alert',
	        });
	 });
}
function ClaerIncilRes(incil) {
	PHA.Confirm('��ʾ', '�Ƿ�Ҫ������ҵ�Ʒ��;��?', function () {
	    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'ClrResQtyLocInci', incil);
	    if (ret > 0) {
	        PHA.Popover({ showType: 'show', msg: '���ҵ�Ʒ��;������ɹ�', type: 'success' });
	        queryIncil();
	    } else
	        PHA.Popover({
	            showType: 'show',
	            msg: '���ҵ�Ʒ��;�����ʧ�ܣ� ��������' + ret,
	            type: 'alert',
	        });
	});
}
function LocStkSyn() {
	var locId = $('#cmbPhaLoc').combobox('getValue') || '';
    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'SynIncilLoc', locId);
    if (ret > 0) {
        PHA.Popover({ showType: 'show', msg: '���ҿ��ͬ���ɹ�', type: 'success' });
        queryIncil();
    } else
        PHA.Popover({
            showType: 'show',
            msg: '���ҿ��ͬ���ɹ�ʧ�ܣ� ��������' + ret,
            type: 'alert',
        });
}
function IncilStkSyn(incil) {
    var ret = tkMakeServerCall('PHA.IN.LocItmStk.Save', 'SynInciLocInci', incil);
    if (ret > 0) {
        PHA.Popover({ showType: 'show', msg: '���ҵ�Ʒ���ͬ���ɹ�', type: 'success' });
        queryIncil();
    } else
        PHA.Popover({
            showType: 'show',
            msg: '���ҵ�Ʒ���ͬ���ɹ�ʧ�ܣ� ��������' + ret,
            type: 'alert',
        });
}
function HospStkInfo(incil, InciDesc) {
    $('#HospStkInfoInciDesc').text('ҩƷ����: ' + InciDesc);
    $('#diagHospStkInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            { field: 'locDesc', title: '����', align: 'left', width: 200 },
            { field: 'StockQtyUom', title: '���', align: 'right', width: 220 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'HospStkInfo',
            INCIL: incil,
            Hosp: HosId,
        },
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagHospStkInfoBar',
    };
    PHA.Grid('gridHospStkInfo', dataGridOption);
}
function ResInfo(incil, InciDesc) {
    $('#ResInfoInciDesc').text('ҩƷ����: ' + InciDesc);
    $('#diagResInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // INCIL,pointer,patNo,patName,orderDept,prescNo,resQty,uomDesc,oeDspDate,oeDspTime
            { field: 'gridDetailSelect', checkbox: true },
            { field: 'INCIL', title: 'INCIL', align: 'left', width: 200, hidden: true },
            { field: 'pointer', title: 'pointer', align: 'left', width: 220, hidden: true },
            { field: 'patNo', title: '�ǼǺ�', align: 'left', width: 150 },
            { field: 'patName', title: '����', align: 'left', width: 100 },
            { field: 'orderDept', title: 'ҽ������', align: 'left', width: 150 },
            { field: 'prescNo', title: '������', align: 'left', width: 150 },
            { field: 'resQty', title: 'ʣ����;��', align: 'right', width: 100 },
            { field: 'uomDesc', title: '��λ', align: 'center', width: 80 },
            { field: 'oeDspDate', title: '����', align: 'left', width: 100 },
            { field: 'oeDspTime', title: 'ʱ��', align: 'left', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'ResInfo',
            INCIL: incil,
            Hosp: HosId,
        },
        singleSelect: false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagResInfoBar',
    };
    PHA.Grid('gridResInfo', dataGridOption);
}

function ClearRes() {
    var gridChecked = $('#gridResInfo').datagrid('getChecked');
    var CheckedLen = gridChecked.length;
    if (CheckedLen == 0) {
        PHA.Popover({ showType: 'show', msg: '��ѡ����Ҫ�������;��ϸ', type: 'alert' });
        return;
    }
    var pointerStr = '',
        INCIL = '';
    for (var i = 0; i < CheckedLen; i++) {
        var pointer = gridChecked[i].pointer;
        INCIL = gridChecked[i].INCIL;
        pointerStr = pointerStr == '' ? pointer : pointerStr + '^' + pointer;
    }
    if (pointerStr == '') {
        PHA.Popover({ showType: 'show', msg: '�޿�ɾ������;��ϸ', type: 'alert' });
        return;
    }
    var ret = tkMakeServerCall('PHA.COM.Reserve', 'ClrReserveByPointerMulti', pointerStr);
    $('#gridResInfo').datagrid('query', {
        INCIL: INCIL,
        Hosp: HosId,
    });
}

function InitDetailOperate() {
    var menuId = 'detailMenu';
    var gridId = 'gridInclb';
    var OperateArr = ['BatchDirtyQty', 'BatchIntransInfo'];
    var OperateArrDesc = ['�鿴ռ�õ���', '����̨����Ϣ'];
    var OperateLen = OperateArr.length;
    var html =
        '<div id=' +
        menuId +
        ' class="hisui-menu" style=" display: none;">' +
        '<div id=' +
        menuId +
        '_export' +
        '>����</div>';
    for (i = 0; i < OperateLen; i++) {
        var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
    }
    html = html + '</div>';
    PHA.onRowContextMenu = function (e, rowIndex, rowData) {
        // �Ҽ�
        var Inclb = rowData.Inclb || '';
        if (Inclb == '') return;
        e.preventDefault(); //��ֹ����ð��
        if ($('#' + menuId).length > 0) {
            $('#' + menuId).remove();
        }
        $('body').append(html);
        $('#' + menuId).menu();
        $('#' + menuId).menu('show', {
            left: e.pageX,
            top: e.pageY,
        });
         $('#' + menuId + '_export').on('click', function () {
            PHA_COM.ExportGrid(gridId);
        });
        
        $('#BatchDirtyQty').on('click', function () {
            BatchDirtyQty(Inclb);
        });
        $('#BatchIntransInfo').on('click', function () {
            BatchIntransInfo(Inclb);
        });
    };
}


function InitDetailOperateNew(event,Inclb) {
    var menuId = 'detailMenu';
    var gridId = 'gridInclb';
    var OperateArr = ['BatchDirtyQty', 'BatchIntransInfo'];
    var OperateArrDesc = ['�鿴ռ�õ���', '����̨����Ϣ'];
    var OperateLen = OperateArr.length;
    var html = '<div id=' + menuId + ' class="hisui-menu" style=" display: none;">' ;
    for (i = 0; i < OperateLen; i++) {
        var html = html + '<div id=' + OperateArr[i] + '>' + OperateArrDesc[i] + '</div>';
    }
    html = html + '</div>';
    if ($('#' + menuId).length > 0) {
        $('#' + menuId).remove();
    }
    $('body').append(html);
    $('#' + menuId).menu();
    $('#' + menuId).menu('show', {
        left: event.pageX,
        top: event.pageY,
    });    
    $('#BatchDirtyQty').on('click', function () {
        BatchDirtyQty(Inclb);
    });
    $('#BatchIntransInfo').on('click', function () {
        BatchIntransInfo(Inclb);
    });
}

function BatchDirtyQty(Inclb) {
    var InciDesc = '';
    var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
    if (gridSelect) InciDesc = gridSelect.InciDesc;
    $('#BatchDirtyQtyInciDesc').text('ҩƷ����: ' + InciDesc);
    $('#diagBatchDirtyQty')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // rowid,trno,qty,uom,trdate
            { field: 'rowid', title: 'rowid', align: 'left', width: 200, hidden: true },
            {
                field: 'deleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 60,
                formatter: deleteFormatter,
            },
            { field: 'trno', title: 'ת�Ƶ���', align: 'left', width: 220 },
            { field: 'qty', title: 'ռ������', align: 'left', width: 100 },
            { field: 'uom', title: '��λ', align: 'left', width: 100 },
            { field: 'trdate', title: '��������', align: 'left', width: 150 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'BatchDirtyQty',
            INCLB: Inclb,
        },
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagBatchDirtyQtyBar',
    };
    PHA.Grid('gridBatchDirtyQty', dataGridOption);
}

function deleteFormatter(value, rowData, rowIndex) {
    var rowid = rowData.rowid;
    return (
        "<a href='#' onclick='DeleteIniti(\"" +
        rowid +
        "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>"
    );
}
function DeleteIniti(initi){
	PHA.Confirm('��ʾ', '�Ƿ�Ҫɾ����ת����ϸ��ռ������?', function () {
        $.cm(
            {
                ClassName: 'web.DHCST.DHCINIsTrfItm',
                MethodName: 'Delete',
                initi: initi,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: 'ɾ���ɹ�!', type: 'success' });
                    var gridSelect = $('#gridInclb').datagrid('getSelected') || '';
				    var Inclb = '';
				    if (gridSelect) Inclb = gridSelect.Inclb;
                    $('#gridBatchDirtyQty').datagrid('query', {
						INCLB: Inclb,
					});
                    queryInclb();
                } else{
	                if(retData=="-1"){
	                	PHA.Popover({ showType: 'show',  msg: $g("���ʧ��,���ⵥΪ���״̬!"),type: 'alert',});
					}else if(retData=="-2"){
						PHA.Popover({ showType: 'show',  msg: $g("���ʧ��,���ⵥΪ���״̬!"),type: 'alert',});
					}else if(retData=="-3"){
						PHA.Popover({ showType: 'show',  msg: $g("���ʧ��,���ⵥΪ���״̬!"),type: 'alert',});
					}else if(retData=="-4"){
						PHA.Popover({ showType: 'show',  msg: $g("���ʧ��,���ⵥΪ���״̬!"),type: 'alert',});
					}else{
						Msg.info("error", $g("���ʧ��,")+retData);
					}
                }
            }
        );
    });
}



function BatchIntransInfo(Inclb) {
    $('#BatchIntransInfoInclb').text(Inclb);
    $('#BatchIntransInfoStDate').datebox('setValue', 't');
    $('#BatchIntransInfoEdDate').datebox('setValue', 't');

    var InciDesc = '';
    var gridSelect = $('#gridIncil').datagrid('getSelected') || '';
    if (gridSelect) InciDesc = gridSelect.InciDesc;
    $('#BatchIntransInfoInciDesc').text('ҩƷ����: ' + InciDesc);
    $('#diagBatchIntransInfo')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [
            // rowid,trno,qty,uom,trdate
            { field: 'TrId', 		title: 'TrId', 				align: 'left', 	width: 200, hidden: true },
            { field: 'TrDate', 		title: '����', 				align: 'left', 	width: 180 },
            { field: 'TrMsg', 		title: 'ժҪ', 				align: 'left', 	width: 100 },
            { field: 'TrQtyUom', 	title: '����', 				align: 'right', width: 100 },
            { field: 'EndQtyUom', 	title: '��������', 			align: 'right', width: 100 },
            { field: 'PurUomRp', 	title: '����', 				align: 'right', width: 100 },
            { field: 'PurUomSp', 	title: '�ۼ�', 				align: 'right', width: 100 },
            { field: 'TrQtyUom', 	title: '����', 				align: 'right', width: 100 },
            { field: 'TrRpAmt', 	title: '���۽��', 			align: 'right', width: 100 },
            { field: 'TrSpAmt', 	title: '�ۼ۽��', 			align: 'right', width: 100 },
            { field: 'EndRpAmt', 	title: '������۽��', 		align: 'right', width: 100 },
            { field: 'EndSpAmt', 	title: '�����ۼ۽��', 		align: 'left', 	width: 100 },
            { field: 'TrNo', 		title: '�����', 			align: 'left', 	width: 150 },
            { field: 'TrAdm', 		title: '������ز���(��)', 	align: 'left', 	width: 150 },
            { field: 'OperateUser', title: '������', 			align: 'left', 	width: 150 },
            { field: 'TrMark', 		title: '��ע', 				align: 'left', 	width: 150 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocItmStk.Query',
            QueryName: 'BatchIntransInfo',
            INCLB: Inclb,
            StDate: $('#BatchIntransInfoStDate').datebox('getValue'),
            EdDate: $('#BatchIntransInfoEdDate').datebox('getValue'),
            HospId: HosId,
        },
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#diagBatchIntransInfoBar',
    };
    PHA.Grid('gridBatchIntransInfo', dataGridOption);
}

function queryBatchIntransInfo() {
    $('#gridBatchIntransInfo').datagrid('query', {
        INCIL: $('#BatchIntransInfoInclb').text(),
        StDate: $('#BatchIntransInfoStDate').datebox('getValue'),
        EdDate: $('#BatchIntransInfoEdDate').datebox('getValue'),
        HospId: HosId,
    });
}
