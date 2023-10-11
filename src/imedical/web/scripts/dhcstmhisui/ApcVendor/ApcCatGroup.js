var VendorCm, VendorGrid;
var HospId = gHospId;
var TableName = 'APC_Vendor';
var init = function() {
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
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#MainConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		VendorGrid.load({
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			QueryName: 'APCVendor',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	
	VendorCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '代码',
			field: 'VendorCode',
			width: 150
		}, {
			title: '名称',
			field: 'VendorDesc',
			width: 200
		}
	]];

	VendorGrid = $UI.datagrid('#VendorGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			QueryName: 'APCVendor',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: VendorCm,
		checkOnSelect: false,
		pagination: false,
		singleSelect: false,
		onSelect: function(Index, Row) {
			var Vendor = Row.RowId;
			GetAuthorDetail(Vendor);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				VendorGrid.selectRow(0);
			}
		}
	});

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

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clear(VendorGrid);
			GetScgTree();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			SaveAuthor();
		}
	});
	
	InitHosp();
};
$(init);

function GetScgTree() {
	var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
	$.cm({
		wantreturnval: 0,
		ClassName: 'web.DHCSTMHUI.MulStkCatGroup',
		MethodName: 'GetScg',
		ParScg: '',
		Params: Params
	}, function(data) {
		$('#ScgTree').tree({
			data: data
		});
	});
}

function GetAuthorDetail(Vendor) {
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
	var AuthorStr = tkMakeServerCall('web.DHCSTMHUI.ApcCatGroup', 'GetAuthorLeafScg', Vendor);
	var AuthorArr = AuthorStr.split('^');
	for (var i = 0; i < AuthorArr.length; i++) {
		Author = AuthorArr[i];
		var Node = $('#ScgTree').tree('find', 'SCG-' + Author);
		if (Node) {
			$('#ScgTree').tree('check', Node.target);
		}
	}
}

function SaveAuthor() {
	var Rows = VendorGrid.getSelectedData();
	if (Rows.length <= 0) {
		$UI.msg('alert', '请勾选要授权的供应商!');
		return;
	}
	var VenStr = VendorGrid.getSelectedData();
	var Str = '';
	var CheckedNodes = $('#ScgTree').tree('getChecked');
	for (var i = 0, Len = CheckedNodes.length; i < Len; i++) {
		var Node = CheckedNodes[i];
		var NodeType = Node.id.split('-')[0];
		var NodeRowId = Node.id.split('-')[1];
		if (NodeType == 'AllSCG') {
			continue;
		}
		if (NodeType == 'INCSC') {
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
	$.cm({
		ClassName: 'web.DHCSTMHUI.ApcCatGroup',
		MethodName: 'SaveAuthorData',
		VenStr: JSON.stringify(VenStr),
		ScgStr: Str
	}, function(jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}