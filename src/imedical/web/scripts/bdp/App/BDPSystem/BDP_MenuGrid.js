/// 名称: 菜单定义
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-李森
/// 编写日期: 2013-5-2
//  最后修改： 2014-8-15  孙凤超
//********************** treecombo控件 ****************************//
Ext.namespace("Ext.tet");
Ext.tet.TreeComboField = Ext.extend(Ext.form.TwinTriggerField, {
    valueField : "Id",
    displayField : "Name",
    haveShow : false,
	editable : true,
	enableKeyEvents: true,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-twin-triggers',
    onTrigger1Click : function(){
    	this.clearValue();
    },
    onTrigger2Click : function() {
        if (!this.tree.rendered) {
            this.treeId = Ext.id();
            var panel = document.createElement('div');
            panel.style.backgroundColor='#ffffff';
            panel.id = this.treeId;
            this.getEl().dom.parentNode.appendChild(panel);
            this.tree.render(this.treeId);
            this.tree.setWidth(this.width);
            this.tree.getEl().alignTo(this.getEl(), "tl-bl");
        }else{
	        if(this.tree.isVisible()){
	        	this.tree.hide();
	        }else{
	        	this.tree.root.reload();
	        	this.tree.show();
	        }
        }
    },
    initComponent : function() {
        Ext.tet.TreeComboField.superclass.initComponent.call(this);
    },
    onRender : function(ct, position) {
        Ext.tet.TreeComboField.superclass.onRender.call(this, ct, position);
        this.tree.on("click", this.choice, this);
        this.tree.on("dblclick",function(){this.tree.hide();},this);
        if (this.hiddenName) {
            this.hiddenField = this.el.insertSibling({
                tag : 'input',
                type : 'hidden',
                name : this.hiddenName,
                id : (this.hiddenId || this.hiddenName)
            }, 'before', true);
            this.hiddenField.value = this.hiddenValue !== undefined ? this.hiddenValue : this.value !== undefined ? this.value : '';
            this.el.dom.removeAttribute('name');
        }
        if (!this.editable) {
            this.editable = true;
            this.setEditable(false);
        }
    },
    onKeyUp : function() {
    	if (!this.tree.rendered) {
            this.treeId = Ext.id();
            var panel = document.createElement('div');
            panel.style.backgroundColor='#ffffff';
            panel.id = this.treeId;
            this.getEl().dom.parentNode.appendChild(panel);
            this.tree.render(this.treeId);
            this.tree.setWidth(this.width);
            this.tree.getEl().alignTo(this.getEl(), "tl-bl");
        }else{
	        if(this.tree.isVisible()){
	        	this.tree.show();
	        }else{
	        	this.tree.root.reload();
	        	this.tree.show();
	        }
        }
        this.doQuery();
    },
    doQuery : function() {
		var treeFilter = new Ext.tree.TreeFilter(this.tree, {
			clearBlank : true,
			autoClear : true
		});
		this.tree.expandAll();
		var text = this.getEl().dom.value;
		var re = new RegExp(Ext.escapeRe(text), 'i'); // 制作正则表达式，'i'代表不区分大小写
		this.tree.root.cascade(function(n) { // 显示所有节点
			n.ui.show();
		});
		if (text != "") {
			treeFilter.filterBy(function(n) {
				// 如果函数返回true,那么该节点将保留否则它将被过滤掉
				return !n.isLeaf() || re.test(n.text);
			});
			// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
			this.tree.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					if(!n.isLeaf() && judge(n,re)==false && !re.test(n.text)){
						n.ui.hide();
					}
				}
			});
		} else {
			treeFilter.clear();
			this.onTrigger1Click();
			return;
		}
		// 过滤不匹配的非叶子节点或者是叶子节点
		function judge(n,re){
			var flag=false;
			n.cascade(function(n1){
				if(n1.isLeaf()){
					if(re.test(n1.text)){ flag=true;return; }
				} else {
					if(re.test(n1.text)){ flag=true;return; }
				}
			});
			return flag;
		}
	},
    getValue : function() {
        return typeof this.value != 'undefined' ? this.value : '';
    },
    clearValue : function() {
        if (this.hiddenField) {
            this.hiddenField.value = '';
        }
        this.setRawValue('');
        this.lastSelectionText = '';
        this.applyEmptyText();
    },
    readPropertyValue : function(obj, p) {
        var v = null;
        for (var o in obj) {
            if (o == p)
                v = obj[o];
        }
        return v;
    },
    setValue : function(obj) {
        if (!obj) {
            this.clearValue();
            return;
        }
        var v = obj;
        var text = v;
        var value = this.valueField || this.displayField;
        if (typeof v == "object" && this.readPropertyValue(obj, value)) {
            text = obj[this.displayField || this.valueField];
            v = obj[value];
        }
        var node = this.tree.getNodeById(v);
        if (node) {
            text = node.text;
        } else if (this.valueNotFoundText !== undefined) {
            text = this.valueNotFoundText;
        }
        this.lastSelectionText = text;
        if (this.hiddenField) {
            this.hiddenField.value = v;
        }
        Ext.tet.TreeComboField.superclass.setValue.call(this, text);
        this.value = v;
    },
    setEditable : function(value) {
        if (value == this.editable) {
            return;
        }
        this.editable = value;
        if (!value) {
            this.el.dom.setAttribute('readOnly', true);
            this.el.on('mousedown', this.onTriggerClick, this);
            this.el.addClass('x-combo-noedit');
        } else {
            this.el.dom.setAttribute('readOnly', false);
            this.el.un('mousedown', this.onTrigger2Click, this);
            this.el.removeClass('x-combo-noedit');
        }
    },
    choice : function(node, eventObject) {
        if (node.id != "menuTreeRoot")
            this.setValue(node.id);
        else
            this.clearValue();
        this.tree.hide();
    },
    onDestroy : function() {
        if (this.tree.rendered) {
            this.tree.getEl().remove();
        }
        Ext.tet.TreeComboField.superclass.onDestroy.call(this);
    },
    hideTree : function() {
        if (this.tree.rendered) {
            this.tree.hide();
        }
    }
});

