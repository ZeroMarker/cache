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
					case "·����ҽ��":
						obj.tabVarType = "O";
						break;
					case "δִ����Ŀ":
						obj.tabVarType = "I";
						break;
					case "��ҩ��������":
						obj.tabVarType = "T"
				}
				obj.VQueryLoad();
			}
		});
		
		//���ఴť
		$('#StepMore').on('click', function () {
			var Emvalue = $('#StepMore').attr("value");
			obj.ShowStepMore(Emvalue);
		});
		//ȷ����ť
		$('#ObtnSave').on('click', function () {
			obj.ConfirmStep();
		})
		//��������
		$('#btnOut').on('click', function () {
			$HUI.dialog('#OutCPWDialog').open();
		})
		//����
		$('#btn-OutCPWDialog').on('click', function () {
			obj.OutCPW();
		})
		//���
		$('#btnClose').on('click', function () {
			obj.CloseCPW();
		})
		//δִ����Ŀ���������Ϣ
		$('#Var-Item-Save').on('click', function () {
			obj.SaveItemVar();
		})
		//δִ����Ŀ����������Ϣ
		$('#Var-Item-Cancel').on('click', function () {
			obj.CancelItemVar();
		})
		//·����ҽ�����������Ϣ
		$('#Var-Order-Save').on('click', function () {
			obj.SaveOrderVar();
		})
		//·����ҽ������������Ϣ
		$('#Var-Order-Cancel').on('click', function () {
			obj.CancelOrderVar();
		})
		//��ҩ�������챣�������Ϣ
		$('#Var-TCMVar-Save').on('click', function() {
			obj.SaveTCMVar();	
		})
		//��ҩ�������쳷��������Ϣ
		$('#Var-TCMVar-Cancel').on('click',function(){
			obj.CancelTCMVar();	
		})
		$('#PrintCPWInformedConsert').on('click', function () {
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintOPCPWConsert");  //��ӡ���������
			LODOP.ADD_PRINT_HTM("285mm", "90mm",300,100,"<span tdata='pageNO'>��##ҳ</span>/<span tdata='pageCount'>��##ҳ</span>");
			LODOP.SET_PRINT_STYLEA(0, "ItemType",1);//ÿҳ�����
			//LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0); 	//�˹�˫���ӡ����ӡ����֧��˫���ӡʱ��0Ϊ�����ӡ��1Ϊ��˫���ӡ��2Ϊ˫���ӡ��
			//LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);			//�˹�˫���ӡ����ӡ����֧��˫���ӡʱ��0Ϊ�����ӡ��1Ϊ��˫���ӡ��2Ϊ˫���ӡ��
			LodopPrintURL(LODOP,"./dhcma.cpw.opcp.consentprint.csp?EpisodeID="+EpisodeID,"10mm","12mm","6mm","20mm")
			LODOP.PRINT();
			
		});
		$('#PrintCPWInform').on('click', function () {			
			var LODOP=getLodop();
			LODOP.PRINT_INIT("PrintOPCPWInform1");  //��ӡ���������
			LODOP.ADD_PRINT_HTM("285mm", "90mm",300,100,"<span tdata='pageNO'>��##ҳ</span>/<span tdata='pageCount'>��##ҳ</span>");
			LODOP.SET_PRINT_STYLEA(0, "ItemType",1);//ÿҳ�����
			//LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0); 	//�˹�˫���ӡ����ӡ����֧��˫���ӡʱ��0Ϊ�����ӡ��1Ϊ��˫���ӡ��2Ϊ˫���ӡ��
			//LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);			//�˹�˫���ӡ����ӡ����֧��˫���ӡʱ��0Ϊ�����ӡ��1Ϊ��˫���ӡ��2Ϊ˫���ӡ��
			LodopPrintURL(LODOP,"./dhcma.cpw.opcp.oplodopprint.csp?EpisodeID="+EpisodeID,"10mm","12mm","6mm","20mm")
			LODOP.PRINT();
		});
	}
	/* ҳ���������,����˳�򲻿ɱ�
	 * ����˳��
	 *	1����ɫ����
	 *	2���׶�״̬����
	 *	3��·��״̬����
	 */
	obj.OperationControl = function () {
		//��ɫ����
		obj.ShowByUserType();
		//�׶�״̬����
		obj.ShowByStepStatus();
		//·��״̬����
		obj.ShowByCPWStatus();
		//�Զ��׶�ȷ�Ͽ���
		if(ServerObj.IsAutoCfmStep=="Y"){
			obj.ShowByConfig();	
		}
	}
	/*	���û�����ҳ�漰����*/
	obj.ShowByUserType = function () {
		var InCPWLocID='';
		if (session['DHCMA.CTLOCID']==InCPWLocID) {
			
		} else {
			//���ǷǱ�����ҽ�� ���ܲ�����·��	
		}

	}
	/*	���ý׶�״̬����ҳ�漰����
	 *	�ǵ�ǰ״̬����
	 *	�׶�ȷ������
	 */
	obj.ShowByStepStatus = function () {
		//�ǵ�ǰ�׶�
		if (obj.CurrIndex != obj.SelectedIndex) {
			$("#ObtnSave").hide();	//ȷ����ť
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("��ֹ����"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("��ѡ�񡾵�ǰ�׶Ρ��󣬼������������"))
		} else {
			$("#ObtnSave").show();
			$("#img-Execute").attr("src","../scripts/DHCMA/img/add.png");
			$("#img-Execute").attr("title", $g("ȫ��ִ��"));
			$("#img-Execute").attr("onclick", "objOrder.ExecuteAllItem()");
			$("#img-Cancle").attr("src","../scripts/DHCMA/img/no.png");
			$("#img-Cancle").attr("title", $g("ȫ������"));
			$("#img-Cancle").attr("onclick", "objOrder.CancelAllItem()");
			
			$('#Var-Item-Save').linkbutton("enable");
			$('#Var-Item-Cancel').linkbutton("enable");
			$('#Var-Order-Save').linkbutton("enable");
			$('#Var-Order-Cancel').linkbutton("enable");
			$('#Var-TCMVar-Save').linkbutton("enable");
			$('#Var-TCMVar-Cancel').linkbutton("enable");
			$("#foot-note").text($g("�밴�ձ��׶�����ִ�У�"))
		}
		if (obj.ConfList.slice(-1) == 1) {
			$("#ObtnSave").hide(); //������һ���׶ζ��Ѿ�ǩ�����ǲ�����ʾȷ�Ͻ׶ΰ�ť
			$('#Addorder').linkbutton("disable");
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("��ֹ����"));
			$(".Operimg").attr("onclick", "");
		}
	}
	obj.ShowByCPWStatus = function () {
		if (obj.StatusCurrDesc == $g("����")) {
			$("#btnClose").hide();	//��ɰ�ť
			$("#btnOut").hide();		//������ť
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("��ֹ����"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("���ٴ�·���Ѿ�")+"��" + $g(obj.StatusCurrDesc) + "����"+$g("��ֹ��������"))
		} else if (obj.StatusCurrDesc == "���") {
			$("#btnClose").hide();	//��ɰ�ť
			$("#btnOut").hide();		//������ť
			$('#Var-Item-Save').linkbutton("disable");
			$('#Var-Item-Cancel').linkbutton("disable");
			$('#Var-Order-Save').linkbutton("disable");
			$('#Var-Order-Cancel').linkbutton("disable");
			$('#Var-TCMVar-Save').linkbutton("disable");
			$('#Var-TCMVar-Cancel').linkbutton("disable");
			$(".Operimg").attr("src", "../scripts/DHCMA/img/forbid.png");
			$(".Operimg").attr("title", $g("��ֹ����"));
			$(".Operimg").attr("onclick", "");
			$("#foot-note").text($g("���ٴ�·���Ѿ�")+"��" + $g(obj.StatusCurrDesc) + "����"+$g("��ֹ��������"))
		} else {	//�뾶

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
					msg: $g('ִ�гɹ�'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('ִ��ʧ��')+',ret=' + ret,
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
	//������Ŀ����ִ��
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
					msg: $g('�����ɹ�'),
					type: 'success',
					style: {
						top: 150,
						left: 450
					}
				});
			} else {
				$.messager.popover({
					msg: $g('����ʧ��'),
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
	//������Ŀ��������
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
	//�����ѡ��Ŀδִ�б���ԭ��
	obj.SaveItemVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Item').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('��ѡ����Ŀ'),
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
					msg: $g('����ѡ��ԭ�����'),
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
				msg: $g('��ѡ�����ԭ��'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	//ȡ����ѡ��Ŀδִ�б���ԭ���¼
	obj.CancelItemVar = function () {
		var rows = $('#tb-Variation-Item').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('��ѡ����Ŀ'),
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
	
	//����·����ҽ���������ԭ��
	obj.SaveOrderVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-Order').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('��ѡ��ҽ��'),
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
					var ImplID = "";	//·����ҽ��û�й�����Ŀ
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
					msg: $g('����ѡ��ԭ�����'),
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
				msg: $g('��ѡ�����ԭ��'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	//ȡ��·����ҽ���������ԭ���¼
	obj.CancelOrderVar = function () {
		var rows = $('#tb-Variation-Order').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('��ѡ��ҽ��'),
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
	
	//���淽���������ԭ��
	obj.SaveTCMVar = function () {
		var Node = $('#ItemTree').tree('getSelected');
		if (Node) {
			var IsLeaf = $('#ItemTree').tree('isLeaf', Node.target)
			if (IsLeaf) {
				var rows = $('#tb-Variation-TCMVar').datagrid("getSelections");
				if (rows.length == 0) {
					$.messager.popover({
						msg: $g('��ѡ��ҽ��'),
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
					msg: $g('����ѡ��ԭ�����'),
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
				msg: $g('��ѡ�����ԭ��'),
				type: 'error',
				style: {
					top: 150,
					left: 450
				}
			});
			return;
		}
	}
	
	//ȡ�������������ԭ���¼
	obj.CancelTCMVar = function () {
		var rows = $('#tb-Variation-TCMVar').datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.popover({
				msg: $g('��ѡ������¼'),
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
					//formatter  ��ʱisLeaf�������޷��ж��ǲ���Ҷ�ӽڵ� ��ͨ��children
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
						//ͬʱ�������µ�tree-node ����position: relative;   ��ʵ��Сͼ�꿿�� */
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
			var strOrder = rowData['OrdGeneID'];	//ͨ����ID
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
			//��ҽ����ӵ��б�
			websys_showModal('options').addOEORIByCPW(strOrderList)
			websys_showModal('close');
		}
	}
	obj.OutCPW = function () {
		var varID = Common_GetValue('OutReason')
		var varTxt = Common_GetValue('OutText')
		var errorInfo = "";
		if (varID == "") {
			errorInfo = $g("��ѡ�����ԭ��<br />")
		}
		if (varTxt == "") {
			errorInfo = errorInfo + $g("����д��ע��Ϣ��")
		}
		if (errorInfo != "") {
			$.messager.alert($g("������ʾ"), errorInfo, "error")
			return;
		}
		$m({
			ClassName: "DHCMA.CPW.OPCPS.InterfaceSrv",
			MethodName: "GetOutOPCPW",
			aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID'] + "^" + varID + "^" + varTxt,
			aSeparete: "^"
		}, function (ret) {
			if (parseInt(ret) > 0) {
				$.messager.popover({ msg: $g("�����ɹ�"), type: 'success' });
				$HUI.dialog('#OutCPWDialog').close();
				obj.InitOCPWInfo();
				obj.OperationControl();
			}
		})
	}
	obj.CloseCPW = function () {		
		if (obj.StepSelecedID != obj.StepList[obj.StepList.length-1].split(":")[0]){
			$.messager.popover({ msg: $g("���н׶�δִ�У���ֹ�˲���"), type: 'error' });
			return;	
		}else{
			//����Ƿ��Զ����н׶�ȷ�ϼ����챣������
			if (ServerObj.IsAutoCfmStep=="Y"||parseInt(ServerObj.IsAutoCfmStep)==1){
				$.messager.confirm($g("���"), $g("ȷ�����?<br />��ɺ󽫲��������κ��޸ģ�"), function (r) {
					if (r) {
						$m({
							ClassName: "DHCMA.CPW.OPCPS.InterfaceSrv",
							MethodName: "CloseOPCPW",
							aEpisodeID: EpisodeID,
							aInputs: obj.PathwayID + "^" + session['DHCMA.USERID'] + "^" + session['DHCMA.CTLOCID'] + "^" + session['DHCMA.CTWARDID']
						}, function (ret) {
							if (parseInt(ret) > 0) {
								$.messager.popover({ msg: $g("�����ɹ�"), type: 'success' });
								obj.InitOCPWInfo();
								obj.OperationControl();
							}else if(parseInt(ret)==-2){
								$.messager.popover({ msg: $g("����ʧ�ܣ����е�ǰ�׶α���δ�������ȴ�����죡"), type: 'error' });		
							}else{
								$.messager.popover({ msg: $g("����ʧ�ܣ����Ժ����ԣ�"), type: 'error' });	
							}
						})
					} 
				});
			}else {
				//���һ���׶��Ƿ�ȷ��
				if (obj.ConfList.slice(-1) != 1) {
					$.messager.popover({ msg: $g("���н׶�δȷ������ֹ�˲���"), type: 'error' });
					return;
				}
			}	
		}		
	}
	obj.ConfirmStep = function () {
		var DateFrom = $('#ODateFrom').datebox('getValue');
		var DateTo = $('#ODateTo').datebox('getValue');
		if (DateFrom == "") {
			$.messager.popover({ msg: $g("��ʼ���ڲ���Ϊ��"), type: 'error' });
			return;
		} else {
			if (DateTo == "") {
				$.messager.popover({ msg: $g("�������ڲ���Ϊ��"), type: 'error' });
				return;
			} else {
				var flg = Common_CompareDate(DateFrom, DateTo);
				if (flg) {
					$.messager.popover({ msg: $g("�������ڲ���С�ڿ�ʼ����"), type: 'error' });
					return;
				}
			}
		}
		//������ԭ��
		var VarCount = $cm({ ClassName: "DHCMA.CPW.OPCPS.PathwayVarSrv", MethodName: "CheckVarToCfmStep", aPathwayID: obj.PathwayID, aEpisID: obj.PathwayID + "||" + obj.StepSelecedID}, false);
		if (parseInt(VarCount) > 0) {
			$.messager.popover({ msg: $g("�б�����Ϣδ�������ȴ��������Ϣ��"), type: 'error' });
			$('#CPW-main').tabs('select', $g("����ԭ��"));
			return;
		}
		//���׶������Ƿ�Ϸ����½׶ο�ʼ���ڲ�������ǰһ�׶ν�������
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
		$.messager.confirm($g("ȷ��"), $g("ȷ�Ϻ󽫲��������κ��޸ģ�"), function (r) {
			if (r) {
				//��������
				var NextEpisID = ""
				var NextIndex = parseInt(obj.CurrIndex) + 1;
				if (NextIndex < obj.StepList.length) {
					var NextStep = obj.StepList[NextIndex];
					var NextEpisID = NextStep.split(":")[0];	//��һ�������ID
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
						$.messager.popover({ msg: $g("ȷ���ɹ�"), type: 'success' });
						//obj.InitOCPWSteps();	//������Ϣ
						obj.InitOCPWInfo();
						obj.OperationControl();
					}
				})
			} else {
				return;
			}
		})

	}
	
	//·����Ϣ
	obj.InitOCPWInfo = function(){
		$m({
			ClassName:"DHCMA.CPW.OPCPS.ImplementSrv",
			MethodName:"GetCPWInfo",
			aEpisodeID:EpisodeID
		},function(JsonStr){
			if (JsonStr=="") return;
			var JsonObj=$.parseJSON(JsonStr);
			 
			obj.CPWCurrDesc=JsonObj.CPWDesc;		//��ǰ��������
			obj.StatusCurrDesc=JsonObj.CPWStatus;	//��ǰ·��״̬
			obj.PathFormID=JsonObj.PathFormID		//��ǰ·���ı�ID
			obj.PathwayID=JsonObj.PathwayID			//���뾶��¼ID
			
			$('#OCPWDesc').text(JsonObj.CPWDesc)
			$('#OCPWStatus').text(JsonObj.CPWStatus)
			$('#OCPWUser').text(JsonObj.CPWUser)
			$('#OCPWTime').text(JsonObj.CPWTime)
			//$('#CPWIcon').text(JsonObj.CPWIcon)
			var htmlIcon=""
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-D">��</span>'
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-B">��</span>'
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-T">T</span>'
			htmlIcon=htmlIcon+'<span class="OIcon OIcon-Y">��</span>'
			$('#OCPWIcon').html(htmlIcon)
			$(".OIcon-D").popover({
				content: $g('��������Ϣ��' + JsonObj.SDDesc)
			});
			$(".OIcon-B").popover({
				content: JsonObj.VarDesc
			});
			$(".OIcon-T").popover({
				content: $g('�뾶������') + JsonObj.CPWDays + $g('��<br />�ƻ�������') + JsonObj.FormDays + $g('��')
			});
			$(".OIcon-Y").popover({
				content: $g('�ܷ��ã�') + JsonObj.PatCost + $g('<br />�ƻ����ã�') + JsonObj.FormCost + $g('Ԫ')
			});
			
			obj.InitOCPWSteps();
		});
	}
	//·������
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
			
			obj.StepCurrID=StepCurr.split(":")[0];			//�Ѿ�ִ�е���ǰ�����ID
			obj.StepList=StepsArr[1].split("^");			//��·�����в�������
			obj.TimeList=StepsArr[2].split("^");			//��·�����в�����ֹʱ�����飬EpDays:SttDate:EndDate
			obj.ConfList=StepsArr[3].split("^");			//��·�����в����Ƿ�ȷ�����飬1��0
			obj.SignList=StepsArr[4].split("^");			//��·�����в���ǩ����Ϣ���飬SignDoc:SignNur:SignDocDate:SignNurDate
			obj.StepSelecedID=obj.StepCurrID;				//���ѡ�еĲ���ID
			obj.CurrIndex=obj.StepList.indexOf(StepCurr);	//�Ѿ�ִ�е���ǰ������±�
			
			//չ�ֲ���
			obj.ShowCPWSteps(obj.CurrIndex);
			//�󶨵���¼�
			$('#OStepMoreList .OselectStepMore').on('click', function(){
				obj.SelectStep(this.id);
			});
			$('#OStepShow .Ostep').on('click', function(){
				var SelectedStepID=this.id.split("-")[1];
				obj.StepSelecedID=SelectedStepID;
				obj.SelectStep(this.id);
				obj.ShowStepDetail(this.id);
			});
			//չ�ֲ�������
			obj.SelectStep("OStep-"+obj.StepCurrID);
		});	
		
	}

	//չ�ֲ���
	obj.ShowCPWSteps = function(selectIndex){
		var StepSelect=obj.TimeList[selectIndex].split(":");
		$('#OStepTime').text(StepSelect[0]);
		$('#ODateFrom').datebox('setValue',StepSelect[1]);
		$('#ODateTo').datebox('setValue',StepSelect[2]);
		
		var StepShow=new Array();	//��ʾ�����Ĳ���
		var StepMore=new Array();	//����Ĳ���
		
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
				StepClass="Ostep Osteppre";	//��ִ��
			}else if(StepIndex>obj.CurrIndex){
				StepClass="Ostep Ostepaft";	//δִ��
			}else{
				StepClass="Ostep Ostepcurr";	//��ǰ����
			}
			if (ConFlg==1) StepClass="Ostep Osteppre";  //�����Ŀ��ȷ�ϣ�չ��Ϊ��ִ����ʽ
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
				StepClass="Osteppre";	//��ִ��
			}else if(StepIndex>obj.CurrIndex){
				StepClass="Ostepaft";	//δִ��
			}else{
				StepClass="Ostepcurr";	//��ǰ����
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
		if(obj.StepSelecedID != obj.StepCurrID) {	//�ǵ�ǰ���費�������ҽ��
			$("#Addorder").linkbutton("disable");
		}else{
			$("#Addorder").linkbutton("enable");
		}
		//������չ�ֲ���
		obj.ShowCPWSteps(SelectedIndex);
		//չ�ֲ�������
		obj.ShowStepDetail(IDStr);
		//�󶨵���¼�
		$('#OStepMoreList .OselectStepMore').on('click', function(){
			obj.SelectStep(this.id);
		});
		$('#OStepShow .Ostep').on('click', function(){
			var SelectedStepID=this.id.split("-")[1];
			obj.StepSelecedID=SelectedStepID;
			obj.SelectStep(this.id);
			//obj.ShowStepDetail(this.id);
		});
		obj.ShowOSetpMore(0)	//�رո��ಽ��
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
					//�Ѿ�ִ��
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
			$('#OStepMore').text($g("�����"));
		}else{
			$('#OStepMore').text($g("���਋"));
			$('#OStepMore').attr("value",1);
			$('#OStepMoreList').css('display','none');
		}
	}
	//��ʾҽ��ִ����Ϣ
	obj.ClickOrdDesc = function(index){
		var selData = $('#CPWItemOrder').datagrid('getRows')[index];
		var FormOrdID=selData['xID']
		if (FormOrdID.indexOf("FJ")>-1) FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1]
		var id=FormOrdID.split("||").join("-")
		if(obj.OrdContent[id]==undefined) return;
		$HUI.popover('#'+id,{content:obj.OrdContent[id],trigger:'hover'});
		$('#'+id).popover('show');
	}
	//��ʾ������Ϣ��ϸ
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
	///����ַ���ʵ�ʳ��ȣ�����2��Ӣ��1������1
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