//�༶�������ά��
var init = function(){
	$HUI.tree('#MulSpecialTree', {
		dnd: true,
		lines: true,
		checkbox: false,
		onBeforeDrop: function(target, source, point){
			var NewParent = $(this).tree('getNode', target);
			var OldParent = $(this).tree('getParent', source.target);
			if(OldParent == NewParent){
				return false;
			}
			var NodeType = source.id.split('-')[0];
			var NewParentType = NewParent.id.split('-')[0];
			var IsLeaf = $(this).tree('isLeaf', target);
			return confirm('�Ƿ� ' + source.text + ' �ƶ��� ' + NewParent.text + ' ��?');
		},
		onDrop: function(target, source){
			var NodeType = source.id.split('-')[0];
			var NodeRowId = source.id.split('-')[1];
			
			var NewParent = $(this).tree('getNode', target);
			var NewParentType = NewParent.id.split('-')[0];
			var NewParentRowId = NewParent.id.split('-')[1];
			if(typeof(NewParentRowId) == 'undefined'){
				//���ϼ���, �ÿ�
				NewParentRowId = '';
			}
			var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'UpdateParMcs', NewParentRowId, NodeRowId);
			if(ret != ''){
				$UI.msg('error', '�����޸�ʧ��:' + ret);
				$(this).tree('reload', target);
			}else{
				$UI.msg('success', '�����޸ĳɹ�!');
			}
		},
		onContextMenu: function(e, node){
			e.preventDefault();
			$(this).tree('select', node.target);
			$('#SpecialRightMenu').menu({
				onClick: function(item){
					var NodeType = node.id.split('-')[0];
					switch (item.name) {
						case 'AddNode' :
							MatCatSpecialAdd(node);
							break;
						case 'UpdateNode' :
							if(NodeType == 'AllMCS'){
								$UI.msg('alert', '�˽ڵ㲻���޸�!');
								return false;
							}else if(NodeType == 'MCS'){
								MatCatSpecialUpdate(node);
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
	
	function MatCatSpecialAdd(Node){
		var AddNodeType = Node.id.split('-')[0];
		var AddNodeRowId = Node.id.split('-')[1];
		if(typeof(AddNodeRowId) == 'undefined'){
			AddNodeRowId = '';
		}
		
		$UI.linkbutton('#AddSaveBT', {
			onClick: function(){
				var UpdateCode = $('#UpdateCode').val();
				var UpdateDesc = $('#UpdateDesc').val();
				if(UpdateCode == ''){
					$UI.msg('alert', '���벻��Ϊ��!');
					return false;
				}
				if(UpdateDesc == ''){
					$UI.msg('alert', '���Ʋ���Ϊ��!');
					return false;
				}
				var Main=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				var StrParam = UpdateCode + '^' + UpdateDesc + '^' + AddNodeRowId;
				var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'AddMatCatSpecial', StrParam,Main);
				if(ret === ''){
					$UI.msg('success', '����ɹ�!');
					$HUI.dialog('#UpdateWin').close();
					GetSpecialTree();
				}else{
					$UI.msg('error', ret);
				}
			}
		});
		
		$HUI.dialog('#UpdateWin', {
			title: '���ӷ���',
			onOpen: function(){
					$('#UpdateCode').val("");
					$('#UpdateDesc').val("");
			}
		}).open();
	}
	
	function MatCatSpecialUpdate(Node){
		var UpdateNodeType = Node.id.split('-')[0];
		var UpdateNodeRowId = Node.id.split('-')[1];
		
		$UI.linkbutton('#AddSaveBT', {
			onClick: function(){
				var UpdateCode = $('#UpdateCode').val();
				var UpdateDesc = $('#UpdateDesc').val();
				if(UpdateCode == ''){
					$UI.msg('alert', '���벻��Ϊ��!');
					return false;
				}
				if(UpdateDesc == ''){
					$UI.msg('alert', '���Ʋ���Ϊ��!');
					return false;
				}
				var Main=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
				var ret = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'UpdateMatCatSpecial', StrParam,Main);
				if(ret === ''){
					$UI.msg('success', '����ɹ�!');
					$HUI.dialog('#UpdateWin').close();
					GetSpecialTree();
				}else{
					$UI.msg('error', ret);
				}
			}
		});
		
		$HUI.dialog('#UpdateWin', {
			title: '�޸ķ���',
			onOpen: function(){
				if(UpdateNodeType == 'MCS'){
					var Info = tkMakeServerCall('web.DHCSTMHUI.MatCatOfficial', 'GetMatCatSpecial', UpdateNodeRowId);
					var InfoArr = Info.split('^');
					var Code = InfoArr[0], Desc = InfoArr[1];
					$('#UpdateCode').val(Code);
					$('#UpdateDesc').val(Desc);
				}
			}
		}).open();
	}
	
	GetSpecialTree();
}
$(init);

	function GetSpecialTree(){
		var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			wantreturnval: 0,
			ClassName: 'web.DHCSTMHUI.MatCatOfficial',
			MethodName: 'GetSpecialInfo',
			ParentId: '',
			Params: Params
		},function(data){
			$('#MulSpecialTree').tree({
				data: data
			});
		});
	}