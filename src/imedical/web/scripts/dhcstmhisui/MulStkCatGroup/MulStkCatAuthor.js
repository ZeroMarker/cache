var init = function() {
	var HospId = gHospId;
	var TableName = 'CT_Loc';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
		Query();
	}
	function Query() {
		GetScgTree();
		var LocText = $('#LocText').val();
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			query2JsonStrict: 1,
			rows: 9999,
			Params: JSON.stringify(addSessionParams({ Type: 'All', Desc: LocText, BDPHospital: HospId }))
		});
	}
	$('#LocText').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			Query();
		}
	});
	var LocGrid = $UI.datagrid('#LocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			query2JsonStrict: 1,
			rows: 9999,
			Params: JSON.stringify(addSessionParams({ Type: 'All' }))
		},
		fitColumns: true,
		singleSelect: true,
		columns: [[
			{ field: 'ck', checkbox: true },
			{ title: '科室ID', field: 'RowId', width: 50, hidden: true },
			{ title: '科室名称', field: 'Description', width: 200 }
		]],
		pagination: false,
		onSelect: function(index, row) {
			var LocId = row['RowId'];
			GetAuthorDetail(LocId);
		}
	});
	
	function GetAuthorDetail(LocId) {
		var LocRowData = LocGrid.getSelected();
		if (isEmpty(LocId) && isEmpty(LocRowData)) {
			return;
		}
		var LocId = LocRowData['RowId'];
		
		// 先去掉勾选,默认
		var Roots = $('#ScgTree').tree('getRoots');
		for (var i = 0, Len = Roots.length; i < Len; i++) {
			$('#ScgTree').tree('uncheck', Roots[i].target);
			var Children = $('#ScgTree').tree('getChildren', Roots[i].target);
			for (var j = 0, ChLen = Children.length; j < ChLen; j++) {
				if (Children[j].id.indexOf('SCG') != -1) {
					$('#ScgTree').tree('update', {
						target: Children[j].target,
						iconCls: 'icon-add'
					});
				}
			}
		}
		
		var UserId = '';
		var StrParam = LocId + '^' + UserId;
		var AuthorStr = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetAuthorLeafScg', StrParam);
		var AuthorArr = AuthorStr.split('^');
		for (var i = 0; i < AuthorArr.length; i++) {
			Author = AuthorArr[i];
			var Node = $('#ScgTree').tree('find', 'SCG-' + Author);
			if (Node) {
				$('#ScgTree').tree('check', Node.target);
			}
		}
		
		// 缺省类组特别标记
		var StrParam = LocId + '^^';
		var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetDefaScg', StrParam);
		var ScgId = DefaInfo.split('^')[0], ScgDesc = DefaInfo.split('^')[1];
		if (ScgId && ScgDesc) {
			var Node = $('#ScgTree').tree('find', 'SCG-' + ScgId);
			if (Node) {
				$('#ScgTree').tree('update', {
					target: Node.target,
					iconCls: 'icon-stamp'
				});
			}
		}
	}
	
	$UI.linkbutton('#AuthorBT', {
		onClick: function() {
			SaveAuthor();
		}
	});
	function SaveAuthor() {
		var SelRec = LocGrid.getSelected();
		if (isEmpty(SelRec)) {
			$UI.msg('alert', '请选择需要授权的对象!');
			return false;
		}
		var LocId = SelRec['RowId'];
		var AuthorPar = LocId;
		
		var Str = '';
		var CheckedNodes = $('#ScgTree').tree('getChecked');
		for (var i = 0, Len = CheckedNodes.length; i < Len; i++) {
			var Node = CheckedNodes[i];
			var NodeType = Node.id.split('-')[0];
			var NodeRowId = Node.id.split('-')[1];
			if ((NodeType == 'INCSC') || (NodeType == 'AllSCG')) {
				continue;
			}
			var IsLeaf = $('#ScgTree').tree('isLeaf', Node.target);
			if (NodeType == 'SCG' && IsLeaf) {
				$UI.msg('alert', Node.text + ' 未关联库存分类,不允许授权');
				return false;
			}
			if (Str == '') {
				Str = NodeRowId;
			} else {
				Str = Str + ',' + NodeRowId;
			}
		}
		var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'SaveAuthorData', Str, AuthorPar);
		if (ret != '') {
			$UI.msg('error', '授权失败:' + ret);
		} else {
			var CheckMainLocScgFlag = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'CheckMainLocScg', LocId);
			if (CheckMainLocScgFlag != 0) {
				$UI.msg('alert', '授权成功,与其支配科室权限不一致!');
			} else {
				$UI.msg('success', '授权成功!');
			}
			GetAuthorDetail(LocId);
		}
	}
	
	$UI.linkbutton('#SetDefaBT', {
		onClick: function() {
			SetDefaBT();
		}
	});
	function SetDefaBT() {
		var LocRowData = LocGrid.getSelected();
		if (isEmpty(LocRowData)) {
			$UI.msg('alert', '请选择科室!');
			return false;
		}
		var Node = $('#ScgTree').tree('getSelected');
		if (isEmpty(Node) || Node.checked != true || Node.id.split('-')[0] != 'SCG'
		|| (!isEmpty(Node.children) && Node.children[0].id.indexOf('INCSC') == -1)) {
			$UI.msg('alert', '请选择需要默认的类组(最底层类组)!');
			return false;
		}

		var LocId = LocRowData['RowId'];
		var ScgId = Node.id.split('-')[1];
		var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'SetLocDefaScg', LocId, ScgId);
		if (ret != '') {
			$UI.msg('error', '设置失败:' + ret);
		} else {
			$UI.msg('success', '设置成功!');
			GetAuthorDetail(LocId);
		}
	}
	
	$('#ScgTree').tree({
		lines: true,
		checkbox: true,
		onBeforeCheck: function(node, checked) {
			var IsLeaf = $(this).tree('isLeaf', node.target);
			if (node.id.indexOf('SCG') >= 0 && IsLeaf) {
				$UI.msg('alert', '未关联库存分类,不允许授权!');
				return false;
			}
		},
		onCheck: function(node, checked) {
			if (node.id.indexOf('INCSC') >= 0) {
				var Parent = $(this).tree('getParent', node.target);
				if (checked) {
					$(this).tree('check', Parent.target);
				} else {
					$(this).tree('uncheck', Parent.target);
				}
			}
		}
	});
	
	function GetScgTree() {
		$.cm({
			wantreturnval: 0,
			ClassName: 'web.DHCSTMHUI.MulStkCatGroup',
			MethodName: 'GetScg',
			ParScg: '',
			Params: JSON.stringify(addSessionParams({ BDPHospital: HospId }))
		}, function(data) {
			$('#ScgTree').tree({
				data: data
			});
		});
	}
	GetScgTree();
	InitHosp();
};
$(init);