/*
 * 界面元素授权window
 */
var PageElementAuthorWin = function(Block) {
	if (CommParObj['PageElementAuthor'] !== 'Y') {
		$UI.msg('alert', '本次登录没有进行界面元素授权的权限,请核实!');
		return;
	}
	
	$HUI.combobox('#ElementAuthorGroup', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			$UI.clear(ElementAuthorGrid);
		}
	}).setValue(gGroupId);
	
	$UI.linkbutton('#ElementAuthorInitBT', {
		onClick: function() {
			var GroupId = $('#ElementAuthorGroup').combobox('getValue');
			if (isEmpty(GroupId)) {
				$UI.msg('alert', '请选择安全组!');
				return;
			}
			$UI.confirm('一经初始化, 自动默认该界面元素全部不授权, 是否继续?', '', '', InitQueryElementAuthor);
			// InitQueryElementAuthor();
		}
	});
	$UI.linkbutton('#ElementAuthorAllYesBT', {
		// text: '全部授权',
		onClick: function() {
			var Rows = ElementAuthorGrid.getRows();
			if (Rows.length == 0) {
				$UI.msg('error', '请先获取授权元素!');
				return;
			}
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				ElementAuthorGrid.updateRow({
					index: i,
					row: { AuthorFlag: 'Y' }
				});
			}
			setTimeout(function() {
				ElementAuthorGrid.refreshRow();
				$UI.msg('alert', '批量处理后请点击保存!');
			}, 50);
		}
	});
	$UI.linkbutton('#ElementAuthorAllNoBT', {
		// text: '全部不授权',
		onClick: function() {
			var Rows = ElementAuthorGrid.getRows();
			if (Rows.length == 0) {
				$UI.msg('error', '请先获取授权元素!');
				return;
			}
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				ElementAuthorGrid.updateRow({
					index: i,
					row: { AuthorFlag: 'N' }
				});
			}
			setTimeout(function() {
				ElementAuthorGrid.refreshRow();
				$UI.msg('alert', '批量处理后请点击保存!');
			}, 50);
		}
	});
	$UI.linkbutton('#ElementAuthorSaveBT', {
		onClick: function() {
			SaveElementAuthor();
		}
	});
	$UI.linkbutton('#ElementAuthorDeleteBT', {
		onClick: function() {
			var GroupId = $('#ElementAuthorGroup').combobox('getValue');
			if (isEmpty(GroupId)) {
				$UI.msg('alert', '请选择安全组!');
				return;
			}
			DeleteElementAuthor();
		}
	});
	
	function InitQueryElementAuthor() {
		var GroupId = $('#ElementAuthorGroup').combobox('getValue');
		if (isEmpty(GroupId)) {
			$UI.msg('alert', '请选择安全组!');
			return;
		}
		var MainObj = {};
		MainObj['SaveFor'] = GroupId;
		MainObj['CspName'] = App_MenuCspName;
		MainObj['FormId'] = Block;
		var MainInfo = JSON.stringify(addSessionParams(MainObj));
		
		var PageInfoArr = [];
		$(Block + ' :input').each(function() {
			// 不做授权的元素,约定给需授权的元素添加class(nopageauthor)
			if ($(this).hasClass('nopageauthor') == false && $(this).attr('type') != 'hidden') {
				var Id = $(this).attr('id');
				var Label = $(this).parent().prev().text() || $(this).text();
				// checkbox取值特殊,和html中定义相关(如物资信息维护,通过label属性定义)
				if ($(this).attr('type') == 'checkbox' && !isEmpty($(this).attr('label'))) {
					Label = $(this).attr('label');
				}
				
				var Obj = {};
				Obj.ElementId = Id;
				Obj.ElementLabel = Label;
				if (!(isEmpty(Id) || isEmpty(Label))) {
					PageInfoArr.unshift(Obj);
				}
			}
		});
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPageElementAuthor',
			MethodName: 'InitSave',
			MainInfo: MainInfo,
			PageInfo: JSON.stringify(PageInfoArr)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				QueryElementAuthor();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function QueryElementAuthor() {
		var GroupId = $('#ElementAuthorGroup').combobox('getValue');
		if (isEmpty(GroupId)) {
			return;
		}
		var ParamsObj = {};
		ParamsObj['SaveFor'] = GroupId;
		ParamsObj['CspName'] = App_MenuCspName;
		ParamsObj['FormId'] = Block;
		
		ElementAuthorGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPageElementAuthor',
			QueryName: 'GetAuthorDetail',
			query2JsonStrict: 1,
			Params: JSON.stringify(ParamsObj),
			rows: 9999
		});
	}
	
	function SaveElementAuthor() {
		var GroupId = $('#ElementAuthorGroup').combobox('getValue');
		if (isEmpty(GroupId)) {
			$UI.msg('alert', '请选择安全组!');
			return;
		}
		var MainObj = {};
		MainObj['SaveFor'] = GroupId;
		MainObj['CspName'] = App_MenuCspName;
		MainObj['FormId'] = Block;
		var MainInfo = JSON.stringify(addSessionParams(MainObj));
		
		var Detail = ElementAuthorGrid.getRowsData();
		if (isEmpty(Detail)) {
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPageElementAuthor',
			MethodName: 'SaveAuthorData',
			MainInfo: MainInfo,
			DetailParams: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryElementAuthor();
				ReSetElementAuthor(Block);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function DeleteElementAuthor() {
		var GroupId = $('#ElementAuthorGroup').combobox('getValue');
		if (isEmpty(GroupId)) {
			$UI.msg('alert', '请选择安全组!');
			return;
		}
		var MainObj = {};
		MainObj['SaveFor'] = GroupId;
		MainObj['CspName'] = App_MenuCspName;
		MainObj['FormId'] = Block;
		var MainInfo = JSON.stringify(addSessionParams(MainObj));
		
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPageElementAuthor',
			MethodName: 'DeleteAuthorData',
			MainInfo: MainInfo
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryElementAuthor();
				ReSetElementAuthor(Block);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var ElementAuthorCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '元素ID',
			field: 'ElementId',
			width: 200
		}, {
			title: '元素名称',
			field: 'ElementLabel',
			width: 200
		}, {
			title: '编辑权限',
			field: 'AuthorFlag',
			width: 100,
			align: 'center',
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var ElementAuthorGrid = $UI.datagrid('#ElementAuthorGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPageElementAuthor',
			QueryName: 'GetAuthorDetail',
			query2JsonStrict: 1
		},
		columns: ElementAuthorCm,
		fitColumns: true,
		navigatingWithKey: true,
		pagination: false,
		onClickCell: function(index, filed, value) {
			ElementAuthorGrid.commonClickCell(index, filed, value);
		}
	});
	
	$HUI.dialog('#PageElementAuthorWin', {
		width: 750,
		height: 650,
		onOpen: function() {
			QueryElementAuthor();
		}
	}).open();
};

