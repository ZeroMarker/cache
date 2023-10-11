var hospid = session['LOGON.HOSPID'];

//��Ӵ���
add = function () {
	var $winadd;
	$winadd = $('#Addwin').window({
			width: 470,
			height: 380,
			top: ($(window).height() - 380) * 0.5,
			left: ($(window).width() - 470) * 0.5,
			shadow: true,
			modal: true,
			closed: true,
			minimizable: false,
			maximizable: false,
			collapsible: false,
			resizable: true,
			onBeforeOpen: function () {
				var row = $('#budgpurchasingTree').treegrid('getSelected');
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

	//alert(hospid);

	//Ԥ����ȵ�������
	var row = $('#budgpurchasingTree').treegrid('getSelected');
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

		//ƷĿ���Ƶļ����¼�����ƴ����
		$('#Name1Box').keyup(function (event) {
			$('#ReMark1Box').val(makePy($('#Name1Box').val().trim()));
		}),

	//����
	$("#AddSave").unbind('click').click(function () {
		var row = $('#budgpurchasingTree').treegrid('getSelected');
		var rowid = "";
		//console.log("row:"+JSON.stringify(row)+"=");
		if (row == null) {
			var ALevel = 0;
			var ASupCode = 0;
			var tmpIslast = 0;

		} else {
			var ALevel = parseInt(row.Level) + 1;
			var ASupCode = row.Code;
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
					top: 0
				}
			});
			return;
		} else {
			$.messager.confirm('ȷ��', 'ȷ�ϱ�����', function (t) {
				if (t) {
					var Year = $('#Year1Box').combobox('getValue');
					var Code = $('#Code1Box').val();
					var ReMark = $('#ReMark1Box').val();
					var Desc = $('#Desc1Box').val();
					var Name = $('#Name1Box').val();
					var IsLast = $('#IsLast1Box').checkbox('getValue') ? 1 : 0;

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
								top: 0
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
								top: 0
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
								top: 0
							}
						});
						return;
					}

					var data = "";
					data = rowid + "|" + hospid
						 + "|" + Year
						 + "|" + Code + "|" + Name.replace(/\+/g, '%2B')
						 + "|" + ASupCode + "|" + IsLast
						 + "|" + ReMark + "|" + ALevel
						 + "|" + Desc.replace(/\+/g, '%2B')

						$.messager.progress({
							title: '��ʾ',
							msg: '���ݱ�����...'
						})
						$.m({
							ClassName: "herp.budg.hisui.udata.ubudgpurchasingitems",
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
										top: 0
									}
								});
								$.messager.progress('close');

								$("#budgpurchasingTree").treegrid("reload", row.rowid);

							} else {
								$.messager.popover({
									msg: '����ʧ�ܣ�' + SQLCODE,
									type: 'error',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 0
									}
								})
							}
							$.messager.progress('close');

						})

				}
				$('#budgpurchasingTree').treegrid("unselectAll");
				$winadd.window('close');
			})
		}
	})
};
