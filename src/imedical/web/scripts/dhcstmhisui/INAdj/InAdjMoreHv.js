
var init = function () {
	var ClearMain = function () {
		$UI.clearBlock('#MainConditions');
		$UI.clear(INAdjMGrid);
		Dafult()
		$UI.fillBlock('#MainConditions', Dafult)
	}
	//高值条码相关
	//var HVBarCodeEditor = {}
	//Grid 列 comboxData
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows =INAdjMGrid.getRows();  
				var row = rows[INAdjMGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.Inci;
				}

			},
			onSelect: function (record) {
				var rows = INAdjMGrid.getRows();
				var row = rows[INAdjMGrid.editIndex];
				row.UomDesc = record.Description;

			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	var AdjLocParams = JSON.stringify(addSessionParams({
				Type: "All"
			}));
	var AdjLocBox = $HUI.combobox('#AdjLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + AdjLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var UserBox = $HUI.combobox('#User', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});
	var ForAdjustReasonIdParams = JSON.stringify(addSessionParams({
				Type: "M"
			}));
	var ForAdjustReasonIdBox = $HUI.combobox('#ForAdjustReasonId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetForAdjustReason&ResultSetType=array&Params=' + ForAdjustReasonIdParams,
			valueField: 'Rowid',
			textField: 'Description'
		});
	//按钮相关操作
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var HvFlag="Y"
			FindWin(Select,HvFlag);
		}
	});
