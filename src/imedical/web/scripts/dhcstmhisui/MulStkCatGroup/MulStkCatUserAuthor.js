var init = function(){
	var HospId=gHospId;
	var TableName="CT_Loc";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				Clear();
			};
		}
	}
	function Clear(){
		$('#UserLoc').combobox('clear');
		$UI.clear(UserGrid);
		GetLocScgTree();
	}
	var UserLoc = $HUI.combobox('#UserLoc',{
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record){
			var LocId = record['RowId'];
			$UI.clear(UserGrid);
			UserGrid.load({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetDeptUser',
				Params: JSON.stringify(addSessionParams({LocDr: LocId}))
			});
			GetLocScgTree();
		},
		onShowPanel: function () {
				var Params=JSON.stringify(addSessionParams({Type:'Login',BDPHospital:HospId}));
				UserLoc.clear();
				var url=$URL+'?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+Params;
				UserLoc.reload(url);
			}
	});
	
	var UserGrid = $UI.datagrid('#UserGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetDeptUser'
		},
		fitColumns: true,
		singleSelect: true,
		columns : [[
			{checkbox: true},
			{title: '��ԱID', field: 'RowId',width : 50, hidden: true},
			{title: '����', field: 'Description', width: 200}
		]],
		pagination: false,
		onSelect: function(index, row){
			var UserId = row['RowId'];
			GetUserAuthorDetail(UserId);
		}
	});
	
	function GetUserAuthorDetail(UserId){
		var UserRowData = UserGrid.getSelected();
		if(isEmpty(UserId) && isEmpty(UserRowData)){
			return;
		}
		
		//��ȥ����ѡ
		var Roots = $('#ScgTree').tree('getRoots');
		for(var i = 0, Len = Roots.length; i < Len; i++){
			$('#ScgTree').tree('uncheck', Roots[i].target);
			var Children = $('#ScgTree').tree('getChildren', Roots[i].target);
			for(var j = 0, ChLen = Children.length; j < ChLen; j++){
				if(Children[j].id.indexOf('SCG') != -1){
					$('#ScgTree').tree('update', {
						target: Children[j].target,
						iconCls: 'icon-add'
					});
				}
			}
		}
		
		var LocId = $('#UserLoc').combobox('getValue');
		if(isEmpty(LocId)){
			return;
		}
		var StrParam = LocId + '^' + UserId;
		var AuthorStr = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetAuthorLeafScg', StrParam);
		var AuthorArr = AuthorStr.split('^');
		for(var i = 0; i < AuthorArr.length; i++){
			Author = AuthorArr[i];
			var Node = $('#ScgTree').tree('find', 'SCG-' + Author);
			if(Node){
				$('#ScgTree').tree('check', Node.target);
			}
		}
		
		//ȱʡ�����ر���
		var StrParam = LocId + '^' + UserId + '^';
		var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetDefaScg', StrParam);
		var ScgId = DefaInfo.split('^')[0], ScgDesc = DefaInfo.split('^')[1];
		if(ScgId && ScgDesc){
			var Node = $('#ScgTree').tree('find', 'SCG-' + ScgId);
			if(Node){
				$('#ScgTree').tree('update', {
					target: Node.target,
					iconCls: 'icon-stamp'
				});
			}
		}
	}
	
	
	$UI.linkbutton('#AuthorBT', {
		onClick: function(){
			SaveAuthor();
		}
	});
	function SaveAuthor(){
		var SelRec = UserGrid.getSelected();
		if(isEmpty(SelRec)){
			$UI.msg('alert', '��ѡ����Ҫ��Ȩ�Ķ���!');
			return false;
		}
		var UserId = SelRec['RowId'];
		var LocId = $('#UserLoc').combobox('getValue');
		if(isEmpty(LocId)){
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return false;
		}
		var AuthorPar = LocId + '^' + UserId;
		
		var Str = '';
		var CheckedNodes = $('#ScgTree').tree('getChecked');
		for(var i =0, Len = CheckedNodes.length; i < Len; i++){
			var Node = CheckedNodes[i];
			var NodeType = Node.id.split('-')[0];
			var NodeRowId = Node.id.split('-')[1];
			if(NodeType == 'INCSC'){
				continue;
			}
			var IsLeaf = $('#ScgTree').tree('isLeaf', Node.target);
			if(NodeType == 'SCG' && IsLeaf){
				$UI.msg('alert', Node.text + ' δ����������,��������Ȩ');
				return false;
			}
			if(Str == ''){
				Str = NodeRowId;
			}else{
				Str = Str + ',' + NodeRowId;
			}
		}
		var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'SaveUserAuthorData', Str, AuthorPar);
		if(ret != ''){
			$UI.msg('error', '��Ȩʧ��:' + ret);
		}else{
			$UI.msg('success', '��Ȩ�ɹ�!');
			GetUserAuthorDetail(UserId);
		}
	}
	
	$UI.linkbutton('#SetDefaBT', {
		onClick: function(){
			SetDefaBT();
		}
	});
	function SetDefaBT(){
		var LocId = $('#UserLoc').combobox('getValue');
		if(isEmpty(LocId)){
			$UI.msg('alert', '��ѡ�����!');
			return false;
		}
		var RowData = UserGrid.getSelected();
		if(isEmpty(RowData)){
			$UI.msg('alert', '��ѡ����Ա!');
			return false;
		}
		var UserId = RowData['RowId'];
		var Node = $('#ScgTree').tree('getSelected');
		if(isEmpty(Node) || Node.checked != true || Node.id.split('-')[0] != 'SCG'
		|| (!isEmpty(Node.children) && Node.children[0].id.indexOf('INCSC') == -1)){
			$UI.msg('alert', '��ѡ����ҪĬ�ϵ�����(��ײ�����)!');
			return false;
		}
		var ScgId = Node.id.split('-')[1];
		var ret = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'SetLocUserDefaScg', LocId, UserId, ScgId);
		if(ret != ''){
			$UI.msg('error', '����ʧ��:' + ret);
		}else{
			$UI.msg('success', '���óɹ�!');
			GetUserAuthorDetail(UserId);
		}
	}
	
	$('#ScgTree').tree({
		lines: true,
		checkbox: true,
		onBeforeCheck: function(node, checked){
			var IsLeaf = $(this).tree('isLeaf', node.target);
			if(node.id.indexOf('SCG') >= 0 && IsLeaf){
				$UI.msg('alert', 'δ����������,��������Ȩ!');
				return false;
			}
		},
		onCheck: function(node, checked){
			if(node.id.indexOf('INCSC') >= 0){
				var Parent = $(this).tree('getParent', node.target);
				if(checked){
					$(this).tree('check', Parent.target);
				}else{
					$(this).tree('uncheck', Parent.target);
				}
			}
		}
	});
	
	function GetLocScgTree(){
		$.cm({
			wantreturnval: 0,
			ClassName: 'web.DHCSTMHUI.MulStkCatGroup',
			MethodName: 'GetScg',
			ParScg: '',
			Params: JSON.stringify(addSessionParams({BDPHospital:HospId,LocId: $('#UserLoc').combobox('getValue')}))
		},function(data){
			$('#ScgTree').tree({
				data: data
			});
		});
	}
	GetLocScgTree();
	InitHosp();
}
$(init);