// 名称:多级类组

//var MulCatGroupPanel = new Ext.tree.TreePanel({
var MulCatGroupPanel = new Ext.ux.tree.ColumnTree({
	columns:[{
		header : '类组(库存分类)名称',
		width : 700,
		dataIndex : 'text'
	}, {
		header : '售价必填',
		width : 100,
		dataIndex : 'SpReq'
	}, {
		header : '类组集合',
		width : 100,
		dataIndex : 'SCGSet'
	}],
	title : '类组信息',
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
		text : '分类',
		draggable : false,
		id: 'AllSCG',
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
						var NodeType = n.id.split('-')[0];
						if(NodeType == 'INCSC'){
							Msg.info('warning', '库存分类上不可增加节点!');
							return false;
						}
						MulStkCatGoupAdd(n);
						break;
					case 'UpdateNode' :
						var NodeType = n.id.split('-')[0];
						if(NodeType == 'AllSCG'){
							Msg.info('warning', '此节点不需修改!');
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
			var uiProvider = 'col';		//ColumnTree用到的属性
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
				//库存分类的父节点只能是类组
				return false;
			}
			if(nodeType == 'INCSC' && newParent.hasChildNodes() && newParent.childNodes && newParent.childNodes[0].id.indexOf('SCG') >= 0){
				Msg.info('warning', newParent.text + '不是底层类组,不可关联库存分类!');
				return false;
			}
			if(nodeType == 'SCG' && newParent.hasChildNodes() && newParent.childNodes && newParent.childNodes[0].id.indexOf('INCSC') >= 0){
				Msg.info('warning', newParent.text + '是底层类组,不可关联子类组!');
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
				//无上级类组的, ParScg置空
				newParentRowId = '';
			}
			if(nodeType == 'INCSC'){
				//修改库存分类和类组的关联
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'ScgRelaIncsc', newParentRowId, nodeRowId);
			}else if(nodeType == 'SCG'){
				//修改类组的上级类组
				var ret = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'UpdateParScg', newParentRowId, nodeRowId);
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

var HisListTab = new Ext.form.FormPanel({
	id : 'HisListTab',
	region : 'north',
	height : 90,
	labelAlign : 'right',
	title : '多级类组维护',
	frame : true,
	autoScroll : false,
	items:[{html:'<font color=blue size=3>单击右键实现新增或修改节点. 关联库存分类后,我们称这个类组为"底层类组",底层类组不可作为任何类组的上级类组.'
				+'<br>类组,库存分类涉及到物资管理最底层的数据,改动需谨慎!!!'
				+'</font>'
	}]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		title : '多级类组维护',
		items : [HisListTab, MulCatGroupPanel],
		renderTo : 'mainPanel'
	});
	MulCatGroupPanel.getRootNode().expand(true);
});