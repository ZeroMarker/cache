/// 名称: 基础数据平台
/// 描述: main
/// 编写者: 基础数据平台组-李森
/// 编写日期: 2013-4-26
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');

Ext.onReady(function(){
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	var LOADMENU_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenuDefine&pClassMethod=GetMenu";
	
	//var version =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPVersion");
	var version =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetBDPVersion");
	var desc="";
	
	
	/** 左侧面板 */
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"west",
			//title:"<div style='text-align:center'>欢迎进入基础数据平台</div>",
			title:'<marquee scrollamount="2" scrolldelay="75" width="187">欢迎您进入基础数据平台'+ version +'</marquee>',
			autoScroll:true,
			split:true,
			collapsible:true, //自动收缩按钮
			border:true,
			width:220,
			minSize: 220,
			maxSize: 300,
			//margins:'0 0 5 5',
			//cmargins:'0 5 5 5',
			//lines:false,
	    	layout:"accordion",
	    	//extraCls:"roomtypegridbbar",
			//iconCls:'icon-feed', 
	 		//添加动画效果
			layoutConfig: {animate: true},
			items:[],
			tbar:[
				    new Ext.form.TextField({
							id:'FindTreeText',
							width:160,
							emptyText:'请输入要查找菜单',
							enableKeyEvents: true,
							listeners:{
								keyup:function(node, event) {
									desc=node.getValue();
									var menusJson1 = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetMenu","menuTreeRoot",SessionStr,desc);
									if (menusJson1=="") return;
									window.eval("var menuArray1 = " + menusJson1);
									loadMenu(menuArray1,westpanel);
									openTree(menuArray1);
									//alert(node.getValue())
									//findByKeyWordFiler(node, event);
								},
								scope: this
							}
						}), {
							text:'',
							iconCls:'icon-refresh',
							handler:function(){
								Ext.getCmp('FindTreeText').reset();
								desc="";
								var menusJson2 = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetMenu","menuTreeRoot",SessionStr,desc);
									//if (menusJson=="") return;
								window.eval("var menuArray2 = " + menusJson);
									//alert(menusJson2)
								loadMenu(menuArray2,westpanel);
							}
						}
					]
		});
	var SessionStr=Ext.BDP.FunLib.Session();
	// 获取一级菜单JSON
	var menusJson = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetMenu","menuTreeRoot",SessionStr,desc);
	if (menusJson=="") return;
	window.eval("var menuArray = " + menusJson);
	loadMenu(menuArray,westpanel);
	
	/*
	Ext.Ajax.request({
		url: LOADMENU_URL + '&id=menuTreeRoot',
		method : 'post',
		waitMsg: '加载中...',
		success: function(response, opts) {
			//var obj = Ext.decode(response.responseText);
			//console.dir(obj);
			//alert(response.responseText);
			window.eval("var menuArray = " + response.responseText);
			loadMenu(menuArray,westpanel);
		},
		failure: function(response, opts) {
			console.log('server-side failure with status code ' + response.status);
		},
		scope : this
	});
	*/
	/**移除之前的菜单**/
	function removeMenu(){
		var menusJson = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetMenu","menuTreeRoot",SessionStr,"");
		if (menusJson=="") return;
		window.eval("var menuArrayn = " + menusJson);
		for(var intRow = 0; intRow < menuArrayn.length; intRow ++){		
			var menuObj = menuArrayn[intRow];
			var movepanel=Ext.getCmp("panel"+menuObj.id);
			westpanel.remove(movepanel);
		}
	}
	
	/**展开树节点**/
	function openTree(menuArray){
		for(var intRow = 0; intRow < menuArray.length; intRow ++){			
			var menuObj = menuArray[intRow];
			var treePanel=Ext.getCmp("tree"+menuObj.id);
			//treePanel.root.expand(true,true);
			treePanel.root.cascade(function(n) {
					if(n.id!='0'){
						n.ui.show();
					}
			});
		}
	}
	
	
	/** 加载菜单 */
	function loadMenu(menuArray,westpanel){
		//westpanel.removeAll();
		removeMenu();
		for(var intRow = 0; intRow < menuArray.length; intRow ++){			
			var menuObj = menuArray[intRow];
			/** TreePanel */
			var tree = new Ext.tree.TreePanel({
					id:"tree"+menuObj.id,
					border:false,
					animate:true,
					enableDD:false, //EnableDD="true" 才可实现选中全部子结点
					containerScroll:true,
		            loader: new Ext.tree.TreeLoader({
		            	nodeParameter : "id",
		            	dataUrl : LOADMENU_URL,
		            	baseParams : {
		            		SessionStr:SessionStr,
		            		desc:desc
		            	}
		            }),
		            rootVisible:menuObj.leaf,
		            lines:true, //虚线
		            autoScroll:true,
		            root: new Ext.tree.AsyncTreeNode({
	                          id: menuObj.id,	                          
		                      text: menuObj.text
		            }),
		            listeners:{
		            	"click":function(node,event) {
									addtab(node);
								}
		            }
				});
			/** 定义一级菜单panel */
			var proPanel = new Ext.Panel({
					id:"panel"+menuObj.id,
					title:menuObj.text,
					autoScroll:true,
					collapsed:true,
					items:tree,
					listeners:{
	            		"beforeexpand":function(p,a){
					         //alert(p.title);
					     }
	                }
				});
			westpanel.add(proPanel);
			westpanel.doLayout();	
		}
	}
	
	/** 新增TabPanel的函数 */
    var addtab = function(node){
	    	if (!node.isLeaf()) return;
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){ //判断tab是否已打开
	    		//刷新页面
//	    		var url = node.attributes.myhref;
//	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
//	    		obj.update(html);
	    	}else{
	    		var url = node.attributes.myhref;
	    		if ('undefined'!==typeof websys_getMWToken)
		        {
					url += "&MWToken="+websys_getMWToken() //增加token
				}
	    		var img=""
	    		if(node.attributes.icon!=""){
	    			var img="<img src='"+node.attributes.icon+ "' /> " ;
	    		}
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:img+node.text,
	            	tabTip:node.text,
	            	//iconCls:"icon-user", 
	            	html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();	//显示tab页
	    };	
	var groupdesc = session['LOGON.GROUPDESC'];
	var url1="../scripts/bdp/App/BDPSystem/Home/index.html?groupdesc="+groupdesc
	if ('undefined'!==typeof websys_getMWToken)
    {
		url1 += "&MWToken="+websys_getMWToken() //增加token
	}
	/** 初始化Home TabPanel */
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
                plugins: new Ext.BDP.TabCloseMenu(), //右键关闭菜单
                items:[{
                	title:"<img src='../scripts/bdp/Framework/BdpIconsLib/Home.png' />Home",
					//html:"Welcome"
					html : "<iframe frameborder='0' name='home1' scrolling='auto' height='100%' width='100%' src='"+url1+"'></iframe>"
                }]
		});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab]
    	});

});