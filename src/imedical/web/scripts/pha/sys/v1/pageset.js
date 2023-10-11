/**
 * 名称:	 药房公共-系统管理-页面设置
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12
 * Update:   Huxt 2020-02-27
 * pha/sys/v1/pageset.js
 */

PHA_COM.App.Csp = "pha.sys.v1.pageset.csp";
PHA_COM.App.Name = "页面设置";
PHA_COM.App.ProCode = "SYS";
PHA_COM.App.ProDesc = "系统管理";
PHA_COM.App.ParamMethod = "";

PHA_COM.VAR = {
	valColor: '#0538f2',
	timer: null,
	previewIncon: '../scripts_lib/hisui-0.1.0/dist/css/icons/search.png',
	PISTable: 'CF_PHA_IN.PageItmSet'
}

// 页面加载完成
$(function () {
	PHA_COM.ResizePanel({
		layoutId: 'layout-right',
		region: 'north',
		height: 0.48
	});

	// 字典
	InitDict();
	// 主界面
	InitGridPage();
	InitGridPageItm();
	InitGridPageEleItm();
	InitGridPageItmSet();
	// 事件
	InitEvents();
	QueryPage();
});

/**
 * @description: 初始化事字典
 */
function InitDict() {
	PHA.ComboBox("proId", {
		width: 345,
		placeholder: '产品线...',
		url: $URL + "?ResultSetType=array&ClassName=PHA.SYS.Store&QueryName=DHCStkSysPro&ActiveFlag=Y",
		onLoadSuccess: function (data) {},
		onSelect: function (rowData) {
			QueryPage();
		},
		onChange: function (newValue, oldValue) {
			if (newValue == "") {
				QueryPage();
			}
		}
	});
	PHA.SearchBox("pageAlias", {
		width: 345,
		searcher: QueryPage,
		placeholder: "页面连接、名称或简拼..."
	});
}

/**
 * @description: 绑定事件
 */
function InitEvents() {
	$('#btnSet').on('click', EleItmValSetWin);
	$('#btnSaveItmSet').on('click', SaveItmSet);
	$('#btnDeleteItmSet').on('click', DeleteItmSet);
	$('#btnCopyItmSet').on('click', CopyItmSet);
	
	$('#btnOpenDictWin').on('click', OpenDictWin);
	$('#btnUpItm').on('click', UpAndDownItm);
	$('#btnDownItm').on('click', UpAndDownItm);
}

/**
 * @description: 初始化页面
 */
function InitGridPage() {
	var columns = [
		[{
				field: "pageId",
				title: 'pageId',
				hidden: true,
				width: 100
			}, {
				field: "proDesc",
				title: '产品线',
				width: 50
			}, {
				field: "pageDesc",
				title: '名称',
				width: 150,
				formatter: function (value, rowData, rowIndex) {
					if (rowData.pageModel && rowData.pageModel != '') {
						return value + " <label style='color:#017bce;cursor:pointer;' onclick=OpenModelSetWin('" + rowData.pageId + "')>[" + rowData.pageLink + "]</label>";
					}
					return value + " <label style='color:gray;'>[" + rowData.pageLink + "]</label>";
				}
			}, {
				field: "pageLink",
				title: '链接',
				hidden: true,
				width: 150
			}, {
				field: "pagePreview",
				title: '预览',
				width: 45,
				fixed: true,
				align: 'center',
				hidden: true,
				formatter: function (value, rowData, rowIndex) {
					if (typeof rowData.pageModel == 'string' && rowData.pageModel != '') {
						return '<div><img src="' + PHA_COM.VAR.previewIncon + '" style="border:0px;cursor:pointer;margin-top:5px;" onclick=OpenPreviewWin("' + rowIndex + '") title="' + $g('点击预览') + '"/></div>';
					}
					return '';
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'PHAINPage'
		},
		columns: columns,
		pagination: true,
		pageSize: 100,
		fitColumns: true,
		toolbar: "#gridPageBar",
		enableDnd: false,
		onRowContextMenu: function () {},
		onDblClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (rowIndex, field, value) {},
		onSelect: function (rowIndex, rowData) {
			QueryPageItm();
		},
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$(this).datagrid('selectRow', 0);
			} else {
				$("#gridPageItm").datagrid('clear');
			}
		},
		gridSave: false,
		translateCols: true
	};
	PHA.Grid("gridPage", dataGridOption);
}
function QueryPage() {
	var proId = $('#proId').combobox('getValue') || "";
	var pageAlias = $("#pageAlias").searchbox('getValue') || "";
	var inputStr = proId + "^" + pageAlias;
	
	$("#gridPage").datagrid('options').url = $URL;
	$("#gridPage").datagrid('query', {
		inputStr: inputStr
	});
}
// 与page.js里面的一样,如修改需同时修改
function OpenModelSetWin(pageId){
	// 显示弹窗
	var winId = 'model_set_win';
	if ($('#' + winId).length == 0) {
		var tipImg = '../scripts_lib/hisui-0.1.0/dist/css/icons/tip.png';
		var layoutHtml = '';
		layoutHtml += '<div style="margin:0 10px 0 10px">';
		layoutHtml += '	<table cellspacing="10">';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="cols">' + $g('表单布局列数') + '</label></td>';
		layoutHtml += '			<td><input id="cols" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('设置表单布局列数') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="width">' + $g('左侧面板宽度') + '</label></td>';
		layoutHtml += '			<td><input id="width" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('当页面模板为左右结构时，设置左侧面板宽度(数字或比例)，其他模板设置无效') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="height">' + $g('上侧面板高度') + '</label></td>';
		layoutHtml += '			<td><input id="height" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('当页面模板为上下结构时，设置上侧面板高度(数字或比例)，其他模板设置无效') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="pkey">' + $g('查询传参') + '</label></td>';
		layoutHtml += '			<td><input id="pkey" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('查询时传参方式，根据表格查询后台的方法设置，比如后台查询Query的入参名为InputStr此处就填InputStr。填写此参数后会将所有表单值作为json串传递到后台，不填此参数默认按照单个表单参数传递。') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="query">' + $g('自动查询') + '</label></td>';
		layoutHtml += '			<td><input id="query" class="hisui-checkbox" data-pha="class:\'hisui-checkbox\',save:true,query:true,clear:true" type="checkbox" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('当页面加载完成时是否自动触发查询。') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '	</table>';
		layoutHtml += '</div>';
		$('body').append('<div id="' + winId + '"></div>');
		$('#' + winId).dialog({
			title: '页面模板属性',
			collapsible: false,
			minimizable: false,
			iconCls: "icon-w-edit",
			border: false,
			closed: true,
			modal: true,
			width: 335,
			height: 300,
			content: layoutHtml,
			buttons:[{
				text: '保存',
				handler: saveOtherCfg
			},{
				text: '关闭',
				handler: function(){
					$('#' + winId).dialog('close');
				}
			}]
		});
	}
	$('#' + winId).dialog('open');
	$('#' + winId).attr('pageId', pageId);
	// 显示数据
	var pageOtherCfg = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'GetOtherCfg',
		pageId: pageId
	}, false);
	$('#' + winId).find('input[id]').each(function(){
		$('#' + this.id).val('');
	});
	$('#' + winId).find('#cols').val('6');
	$('#' + winId).find('#pkey').val('pJsonStr');
	for (var k in pageOtherCfg) {
		$('#' + winId).find('#' + k).val(pageOtherCfg[k]);
	}
	// 保存数据
	function saveOtherCfg(){
		var checkNumArr = ['cols', 'width', 'height'];
		var isErr = false;
		var pJson = {};
		$('#' + winId).find('input[id]').each(function(){
			if ($(this).hasClass('hisui-checkbox')) {
				pJson[this.id] = $('#' + winId).find('#' + this.id).checkbox('getValue') ? 'Y' : 'N';
			} else {
				pJson[this.id] = $('#' + winId).find('#' + this.id).val();
			}
			var lb = $('#' + winId).find("label[for='" + this.id + "']").text();
			if (checkNumArr.indexOf(this.id) >= 0 && pJson[this.id] !== '' && isNaN(parseFloat(pJson[this.id]))) {
				PHA.Alert("温馨提示", lb + "：" + "请输入数字", -1);
				isErr = true;
				return false;
			}
			if (parseFloat(pJson[this.id]) <= 0) {
				PHA.Alert("温馨提示", lb + "：" + "数字不能小于0", -1);
				isErr = true;
				return false;
			}
		});
		if (isErr)
			return;
		var pJsonStr = JSON.stringify(pJson);
		var pId = $('#' + winId).attr('pageId');
		var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'UpdOtherCfg', pId, pJsonStr);
		var retArr = retStr.split('^');
		if (retArr[0] < 0) {
			return PHA.Alert("温馨提示", retArr[1], retArr[0]);
		}
		$('#' + winId).dialog('close');
		PHA.Popover({
			msg: "保存成功!",
			type: "success"
		});
	}
}

