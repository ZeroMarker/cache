/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: ȫ��Ԥ�����-Ԥ����ƹ���-��ڿ������Ԥ�����-���Ԥ����ϸ����
CSPName: herp.budg.hisui.budgschemowndept.csp
ClassName: herp.budg.hisui.udata.uBudgSchemOwnDept
 */

var FYDAEditIndex = undefined;

function FYDAppendixGridShow(schemRow, factYearRow, factYearDetailRow) {

	var mainData = factYearRow.schemAuditIdObjDept + "^" + factYearRow.Rowid + "^" + factYearRow.Code + "^" + factYearDetailRow.rowid;

	var IsGov=(factYearRow.IsGovBuy==1) ? '(�����ɹ�)' : '(�������ɹ�)';

	var FYDAppendixWinObj = $HUI.window("#FYDAppendixWin", {
			iconCls: 'icon-w-new',
			title: factYearRow.Name.replace(/&nbsp;/g,"") + IsGov + '-' + '��Ԥ����ϸ-�ɹ�Ԥ�����',
			width: 1015,
			height: 500,
			resizable: true,
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			draggable: true,
			modal: true,
			onClose: function () { //�رչرմ��ں󴥷�
				$('#FYDetailGrid').datagrid("reload");
			}

		});
		
	$("#FYDAppendixWin").css("display", "block");

	var FYDGridColumn = [[{
				field: 'ck',
				checkbox: true
			}, {
				field: 'rowid',
				title: 'ID',
				hidden: true
			}, {
				field: 'mainId',
				title: '����ID',
				hidden: true
			}, {
				field: 'purchItemCo',
				title: '�ɹ�ƷĿ����',
				width: 120,
				allowBlank: false,
				formatter: function (value, row) {
					return row.purchItemNa;
				},
				editor: {
					type: 'combobox',
					options: {
						required: true,
						valueField: 'code',
						textField: 'name',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemPurch",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
							param.flag = '1';
							param.year = factYearRow.Year;
							param.supercode = '';
						}
					}
				}
			}, {
				field: 'fundTypeId',
				title: '�ʽ�����',
				width: 100,
				allowBlank: false,
				formatter: function (value, row) {
					return row.fundTypeNa;
				},
				editor: {
					type: 'combobox',
					options: {
						required: true,
						valueField: 'fundTypeId',
						textField: 'fundTypeNa',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
						}
					}
				}
			}, {
				field: 'budgVal',
				title: 'Ԥ���ܶ�',
				width: 100,
				allowBlank: false,
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						precision: 2
					}
				}
			}, {
				field: 'bgPrice',
				title: '����',
				width: 100,
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						precision: 2
					}
				}
			}, {
				field: 'bgNum',
				title: '����',
				width: 100,
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						precision: 2
					}
				}
			}, {
				field: 'desc',
				title: '��ע',
				width: 300,
				editor: {
					type: 'text'
				}
			}, {
				field: 'process',
				title: '���ƹ���',
				width: 100,
				formatter: comboboxFormatter,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'rowid',
						textField: 'name',
						data: [{
								rowid: '1',
								name: 'һ��'
							}, {
								rowid: '2',
								name: 'һ��'
							}, {
								rowid: '3',
								name: '����'
							}, {
								rowid: '4',
								name: '����'
							}
						]
					}
				}
			}

		]];

	//���Ӱ�ť
	var AddBtn = {
		id: 'FYDAppendixAdd',
		iconCls: 'icon-add',
		text: '����',
		handler: function () {

			if (FYDAEndEditing()) {
				$('#FYDAppendixGrid').datagrid('appendRow', {
					rowid: '',
					mainId: factYearDetailRow.rowid,
					purchItemCo: '',
					fundTypeId: '',
					budgVal: '',
					bgPrice: '',
					bgNum: '',
					desc: '',
					process: factYearRow.CurStep
				});
				FYDAEditIndex = $('#FYDAppendixGrid').datagrid('getRows').length - 1;
				$('#FYDAppendixGrid').datagrid('selectRow', FYDAEditIndex).datagrid('beginEdit', FYDAEditIndex);
				//���������beginEdit֮�󣬲�Ȼetȡ����ֵ��Ϊnull
				//�����ƹ�������Ϊֻ��ģʽ
				var et = $('#FYDAppendixGrid').datagrid('getEditor', {
						index: FYDAEditIndex,
						field: 'process'
					});
				$(et.target).combobox('disable'); //ֻ��ģʽ������������
				//$(et.target).attr('disabled', 'disabled'); //ֻ��ֻ��ģʽ�������ı���

			}
		}
	}

	//���水ť
	var SaveBtn = {
		id: 'FYDAppendixSave',
		iconCls: 'icon-save',
		text: '����',
		handler: function () {
			FYDAppendixSave(schemRow, factYearRow, factYearDetailRow);
		}
	}

	//ɾ����ť
	var DelBt = {
		id: 'FYDAppendixDel',
		iconCls: 'icon-remove',
		text: 'ɾ��',
		handler: function () {
			FYDAppendixDel();
		}
	}

	//��հ�ť
	var ClearBT = {
		id: 'FYDAppendixReset',
		iconCls: 'icon-reset',
		text: '����',
		handler: function () {
			$('#FYDAppendixGrid').datagrid('rejectChanges');
		}
	}

	var FYDAppendixGridObj = $HUI.datagrid('#FYDAppendixGrid', {
			title: '',
			region: 'center',
			fit: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
				MethodName: 'ListFYDAppendix',
				rowid: factYearDetailRow.rowid
			},
			columns: FYDGridColumn,
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, '-', SaveBtn, '-', DelBt, '-', ClearBT],
			onClickCell: FYDAppendixClickCell
		});

	//�ж��Ƿ�����༭
	function FYDAEndEditing() {

		if (FYDAEditIndex == undefined) {
			return true
		}
		if ($('#FYDAppendixGrid').datagrid('validateRow', FYDAEditIndex)) {
			var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
					index: FYDAEditIndex,
					field: 'purchItemCo'
				});
			if (ed) {
				var purchItemNa = $(ed.target).combobox('getText');
				$('#FYDAppendixGrid').datagrid('getRows')[FYDAEditIndex]['purchItemNa'] = purchItemNa;
			}

			var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
					index: FYDAEditIndex,
					field: 'fundTypeId'
				});
			if (ed) {
				var fundTypeNa = $(ed.target).combobox('getText');
				$('#FYDAppendixGrid').datagrid('getRows')[FYDAEditIndex]['fundTypeNa'] = fundTypeNa;
			}

			$('#FYDAppendixGrid').datagrid('endEdit', FYDAEditIndex);
			FYDAEditIndex = undefined;
			return true;
		} else {
			return false;
		}
	}

	//�ж��Ƿ�ɱ༭
	function FYDAppendixIsEdit(schemRow, factYearRow, factYearDetailRow, index, field) {

		//alert(factYearRow.IsLast);

		//��������ģʽ
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//�Ƿ�ɱ༭�ж�
			if ((field == "purchItemCo") || (field == "fundTypeId") || (field == "budgVal") || (field == "bgPrice") || (field == "bgNum") || (field == "desc")) {
				//alert(factYearRow.CurStep);
				//alert(factYearDetailRow.process);

				//�Ƿ�ǰ����=null/1 && �������=null/1 && ��������=null/1
				//һ�����
				if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
					 && (((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 1)) && ((factYearDetailRow.process == '') || (factYearDetailRow.process == null) || (factYearDetailRow.process == 1)))) {
					return true;
				}
				//һ�����
				if ((factYearRow.IsCurStep == 1)&&((factYearDetailRow.process == 2))) {
					if (((factYearRow.OneState == 4) || (factYearRow.OneState == 5) || (factYearRow.OneState == 6))) {
						return true;
					}
				}
				
				//�������
				//alert(factYearRow.DChkResult+"^"+factYearRow.CurStep+"^"+factYearDetailRow.process);
				if (((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1) || (factYearRow.DChkResult == 3) || (factYearRow.DChkResult == 7))
					 && (((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 3)) && ((factYearDetailRow.process == '') || (factYearDetailRow.process == null) || (factYearDetailRow.process == 3)))) {
					return true;
				}
				//�������
				//alert(factYearRow.DChkResult+"^"+factYearRow.CurStep+"^"+factYearDetailRow.process);
				if ((factYearRow.IsCurStep == 1)
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
					 && (((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 4)) && ((factYearDetailRow.process == '') || (factYearDetailRow.process == null) || (factYearDetailRow.process == 4)))) {
					return true;
				}

			}
		}

		//����������ģʽ
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 0)) {
			//�Ƿ�ɱ༭�ж�
			if ((field == "purchItemCo") || (field == "fundTypeId") || (field == "budgVal") || (field == "bgPrice") || (field == "bgNum") || (field == "desc")) {
				//alert(factYearRow.CurStep);
				//alert(factYearDetailRow.process);
				//�Ƿ�ǰ����=null/1 && �������=null/1 && ��������=null/1
				//һ�����
				if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
					 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
					 && (((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 1)) && ((factYearDetailRow.process == '') || (factYearDetailRow.process == null) || (factYearDetailRow.process == 1)))) {
					return true;
				}
			}
		}
		return false;
	}

	//�����Ԫ���¼�
	function FYDAppendixClickCell(index, field) {

		var factYearDetailRow = $('#FYDAppendixGrid').datagrid('getRows')[index];
		//alert(FYDAEndEditing());
		//alert(FYDAppendixIsEdit(schemRow, factYearRow,factYearDetailRow, index, field));

		if (FYDAEndEditing() && FYDAppendixIsEdit(schemRow, factYearRow, factYearDetailRow, index, field)) {
			$('#FYDAppendixGrid').datagrid('editCell', {
				index: index,
				field: field
			});
			FYDAEditIndex = index;
		}
	}

	//����ǰУ��
	function FYDAppendixChkBefSave(schemRow, factYearRow, factYearDetailRow, rowIndex, grid, row) {
		var fields = grid.datagrid('getColumnFields')
			for (var j = 0; j < fields.length; j++) {
				var field = fields[j];
				var tmobj = grid.datagrid('getColumnOption', field);
				if (tmobj != null) {
					var reValue = "";
					reValue = row[field];
					if (reValue == undefined) {
						reValue = "";
					}
					if ((tmobj.allowBlank == false) && FYDAppendixIsEdit(schemRow, factYearRow, factYearDetailRow, rowIndex, field)) {
						var title = tmobj.title;
						if ((reValue == "") || (reValue == undefined) || (parseInt(reValue) == 0)) {
							var info = title + "��Ϊ���������Ϊ�ջ��㣡";
							$.messager.popover({
								msg: info,
								type: 'info',
								timeout: 2000,
								showType: 'show',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
									top: 10
								}
							});
							return false;
						}
					}
				}
			}
			return true;
	}

	//���淽��
	function FYDAppendixSave(schemRow, factYearRow, factYearDetailRow) {

		var grid = $('#FYDAppendixGrid');
		var indexs = grid.datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {

				var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'purchItemCo'
					});
				if (ed) {
					var purchItemNa = $(ed.target).combobox('getText');
					$('#FYDAppendixGrid').datagrid('getRows')[indexs[i]]['purchItemNa'] = purchItemNa;

				}
				var ed = $('#FYDAppendixGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'fundTypeId'
					});
				if (ed) {
					var fundTypeNa = $(ed.target).combobox('getText');
					$('#FYDAppendixGrid').datagrid('getRows')[indexs[i]]['fundTypeNa'] = fundTypeNa;
				}
				grid.datagrid("endEdit", indexs[i]);
			}
		}
		var rows = grid.datagrid("getChanges");
		var rowIndex = "",
		row = "",
		detailData = "";
		if (rows.length > 0) {
			$.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function (t) {
				if (t) {
					for (var i = 0; i < rows.length; i++) {
						row = rows[i];
						rowIndex = grid.datagrid('getRowIndex', row);
						grid.datagrid('endEdit', rowIndex);
						if (FYDAppendixChkBefSave(schemRow, factYearRow, factYearDetailRow, rowIndex, grid, row)) {
							var tempdata = row.rowid
								 + "^" + row.purchItemCo
								 + "^" + row.fundTypeId
								 + "^" + row.budgVal
								 + "^" + row.bgPrice
								 + "^" + row.bgNum
								 + "^" + row.desc
								 + "^" + row.process;
							if (detailData == "") {
								detailData = tempdata;
							} else {
								detailData = detailData + "|" + tempdata;
							}
						}
					}
					//alert(mainData);
					//alert(detailData);
					FYDAppendixSaveOrder(mainData, detailData);
					grid.datagrid("reload");
				}
			})
		}
	}

	//���������̨����
	var FYDAppendixSaveOrder = function (mainData, detailData) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
			MethodName: 'FYDAppendixSave',
			userid: userid,
			mainData: mainData,
			detailData: detailData
		},
			function (Data) {
			if (Data == 0) {
				$.messager.popover({
					msg: '����ɹ���',
					type: 'success',
					timeout: 5000,
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});
			} else {
				$.messager.popover({
					msg: '����ʧ�ܣ�' + Data,
					type: 'error',
					timeout: 5000,
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});
			}
		});
	}

	//ɾ��
	function FYDAppendixDel() {
		var rows = $('#FYDAppendixGrid').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: '��ѡ��Ҫɾ���ļ�¼��',
				type: 'info',
				timeout: 2000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		}

		$.messager.confirm('ȷ��', 'ȷ��Ҫɾ��ѡ����������', function (t) {
			if (t) {
				var detailData = "";
				for (var i = 0; i < rows.length; i++) {
					var row = rows[i];
					var rowid = row.rowid;
					if (row.rowid > 0) {
						//ֻ����ɾ����ǰ�����µļ�¼��������ɾ��������¼
						//alert(factYearRow.CurStep );
						//alert(row.process);
						if ((factYearRow.CurStep == '')||(factYearRow.CurStep == row.process)) {
							if (detailData == "") {
								detailData = row.rowid;
							} else {
								detailData = detailData + "|" + row.rowid;
							}
						}
					} else {
						//��������ɾ��
						editIndex = $('#FYDAppendixGrid').datagrid('getRowIndex', row);
						$('#FYDAppendixGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					}
				}

				//alert(detailData);
				if (detailData != '') {
					$.m({
						ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
						MethodName: 'FYDAppendixDel',
						userid: userid,
						mainData: mainData,
						detailData: detailData
					},
						function (Data) {
						if (Data == 0) {
							$.messager.popover({
								msg: 'ɾ���ɹ���',
								type: 'success',
								timeout: 5000,
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
									top: 10
								}
							});
							$('#FYDAppendixGrid').datagrid("reload");
						} else {
							$.messager.popover({
								msg: 'ɾ��ʧ�ܣ�' + Data,
								type: 'error',
								timeout: 5000,
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
									top: 10
								}
							});
						}
					});

					$('#FYDAppendixGrid').datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
					startIndex = undefined;
					return startIndex;
				} else {
					$.messager.popover({
						msg: 'ֻ����ɾ����ǰ�����µļ�¼!',
						type: 'info',
						timeout: 2000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 10
						}
					});
					return;
				}

			}
		})
	}

	//��ťȨ�޹ܿ�
	function FYDABtnsEnableManage(schemRow, factYearRow) {
		//��������ģʽ
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//���ÿ�Ŀ
			if (schemRow.IsEconItem == 1) {
				//alert(factYearRow.Name+"->"+factYearRow.EstState );
				//�½�״̬
				if (((factYearRow.EstState == '') || (factYearRow.EstState == null) || (factYearRow.EstState == 1) || (factYearRow.EstState == 7))) {
					$('#FYDAppendixAdd').linkbutton('enable');
					$('#FYDAppendixSave').linkbutton('enable');
					$('#FYDAppendixDel').linkbutton('enable');
					$('#FYDAppendixReset').linkbutton('enable');

				}
				//���½�״̬
				if ((2 <= factYearRow.EstState) && (factYearRow.EstState <= 6)) {
					if (factYearRow.IsCurStep == 1) {
						$('#FYDAppendixAdd').linkbutton('enable');
						$('#FYDAppendixSave').linkbutton('enable');
						$('#FYDAppendixDel').linkbutton('enable');
						$('#FYDAppendixReset').linkbutton('enable');
					} else {
						$('#FYDAppendixAdd').linkbutton('disable');
						$('#FYDAppendixSave').linkbutton('disable');
						$('#FYDAppendixDel').linkbutton('disable');
						$('#FYDAppendixReset').linkbutton('disable');
					}
				}

			}
			//�Ǿ��ÿ�Ŀ
			if (schemRow.IsEconItem == 0) {
				//�½�״̬
				if (((factYearRow.EstState == '') || (factYearRow.EstState == null) || (FactYearRow.EstState == 1) || (factYearRow.EstState == 7))) {
					$('#FYDAppendixAdd').linkbutton('enable');
					$('#FYDAppendixSave').linkbutton('enable');
					$('#FYDAppendixDel').linkbutton('enable');
					$('#FYDAppendixReset').linkbutton('enable');
				}
				//���½�״̬
				if ((2 <= factYearRow.EstState) && (factYearRow.EstState <= 6)) {
					if (factYearRow.IsCurStep == 1) {
						$('#FYDAppendixAdd').linkbutton('enable');
						$('#FYDAppendixSave').linkbutton('enable');
						$('#FYDAppendixDel').linkbutton('enable');
						$('#FYDAppendixReset').linkbutton('enable');
					} else {
						$('#FYDAppendixAdd').linkbutton('disable');
						$('#FYDAppendixSave').linkbutton('disable');
						$('#FYDAppendixDel').linkbutton('disable');
						$('#FYDAppendixReset').linkbutton('disable');
					}
				}

			}
		}
	}

	//��ťȨ�޹ܿ�
	FYDABtnsEnableManage(schemRow, factYearRow);

	FYDAppendixWinObj.open();
};
