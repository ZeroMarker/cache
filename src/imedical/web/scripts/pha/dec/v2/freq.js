/**
 * 模块:	 煎药室配置
 * 子模块:	 频次对照维护
 * 编写人:	 MaYuqiang
 * 编写日期: 2021-01-03
 */

$(function () {
	InitDict();
	InitGridFreq();
});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	/*
	PHA.ComboBox("cmbFreq", {
		url: PHA_STORE.PHCFreq().url,
		onSelect: function (selData) {
			queryData();
		}
	});
	*/
}

// 表格-流程字典
function InitGridFreq() {
	var columns = [
		[{
				field: "TPIFId",
				title: '频次对照Id',
				hidden: true,
				width: 100
			},{
				field: "TFreqId",
				title: '频次Id',
				hidden: true,
				width: 100
			}, {
				field: "TFreqCode",
				title: '频次代码',
				width: 250,
				align: "left"
			}, {
				field: "TFreqDesc",
				title: '频次描述',
				width: 300,
				align: "left",
				editor: {
					type: 'combogrid',
					options: {
						url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=GetFreqStore&QText=' + '' ,	//this.value
						blurValidValue: true,
						required: true,
						idField: 'freqDesc',
						textField: 'freqDesc',
						method: 'get',
						columns: columns,
						fitColumns: true,
						columns: [[{
									field: 'freqId',
									title: 'freqId',
									hidden: true
								}, {
									field: 'freqCode',
									title: '频次代码',
									align: 'center'
								}, {
									field: 'freqDesc',
									title: '频次名称',
									align: 'center'
								}
							]],
						onSelect: function (rowIndex, rowData) {
							var selRow = $('#gridFreq').datagrid('getSelected');
							selRow.TFreqId = rowData.freqId;
							selRow.TFreqCode = rowData.freqCode;
						}
					}
				}
			},{
				field: "TFactor",
				title: '系数',
				hidden: false,
				width: 100,
				editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
			},{
				field: 'TActive',
				title: '是否使用',
				align: 'left',
				width: 100,
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N',
						required: true
					}
				},
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
			ClassName: 'PHA.DEC.CfFreq.Query',
			QueryName: 'QueryPIFFreq'
		},
		pagination: false,
		columns: columns,
		shrinkToFit: true,
		exportXls: false,
		toolbar: "#gridFreqBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickRow: function (rowIndex) {
			$('#gridFreq').datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
		},
		onLoadSuccess:function(){

		}
	};
	PHA.Grid("gridFreq", dataGridOption);
}

// 新增
function Add() {
	$("#gridFreq").datagrid('addNewRow', {
		defaultRow : {
			TPIFId : '',
			TFreqId : '',
			TFreqCode : '',
			TFreqDesc : '',
			TFactor : '',
			TActive : 'Y'
		}
	});
}

// 保存
function Save() {
	$('#gridFreq').datagrid('endEditing');
	var gridChanges = $('#gridFreq').datagrid('getChanges');
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
		var params = $.trim(iData.TPIFId || "") + "^" + $.trim(iData.TFreqId || "") + "^" + $.trim(iData.TFactor || "") + "^" + $.trim(iData.TActive);
		inputStrArr.push(params)
	}
	
	var inputStr = inputStrArr.join("!!");
	var saveRet = $.cm({
			ClassName: 'PHA.DEC.CfFreq.OperTab',
			MethodName: 'SaveBatch',
			params: inputStr,
			dataType: 'text',
		}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, "-4");
		return ;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
	}
	$('#gridFreq').datagrid("reload");
}

// 新增
function Delete() {
	var gridSelect = $('#gridFreq').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请先选中需要删除的对照信息",
			type: "alert"
		});
		return;
	}
	
	var delInfo = "您确认删除吗?"
	PHA.Confirm("删除提示", delInfo, function () {
		var pifId = gridSelect.TPIFId ;
		if (pifId == undefined) {
			var index=$('#gridFreq').datagrid('getRowIndex',gridSelect);
			$('#gridFreq').datagrid('deleteRow', index);
		}
		else {
			var deleteRet = $.cm({
				ClassName: 'PHA.DEC.CfFreq.OperTab',
				MethodName: 'Delete',
				pifId: pifId,
				dataType: 'text'
			}, false);
			var deleteArr = deleteRet.split('^');
			var deleteVal = deleteArr[0];
			var deleteInfo = deleteArr[1];
				
			if (deleteVal < 0) {
				PHA.Alert('提示', deleteInfo, 'warning');
				return ;
			} else {
				PHA.Alert('提示',"删除成功", 'success');
				
			}
			$('#gridFreq').datagrid("reload");
		}
	})
}


/**
 * 查询数据
 * @method queryData
 */
function queryData(){
	var freqDesc = $('#txtFreq').val();
	$('#gridFreq').datagrid('query', {
		inputStr: freqDesc
	});	
}
