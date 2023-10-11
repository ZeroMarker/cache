/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: ȫ��Ԥ�����-Ԥ����ƹ���-��ڿ������Ԥ�����
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
			onClose: function () { //�رչرմ��ں󴥷�
				$("#FYCheckWinForm").form("clear");
			}
		});
		
	$("#FYCheckWin").css("display", "block");

	FYCheckWinObj.open();
	// ���Ĵ�ֱ����
	xycenter($("#FYCheckWinCenter"), $("#FYCheckWinForm"));

	//ȷ��
	$("#BtnOk").unbind('click').click(function () {
		var Result = '',
		Desc = '';
		Result = $("#CheckResultCb").combobox("getValue") == undefined ? '' : $("#CheckResultCb").combobox("getValue");
		Desc = $("#CheckDesTxa").val();
		var mainData = '';
		detailData = '';
		//��ȡ�������ID�������Ϣ
		var mainData = Result + "^" + Desc;
		//��ȡ���Ԥ������id��
		for (i = 0; i < factYearRow.length; i++) {
			row = factYearRow[i];

			if ((row.IsLast == 1)&&(row.IsCurStep == 1)) {
				if ((flag == "���") && ((row.EstState == 2) || (row.EstState == 3))) {
					//ֻȡ��ɡ��·�״̬�µĵ���
					var tempdata = row.schemAuditIdObjDept+"^"+row.rowid;
					if (detailData == "") {
						detailData = tempdata;
					} else {
						detailData = detailData + "|" + tempdata;
					}
				}
				//alert(row.EstState);
				if ((flag == "�·�") && ((row.EstState == 4) || (row.EstState == 5))) {
					//ֻȡ��ɡ��·�״̬�µĵ���
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

		if (flag == "���") {
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
							msg: '�����ɹ���',
							type: 'success',
							timeout: 5000,
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
						FYCheckWinObj.close();
					} else {
						$.messager.popover({
							msg: '����ʧ�ܣ�',
							type: 'error',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
					}
				});
			} else {
				$.messager.popover({
					msg: '��ѡ��δ��˵ĵ���!',
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

			}
		}

		if (flag == "�·�") {
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
							msg: '�����ɹ���',
							type: 'success',
							timeout: 5000,
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
						FYCheckWinObj.close();
					} else {
						$.messager.popover({
							msg: '����ʧ�ܣ�',
							type: 'error',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
								top: 10
							}
						});
						$('#schemDetailGrid').datagrid("reload");
					}
				});
			} else {
				$.messager.popover({
					msg: '��ѡ��Ҫ�·ŵĵ���!',
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

			}
		}

	});

	//ȡ��
	$("#BtnCancel").unbind('click').click(function () {
		FYCheckWinObj.close();
	});

}
