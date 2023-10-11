/**
 * ����:	 ҩ������-ϵͳ����-ҳ������
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 * Update:   Huxt 2020-02-27
 * pha/sys/v1/pageset.js
 */

PHA_COM.App.Csp = "pha.sys.v1.pageset.csp";
PHA_COM.App.Name = "ҳ������";
PHA_COM.App.ProCode = "SYS";
PHA_COM.App.ProDesc = "ϵͳ����";
PHA_COM.App.ParamMethod = "";

PHA_COM.VAR = {
	valColor: '#0538f2',
	timer: null,
	previewIncon: '../scripts_lib/hisui-0.1.0/dist/css/icons/search.png',
	PISTable: 'CF_PHA_IN.PageItmSet'
}

// ҳ��������
$(function () {
	PHA_COM.ResizePanel({
		layoutId: 'layout-right',
		region: 'north',
		height: 0.48
	});

	// �ֵ�
	InitDict();
	// ������
	InitGridPage();
	InitGridPageItm();
	InitGridPageEleItm();
	InitGridPageItmSet();
	// �¼�
	InitEvents();
	QueryPage();
});

/**
 * @description: ��ʼ�����ֵ�
 */
function InitDict() {
	PHA.ComboBox("proId", {
		width: 345,
		placeholder: '��Ʒ��...',
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
		placeholder: "ҳ�����ӡ����ƻ��ƴ..."
	});
}

