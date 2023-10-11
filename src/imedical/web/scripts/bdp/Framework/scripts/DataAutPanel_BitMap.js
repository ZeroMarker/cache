//bitmap数据格式保存
Ext.namespace("Ext.BDP.Component");
Ext.namespace("Ext.BDP.Component.tree");

/**
 * @class Ext.BDP.Component.tree.TreeLoaderStore
 * @extends Ext.data.Store
 * @author 2013-6-6 by 李森
 * 说明：
 * 		用于TreePanel数据分页。
 * 		当tree层级为二级以上时不建议分页，因为后台方法还不完善，分页后检索功能不太完美。
 */
Ext.BDP.Component.tree.TreeLoaderStore = Ext.extend(Ext.data.Store,{
	/**
	 * 加载数据源的数据对象，是树结构的loader
	 * @type  Ext.BDP.Component.tree.TreePagingLoader
	 */
	loader : null,
	/**
	 * 树的根节点，最顶的节点
	 * @type Ext.BDP.Component.tree.AsyncTreeNode
	 */
	rootNode : null,
	
	constructor : function(config){
	 	Ext.BDP.Component.tree.TreeLoaderStore.superclass.constructor.call(this);
	 	this.loader = config.loader;
	 	this.rootNode = config.rootNode;
	 },
	 load : function(options){
	 	var _self = this;
	 	if(!this.loader || !this.rootNode){
	 		Ext.MessageBox.alert("错误","必须指定loader或者rootNode");
	 		return false;
	 	}
	 	Ext.apply(this.loader.baseParams,{start:options.params.start,limit:options.params.limit}),
	 	this.loader.load(this.rootNode,function(node){
	 		_self.currentCount = _self.loader.currentCount;
	 		_self.totalLength = _self.loader.totalCount;
			if(typeof(_self.totalLength)=="undefined"){
				//Ext.Msg.alert("提示","数据太多无法显示,请设置分页!");
				Ext.Msg.alert("提示","数据加载失败!");
				return false;
			}
	 		node.expand();
			_self.fireEvent("load",_self,null,options);
			delete _self;
		});
		return true;
	},
	getCount : function(){
	   return this.currentCount || 0;
	},
	getTotalCount : function(){
		return this.totalLength || 0;
	}
});

/**
 * @class Ext.BDP.Component.tree.TreePagingLoader
 * @extends Ext.tree.TreeLoader
 * @author 2013-6-6 by 李森
 * 说明：
 * 		用于tree分页加载
 */
Ext.BDP.Component.tree.TreePagingLoader = Ext.extend(Ext.tree.TreeLoader,{
    doPreload : function(node){
        if(node.attributes.children){ //渲染子节点
            if(node.childNodes.length < 1){
                var cs = node.attributes.children.data;
                node.beginUpdate();
                for(var i = 0, len = cs.length; i < len; i++){
                    var cn = node.appendChild(this.createNode(cs[i]));
                    if(this.preloadChildren){
                        this.doPreload(cn);
                    }
                }
                node.endUpdate();
            }
            return true;
        }
        return false;
    },
    processResponse : function(response, node, callback, scope){
        var json = response.responseText;
        try {
            var o = response.responseData || Ext.decode(json);
            this.totalCount = o.totalCount;  //获取数据条数,用于store分页
            this.currentCount = o.data.length;
            var o = o.data;
            node.beginUpdate();
            for(var i = 0, len = o.length; i < len; i++){
                var n = this.createNode(o[i]);
                if(n){
                    node.appendChild(n);
                }
            }
            node.endUpdate();
            this.runCallback(callback, scope || node, [node]);
        }catch(e){
            this.handleFailure(response);
        }
    }
});

/**
 * @class Ext.BDP.Component.tree.AsyncTreeNode
 * @extends Ext.tree.AsyncTreeNode
 * @author 2013-6-6 by 李森
 * 说明：
 * 		根节点定义
 */
