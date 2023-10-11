/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: 全面预算管理-预算编制管理-归口科室年度预算审核
CSPName: herp.budg.hisui.budgschemowndept.csp
ClassName: herp.budg.hisui.udata.uBudgSchemOwnDept
 */
function FYCheckWinShow(schemRow, factYearRow, flag) {

	var FYCheckWinObj = $HUI.window("#FYCheckWin", {
			iconCls: 'icon-w-stamp',
			width: 470,
			height: 300,
			left: ($(window).width() - 470) * 0.5,
			top: ($(window).height() - 300) * 0.5,
			resizable: true,
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			draggable: true,
			modal: true,
			onClose: function () { //关闭关闭窗口后触发
				$("#FYCheckWinForm").form("clear");
			}
		});
		
	$("#FYCheckWin").css("display", "block");

	FYCheckWinObj.open();
	// 表单的垂直居中
	xycenter($("#FYCheckWinCenter"), $("#FYCheckWinForm"));

	//确定
	$("#BtnOk").unbind('click').click(function () {
		var Result = '',
		Desc = '';
		Result = $("#CheckResultCb").combobox("getValue") == undefined ? '' : $("#CheckResultCb").combobox("getValue");
		Desc = $("#CheckDesTxa").val();
		var mainData = '';
		detailData = '';
		//获取方案归口ID及审核信息
		var mainData = Result + "^" + Desc;
		//获取年度预算主表id串
		for (i = 0; i < factYearRow.length; i++) {
			row = factYearRow[i];

			if ((row.IsLast == 1)&&(row.IsCurStep == 1)) {
				if ((flag == "审核") && ((row.EstState == 2) || (row.EstState == 3))) {
					//只取完成、下放状态下的单据
					var tempdata = row.schemAuditIdObjDept+"^"+row.rowid;
					if (detailData == "") {
						detailData = tempdata;
					} else {
						detailData = detailData + "|" + tempdata;
					}
				}
				//alert(row.EstState);
				if ((flag == "下放") && ((row.EstState == 4) || (row.EstState == 5))) {
					//只取完成、下放状态下的单据
					var tempdata = row.schemAuditIdObjDept+"^"+row.rowid;
					if (detailData == "") {
						detailData = tempdata;
					} else {
						detailData = detailData + "|" + tempdata;
					}
				}
			} else {
				continue;
			}

		}

		//alert(mainData + ";" + detailData);

		if (flag == "审核") {
			if (detailData != '') {
				$.m({
					ClassName: 'herp.budg.hisui.udata.uBudgSchemOwnDept',
					MethodName: 'FactYearCheck',
					userid: userid,
					mainData: mainData,
					detailData: detailData
				},
					function (Data) {
					if (Data == 0) {
						$.messager.popover({
							msg: '操作成功！',
							type: 'success',
							timeout: 5000,
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
						FYCheckWinObj.close();
					} else {
						$.messager.popover({
							msg: '操作失败！',
							type: 'error',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
					}
				});
			} else {
				$.messager.popover({
					msg: '请选择未审核的单据!',
					type: 'info',
					timeout: 2000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});

			}
		}

		if (flag == "下放") {
			if (detailData != '') {
				$.m({
					ClassName: 'herp.budg.hisui.udata.uBudgSchemOwnDept',
					MethodName: 'FactYearCheckDown',
					userid: userid,
					mainData: mainData,
					detailData: detailData
				},
					function (Data) {
					if (Data == 0) {
						$.messager.popover({
							msg: '操作成功！',
							type: 'success',
							timeout: 5000,
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
						FYCheckWinObj.close();
					} else {
						$.messager.popover({
							msg: '操作失败！',
							type: 'error',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
					}
				});
			} else {
				$.messager.popover({
					msg: '请选择要下放的单据!',
					type: 'info',
					timeout: 2000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
						top: 10
					}
				});

			}
		}

	});

	//取消
	$("#BtnCancel").unbind('click').click(function () {
		FYCheckWinObj.close();
	});

}