/**
 * @description: 初始化页面元素列表
 */
function InitGridPageItm() {
	var columns = [
		[{
				field: "pageItmId",
				title: 'pageItmId',
				width: 100,
				hidden: true
			}, {
				field: "pageItmDom",
				title: 'DomId',
				width: 100
			}, {
				field: "pageItmDesc",
				title: '名称',
				width: 100
			}, {
				field: "pageItmEleDR",
				title: 'pageItmEleDR',
				width: 100,
				hidden: true
			}, {
				field: "pageItmEleDesc",
				title: '元素类型',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'PHAINPageItm'
		},
		columns: columns,
		pagination: false,
		fitColumns: true,
		toolbar: '#gridPageItmBar',
		enableDnd: false,
		onRowContextMenu: function () {},
		onDblClickRow: function (rowIndex, rowData) {
			$('#gridPageItm').datagrid('options').selectedRowIndex = rowIndex;
			EleItmValSetWin();
		},
		onDblClickCell: function (rowIndex, field, value) {},
		onSelect: function (rowIndex, rowData) {
			$('#gridPageItm').datagrid('options').selectedRowIndex = rowIndex;
			QueryPageEleItm();
		},
		onLoadSuccess: function (data) {
			$("#gridPageEleItm").datagrid('clear');
			$("#gridPageItmSet").datagrid('clear');
			if (data.total > 0) {
				var selectedRowIndex = $(this).datagrid('options').selectedRowIndex;
				if (selectedRowIndex >= 0 && data.total > selectedRowIndex) {
					$(this).datagrid('selectRow', selectedRowIndex);
				} else {
					$(this).datagrid('selectRow', 0);
				}
			} else {
				$("#gridPageEleItm").datagrid('clear');
				$("#gridPageItmSet").datagrid('clear');
			}
			
			$('#btnUpItm').prop('disabled', '');
			$('#btnDownItm').prop('disabled', '');
		},
		gridSave: false
	};
	PHA.Grid("gridPageItm", dataGridOption);
}
function QueryPageItm() {
	var selRow = $("#gridPage").datagrid('getSelected') || {};
	var pageId = selRow.pageId || "";
	
	$("#gridPageItm").datagrid('options').url = $URL;
	$("#gridPageItm").datagrid('reload', {
		ClassName: 'PHA.SYS.Page.Query',
		QueryName: 'PHAINPageItm',
		inputStr: pageId
	});
}

/**
 * @description: 表格-元素属性
 */
function InitGridPageEleItm() {
	var columns = [
		[{
				field: "eleItmId",
				title: 'eleItmId',
				width: 100,
				hidden: true
			}, {
				field: "eleItmCode",
				title: '属性代码',
				width: 150,
				hidden: true
			}, {
				field: "eleItmDesc",
				title: "<label style='font-weight:bold'>" + $g('属性名称') + "</label>",
				width: 150,
				trans: false,
				formatter: function (value, rowData, rowIndex) {
					return value + " <label style='color:gray;'>[" + rowData.eleItmCode + "]</label>";
				}
			}, {
				field: "eleItmValType",
				title: '类型',
				width: 100,
				hidden: true
			}, {
				field: "eleItmMemo",
				title: '说明',
				width: 410,
				showTip: true,
				tipWidth: 300,
				hidden: true
			}, {
				field: "eleItmActive",
				title: '启用',
				align: "center",
				width: 50,
				formatter: function (val, rowData, rowIndex) {
					if (val == "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				},
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Ele.Query',
			QueryName: 'PHAINEleItm'
		},
		columns: columns,
		pagination: false,
		fitColumns: true,
		toolbar: '#gridPageEleItmBar',
		enableDnd: false,
		onRowContextMenu: function () {},
		onDblClickRow: function (rowIndex, rowData) {
			EleItmValSetWin();
		},
		onDblClickCell: function (rowIndex, field, value) {},
		onSelect: function (rowIndex, rowData) {
			QueryPageItmSet();
		},
		onLoadSuccess: function (data) {
			$("#gridPageItmSet").datagrid('clear');
			if (data.total > 0) {
				$(this).datagrid('selectRow', 0);
			} else {
				$("#gridPageItmSet").datagrid('clear');
			}
		},
		gridSave: false
	};
	PHA.Grid("gridPageEleItm", dataGridOption);
}
function QueryPageEleItm() {
	var selRow = $("#gridPageItm").datagrid('getSelected') || {};
	var eleId = selRow.pageItmEleDR || "";
	
	$("#gridPageEleItm").datagrid('options').url = $URL;
	$("#gridPageEleItm").datagrid('reload', {
		ClassName: 'PHA.SYS.Ele.Query',
		QueryName: 'PHAINEleItm',
		inputStr: eleId
	});
}

/**
 * @description: 初始化页面元素属性列表
 */
function InitGridPageItmSet() {
	var columns = [
		[{
				field: "pageItmSetId",
				title: 'pageItmSetId',
				hidden: true,
				width: 80
			}, {
				field: "pageItmSetEleItmVal",
				title: "<label style='font-weight:bold'>" + $g('属性值') + "</label>",
				width: 120,
				trans: false,
				formatter: function (value, rowData, rowIndex) {
					if (rowData.eleItmCode == "columns") {
						return "<a style='border:0px;cursor:pointer' onclick=OpenColumnsSetWin('" + value + "')>" + value + "</a>"
					} else {
						return value;
					}
				},
				editor: {
					type: 'validatebox',
					options: {
						onEnter: function() {
					        PHA_GridEditor.Next();
					    }
					}
				}
			}, {
				field: "hospId",
				title: '医院ID',
				hidden: true,
				width: 80
			}, {
				field: "hospDesc",
				title: '医院',
				width: 180
			}, {
				field: "pageItmSetType",
				title: '类型Code',
				hidden: true,
				width: 80
			}, {
				field: "pageItmSetTypeDesc",
				title: '类型',
				width: 80
			}, {
				field: "pageItmSetPointer",
				title: '类型值ID',
				hidden: true,
				width: 100
			}, {
				field: "pageItmSetPointerDesc",
				title: '类型值',
				width: 140
			}, {
				field: "pageItmSetEleItmDR",
				title: '属性ID',
				hidden: true,
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'PHAINPageItmSet'
		},
		columns: columns,
		pagination: false,
		fitColumns: true,
		toolbar: '#gridPageItmSetBar',
		enableDnd: false,
		editFieldSort: ["pageItmSetEleItmVal"],
		onRowContextMenu: function () {},
		onDblClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {},
		onClickCell: function (index, field, value) {
			// 先判断是否可编辑
			var rowsData = $(this).datagrid('getRows');
			var rowData = rowsData[index];
			if (!IsCanEdit(rowData)) {
				return;
			}
			// 然后开始编辑
			if (field == 'pageItmSetEleItmVal') {
				PHA_GridEditor.Edit({
					gridID: "gridPageItmSet",
					index: index,
					field: field
				});
			} else {
				$(this).datagrid('endEditing');
			}
		},
		onClickRow: function (rowIndex, rowData) {
			// $(this).datagrid('endEditing');
		},
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {},
		gridSave: false
	};
	PHA.Grid("gridPageItmSet", dataGridOption);
}
function QueryPageItmSet() {
	var pageItmSelRow = $("#gridPageItm").datagrid('getSelected') || {};
	var pageItmId = pageItmSelRow.pageItmId || "";
	var pageEleItmSelRow = $("#gridPageEleItm").datagrid('getSelected') || {};
	var eleItmId = pageEleItmSelRow.eleItmId || "";
	var hospId = ""; // 预留
	
	$("#gridPageItmSet").datagrid('options').url = $URL;
	$("#gridPageItmSet").datagrid('reload', {
		ClassName: 'PHA.SYS.Page.Query',
		QueryName: 'PHAINPageItmSet',
		inputStr: pageItmId + "^" + eleItmId + "^" + hospId
	});
}
function SaveItmSet(){
	$('#gridPageItmSet').datagrid('endEditing');
	
	var pJsonData = [];
	var changesData = $('#gridPageItmSet').datagrid('getChanges');
	if ((changesData == null || changesData.length == 0)) {
		PHA.Popover({
			msg: "数据未发生改变，不需要保存!",
			type: "alert"
		});
		return false;
	}
	for (var i = 0; i < changesData.length; i++) {
		var oneRow = changesData[i];
		oneRow.rowIndex = GetGridRowIndex('gridPageItmSet', oneRow) + 1;
		if (oneRow.eleItmCode == "columns") {
			continue;
		}
		
		oneRow.hospId = oneRow.hospId;
		oneRow.type = oneRow.pageItmSetType;
		oneRow.pointer = oneRow.pageItmSetPointer;
		oneRow.eleItmId = oneRow.pageItmSetEleItmDR;
		oneRow.pageItmSetEleItmVal = oneRow.pageItmSetEleItmVal;
		
		pJsonData.push(oneRow);
	}
	var pJsonStr = JSON.stringify(pJsonData);
	
	// 保存到后台
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'SaveItmSetMulti', pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], -2);
		return false;
	} else {
		PHA.Popover({
			msg: "保存成功!",
			type: "success",
			timeout: 1000
		});
		QueryPageItmSet();
	}
}
function DeleteItmSet(){
	var selRow = $("#gridPageItmSet").datagrid('getSelected');
	if (selRow == null) {
		PHA.Popover({
			msg: "请选择一条数据！",
			type: "alert"
		});
		return;
	}
	var pageItmSetId = selRow.pageItmSetId || "";
	
	PHA.Confirm("温馨提示", "是否确认删除？", function () {
		if (pageItmSetId == "") {
			var rowIndex = $("#gridPageItmSet").datagrid('getRowIndex', selRow);
			$("#gridPageItmSet").datagrid('deleteRow', rowIndex);
			return;
		}
		
		// 保存到后台
		var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'DeleteItmSet', pageItmSetId);
		var retArr = retStr.split('^');
		if (retArr[0] < 0) {
			PHA.Alert("温馨提示", retArr[1], -2);
			return false;
		} else {
			PHA.Popover({
				msg: "删除成功!",
				type: "success"
			});
			QueryPageItmSet();
		}
	});
}

/**
 * 新增复制功能
 * 2023-04-21 Huxt
 */
function CopyItmSet(){
	var selRow = $("#gridPageItmSet").datagrid('getSelected');
	if (selRow == null) {
		PHA.Popover({
			msg: "请选择一条数据！",
			type: "alert"
		});
		return;
	}
	var pageItmSetId = selRow.pageItmSetId || "";
	if (pageItmSetId == '') {
		PHA.Popover({
			msg: "请选择一条数据！",
			type: "alert"
		});
		return;
	}
	var hospId = selRow.hospId || "";
	var hospDesc = selRow.hospDesc || "";
	var pageItmSetType = selRow.pageItmSetType || "";
	var pageItmSetPointer = selRow.pageItmSetPointer || "";
	var pageItmSetPointerDesc = selRow.pageItmSetPointerDesc || "";
	var pageItmSetTypeDesc = selRow.pageItmSetTypeDesc || "";
	var pageItmSetEleItmVal = selRow.pageItmSetEleItmVal || "";
	
	var winId = 'copy_itm_set_win';
	if ($('#' + winId).length == 0) {
		var layoutHtml = '';
		layoutHtml += '<div class="hisui-layout" fit="true" border="false">';
        layoutHtml += '    <div data-options="region:\'center\',border:false" style="padding:10px">';
        layoutHtml += '        <table class="pha-con-table">';
        layoutHtml += '            <tr>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="fromHospId"><span style="color:red">*</span>' + $g('医院') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromHospId" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '                <td style="padding-left:30px;padding-right:10px;"></td>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toHospId"><span style="color:red">*</span>' + $g('医院') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="toHospId" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '            </tr>';
        layoutHtml += '            <tr>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="fromType"><span style="color:red">*</span>' + $g('类型') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromType" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '                <td style="padding-left:30px;padding-right:10px;" rowspan="2">';
        layoutHtml += '                    <span class="icon icon-arrow-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toType"><span style="color:red">*</span>' + $g('类型') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="toType" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '            </tr>';
        layoutHtml += '            <tr>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="fromPointer"><span style="color:red">*</span>' + $g('类型值') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromPointer" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" style="width:233px;" />';
        layoutHtml += '                </td>';
        layoutHtml += '                <!-- <td style="padding-left:30px;padding-right:10px;"></td> -->'; // 跨行占用了
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toPointer"><span style="color:red">*</span>' + $g('类型值') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="toPointer" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" style="width:233px;" />';
        layoutHtml += '                </td>';
        layoutHtml += '            </tr>';
        layoutHtml += '            <tr>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="fromValue"><span style="color:red">*</span>' + $g('原始值') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromValue" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true,required:true" style="width:173px;" disabled />';
        layoutHtml += '                </td>';
        layoutHtml += '                <td style="padding-left:30px;padding-right:10px;"></td>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toValue"><span style="color:red">*</span>' + $g('复制值') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="toValue" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true,required:true" style="width:173px;" disabled />';
        layoutHtml += '                </td>';
        layoutHtml += '            </tr>';
        layoutHtml += '        </table>';
        layoutHtml += '    </div>';
        layoutHtml += '</div>';
        
		$('body').append('<div id="' + winId + '"></div>');
		$('#' + winId).dialog({
			title: '复制元素属性',
			collapsible: false,
			minimizable: false,
			iconCls: "icon-w-copy",
			border: false,
			closed: true,
			modal: true,
			width: 610,
			height: 280,
			content: layoutHtml,
			buttons:[{
				text: '保存',
				handler: SaveCopyItmSet
			},{
				text: '关闭',
				handler: function(){
					$('#' + winId).dialog('close');
				}
			}]
		}).dialog('open');
		
		// 医院
		PHA.ComboBox('fromHospId', {
			url: PHA_STORE.CTHospital().url,
			width: 180,
			disabled: true
		});
		PHA.ComboBox('toHospId', {
			url: PHA_STORE.CTHospital().url,
			width: 180
		});
		// 类型
		var typeData = [{
			RowId: 'A',
			Description: $g('通用')
		}, {
			RowId: 'L',
			Description: $g('科室')
		}, {
			RowId: 'G',
			Description: $g('安全组')
		}, {
			RowId: 'U',
			Description: $g('用户')
		}];
		PHA.ComboBox('fromType', {
			data: typeData,
			width: 180,
			disabled: true
		});
		PHA.ComboBox('toType', {
			data: typeData,
			width: 180,
			onSelect: function(record){
				_reload_to_pointer(record.RowId);
			}
		});
		// 类型值
		PHA.ComboBox('fromPointer', {
			url: '',
			width: 180,
			disabled: true
		});
		PHA.ComboBox('toPointer', {
			url: '',
			width: 180
		});
	}
	$('#' + winId).dialog('open');
	
	$('#fromHospId').combobox('setValue', hospId);
	$('#fromHospId').combobox('setText', hospDesc);
	$('#fromType').combobox('setValue', pageItmSetType);
	$('#fromType').combobox('setText', pageItmSetTypeDesc);
	$('#fromPointer').combobox('setValue', pageItmSetPointer);
	$('#fromPointer').combobox('setText', pageItmSetPointerDesc);
	$('#fromValue').val(pageItmSetEleItmVal);
	
	$('#toHospId').combobox('setValue', hospId);
	$('#toHospId').combobox('setText', hospDesc);
	$('#toType').combobox('setValue', '');
	$('#toPointer').combobox('loadData', []);
	$('#toPointer').combobox('setValue', '');
	$('#toValue').val(pageItmSetEleItmVal);
	
	// 定义加载Pointer的方法
	function _reload_to_pointer(type){
		$('#toPointer').combobox('loadData', []);
		$('#toPointer').combobox('setValue', '');
		$('#toPointer').combobox('setText', '');
		
		if (type == 'A') {
			$('#toPointer').combobox('loadData', [
				{
					RowId: '0',
					Description: $g('通用')
				}
			]);
			$('#toPointer').combobox('setValue', '0');
			$('#toPointer').combobox('setText', $g('通用'));
			return;
		} else if (type == 'L') {
			var _url = PHA_STORE.CTLoc().url;
		} else if (type == 'G') {
			var _url = PHA_STORE.SSGroup().url;
		} else if (type == 'U') {
			var _url = PHA_STORE.SSUser().url;
		}
		$('#toPointer').combobox('reload', _url);
	}
}
function SaveCopyItmSet(){
	var winId = 'copy_itm_set_win';
	var winData = PHA.DomData('#' + winId, {
		doType: 'save',
		retType: 'Json'
	});
	if (winData.length == 0) {
		return;
	}
	var saveData = winData[0];
	saveData.pageItmId = GetPageItmId();
	saveData.eleId = GetEleId();
	saveData.eleItmId = GetEleItmId();
	var pJsonStr = JSON.stringify(saveData);
	
	// 保存到后台
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'SaveCopyItmSet', pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], -2);
		return false;
	} else {
		PHA.Popover({
			msg: "保存成功",
			type: "success"
		});
		QueryPageItmSet();
		$('#' + winId).dialog('close');
	}
}

