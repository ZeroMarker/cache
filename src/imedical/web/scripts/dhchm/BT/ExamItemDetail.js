/*
 * FileName: dhchm/BT/ExamItemDetail.js
 * Author: zhufei
 * Date: 2021-11-30
 * Description: 知识库维护-标准站点细项
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];

$(function(){
    InitGridBTExamItemDetail();
	$('#gridBTExamItemDetail').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	LoadGridBTExamItemDetail();
	
	$('#gridBTExamItemDetail_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridBTExamItemDetail"),value,Public_gridsearch1);
		}
	});
	
    //新增
    $("#btnAdd").click(function() {  
        winBTExamItemDetailEdit_layer("");
    });
	
    //修改
    $("#btnUpdate").click(function() {
		var rd = $('#gridBTExamItemDetail').datagrid('getSelected');
		winBTExamItemDetailEdit_layer(rd);
    });
	
	//弹出框-初始化
	InitWinBTExamItemDetailEdit();
})

//弹出框-保存操作
function winBTExamItemDetailEdit_btnSave_click(){
	var ID = Public_layer_ID;
	var Code = Common_GetValue("txtCode");
    var Desc = Common_GetValue("txtDesc");
    var Desc2 = Common_GetValue("txtDesc2");
    var ItemCatID = Common_GetValue("cboItemCat");
    var BaseType = Common_GetValue("cboBaseType");
    var DataFormat = Common_GetValue("cboDataFormat");
    var Unit = Common_GetValue("txtUnit");
    var Sex = Common_GetValue("cboSex");
    var Express = Common_GetValue("txtExpress");
    var Explain = Common_GetValue("txtExplain");
    var Sort = Common_GetValue("txtSort");
    var Active = (Common_GetValue("chkActive") ? 1 : 0);
	var InputStr = ID + "^" + Code + "^" + Desc + "^" + Desc2 + "^" + ItemCatID + "^" + BaseType + "^" + DataFormat + "^" + Unit + "^" + Express + "^" + Explain + "^" + Sex + "^" + Sort + "^" + Active + "^" + session['LOGON.USERID'];
	
	$.m({
		ClassName: "HMS.BT.ExamItemDetail",
		MethodName: "UpdateItemDtl",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			$.messager.alert('提示', '站点细项保存失败', 'error');
		} else {
			$.messager.popover({msg:'站点细项保存成功',type:'success',timeout: 1000});
			$HUI.dialog('#winBTExamItemDetailEdit').close();
			LoadGridBTExamItemDetail();
		}
	})
}

//弹出框-Open操作
function winBTExamItemDetailEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('txtCode',rd['Code']);
		Common_SetValue('txtDesc',rd['Desc']);
		Common_SetValue('txtDesc2',rd['Desc2']);
		//Common_SetValue('cboItemCat',rd['ItemCatID'],rd['ItemCatDesc']);
		$("#cboItemCat").combobox('select',rd['ItemCatID']);
		//Common_SetValue('cboBaseType',rd['BaseType'],rd['BaseTypeDesc']);
		$("#cboBaseType").combobox('select',rd['BaseType']);
		//Common_SetValue('cboDataFormat',rd['DataFormat'],rd['DataFormatDesc']);
		$("#cboDataFormat").combobox('select',rd['DataFormat']);
		Common_SetValue('txtUnit',rd['Unit']);
		//Common_SetValue('cboSex',rd['Sex'],rd['SexDesc']);
		$("#cboSex").combobox('select',rd['Sex']);
		Common_SetValue('txtExpress',rd['Express']);
		Common_SetValue('txtExplain',rd['Explain']);
		Common_SetValue('txtSort',rd['Sort']);
		Common_SetValue('chkActive',(rd['Active']=='1'));
	}else{
		Public_layer_ID = "";
		Common_SetValue('txtCode','');
		Common_SetValue('txtDesc','');
		Common_SetValue('txtDesc2','');
		Common_SetValue('cboItemCat','','');
		Common_SetValue('cboBaseType','','');
		Common_SetValue('cboDataFormat','','');
		Common_SetValue('txtUnit','');
		Common_SetValue('cboSex','','');
		Common_SetValue('txtExpress','');
		Common_SetValue('txtExplain','');
		Common_SetValue('txtSort','');
		Common_SetValue('chkActive',0);
	}
	$HUI.dialog('#winBTExamItemDetailEdit').open();
}

function InitWinBTExamItemDetailEdit(){
	//初始化编辑窗
	$('#winBTExamItemDetailEdit').dialog({
		title: '站点细项编辑',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: '保存',
			handler:function(){
				winBTExamItemDetailEdit_btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winBTExamItemDetailEdit').close();
			}
		}]
	});
	//初始化表单控件（下拉框）
	Common_ComboToExamItemCat('cboItemCat');
	Common_ComboToBaseType('cboBaseType');
	Common_ComboToDataFormat('cboDataFormat')
	Common_ComboToSex('cboSex');
}

function LoadGridBTExamItemDetail(){
	$cm ({
		ClassName:"HMS.BT.ExamItemDetail",
		QueryName:"QryItemDtlEdit",
		aActive:"",
		page:1,
		rows:9999
	},function(rs){
		$('#gridBTExamItemDetail').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridBTExamItemDetail(){
    // 初始化DataGrid
    $('#gridBTExamItemDetail').datagrid({
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
			,{ field:'Code', width: 100, title:'内部编码', sortable: true, resizable: true}
			,{ field:'Desc', width: 200, title:'细项名称', sortable: true, resizable: true}
			,{ field:'Desc2', width: 200, title:'别名', sortable: true, resizable: true}
			,{ field:'ItemCatDesc', width: 100, title:'项目分类', sortable: true, resizable: true}
			,{ field:'BaseTypeDesc', width: 50, title:'基本<br>类型', sortable: true, resizable: true}
			,{ field:'DataFormatDesc', width: 60, title:'数据<br>格式', sortable: true, resizable: true}
			,{ field:'Unit', width: 80, title:'单位', sortable: true, resizable: true}
			,{ field:'SexDesc', width: 60, title:'性别', sortable: true, resizable: true}
			,{ field:'Express', width: 150, title:'计算公式', sortable: true, resizable: true}
			,{ field:'Explain', width: 150, title:'说明', sortable: true, resizable: true}
			,{ field:'Sort', width: 60, title:'顺序号', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:'是否<br>有效', sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 100, title:'更新日期', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'更新时间', sortable: true, resizable: true}
			,{ field:'UpdateUser', width: 80, title:'更新人', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
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
				winBTExamItemDetailEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			//Public_gridsearch1 = []; //输入查询条件查询后，翻页，去掉查询条件，无法查询的bug
			$("#btnAdd").linkbutton("enable");
			$("#btnUpdate").linkbutton("disable");
        }
    });
}

//创建站点项目分类下拉框
function Common_ComboToExamItemCat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'EICRowId',
		textField: 'EICDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'HMS.BT.ExamItemCat';
			param.QueryName = 'QueryExamItemCat';
			param.aActive = "1";
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				//$(this).combobox('select',data[0]['EICRowId']);
			}
		}
	});
	return  cbox;
}

//创建数据格式下拉框
function Common_ComboToDataFormat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: '说明型', Code: 'T' }
			,{ Desc: '数值型', Code: 'N' }
			,{ Desc: '计算型', Code: 'C' }
			,{ Desc: '选择型', Code: 'S' }
			,{ Desc: '多行文本', Code: 'A' }
		],
		defaultFilter:0
	});
	return  cbox;
}

//创建数据格式下拉框
function Common_ComboToBaseType(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: '检验', Code: 'L' }
			,{ Desc: '检查', Code: 'X' }
			,{ Desc: '药品', Code: 'R' }
			,{ Desc: '耗材', Code: 'M' }
			,{ Desc: '其他', Code: 'N' }
		],
		defaultFilter:0
	});
	return  cbox;
}

//创建数据格式下拉框
function Common_ComboToSex(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: '男', Code: 'M' }
			,{ Desc: '女', Code: 'F' }
			,{ Desc: '其他', Code: 'N' }
		],
		defaultFilter:0
	});
	return  cbox;
}