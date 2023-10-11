var init = function() {
	// 盘点录入方式一
	// =======================条件初始化start==================
	// 库存分类
	var StkCatBox = $HUI.combobox('#StkCat', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// 类组
	$('#StkScg').stkscgcombotree({
		onSelect: function(node) {
			StkCatBox.clear();
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.loadData(data);
			});
		}
	});
	
	var HandlerParams = function() {
		var Scg = $('#StkScg').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#InciId'));
	
	// ===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	// 清屏
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#ConditionsWd');
		$UI.clear(DetailGrid);
		var DefaultData = {
			StkScg: '',
			LocManGrp: '',
			InstNo: '',
			StkCat: '',
			LocStkBin: '',
			InStkTkWin: ''
		};
		$UI.fillBlock('#ConditionsWd', DefaultData);
		Select(gRowId);
	}
	// 查询
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryDetail();
		}
	});
	// 保存
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var ParamsObj = $UI.loopBlock('#ConditionsWd');
		var Main = JSON.stringify(ParamsObj);
		var ListData = DetailGrid.getChangesData('RowId');
		if (ListData === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(ListData)) { // 明	细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'jsSave',
			Main: Main,
			ListData: JSON.stringify(ListData)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryDetail();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 设置未填数 flag=1 等于0  flag=2 等于账盘数
	function SetDefault(Flag) {
		var ParamsObj = $UI.loopBlock('#ConditionsWd');
		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'jsSetDefaultQty',
			Params: Params,
			Flag: Flag
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				QueryDetail();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 根据账盘数据插入实盘列表
	function CreatStk(Inst, InstwWin) {
		if (isEmpty(Inst)) {
			$UI.msg('alert', '请选择盘点单!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'jsCreateStkTkItmWd',
			Inst: Inst,
			UserId: gUserId,
			WinId: InstwWin
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				Select(Inst);
			}
		});
	}
	
	var Select = function(Inst) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			Inst: Inst
		},
		function(jsonData) {
			var SupLocId = jsonData.SupLocId;
			LoadData(SupLocId);
			$UI.fillBlock('#ConditionsWd', jsonData);
			QueryDetail();
		});
	};
	
	function LoadData(LocId) {
		// 货位
		var LocStkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		$HUI.combobox('#LocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + LocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
		// 管理组
		$HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description'
		});
		// 实盘窗口
		$HUI.combobox('#InStkTkWin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description',
			editable: false
		});
		$('#InStkTkWin').combobox('setValue', gInstwWin);
	}
	
	function QueryDetail() {
		var ParamsObj = $UI.loopBlock('#ConditionsWd');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'jsINStkTkItmWd',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	// ======================tbar操作事件end============================
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Inst',
			field: 'Inst',
			width: 50,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: 'UomId',
			field: 'UomId',
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 60
		}, {
			title: '账盘数量',
			field: 'FreezeQty',
			width: 80,
			align: 'right'
		}, {
			title: '实盘数量',
			field: 'CountQty',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '损益数量',
			field: 'VarianceQty',
			width: 80,
			align: 'right'
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '账盘金额',
			field: 'FreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '实盘金额',
			field: 'CountRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '损益金额',
			field: 'VarianceRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '货位',
			field: 'StkBinDesc',
			width: 100
		}, {
			title: '实盘人',
			field: 'CountUserName',
			width: 100
		}, {
			title: '实盘日期',
			field: 'CountDate',
			width: 100
		}, {
			title: '实盘时间',
			field: 'CountTime',
			width: 100
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'jsINStkTkItmWd',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: DetailGridCm,
		showBar: true,
		sortName: 'InciCode',
		sortOrder: 'asc',
		pagination: false,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		},
		onBeginEdit: function(index, row) {
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'CountQty') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 38) { // up
							var newed;
							// 向上移动到第一行为止
							if (index > 0) {
								newindex = index - 1;
								$('#DetailGrid').datagrid('selectRow', newindex);
								$('#DetailGrid').datagrid('endEdit', index).datagrid('beginEdit', newindex);
								var newed = DetailGrid.getEditor({ index: newindex, field: 'CountQty' });
								if (newed != null) {
									$(newed.target).focus();
									$(newed.target).next().children().focus();
								}
							}
						}
						if (event.keyCode == 40) { // down
							if (index < $('#DetailGrid').datagrid('getData').rows.length - 1) {
								newindex = index + 1;
								$('#DetailGrid').datagrid('selectRow', newindex);
								$('#DetailGrid').datagrid('endEdit', index).datagrid('beginEdit', newindex);
								newed = DetailGrid.getEditor({ index: newindex, field: 'CountQty' });
								if (newed != null) {
									$(newed.target).focus();
									$(newed.target).next().children().focus();
								}
							}
						}
					});
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('CountQty')) {
				var CountQty = Number(row.CountQty);
				var FreezeQty = Number(row.FreezeQty);
				var Rp = Number(row.Rp);
				var FreezeRpAmt = Number(row.FreezeRpAmt);
				var VarianceQty, VarianceRpAmt;
				if (CountQty < 0) {
					$UI.msg('alert', '实盘数量不能小于0!');
					VarianceQty = 0 - FreezeQty;
					VarianceRpAmt = 0 - FreezeRpAmt;
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							CountQty: 0,
							CountRpAmt: 0,
							VarianceQty: VarianceQty,
							VarianceRpAmt: VarianceRpAmt
						}
					});
					return false;
				} else {
					VarianceQty = CountQty - FreezeQty;
					VarianceRpAmt = VarianceQty * Rp;
					var CountRpAmt = CountQty * Rp;
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							CountRpAmt: CountRpAmt,
							VarianceQty: VarianceQty,
							VarianceRpAmt: VarianceRpAmt
						}
					});
				}
			}
		},
		toolbar: [
			{
				text: '设置未填数等于0',
				iconCls: 'icon-set-zero',
				handler: function() {
					SetDefault(1);
				}
			}, {
				text: '设置未填数等于账盘数',
				iconCls: 'icon-set-paper',
				handler: function() {
					var RowData = DetailGrid.getRows();
					var RowLength = RowData.length;
					var Flag = '';
					for (var i = 0; i < RowLength; i++) {
						var FreezeQty = RowData[i].FreezeQty;
						var CountQty = RowData[i].CountQty;
						if ((Number(FreezeQty) < 0) && (isEmpty(CountQty))) {
							Flag = 'Y';
							break;
						}
					}
					if (Flag == 'Y') {
						$UI.confirm('存在批次冻结数小于0, 系统将自动匹配到其他批次, 是否继续?', '', '', SetDefault, '', '', '', '', 2);
					} else {
						SetDefault(2);
					}
				}
			}
		]
	});
	CreatStk(gRowId, gInstwWin);
};
$(init);