// 获取选中的行的ID
function GetPageId() {
	var selRow = $("#gridPage").datagrid('getSelected') || {};
	var pageId = selRow.pageId || "";
	return pageId;
}
function GetPageItmId() {
	var selRow = $("#gridPageItm").datagrid('getSelected') || {};
	var pageItmId = selRow.pageItmId || "";
	return pageItmId;
}
function GetEleId() {
	var selRow = $("#gridPageItm").datagrid('getSelected') || {};
	var eleId = selRow.pageItmEleDR || "";
	return eleId;
}
function GetEleItmId() {
	var selRow = $("#gridPageEleItm").datagrid('getSelected') || {};
	var eleItmId = selRow.eleItmId || "";
	return eleItmId;
}
function AddColor(str) {
	return "<label style='color:" + PHA_COM.VAR.valColor + "'>" + str + "</label>";
}
function GetGridRowIndex(_id, _rowData) {
	var rowIndex = $('#' + _id).datagrid('getRowIndex', _rowData);
	return rowIndex;
}

// ==================================
// 元素属性值设置弹窗
function EleItmValSetWin() {
	// 验证
	if (GetPageItmId() == "") {
		PHA.Popover({
			msg: "请先选择页面元素!",
			type: "alert"
		});
		return;
	}

	// 定义窗口的基本属性
	var winWidth = 920;
	var winHeight = parseInt($(window).height() * 0.9);
	var winId = "win_page_set";
	var winContentId = winId + "_" + "content";
	var contentHtml = "";
	contentHtml += '<div class="hisui-layout" fit="true">';
	contentHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
	contentHtml += '		<div class="hisui-layout" fit="true">';
	contentHtml += '			<div data-options="region:\'west\',border:false,split:true,width:405">';
	contentHtml += '				<div class="hisui-panel" title="' + $g('类型') + '" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true,bodyCls:\'\'">';
	contentHtml += '					<table id="gridAuth"></table>';
	contentHtml += '				</div>';
	contentHtml += '			</div>';
	contentHtml += '			<div data-options="region:\'center\',border:false,split:true">';
	contentHtml += '				<div id="panelPageEleItmVal" class="hisui-panel" title="' +$g('属性列表') + '" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true,bodyCls:\'\'">';
	contentHtml += '					<table id="gridPageEleItmVal"></table>';
	contentHtml += '				</div>';
	contentHtml += '			</div>';
	contentHtml += '		</div>';
	contentHtml += '	</div>';
	contentHtml += '</div>';

	// 窗口初始化(仅一次)
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: winWidth,
			height: winHeight,
			modal: true,
			draggable: false,
			title: '设置元素属性值',
			iconCls: 'icon-w-setting',
			content: contentHtml,
			closable: true
		});
		InitWinDict();
		InitGridAuth();
		InitGridPageEleItmVal();
		InitKeyWords();
		InitWinEvents();
	}

	// 打开窗口
	var pageDesc = ($("#gridPage").datagrid("getSelected") || {}).pageDesc || "";
	var pageItmDesc = ($("#gridPageItm").datagrid("getSelected") || {}).pageItmDesc || "";
	var pageItmEleDesc = ($("#gridPageItm").datagrid("getSelected") || {}).pageItmEleDesc || "";
	var newTitle = (pageDesc + AddColor("(页面)")) + " - " + (pageItmDesc + AddColor("(" + pageItmEleDesc + ")"));
	$('#panelPageEleItmVal').panel('setTitle', newTitle);
	$('#' + winId).dialog('open');
	
	var hospId = $('#combHosp').combobox('getValue') || "";
	if (hospId != "") {
		QueryPageEleItmVal();
		QueryAuth();
	} else {
		PHA_COM.VAR.timer = setInterval(function () {
			var hospId = $('#combHosp').combobox('getValue') || "";
			if (hospId != "") {
				clearInterval(PHA_COM.VAR.timer);
				QueryPageEleItmVal();
				QueryAuth();
			}
		}, 50);
	}
}

