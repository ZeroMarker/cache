var hospid = session['LOGON.HOSPID'];
//��Ӵ���
add = function () {
	var $winadd;
	$winadd = $('#Addwin').window({
			title: '���',
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
			resizable: true,
			onBeforeOpen: function () {
				var row = $('#EconomicTree').treegrid('getSelected');
				if (row == null) {
					$("#Year1Box").combobox("enable")
				} else {
					$("#Year1Box").combobox("disable")
				};
				$("#IsLast1Box").checkbox('setValue', false)
				$("#addfm").form("reset")
			},

			onClose: function () { //�رմ��ں󴥷�
				$("#IsLast1Box").checkbox('setValue', false);
				$("#addfm").form("reset")
			}

		});
	$('#Addwin').css('display', 'block');
	$winadd.window('open');

	$("#AddClose").unbind('click').click(function () {
		$winadd.window('close');
	})

	//Ԥ����ȵ�������
	var row = $('#EconomicTree').treegrid('getSelected');
	if (row == null) {
		var year = ""
	} else {
		var year = row.Year;
	}

	var year1Obj = $HUI.combobox("#Year1Box", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			value: year,
			onBeforeLoad: function (param) {
				param.str = param.q;
				param.flag = ""

			}
		})

		//������λ������
		var DirectionObj = $HUI.combobox("#CalUnitDR1Box", {
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=CalUnit&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.str = param.q;
			}
		});

	//ƷĿ���Ƶļ����¼�����ƴ����
	$('#Name1Box').keyup(function (event) {
		$('#Spell1Box').val(makePy($('#Name1Box').val().trim()));
	});

	//ƷĿ���Ƶļ����¼�����ȫƴ
	$('#Name1Box').keyup(function (event) {
		$('#NameAll1Box').val(chineseToPinYin($('#Name1Box').val().trim()));
	});

	//�������
	var DirectionObj = $HUI.combobox("#Direction1Box", {
			//required:true,
			valueField: 'id',
			textField: 'name',
			mode: 'local',
			data: [{
					id: '0',
					name: '�跽'
				}, {
					id: '1',
					name: '����'
				}
			]
		});

	//����
	$("#AddSave").unbind('click').click(function () {
		var row = $('#EconomicTree').treegrid('getSelected');
		var rowid = "";
		//console.log("row:"+JSON.stringify(row)+"=");
		if (row == null) {
			var Level = 0;
			var SuperCode = "TOP";
			var tmpIslast = 0;

		} else {
			var Level = parseInt(row.Level) + 1;
			var SuperCode = row.Code;
			var tmpIslast = row.IsLast;
		};

		if (tmpIslast == 1) {
			$.messager.popover({
				msg: '�������ĩ���ڵ�����ӽڵ㣡',
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
		} else {
			$.messager.confirm('ȷ��', 'ȷ�ϱ�����', function (t) {
				if (t) {
					var Year = $('#Year1Box').combobox('getValue');
					var Code = $('#Code1Box').val();
					var Name = $('#Name1Box').val();
					var NameAll = $('#NameAll1Box').val();
					var TypeCode = $('#TypeCode1Box').val();
					var Spell = $('#Spell1Box').val();
					var Direction = $('#Direction1Box').combobox('getValue');
					var CalUnitDR = $('#CalUnitDR1Box').combobox('getValue');
					var State = $('#State1Box').checkbox('getValue') ? 1 : 0;
					var IsLast = $('#IsLast1Box').checkbox('getValue') ? 1 : 0;
					var IsCash = $('#IsCash1Box').checkbox('getValue') ? 1 : 0;

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
							MethodName: "Insert",
							data: data
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

								if ((SuperCode == "TOP") || (SuperCode == 0)) {
									$("#EconomicTree").treegrid("reload", "");
								} else {
									$("#EconomicTree").treegrid("reload", row.rowid);
								}

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

				}
				$('#EconomicTree').treegrid("unselectAll");
				$winadd.window('close');
			})
		}
	})
}