/**
 * @description: ���¼�
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
 * @description: ��ʼ��ҳ��
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
				title: '��Ʒ��',
				width: 50
			}, {
				field: "pageDesc",
				title: '����',
				width: 150,
				formatter: function (value, rowData, rowIndex) {
					if (rowData.pageModel && rowData.pageModel != '') {
						return value + " <label style='color:#017bce;cursor:pointer;' onclick=OpenModelSetWin('" + rowData.pageId + "')>[" + rowData.pageLink + "]</label>";
					}
					return value + " <label style='color:gray;'>[" + rowData.pageLink + "]</label>";
				}
			}, {
				field: "pageLink",
				title: '����',
				hidden: true,
				width: 150
			}, {
				field: "pagePreview",
				title: 'Ԥ��',
				width: 45,
				fixed: true,
				align: 'center',
				hidden: true,
				formatter: function (value, rowData, rowIndex) {
					if (typeof rowData.pageModel == 'string' && rowData.pageModel != '') {
						return '<div><img src="' + PHA_COM.VAR.previewIncon + '" style="border:0px;cursor:pointer;margin-top:5px;" onclick=OpenPreviewWin("' + rowIndex + '") title="' + $g('���Ԥ��') + '"/></div>';
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
// ��page.js�����һ��,���޸���ͬʱ�޸�
function OpenModelSetWin(pageId){
	// ��ʾ����
	var winId = 'model_set_win';
	if ($('#' + winId).length == 0) {
		var tipImg = '../scripts_lib/hisui-0.1.0/dist/css/icons/tip.png';
		var layoutHtml = '';
		layoutHtml += '<div style="margin:0 10px 0 10px">';
		layoutHtml += '	<table cellspacing="10">';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="cols">' + $g('����������') + '</label></td>';
		layoutHtml += '			<td><input id="cols" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('���ñ���������') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="width">' + $g('��������') + '</label></td>';
		layoutHtml += '			<td><input id="width" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ҳ��ģ��Ϊ���ҽṹʱ��������������(���ֻ����)������ģ��������Ч') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="height">' + $g('�ϲ����߶�') + '</label></td>';
		layoutHtml += '			<td><input id="height" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ҳ��ģ��Ϊ���½ṹʱ�������ϲ����߶�(���ֻ����)������ģ��������Ч') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="pkey">' + $g('��ѯ����') + '</label></td>';
		layoutHtml += '			<td><input id="pkey" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ѯʱ���η�ʽ�����ݱ���ѯ��̨�ķ������ã������̨��ѯQuery�������ΪInputStr�˴�����InputStr����д�˲�����Ὣ���б�ֵ��Ϊjson�����ݵ���̨������˲���Ĭ�ϰ��յ������������ݡ�') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '		<tr>';
		layoutHtml += '			<td style="text-align:right"><label for="query">' + $g('�Զ���ѯ') + '</label></td>';
		layoutHtml += '			<td><input id="query" class="hisui-checkbox" data-pha="class:\'hisui-checkbox\',save:true,query:true,clear:true" type="checkbox" /></td>';
		layoutHtml += '			<td><img src="' + tipImg + '" title="' + $g('��ҳ��������ʱ�Ƿ��Զ�������ѯ��') + '" class="hisui-tooltip" data-options="position:\'right\'" style="cursor:pointer;margin-top:5px;"></td>';
		layoutHtml += '		</tr>';
		layoutHtml += '	</table>';
		layoutHtml += '</div>';
		$('body').append('<div id="' + winId + '"></div>');
		$('#' + winId).dialog({
			title: 'ҳ��ģ������',
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
				text: '����',
				handler: saveOtherCfg
			},{
				text: '�ر�',
				handler: function(){
					$('#' + winId).dialog('close');
				}
			}]
		});
	}
	$('#' + winId).dialog('open');
	$('#' + winId).attr('pageId', pageId);
	// ��ʾ����
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
	// ��������
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
				PHA.Alert("��ܰ��ʾ", lb + "��" + "����������", -1);
				isErr = true;
				return false;
			}
			if (parseFloat(pJson[this.id]) <= 0) {
				PHA.Alert("��ܰ��ʾ", lb + "��" + "���ֲ���С��0", -1);
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
			return PHA.Alert("��ܰ��ʾ", retArr[1], retArr[0]);
		}
		$('#' + winId).dialog('close');
		PHA.Popover({
			msg: "����ɹ�!",
			type: "success"
		});
	}
}

/**
 * @description: ��ʼ��ҳ��Ԫ���б�
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
				title: '����',
				width: 100
			}, {
				field: "pageItmEleDR",
				title: 'pageItmEleDR',
				width: 100,
				hidden: true
			}, {
				field: "pageItmEleDesc",
				title: 'Ԫ������',
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
 * @description: ���-Ԫ������
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
				title: '���Դ���',
				width: 150,
				hidden: true
			}, {
				field: "eleItmDesc",
				title: "<label style='font-weight:bold'>" + $g('��������') + "</label>",
				width: 150,
				trans: false,
				formatter: function (value, rowData, rowIndex) {
					return value + " <label style='color:gray;'>[" + rowData.eleItmCode + "]</label>";
				}
			}, {
				field: "eleItmValType",
				title: '����',
				width: 100,
				hidden: true
			}, {
				field: "eleItmMemo",
				title: '˵��',
				width: 410,
				showTip: true,
				tipWidth: 300,
				hidden: true
			}, {
				field: "eleItmActive",
				title: '����',
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
 * @description: ��ʼ��ҳ��Ԫ�������б�
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
				title: "<label style='font-weight:bold'>" + $g('����ֵ') + "</label>",
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
				title: 'ҽԺID',
				hidden: true,
				width: 80
			}, {
				field: "hospDesc",
				title: 'ҽԺ',
				width: 180
			}, {
				field: "pageItmSetType",
				title: '����Code',
				hidden: true,
				width: 80
			}, {
				field: "pageItmSetTypeDesc",
				title: '����',
				width: 80
			}, {
				field: "pageItmSetPointer",
				title: '����ֵID',
				hidden: true,
				width: 100
			}, {
				field: "pageItmSetPointerDesc",
				title: '����ֵ',
				width: 140
			}, {
				field: "pageItmSetEleItmDR",
				title: '����ID',
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
			// ���ж��Ƿ�ɱ༭
			var rowsData = $(this).datagrid('getRows');
			var rowData = rowsData[index];
			if (!IsCanEdit(rowData)) {
				return;
			}
			// Ȼ��ʼ�༭
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
	var hospId = ""; // Ԥ��
	
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
			msg: "����δ�����ı䣬����Ҫ����!",
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
	
	// ���浽��̨
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'SaveItmSetMulti', pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("��ܰ��ʾ", retArr[1], -2);
		return false;
	} else {
		PHA.Popover({
			msg: "����ɹ�!",
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
			msg: "��ѡ��һ�����ݣ�",
			type: "alert"
		});
		return;
	}
	var pageItmSetId = selRow.pageItmSetId || "";
	
	PHA.Confirm("��ܰ��ʾ", "�Ƿ�ȷ��ɾ����", function () {
		if (pageItmSetId == "") {
			var rowIndex = $("#gridPageItmSet").datagrid('getRowIndex', selRow);
			$("#gridPageItmSet").datagrid('deleteRow', rowIndex);
			return;
		}
		
		// ���浽��̨
		var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'DeleteItmSet', pageItmSetId);
		var retArr = retStr.split('^');
		if (retArr[0] < 0) {
			PHA.Alert("��ܰ��ʾ", retArr[1], -2);
			return false;
		} else {
			PHA.Popover({
				msg: "ɾ���ɹ�!",
				type: "success"
			});
			QueryPageItmSet();
		}
	});
}

/**
 * �������ƹ���
 * 2023-04-21 Huxt
 */
