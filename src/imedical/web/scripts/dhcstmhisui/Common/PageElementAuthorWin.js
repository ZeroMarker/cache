/*
 * ����Ԫ����Ȩwindow
 */
var PageElementAuthorWin = function(Block) {
	if (CommParObj['PageElementAuthor'] !== 'Y') {
		$UI.msg('alert', '���ε�¼û�н��н���Ԫ����Ȩ��Ȩ��,���ʵ!');
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
				$UI.msg('alert', '��ѡ��ȫ��!');
				return;
			}
			$UI.confirm('һ����ʼ��, �Զ�Ĭ�ϸý���Ԫ��ȫ������Ȩ, �Ƿ����?', '', '', InitQueryElementAuthor);
			// InitQueryElementAuthor();
		}
	});
	$UI.linkbutton('#ElementAuthorAllYesBT', {
		// text: 'ȫ����Ȩ',
		onClick: function() {
			var Rows = ElementAuthorGrid.getRows();
			if (Rows.length == 0) {
				$UI.msg('error', '���Ȼ�ȡ��ȨԪ��!');
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
				$UI.msg('alert', '�����������������!');
			}, 50);
		}
	});
	$UI.linkbutton('#ElementAuthorAllNoBT', {
		// text: 'ȫ������Ȩ',
		onClick: function() {
			var Rows = ElementAuthorGrid.getRows();
			if (Rows.length == 0) {
				$UI.msg('error', '���Ȼ�ȡ��ȨԪ��!');
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
				$UI.msg('alert', '�����������������!');
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
				$UI.msg('alert', '��ѡ��ȫ��!');
				return;
			}
			DeleteElementAuthor();
		}
	});
	
	function InitQueryElementAuthor() {
		var GroupId = $('#ElementAuthorGroup').combobox('getValue');
		if (isEmpty(GroupId)) {
			$UI.msg('alert', '��ѡ��ȫ��!');
			return;
		}
		var MainObj = {};
		MainObj['SaveFor'] = GroupId;
		MainObj['CspName'] = App_MenuCspName;
		MainObj['FormId'] = Block;
		var MainInfo = JSON.stringify(addSessionParams(MainObj));
		
		var PageInfoArr = [];
		$(Block + ' :input').each(function() {
			// ������Ȩ��Ԫ��,Լ��������Ȩ��Ԫ�����class(nopageauthor)
			if ($(this).hasClass('nopageauthor') == false && $(this).attr('type') != 'hidden') {
				var Id = $(this).attr('id');
				var Label = $(this).parent().prev().text() || $(this).text();
				// checkboxȡֵ����,��html�ж������(��������Ϣά��,ͨ��label���Զ���)
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
			$UI.msg('alert', '��ѡ��ȫ��!');
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
			$UI.msg('alert', '��ѡ��ȫ��!');
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
			title: 'Ԫ��ID',
			field: 'ElementId',
			width: 200
		}, {
			title: 'Ԫ������',
			field: 'ElementLabel',
			width: 200
		}, {
			title: '�༭Ȩ��',
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
 * ���ý���Ԫ���Ƿ�ɱ༭
 * @param {����id} Block
 * @param {���ɱ༭�Ŀؼ�id����} DisabledCompArr
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
			// ����Ȩ, �Ҳ���ϵͳ�ѿ��Ʒ�Χ��,��������Ϊ����
			try {
				$(ElementId).attr('disabled', false);
			} catch (e) {}
			
			try {
				$(ElementId).combo('enable');
			} catch (e) {}
			
			try {
				$HUI.checkbox(ElementId).enable();
			} catch (e) {}
			
			// �����Ա߿��ܴ��ڵİ�ť
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
			
			// �����Ա߿��ܴ��ڵİ�ť
			if ($(ElementId + '~ .hisui-linkbutton').length > 0) {
				for (var n = 0, len = $(ElementId + '~ .hisui-linkbutton').length; n < len; n++) {
					if ($($(ElementId + '~ .hisui-linkbutton')[n]).hasClass('nopageauthor')) {
						// ����nopageauthorʱ,�����в����ô���, ������pageauthorno,�����������Ʋ��ɱ����(��ע��֤��ť,�����鿴����)
						$($(ElementId + '~ .hisui-linkbutton')[n]).addClass('pageauthorno');
					} else {
						$($(ElementId + '~ .hisui-linkbutton')[n]).linkbutton('disable');
					}
				}
			}
		}
	}
}