var init = function() {
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7' }));
	$HUI.combobox('#PkgId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			CodeDictBox.clear();
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCodeDict&ResultSetType=array&PkgDr=' + record['RowId'];
			CodeDictBox.reload(url);
		}
	});
	var CodeDictBox = $HUI.combobox('#CodeDict', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCodeDict&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var SterTypeParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#SterType', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&Params' + SterTypeParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var UserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#User', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + UserParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#PackageStatus', {
		valueField: 'RowId',
		textField: 'Description',
		data: PackageStatusData
	});
	// 接收科室
	var ToLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ToLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryTrans();
		}
	});
	function QueryTrans() {
		$UI.clear(TransAllListGrid);
		var ParamsObj = $UI.loopBlock('#TransAllCondition');
		if ((isEmpty(ParamsObj['StartDate']) || isEmpty(ParamsObj['EndDate'])) && isEmpty(ParamsObj['Label'])) {
			$UI.msg('alert', '起始日期、截止日期不允许为空！');
		}
		var Params = JSON.stringify(ParamsObj);
		TransAllListGrid.load({
			ClassName: 'web.CSSDHUI.Stat.TransStat',
			QueryName: 'QueryTrans',
			rows: 9999,
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('TransAllCondition');
			$UI.clear(TransAllListGrid);
			$UI.fillBlock('#TransAllCondition', Default);
		}
	});
	var Default = {
		StartDate: new Date(),
		EndDate: new Date()
	};
	$UI.fillBlock('#TransAllCondition', Default);

	var TransAllCm = [[
		{
			title: '标签',
			field: 'Label',
			frozen: true,
			width: 180
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			frozen: true,
			width: 150
		}, {
			title: '状态',
			field: 'StatusDesc',
			width: 80
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 100
		}, {
			title: '绑定科室',
			field: 'BindLocDesc',
			width: 150
		}, {
			title: '回收单号',
			field: 'PreCBNo',
			width: 140
		}, {
			title: '回收人',
			field: 'PreCBUserName',
			width: 80
		}, {
			title: '回收时间',
			field: 'PreCBDateTime',
			width: 150
		}, {
			title: '清洗批号',
			field: 'CleanNo',
			width: 140
		}, {
			title: '清洗机',
			field: 'CleanMachineNo',
			align: 'center',
			width: 80
		}, {
			title: '清洗人',
			field: 'CleanUserName',
			width: 80
		}, {
			title: '清洗方式',
			field: 'CleanTypeName',
			width: 100
		}, {
			title: '清洗时间',
			field: 'CleanDateTime',
			width: 150
		}, {
			title: '验收人',
			field: 'CleanChkUserName',
			width: 80
		}, {
			title: '验收时间',
			field: 'CleanChkDateTime',
			width: 150
		}, {
			title: '配包人',
			field: 'PackUserName',
			width: 80
		}, {
			title: '审核人',
			field: 'PackAckUserName',
			width: 80
		}, {
			title: '配包时间',
			field: 'PackDateTime',
			width: 150
		}, {
			title: '灭菌批号',
			field: 'SterNo',
			width: 140
		}, {
			title: '灭菌器',
			field: 'SterMachineNo',
			align: 'center',
			width: 80
		}, {
			title: '灭菌人',
			field: 'SterUserName',
			width: 80
		}, {
			title: '灭菌时间',
			field: 'SterDateTime',
			width: 150
		}, {
			title: '验收人',
			field: 'SterChkUserName',
			width: 80
		}, {
			title: '验收时间',
			field: 'SterChkDateTime',
			width: 150
		}, {
			title: '发放单号',
			field: 'DispNo',
			width: 140
		}, {
			title: '发放人',
			field: 'DispUserName',
			width: 80
		}, {
			title: '发放时间',
			field: 'DispDateTime',
			width: 150
		}, {
			title: '接收人',
			field: 'ToUserName',
			width: 80
		}, {
			title: '接收时间',
			field: 'ReceiveDateTime',
			width: 150
		}, {
			title: '患者登记号',
			field: 'PatientId',
			width: 100
		}, {
			title: '患者姓名',
			field: 'PatientName',
			width: 80
		}, {
			title: '手术医生',
			field: 'OprDoctorName',
			width: 80
		}, {
			title: '器械护士',
			field: 'InstNurseName',
			width: 80
		}, {
			title: '巡回护士',
			field: 'CircNurseName',
			width: 80
		}, {
			title: '手术时间',
			field: 'OprDateTime',
			width: 150
		}, {
			title: '手术房间号',
			field: 'OprRoomNo',
			width: 100
		}, {
			title: '手术室',
			field: 'OprRoomDesc',
			width: 100
		}, {
			title: '患者科室',
			field: 'AdmLocDesc',
			width: 150
		}, {
			title: '感染名称',
			field: 'InfectDesc',
			width: 150
		}, {
			title: '发放后回收人',
			field: 'CBUserName',
			width: 100
		}, {
			title: '发放后回收时间',
			field: 'CBDateTime',
			width: 150
		}
	]];
	var TransAllListGrid = $UI.datagrid('#TransAllList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Stat.TransStat',
			QueryName: 'QueryTrans'
		},
		columns: TransAllCm,
		pagination: false,
		singleSelect: true,
		showBar: true,
		onDblClickRow: function(index, row) {
			var Label = row['Label'];
			TransInfoWin(Label);
		}
	});

	var DefaultValue = {
		StartDate: DateFormatter(DateAdd(new Date(), 'm', -6)),
		EndDate: DateFormatter(new Date())
	};
	$UI.fillBlock('#TransAllCondition', DefaultValue);

	QueryTrans();
};
$(init);