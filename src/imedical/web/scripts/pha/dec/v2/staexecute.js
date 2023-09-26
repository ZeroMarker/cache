/**
 * @ģ��:     ��ҩ����-״ִ̬��
 * @��д����: 2019-07-17
 * @��д��:   hulihua
 */

var Number = 0;
var pageTbNum = 15;
var NowTAB=""; 			//��¼��ǰҳǩ��tab
var ComPropData;		//��������
var NowRowId;			//����ִ��ʱ��¼��ǰ���ڱ༭����
$(function () {
	InitDict();
	InitSetDefVal();
	InitGridScanPresc();
	InitGridBatPresc();
	InitGridExePresc();
	//�ǼǺŻس��¼�
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				Query();
			}
		}
	});

	$('#txtBarCode').on('keypress', function (event) {
		if (event.keyCode == "13") {
			var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
			if (tabTitle != "ɨ��ִ��") {
				$("#tabsExecute").tabs("select", 0);
			}
			var decPstId = $("#cmbDecState").combobox('getValue');
			if (decPstId == "") {
				PHA.Popover({
					msg: "����ѡ���ҩ���̣�",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			};
			if (this.value.trim() == "") {
				PHA.Popover({
					msg: "������Ϊ�գ�",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			}
			ScanExecute(this.value);
			$(this).val("");
		}
	});

	//�¼�
	$('#cmbDecState').combobox({
		onSelect: function () {
			Query();
		}
	});

	$('#cmbDecLoc').combobox({
		onSelect: function () {
			var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
			var type = $("input[name='busType']:checked").val() || "O";
			PHA.ComboBox("cmbDecState", {
				editable: false,
				url: PHA_DEC_STORE.DecState(decLocId, type, "Execute").url
			});

			PHA.ComboBox("cmbEquiDesc", {
				url: PHA_DEC_STORE.DecEqui(decLocId).url
			});
			$HUI.combobox("#cmbEquiDesc").disable();
		}
	});

	$HUI.radio("[name='busType']", {
		onChecked: function (e, value) {
			var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
			PHA.ComboBox("cmbDecState", {
				editable: false,
				url: PHA_DEC_STORE.DecState(decLocId, $(this).val(), "Execute").url
			});
			$('#gridScanPresc').datagrid('clear');
			$('#gridBatPresc').datagrid('clear');
			$('#gridPrescExe').datagrid('clear');
			{DEC_PRINT.VIEW(ComPropData.decInfoId, {});}
			$("#txtBarCode").val('');
			$("#txtWaterQua").val('');
			$("#cmbEquiDesc").combobox("setValue", '');
			$("#txtInput").val('');
		}
	});

	$("#tabsExecute").on("click", ChangeTabs);

});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	//��������
	ComPropData = $.cm({
		ClassName: "PHA.DEC.Com.Method",
		MethodName: "GetAppProp",
		UserId: gUserID,
		LocId: gLocId,
		SsaCode: "DEC.COMMON",
	}, false);
	PHA.ComboBox("cmbDecLoc", {
		editable: false,
		url: PHA_DEC_STORE.DecLoc().url,
		onLoadSuccess: function () {
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		}
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url,
		onLoadSuccess: function () {
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});
	PHA.ComboBox("cmbDocLoc", {
		url: PHA_DEC_STORE.DocLoc().url
	});
	
	PHA.ComboBox("cmbDecState", {
		editable: false,
		url: PHA_DEC_STORE.DecState(ComPropData.DefaultDecLoc, "O", "Execute").url
	});
	PHA.ComboBox("cmbEquiDesc", {
		url: PHA_DEC_STORE.DecEqui(ComPropData.DefaultDecLoc).url,
		width: 155
	});
	$HUI.combobox("#cmbEquiDesc").disable();
	if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {
		//��ʾ��ҩ��Ϣpanel
		var decInfoId = DEC_PRINT.DecInfo("colexecutelayout");	
		ComPropData.decInfoId = decInfoId;
		DEC_PRINT.VIEW(decInfoId, {PrescNo: ""});	
	}
}

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
	if(parseInt(ComPropData.ScanPageTbNum)>0){
		pageTbNum=parseInt(ComPropData.ScanPageTbNum);
	}
	$("#tabsExecute").tabs("select", parseInt(ComPropData.OperateModel));
	if (parseInt(ComPropData.OperateModel) == "0") {
		$('#txtBarCode').focus();
	}
	$HUI.radio("input[value='O']").check();
	var tabId= $('#tabsExecute').tabs('getSelected').attr("id");
	NowTAB=tabId;
	//��������
	$.cm({
		ClassName: "PHA.DEC.Com.Method",
		MethodName: "GetAppProp",
		UserId: gUserID,
		LocId: gLocId,
		SsaCode: "DEC.STATUSEXE"
	}, function (jsonData) {
		$("#dateStart").datebox("setValue", jsonData.ExeStartDate);
		$("#dateEnd").datebox("setValue", jsonData.ExeEndDate);
		$('#timeStart').timespinner('setValue', "00:00:00");
		$('#timeEnd').timespinner('setValue', "23:59:59");
		$('#txtWaterQua').val("").prop('disabled', true);
		$('#txtInput').val("").prop('disabled', true);
		$("#txtPatNo").val("");
		$('#txtBarCode').val("");
	});
	if (NowTAB=="tabScanPresc"){
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);
	} else {
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
	}
}

