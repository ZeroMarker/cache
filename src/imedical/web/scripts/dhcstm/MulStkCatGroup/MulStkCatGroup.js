// ����:�༶����

//var MulCatGroupPanel = new Ext.tree.TreePanel({
var MulCatGroupPanel = new Ext.ux.tree.ColumnTree({
	columns:[{
		header : '����(������)����',
		width : 700,
		dataIndex : 'text'
	}, {
		header : '�ۼ۱���',
		width : 100,
		dataIndex : 'SpReq'
	}, {
		header : '���鼯��',
		width : 100,
		dataIndex : 'SCGSet'
	}],
	title : '������Ϣ',
	region : 'center',
	autoScroll : true,
	enableDD : true,
	split : true,
	containerScroll : true,
	border : false,
	loader : new Ext.tree.TreeLoader({
		uiProviders:{
			'col': Ext.ux.tree.ColumnNodeUI
		}
	}),
	lines : true,
	root : {
		nodeType : 'async',
		text : '����',
		draggable : false,
		id: 'AllSCG',
		expanded : true
	},
	contextMenu: new Ext.menu.Menu({
		items: [{
			id: 'AddNode',
			text : '���ӽڵ�'
		},{
			id: 'UpdateNode',
			text : '�޸Ľڵ�����'
		}],
		listeners: {
			itemclick : function(item) {
				var n = item.parentMenu.contextNode;
				switch (item.id) {
					case 'AddNode' :
						var NodeType = n.id.split('-')[0];
						if(NodeType == 'INCSC'){
							Msg.info('warning', '�������ϲ������ӽڵ�!');
							return false;
						}
						MulStkCatGoupAdd(n);
						break;
					case 'UpdateNode' :
						var NodeType = n.id.split('-')[0];
						if(NodeType == 'AllSCG'){
							Msg.info('warning', '�˽ڵ㲻���޸�!');
							return false;
						}else if(NodeType == 'SCG'){
							MulStkCatGoupUpdate(n);
						}else if(NodeType == 'INCSC'){
							StkCatUpdate(n);
						}
						break;
				}
			}
		}
	}),
	listeners : {
		contextmenu : function(node, e) {
			node.select();
			var c = node.getOwnerTree().contextMenu;
			c.contextNode = node;
			c.showAt(e.getXY());
		},
		beforeload : function(node){
			var uiProvider = 'col';		//ColumnTree�õ�������
			var StrParam = 'N^^' + uiProvider;
			this.loader.dataUrl = 'dhcstm.mulstkcatgroupaction.csp?actiontype=GetChildNode'
				+'&id=' + node.id+'&StrParam='+StrParam;
		},
		beforemovenode : function(tree, node, oldParent, newParent, index){
			if(oldParent == newParent){
				return false;
			}
			var nodeType = node.id.split('-')[0];
			var newParentType = newParent.id.split('-')[0];
			if(nodeType == 'INCSC' && newParentType != 'SCG'){
				//������ĸ��ڵ�ֻ��������
				return false;
			}
			if(nodeType == 'INCSC' && newParent.hasChildNodes() && newParent.childNodes && newParent.childNodes[0].id.indexOf('SCG') >= 0){
				Msg.info('warning', newParent.text + '���ǵײ�����,���ɹ���������!');
				return false;
			}
			if(nodeType == 'SCG' && newParent.hasChildNodes() && newParent.childNodes && newParent.childNodes[0].id.indexOf('INCSC') >= 0){
				Msg.info('warning', newParent.text + '�ǵײ�����,���ɹ���������!');
				return false;
			}
			return confirm('�Ƿ� ' + node.text + ' �ƶ��� ' + newParent.text + ' ��?');
		},
		movenode : function(tree, node, oldParent, newParent, index){
			var nodeType = node.id.split('-')[0];
			var nodeRowId = node.id.split('-')[1];
			
			var newParentType = newParent.id.split('-')[0];
			var newParentRowId = newParent.id.split('-')[1];
			if(typeof(newParentRowId) == 'undefined'){
				//���ϼ������, ParScg�ÿ�
				newParentRowId = '';
			}
			if(nodeType == 'INCSC'){
				//�޸Ŀ����������Ĺ���
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'ScgRelaIncsc', newParentRowId, nodeRowId);
			}else if(nodeType == 'SCG'){
				//�޸�������ϼ�����
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'UpdateParScg', newParentRowId, nodeRowId);
			}
			if(ret != ''){
				Msg.info('error', '�����޸�ʧ��!');
				newParent.reload();
			}else{
				Msg.info('success', '�����޸ĳɹ�!');
			}
		}
	}
});

var HisListTab = new Ext.form.FormPanel({
	id : 'HisListTab',
	region : 'north',
	height : 90,
	labelAlign : 'right',
	title : '�༶����ά��',
	frame : true,
	autoScroll : false,
	items:[{html:'<font color=blue size=3>�����Ҽ�ʵ���������޸Ľڵ�. �����������,���ǳ��������Ϊ"�ײ�����",�ײ����鲻����Ϊ�κ�������ϼ�����.'
				+'<br>����,�������漰�����ʹ�����ײ������,�Ķ������!!!'
				+'</font>'
	}]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		title : '�༶����ά��',
		items : [HisListTab, MulCatGroupPanel],
		renderTo : 'mainPanel'
	});
	MulCatGroupPanel.getRootNode().expand(true);
});