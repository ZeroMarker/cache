/*
 * ����:	 ����ҩƷ���� - ���һ�������
 * ��д��:	 Huxt
 * ��д����: 2021-08-10
 * csp:      pha.in.v1.narcbase.csp
 * js:       pha/in/v1/narcbase.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = $g('ҩ��');
PHA_COM.App.Csp = 'pha.in.v1.narcbase.csp';
PHA_COM.App.Name = $g('���ҿ�����ά��');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};

$(function () {
	if (!PHA_COM.IsTabsMenu()){
		var pOpts = $('#panelNarcDrug').panel('options');
		$('#panelNarcDrug').panel('setTitle', PHA_COM.App.Name + ' - ' + pOpts.title);
	}
	
	InitDict();
	InitGridNarcDrug();
	InitGridNarcDrugBat();
	InitEvents();
	InitConfig();
});

function InitEvents(){
	$('#btnFindNarcDrug').on('click', QueryNarcDrug);
	$('#btnClearNarcDrug').on('click', ClearNarcDrug);
	$('#btnFindNarcDrugBat').on('click', QueryNarcDrugBat);
	$('#btnClearNarcDrugBat').on('click', ClearNarcDrugBat);
	$('#btnSave').on('click', BeforeSave);
	$('#inciText').on('keydown', function(e){
		if (e.keyCode == 13) {
			QueryNarcDrug();
		}
	});
	$('#closeReason').on('click', function(){
		$('#dialogSelReason').dialog('close');
	});
	$('#saveReason').on('click', function(){
		Save();
		$('#dialogSelReason').dialog('close');
	});
}

function InitDict(){
	PHA.ComboBox('baseLocId', {
		required: true,
		placeholder: '��������...',
		disabled: true,
		url: PHA_STORE.CTLoc().url,
		onSelect: function (rowData) {
			QueryNarcDrugBat();
		}
	});
	PHA.ComboBox('baseStatus', {
		placeholder: '���״̬...',
		panelHeight: 'auto',
		data: [
			{RowId: 'A', Description: $g('ȫ��')},
			{RowId: 'Y', Description: $g('�п��')},
			{RowId: 'N', Description: $g('�޿��')}
		]
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '���Ʒ���...',
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		width: 295
	});
	
	PHA.ComboBox("adjReason", {
		placeholder: '����ԭ��...',
		mode: 'remote',
		width: 260,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=ComDic',
		onBeforeLoad: function (param) {
			var scdiType = 'NARCAdjReason';
			var valType = 'Code';
			var QText = param.q || '';
			param.InputStr = scdiType + '^' + valType + '^' + QText;
		}
	});
	
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('baseLocId', PHA_COM.VAR.locId);
	PHA.SetComboVal('baseStatus', 'A');
	PHA.SetComboVal('adjReason', '1');
}

// ��ʼ�� - ���
function InitGridNarcDrug() {
	var columns = [[{
				field: 'inci',
				title: '�����ID',
				width: 100,
				hidden: true
			}, {
				field: 'inciCode',
				title: 'ҩƷ����',
				width: 140,
				hidden: true
			}, {
				field: 'inciDesc',
				title: 'ҩƷ����',
				width: 200
			}, {
				field: 'inciSpec',
				title: '���',
				width: 100
			}, {
				field: 'poisonDesc',
				title: '���Ʒ���',
				width: 100
			}, {
				field: 'showDetail',
				title: '����',
				width: 45,
				fixed: true,
				formatter: function(value, rowData, rowIndex){
					return "<a class='pha-detail-tips' rowIndex='" + rowIndex + "'>" + $g("����") + "</a>";
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcBase.Query',
			QueryName: 'NarcDrug',
			hospId: PHA_COM.VAR.hospId
		},
		fitColumns: true,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridNarcDrugBar',
		onSelect: function (rowIndex, rowData) {
			QueryNarcDrugBat();
		},
		onLoadSuccess: function (data) {
			$('#gridNarcDrugBat').datagrid('loadData', []);
			$(".pha-detail-tips").each(function(){
				var rowIndex = $(this).attr('rowIndex');
				var rowsData = $('#gridNarcDrug').datagrid('getRows');
				var rowData = rowsData[rowIndex];
				var contentHtml = '';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩƷ����') + '��</font>' + rowData.inciCode + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩƷ����') + '��</font>' + rowData.inciDesc + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩƷ���') + '��</font>' + rowData.inciSpec + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('���Ʒ���') + '��</font>' + rowData.poisonDesc + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('ҩѧ����') + '��</font>' + rowData.phccDescAll + '</p>';
				$(this).popover({
					placement: 'auto',
					trigger: 'hover',
					title: 'ҩƷ����',
					content: contentHtml
				});
			});
		}
	};
	PHA.Grid('gridNarcDrug', dataGridOption);
}

// ��ʼ�� - ���
function InitGridNarcDrugBat() {
	var columns = [[{
				field: 'incib',
				title: '����ID',
				width: 100,
				hidden: true
			}, {
				field: 'pinb',
				title: '����',
				width: 100,
				hidden: true
			}, {
				field: 'baseLocDesc',
				title: '��������',
				width: 130
			}, {
				field: 'batNo',
				title: '����',
				width: 130
			}, {
				field: 'expDate',
				title: 'Ч��',
				width: 95
			}, {
				field: 'displayQty',
				title: GetEditTitle('������'),
				width: 100,
				align: 'right',
				editor: PHA_GridEditor.NumberBox({})
			}, {
				field: 'displayUomId',
				descField: 'displayUomDesc',
				title: GetEditTitle('��λ'),
				width: 90,
				formatter: function (value, rowData, rowIndex) {
					return rowData["displayUomDesc"];
				},
				editor: PHA_GridEditor.ComboBox({
					mode: 'remote',
					url: $URL + '?ResultSetType=Array&ClassName=PHA.IN.NarcBase.Query&QueryName=DrugUom',
					onBeforeLoad: function (param) {
						var selRow = $('#gridNarcDrug').datagrid('getSelected');
						if (selRow == null) {
							return;
						}
						param.inci = selRow.inci || "";
					}
				})
			}, {
				title: "�Ƿ����",
				field: "active",
				width: 70,
				align: "center",
				formatter: function (value, rowData, rowIndex) {
					var fmtStr = '<label style="border:0px;cursor:pointer;" title="'+$g('����޸Ŀ���״̬')+'" onclick=UpdateActive(' + rowIndex + ')>';
					if (value == 'Y') {
						fmtStr += '<font color="#21ba45">'+$g('��')+'</font>';
					} else {
						fmtStr += '<font color="#f16e57">'+$g('��')+'</font>';
					}
					fmtStr += '</label>';
					return fmtStr;
				},
			}, {
				field: 'baseQty',
				title: '������λ����',
				width: 90,
				hidden: true
			}, {
				field: 'baseUomDesc',
				title: '������λ',
				width: 90,
				hidden: true
			}, {
				field: 'vendDesc',
				title: '��Ӫ��ҵ',
				width: 170
			}, {
				field: 'manfName',
				title: '������ҵ',
				width: 170
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcBase.Query',
			QueryName: 'NarcDrugBat',
			hospId: PHA_COM.VAR.hospId
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridNarcDrugBatBar',
		onSelect: function (rowIndex, rowData) {},
		allowEnd: true,
		isAutoShowPanel: true,
		editFieldSort: ['displayQty', 'displayUomId'],
		onDblClickCell: function(index, field, value){
			PHA_GridEditor.Edit({
				gridID: 'gridNarcDrugBat',
				index: index,
				field: field
			});
		},
		onClickCell: function(index, field, value){
			PHA_GridEditor.End('gridNarcDrugBat');
		},
		onLoadSuccess: function (data) {
			PHA_GridEditor.End('gridNarcDrugBat');
		}
	};
	PHA.Grid('gridNarcDrugBat', dataGridOption);
}

function QueryNarcDrug(){
	var formDataArr = PHA.DomData("#gridNarcDrugBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	
	$('#gridNarcDrug').datagrid('options').url = $URL;
	$('#gridNarcDrug').datagrid('query', {
		pJsonStr: JSON.stringify(formData),
		hospId: PHA_COM.VAR.hospId
	});
}

function QueryNarcDrugBat(){
	var selRow = $('#gridNarcDrug').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	var inci = selRow.inci;
	var formDataArr = PHA.DomData("#gridNarcDrugBatBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	formData.inci = inci;
	
	$('#gridNarcDrugBat').datagrid('options').url = $URL;
	$('#gridNarcDrugBat').datagrid('query', {
		pJsonStr: JSON.stringify(formData),
		hospId: PHA_COM.VAR.hospId
	});
}

function BeforeSave(){
	PHA_GridEditor.End('gridNarcDrugBat');
	// ��֤����Ȩ��
	if (!CheckLocAuth()) {
		return;
	}
	
	$('#dialogSelReason').dialog({
		/*buttons:[{
				text: '����',
				handler: function(){
					Save();
					$('#dialogSelReason').dialog('close');
				}
			},{
				text: '�ر�',
				handler:function(){
					$('#dialogSelReason').dialog('close');
				}
			}
		]*/
	});
	$('#dialogSelReason').dialog('open');
}