/**
 * �л�ҳǩ
 * @method ChangeTabs
 */
function ChangeTabs() {
	var tabId= $('#tabsExecute').tabs('getSelected').attr("id");
	if(NowTAB==tabId){
		return;
	}
	NowTAB=tabId;
	var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
	if (tabTitle == "ɨ��ִ��") {
		$('#txtBarCode').focus();
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);
	}
	else{
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
	}
	if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {DEC_PRINT.VIEW(ComPropData.decInfoId, {});}
	Query();
}

/**
 * ��ʼ��ɨ�账���б�
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [[{
				field: 'TPstDesc',
				title: '��ǰ����',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TPstDesc == "�շ�") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TPstDesc == "�׼�") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TPstDesc == "�Ƹ�") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TPstDesc == "��ǩ") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TPstDesc == "��ҩ") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TPstCode',
				title: 'TPstCode',
				width: 60,
				hidden: 'true'
			}, {
				field: 'TPMId',
				title: 'TPMId',
				width: 60,
				hidden: 'true'
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 100
			}, {
				field: 'TPatName',
				title: '��������',
				align: 'left',
				width: 100
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 120
			}, {
				field: 'TPhaLocDesc',
				title: '����ҩ��',
				align: 'left',
				width: 120
			}, {
				field: 'TDocLocDesc',
				title: '��������',
				align: 'left',
				width: 120
			}, {
				field: 'TDecType',
				title: '��ҩ����',
				align: 'left',
				width: 80
			}, {
				field: 'TPreFacTor',
				title: '����',
				align: 'left',
				width: 60
			}, {
				field: 'TPreCount',
				title: 'ζ��',
				align: 'left',
				width: 60
			}, {
				field: 'TPreForm',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 80
			}, {
				field: 'TOperUser',
				title: '��ǰ���̲�����',
				align: 'left',
				width: 120
			}, {
				field: 'TOperDate',
				title: '��ǰ���̲���ʱ��',
				align: 'left',
				width: 150
			}
		]];
	var dataGridOption = {
		url: '',
		rownumbers: true,
		columns: columns,
		pagination: false,
		singleSelect: true,
		onSelect: function (rowIndex, rowData) {
			if (rowData.TPstCode == "JP") {
				$("label[for='labelText']").html("����ʱ��(����)");
				$('#txtInput').prop('disabled', false);
				$("#txtInput").val(rowData.TInterval).validatebox("validate");
				$HUI.combobox("#cmbEquiDesc").disable();
				$('#txtWaterQua').prop('disabled', true);
			} else if (rowData.TPstCode == "SJ") {
				$("label[for='labelEqui']").html("�׼��豸");
				$("label[for='labelWaterQua']").html("�׼�ˮ��(ml)");
				$("label[for='labelText']").html("�׼�ʱ��(����)");
				$HUI.combobox("#cmbEquiDesc").enable();
				$('#txtWaterQua').prop('disabled', false);
				$('#txtInput').prop('disabled', false);
				$("#txtInput").val(rowData.TInterval).validatebox("validate");
				$("#txtWaterQua").val(rowData.TWaterQua).validatebox("validate");
				$("#cmbEquiDesc").combobox("setValue", rowData.TDecEquiId);
			} else if (rowData.TPstCode == "EJ") {
				$("label[for='labelEqui']").html("�����豸");
				$("label[for='labelWaterQua']").html("����ˮ��(ml)");
				$("label[for='labelText']").html("����ʱ��(����)");
				$HUI.combobox("#cmbEquiDesc").enable();
				$('#txtWaterQua').prop('disabled', false);
				$('#txtInput').prop('disabled', false);
				$("#txtInput").val(rowData.TInterval).validatebox("validate");
				$("#txtWaterQua").val(rowData.TWaterQua).validatebox("validate");
				$("#cmbEquiDesc").combobox("setValue", rowData.TDecEquiId);
			}else{
				$('#txtInput').prop('disabled', true);
				$('#txtWaterQua').prop('disabled', true);
				$HUI.combobox("#cmbEquiDesc").disable();
			}
			if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) { 
				var prescNo = rowData.TPrescNo;
				DEC_PRINT.VIEW(ComPropData.decInfoId, {
					PrescNo: prescNo
				});
			}
		},
		onRowContextMenu:function(){
			return false;	
		}
	};
	PHA.Grid("gridScanPresc", dataGridOption);
}

/**
 * ��ʼ������ִ�б��
 * @method InitGridBatPresc
 */
