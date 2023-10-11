/* 打包收费关联*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(IOeoriMainGrid);
		$UI.clear(InciMainGrid);
		$UI.clear(IOeoriDetailGrid);
		// /设置初始值 考虑使用配置
		var DefaultData = {
			StartDate: new Date(),
			EndDate: new Date()
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var FRecLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var OeorcatParams = JSON.stringify(addSessionParams());
	var OeorcatBox = $HUI.combobox('#oeorcat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array&Params=' + OeorcatParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			var Select = IOeoriMainGrid.getSelected();
			if (isEmpty(Select.Oeori)) {
				$UI.msg('alert', '请选择需要保存的医嘱信息!');
				return;
			}
			var Detail = IOeoriDetailGrid.getChangesData('inci');
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				MethodName: 'Save',
				Params: Params,
				Oeori: Select.Oeori,
				ListDetail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					IOeoriDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var Row = IOeoriDetailGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择需要删除的明细!');
				return;
			}
			var orirowid = Row.orirowid;
			if (isEmpty(orirowid)) {
				IOeoriDetailGrid.commonDeleteRow();
			} else {
				var IngrFlag = Row.IngrFlag;
				if (IngrFlag == 'Y') {
					$UI.msg('alert', '已生成入库单,不可以删除!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.OeoriBindInci',
					MethodName: 'Delete',
					hvm: orirowid
				}, function(jsonData) {
					if (jsonData.success === 0) {
						$UI.msg('success', jsonData.msg);
						IOeoriDetailGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	});

	$('#BarCode').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			Query();
		}
	});
	$('#PapmiNo').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			var PapmiNo = $(this).val();
			if (PapmiNo == '') {
				$UI.msg('alert', '请输入登记号!');
				return;
			}
			var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PapmiNo);
			var patinfoarr = patinfostr.split('^');
			var newPaAdmNo = patinfoarr[0];
			var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
			$('#PapmiNo').val(newPaAdmNo);
		}
	});
	var OeoriMainCm = [[
		{
			title: 'Oeori',
			field: 'Oeori',
			width: 100,
			hidden: true
		}, {
			title: '医嘱项代码',
			field: 'ArcimCode',
			width: 120
		}, {
			title: '医嘱项名称',
			field: 'ArcimDesc',
			width: 150
		}, {
			title: '患者登记号',
			field: 'PaAdmNo',
			width: 150
		}, {
			title: '患者姓名',
			field: 'PaAdmName',
			width: 200
		}, {
			title: '接收科室id',
			field: 'RecLoc',
			width: 200,
			hidden: true
		}, {
			title: '接收科室',
			field: 'RecLocDesc',
			width: 70
		}, {
			title: '医嘱日期',
			field: 'OeoriDate',
			width: 90,
			hidden: true
		}, {
			title: '医嘱录入人',
			field: 'UserAddName',
			width: 70
		}, {
			title: '条码',
			field: 'BarCode',
			width: 450
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 70,
			hidden: 'true'
		}
	]];
	var IOeoriMainGrid = $UI.datagrid('#IOeoriMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1
		},
		columns: OeoriMainCm,
		showBar: false,
		onSelect: function(index, row) {
			var Params = JSON.stringify({ Oeori: row.Oeori });
			IOeoriDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				QueryName: 'QueryItem',
				query2JsonStrict: 1,
				Params: Params
			});
			InciMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				QueryName: 'GetDetail',
				query2JsonStrict: 1,
				Pack: row.Inci
			});
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var InciMainCm = [[
		{
			title: 'PCL',
			field: 'PCL',
			width: 100,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 120,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 200
		}, {
			title: '进价',
			field: 'PbRp',
			width: 200
		}
	]];
	var InciMainGrid = $UI.datagrid('#InciMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetDetail',
			query2JsonStrict: 1
		},
		columns: InciMainCm,
		showBar: false,
		onDblClickRow: function(index, row) {
			var inci = row.Inci;
			var incicode = row.InciCode;
			var incidesc = row.InciDesc;
			var qty = 1;
			var record = {
				inci: inci,
				desc: incidesc,
				qty: 1,
				code: incicode
				
			};
			IOeoriDetailGrid.appendRow(record);
		}
	});
	var OeoriDetailCm = [[
		{
			title: 'orirowid',
			field: 'orirowid',
			width: 100,
			hidden: true
		}, {
			title: 'oeori',
			field: 'oeori',
			width: 80,
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'code',
			width: 80
		}, {
			title: '物资名称',
			field: 'desc',
			width: 80
		}, {
			title: '数量',
			field: 'qty',
			width: 80
		}, {
			title: '单位',
			field: 'uomdesc',
			width: 80
		}, {
			title: '批号',
			field: 'batno',
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: '效期',
			field: 'expdate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '自带码',
			field: 'originalcode',
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: '规格',
			field: 'specdesc',
			width: 80
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: 'true'
		}, {
			title: '高值条码',
			field: 'barcode',
			width: 180
		}, {
			title: '补录标记',
			field: 'IngrFlag',
			width: 80
		}, {
			title: '进价',
			field: 'rp',
			width: 80
		}, {
			title: '售价',
			field: 'sp',
			width: 80
		}, {
			title: '发票金额',
			field: 'invamt',
			width: 80
		}, {
			title: '发票号',
			field: 'invno',
			width: 80
		}, {
			title: '发票日期',
			field: 'invdate',
			width: 80
		}, {
			title: '费用状态',
			field: 'feestatus',
			width: 80
		}, {
			title: '费用总额',
			field: 'feeamt',
			width: 80
		}, {
			title: '生成日期',
			field: 'dateofmanu',
			width: 80
		}, {
			title: '供应商',
			field: 'vendor',
			width: 80
		}, {
			title: '生产厂家',
			field: 'manf',
			width: 80
		}
		
	]];
	
	var IOeoriDetailGrid = $UI.datagrid('#IOeoriDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryItem',
			query2JsonStrict: 1
		},
		columns: OeoriDetailCm,
		pagination: false,
		showBar: false,
		toolbar: '#OeoriTB',
		onClickRow: function(index, row) {
			IOeoriDetailGrid.commonClickRow(index, row);
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		ParamsObj.packFlag = 'Y';
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(IOeoriMainGrid);
		$UI.clear(IOeoriDetailGrid);
		$UI.clear(InciMainGrid);
		IOeoriMainGrid.load({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	Clear();
	Query();
};
$(init);