// 初始化 - 窗口事件
function InitWinEvents() {
	$('#btnSave').on('click', SavePageEleItmVal);
	$('#btnReload').on('click', QueryPageEleItmVal);
}

// 初始化 - 窗口字典
function InitWinDict() {
	PHA.SearchBox("conAuthAlias", {
		placeholder: "请输入简拼或名称回车查询",
		width: 332,
		searcher: function () {
			QueryPageEleItmVal();
			QueryAuth();
		}
	});
	PHA.ComboBox("combHosp", {
		placeholder: '请选择医院...',
		url: $URL + "?ResultSetType=array&ClassName=PHA.SYS.Store&QueryName=CTHospital",
		width: 332,
		onLoadSuccess: function (data) {
			$('#combHosp').combobox('setValue', session['LOGON.HOSPID']);
		},
		onSelect: function () {
			QueryPageEleItmVal();
			QueryAuth();
		}
	});
}

// 初始化 - 权限关键字(作为查询条件)
function InitKeyWords() {
	$("#kwAuthType").keywords({
		singleSelect: true,
		labelCls: 'blue',
		items: [{
				text: '用户',
				id: 'U'
			}, {
				text: '安全组',
				id: 'G'
			}, {
				text: '科室',
				id: 'L'
			}, {
				text: '通用',
				id: 'A',
				selected: true
			}
		],
		onClick: function () {
			QueryPageEleItmVal();
			QueryAuth();
		}
	});

	$("#kwAuthStat").keywords({
		singleSelect: false,
		labelCls: 'red',
		items: [{
				text: '未授',
				id: 'N',
				selected: true
			}, {
				text: '已授',
				id: 'Y',
				selected: true
			}
		],
		onClick: function () {
			QueryPageEleItmVal();
			QueryAuth();
		}
	});
}

