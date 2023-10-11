var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //��ʼ��
	Init();
});

function Init() {
	var YMboxObj = $HUI.combobox("#YMbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			onBeforeLoad: function (param) {
				param.str = param.q;
			},
			onSelect: function (data) {
				var Year = $("#YMbox").combobox('getValue');
				var DutyDR = $("#DutyDR").combobox('getValue');
				//alert(DutyDR)
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgPrjEstablishTime",
					MethodName: "List",
					hospid: hospid,
					Year: Year,
					DutyDeptDR: DutyDR
				})
			}
		});
	// ���ο��ҵ�������
	var DutyDRObj = $HUI.combobox("#DutyDR", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 3;
				param.str = param.q;
			},
			onSelect: function (data) {
				var Year = $("#YMbox").combobox('getValue');
				var DutyDR = $("#DutyDR").combobox('getValue');
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgPrjEstablishTime",
					MethodName: "List",
					hospid: hospid,
					Year: Year,
					DutyDeptDR: DutyDR
				})
			}
		});

	MainColumns = [[{
				field: 'ckbox',
				checkbox: true
			}, //��ѡ��
			{
				field: 'rowid',
				title: 'ID',
				width: 80,
				hidden: true
			}, {
				field: 'Year',
				title: '���',
				width: 80,
				align: 'left'
			}, {
				field: 'DutyDeptDR',
				title: '���ο���ID',
				width: 100,
				hidden: true
			}, {
				field: 'DCode',
				title: '���ο��ұ���',
				align: 'left',
				width: 120,
				hidden: true
			}, {
				field: 'DName',
				title: '���ο���',
				width: 150,
				align: 'left'
			}, {
				field: 'StartDate',
				title: '���ƿ�ʼʱ��',
				align: 'left',
				width: 150,
				editor: {
					type: 'datebox',
					options: {
						required: 'true',
						placeholder:"��ѡ"
					}
				}
			}, {
				field: 'EndDate',
				title: '���ƽ���ʱ��',
				align: 'left',
				width: 150,
				editor: {
					type: 'datebox',
					options: {
						required: 'true',
						placeholder:"��ѡ"
					}
				}
			},
		]];
	var MainGridObj = $HUI.datagrid("#MainGrid", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.uBudgPrjEstablishTime",
				MethodName: "List",
				hospid: hospid,
				Year: "",
				DutyDeptDR: ""
			},
			fitColumns: false, //�й̶�
			loadMsg: "���ڼ��أ����Եȡ�",
			autoRowHeight: true,
			rownumbers: true, //�к�
			ctrlSelec: true, //�����ö���ѡ���ʱ������ʹ��Ctrl��+������ķ�ʽ���ж�ѡ����
			// singleSelect: true, //ֻ����ѡ��һ��
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //ҳ���Сѡ���б�
			pagination: true, //��ҳ
			fit: true,
			columns: MainColumns,
			rowStyler: function (index, row) {
				if (index % 2 == 1) {
					return 'background-color:#FAFAFA;';
				}
			},
			onClickCell: function (index, field, value) { //���û����һ����Ԫ���ʱ�򴥷�
				if ((field == "StartDate") || (field == "EndDate")) {
					$('#MainGrid').datagrid('beginEdit', index); //����Ϊindex���п����༭
				}
			},
			toolbar: '#tb'
		});
	//��ѯ����
	var FindBtn = function () {
		var year = $('#YMbox').combobox('getValue'); // �������
		var DutyDR = $('#DutyDR').combobox('getValue'); // ���ο���
		MainGridObj.load({
			ClassName: "herp.budg.hisui.udata.uBudgPrjEstablishTime",
			MethodName: "List",
			hospid: hospid,
			Year: year,
			DutyDeptDR: DutyDR
		})
	}

	//�����ѯ��ť
	$("#FindBn").click(FindBtn);

	//����
	var saveOrder = function () {
		var rows = $('#MainGrid').datagrid("getSelections");
		var indexs = $('#MainGrid').datagrid('getEditingRowIndexs')
		var length = rows.length;
		var str = "",
		rowid = "",
		StartDate = "",
		EndDate = "",
		DutyDeptDR = "",
		Year = ""
			if (length < 1) {
				$.messager.popover({
					msg: '����ѡ������һ������!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
			}
			if (indexs.length <= 0) {
				$.messager.popover({
					msg: 'û��Ҫ���������!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
			} else {
				if (indexs.length > 0) {
					for (i = 0; i < indexs.length; i++) {
						$("#MainGrid").datagrid("endEdit", indexs[i]);
					}
				}
				for (var i = 0; i < length; i++) {
					var row = rows[i];
					rowid = row.rowid;
					Year = row.Year;
					DName=row.DName;
					DutyDeptDR = row.DutyDeptDR;
					StartDate = row.StartDate;
					EndDate = row.EndDate
						if ((!row.StartDate) || (!row.EndDate)) {
							var message = "��ѡ���Ϊ��!";
							$.messager.popover({
								msg: message,
								type: 'info',
								timeout: 5000,
								style: {
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
									top:10
								}
							});
							return false;
						}
						if (rowid == "") {
							$.m({
								ClassName: 'herp.budg.hisui.udata.uBudgPrjEstablishTime',
								MethodName: 'InsertRec',
								Year: Year,
								StartDate: StartDate,
								EndDate: EndDate,
								DutyDeptDR: DutyDeptDR
							},
								function (Data) {
								if (Data == 0) {
									$.messager.popover({
										msg: "����ɹ���",
										type: 'success',
										style: {
											left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
											top: 10
										}
									});
									return false;
								} else {
									$.messager.popover({
										msg: Year+"-"+DName+"����ʧ�ܣ�" +" "+ Data,
										type: 'error',
										timeout: 5000,
										style: {
											left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
											top: 10
										}
									});
									return false;
								}
							});
						} else {
							$.m({
								ClassName: 'herp.budg.hisui.udata.uBudgPrjEstablishTime',
								MethodName: 'UpdateRec',
								rowid: rowid,
								Year: Year,
								StartDate: StartDate,
								EndDate: EndDate,
								DutyDeptDR: DutyDeptDR
							},
								function (Data) {
								if (Data == 0) {
									$.messager.popover({
										msg: "����ɹ���",
										type: 'success',
										style: {
											left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
											top: 10
										}
									});
									return false;
								} else {
									$.messager.popover({
										msg: Year+"-"+DName+"����ʧ�ܣ�" +" "+ Data,
										type: 'error',
										timeout: 5000,
										style: {
											left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
											top: 10
										}
									});
									return false;
								}
							});
						}
				}
				$('#MainGrid').datagrid("reload");
			}
	}
	//������水ť
	$("#SaveBn").click(saveOrder);

	/**�������ý�ֹʱ��  ��ʼ**/
	var SetFun = function () {
		$("#Detailff").form('clear');
		var $win; 
		$win = $('#BtchWin').window({
				title: '�������ý�ֹʱ��',
				width: 500,
				height: 270,
				top: ($(window).height() - 260) * 0.5,
				left: ($(window).width() - 520) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-batch-cfg',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //�رչرմ��ں󴥷�
					$("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
				}
			});
		$win.window('open');
		// ��ȵ�������
		var BYMboxObj = $HUI.combobox("#BYMbox", {
				url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
				mode: 'remote',
				delay: 200,
				valueField: 'year',
				textField: 'year',
				value: new Date().getFullYear() + 1, //Ĭ�ϵ�ǰ��ȵ���һ��
				onBeforeLoad: function (param) {
					param.str = param.q;
				}
			});
		// ���ο��ҵ�������
		var BDutyDRObj = $HUI.combobox("#BDutyDR", {
				url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
				mode: 'remote',
				delay: 200,
				valueField: 'rowid',
				textField: 'name',
				onBeforeLoad: function (param) {
					param.hospid = hospid;
					param.userdr = userid;
					param.flag = 3;
					param.str = param.q;
				}
			});

		//��������
		$("#BtchSave").unbind('click').click(function () {
			var BStdate = "",
			BEddate = ""
			BStdate = $('#BStdate').datebox('getValue');
			BEddate = $('#BEddate').datebox('getValue');
			DutyDeptDR = $('#BDutyDR').combobox('getValue')
			if (!BStdate||!BEddate) {
				var message = "��ѡ���Ϊ��!";
				$.messager.popover({
					msg: message,
					type: 'info',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
				return false;
			}
			if (BStdate > BEddate) {
				var message = "��ʼʱ�䲻�ܴ��ڽ���ʱ��!";
				$.messager.popover({
					msg: message,
					type: 'info',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
				return false;
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgPrjEstablishTime',
				MethodName: 'SetTime',
				Year: $('#BYMbox').combobox('getValue'),
				StartDate: BStdate,
				EndDate: BEddate,
				DutyDeptDR: $('#BDutyDR').combobox('getValue')
			},
				function (Data) {
				//console.log("Data:"+Data);	//JSON.stringify(rows)
				if (Data == 0) {
					$.messager.popover({
						msg: '���óɹ���',
						type: 'success',
						style: {
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
							top:10
						}
					});
				} else {
					$.messager.popover({
						msg: "����ʧ�ܣ�" + Data,
						type: 'error',
						style: {
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
							top:10
						}
					});
				}
			});
			$win.window('close');
		});
		//ȡ��
		$("#BtchClose").unbind('click').click(function () {
			$win.window('close');
		});

	}
	$("#BatchBn").click(SetFun);
	/**�������ý�ֹʱ��  ����**/

}
