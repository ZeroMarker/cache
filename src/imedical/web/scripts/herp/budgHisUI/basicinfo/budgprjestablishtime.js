var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //初始化
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
	// 责任科室的下拉框
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
			}, //复选框
			{
				field: 'rowid',
				title: 'ID',
				width: 80,
				hidden: true
			}, {
				field: 'Year',
				title: '年度',
				width: 80,
				align: 'left'
			}, {
				field: 'DutyDeptDR',
				title: '责任科室ID',
				width: 100,
				hidden: true
			}, {
				field: 'DCode',
				title: '责任科室编码',
				align: 'left',
				width: 120,
				hidden: true
			}, {
				field: 'DName',
				title: '责任科室',
				width: 150,
				align: 'left'
			}, {
				field: 'StartDate',
				title: '编制开始时间',
				align: 'left',
				width: 150,
				editor: {
					type: 'datebox',
					options: {
						required: 'true',
						placeholder:"必选"
					}
				}
			}, {
				field: 'EndDate',
				title: '编制结束时间',
				align: 'left',
				width: 150,
				editor: {
					type: 'datebox',
					options: {
						required: 'true',
						placeholder:"必选"
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
			fitColumns: false, //列固定
			loadMsg: "正在加载，请稍等…",
			autoRowHeight: true,
			rownumbers: true, //行号
			ctrlSelec: true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
			// singleSelect: true, //只允许选中一行
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //页面大小选择列表
			pagination: true, //分页
			fit: true,
			columns: MainColumns,
			rowStyler: function (index, row) {
				if (index % 2 == 1) {
					return 'background-color:#FAFAFA;';
				}
			},
			onClickCell: function (index, field, value) { //在用户点击一个单元格的时候触发
				if ((field == "StartDate") || (field == "EndDate")) {
					$('#MainGrid').datagrid('beginEdit', index); //索引为index的行开启编辑
				}
			},
			toolbar: '#tb'
		});
	//查询函数
	var FindBtn = function () {
		var year = $('#YMbox').combobox('getValue'); // 申请年度
		var DutyDR = $('#DutyDR').combobox('getValue'); // 责任科室
		MainGridObj.load({
			ClassName: "herp.budg.hisui.udata.uBudgPrjEstablishTime",
			MethodName: "List",
			hospid: hospid,
			Year: year,
			DutyDeptDR: DutyDR
		})
	}

	//点击查询按钮
	$("#FindBn").click(FindBtn);

	//保存
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
					msg: '请先选中至少一行数据!',
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
					msg: '没有要保存的数据!',
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
							var message = "必选项不能为空!";
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
										msg: "保存成功！",
										type: 'success',
										style: {
											left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
											top: 10
										}
									});
									return false;
								} else {
									$.messager.popover({
										msg: Year+"-"+DName+"保存失败！" +" "+ Data,
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
										msg: "保存成功！",
										type: 'success',
										style: {
											left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
											top: 10
										}
									});
									return false;
								} else {
									$.messager.popover({
										msg: Year+"-"+DName+"保存失败！" +" "+ Data,
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
	//点击保存按钮
	$("#SaveBn").click(saveOrder);

	/**批量设置截止时间  开始**/
	var SetFun = function () {
		$("#Detailff").form('clear');
		var $win; 
		$win = $('#BtchWin').window({
				title: '批量设置截止时间',
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
				onClose: function () { //关闭关闭窗口后触发
					$("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
				}
			});
		$win.window('open');
		// 年度的下拉框
		var BYMboxObj = $HUI.combobox("#BYMbox", {
				url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
				mode: 'remote',
				delay: 200,
				valueField: 'year',
				textField: 'year',
				value: new Date().getFullYear() + 1, //默认当前年度的下一年
				onBeforeLoad: function (param) {
					param.str = param.q;
				}
			});
		// 责任科室的下拉框
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

		//批量设置
		$("#BtchSave").unbind('click').click(function () {
			var BStdate = "",
			BEddate = ""
			BStdate = $('#BStdate').datebox('getValue');
			BEddate = $('#BEddate').datebox('getValue');
			DutyDeptDR = $('#BDutyDR').combobox('getValue')
			if (!BStdate||!BEddate) {
				var message = "必选项不能为空!";
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
				var message = "开始时间不能大于结束时间!";
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
						msg: '设置成功！',
						type: 'success',
						style: {
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
							top:10
						}
					});
				} else {
					$.messager.popover({
						msg: "保存失败！" + Data,
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
		//取消
		$("#BtchClose").unbind('click').click(function () {
			$win.window('close');
		});

	}
	$("#BatchBn").click(SetFun);
	/**批量设置截止时间  结束**/

}
