var hospid = session['LOGON.HOSPID'];
//添加窗口
add = function () {
	var $winadd;
	$winadd = $('#Addwin').window({
			title: '添加',
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

			onClose: function () { //关闭窗口后触发
				$("#IsLast1Box").checkbox('setValue', false);
				$("#addfm").form("reset")
			}

		});
	$('#Addwin').css('display', 'block');
	$winadd.window('open');

	$("#AddClose").unbind('click').click(function () {
		$winadd.window('close');
	})

	//预算年度的下拉框
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

		//计量单位下拉框
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

	//品目名称的监听事件生成拼音码
	$('#Name1Box').keyup(function (event) {
		$('#Spell1Box').val(makePy($('#Name1Box').val().trim()));
	});

	//品目名称的监听事件生成全拼
	$('#Name1Box').keyup(function (event) {
		$('#NameAll1Box').val(chineseToPinYin($('#Name1Box').val().trim()));
	});

	//借贷方向
	var DirectionObj = $HUI.combobox("#Direction1Box", {
			//required:true,
			valueField: 'id',
			textField: 'name',
			mode: 'local',
			data: [{
					id: '0',
					name: '借方'
				}, {
					id: '1',
					name: '贷方'
				}
			]
		});

	//保存
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
				msg: '不允许给末级节点添加子节点！',
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
			$.messager.confirm('确定', '确认保存吗？', function (t) {
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
							msg: '年度不能为空！',
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
							msg: '品目编码不能为空！',
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
							msg: '品目名称不能为空！',
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
							title: '提示',
							msg: '数据保存中...'
						})
						$.m({
							ClassName: "herp.budg.hisui.udata.ubudgitemdicteconomic",
							MethodName: "Insert",
							data: data
						},
							function (SQLCODE) {
							if (SQLCODE == 0) {
								$.messager.popover({
									msg: '保存成功！',
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
									msg: '保存失败！' + SQLCODE,
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
