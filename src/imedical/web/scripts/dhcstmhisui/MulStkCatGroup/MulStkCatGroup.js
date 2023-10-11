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

// ���ݽӿ����ÿ�����ذ�ťչʾ
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
					// ������ĸ��ڵ�ֻ��������
					$UI.msg('alert', '������ֻ�ܹ����ײ�����!');
					return false;
				} else if (!IsLeaf) {
					var Children = $(this).tree('getChildren', target);
					if (!isEmpty(Children) && Children[0].id.indexOf('SCG') >= 0) {
						$UI.msg('alert', NewParent.text + ' ���ǵײ�����,���ɹ���������!');
						return false;
					}
				}
			}
			if (NodeType == 'SCG' && !IsLeaf) {
				var Children = $(this).tree('getChildren', target);
				if (!isEmpty(Children) && Children[0].id.indexOf('INCSC') >= 0) {
					$UI.msg('alert', NewParent.text + ' �ǵײ�����,���ɹ���������!');
					return false;
				}
			}
			return confirm('�Ƿ� ' + source.text + ' �ƶ��� ' + NewParent.text + ' ��?');
		},
		onDrop: function(target, source) {
			var NodeType = source.id.split('-')[0];
			var NodeRowId = source.id.split('-')[1];
			
			var NewParent = $(this).tree('getNode', target);
			var NewParentType = NewParent.id.split('-')[0];
			var NewParentRowId = NewParent.id.split('-')[1];
			if (typeof (NewParentRowId) === 'undefined') {
				// ���ϼ������, ParScg�ÿ�
				NewParentRowId = '';
			}
			if (NodeType == 'INCSC') {
				// �޸Ŀ����������Ĺ���
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'ScgRelaIncsc', NewParentRowId, NodeRowId);
			} else if (NodeType == 'SCG') {
				// �޸�������ϼ�����
				var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'UpdateParScg', NewParentRowId, NodeRowId);
			}
			if (ret != '') {
				$UI.msg('error', '�����޸�ʧ��:' + ret);
				$(this).tree('reload', target);
			} else {
				$UI.msg('success', '�����޸ĳɹ�!');
			}
		},
		onContextMenu: function(e, node) {
			e.preventDefault();
			// ���ҽڵ�
			$(this).tree('select', node.target);
			// ��ʾ��ݲ˵�
			$('#ScgRightMenu').menu({
				onClick: function(item) {
					var NodeType = node.id.split('-')[0];
					switch (item.name) {
						case 'AddNode' :
							if (NodeType == 'INCSC') {
								$UI.msg('alert', '�������ϲ������ӽڵ�!');
								return false;
							}
							MulScgAdd(node);
							break;
						case 'UpdateNode' :
							if (NodeType == 'AllSCG') {
								$UI.msg('alert', '�˽ڵ㲻���޸�!');
								return false;
							} else if (NodeType == 'SCG') {
								MulScgUpdate(node);
							} else if (NodeType == 'INCSC') {
								StkCatUpdate(node);
							}
							break;
						case 'DelRelation' :
							if (NodeType != 'INCSC') {
								$UI.msg('alert', '���ɲٿ� ������!');
								return false;
							}
							var NodeRowId = node.id.split('-')[1];
							$UI.confirm('ȷ��Ҫ���������?', 'question', '', function() {
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
								$UI.msg('alert', '���ɲٿ� ������!');
								return false;
							}
							var NodeRowId = node.id.split('-')[1];
							$.cm({
								ClassName: 'web.DHCSTMHUI.ServiceForECS',
								MethodName: 'updateHosCat',
								IncscIdStr: NodeRowId
							}, function(jsonData) {
								$UI.msg('success', '���ͳɹ�');
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