var init = function() {
	var UseItmTrack = GetAppPropValue('DHCITMTRACKM').UseItmTrack;
	// 科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InStkTkParamObj.AllLoc == 'Y') {
		SupLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkScg').setFilterByLoc(LocId);
		},
		onChange: function(e) {
			InitLocSet(e);
		}
	});
	$HUI.combobox('#Supervision', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'I', 'Description': 'I' }, { 'RowId': 'II', 'Description': 'II' }, { 'RowId': 'III', 'Description': 'III' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	// 库存分类
	var StkCatBox = $HUI.combobox('#StkCat', {
		valueField: 'RowId',
		textField: 'Description'
	});
		
	// 类组  库存分类联动
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
	
	function InitLocSet(LocId) {
		$HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description',
			multiple: true,
			selectOnNavigation: false,
			panelHeight: 'auto',
			editable: false,
			formatter: function(row) {
				var opts;
				if (row.selected == true) {
					opts = row.Description + "<span id='i" + row.RowId + "' class='icon icon-ok'></span>";
				} else {
					opts = row.Description + "<span id='i" + row.RowId + "' class='icon'></span>";
				}
				return opts;
			},
			onSelect: function(rec) {
				var obji = document.getElementById('i' + rec.RowId);
				$(obji).addClass('icon-ok');
			},
			onUnselect: function(rec) {
				var obji = document.getElementById('i' + rec.RowId);
				$(obji).removeClass('icon-ok');
			}
		});
		// 起始货位
		var FrStkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		$HUI.combobox('#FrStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + FrStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
		// 终止货位
		var ToStkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		$HUI.combobox('#ToStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + ToStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	
	// 查询
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var LocId = $('#SupLoc').combobox('getValue');
			FindWin(LocId, Query);
		}
	});
	var Query = function Query(ParamsObj) {
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(DetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1,
			Params: Params
		});
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(DetailGrid);
		$UI.clear(MasterGrid);
		
		$('[name="HVFlag"]').radio('enable');
		$('[name="HVFlag"][id="HVFlag"]').radio('setDisable', UseItmTrack == 'Y');
		
		var DefaultData = {
			SupLoc: gLocObj
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		DetailGrid.setFooterInfo();
	}
	// 生成盘点点
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			$UI.confirm('请确保盘点期间盘点科室不再进行库存变动!', '', '', function() {
				var MainObj = $UI.loopBlock('#MainConditions');
				var HVFlag = MainObj['HVFlag'];
				if ((UseItmTrack == 'N') && (HVFlag != '')) {
					$UI.confirm('未启用高值跟踪，是否将高值与非高值分开盘点?', '', '', function() {
						Save();
					});
				} else {
					Save();
				}
			});
		}
	});
	function Save() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		var LocId = MainObj['SupLoc'];
		var HVFlag = MainObj['HVFlag'];
		var FrStkBin = MainObj['FrStkBin'];
		var ToStkBin = MainObj['ToStkBin'];
		if (isEmpty(LocId)) {
			$UI.msg('alert', '请选取科室!');
			return;
		}
		if ((UseItmTrack == 'Y') && (HVFlag == '')) {
			$UI.msg('alert', '已启用高值跟踪,请将高值与非高值分开盘点!');
			return;
		}
		if ((isEmpty(FrStkBin) && (!isEmpty(ToStkBin))) || (!isEmpty(FrStkBin) && (isEmpty(ToStkBin)))) {
			$UI.msg('alert', '请同时维护起始货位和终止货位!');
			return;
		}
		// 判断是否存在未调整完成的盘点单
		/* var CheckExistRet = $.m({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'CheckExistBeforeInstk',
			Params: Main
		},false);
		if(CheckExistRet!="N"){
			$UI.msg('alert', "存在未调整完成的盘点单"+CheckExistRet+",请先完成调整或删除盘点单");
			return;
		}*/
		// 判断是否存在需要处理的单据
		var CheckParams = { LocId: LocId };
		var CheckRet = $.m({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'CheckBeforeInstk',
			Params: JSON.stringify(CheckParams)
		}, false);
		if (!isEmpty(CheckRet)) {
			$UI.msg('alert', CheckRet);
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsCreateInStktk',
			Main: Main
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				var RowId = jsonData.rowid;
				var ParamsObj = $UI.loopBlock('#FindWin');
				ParamsObj.RowId = RowId;
				Query(ParamsObj);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// 完成
	var SetComp = function() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSetComplete',
			Inst: row.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				var ParamsObj = {};
				ParamsObj.RowId = row.RowId;
				Query(ParamsObj);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	// 取消完成
	var SetUnComplete = function() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSetUnComplete',
			Inst: row.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				var ParamsObj = {};
				ParamsObj.RowId = row.RowId;
				Query(ParamsObj);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	// 删除
	var Delete = function() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		if (row.CompFlag == 'Y') {
			$UI.msg('alert', '请先取消完成后再删除操作!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsDelete',
			Inst: row.RowId
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				var ParamsObj = $UI.loopBlock('#FindWin');
				Clear();
				Query(ParamsObj);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	function Select() {
		$UI.clearBlock('#MainConditions');
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		var RowId = row.RowId;
		if (isEmpty(RowId)) {
			$UI.msg('alert', '请选择一条盘点单!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			Inst: RowId
		}, function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			$('#LocManGrp').combobox('setValues', jsonData.InStkGrpId.split(','));
		});
	}
	// 加载明细
	function loadDetailGrid() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		var RowId = row.RowId;
		if (isEmpty(RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		var ParamsObj = $UI.loopBlock('DetailConditions');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1,
			Inst: RowId,
			Others: '',
			totalFooter: '"InciCode":"合计"',
			totalFields: 'FreezeQty,FreezeRpAmt'
		});
	}
	// 打印
	function Print(type) {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		var RowId = row.RowId;
		if (isEmpty(RowId)) {
			$UI.msg('alert', '请选择一条盘点单!');
			return;
		}
		PrintINStk(RowId, type);
		var ParamsObj = $UI.loopBlock('#FindWin');
		Clear();
		Query(ParamsObj);
	}
	
	var MasterGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 50
		}, {
			title: '盘点单号',
			field: 'InstNo',
			width: 150
		}, {
			title: '账盘日期',
			field: 'FreezeDate',
			width: 100,
			align: 'left'
		}, {
			title: '账盘时间',
			field: 'FreezeTime',
			width: 80,
			align: 'left'
		}, {
			title: '盘点人Id',
			field: 'FreezeUserId',
			hidden: true
		}, {
			title: '账盘人',
			field: 'FreezeUserName',
			width: 80,
			align: 'left'
		}, {
			title: '状态',
			field: 'Status',
			width: 60,
			align: 'left',
			hidden: true
		}, {
			title: '盘点科室Id',
			field: 'LocId',
			hidden: true
		}, {
			title: '盘点科室',
			field: 'LocDesc',
			width: 150,
			align: 'left'
		}, {
			title: '账盘完成',
			field: 'CompFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '重点关注标志',
			field: 'ManaFlag',
			width: 80,
			align: 'left',
			formatter: BoolFormatter,
			hidden: true
		}, {
			title: '盘点单位',
			field: 'FreezeUomId',
			width: 80,
			align: 'left',
			formatter: function(value, row, index) {
				if (row.FreezeUomId == 1) {
					return '入库单位';
				} else {
					return '基本单位';
				}
			}
		}, {
			title: '账盘进价金额',
			field: 'SumFreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '账盘售价金额',
			field: 'SumFreezeSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '包括不可用',
			field: 'IncludeNotUse',
			width: 100,
			align: 'left',
			formatter: BoolFormatter,
			hidden: true
		}, {
			title: '仅不可用',
			field: 'OnlyNotUse',
			width: 80,
			align: 'left',
			formatter: BoolFormatter,
			hidden: true
		}, {
			title: '不可用标志',
			field: 'NotUseFlag',
			width: 90,
			align: 'center'
		}, {
			title: '类组Id',
			field: 'StkScgId',
			hidden: true
		}, {
			title: '类组',
			field: 'StkScgDesc',
			width: 80,
			align: 'left'
		}, {
			title: '库存分类Id',
			field: 'StkCatId',
			hidden: true
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 80,
			align: 'left'
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 80,
			formatter: BoolFormatter,
			align: 'center'
		}, {
			title: '收费标志',
			field: 'ChargeFlag',
			width: 80,
			formatter: BoolFormatter,
			align: 'center'
		}, {
			title: '开始货位',
			field: 'FrSbDesc',
			width: 80,
			align: 'left'
		}, {
			title: '结束货位',
			field: 'ToSbDesc',
			width: 80,
			align: 'left'
		}, {
			title: '打印标志',
			field: 'PrintFlag',
			width: 80,
			align: 'left',
			formatter: BoolFormatter
		}, {
			title: '最低进价',
			field: 'MinRp',
			width: 80,
			align: 'right'
		}, {
			title: '最高进价',
			field: 'MaxRp',
			width: 80,
			align: 'right'
		}, {
			title: '抽查数',
			field: 'RandomNum',
			width: 80,
			align: 'right'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		showBar: true,
		toolbar: [
			{
				text: '完成',
				id: 'CompBT',
				iconCls: 'icon-ok',
				handler: function() {
					SetComp();
				}
			}, {
				text: '取消完成',
				id: 'CancleCompBT',
				iconCls: 'icon-no',
				handler: function() {
					SetUnComplete();
				}
			}, {
				text: '删除',
				id: 'DeleteBT',
				iconCls: 'icon-cancel',
				handler: function() {
					Delete();
				}
			}, {
				text: '按批次打印',
				iconCls: 'icon-print',
				handler: function() {
					var type = 1;
					Print(type);
				}
			}, {
				text: '按品种打印',
				iconCls: 'icon-print-box',
				handler: function() {
					var type = 2;
					Print(type);
				}
			}
		],
		onSelect: function(index, row) {
			loadDetailGrid();
			Select();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#MasterGrid').datagrid('selectRow', 0);
			}
		}
	});
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 50
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
			width: 50
		}, {
			title: 'InciId',
			field: 'InciId',
			hidden: true,
			width: 50
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
			title: '条码',
			field: 'Barcode',
			width: 100,
			align: 'left'
		}, {
			title: '账盘数量',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: '账盘日期',
			field: 'FreezeDate',
			width: 100,
			hidden: true
		}, {
			title: '账盘时间',
			field: 'FreezeTime',
			width: 100,
			align: 'left',
			hidden: true
		}, {
			title: '实盘数量',
			field: 'CountQty',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '实盘日期',
			field: 'CountDate',
			width: 100,
			hidden: true
		}, {
			title: '实盘时间',
			field: 'CountTime',
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: '实盘人',
			field: 'CountUserId',
			hidden: true,
			align: 'left'
		}, {
			title: '实盘人',
			field: 'CountUserName',
			width: 100,
			align: 'left',
			hidden: true
		}, {
			title: 'Variance',
			field: 'Variance',
			width: 100,
			align: 'left',
			hidden: true
		}, {
			title: '备注',
			field: 'Remark',
			width: 60,
			align: 'left',
			hidden: true
		}, {
			title: '状态',
			field: 'Status',
			width: 60,
			align: 'left',
			hidden: true
		}, {
			title: '单位',
			field: 'UomId',
			hidden: true,
			align: 'left'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80,
			align: 'left'
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100,
			align: 'left'
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100,
			align: 'left'
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '类组',
			field: 'StkScgDesc',
			width: 100,
			align: 'left'
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 100,
			align: 'left'
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 100,
			align: 'left'
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '调整标志',
			field: 'AdjFlag',
			width: 60,
			align: 'left',
			hidden: true
		}, {
			title: '货位码',
			field: 'StkBinDesc',
			width: 100,
			align: 'left'
		}, {
			title: 'dd',
			field: 'AdjId',
			hidden: true,
			align: 'left'
		}, {
			title: '售价',
			field: 'Sp',
			width: 60,
			align: 'right',
			hidden: true
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '账盘售价金额',
			field: 'FreezeSpAmt',
			width: 60,
			align: 'right',
			hidden: true
		}, {
			title: '账盘进价金额',
			field: 'FreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '实盘售价金额',
			field: 'CountSpAmt',
			width: 60,
			align: 'right',
			hidden: true
		}, {
			title: '实盘进价金额',
			field: 'CountRpAmt',
			width: 60,
			align: 'right',
			hidden: true
		}, {
			title: '损益售价金额',
			field: 'VarianceSpAmt',
			width: 60,
			align: 'right',
			hidden: true
		}, {
			title: '损益进价金额',
			field: 'VarianceRpAmt',
			width: 60,
			align: 'right',
			hidden: true
		}, {
			title: '账盘条码',
			field: 'FreezeBarCodeStr',
			width: 60,
			align: 'left',
			hidden: true
		}, {
			title: '实盘条码',
			field: 'CountBarCodeStr',
			width: 60,
			align: 'left',
			hidden: true
		}, {
			title: '未盘条码',
			field: 'VarianceBarCodeStr',
			width: 60,
			align: 'left',
			hidden: true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1
		},
		columns: DetailGridCm,
		showBar: true,
		showFooter: true,
		sortName: 'InciCode',
		sortOrder: 'asc',
		totalFooter: '"InciCode":"合计"',
		totalFields: 'FreezeQty,FreezeRpAmt'
	});
	Clear();
	Query({ FLoc: gLocId, FStartDate: '', FEndDate: '', FInstComp: 'N' });
};
$(init);