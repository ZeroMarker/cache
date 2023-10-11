/*
 * FileName: dhchm/PE/DiagnosCode.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: 知识库维护-专家建议维护
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
	Common_ComboToHospTags('cboHospTags');
    InitGridPEDiagnosCode();
	$('#gridPEDiagnosCode').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	
	$('#gridPEDiagnosCode_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridPEDiagnosCode"),value,Public_gridsearch1);
		}
	});
	
	//知识库版本联动
	$HUI.combobox('#cboHospTags',{
	    onSelect:function(row){
			LoadGridPEDiagnosCode();
	    }
    });
	
    //查询
    $("#btnFind").click(function() {
		LoadGridPEDiagnosCode();
    });
	
    //修改
    $("#btnUpdate").click(function() {
		var rd = $('#gridPEDiagnosCode').datagrid('getSelected');
		winPEDiagnosCodeEdit_layer(rd);
    });
	
    //表达式
    $("#btnExpress").click(function() {
		var rd = $('#gridPEDiagnosCode').datagrid('getSelected');
		winPEDiagnosExpressView_layer(rd);
    });
	
	//弹出框-初始化
	InitWinPEDiagnosCodeEdit();
	
	//弹出框-表达式
	InitWinPEDiagnosExpressView();
})

//弹出框-Open操作
function winPEDiagnosExpressView_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
	}else{
		Public_layer_ID = "";
	}
	LoadgridPEDiagnosExpress(Public_layer_ID);
	$HUI.dialog('#winPEDiagnosExpressView').open();
}

function InitWinPEDiagnosExpressView(){
	//初始化列表
	InitgridPEDiagnosExpress();
	//初始化编辑窗
	$('#winPEDiagnosExpressView').dialog({
		title: '专家建议表达式',
		iconCls:"icon-w-paper",
		width: 800,
		height: 500,
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEDiagnosExpressView').close();
			}
		}]
	});
}

function LoadgridPEDiagnosExpress(DiagnosDr){
	$cm ({
		ClassName:"HMS.PE.DiagnosSrv",
		QueryName:"QryDiagnosExpress",
		aDiagnosId:DiagnosDr,
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiagnosExpress').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitgridPEDiagnosExpress(){
    // 初始化DataGrid
    $('#gridPEDiagnosExpress').datagrid({
		fit: true,
		//title: "专家建议表达式列表",
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
			,{ field:'PreBracket', width: 40, title:'前置<br>括号', sortable: true, resizable: true}
			,{ field:'ItemDtlDesc', width: 80, title:'站点细项', sortable: true, resizable: true}
			,{ field:'Operator', width: 40, title:'操作<br>符', sortable: true, resizable: true}
			,{ field:'Reference', width: 80, title:'比较值', sortable: true, resizable: true}
			,{ field:'AfterBracket', width: 40, title:'后置<br>括号', sortable: true, resizable: true}
			,{ field:'Relation', width: 40, title:'逻辑<br>关系', sortable: true, resizable: true}
			,{ field:'AgeRange', width: 50, title:'年龄<br>限定', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'性别', sortable: true, resizable: true}
			,{ field:'NoBloodDesc', width: 60, title:'非血<br>标志', sortable: true, resizable: true}
			,{ field:'Sort', width: 50, title:'顺序号', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			//,{ field:'UpdateDate', width: 80, title:'更新日期', sortable: true, resizable: true}
			//,{ field:'UpdateTime', width: 60, title:'更新时间', sortable: true, resizable: true}
		]],
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
        }
    });
}

//弹出框-保存操作
function winPEDiagnosCodeEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var Desc2 = Common_GetValue("txtDesc2");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Desc2 + "^" + Sort + "^" + Active
	
	$.m({
		ClassName: "HMS.PE.DiagnosSrv",
		MethodName: "UpdateDiagnosCode",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '专家建议保存失败', 'error');
		} else {
			$.messager.popover({msg:'专家建议保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winPEDiagnosCodeEdit').close();
			LoadGridPEDiagnosCode();
		}
	})
}

//弹出框-Open操作
function winPEDiagnosCodeEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDiagnos',rd['Diagnos']);
		Common_SetValue('txtDesc2',rd['Desc2']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDiagnos','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winPEDiagnosCodeEdit').open();
}

function InitWinPEDiagnosCodeEdit(){
	//初始化编辑窗
	$('#winPEDiagnosCodeEdit').dialog({
		title: '专家建议编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winPEDiagnosCodeEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winPEDiagnosCodeEdit').close();
			}
		}]
	});
}

function LoadGridPEDiagnosCode(){
	$('#gridPEDiagnosCode').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"HMS.PE.DiagnosSrv",
		QueryName:"QryDiagnosCode",
		aHospTagId:Common_GetValue('cboHospTags'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridPEDiagnosCode').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridPEDiagnosCode(){
    // 初始化DataGrid
    $('#gridPEDiagnosCode').datagrid({
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
            { field:'ID', title:'ID', hidden:true }
			,{ field:'Code', width: 80, title:'结论代码', sortable: true, resizable: true}
			,{ field:'Diagnos', width: 180, title:'主检结论', sortable: true, resizable: true}
			,{ field:'Advice', width: 240, title:'专家建议', sortable: true, resizable: true}
			,{ field:'ItemCatDesc', width: 150, title:'项目分类', sortable: true, resizable: true}
			,{ field:'Desc2', width: 100, title:'别名', sortable: true, resizable: true}
			,{ field:'Alias', width: 80, title:'首拼', sortable: true, resizable: true}
			,{ field:'IllnessDesc', width: 50, title:'是否<br>疾病', sortable: true, resizable: true}
			,{ field:'CommonIllDesc', width: 50, title:'是否<br>常见病', sortable: true, resizable: true}
			,{ field:'HighRiskDesc', width: 50, title:'高危', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 50, title:'性别', sortable: true, resizable: true}
			,{ field:'HBVDesc', width: 50, title:'乙肝', sortable: true, resizable: true}
			,{ field:'ClassDesc', width: 70, title:'建议级别', sortable: true, resizable: true}
			,{ 
				field:'ExpressFlag',
				width:60,
				align:'center',
				title:'表达式',
				formatter: function (value, rec, rowIndex) {
					if(value=="1"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}
			,{ field:'Sort', width: 60, title:'顺序号', sortable: true, resizable: true}
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
					$("#btnExpress").linkbutton("disable");
					$("#btnUpdate").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					if (rowData["ExpressFlag"] == '1'){
						$("#btnExpress").linkbutton("enable");
					} else {
						$("#btnExpress").linkbutton("disable");
					}
					$("#btnUpdate").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winPEDiagnosCodeEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询的bug
			$("#btnExpress").linkbutton("disable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}