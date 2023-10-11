function InitOPOrderWinEvent(obj) {
	obj.LoadEvent = function (args) {
		obj.tabType = "T";
		obj.tabVarType = "I";
		obj.InitOCPWInfo();
		
		$('#OStepMore').on('click', function(){
			var Emvalue = $('#OStepMore').attr("value");
			obj.ShowOSetpMore(Emvalue);
		});
		$('#Addorder').on('click', function(){
			obj.AddOrderToEntry();
		})
		$('#GetHelp').on('click', function(){
			$HUI.dialog('#HelpCPWDialog').open();
		})
		$('#GeneReplace').on('click', function(){
			var selData = $('#gridGeneOrder').datagrid('getSelected')
			$('#CPWItemOrder').datagrid('updateRow',{
				index: obj.replaceIndex,
				row: {
					OrdMastIDDesc: selData['ArcimDesc'],
					OrdDoseQty: selData['DoseQty'],
					OrdUOMIDDesc: selData['DoseUomDesc'],
					OrdFreqIDDesc: selData['FreqDesc'],
					OrdInstrucIDDesc: selData['InstrucDesc'],
					OrdDuratIDDesc: selData['DuratDesc'],
					OrdMastID:selData['ArcimID'],
					OrdUOMID:selData['DoseUomDR'],
					OrdFreqID:selData['FreqDR'],
					OrdDuratID:selData['DuratDR'],
					OrdInstrucID:selData['InstrucDR']
				}
			});
			$HUI.dialog('#GeneCPWDialog').close();
		})

		$HUI.tabs("#CPW-Var", {
			onSelect: function (title) {
				switch (title) {
					case "路径外医嘱":
						obj.tabVarType = "O";
						break;
					case "未执行项目":
						obj.tabVarType = "I";
						break;
					case "中药方剂变异":
						obj.tabVarType = "T"
				}
				obj.VQueryLoad();
			}
		});
		
		//更多按钮
		$('#StepMore').on('click', function () {
			var Emvalue = $('#StepMore').attr("value");
			obj.ShowStepMore(Emvalue);
		});
		//确定按钮
		$('#ObtnSave').on('click', function () {
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
		//中药方剂变异保存变异信息
		$('#Var-TCMVar-Save').on('click', function() {
			obj.SaveTCMVar();	
		})
		//中药方剂变异撤销变异信息
		$('#Var-TCMVar-Cancel').on('click',function(){
			obj.CancelTCMVar();	
		})
		$('#PrintCPWInformedConsert').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintOPCPWConsert");  //打印任务的名称
			LODOP.ADD_PRINT_HTM("285mm", "90mm",300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
			LODOP.SET_PRINT_STYLEA(0, "ItemType",1);//每页都输出
			//LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0); 	//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
			//LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);			//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
			LodopPrintURL(LODOP,"./dhcma.cpw.opcp.consentprint.csp?EpisodeID="+EpisodeID,"10mm","12mm","6mm","20mm")
			LODOP.PRINT();
			
		});
		$('#PrintCPWInform').on('click', function () {			
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintOPCPWInform1");  //打印任务的名称
			LODOP.ADD_PRINT_HTM("285mm", "90mm",300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
			LODOP.SET_PRINT_STYLEA(0, "ItemType",1);//每页都输出
			//LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0); 	//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
			//LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);			//人工双面打印（打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印）
			LodopPrintURL(LODOP,"./dhcma.cpw.opcp.oplodopprint.csp?EpisodeID="+EpisodeID,"10mm","12mm","6mm","20mm")
			LODOP.PRINT();
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
		//自动阶段确认控制
		if(ServerObj.IsAutoCfmStep=="Y"){
			obj.ShowByConfig();	
		}
	}
	/*	按用户控制页面及操作*/
	obj.ShowByUserType = function () {
		var InCPWLocID='';
		if (session['DHCMA.CTLOCID']==InCPWLocID) {
			
		} else {
			//考虑非本科室医生 不能操作该路径	
		}

	}
	/*	按用阶段状态控制页面及操作
	 *	非当前状态控制
	 *	阶段确定控制
	 */
	obj.ShowByStepStatus = function () {
		//非当前阶段
		if (obj.CurrIndex != obj.SelectedIndex) {
			$("#ObtnSave").hide();	//确定按钮
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("禁止操作"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("请选择【当前阶段】后，继续各项操作！"))
		} else {
			$("#ObtnSave").show();
			$("#img-Execute").attr("src","../scripts/DHCMA/img/add.png");
			$("#img-Execute").attr("title", $g("全部执行"));
			$("#img-Execute").attr("onclick", "objOrder.ExecuteAllItem()");
			$("#img-Cancle").attr("src","../scripts/DHCMA/img/no.png");
			$("#img-Cancle").attr("title", $g("全部撤销"));
			$("#img-Cancle").attr("onclick", "objOrder.CancelAllItem()");
			
			$('#Var-Item-Save').linkbutton("enable");
			$('#Var-Item-Cancel').linkbutton("enable");
			$('#Var-Order-Save').linkbutton("enable");
			$('#Var-Order-Cancel').linkbutton("enable");
			$('#Var-TCMVar-Save').linkbutton("enable");
			$('#Var-TCMVar-Cancel').linkbutton("enable");
			$("#foot-note").text($g("请按照本阶段内容执行！"))
		}
		if (obj.ConfList.slice(-1) == 1) {
			$("#ObtnSave").hide(); //如果最后一个阶段都已经签名，那不再显示确认阶段按钮
			$('#Addorder').linkbutton("disable");
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("禁止操作"));
			$(".Operimg").attr("onclick", "");
		}
	}
	obj.ShowByCPWStatus = function () {
		if (obj.StatusCurrDesc == $g("出径")) {
			$("#btnClose").hide();	//完成按钮
			$("#btnOut").hide();		//出径按钮
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("禁止操作"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("该临床路径已经")+"【" + $g(obj.StatusCurrDesc) + "】，"+$g("禁止表单操作！"))
		} else if (obj.StatusCurrDesc == "完成") {
			$("#btnClose").hide();	//完成按钮
			$("#btnOut").hide();		//出径按钮
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("禁止操作"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("该临床路径已经")+"【" + $g(obj.StatusCurrDesc) + "】，"+$g("禁止表单操作！"))
		} else {	//入径

		}
	}
	obj.ShowByConfig = function(){
		$("#ObtnSave").hide();
		$('#Var-Item-Save').hide();
		$('#Var-Item-Cancel').hide();
		$('#Var-Order-Save').hide();
		$('#Var-Order-Cancel').hide();
		$('#Var-TCMVar-Save').hide();
		$('#Var-TCMVar-Cancel').hide();
		
		$('#tb-Variation-Order').datagrid('hideColumn','checkOrd');
		$('#tb-Variation-Item').datagrid('hideColumn','checkOrd');
		$('#tb-Variation-TCMVar').datagrid('hideColumn','checkOrd');
	}
	
	obj.ExecuteItem = function (ItemID) {
		$m({
			ClassName: "DHCMA.CPW.OPCPS.ImplementSrv",
			MethodName: "ExecuteItem",
			aPathwayID: obj.PathwayID,
			aItemID: ItemID,
			aOrdDID: "",
			aUserID: session['DHCMA.USERID'],
			aIsImpl: 1,
			aIsSystem: 0,
			aEpisodeID:EpisodeID
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({
					msg: $g('执行成功'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('执行失败')+',ret=' + ret,
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
	//诊疗项目批量执行
	obj.ExecuteAllItem = function(){
		$cm({
			ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",
			ResultSetType:"array",
			aPathwayID: obj.PathwayID, 
			aEpisID: obj.PathwayID+"||"+obj.StepSelecedID,
			aType:"T"
		},function(rs){
			var len = rs.length
			for (var i=0;i<len;i++){
				obj.ExecuteItem(rs[i].ID);	
			}
		});
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
					msg: $g('撤销成功'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('撤销失败'),
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
	//诊疗项目批量撤销
	obj.CancelAllItem = function(){
		$cm({
			ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",
			ResultSetType:"array",
			aPathwayID: obj.PathwayID, 
			aEpisID: obj.PathwayID+"||"+obj.StepSelecedID,
			aType:"T"
		},function(rs){
			var len = rs.length
			for (var i=0;i<len;i++){
				obj.CancelItem(rs[i].ID);	
			}
		});
	}
	//保存必选项目未执行变异原因
	obj.SaveItemVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Item').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('请选择项目'),
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
					msg: $g('不能选择原因分类'),
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
				msg: $g('请选择变异原因'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	//取消必选项目未执行变异原因记录
	obj.CancelItemVar = function () {
		var rows = $('#tb-Variation-Item').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('请选择项目'),
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
	
	//保存路径外医嘱变异变异原因
	obj.SaveOrderVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Order').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('请选择医嘱'),
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
					var InputStr = obj.PathwayID + "^" + rowData['VarID'] + "^" + Node.id.split("-")[1] + "^" + VariatTxt + "^" + EpisID + "^" + ImplID + "^" + OrdDID + "^" + session['DHCMA.USERID']+"^"+1;
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
					msg: $g('不能选择原因分类'),
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
				msg: $g('请选择变异原因'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	//取消路径外医嘱变异变异原因记录
	obj.CancelOrderVar = function () {
		var rows = $('#tb-Variation-Order').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('请选择医嘱'),
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
	
	//保存方剂变异变异原因
	obj.SaveTCMVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-TCMVar').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('请选择医嘱'),
						type: 'error',
						style: {
							top: 150,
							left: 450
						}
					});
					return;
				}
				for (var ind = 0, len = rows.length; ind < len; ind++) {
					var RowIndex = $('#tb-Variation-TCMVar').datagrid("getRowIndex", rows[ind]);
					var Node = $('#ItemTree').tree('getSelected');
					var ed = $('#tb-Variation-TCMVar').datagrid('getEditor', { index: RowIndex, field: 'VariatTxt' });
					var VariatTxt = "";
					
					if (ed) VariatTxt = $(ed.target).val();
					var rowData = rows[ind]
					var EpisID = obj.PathwayID + "||" + obj.StepSelecedID;
					var ImplID = rowData['ImplID'];			
					var OrdDID = rowData['OrdDID'];
					var InputStr = obj.PathwayID + "^" + rowData['VarID'] + "^" + Node.id.split("-")[1] + "^" + VariatTxt + "^" + EpisID + "^" + ImplID + "^" + OrdDID + "^" + session['DHCMA.USERID']+"^"+1;
					ret = $m({
						ClassName: "DHCMA.CPW.CP.PathwayVar",
						MethodName: "Update",
						aInputStr: InputStr,
						aSeparete: "^"
					}, false)
					if (parseInt(ret) > 0) {
						$('#tb-Variation-TCMVar').datagrid("uncheckRow", RowIndex);
					}
				}
				$('#tb-Variation-TCMVar').datagrid('reload');
				$('#ItemTree').find('.tree-node-selected').removeClass('tree-node-selected');
			} else {
				$.messager.popover({
					msg: $g('不能选择原因分类'),
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
				msg: $g('请选择变异原因'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	
	//取消方剂变异变异原因记录
	obj.CancelTCMVar = function () {
		var rows = $('#tb-Variation-TCMVar').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('请选择变异记录'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
		for (var ind = 0, len = rows.length; ind < len; ind++) {
			var RowIndex = $('#tb-Variation-TCMVar').datagrid("getRowIndex", rows[ind]);
			var VarID = rows[ind]['VarID'];
			if (VarID == "") continue;
			$m({
				ClassName: "DHCMA.CPW.CP.PathwayVar",
				MethodName: "Invalid",
				aID: obj.PathwayID + "||" + VarID,
				aUserID: session['DHCMA.USERID']
			}, false)
			$('#tb-Variation-TCMVar').datagrid("uncheckRow", RowIndex);
		}
		$('#tb-Variation-TCMVar').datagrid('reload');
	}
	
	obj.TQueryLoad = function () {
		obj.gridTreatment.load({
			ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",		
			aPathwayID: obj.PathwayID, 
			aEpisID: obj.PathwayID+"||"+obj.StepSelecedID,
			aType:"T" 
		});
	}			

	obj.VQueryLoad = function () {
		$m({
			ClassName: "DHCMA.CPW.OPCPS.ImplementSrv",
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
				ClassName: "DHCMA.CPW.OPCPS.PathwayVarSrv",
				QueryName: "QryCPWVarOrder",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID
			});
		} else if(obj.tabVarType == "I") {
			obj.gridVarItem.load({
				ClassName: "DHCMA.CPW.OPCPS.PathwayVarSrv",
				QueryName: "QryCPWVarItem",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID
			});
		} else{
			obj.gridVarTCM.load({
				ClassName: "DHCMA.CPW.OPCPS.PathwayVarSrv",
				QueryName: "QryCPWTCMVar",
				aPathwayID: obj.PathwayID,
				aEpisID: obj.PathwayID + "||" + obj.StepSelecedID
			});	
		}
		
	}
	obj.AddOrderToEntry = function(){
		var rows = $('#CPWItemOrder').datagrid("getSelections");
		if(rows.length==0) return;
		var strOrderList = '';
		for (var ind=0,len=rows.length;ind<len;ind++){
			var rowData=rows[ind];
			var strOrder = rowData['OrdGeneID'];	//通用名ID
				strOrder += '^' + rowData['OrdMastID'];
				strOrder += '^' + rowData['OrdPriorityID'];
				strOrder += '^' + rowData['OrdQty'];
				strOrder += '^' + rowData['OrdDoseQty'];
				strOrder += '^' + rowData['OrdUOMID'];
				strOrder += '^' + rowData['OrdFreqID'];
				strOrder += '^' + rowData['OrdDuratID'];
				strOrder += '^' + rowData['OrdInstrucID'];
				strOrder += '^' + rowData['OrdNote'];
				strOrder += '^' + rowData['OrdLnkOrdDr']+"."+ind;
				var posStr=rowData['OrdChkPosID']
				if(posStr!=""){
					strOrder += '^' + posStr.split("||")[1];
				}
				strOrderList +=  CHR_1 + strOrder;
			}		
		if(strOrderList!=""){
			console.log("MZstrOrderList="+strOrderList);
			//将医嘱添加到列表
			websys_showModal('options').addOEORIByCPW(strOrderList)
			websys_showModal('close');
		}
	}
	obj.OutCPW = function () {
		var varID = Common_GetValue('OutReason')
		var varTxt = Common_GetValue('OutText')
		var errorInfo = "";
		if (varID == "") {
			errorInfo = $g("请选择出径原因！<br />")
		}
		if (varTxt == "") {
			errorInfo = errorInfo + $g("请填写备注信息！")
		}
		if (errorInfo != "") {
			$.messager.alert($g("错误提示"), errorInfo, "error")
			return;
		}
		$m({
			ClassName: "DHCMA.CPW.OPCPS.InterfaceSrv",
			MethodName: "GetOutOPCPW",
			aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID'] + "^" + varID + "^" + varTxt,
			aSeparete: "^"
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({ msg: $g("操作成功"), type: 'success' });
				$HUI.dialog('#OutCPWDialog').close();
				obj.InitOCPWInfo();
				obj.OperationControl();
			}
		})
	}
	obj.CloseCPW = function () {		
		if (obj.StepSelecedID != obj.StepList[obj.StepList.length-1].split(":")[0]){
			$.messager.popover({ msg: $g("还有阶段未执行，禁止此操作"), type: 'error' });
			return;	
		}else{
			//检查是否自动进行阶段确认及变异保存设置
			if (ServerObj.IsAutoCfmStep=="Y"||parseInt(ServerObj.IsAutoCfmStep)==1){
				$.messager.confirm($g("完成"), $g("确定完成?<br />完成后将不能再做任何修改！"), function (r) {
					if (r) {
						$m({
							ClassName: "DHCMA.CPW.OPCPS.InterfaceSrv",
							MethodName: "CloseOPCPW",
							aEpisodeID: EpisodeID,
							aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID']
						}, function (ret) {
							if (parseInt(ret) > 0) {
								$.messager.popover({ msg: $g("操作成功"), type: 'success' });
								obj.InitOCPWInfo();
								obj.OperationControl();
							}else if(parseInt(ret)==-2){
								$.messager.popover({ msg: $g("操作失败，您有当前阶段变异未处理，请先处理变异！"), type: 'error' });		
							}else{
								$.messager.popover({ msg: $g("操作失败，请稍后再试！"), type: 'error' });	
							}
						})
					} 
				});
			}else {
				//最后一个阶段是否确定
				if (obj.ConfList.slice(-1) != 1) {
					$.messager.popover({ msg: $g("还有阶段未确定，禁止此操作"), type: 'error' });
					return;
				}
			}	
		}		
	}
	obj.ConfirmStep = function () {
		var DateFrom = $('#ODateFrom').datebox('getValue');
		var DateTo = $('#ODateTo').datebox('getValue');
		if (DateFrom == "") {
			$.messager.popover({ msg: $g("开始日期不能为空"), type: 'error' });
			return;
		} else {
			if (DateTo == "") {
				$.messager.popover({ msg: $g("结束日期不能为空"), type: 'error' });
				return;
			} else {
				var flg = Common_CompareDate(DateFrom, DateTo);
				if (flg) {
					$.messager.popover({ msg: $g("结束日期不能小于开始日期"), type: 'error' });
					return;
				}
			}
		}
		//检查变异原因
		var VarCount = $cm({ ClassName: "DHCMA.CPW.OPCPS.PathwayVarSrv", MethodName: "CheckVarToCfmStep", aPathwayID: obj.PathwayID, aEpisID: obj.PathwayID + "||" + obj.StepSelecedID}, false);
		if (parseInt(VarCount) > 0) {
			$.messager.popover({ msg: $g("有变异信息未处理，请先处理变异信息！"), type: 'error' });
			$('#CPW-main').tabs('select', $g("变异原因"));
			return;
		}
		//检查阶段日期是否合法：新阶段开始日期不能早于前一阶段结束日期
		var CheckStepDateMsg = $m({
			ClassName: "DHCMA.CPW.OPCPS.ImplementSrv",
			MethodName: "CheckStepDate",
			aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
			aSttDate: DateFrom
		}, false)
		if (CheckStepDateMsg != "") {
			$.messager.popover({ msg: CheckStepDateMsg, type: 'error' });
			return;
		}
		$.messager.confirm($g("确定"), $g("确认后将不能再做任何修改！"), function (r) {
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
					ClassName: "DHCMA.CPW.OPCPS.ImplementSrv",
					MethodName: "ConfirmStep",
					aEpisID: obj.PathwayID + "||" + obj.StepSelecedID,
					aSttDate: DateFrom,
					aEndDate: DateTo,
					aUserID: session['DHCMA.USERID'],
					aNextEpisID: NextEpisID
				}, function (ret) {
					if (parseInt(ret) > 0) {
						$.messager.popover({ msg: $g("确定成功"), type: 'success' });
						//obj.InitOCPWSteps();	//步骤信息
						obj.InitOCPWInfo();
						obj.OperationControl();
					}
				})
			} else {
				return;
			}
		})

	}
	
	//路径信息
	obj.InitOCPWInfo = function(){
		$m({
			ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			MethodName:"GetCPWInfo",
			aEpisodeID:EpisodeID
		},function(JsonStr){
			if (JsonStr=="") return;
			var JsonObj=$.parseJSON(JsonStr);
			 
			obj.CPWCurrDesc=JsonObj.CPWDesc;		//当前步骤名称
			obj.StatusCurrDesc=JsonObj.CPWStatus;	//当前路径状态
			obj.PathFormID=JsonObj.PathFormID		//当前路径的表单ID
			obj.PathwayID=JsonObj.PathwayID			//出入径记录ID
			
			$('#OCPWDesc').text(JsonObj.CPWDesc)
			$('#OCPWStatus').text(JsonObj.CPWStatus)
			$('#OCPWUser').text(JsonObj.CPWUser)
			$('#OCPWTime').text(JsonObj.CPWTime)
			//$('#CPWIcon').text(JsonObj.CPWIcon)
			var htmlIcon=""
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-D">单</span>'
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-B">变</span>'
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-T">T</span>'
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-Y">￥</span>'
			$('#OCPWIcon').html(htmlIcon)
			$(".OIcon-D").popover({
				content: $g('单病种信息：' + JsonObj.SDDesc)
			});
			$(".OIcon-B").popover({
				content: JsonObj.VarDesc
			});
			$(".OIcon-T").popover({
				content: $g('入径天数：') + JsonObj.CPWDays + $g('天<br />计划天数：') + JsonObj.FormDays + $g('天')
			});
			$(".OIcon-Y").popover({
				content: $g('总费用：') + JsonObj.PatCost + $g('<br />计划费用：') + JsonObj.FormCost + $g('元')
			});
			
			obj.InitOCPWSteps();
		});
	}
	//路径步骤
	obj.InitOCPWSteps = function(){
		$m({
			ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			MethodName:"GetCPWSteps",
			aEpisodeID:EpisodeID,
			aPathwayID:obj.PathwayID
		},function(StepsStr){
			var StepsArr=StepsStr.split("#");
			var StepCurr=StepsArr[0];
			if (StepCurr=="") return;
			
			obj.StepCurrID=StepCurr.split(":")[0];			//已经执行到当前步骤的ID
			obj.StepList=StepsArr[1].split("^");			//该路径所有步骤数组
			obj.TimeList=StepsArr[2].split("^");			//该路径所有步骤起止时间数组，EpDays:SttDate:EndDate
			obj.ConfList=StepsArr[3].split("^");			//该路径所有步骤是否确定数组，1、0
			obj.SignList=StepsArr[4].split("^");			//该路径所有步骤签名信息数组，SignDoc:SignNur:SignDocDate:SignNurDate
			obj.StepSelecedID=obj.StepCurrID;				//点击选中的步骤ID
			obj.CurrIndex=obj.StepList.indexOf(StepCurr);	//已经执行到当前步骤的下标
			
			//展现步骤
			obj.ShowCPWSteps(obj.CurrIndex);
			//绑定点击事件
			$('#OStepMoreList .OselectStepMore').on('click', function(){
				obj.SelectStep(this.id);
			});
			$('#OStepShow .Ostep').on('click', function(){
				var SelectedStepID=this.id.split("-")[1];
				obj.StepSelecedID=SelectedStepID;
				obj.SelectStep(this.id);
				obj.ShowStepDetail(this.id);
			});
			//展现步骤内容
			obj.SelectStep("OStep-"+obj.StepCurrID);
		});	
		
	}

	//展现步骤
	obj.ShowCPWSteps = function(selectIndex){
		var StepSelect=obj.TimeList[selectIndex].split(":");
		$('#OStepTime').text(StepSelect[0]);
		$('#ODateFrom').datebox('setValue',StepSelect[1]);
		$('#ODateTo').datebox('setValue',StepSelect[2]);
		
		var StepShow=new Array();	//显示出来的步骤
		var StepMore=new Array();	//更多的步骤
		
		for(var ind = 0,len=obj.StepList.length;ind < len; ind++){
			if(selectIndex<3){
				if(ind<5){
					StepShow.push(obj.StepList[ind]);
				}else{
					StepMore.push(obj.StepList[ind]);
				}
			}else if(selectIndex>(len-3)){
				if(ind>len-6){
					StepShow.push(obj.StepList[ind]);
				}else{
					StepMore.push(obj.StepList[ind]);
				}
			} else {
				if((ind<(selectIndex-2)) || (ind>(selectIndex+2))) {
					StepMore.push(obj.StepList[ind]);
				} else {
					StepShow.push(obj.StepList[ind]);
				}
			}
		}
		
		var StepClass="";
		var StepShowHtml="";
		for(var ind = 0,len = StepShow.length; ind < len; ind++){
			var StepIndex=obj.StepList.indexOf(StepShow[ind]);
			var ConFlg=obj.ConfList[StepIndex]
			if(StepIndex<obj.CurrIndex){
				StepClass="Ostep Osteppre";	//已执行
			}else if(StepIndex>obj.CurrIndex){
				StepClass="Ostep Ostepaft";	//未执行
			}else{
				StepClass="Ostep Ostepcurr";	//当前步骤
			}
			if (ConFlg==1) StepClass="Ostep Osteppre";  //如果项目已确认，展现为已执行样式
			var tmpStep=StepShow[ind].split(":");
			if(GetLength(tmpStep[1])<=13) StepClass=StepClass+" Ostepshort";
			StepShowHtml=StepShowHtml+"<div id='OStep-"+tmpStep[0]+"' class='"+StepClass+"'>"+tmpStep[1]+"</div>"
			if(ind != len-1) {
				StepShowHtml=StepShowHtml+"<div class='Ostepline'></div>"
			}
		}
		$('#OStepShow').html(StepShowHtml);
		
		var StepClass="";
		var StepMoreHtml="";
		for(var ind = 0,len =StepMore.length; ind < len; ind++){
			var StepIndex=obj.StepList.indexOf(StepMore[ind]);
			if(StepIndex<obj.CurrIndex){
				StepClass="Osteppre";	//已执行
			}else if(StepIndex>obj.CurrIndex){
				StepClass="Ostepaft";	//未执行
			}else{
				StepClass="Ostepcurr";	//当前步骤
			}
			var tmpStep=StepMore[ind].split(":");
			StepMoreHtml=StepMoreHtml+"<div id='OStep-"+tmpStep[0]+"' class='OselectStepMore "+StepClass+"'>"+tmpStep[1]+"</div>"
		}
		$('#OStepMoreList').html(StepMoreHtml);
	}

	obj.SelectStep = function(IDStr){
		var SelectedStepID=IDStr.split("-")[1];
		var SelectedStepText=$("#"+IDStr).text();
		var SelectedStep=SelectedStepID+":"+SelectedStepText;
		var SelectedIndex=obj.StepList.indexOf(SelectedStep);
		obj.SelectedIndex=SelectedIndex;
		obj.StepSelecedID=SelectedStepID;
		if(obj.StepSelecedID != obj.StepCurrID) {	//非当前步骤不允许添加医嘱
			$("#Addorder").linkbutton("disable");
		}else{
			$("#Addorder").linkbutton("enable");
		}
		//调整并展现步骤
		obj.ShowCPWSteps(SelectedIndex);
		//展现步骤内容
		obj.ShowStepDetail(IDStr);
		//绑定点击事件
		$('#OStepMoreList .OselectStepMore').on('click', function(){
			obj.SelectStep(this.id);
		});
		$('#OStepShow .Ostep').on('click', function(){
			var SelectedStepID=this.id.split("-")[1];
			obj.StepSelecedID=SelectedStepID;
			obj.SelectStep(this.id);
			//obj.ShowStepDetail(this.id);
		});
		obj.ShowOSetpMore(0)	//关闭更多步骤
	}
	obj.ShowStepDetail = function(IDStr){
		$("#OStepShow .Ostep").removeClass('selected');
		$("#"+IDStr).addClass('selected');
		$m({
			ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			MethodName:"GetOrdItmTree",
			aPathwayID: obj.PathwayID, 
			aEpisID: obj.PathwayID+"||"+obj.StepSelecedID
		},function(treeJson){
			var dataArr=$.parseJSON(treeJson)
			$('#OItemTree').tree({
				data: dataArr,
				formatter:function(node){
					var Displaytxt="";
					if (node.children){
						Displaytxt = node.text;
					}else{
						len=node.text.length;
						if (len<15) {
							Displaytxt = node.text;
						}else{
							Displaytxt = node.text.substring(0,15)+"<br />"+node.text.substring(15)
						}
					}
					//已经执行
					if((!node.children)&&(node.attributes.IsImp)){
						Displaytxt = "<span id='Executed-"+node.id.split("-")[0]+"' style='color:#509DE1;'>"+Displaytxt+"</span>";
					}
					if((!node.children)&&(node.attributes.IsRequired)){
						Displaytxt = "<span id='Required"+node.id.split("-")[0]+"' style='font-size:15px;color:#ff0000;'>*</span>"+Displaytxt;
					}
					return Displaytxt
				},
				onClick: function(node){
					var PathFormEpID="";
					var PathFormEpItemID="";
					if(node.id.split("-")[0]=="OrdTree"){
						PathFormEpID=node.id.split("-")[2];
						PathFormEpItemID="";
						obj.CPWItemOrder.load({
							ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
							QueryName:"QryPathFormEpItemOrdAll",
							aPathFormEpDr:PathFormEpID,
							aPathFormEpItemDr:PathFormEpItemID
						});
					}else{
						var root=$('#OItemTree').tree('getParent', node.target);
						PathFormEpID=root.id.split("-")[2];
						PathFormEpItemID=node.id.split("-")[1];
						obj.CPWItemOrder.load({
							ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
							QueryName:"QryPathFormEpItemOrdAll",
							aPathFormEpDr:PathFormEpID,
							aPathFormEpItemDr:PathFormEpItemID
						});
					}
					
				},
				onLoadSuccess: function(node, data){
					if(data.length>0){						
						var rootID=data[0].id;
						var node = $('#OItemTree').tree('find', rootID);
						$('#OItemTree').tree('select', node.target);
						$('#OItemTree').tree('check', node.target);
						PathFormEpID=rootID.split("-")[2];	
						obj.CPWItemOrder.load({
							ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
							QueryName:"QryPathFormEpItemOrdAll",
							aPathFormEpDr:PathFormEpID,
							aPathFormEpItemDr:''
						});
					}
				},
				lines:true,autoNodeHeight:true
			})
			obj.VQueryLoad();
			obj.TQueryLoad();
			obj.commonAddTreeTitle('OItemTree',dataArr);
			
		});	
	}
	obj.commonAddTreeTitle=function (domId, nodeData) {
		if (nodeData != null && nodeData != "") {
			for (var index = 0; index < nodeData.length; index++) {
				var operNode = $('#' + domId).tree('find', nodeData[index].id + "");
				if((!operNode.children)&&(operNode.attributes.IsImp)){					
					$(operNode.target).popover({trigger:'hover',placement:'top',content:"<span style='color:#1FAE40'>"+operNode.attributes.OperInfo+"</span>"});
					
					$(operNode.target).mouseover(function(e){
						$(operNode.target).popover('show');
					});
				
					$(operNode.target).mouseout(function(e){ 
						$(operNode.target).popover('hide');
					});
				}
				obj.commonAddTreeTitle(domId, nodeData[index].children);
			}
		}
	}
	obj.ShowOSetpMore = function(Emvalue){
		if(Emvalue==1){
			$('#OStepMoreList').css('display','block');
			$('#OStepMore').attr("value",0);
			$('#OStepMore').text($g("收起▲"));
		}else{
			$('#OStepMore').text($g("更多▼"));
			$('#OStepMore').attr("value",1);
			$('#OStepMoreList').css('display','none');
		}
	}
	//显示医嘱执行信息
	obj.ClickOrdDesc = function(index){
		var selData = $('#CPWItemOrder').datagrid('getRows')[index];
		var FormOrdID=selData['xID']
		if (FormOrdID.indexOf("FJ")>-1) FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1]
		var id=FormOrdID.split("||").join("-")
		if(obj.OrdContent[id]==undefined) return;
		$HUI.popover('#'+id,{content:obj.OrdContent[id],trigger:'hover'});
		$('#'+id).popover('show');
	}
	//显示方剂信息明细
	obj.ShowFJDetail = function(FJid){
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathTCMExtSrv",
			QueryName:"QryPathTCMExt",
			aParRef:FJid,
			ResultSetType:"array"
		},function(rs){
			var PopHtml=""
			if (rs.length>0){
				for(var i=0;i<rs.length;i++){
					PopHtml=PopHtml+rs[i].BTTypeDesc+"&nbsp&nbsp&nbsp"+rs[i].BTOrdMastID+"&nbsp&nbsp&nbsp"+rs[i].ArcResumeDesc+"<br/>"
				}
			}
			$HUI.popover('#pop'+FJid,{content:PopHtml,trigger:'hover'});
			$('#pop'+FJid).popover('show');
		});
	}
	obj.DestoryFJDetail = function(FJid){
		$('#pop'+FJid).popover('destroy');
	}
}
GetLength = function(str) {
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