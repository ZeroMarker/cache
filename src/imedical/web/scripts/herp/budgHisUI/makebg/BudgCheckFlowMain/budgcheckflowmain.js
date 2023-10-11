/*
Creator: zhouwenjie
CreatDate: 2018-11-21
Description: 全面预算管理-基本信息维护-审批流
CSPName: herp.budg.hisui.budgcheckflowain.csp
ClassName: herp.budg.hisui.udata.uBudgCheckFlow,
herp.budg.hisui.udata.uBudgCheckFlowMain,
herp.budg.hisui.udata.uBudgCheckFlowDetail,
 */
var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
 
 $(function(){//初始化
    Initmain();
}); 
function Initmain(){
	MainColumns=[[{
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
					]}}
}]]
	
//增加按钮
var AddBtn = {
	id: 'Add',
	iconCls: 'icon-add',
	text: '新增',
	handler: function () {
	  if (endEditing()){
		  $('#MainGrid').datagrid('appendRow',{rowid: '',compNa: '',code: '',name: '',sysno: ''}); 
		  editIndex = $('#MainGrid').datagrid('getRows').length-1;
		  $('#MainGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}
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
var mainGridObj = $HUI.datagrid('#MainGrid', {
		fit: true,
		url: $URL,
		loadMsg:"正在加载，请稍等…",
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgCheckFlow',
			MethodName: 'List',
			groupid:groupid,
			hospid: hospid,
			userid: userid
		},
		columns: MainColumns, 
        onClickRow:onClickRow,
		fitColumns:true,
		singleSelect:true,
		rownumbers: true, //行号
		pagination: true, //分页
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100],
		toolbar: [AddBtn, SaveBtn, DelBtn]  //AutoAddBtn, 
	});
	
        var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				$('#MainGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
        function onClickRow(index){
	        $('#MainGrid').datagrid('endEdit', editIndex);
	        var row = $('#MainGrid').datagrid('getSelected');
	        $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgCheckFlow",
                MethodName:"ListDetail",
                hospid: hospid,
                userid: userid,
                checkmainid: row.rowid
            });
			if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
					$('#MainGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex)}
			}}
			
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
	var grid = $('#MainGrid');
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
				$('#DetailGrid').datagrid("reload");
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

var mainData = ""
//删除方法	
function Del() {
	var row = $('#MainGrid').datagrid("getSelected");
	var rowDetail = $('#DetailGrid').datagrid('getRows').length;
	
	if((rowDetail>0)&&(row.rowid>0)){
		$.messager.popover({
			msg: '此项含有明细，不可删除！',
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
	if (row.length == 0) {
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
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//新增的行删除
		            editIndex= $('#MainGrid').datagrid('getRows').length-1;
					$('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					return;
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
			$('#MainGrid').datagrid("unselectAll"); //取消选择所有当前页中所有的行
			$('#MainGrid').datagrid("reload");
			$('#DetailGrid').datagrid("reload");
		}
	)
}
	
	}
