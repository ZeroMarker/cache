// 名称:招标轮次维护
// 编写日期:2018-8-8
var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_ItmPBLevel';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
		Query();
	}
	function Query() {
		Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		if (TableName == 'DHC_ItmPBLevel') {
			PbLevelGrid.load({
				ClassName: 'web.DHCSTMHUI.ITMPBLEVEL',
				MethodName: 'SelectAll',
				Params: Params
			});
		} else if (TableName == 'DHC_PublicBiddingList') {
			PublicBiddingListGrid.load({
				ClassName: 'web.DHCSTMHUI.PublicBiddingList',
				QueryName: 'SelectAll',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	}
	
	$HUI.tabs('#DetailTabs', {
		onSelect: function(title, index) {
			if (title == '招标级别') {
				TableName = 'DHC_ItmPBLevel';
			} else if (title == '招标轮次维护') {
				TableName = 'DHC_PublicBiddingList';
			}
			InitHosp();
			Query();
		}
	});
	
	var PbLevelAddRowBtn = {
		iconCls: 'icon-add',
		text: '新增',
		handler: function() {
			PbLevelGrid.commonAddRow();
		}
	};
	
	var PbLevelSaveBtn = {
		iconCls: 'icon-save',
		text: '保存',
		handler: function() {
			var Rows = PbLevelGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			for (var i = 0; i < Rows.length; i++) {
				if (Rows[i].DateFrom > Rows[i].DateTo) {
					$UI.msg('alert', '开始日期大于截止日期,无法保存!');
					return;
				}
			}
			var ListDetail = JSON.stringify(Rows);
			var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.ITMPBLEVEL',
				MethodName: 'Save',
				Main: MainObj,
				Params: ListDetail
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					PbLevelGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	};
	
	var PbLevelCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '级别代码',
			field: 'Code',
			width: 100,
			editor: {
				type: 'validatebox',
				options: {
					tipPosition: 'bottom',
					required: true
				}
			}
		}, {
			title: '级别名称',
			field: 'Desc',
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					tipPosition: 'bottom',
					required: true
				}
			}
		}, {
			title: '开始日期',
			field: 'DateFrom',
			width: 150,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '结束日期',
			field: 'DateTo',
			width: 150,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}
	]];
	
	var PbLevelGrid = $UI.datagrid('#PbLevelGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ITMPBLEVEL',
			MethodName: 'SelectAll'
		},
		columns: PbLevelCm,
		toolbar: [PbLevelAddRowBtn, PbLevelSaveBtn],
		onClickRow: function(index, row) {
			PbLevelGrid.commonClickRow(index, row);
		}
	});
	/* ---------------------*/
	$('#AddBT').on('click', function() {
		PublicBiddingListGrid.commonAddRow();
	});
	
	$('#SaveBT').on('click', function() {
		var Rows = PublicBiddingListGrid.getChangesData();
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			if (Rows[i].StartDate > Rows[i].EndDate) {
				$UI.msg('alert', '开始日期大于截止日期,无法保存!');
				return;
			}
		}
		var ListDetail = JSON.stringify(Rows);
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.PublicBiddingList',
			MethodName: 'Save',
			Main: MainObj,
			Params: ListDetail
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				PublicBiddingListGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});
	
	/* var PbLevelCombo = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			data : function(){
				var ComboData =$.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetPBLevel',
					ResultSetType: 'array',
					Params:JSON.stringify(addSessionParams({BDPHospital:HospId}))
				}, false);
				return ComboData;
			}()
		}
	};*/
	var PbLevelCombo = {
		type: 'combobox',
		options: {
			// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array&Params=' + Params,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = PublicBiddingListGrid.getRows();
				var row = rows[PublicBiddingListGrid.editIndex];
				row.Level = record.Description;
			},
			onShowPanel: function() {
				var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				$(this).combobox('clear');
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=Array&Params=' + Params;
				$(this).combobox('reload', url);
			}
		}
	};
	var PublicBiddingListCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '招标代码',
			field: 'Code',
			width: 100,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '招标名称',
			field: 'Description',
			width: 150,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '招标日期',
			field: 'Date',
			width: 140,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '代理机构名称',
			field: 'Tenderee',
			width: 150,
			editor: 'text'
		}, {
			title: '开始日期',
			field: 'StartDate',
			width: 140,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '结束日期',
			field: 'EndDate',
			width: 140,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '招标级别',
			field: 'LevelId',
			width: 140,
			formatter: CommonFormatter(PbLevelCombo, 'LevelId', 'Level'),
			editor: PbLevelCombo
		}, {
			title: '备注',
			field: 'Remark',
			width: 150,
			editor: 'text'
		}, {
			title: '激活标志',
			field: 'ActiveFlag',
			width: 80,
			align: 'center',
			editor: {
				type: 'checkbox',
				options: {
					on: 'Y',
					off: 'N'
				}
			},
			formatter: BoolFormatter
		}
	]];
	
	var PublicBiddingListGrid = $UI.datagrid('#PublicBiddingList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PublicBiddingList',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		columns: PublicBiddingListCm,
		toolbar: '#PublicBiddingListTB',
		sortName: 'RowId',
		sortOrder: 'asc',
		fitColumns: true,
		onClickRow: function(index, row) {
			PublicBiddingListGrid.commonClickRow(index, row);
		},
		beforeAddFn: function() {
			var DefaValue = { ActiveFlag: 'Y' };
			return DefaValue;
		}
	});
	InitHosp();
};
$(init);