function InitGridBatPresc() {
	var columns = [
		[{
				field: 'gridPreSelect',
				checkbox: true
			}, {
				field: 'TPstCode',
				title: '��ǰ����',
				width: 60,
				align: 'left',
				hidden: 'true'
			}, {
				field: 'TPstDesc',
				title: '��ǰ����',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TPstDesc == "�շ�") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TPstDesc == "�׼�") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TPstDesc == "�Ƹ�") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TPstDesc == "��ǩ") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TPstDesc == "��ҩ") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TPrescNo',
				title: '������',
				width: 120,
				align: 'left'
			}, {
				field: 'TSoakInterval',
				title: '����ʱ��',
				align: 'left',
				width: 80,
				hidden: true,
				editor: {
					type: 'numberbox',
					options: {
						isKeyupChange: false,
						suffix: "����"
					}
				},
				formatter: function (value, row, index) {
					if (value != "") {
						return value.toString()+this.editor.options.suffix;
					}
				}
			}, {
				field: 'TDecInterval',
				title: '��ҩʱ��',
				align: 'left',
				width: 80,
				hidden: true,
				editor: {
					type: 'numberbox',
					options: {
						isKeyupChange: false,
						suffix: "����"
					}
				},
				formatter: function (value, row, index) {
					if (value != "") {
						return value.toString()+this.editor.options.suffix;
					}
				}
			}, {
				field: 'TWaterQua',
				title: '��ˮ��',
				align: 'left',
				width: 80,
				hidden: true,
				editor: {
					type: 'numberbox',
					options: {
						isKeyupChange: false,
						suffix: "ml"
					}
				},
				formatter: function (value, row, index) {
					if (value != "") {
						return value.toString()+this.editor.options.suffix;
					}
				}
			}, {
				field: 'TEquiId',
				title: '��ҩ�豸id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'TDecEqui',
				title: '��ҩ�豸',
				align: 'left',
				width: 100,
				hidden: true,
				editor: {
					type: 'combogrid',
					options: {
						url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=GetEquiMai&DecLocId=' + gLocId,
						blurValidValue: true,
						panelWidth: 180,
						idField: 'Desc',
						textField: 'Desc',
						method: 'get',
						fitColumns: true,
						columns: [[{
									field: 'id',
									title: 'id',
									hidden: true
								}, {
									field: 'Code',
									title: '�豸����',
									align: 'center'
								}, {
									field: 'Desc',
									title: '�豸����',
									align: 'center'
								}
							]],
						onSelect: function(rowIndex, rowData){
							$("#gridBatPresc").datagrid("getRows")[NowRowId].TEquiId = rowData.id;
						}
					}
				}
			}, {
				field: 'TPreFacTor',
				title: '����',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreCount',
				title: 'ζ��',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreForm',
				title: '��������',
				width: 80,
				align: 'left'
			}, {
				field: 'TPreEmFlag',
				title: '�Ƿ�Ӽ�',
				width: 80,
				align: 'left'
			}, {
				field: 'TPhaLocDesc',
				title: '��������',
				width: 120,
				align: 'left'
			}, {
				field: 'TOperUser',
				title: '��ǰ���̲�����',
				width: 120,
				align: 'left'
			}, {
				field: 'TOperDate',
				title: '��ǰ���̲�������',
				width: 150,
				align: 'left'
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				width: 100,
				align: 'left'
			}, {
				field: 'TPatName',
				title: '��������',
				width: 100,
				align: 'left'
			}, {
				field: 'TDocLocDesc',
				title: '��������',
				width: 180,
				align: 'left'
			}, {
				field: 'TCookType',
				title: '��ҩ��ʽ',
				width: 80,
				align: 'left'
			}, {
				field: 'TDecType',
				title: '��ҩ����',
				width: 80,
				align: 'left'
			}, {
				field: 'TPdpmId',
				title: '��ҩID',
				align: 'left',
				width: 30,
				hidden: true
			}
		]
	];

	var dataGridOption = {
		url: '',
		fit: true,
		toolbar: '#gridBatPrescBar',
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ProExe.Query",
			QueryName: "BatExePre",
		},
		onLoadSuccess: function (data) {
			console.log(data)
			$('#gridBatPresc').datagrid('uncheckAll');
			var decPstDesc = $("#cmbDecState").combobox('getText');
			if (decPstDesc == "�׼�") {
				$(this).datagrid('showColumn', 'TDecInterval');
				$(this).datagrid('showColumn', 'TWaterQua');
				$(this).datagrid('showColumn', 'TDecEqui');
				$(this).datagrid('hideColumn', 'TSoakInterval');
				$(this).datagrid('setColumnTitle', {
					'TDecInterval': '�׼�ʱ��',
					'TWaterQua': '�׼��ˮ��',
					'TDecEqui': '�׼��豸'
				});
			} else if (decPstDesc == "����") {
				$(this).datagrid('showColumn', 'TDecInterval');
				$(this).datagrid('showColumn', 'TWaterQua');
				$(this).datagrid('showColumn', 'TDecEqui');
				$(this).datagrid('hideColumn', 'TSoakInterval');
				$(this).datagrid('setColumnTitle', {
					'TDecInterval': '����ʱ��',
					'TWaterQua': '�����ˮ��',
					'TDecEqui': '�����豸'
				});
			} else if (decPstDesc == "����") {
				$(this).datagrid('hideColumn', 'TDecInterval');
				$(this).datagrid('hideColumn', 'TWaterQua');
				$(this).datagrid('hideColumn', 'TDecEqui');
				$(this).datagrid('showColumn', 'TSoakInterval');
			} else {
				$(this).datagrid('hideColumn', 'TDecInterval');
				$(this).datagrid('hideColumn', 'TWaterQua');
				$(this).datagrid('hideColumn', 'TDecEqui');
				$(this).datagrid('hideColumn', 'TSoakInterval');
			}
		},
		onSelect: function (rowIndex, rowData) {
			if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {
				var prescNo = rowData.TPrescNo;
				DEC_PRINT.VIEW(ComPropData.decInfoId, {
					PrescNo: prescNo
				});
			}
		},
		onClickCell: function (rowIndex, field, value) {
			NowRowId = rowIndex;
			var decPstDesc = $("#cmbDecState").combobox('getText');
			if ((decPstDesc != "����") && (decPstDesc != "�׼�") && (decPstDesc != "����")) {
				return false;
			}
			if (field == "TSoakInterval") {
				$(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
					editField: 'TSoakInterval'
				});
			} else if ((field == "TWaterQua") || (field == "TDecEqui") || (field == "TDecInterval")) {
				$(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
					editField: 'TDecInterval'
				});
			} else {
				$(this).datagrid('endEditing');
			}
		}
	};
	PHA.Grid("gridBatPresc", dataGridOption);
}