// 初始化 - 权限列表
function InitGridAuth() {
	var columns = [
		[{
				field: "authId",
				title: '权限Id',
				hidden: true,
				width: 100
			}, {
				field: "authCode",
				title: '代码',
				width: 125
			}, {
				field: "authDesc",
				title: '名称',
				width: 150
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'GridAuth'
		},
		columns: columns,
		pagination: true,
		fitColumns: true,
		toolbar: "#gridAuthBar",
		enableDnd: false,
		onRowContextMenu: function () {},
		onDblClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (rowIndex, field, value) {},
		onSelect: function (rowIndex, rowData) {
			QueryPageEleItmVal();
		},
		onLoadSuccess: function (data) {},
		gridSave: false
	};
	PHA.Grid("gridAuth", dataGridOption);
}
// 查询 - 权限列表
function QueryAuth() {
	var hospId = $("#combHosp").combobox('getValue');
	var type = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var stateStr = "";
	var stateArr = $("#kwAuthStat").keywords('getSelected');
	for (var i = 0; i < stateArr.length; i++) {
		stateStr = stateStr == "" ? stateArr[i].id : stateStr + ',' + stateArr[i].id;
	}
	var authAlias = $("#conAuthAlias").searchbox("getValue") || "";
	var pointer = "";
	var pageItmId = GetPageItmId();
	var eleItmId = GetEleItmId();
	var inputStr = hospId + "^" + type + "^" + pointer + "^" + pageItmId + "^" + eleItmId + "^" + stateStr + "^" + authAlias; // 7

	$("#gridAuth").datagrid("options").url = $URL;
	$("#gridAuth").datagrid("query", {
		inputStr: inputStr
	});
}

// 初始化 - 元素属性值列表
function InitGridPageEleItmVal() {
	var columns = [
		[{
				field: "eleItmId",
				title: 'eleItmId',
				hidden: true,
				width: 100
			}, {
				field: "eleItmDesc",
				title: '属性名称',
				width: 130,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return value + " <label style='color:gray;'>[" + rowData.eleItmCode + "]</label>";
				}
			}, {
				field: "pageItmSetId",
				title: 'pageItmSetId',
				hidden: true,
				width: 150
			}, {
				field: "pageItmSetEleItmVal",
				title: '属性值',
				width: 150,
				formatter: function (value, rowData, rowIndex) {
					if (rowData.eleItmCode == "columns") {
						if (value == "") {
							return "<label style='color:gray;border:0px;cursor:pointer'>" + $g("请点先击保存后再维护此项...") + "</label>";
						}
						return "<a style='border:0px;cursor:pointer' onclick=OpenColumnsSetWin('" + value + "')>" + value + "</a>";
					} else {
						return value;
					}
				},
				editor: {
					type: 'validatebox',
					options: {
						onEnter: function() {
					        PHA_GridEditor.Next();
					    }
					}
				}
			}, {
				field: "eleItmMemo",
				title: '提示',
				width: 50,
				fixed: true,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return '<img title="' + value + '" class="hisui-tooltip" style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/tip.png" />';
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Page.Query',
			QueryName: 'PageEleItmVal'
		},
		columns: columns,
		pagination: false,
		fitColumns: true,
		toolbar: "#gridPageEleItmValBar",
		editFieldSort: ["pageItmSetEleItmVal"],
		enableDnd: false,
		onRowContextMenu: function () {},
		onDblClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {},
		onClickCell: function (index, field, value) {
			// 先判断是否可编辑
			var rowsData = $(this).datagrid('getRows');
			var rowData = rowsData[index];
			if (!IsCanEdit(rowData)) {
				return;
			}
			// 然后开始编辑
			if (field == 'pageItmSetEleItmVal') {
				PHA_GridEditor.Edit({
					gridID: "gridPageEleItmVal",
					index: index,
					field: field
				});
			} else {
				$(this).datagrid('endEditing');
			}
		},
		onClickRow: function (index, field, value) {
			// $(this).datagrid('endEditing');
		},
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function (data) {
			$('.hisui-tooltip').tooltip({
				position: 'right'
			});
			// 默认选中
			var eleItmId = GetEleItmId();
			if (eleItmId != "" && data.total > 0) {
				var rowsData = data.rows;
				for (var i = 0; i < rowsData.length; i++) {
					var rowData = rowsData[i];
					if (rowData.eleItmId == eleItmId) {
						$(this).datagrid('selectRow', i);
					}
				}
			}
		},
		onAfterEdit: function (index, rowData, changes) {
			$('.hisui-tooltip').tooltip({
				position: 'right'
			});
		},
		gridSave: false
	};
	PHA.Grid("gridPageEleItmVal", dataGridOption);
}
// 查询 - 元素属性值列表
function QueryPageEleItmVal() {
	var hospId = $("#combHosp").combobox('getValue');
	var type = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var pointer = ($("#gridAuth").datagrid("getSelected") || {}).authId || "";
	if (type == "A") {
		pointer = 0;
	}
	var pageItmId = GetPageItmId();
	var inputStr = hospId + "^" + type + "^" + pointer + "^" + pageItmId;

	$("#gridPageEleItmVal").datagrid("options").url = $URL;
	$("#gridPageEleItmVal").datagrid("query", {
		inputStr: inputStr
	});
}
// 保存 - 元素属性值列表
function SavePageEleItmVal() {
	$("#gridPageEleItmVal").datagrid('endEditing');
	
	// 获取类型
	var hospId = $("#combHosp").combobox('getValue') || "";
	var type = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var pointer = ($("#gridAuth").datagrid("getSelected") || {}).authId || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "请选择医院!",
			type: "alert"
		});
		return false;
	}
	if (type == "") {
		PHA.Popover({
			msg: "请选择类型:用户/科室/安全组/通用!",
			type: "alert"
		});
		return false;
	}
	if (pointer == "" && type != "A") {
		PHA.Popover({
			msg: "非“通用”设置，需要选择左侧列表中的类型值!",
			type: "alert"
		});
		return false;
	}
	if (type == "A") {
		pointer = 0;
	}
	
	// 新数据
	var pJsonData = [];
	// 获取列属性所在行的数据
	var rowsData = $('#gridPageEleItmVal').datagrid('getRows');
	for (var i = 0; i < rowsData.length; i++) {
		var oneRow = rowsData[i];
		if (oneRow.eleItmCode == "columns") {
			oneRow.hospId = hospId;
			oneRow.type = type;
			oneRow.pointer = pointer;
			pJsonData.push(oneRow);
			break;
		}
	}
	// 验证页码
	var rowsJsonStr = JSON.stringify(rowsData);
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'CheckEleItmValRela', rowsJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], -2);
		return false;
	}
	// 获取其他改变的属性值
	var changesData = $('#gridPageEleItmVal').datagrid('getChanges');
	if ((changesData == null || changesData.length == 0) && (pJsonData.length == 0)) {
		PHA.Popover({
			msg: "数据未发生改变，不需要保存!",
			type: "alert"
		});
		return false;
	}
	for (var i = 0; i < changesData.length; i++) {
		var oneRow = changesData[i];
		oneRow.rowIndex = GetGridRowIndex('gridPageEleItmVal', oneRow) + 1;
		if (oneRow.eleItmCode == "columns") {
			continue;
		}
		if (oneRow.eleItmCode == "ClassName" && type != "A") {
			PHA.Popover({
				msg: "属性“类名”只能按照“通用”保存!",
				type: "alert"
			});
			return false;
		}
		if (oneRow.eleItmCode == "QueryName" && type != "A") {
			PHA.Popover({
				msg: "属性“Query名”只能按照“通用”保存!",
				type: "alert"
			});
			return false;
		}
		if (oneRow.eleItmCode == "MethodName" && type != "A") {
			PHA.Popover({
				msg: "属性“方法名”只能按照“通用”保存!",
				type: "alert"
			});
			return false;
		}
		oneRow.hospId = hospId;
		oneRow.type = type;
		oneRow.pointer = pointer;
		
		pJsonData.push(oneRow);
	}
	var pJsonStr = JSON.stringify(pJsonData);
	
	// 保存到后台
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'SaveItmSetMulti', pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], -2);
		return false;
	} else {
		PHA.Popover({
			msg: "保存成功!",
			type: "success",
			timeout: 1000
		});
		QueryPageEleItmVal();
		QueryPageItmSet();
	}
	return true;
}

