var hospid = session['LOGON.HOSPID'];

//添加窗口
copy = function () {
	var $win;
	$win = $('#Copywin').window({
			title: '复制',
			width: 470,
			height: 210,
			top: ($(window).height() - 210) * 0.5,
			left: ($(window).width() - 470) * 0.5,
			shadow: true,
			modal: true,
			closed: true,
			minimizable: false,
			maximizable: false,
			collapsible: false,
			resizable: true,
			onBeforeOpen: function () {
				$("#HisYearBox").combobox('setValue', "");
				$("#BudgYearBox").combobox('setValue', "")
			},
			onClose: function () { //关闭窗口后触发
				$("#budgpurchasingTree").treegrid("reload"); //关闭窗口，重新加载主表格
			}

		});
	$('#Copywin').css('display', 'block');
	$win.window('open');

	$("#CopyClose").unbind('click').click(function () {
		$win.window('close');
	})

	//历史年度的下拉框
	var row = $('#budgpurchasingTree').treegrid('getSelected');
	if (row == null) {
		var year = ""
	} else {
		var year = row.Year;
	}

	var year1Obj = $HUI.combobox("#HisYearBox", {
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

		//预算年度的下拉框

		var year1Obj = $HUI.combobox("#BudgYearBox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			onBeforeLoad: function (param) {
				param.str = param.q;
				param.flag = ""

			}
		})

		//保存
		$("#CopySave").unbind('click').click(function () {
			var hisyear = $('#HisYearBox').combobox('getValue');
			var budgyear = $('#BudgYearBox').combobox('getValue');

			if (!hisyear) {
				$.messager.popover({
					msg: '历史年度不能为空！',
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
			if (!budgyear) {
				$.messager.popover({
					msg: '预算年度不能为空！',
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
			$.messager.progress({
				title: '提示',
				msg: '数据保存中...'
			})
			$.m({
				ClassName: "herp.budg.hisui.udata.ubudgpurchasingitems",
				MethodName: "CopyInsert",
				hospid: hospid,
				hisyear: hisyear,
				budgyear: budgyear
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
							top: 0
						}
					});
					$.messager.progress('close');
					$('#budgpurchasingTree').treegrid("collapseAll");
				} else {
					$.messager.popover({
						msg: '保存失败！' + SQLCODE,
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
			$('#budgpurchasingTree').treegrid("unselectAll");
			$win.window('close');
		})
};
