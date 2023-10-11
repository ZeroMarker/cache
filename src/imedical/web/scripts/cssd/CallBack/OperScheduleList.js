var init = function() {
	var CurrId = '';
	var Default = function() {
		var DefaultData = {
			FStartDate: DefaultStDate(),
			FEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#OperScheduleTB', DefaultData);
	};
	
	// 接收科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#OperLocId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	function PrefixInteger(num, length) {
		return (Array(length).join('0') + num).slice(-length);
	}
	
	$('#regNo').keypress(function(event) {
		if (event.which === '13') {
			var value = $('#regNo').val();
			if (isEmpty(value)) {
				return;
			}
			var patNo = PrefixInteger(value, 10);
			$('#regNo').val(patNo);
		}
	});

	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearDrugInfo();
		}
	});
	
	function ClearDrugInfo() {
		$UI.clearBlock('#OperScheduleTB');
		$UI.clear(OperScheduleGrid);
		Default();
	}
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#OperScheduleTB');
		if (isEmpty(ParamsObj.FStartDate) || isEmpty(ParamsObj.FEndDate)) {
			$UI.msg('alert', '请选择手术日期！');
			return;
		}
		OperScheduleGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.OperScheduleList',
			QueryName: 'FindOperScheduleList',
			// QueryName: 'ANOPArrData',			//老版本排班表结构不同(目前已知8.3项目存在老版本)
			Params: JSON.stringify(ParamsObj),
			rows: 9999
		});
	}
	
	var OperScheduleCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '状态背景',
			field: 'StatusColor',
			width: 80,
			hidden: true
		}, {
			title: '状态',
			field: 'StatusDesc',
			width: 80,
			styler: function(value, row, index) {
				return 'background-color:' + row.StatusColor + ';' + 'color:' + GetFontColor(row.StatusColor);
			}
		}, {
			title: '类型',
			field: 'SourceType',
			width: 80,
			hidden: true
		}, {
			title: '类型',
			field: 'SourceTypeDesc',
			width: 80
		}, {
			title: '登记号',
			field: 'RegNo',
			width: 120
		}, {
			title: '手术日期',
			field: 'OperDate',
			width: 100
		}, {
			title: '手术间Code',
			field: 'RoomCode',
			width: 80,
			hidden: true
		}, {
			title: '手术间',
			field: 'RoomDesc',
			width: 100
		}, {
			title: '病案号',
			field: 'MedcareNo',
			width: 120
		}, {
			title: '患者姓名',
			field: 'PatName',
			width: 100
		}, {
			title: '性别',
			field: 'PatGender',
			width: 80
		}, {
			title: '年龄',
			field: 'PatAge',
			width: 80
		}, {
			title: '床号',
			field: 'BedNo',
			width: 80
		}, {
			title: '排班科室ID',
			field: 'OperDeptID',
			width: 80,
			hidden: true
		}, {
			title: '排班科室',
			field: 'OperDeptDesc',
			width: 160
		}, {
			title: '患者科室ID',
			field: 'PatDeptID',
			width: 80,
			hidden: true
		}, {
			title: '科室',
			field: 'PatDeptDesc',
			width: 160
		}, {
			title: '手术名称',
			field: 'OperDesc',
			width: 200
		}, {
			title: '艾滋',
			field: 'HivStatus',
			width: 100
		}, {
			title: '梅毒',
			field: 'SypStatus',
			width: 100
		}, {
			title: '乙肝',
			field: 'HbsStatus',
			width: 100
		}, {
			title: '丙肝',
			field: 'HcvStatus',
			width: 100
		}
	]];
	var OperScheduleGrid = $UI.datagrid('#OperSchedule', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.OperScheduleList',
			QueryName: 'FindOperScheduleList'
		},
		columns: OperScheduleCm,
		pagination: true,
		selectOnCheck: false,
		onLoadSuccess: function(data) {
			$.each(data.rows, function(Index, Row) {
				var StatusColor = Row.StatusColor;
				SetGridBgColor(OperScheduleGrid, Index, 'RowId', StatusColor, 'StatusDesc');
			});
			
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrId)) {
					var Rows = $('#OperSchedule').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId === CurrId) {
							GridListIndex = index;
							return false;
						}
					});
					CurrId = '';
				} else if (CommParObj.SelectFirstRow === 'Y') {
					GridListIndex = 0;
				}
				if (!isEmpty(GridListIndex)) {
					$('#OperSchedule').datagrid('selectRow', GridListIndex);
				}
			}
		},
		onSelect: function(index, row) {
			var Id = row.RowId;
			if (!isEmpty(Id)) {
				BindAllPackage(Id);
			}
		}
	});
	
	// /登记外来器械表
	var DetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '消毒包',
			field: 'InstruName',
			width: 200
		}, {
			title: '标牌',
			field: 'InstruCode',
			align: 'left',
			width: 120
		}
	]];

	var DetailListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			QueryName: 'GetDeviceRegister',
			Params: JSON.stringify($UI.loopBlock('#IpuntTB')),
			rows: 9999999999
		},
		columns: DetailCm,
		pagination: false,
		fitColumns: true
	});
	
	// 扫码动作自动提交
	$('#BarCode').keypress(function(event) {
		if (event.which == 13) {
			var barCode = $('#BarCode').val();
			var row = $('#OperSchedule').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择需要绑定的数据!');
				return;
			}
			if (isEmpty(row.RowId)) {
				$UI.msg('alert', '参数错误!');
				return;
			}
			if (isEmpty(barCode)) {
				return;
			}
			var ParamsTB = JSON.stringify(addSessionParams({ barCode: barCode }));
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
				MethodName: 'jsBindBarCode',
				Params: JSON.stringify(row),
				ParamsTB: ParamsTB
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					CurrId = row.RowId;
					OperScheduleGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
				$('#BarCode').val('').focus();
			});
		}
	});
	
	function BindAllPackage(Id) {
		var Params = JSON.stringify(addSessionParams({ MainDr: Id }));
		DetailListGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			QueryName: 'GetDeviceRegister',
			Params: Params,
			rows: 9999999999
		});
	}

	Default();
};
$(init);