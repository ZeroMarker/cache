/*
 * FileName: dhchm/PE/DiseaseCode.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: 知识库维护-体检疾病维护
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEDiseaseCode();
	$('#gridPEDiseaseCode').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	
	$('#gridPEDiseaseCode_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEDiseaseCode"),value,Public_gridsearch1);
		}
	});
	
	//知识库版本联动
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEDiseaseCode();
	    }
    });
	
    //查询
    $("#btnFind").click(function() {
		LoadGridPEDiseaseCode();
    });
	
    //修改
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEDiseaseCode').datagrid('getSelected');
		winPEDiseaseCodeEdit_layer(rd);
    });
	
    //疾病关联专家建议
    $("#btnDiagnos").click(function() {
		var rd = $('#gridPEDiseaseCode').datagrid('getSelected');
		winPEDiseaseDiagnosView_layer(rd);
    });
	
	//弹出框-初始化
	InitWinPEDiseaseCodeEdit();
	
	//弹出框-关联专家建议
	InitWinPEDiseaseDiagnosView();
})

//弹出框-Open操作
function winPEDiseaseDiagnosView_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
	}else{
		Public_layer_ID = "";
	}
	LoadgridPEDiseaseDiagnos(Public_layer_ID);
	$HUI.dialog('#winPEDiseaseDiagnosView').open();
}

function InitWinPEDiseaseDiagnosView(){
	//初始化列表
	InitgridPEDiseaseDiagnos();
	//初始化编辑窗
	$('#winPEDiseaseDiagnosView').dialog({
		title: '体检疾病关联专家建议',
		iconCls:"icon-w-paper",
		width: 400,
		height: 400,
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEDiseaseDiagnosView').close();
			}
		}]
	});
}

function LoadgridPEDiseaseDiagnos(DiseaseDr){
	$cm ({
		ClassName:"HMS.PE.DiseaseSrv",
		QueryName:"QryDiseaseDiagnos",
		aDiseaseId:DiseaseDr,
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiseaseDiagnos').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitgridPEDiseaseDiagnos(){
    // 初始化DataGrid
    $('#gridPEDiseaseDiagnos').datagrid({
		fit: true,
		//title: "疾病关联专家建议",
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
			,{ field:'DiagnosDesc', width: 150, title:'专家建议', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'顺序号', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 70, title:'是否有效', sortable: true, resizable: true}
			//,{ field:'UpdateDate', width: 80, title:'更新日期', sortable: true, resizable: true}
			//,{ field:'UpdateTime', width: 60, title:'更新时间', sortable: true, resizable: true}
		]],
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
        }
    });
}

//弹出框-保存操作
function winPEDiseaseCodeEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Desc2 + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.DiseaseSrv",
		MethodName: "UpdateDiseaseCode",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '体检疾病保存失败', 'error');
		} else {
			$.messager.popover({msg:'体检疾病保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEDiseaseCodeEdit').close();
			LoadGridPEDiseaseCode();
		}
	})
}

//弹出框-Open操作
function winPEDiseaseCodeEdit_layer(rd){
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
	$HUI.dialog('#winPEDiseaseCodeEdit').open();
}

function InitWinPEDiseaseCodeEdit(){
	//初始化编辑窗
	$('#winPEDiseaseCodeEdit').dialog({
		title: '体检疾病编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEDiseaseCodeEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEDiseaseCodeEdit').close();
			}
		}]
	});
}

function LoadGridPEDiseaseCode(){
	$('#gridPEDiseaseCode').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"HMS.PE.DiseaseSrv",
		QueryName:"QryDiseaseCode",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiseaseCode').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEDiseaseCode(){
    // 初始化DataGrid
    $('#gridPEDiseaseCode').datagrid({
		fit: true,
		//title: "体检疾病列表",
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
			,{ field:'Code', width: 80, title:'疾病代码', sortable: true, resizable: true}
			,{ field:'Desc', width: 240, title:'疾病名称', sortable: true, resizable: true}
			,{ field:'Detail', width: 240, title:'疾病建议', sortable: true, resizable: true}
			,{ field:'Desc2', width: 100, title:'别名', sortable: true, resizable: true}
			,{ field:'Alias', width: 80, title:'首拼', sortable: true, resizable: true}
			,{ field:'IllnessDesc', width: 50, title:'是否<br>疾病', sortable: true, resizable: true}
			,{ field:'CommonIllDesc', width: 50, title:'是否<br>常见病', sortable: true, resizable: true}
			,{ field:'ToReportDesc', width: 50, title:'是否<br>上报', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'性别', sortable: true, resizable: true}
			,{ field:'TypeDesc', width: 100, title:'类型', sortable: true, resizable: true}
			,{ 
				field:'DiagnosFlag',
				width:60,
				align:'center',
				title:'关联专<br>家建议',
				formatter: function (value, rec, rowIndex) {
					if(value=="1"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
			,{ field:'Sort', width: 100, title:'顺序号', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 100, title:'更新日期', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'更新时间', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnDiagnos").linkbutton("disable");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					if (rowData["DiagnosFlag"] == '1'){
						$("#btnDiagnos").linkbutton("enable");
					} else {
						$("#btnDiagnos").linkbutton("disable");
					}
					$("#btnUpdate").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEDiseaseCodeEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询的bug
			$("#btnDiagnos").linkbutton("disable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}