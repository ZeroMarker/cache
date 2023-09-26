///GR0033 设备管理组 图片上传 参考demo-基础数据平台页面
///当此js执行效率低下时，删除点击菜单自动查询图片主表数据过程的相关代码
//关联csp：dhceq.process.picturemenu.csp
//=========================================初始化数据================================
var CurrentSourceType=GetQueryString("CurrentSourceType")
var CurrentSourceID=GetQueryString("CurrentSourceID")
var EquipDR=GetQueryString("EquipDR")
var Status=GetQueryString("Status") //单据状态 新增,提交,审核
var ReadOnly=GetQueryString("ReadOnly")
var PicType="-1" //当且仅当页面初始化时值为-1，页面刷新时会用到
//===============================================================
Ext.onReady(function(){
	
///////////////Tab右键关闭菜单///////////////////////////////////////
/**
 * @class Ext.ux.TabCloseMenu
 * @extends Object 
 * Plugin (ptype = 'tabclosemenu') for adding a close context menu to tabs. Note that the menu respects
 * the closable configuration on the tab. As such, commands like remove others and remove all will not
 * remove items that are not closable.
 * 
 * @constructor
 * @param {Object} config The configuration options
 * @ptype tabclosemenu
 */
Ext.ux.TabCloseMenu = Ext.extend(Object, {
    /**
     * @cfg {String} closeTabText
     * The text for closing the current tab. Defaults to <tt>'Close Tab'</tt>.
     */
    closeTabText: '关闭当前窗口',

    /**
     * @cfg {String} closeOtherTabsText
     * The text for closing all tabs except the current one. Defaults to <tt>'Close Other Tabs'</tt>.
     */
    closeOtherTabsText: '关闭其他窗口',
    
    /**
     * @cfg {Boolean} showCloseAll
     * Indicates whether to show the 'Close All' option. Defaults to <tt>true</tt>. 
     */
    showCloseAll: true,

    /**
     * @cfg {String} closeAllTabsText
     * <p>The text for closing all tabs. Defaults to <tt>'Close All Tabs'</tt>.
     */
    closeAllTabsText: '关闭所有窗口',
    
    constructor : function(config){
        Ext.apply(this, config || {});
    },

    //public
    init : function(tabs){
        this.tabs = tabs;
        tabs.on({
            scope: this,
            contextmenu: this.onContextMenu,
            destroy: this.destroy
        });
    },
    
    destroy : function(){
        Ext.destroy(this.menu);
        delete this.menu;
        delete this.tabs;
        delete this.active;    
    },

    // private
    onContextMenu : function(tabs, item, e){
        this.active = item;
        var m = this.createMenu(),
            disableAll = true,
            disableOthers = true,
            closeAll = m.getComponent('closeall');
        
        m.getComponent('close').setDisabled(!item.closable);
        tabs.items.each(function(){
            if(this.closable){
                disableAll = false;
                if(this != item){
                    disableOthers = false;
                    return false;
                }
            }
        });
        m.getComponent('closeothers').setDisabled(disableOthers);
        if(closeAll){
            closeAll.setDisabled(disableAll);
        }
        
        e.stopEvent();
        m.showAt(e.getPoint());
    },
    
    createMenu : function(){
        if(!this.menu){
            var items = [{
                itemId: 'close',
                text: this.closeTabText,
                scope: this,
                handler: this.onClose
            }];
            if(this.showCloseAll){
                items.push('-');
            }
            items.push({
                itemId: 'closeothers',
                text: this.closeOtherTabsText,
                scope: this,
                handler: this.onCloseOthers
            });
            if(this.showCloseAll){
                items.push({
                    itemId: 'closeall',
                    text: this.closeAllTabsText,
                    scope: this,
                    handler: this.onCloseAll
                });
            }
            this.menu = new Ext.menu.Menu({
                items: items
            });
        }
        return this.menu;
    },
    
    onClose : function(){
        this.tabs.remove(this.active);
    },
    
    onCloseOthers : function(){
        this.doClose(true);
    },
    
    onCloseAll : function(){
        this.doClose(false);
    },
    
    doClose : function(excludeActive){
        var items = [];
        this.tabs.items.each(function(item){
            if(item.closable){
                if(!excludeActive || item != this.active){
                    items.push(item);
                }    
            }
        }, this);
        Ext.each(items, function(item){
            this.tabs.remove(item);
        }, this);
    }
});

Ext.preg('tabclosemenu', Ext.ux.TabCloseMenu);
////////////////////////////////////////////////////////////////
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	var LOADMENU_URL = "../csp/dhceq.process.picturemenuaction.csp?&actiontype=GetPicTypeMenu&CurrentSourceType="+CurrentSourceType+"&CurrentSourceID="+CurrentSourceID;
	
	/** 左侧面板 */
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"west",
			//title:"<div style='text-align:center'>欢迎进入基础数据平台</div>",
			title:"图片录入数据平台",
			//title:'<marquee scrollamount="2" scrolldelay="75">图片录入数据平台</marquee>',
			autoScroll:true,
			split:true,
			collapsible:true, //自动收缩按钮
			border:true,
			width:150,
			minSize: 150,
			maxSize: 230,
			//margins:'0 0 5 5',
			//cmargins:'0 5 5 5',
			//lines:false,
	    	layout:"accordion",//折叠布局
	    	//extraCls:"roomtypegridbbar",
			//iconCls:'icon-feed', 
	 		//添加动画效果
			layoutConfig: {animate: true},
			items:[]
		});
	//var SessionStr=Ext.dhceq.config.Session();
	//var menusJson = tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetMainMenu",CurrentSourceType);
	var menusJson ='[{"id":"0","text":"图片类型","icon":"","leaf":false}]'
	
	if (menusJson=="") return;//"[{"id":"2","text":"基础数据维护","icon":"","leaf":false},{"id":"1","text":"系统配置","icon":"","leaf":false}]"
	window.eval("var menuArray = " + menusJson);
	loadMenu(menuArray,westpanel);
	
	/*
	Ext.Ajax.request({
		url: LOADMENU_URL + '?&actiontype=getpicturetypemenu&id=&PicSourceType=0&CurrentSourceID=10660',
		method : 'post',
		waitMsg: '加载中...',
		success: function(response, opts) {
			//var obj = Ext.decode(response.responseText);
			//console.dir(obj);
			//messageShow("","","",response.responseText);
			window.eval("var menuArray = " + response.responseText);
			loadMenu(menuArray,westpanel);
		},
		failure: function(response, opts) {
			console.log('server-side failure with status code ' + response.status);
		},
		scope : this
	});*/
	
	function loadMenu(menuArray,westpanel){
		for(var intRow = 0; intRow < menuArray.length; intRow ++){
			var menuObj = menuArray[intRow];
			/** TreePanel */
			var tree = new Ext.tree.TreePanel({
					title: menuObj.text,
					//checkModel: 'cascade',    //(属性使用条件错误)对树的级联多选   
     				//onlyLeafCheckable: true,//对树所有结点都可选  
					border:false,
					animate:true,
					//EnableDD:true, //EnableDD="true" 才可实现选中全部子结点
					containerScroll:true,
					/*load : function(){
        				var um = this.body.getUpdater();
        				um.update.apply(um, arguments);
        				return this;
    				},*/
		            loader: new Ext.tree.TreeLoader({
		            	nodeParameter : "id",
		            	dataUrl : LOADMENU_URL
		            	//,baseParams : {SessionStr:SessionStr}
		            }),
		            //rootVisible:menuObj.leaf,
		            lines:true, //虚线
		            autoScroll:true,
		            root: /*new Ext.tree.AsyncTreeNode({//异步
			            		
	                          id: menuObj.id,
		                      text: menuObj.text,
		                      checked:false
		            }),*/
		            {
			            		
	                          id: menuObj.id,
		                      text: menuObj.text,
		                      checked:false
		            },
		            listeners:{
		            	"click":function(node,event) {
									//addtab(node);
								},
						afterrender: function(node) {
						//expand : function(deep, anim, callback, scope)
						//初始化菜单时自动产开并且加载图片主表数据 
						this.root.expand("","",this.getPicType,this)
						//this.loader.load(this.root,this.getPicType,this)   
							//tree.expandAll();//展开树
							//this.getPicType() 
							//arguments 参数已经可见
							//if(this.fireEvent("beforeload",this)===false)
						} 
		            },
		            //设置子节点选中状态
					SetChildNodeChecked:function SetChildNodeChecked(node) {
						var isChecked = node.attributes.checked;
						var childCount = node.childNodes.length;
						if (childCount > 0) {
							for (var i = 0; i < childCount; i++) {
								var child = node.childNodes[i];
								var checkBox = child.getUI().checkbox;
								child.attributes.checked = isChecked;
								checkBox.checked = isChecked;
								checkBox.indeterminate = false;
								this.SetChildNodeChecked(child);
							}
						}
					},
					//设置节点父节点选中状态
					SetParentNodeCheckState:function SetParentNodeCheckState(node) {
						var parentNode = node.parentNode;
						if (parentNode != null) {
							var checkBox = parentNode.getUI().checkbox;
							var isAllChildChecked = true;
							var someChecked = false;
							var childCount = parentNode.childNodes.length;
							for (var i = 0; i < childCount; i++) {
								var child = parentNode.childNodes[i];
								if (child.attributes.checked) {
									someChecked = true;
								}
								else if (child.getUI().checkbox.indeterminate == true && child.getUI().checkbox.checked == false) {
									someChecked = true;
									isAllChildChecked = false;
									break;
								}
								else {
									isAllChildChecked = false;
								}
							}
							if (isAllChildChecked && someChecked) {
								parentNode.attributes.checked = true;
								if (checkBox != null) {
									checkBox.indeterminate = false;
									checkBox.checked = true;
								}
							}
							else if (someChecked) {
								parentNode.attributes.checked = false;
								if (checkBox != null) {
									checkBox.indeterminate = true;
									checkBox.checked = false;
								}
							}
							else {
								parentNode.attributes.checked = false;
								if (checkBox != null) {
									checkBox.indeterminate = false;
									checkBox.checked = false;
								}
							}
						this.SetParentNodeCheckState(parentNode);
						}
					},
					//加载图片主信息信息
					getPicType:function(){
						var b = tree.getChecked();
              			var checkid = new Array;// 存放选中id的数组
              			for (var i = 0; i < b.length; i++) {
                  			checkid.push(b[i].id);// 添加id到数组
              			}
              			//window.frames['picture'].document.getElementById("PicPicType").value=checkid.toString()
              			//PictureGrid
              			//PictureGridDs.load({params:{start:0,limit:PicturePagingToolbar.pageSize,CurrentSourceType:CurrentSourceType,CurrentSourceID:CurrentSourceID,vData:"^^^^^"+window.parent.PicType}});
              			PicType=checkid.toString()
              			//当网络延迟高时,这个加载语句将慢于picture.js的加载数据语句
              			if(undefined!=window.frames['picture'].findPicture) window.frames['picture'].findPicture.handler()
              			this.SetParentNodeCheckState(this.root.childNodes[0]) 
              			//if(undefined!=window.frames['picture'].PictureGrid) window.frames['picture'].PictureGrid.store.load({params:{start:0,limit:window.frames['picture'].PicturePagingToolbar.pageSize,CurrentSourceType:window.frames['picture'].CurrentSourceType,CurrentSourceID:window.frames['picture'].CurrentSourceID,vData:"^^^^^"+PicType}});
              		}
			});
			tree.on('checkchange', function(node, checked) { 
				this.SetChildNodeChecked(node);
				this.SetParentNodeCheckState(node);
				this.getPicType()
             })
			westpanel.add(tree);
		}
	}
	   
	/** 新增TabPanel的函数 */
    var addtab = function(node){
	    	if (!node.isLeaf()) return;
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){
	    	}else{
	    		var url = node.attributes.myhref;
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text,
	            	tabTip:node.text,
	            	html:"<iframe height='100%' width='100%' src='"+url+"'/>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();
	    };	
	
	/** 初始化TabPanel */
	var centertab =  new Ext.TabPanel({
                id:'main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
                //margins:'0 5 5 0',
                resizeTabs:true,
                //tabWidth:150
                plugins: new Ext.ux.TabCloseMenu(),
                items:[{
                	title:"图片查找与录入",
					//html:"Welcome"
					html : "<iframe name='picture' src='dhceq.process.picture.csp?&CurrentSourceType="+CurrentSourceType+"&CurrentSourceID="+CurrentSourceID+"&EquipDR="+EquipDR+"&Status="+Status+"&ReadOnly="+ReadOnly+"' width='100%' height='100%' frameborder='0' scrolling='auto'></iframe>"
                }]
		});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab]
    	});
	
});