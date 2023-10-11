var gCleanItmId, gPkgId;
function FindDetail(CleanItmId, PkgId) {
	gCleanItmId = CleanItmId;
	gPkgId = PkgId;
	$HUI.dialog('#SelReqWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}

var initSelReqWin = function() {
	function SelReqQuery() {
		CleanDetailList.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'GetOrdPackInfo',
			detailIds: gCleanItmId,
			rows: 999
		});
	}

	$UI.linkbutton('#UpdatePack', {
		onClick: function() {
			var Detail = CleanDetailList.getChecked();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要修改的消毒包');
				return;
			}
			for (var i = 0; i < Detail.length; i++) {
				if(Detail[i].Status=="PA"){
					$UI.msg('alert', '标签已停用不能修改!');
					return;
				}
			}
			var PackIdStr = '';
			$.each(Detail, function(index, item) {
				if (!isEmpty(item.PackId)) {
					if (!isEmpty(PackIdStr)) {
						PackIdStr = PackIdStr + ',' + item.PackId;
					} else {
						PackIdStr = item.PackId;
					}
				}
			});
			LabelInfoEdit(PackIdStr, SelReqQuery);
		}
	});
	// 标签停用
	$UI.linkbutton('#SetNotAvailableBT', {
		onClick: function() {
			var Rows = CleanDetailList.getSelectedData();
			var ParamsDetail = JSON.stringify(Rows);
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要修改的消毒包');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'jsSetNotAvailable',
				Detail: ParamsDetail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', '修改成功！');
					CleanDetailList.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	// 标签复用
	$UI.linkbutton('#SetAvailableBT', {
		onClick: function() {
			var Rows = CleanDetailList.getSelectedData();
			var ParamsDetail = JSON.stringify(Rows);
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要修改的消毒包');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'jsSetAvailable',
				Detail: ParamsDetail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', '修改成功！');
					CleanDetailList.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	// 删除已生成标签
	$UI.linkbutton('#DeleteLabel', {
		onClick: function() {
			var Rows = CleanDetailList.getSelectedData();
			var Params = JSON.stringify(Rows);
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要删除的标签!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'jsDelete',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', '删除成功!');
					CleanDetailList.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function Print(WithDetail) {
		var Detail = CleanDetailList.getSelections();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印的消毒包');
			return;
		}
		var MainParams = '';
		$.each(Detail, function(index, item) {
			if (WithDetail == 'Y') {
				// 打印明细
				if (item.IsExt == 'Y') {
					printExt(item.Label, MainParams);
				} else {
					if (item.IsLowerSter === 'Y') {	// 低温灭菌打印
						printlower(item.Label, MainParams);
					} else if (item.IsSter === 'N') {	// 消毒类
						printoutXD(item.Label, MainParams);
					} else {	// 高温灭菌打印
						printout(item.Label, MainParams);
					}
				}
			} else {
				if (item.IsExt == 'Y') {
					printExtNotDetail(item.Label, MainParams);
				} else {
					printoutnotitm(item.Label, MainParams);
				}
			}
		});
	}

	// 标签打印
	$UI.linkbutton('#Print', {
		onClick: function() {
			Print('Y');
		}
	});
	// 标签打印(无明细)
	$UI.linkbutton('#PrintNot', {
		onClick: function() {
			Print('N');
		}
	});

	var Cm = [
		[
			{
				title: '',
				field: 'ck',
				checkbox: true,
				width: 50
			}, {
				title: '清洗明细Id',
				field: 'CleanItmId',
				hidden: true
			}, {
				title: '标签',
				field: 'Label',
				width: 170
			}, {
				title: '消毒包',
				field: 'PkgDesc',
				width: 150
			}, {
				title: '打印',
				field: 'IsPrint',
				width: 80,
				formatter: function(value) {
					var status = '';
					if (value === 'Y') {
						status = '是';
					} else {
						status = '否';
					}
					return status;
				}
			}, {
				title: '打包表Id',
				field: 'PackId',
				width: 100,
				hidden: true
			}, {
				title: '审核人Id',
				field: 'PackChkUserId',
				width: 100,
				hidden: true
			}, {
				title: '审核人',
				field: 'PackChkUserName',
				width: 100
			}, {
				title: '包装人Id',
				field: 'PackUserId',
				width: 150,
				hidden: true
			}, {
				title: '包装人',
				field: 'PackUserName',
				width: 100
			}, {
				title: '配包人Id',
				field: 'PackerId',
				width: 100,
				hidden: true
			}, {
				title: '配包人',
				field: 'PackerName',
				width: 100
			}, {
				title: '灭菌人',
				field: 'SterUserName',
				width: 100
			}, {
				title: '失效日期',
				field: 'ExpDate',
				width: 100
			}, {
				title: '包装材料',
				field: 'MaterialDesc',
				width: 100
			}, {
				title: '是否停用',
				field: 'Status',
				width: 80,
				formatter: function(value) {
					var status = '';
					if (value === 'PA') {
						status = '是';
					} else {
						status = '否';
					}
					return status;
				}
			}, {
				title: '备注',
				field: 'Remark',
				width: 160,
				editor: {
					type: 'text'
				}
			}, {
				title: '灭菌明细ID',
				field: 'SterItmId',
				hidden: true,
				width: 100
			}, {
				title: '批次',
				field: 'HeatNo',
				width: 100
			}, {
				title: '灭菌器',
				field: 'MachineDesc',
				width: 100
			}, {
				title: '外来器械',
				field: 'IsExt',
				width: 100,
				hidden: true
			}, {
				title: 'IsLowerSter',
				field: 'IsLowerSter',
				width: 100,
				hidden: true
			}, {
				title: 'IsSter',
				field: 'IsSter',
				width: 100,
				hidden: true
			}
		]
	];
	var CleanDetailList = $UI.datagrid('#CleanDetail', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'GetOrdPackInfo',
			rows: 999
		},
		columns: Cm,
		pagination: false,
		singleSelect: false
	});
	$HUI.dialog('#SelReqWin', {
		onOpen: function() {
			$UI.clearBlock('#usertb');
			SelReqQuery();
		}
	});
	$HUI.dialog('#SelReqWin', {
		onClose: function() {
			var CheckData = CleanList.getChecked();
			for (var i = 0; i < CheckData.length; i++) {
				var CheckItem = CheckData[i];
				var Id = CheckItem.ID;
				if (CurrentIds === '') {
					CurrentIds = Id;
				} else {
					CurrentIds = CurrentIds + ',' + Id;
				}
			}
			CleanList.commonReload();
		}
	});
};
$(initSelReqWin);