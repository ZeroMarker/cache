var startIndex = undefined;
var FYDEditIndex = undefined;

function FYDetailGridShow(schemRow, factYearRow) {

	var mainId = factYearRow.rowid;
	if (!mainId) {
		$.messager.popover({
			msg: '����IDΪ��!',
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
	//schemRow.Rowid-��ڱ�ID;factYearRow.rowid-�������ID;factYearRow.Code-���������Ŀ����
	var mainData = schemRow.Rowid + "^" + factYearRow.rowid + "^" + factYearRow.Code;
	
	var IsGov='';
	if(factYearRow.IsGovBuy==1){
		IsGov='(�����ɹ�)';
	}else{
		IsGov='(�������ɹ�)';
	}
	var FYDetailWinObj = $HUI.window("#FYDetailWin", {
			iconCls: 'icon-w-new',
			title: factYearRow.Name+ IsGov +'-'+'��Ԥ����ϸ����',
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
				var OldRowIndex = $('#schemDetailGrid').datagrid('getRowIndex', factYearRow);
				$('#schemDetailGrid').datagrid("reload");
				//�ص�ѡ�м�¼
				$('#schemDetailGrid').datagrid({
					onLoadSuccess: function () {
						$('#schemDetailGrid').datagrid("selectRow", OldRowIndex);
					}
				});
			}
		});

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
				field: 'ecoItemCo',
				title: '���ÿ�Ŀ',
				width: 120,
				allowBlank: false,
				formatter: function (value, row) {
					return row.ecoItemNa;
				},
				editor: {
					type: 'combobox',
					options: {
						valueField: 'ecoItemCo',
						textField: 'ecoItemNa',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemEco",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
							param.flag = '1^3';
							param.type = '';
							param.level = '';
							param.supercode = '';
						},
						required: true
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
						valueField: 'fundTypeId',
						textField: 'fundTypeNa',
						url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
						delay: 200,
						onBeforeLoad: function (param) {
							param.str = param.q;
							param.hospid = hospid;
						},
						required: true
					}
				}
			}, {
				field: 'oneUpVal',
				title: 'һ��Ԥ��',
				width: 100,
				halign:'right',
				align:'right',
				allowBlank: false,
				formatter:dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'oneDowVal',
				title: 'һ��Ԥ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'twoUpVal',
				title: '����Ԥ��',
				width: 100,
				halign:'right',
				align:'right',			
				allowBlank: false,
				formatter:dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'twoDowVal',
				title: '����Ԥ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter:dataFormat,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2
					}
				}
			}, {
				field: 'planVal',
				title: '����Ԥ��',
				width: 100,
				halign:'right',
				align:'right',
				formatter: finalValueStyle,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2,
					}
				}
			}, {
				field: 'desc',
				title: '��ע',
				width: 300,
				editor: {
					type: 'text'
				}
			}

		]]

	//������ť
	var AddBtn = {
		id: 'FYDAdd',
		iconCls: 'icon-add',
		text: '����',
		handler: function (index, field) {
			if (FYDEndEditing()) {
				$('#FYDetailGrid').datagrid('appendRow', {
					rowid: '',
					mainId: mainId,
					ecoItemCo: '',
					fundTypeId: '',
					oneUpVal: '',
					oneDowVal: '',
					twoUpVal: '',
					twoDowVal: '',
					planVal: '',
					desc: ''
				});
				}
				//���ݵ�ǰ���̣��ö�Ӧ�пɱ༭
				
				if(schemRow.IsTwoUpDown==1&&(factYearRow.IsGovBuy == 0)){
				var fields = $('#FYDetailGrid').datagrid('getColumnFields', true).concat($('#FYDetailGrid').datagrid('getColumnFields'));
				for (var i = 5; i < fields.length - 1; i++) {
					//alert(fields[i]);
					var col = $('#FYDetailGrid').datagrid('getColumnOption', fields[i]);
					var curStep = factYearRow.CurStep;
					if (curStep == ''){
						curStep = 1;}
					var fieldIndex = parseInt(curStep) + 4;
					if (fieldIndex == i) {
						col.editor = col.editor;
					} else {
						col.editor = null;
					}
				}
				startIndex = $('#FYDetailGrid').datagrid('getRows').length - 1;
				$('#FYDetailGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);}
				
				
				if(factYearRow.IsGovBuy == 1){
				startIndex = $('#FYDetailGrid').datagrid('getRows').length - 1;
				var ee = $('#FYDetailGrid').datagrid('getColumnOption', 'oneUpVal');
				var ff = $('#FYDetailGrid').datagrid('getColumnOption', 'oneDowVal');
				var gg = $('#FYDetailGrid').datagrid('getColumnOption', 'twoUpVal');
				var hh = $('#FYDetailGrid').datagrid('getColumnOption', 'twoDowVal');
			    ee.editor={};
			    ff.editor={};
			    gg.editor={};
			    hh.editor={};
			    $('#FYDetailGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);
			    var dd = $('#FYDetailGrid').datagrid('getEditor', { index:startIndex, field: 'planVal' });
			    $(dd.target).focus(function(){
				    $('#FYDetailGrid').datagrid('endEdit', startIndex)
				    var factYearDetailRow = $('#FYDetailGrid').datagrid('getSelected')
				    if(factYearDetailRow.ecoItemCo == ""){
					    $.messager.popover({
								msg: "���ÿ�Ŀ����Ϊ�գ�",
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
					if(factYearDetailRow.fundTypeId == ""){
						$.messager.popover({
								msg: "�ʽ����ʲ���Ϊ�գ�",
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
				    var detailData = factYearDetailRow.rowid
								 + "^" + factYearDetailRow.ecoItemCo
								 + "^" + factYearDetailRow.fundTypeId
								 + "^" + factYearDetailRow.oneUpVal
								 + "^" + factYearDetailRow.oneDowVal
								 + "^" + factYearDetailRow.twoUpVal
								 + "^" + factYearDetailRow.twoDowVal
								 + "^" + factYearDetailRow.planVal
								 + "^" + factYearDetailRow.desc;
					$.m({
						ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
						MethodName: 'FYDetailSave',
						userid: userid,
						mainData: mainData,
						detailData: detailData
						},
						function (Data) {
							if (Data == 0) {
								//alert(mainData)
								$('#FYDetailGrid').datagrid("reload");
								//FYDAppendixGridShow(schemRow, factYearRow, factYearDetailRow)
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
				})
			})}
			}
		}
	
	//���水ť
	var SaveBtn = {
		id: 'FYDSave',
		iconCls: 'icon-save',
		text: '����',
		handler: function () {
			FYDetailSave(schemRow, factYearRow);
		}
	}
	//ɾ����ť
	var DelBt = {
		id: 'FYDDel',
		iconCls: 'icon-cancel',
		text: 'ɾ��',
		handler: function () {
			FYDetailDel();
		}
	}
	//��հ�ť
	var ClearBT = {
		id: 'FYDReset',
		iconCls: 'icon-reset',
		text: '����',
		handler: function () {
			$('#FYDetailGrid').datagrid('rejectChanges');
		}
	}

	var FYDetailGridObj = $HUI.datagrid('#FYDetailGrid', {
			title: '',
			region: 'center',
			fit: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
				MethodName: 'ListFYDetail',
				rowid: mainId
			},
			columns: FYDGridColumn,
			rownumbers: true, //�к�
			pagination: true, //��ҳ
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100],
			toolbar: [AddBtn, SaveBtn, DelBt, ClearBT],
			onClickCell: FYDetailClickCell,
			onLoadSuccess:function(data){
				if(data){
					$('.SpecialClass').linkbutton({
						plain:true
						})
				}}
		});
		
	//�����Ԫ���¼�
	function FYDetailClickCell(index, field) {
		var factYearDetailRow = $('#FYDetailGrid').datagrid('getRows')[index];
		//alert(startIndex+"^"+index);
		startIndex = index;
		if (FYDEndEditing() && FYDIsEdit(schemRow, factYearRow, index, field)) {
			$('#FYDetailGrid').datagrid('selectRow', index)
			$('#FYDetailGrid').datagrid('editCell', {
				index: index,
				field: field
			});
			//startIndex = index;
		}
		//������Ԥ�㵯�����������
		if ((factYearDetailRow.rowid != '')&&(factYearRow.IsGovBuy == 1)&&(field == 'planVal')&&(schemRow.IsEconItem==1)) {
			//alert(factYearDetailRow.rowid)
			FYDAppendixGridShow(schemRow, factYearRow, factYearDetailRow);
		}

	}

	//�ж��Ƿ�����༭
	function FYDEndEditing() {

		if (startIndex == undefined) {
			return true
		}
		if ($('#FYDetailGrid').datagrid('validateRow', startIndex)) {
			var ed = $('#FYDetailGrid').datagrid('getEditor', {
					index: startIndex,
					field: 'ecoItemCo'
				});
			if (ed) {
				var ecoItemNa = $(ed.target).combobox('getText');
				$('#FYDetailGrid').datagrid('getRows')[startIndex]['ecoItemNa'] = ecoItemNa;
			}
			var ed = $('#FYDetailGrid').datagrid('getEditor', {
					index: startIndex,
					field: 'fundTypeId'
				});
			if (ed) {
				var fundTypeNa = $(ed.target).combobox('getText');
				$('#FYDetailGrid').datagrid('getRows')[startIndex]['fundTypeNa'] = fundTypeNa;
			}

			$('#FYDetailGrid').datagrid('endEdit', startIndex);
			startIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	

	//�ж��Ƿ�ɱ༭
	function FYDIsEdit(schemRow, factYearRow, index, field) {
		//���������ɹ������Ԥ��ֵ�ɱ༭
		if(field == "planVal"&&factYearRow.IsGovBuy == 0){
			return true}
		//���ÿ�Ŀ/�ʽ�����
		if ((factYearRow.IsLast == 1) && ((field == "ecoItemCo") || (field == "fundTypeId"))) {
			//�Ƿ�ǰ����=null/1 && �������=null/1 && ��������=null/1
			if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
				 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
				 && ((factYearRow.CurStep == '') || (factYearRow.CurStep == null) || (factYearRow.CurStep == 1))) {
				return true;
			}
		}

		//��������ģʽ
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//һ��Ԥ����
			if ((field == "oneUpVal") && ((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))) {
				if (((factYearRow.EstState == '') || (factYearRow.EstState == null) || (factYearRow.EstState == 1))
					 && ((factYearRow.OneState == '') || (factYearRow.OneState == null) || (factYearRow.OneState == 1))) {
					return true;
				}
			}

			//һ��Ԥ����
			if (field == "oneDowVal") {
				//�Ƿ�ǰ����=1 && ��������=2(һ��)
				if ((factYearRow.IsCurStep == 1)
					 && (factYearRow.CurStep == 2)) {
					return true;
				}
			}

			//����Ԥ����
			if ((field == "twoUpVal") && ((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) ||(factYearRow.IsCurStep == 1))) {
				if ((factYearRow.TwoState == 2)
					 ||(factYearRow.TwoState == 7)) {
					return true;
				}
			}

			//����Ԥ����
			if (field == "twoDowVal") {
				//�Ƿ�ǰ����=1 && ��������=2(һ��)
				if ((factYearRow.IsCurStep == 1)
					 && (factYearRow.CurStep == 4)) {
					return true;
				}
			}

		}

		if ((factYearRow.IsLast == 1) && (field == "desc")) {
			//�Ƿ�ǰ����=null/1 && �������=null/1 && ��������=null/2
			if (((factYearRow.IsCurStep == '') || (factYearRow.IsCurStep == null) || (factYearRow.IsCurStep == 1))
				 && ((factYearRow.DChkResult == '') || (factYearRow.DChkResult == null) || (factYearRow.DChkResult == 1))
				 && ((factYearRow.CurStep == 1) || (factYearRow.CurStep == 2))) {
				return true;
			}
		}

		return false;
	}

	//���淽��
	function FYDetailSave(schemRow, factYearRow) {

		var grid = $('#FYDetailGrid');
		var indexs = grid.datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {

				var ed = $('#FYDetailGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'ecoItemCo'
					});
				if (ed) {
					var ecoItemNa = $(ed.target).combobox('getText');
					$('#FYDetailGrid').datagrid('getRows')[indexs[i]]['ecoItemNa'] = ecoItemNa;

				}
				var ed = $('#FYDetailGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'fundTypeId'
					});
				if (ed) {
					var fundTypeNa = $(ed.target).combobox('getText');
					$('#FYDetailGrid').datagrid('getRows')[indexs[i]]['fundTypeNa'] = fundTypeNa;
				}
				grid.datagrid("endEdit", indexs[i]);
			}
		}
		var rows = grid.datagrid("getChanges");
		var rowIndex = "";
		var row = "";
		var detailData = "";
		if (rows.length > 0) {
			$.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function (t) {
				if (t) {
					for (var i = 0; i < rows.length; i++) {
						row = rows[i];
						rowIndex = grid.datagrid('getRowIndex', row);
						grid.datagrid('endEdit', rowIndex);
						///if (FYDChkBefSave(schemRow, factYearRow, rowIndex, grid, row)) {
							var tempdata = row.rowid
								 + "^" + row.ecoItemCo
								 + "^" + row.fundTypeId
								 + "^" + row.oneUpVal
								 + "^" + row.oneDowVal
								 + "^" + row.twoUpVal
								 + "^" + row.twoDowVal
								 + "^" + row.planVal
								 + "^" + row.desc;
							if (detailData == "") {
								detailData = tempdata;
							} else {
								detailData = detailData + "|" + tempdata;
							}
						//}
					}
					//alert(mainData);
					//alert(detailData);
					FYDSaveOrder(mainData, detailData);
					grid.datagrid("reload");
				}
			})
		}
	}

	//����ǰУ��
	function FYDChkBefSave(schemRow, factYearRow, rowIndex, grid, row) {
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
					if ((tmobj.allowBlank == false) && FYDIsEdit(schemRow, factYearRow, rowIndex, field)) {
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

	//���������̨����
	var FYDSaveOrder = function (mainData, detailData) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
			MethodName: 'FYDetailSave',
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
				$('#FYDetailGrid').datagrid("reload");
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

	function FYDetailDel() {
		var rows = $('#FYDetailGrid').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: '��ѡ��Ҫɾ���ļ�¼��',
				type: 'info',
				timeout: 2000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		}

		$.messager.confirm('ȷ��', '����ɾ����Ӧ���ӱ��¼��ȷ��Ҫɾ��ѡ����������', function (t) {
			if (t) {
				var detailData = "";
				for (var i = 0; i < rows.length; i++) {
					var row = rows[i];
					var rowid = row.rowid;
					if (row.rowid > 0) {
						if (detailData == "") {
							detailData = row.rowid;
						} else {
							detailData = detailData + "|" + row.rowid;
						}
					} else {
						//��������ɾ��
						editIndex = $('#FYDetailGrid').datagrid('getRowIndex', row);
						$('#FYDetailGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					}
				}
				$.m({
					ClassName: 'herp.budg.hisui.udata.uBudgSchemMAself',
					MethodName: 'FYDetailDel',
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
						$('#FYDetailGrid').datagrid("reload");
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

				$('#FYDetailGrid').datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
				startIndex = undefined;
				return startIndex;
			}
		})
	}

	//��ťȨ�޹ܿ�
	function FYDBtnsEnableManage(schemRow, factYearRow) {
		//��������ģʽ
		if ((factYearRow.IsLast == 1) && (schemRow.IsTwoUpDown == 1)) {
			//ҵ����ұ��ƽ���
			if (((factYearRow.OneState == '')
					 || (factYearRow.OneState == null)
					 || (factYearRow.OneState == 1))) {
				//һ���½�״̬
				$('#FYDAdd').linkbutton('enable');
				$('#FYDSave').linkbutton('enable');
				$('#FYDDel').linkbutton('enable');
				$('#FYDReset').linkbutton('enable');

			}else if (factYearRow.TwoState == 7) {
				//�����½�״̬ 7-�·��꣬������
							$('#FYDAdd').linkbutton('enable');
							$('#FYDSave').linkbutton('enable');
							$('#FYDDel').linkbutton('enable');
							$('#FYDReset').linkbutton('enable');

			} 
			//ҵ�������˽���
			else if (factYearRow.IsCurStep == 1) {
				$('#FYDAdd').linkbutton('enable');
				$('#FYDSave').linkbutton('enable');
				$('#FYDDel').linkbutton('enable');
				$('#FYDReset').linkbutton('enable');

			} else {
				$('#FYDAdd').linkbutton('disable');
				$('#FYDSave').linkbutton('disable');
				$('#FYDDel').linkbutton('disable');
				$('#FYDReset').linkbutton('disable');

			}
			//��ڿ�����˽���


		}
	}
	if (schemRow.IsTwoUpDown == 0) {   //����������ģʽ�����ر���������������;
		$('#FYDetailGrid').datagrid('hideColumn', 'oneUpVal');
		$('#FYDetailGrid').datagrid('hideColumn', 'oneDowVal');
		$('#FYDetailGrid').datagrid('hideColumn', 'twoUpVal');
		$('#FYDetailGrid').datagrid('hideColumn', 'twoDowVal');
	} else {   //��ʾ����������������;
		$('#FYDetailGrid').datagrid('showColumn', 'oneUpVal');
		$('#FYDetailGrid').datagrid('showColumn', 'oneDowVal');
		$('#FYDetailGrid').datagrid('showColumn', 'twoUpVal');
		$('#FYDetailGrid').datagrid('showColumn', 'twoDowVal');
	}
	//��ťȨ�޹ܿ�
	FYDBtnsEnableManage(schemRow, factYearRow);

	FYDetailWinObj.open();
};
