//页面Event
function InitCPImplWinEvent(obj) {

	obj.LoadEvent = function (args) {
		obj.InitCPWInfo();	//路径信息
		obj.tabType = "T";
		obj.tabVarType = "I";
		obj.FormID="";
		$HUI.tabs("#CPW-main", {
			onSelect: function (title) {
				switch (title) {
					case "主要诊疗工作":
						obj.tabType = "T";
						obj.TQueryLoad();
						break;
					case "主要护理工作":
						obj.tabType = "N";
						obj.NQueryLoad();
						break;
					case "重点医嘱":
						obj.tabType = "O";
						obj.OQueryLoad();
						break;
					case "变异原因":
						obj.tabType = "V";
						obj.tabVarType = "N";
						obj.VQueryLoad();
						break;

				}

			}
		});
		if (UserType == "N") {
			$('#CPW-main').tabs('select', "主要护理工作");
		}
		$HUI.tabs("#CPW-Var", {
			onSelect: function (title) {
				switch (title) {
					case "路径外医嘱":
						obj.tabVarType = "O";
						obj.VQueryLoad();
						break;
					case "表单项目":
						obj.tabVarType = "I";
						obj.VQueryLoad();
						break;
					case "未执行项目":
						obj.tabVarType = "N";
						obj.VQueryLoad();
						break;
				}
			}
		});
		//查看本科室路径(未入径页面)
		$('#LookCPWList').on('click', function () {
			obj.ShowCPWList(session['DHCMA.CTLOCID'],obj.searchValue);
		});
		if (UserType == "N") {
			$('#LookCPWList').linkbutton("disable");//路径列表按钮
		}
		//更多按钮
		$('#StepMore').on('click', function () {
			var Emvalue = $('#StepMore').attr("value");
			obj.ShowStepMore(Emvalue);
		});
		//切换路径弹窗
		$('#btnChange').on('click', function () {
			obj.ShowChangeCPW();
		})
		//切换
		$('#btn-CgCPWDialog').on('click', function () {
			if(obj.NewStepID){
				obj.BtnChangeCPW();
			}else{ 
				$.messager.popover({
							msg: '请选择目标阶段',
							type: 'error',
							style: {
								top: 150,
								left: 450
							}
						});
			}
			
		})
		//医生签名
		$('#btnDoc').on('click', function () {
			obj.SignStep();
		})
		//护士签名
		$('#btnNur').on('click', function () {
			obj.SignStep();
		})
		//确定按钮
		$('#btnSave').on('click', function () {
			obj.ConfirmStep();
		})
		//出径弹窗
		$('#btnOut').on('click', function () {
			$HUI.dialog('#OutCPWDialog').open();
		})
		//出径
		$('#btn-OutCPWDialog').on('click', function () {
			obj.OutCPW();
		})
		//展现单病种表单
		$('#btnSD').on('click', function () {
			obj.ShowSD();
		})
		//完成
		$('#btnClose').on('click', function () {
			obj.CloseCPW();
		})
		//未执行项目保存变异信息
		$('#Var-Item-Save').on('click', function () {
			obj.SaveItemVar();
		})
		//未执行项目撤销变异信息
		$('#Var-Item-Cancel').on('click', function () {
			obj.CancelItemVar();
		})
		//路径外医嘱保存变异信息
		$('#Var-Order-Save').on('click', function () {
			obj.SaveOrderVar();
		})
		//路径外医嘱撤销变异信息
		$('#Var-Order-Cancel').on('click', function () {
			obj.CancelOrderVar();
		})
		$('#PrintCPWInformedConsert').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("#PrintCPWInformedConsert");  //打印任务的名称
			var PrintUrl="./dhcma.cpw.cp.consentprint.csp?EpisodeID="+EpisodeID;
			LODOP.ADD_PRINT_URL("2cm","0","100%","100%",PrintUrl);
			LODOP.PRINT();
		});
		$('#PrintCPWInform').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintCPWInform");  //打印任务的名称
			var PrintUrl="./dhcma.cpw.cp.lodopprint.csp?EpisodeID="+EpisodeID;
			LODOP.ADD_PRINT_URL("1mm","1mm","100%","100%",PrintUrl);
			LODOP.PRINT();
		});
		$('#btnShow').on('click', function () {
			var FormUrl="./dhcma.cpw.cp.form.csp?EpisodeID="+EpisodeID+"&UserType="+UserType;
			websys_showModal({
				url:FormUrl,
				title:'表单总览',
				iconCls:'icon-w-import',  
				closable:true,
				originWindow:window,
				width:screen.availWidth-200,
				height:screen.availHeight-200
			});	
		});
	}
	/* 页面操作控制,控制顺序不可变
	 * 控制顺序：
	 *	1、角色控制
	 *	2、阶段状态控制
	 *	3、路径状态控制
	 */
	obj.OperationControl = function () {
		//角色控制
		obj.ShowByUserType();
		//阶段状态控制
		obj.ShowByStepStatus();
		//路径状态控制
		obj.ShowByCPWStatus();
	}

	/*	按用户类型控制页面及操作
	 *	UserType在CSP中定义
	 *	D医生，N护士，空管理员
	 */
	obj.ShowByUserType = function () {
		if (UserType == "D") {
			$("#btnSave").linkbutton("enable");
			$("#CPWPatList").lookup("disable");
			$("#btnDoc").linkbutton("enable");
			$("#btnNur").linkbutton("disable");
			$(".img-NOper").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".img-NOper").attr("title", "禁止操作");
			$(".img-NOper").attr("onclick", "");
		} else if (UserType == "N") {
			$("#btnNur").linkbutton("enable");
			$("#btnDoc").linkbutton("disable");
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnClose").linkbutton("disable");	//完成按钮
			$("#btnOut").linkbutton("disable");		//出径按钮
			$("#btnChange").linkbutton("disable");	//切换路径按钮
			$('#LookCPWList').linkbutton("disable");//路径列表按钮
			$("#btnChange").css("background-color", "#BBBBBB");
			$(".img-TOper").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".img-TOper").attr("title", "禁止操作");
			$(".img-TOper").attr("onclick", "");
		} else {
			$("#btnNur").linkbutton("disable");
			$("#btnDoc").linkbutton("disable");
		}

	}
	/*	按用阶段状态控制页面及操作
	 *	非当前状态控制
	 *	阶段确定控制
	 */
	obj.ShowByStepStatus = function () {
		//非当前阶段
		if (obj.CurrIndex != obj.SelectedIndex) {
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnNur").linkbutton("disable");
			$("#btnDoc").linkbutton("disable");
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", "禁止操作");
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text("请选择【当前阶段】后，继续各项操作！")
		} else {
			$('#Var-Item-Save').linkbutton("enable");
			$('#Var-Item-Cancel').linkbutton("enable");
			$('#Var-Order-Save').linkbutton("enable");
			$('#Var-Order-Cancel').linkbutton("enable");
			$("#foot-note").text("请按照本阶段内容执行！")
		}
	}
	obj.ShowByCPWStatus = function () {
		if (obj.CPWStatus == "出径") {
			$("#btnDoc").linkbutton("disable");		//医生签名
			$("#btnNur").linkbutton("disable");		//护士签名
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnClose").linkbutton("disable");	//完成按钮
			$("#btnOut").linkbutton("disable");		//出径按钮
			$("#btnChange").linkbutton("disable");	//切换路径按钮
			$("#btnChange").css("background-color", "#BBBBBB");
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", "禁止操作");
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text("该临床路径已经【" + obj.CPWStatus + "】，禁止做任何操作！")
		} else if (obj.CPWStatus == "完成") {
			$("#btnDoc").linkbutton("disable");		//医生签名
			$("#btnNur").linkbutton("disable");		//护士签名
			$("#btnSave").linkbutton("disable");	//确定按钮
			$("#btnClose").linkbutton("disable");	//完成按钮
			$("#btnOut").linkbutton("disable");		//出径按钮
			$("#btnChange").linkbutton("disable");	//切换路径按钮
			$("#btnChange").css("background-color", "#BBBBBB");
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", "禁止操作");
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text("该临床路径已经【" + obj.CPWStatus + "】，禁止做任何操作！")
		} else {	//入径

		}
	}
	obj.SaveItemVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Item').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: '请选择项目',
						type: 'error',
						style: {
							top: 150,
							left: 450
						}
					});
					return;
				}
				for (var ind = 0, len = rows.length; ind < len; ind++) {
					var RowIndex = $('#tb-Variation-Item').datagrid("getRowIndex", rows[ind]);
					var ed = $('#tb-Variation-Item').datagrid('getEditor', { index: RowIndex, field: 'VariatTxt' });
					var VariatTxt = ""
					if (ed) VariatTxt = $(ed.target).val();
					var rowData = rows[ind]
					var Node = $('#ItemTree').tree('getSelected');
					var EpisID = obj.PathwayID + "||" + obj.StepSelecedID;
					var ImplID = obj.PathwayID + "||" + rowData['ImplID'];
					var OrdDID = "";
					var InputStr = obj.PathwayID + "^" + rowData['VarID'] + "^" + Node.id.split("-")[1] + "^" + VariatTxt + "^" + EpisID + "^" + ImplID + "^" + OrdDID + "^" + session['DHCMA.USERID'];
					var ret = $m({
						ClassName: "DHCMA.CPW.CP.PathwayVar",
						MethodName: "Update",
						aInputStr: InputStr,
						aSeparete: "^"
					}, false)

					if (parseInt(ret) > 0) {
						$('#tb-Variation-Item').datagrid("uncheckRow", RowIndex);
					}
				}
				$('#tb-Variation-Item').datagrid('reload');
				$('#ItemTree').find('.tree-node-selected').removeClass('tree-node-selected');
			} else {
				$.messager.popover({
					msg: '不能选择原因分类',
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
				return;
			}
		} else {
			$.messager.popover({
				msg: '请选择变异原因',
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	obj.CancelItemVar = function () {
		var DocSignText=$('#SignDoc').val();
		var NurSignText=$('#SignNur').val();
		if(DocSignText!=""&&NurSignText!="") {
			$.messager.popover({msg:"医生和护士已经签名，不能撤销！",type:'error'});
			return;
		}
		var rows = $('#tb-Variation-Item').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: '请选择项目',
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
		for (var ind = 0, len = rows.length; ind < len; ind++) {
			var RowIndex = $('#tb-Variation-Item').datagrid("getRowIndex", rows[ind]);
			var VarID = rows[ind]['VarID'];
			if (VarID == "") continue;
			$m({
				ClassName: "DHCMA.CPW.CP.PathwayVar",
				MethodName: "Invalid",
				aID: obj.PathwayID + "||" + VarID,
				aUserID: session['DHCMA.USERID']
			}, false)
			$('#tb-Variation-Item').datagrid("uncheckRow", RowIndex);
		}
		$('#tb-Variation-Item').datagrid('reload');
	}
	obj.SaveOrderVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Order').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: '请选择医嘱',
						type: 'error',
						style: {
							top: 150,
							left: 450
						}
					});
					return;
				}
				for (var ind = 0, len = rows.length; ind < len; ind++) {
					var RowIndex = $('#tb-Variation-Order').datagrid("getRowIndex", rows[ind]);
					var Node = $('#ItemTree').tree('getSelected');
					var ed = $('#tb-Variation-Order').datagrid('getEditor', { index: RowIndex, field: 'VariatTxt' });
					var VariatTxt = ""
					if (ed) VariatTxt = $(ed.target).val();
					var EpisID = obj.PathwayID + "||" + obj.StepSelecedID;
					var ImplID = "";	//路径外医嘱没有关联项目
					var rowData = rows[ind]
					var OrdDID = rowData['OrdDID'];
					var InputStr = obj.PathwayID + "^" + rowData['VarID'] + "^" + Node.id.split("-")[1] + "^" + VariatTxt + "^" + EpisID + "^" + ImplID + "^" + OrdDID + "^" + session['DHCMA.USERID']+"^1";
					ret = $m({
						ClassName: "DHCMA.CPW.CP.PathwayVar",
						MethodName: "Update",
						aInputStr: InputStr,
						aSeparete: "^"
					}, false)
					if (parseInt(ret) > 0) {
						$('#tb-Variation-Order').datagrid("uncheckRow", RowIndex);
					}
				}
				$('#tb-Variation-Order').datagrid('reload');
				$('#ItemTree').find('.tree-node-selected').removeClass('tree-node-selected');
			} else {
				$.messager.popover({
					msg: '不能选择原因分类',
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
				return;
			}
		} else {
			$.messager.popover({
				msg: '请选择变异原因',
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	obj.CancelOrderVar = function () {
		var rows = $('#tb-Variation-Order').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: '请选择医嘱',
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
		for (var ind = 0, len = rows.length; ind < len; ind++) {
			var RowIndex = $('#tb-Variation-Order').datagrid("getRowIndex", rows[ind]);
			var VarID = rows[ind]['VarID'];
			if (VarID == "") continue;
			$m({
				ClassName: "DHCMA.CPW.CP.PathwayVar",
				MethodName: "Invalid",
				aID: obj.PathwayID + "||" + VarID,
				aUserID: session['DHCMA.USERID']
			}, false)
			$('#tb-Variation-Order').datagrid("uncheckRow", RowIndex);
		}
		$('#tb-Variation-Order').datagrid('reload');
	}
	obj.OutCPW = function () {
		var verID = Common_GetValue('OutReason')
		var verTxt = Common_GetValue('OutText')
		var errorInfo = "";
		if (verID == "") {
			errorInfo = "请选择出径原因！<br />"
		}
		if (verTxt == "") {
			errorInfo = errorInfo + "请填写备注信息！"
		}
		if (errorInfo != "") {
			$.messager.alert("错误提示", errorInfo, "error")
			return;
		}
		$m({
			ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
			MethodName: "GetOutCPW",
			aEpisodeID: EpisodeID,
			aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID'] + "^" + verID + "^" + verTxt
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({ msg: "操作成功", type: 'success' });
				$HUI.dialog('#OutCPWDialog').close();
				obj.InitCPWInfo();
				obj.OperationControl();
			}
		})
	}
	obj.CloseCPW = function () {
		//最后一个阶段是否确定
		if (obj.ConfList.slice(-1) != 1) {
			$.messager.popover({ msg: "还有阶段未确定，禁止此操作", type: 'error' });
			return;
		}
		$.messager.confirm("完成", "确定完成?<br />完成后将不能再做任何修改！", function (r) {
			if (r) {
				$m({
					ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
					MethodName: "CloseCPW",
					aEpisodeID: EpisodeID,
					aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID']
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$.messager.popover({ msg: "操作成功", type: 'success' });
						obj.InitCPWInfo();
						obj.OperationControl();
					}
				})
			} else {

			}
		});
	}
	obj.ConfirmStep = function () {
		var DateFrom = $('#DateFrom').datebox('getValue');
		var DateTo = $('#DateTo').datebox('getValue');
		if (DateFrom == "") {
			$.messager.popover({ msg: "开始日期不能为空", type: 'error' });
			return;
		} else {
			if (DateTo == "") {
				$.messager.popover({ msg: "结束日期不能为空", type: 'error' });
				return;
			} else {
				var flg = Common_CompareDate(DateFrom, DateTo);
				if (flg) {
					$.messager.popover({ msg: "结束日期不能小于开始日期", type: 'error' });
					return;
				}
			}
		}
		//检查阶段日期是否合法
		var CheckStepDateMsg = $m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "CheckStepDate",
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aSttDate: DateFrom
		}, false)
		if (CheckStepDateMsg != "") {
			$.messager.popover({ msg: CheckStepDateMsg, type: 'error' });
			return;
		}
		var DocSignText = $('#SignDoc').val();
		var NurSignText = $('#SignNur').val();
		//通过配置信息判断是否检查签名
		var strCheckSign = $m({
			ClassName: "DHCMA.Util.BT.Config",
			MethodName: "GetValueByCode",
			aCode: "CPWCheckSignBeforeClose"
		}, false)
		if (strCheckSign == "") strCheckSign = "Y||0"	//默认强制医护签名
		var SignMsg = ""
		var arrCheckSign = strCheckSign.split("||");
		if (arrCheckSign[1] == "0") {
			if ((DocSignText == "") || (NurSignText == "")) {
				SignMsg = "医生或护士没有签名，";
			}
		} else if (arrCheckSign[1] == "1") {
			if (DocSignText == "") {
				SignMsg = "医生没有签名，";
			}
		} else if (arrCheckSign[1] == "2") {
			if (NurSignText == "") {
				SignMsg = "护士没有签名，";
			}
		} else {
		}

		if ((SignMsg != "") && (arrCheckSign[0] == "Y")) {
			$.messager.popover({ msg: SignMsg + "禁止此操作", type: 'error' });
			return;
		}

		$.messager.confirm("确定", SignMsg + "确定后将不能再做任何修改！", function (r) {
			if (r) {
				//继续操作
				var NextEpisID = ""
				var NextIndex = parseInt(obj.CurrIndex) + 1;
				if (NextIndex < obj.StepList.length) {
					var NextStep = obj.StepList[NextIndex];
					var NextEpisID = NextStep.split(":")[0];	//下一个步骤的ID
					NextEpisID = obj.PathwayID + "||" + NextEpisID;
				}
				$m({
					ClassName: "DHCMA.CPW.CPS.ImplementSrv",
					MethodName: "ConfirmStep",
					aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
					aSttDate: DateFrom,
					aEndDate: DateTo,
					aUserID: session['DHCMA.USERID'],
					aNextEpisID: NextEpisID
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$.messager.popover({ msg: "确定成功", type: 'success' });
						obj.InitCPWSteps();	//步骤信息
					}
				})
			} else {
				return;
			}
		})

	}
	obj.SignStep = function () {
		var VarCount = $cm({ ClassName: "DHCMA.CPW.CPS.ImplementSrv", MethodName: "CheckVarToSign", aPathwayID: obj.PathwayID, aEpisID: obj.PathwayID + "||" + obj.StepSelecedID, aSignType: UserType }, false);
		if (parseInt(VarCount) > 0) {
			$.messager.popover({ msg: "有变异信息未处理，不允许签名", type: 'error' });
			$('#CPW-main').tabs('select', "变异原因");
			return;
		}
		var SignText = "";
		if (UserType == "D") SignText = $('#SignDoc').val();
		if (UserType == "N") SignText = $('#SignNur').val();
		if (SignText != "") {
			$.messager.popover({ msg: "不能重复签名", type: 'error' });
			return;
		}

		var strCheckItm = $m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "CheckHaveUnExItm",
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID + "||" + obj.StepCurrID,
			aUserType: UserType
		}, false)
		if (strCheckItm == "1") {
			$.messager.confirm("提示", "存在未执行的非必选项目，确定不执行？", function (r) {
				if (r) {
					$.messager.confirm("签名", "确定签名?<br />签名信息：" + session['LOGON.USERNAME'], function (r) {
						if (r) {
							//继续执行
							var ret=$m({
								ClassName: "DHCMA.CPW.CP.PathwayEpis",
								MethodName: "Sign",
								aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
								aUserID: session['DHCMA.USERID'],
								aUserType: UserType
							}, false)
							if (parseInt(ret) > 0) {
								$.messager.popover({ msg: "签名成功！", type: 'success' });
								obj.InitCPWSteps();	//步骤信息
							}
						} else {
							$.messager.popover({ msg: "签名取消" });
							return;
						}
					});
				} else {
					return;
				}
			});
		}else{
			$.messager.confirm("签名", "确定签名?<br />签名信息：" + session['LOGON.USERNAME'], function (r) {
				if (r) {
					//继续执行
					var ret=$m({
							ClassName: "DHCMA.CPW.CP.PathwayEpis",
							MethodName: "Sign",
							aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
							aUserID: session['DHCMA.USERID'],
							aUserType: UserType
					}, false)
					if (parseInt(ret) > 0) {
						$.messager.popover({ msg: "签名成功！", type: 'success' });
						obj.InitCPWSteps();	//步骤信息
					}
				} else {
					$.messager.popover({ msg: "签名取消" });
							return;
				}
			});
		}
	}
	//路径信息
	obj.InitCPWInfo = function () {
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetCPWInfo",
			aEpisodeID: EpisodeID
		}, function (JsonStr) {
			if (JsonStr == "") return;
			var JsonObj = $.parseJSON(JsonStr);
			obj.CPWCurrDesc = JsonObj.CPWDesc;		//当前步骤名称
			obj.CPWStatus = JsonObj.CPWStatus;		//当前路径状态
			obj.PathFormID = JsonObj.PathFormID		//当前路径的表单ID
			obj.PathwayID = JsonObj.PathwayID			//出入径记录ID

			$('#CPWDesc').text(JsonObj.CPWDesc)
			$('#CPWStatus').text(JsonObj.CPWStatus)
			$('#CPWUser').text(JsonObj.CPWUser)
			$('#CPWTime').text(JsonObj.CPWTime)

			var htmlIcon = ""
			htmlIcon = htmlIcon + '<span class="Icon Icon-D">单</span>'
			htmlIcon = htmlIcon + '<span class="Icon Icon-B">变</span>'
			htmlIcon = htmlIcon + '<span class="Icon Icon-T">T</span>'
			htmlIcon = htmlIcon + '<span class="Icon Icon-Y">¥</span>'
			$('#CPWIcon').html(htmlIcon)
			$(".Icon-D").popover({
				content: '单病种信息：' + JsonObj.SDDesc
			});
			$(".Icon-B").popover({
				content: JsonObj.VarDesc
			});
			$(".Icon-T").popover({
				content: '入径天数：' + JsonObj.CPWDays + '天<br />计划天数：' + JsonObj.FormDays + '天'
			});
			$(".Icon-Y").popover({
				content: '住院总费用：' + JsonObj.PatCost + '<br />计划费用：' + JsonObj.FormCost + '元'
			});

			$m({
				ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
				MethodName: "GetPatName",
				aEpisodeID: EpisodeID
			}, function (PatName) {
				$("#CPWPatList").lookup("setText", PatName);
			});

			obj.InitCPWSteps();	//步骤信息
			
			//单病种入组->表单展现
			$m({
				ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
				MethodName: "GetMrListIDByCPID",
				CPID: obj.PathwayID
			}, function (MrListID) {
				if (MrListID>0) {
					obj.MrListID=MrListID
					$("#btnSD").show();
				}
			})
		});
	}

	//获取路径步骤列表
	obj.InitCPWSteps = function () {
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetCPWSteps",
			aPathwayID: obj.PathwayID
		}, function (StepsStr) {
			var StepsArr = StepsStr.split("#");
			var StepCurr = StepsArr[0];
			if (StepCurr == "") return;

			obj.StepCurrID = StepCurr.split(":")[0];			//已经执行到当前步骤的ID
			obj.StepCurrDesc = StepCurr.split(":")[1];		//已经执行到当前步骤的Desc
			obj.StepList = StepsArr[1].split("^");			//该路径所有步骤数组，ID:Desc
			obj.TimeList = StepsArr[2].split("^");			//该路径所有步骤起止时间数组，EpDays:SttDate:EndDate
			obj.ConfList = StepsArr[3].split("^");			//该路径所有步骤是否确定数组，1、0
			obj.SignList = StepsArr[4].split("^");			//该路径所有步骤签名信息数组，SignDoc:SignNur:SignDocDate:SignNurDate
			obj.NoteList = StepsArr[5].split("^");	
			obj.CurrIndex = obj.StepList.indexOf(StepCurr);	//已经执行到当前步骤的下标
			obj.StepSelecedID = obj.StepCurrID;				//点击选中的步骤ID
			
			//展现步骤
			obj.ShowCPWSteps(obj.CurrIndex);
			//绑定点击事件
			$('#StepMoreList .selectStepMore').on('click', function () {
				obj.SelectStep(this.id);
			});
			$('#StepShow .node').on('click', function () {
				var SelectedStepID = this.id.split("-")[1];
				obj.StepSelecedID = SelectedStepID;
				obj.SelectStep(this.id);
				obj.ShowStepDetail(this.id);
			});
			//展现步骤内容
			obj.SelectStep("Step-" + obj.StepCurrID);
		});
	}

	//展现步骤
	obj.ShowCPWSteps = function (selectIndex) {
		var StepSelect = obj.TimeList[selectIndex].split(":");
		$('#StepTime').text(StepSelect[0]);
		$('#DateFrom').datebox('setValue', StepSelect[1]);
		$('#DateTo').datebox('setValue', StepSelect[2]);
		var StepSign = obj.SignList[selectIndex].split(":");
		$('#SignDoc').val(StepSign[0]);
		$('#SignNur').val(StepSign[1]);

		var StepShow = [];	//显示出来的步骤
		var StepMore = [];	//更多的步骤
		
		var NumOfStepShow=6; //页面显示步骤个数
		var startStep=selectIndex;
		var endStep=selectIndex;
		
		while((endStep-startStep+1)!=NumOfStepShow){
			if((startStep-1)>-1) startStep--;
			if(((endStep+1)<obj.StepList.length)&&((endStep-startStep+1)!=NumOfStepShow)) endStep++;
			if((endStep-startStep+1)==obj.StepList.length) break;
		}
		
		for (var ind = 0; ind < obj.StepList.length; ind++) {
			if((ind<startStep)||(ind>endStep)){
				StepMore.push(obj.StepList[ind]);
			}else{
				StepShow.push(obj.StepList[ind]);
			}
		}
		
		var StepClass = "";
		var StepShowHtml = "";
		var lineNum=(obj.StepList.length < NumOfStepShow)?obj.StepList.length:NumOfStepShow;
		var linewidth=(lineNum-1)*180;
		var innerHTML = '<i id="line" style="width:'+linewidth+'px;"></i>'
    	innerHTML = innerHTML + '<ul class="timeline">';
		for (var ind = 0, len = StepShow.length; ind < len; ind++) {
			var StepIndex = obj.StepList.indexOf(StepShow[ind]);
			if (StepIndex < obj.CurrIndex) {
				var li_class="steppre";
			} else if (StepIndex > obj.CurrIndex) {
				var li_class="stepaft";
			} else {
				var li_class="stepcurr on";
			}
			
			var tmpStep = StepShow[ind].split(":");
			var nodeHtml = "";
	        var icon=""
	        var Note=obj.NoteList[StepIndex].split(":");
	        var icon="";
	        if(Note[0].indexOf("F")>-1){
	        	icon=icon+'<span title="入径：'+Note[1]+'" class="hisui-tooltip" data-options="position:\'bottom\'"><i class="icon icon-arrow-right">&nbsp&nbsp&nbsp&nbsp</i></span>'
	        }
	        if(Note[0].indexOf("E")>-1){
	        	icon=icon+'<span title="正常执行：'+Note[1]+'" class="hisui-tooltip" data-options="position:\'bottom\'"><i class="icon icon-arrow-blue">&nbsp&nbsp&nbsp&nbsp</i></span>'
	        }
	        if(Note[0].indexOf("S")>-1){
	        	icon=icon+'<span title="切换路径：'+Note[1]+'" class="hisui-tooltip" data-options="position:\'bottom\'"><i class="icon icon-switch">&nbsp&nbsp&nbsp&nbsp</i></span>'
	        } 
	        if(Note[0].indexOf("O")>-1){
	        	icon=icon+'<span title="退出路径：'+Note[1]+'" class="hisui-tooltip" data-options="position:\'bottom\'"><i class="icon icon-unuse">&nbsp&nbsp&nbsp&nbsp</i></span>'
	        }
	        if(Note[0].indexOf("C")>-1){
	        	icon=icon+'<span title="完成路径：'+Note[1]+'" class="hisui-tooltip" data-options="position:\'bottom\'"><i class="icon icon-accept">&nbsp&nbsp&nbsp&nbsp</i></span>'
	        }
	       
	        nodeHtml = nodeHtml + '<li class="node '+li_class+'" id="Step-' + tmpStep[0] + '">';
	        nodeHtml = nodeHtml + '<a href="javascript:;">';
	        nodeHtml = nodeHtml + '<div>'+icon+'<span id="nodeDesc-'+ tmpStep[0] +'">' + tmpStep[1] + '</span></div>';
	        nodeHtml = nodeHtml + '<div class="circle">';
	        nodeHtml = nodeHtml + '<i class="dot"></i>';
	        nodeHtml = nodeHtml + '</div>';
	        nodeHtml = nodeHtml + '</a>';
	        nodeHtml = nodeHtml + '</li>';
			console.log(nodeHtml)
	        innerHTML = innerHTML + nodeHtml;
		}
		innerHTML = innerHTML + '</ul>'
		
		$('#StepShow').html(innerHTML);

		var StepMoreHtml = "";
		for (var ind = 0, len = StepMore.length; ind < len; ind++) {
			var StepIndex = obj.StepList.indexOf(StepMore[ind]);
			if (StepIndex < obj.CurrIndex) {
				StepClass = "steppre";	//已执行
			} else if (StepIndex > obj.CurrIndex) {
				StepClass = "stepaft";	//未执行
			} else {
				StepClass = "stepcurr";	//当前步骤
			}
			var tmpStep = StepMore[ind].split(":");
			StepMoreHtml = StepMoreHtml + "<div id='nodeDesc-" + tmpStep[0] + "' class='selectStepMore " + StepClass + "'>" + tmpStep[1] + "</div>"
		}
		$('#StepMoreList').html(StepMoreHtml);
	}
	obj.SelectStep = function (IDStr) {
		var SelectedStepID = IDStr.split("-")[1];
		var SelectedStepText = $("#nodeDesc-" + SelectedStepID).text();
		var SelectedStep = SelectedStepID + ":" + SelectedStepText;
		var SelectedIndex = obj.StepList.indexOf(SelectedStep);
		obj.StepSelecedID = SelectedStepID;
		obj.SelectedIndex = SelectedIndex;
		//调整并展现步骤
		obj.ShowCPWSteps(SelectedIndex);
		//展现步骤内容
		obj.ShowStepDetail(IDStr);

		//绑定点击事件
		$('#StepMoreList .selectStepMore').on('click', function () {
			obj.SelectStep(this.id);
		});
		$('#StepShow .node').on('click', function () {
			var SelectedStepID = this.id.split("-")[1];
			obj.StepSelecedID = SelectedStepID;
			obj.SelectStep(this.id);
			obj.ShowStepDetail(this.id);
		});
		obj.ShowStepMore(0)	//关闭更多步骤
		//已经确定的步骤不能再操作
		obj.OperationControl();
		obj.VQueryLoad(); //dsp
	}

	obj.ShowStepDetail = function (IDStr) {
		$("#StepShow .node").removeClass('on');
		$("#" + IDStr).addClass('on');

		switch (obj.tabType) {
			case "T":
				obj.TQueryLoad();
				break;
			case "N":
				obj.NQueryLoad();
				break;
			case "O":
				obj.OQueryLoad();
				break;
			case "V":
				obj.VQueryLoad();
				break;
		}
	}

	obj.ShowStepMore = function (Emvalue) {
		if (Emvalue == 1) {
			$('#StepMoreList').css('display', 'block');
			$('#StepMore').attr("value", 0);
			$('#StepMore').text("收起▲");
		} else {
			$('#StepMore').text("更多▼");
			$('#StepMore').attr("value", 1);
			$('#StepMoreList').css('display', 'none');
		}
	}

	obj.TQueryLoad = function () {
		obj.gridTreatment.load({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			QueryName: "QryCPWStepInfo",
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aType: "T"
		});
	}
	obj.NQueryLoad = function () {
		obj.gridNursing.load({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			QueryName: "QryCPWStepInfo",
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aType: "N"
		});
	}
	obj.OQueryLoad = function () {
		obj.gridOrder.load({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			QueryName: "QryCPWStepInfo",
			aPathwayID: obj.PathwayID,
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aType: "O"
		});
	}
	obj.VQueryLoad = function () {
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetVariatTree",
			aTypeCode: "01",
			aCatCode: ""
		}, function (treeJson) {
			var dataArr = $.parseJSON(treeJson)
			$('#ItemTree').tree({
				data: dataArr,
				formatter: function (node) {
					//formatter  此时isLeaf方法还无法判断是不是叶子节点 可通过children
					if (node.children) {
						return node.text;
					} else {
						len = node.text.length;
						if (len < 15) {
							return node.text;
						} else {
							return node.text.substring(0, 15) + "<br />" + node.text.substring(15)
						}
						/* return "<div >"
							+"<span data-id='"+node.id+"' class='icon-write-order' style='display:block;width:16px;height:16px;position:absolute;right:5px;top:5px;'></span>"
							+"<div style='height:20px;line-height:20px;color:gray'>"+(new Date()).toLocaleString()+"</div>"
							+"<div style='height:20px;line-height:20px;'>"+node.text+"</div>"
							+"</div>";
						//同时给此树下的tree-node 加上position: relative;   以实现小图标靠右 */
					}

				},
				onClick: function (node) {

				},
				lines: true, autoNodeHeight: true
			})
		});

		if (obj.tabVarType == "O") {
			obj.gridVarOrder.load({
				ClassName: "DHCMA.CPW.CPS.ImplementSrv",
				QueryName: "QryCPWVarOrder",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID
			});
		} else if(obj.tabVarType == "N") {
			obj.gridVarItem.load({
				ClassName: "DHCMA.CPW.CPS.ImplementSrv",
				QueryName: "QryCPWVarItem",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID
			});
		}

	}
	obj.ExecuteItem = function (ItemID) {
		$m({
			ClassName: "DHCMA.CPW.CP.PathwayImpl",
			MethodName: "ExecuteItem",
			aPathwayID: obj.PathwayID,
			aItemID: ItemID,
			aOrdDID: "",
			aUserID: session['DHCMA.USERID'],
			aIsImpl: 1,
			aIsSystem: 0
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({
					msg: '执行成功',
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: '执行失败,ret=' + ret,
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
			}
		});
		obj.ShowStepDetail("Step-" + obj.StepSelecedID);
	}
	obj.CancelItem = function (ItemID) {
		$m({
			ClassName: "DHCMA.CPW.CP.PathwayImpl",
			MethodName: "ExecuteItem",
			aPathwayID: obj.PathwayID,
			aItemID: ItemID,
			aOrdDID: "",
			aUserID: session['DHCMA.USERID'],
			aIsImpl: 0,
			aIsSystem: 0
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({
					msg: '撤销成功',
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: '撤销失败',
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
			}
		});
		obj.ShowStepDetail("Step-" + obj.StepSelecedID);
	}

	//切换路径
	obj.ShowChangeCPW = function () {
		$('#CgStepList').html("");
		$('#CgStepDetail').html("");
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetCPWList",
			aPathFormID: obj.PathFormID,
			//增加科室常用路径判断
			aAdmLocID: session['DHCMA.CTLOCID']
		}, function (CPWList) {
			if (CPWList == "") {
				$.messager.popover({
					msg: '没有可切换的路径',
					type: 'error',
					style: {
						top: 150,
						left: 450
					}
				});
				return;
			}
			var CPWHtml = "";
			var CPWArr = CPWList.split("^");
			for (var ind = 0, len = CPWArr.length; ind < len; ind++) {
				var tmpCPW = CPWArr[ind].split(":");
				CPWHtml = CPWHtml + "<input class='hisui-radio' type='radio' label='" + tmpCPW[1] + "' value='" + tmpCPW[0] + "' name='ipCPWList' id='CPW-" + tmpCPW[0] + "'>";
				if ((ind + 1) % 4 == 0) CPWHtml = CPWHtml + "<br />";
			}
			$('#CgCPWlist').html(CPWHtml)
			$HUI.radio("#CgCPWlist input.hisui-radio", {});
			//$HUI.radio("#CPW-"+CPWArr[0].split(":")[0]).setValue(true);	//默认选中第一个
			$('#CurrCPWDesc').text(obj.CPWCurrDesc);
			$('#CurrStepDesc').text(obj.StepCurrDesc);
			$HUI.radio("[name='ipCPWList']", {
				onChecked: function (e) {
					var CgCPWID = $(e.target).attr("value");
					obj.ShowCgSteps(CgCPWID);
				}
			});
			$HUI.dialog('#ChangeCPWDialog').open();
		});

	}
	obj.BtnChangeCPW = function () {
		/*add by xwj 2019-07-31*/
		var StepList = document.getElementById("CgStepList");
		if (StepList.innerHTML== "") {
			$.messager.alert("提示", "请选择切换的路径及阶段!", 'info');
			return   		
		}
		//end
		$.messager.prompt("提示", "切换原因", function (note) {
			if (note) {
				$m({
					ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
					MethodName: "SwitchCPW",
					aEpisodeID: EpisodeID,
					aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + obj.NewFormID + "^" + obj.NewStepID + "^" + note
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$HUI.dialog('#ChangeCPWDialog').close();
						$.messager.popover({
							msg: '切换成功',
							type: 'success',
							style: {
								top: 150,
								left: 450
							}
						});
						window.location.reload();	//刷新页面
					} else {
						$.messager.popover({
							msg: '切换失败',
							type: 'error',
							style: {
								top: 150,
								left: 450
							}
						});
					}
				});
			} else {
				$HUI.dialog('#ChangeCPWDialog').close();
				$.messager.popover({ msg: "原因为空或取消切换", type: 'alert' });
			}
		});
	}
	obj.ShowCgSteps = function (CPWID) {
		obj.NewStepID=""
		$('.Cgstep').removeClass('CgstepActive');
		$('#CgStepDetail').html("");
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetStepList",
			aPathFormID: CPWID
		}, function (StepList) {
			if (StepList == "") {
				return;
			}
			var StepHtml = ""
			var StepArr = StepList.split("^");
			for (var ind = 0, len = StepArr.length; ind < len; ind++) {
				var tmpStep = StepArr[ind].split(":");
				StepHtml = StepHtml + "<div id='CgStep-" + tmpStep[0] + "' class='selectStepMore Cgstep' style='margin-top:10px;'>" + tmpStep[1] + "</div>"
			}
			$('#CgStepList').html(StepHtml);
			$('#CgStepList .Cgstep').on('click', function () {
				$('.Cgstep').removeClass('CgstepActive');
				$('#' + this.id).addClass('CgstepActive');
				obj.ShowCgStepDetail(CPWID + "||" + this.id.split("-")[1]);
			});
		});
	}
	obj.ShowCgStepDetail = function (StepID) {
		obj.NewFormID = StepID.split("||")[0];
		obj.NewStepID = StepID.split("||")[1];
		$m({
			ClassName: "DHCMA.CPW.CPS.ImplementSrv",
			MethodName: "GetStepDetail",
			aFormEpID: StepID
		}, function (StepDetail) {
			if (StepDetail == "") {
				return;
			}
			$('#CgStepDetail').html(StepDetail);
		});
	}
	obj.ShowCPWList = function (LocID,Desc) {
		$m({
			ClassName: "DHCMA.CPW.BTS.PathLocSrv",
			QueryName: "QryPathByLocDesc",
			ResultSetType: 'array',
			aLocID: LocID,
			aDesc: Desc
		}, function (CPWList) {
			if (CPWList == "") {
				return;
			}
			var CPWHtml = ""
			var CPWArr = JSON.parse(CPWList);

			for (var ind = 0, len = CPWArr.length; ind < len; ind++) {
				var tmpPLID = CPWArr[ind].PLID;
				var tmpLocDesc = CPWArr[ind].LocDesc;
				var tmpItemID = CPWArr[ind].MastID;
				var tmpItemDesc = CPWArr[ind].MastDesc;
				CPWHtml = CPWHtml + "<div id='CPWItem"+tmpPLID+"-" + tmpItemID + "' class='selectStepMore CPWItem' style='margin-top:10px;'>"
				CPWHtml = CPWHtml + tmpItemDesc
				CPWHtml = CPWHtml + "<div style='text-align:right;font-size:0.8em;border-top:1px dashed;'>"+tmpLocDesc+"</div>"
				CPWHtml = CPWHtml + "</div>"
			}
			$('#CPWListItem').html(CPWHtml);
			$('#CPWListItem .CPWItem').on('click', function () {
				$('.CPWItem').removeClass('CgstepActive');
				$('#' + this.id).addClass('CgstepActive');
				obj.ShowCPWDetail(this.id.split("-")[1]);
			});
		});
		$HUI.dialog('#LookCPWDialog').open();
		obj.FormID=""
	}
	//add by xwj 2019-08-09
	$('#btn-GetInCPW').on('click', function () {
		var content = document.getElementById('CCPWDiag-right');
		if ((content.innerText != "")&&(obj.FormID == "")) {
			$.messager.popover({ msg: "路径未发布，请选择其他路径！", type: 'error' });
			return;
		}
		if ((obj.FormID=="")&&(content.innerText == "")) {
			$.messager.popover({ msg: "未选择路径", type: 'error' });
			return;
		}
		
		var ret = $m({
			ClassName: "DHCMA.CPW.CPS.InterfaceSrv",
			MethodName: "GetInCPW",
			aEpisodeID: EpisodeID,
			aInputs: parseInt(obj.FormID) + CHR_1 + session['DHCMA.USERID'] + CHR_1 + session['DHCMA.CTLOCID'] + CHR_1 + session['DHCMA.CTWARDID'],
			aSeparete:CHR_1
		}, false);
		if (parseInt(ret) > 0) {
			$.messager.popover({ msg: "入径成功！", type: 'success' });
		} else {
			$.messager.popover({ msg: "入径失败！", type: 'error' });
		}
		$HUI.dialog('#LookCPWDialog').close();
		window.location.reload();
	});
	//end
	obj.ShowCPWDetail = function (MastID) {
		var FormID = $m({
			ClassName: "DHCMA.CPW.BTS.PathFormSrv",
			MethodName: "GetFormByMast",
			aMastID: MastID,
			aIO: 1
		}, false);
		//FormID = parseInt(FormID); //会将空值转换为0
		obj.FormID=(FormID.split("^"))[0];
		var aFormID=(FormID.split("^"))[0];
		if (FormID == "") {
			$('#CPWListDetail').html("<p>没有可用的已发布版本！</p>")
		} else {
			$m({
				ClassName:"DHCMA.CPW.CPS.InterfaceSrv",
				MethodName:"GetCPWSummary",
				aPathID:aFormID
			}, function (Summary) {
				$('#CPWListDetail').html(Summary);
			});
		}
	}
	obj.SearchCPW = function(){
		$('#CPWListDetail').html('<p></p>');
		if(obj.serchType=="myloc"){
			obj.ShowCPWList(session['DHCMA.CTLOCID'],obj.searchValue)
		}else{
			obj.ShowCPWList("",obj.searchValue)
		}
	}
	obj.ShowSD=function(){
		title="单病种表单填报" 
		url="./dhcma.cpw.sd.qcformshow.csp?MrListID=" + obj.MrListID + "&random="+Math.random();
		websys_showModal({
			url:url,
			title:title,
			iconCls:'icon-w-epr',
			originWindow:window,
			isTopZindex:true,
			onBeforeClose:function(){}
		});
	}
}
GetLength = function (str) {
	///获得字符串实际长度，中文2，英文1，符号1
	var realLength = 0, len = str.length, charCode = -1;
	for (var i = 0; i < len; i++) {
		charCode = str.charCodeAt(i);
		if (charCode >= 0 && charCode <= 128)
			realLength += 1;
		else
			realLength += 2;
	}
	return realLength;
}