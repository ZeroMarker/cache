var init = function() {
	var Params = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#WardLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	/*
	var HandlerParams=function(){
		var Obj={StkGrpRowId:"",StkGrpType:"M",Locdr:gLocId};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	*/
	$('#PatNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PatNo = $(this).val();
			if (isEmpty(PatNo)) {
				$UI.msg('alert', '请输入登记号!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PatNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
				$('#PatNo').val(newPaAdmNo);
				$('#RegInfo').val(patinfo);
			} catch (e) {}
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(DispDetailGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		if (isEmpty(ParamsObj.WardLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		var PatNo = ParamsObj.PatNo;
		var MainParam = JSON.stringify(ParamsObj);
		if (!isEmpty(PatNo)) {
			DispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCIpMatDisp',
				QueryName: 'QueryIpMatDispDetailByPatNo',
				query2JsonStrict: 1,
				Params: MainParam,
				rows: 99999
			});
		} else {
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			DispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCIpMatDisp',
				QueryName: 'QueryIpMatDispDetailByDate',
				query2JsonStrict: 1,
				Params: MainParam,
				rows: 99999
			});
		}
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(DispDetailGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#DispBT', {
		onClick: function() {
			var RowsData = DispDetailGrid.getSelections();
			if (RowsData.length == 0) {
				$UI.msg('alert', '请选择需要处理的材料记录!');
				return;
			}
			var dispStr = '';
			for (var i = 0; i < RowsData.length; i++) {
				var DSPRowId = RowsData[i].DSPRowId;
				if (dispStr == '') {
					dispStr = DSPRowId;
				} else {
					dispStr = dispStr + '^' + DSPRowId;
				}
			}
			if (isEmpty(dispStr)) {
				$UI.msg('alert', '请选择需要处理的材料记录!');
				return;
			}
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var LocId = ParamsObj.WardLoc;
			var Params = JSON.stringify(addSessionParams({
				WardLoc: LocId,
				dispStr: dispStr
			}));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCIpMatDisp',
				MethodName: 'jsIPMatDisp',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#PatNo').val('');
					$('#RegInfo').val('');
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	// / 待处理记录
	var DispDetailGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'DSPRowId',
			field: 'DSPRowId',
			saveCol: true,
			width: 60,
			hidden: true
		}, {
			title: '要求执行时间',
			field: 'exestdatetime',
			width: 150
		}, {
			title: '库存项id',
			field: 'inci',
			saveCol: true,
			width: 60,
			hidden: true
		}, {
			title: '登记号',
			field: 'regno',
			width: 100
		}, {
			title: '姓名',
			field: 'patname',
			width: 60
		}, {
			title: '物资代码',
			field: 'incicode',
			width: 100
		}, {
			title: '物资名称',
			field: 'incidesc',
			width: 150
		}, {
			title: '数量',
			field: 'qty',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'dispUomDesc',
			width: 80
		}, {
			title: '单价',
			field: 'Sp',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '金额',
			field: 'SpAmt',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '医嘱状态',
			field: 'oeflag',
			width: 80,
			hidden: true
		}, {
			title: '医师',
			field: 'orduserName',
			width: 100
		}, {
			title: '货位',
			field: 'stkbin',
			width: 100
		}, {
			title: '厂家',
			field: 'manf',
			width: 100
		}, {
			title: '库存',
			field: 'logQty',
			width: 80,
			align: 'right'
		}, {
			title: '在途库存',
			field: 'reservedQty',
			width: 80,
			align: 'right'
		}, {
			title: '医嘱明细id',
			field: 'orditm',
			saveCol: true,
			width: 80
		}, {
			title: '就诊号',
			field: 'ADMNo',
			saveCol: true,
			width: 80
		}
	]];

	var DispDetailGrid = $UI.datagrid('#DispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCIpMatDisp',
			QueryName: 'QueryIpMatDispDetailByDate',
			query2JsonStrict: 1,
			rows: 99999
		},
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		showBar: true,
		columns: DispDetailGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			DispDetailGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			
		}
	});
	
	/* --设置初始值--*/
	var Default = function() {
		var StartDate = new Date();
		var EndDate = new Date();
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DateFormatter(StartDate),
			EndDate: DateFormatter(EndDate),
			WardLoc: gLocObj
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	Query();
};
$(init);