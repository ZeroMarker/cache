/**
 * 模块:	 煎药室配置
 * 子模块:	 煎药流程字典维护
 * 编写人:	 hulihua
 * 编写日期: 2019-06-18
 */

$(function () {
	InitGridProDict();
});

// 表格-流程字典
function InitGridProDict() {
	var columns = [
		[{
				field: "TDictId",
				title: '流程字典Id',
				hidden: true,
				width: 100
			}, {
				field: "TDictCode",
				title: '代码',
				width: 250,
				align: "left",
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "TDictDesc",
				title: '描述',
				width: 400,
				align: "left",
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "TDictNumber",
				title: '标识号',
				width: 250,
				hidden: true ,
				align: "left",
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: 'TSysFlag',
				title: '系统流程',
				align: 'left',
				width: 250,
				disable: true ,
				/*
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N',
						required: true
					}
				},*/
				formatter: function (value, row, index) {
					if (value == "Y") {
						return '<input type="checkbox"  class="checkbox-f" style="display: none;"><label class="checkbox disabled checked"></label>'
						
					} else {
						return '<input type="checkbox"  class="checkbox-f" style="display: none;"><label class="checkbox disabled"></label>'
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.DEC.CfProDict.Query',
			QueryName: 'QueryProDict'
		},
		pagination: false,
		columns: columns,
		shrinkToFit: true,
		exportXls: false,
		toolbar: "#gridProDictBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickRow: function (rowIndex) {
			$('#gridProDict').datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
		},
		onLoadSuccess:function(){

		}
	};
	PHA.Grid("gridProDict", dataGridOption);
}

// 新增
function Add() {
	$("#gridProDict").datagrid('addNewRow', {});
}

// 修改
function Update(){
	$('#gridProDict').datagrid('endEditing');
	var selRow = $('#gridProDict').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "请先选择要修改的数据！",
			type: 'alert'
		});
		return;
	}
	var rowIndex = $('#gridProDict').datagrid('getRowIndex', selRow);
	$('#gridProDict').datagrid('beginEditRow', {
		rowIndex: rowIndex,
	});
}

// 保存
function Save() {
	$('#gridProDict').datagrid('endEditing');
	var gridChanges = $('#gridProDict').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "没有需要保存的数据",
			type: 'alert'
		});
		return;
	}
	var inputStrArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		var params = $.trim(iData.TDictId || "") + "^" + $.trim(iData.TDictCode || "") + "^" + $.trim(iData.TDictDesc || "") + "^" + $.trim(iData.TDictNumber) + "^" + $.trim(iData.TSysFlag);
		//alert("params:"+params)
		inputStrArr.push(params)
	}
	
	var inputStr = inputStrArr.join("!!");
	
	var saveRet = $.cm({
			ClassName: 'PHA.DEC.CfProDict.OperTab',
			MethodName: 'SaveBatch',
			MultiDataStr: inputStr,
			dataType: 'text',
		}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, "-4");
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
	}
	$('#gridProDict').datagrid("reload");
}