// 列信息设置弹窗
function OpenColumnsSetWin(pageItmSetId) {
	var pageItmSetId = pageItmSetId || "";
	if (pageItmSetId == '') {
		PHA.Popover({
			msg: "属性未保存!",
			type: "alert"
		});
		return;
	}
	// 获取Query信息 (自动加载列信息)
	var retStr = tkMakeServerCall('PHA.SYS.Page.Query', 'GetClassQuery', pageItmSetId);
	var retObj = eval('(' + retStr + ')');
	var clsName = retObj.ClassName;
	var quyName = retObj.QueryName;
	
	// 是否可维护取值表达式
	var colValBtnMsg = '';
	var selPage = $('#gridPage').datagrid('getSelected') || {};
	colValBtnMsg = selPage.pageModel == '' ? '[CSP页面]不能维护取值表达式' : '';
	
	// 表格列信息维窗口 - 公共
	var inputStr = PHA_COM.VAR.PISTable + "^" + pageItmSetId + "^" + clsName + "^" + quyName;
	COLSET_WIN.Open({
		colValBtnMsg: colValBtnMsg,
		showColValBtn: true,
		showGridInfo: false,
		// 列信息 - 查询
		queryParams: {
			ClassName: 'PHA.SYS.Col.Query',
			QueryName: 'PHAINCol',
			inputStr: inputStr
		},
		// 列信息 - 保存
		onClickSave: function(initOpts, gridColsData, gridOptsData, saveType) {
			var jsonColStr = JSON.stringify(gridColsData);
			$.m({
				ClassName: "PHA.SYS.Col.Save",
				MethodName: "SaveForPIPIS",
				jsonColStr: jsonColStr,
				dataType: 'text'
			}, function(retText) {
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("温馨提示", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "保存成功!",
					type: "success"
				});
				COLSET_WIN.Query();
			});
		},
		// 列信息 - 删除
		onClickDelete: function(initOpts, selectedRow, colId){
			$.m({
				ClassName: "PHA.SYS.Col.Save",
				MethodName: "Delete",
				Id: colId
			}, function(retText) {
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("温馨提示", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "删除成功!",
					type: "success"
				});
				COLSET_WIN.Query();
			});
		}
	});
}

