/**
 * 名称:	 药房公共-系统管理-公共类型字典维护
 * 编写人:	 yunhaibao
 * 编写日期: 2019-08-16
 */
PHA_COM.App.Csp = "pha.sys.v1.comdict.csp";
PHA_COM.App.Name = "SYS.COMDICT";
$(function () {
	PHA.SearchBox("conQText", {
		width: parseInt($("#treegridDHCPHCCatBar").width()) - 20,
		searcher: function (text) {
			$("#gridComDict").datagrid("query", {
				QText: text.trim()
			});
			$(this).searchbox("clear");
			$(this).next().children().focus();
		},
		placeholder: " 模糊检索..."
	});
	InitGridComDict();
	InitEvents();
});

// 表格-产品线
function InitGridComDict() {
	var columns = [
		[{
				field: "scdiId",
				title: 'scdiId',
				hidden: true,
				width: 100
			},
			{
				field: "scdiCode",
				title: '类型值',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			},
			{
				field: "scdiDesc",
				title: '类型值名称',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "scdiType",
				title: '类型代码',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "scdiTypeDesc",
				title: '类型名称',
				width: 400,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.ComDict.Query',
			QueryName: 'DHCStkComDictionary'
		},
		columns: columns,
		shrinkToFit: true,
		toolbar: "#gridComDictBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
			// $("[datagrid-row-index="+rowIndex+"]").css("background","red")
		},
		onDblClickCell: function (rowIndex, field, value) {
			$(this).datagrid('beginEditCell', {
				index: rowIndex,
				field: field
			});
		}
	};
	PHA.Grid("gridComDict", dataGridOption);
}


// 事件
function InitEvents() {
	$("#btnAdd").on("click", function () {
		$("#gridComDict").datagrid('addNewRow', {});
	})
	$("#btnSave").on("click", function () {
		Save();
	});
	$("#btnDelete").on("click", Delete);
}

// 保存
function Save() {
	$('#gridComDict').datagrid('endEditing');
	var gridChanges = $('#gridComDict').datagrid('getChanges');
	var gridDelChanges= $('#gridComDict').datagrid('getChanges','deleted');
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
		if (gridDelChanges.indexOf(iData)>=0){
			continue;
		}
		var params = (iData.scdiId || "") + "^" + (iData.scdiCode||"") + "^" + (iData.scdiDesc||"") + "^" + (iData.scdiType||"") + "^" + (iData.scdiTypeDesc||"");
		inputStrArr.push(params)
	}
	var inputStr = inputStrArr.join("!!");
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.ComDict.Save',
		MethodName: 'SaveMulti',
		MultiDataStr: inputStr,
		dataType: 'text',
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, saveVal);
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
		$('#gridComDict').datagrid("reload");
	}
}
// 删除
function Delete() {
	var gridSelect = $('#gridComDict').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请先选中需要删除的记录",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	PHA.Confirm("删除提示", "您确定删除吗?</br>数据可能已被使用,请谨慎操作!", function () {
		var scdiId = gridSelect.scdiId || "";
		var rowIndex = $('#gridComDict').datagrid('getRowIndex', gridSelect);
		if (scdiId != "") {
			var saveRet = $.cm({
				ClassName: 'PHA.SYS.ComDict.Save',
				MethodName: 'Delete',
				Id: scdiId,
				dataType: 'text'
			}, false);
			var saveArr = saveRet.split('^');
			var saveVal = saveArr[0];
			var saveInfo = saveArr[1];
			if (saveVal < 0) {
				PHA.Alert('提示', saveInfo, 'warning');
				return;
			} else {
				PHA.Popover({
					msg: '删除成功',
					type: 'success'
				});
			}
		}
		$('#gridComDict').datagrid("deleteRow", rowIndex);
	});
}