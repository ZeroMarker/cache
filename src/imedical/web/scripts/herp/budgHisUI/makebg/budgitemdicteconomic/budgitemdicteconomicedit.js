//�༭����
edit = function () {
	var $win;
	var row = $('#EconomicTree').treegrid('getSelected');
	$win = $('#Editwin').window({
			title: '�༭',
			width: 590,
			height: 320,
			top: ($(window).height() - 320) * 0.5,
			left: ($(window).width() - 590) * 0.5,
			shadow: true,
			modal: true,
			closed: true,
			minimizable: false,
			maximizable: false,
			collapsible: false,
			resizable: false,
			onBeforeOpen: function () {
				if (row == null) {
					$.messager.popover({
						msg: '��ѡ����Ҫ�༭���У�',
						timeout: 2000,
						type: 'alert',
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
							top: 1
						}
					});
					return false;
				}
				$("#IsLast2Box").iCheck('setValue', false);
				$("#editfm").form("reset")
			},
			onOpen: function () {
				$('#Code2Box').val(row.Code);
				$('#Spell2Box').val(row.Spell);
				$('#Name2Box').val(row.Name);
				$('#NameAll2Box').val(row.NameAll);
				$('#TypeCode2Box').val(row.TypeCode);

				var rows = $('#EconomicTree').treegrid('getChildren', row.rowid);
				var obj = JSON.stringify(rows);
				//console.log(JSON.stringify(aa));
				//console.log(row.rowid);
				if (row.IsLast == 1) {
					$('#IsLast2Box').iCheck('check');
					$('#IsLast2Box').iCheck('disable')
				};
				if ((row.IsLast == 0) && (obj == '[]')) {
					$('#IsLast2Box').iCheck('uncheck');
					$("#IsLast2Box").iCheck("disable")
				};
				if ((row.IsLast == 0) && (obj != '[]')) {
					$('#IsLast2Box').iCheck('uncheck');
					$("#IsLast2Box").iCheck("disable")
				};
				if (row.IsCash == 1) {
					$('#IsCash2Box').iCheck('check');
				} else {
					$('#IsCash2Box').iCheck('uncheck');
				};
				if (row.State == 1) {
					$('#State2Box').iCheck('check');
				} else {
					$('#State2Box').iCheck('uncheck');
				}
			},
			onClose: function () { //�رմ��ں󴥷�
				$("#IsLast2Box").checkbox('setValue', false)
				$("#editfm").form("reset");

			}

		});
	$('#Editwin').css('display', 'block');
	$win.window('open');
	$("#EditClose").click(function () {
		$win.window('close');
		$("#editfm").form("reset");
	})
	//���������
	var year1Obj = $HUI.combobox("#Year2Box", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			value: row.Year,
			onBeforeLoad: function (param) {
				param.str = param.q;
				param.flag = ""

			}
		})
		//�������
		var DirectionObj = $HUI.combobox("#Direction2Box", {
			//required:true,
			valueField: 'id',
			textField: 'name',
			mode: 'local',
			value: row.Direction,
			data: [{
					id: '0',
					name: '�跽'
				}, {
					id: '1',
					name: '����'
				}
			]
		});
	//ƷĿ���Ƶļ����¼�����ƴ����
	$('#Name2Box').keyup(function (event) {
		$('#Spell2Box').val(makePy($('#Name2Box').val().trim()));

		//ƷĿ���Ƶļ����¼�����ȫƴ
		$('#Name2Box').keyup(function (event) {
			$('#NameAll2Box').val(chineseToPinYin($('#Name2Box').val().trim()));
		});
	})

	//������λ������
	var CalUnitDRObj = $HUI.combobox("#CalUnitDR2Box", {
			value: row.Direction,
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			value: row.CalUnitDR,
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=CalUnit&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.str = param.q;
			}
		});

	//����
	$("#EditSave").unbind('click').click(function () {
		var Level = row.Level;
		var SuperCode = row.SuperCode;
		var Year = $('#Year2Box').combobox('getValue');
		var Code = $('#Code2Box').val();
		var Name = $('#Name2Box').val();
		var NameAll = $('#NameAll2Box').val();
		var TypeCode = $('#TypeCode2Box').val();
		var Spell = $('#Spell2Box').val();
		var Direction = $('#Direction2Box').combobox('getValue');
		if (Direction == "�跽") {
			Direction = 0
		}
		if (Direction == "����") {
			Direction = 1
		}
		var CalUnitDR = $('#CalUnitDR2Box').combobox('getValue');
		var State = $('#State2Box').checkbox('getValue') ? 1 : 0;
		var IsLast = $('#IsLast2Box').checkbox('getValue') ? 1 : 0;
		var IsCash = $('#IsCash2Box').checkbox('getValue') ? 1 : 0;
		var rowid = row.rowid;
		var parentid = row._parentId
			$.messager.confirm('ȷ��', 'ȷ�ϱ�����', function (t) {
				if (t) {
					if (!Year) {
						$.messager.popover({
							msg: '��Ȳ���Ϊ�գ�',
							timeout: 2000,
							type: 'alert',
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
								top: 1
							}
						});
						return;
					}
					if (!Code) {
						$.messager.popover({
							msg: 'ƷĿ���벻��Ϊ�գ�',
							timeout: 2000,
							type: 'alert',
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
								top: 1
							}
						});
						return;
					}
					if (!Name) {
						$.messager.popover({
							msg: 'ƷĿ���Ʋ���Ϊ�գ�',
							timeout: 2000,
							type: 'alert',
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
								top: 1
							}
						});
						return;
					}

					var data = "";
					data = rowid + "|" + hospid + "|" + Year
						 + "|" + Code + "|" + SuperCode + "|" + Name
						 + "|" + NameAll + "|" + Level + "|" + TypeCode + "|" + Spell
						 + "|" + Direction + "|" + IsLast + "|" + IsCash
						 + "|" + CalUnitDR + "|" + State

						$.messager.progress({
							title: '��ʾ',
							msg: '���ݱ�����...'
						})
						$.m({
							ClassName: "herp.budg.hisui.udata.ubudgitemdicteconomic",
							MethodName: "Update",
							data: data,
							rowid: rowid
						},
							function (SQLCODE) {
							if (SQLCODE == 0) {
								$.messager.popover({
									msg: '����ɹ���',
									type: 'success',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');

								$("#EconomicTree").treegrid("reload", parentid);

							} else {
								$.messager.popover({
									msg: '����ʧ�ܣ�' + SQLCODE,
									type: 'error',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								})
							}
							$.messager.progress('close');

						})
						$('#EconomicTree').treegrid("unselectAll");
					$win.window('close');
				}
			})
	})
};