/**
 * ��ʼ������ִ�в�ѯ���
 * @method InitGridExePresc
 */
function InitGridExePresc() {
	var columns = [
		[{
				field: 'TPstDesc',
				title: '��ҩ����',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TPstDesc == "�շ�") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TPstDesc == "�׼�") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TPstDesc == "�Ƹ�") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TPstDesc == "��ǩ") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TPstDesc == "����") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TPstDesc == "��ҩ") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TOperUser',
				title: '������',
				width: 100,
				align: 'left'
			}, {
				field: 'TOperDate',
				title: '��������',
				width: 150,
				align: 'left'
			}, {
				field: 'TAdvDictDesc',
				title: '��ǰ����',
				align: 'left',
				width: 80,
				styler: function (value, row, index) {
					if (row.TAdvDictDesc == "�շ�") {
                        return 'background-color:#f1c516;color:white;';
                    } else if (row.TAdvDictDesc == "����") {
                        return 'background-color:#f58800;color:white;'; 
                    } else if (row.TAdvDictDesc == "�׼�") {
                        return 'background-color:#a4c703;color:white;';
                    } else if (row.TAdvDictDesc == "����") {
                        return 'background-color:#51b80c;color:white;';
                    } else if (row.TAdvDictDesc == "�Ƹ�") {
                        return 'background-color:#4b991b;color:white;';
                    } else if (row.TAdvDictDesc == "��ǩ") {
                        return 'background-color:#a849cb;color:white;';
                    } else if (row.TAdvDictDesc == "����") {
                        return 'background-color:#6557d3;color:white;';
                    } else if (row.TAdvDictDesc == "��ҩ") {
                        return 'background-color:#1044c8;color:white;';
                    } else{
					return 'background-color:#d773b0;color:white;';
                    }
				}
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				width: 100,
				align: 'left'
			}, {
				field: 'TPatName',
				title: '��������',
				width: 100,
				align: 'left'
			}, {
				field: 'TDocLocDesc',
				title: '��������',
				width: 180,
				align: 'left'
			}, {
				field: 'TPhaLocDesc',
				title: '��������',
				width: 120,
				align: 'left'
			}, {
				field: 'TPrescNo',
				title: '������',
				width: 120,
				align: 'left',
			}, {
				field: 'TPreFacTor',
				title: '����',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreCount',
				title: 'ζ��',
				width: 40,
				align: 'left'
			}, {
				field: 'TPreForm',
				title: '��������',
				width: 80,
				align: 'left'
			}, {
				field: 'TPreEmFlag',
				title: '�Ƿ�Ӽ�',
				width: 80,
				align: 'left'
			}, {
				field: 'TCookType',
				title: '��ҩ��ʽ',
				width: 80,
				align: 'left'
			}, {
				field: 'TDecType',
				title: '��ҩ����',
				width: 80,
				align: 'left'
			}, {
				field: 'TPdpmId:',
				title: '��ҩID',
				align: 'left',
				width: 30,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		fit: true,
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ProExe.Query",
			QueryName: "AlrExePre",
		},
		onSelect: function (rowIndex, rowData) {
			if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {
				var prescNo = rowData.TPrescNo;
				DEC_PRINT.VIEW(ComPropData.decInfoId, {
					PrescNo: prescNo
				});
			}
		}
	};
	PHA.Grid("gridPrescExe", dataGridOption);
}

