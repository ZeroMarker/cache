//编辑窗口
edit = function () {
	var $win;
	var row = $('#budgpurchasingTree').treegrid('getSelected');
	$win = $('#Editwin').window({
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
			resizable: false,
			onBeforeOpen: function () {
				if (row == null) {
					$.messager.popover({
						msg: '请选择所要编辑的行！',
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
					return false;
				}
				$("#IsLast2Box").checkbox('setValue', false)
				$("#editfm").form("reset")
			},
			onOpen: function () {
				$('#Year2Box').val(row.Year);
				$('#Code2Box').val(row.Code);
				$('#ReMark2Box').val(row.ReMark);
				$('#Name2Box').val(row.Name);
				$('#Desc2Box').val(row.Desc);

				var rows = $('#budgpurchasingTree').treegrid('getChildren', row.rowid);
				var obj = JSON.stringify(rows);
				//console.log(JSON.stringify(rows));
				//console.log(row.rowid);
				if (row.IsLast == 1) {
					$('#IsLast2Box').iCheck('check');
					$("#IsLast2Box").iCheck("enable")
				};
				if ((row.IsLast == 0) && (obj == '[]')) {
					$('#IsLast2Box').iCheck('uncheck');
					$("#IsLast2Box").iCheck("enable")
				};
				if ((row.IsLast == 0) && (obj != '[]')) {
					$('#IsLast2Box').iCheck('uncheck');
					$("#IsLast2Box").iCheck("disable")
				}
			},
			onClose: function () { //关闭窗口后触发
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

	//品目名称的监听事件生成拼音码
	$('#Name2Box').keyup(function (event) {
		$('#ReMark2Box').val(makePy($('#Name2Box').val().trim()));
	})

	//保存
	$("#EditSave").unbind('click').click(function () {
		var Level = row.Level;
		var SupCode = row.SupCode;
		var Year = $('#Year2Box').val();
		var Code = $('#Code2Box').val();
		var ReMark = $('#ReMark2Box').val();
		var Desc = $('#Desc2Box').val();
		var Name = $('#Name2Box').val();
		var IsLast = $('#IsLast2Box').checkbox('getValue') ? 1 : 0;
		var rowid = row.rowid;
		var parentid = row._parentId

			$.messager.confirm('确定', '确认保存吗？', function (t) {
				if (t) {
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
								top: 0
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
								top: 0
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
								top: 0
							}
						});
						return;
					}

					var data = "";
					data = rowid + "|" + hospid
						 + "|" + Year
						 + "|" + Code + "|" + Name.replace(/\+/g, '%2B')
						 + "|" + SupCode + "|" + IsLast
						 + "|" + ReMark + "|" + Level
						 + "|" + Desc.replace(/\+/g, '%2B')

						$.messager.progress({
							title: '提示',
							msg: '数据保存中...'
						})
						$.m({
							ClassName: "herp.budg.hisui.udata.ubudgpurchasingitems",
							MethodName: "Update",
							data: data,
							rowid: rowid
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

								$("#budgpurchasingTree").treegrid("reload", parentid);

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
				}
			})
	})
};
