/**
 * ģ��:     �Ƽ���Ϣά��
 * ��д����: 2018-07-04
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var inmanuurl="dhcst.inmanuorderaction.csp"
var GridCmgInc,GridCmgUom
$(function() {
    
	InitDict();
    InitGridDrugInfo();
     
    $('#btnFind').on("click", Query);
    InitGridRcpInfo();
    InitGridInrecIngr();
})


function InitDict() {
    
    // ҩƷ
    DHCST.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { placeholder: "ҩƷ..." }); // width: 315
     // ������
    DHCST.ComboBox.Init({ Id: 'cmbStkCat', Type: 'StkCat' }, { placeholder: "������..." });
	
}

function InitGridDrugInfo() {
    var columns = [
        [
        	{ field: "InciCode", title: 'ҩƷ����', width: 200, halign: 'center' },
            { field: "InciDesc", title: 'ҩƷ����', width: 250, halign: 'center' },
            { field: "Spec", title: '���', width: 105, halign: 'center' },
            { field: "Manf", title: '����', width: 200, halign: 'center' },
            { field: "Sp", title: '�ۼ�', width: 100, halign: 'center' },
            { field: "Rp", title: '����', width: 90, halign: 'center', align: 'center' },
            { field: "Uom", title: '��λ', width: 70, halign: 'center' },
            { field: "Form", title: '����', width: 80, halign: 'center', align: 'right' },
            { field: "GenName", title: 'ͨ����', width: 260, halign: 'center' },
            { field: "StkCat", title: '������', width: 120, halign: 'center', align: 'center' },
            { field: "Inci", title: '���id', width: 50, halign: 'center', hidden: true }
        ]
    ];
    var dataGridOption = {
        url:'', // inmanuurl + '?action=JsGetIncItm',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        onClickRow: function(rowIndex, rowData) {
            if(rowData){
	        	FindInRcp();
	        }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDrugInfo", dataGridOption);
}

///��ѯ
function Query() {
    var params = GetParams();
    $('#gridDrugInfo').datagrid("clear")
    $('#gridDrugInfo').datagrid({
	    url: inmanuurl + '?action=JsGetIncItm',
        queryParams: {
            params: params
        }
    });
}
function GetParams(){
	var incId =$("#cmgIncItm").combobox("getValue"); // ҩƷ
	var stkcat = $('#cmbStkCat').combobox("getValue"); // ����
	var incAlias = $("#txtAlias").val().trim();
    var inmanu = "Y";
    
    var params = incId+"^"+stkcat+"^"+incAlias+"^"+inmanu
    return params
    
}

function InitGridRcpInfo() {
    var columns = [
        [
        	{ field: "InRec", title: 'Rowid', width: 50, halign: 'center', hidden: true },
        	{ field: "InrecDesc",title: '�Ƽ���',width: 150,halign: 'center',align: 'right',hidden: true},
            { field: "QtyManuf", title: '����', width: 80, halign: 'center'},
            { field: "UomId", title: '��λ', width: 60, halign: 'center', hidden: true},
            { field: "Ratio", title: '�ɱ��ӳ�ϵ��', width: 60, halign: 'center',hidden: true}, 
            { field: "Uom", title: '��λ', width: 100, halign: 'center'},
            { field: "Creator", title: '��ʼ��', width: 60, halign: 'center' , hidden: true },
            { field: "UpdUser", title: '������', width: 60, halign: 'center', hidden: true  },
            { field: "CreatDate", title: '��ʼ����', width: 90, halign: 'center', align: 'center', hidden: true  },
            { field: "UpdDate", title: '��������', width: 70, halign: 'center' , hidden: true },
            { field: "Remark", title: '��ע', width: 260, halign: 'center' },
			{ field: "ExpDate", title: 'Ԥ��Ч��(��)', width: 80, halign: 'center' },
            { field: "AddCost", title: 'Ĭ�ϸ��ӷ���', width: 80, halign: 'center' , align: 'center',hidden: true}
        ]
    ];
    var dataGridOption = {
        url: '',           //inmanuurl + '?action=JsGetIncItm',
        toolbar: '#gridInRcpBar',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                FindInRecIngr()
            }
        },
        onLoadSuccess: function() {
	        var rows = $("#gridInRcp").datagrid("getRows").length; 
			if(rows>0){
				$('#gridInRcp').datagrid("selectRow",0);
				FindInRecIngr()
			}
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridInRcp", dataGridOption);
}

function InitGridInrecIngr() {
    var columns = [
        [		
        	{ field: "InRin", title: 'InRin', width: 50, halign: 'center', hidden: true },
        	{ field: "InRinCode", title: '����', width: 80, halign: 'center' },
            { field: "InRinInci", title: '�������', width: 250, halign: 'center',hidden: true},
            { field: "InRinDesc", title: '����', width: 200,halign: 'center'},
            { field: "InRinQty", title: '����', width: 80, halign: 'center' , align: 'center'},
            { field: "InRinUomId", title: '��λ', width: 100, halign: 'center', align: 'center',hidden: true},
			{ field: "InRinUom", title: '��λ', width: 200,halign: 'center'},
        ]
    ];
    var dataGridOption = {
        url: '',
        toolbar: '#gridInRecIngrBar',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200]
    };
    DHCPHA_HUI_COM.Grid.Init("gridInRecIngr", dataGridOption);
}
function FindInRcp(){
	var gridSelect = $('#gridDrugInfo').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	var Inci= gridSelect.Inci;
	$("#gridInRcp").datagrid("clear");
	$("#gridInRecIngr").datagrid("clear");
	$('#gridInRcp').datagrid({
	    url: inmanuurl + '?action=GetIncItmRcp',
        queryParams: {
            Params: Inci
        }
    });
}
//��ѯ�Ƽ�
function FindInRecIngr(){
	var gridSelect = $('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	$("#gridInRecIngr").datagrid("clear");
	var InRec= (gridSelect.InRec || "");
	$('#gridInRecIngr').datagrid({
	    url: inmanuurl + '?action=GetIncItmRecIngr',
        queryParams: {
            Params: InRec
        }
    });
}
