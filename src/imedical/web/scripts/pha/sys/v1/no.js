/**
 * 名称:	 药房公共-系统管理-产品线维护
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-19
 */
PHA_COM.App.Csp = "pha.sys.v1.no.csp";
PHA_COM.App.Name = "COM.NO";
$(function () {
	InitHosp();
	InitGridPro();
	InitGridNo();
	InitEvents();
	InitDict();
	
	QueryGridNo();
	
	$('#gridPro').parent().parent().css('border-radius', '0px');
	AddTips();
});

// 初始化字典
function InitDict(){
	// 检索别名
	PHA.SearchBox("conAppAlias", {
		width: 300,
        searcher: QueryGridNo,
        placeholder: "可输入模块的简拼、代码、名称..."
    });
    
    // 查询参数列表是否使用查询条件
	$('#chk-FindAll').checkbox({
		onCheckChange: function(e, value){
			QueryGridNo();
		}
	});
}

// 表格-产品线
function InitGridPro() {
	var columns = [
		[{
				field: "RowId",
				title: '产品线Id',
				hidden: true,
				width: 100
			},
			{
				field: "Description",
				title: '名称',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Store',
			QueryName: 'DHCStkSysPro',
			ActiveFlag: "Y"
		},
		pagination: false,
		columns: columns,
		fitColumns: true,
		toolbar: null,
		enableDnd: false,
		onSelect: function (rowIndex, rowData) {
			$('#chk-FindAll').checkbox('setValue', false);
			QueryGridNo();
			$("#gridPro").datagrid("options").selectedRowIndex = rowIndex;
		},
		onLoadSuccess: function(data){
			var total = data.total;
			if (total > 0) {
				var selRowIdx = $("#gridPro").datagrid("options").selectedRowIndex;
				if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
					$("#gridPro").datagrid("selectRow", selRowIdx);
				} else {
					$("#gridPro").datagrid("selectRow", 0);
				}
			}
		}
	};

	PHA.Grid("gridPro", dataGridOption);
}

// 表格-单号
function InitGridNo() {
	var columns = [
		[{
				field: "countId",
				title: '规则Id',
				hidden: true,
				width: 100
			}, {
				field: "appId",
				title: '模块Id',
				hidden: true,
				width: 100
			},
			{
				field: "appCode",
				title: '代码',
				width: 200
			},
			{
				field: "appDesc",
				title: '名称',
				width: 200
			},
			{
				field: "hospFlag",
				title: '医院',
				width: 75,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value== "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			{
				field: "locFlag",
				title: '科室',
				width: 75,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value== "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			{
				field: "catGrpFlag",
				title: '类组',
				width: 75,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value== "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			{
				field: "prefix",
				title: '前缀',
				width: 100,
				editor: {
					type: 'validatebox',
					options: {}
				}
			},
			{
				field: "yearFlag",
				title: '年',
				width: 75,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value== "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			{
				field: "monthFlag",
				title: '月',
				width: 75,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value== "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			{
				field: "dayFlag",
				title: '日',
				width: 75,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value== "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			{
				field: "sufLen",
				title: '后缀长度',
				width: 100,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},
		]
	];
	var dataGridOption = {
		// clickToEdit: false,
		// dblclickToEdit: true,
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.No.Query',
			QueryName: 'QueryNo'
		},
		pagination: false,
		columns: columns,
		fitColumns: true,
		shrinkToFit: true,
		toolbar: "#gridNoBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickCell: function (rowIndex, field, value) {
			$(this).datagrid('beginEditCell', {
				index: rowIndex,
				field: field
			});
		}
	};
	PHA.Grid("gridNo", dataGridOption);
}

function QueryPro(){
	$("#gridPro").datagrid("query", {
		InputStr: ''
	});
}

function QueryGridNo(){
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		return false;
	}
	
	var activeFlag = "Y";
	var selRowData = $("#gridPro").datagrid("getSelected");
	if (selRowData == null) {
		return false;
	}
	var proId = selRowData.RowId || "";
	if (proId == "") {
		return false;
	}
	var QText = $('#conAppAlias').searchbox('getValue') || "";
	var findAllFlag = $('#chk-FindAll').checkbox('getValue') == true ? "Y" : "N";
	if (QText.indexOf('^') >= 0) {
		PHA.Popover({
			msg: "不能包含字符^",
			type: 'alert'
		});
		return false;
	}
	var InputStr = activeFlag + "^" + proId + "^" + QText + "^" + findAllFlag;
	$("#gridNo").datagrid('query', {
		InputStr: InputStr,
		HospID: hospId
	});
}

// 事件
function InitEvents() {
	$("#btnSave").on("click", function () {
		Save();
	});
}

// 保存-产品线
function Save() {
	// 验证
	if($('#gridNo').datagrid('endEditing') == false){
		PHA.Popover({
			msg: "请输入必填项之后再保存",
			type: 'alert'
		});
		return;
	}
	// 取值
	var gridChanges = $('#gridNo').datagrid('getChanges') || [];
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "没有需要保存的数据",
			type: 'alert'
		});
		return;
	}
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "请选择医院!",
			type: 'alert'
		});
		return;
	}
	
	// 保存
	var jsonDataStr = JSON.stringify(gridChanges);
	var retStr = tkMakeServerCall('PHA.SYS.No.Save', 'SaveMulti', jsonDataStr, hospId);
	var retArr = retStr.split("^");
	var retVal = retArr[0];
	var retInfo = retArr[1];
	if (retVal < 0) {
		PHA.Alert("提示", retInfo, retVal);
	} else {
		PHA.Popover({
			msg: retInfo || "成功!",
			type: "success",
			timeout: 500
		});
		QueryGridNo();
	}
}

/*
* @description: 多院区配置 - 加载初始化医院
*/
function InitHosp() {
	var hospComp = GenHospComp("DHC_StkSysCounter");  
	hospComp.options().onSelect = function(record){
		QueryGridNo();
	}
}

function AddTips(){
	$Tips = $('#panel-no').prev().find('.panel-tool').find('.icon-tip');
	$Tips.attr('title', $g('(1)仅查询“产品模块维护”界面维护的“模块类型”为“业务”的产品模块;') + '<br/>' + $g('(2)全局检索将不过滤产品线,检索出所有符合条件的模块。'));
	$Tips.tooltip({position:'left'}).show();
}