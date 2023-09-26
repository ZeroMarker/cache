///GR0033 �豸������ ͼƬ�ϴ� �ο�demo-��������ƽ̨ҳ��
///����jsִ��Ч�ʵ���ʱ��ɾ������˵��Զ���ѯͼƬ�������ݹ��̵���ش���
//����csp��dhceq.process.picturemenu.csp
//=========================================��ʼ������================================
var CurrentSourceType=GetQueryString("CurrentSourceType")
var CurrentSourceID=GetQueryString("CurrentSourceID")
var EquipDR=GetQueryString("EquipDR")
var Status=GetQueryString("Status") //����״̬ ����,�ύ,���
var ReadOnly=GetQueryString("ReadOnly")
var PicType="-1" //���ҽ���ҳ���ʼ��ʱֵΪ-1��ҳ��ˢ��ʱ���õ�
//===============================================================
Ext.onReady(function(){
	
///////////////Tab�Ҽ��رղ˵�///////////////////////////////////////
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
    closeTabText: '�رյ�ǰ����',

    /**
     * @cfg {String} closeOtherTabsText
     * The text for closing all tabs except the current one. Defaults to <tt>'Close Other Tabs'</tt>.
     */
    closeOtherTabsText: '�ر���������',
    
    /**
     * @cfg {Boolean} showCloseAll
     * Indicates whether to show the 'Close All' option. Defaults to <tt>true</tt>. 
     */
    showCloseAll: true,

    /**
     * @cfg {String} closeAllTabsText
     * <p>The text for closing all tabs. Defaults to <tt>'Close All Tabs'</tt>.
     */
    closeAllTabsText: '�ر����д���',
    
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
	
	/** ������ */
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"west",
			//title:"<div style='text-align:center'>��ӭ�����������ƽ̨</div>",
			title:"ͼƬ¼������ƽ̨",
			//title:'<marquee scrollamount="2" scrolldelay="75">ͼƬ¼������ƽ̨</marquee>',
			autoScroll:true,
			split:true,
			collapsible:true, //�Զ�������ť
			border:true,
			width:150,
			minSize: 150,
			maxSize: 230,
			//margins:'0 0 5 5',
			//cmargins:'0 5 5 5',
			//lines:false,
	    	layout:"accordion",//�۵�����
	    	//extraCls:"roomtypegridbbar",
			//iconCls:'icon-feed', 
	 		//��Ӷ���Ч��
			layoutConfig: {animate: true},
			items:[]
		});
	//var SessionStr=Ext.dhceq.config.Session();
	//var menusJson = tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetMainMenu",CurrentSourceType);
	var menusJson ='[{"id":"0","text":"ͼƬ����","icon":"","leaf":false}]'
	
	if (menusJson=="") return;//"[{"id":"2","text":"��������ά��","icon":"","leaf":false},{"id":"1","text":"ϵͳ����","icon":"","leaf":false}]"
	window.eval("var menuArray = " + menusJson);
	loadMenu(menuArray,westpanel);
	
	/*
	Ext.Ajax.request({
		url: LOADMENU_URL + '?&actiontype=getpicturetypemenu&id=&PicSourceType=0&CurrentSourceID=10660',
		method : 'post',
		waitMsg: '������...',
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
					//checkModel: 'cascade',    //(����ʹ����������)�����ļ�����ѡ   
     				//onlyLeafCheckable: true,//�������н�㶼��ѡ  
					border:false,
					animate:true,
					//EnableDD:true, //EnableDD="true" �ſ�ʵ��ѡ��ȫ���ӽ��
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
		            lines:true, //����
		            autoScroll:true,
		            root: /*new Ext.tree.AsyncTreeNode({//�첽
			            		
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
						//��ʼ���˵�ʱ�Զ��������Ҽ���ͼƬ�������� 
						this.root.expand("","",this.getPicType,this)
						//this.loader.load(this.root,this.getPicType,this)   
							//tree.expandAll();//չ����
							//this.getPicType() 
							//arguments �����Ѿ��ɼ�
							//if(this.fireEvent("beforeload",this)===false)
						} 
		            },
		            //�����ӽڵ�ѡ��״̬
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
					//���ýڵ㸸�ڵ�ѡ��״̬
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
					//����ͼƬ����Ϣ��Ϣ
					getPicType:function(){
						var b = tree.getChecked();
              			var checkid = new Array;// ���ѡ��id������
              			for (var i = 0; i < b.length; i++) {
                  			checkid.push(b[i].id);// ���id������
              			}
              			//window.frames['picture'].document.getElementById("PicPicType").value=checkid.toString()
              			//PictureGrid
              			//PictureGridDs.load({params:{start:0,limit:PicturePagingToolbar.pageSize,CurrentSourceType:CurrentSourceType,CurrentSourceID:CurrentSourceID,vData:"^^^^^"+window.parent.PicType}});
              			PicType=checkid.toString()
              			//�������ӳٸ�ʱ,���������佫����picture.js�ļ����������
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
	   
	/** ����TabPanel�ĺ��� */
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
	
	/** ��ʼ��TabPanel */
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
                	title:"ͼƬ������¼��",
					//html:"Welcome"
					html : "<iframe name='picture' src='dhceq.process.picture.csp?&CurrentSourceType="+CurrentSourceType+"&CurrentSourceID="+CurrentSourceID+"&EquipDR="+EquipDR+"&Status="+Status+"&ReadOnly="+ReadOnly+"' width='100%' height='100%' frameborder='0' scrolling='auto'></iframe>"
                }]
		});
	
	/** ���� */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab]
    	});
	
});