var MustInputSet = function(Block) {
	$HUI.dialog('#MustInputSetWin', {
		height: 600,
		width: 780,
		onOpen: function() {
			InitMustInput();
		}
	}).open();
	function MustInputSave() {
		var Detail = MustInputSetGrid.getRowsData();
		if (Detail === false) { return; } // 验证未通过  不能保存
		$.cm({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Save',
			Params: JSON.stringify(Detail),
			LocId: gLocId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				MustInputSetFind();
				ReSetMustInput(Block);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function InitMustInput() {
		var ArrData = [];
		$(Block + ' :input').each(function() {
			if ($(this).attr('type') != 'hidden') {
				if ($(this).attr('type') != 'checkbox') {
					var obj = {};
					var Id = $(this).attr('id');
					var Name = $(this).attr('name') || $(this).attr('comboname');
					var Label = $(this).parent().prev().text() || $(this).text();
					var Csp = App_MenuCspName;
					obj.INCMIEleId = Id;
					obj.INCMIEleLabel = Label;
					obj.INCMIEleName = Name;
					obj.INCMICspName = Csp;
					obj.INCMIBlock = Block;
					if (!(isEmpty(Id) || isEmpty(Name) || isEmpty(Label))) {
						ArrData.unshift(obj);
					}
				}
			}
		});

		$.cm({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'InitSave',
			Params: JSON.stringify(ArrData),
			LocId: gLocId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				MustInputSetFind();
				// ResSetMustInput(Block);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	/* --按钮事件--*/
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			MustInputSave();
		}
	});
	var MustInputSetGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '控件ID',
			field: 'INCMIEleId',
			width: 200
		}, {
			title: '控件Name',
			field: 'INCMIEleName',
			width: 200,
			align: 'left'
		}, {
			title: '控件名称',
			field: 'INCMIEleLabel',
			width: 200,
			align: 'left'
		}, {
			title: '是否必填',
			field: 'INCMIMustFlag',
			width: 100,
			align: 'center',
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var MustInputSetGrid = $UI.datagrid('#MustInputSetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Query'
		},
		columns: MustInputSetGridCm,
		pagination: false,
		navigatingWithKey: true,
		onClickRow: function(index, row) {
			MustInputSetGrid.commonClickRow(index, row);
		}
	});
	function MustInputSetFind() {
		MustInputSetGrid.load({
			ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
			MethodName: 'Query',
			Block: Block,
			LocId: gLocId
		});
	}
};

function ReSetMustInput(Block) {
	$.cm({
		ClassName: 'web.DHCSTMHUI.InciInfoMustInput',
		MethodName: 'Query',
		Block: Block,
		LocId: gLocId
	}, function(jsonData) {
		ChangeMust(Block, jsonData);
	});
}
function ChangeMust(Block, jsonData) {
	if (jsonData.rows.lenght == 0) {
		return;
	}
	FormMustInput[Block] = [];
	for (var i = 0; i < jsonData.rows.length; i++) {
		var obj = jsonData.rows[i];
		if (obj.INCMIMustFlag == 'Y') {
			//FormMustInput[Block].push(obj.INCMIEleName);
			FormMustInput[Block].push(obj);
			if ($('#' + obj.INCMIEleId).attr('type') == 'checkbox') {
				continue;
			}
			var Original = $('#' + obj.INCMIEleId).parent().prev().text();
			if (Original.indexOf('*') == -1) {
				$('#' + obj.INCMIEleId).parent().prev().html('<span class="required">*</span>' + Original);
			}
		} else {
			var Original = $('#' + obj.INCMIEleId).parent().prev().text();
			if (Original.indexOf('*') > -1) {
				Original = Original.slice(1);
				$('#' + obj.INCMIEleId).parent().prev().html(Original);
			}
		}
	}
}
