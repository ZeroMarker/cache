/*
 * FileName: dhchm/PE/STItemCatMap.js
 * Author: yupeng
 * Date: 2021-11-10
 * Description: 知识库维护-站点分类对照
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];

$(function(){
    Common_ComboToHospTags("cboHospTags");
    InitGridPESTItemCat();
    InitGridBTExamItemCat();
	$('#gridPESTItemCat').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	$('#gridBTExamItemCat').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	LoadGridPESTItemCat();
	LoadGridBTExamItemCat();
	
	$('#gridPESTItemCat_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPESTItemCat"),value,Public_gridsearch1);
		}
	});
	
	$('#gridBTExamItemCat_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridBTExamItemCat"),value,Public_gridsearch2);
		}
	});
	
	//知识库版本联动
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPESTItemCat();
	    }
    });
	
    //查询
    $("#btnFind").click(function() {  
        LoadGridPESTItemCat();
    });
    
    //对照
    $("#btnMapping").click(function() {  
        btnMapping_click();      
    });
})

//对照
function btnMapping_click(){
    var SICRowId=$("#gridPESTItemCat_ID").val();
    if(SICRowId==""){
        $.messager.alert("提示", "请选择医院分类！", "info");
        return false;
    }
    var EICRowId=$("#gridBTExamItemCat_ID").val();
    if(EICRowId==""){
        $.messager.alert("提示", "请选择标准分类！", "info");
        return false;
    }
    
    $.m({
           ClassName: "HM.PE.STItemCatMap",
           MethodName: "Mapping",
           aInputStr:SICRowId+"^"+EICRowId,
           aDelimiter:"^"
		}, function (rtn) {
			var rtnArr=rtn.split("^");
			if(rtnArr[0]=="-1"){    
				$.messager.alert('提示', '对照失败:'+ rtnArr[1], 'error');
			}else{
				$.messager.popover({msg:'对照成功',type:'success',timeout: 1000});
			}
     });
     LoadGridPESTItemCat();
}

function LoadGridPESTItemCat(){
	$cm ({
		ClassName:"HMS.PE.STItemCatMap",
        QueryName:"QuerySTItemCatMap",
        HospId:Common_GetValue("cboHospTags"),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPESTItemCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function LoadGridBTExamItemCat(){
	$cm ({
		ClassName:"HMS.BT.ExamItemCat",
		QueryName:"QueryExamItemCat",
		aActive:"1",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemCat').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPESTItemCat(){
    // 初始化DataGrid
    $('#gridPESTItemCat').datagrid({
		fit: true,
		//title: "医院站点项目分类列表",
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
            { field:'SICRowId', title:'SICRowId', hidden:true }
			//,{ field:'SICCode', width: 80, title:'分类代码', sortable: true, resizable: true}
			,{ field:'SICDesc', width: 150, title:'分类描述', sortable: true, resizable: true}
			,{ field:'SICType', width: 60, title:'类型', sortable: true, resizable: true}
			,{ field:'SICItemCat', width: 150, title:'标准分类', sortable: true, resizable: true}
			,{ field:'SICSort', width: 60, title:'顺序号', sortable: true, resizable: true}
			,{ field:'SICActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			,{ field: 'SICUpdateDate', width: 100, title: '更新日期' }
			,{ field: 'SICUpdateTime', width: 80, title: '更新时间' }
			,{ field: 'SICMappingDate', width: 100, title: '对照日期' }
			,{ field: 'SICMappingTime', width: 80, title: '对照时间'}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["SICRowId"];
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
			//Public_gridsearch1 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询
        }
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
			//,{ field:'EICCode', width: 100, title:'内部编码', sortable: true, resizable: true}
			,{ field:'EICDesc', width: 120, title:'分类描述', sortable: true, resizable: true}
			,{ field:'EICDesc2', width: 180, title:'别名', sortable: true, resizable: true}
			,{ field:'EICSort', width: 60, title:'顺序号', sortable: true, resizable: true}
			,{ field:'EICActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["EICRowId"];
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
			//Public_gridsearch2 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询
        }
    });
}