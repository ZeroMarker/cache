/*
Creator: Liu XiaoMing
CreatDate: 2018-09-06
Description: 全面预算管理-基本信息维护-审批流
CSPName: herp.budg.hisui.budgcheckflowain.csp
ClassName: herp.budg.hisui.udata.uBudgCheckFlow,
herp.budg.hisui.udata.uBudgCheckFlowMain,
herp.budg.hisui.udata.uBudgCheckFlowDetail,
 */

var startIndex = undefined;
//判断是否结束编辑
function endEditing(grid,startIndex) {

	if (startIndex == undefined) {
		return true
	}
	if (grid.datagrid('validateRow', startIndex)) {
		grid.datagrid('endEdit', startIndex);
		startIndex = undefined;
		return true;
	} else {
		return false;
	}
}

//新增行
function appendRow(grid,obj,startIndex) {

		if (endEditing(grid,startIndex)) {
			grid.datagrid('appendRow', obj);
			startIndex = grid.datagrid('getRows').length - 1;
			grid.datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);

		}
}

var westColumn = [[{
			field: 'rowid',
			title: 'ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'compNa',
			title: '医疗单位',
			halign: 'center',
			hidden: true
		}, {
			field: 'code',
			title: '编码',
			halign: 'center',
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			field: 'name',
			title: '名称',
			halign: 'center',
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			field: 'sysno',
			title: '适用模块',
			halign: 'center',
			allowBlank: false,
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					required: true,
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '项目支出'
						}, {
							rowid: '2',
							name: '预算编制'
						},{
							rowid: '3',
							name: '一般支出'
						}, {
							rowid: '4',
							name: '项目编制'
						}
					]
				}
			}
		}
	]]

//增加按钮
var AddBtn = {
	id: 'Add',
	iconCls: 'icon-add',
	text: '新增',
	handler: function () {
		appendRow($('#WestGrid'),{
				rowid: '',
				compNa: '',
				code: '',
				name: '',
				sysno: ''
			},startIndex) 
	}
}

//保存按钮
var SaveBtn = {
	id: 'Save',
	iconCls: 'icon-save',
	text: '保存',
	handler: function () {
		Save();
	}
}

//删除按钮
var DelBtn = {
	id: 'Del',
	iconCls: 'icon-cancel',
	text: '删除',
	handler: function () {
		Del();
	}
}

var westGridObj = $HUI.datagrid('#WestGrid', {
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
			MethodName: 'List',
			groupid:groupid,
			hospid: hospid,
			userid: userid
		},
		columns: westColumn,
		fitColumns:true,
		singleSelect:true,
		rownumbers: true, //行号
		pagination: true, //分页
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100],
		toolbar: [AddBtn, SaveBtn, DelBtn],  //AutoAddBtn, 
		onClickRow: ClickRow,
	});


	
	
var stepNocbObj=$HUI.combobox('#stepNocb',{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgCheckFlow&MethodName=StepNO",
        mode:'remote',
        valueField:'rowid',    
        textField:'rowid',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid,
            param.userid = userid
        }
	
	});	
	
var usercbObj=$HUI.combobox('#usercb',{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgCheckFlow&MethodName=UserName",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid,
            param.userid = userid
        }
	
	});	

var deptcbObj=$HUI.combobox('#deptcb',{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid,
            param.userdr = userid,
            param.flag = '1^',
            param.year = '',
            param.audept = '',
            param.schemedr = ''
            
        }
	
	});	
	
//科室预算方案明细查询
function SearchDetail(mainId) {
	
		$('#CenterGrid').datagrid('load', {
			ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
			MethodName: 'ListDetail',
			hospid: hospid,
			userid: userid,
			checkmainid: mainId, 
			stepno:$('#stepNocb').combobox('getValue'),
			usernameDr:$('#usercb').combobox('getValue'), 
			deptname:$('#deptcb').combobox('getValue') 
		});
}

$('#findBtn').bind('click',function(){
	var rowData=$('#WestGrid').datagrid('getSelected');
	if(rowData!=null){
		mainId=rowData.rowid;
	}else{
		mainId='';
	}
	SearchDetail(mainId);
});
		
/*//增加按钮
var AddBtnCen = {
	id: 'AddBtnCen',
	iconCls: 'icon-add',
	text: '新增',
	handler: function () {
		appendRow($('#CenterGrid'),{
				rowid: '',
				checkmainid: '',
				deptid: '',
				stepno: '',
				procdesc: '',
				chkerid:'',
				isdirect:''
			},startIndex) 
		
	}
}

//保存按钮
var SaveBtnCen = {
	id: 'SaveBtnCen',
	iconCls: 'icon-save',
	text: '保存',
	handler: function () {
		SaveCen();
	}
}

//删除按钮
var DelBtnCen = {
	id: 'DelBtnCen',
	iconCls: 'icon-remove',
	text: '删除',
	handler: function () {
		DelCen();
	}
}*/	