/**
 * ��ѯ����
 * @method Query
 */
function Query() {
	var params = GetParams();
	if (params == "") {
		return;
	}
	var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
	if (tabTitle == "����ִ��") {
		$('#gridBatPresc').datagrid('query', {
			ParamStr: params
		});
	} else if (tabTitle == "��ִ�в�ѯ") {
		var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
		if (decLocId == "") {
			PHA.Popover({
				msg: "����ѡ����Ҫ��ѯ�ļ�ҩ�ң�",
				type: 'alert'
			});
			return;
		}

		var decPstId = $("#cmbDecState").combobox('getValue');
		if (decPstId == "") {
			PHA.Popover({
				msg: "����ѡ���ҩ���̣�",
				type: 'alert'
			});
			return;
		};
		$('#gridPrescExe').datagrid('query', {
			ParamStr: params
		});
	} else {
		return;
	}
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitDict();
	$('#txtPatNo').val("");
	$('#gridScanPresc').datagrid('clear');
	$('#gridBatPresc').datagrid('clear');
	$('#gridPrescExe').datagrid('clear');
	if((ComPropData.ViewDecInfo)&&(ComPropData.ViewDecInfo=="Y")) {DEC_PRINT.VIEW(ComPropData.decInfoId, {});}
	InitSetDefVal();
}

/**
 * ��ȡ����Ԫ��ֵ
 * @method GetParams
 */
