Ext.namespace("Ext.BDP.Component");
Ext.namespace("Ext.BDP.Component.tree");


Ext.BDP.Component.tree.TreeLoaderStore = Ext.extend(Ext.data.Store,{
	loader : null,
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
 * 说明：
 * 		树JSON格式为：{data:[ {},"children":{data:[{},{}]} ],totalCount:2}
 */
Ext.BDP.Component.tree.TreePanel = Ext.extend(Ext.tree.TreePanel, {
	autoScroll : true,
    rootVisible : false,
    animate : true,
    enableDD : true,
    containerScroll : true,
    height : Ext.getBody().getHeight(),
	pageSize : 0, //分页大小,为0时不分页
	disToolbar : true, //是否显示工具条
	Type : '',
    
	initComponent : function(){
        Ext.BDP.Component.tree.TreePanel.superclass.initComponent.call(this);
        this.root = new Ext.BDP.Component.tree.AsyncTreeNode({
	         id:"TreeRoot",
	         text: '数据',
	         expanded :true,
	         draggable:false
	    });
	    this.loader = new Ext.BDP.Component.tree.TreePagingLoader({
	    	nodeParameter: "ParentID",
			dataUrl:this.dataUrl,
			baseParams : {Type:this.Type}
		});
		var loadmark = null;
        this.loader.on({ //避免分页点击过快时，分页参数传递两次，获取数据重复显示
	       'beforeload' : function(){
	           loadmark = new Ext.LoadMask(Ext.getBody(),{
	              msg : '数据加载中,请稍后...',
	              removeMask : true //完成后移除
	            });
	            //loadmark.show();
	       }, //加载前
	       'load' : function(){
	       		//loadmark.hide(); //加载完成后
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
					items : ["检索:",new Ext.form.TextField({
						id : 'TreeSearchText',
						emptyText : '请输入查找内容'/*,
						enableKeyEvents : true,
						listeners : {
							keyup : function(field, event) {
								this.doQuery();
							},
							scope : this
						}*/
					}), '-', new Ext.Button({
						iconCls : 'icon-search',
						handler : function(){
							this.doQuery();
						},
						scope : this
					}), '-', new Ext.Button({
						iconCls : 'icon-refresh',
						handler : function(){
							Ext.getCmp('TreeSearchText').setValue('');
							this.doQuery();
						},
						scope : this
					})]
				});
			this.elements += ',tbar';
	        this.topToolbar = this.createToolbar(this.tbar);
	        this.tbar = null;
	        /*var keymap = new Ext.KeyMap(document, {
							key:Ext.EventObject.ENTER, *//**按钮转换功能，将enter键转换为tab键。当为button时不进行按键的转换**//*
							fn:  function changeFocus() {
									if(event.keyCode==13 && event.srcElement.type!='button') {
							      		event.keyCode=9; //tab
							      	}
							    }
						});*/
		}
		/**分页工具条*/
		if(this.pageSize){
			this.store.load({params:{start:0,limit:this.pageSize}}); //加载数据
			this.pageTb = new Ext.PagingToolbar({
                store : this.store,
                pageSize : this.pageSize,
                displayInfo: true
            });
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
    	var v = Ext.getCmp('TreeSearchText').getValue();
    	//从服务器端查询数据,思路是把查询条件query传到服务器端,由服务器返回查询后的树。
    	//后台方法还有缺陷,目前只能检索叶子节点。
    	Ext.apply(this.loader.baseParams,{query:v}); //添加参数query。
    	this.store.load({params:{start:0,limit:this.pageSize}}); //加载数据
    },
    /**
     * 重新加载数据
     */
    loadTree : function(Type,hospid){
    	this.Type = Type;
		this.hospid = hospid;
    	this.loader.baseParams = {
			Type:Type,
			hospid:hospid
		};
    	this.store.load({params:{start:0,limit:this.pageSize}}); //加载数据
    }
});