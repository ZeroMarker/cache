/**
* @author: wanghc
* @date: 2012/4/14
* 菜单配置主页面
* scripts/dhcdoc/dhcc.doc.menuConfig.js
*/
var treePanel;
var findGroupTree = function(e){
	var groupDesc = Ext.getCmp('groupTF').getValue();				
	var loader = treePanel.getLoader();
	loader.baseParams.groupDesc = groupDesc;
	loader.load(treePanel.root);
}
var initComp = function(){
	var Tree = Ext.tree ; 
    var treeLoader = new Tree.TreeLoader({dataUrl: 'dhcdoc.menuconfigrequest.csp', baseParams:{act:'groupTree'}}) ; //自动传node id
	var root = new Tree.AsyncTreeNode({id:"groupTreeRoot" ,text:"安全组" ,draggable:false ,singleClickExpand:true}) ;
	treePanel = new Tree.TreePanel({ 		
		title:'安全组',
		root:root,
		region:'west',
		loader:treeLoader,
		autoScroll:true, 
		expanded:true,  //根节点自动展开
		containerScroll: true,	
		//frame: true,
		split:true,
		selModel: new Ext.tree.DefaultSelectionModel(),
		minSize:175,
		maxSize:400,
		width:250,
		margins:'0 0 0 0',
		cmargins:'0 0 0 0',
		collapsible: true,
		collapseMode: 'mini',
		rootVisible:false, //设为false将隐藏根节点	
		tbar: ['安全组:','-',new Ext.form.TwinTriggerField({
			widht:280,id:'groupTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			},
			onTrigger2Click: findGroupTree
		})]
	});
	var menuTreeLoader = new Tree.TreeLoader({dataUrl: 'dhcdoc.menuconfigrequest.csp', baseParams:{act:'menuTree'}});	
	var menuPanel = {
			title: '菜单权限配置',
			region: 'center',	
			xtype:'treepanel',
			id: 'menuConfigTreePanel',
			root: new Tree.AsyncTreeNode({id:"menuTreeRoot",text:"菜单",draggable:false ,singleClickExpand:true}),
			loader: menuTreeLoader,
			contextMenu: new Ext.menu.Menu({
				items: [{
					id: 'addNode',
					iconCls:'icon-add-custom',
					text: '增加'
				},{
					id: 'updateNode',
					iconCls:'icon-update-custom',
					text: '更新'
				},{
					id: 'deleteNode',
					iconCls:'icon-delete-custom',
					text: '删除'
				}],
				listeners: {
					itemclick: function(item) {
						var n = item.parentMenu.contextNode;
						switch (item.id) {
							case 'deleteNode':								
								if (n.parentNode) {
									Ext.Msg.confirm("提示","你确定删除?",function(btn, text){;	
										if(btn == 'yes'){ 
											if(0==tkMakeServerCall("web.DHCDocMenuConfig","DeleteExtMenu",n.id)){
												n.remove();
											}else{
												Ext.Msg.alert("提示","操作失败");
											}
										} 
									})									
								}
								break;
							case 'addNode':								
								var form = Ext.getCmp("menuInfoForm").getForm();
								if(n.id !== "menuTreeRoot"){
									form.setValues({EMParentCode: n.id});
								}						
								menuForm.setTitle("增加菜单");
								menuForm.show();	
								break;
							case 'updateNode':
								if(n.parentNode){
									var form = Ext.getCmp("menuInfoForm").getForm();
									var json = tkMakeServerCall("web.DHCDocMenuConfig","GetMenuItemInfo",n.id);
									try{ json = Ext.decode(json); }catch(e){ alert("操作错误!"); }
									form.setValues(json);
									menuForm.setTitle("更新菜单");
									menuForm.show();
								}
								break;
								
						}
					}
				}
			}),
			autoScroll: true, 
			expanded: false,
			containerScroll: true,	
			//selModel: new Ext.tree.MultiSelectionModel(), //Ext.tree.DefaultSelectionModel(),
			rootVisible:true,		
			tbar:[{text:'保存',iconCls:'icon-filesave-custom',handler:function(){
				var groupnode,groupid=0;
				if(treePanel){
					var groupnode = treePanel.getSelectionModel().getSelectedNode();
					if(groupnode){
						groupid = groupnode.id;
					}else{
						Ext.Msg.alert("提示","没有选中安全组!");
						return ;
					}
				}
				var arr = [];
				var f  = function(){
					var flag = this.attributes.checked;
					if('undefined' !== typeof flag) { 
						flag = flag ? 1 : 0;
						arr.push(this.id + "!" + flag);
					}
				}
				Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f);		//在所有childnode上做f
				var ids = arr.join("^");
				Ext.Ajax.request({
					url:'dhcdoc.menuconfigrequest.csp',					
					params: {act: 'savegroupmenulink', ids: ids, groupid: groupid},
					success: function(resp,option){
						var rtn = resp.responseText.replace(/\r\n/g,"");
						try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
						if (obj.msg == "0"){					
							Ext.Msg.alert("提示","保存成功!");
						}else{
							Ext.Msg.alert("提示","失败!<br>代码: " + obj.msg);
						}						
					}
				});
				
			}}]			
	}
	var menuForm = new Ext.Window({
		id: 'menuInfoWin',		
		layout: 'fit',					
		width: 450, height: 300, modal: true,
		labelAlign: 'right',
		closable:false,
		renderTo: Ext.getBody(),
		items: [{
			id: 'menuInfoForm',
			xtype: 'form',
			frame:true,
			defaults: {width: 200},
			defaultType: 'textfield',
			labelSeparator :'&nbsp', //去掉label后的冒号
			items:[{
				name: 'EMParentCode',fieldLabel: '父节点',readOnly:true
			},{   
				name: 'EMCode',fieldLabel: '菜单代码'
			},{
				name: 'EMText',fieldLabel: '菜单描述'	
			},{
				name: 'EMHandler', fieldLabel: '处理函数'	
			},{
				name: 'EMDisplayHandler',fieldLabel:'显示函数'
			},{
				name:'EMCls',fieldLabel:'菜单样式'
			},{
				name: 'EMItemIndex', fieldLabel: '菜单顺序'
			},{
				name: 'ID',fieldLabel: '菜单ID',readOnly:true
			}],
			buttons:[{
				name:'save',text:'确定',iconCls:'icon-ok-custom',handler: function(b, e){
					var form = Ext.getCmp("menuInfoForm").getForm();
					var json = form.getValues(true);
					var rtn = tkMakeServerCall("web.DHCDocMenuConfig","SaveExtMenu",json);										
					if(rtn == "-306") {
						Ext.Msg.alert("提示","操作失败!");					
					}else if( rtn == "0"){
						var menuConfigTempTreePanel =  Ext.getCmp("menuConfigTreePanel");
						var selectedNode = menuConfigTempTreePanel.getSelectionModel().getSelectedNode();
						var id = selectedNode.id;						
						var parentId ;
						if(menuForm.title =='增加菜单'){
							menuTreeLoader.load(selectedNode);
							menuConfigTempTreePanel.getNodeById(id).expand();
						}else if(menuForm.title =='更新菜单'){
							parentId = selectedNode.parentNode.id;
							menuTreeLoader.load(selectedNode.parentNode);
							menuConfigTempTreePanel.getNodeById(parentId).expand();
						}
						Ext.getCmp("menuInfoForm").getForm().reset();
						menuForm.hide();
					}
				}
			},{
				name:'cancel',text:'取消',iconCls:'icon-skip-custom',handler:function(b, e){
					Ext.getCmp("menuInfoForm").getForm().reset();
					menuForm.hide();
				}
			}]
		}]
	});
	var viewport = new Ext.Viewport({
		layout:'border',
		items:[treePanel,menuPanel]
	});
	
}