function Save(){
	// ��֤����Ȩ��
	if (!CheckLocAuth()) {
		return;
	}
	
	var rowsData = $('#gridNarcDrugBat').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({
			msg: 'û�����ݣ�',
			type: "alert"
		});
		return;
	}
	var changesData = $('#gridNarcDrugBat').datagrid('getChanges');
	if (changesData == null || changesData.length == 0) {
		PHA.Popover({
			msg: '����û�з����ı䣡',
			type: "alert"
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridNarcDrugBat');
	if (chkRetStr != "") {
		PHA.Popover({
			msg: chkRetStr,
			type: "alert"
		});
		return;
	}
	var locId = $('#baseLocId').combobox('getValue') || '';
	var adjReason = $('#adjReason').combobox('getText') || '';
	var pJsonStr = JSON.stringify({
		locId: locId,
		userId: PHA_COM.VAR.userId,
		adjReason: adjReason
	});
	AddRowIndex('gridNarcDrugBat', changesData);
	var pRowsDataStr = JSON.stringify(changesData);
	
	// ����
	var retStr = tkMakeServerCall('PHA.IN.NarcBase.Save', 'AdjLocBase', pJsonStr, pRowsDataStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert('��ʾ', retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: '����ɹ���',
		type: "success"
	});
	QueryNarcDrugBat();
}

function UpdateActive(rowIndex){
	// ��֤����Ȩ��
	if (!CheckLocAuth()) {
		return;
	}
	
	var rowsData = $('#gridNarcDrugBat').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	var locId = $('#baseLocId').combobox('getValue') || '';
	if (locId == '') {
		PHA.Popover({
			msg: '��ѡ��������ң�',
			type: "alert"
		});
		return;
	}
	rowData.locId = locId;
	rowData.userId = PHA_COM.VAR.userId;
	var activeFlag = rowData.active;
	var oldDesc = activeFlag == 'Y' ? $g('����') : $g('������');
	var newDesc = activeFlag == 'Y' ? $g('������') : $g('����');
	var newColor = activeFlag == 'Y' ? '#f16e57' : '#21ba45';
	var conTips = '�Ƿ�ȷ�Ͻ�״̬�޸�Ϊ [<font color="' + newColor + '">' + newDesc + '</font>] ��';
	var pJsonStr = JSON.stringify(rowData);
	
	PHA.Confirm('��ܰ��ʾ', conTips, function () {
		var retStr = tkMakeServerCall('PHA.IN.NarcBase.Save', 'UpdateActive', pJsonStr);
		var retArr = retStr.split('^');
		if (retArr[0] < 0) {
			PHA.Alert('��ʾ', retArr[1], retArr[0]);
			return;
		}
		PHA.Popover({
			msg: '�޸ĳɹ���',
			type: "success"
		});
		QueryNarcDrugBat();
	});
}

function ClearNarcDrug(){
	var formDataArr = PHA.DomData("#gridNarcDrugBar", {
		doType: 'clear'
	});
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#gridNarcDrug').datagrid('loadData', []);
	$('#gridNarcDrugBat').datagrid('loadData', []);
}

function ClearNarcDrugBat(){
	var formDataArr = PHA.DomData("#gridNarcDrugBatBar", {
		doType: 'clear'
	});
	InitDictVal();
	$('#gridNarcDrugBat').datagrid('loadData', []);
}

function CheckLocAuth(){
	var locId = $('#baseLocId').combobox('getValue') || '';
	if (locId == '') {
		PHA.Popover({
			msg: '��ѡ��������ң�',
			type: "alert"
		});
		return false;
	}
	var locType = tkMakeServerCall('PHA.IN.Narc.Com', 'GetLocType', locId);
	if (['OP', 'W'].indexOf(locType) < 0) {
		PHA.Alert('��ܰ��ʾ', '[��������]Ϊҽ�����һ�������ʹ�ô˹���', -1);
		return false;
	}
	return true;
} 

function GetEditTitle(title) {
	return title;
}

function AddRowIndex(gridId, rowsData){
	var rLen = rowsData.length;
	for (var i = 0; i < rLen; i++) {
		var iData = rowsData[i];
		var rowIndex = $("#" + gridId).datagrid('getRowIndex', iData);
		iData.rowIndex = rowIndex + 1;
	}
}

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}