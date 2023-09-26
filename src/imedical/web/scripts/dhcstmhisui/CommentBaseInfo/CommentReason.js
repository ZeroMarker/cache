//�������ϸ�ԭ��ά��
var init = function(){
	$HUI.tree('#CommentReasonTree', {
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
			var ret = tkMakeServerCall('web.DHCSTMHUI.CommentReason', 'UpdateParMCR', NewParentRowId, NodeRowId);
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
			$('#ComReasonRightMenu').menu({
				onClick: function(item){
					var NodeType = node.id.split('-')[0];
					switch (item.name) {
						case 'AddNode' :
							MatComReasonAdd(node);
							break;
						case 'UpdateNode' :
							if(NodeType == 'AllMCR'){
								$UI.msg('alert', '�˽ڵ㲻���޸�!');
								return false;
							}else if(NodeType == 'MCR'){
								MatComReasonUpdate(node);
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
	
	function MatComReasonAdd(Node){
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
				var StrParam = UpdateCode + '^' + UpdateDesc + '^' + AddNodeRowId;
				var ret = tkMakeServerCall('web.DHCSTMHUI.CommentReason', 'AddMatComReason', StrParam);
				if(ret === ''){
					$UI.msg('success', '����ɹ�!');
					$HUI.dialog('#UpdateWin').close();
					GetComReasonTree();
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
	
	function MatComReasonUpdate(Node){
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
				var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
				var ret = tkMakeServerCall('web.DHCSTMHUI.CommentReason', 'UpdateMatComReason', StrParam);
				if(ret === ''){
					$UI.msg('success', '����ɹ�!');
					$HUI.dialog('#UpdateWin').close();
					GetComReasonTree();
				}else{
					$UI.msg('error', ret);
				}
			}
		});
		
		$HUI.dialog('#UpdateWin', {
			title: '�޸ķ���',
			onOpen: function(){
				if(UpdateNodeType == 'MCR'){
					var Info = tkMakeServerCall('web.DHCSTMHUI.CommentReason', 'GetMatComReason', UpdateNodeRowId);
					var InfoArr = Info.split('^');
					var Code = InfoArr[0], Desc = InfoArr[1];
					$('#UpdateCode').val(Code);
					$('#UpdateDesc').val(Desc);
				}
			}
		}).open();
	}
	
	function GetComReasonTree(){
		$.cm({
			wantreturnval: 0,
			ClassName: 'web.DHCSTMHUI.CommentReason',
			MethodName: 'GetComReasonInfo',
			ParentId: ''
		},function(data){
			$('#CommentReasonTree').tree({
				data: data
			});
		});
	}
	GetComReasonTree();
}
$(init);