var initListener = function(){	
	if(treePanel){
		treePanel.on("click",function (node, e){
			var patArr;
			if (node.isLeaf()){
				e.stopEvent();
				var groupnode = treePanel.getSelectionModel().getSelectedNode()
				var menuTree = Ext.getCmp("menuConfigTreePanel");
				var loader = menuTree.getLoader();
				loader.baseParams.groupid = groupnode.id;			
				loader.load(menuTree.root);
			}
		},this,{stopEvent:true});
	}
	var menuConfigTreePanel = Ext.getCmp("menuConfigTreePanel");
	if (menuConfigTreePanel){
		menuConfigTreePanel.on("checkchange",function(node,checked){
			var f  = function(){
				this.attributes.checked  = checked;			
				this.getUI().checkbox.checked = checked ;
				//if(checked) this.getUI().addClass('x-tree-selected ');
				//else this.getUI().removeClass('x-tree-selected ');
			}
			node.cascade(f);		//在所有childnode上做f
		});
		menuConfigTreePanel.on("contextmenu",function(node, e){
			node.select();
			var c = node.getOwnerTree().contextMenu;
			c.contextNode = node;
			c.showAt(e.getXY());
		});
	}
	var obj = Ext.getCmp("groupTF");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				findGroupTree();
			}
		});
	}
};
var init = function(){
	initComp();
	initListener();
};
Ext.onReady(init);