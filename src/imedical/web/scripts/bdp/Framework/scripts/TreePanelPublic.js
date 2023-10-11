/**
 * @version Base on Ext3.0
 * @class Ext.BDP.Component.tree.TreePanel
 * @extends Ext.tree.TreePanel
 * @author 2016-09-19 by 高姗姗 
 * 说明：
 * 	1.树形结构封装
 *  2.扩展功能：
 *  	右键菜单(添加本级、添加下级、修改、删除)
 *  	拖拽
 *  	添加、修改、删除、拖拽操作后保留节点的展开收起状态
 * 	3.公共方法:
 * 		loadTreeAdd()   ----添加成功后调用
 * 		loadTreeOther() ----修改删除成功后调用
 *  4.使用方法：
 *	  var treePanel = new Ext.BDP.Component.tree.TreePanel({
 *		region:'center',
 *		rootId : "TreeRoot",
 *		nodeParameter :"LastLevel",
 *		dataUrl: TREE_ACTION_URL, //加载方法
 *		dragUrl: DRAG_ACTION_URL, //拖拽方法
 *		AddMethod:AddSame, //右键菜单添加本级方法
 *		comboId:"treeCombox" //下拉树id
 *	 });
 */
Ext.namespace("Ext.BDP.Component");
Ext.namespace("Ext.BDP.Component.tree");
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeFilter.js"></script>');
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
	 	Ext.apply(this.loader.baseParams),
	 	this.loader.load(this.rootNode,function(node){
	 		//node.expand();
			_self.fireEvent("load",_self,null,options);
			delete _self;
		});
		return true;
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


