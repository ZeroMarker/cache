// 名称:单据号自动生成规则
var StkSysCounteGrid;
var initCounte = function() {
	var StkSysCounteSynBT = {
		text: '同步',
		iconCls: 'icon-reload',
		handler: function() {
			Reset();
		}
	};
	function Reset() {
		showMask();
		var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId(), Type: 'Counte', InitFlag: 'N' }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DataInit',
			MethodName: 'jsInit',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var StkSysCounteSaveBT = {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			StkSysCounteSave();
		}
	};
	
	function StkSysCounteSave() {
		var Rows = StkSysCounteGrid.getChangesData();
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.Common.DHCStkSysCounter',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var StkSysCounteCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: 'AppId',
			field: 'AppId',
			width: 80,
			hidden: true
		}, {
			title: '代码',
			field: 'AppCode',
			width: 120,
			align: 'left'
		}, {
			title: '名称',
			field: 'AppDesc',
			width: 120,
			align: 'left'
		}, {
			title: '医院',
			field: 'Hosp',
			width: 50,
			align: 'center',
			editor: { type: 'icheckbox', options: { on: 'Y', off: 'N' }}
		}, {
			title: '科室',
			field: 'Loc',
			width: 50,
			align: 'center',
			editor: { type: 'icheckbox', options: { on: 'Y', off: 'N' }}
		}, {
			title: '类组',
			field: 'CatGrp',
			width: 50,
			align: 'center',
			editor: { type: 'icheckbox', options: { on: 'Y', off: 'N' }}
		}, {
			title: '前缀',
			field: 'Prefix',
			width: 80,
			align: 'left',
			editor: 'validatebox'
		}, {
			title: '年',
			field: 'Year',
			width: 50,
			align: 'center',
			editor: { type: 'icheckbox', options: { on: 'Y', off: 'N' }}
		}, {
			title: '月',
			field: 'Month',
			width: 50,
			align: 'center',
			editor: { type: 'icheckbox', options: { on: 'Y', off: 'N' }}
		}, {
			title: '日',
			field: 'Day',
			width: 50,
			align: 'center',
			editor: { type: 'icheckbox', options: { on: 'Y', off: 'N' }}
		}, {
			title: '序号长度',
			field: 'NoLength',
			width: 60,
			align: 'right',
			editor: 'numberbox'
		}, {
			title: '按科室',
			field: 'CountByLoc',
			width: 60,
			align: 'center',
			editor: { type: 'icheckbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
	StkSysCounteGrid = $UI.datagrid('#StkSysCounteGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.DHCStkSysCounter',
			MethodName: 'SelectAll',
			Params: Params,
			rows: 999
		},
		pagination: false,
		toolbar: [StkSysCounteSynBT, StkSysCounteSaveBT],
		showAddDelItems: false,
		fitColumns: true,
		columns: StkSysCounteCm,
		onClickRow: function(index, row) {
			StkSysCounteGrid.commonClickRow(index, row);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
			return true;
		}
	});
};
function Query() {
	var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
	$UI.clear(StkSysCounteGrid);
	StkSysCounteGrid.load({
		ClassName: 'web.DHCSTMHUI.Common.DHCStkSysCounter',
		MethodName: 'SelectAll',
		Params: Params,
		rows: 999
	});
}