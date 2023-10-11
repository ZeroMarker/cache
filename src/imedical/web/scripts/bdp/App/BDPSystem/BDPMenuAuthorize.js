/// 名称: 菜单授权-- 一级授权
/// 编写者: 基础数据平台组-李森
/// 编写日期: 2013-4-26
/// 修改日期：2014-10-23 蔡昊哲

	
	
	
//******************** 菜单树级联设置 ****************************//
function cascadeParent(){
	var pn = this.parentNode;
	if (!pn || !Ext.isBoolean(this.attributes.checked)) return;
	if (this.attributes.checked) { //级联选中
		pn.getUI().toggleCheck(true);
	}else {//级联未选中
		var b = true;
		Ext.each(pn.childNodes, function(n){
			if (n.getUI().isChecked()){
				return b = false;
			}
			return true;
		});
		if (b) pn.getUI().toggleCheck(false);
	}
	pn.cascadeParent();
}        
function cascadeChildren(){
	var ch = this.attributes.checked;
	if (!Ext.isBoolean(ch)) return;
	Ext.each(this.childNodes, function(n){
		n.getUI().toggleCheck(ch);
		n.cascadeChildren();
	});
}
Ext.apply(Ext.tree.TreeNode.prototype, {
	cascadeParent: cascadeParent,
	cascadeChildren: cascadeChildren
});
Ext.override(Ext.tree.TreeNodeUI,{
                onDblClick: function(e){
                    e.preventDefault();
                    if(this.disabled){
                        return;
                    }
                    if(!this.animating && this.node.isExpandable()){
                        this.node.toggle();
                    }
                    this.fireEvent("dblclick", this.node, e);
                }
            });
