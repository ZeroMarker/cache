/// 名称:系统配置 - 系统参数
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-4-20

	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');
	
Ext.onReady(function() {	
   
   
	/////-------------------
	var MENUTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SystemParameter&pClassMethod=GetTreeJson";
	/** 授权功能面板 */
	var menuTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter: "ParentID",
			dataUrl: MENUTREE_ACTION_URL
		});
	var menuPanel = new Ext.tree.TreePanel({
				title: '系统参数--配置项',
				region: 'west',
				width:220,
				//xtype:'treepanel',
				id: 'menuConfigTreePanel',
				expanded:true,
				split:true,
				collapsible:true, //自动收缩按钮 
				border:true,
				root: new Ext.tree.AsyncTreeNode({
						id:"menuTreeRoot",
						text:"配置项",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: menuTreeLoader,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false,
	            listeners:{
	            	"click":function(node,event) {
	            				centertab.removeAll();
								addtab(node);
							}
	            }
		});
	/** 初始化Home TabPanel */
	var URLwebsys="websys.csp";
	if ('undefined'!==typeof websys_getMWToken)
	{
		URLwebsys += "?MWToken="+websys_getMWToken() //增加token  
	}
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
               	plugins:new Ext.BDP.TabCloseMenu(),
                items:[{
                	title:"Home",
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+URLwebsys+"'></iframe>"
                }]
		});
	/** 新增TabPanel的函数 */
    var addtab = function(node){
	    	if (!node.isLeaf()) return;
	    	//if(ObjectReference == "") {Ext.Msg.alert("提示","请先选择授权类别!"); return;}
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){
	    		obj.setTitle(node.text);
	    		var url = node.attributes.myhref;
				if ('undefined'!==typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken() //增加token  
				}
	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
	    		obj.update(html);
	    	}else{
	    		var url = node.attributes.myhref;
				if ('undefined'!==typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken() //增加token  
				}
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text,
	            	tabTip:node.text,
	            	iconCls:node.attributes.iconCls,
	            	html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();	//显示tab页
	    };
	    

	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
       items:[menuPanel,centertab]
    });
	
	});