Ext.BDP.Component.tree.AsyncTreeNode = Ext.extend(Ext.tree.AsyncTreeNode, {
	expand : function(deep, anim, callback, scope){
		this.loaded = true; //设置为true,防止页面初始化时重复加载TreeLoader
        if(this.loading){
            var timer;
            var f = function(){
                if(!this.loading){ 
                    clearInterval(timer);
                    this.expand(deep, anim, callback, scope);
                }
            }.createDelegate(this);
            timer = setInterval(f, 200);
            return;
        }
        if(!this.loaded){
            if(this.fireEvent("beforeload", this) === false){
                return;
            }
            this.loading = true;
            this.ui.beforeLoad(this);
            var loader = this.loader || this.attributes.loader || this.getOwnerTree().getLoader();
            if(loader){
                loader.load(this, this.loadComplete.createDelegate(this, [deep, anim, callback, scope]), this);
                return;
            }
        }
        Ext.BDP.Component.tree.AsyncTreeNode.superclass.expand.call(this, deep, anim, callback, scope);
    }
});

/**
 * @class Ext.BDP.Component.tree.TreePanel
 * @extends Ext.tree.TreePanel
 * @author 2013-6-6 by 李森
 * 说明：
 * 		具有分页、查询、级联选择、搜索、保存选中节点功能
 */