Ext.reg('treecombo', Ext.tet.TreeComboField);
//***************************************************************************//
var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/BDP_Menu/BDP_Menu.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPMenuDefine";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;

	var MENUTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=GetMenuForCmb";
	var LinkFuntion_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExecutables&pClassQuery=GetDataForCmb1";
	
	//********** 初始化treecombo *************//
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "id",
				dataUrl: MENUTREE_ACTION_URL
			});
	var menuPanel = new Ext.tree.TreePanel({
				id: 'menuPanel',
				root: new Ext.tree.AsyncTreeNode({
						id:"menuTreeRoot",
						text:"菜单",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: menuTreeLoader,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false
			});
	var treeCombox = new Ext.tet.TreeComboField({
				name:'ParentMenuDr',
				id:'treeCombox',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('treeCombox')),
				fieldLabel:"父菜单",
				hiddenName : 'ParentMenuDr',
				anchor:"97%",
				editable : true,
				enableKeyEvents: true,
				tree:menuPanel
			});
			
	/// 名称: 批量隐藏或激活菜单
		
			
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=GetTreeJson2";
	var TREE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=SaveTreeJson2";
    var sessionStr = Ext.BDP.FunLib.Session(); 
    
    
	//**************** 树检索功能 ****************************************//
	var findByRadioCheck = function(flag){
		if(flag=='all'){
			menuPanelG.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
				}
			});
		}
		if(flag=='checked'){
			menuPanelG.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
					if(!n.attributes.checked){
						n.ui.hide();
					}
				}
			});
		}
		if(flag=='unchecked'){
			menuPanelG.root.cascade(function(n) {
				if(n.id!='menuTreeRoot'){
					n.ui.show();
					var falg = 1;
					if(n.attributes.checked&&n.isLeaf()){
						n.ui.hide();
					}
					else if(n.attributes.checked&&!n.isLeaf()){
						n.cascade(function(n) {
							//if(!n.attributes.checked&&n.isLeaf()){
							if(!n.attributes.checked){
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
	}
	
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(menuPanelG, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// 清除timeOutId
		menuPanelG.expandAll();// 展开树节点
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
				menuPanelG.root.cascade(function(n) {
					if(n.id!='0'){
						if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
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
		menuPanelG.root.cascade(function(n) {
					if(n.id!='0'){
							n.ui.show();
						}
				});
	}
//**************************************************************//
	/** 菜单面板 */
	var menuTreeLoaderG = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: TREE_QUERY_ACTION_URL 
			});
	
	var menuPanelG = new Ext.tree.TreePanel({
			region: 'center',
			//xtype:'treepanel',
			id: 'menuConfigTreePanel',
			expanded:true,
			root: ssordroot=new Ext.tree.AsyncTreeNode({
					id:"menuTreeRoot",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
					
				}),
			loader: menuTreeLoaderG,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false,///
			tbar:[{
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
				            		}
				            	},
				            	scope : this
				            }
		            	}]
		              }]
					}]
	});

	
	var Tree1Window = new Ext.Window({
	    title: '批量隐藏/激活菜单',
	    closable: true,      
	    width: 350,
	    height: 500,
	    border: false,
	    layout: 'border',
	    modal : true,
		closeAction : 'hide',
	    items: [menuPanelG],
	    buttons: [{
	        text: '保存',
	        handler: function () {
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
								url: TREE_SAVE_ACTION_URL,
								method : 'POST',
								params: {Data:str},
								callback : function(options, success, response) {	
								if(success){
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '保存成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK														
											})		
									}
									else {
										var errorMsg = '';
										if(jsonData.errorinfo){
											errorMsg='<br/>错误信息:'+jsonData.errorinfo
										}
										Ext.Msg.show({
											title : '提示',
											msg : '保存失败!'+errorMsg,
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK														
											})		
									}
								}
								else {
										Ext.Msg.show({
											title : '提示',
											msg : '异步通讯失败,请检查网络连接!',
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
											});
								}	
							}
						},this);
	            Tree1Window.hide();
	            ds.reload();
	        }
	    },{
	        text: '取消',
	        handler: function () { 
	            Tree1Window.hide();
	           // ds.reload();
	        }
	    }]
  	});	
  				
		var btnGroup = new Ext.Button({
				id : 'group_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('group_btn'),
				iconCls : 'icon-AdmType',
				text : '批量隐藏/激活',
				handler :function(){
					menuTreeLoaderG.dataUrl=TREE_QUERY_ACTION_URL;
					ssordroot.reload();  //重新加载dataURL和根节点
					Tree1Window.show();
					Ext.getCmp("radioGroup1").setValue("0");
				}
			});	
			
			