Ext.override(Ext.tree.TreeEventModel, {
	onCheckboxClick: Ext.tree.TreeEventModel.prototype.onCheckboxClick.createSequence(function(e, node){
		node.cascadeParent();
		node.cascadeChildren();
	})
});
//****************************************************************//

	var MENUTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.Menu&pClassMethod=GetTreeJson2";
	var MENU_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.Menu&pClassMethod=SaveAuthorizeData";
	
	var sessionStr = Ext.BDP.FunLib.Session(); //二级授权时使用，20140317 by lisen
	
	/** 菜单面板 */
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: MENUTREE_ACTION_URL + '&SessionStr=' + sessionStr //20140317 by lisen
			});
	var menuPanel = new Ext.tree.TreePanel({
			title: '菜单授权',
			region: 'center',
			//xtype:'treepanel',
			id: 'menuConfigTreePanel',
			expanded:true,
			root: new Ext.tree.AsyncTreeNode({
					id:"menuTreeRoot",
					text:"菜单",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
				}),
			loader: menuTreeLoader,
			autoScroll: true,
			containerScroll: true,
			rootVisible:true,
			tbar:['查询',
			new Ext.form.TextField({
				id:'FindTreeText',
				width:200,
				emptyText:'请输入查找内容，回车查询',
				enableKeyEvents: true,
				listeners:{
					keyup:function(node, event) {
						if (event.getKey() == 13) {
							findByKeyWordFiler(node);
							}
						},
						scope: this
					}
				}), '-', {
					text:'清空',
					tooltip:'清空查找内容并查找全部菜单',
					iconCls:'icon-refresh',
					handler:function(){
						clearFind();
					
					} //清除树过滤
				}, '-', {
					text:'保存',
					icon:Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
					handler:function() {
							//clearFind(); //清除树过滤
							
							if(ObjectReference!=""){
								if(ObjectType!="L")
								{
									if(ObjectReference==1){
									Ext.Msg.alert("提示","禁止给Demo Group授权!");
									return ;
								}
							}
							}else{
								Ext.Msg.alert("提示","没有选中授权类别!");
								return ;
							}
							
							str = "";
							var f  = function(node) {
								var flag = this.attributes.checked;
								if(flag==true) {
									if (str!="") str=str+",{";
									else str=str+"{";
									str=str+"ID:"+node.id+"}"
								}
							}
							Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f); //在所有childnode上做f
							if(str!="") str="["+str+"]";
							Ext.Ajax.request({
								url: MENU_SAVE_ACTION_URL,
								params: {ObjectType:ObjectType, ObjectReference:ObjectReference, Data:str},
								success: function(resp,option){
											var rtn = resp.responseText.replace(/\r\n/g,"");
											try{var obj = Ext.decode(rtn);}catch(e){alert("操作失败!");return ;}
											if (obj.msg == "0") {
												Ext.Msg.show({
													title : '提示',
													msg : '保存成功!',
													minWidth : 150,
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK
												});
											}else {
												Ext.Msg.show({
													title : '提示',
													msg : '保存失败!<br>代码:' + obj.msg,
													minWidth : 150,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
											}
										},
								failure: function(response, opts) {
											console.log('server-side failure with status code ' + response.status);
										},
								scope : this
							});
					}
				}, '-', {
					text:'取消授权',
					tooltip:'取消用户的所有授权',
					icon:Ext.BDP.FunLib.Path.URL_Icon+'delete.gif',
					handler:function(){
						//cancelauth();
						if(ObjectReference!=""){
							if(ObjectType!="L")
							{
								if(ObjectReference==1){
								Ext.Msg.alert("提示","禁止给Demo Group授权!");
								return ;
								}
							}
						}else{
							Ext.Msg.alert("提示","没有选中授权类别!");
							return ;
						}
						Ext.MessageBox.confirm('提示', '确定要取消用户的所有授权吗?', function(btn) {
							if (btn == 'yes') {
								//未授权时，删除对应授权数据
		                        var rowid= tkMakeServerCall("web.DHCBL.Authorize.Menu","DHCGetRowID",ObjectType,ObjectReference);
		                        if (rowid!=""){
		                            var result= tkMakeServerCall("web.DHCBL.BDP.BDPPreferences","DeleteData",rowid);
		                            var result=eval('('+result+')'); 
		                            if (result.success == 'true'){
										menuPanel.getRootNode().cascade(function(n) {
										    var ui = n.getUI();
										    ui.toggleCheck(false);
										});
										
										Ext.Msg.show({
											title : '提示',
											msg : '取消授权成功!',
											minWidth : 150,
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK
										});
									}else {
										Ext.Msg.show({
											title : '提示',
											msg : '取消授权失败!<br>' + result.info,
											minWidth : 150,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
									}

		                        }
		                        else
		                        {
									  Ext.Msg.show({
											title : '提示',
											msg : '没有授权信息!',
											minWidth : 150,
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK
										});                      	
		                        }

							}
						}, this);
								
					
					} 
				}, '-', {
					xtype:'panel',
					baseCls:'x-plain',
					height:30,
					items:[{
						id : 'radioGroup1',
						xtype : 'radiogroup',
						columns: [60, 60, 60],
			            items : [{
		            		id : 'radio1',
		            		boxLabel : "全部",
		            		name : 'FilterCK',
		            		inputValue : '0',
		            		checked : true,
		            		listeners : {
				            	'check' : function(com, checked){
				            		if(checked){
				            			findByRadioCheck('all');
				            			//findByKeyWordFiler(Ext.getCmp('FindTreeText'))
				            			
				            		}
				            	},
				            	scope : this
				            }
		            	}, {
		            		id : 'radio2',
		            		boxLabel : "已选",
		            		name : 'FilterCK',
		            		inputValue : '1',
		            		listeners : {
				            	'check' : function(com, checked){
				            		if(checked){
				            			findByRadioCheck('checked');
				            			//findByKeyWordFiler(Ext.getCmp('FindTreeText'))
				            		}
				            	},
				            	scope : this
				            }
		            	}, {
		            		id : 'radio3',
		            		boxLabel : "未选",
		            		name : 'FilterCK',
		            		inputValue : '2',
		            		listeners : {
				            	'check' : function(com, checked){
				            		if(checked){
				            			findByRadioCheck('unchecked');
				            			//findByKeyWordFiler(Ext.getCmp('FindTreeText'))
				            		}
				            	},
				            	scope : this
				            }
		            	}]
		            }]
				},'->',helphtmlbtn]
	});
	
	/** 获取菜单面板 */
	function getMeunPanel(){
		return menuPanel;
	};

//**************** 树检索功能 ****************************************//
	var findByRadioCheck = function(flag){
		//alert(flag)
		if(flag=='all'){
			menuPanel.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
				}
			});
		}
		if(flag=='checked'){
			menuPanel.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
					if(!n.attributes.checked){
						n.ui.hide();
					}
				}
			});
		}
		if(flag=='unchecked'){
			menuPanel.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
					var falg = 1;
					if(n.attributes.checked&&n.isLeaf()){
						n.ui.hide();
					}
					else if(n.attributes.checked&&!n.isLeaf()){
						n.cascade(function(n) {
							if(!n.attributes.checked&&n.isLeaf()){
								falg = 0;
								return;
							}
						});
						if (falg == 1)
						{
							n.ui.hide();
						}
						
					}
				}
			});
		}
		Ext.getCmp('FindTreeText').reset();  ///切换 全部、已选、未选时，清空搜索框
	}
	
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(menuPanel, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	//node, event
	var findByKeyWordFiler = function(node) {
		//alert(node.getValue())
		clearTimeout(timeOutId);// 清除timeOutId
		menuPanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});
			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
					return !n.isLeaf() || re.test(n.text);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				menuPanel.root.cascade(function(n) {
					if(n.id!='0'){
						if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				//treeFilter.clear();  
				///2016-3-7  解决“勾选【已选】或【未选】前提下，检索框中输入内容查询，再删除内容并回车后，已选和未选条件失效，查询出了全部菜单”bug
				if (!(Ext.getCmp('radio1').getEl().dom.checked))
				{
					
					if (Ext.getCmp('radio2').getEl().dom.checked)
					{
						findByRadioCheck('checked');
					}
					if (Ext.getCmp('radio3').getEl().dom.checked)
					{
						findByRadioCheck('unchecked');
					}
					
				}
				else
				{
					treeFilter.clear();
					
				}
				return;
			}
		}, 500);
	}
	
	// 过滤不匹配的非叶子节点或者是叶子节点
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			if(n1.isLeaf()){
				if(re.test(n1.text)){ str=true;return; }
			} else {
				if(re.test(n1.text)){ str=true;return; }
			}
		});
		return str;
	};
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		
		
		if (!(Ext.getCmp('radio1').getEl().dom.checked))
		{
			
			if (Ext.getCmp('radio2').getEl().dom.checked)
			{
				Ext.getCmp('radio2').setValue(false);
			}
			if (Ext.getCmp('radio3').getEl().dom.checked)
			{
				Ext.getCmp('radio3').setValue(false);
			}
			Ext.getCmp('radio1').setValue(true);
		}
		//findByKeyWordFiler(Ext.getCmp('radio2').getValue())
		
		
		//findByRadioCheck('all');
		//Ext.getCmp('radio1').setValue(true);
		
		menuPanel.root.cascade(function(n) {
					if(n.id!='0'){
							n.ui.show();
						}
				});
	}
//**************************************************************//

/*

var initListener = function(){
	// 安全组菜单单击事件
	if(treePanel){
		treePanel.on("click",function (node, e){
			if (node.isLeaf()){
				var groupnode = treePanel.getSelectionModel().getSelectedNode();
				var ObjectReference=groupnode.id;
				var menuTree = Ext.getCmp("menuConfigTreePanel");
				var loader = menuTree.getLoader();
				loader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
				loader.load(menuTree.root);
				menuTree.expandAll();
			}
		},this,{stopEvent:true});
	}
	
	// 菜单配置单击事件
	var menuConfigTreePanel = Ext.getCmp("menuConfigTreePanel");
	if (menuConfigTreePanel){
		menuConfigTreePanel.on("checkchange",function(node,checked){
			var f  = function(){
				this.attributes.checked  = checked;			
				this.getUI().checkbox.checked = checked ;
				//if(checked) this.getUI().addClass('x-tree-selected ');
				//else this.getUI().removeClass('x-tree-selected ');
			}
			node.cascade(f); //在所有childnode上打钩
		});
	}
	
	// 安全组查找“回车”事件
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
	//initComp();
	initListener();
};
//Ext.onReady(init);*/