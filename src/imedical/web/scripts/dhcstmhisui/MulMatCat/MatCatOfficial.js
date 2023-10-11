// 多级官方分类维护
var HospId = '';
var TableName = 'DHC_MatCatOfficial';
function InitHosp() {
	var hospComp = InitHospCombo(TableName, gSessionStr);
	if (typeof hospComp === 'object') {
		HospId = $HUI.combogrid('#_HospList').getValue();
		GetOfficialTree();
		GetClinicalTree();
		GetSpecialTree();
		$('#_HospList').combogrid('options').onSelect = function(index, record) {
			HospId = record.HOSPRowId;
			GetOfficialTree();
			GetClinicalTree();
			GetSpecialTree();
		};
	} else {
		HospId = gHospId;
	}
}

var init = function() {
	$HUI.tabs('#MulMatCat', {
		onSelect: function(title, index) {
			if (title == '68分类') {
				TableName = 'DHC_MatCatOfficial';
			} else if (title == '临床分类') {
				TableName = 'DHC_MatCatClinical';
			} else if (title == '特殊分类') {
				TableName = 'DHC_MatCatSpecial';
			}
			InitHosp();
			// Query();
		}
	});
	
	$HUI.tree('#MulOfficialTree', {
		dnd: true,
		lines: true,
		checkbox: false,
		onBeforeDrop: function(target, source, point) {
			var NewParent = $(this).tree('getNode', target);
			var OldParent = $(this).tree('getParent', source.target);
			if (OldParent == NewParent) {
				return false;
			}
			var NodeType = source.id.split('-')[0];
			var NewParentType = NewParent.id.split('-')[0];
			var IsLeaf = $(this).tree('isLeaf', target);
			return confirm('是否将 ' + source.text + ' 移动到 ' + NewParent.text + ' 下?');
		},
		onDrop: function(target, source) {
			var NodeType = source.id.split('-')[0];
			var NodeRowId = source.id.split('-')[1];
			
			var NewParent = $(this).tree('getNode', target);
			var NewParentType = NewParent.id.split('-')[0];
			var NewParentRowId = NewParent.id.split('-')[1];
			if (typeof (NewParentRowId) === 'undefined') {
				// 无上级的, 置空
				NewParentRowId = '';
			}
			var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'UpdateParMco', NewParentRowId, NodeRowId);
			if (ret != '') {
				$UI.msg('error', '关联修改失败:' + ret);
				$(this).tree('reload', target);
			} else {
				$UI.msg('success', '关联修改成功!');
			}
		},
		onContextMenu: function(e, node) {
			e.preventDefault();
			$(this).tree('select', node.target);
			$('#OfficialRightMenu').menu({
				onClick: function(item) {
					var NodeType = node.id.split('-')[0];
					switch (item.name) {
						case 'AddNode' :
							MatCatOfficialAdd(node);
							break;
						case 'UpdateNode' :
							if (NodeType == 'AllMCO') {
								$UI.msg('alert', '此节点不需修改!');
								return false;
							} else if (NodeType == 'MCO') {
								MatCatOfficialUpdate(node);
							}
							break;
					}
				}
			}).menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}
	});
	
	function MatCatOfficialAdd(Node) {
		var AddNodeType = Node.id.split('-')[0];
		var AddNodeRowId = Node.id.split('-')[1];
		if (typeof (AddNodeRowId) === 'undefined') {
			AddNodeRowId = '';
		}
		
		$UI.linkbutton('#AddSaveBT', {
			onClick: function() {
				var UpdateCode = $('#UpdateCode').val();
				var UpdateDesc = $('#UpdateDesc').val();
				if (UpdateCode == '') {
					$UI.msg('alert', '代码不可为空!');
					return false;
				}
				if (UpdateDesc == '') {
					$UI.msg('alert', '名称不可为空!');
					return false;
				}
				var Main = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				var StrParam = UpdateCode + '^' + UpdateDesc + '^' + AddNodeRowId;
				var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'AddMatCatOfficial', StrParam, Main);
				if (ret === '') {
					$UI.msg('success', '保存成功!');
					$HUI.dialog('#UpdateWin').close();
					GetOfficialTree();
				} else {
					$UI.msg('error', ret);
				}
			}
		});
		
		$HUI.dialog('#UpdateWin', {
			title: '增加分类',
			onOpen: function() {
				$('#UpdateCode').val('');
				$('#UpdateDesc').val('');
			}
		}).open();
	}
	
	function MatCatOfficialUpdate(Node) {
		var UpdateNodeType = Node.id.split('-')[0];
		var UpdateNodeRowId = Node.id.split('-')[1];
		
		$UI.linkbutton('#AddSaveBT', {
			onClick: function() {
				var UpdateCode = $('#UpdateCode').val();
				var UpdateDesc = $('#UpdateDesc').val();
				if (UpdateCode == '') {
					$UI.msg('alert', '代码不可为空!');
					return false;
				}
				if (UpdateDesc == '') {
					$UI.msg('alert', '名称不可为空!');
					return false;
				}
				var Main = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
				var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'UpdateMatCatOfficial', StrParam, Main);
				if (ret === '') {
					$UI.msg('success', '保存成功!');
					$HUI.dialog('#UpdateWin').close();
					GetOfficialTree();
				} else {
					$UI.msg('error', ret);
				}
			}
		});
		
		$HUI.dialog('#UpdateWin', {
			title: '修改分类',
			onOpen: function() {
				if (UpdateNodeType == 'MCO') {
					var Info = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'GetMatCatOfficial', UpdateNodeRowId);
					var InfoArr = Info.split('^');
					var Code = InfoArr[0], Desc = InfoArr[1];
					$('#UpdateCode').val(Code);
					$('#UpdateDesc').val(Desc);
				}
			}
		}).open();
	}
	
	GetOfficialTree();
	InitHosp();
};
function GetOfficialTree() {
	$.cm({
		wantreturnval: 0,
		ClassName: 'web.DHCSTMHUI.MatCatOfficial',
		MethodName: 'GetOfficalInfo',
		ParentId: '',
		Params: JSON.stringify(addSessionParams({ BDPHospital: HospId }))
	}, function(data) {
		$('#MulOfficialTree').tree({
			data: data
		});
	});
}
$(init);