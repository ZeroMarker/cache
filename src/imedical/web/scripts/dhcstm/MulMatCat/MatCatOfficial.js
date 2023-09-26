// 名称:多级官方分类

var MatCatOfficialPanel = new Ext.ux.tree.ColumnTree({
	columns:[{
		header : '官方分类名称',
		width : 700,
		dataIndex : 'text'
	}],
	title : '官方分类信息',
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
		text : '68分类',
		draggable : false,
		id: 'AllMCO',
		expanded : true
	},
	contextMenu: new Ext.menu.Menu({
		items: [{
			id: 'AddNode',
			text : '增加节点'
		},{
			id: 'UpdateNode',
			text : '修改节点名称'
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
							Msg.info('warning', '此节点不需修改!');
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
			return confirm('是否将 ' + node.text + ' 移动到 ' + newParent.text + ' 下?');
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
				Msg.info('error', '关联修改失败!');
				newParent.reload();
			}else{
				Msg.info('success', '关联修改成功!');
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
		fieldLabel : '代码',
		allowBlank : false
	});
	
	var AddDesc = new Ext.form.TextField({
		id : 'AddDesc',
		fieldLabel : '名称',
		allowBlank : false
	});
	
	var AddConfirmBT = new Ext.ux.Button({
		id : 'AddConfirmBT',
		text : '保存',
		iconCls : 'page_save',
		handler : function(){
			var AddCode = Ext.getCmp('AddCode').getValue();
			var AddDesc = Ext.getCmp('AddDesc').getValue();
			if(AddCode == ''){
				Msg.info('warning', '代码不可为空!');
				return false;
			}
			if(AddDesc == ''){
				Msg.info('warning', '名称不可为空!');
				return false;
			}
			var StrParam = AddCode + '^' + AddDesc + '^' + AddNodeRowId;
			var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'AddMatCatOfficial', StrParam);
			if(ret === ''){
				Msg.info('success', '保存成功!');
				MatCatOfficialAddWin.close();
				Node.reload();
			}else{
				Msg.info('error', ret);
			}
			
		}
	});
	
	var AddCancelBT = new Ext.ux.Button({
		id : 'AddCancelBT',
		text : '关闭',
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
			title : '节点信息',
			xtype : 'fieldset',
			items : [AddCode, AddDesc]
		}],
		tbar : [AddConfirmBT, AddCancelBT]
	});
	
	var MatCatOfficialAddWin = new Ext.Window({
		title : Node.text + '增加节点',
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
		fieldLabel : '代码',
		allowBlank : false
	});
	
	var UpdateDesc = new Ext.form.TextField({
		id : 'UpdateDesc',
		anchor : '90%',
		fieldLabel : '名称',
		allowBlank : false
	});
	
	var UpdateConfirmBT = new Ext.ux.Button({
		id : 'UpdateConfirmBT',
		text : '保存',
		iconCls : 'page_save',
		handler : function(){
			var UpdateCode = Ext.getCmp('UpdateCode').getValue();
			var UpdateDesc = Ext.getCmp('UpdateDesc').getValue();
			if(UpdateCode == ''){
				Msg.info('warning', '代码不可为空!');
				return false;
			}
			if(UpdateDesc == ''){
				Msg.info('warning', '名称不可为空!');
				return false;
			}
			var StrParam = UpdateNodeRowId + '^' + UpdateCode + '^' + UpdateDesc;
			var ret = tkMakeServerCall('web.DHCSTM.MatCatOfficial', 'UpdateMatCatOfficial', StrParam);
			if(ret === ''){
				Msg.info('success', '保存成功!');
				MatCatOfficialUpdateWin.close();
				Node.parentNode.reload(function(){this.expand(true)});
			}else{
				Msg.info('error', ret);
			}
		}
	});
	
	var UpdateCancelBT = new Ext.ux.Button({
		id : 'UpdateCancelBT',
		text : '关闭',
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
			title : '官方分类信息',
			xtype : 'fieldset',
			items : [UpdateCode, UpdateDesc]
		}],
		tbar : [UpdateConfirmBT, UpdateCancelBT]
	});
	
	var MatCatOfficialUpdateWin = new Ext.Window({
		title : Node.text + ' 修改官方分类信息',
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
		title : '多级官方分类维护',
		items : [MatCatOfficialPanel],
		renderTo : 'mainPanel'
	});
	MatCatOfficialPanel.getRootNode().expand(true);
});