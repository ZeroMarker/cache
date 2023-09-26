
Ext.onReady(function(){
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.QuickTips.init();
	/** ������ */
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"west",
			title:'<marquee scrollamount="2" scrolldelay="75" width="187">��ӭ�� '+session['LOGON.USERNAME']+'</marquee>',
			//autoScroll:true,
			split:true,
			collapsible:true, //�Զ�������ť
			border:true,
			width:220,
			minSize: 220,
			maxSize: 300,
	    	layout:"accordion",
			layoutConfig: {animate: true},
			items:[]
		});
	// ��ȡһ���˵�JSON
	var menusJson = tkMakeServerCall("web.DHCSTM.Menu","ShowBarJson","1");
	if (menusJson=="") return;
	var menuArray = Ext.decode(menusJson);
	loadMenu(menuArray,westpanel);
	
	
	function SetKeepOpen(url,newwin) {
		parent.keepopen=true;	
		parent.location.href=url;
	}	
	function loadMenu(menuArray,westpanel){
		 for(var intRow = 0; intRow < menuArray.length; intRow ++){		
			var menuObj = menuArray[intRow];
			var proPanel = new Ext.Panel({
				title:menuObj.text,
				id:menuObj.id,			
				autoScroll:true,
				collapsed:true,
				menuObj:menuObj,
				firstClick: true,
				listeners:{"beforeexpand":function(p, animate){																							
						if(!p.firstClick) return ;
						var menuObj = p.menuObj;					
						var tree = new Ext.tree.TreePanel({
							border:false,
							animate:true,
							enableDD:false,
							containerScroll:true,
							loader: new Ext.tree.TreeLoader({nodeParameter : "id" ,dataUrl:"dhcstm.mainaction.csp?actiontype=GetMenu"}),
							rootVisible:menuObj.leaf,
							lines:true,
							autoScroll:true,
							root: new Ext.tree.AsyncTreeNode({
								text: menuObj.text,		                          
								id: menuObj.id,
								href:menuObj.href,
								hrefTarget:menuObj.hrefTarget,
								leaf:menuObj.leaf,
								cls:menuObj.cls,
								expanded: menuObj.leaf
							}),
							listeners:{
								"click":function(node,event){
									if (node.isLeaf()){
										addtab(node)
									}else{
										node.expand(!node.isExpanded());
									}
								}
							}
						});
						
						p.firstClick  = false;
						p.add(tree);
					}
				}			
			});
			westpanel.add(proPanel);
		}
	}

	/** ����TabPanel�ĺ��� */
    var addtab = function(node){
	    	if (!node.isLeaf()) return;
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+node.id;
			var iframeId = "iframe_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (!obj){ //�ж�tab�Ƿ��Ѵ�
	    		var url = node.attributes.myhref;   //��Ҫ��href  ���Զ���ת
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text,
	            	tabTip:node.text,
	            	iconCls:node.attributes.iconCls,
	            	html:"<iframe name='"+iframeId+"' frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
	            	closable:true,
					listeners : { 'beforeclose': function() {
						var ifclose=false;
						var iframeid = "iframe_"+node.id;
						var viewport = window.frames[iframeid].Ext.getCmp("mainPanel");
						if(viewport){
							var grid = viewport.findByType('grid')[0];
							if(grid){
								var gridEdit = isDataChanged("",grid);
								if(gridEdit){
									Ext.MessageBox.show({
										title : "ȷ�Ϲر�",
										msg :"ȷ�Ϲرո�ҳ�棿",
										buttons : Ext.Msg.YESNO,
										icon : Ext.Msg.WARNIN,
										fn : function(btn) {
											if (btn == 'yes') {
												tabs.remove(Ext.getCmp(tabId));
												ifclose = true;
												return true;	
											}
										}
									}); 
									return ifclose;
								}else{
									return true;
								}
							}else{
								return true;
							}
						}else{
							return true;
						}
					}}
	      		});
	    	}
	    	obj.show();	//��ʾtabҳ
	    };	
	
	/** ��ʼ��Home TabPanel */
	var centertab =  new Ext.TabPanel({
                id:'main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
                resizeTabs:true,
                plugins: new Ext.ux.TabCloseMenu(), //�Ҽ��رղ˵�
                items:[{
                	title:"Home",
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                }]
		});
	
	/** ���� */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab] 
    	});
    	
	if(menuArray){
		Ext.getCmp(menuArray[0].id).expand();
	}
});