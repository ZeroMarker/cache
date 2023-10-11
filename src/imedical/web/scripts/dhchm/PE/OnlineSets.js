/*
 * FileName: OnlineSets.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: 知识库维护-体检预约套餐维护
 */
var Public_layer_ID = "";
var Public_layer_ID21 = "";
var Public_layer_ID22 = "";
var Public_layer_ID3 = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];
var Public_gridsearch3 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEOnlineSets();
    InitGridPEOnlineSetsItem();
    InitGridPEOnlineSetsItemDtl();
	$('#gridPEOnlineSets').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	$('#gridPEOnlineSetsItem').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	$('#gridPEOnlineSetsItemDtl').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	
	$('#gridPEOnlineSets_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEOnlineSets"),value,Public_gridsearch1);
		}
	});
	
	$('#gridPEOnlineSetsItem_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridPEOnlineSetsItem"),value,Public_gridsearch2);
		}
	});
	
	//知识库版本联动
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEOnlineSets();
	    }
    });
	
    //查询
    $("#btnFind").click(function() {
		LoadGridPEOnlineSets();
    });
	
    //修改
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEOnlineSets').datagrid('getSelected');
		winPEOnlineSetsEdit_layer(rd);
    });
	
    //修改
    $("#btnUpdate21").click(function() {
		var rd = $('#gridPEOnlineSetsItem').datagrid('getSelected');
		winPEOnlineSetsCatEdit_layer(rd);
    });
	
    //修改
    $("#btnUpdate22").click(function() {
		var rd = $('#gridPEOnlineSetsItem').datagrid('getSelected');
		winPEOnlineSetsItemEdit_layer(rd);
    });
	
    //修改
    $("#btnUpdate3").click(function() {
		var rd = $('#gridPEOnlineSetsItemDtl').datagrid('getSelected');
		winPEOnlineSetsItemDtlEdit_layer(rd);
    });
	
	//弹出框-初始化
	InitWinPEOnlineSetsEdit();
	
	//弹出框-初始化
	InitWinPEOnlineSetsCatEdit();
	
	//弹出框-初始化
	InitWinPEOnlineSetsItemEdit();
	
	//弹出框-初始化
	InitWinPEOnlineSetsItemDtlEdit();
})

//弹出框-保存操作
function winPEOnlineSetsEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSets",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '体检预约套餐保存失败', 'error');
		} else {
			$.messager.popover({msg:'体检预约套餐保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsEdit').close();
			LoadGridPEOnlineSets();
		}
	})
}

//弹出框-Open操作
function winPEOnlineSetsEdit_layer(rd){
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
	$HUI.dialog('#winPEOnlineSetsEdit').open();
}

function InitWinPEOnlineSetsEdit(){
	//初始化编辑窗
	$('#winPEOnlineSetsEdit').dialog({
		title: '体检预约套餐编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEOnlineSetsEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsEdit').close();
			}
		}]
	});
}

function LoadGridPEOnlineSets(){
	$('#gridPEOnlineSets').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"HMS.PE.OnlineSetsSrv",
		QueryName:"QryOnlineSets",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOnlineSets').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOnlineSets(){
    // 初始化DataGrid
    $('#gridPEOnlineSets').datagrid({
		fit: true,
		//title: "体检预约套餐列表",
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
			,{ field:'Desc', width: 150, title:'套餐名称', sortable: true, resizable: true}
			,{ field:'Price', width: 80, title:'套餐定价', sortable: true, resizable: true}
			,{ field:'GIFlagDesc', width: 50, title:'团体<br>标志', sortable: true, resizable: true}
			,{ field:'VIPLevel', width: 50, title:'VIP<br>等级', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'性别', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'顺序号', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			,{ field:'OrdSetsDesc', width: 150, title:'体检预约套餐', sortable: true, resizable: true}
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
				LoadGridPEOnlineSetsItem(); //加载体检预约套餐项目列表
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOnlineSetsEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch1 = [];
			$("#btnUpdate").linkbutton("disable");
			LoadGridPEOnlineSetsItem(); //加载体检预约套餐项目列表
        }
    });
}

//弹出框-保存操作
function winPEOnlineSetsCatEdit_btnSave_click(){
	var ID = Public_layer_ID21;
    var Sort = Common_GetValue("txtCatSort");
    var Active = (Common_GetValue("chkCatActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSetsCat",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '体检预约套餐项目分类保存失败', 'error');
		} else {
			$.messager.popover({msg:'体检预约套餐项目分类保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsCatEdit').close();
			LoadGridPEOnlineSetsItem();
		}
	})
}

//弹出框-Open操作
function winPEOnlineSetsCatEdit_layer(rd){
	if(rd){
		Public_layer_ID21 = rd['CatID'];
		Common_SetValue('txtCatDesc',rd['CatDesc']);
		Common_SetValue('txtCatSort',rd['CatSort']);
		Common_SetValue('chkCatActive',(rd['CatActive']=='1'));
	}else{
		Public_layer_ID21 = "";
		Common_SetValue('txtCatDesc','');
		Common_SetValue('txtCatSort','');
		Common_SetValue('chkCatActive',0);
	}
	$HUI.dialog('#winPEOnlineSetsCatEdit').open();
}

function InitWinPEOnlineSetsCatEdit(){
	//初始化编辑窗
	$('#winPEOnlineSetsCatEdit').dialog({
		title: '体检预约套餐项目分类编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEOnlineSetsCatEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsCatEdit').close();
			}
		}]
	});
}