Ext.BDP.Component.tree.TreePanel = Ext.extend(Ext.tree.TreePanel, {
	/**
	 * 方法说明：
	 * 		1、loadAuthorizeTree(ObjectType,ObjectReference); //重新加载授权后的树
	 */
	//**************方法说明(以上)************************************//
	
	autoScroll : true,
    rootVisible : false,
    animate : true,
    enableDD : true,
    containerScroll : true,
    height : Ext.getBody().getHeight(),
    //title : Ext.BDP.FunLib.getParam('ObjectType')=='G'?'安全组：'+Ext.BDP.FunLib.getParam('ObjectReferenceText'):(Ext.BDP.FunLib.getParam('ObjectType')=='L'?'科室：'+Ext.BDP.FunLib.getParam('ObjectReferenceText'):'用户：'+Ext.BDP.FunLib.getParam('ObjectReferenceText')),
	//iconCls : Ext.BDP.FunLib.getParam('ObjectType')=='G'?'icon-book':(Ext.BDP.FunLib.getParam('ObjectType')=='L'?'icon-LoginLoc':'icon-user'),
	
	pageSize : 0, //分页大小,为0时不分页
	disToolbar : true, //是否显示工具条
	isCascade : true, //是否级联选择
	treeChanged : false, //标记当前页的数据是否变化,该属性只有在分页时有效
	getAutClass : '', //获取授权数据类名称
	getAutMethod : '', //获取授权数据方法,保存时使用
	saveAutClass : '', //保存授权数据类名称
	saveAutMethod : '', //保存授权数据方法
	ObjectType : '', //授权类型
	ObjectReference : '', //授权类型id
    AutCode:'', //授权页代码
	initComponent : function(){
        Ext.BDP.Component.tree.TreePanel.superclass.initComponent.call(this);
		
        this.root = new Ext.BDP.Component.tree.AsyncTreeNode({
	         id:"menuTreeRoot",
	         text: '数据',
	         expanded :true,
	         draggable:false
	    });
	    this.loader = new Ext.BDP.Component.tree.TreePagingLoader({
	    	nodeParameter: "ParentID",
			dataUrl:this.dataUrl, //+"&ObjectType="+this.ObjectType+"&ObjectReference="+this.ObjectReference,
			baseParams : {ObjectType:this.ObjectType,ObjectReference:this.ObjectReference}
		});
		var loadmark = null;
        this.loader.on({
	       'beforeload' : function(){
	           loadmark = new Ext.LoadMask(Ext.getBody(),{
	              msg : '数据加载中,请稍后...',
	              removeMask : true //完成后移除
	            });
	            loadmark.show();
	            Ext.getCmp('checkall').setValue(false);
	       }, //加载前
	       'load' : function(){
	       		loadmark.hide(); //加载完成后
	       		var a = true;
	            Ext.each(this.root.childNodes, function(n){
	                if (!n.getUI().isChecked()){
	                    return a = false;
	                }
	                return true;
	            });
	            if (a) {
	            	Ext.get('checkall').dom.checked = true;
	                Ext.getCmp('checkall').checked = true;
	            }
	       },
	       scope:this
        });
        if(!this.eventModel){
            this.eventModel = new Ext.tree.TreeEventModel(this);
        }
        var l = this.loader;
        if(!l){
            l = new Ext.BDP.Component.tree.TreePagingLoader({
                dataUrl: this.dataUrl,
                requestMethod: this.requestMethod
            });
        }else if(Ext.isObject(l) && !l.load){
            l = new Ext.BDP.Component.tree.TreePagingLoader(l);
        }
        this.loader = l;
        this.nodeHash = {};
        /**用于分页的store*/
        this.store = new Ext.BDP.Component.tree.TreeLoaderStore({
			rootNode : this.root,
			loader : this.loader
		});
		/**搜索工具条*/
		if(this.disToolbar){
			this.tbar = new Ext.Toolbar({
					items : [{
						id : 'checkall',
						xtype : 'checkbox',
						boxLabel : '全选',
						listeners : {
							'check' : function(com, checked){
								var t  = function(node) {node.getUI().toggleCheck(true);}
								var f  = function(node) {node.getUI().toggleCheck(false);}
								if(checked){
									this.root.cascade(t);
								}else{
									this.root.cascade(f);
								}
							},
							scope : this
						}
					}, '-', '查找', new Ext.form.TextField({
						id : 'TreeSearchText',
						/*enableKeyEvents : true,
						listeners : {
							keyup : function(field, event) {
								this.doQuery();
							},
							scope : this
						}*/
					}), '-', new Ext.Button({
						text : '搜索',
						iconCls : 'icon-search',
						handler : function(){
							this.doQuery();
						},
						scope : this
					}), '-', new Ext.Button({
						text : '重置',
						iconCls : 'icon-refresh',
						handler : function(){
							Ext.getCmp('TreeSearchText').setValue('');
							if (Ext.getCmp('_HospList'))
							{
								Ext.getCmp('_HospList').setValue('');
								//var thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName",AutCode,session['LOGON.HOSPID'])
			       				//hospComp.setValue(thisHospId);   //初始赋值为当前登录科室的院区
			      				//Ext.getCmp('_HospList').fireEvent('select',Ext.getCmp('_HospList'),Ext.getCmp('_HospList').getStore().getById(thisHospId))  //触发select事件
							}
							if(this.AutCode=="ARC_ItmMast"){
								Ext.getCmp('alias').setValue('');
								Ext.getCmp('billgroup').setValue('');
								Ext.getCmp('subbillgroup').setValue('');
								Ext.getCmp('ordersubsort').setValue('');
							}
							
							this.doQuery();
						},
						scope : this
					}), '-', new Ext.Button({
						text : '保存',
						icon : Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
						listeners : {
							click : function(){
								var ff = this.saveAuthorizeData(); //保存当前数据
		            			if(ff){ //保存成功
			            			this.treeChanged = false;
		            			}else{
		            				this.treeChanged = true;
		            			}
							},
							scope : this
						}
					}), '-', {
						xtype:'panel',
						baseCls:'x-plain',
						height:30,
						items:[{
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
					            			this.loader.dataUrl = this.dataUrl;
					            			this.loadAuthorizeTree(this.ObjectType,this.ObjectReference);
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
					            			this.loader.dataUrl = this.dataUrl + '&FilterCK=checked';
					            			this.loadAuthorizeTree(this.ObjectType,this.ObjectReference);
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
					            			this.loader.dataUrl = this.dataUrl + '&FilterCK=unchecked';
					            			this.loadAuthorizeTree(this.ObjectType,this.ObjectReference);
					            		}
					            	},
					            	scope : this
					            }
			            	}]
			            }]
					}]
				});
			this.elements += ',tbar';
	        this.topToolbar = this.createToolbar(this.tbar);
	        this.tbar = null;
	        var keymap = new Ext.KeyMap(document, {
							key:Ext.EventObject.ENTER, /**按钮转换功能，将enter键转换为tab键。当为button时不进行按键的转换**/
							fn:  function changeFocus() {
									if(event.keyCode==13 && event.srcElement.type!='button') {
							      		event.keyCode=9; //tab
							      	}
							    }
						});
		}
		/**分页工具条*/
		if(this.pageSize){
			this.store.load({params:{start:0,limit:this.pageSize}}); //加载数据
			this.pageTb = new Ext.PagingToolbar({
                store : this.store,
                pageSize : this.pageSize,
                displayInfo: true
            });
            this.on('checkchange',function(node,checked){ //添加checkchange监听
            	this.treeChanged = true;
            },this);
            this.pageTb.on('beforechange',function(tb,e){ //添加翻页监听
            	if(this.treeChanged){
            		var cfmF = window.confirm('本页数据已变动,是否保存?');
            		if(cfmF){ //是
            			var ff = this.saveAuthorizeData(); //保存当前数据
            			if(ff){ //保存成功
	            			this.treeChanged = false;
	            			return true; //翻页
            			}else{
            				return false; //不翻页
            			}
            		}else{ //否
            			this.treeChanged = false;
            			return true; //翻页
            		}
            	}
            },this);
            this.elements += ',bbar';
            this.bottomToolbar = this.createToolbar(this.pageTb);
            this.pageTb = null;
		}else{
			this.store.load({params:{start:0,limit:this.pageSize}}); //加载数据
		}
        if(this.root){
            var r = this.root;
            delete this.root;
            this.setRootNode(r);
        }
        /**级联功能*/
        if(this.isCascade){
        	/**
		     * tree的属性enableAllCheck为true时，所有节点默认渲染未选中的checkbox
		     */
		    Ext.apply(Ext.tree.TreePanel.prototype, {
		        checkAllNodes: this.checkAllNodes,
		        loadCheckedNodes: this.loadCheckedNodes,
		        initComponent: Ext.tree.TreePanel.prototype.initComponent.createInterceptor(function(){
		            if (this.enableAllCheck === true) {
		                var loader = this.loader;
		                loader.baseAttrs = loader.baseAttrs || {};
		                loader.baseAttrs['checked'] = false;
		            }
		        })
		    });
		    /**
		     * 为TreeNode对象添加级联父节点和子节点的方法
		     */
		    Ext.apply(Ext.tree.TreeNode.prototype, {
		        cascadeParent: this.cascadeParent,
		        cascadeChildren: this.cascadeChildren
		    });
		    /**
		     * 结点加载后级联子节点
		     */
		    /*Ext.override(Ext.tree.AsyncTreeNode, {
		        loadComplete: Ext.tree.AsyncTreeNode.prototype.loadComplete.createSequence(function(e, node){
		            this.cascadeChildren();
		        })
		    });*/
		    /**
		     * Checkbox被点击后级联父节点和子节点
		     */
		    Ext.override(Ext.tree.TreeEventModel, {
		        onCheckboxClick: Ext.tree.TreeEventModel.prototype.onCheckboxClick.createSequence(function(e, node){
		            node.cascadeParent();
		            node.cascadeChildren();
		        })
		    });
        }
        this.addEvents(
           'append',
           'remove',
           'movenode',
           'insert',
           'beforeappend',
           'beforeremove',
           'beforemovenode',
           'beforeinsert',
           'beforeload',
           'load',
           'textchange',
           'beforeexpandnode',
           'beforecollapsenode',
           'expandnode',
           'disabledchange',
           'collapsenode',
           'beforeclick',
           'click',
           'containerclick',
           'checkchange',
           'beforedblclick',
           'dblclick',
           'containerdblclick',
           'contextmenu',
           'containercontextmenu',
           'beforechildrenrendered',
           'startdrag',
           'enddrag',
           'dragdrop',
           'beforenodedrop',
           'nodedrop',
           'nodedragover'
        );
        if(this.singleExpand){
            this.on('beforeexpandnode', this.restrictExpand, this);
        }
    },
    
    /**检索*/
    doQuery : function(){
    	var v = Ext.getCmp('TreeSearchText').getValue()   	
    	if(this.AutCode=="ARC_ItmMast"){
			v=v +"^"+Ext.getCmp('billgroup').getValue() //账单组
	    	+"^"+Ext.getCmp('subbillgroup').getValue()//账单子组  		
	    	+"^"+Ext.getCmp('ordersubsort').getValue()//医嘱子类	
	    	+"^"+Ext.getCmp('alias').getValue(); //别名
    	}
		var DataType=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",this.AutCode);
		if (DataType!='G')
		{
			v=v+"^"+Ext.getCmp('_HospList').getValue()
		}
    	//TODO:从服务器端查询数据,思路是把查询条件query传到服务器端,由服务器返回查询后的树。
    	//后台方法还有缺陷,目前只能检索叶子节点。
    	Ext.apply(this.loader.baseParams,{query:v}); //添加参数query。
    	this.store.load({params:{start:0,limit:this.pageSize}}); //加载数据
    },
    
    /**级联父节点*/
    cascadeParent : function(){
        var pn = this.parentNode;
        if (!pn || !Ext.isBoolean(this.attributes.checked)) 
            return;
        if (this.attributes.checked) {//级联选中
        	var a = true;
            Ext.each(pn.childNodes, function(n){
                if (!n.getUI().isChecked()){
                    return a = false;
                }
                return true;
            });
            if (a) {
                Ext.getCmp('checkall').setValue(true);
            }
            pn.getUI().toggleCheck(true);
        }
        else {//级联未选中
        	Ext.get('checkall').dom.checked = false;
        	Ext.getCmp('checkall').checked = false;
            var b = true;
            Ext.each(pn.childNodes, function(n){
                if (n.getUI().isChecked()){ 
                    return b = false;
                }
                return true;
            });
            if (b) {
                pn.getUI().toggleCheck(false);
            }
        }
        pn.cascadeParent();
    },
    
    /**级联子节点*/
    cascadeChildren : function(){
        var ch = this.attributes.checked;
        if (!Ext.isBoolean(ch)) 
            return;
        Ext.each(this.childNodes, function(n){
            n.getUI().toggleCheck(ch);
            n.cascadeChildren();
        });
    },
    
    /**
     * 全选或全不选所有结点，必须所有结点都有checked属性
     * @param {Boolean} checked
     */
    checkAllNodes : function(checked){
        this.root.attributes.checked = checked;
        this.root.cascadeChildren();
    },
    
    /**
     * 根据nodes数组加载选中节点
     * @param {Object} nodes node或id数组
     */
    loadCheckedNodes : function(nodes){
        this.checkAllNodes(false);
        Ext.each(nodes, function(n){
            if (Ext.isString(n)) {
                n = this.getNodeById(n);
            }
            n.getUI().toggleCheck(true);
        }, this);
    },
    
    /**
     * 重新加载授权的数据
     * 入参：ObjectType 优先级类别,
     * 		ObjectReference 类别中的id
     */
    loadAuthorizeTree : function(ObjectType,ObjectReference){
    	this.ObjectType = ObjectType;
    	this.ObjectReference = ObjectReference;
    	this.loader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
    	this.store.load({params:{start:0,limit:this.pageSize}}); //加载数据
    },
    
    /**
     * 保存授权数据
     */
    saveAuthorizeData : function(){
		if(typeof(this.ObjectReference)=="undefined"||this.ObjectReference==null){
			Ext.Msg.alert("提示","没有选中授权类别!");
			return false;
		}
		
		var str = "";
		var f  = function(node) {
			if (node.id=="menuTreeRoot") return;
			var flag = node.attributes.checked;
			var check = "";
			if(flag==true) {
				check = 1;
			}else {
				check = 0;
			}
			if (str!="") str=str+"^";
			str=str+node.id+"!"+check;
		}
		this.getRootNode().cascade(f);
		str = "IDS:" + str;
		//保存改动后的数据
		rtn = tkMakeServerCall(this.saveAutClass,this.saveAutMethod,this.ObjectType,this.ObjectReference,str);
		var rtn = rtn.replace(/\r\n/g,"");
		try{ var obj = Ext.decode(rtn); }catch(e){ alert("操作失败!"); return; }
		if (obj.msg == "0") {
			Ext.Msg.show({
				title : '提示',
				msg : '保存成功!',
				minWidth : 150,
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK
			});
			return true;
		}else {
			Ext.Msg.show({
				title : '提示',
				msg : '保存失败!<br>代码:' + obj.msg,
				minWidth : 150,
				icon : Ext.Msg.ERROR,
				buttons : Ext.Msg.OK
			});
			return false;
		}
	}
});