function OpenPreviewWin(rowIndex){
	var rowsData = $('#gridPage').datagrid('getRows') || [];
	if (rowsData.length - 1 < rowIndex) {
		return;
	}
	var rowData = rowsData[rowIndex];
	var pageDesc = rowData.pageDesc;
	var pageLink = rowData.pageLink;
	var pageModel = rowData.pageModel;
	
	var _linkUrl = pageLink;
	if (pageModel && pageModel != '') {
		_linkUrl = 'pha.sys.v2.pagecom.csp?code=' + pageLink;
	}
	if ('undefined' !== typeof websys_getMWToken){
		_linkUrl += (_linkUrl.indexOf('?') > 0 ? '&' : '?') + "MWToken=" + websys_getMWToken();
	}
	var w = screen.availWidth - 15;
	var h = screen.availHeight - 65;
	if (isIECore()) {
		var w = screen.availWidth - 28;
		var h = screen.availHeight - 52;
	}
	window.open(_linkUrl, pageDesc, 'height=' + h + ', width=' + w + ', top=0, left=0, toolbar=yes, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	
	// 是否IE
	function isIECore() {
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
			return true;
		} else {
			return false;
		}
	}
}

function IsCanEdit(editRow){
	if (editRow.eleItmCode == "columns") {
		return false;
	}
	var selPage = $('#gridPage').datagrid('getSelected') || {};
	if (selPage.pageModel == '' && editRow.eleItmComFlag != 'Y') {
		PHA.Popover({
			msg: "[CSP页面]不可以编辑非通用属性",
			type: "alert"
		});
		return false;
	}
	var selPageItm = $('#gridPageItm').datagrid('getSelected') || {};
	var pageItmEleCode = selPageItm.pageItmEleCode;
	if (selPage.pageModel == '' && pageItmEleCode == 'hisui-datagrid') {
		if (editRow.eleItmCode == 'ClassName' ||
			editRow.eleItmCode == 'QueryName' ||
			editRow.eleItmCode == 'MethodName') {
			PHA.Popover({
				msg: '[CSP页面]表格的' + editRow.eleItmCode + '属性不可编辑',
				type: "alert"
			});
			return false;
		}
	}
	
	return true;
}

