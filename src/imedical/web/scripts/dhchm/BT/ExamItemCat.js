/*
 * FileName: dhchm/BT/ExamItemCat.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: 知识库维护-标准站点项目分类
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
    InitGridBTExamItemCat();
	$('#gridBTExamItemCat').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	LoadGridBTExamItemCat();
	
	$('#gridBTExamItemCat_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridBTExamItemCat"),value,Public_gridsearch1);
		}
	});
	
    //新增
    $("#btnAdd").click(function() {  
        winBTExamItemCatEdit_layer("");
    });
	
    //修改
    $("#btnUpdate").click(function() {
		var rd = $('#gridBTExamItemCat').datagrid('getSelected');
		winBTExamItemCatEdit_layer(rd);
    });
	
	//弹出框-初始化
	InitWinBTExamItemCatEdit();
})

//弹出框-保存操作
function winBTExamItemCatEdit_btnSave_click(){
	var ID = Public_layer_ID;
	var Code = Common_GetValue("txtCode");
    var Desc = Common_GetValue("txtDesc");
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Code + "^" + Desc + "^" + Desc2 + "^" + Sort + "^" + Active + "^" + session['LOGON.USERID'];
	$.m({
		ClassName: "HMS.BT.ExamItemCat",
		MethodName: "UpdateItemCat",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '站点项目分类保存失败', 'error');
		} else {
			$.messager.popover({msg:'站点项目分类保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winBTExamItemCatEdit').close();
			LoadGridBTExamItemCat();
		}
	})
}

//弹出框-Open操作
function winBTExamItemCatEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['EICRowId'];
		Common_SetValue('txtCode',rd['EICCode']);
		Common_SetValue('txtDesc',rd['EICDesc']);
		Common_SetValue('txtDesc2',rd['EICDesc2']);
		Common_SetValue('txtSort',rd['EICSort']);
		Common_SetValue('chkActive',(rd['EICActive']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winBTExamItemCatEdit').open();
}

function InitWinBTExamItemCatEdit(){
	//初始化编辑窗
	$('#winBTExamItemCatEdit').dialog({
		title: '站点项目分类编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winBTExamItemCatEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winBTExamItemCatEdit').close();
			}
		}]
	});
}

function LoadGridBTExamItemCat(){
	$cm ({
		ClassName:"HMS.BT.ExamItemCat",
		QueryName:"QueryExamItemCat",
		aActive:"",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridBTExamItemCat(){
    // 初始化DataGrid
    $('#gridBTExamItemCat').datagrid({
		fit: true,
		//title: "标准站点项目分类列表",
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
            { field:'EICRowId', title:'EICRowId', hidden:true }
			,{ field:'EICCode', width: 100, title:'内部编码', sortable: true, resizable: true}
			,{ field:'EICDesc', width: 150, title:'项目分类', sortable: true, resizable: true}
			,{ field:'EICDesc2', width: 200, title:'别名', sortable: true, resizable: true}
			,{ field:'EICSort', width: 80, title:'顺序号', sortable: true, resizable: true}
			,{ field:'EICActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			,{ field:'EICUpdateDate', width: 100, title:'更新日期', sortable: true, resizable: true}
			,{ field:'EICUpdateTime', width: 80, title:'更新时间', sortable: true, resizable: true}
			,{ field:'EICUpdateUser', width: 80, title:'更新人', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["EICRowId"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnAdd").linkbutton("enable");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnAdd").linkbutton("disable");
					$("#btnUpdate").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winBTExamItemCatEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = [];  //输入查询条件查询后，翻页，去掉查询条件，无法查询
			$("#btnAdd").linkbutton("enable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}