function GetParams() {
	var stDate = $("#dateStart").datebox('getValue');
	var enDate = $("#dateEnd").datebox('getValue');
	var stTime = $('#timeStart').timespinner('getValue');
	var enTime = $('#timeEnd').timespinner('getValue');
	var declocid = $('#cmbDecLoc').combobox("getValue") || "";
	var phalocid = $('#cmbPhaLoc').combobox("getValue") || "";		//����ҩ��
	var type = $("input[name='busType']:checked").val() || "";
	var decPstId = $("#cmbDecState").combobox('getValue');
	//alert("decPstId:"+decPstId)
	if (decPstId == "") {
		PHA.Popover({
			msg: "����ѡ���ҩ���̣�",
			type: 'alert'
		});
		return;
	};
	var patNo = $.trim($("#txtPatNo").val());
	var doclocid = $('#cmbDocLoc').combobox("getValue") || "";		//���ſ���
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + declocid + "^" + type + "^" + decPstId + "^" + patNo + "^" + phalocid + "^" + doclocid;
	return params;
}

/**
 * ɨ��ִ��
 * @method ScanExecute
 */
function ScanExecute(barCode) {
	var barCode = barCode.trim();
	var decPstId = $("#cmbDecState").combobox('getValue');
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	var type = ($("input[name='busType']:checked").val() || "O").trim();
	if((barCode.indexOf("E")<0)&&(barCode.indexOf(type)<0)){
		var busType = type=="I"?"סԺ":"����";
		PHA.Popover({
			msg: "�˴����뵱ǰѡ������Ͳ�һ�£���ǰ����Ϊ"+busType,
			type: 'alert'
		});
		return;
	}
	var inputStr = decPstId + "^" + decLocId;
	var jsonData = $.cm({
			ClassName: "PHA.DEC.ProExe.Query",
			MethodName: "GetBarCodeInfo",
			BarCode: barCode,
			InputStr: inputStr,
			dataType: 'json'
		}, false);
	var retCode = jsonData.retCode;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert'
		});
		return;
	} else {
		$.cm({
			ClassName: "PHA.DEC.ProExe.OperTab",
			MethodName: "Execute",
			PMId: jsonData.TPMId,
			PstId: decPstId,
			UserId: gUserID
		}, function (retData) {
			var retCode = retData.retCode;
			if (retCode < 0) {
				$.messager.alert('��ʾ', retData.retMessage, 'warning');
			} else {
				PHA.Popover({
					msg: "ִ�гɹ���",
					type: 'success'
				})
				var jsonData = $.cm({
					ClassName: "PHA.DEC.ProExe.Query",
					MethodName: "GetPrescDecInfo",
					BarCode: barCode,
					InputStr: inputStr,
					dataType: 'json'
				}, false);
				$('#gridScanPresc').datagrid('insertRow', {
					index: 0,
					row: jsonData
				});
				Number = Number + 1; //������id˳���
				$('#gridScanPresc').datagrid('selectRow', 0);
				var totalRows = $('#gridScanPresc').datagrid('getRows').length;
				if (totalRows > pageTbNum) { //�������õ�������ÿ����һ������ɾ��һ��֮ǰ������
					if ((Number - pageTbNum) != 0) {
						$('#gridScanPresc').datagrid('deleteRow', pageTbNum);
					}
				}
			}
			$('#txtBarCode').focus();
		});
	}

}

/**
 * ��������ִ�м�¼
 * @method SaveBat
 */
function SaveBat() {
	var pdpmIdStr = GetCheckedPdIdArr();
	if (pdpmIdStr == "") {
		PHA.Popover({
			msg: "�빴ѡ��Ҫִ�еĴ�����",
			type: 'alert'
		});
		return;
	}

	var decPstId = $("#cmbDecState").combobox('getValue');
	if (decPstId == "") {
		PHA.Popover({
			msg: "����ѡ���ҩ���̣�",
			type: 'alert'
		});
		return;
	};

	$.cm({
		ClassName: "PHA.DEC.ProExe.OperTab",
		MethodName: "SaveBatch",
		MultiDataStr: pdpmIdStr,
		PstId: decPstId,
		UserId: gUserID
	}, function (retData) {
		var retCode = retData.retCode;
		if (retCode < 0) {
			$.messager.alert('��ʾ', retData.retMessage, 'warning');
		} else {
			PHA.Popover({
				msg: "ִ�гɹ���",
				type: 'success'
			});
			Query();
		}
	});
}

