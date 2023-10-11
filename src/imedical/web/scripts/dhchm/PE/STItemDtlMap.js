/*
 * FileName: dhchm/PE/STItemDtlMap.js
 * Author: zhufei
 * Date: 2021-11-10
 * Description: 知识库维护-站点细项对照功能页面
 */
var Public_FindType = "";
var Public_layer_ID = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];

$(function(){
	//$.parser.parse(); // 解析整个页面 
	Common_ComboToHospTags("cboHospTags");
	InitGridBTExamItemDetail();
    InitGridPESTItemDtlMap();
	$('#gridPESTItemDtlMap').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	$('#gridBTExamItemDetail').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	LoadGridBTExamItemDetail();
	
	$('#gridBTExamItemDetail_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridBTExamItemDetail"),value,Public_gridsearch1);
		}
	});
	
	$('#gridPESTItemDtlMap_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridPESTItemDtlMap"),value,Public_gridsearch2);
		}
	});
	
	//知识库版本联动
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			Public_FindType = "";
			LoadGridPESTItemDtlMap();
	    }
    });
	
    //全部
    $("#btnFindAll").click(function() {
		Public_FindType = "";
        LoadGridPESTItemDtlMap();
    });
	
    //未对照
    $("#btnFindNo").click(function() {
		Public_FindType = "N";
        LoadGridPESTItemDtlMap();
    });
	
    //已对照
    $("#btnFindYes").click(function() {
		Public_FindType = "Y";
        LoadGridPESTItemDtlMap();
    });
	
	//建议条件细项
    $("#btnFindExpAll").click(function() {
		Public_FindType = "E";
        LoadGridPESTItemDtlMap();
    });
	
	//建议条件细项
    $("#btnFindExpNo").click(function() {
		Public_FindType = "EN";
        LoadGridPESTItemDtlMap();
    });
	
	//建议条件细项
    $("#btnFindExpYes").click(function() {
		Public_FindType = "EY";
        LoadGridPESTItemDtlMap();
    });
	
    //细项对照
    $("#btnMapping").click(function() {
		btnMapping_click();
    });
	
    //撤销对照
    $("#btnCancel").click(function() {
		btnCancel_click();
    });
	
    //修改
    $("#btnEdit").click(function() {
		btnEdit_click();
    });
	
	//弹出框-初始化
	InitWinSTItemDtlEdit();
})

//弹出框-保存操作
function winSTItemDtlEdit_btnSave_click(){
	var ID = Public_layer_ID;
	var Code = Common_GetValue("txtCode");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Code + "^" + Sort + "^" + Active;
	$.m({
		ClassName: "HMS.PE.STItemDtlMap",
		MethodName: "UpdateItemDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<0) {
			$.messager.alert('提示', '站点细项修改保存失败', 'error');
		} else {
			$.messager.popover({msg:'站点细项修改保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winSTItemDtlEdit').close();
			LoadGridPESTItemDtlMap();
		}
	})
}

//弹出框-Open操作
function winSTItemDtlEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDesc',rd['Desc']);
		Common_SetValue('txtItemCat',rd['ItemCatDesc']);
		Common_SetValue('txtItemDtl',rd['ItemDtlDesc']);
		Common_SetValue('txtDataFormat',rd['DataFormat']);
		Common_SetValue('txtExpress',rd['Express']);
		Common_SetValue('txtUnit',rd['Unit']);
		Common_SetValue('txtExplain',rd['Explain']);
		Common_SetValue('txtSex',rd['SexDesc']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtItemCat','');
		Common_SetValue('txtItemDtl','');
		Common_SetValue('txtDataFormat','');
		Common_SetValue('txtExpress','');
		Common_SetValue('txtUnit','');
		Common_SetValue('txtExplain','');
		Common_SetValue('txtSex','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winSTItemDtlEdit').open();
}

function InitWinSTItemDtlEdit(){
	//初始化编辑窗
	$('#winSTItemDtlEdit').dialog({
		title: '站点细项编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winSTItemDtlEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winSTItemDtlEdit').close();
			}
		}]
	});
}

//修改操作
function btnEdit_click(){
	var rd = $('#gridPESTItemDtlMap').datagrid('getSelected');
	winSTItemDtlEdit_layer(rd);
}

//细项对照操作
function btnMapping_click(){
    var BTExamItemDtlID = Common_GetValue("gridBTExamItemDetail_ID");
    var PESTItemDtlID = Common_GetValue("gridPESTItemDtlMap_ID");
	if ((!PESTItemDtlID)||(!BTExamItemDtlID)){
		$.messager.alert('提示', "请选择对照细项", 'info');
        return;
	}
	var InputStr = PESTItemDtlID+"^"+BTExamItemDtlID;
	$.m({
		ClassName: "HM.PE.STItemDtlMap",
		MethodName: "Mapping",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<0) {
			$.messager.alert('提示', '细项对照失败', 'error');
		} else {
			$.messager.popover({msg:'细项对照成功',type:'success',timeout: 1000});
			LoadGridPESTItemDtlMap();
		}
	})
}

