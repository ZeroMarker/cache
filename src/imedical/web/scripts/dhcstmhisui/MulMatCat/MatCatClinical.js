// �༶�ٴ�����ά��
var init = function() {
	$UI.linkbutton('#ResetBT', {
		onClick: function() {
			$UI.confirm('�����ڳ�ʼ��, ���ͬʱɾ����ά��������, �Ƿ����?', '', '', Reset);
		}
	});
	
	function Reset() {
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.MatCatOfficial',
			MethodName: 'ResetClinicData'
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				GetClinicalTree();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$HUI.tree('#MulClinicalTree', {
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
			return confirm('�Ƿ� ' + source.text + ' �ƶ��� ' + NewParent.text + ' ��?');
		},
		onDrop: function(target, source) {
			var NodeType = source.id.split('-')[0];
			var NodeRowId = source.id.split('-')[1];
			
			var NewParent = $(this).tree('getNode', target);
			var NewParentType = NewParent.id.split('-')[0];
			var NewParentRowId = NewParent.id.split('-')[1];
			if (typeof (NewParentRowId) === 'undefined') {
				// ���ϼ���, �ÿ�
				NewParentRowId = '';
			}
			var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'UpdateParMcc', NewParentRowId, NodeRowId);
			if (ret != '') {
				$UI.msg('error', '�����޸�ʧ��:' + ret);
				$(this).tree('reload', target);
			} else {
				$UI.msg('success', '�����޸ĳɹ�!');
			}
		},
		onContextMenu: function(e, node) {
			e.preventDefault();
			$(this).tree('select', node.target);
			$('#ClinicalRightMenu').menu({
				onClick: function(item) {
					var NodeType = node.id.split('-')[0];
					switch (item.name) {
						case 'AddNode' :
							MatCatOfficialAdd(node);
							break;
						case 'UpdateNode' :
							if (NodeType == 'AllMCC') {
								$UI.msg('alert', '�˽ڵ㲻���޸�!');
								return false;
							} else if (NodeType == 'MCC') {
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
					$UI.msg('alert', '���벻��Ϊ��!');
					return false;
				}
				if (UpdateDesc == '') {
					$UI.msg('alert', '���Ʋ���Ϊ��!');
					return false;
				}
				var Main = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				var StrParam = UpdateCode + '^' + UpdateDesc + '^' + AddNodeRowId;
				var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'AddMatCatClinical', StrParam, Main);
				if (ret === '') {
					$UI.msg('success', '����ɹ�!');
					$HUI.dialog('#UpdateWin').close();
					GetClinicalTree();
				} else {
					$UI.msg('error', ret);
				}
			}
		});
		
		$HUI.dialog('#UpdateWin', {
			title: '���ӷ���',
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
					$UI.msg('alert', '���벻��Ϊ��!');
					return false;
				}
				if (UpdateDesc == '') {
					$UI.msg('alert', '���Ʋ���Ϊ��!');
					return false;
				}
				var Main = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
				var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
				var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'UpdateMatCatClinical', StrParam, Main);
				if (ret === '') {
					$UI.msg('success', '����ɹ�!');
					$HUI.dialog('#UpdateWin').close();
					GetClinicalTree();
				} else {
					$UI.msg('error', ret);
				}
			}
		});
		
		$HUI.dialog('#UpdateWin', {
			title: '�޸ķ���',
			onOpen: function() {
				if (UpdateNodeType == 'MCC') {
					var Info = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'GetMatCatClinical', UpdateNodeRowId);
					var InfoArr = Info.split('^');
					var Code = InfoArr[0], Desc = InfoArr[1];
					$('#UpdateCode').val(Code);
					$('#UpdateDesc').val(Desc);
				}
			}
		}).open();
	}
	
	GetClinicalTree();
};
$(init);
function GetClinicalTree() {
	var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
	$.cm({
		wantreturnval: 0,
		ClassName: 'web.DHCSTMHUI.MatCatOfficial',
		MethodName: 'GetClinicalInfo',
		ParentId: '',
		Params: Params
	}, function(data) {
		$('#MulClinicalTree').tree({
			data: data
		});
	});
}