//归口科室下拉框渲染函数
function AuditDeptFormatter(value, row) {
	return row.AuditDeptNa;
}


var centerColumn = [[{
			field: 'rowid',
			title: 'ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'checkmainid',
			title: '主表ID',
			halign: 'center',
			hidden: true
		}, {
			field: 'deptid',
			title: '适用科室',
			halign: 'center',
			width:150,
			allowBlank: false,
			formatter:function(value, row) {
				return row.deptname;
			},
			editor: {
				type: 'combobox',
				options: {
					required: true,
			        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			        mode:'remote',
			        valueField:'rowid',    
			        textField:'name',
			        onBeforeLoad:function(param){
			            param.str = param.q;
			            param.hospid = hospid,
			            param.userdr = userid,
			            param.flag = '1^',
			            param.year = '',
			            param.audept = '',
			            param.schemedr = ''
			            
			        }
				}
			}
		}, {
			field: 'stepno',
			title: '顺序号',
			halign: 'center',
			width:60,
			allowBlank: false,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					min:0,
					max:10
				}
			}
		}, {
			field: 'procdesc',
			title: '岗位描述',
			halign: 'center',
			width:150,
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			field: 'chkerid',
			title: '用户名',
			halign: 'center',
			width:150,
			allowBlank: false,
			formatter:function(value, row) {
				return row.chkname;
			},
			editor: {
				type: 'combobox',
				options: {
					required: true,
			        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
			        mode:'remote',
			        valueField:'rowid',    
			        textField:'name',
			        onBeforeLoad:function(param){
			            param.str = param.q;
			            param.hospid = hospid,
			            param.userdr = userid,
			            param.flag = '1',
			            param.checkflag = ''
			            
			        }
				}
			}
		}, {
			field: 'isdirect',
			title: '是否科主任',
			halign: 'center',
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					required: true,
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '是'
						}, {
							rowid: '2',
							name: '否'
						}
					]
				}
			}
		}
	]]
var centerGridObj = $HUI.datagrid('#CenterGrid', {	
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
			MethodName: 'ListDetail',
			hospid: hospid,
			userid: userid
		},
		columns: centerColumn,
		singleSelect: true, 
		fit:true,
		fitColumns:false,
		autoSizeColumn:true, //调整列的宽度以适应内容
		rownumbers: true, //行号
		pagination: true, //分页
		pageSize: 12,
		pageList: [12, 24, 36, 48, 60],
		toolbar: "#trb",
		onClickRow:onClickRow,
	});
	
	 function onClickRow(index){
	        $('#CenterGrid').datagrid('endEdit', editIndex);
	        var row = $('#CenterGrid').datagrid('getSelected');
			if (editIndex != index){
				if (endEditing()){
					$('#CenterGrid').datagrid('selectRow', index)
					$('#CenterGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#CenterGrid').datagrid('selectRow', editIndex)}
			}} 

//新增
  $("#AddBtnCen").click(function(){
	  if (endEditing()){
		  $('#CenterGrid').datagrid('appendRow',{rowid: '',checkmainid: '',deptid: '',stepno: '',procdesc: '',chkerid:'',isdirect:''}); 
		  editIndex = $('#MainGrid').datagrid('getRows').length-1;
		  $('#MainGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}})
		  				
//点击行事件
function ClickRow(rowIndex, rowData) {
	if(rowData.rowid!=''){
		SearchDetail(rowData.rowid);
	}
}

	

//保存前校验
function chkBefSave(rowIndex, grid, row) {
	var fields = grid.datagrid('getColumnFields')
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var tmobj = grid.datagrid('getColumnOption', field);
			if (tmobj != null) {
				var reValue = "";
				reValue = row[field];
				if (reValue == undefined) {
					reValue = "";
				}
				if ((tmobj.allowBlank == false)) {
					var title = tmobj.title;
					if ((reValue == "") || (reValue == undefined)) {
						var info = title + "列为必填项，不能为空！";
						$.messager.popover({
							msg: info,
							type: 'info',
							timeout: 2000,
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
								top: 1
							}
						});
						return false;
					}
				}
			}
		}
		return true;
}

//保存方法
function Save() {
	var grid = $('#WestGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	row = "",
	mainData = "";
	if (rows.length > 0) {
		$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
			if (t) {
				var flag = 1;
				for (var i = 0; i < rows.length; i++) {
					row = rows[i];
					rowIndex = grid.datagrid('getRowIndex', row);
					grid.datagrid('endEdit', rowIndex);
					if (chkBefSave(rowIndex, grid, row)) {
						var tempdata = row.rowid
							 + '^' + hospid
							 + '^' + row.code
							 + '^' + row.name
							 + '^' + row.sysno;
						if (mainData == "") {
							mainData = tempdata;
						} else {
							mainData = mainData + "|" + tempdata;
						}
					} else {
						flag = 0;
						break;
					}
				}
				//alert(mainData);
				if (flag == 1) {
					DoSave(mainData);
				}
				grid.datagrid("reload");
				$('#CenterGrid').datagrid("reload");
			}
		})
	}
}

//保存请求后台方法
var DoSave = function (mainData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
		MethodName: 'Save',
		mainData: mainData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '添加成功！',
				type: 'success',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 1
				}
			});
		} else {
			$.messager.popover({
				msg: '添加失败！' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 1
				}
			});
		}
	});
}