//撤销对照操作
function btnCancel_click(){
    var PESTItemDtlID = Common_GetValue("gridPESTItemDtlMap_ID");
	if (!PESTItemDtlID){
		$.messager.alert('提示', "请选择撤销对照记录", 'info');
        return;
	}
	
	$.messager.confirm("确认", "确定要撤销对照记录吗？", function(r){
		if (r){
			var InputStr = PESTItemDtlID+"^"+"";
			$.m({
				ClassName: "HM.PE.STItemDtlMap",
				MethodName: "Mapping",
				aInputStr:InputStr,
				aDelimiter:"^"
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					$.messager.alert('提示', '撤销对照失败', 'error');
				} else {
					$.messager.popover({msg:'撤销对照成功',type:'success',timeout: 1000});
					LoadGridPESTItemDtlMap();
				}
			})
		}
	})
}

function LoadGridPESTItemDtlMap(){
	$cm ({
		ClassName:"HMS.PE.STItemDtlMap",
		QueryName:"QrySTItemDtlMap",
		aHospTagID:Common_GetValue("cboHospTags"),
		aAlias:"",
		aIsMapping:Public_FindType,
		page:1,
		rows:9999
	},function(rs){
		$('#gridPESTItemDtlMap').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function LoadGridBTExamItemDetail(){
	$cm ({
		ClassName:"HMS.BT.ExamItemDetail",
		QueryName:"QryExamItemDtl",
		aAlias:"",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemDetail').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPESTItemDtlMap(){
    // 初始化DataGrid
    $('#gridPESTItemDtlMap').datagrid({
		fit: true,
		//title: "站点细项列表",
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
			//,{ field:'XCode', width: 80, title:'外部码', sortable: true, resizable: true }
			//,{ field:'Code', width: 80, title:'细项代码', sortable: true, resizable: true }
			,{ field:'Desc', width: 200, title:'细项名称', sortable: true, resizable: true }
			,{ field:'ItemCatDesc', width: 100, title:'项目分类', sortable: true, resizable: true }
			,{ field:'ItemDescStr', width: 200, title:'体检项目', sortable: true, resizable: true }
			,{ field:'ItemDtlDesc', width: 200, title:'标准细项', sortable: true, resizable: true }
			,{ field:'DataFormat', width: 50, title:'数据<br>格式', sortable: true, resizable: true }
			,{ field:'Unit', width: 70, title:'单位', sortable: true, resizable: true }
			,{ field:'Sex', width: 50, title:'性别', sortable: true, resizable: true }
			,{ field:'Sort', width: 60, title:'顺序号', sortable: true, resizable: true }
			,{ field:'ActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true }
			,{ field:'Express', width: 150, title:'表达式', sortable: true, resizable: true }
			,{ field:'Explain', width: 150, title:'说明', sortable: true, resizable: true }
			,{ field:'UpdateDate', width: 100, title:'更新日期', sortable: true, resizable: true }
			,{ field:'UpdateTime', width: 80, title:'更新时间', sortable: true, resizable: true }
			,{ field:'MappingDate', width: 100, title:'对照日期', sortable: true, resizable: true }
			,{ field:'MappingTime', width: 80, title:'对照时间', sortable: true, resizable: true }
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnEdit").linkbutton("disable");
					$("#btnMapping").linkbutton("disable");
					$("#btnCancel").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnEdit").linkbutton("enable");
					$("#btnMapping").linkbutton("enable");
					$("#btnCancel").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winSTItemDtlEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			$("#btnEdit").linkbutton("disable");
			$("#btnMapping").linkbutton("disable");
			$("#btnCancel").linkbutton("disable");
			//Public_gridsearch2 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询的bug
        }
    });
}

function InitGridBTExamItemDetail(){
    // 初始化DataGrid
    $('#gridBTExamItemDetail').datagrid({
		fit: true,
		//title: "标准站点细项列表",
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
			,{ field:'Code', width: 80, title:'细项代码', sortable: true, resizable: true }
			,{ field:'Desc', width: 200, title:'细项名称', sortable: true, resizable: true }
			,{ field:'ItemCatDesc', width: 100, title:'项目分类', sortable: true, resizable: true }
			,{ field:'DataFormat', width: 50, title:'数据<br>格式', sortable: true, resizable: true }
			,{ field:'Express', width: 200, title:'表达式', sortable: true, resizable: true }
			,{ field:'Unit', width: 80, title:'单位', sortable: true, resizable: true }
			,{ field:'Explain', width: 200, title:'说明', sortable: true, resizable: true }
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					
				}
			}
        },
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询的bug
        }
    });
}
