// 设置清洗方式详细内容
var CleanTypeDetail_CleanId;
function SetCleanTypeDetailWin(ID) {
	CleanTypeDetail_CleanId = ID;
	
	$HUI.dialog('#CleanTypeDetailWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			GetCleanTypeDetail();
		}
	}).open();
}

function GetCleanTypeDetail() {
	var DataObj = $.cm({
		ClassName: 'web.CSSDHUI.Clean.CleanTypeDetail',
		MethodName: 'GetCleanTypeDetail',
		CleanId: CleanTypeDetail_CleanId
	}, false);
	
	var Type = DataObj['Type'];
	var Tabs = $('#CleanTypeDetailTabs').tabs('tabs');
	if (!isEmpty(Type)) {
		$.each(Tabs, function(k, v) {
			$('#CleanTypeDetailTabs').tabs('disableTab', k);
		});
		var TabIndex = GetTabIndex('#CleanTypeDetailTabs', Type);
		$('#CleanTypeDetailTabs').tabs('enableTab', TabIndex).tabs('select', TabIndex);
		var TableId = 'CleanTypeDetail_' + Type;
		$UI.clearBlock(TableId);
		$UI.fillBlock(TableId, DataObj);
	} else {
		$.each(Tabs, function(k, v) {
			$('#CleanTypeDetailTabs').tabs('enableTab', k);
		});
		$UI.clearBlock('CleanTypeDetail_Instrument');
		$('#CleanTypeDetailTabs').tabs('select', 0);
		$('#CleanTypeDetailTabs').tabs('options')['onSelect']('模式1', 0);
	}
}

function GetTabIndex(TabId, Name) {
	var Tabs = $(TabId).tabs('tabs');
	var TabIndex;
	$.each(Tabs, function(k, v) {
		if (Name === v.attr('name')) {
			TabIndex = k;
			return false;
		}
	});
	return TabIndex;
}