// 常用字典弹窗
function OpenDictWin(){
	var selPage = $('#gridPage').datagrid('getSelected') || {};
	if (selPage.pageModel == '') {
		PHA.Popover({
			msg: "[CSP页面]不能使用此功能！",
			type: "alert"
		});
		return false;
	}
	
	var winId = 'dict_win';
	var gridId = winId + '_grid';
	var findId = winId + '_find';
	var sureId = winId + '_sure';
	var qPackId = winId + '_qPack';
	var qTextId = winId + '_qText';
	
	if ($('#' + winId).length == 0) {
		var layoutHtml = '';
		layoutHtml += '<div id="' + (gridId + '_Bar') + '">';
		layoutHtml += '	<div style="margin-top:5px;margin-bottom:5px;">';
		layoutHtml += '		<div class="pha-col">';
		layoutHtml += '			<input id="' + qPackId + '" class="hisui-validatebox" placeholder="类/包名,PHA.STORE/PHA.IN.Store" style="width:230px;"/>';
		layoutHtml += '		</div>';
		layoutHtml += '		<div class="pha-col">';
		layoutHtml += '			<input id="' + qTextId + '" class="hisui-validatebox" placeholder="模糊检索..." style="width:230px;"/>';
		layoutHtml += '		</div>';
		layoutHtml += '		<div class="pha-col">';
		layoutHtml += '			<a id="' + findId + '" class="hisui-linkbutton" iconCls="icon-w-find">' + $g('查询') + '</a>';
		layoutHtml += '		</div>';
		layoutHtml += '		<div class="pha-col">';
		layoutHtml += '			<a id="' + sureId + '" class="hisui-linkbutton" iconCls="icon-w-save">' + $g('确认') + '</a>';
		layoutHtml += '		</div>';
		layoutHtml += '	</div>';
		layoutHtml += '</div>';
		layoutHtml += '<div class="hisui-layout" fit="true">';
		layoutHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
		layoutHtml += '		<div class="hisui-panel" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true" title="">';
		layoutHtml += '			<table id="' + gridId + '"></table>';
		layoutHtml += '		</div>';
		layoutHtml += '	</div>';
		layoutHtml += '</div>';
		// 弹窗
		$('body').append('<div id="' + winId + '"></div>');
		$('#' + winId).dialog({
			title: '常用字典',
			collapsible: false,
			minimizable: false,
			iconCls: "icon-w-book",
			border: false,
			closed: true,
			modal: true,
			width: 725,
			height: 500,
			content: layoutHtml
		});
		$('#' + winId).dialog('open');
		// 表格
		var columns = [
			[{
					field: 'mqDesc',
					title: '字典描述',
					width: 100
				}, {
					field: 'mqInfo',
					title: '字典代码',
					width: 100,
					formatter: function (value, rowData, rowIndex) {
						if (rowData.QueryName) {
							return rowData.ClassName + ':' + rowData.QueryName;
						}
						if (rowData.MethodName) {
							return rowData.ClassName + ':' + rowData.MethodName;
						}
						return '';
					}
				}
			]
		];
		var dataGridOption = {
			url: '',
			queryParams: {
				ClassName: 'PHA.SYS.Page.Query',
				QueryName: 'ComDict'
			},
			columns: columns,
			pagination: true,
			fitColumns: true,
			toolbar: '#' + gridId + '_Bar',
			enableDnd: false,
			onRowContextMenu: function () {},
			onDblClickRow: function (rowIndex, rowData) {
				SetDictInfo(rowData);
				$('#' + winId).dialog('close');
			},
			onSelect: function (rowIndex, rowData) {},
			onLoadSuccess: function (data) {},
			gridSave: false
		};
		PHA.Grid(gridId, dataGridOption);
		
		// 事件
		$('#' + findId).on('click', QueryDict);
		$('#' + qPackId).on('keydown', function(e){
			if (e.keyCode == 13) {
				QueryDict();
			}
		});
		$('#' + qTextId).on('keydown', function(e){
			if (e.keyCode == 13) {
				QueryDict();
			}
		});
		$('#' + sureId).on('click', function(){
			var selRow = $('#' + gridId).datagrid('getSelected');
			if (selRow) {
				SetDictInfo(selRow);
				$('#' + winId).dialog('close');
			} else {
				PHA.Popover({
					msg: "请选择字典",
					type: "alert"
				});
			}
		});
	}
	$('#' + winId).dialog('open');
	$('#' + qTextId).focus();
	
	function QueryDict(){
		var QPack = $('#' + qPackId).val();
		var QText = $('#' + qTextId).val();
		$('#' + gridId).datagrid('options').url = $URL;
		$('#' + gridId).datagrid('query', {
			inputStr: QPack + '^' + QText
		});
	}
	QueryDict();
}

// 自动填写字典信息 (不能使用updateRow)
function SetDictInfo(queryInfo){
	var eleItmValRows = $('#gridPageEleItmVal').datagrid('getRows');
	if (!eleItmValRows) {
		return;
	}
	var firstEditIdx = -1;
	// 先清空
	for (var i = 0; i < eleItmValRows.length; i++) {
		var eleItmValRow = eleItmValRows[i];
		var eleItmCode = eleItmValRow.eleItmCode;
		if (typeof queryInfo[eleItmCode] != 'undefined') {
			$('#gridPageEleItmVal').datagrid('beginEdit', i);
			var ed = $('#gridPageEleItmVal').datagrid("getEditor", {
				index: i,
				field: 'pageItmSetEleItmVal'
			});
			$(ed.target).val('');
            $('#gridPageEleItmVal').datagrid("endEdit", i);
			firstEditIdx = firstEditIdx < 0 ? i : firstEditIdx;
		}
	}
	// 再重写
	for (var i = 0; i < eleItmValRows.length; i++) {
		var eleItmValRow = eleItmValRows[i];
		var eleItmCode = eleItmValRow.eleItmCode;
		if (typeof queryInfo[eleItmCode] != 'undefined') {
			$('#gridPageEleItmVal').datagrid('beginEdit', i);
			var ed = $('#gridPageEleItmVal').datagrid("getEditor", {
				index: i,
				field: 'pageItmSetEleItmVal'
			});
			$(ed.target).val(queryInfo[eleItmCode]);
            $('#gridPageEleItmVal').datagrid("endEdit", i);
            firstEditIdx = firstEditIdx < 0 ? i : firstEditIdx;
		}
	}
	// 开始编辑
	if (firstEditIdx >= 0) {
		PHA_GridEditor.Edit({
			gridID: "gridPageEleItmVal",
			index: firstEditIdx,
			field: 'pageItmSetEleItmVal'
		});
	}
}


function UpAndDownItm(e){
	if ($('#btnUpItm').prop('disabled') == 'disabled') {
		PHA.Popover({
			msg: '您点击太快!',
			type: 'alert'
		});
		return;
	}
	var ret = PHA_GridEditor.__UpAndDown_Exchange({
		gridID: 'gridPageItm',
		ifUp: (e.currentTarget.id.indexOf('Up') > 0 ? true : false)
	});
	if (!ret) {
		return;
	}
	
	var selectedRow = $('#gridPageItm').datagrid('getSelected');
	var selectedRowIndex = $('#gridPageItm').datagrid('getRowIndex', selectedRow);
	$('#gridPageItm').datagrid('options').selectedRowIndex = selectedRowIndex;
	
	$('#btnUpItm').prop('disabled', 'disabled');
	$('#btnDownItm').prop('disabled', 'disabled');
	var rowsData = $('#gridPageItm').datagrid('getRows');
	var pJsonStr = JSON.stringify(rowsData);
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.Page.Save',
		MethodName: 'UpdateItmSort',
		pJsonStr: pJsonStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('温馨提示', saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: '操作成功!',
			type: 'success'
		});
		QueryPageItm();
	}
}