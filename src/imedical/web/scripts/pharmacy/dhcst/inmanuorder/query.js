/**
 * 模块:     制剂单据查询
 * 编写日期: 2018-07-04
 * 编写人:   zzd
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
    //DHCST.ComboBox.Init({ Id: 'cmbInci',Type: 'InRec' }, {placeholder: "制剂..."}); 
    DHCST.ComboGrid.Init({ Id: 'cmbInci', Type: 'IncItm' }, {}); // width: 315
	 DHCST.ComboBox.Init({Id: 'cmbStatus',data: {
        data: [
            { "RowId": "10", "Description": $g("保存") },
            //{ "RowId": "15", "Description": "完成" },
            { "RowId": "21", "Description": $g("已审核") }
        ]
    }}, {});
}
function InitGridManuOrd(){
	var columns = [
        [	
        	{ field: "InManuId", title: 'InManuId', width: 120, halign: 'center',hidden:'true' },
        	{ field: "InManuNo", title: '制剂单号', width: 150 },
            { field: "InManuDesc", title: '制剂名称', width: 250 },
            { field: "InManuTQty", title: '理论数量', width: 65},
            { field: "InManuFQty", title: '实际数量', width: 65 },
            { field: "InManuUomDesc", title: '单位', width: 80 },
            { field: "InManuBatNo", title: '批号', width: 120},
            { field: "InManuExpDate", title: '效期', width: 120},
            { field: "InManuAddCost", title: '附加费', width: 60 , halign: 'right', align: 'right' },
            { field: "InManuRp", title: '成本', width: 60, halign: 'right', align: 'right' },
            { field: "InManuRpAmt", title: '总金额', width: 60, halign: 'right', align: 'right' },
            { field: "CreatorUser", title: '建单人', width: 100 },
            { field: "InManuDate", title: '制剂日期', width: 120},
            { field: "InManuUser", title: '制剂人', width: 80},
            { field: "AuditDate", title: '审核日期', width: 120},
            { field: "AuditUser", title: '审核人', width: 120 },
            { field: "InManuSp", title: '售价', width: 100, halign: 'right', align: 'right' },
            { field: "InManuSpAmt", title: '售价金额', width: 100, halign: 'right', align: 'right'},
            { field: "Status", title: '状态', width: 60 }
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
        	{ field: "InciCode", title: '原料代码', width: 100 },
            { field: "InciDesc", title: '原料名称', width: 250},
            { field: "ExpDate", title: '效期', width: 100 },
            { field: "BatNo", title: '批号', width: 80},
            { field: "Uom", title: '单位', width: 60},
            { field: "Qty", title: '数量', width: 60 },
            { field: "StkQTy", title: '库存数量', width: 80},
            { field: "PurUom", title: '入库单位', width: 80 }
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
	var StartDate = $('#txtStartDate').datebox('getValue'); // 开始日期
	var EndDate = $('#txtEndDate').datebox('getValue'); // 结束日期
	var LocId = $('#cmbLoc').combobox("getValue"); // 制剂生产库
	var Status = $('#cmbStatus').combobox("getValue"); // 制剂状态
	var Inci = $('#cmbInci').combobox("getValue"); // 制剂
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
	var StartDate = $('#txtStartDate').datebox('getValue'); // 开始日期
	var EndDate = $('#txtEndDate').datebox('getValue'); // 结束日期
	var LocId = $('#cmbLoc').combobox("getValue"); // 制剂生产库
	var Status = $('#cmbStatus').combobox("getValue"); // 制剂状态
	var Inci = $('#cmbInci').combobox("getValue"); // 制剂
	var params=StartDate+"^"+EndDate+"^"+LocId+"^"+Status+"^"+Inci;
	$.cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:$g("制剂单列表"), 
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
		ExcelName:$g("制剂明细"), 
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
		$.messager.alert("提示", "正在查询打印中...!", "warning");
        return;
	}
	PrintFlag=1;
	setTimeout(function(){
		PrintFlag=0;
	},3000)
	var gridSelect=$('#gridInManuOrd').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	
	PintInaManu(InManu);
}
function GetDate(val){
	return tkMakeServerCall("web.DHCST.ManuOrder","DateChange",val);
}
