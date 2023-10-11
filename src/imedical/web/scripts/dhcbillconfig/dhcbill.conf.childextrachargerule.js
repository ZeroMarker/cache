/*
 * FileName:	dhcbill.conf.childextrachargerule.js
 * User:		tangzf
 * Date:		2020-07-27
 * Description: 儿童加收项规则维护
 */
var GV = {
	SELECTEDINDEX : -1,
	EDITINDEX : -1
};

$(function () {
	init_dg(); 	
});

/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'RuleDesc', title:'规则描述', width:150, editor: {
					type: 'text'}
			},
			{field:'RuleCode', title:'规则代码', width:150, editor: {
					type: 'text'}
			},
			{field:'ActStartDate', title:'有效开始日期', width:150,
				editor: {
					type: 'datebox'
				}
			},
			{field:'ActEndDate', title:'有效结束日期', width:150, editor: {
					type: 'datebox'}
			},
			{field:'AgeStart', title:'开始年龄', width:220, editor: {
					type: 'text'}
			},
			{field:'AgeEnd', title:'结束年龄', width:150, editor: {
					type: 'text'}
			},
			{field:'RowId', title:'规则ID', width:150},
			{field:'AgeUom', title:'规则单位', width:150, hidden:true}	
		]];

	//初始化DataGrid
	$('#dg').datagrid({
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		columns: dgColumns,
		toolbar: '#tToolBar',
		onLoadSuccess:function(data){
			GV.SELECTEDINDEX = -1;
			GV.EDITINDEX = -1;
		},
		onSelect:function(index,rowData){
			GV.SELECTEDINDEX = index;
		},
		onUnselect:function(index,rowData){
			GV.SELECTEDINDEX = -1;
		}
	});
}

/*
 * 加载数据 
 */ 
function initLoadGrid(){
    var queryParams = {
	    ClassName: 'BILL.CFG.COM.ChildExtraChargeRuleCom',
	    QueryName: 'QueryAll',
	    HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
	}	
    loadDataGridStore('dg',queryParams);
}

/*
 * 新增
 */
$('#BtnAdd').bind('click', function () {
	BeginEdit();
});

$('#BtnUpdate').bind('click', function () {
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('提示','请选择一条数据','info');
		return;		
	}
	
	if(GV.SELECTEDINDEX != GV.EDITINDEX && GV.EDITINDEX > -1 && GV.EDITINDEX !=-1){
		$.messager.alert('提示','一次只能修改一条数据','info');
		return;		
	}
	$('#dg').datagrid('beginEdit', GV.SELECTEDINDEX);
	GV.EDITINDEX = GV.SELECTEDINDEX;
});

function BeginEdit(){
	if(GV.SELECTEDINDEX > -1 && GV.EDITINDEX !=-1){
		$.messager.alert('提示','只能操作一条数据','info');
		return;		
	}
	if(GV.SELECTEDINDEX != GV.EDITINDEX && GV.EDITINDEX > -1 ){
		$.messager.alert('提示','一次只能修改一条数据','info');
		return;		
	}
	
	$('#dg').datagrid('insertRow',{
		index: 0,	// index start with 0
		row: {
			RuleDesc: '',
			RuleCode: '',
			ActStartDate: '',
			ActEndDate: '',
			AgeStart: '',
			AgeEnd: '',
			AgeUom: '',
			RowId: '',
		}
	});
	$('#dg').datagrid('beginEdit', 0);
	GV.SELECTEDINDEX = 0;
	GV.EDITINDEX = 0;
}

/*
 * save
 */
$('#BtnSave').bind('click', function () {
	if(GV.SELECTEDINDEX < 0){
		$.messager.alert('提示','请选择要保存的记录','info');
		return;
	}
	try{
		$('#dg').datagrid('acceptChanges');
		$('#dg').datagrid('selectRow', GV.EDITINDEX);
		var selRow = $('#dg').datagrid('getSelected');
		var reg = /^[0-9]*$/;
		if((!reg.test(selRow.AgeStart)) || (!reg.test(selRow.AgeEnd))){
			$.messager.alert('提示', '请输入有效值', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if(!selRow.RuleCode){
			$.messager.alert('提示', '规则代码不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if (!selRow.RuleDesc){
			$.messager.alert('提示', '规则描述不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if (!selRow.ActStartDate || (selRow.ActStartDate == '')){
			$.messager.alert('提示', '开始日期不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if ((!selRow.ActEndDate) || (selRow.ActEndDate == '')) {
			$.messager.alert('提示', '结束日期不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		var tmpStDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActStartDate);
		var tmpEndDate = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", selRow.ActEndDate);
		if (tmpStDate > tmpEndDate){
			$.messager.alert('提示', '开始日期不能大于结束日期','error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if ((selRow.AgeStart=='') || (selRow.AgeEnd=='')) {
			$.messager.alert('提示', '年龄不能为空', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		if (+selRow.AgeStart > +selRow.AgeEnd){
			$.messager.alert('提示', '开始年龄不能大于结束年龄', 'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		var inputStr = selRow.RowId + "^" + selRow.RuleCode + "^" + selRow.RuleDesc + "^" + selRow.ActStartDate + "^" + selRow.ActEndDate + "^" + selRow.AgeStart + "^" + selRow.AgeEnd + "^" + '' + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
		var rtn = tkMakeServerCall("BILL.CFG.COM.ChildExtraChargeRuleCom", "CheckData", inputStr);
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			$.messager.alert('提示', (myAry[1] || myAry[0]) ,'error');
			$('#dg').datagrid('beginEdit', GV.EDITINDEX);
			return;
		}
		var rtn = tkMakeServerCall("BILL.CFG.COM.ChildExtraChargeRuleCom", "Insert", inputStr);
		if(rtn != 0){
			$.messager.alert('提示', "保存失败" + rtn, 'error');
		}else{
			$.messager.alert('提示', "保存成功", 'info', function(){
				initLoadGrid();
			});
		}
	}catch(e){
	}
});

/*
 * 删除
 */
$('#BtnDelete').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.RowId != "") {
			$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
				if (r) {
					var inputStr = selected.RowId;
					var rtn=tkMakeServerCall("BILL.CFG.COM.ChildExtraChargeRuleCom", "Delete", inputStr);
					if(rtn != 0){
						$.messager.alert('提示', "删除失败" + rtn, 'error');
					}else{
						$.messager.alert('提示', "删除成功", 'info',function(){
							initLoadGrid();
						});
					}
				}
			});
		}
	} else {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
	}
});

/*
 * 查询
 */
$('#BtnFind').bind('click', function () {
	FindClick();
});

/*
 * 查询
 */
function FindClick() {
	initLoadGrid();
}

function selectHospCombHandle(){
	initLoadGrid();
}