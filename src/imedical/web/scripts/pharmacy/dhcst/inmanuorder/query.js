/**
 * ģ��:     �Ƽ����ݲ�ѯ
 * ��д����: 2018-07-04
 * ��д��:   zzd
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var inmanuurl="dhcst.inmanuorderaction.csp"
var InManu="";
var PrintFlag=0;
$(function() {
   
	InitDict();
    InitGridManuOrd();
    InitGridManuOrdBat() ;
    $('#btnFind').on("click", SearchInManuOrd);
    $('#btnExpStat').on("click", ExportInManuOrd);
    $('#btnExpDetail').on("click", ExportInManuOrdBat);
    $('#btnPrint').on("click", PrintInManuOrd);

})
function InitDict(){
	 DHCST.ComboBox.Init({ Id: 'cmbLoc', Type: 'Loc' }, {
	    editable: false,
	    onLoadSuccess: function() {
	        var datas = $("#cmbLoc").combobox("getData");
	        for (var i = 0; i < datas.length; i++) {
	            if (datas[i].RowId == SessionLoc) {
	                $("#cmbLoc").combobox("setValue", datas[i].RowId);
	                break;
	            }
	        }
	    }
	});
	$("#txtStartDate").datebox("setValue",GetDate(-3));
    $("#txtEndDate").datebox("setValue", GetDate(0));
    //DHCST.ComboBox.Init({ Id: 'cmbInci',Type: 'InRec' }, {placeholder: "�Ƽ�..."}); 
    DHCST.ComboGrid.Init({ Id: 'cmbInci', Type: 'IncItm' }, {}); // width: 315
	 DHCST.ComboBox.Init({Id: 'cmbStatus',data: {
        data: [
            { "RowId": "10", "Description": $g("����") },
            //{ "RowId": "15", "Description": "���" },
            { "RowId": "21", "Description": $g("�����") }
        ]
    }}, {});
}
function InitGridManuOrd(){
	var columns = [
        [	
        	{ field: "InManuId", title: 'InManuId', width: 120, halign: 'center',hidden:'true' },
        	{ field: "InManuNo", title: '�Ƽ�����', width: 150 },
            { field: "InManuDesc", title: '�Ƽ�����', width: 250 },
            { field: "InManuTQty", title: '��������', width: 65},
            { field: "InManuFQty", title: 'ʵ������', width: 65 },
            { field: "InManuUomDesc", title: '��λ', width: 80 },
            { field: "InManuBatNo", title: '����', width: 120},
            { field: "InManuExpDate", title: 'Ч��', width: 120},
            { field: "InManuAddCost", title: '���ӷ�', width: 60 , halign: 'right', align: 'right' },
            { field: "InManuRp", title: '�ɱ�', width: 60, halign: 'right', align: 'right' },
            { field: "InManuRpAmt", title: '�ܽ��', width: 60, halign: 'right', align: 'right' },
            { field: "CreatorUser", title: '������', width: 100 },
            { field: "InManuDate", title: '�Ƽ�����', width: 120},
            { field: "InManuUser", title: '�Ƽ���', width: 80},
            { field: "AuditDate", title: '�������', width: 120},
            { field: "AuditUser", title: '�����', width: 120 },
            { field: "InManuSp", title: '�ۼ�', width: 100, halign: 'right', align: 'right' },
            { field: "InManuSpAmt", title: '�ۼ۽��', width: 100, halign: 'right', align: 'right'},
            { field: "Status", title: '״̬', width: 60 }
        ]
    ];
    var dataGridOption = {
        url:'', 
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: true,
        checkOnSelect: false,
        toolbar:'#gridInManuOrdBar',
        pageSize: 50,
        pageList: [50, 100, 200],
        onLoadSuccess: function() {
            
        },
        
        onClickRow: function(rowIndex, rowData) {
	        InManu=rowData.InManuId
	        SearchInManuOrdBat()
	    },
        onClickCell: function(rowIndex, field, value) {
           
        },
        onCheck: function(rowIndex, rowData) {
            
        },
        onUncheck: function(rowIndex, rowData) {
            
        },
        onSelect: function(rowIndex, rowData) {
	        
            
        },
        onUnselect: function(rowIndex, rowData) {
            
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridInManuOrd", dataGridOption);
	
}
function InitGridManuOrdBat() {
    var columns = [
        [	
        	{ field: "Inclb", title: 'Inclb', width: 200, halign: 'center',hidden:'true' },
        	{ field: "InciCode", title: 'ԭ�ϴ���', width: 100 },
            { field: "InciDesc", title: 'ԭ������', width: 250},
            { field: "ExpDate", title: 'Ч��', width: 100 },
            { field: "BatNo", title: '����', width: 80},
            { field: "Uom", title: '��λ', width: 60},
            { field: "Qty", title: '����', width: 60 },
            { field: "StkQTy", title: '�������', width: 80},
            { field: "PurUom", title: '��ⵥλ', width: 80 }
        ]
    ];
    var dataGridOption = {
        url:'', // inmanuurl + '?action=JsGetIncItm',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: true,
        pageSize: 50,
        toolbar:[],
        pageList: [50, 100, 200]
    };
    DHCPHA_HUI_COM.Grid.Init("gridInManuOrdBat", dataGridOption);
}
function SearchInManuOrd(){
	$('#gridInManuOrd').datagrid("clear");
	InManu=""
	var StartDate = $('#txtStartDate').datebox('getValue'); // ��ʼ����
	var EndDate = $('#txtEndDate').datebox('getValue'); // ��������
	var LocId = $('#cmbLoc').combobox("getValue"); // �Ƽ�������
	var Status = $('#cmbStatus').combobox("getValue"); // �Ƽ�״̬
	var Inci = $('#cmbInci').combobox("getValue"); // �Ƽ�
	var params=StartDate+"^"+EndDate+"^"+LocId+"^"+Status+"^"+Inci;
	$('#gridInManuOrd').datagrid({
	    url: inmanuurl + '?action=GetManuOrdList',
        queryParams: {
            Params: params
        }
    });
}
function SearchInManuOrdBat(){
	$('#gridInManuOrdBat').datagrid("clear");
	var params=InManu
	$('#gridInManuOrdBat').datagrid({
	    url: inmanuurl + '?action=GetManuOrdBat',
        queryParams: {
            Params: params
        }
    });
}
function ExportInManuOrd(){
	var StartDate = $('#txtStartDate').datebox('getValue'); // ��ʼ����
	var EndDate = $('#txtEndDate').datebox('getValue'); // ��������
	var LocId = $('#cmbLoc').combobox("getValue"); // �Ƽ�������
	var Status = $('#cmbStatus').combobox("getValue"); // �Ƽ�״̬
	var Inci = $('#cmbInci').combobox("getValue"); // �Ƽ�
	var params=StartDate+"^"+EndDate+"^"+LocId+"^"+Status+"^"+Inci;
	$.cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:$g("�Ƽ����б�"), 
		ClassName:"web.DHCST.ManuOrder",
		QueryName:"ExportInManuList",
		Params:params
	},function( rtn){
		location.href = rtn;
	});	
	
}
function ExportInManuOrdBat(){
	var params=InManu
	$.cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:$g("�Ƽ���ϸ"), 
		ClassName:"web.DHCST.ManuOrder",
		QueryName:"ExportInManuDetail",
		InManu:params
	},function( rtn){
		location.href = rtn;
	});	

}
function PrintInManuOrd()
{
	if(PrintFlag==1){
		$.messager.alert("��ʾ", "���ڲ�ѯ��ӡ��...!", "warning");
        return;
	}
	PrintFlag=1;
	setTimeout(function(){
		PrintFlag=0;
	},3000)
	var gridSelect=$('#gridInManuOrd').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("��ʾ", "��ѡ���¼!", "warning");
        return;
	}
	
	PintInaManu(InManu);
}
function GetDate(val){
	return tkMakeServerCall("web.DHCST.ManuOrder","DateChange",val);
}