//==============================================================菜单维护部分======================================
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
					text : '删除',
					id:'del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
					tooltip : '请选择一行后删除(Shift+D)',
					iconCls : 'icon-delete',
					handler : function DelData() {
						if (grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
								//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									Ext.Ajax.request({
										url : DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('ID')
										},
										callback : function(options, success, response) {
											if (success) {
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true') {
													Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var startIndex = grid.getBottomToolbar().cursor;
															var totalnum=grid.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
															{
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : pagesize_main
																		}
																	});
														}
													});
												} else {
													var errorMsg = '';
													if (jsonData.info) {
														errorMsg = '<br/>错误信息:' + jsonData.info
													}
													Ext.Msg.show({
																title : '提示',
																msg : '数据删除失败!' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
												}
											} else {
												Ext.Msg.show({
															title : '提示',
															msg : '异步通讯失败,请检查网络连接!',
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
										}
									}, this);
								}
							}, this);
						} else {
							Ext.Msg.show({
										title : '提示',
										msg : '请选择需要删除的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
						}
					}
				});
	
	/** 功能定义checkbox数据存储 */
	var ds_LinkFuntion = new Ext.data.Store({
				autoLoad : true,
				proxy : new Ext.data.HttpProxy({ url : LinkFuntion_QUERY_ACTION_URL }),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'ID', 'Caption' ])
			});
			
    var WinForm=new Ext.form.FormPanel({
    			id : 'form-save',
				labelAlign : 'right',
				labelWidth : 130,
				frame:true,
				autoScroll : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                    [
                      	{name: 'ID',mapping:'ID',type:'string'},
                        {name: 'Code',mapping:'Code',type:'string'},
                        {name: 'Caption',mapping:'Caption',type:'string'},
                        {name: 'LinkFuntionDR',mapping:'LinkFuntionDR',type:'string'},
                        {name: 'LinkUrl',mapping:'LinkUrl',type:'string'},
                        {name: 'Image',mapping:'Image',type:'string'},
                        {name: 'Method',mapping:'Method',type:'string'},
                        {name: 'Sequence',mapping:'Sequence',type:'int'},
                        {name: 'ShortcutKey',mapping:'ShortcutKey',type:'string'},
                        {name: 'ShowInNewWindow',mapping:'ShowInNewWindow',type:'string'},
                        {name: 'ParentMenuDr',mapping:'ParentMenuDr',type:'string'},
                        {name: 'ValueExpression',mapping:'ValueExpression',type:'string'},
                        {name: 'actMenuBDP',mapping:'actMenuBDP',type:'string'},
                        {name: 'actMenuAutItem',mapping:'actMenuAutItem',type:'string'},
                        {name: 'actMenuAutData',mapping:'actMenuAutData',type:'string'},
                        {name: 'CompName',mapping:'CompName',type:'string'}
                 ]),
				layout:'column',
				items : [{
					columnWidth:0.5,
					items:[{
						layout:'form',
						defaultType : 'textfield',
						defaults : {
							anchor : '88%',
							border : false
						},
						items:[
						  {
							fieldLabel : 'ID',
							hideLabel : 'True',
							hidden : true,
							name : 'ID'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'Code',
							id:'Code',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Code'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Code')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPMenuDefine";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ID'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							name : 'Caption',
							id :"Caption",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Caption'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Caption')),
							allowBlank : false
						}, {
							fieldLabel : 'URL解析地址',
							name : 'LinkUrl',
							id:'LinkUrl',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LinkUrl'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LinkUrl'))
						}, {
							xtype:'combo',
							fieldLabel : '功能',
							hiddenName : 'LinkFuntionDR',
							id: 'LinkFuntionDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('LinkFuntionDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LinkFuntionDRF')),
							store : ds_LinkFuntion,
							listWidth:156,
							mode : 'local',
							queryParam : 'caption',
							forceSelection : true,
						 	triggerAction:'all',
							selectOnFocus : false,//true表示获取焦点时选中既有值
							typeAhead : true,
							minChars : 1,
							valueField : 'ID',
							displayField : 'Caption'
						}, {
							fieldLabel : '组件名称',
							name : 'CompName',
							id: 'CompName',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CompName'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CompName'))
						},treeCombox, {
							xtype:'numberfield',
							fieldLabel : '显示顺序',
							name : 'Sequence',
							id: 'Sequence',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Sequence'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Sequence')),
							allowDecimals : false, //不允许输入小数
							minValue : 0,
							nanText : '只能是数字'
						}, {
							fieldLabel : '图标',
							name : 'Image',
							id: 'Image',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Image'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Image'))
						 }
						]
					}]
				},{
					columnWidth:.5,
					items:[{
							layout:'form',
							defaultType : 'textfield',
							defaults : {
								anchor : '88%',
								border : false
							},
							items:[ 
						{
							fieldLabel : '服务器端类方法',
							name : 'Method',
							id: 'Method',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Method'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Method'))
						},
					   {
							fieldLabel : '快捷键',
							name : 'ShortcutKey',
							id: 'ShortcutKey',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ShortcutKey'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ShortcutKey'))
						}, {
							fieldLabel : '弹出窗口或增加Tab的方式',
							name : 'ShowInNewWindow',
							id: 'ShowInNewWindow',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ShowInNewWindow'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ShowInNewWindow'))
						}, {
							fieldLabel : '值表达式',
							name : 'ValueExpression',
							id: 'ValueExpression',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValueExpression'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValueExpression'))
							}]
						}, {
							xtype: 'fieldset',
				            title: '',
				            autoHeight: true,
				            defaultType: 'checkbox',
				            items: [{
				                checked: true,
				                fieldLabel: '',
				                boxLabel: '激活基础数据维护菜单',
				                name: 'actMenuBDP',
				                inputValue: '1',
				                id: 'actMenuBDP',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('actMenuBDP'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('actMenuBDP'))
				            }, {
				            	checked: true,
				                fieldLabel: '',
				                labelSeparator: '',
				                boxLabel: '激活功能元素授权菜单',
				                name: 'actMenuAutItem',
				                inputValue: '1',
				                id: 'actMenuAutItem',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('actMenuAutItem'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('actMenuAutItem'))
				            }, {
				            	checked: true,
				                fieldLabel: '',
				                labelSeparator: '',
				                boxLabel: '激活基础数据授权菜单',
				                name: 'actMenuAutData',
				                inputValue: '1',
				                id: 'actMenuAutData',
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('actMenuAutData'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('actMenuAutData'))
				            }]
				          }]
					}]
   		 });
 
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 680,
					height:360,
					layout : 'fit',
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : true,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : WinForm,
					buttons : [{
						text : '保存',
						id:'save_btn',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("Code").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("Caption").getValue();
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	//alert(WinForm.form.isValid());
			   			 	if(WinForm.form.isValid()==false){return;}
							if (win.title == "添加") {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
								//	waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											win.hide();
											var myrowid = action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															grid.getStore().load({
																		params : {
																			start : 0,
																			limit : 1,
																			rowid : myrowid
																		}
																	});
														}
											});
										} else {
											var errorMsg = '';
											if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:' + action.result.errorinfo
											}
											Ext.Msg.show({
														title : '提示',
														msg : '添加失败!' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										}			
									},
									failure : function(form, action) {
										Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
									}
								})
							} else {
								Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											success : function(form, action) {
												if (action.result.success == 'true') {
													win.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
															/*grid.getStore().load({
																		params : {
																			start : 0,
																			limit : 1,
																			rowid : myrowid
																		}
																	});*/
														}
													});
												} else {
													var errorMsg = '';
													if (action.result.errorinfo) {
														errorMsg = '<br/>错误信息:' + action.result.errorinfo
													}
													Ext.Msg.show({
																title : '提示',
																msg : '修改失败!' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
												}			
											},
											failure : function(form, action) {
												Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
											}
										})
									}
								}, this);
								// WinForm.getForm().reset();
							}			
						}
					}, {
						text : '取消',
						handler : function() {
							win.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-save").getForm().findField("Code").focus(true,1000);
						},
						"hide" : function() {
							Ext.BDP.FunLib.Component.FromHideClearFlag();
							Ext.getCmp("treeCombox").hideTree();
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : function AddData() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : function UpdateData() {
					var _record = grid.getSelectionModel().getSelected();
					if (!_record) {
						Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			        	var ParentMenuDr=_record.get('ParentMenuDr');
			        	//屏蔽当前选中菜单,避免死锁
			        	menuPanel.getLoader().baseParams = {'nodeId': _record.get('ID')};
			        	
			        	win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
			                success : function(form,action) {
		                		Ext.get("treeCombox").dom.value = ParentMenuDr;
			                	//Ext.Msg.alert('编辑', '载入成功');
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
				}
			});
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'Code',
									mapping : 'Code',
									type : 'string'
								}, {
									name : 'Caption',
									mapping : 'Caption',
									type : 'string'
								}, {
									name : 'LinkFuntionDR',
									mapping : 'LinkFuntionDR',
									type : 'string'
								}, {
									name : 'CompName',
									mapping : 'CompName',
									type : 'string'
								}, {
									name : 'LinkUrl',
									mapping : 'LinkUrl',
									type : 'string'
								}, {
									name : 'Image',
									mapping : 'Image',
									type : 'string'
								}, {
									name : 'Method',
									mapping : 'Method',
									type : 'string'
								}, {
									name : 'Sequence',
									mapping : 'Sequence',
									type : 'int'
								}, {
									name : 'ShortcutKey',
									mapping : 'ShortcutKey',
									type : 'string'
								}, {
									name : 'ShowInNewWindow',
									mapping : 'ShowInNewWindow',
									type : 'string'
								}, {
									name : 'ParentMenuDr',
									mapping : 'ParentMenuDr',
									type : 'string'
								}, {
									name : 'UpdateDate',
									mapping : 'UpdateDate',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name : 'UpdateTime',
									mapping : 'UpdateTime',
									type : 'time'
								}, {
									name : 'UpdateUser',
									mapping : 'UpdateUser',
									type : 'string'
								}, {
									name : 'ValueExpression',
									mapping : 'ValueExpression',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						disabled : false,
						store : ds
					});
	/** grid加载数据 */
	ds.load({
				params : {
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {
				}
			});
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-', btnGroup]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={			
							myCode : Ext.getCmp("TextCode").getValue(),
							myCaption : Ext.getCmp("TextDesc").getValue(),
							myParMenu : Ext.getCmp("TextParM").getValue()
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit : pagesize_main
						}
					});
				}
			});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextParM").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize_main
								}
							});
				}
			});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码:', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						}, '-',
						'描述:', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}, '-',
						'父菜单:', {
							xtype : 'textfield',
							id : 'TextParM',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextParM')
						}, '-', btnSearch, '-', btnRefresh, '->',helphtmlbtn
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar);
					}
				}
			});
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ID',
							sortable : true,
							dataIndex : 'ID',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'Code',
							width : 200,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'Caption'
						}, {
							header : '功能',
							sortable : true,
							dataIndex : 'LinkFuntionDR'
						}, {
							header : '组件名称',
							sortable : true,
							dataIndex : 'CompName',
							width : 200,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : 'URL解析地址',
							sortable : true,
							dataIndex : 'LinkUrl',
							width : 200,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '父菜单',
							sortable : true,
							dataIndex : 'ParentMenuDr'
						}, {
							header : '显示顺序',
							sortable : true,
							dataIndex : 'Sequence'
						}, {
							header : '快捷键',
							sortable : true,
							dataIndex : 'ShortcutKey'
						}, {
							header : '图标',
							sortable : true,
							dataIndex : 'Image'
						}, {
							header : '弹出窗口或增加Tab的方式',
							sortable : true,
							dataIndex : 'ShowInNewWindow'
						}, {
							header : '服务器端类方法',
							sortable : true,
							dataIndex : 'Method'
						}, {
							header : '值表达式',
							sortable : true,
							dataIndex : 'ValueExpression'
						}, {
							header : '最后的更新日期',
							sortable : true,
							renderer : Ext.util.Format.dateRenderer('Y/m/d'),
							dataIndex : 'UpdateDate'
						}, {
							header : '最后的更新时间',
							sortable : true,
							dataIndex : 'UpdateTime'
						}, {
							header : '最后的更新用户',
							sortable : true,
							dataIndex : 'UpdateUser'
						}],
				stripeRows : true,
				title : '菜单维护',
				//stateful : true,// 记录表格状态
				//viewConfig : {forceFit : true },
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		        	var ParentMenuDr=_record.get('ParentMenuDr');
		        	//屏蔽当前选中菜单,避免死锁
		        	menuPanel.getLoader().baseParams = {'nodeId': _record.get('ID')};
		        	
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
		                success : function(form,action) {
		                	Ext.get("treeCombox").dom.value = ParentMenuDr;
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	/** 调用keymap */
	if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
    {
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    }
});