//弹出框-保存操作
function winPEOnlineSetsItemEdit_btnSave_click(){
	var ID = Public_layer_ID22;
    var Sort = Common_GetValue("txtItemSort");
    var Active = (Common_GetValue("chkItemActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSetsItem",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '体检预约套餐项目保存失败', 'error');
		} else {
			$.messager.popover({msg:'体检预约套餐项目保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsItemEdit').close();
			LoadGridPEOnlineSetsItem();
		}
	})
}

//弹出框-Open操作
function winPEOnlineSetsItemEdit_layer(rd){
	if(rd){
		Public_layer_ID22 = rd['ID'];
		Common_SetValue('txtItemDesc',rd['ItemDesc']);
		Common_SetValue('txtItemSort',rd['ItemSort']);
		Common_SetValue('chkItemActive',(rd['ItemActive']=='1'));
	}else{
		Public_layer_ID22 = "";
		Common_SetValue('txtItemDesc','');
		Common_SetValue('txtItemSort','');
		Common_SetValue('chkItemActive',0);
	}
	$HUI.dialog('#winPEOnlineSetsItemEdit').open();
}

function InitWinPEOnlineSetsItemEdit(){
	//初始化编辑窗
	$('#winPEOnlineSetsItemEdit').dialog({
		title: '体检预约套餐项目编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEOnlineSetsItemEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsItemEdit').close();
			}
		}]
	});
}

function LoadGridPEOnlineSetsItem(){
	$('#gridPEOnlineSetsItem').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"HMS.PE.OnlineSetsSrv",
		QueryName:"QryOnlineSetsItem",
		aOrderSetsId: $('#gridPEOnlineSets_ID').val(),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOnlineSetsItem').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOnlineSetsItem(){
    // 初始化DataGrid
    $('#gridPEOnlineSetsItem').datagrid({
		fit: true,
		//title: "体检预约套餐项目列表",
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
			,{ field:'CatDesc', width: 100, title:'项目分类', sortable: true, resizable: true}
			,{ field:'ItemDesc', width: 150, title:'项目名称', sortable: true, resizable: true}
			,{ field:'SortDesc', width: 60, title:'顺序号', sortable: true, resizable: true}
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
					$("#btnUpdate21").linkbutton("disable");
					$("#btnUpdate22").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate21").linkbutton("enable");
					$("#btnUpdate22").linkbutton("enable");
				}
				LoadGridPEOnlineSetsItemDtl(); //加载体检预约套餐细项列表
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOnlineSetsItemEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch2 = [];
			$("#btnUpdate21").linkbutton("disable");
			$("#btnUpdate22").linkbutton("disable");
			LoadGridPEOnlineSetsItemDtl(); //加载体检预约套餐细项列表
        }
    });
}

//弹出框-保存操作
function winPEOnlineSetsItemDtlEdit_btnSave_click(){
	var ID = Public_layer_ID3;
    var Sort = Common_GetValue("txtItemDtlSort");
    var Active = (Common_GetValue("chkItemDtlActive") ? 1 : 0);
	var InputStr = ID + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.OnlineSetsSrv",
		MethodName: "UpdateOnlineSetsItemDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '体检预约套餐细项保存失败', 'error');
		} else {
			$.messager.popover({msg:'体检预约套餐细项保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEOnlineSetsItemDtlEdit').close();
			LoadGridPEOnlineSetsItemDtl();
		}
	})
}

//弹出框-Open操作
function winPEOnlineSetsItemDtlEdit_layer(rd){
	if(rd){
		Public_layer_ID3 = rd['ID'];
		Common_SetValue('txtItemDtlDesc',rd['Desc']);
		Common_SetValue('txtItemDtlSort',rd['Sort']);
		Common_SetValue('chkItemDtlActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID3 = "";
		Common_SetValue('txtItemDtlDesc','');
		Common_SetValue('txtItemDtlSort','');
		Common_SetValue('chkItemDtlActive',0);
	}
	$HUI.dialog('#winPEOnlineSetsItemDtlEdit').open();
}

function InitWinPEOnlineSetsItemDtlEdit(){
	//初始化编辑窗
	$('#winPEOnlineSetsItemDtlEdit').dialog({
		title: '体检预约套餐细项编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEOnlineSetsItemDtlEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEOnlineSetsItemDtlEdit').close();
			}
		}]
	});
}

function LoadGridPEOnlineSetsItemDtl(){
	$('#gridPEOnlineSetsItemDtl').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"HMS.PE.OnlineSetsSrv",
		QueryName:"QryOnlineSetsItemDtl",
		aOrderSetsItemId: $('#gridPEOnlineSetsItem_ID').val(),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEOnlineSetsItemDtl').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEOnlineSetsItemDtl(){
    // 初始化DataGrid
    $('#gridPEOnlineSetsItemDtl').datagrid({
		fit: true,
		//title: "体检预约套餐项目列表",
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
			,{ field:'Desc', width: 100, title:'细项名称', sortable: true, resizable: true}
			,{ field:'Intent', width: 80, title:'缩写', sortable: true, resizable: true}
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
					$("#btnUpdate3").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate3").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEOnlineSetsItemDtlEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch3 = [];
			$("#btnUpdate3").linkbutton("disable");
        }
    });
}
