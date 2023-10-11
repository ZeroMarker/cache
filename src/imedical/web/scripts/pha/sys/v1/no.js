/**
 * ����:	 ҩ������-ϵͳ����-��Ʒ��ά��
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-19
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

// ��ʼ���ֵ�
function InitDict(){
	// ��������
	PHA.SearchBox("conAppAlias", {
		width: 300,
        searcher: QueryGridNo,
        placeholder: "������ģ��ļ�ƴ�����롢����..."
    });
    
    // ��ѯ�����б��Ƿ�ʹ�ò�ѯ����
	$('#chk-FindAll').checkbox({
		onCheckChange: function(e, value){
			QueryGridNo();
		}
	});
}

// ���-��Ʒ��
function InitGridPro() {
	var columns = [
		[{
				field: "RowId",
				title: '��Ʒ��Id',
				hidden: true,
				width: 100
			},
			{
				field: "Description",
				title: '����',
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

// ���-����
function InitGridNo() {
	var columns = [
		[{
				field: "countId",
				title: '����Id',
				hidden: true,
				width: 100
			}, {
				field: "appId",
				title: 'ģ��Id',
				hidden: true,
				width: 100
			},
			{
				field: "appCode",
				title: '����',
				width: 200
			},
			{
				field: "appDesc",
				title: '����',
				width: 200
			},
			{
				field: "hospFlag",
				title: 'ҽԺ',
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
				title: '����',
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
				title: '����',
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
				title: 'ǰ׺',
				width: 100,
				editor: {
					type: 'validatebox',
					options: {}
				}
			},
			{
				field: "yearFlag",
				title: '��',
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
				title: '��',
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
				title: '��',
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
				title: '��׺����',
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
			msg: "���ܰ����ַ�^",
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

// �¼�
function InitEvents() {
	$("#btnSave").on("click", function () {
		Save();
	});
}

// ����-��Ʒ��
function Save() {
	// ��֤
	if($('#gridNo').datagrid('endEditing') == false){
		PHA.Popover({
			msg: "�����������֮���ٱ���",
			type: 'alert'
		});
		return;
	}
	// ȡֵ
	var gridChanges = $('#gridNo').datagrid('getChanges') || [];
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "û����Ҫ���������",
			type: 'alert'
		});
		return;
	}
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "��ѡ��ҽԺ!",
			type: 'alert'
		});
		return;
	}
	
	// ����
	var jsonDataStr = JSON.stringify(gridChanges);
	var retStr = tkMakeServerCall('PHA.SYS.No.Save', 'SaveMulti', jsonDataStr, hospId);
	var retArr = retStr.split("^");
	var retVal = retArr[0];
	var retInfo = retArr[1];
	if (retVal < 0) {
		PHA.Alert("��ʾ", retInfo, retVal);
	} else {
		PHA.Popover({
			msg: retInfo || "�ɹ�!",
			type: "success",
			timeout: 500
		});
		QueryGridNo();
	}
}

/*
* @description: ��Ժ������ - ���س�ʼ��ҽԺ
*/
function InitHosp() {
	var hospComp = GenHospComp("DHC_StkSysCounter");  
	hospComp.options().onSelect = function(record){
		QueryGridNo();
	}
}

function AddTips(){
	$Tips = $('#panel-no').prev().find('.panel-tool').find('.icon-tip');
	$Tips.attr('title', $g('(1)����ѯ����Ʒģ��ά��������ά���ġ�ģ�����͡�Ϊ��ҵ�񡱵Ĳ�Ʒģ��;') + '<br/>' + $g('(2)ȫ�ּ����������˲�Ʒ��,���������з���������ģ�顣'));
	$Tips.tooltip({position:'left'}).show();
}