Ext.BDP.Component.tree.TreePanel = Ext.extend(Ext.tree.TreePanel, {
	id:"treePanel",
	autoScroll : true,
    rootVisible : false,
    animate : true,
    enableDD : true,
    containerScroll : true,
    height : Ext.getBody().getHeight(),
	disToolbar : false, //是否显示工具条
	rootId : this.rootId, //根节点id
	nodeParameter : this.nodeParameter, //后台参数
	nodeStr : '', //加载一级节点时保留节点展开收起状态传参 
	comboId:this.comboId, //弹出窗下拉树id
	expandFlag : this.expandFlag,
	
    
	initComponent : function(){
		
        Ext.BDP.Component.tree.TreePanel.superclass.initComponent.call(this);
        this.root = new Ext.BDP.Component.tree.AsyncTreeNode({
	         id:this.rootId,
	         expanded :true,
	         draggable:false
	    });
	    this.loader = new Ext.tree.TreeLoader({
	    	nodeParameter: this.nodeParameter,
			dataUrl:this.dataUrl
		});
		var loadmark = null;
        this.loader.on({
	       'beforeload' : function(){
	           loadmark = new Ext.LoadMask(Ext.getBody(),{
	              msg : '数据加载中,请稍后...',
	              removeMask : true //完成后移除
	            });
	            loadmark.show();
	       }, //加载前
	       'load' : function(){
	       		loadmark.hide(); //加载完成后
	       },
	       scope:this
        });
        if(!this.eventModel){
            this.eventModel = new Ext.tree.TreeEventModel(this);
        }
        this.nodeHash = {};
       	this.store = new Ext.BDP.Component.tree.TreeLoaderStore({
			rootNode : this.root,
			loader : this.loader
		});
		/**搜索工具条*/
		if(this.disToolbar){
			this.tbar = new Ext.Toolbar({
				items : ['查找:', new Ext.form.TextField({
					id : 'TreeSearchText',
					emptyText : '请输入查找内容'
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
						
						this.doQuery();
					},
					scope : this
				})]
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
		
		this.store.load(); //加载数据
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
        /**拖拽功能*/
        this.on('movenode',function(panel, node , oldParent , newParent , index){
        	var orderstr=""
        	var childnodes=newParent.childNodes; 
	    	for(var i=0;i<childnodes.length;i++)
	    	{
	    		var rootnode = childnodes[i];
	    		if (orderstr!="")
	    		{
	    			var orderstr=orderstr+"^"+rootnode.id;
	    		}
	    		else
	    		{
	    			var orderstr=rootnode.id;
	    		}
	    	}
        	Ext.Ajax.request({
				url : this.dragUrl , 		
				method : 'POST',	
				params : {
						'id' : node.id,
						'parentid' : newParent.id,
						'orderstr' : orderstr
				},
				callback : function(options, success, response) {	
					if(success){
						var jsonData = Ext.util.JSON.decode(response.responseText);
						if (jsonData.success == 'true') {
							/*Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:this.nodeStr});
							this.store.load();*/
						}else{
							var errorMsg ='';
							if(jsonData.info){
								errorMsg='<br />'+jsonData.info
							}
							Ext.Msg.show({
								title:'提示',
								msg:errorMsg,
								minWidth:210,
								icon:Ext.Msg.ERROR,
								buttons:Ext.Msg.OK
							});
						}
					}
				}								
			})
        });
        this.on('beforeexpand',function(p){
        	//this.flag=1;
        })
        /**节点收起设置节点状态参数*/
        this.on('collapsenode',function(node){
        	/*if (flag=1){
        		if (this.nodeStr!=""){
			 		this.nodeStr=this.nodeStr+"^<"+node.id+">";
			 	}else{
			 		this.nodeStr="<"+node.id+">";
			 	}
        	}else{
        		this.nodeStr=this.nodeStr.replace("<"+node.id+">","");
        	}*/
        	if (this.expandFlag==1){
        		this.nodeStr=this.nodeStr.replace("<"+node.id+">","");
        	}else{
        		if (this.nodeStr.indexOf("<"+node.id+">")<0){
			 		this.nodeStr=this.nodeStr+"<"+node.id+">";
        		}
        	}
        });
        /**节点展开设置节点状态参数*/
        this.on('expandnode',function(node){
        	/*if (flag=1){
        		this.nodeStr=this.nodeStr.replace("<"+node.id+">","");
        	}else{
        		if (this.nodeStr!=""){
			 		this.nodeStr=this.nodeStr+"^<"+node.id+">";
			 	}else{
			 		this.nodeStr="<"+node.id+">";
			 	}
        	}*/
        	if (this.expandFlag==1){
			 	if (this.nodeStr.indexOf("<"+node.id+">")<0){
			 		this.nodeStr=this.nodeStr+"<"+node.id+">";
			 	}
        	}else{
        		this.nodeStr=this.nodeStr.replace("<"+node.id+">","");
        	}
        	
        });
        /**右键菜单*/
        this.on('contextmenu',function(node, e){
        	if(this.nodemenu==null){
			this.nodemenu=new Ext.menu.Menu({  			
				items: [
				{
		            iconCls :'icon-add',
		            handler: this.AddMethod,
		            id:'menuAddSame',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddSame'),
		            text: '添加本级'
		        },{
		            iconCls :'icon-add',
		            handler: AddData,
		            id:'menuAddData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
		            text: '添加下级'
		        },{
		            iconCls :'icon-Update',
		            handler: UpdateData,
		             id:'menuUpdateData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuUpdateData'),
		            text: '修改'
		        },{
		            iconCls :'icon-delete',
		            handler: DelData,
		            id:'menuDelData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDelData'),
		            text: '删除'
		         },{
		            iconCls :'icon-refresh',
		            handler: Refresh,
		            id:'menuRefresh',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuRefresh'),
		            text: '重置'
		        }]     	
			}); 
			}
			this.nodemenu.showAt(e.getXY());//menu的showAt，不要忘记
			this.getSelectionModel().select(node);
        });
    },
    
    /**检索*/
    doQuery : function(){
    	var v = Ext.getCmp('TreeSearchText').getValue();
			
    	//从服务器端查询数据,思路是把查询条件query传到服务器端,由服务器返回查询后的树。
    	//后台方法还有缺陷,目前只能检索叶子节点。
    	Ext.apply(this.loader.baseParams,{query:v}); //添加参数query。
    	this.store.load(); //加载数据
    },
    /**修改删除成功后加载*/
	loadTreeOther : function(){
    	//Ext.apply(this.loader.baseParams,{query:""}); //添加参数query。
    	//this.store.load();
    	var _record = this.getSelectionModel().getSelectedNode();
		if (_record == null) {
			Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:this.nodeStr});
			this.store.load(); 
		 } else {
		 	if (_record.parentNode.id=="TreeRoot"){
		 		Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:this.nodeStr});
				this.store.load(); 
		 	}else{
		 		var countChild=0
		 		_record.parentNode.eachChild(function(n){
		 			countChild=countChild+1;
		 		});
		 		if (countChild==1){
		 			if(_record.parentNode.parentNode.id=="TreeRoot"){ //现调用方法，解决-删除某分类文件夹的所有下级后-该分类仍以文件夹的形式显示
			 			Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:this.nodeStr});
						this.store.load(); 
			 			
			 		}else{
			 			this.getNodeById(_record.parentNode.parentNode.id).reload();
			 		}
		 		}else{
		 			this.getNodeById(_record.parentNode.id).reload();//原调用方法
		 		}
		 	}
		 }
    	/*Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:""});
		this.store.load();*/ 
		//刷新树形下拉框的数据
 		 Ext.getCmp(this.comboId).treePanel.root.reload();
 		 //清除树形列表的选中状态
 		 this.getSelectionModel().clearSelections();
    },
	
    /**添加成功后加载*/
    loadTreeAdd : function(){
    	//Ext.apply(this.loader.baseParams,{query:""}); //添加参数query。
    	//this.store.load();
    	 if (Ext.get(this.comboId).getValue() == "") {//如果上级分类为空
    		Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:this.nodeStr});
			this.store.load();
		 } else {//如果上级分类不空
		 	var _record = this.getSelectionModel().getSelectedNode();
		 	if (_record!=null){//如果选中节点 
		 		if (_record.id==Ext.getCmp(this.comboId).getValue()){ //选中行与弹窗所选父菜单一致
					this.reloadTree(_record.id,this)
		 		}else{
		 			this.reloadTree(Ext.getCmp(this.comboId).getValue(),Ext.getCmp(this.comboId).treePanel)
		 		}
		 	}else{
		 		this.reloadTree(Ext.getCmp(this.comboId).getValue(),Ext.getCmp(this.comboId).treePanel)
		 	}
		 } 
    	///注释掉以上 是因为会加载两遍同样的数据
    	/*Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:""});
		this.store.load(); */
    	//刷新树形下拉框的数据
 		Ext.getCmp(this.comboId).treePanel.root.reload();
    	this.getSelectionModel().clearSelections();
    },
    reloadTree:function(parentid,tTree){
		var parent = tTree.getNodeById(parentid); //获取选中节点的父节点
		for (i = 0; i < 6; i++) { //可以视树的层级合理设置I
			if (parent != null) {
				if (this.nodeStr.indexOf("<"+parent.id+">")<0){
		    		this.nodeStr=this.nodeStr+"<"+parent.id+">";
		    	}
				parent = parent.parentNode;
			}
		}
    	this.expandFlag=1;
    	Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:this.nodeStr});
		this.store.load(); 

	}
	
		
});

Ext.reg('bdptreepanel', Ext.BDP.Component.tree.TreePanel);