function InitCleanTypeDetail() {
	$('#CleanTypeDetailTabs').tabs({
		onSelect: function(title, index) {
			$UI.clearBlock($(this).tabs('getTab', index));
		}
	});
	// 普通器械
	// 冲洗部分
	var FlushModeData = [
		{ text: '流动水', id: '1' },
		{ text: '压力水枪', id: '2' }
	];
	var WashModeData = [
		{ text: '刷洗', id: '1' },
		{ text: '擦洗', id: '2' }
	];
	var SterModeData = [
		{ text: '含氯消毒剂', id: '1' },
		{ text: '75%酒精', id: '2' },
		{ text: '2%戊二醛', id: '3' },
		{ text: 'AO值≥600', id: '4' },
		{ text: 'AO值≥3000', id: '5' }
	];
	var RinseModeData = [
		{ text: '漂洗', id: '1' },
		{ text: '擦洗', id: '2' }
	];
	var DryModeData = [
		{ text: '高温干燥柜', id: '1' },
		{ text: '低温真空干燥柜', id: '2' },
		{ text: '压力气枪', id: '3' },
		{ text: '95%酒精', id: '4' }
	];
	
	$('#CleanFlushMode').keywords({
		type: 'section',
		singleSelect: false,
		items: FlushModeData
	});
	$('#CleanFlushTem').numberbox({
		min: 1,
		precision: 0
	});
	$('#CleanFlushTime').numberbox({
		min: 1,
		precision: 0
	});
	
	// 模式一
	// 洗涤
	$('#CleanWashMode').keywords({
		type: 'section',
		singleSelect: false,
		items: WashModeData
	});
	// 消毒部分
	$('#CleanSterMode').keywords({
		type: 'section',
		singleSelect: false,
		items: SterModeData
	});
	// 漂洗/终末漂洗部分
	$('#CleanRinseMode').keywords({
		type: 'section',
		singleSelect: false,
		items: RinseModeData
	});
	// 干燥部分
	$('#CleanDryMode').keywords({
		type: 'section',
		singleSelect: false,
		items: DryModeData,
		onClick: function(item) {
			if (item.id === '1') {
				$('#CleanDryTime').numberbox('setValue', 20);
			} else if (item.id === '2' || item.id === '3') {
				$('#CleanDryTime').numberbox('setValue', 20);
			}
		}
	});
	
	// 模式二
	$('#CavityMirrorFlushTem').numberbox({
		min: 1,
		precision: 0
	});
	$('#CavityMirrorFlushTime').numberbox({
		min: 1,
		precision: 0
	});
	$('#CavityMirrorFlushMode').keywords({
		type: 'section',
		singleSelect: false,
		items: FlushModeData
	});
	// 洗涤
	$('#CavityMirrorWashMode').keywords({
		type: 'section',
		singleSelect: false,
		items: WashModeData
	});
	// 漂洗部分
	$('#CavityMirrorRinseMode').keywords({
		type: 'section',
		singleSelect: false,
		items: RinseModeData
	});
	// 消毒部分
	$('#CavityMirrorSterMode').keywords({
		type: 'section',
		singleSelect: false,
		items: SterModeData
	});
	// 终末漂洗部分
	$('#CavityMirrorZMMode').keywords({
		type: 'section',
		singleSelect: false,
		items: RinseModeData
	});
	// 干燥部分
	$('#CavityMirrorDryMode').keywords({
		type: 'section',
		singleSelect: false,
		items: DryModeData,
		onClick: function(item) {
			$('#CavityMirrorDryTime').numberbox('setValue', 20);
		}
	});
	
	// 模式三
	var MachineWashModeData = [
		{ text: '手工刷洗', id: '1' },
		{ text: '超声擦洗', id: '2' }
	];
	var MachineSterModeData = [
		{ text: 'AO值≥600', id: '1' },
		{ text: 'AO值≥3000', id: '2' }
	];
	var ProgramModeData = [
		{ text: 'P1手术器械', id: '1' },
		{ text: 'P2玻璃器皿', id: '2' },
		{ text: 'P3塑料物品', id: '3' },
		{ text: 'P4麻醉管路', id: '4' },
		{ text: 'P5重度污染器械', id: '5' },
		{ text: 'P6传染物品器械', id: '6' },
		{ text: 'P7清洗流程', id: '7' },
		{ text: 'P8消毒流程', id: '8' },
		{ text: 'P9干燥程序', id: '9' },
		{ text: 'P10弯盘碗类', id: '10' }
	];
	$('#MachineCleanFlushTem').numberbox({
		min: 1,
		precision: 0
	});
	$('#MachineCleanFlushTime').numberbox({
		min: 1,
		precision: 0
	});
	$('#MachineCleanFlushMode').keywords({
		type: 'section',
		singleSelect: false,
		items: FlushModeData
	});
	// 洗涤
	$('#MachineCleanWashMode').keywords({
		type: 'section',
		singleSelect: false,
		items: MachineWashModeData
	});
	// 程序
	$('#MachineCleanProgram').keywords({
		type: 'section',
		singleSelect: false,
		items: ProgramModeData
	});
	// 消毒部分
	$('#MachineCleanSterMode').keywords({
		type: 'section',
		singleSelect: false,
		items: MachineSterModeData
	});
	
	// 保存
	$UI.linkbutton('#SaveTypeDetailBtn', {
		onClick: function() {
			var tab = $('#CleanTypeDetailTabs').tabs('getSelected');
			var Type = $(tab[0]).attr('name');
			var MainParamObj = { CleanId: CleanTypeDetail_CleanId, Type: Type };
			var MainParams = JSON.stringify(MainParamObj);
			var TableId = 'CleanTypeDetail_' + Type;
			var ParamObj = $UI.loopBlock(TableId);
			var Params = JSON.stringify(ParamObj);
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanTypeDetail',
				MethodName: 'jsSave',
				MainParams: MainParams,
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					// 回显
					GetCleanTypeDetail();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	// 删除
	$UI.linkbutton('#ClearTypeDetailBtn', {
		onClick: function() {
			$UI.confirm('您将要进行删除操作,是否继续?', 'question', '', DeleteTypeDetail);
		}
	});
	
	function DeleteTypeDetail() {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanTypeDetail',
			MethodName: 'jsDelete',
			CleanId: CleanTypeDetail_CleanId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				// 回显
				GetCleanTypeDetail();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$('#CleanTypeDetailTabs').tabs({
		onSelect: function(title, index) {
			$UI.clearBlock('CleanTypeDetail_Instrument');
			$UI.clearBlock('CleanTypeDetail_CavityMirror');
			$UI.clearBlock('CleanTypeDetail_MachineClean');
			var DefaultData;
			if (title === '模式1') {
				DefaultData = {
					CleanFlushMode: '1', CleanFlushTem: 20, CleanFlushTime: 1,
					CleanWashMode: '1', CleanWashTem: 20, CleanWashTime: 1, CleanWashRatio: '1:270',
					CleanSterMode: '1', CleanSterRatio: '500mg/L', CleanSterTime: 30, CleanSterCheck: 'Y',
					CleanRinseMode: '1', CleanRinseTem: 20, CleanRinseTime: 1,
					CleanLubricateRatio: '1:15', CleanLubricateTime: 15,
					CleanDryMode: '1', CleanDryTime: 20
				};
				$UI.fillBlock('CleanTypeDetail_Instrument', DefaultData);
			} else if (title === '模式2') {
				DefaultData = {
					CleanFlushMode: '1', CleanFlushTem: 20, CleanFlushTime: 1,
					CleanWashMode: '1', CleanWashTem: 20, CleanWashTime: 1, CleanWashRatio: '1:270',
					CleanRinseMode: '1', CleanRinseTem: 20, CleanRinseTime: 1,
					CleanSterMode: '1', CleanSterRatio: '500mg/L', CleanSterTime: 30, CleanSterCheck: 'Y',
					CleanFinalRinseMode: '1', CleanFinalRinseTem: 20, CleanFinalRinseTime: 1,
					CleanDryMode: '1', CleanDryTime: 20
				};
				$UI.fillBlock('CleanTypeDetail_CavityMirror', DefaultData);
			} else if (title === '模式3') {
				DefaultData = {
					CleanFlushMode: '1', CleanFlushTem: 20, CleanFlushTime: 1,
					CleanWashMode: '1', CleanWashTem: 20, CleanWashTime: 1, CleanWashRatio: '1:270',
					MachineCleanProgram: '1',
					CleanSterMode: '1'
				};
				$UI.fillBlock('CleanTypeDetail_MachineClean', DefaultData);
			}
		}
	});
}
$(InitCleanTypeDetail);