Ext.reg('bdptreepanel', Ext.BDP.Component.tree.TreePanel);

/**
 * @class Ext.BDP.Component.DataAutPanel
 * @extends Ext.Panel
 * @author 2014-2-11 by 李森
 * 说明：
 * 		增加应用级别授权
 * 		授权数据格式为："limited 1 or 0" # "bitmap"
 * 		limited  1:受限 0:不受限 空:不受限
 */
Ext.BDP.Component.DataAutPanel = Ext.extend(Ext.Panel, {
	layout:'border',
	//title : Ext.BDP.FunLib.getParam('ObjectType')=='G'?'安全组：'+Ext.BDP.FunLib.getParam('ObjectReferenceText'):(Ext.BDP.FunLib.getParam('ObjectType')=='L'?'科室：'+Ext.BDP.FunLib.getParam('ObjectReferenceText'):'用户：'+Ext.BDP.FunLib.getParam('ObjectReferenceText')),
	//iconCls : Ext.BDP.FunLib.getParam('ObjectType')=='G'?'icon-book':(Ext.BDP.FunLib.getParam('ObjectType')=='L'?'icon-LoginLoc':'icon-user'),
	
	dataUrl : '',
	ObjectType : '',
	ObjectReference : '',
	pageSize : '',
	AutClass : '',
	AutCode : '',
	getAutMethod : '', //"GetLimited()"
	saveAutMethod : '',
	
	initComponent : function(){
        Ext.BDP.Component.DataAutPanel.superclass.initComponent.call(this);
        
        this.myTree = new Ext.BDP.Component.tree.TreePanel({
		        region : "center",
		        dataUrl : this.dataUrl, //页面初始化时加载数据
		        ObjectType : this.ObjectType,
				ObjectReference : this.ObjectReference,
				AutCode : this.AutCode,
		        pageSize : this.pageSize, //分页大小,默认为0,为0时不分页
		        getAutClass : this.AutClass, //获取授权数据类名称
		        getAutMethod : this.getAutMethod, //获取授权数据方法
		        saveAutClass : this.AutClass, //保存授权数据类名称
		        saveAutMethod : this.saveAutMethod //保存授权数据方法
		    });
		this.add(this.myTree);
		
		this.myTBar = new Ext.Toolbar({
				items : [{
						xtype:'panel',
						baseCls:'x-plain',
						height:30,
						items:[{
								xtype : 'radiogroup',
								columns: [70,55,70,100],
								defaultType:'radio',
								items:[{
				            		id : 'radioLimit0',
				            		boxLabel : "不受限",
				            		name : 'limited',
				            		inputValue : '0',
				            		listeners : {
						            	'check' : function(com, checked){
						            		if(checked){
						            			this.radioOnCheck(com, checked);
						            		}
						            	},
						            	scope : this
						            }
					            },{
									id : 'radioLimit1',
									//xtype : 'checkbox',
									boxLabel : '受限',
									name : 'limited',
									inputValue : '1',
									listeners : {
						            	'check' : function(com, checked){
						            		if(checked){
						            			this.radioOnCheck(com, checked);
						            		}
						            	},
						            	scope : this
						            }
								}, {
		                            id : 'radioLimit4',   //update20220722增加状态——未授权
		                            boxLabel : "未授权",
		                            name : 'limited',
		                            inputValue : '3',
		                            //checked : true,
		                            listeners : {
		                                'check' : function(com, checked){
		                                    if(checked){
		                                        this.radioOnCheck(com, checked);
		                                    }
		                                },
		                                scope : this
		                            }
		                        }, {
				            		id : 'radioLimit2',
				            		boxLabel : "登录角色科室",
				            		//xtype : 'checkbox',
				            		name : 'limited',
				            		inputValue : '2',
				            		//checked : true,
				            		hidden:(this.AutCode=="CT_Loc"?false:true),
				            		listeners : {
						            	'check' : function(com, checked){
						            		if(checked){
						            			this.radioOnCheck(com, checked);
						            		}
						            	},
						            	scope : this
						            }
						        
				            	}],
				            	
					            listeners : {
					            	'afterrender' : function(com){
					            		Ext.get('radioLimit0').dom.checked = true;
					            		var domRadioLable1 = Ext.getCmp('radioLimit0').getEl().dom.parentNode.lastChild;
					            		var domRadioLable2 = Ext.getCmp('radioLimit1').getEl().dom.parentNode.lastChild;
					            		domRadioLable1.setAttribute('ext:qtip','可以访问该菜单所有数据（关联界面授权过的数据除外）');
					            		domRadioLable2.setAttribute('ext:qtip','仅可以访问所勾选并且关联界面授权可以显示的数据。');
					            		
					            		var domRadioLable4 = Ext.getCmp('radioLimit4').getEl().dom.parentNode.lastChild;     //update20220722增加状态——未授权
					            		domRadioLable4.setAttribute('ext:qtip','没有对应的授权数据，默认可以访问该菜单所有数据（关联界面授权过的数据除外）');
					            		var AutJson = tkMakeServerCall(this.AutClass,this.getAutMethod,this.ObjectType,this.ObjectReference);
										if(AutJson!=""){
											var flagLimited = AutJson;
											if(flagLimited=='0'){ //不受限
												Ext.getCmp('radioLimit0').setValue(true);
											}
											if(flagLimited=='1'){ //自定义
												Ext.getCmp('radioLimit1').setValue(true);
											}
										}
										else{ //未授权
											Ext.getCmp('radioLimit4').setValue(true); //update20220722增加状态——未授权
	    									this.myTree.setDisabled(true);
										}
					            	},
					            	scope : this
					            }
		            	}
		            	]}, '->', {
						xtype : 'tbtext',
						id : 'showState',
						text : '<img style="width:12px;height:12px;" src="'+ Ext.BDP.FunLib.Path.URL_Icon +'accept.png" />'
									+ '<font style="color:green;">当前为不受限状态，可以访问该菜单所有数据（关联界面授权过的数据除外）。</font>'
					}]
			});
		this.tbar = this.myTBar;
        
		this.addEvents(
        
            'bodyresize',
            
            'titlechange',
            
            'iconchange',
            
            'collapse',
            
            'expand',
            
            'beforecollapse',
            
            'beforeexpand',
            
            'beforeclose',
            
            'close',
            
            'activate',
            
            'deactivate'
        );

        if(this.unstyled){
            this.baseCls = 'x-plain';
        }

        this.toolbars = [];
        
        if(this.tbar){
            this.elements += ',tbar';
            this.topToolbar = this.createToolbar(this.tbar);
            this.tbar = null;

        }
        if(this.bbar){
            this.elements += ',bbar';
            this.bottomToolbar = this.createToolbar(this.bbar);
            this.bbar = null;
        }

        if(this.header === true){
            this.elements += ',header';
            this.header = null;
        }else if(this.headerCfg || (this.title && this.header !== false)){
            this.elements += ',header';
        }

        if(this.footerCfg || this.footer === true){
            this.elements += ',footer';
            this.footer = null;
        }

        if(this.buttons){
            this.fbar = this.buttons;
            this.buttons = null;
        }
        if(this.fbar){
            this.createFbar(this.fbar);
        }
        if(this.autoLoad){
            this.on('render', this.doAutoLoad, this, {delay:10});
        }
	},
	afterRender : function(){
		if(this.floating && !this.hidden){
            this.el.show();
        }
        if(this.title){
            this.setTitle(this.title);
        }
        Ext.Panel.superclass.afterRender.call(this); 
        if (this.collapsed) {
            this.collapsed = false;
            this.collapse(false);
        }
        this.initEvents();
    },
    radioOnCheck : function(com, checked){
		var AutJson = tkMakeServerCall(this.AutClass,this.getAutMethod,this.ObjectType,this.ObjectReference);
		//alert(AutJson)
		if(AutJson!=""){
			var flagLimited = AutJson;
			if(flagLimited=='1'){ //受限
				var str = "limited:1";
			}else{
				var str = "limited:0";
			}
		}else{
			var str = "";
		}
		//设置授权状态图标和说明
		this.setShowState(checked);
		
		if(checked){
			if(com.id=='radioLimit0'){
				var lmd = 0;
				this.myTree.setDisabled(true);
				this.setShowState('0');
			}
			if(com.id=='radioLimit1'){
				var lmd = 1;
				this.myTree.setDisabled(false);
				this.setShowState('1');
			}
			if(com.id=='radioLimit4'){           //update20220722 增加状态——未授权
                var lmd = "";
                this.myTree.setDisabled(true);
                this.setShowState('3');
                //this.myTree
                Ext.getCmp('checkall').setValue(false);
                var nodes=this.myTree.getChecked();
                if(nodes && nodes.length){
                	for(var i=0;i<nodes.length;i++){
                		//设置UI状态为未选中状态
                		nodes[i].getUI().toggleCheck(false);
                		//设置节点属性为未选中状态
                		nodes[i].attributes.checked=false;
                	}
                }

            }
			
			
			var changedflag=0
            if (flagLimited!=lmd)   //radio发生改变
            {
                changedflag=1
                if(changedflag==1)  
                {
                    if(com.id!='radioLimit4'){   //非未授权状态
                    	var str = "limited:" + lmd 
                        //保存改动后的数据
						var rtn = tkMakeServerCall(this.AutClass,this.saveAutMethod,this.ObjectType,this.ObjectReference,str);

                    }else{      //未授权状态
                        //未授权时，删除对应授权数据
                        var rowid= tkMakeServerCall("web.DHCBL.BDP.Authorize","DHCGetRowIDForBD",this.ObjectType,this.ObjectReference,"BD",this.AutCode);
                        if (rowid!=""){
                            var result= tkMakeServerCall("web.DHCBL.BDP.BDPPreferences","DeleteData",rowid);
                        }
                            
                    }
                }
            }
		}
	},
    setShowState : function(v){
    	var comShowState = Ext.getCmp('showState');
    	if (v=='0')
    	{
    		comShowState.setText('<img style="width:12px;height:12px;" src="'+ Ext.BDP.FunLib.Path.URL_Icon +'accept.png" />'
    						+ '<font style="color:green;">当前为不受限状态，可以访问该菜单所有数据（关联界面授权过的数据除外）。</font>');
    	}
    	if(v=='1')
    	{
    		comShowState.setText('<img style="width:12px;height:12px;" src="'+ Ext.BDP.FunLib.Path.URL_Icon +'stop.png" />'
    						+ '<font style="color:red;">当前为受限状态，仅可以访问所勾选并且关联界面授权可以显示的数据。</font>');
    	}
    	if(v=='3'){
            comShowState.setText('<div style="text-align:right;">'
                            + '<img style="width:12px;height:12px;" src="'+ Ext.BDP.FunLib.Path.URL_Icon +'accept.png" />'
                            + '<font style="color:green;">没有对应的授权数据，默认可以访问该菜单所有数据（关联界面授权过的数据除外）。</font></div>');
        }
    }
});