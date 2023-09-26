// ����:�༶�������

var MatCatSpecialPanel = new Ext.ux.tree.ColumnTree({
	columns:[{
		header : '�����������',
		width : 700,
		dataIndex : 'text'
	}],
	title : '���������Ϣ',
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
		id: 'AllMCS',
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
						MatCatSpecialAdd(n);
						break;
					case 'UpdateNode' :
						var NodeType = n.id.split('-')[0];
						if(NodeType == 'AllMCS'){
							Msg.info('warning', '�˽ڵ㲻���޸�!');
							return false;
						}else if(NodeType == 'MCS'){
							MatCatSpecialUpdate(n);
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
			var uiProvider = 'col';
			this.loader.dataUrl = 'dhcstm.mulmatcataction.csp?actiontype=GetSpecialChildNode'
				+'&NodeId=' + node.id;
		},
		beforemovenode : function(tree, node, oldParent, newParent, index){
			if(oldParent == newParent){
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
				newParentRowId = '';
			}
			if(nodeType == 'MCS'){
				var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'UpdateParMcs', newParentRowId, nodeRowId);
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

function MatCatSpecialAdd(Node){
	var AddNodeType = Node.id.split('-')[0];
	var AddNodeRowId = Node.id.split('-')[1];
	if(typeof(AddNodeRowId) == 'undefined'){
		AddNodeRowId = '';
	}
	
	var AddCode = new Ext.form.TextField({
		id : 'AddCode',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var AddDesc = new Ext.form.TextField({
		id : 'AddDesc',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var AddConfirmBT = new Ext.ux.Button({
		id : 'AddConfirmBT',
		text : '����',
		iconCls : 'page_save',
		handler : function(){
			var AddCode = Ext.getCmp('AddCode').getValue();
			var AddDesc = Ext.getCmp('AddDesc').getValue();
			if(AddCode == ''){
				Msg.info('warning', '���벻��Ϊ��!');
				return false;
			}
			if(AddDesc == ''){
				Msg.info('warning', '���Ʋ���Ϊ��!');
				return false;
			}
			var StrParam = AddCode + '^' + AddDesc + '^' + AddNodeRowId;
			var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'AddMatCatSpecial', StrParam);
			if(ret === ''){
				Msg.info('success', '����ɹ�!');
				MatCatSpecialAddWin.close();
				Node.reload();
			}else{
				Msg.info('error', ret);
			}
			
		}
	});
	
	var AddCancelBT = new Ext.ux.Button({
		id : 'AddCancelBT',
		text : '�ر�',
		iconCls : 'page_close',
		handler : function(){
			MatCatSpecialAddWin.close();
		}
	});
	
	var AddFormPanel = new Ext.form.FormPanel({
		region : 'north',
		frame : true,
		height : 170,
		labelAlign : 'right',
		items : [{
			title : '�ڵ���Ϣ',
			xtype : 'fieldset',
			items : [AddCode, AddDesc]
		}],
		tbar : [AddConfirmBT, AddCancelBT]
	});
	
	var MatCatSpecialAddWin = new Ext.Window({
		title : Node.text + '���ӽڵ�',
		width : 400,
		height : 180,
		plain : true,
		modal : true,
		layout : 'fit',
		labelAlign : 'right',
		items : [AddFormPanel]
	});
	
	MatCatSpecialAddWin.show();
}

function MatCatSpecialUpdate(Node){
	var UpdateNodeType = Node.id.split('-')[0];
	var UpdateNodeRowId = Node.id.split('-')[1];
	
	var UpdateCode = new Ext.form.TextField({
		id : 'UpdateCode',
		anchor : '90%',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var UpdateDesc = new Ext.form.TextField({
		id : 'UpdateDesc',
		anchor : '90%',
		fieldLabel : '����',
		allowBlank : false
	});
	
	var UpdateConfirmBT = new Ext.ux.Button({
		id : 'UpdateConfirmBT',
		text : '����',
		iconCls : 'page_save',
		handler : function(){
			var UpdateCode = Ext.getCmp('UpdateCode').getValue();
			var UpdateDesc = Ext.getCmp('UpdateDesc').getValue();
			if(UpdateCode == ''){
				Msg.info('warning', '���벻��Ϊ��!');
				return false;
			}
			if(UpdateDesc == ''){
				Msg.info('warning', '���Ʋ���Ϊ��!');
				return false;
			}
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
			var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'UpdateMatCatSpecial', StrParam);
			if(ret === ''){
				Msg.info('success', '����ɹ�!');
				MatCatSpecialUpdateWin.close();
				Node.parentNode.reload(function(){this.expand(true)});
			}else{
				Msg.info('error', ret);
			}
		}
	});
	
	var UpdateCancelBT = new Ext.ux.Button({
		id : 'UpdateCancelBT',
		text : '�ر�',
		iconCls : 'page_close',
		handler : function(){
			MatCatSpecialUpdateWin.close();
		}
	});
	
	var UpdateFormPanel = new Ext.form.FormPanel({
		region : 'center',
		frame : true,
		autoHeight : true,
		labelAlign : 'right',
		items : [{
			title : '���������Ϣ',
			xtype : 'fieldset',
			items : [UpdateCode, UpdateDesc]
		}],
		tbar : [UpdateConfirmBT, UpdateCancelBT]
	});
	
	var MatCatSpecialUpdateWin = new Ext.Window({
		title : Node.text + ' �޸����������Ϣ',
		width : 300,
		autoHeight : true,
		plain : true,
		modal : true,
		layout : 'form',
		labelAlign : 'right',
		items : [UpdateFormPanel],
		listeners : {
			show : function(){
				if(UpdateNodeType == 'MCS'){
					var Info = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'GetMatCatSpecial', UpdateNodeRowId);
				}
				var InfoArr = Info.split('^');
				var Code = InfoArr[0], Desc = InfoArr[1];
				Ext.getCmp('UpdateCode').setValue(Code);
				Ext.getCmp('UpdateDesc').setValue(Desc);
			}
		}
	});
	
	MatCatSpecialUpdateWin.show();
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		title : '�༶�������ά��',
		items : [MatCatSpecialPanel],
		renderTo : 'mainPanel'
	});
	MatCatSpecialPanel.getRootNode().expand(true);
});