var Save = function () {
		var MainObj = $UI.loopBlock('#MainConditions')
			var MainInfo = JSON.stringify(MainObj)
			var IsChange = $UI.isChangeBlock('#MainConditions')
			if (MainObj['INADCompleted'] == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			var MainInfo = JSON.stringify(MainObj)
			var SelectedRow = INAdjMGrid.getSelected();
		if (isEmpty(SelectedRow) && IsChange === false) {
			$UI.msg('alert',"没有需要保存的明细!");
			return false;
		}
		var ListData = INAdjMGrid.getChangesData('Inclb')
		if (ListData === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(ListData)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		var ListData=JSON.stringify(ListData)
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			MethodName: 'SaveAdj',
			MainInfo: MainInfo,
			ListData: ListData
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			Save();
		}
	});

	$UI.linkbutton('#DelBT', {
		onClick: function () {
			var InAdj = $('#RowId').val()
				if (isEmpty(InAdj)) {
					return;
				}
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINAdj',
					MethodName: 'Delete',
					InAdj: InAdj
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success',jsonData.msg);
						ClearMain();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
			$UI.confirm('确定要删除吗?', '', '', del)
		}
	});
	$UI.linkbutton('#ComBT', {
		onClick: function () {
			var MainObj = $UI.loopBlock('#MainConditions')
				var InAdj = MainObj.RowId;
			if (isEmpty(InAdj)) {
				return;
			}
			var Main = JSON.stringify(MainObj)
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINAdj',
					MethodName: 'SetComplete',
					Params: Main,
					InAdj: InAdj
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success',jsonData.msg);
						Select(InAdj);
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
		}
	});
	$UI.linkbutton('#CanComBT', {
		onClick: function () {
			var MainObj = $UI.loopBlock('#MainConditions')
				var InAdj = MainObj.RowId;
			var Main = JSON.stringify(MainObj)

				if (isEmpty(InAdj)) {
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINAdj',
					MethodName: 'SetCancelComplete',
					InAdj: InAdj,
					Params: Main
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success',jsonData.msg);
						Select(InAdj);
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			ClearMain();
			setEditEnable();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			if (isEmpty($('#RowId').val())) {
				$UI.msg('alert',"没有需要打印的单据!");
				return;
			}
			PrintInAdj($('#RowId').val());
		}
	});
	var Select = function (RowId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(INAdjMGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			MethodName: 'jsSelect',
			InAdj: RowId
		}, function (jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			var ComBT = jsonData['INADCompleted'];
			if(ComBT=='Y'){
				var BtnEnaleObj = {'#ComBT':false, '#CanComBT':true,
				'#DelBT':false,'#PrintBT':true};
			}else{
				var BtnEnaleObj = {'#ComBT':true, '#CanComBT':false,
				'#DelBT':true,'#PrintBT':true};
			}
			ChangeButtonEnable(BtnEnaleObj);

		});

		var ParamsObj = {
			InAdj: RowId
		};
		var Params = JSON.stringify(ParamsObj);
		$UI.setUrl(INAdjMGrid);
		INAdjMGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
			QueryName: 'DHCINAdjD',
			Params: Params,
			rows: 99999
		});

	}

	var INAdjMGridCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: 'RowId',
				field: 'RowId',
				saveCol: true,
				hidden: true
			}, {
				title: "InciId",
				field: 'InciId',
				width: 150,
				hidden: true
			}, {
				title: "Inclb",
				field: 'Inclb',
				saveCol: true,
				width: 150,
				hidden: true
			}, {
				title: "代码",
				field: 'Code',
				width: 100
			}, {
				title: '描述',
				field: 'InciDesc',
				width: 150
			}, {
				title: 'dhcit',
				field: 'dhcit',
				width: 80,
				hidden: true
			}, {
				title: '高值条码',
				field: 'HvBarCode',
				saveCol: true,
				width: 150,
				jump:false,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "批号~效期",
				field: 'BatExp',
				width: 150
			}, {
				title: "厂商",
				field: 'Manf',
				width: 200
			}, {
				title: "批次库存",
				field: 'InclbQty',
				width: 100
			}, {
				title: "调整数量",
				field: 'Qty',
				width: 100,
				align: 'right',
				saveCol: true
			}, {
			title: '单位Id',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: "售价",
			field: 'Sp',
			saveCol: true,
			width: 100

		}, {
			title: "售价金额",
			field: 'SpAmt',
			saveCol: true,
			width: 100

		}, {
			title: "进价",
			field: 'Rp',
			saveCol: true,
			width: 100

		}, {
			title: "进价金额",
			field: 'RpAmt',
			saveCol: true,
			width: 100
		}, {
			title: "批价",
			field: 'Pp',
			saveCol: true,
			width: 100,
			hidden: true
		}
		]];
	var lastIndex = '';
	var INAdjMGrid = $UI.datagrid('#INAdjMGrid', {
			url: '',
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				QueryName: 'DHCINSpD'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				MethodName: 'jsDelete'
			},
			columns: INAdjMGridCm,
			showBar: true,
			showAddDelItems: true,
			pagination: false,
			onClickCell: function (index, filed, value) {
				if ($HUI.checkbox("#Complete").getValue()) {
					return false;
				}
				INAdjMGrid.commonClickCell(index, filed, value);
			},
			afterAddFn: function(){
				var BtnEnaleObj = {'#ComBT':true, '#CanComBT':false,
				'#DelBT':false,'#PrintBT':true};
				ChangeButtonEnable(BtnEnaleObj);
			},
			onBeginEdit: function (index, row) {
				$('#INAdjMGrid').datagrid('beginEdit', index);
				var ed = $('#INAdjMGrid').datagrid('getEditors', index);
				for (var i = 0; i < ed.length; i++) {
					var e = ed[i];
					if (e.field == 'HvBarCode') {
						$(e.target).bind('keydown', function (event) {
							if (event.keyCode == 13) {
								var BarCode = $(this).val();
								if (isEmpty(BarCode)) {
									INAdjMGrid.stopJump();
									return;
								}
								var FindIndex = INAdjMGrid.find('HvBarCode', BarCode);
								if (FindIndex >= 0 && FindIndex != index) {
									$UI.msg('alert','条码不可重复录入!', 'warning', '', 500);
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return false;
								}
								var BarCodeData = $.cm({
										ClassName: 'web.DHCSTMHUI.DHCItmTrack',
										MethodName: 'GetItmByBarcode',
										BarCode: BarCode
									}, false);
								if (!isEmpty(BarCodeData.sucess) && BarCodeData.sucess != 0) {
									$UI.msg('alert',BarCodeData.msg)
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return;
								}
								var ScgStk = BarCodeData['ScgStk'];
								var ScgStkDesc = BarCodeData['ScgStkDesc'];
								var Inclb = BarCodeData['Inclb'];
								var IsAudit = BarCodeData['IsAudit'];
								var Type = BarCodeData['Type'];
								var Status = BarCodeData['Status'];
								var RecallFlag = BarCodeData['RecallFlag'];
								var Inci = BarCodeData['Inci'];
								var dhcit = BarCodeData['dhcit'];
								var lastDetailOperNo=BarCodeData['OperNo'];
								var ScgStk = $('#ScgStk').combobox('getValue');
								if (Inclb == '') {
									$UI.msg('alert','该高值材料没有相应库存记录,不能制单!');
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return;
								} else if (IsAudit != 'Y') {
									$UI.msg('alert','该高值材料有未审核的' + lastDetailOperNo + ',请核实!');
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return;
								} else if (Type == 'T') {
									$UI.msg('alert','该高值材料已经出库,不可制单!');
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return;
								}else if ((Status != 'InAdj')&&(Status != 'InScrap')){
									$UI.msg('alert', '该高值条码不是已调整或已报损状态,不可制单!');
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return;
								} else if (RecallFlag == 'Y') {
									$UI.msg('alert','该高值条码处于锁定状态,不可制单!');
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return;
								}
								var ProLocId = $('#AdjLoc').combobox('getValue');
								var ReqLocId = $('#AdjLoc').combobox('getValue');
								var ParamsObj = {
									InciDr: Inci,
									ProLocId: ProLocId,
									ReqLocId: ReqLocId,
									QtyFlag: 0,
									Inclb: Inclb
								};
								var Params = JSON.stringify(ParamsObj);

								var InclbData = $.cm({
										ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
										MethodName: 'GetDrugBatInfo',
										page: 1,
										rows: 1,
										Params: Params
									}, false);
								if (!InclbData || InclbData.rows.length < 1) {
									$UI.msg('alert', BarCode + '没有相应库存记录,不能制单!');
									$(this).val('');
									$(this).focus();
									INAdjMGrid.stopJump();
									return;
								}
								var InclbInfo = $.extend(InclbData.rows[0], {
										InciDr: Inci,
										dhcit: dhcit,
										HvBarCode: BarCode
									});
								ReturnInfoFn(index, InclbInfo);
							}
						});
					}

				}
			},
			beforeAddFn: function () {
				if ($HUI.checkbox("#Complete").getValue()) {
					$UI.msg('alert',"已经完成，不能增加一行!");
					return false;
				}
				if (isEmpty($HUI.combobox("#AdjLoc").getValue())) {
					$UI.msg('alert',"制单科室不能为空!");
					return false;
				};
				if (isEmpty($HUI.combobox("#ScgStk").getValue())) {
					$UI.msg('alert',"类组不能为空!");
					return false;
				};
				if (isEmpty($HUI.combobox("#ForAdjustReasonId").getValue())) {
					$UI.msg('alert',"调整原因不能为空!");
					return false;
				}
			},
			beforeDelFn: function(){
				if ($HUI.checkbox("#Complete").getValue()) {
					$UI.msg('alert',"已经完成，不能删除选中行!");
					return false;
				}
			}
		});
	function ReturnInfoFn(RowIndex, row) {
		INAdjMGrid.updateRow({
			index: RowIndex,
			row: {
				HvBarCode: row.HvBarCode,
				dhcit: row.dhcit,
				InciId: row.InciDr,
				Code: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				BatExp: row.BatExp,
				Qty: row.OperQty,
				UomId: row.PurUomId,
				UomDesc: row.PurUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				InclbQty: row.InclbQty,
				Qty: 1
			}
		});
		$('#INAdjMGrid').datagrid('refreshRow', RowIndex);
		INAdjMGrid.commonAddRow();
	}
	/*--设置初始值--*/
	var BtnEnaleObj = {'#ComBT':false, '#CanComBT':false,'#DelBT':false,'#PrintBT':false};
	ChangeButtonEnable(BtnEnaleObj);
	var Dafult = function () {
		var EdDate = DateAdd(new Date(), 'd', parseInt(7));
		var DafultValue = {
			RowId: "",
			AdjLoc: gLocObj,
			Audit: 'N'
		}
		$UI.fillBlock('#MainConditions', DafultValue)
	}
	Dafult()
}
$(init);