/**
 * 重置界面元素是否可编辑
 * @param {容器id} Block
 * @param {不可编辑的控件id数组} DisabledCompArr
 */
function ReSetElementAuthor(Block) {
	var ParamsObj = {};
	ParamsObj['SaveFor'] = gGroupId;
	ParamsObj['CspName'] = App_MenuCspName;
	ParamsObj['FormId'] = Block;
	var MainInfo = JSON.stringify(addSessionParams(ParamsObj));
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCPageElementAuthor',
		QueryName: 'GetAuthorDetail',
		query2JsonStrict: 1,
		Params: JSON.stringify(ParamsObj),
		rows: 9999
	}, false);
	var AuthorArr = jsonData.rows;
	for (var i = 0; i < AuthorArr.length; i++) {
		var Obj = AuthorArr[i];
		var ElementId = '#' + Obj.ElementId;
		var AuthorFlag = Obj.AuthorFlag;
		if ((AuthorFlag == 'Y') && !$(ElementId).hasClass('pageauthorno')) {
			// 有授权, 且不再系统已控制范围的,才允许置为可用
			try {
				$(ElementId).attr('disabled', false);
			} catch (e) {}
			
			try {
				$(ElementId).combo('enable');
			} catch (e) {}
			
			try {
				$HUI.checkbox(ElementId).enable();
			} catch (e) {}
			
			// 控制旁边可能存在的按钮
			if ($(ElementId + '~ .hisui-linkbutton').length > 0) {
				$(ElementId + '~ .hisui-linkbutton').linkbutton('enable');
			}
		} else {
			try {
				$(ElementId).attr('disabled', true);
			} catch (e) {}
			
			try {
				$(ElementId).combo('disable');
			} catch (e) {}
			
			try {
				$HUI.checkbox(ElementId).disable();
			} catch (e) {}
			
			$(ElementId).addClass('pageauthorno');
			
			// 控制旁边可能存在的按钮
			if ($(ElementId + '~ .hisui-linkbutton').length > 0) {
				for (var n = 0, len = $(ElementId + '~ .hisui-linkbutton').length; n < len; n++) {
					if ($($(ElementId + '~ .hisui-linkbutton')[n]).hasClass('nopageauthor')) {
						// 设置nopageauthor时,不进行不可用处理, 仅设置pageauthorno,后续单独控制不可保存等(如注册证按钮,保留查看功能)
						$($(ElementId + '~ .hisui-linkbutton')[n]).addClass('pageauthorno');
					} else {
						$($(ElementId + '~ .hisui-linkbutton')[n]).linkbutton('disable');
					}
				}
			}
		}
	}
}