function Del() {
	var rows = $('#WestGrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({
			msg: '请选中要删除的记录！',
			type: 'info',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 1
			}
		});
		return;
	}

	$.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
		if (t) {
			var mainData = "";
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				var rowid = row.rowid;
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//新增的行删除
					editIndex = $('#WestGrid').datagrid('getRowIndex', row);
					$('#WestGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
				}
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
				MethodName: 'Del',
				userid: userid,
				mainData: mainData
			},
				function (Data) {
				if (Data == 0) {
					$.messager.popover({
						msg: '删除成功！',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 1
						}
					});
				} else {
					$.messager.popover({
						msg: '删除失败！' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 1
						}
					});
				}
			});
			$('#WestGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
			$('#WestGrid').datagrid("reload");
			$('#CenterGrid').datagrid("reload");
			startIndex = undefined;
			return startIndex;
		}
	})
}

//保存方法
function SaveCen() {
	var grid = $('#CenterGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			var ed = $('#CenterGrid').datagrid('getEditor', {
					index: indexs[i],
					field: 'chkerid'
				});
			if (ed) {
				var chkname = $(ed.target).combobox('getText');
				$('#CenterGrid').datagrid('getRows')[indexs[i]]['chkname'] = chkname;

			}
			var ed = $('#CenterGrid').datagrid('getEditor', {
					index: indexs[i],
					field: 'deptid'
				});
			if (ed) {
				var deptname = $(ed.target).combobox('getText');
				$('#CenterGrid').datagrid('getRows')[indexs[i]]['deptname'] = deptname;

			}
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	row = "",
	mainData = "",detailData='';
	if (rows.length > 0) {
		$.messager.confirm('确定', '确定要保存数据吗？', function (t) {
			if (t) {
				var mainRow=$('#WestGrid').datagrid('getSelected');
				mainData=mainRow.rowid;
				var flag = 1;
				for (var i = 0; i < rows.length; i++) {
					row = rows[i];
					rowIndex = grid.datagrid('getRowIndex', row);
					grid.datagrid('endEdit', rowIndex);
					if (chkBefSave(rowIndex, grid, row)) {
						var tempdata = row.rowid
							 + '^' + row.deptid
							 + '^' + row.stepno
							 + '^' + row.procdesc
							 + '^' + row.chkerid
							 + '^' + row.isdirect ;
						if (detailData == "") {
							detailData = tempdata;
						} else {
							detailData = detailData + "|" + tempdata;
						}
					} else {
						flag = 0;
						break;
					}
				}
				//alert(mainData);
				//alert(detailData);
				if (flag == 1) {
					DoSaveCen(mainData,detailData);
				}
				grid.datagrid("reload");
				$('#CenterGrid').datagrid("reload");
			}
		})
	}
}

//保存请求后台方法
var DoSaveCen = function (mainData,detailData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
		MethodName: 'SaveCen',
		mainData: mainData,
		detailData: detailData,
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '添加成功！',
				type: 'success',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 1
				}
			});
		} else {
			$.messager.popover({
				msg: '添加失败！' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 1
				}
			});
		}
	});
}


function DelCen() {
	var rows = $('#CenterGrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({
			msg: '请选中要删除的记录！',
			type: 'info',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
				top: 1
			}
		});
		return;
	}

	$.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
		if (t) {
			var mainData = "";
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				var rowid = row.rowid;
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//新增的行删除
					editIndex = $('#CenterGrid').datagrid('getRowIndex', row);
					$('#CenterGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
				}
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
				MethodName: 'DelCen',
				userid: userid,
				mainData: mainData
			},
				function (Data) {
				if (Data == 0) {
					$.messager.popover({
						msg: '删除成功！',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 1
						}
					});
				} else {
					$.messager.popover({
						msg: '删除失败！' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 1
						}
					});
				}
			});
			$('#CenterGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
			$('#CenterGrid').datagrid("reload");
			startIndex = undefined;
			return startIndex;
		}
	})
}