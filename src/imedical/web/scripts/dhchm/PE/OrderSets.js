/*
 * FileName: dhchm/PE/OrderSets.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: 知识库维护-体检套餐维护
 */
var Public_layer_ID = "";
var Public_layer_ID2 = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEOrderSets();
    InitGridPEOrderSetsDtl();
	$('#gridPEOrderSets').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	$('#gridPEOrderSetsDtl').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	
	$('#gridPEOrderSets_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEOrderSets"),value,Public_gridsearch1);
		}
	});
	
	$('#gridPEOrderSetsDtl_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridPEOrderSetsDtl"),value,Public_gridsearch2);
		}
	});
	
	//知识库版本联动
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEOrderSets();
	    }
    });
	
    //查询
    $("#btnFind").click(function() {
		LoadGridPEOrderSets();
    });
	
    //修改
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEOrderSets').datagrid('getSelected');
		winPEOrderSetsEdit_layer(rd);
    });
	
    //修改
    $("#btnUpdate2").click(function() {
		var rd = $('#gridPEOrderSetsDtl').datagrid('getSelected');
		winPEOrderSetsDtlEdit_layer(rd);
    });
	
	//弹出框-初始化
	InitWinPEOrderSetsEdit();
	
	//弹出框-初始化
	InitWinPEOrderSetsDtlEdit();
})

//弹出框-保存操作
function winPEOrderSetsEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Desc2 + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OrderSetsSrv",
		MethodName: "UpdateOrderSets",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '体检套餐保存失败', 'error');
		} else {
			$.messager.popover({msg:'体检套餐保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOrderSetsEdit').close();
			LoadGridPEOrderSets();
		}
	})
}

//弹出框-Open操作
function winPEOrderSetsEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDesc',rd['Desc']);
		Common_SetValue('txtDesc2',rd['Desc2']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winPEOrderSetsEdit').open();
}

function InitWinPEOrderSetsEdit(){
	//初始化编辑窗
	$('#winPEOrderSetsEdit').dialog({
		title: '体检套餐编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEOrderSetsEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEOrderSetsEdit').close();
			}
		}]
	});
}

function LoadGridPEOrderSets(){
	$('#gridPEOrderSets').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"HMS.PE.OrderSetsSrv",
		QueryName:"QryOrderSets",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOrderSets').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOrderSets(){
    // 初始化DataGrid
    $('#gridPEOrderSets').datagrid({
		fit: true,
		//title: "体检套餐列表",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //如果为false，超过最大宽度显示横向滚动条
        columns: [[
            { field:'ID', title:'ID', hidden:true }
			//,{ field:'Code', width: 80, title:'套餐编码', sortable: true, resizable: true}
			,{ field:'Desc', width: 180, title:'套餐名称', sortable: true, resizable: true}
			,{ field:'Desc2', width: 100, title:'别名', sortable: true, resizable: true}
			,{ field:'Price', width: 80, title:'套餐定价', sortable: true, resizable: true}
			,{ field:'VIPLevel', width: 70, title:'VIP等级', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'性别', sortable: true, resizable: true}
			,{ field:'DeitDesc', width: 50, title:'是否有<br>早餐', sortable: true, resizable: true}
			,{ field:'BreakDesc', width: 50, title:'是否<br>拆分', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'顺序号', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			,{ field:'DateBegin', width: 90, title:'有效开<br>始日期', sortable: true, resizable: true}
			,{ field:'DateEnd', width: 90, title:'有效截<br>止日期', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 90, title:'更新日期', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'更新时间', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate").linkbutton("enable");
				}
				LoadGridPEOrderSetsDtl(); //加载体检套餐项目列表
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOrderSetsEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询
			$("#btnUpdate").linkbutton("disable");
			LoadGridPEOrderSetsDtl(); //加载体检套餐项目列表
        }
    });
}

//弹出框-保存操作
function winPEOrderSetsDtlEdit_btnSave_click(){
	var ID = Public_layer_ID2;
    var Sort = Common_GetValue("txtDtlSort");
    var Active = (Common_GetValue("chkDtlActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OrderSetsSrv",
		MethodName: "UpdateOrderSetsDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '体检套餐项目保存失败', 'error');
		} else {
			$.messager.popover({msg:'体检套餐项目保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOrderSetsDtlEdit').close();
			LoadGridPEOrderSetsDtl();
		}
	})
}

//弹出框-Open操作
function winPEOrderSetsDtlEdit_layer(rd){
	if(rd){
		Public_layer_ID2 = rd['ID'];
		Common_SetValue('txtDtlItemDesc',rd['ItemDesc']);
		Common_SetValue('txtDtlItemCatDesc',rd['ItemCatDesc']);
		Common_SetValue('txtDtlSort',rd['Sort']);
		Common_SetValue('chkDtlActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID2 = "";
		Common_SetValue('txtDtlItemCatDesc','');
		Common_SetValue('txtDtlItemDesc','');
		Common_SetValue('txtDtlSort','');
		Common_SetValue('chkDtlActive',0);
	}
	$HUI.dialog('#winPEOrderSetsDtlEdit').open();
}

function InitWinPEOrderSetsDtlEdit(){
	//初始化编辑窗
	$('#winPEOrderSetsDtlEdit').dialog({
		title: '体检套餐项目编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEOrderSetsDtlEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEOrderSetsDtlEdit').close();
			}
		}]
	});
}

function LoadGridPEOrderSetsDtl(){
	$('#gridPEOrderSetsDtl').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"HMS.PE.OrderSetsSrv",
		QueryName:"QryOrderSetsDtl",
		aOrderSetsId: $('#gridPEOrderSets_ID').val(),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOrderSetsDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOrderSetsDtl(){
    // 初始化DataGrid
    $('#gridPEOrderSetsDtl').datagrid({
		fit: true,
		//title: "体检套餐项目列表",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //如果为false，超过最大宽度显示横向滚动条
        columns: [[
            { field:'ID', title:'ID', hidden:true }
			,{ field:'ItemDesc', width: 180, title:'体检项目', sortable: true, resizable: true}
			,{ field:'ItemCatDesc', width: 150, title:'项目分类', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'顺序号', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 90, title:'更新日期', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'更新时间', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnUpdate2").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate2").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOrderSetsDtlEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch2 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询
			$("#btnUpdate2").linkbutton("disable");
        }
    });
}