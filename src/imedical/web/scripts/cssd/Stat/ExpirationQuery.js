// 过期包查询
var init = function() {
	// 获取页面传参
	function getQueryVariable(variable) {
		var query = window.location.search.substring(1);
		var vars = query.split('&');
		for (var i = 0; i < vars.length; i++) {
			var pair = vars[i].split('=');
			if (pair[0] === variable) {
				return pair[1];
			}
		}
		return (false);
	}
	
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	$HUI.combobox('#LocationLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PkgStatusData = [
		{ 'RowId': '0', 'Description': $g('全部') },
		{ 'RowId': '1', 'Description': $g('已过期') },
		{ 'RowId': '2', 'Description': $g('已处理') },
		{ 'RowId': '3', 'Description': $g('已灭菌') },
		{ 'RowId': '4', 'Description': $g('未发放') },
		{ 'RowId': '5', 'Description': $g('已发放') }
	];
	$HUI.combobox('#Status', {
		valueField: 'RowId',
		textField: 'Description',
		data: PkgStatusData
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空');
			return;
		} else if (compareDate(ParamsObj.StartDate, DateFormatter(new Date()))) {
			$UI.msg('alert', '开始日期不能晚于当前日期');
			return;
		}
		GridList.load({
			ClassName: 'web.CSSDHUI.Stat.ExpireQueryStat',
			QueryName: 'GetExpiredPkgs',
			Params: JSON.stringify(ParamsObj)
		});
	}
	function ExpCommit() {
		var DetailObj = GridList.getChecked();
		if (isEmpty(DetailObj)) {
			$UI.msg('alert', '请选择需要处理的标签');
			return;
		}
		for (var i = 0, Len = DetailObj.length; i < Len; i++) {
			var statusFlag = DetailObj[i]['Status'];
			if (statusFlag === 'TC') {
				$UI.msg('alert', '存在已过期处理标签，请核对！');
				return;
			}
		}
		var Main = JSON.stringify($UI.loopBlock('Conditions'));
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Stat.ExpireQueryStat',
			MethodName: 'jsExpDeal',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#GridList').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var Cm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'TransId',
			field: 'TransId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 200
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			width: 100
		}, {
			title: '当前状态',
			field: 'StatusDesc',
			width: 100
		}, {
			title: '当前状态',
			field: 'Status',
			width: 80,
			hidden: true
		}, {
			title: '当前位置',
			field: 'CurLocDesc',
			width: 120
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '离失效天数',
			field: 'MinusDate',
			align: 'right',
			width: 90
		}, {
			title: '过期处理日期',
			field: 'DealDate',
			width: 100
		}, {
			title: '过期处理时间',
			field: 'DealTime',
			width: 100
		}, {
			title: '过期处理人',
			field: 'DealUserName',
			width: 100
		}, {
			title: '重新清洗批号',
			field: 'DealCleanNo',
			width: 150
		}, {
			title: '重新清洗明细ID',
			field: 'DealCleanDetailId',
			width: 120,
			hidden: true
		}
	]];
	var GridList = $UI.datagrid('#GridList', {
		singleSelect: false,
		queryParams: {
			ClassName: 'web.CSSDHUI.Stat.ExpireQueryStat',
			QueryName: 'GetExpiredPkgs'
		},
		columns: Cm,
		showBar: true,
		toolbar: [{
			text: '过期处理',
			iconCls: 'icon-skip-no',
			handler: function() {
				ExpCommit();
			}
		}]
	});
	var Default = function() {
		// 设置初始值 考虑使用配置
		var days = getQueryVariable('ndays');
		var sterFlag = getQueryVariable('sterFlag'); // 灭菌状态的
		var isDisped = getQueryVariable('isDisped');
		var TxtDays = '', Status = '0';
		if (days !== '') {
			TxtDays = days;
		}
		if (sterFlag === '1') {
			Status = '3';
		}
		if (isDisped === '1') {
			Status = '5';
		} else if (isDisped === '0') {
			Status = '4';
		}
		var DefaultValue = {
			TxtDays: TxtDays,
			Status: Status,
			StartDate: DateFormatter(DateAdd(new Date(), 'y', -1))
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		Query();
	};
	Default();
};
$(init);