/**
 * ��ȡѡ�м�¼����ϸ�ļ�ҩ����ID��
 * @method SaveBat
 */
function GetCheckedPdIdArr() {
	var batPdIdArr = [];
	var gridBatPrescChecked = $('#gridBatPresc').datagrid('getChecked');
	for (var i = 0; i < gridBatPrescChecked.length; i++) {
		var checkedData = gridBatPrescChecked[i];
		var pdpmId = checkedData.TPdpmId;
		var dataStr = pdpmId;
		if (batPdIdArr.indexOf(dataStr) < 0) {
			batPdIdArr.push(dataStr);
		}
	}
	return batPdIdArr.join("!!");
}

/**
 * ɨ�����ִ�м�¼
 * @method SacnUpdate
 */
function SacnUpdate() {
	var row = $('#gridScanPresc').datagrid('getSelected');
	if ((row == null) || (row == "")) {
		$.messager.alert("��ʾ", "����ѡ����Ҫ���µļ�ҩ��¼��", "warning");
		return;
	}
	var pstDesc = row.TPstDesc		//���̴���
	var pdPmId = row.TPMId;
	if ((pdPmId == null) || (pdPmId == "")) {
		$.messager.alert("��ʾ", "ѡ��ļ�ҩ��¼��δ�շ���", "warning");
		return;
	}
	
	var decEquId = $("#cmbEquiDesc").combobox('getValue');
	var decDesc = $("#cmbEquiDesc").combobox('getText');
	var waterQua = $('#txtWaterQua').val().trim();
	var stateInt = $('#txtInput').val().trim();
	if ((stateInt == null) || (stateInt == "")) {
		$.messager.alert("��ʾ", "�������ݲ�����Ϊ�գ�", "warning");
		return;
	}
	var upDataStr = pdPmId + "^" + stateInt + "^" + waterQua + "^" + decEquId + "^" + pstDesc;
	$.cm({
		ClassName: "PHA.DEC.ProExe.OperTab",
		MethodName: "ScanUpData",
		UpDataStr: upDataStr
	}, function (retData) {
		var retCode = retData.retCode;
		if (retCode < 0) {
			$.messager.alert('��ʾ', retData.retMessage, 'warning');
		} else {
			PHA.Popover({
				msg: "���³ɹ���",
				type: 'success'
			});
			$('#gridScanPresc').datagrid('updateRow',{
				index: $('#gridScanPresc').datagrid('getRowIndex',row),
				row: {
					TInterval: parseInt(stateInt)||'',
					TWaterQua: parseInt(waterQua)||'',
					TDecEqui: decDesc,
					TDecEquiId:decEquId
				}
			});
		}
	});
}

/**
 * ��������ִ�м�¼
 * @method UpdateBat
 */
function UpdateBat() {
	$('#gridBatPresc').datagrid('endEditing');
	var gridChanges = $('#gridBatPresc').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("��ʾ", "û����Ҫ���������", "info");
		return "";
	}
	var decPstDesc = $("#cmbDecState").combobox('getText');
	var updatastr = ""
		for (var j = 0; j < gridChangeLen; j++) {
			var rowData = gridChanges[j];
			var pdPmId = rowData.TPdpmId || "";
			var soakint = rowData.TSoakInterval || "";
			var decint = rowData.TDecInterval || "";
			var waterqua = rowData.TWaterQua || "";
			var equiId = rowData.TEquiId || "";
			var data = pdPmId + "^" + soakint + "^" + decint + "^" + waterqua + "^" + equiId + "^" + decPstDesc;
			if (updatastr == "") {
				updatastr = data;
			} else {
				updatastr = updatastr + "!!" + data
			}
		}
		if (updatastr == "") {
			$.messager.alert("��ʾ", "û����Ҫ���������", "info");
			return "";
		}
		$m({
			ClassName: "PHA.DEC.ProExe.OperTab",
			MethodName: "SaveUpData",
			UpDataStr: updatastr
		}, function (retData) {
			var retArr = retData.split("^");
			if (retArr[0] < 0) {
				$.messager.alert('��ʾ', retArr[1], 'warning');
				return;
			} else {
				PHA.Popover({
					msg: "���³ɹ���",
					type: 'success'
				})
				$('#gridBatPresc').datagrid('reload')
			}
		});
}
