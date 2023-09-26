/**
 * 模块:     制剂信息维护
 * 编写日期: 2018-07-04
 * 编写人:   yunhaibao
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
    
    // 药品
    DHCST.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { placeholder: "药品..." }); // width: 315
     // 库存分类
    DHCST.ComboBox.Init({ Id: 'cmbStkCat', Type: 'StkCat' }, { placeholder: "库存分类..." });
	
}

function InitGridDrugInfo() {
    var columns = [
        [
        	{ field: "InciCode", title: '药品代码', width: 200, halign: 'center' },
            { field: "InciDesc", title: '药品名称', width: 250, halign: 'center' },
            { field: "Spec", title: '规格', width: 105, halign: 'center' },
            { field: "Manf", title: '厂商', width: 200, halign: 'center' },
            { field: "Sp", title: '售价', width: 100, halign: 'center' },
            { field: "Rp", title: '进价', width: 90, halign: 'center', align: 'center' },
            { field: "Uom", title: '单位', width: 70, halign: 'center' },
            { field: "Form", title: '剂型', width: 80, halign: 'center', align: 'right' },
            { field: "GenName", title: '通用名', width: 260, halign: 'center' },
            { field: "StkCat", title: '库存分类', width: 120, halign: 'center', align: 'center' },
            { field: "Inci", title: '库存id', width: 50, halign: 'center', hidden: true }
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

///查询
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
	var incId =$("#cmgIncItm").combobox("getValue"); // 药品
	var stkcat = $('#cmbStkCat').combobox("getValue"); // 分类
	var incAlias = $("#txtAlias").val().trim();
    var inmanu = "Y";
    
    var params = incId+"^"+stkcat+"^"+incAlias+"^"+inmanu
    return params
    
}

function InitGridRcpInfo() {
    var columns = [
        [
        	{ field: "InRec", title: 'Rowid', width: 50, halign: 'center', hidden: true },
        	{ field: "InrecDesc",title: '制剂名',width: 150,halign: 'center',align: 'right',hidden: true},
            { field: "QtyManuf", title: '数量', width: 80, halign: 'center'},
            { field: "UomId", title: '单位', width: 60, halign: 'center', hidden: true},
            { field: "Ratio", title: '成本加成系数', width: 60, halign: 'center',hidden: true}, 
            { field: "Uom", title: '单位', width: 100, halign: 'center'},
            { field: "Creator", title: '创始人', width: 60, halign: 'center' , hidden: true },
            { field: "UpdUser", title: '更新人', width: 60, halign: 'center', hidden: true  },
            { field: "CreatDate", title: '创始日期', width: 90, halign: 'center', align: 'center', hidden: true  },
            { field: "UpdDate", title: '更新日期', width: 70, halign: 'center' , hidden: true },
            { field: "Remark", title: '备注', width: 260, halign: 'center' },
			{ field: "ExpDate", title: '预计效期(月)', width: 80, halign: 'center' },
            { field: "AddCost", title: '默认附加费用', width: 80, halign: 'center' , align: 'center',hidden: true}
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
        	{ field: "InRinCode", title: '代码', width: 80, halign: 'center' },
            { field: "InRinInci", title: '库存名称', width: 250, halign: 'center',hidden: true},
            { field: "InRinDesc", title: '名称', width: 200,halign: 'center'},
            { field: "InRinQty", title: '数量', width: 80, halign: 'center' , align: 'center'},
            { field: "InRinUomId", title: '单位', width: 100, halign: 'center', align: 'center',hidden: true},
			{ field: "InRinUom", title: '单位', width: 200,halign: 'center'},
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
		$.messager.alert("提示", "请选择记录!", "warning");
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
//查询制剂
function FindInRecIngr(){
	var gridSelect = $('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
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
