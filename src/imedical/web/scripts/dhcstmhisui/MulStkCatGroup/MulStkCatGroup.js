var HospId = gHospId;
var TableName = 'DHC_StkCatGroup';
function InitHosp() {
	var hospComp = InitHospCombo(TableName, gSessionStr);
	if (typeof hospComp === 'object') {
		HospId = $HUI.combogrid('#_HospList').getValue();
		$('#_HospList').combogrid('options').onSelect = function(index, record) {
			HospId = record.HOSPRowId;
			SetServiceInfo(HospId);
			GetScgTree();
		};
	}
	SetServiceInfo();
	GetScgTree();
}

// 根据接口启用控制相关按钮展示
function SetServiceInfo(HospId) {
	if (!isEmpty(HospId)) {
		SerUseObj = GetSerUseObj(HospId);
	}
	if (SerUseObj.ECS == 'Y') {
		$('.SCIShow').show();
	} else {
		$('.SCIShow').hide();
	}
}

$HUI.radio("[name='ScgType']", {
	onChecked: function(e, value) {
		GetScgTree();
	}
});

function GetScgTree() {
	var ScgType = $("input[name='ScgType']:checked").val();
	$.cm({
		wantreturnval: 0,
		ClassName: 'web.DHCSTMHUI.MulStkCatGroup',
		MethodName: 'GetScg',
		ParScg: '',
		Params: JSON.stringify(addSessionParams({ Type: ScgType, BDPHospital: HospId }))
	}, function(data) {
		$('#ScgTree').tree({
			data: data
		});
	});
}

var init = function() {
	$('#ScgTree').tree({
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
			if (NodeType == 'INCSC') {
				if (NewParentType != 'SCG') {
					// 库存分类的父节点只能是类组
					$UI.msg('alert', '库存分类只能关联底层类组!');
					return false;
				} else if (!IsLeaf) {
					var Children = $(this).tree('getChildren', target);
					if (!isEmpty(Children) && Children[0].id.indexOf('SCG') >= 0) {
						$UI.msg('alert', NewParent.text + ' 不是底层类组,不可关联库存分类!');
						return false;
					}
				}
			}
			if (NodeType == 'SCG' && !IsLeaf) {
				var Children = $(this).tree('getChildren', target);
				if (!isEmpty(Children) && Children[0].id.indexOf('INCSC') >= 0) {
					$UI.msg('alert', NewParent.text + ' 是底层类组,不可关联子类组!');
					return false;
				}
			}
			return confirm('是否将 ' + source.text + ' 移动到 ' + NewParent.text + ' 下?');
		},
		onDrop: function(target, source) {
			var NodeType = source.id.split('-')[0];
			var NodeRowId = source.id.split('-')[1];
			
			var NewParent = $(this).tree('getNode', target);
			var NewParentType = NewParent.id.split('-')[0];
			var NewParentRowId = NewParent.id.split('-')[1];
			if (typeof (NewParentRowId) === 'undefined') {
				// 无上级类组的, ParScg置空
				NewParentRowId = '';
			}
			if (NodeType == 'INCSC') {
				// 修改库存分类和类组的关联
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'ScgRelaIncsc', NewParentRowId, NodeRowId);
			} else if (NodeType == 'SCG') {
				// 修改类组的上级类组
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'UpdateParScg', NewParentRowId, NodeRowId);
			}
			if (ret != '') {
				$UI.msg('error', '关联修改失败:' + ret);
				$(this).tree('reload', target);
			} else {
				$UI.msg('success', '关联修改成功!');
			}
		},
		onContextMenu: function(e, node) {
			e.preventDefault();
			// 查找节点
			$(this).tree('select', node.target);
			// 显示快捷菜单
			$('#ScgRightMenu').menu({
				onClick: function(item) {
					var NodeType = node.id.split('-')[0];
					switch (item.name) {
						case 'AddNode' :
							if (NodeType == 'INCSC') {
								$UI.msg('alert', '库存分类上不可增加节点!');
								return false;
							}
							MulScgAdd(node);
							break;
						case 'UpdateNode' :
							if (NodeType == 'AllSCG') {
								$UI.msg('alert', '此节点不需修改!');
								return false;
							} else if (NodeType == 'SCG') {
								MulScgUpdate(node);
							} else if (NodeType == 'INCSC') {
								StkCatUpdate(node);
							}
							break;
						case 'DelRelation' :
							if (NodeType != 'INCSC') {
								$UI.msg('alert', '仅可操控 库存分类!');
								return false;
							}
							var NodeRowId = node.id.split('-')[1];
							$UI.confirm('确定要解除关联吗?', 'question', '', function() {
								$.cm({
									ClassName: 'web.DHCSTMHUI.MulStkCatGroup',
									MethodName: 'DeleteRelation',
									IncscId: NodeRowId
								}, function(jsonData) {
									if (jsonData.success === 0) {
										$UI.msg('success', jsonData.msg);
										GetScgTree();
									} else {
										$UI.msg('error', jsonData.msg);
									}
								});
							});
							break;
						case 'SendBT' :
							if (NodeType != 'INCSC') {
								$UI.msg('alert', '仅可操控 库存分类!');
								return false;
							}
							var NodeRowId = node.id.split('-')[1];
							$.cm({
								ClassName: 'web.DHCSTMHUI.ServiceForECS',
								MethodName: 'updateHosCat',
								IncscIdStr: NodeRowId
							}, function(jsonData) {
								$UI.msg('success', '发送成功');
							});
							break;
					}
				}
			}).menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}
	});
	
	GetScgTree();
	InitHosp();
};
$(init);