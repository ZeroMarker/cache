// ����:�༶�ٷ�����

var MatCatOfficialPanel = new Ext.ux.tree.ColumnTree({
	columns:[{
		header : '�ٷ���������',
		width : 700,
		dataIndex : 'text'
	}],
	title : '�ٷ�������Ϣ',
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
		text : '68����',
		draggable : false,
		id: 'AllMCO',
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
						MatCatOfficialAdd(n);
						break;
					case 'UpdateNode' :
						var NodeType = n.id.split('-')[0];
						if(NodeType == 'AllMCO'){
							Msg.info('warning', '�˽ڵ㲻���޸�!');
							return false;
						}else if(NodeType == 'MCO'){
							MatCatOfficialUpdate(n);
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
			this.loader.dataUrl = 'dhcstm.mulmatcataction.csp?actiontype=GetChildNode'
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
			if(nodeType == 'MCO'){
				var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'UpdateParMco', newParentRowId, nodeRowId);
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

function MatCatOfficialAdd(Node){
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
			var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'AddMatCatOfficial', StrParam);
			if(ret === ''){
				Msg.info('success', '����ɹ�!');
				MatCatOfficialAddWin.close();
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
			MatCatOfficialAddWin.close();
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
	
	var MatCatOfficialAddWin = new Ext.Window({
		title : Node.text + '���ӽڵ�',
		width : 400,
		height : 180,
		plain : true,
		modal : true,
		layout : 'fit',
		labelAlign : 'right',
		items : [AddFormPanel]
	});
	
	MatCatOfficialAddWin.show();
}

function MatCatOfficialUpdate(Node){
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
			var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'UpdateMatCatOfficial', StrParam);
			if(ret === ''){
				Msg.info('success', '����ɹ�!');
				MatCatOfficialUpdateWin.close();
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
			MatCatOfficialUpdateWin.close();
		}
	});
	
	var UpdateFormPanel = new Ext.form.FormPanel({
		region : 'center',
		frame : true,
		autoHeight : true,
		labelAlign : 'right',
		items : [{
			title : '�ٷ�������Ϣ',
			xtype : 'fieldset',
			items : [UpdateCode, UpdateDesc]
		}],
		tbar : [UpdateConfirmBT, UpdateCancelBT]
	});
	
	var MatCatOfficialUpdateWin = new Ext.Window({
		title : Node.text + ' �޸Ĺٷ�������Ϣ',
		width : 300,
		autoHeight : true,
		plain : true,
		modal : true,
		layout : 'form',
		labelAlign : 'right',
		items : [UpdateFormPanel],
		listeners : {
			show : function(){
				if(UpdateNodeType == 'MCO'){
					var Info = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'GetMatCatOfficial', UpdateNodeRowId);
				}
				var InfoArr = Info.split('^');
				var Code = InfoArr[0], Desc = InfoArr[1];
				Ext.getCmp('UpdateCode').setValue(Code);
				Ext.getCmp('UpdateDesc').setValue(Desc);
			}
		}
	});
	
	MatCatOfficialUpdateWin.show();
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		title : '�༶�ٷ�����ά��',
		items : [MatCatOfficialPanel],
		renderTo : 'mainPanel'
	});
	MatCatOfficialPanel.getRootNode().expand(true);
});