function CopyItmSet(){
	var selRow = $("#gridPageItmSet").datagrid('getSelected');
	if (selRow == null) {
		PHA.Popover({
			msg: "��ѡ��һ�����ݣ�",
			type: "alert"
		});
		return;
	}
	var pageItmSetId = selRow.pageItmSetId || "";
	if (pageItmSetId == '') {
		PHA.Popover({
			msg: "��ѡ��һ�����ݣ�",
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
        layoutHtml += '                    <label for="fromHospId"><span style="color:red">*</span>' + $g('ҽԺ') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromHospId" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '                <td style="padding-left:30px;padding-right:10px;"></td>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toHospId"><span style="color:red">*</span>' + $g('ҽԺ') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="toHospId" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '            </tr>';
        layoutHtml += '            <tr>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="fromType"><span style="color:red">*</span>' + $g('����') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromType" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '                <td style="padding-left:30px;padding-right:10px;" rowspan="2">';
        layoutHtml += '                    <span class="icon icon-arrow-right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toType"><span style="color:red">*</span>' + $g('����') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="toType" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" />';
        layoutHtml += '                </td>';
        layoutHtml += '            </tr>';
        layoutHtml += '            <tr>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="fromPointer"><span style="color:red">*</span>' + $g('����ֵ') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromPointer" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" style="width:233px;" />';
        layoutHtml += '                </td>';
        layoutHtml += '                <!-- <td style="padding-left:30px;padding-right:10px;"></td> -->'; // ����ռ����
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toPointer"><span style="color:red">*</span>' + $g('����ֵ') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="toPointer" class="hisui-combobox" data-pha="class:\'hisui-combobox\',save:true,query:true,clear:true,required:true" style="width:233px;" />';
        layoutHtml += '                </td>';
        layoutHtml += '            </tr>';
        layoutHtml += '            <tr>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="fromValue"><span style="color:red">*</span>' + $g('ԭʼֵ') + '</label>';
        layoutHtml += '                </td>';
        layoutHtml += '                <td>';
        layoutHtml += '                    <input id="fromValue" class="hisui-validatebox" data-pha="class:\'hisui-validatebox\',save:true,query:true,clear:true,required:true" style="width:173px;" disabled />';
        layoutHtml += '                </td>';
        layoutHtml += '                <td style="padding-left:30px;padding-right:10px;"></td>';
        layoutHtml += '                <td class="r-label">';
        layoutHtml += '                    <label for="toValue"><span style="color:red">*</span>' + $g('����ֵ') + '</label>';
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
			title: '����Ԫ������',
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
				text: '����',
				handler: SaveCopyItmSet
			},{
				text: '�ر�',
				handler: function(){
					$('#' + winId).dialog('close');
				}
			}]
		}).dialog('open');
		
		// ҽԺ
		PHA.ComboBox('fromHospId', {
			url: PHA_STORE.CTHospital().url,
			width: 180,
			disabled: true
		});
		PHA.ComboBox('toHospId', {
			url: PHA_STORE.CTHospital().url,
			width: 180
		});
		// ����
		var typeData = [{
			RowId: 'A',
			Description: $g('ͨ��')
		}, {
			RowId: 'L',
			Description: $g('����')
		}, {
			RowId: 'G',
			Description: $g('��ȫ��')
		}, {
			RowId: 'U',
			Description: $g('�û�')
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
		// ����ֵ
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
	
	// �������Pointer�ķ���
	function _reload_to_pointer(type){
		$('#toPointer').combobox('loadData', []);
		$('#toPointer').combobox('setValue', '');
		$('#toPointer').combobox('setText', '');
		
		if (type == 'A') {
			$('#toPointer').combobox('loadData', [
				{
					RowId: '0',
					Description: $g('ͨ��')
				}
			]);
			$('#toPointer').combobox('setValue', '0');
			$('#toPointer').combobox('setText', $g('ͨ��'));
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
	
	// ���浽��̨
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'SaveCopyItmSet', pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("��ܰ��ʾ", retArr[1], -2);
		return false;
	} else {
		PHA.Popover({
			msg: "����ɹ�",
			type: "success"
		});
		QueryPageItmSet();
		$('#' + winId).dialog('close');
	}
}

// ��ȡѡ�е��е�ID
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
// Ԫ������ֵ���õ���
function EleItmValSetWin() {
	// ��֤
	if (GetPageItmId() == "") {
		PHA.Popover({
			msg: "����ѡ��ҳ��Ԫ��!",
			type: "alert"
		});
		return;
	}

	// ���崰�ڵĻ�������
	var winWidth = 920;
	var winHeight = parseInt($(window).height() * 0.9);
	var winId = "win_page_set";
	var winContentId = winId + "_" + "content";
	var contentHtml = "";
	contentHtml += '<div class="hisui-layout" fit="true">';
	contentHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
	contentHtml += '		<div class="hisui-layout" fit="true">';
	contentHtml += '			<div data-options="region:\'west\',border:false,split:true,width:405">';
	contentHtml += '				<div class="hisui-panel" title="' + $g('����') + '" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true,bodyCls:\'\'">';
	contentHtml += '					<table id="gridAuth"></table>';
	contentHtml += '				</div>';
	contentHtml += '			</div>';
	contentHtml += '			<div data-options="region:\'center\',border:false,split:true">';
	contentHtml += '				<div id="panelPageEleItmVal" class="hisui-panel" title="' +$g('�����б�') + '" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true,bodyCls:\'\'">';
	contentHtml += '					<table id="gridPageEleItmVal"></table>';
	contentHtml += '				</div>';
	contentHtml += '			</div>';
	contentHtml += '		</div>';
	contentHtml += '	</div>';
	contentHtml += '</div>';

	// ���ڳ�ʼ��(��һ��)
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: winWidth,
			height: winHeight,
			modal: true,
			draggable: false,
			title: '����Ԫ������ֵ',
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

	// �򿪴���
	var pageDesc = ($("#gridPage").datagrid("getSelected") || {}).pageDesc || "";
	var pageItmDesc = ($("#gridPageItm").datagrid("getSelected") || {}).pageItmDesc || "";
	var pageItmEleDesc = ($("#gridPageItm").datagrid("getSelected") || {}).pageItmEleDesc || "";
	var newTitle = (pageDesc + AddColor("(ҳ��)")) + " - " + (pageItmDesc + AddColor("(" + pageItmEleDesc + ")"));
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

// ��ʼ�� - �����¼�
function InitWinEvents() {
	$('#btnSave').on('click', SavePageEleItmVal);
	$('#btnReload').on('click', QueryPageEleItmVal);
}

// ��ʼ�� - �����ֵ�
function InitWinDict() {
	PHA.SearchBox("conAuthAlias", {
		placeholder: "�������ƴ�����ƻس���ѯ",
		width: 332,
		searcher: function () {
			QueryPageEleItmVal();
			QueryAuth();
		}
	});
	PHA.ComboBox("combHosp", {
		placeholder: '��ѡ��ҽԺ...',
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

// ��ʼ�� - Ȩ�޹ؼ���(��Ϊ��ѯ����)
function InitKeyWords() {
	$("#kwAuthType").keywords({
		singleSelect: true,
		labelCls: 'blue',
		items: [{
				text: '�û�',
				id: 'U'
			}, {
				text: '��ȫ��',
				id: 'G'
			}, {
				text: '����',
				id: 'L'
			}, {
				text: 'ͨ��',
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
				text: 'δ��',
				id: 'N',
				selected: true
			}, {
				text: '����',
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

// ��ʼ�� - Ȩ���б�
function InitGridAuth() {
	var columns = [
		[{
				field: "authId",
				title: 'Ȩ��Id',
				hidden: true,
				width: 100
			}, {
				field: "authCode",
				title: '����',
				width: 125
			}, {
				field: "authDesc",
				title: '����',
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
// ��ѯ - Ȩ���б�
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

// ��ʼ�� - Ԫ������ֵ�б�
function InitGridPageEleItmVal() {
	var columns = [
		[{
				field: "eleItmId",
				title: 'eleItmId',
				hidden: true,
				width: 100
			}, {
				field: "eleItmDesc",
				title: '��������',
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
				title: '����ֵ',
				width: 150,
				formatter: function (value, rowData, rowIndex) {
					if (rowData.eleItmCode == "columns") {
						if (value == "") {
							return "<label style='color:gray;border:0px;cursor:pointer'>" + $g("����Ȼ��������ά������...") + "</label>";
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
				title: '��ʾ',
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
			// ���ж��Ƿ�ɱ༭
			var rowsData = $(this).datagrid('getRows');
			var rowData = rowsData[index];
			if (!IsCanEdit(rowData)) {
				return;
			}
			// Ȼ��ʼ�༭
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
			// Ĭ��ѡ��
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
// ��ѯ - Ԫ������ֵ�б�
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
// ���� - Ԫ������ֵ�б�
function SavePageEleItmVal() {
	$("#gridPageEleItmVal").datagrid('endEditing');
	
	// ��ȡ����
	var hospId = $("#combHosp").combobox('getValue') || "";
	var type = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var pointer = ($("#gridAuth").datagrid("getSelected") || {}).authId || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "��ѡ��ҽԺ!",
			type: "alert"
		});
		return false;
	}
	if (type == "") {
		PHA.Popover({
			msg: "��ѡ������:�û�/����/��ȫ��/ͨ��!",
			type: "alert"
		});
		return false;
	}
	if (pointer == "" && type != "A") {
		PHA.Popover({
			msg: "�ǡ�ͨ�á����ã���Ҫѡ������б��е�����ֵ!",
			type: "alert"
		});
		return false;
	}
	if (type == "A") {
		pointer = 0;
	}
	
	// ������
	var pJsonData = [];
	// ��ȡ�����������е�����
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
	// ��֤ҳ��
	var rowsJsonStr = JSON.stringify(rowsData);
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'CheckEleItmValRela', rowsJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("��ܰ��ʾ", retArr[1], -2);
		return false;
	}
	// ��ȡ�����ı������ֵ
	var changesData = $('#gridPageEleItmVal').datagrid('getChanges');
	if ((changesData == null || changesData.length == 0) && (pJsonData.length == 0)) {
		PHA.Popover({
			msg: "����δ�����ı䣬����Ҫ����!",
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
				msg: "���ԡ�������ֻ�ܰ��ա�ͨ�á�����!",
				type: "alert"
			});
			return false;
		}
		if (oneRow.eleItmCode == "QueryName" && type != "A") {
			PHA.Popover({
				msg: "���ԡ�Query����ֻ�ܰ��ա�ͨ�á�����!",
				type: "alert"
			});
			return false;
		}
		if (oneRow.eleItmCode == "MethodName" && type != "A") {
			PHA.Popover({
				msg: "���ԡ���������ֻ�ܰ��ա�ͨ�á�����!",
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
	
	// ���浽��̨
	var retStr = tkMakeServerCall('PHA.SYS.Page.Save', 'SaveItmSetMulti', pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("��ܰ��ʾ", retArr[1], -2);
		return false;
	} else {
		PHA.Popover({
			msg: "����ɹ�!",
			type: "success",
			timeout: 1000
		});
		QueryPageEleItmVal();
		QueryPageItmSet();
	}
	return true;
}

// ����Ϣ���õ���
function OpenColumnsSetWin(pageItmSetId) {
	var pageItmSetId = pageItmSetId || "";
	if (pageItmSetId == '') {
		PHA.Popover({
			msg: "����δ����!",
			type: "alert"
		});
		return;
	}
	// ��ȡQuery��Ϣ (�Զ���������Ϣ)
	var retStr = tkMakeServerCall('PHA.SYS.Page.Query', 'GetClassQuery', pageItmSetId);
	var retObj = eval('(' + retStr + ')');
	var clsName = retObj.ClassName;
	var quyName = retObj.QueryName;
	
	// �Ƿ��ά��ȡֵ���ʽ
	var colValBtnMsg = '';
	var selPage = $('#gridPage').datagrid('getSelected') || {};
	colValBtnMsg = selPage.pageModel == '' ? '[CSPҳ��]����ά��ȡֵ���ʽ' : '';
	
	// �������Ϣά���� - ����
	var inputStr = PHA_COM.VAR.PISTable + "^" + pageItmSetId + "^" + clsName + "^" + quyName;
	COLSET_WIN.Open({
		colValBtnMsg: colValBtnMsg,
		showColValBtn: true,
		showGridInfo: false,
		// ����Ϣ - ��ѯ
		queryParams: {
			ClassName: 'PHA.SYS.Col.Query',
			QueryName: 'PHAINCol',
			inputStr: inputStr
		},
		// ����Ϣ - ����
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
					PHA.Alert("��ܰ��ʾ", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "����ɹ�!",
					type: "success"
				});
				COLSET_WIN.Query();
			});
		},
		// ����Ϣ - ɾ��
		onClickDelete: function(initOpts, selectedRow, colId){
			$.m({
				ClassName: "PHA.SYS.Col.Save",
				MethodName: "Delete",
				Id: colId
			}, function(retText) {
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("��ܰ��ʾ", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "ɾ���ɹ�!",
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
	
	// �Ƿ�IE
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
			msg: "[CSPҳ��]�����Ա༭��ͨ������",
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
				msg: '[CSPҳ��]����' + editRow.eleItmCode + '���Բ��ɱ༭',
				type: "alert"
			});
			return false;
		}
	}
	
	return true;
}

// �����ֵ䵯��
function OpenDictWin(){
	var selPage = $('#gridPage').datagrid('getSelected') || {};
	if (selPage.pageModel == '') {
		PHA.Popover({
			msg: "[CSPҳ��]����ʹ�ô˹��ܣ�",
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
		layoutHtml += '			<input id="' + qPackId + '" class="hisui-validatebox" placeholder="��/����,PHA.STORE/PHA.IN.Store" style="width:230px;"/>';
		layoutHtml += '		</div>';
		layoutHtml += '		<div class="pha-col">';
		layoutHtml += '			<input id="' + qTextId + '" class="hisui-validatebox" placeholder="ģ������..." style="width:230px;"/>';
		layoutHtml += '		</div>';
		layoutHtml += '		<div class="pha-col">';
		layoutHtml += '			<a id="' + findId + '" class="hisui-linkbutton" iconCls="icon-w-find">' + $g('��ѯ') + '</a>';
		layoutHtml += '		</div>';
		layoutHtml += '		<div class="pha-col">';
		layoutHtml += '			<a id="' + sureId + '" class="hisui-linkbutton" iconCls="icon-w-save">' + $g('ȷ��') + '</a>';
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
		// ����
		$('body').append('<div id="' + winId + '"></div>');
		$('#' + winId).dialog({
			title: '�����ֵ�',
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
		// ���
		var columns = [
			[{
					field: 'mqDesc',
					title: '�ֵ�����',
					width: 100
				}, {
					field: 'mqInfo',
					title: '�ֵ����',
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
		
		// �¼�
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
					msg: "��ѡ���ֵ�",
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

// �Զ���д�ֵ���Ϣ (����ʹ��updateRow)
function SetDictInfo(queryInfo){
	var eleItmValRows = $('#gridPageEleItmVal').datagrid('getRows');
	if (!eleItmValRows) {
		return;
	}
	var firstEditIdx = -1;
	// �����
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
	// ����д
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
	// ��ʼ�༭
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
			msg: '�����̫��!',
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
		PHA.Alert('��ܰ��ʾ', saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: '�����ɹ�!',
			type: 'success'
		});
		QueryPageItm();
	}
}