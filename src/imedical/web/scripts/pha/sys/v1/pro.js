/**
 * 名称:	 药房公共-系统管理-产品线维护
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-19
 */
PHA_COM.App.Csp = "pha.sys.v1.pro.csp";
PHA_COM.App.Name = "SYS.PRO";
$(function () {
	InitGridPro();
	InitEvents();
});

// 表格-产品线
function InitGridPro() {
	var columns = [
		[{
				field: "proId",
				title: '产品线Id',
				hidden: true,
				width: 100
			},
			{
				field: "proCode",
				title: '代码',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function(){
							PHA_GridEditor.Next();
						}
					}
				}
			},
			{
				field: "proDesc",
				title: '名称',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function(){
							PHA_GridEditor.Next();
						}
					}
				}
			},
			{
				field: "proActiveFlag",
				title: '启用',
				width: 50,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value == "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			}
		]
	];
	var dataGridOption = {
		// clickToEdit: false,
		// dblclickToEdit: true,
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Pro.Query',
			QueryName: 'DHCStkSysPro'
		},
		pagination: false,
		columns: columns,
		shrinkToFit: true,
		toolbar: "#gridProBar",
		enableDnd: false,
		isAutoShowPanel: true,
		editFieldSort: ["proCode", "proDesc", "proActiveFlag"],
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickCell: function (rowIndex, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPro",
				index: rowIndex,
				field: field
			});
		}
	};
	PHA.Grid("gridPro", dataGridOption);
}

// 查询
function Query(){
	$("#gridPro").datagrid("query",{})
}

// 事件
function InitEvents() {
	$("#btnAddPro").on("click", function () {
		Add();
	})
	$("#btnSavePro").on("click", function () {
		Save();
	});
}

// 新增-产品线
function Add(){
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridPro');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	// 添加
	PHA_GridEditor.Add({
		gridID: 'gridPro',
		field: 'proCode',
		rowData: {proActiveFlag:'Y'}
	});
}

// 保存-产品线
function Save() {
	$('#gridPro').datagrid('endEditing');
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridPro');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	// 重复行验证
	var chkRetStr = PHA_GridEditor.CheckDistinct({gridID:'gridPro', fields:['proCode']});
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	// 验证是否改变
	var gridChanges = $('#gridPro').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "没有需要保存的数据！",
			type: 'alert'
		});
		return;
	}
	// 字符串
	var inputStrArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		var params = (iData.proId || "") + "^" + (iData.proCode || "") + "^" + (iData.proDesc || "") + "^" + iData.proActiveFlag;
		inputStrArr.push(params)
	}
	var inputStr = inputStrArr.join("!!");
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.Pro.Save',
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
	}
	$('#gridPro').datagrid("reload");
}