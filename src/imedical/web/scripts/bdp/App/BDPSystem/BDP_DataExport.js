/**
 * @Title: 基础数据平台-数据导出
 * @Author: 谷雪萍 DHC-BDP
 * @Description: 数据导出界面
 * @Created on 2016-3-16
 * @LastUpdated on 2016-3-16 by gxp
 */

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');	
Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	
	var EXECUTABLE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=GetExecutableTreeJson&EIflag=E";	
	var pagesize = Ext.BDP.FunLib.PageSize.Aut;
	var AutCode =""  //选中的界面code（SS_User）,全局变量
	
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	
	/** 授权页面面板 */
    var ExecutabletreeLoader = new Ext.tree.TreeLoader({
    		nodeParameter: "ParentID",
    		dataUrl: EXECUTABLE_ACTION_URL
    	}) ; //自动传node id
	var Executableroot = new Ext.tree.AsyncTreeNode({
			id:"ExecutablegroupTreeRoot",
			text:"菜单列表",
			draggable:false
		}) ;
	westpanel = new Ext.tree.TreePanel({
		id:'westpanel',
		title:'BDP数据导出',
		root:Executableroot,
		region:'west',
		loader:ExecutabletreeLoader,
		autoScroll:true,
		containerScroll: true,	
		split:true,
		minSize:175,
		maxSize:300,
		width:240,
		collapsible: true,
		rootVisible:false ,//设为false将隐藏根节点
		tbar:['检索',
				new Ext.form.TextField({
					id:'FindTreeText',
					width:150,
					emptyText:'请输入查找内容',
					enableKeyEvents: true,
					listeners:{
						keyup:function(node, event) {
							findByKeyWordFiler(node, event);
						},
						scope: this
					}
				}), '-', {
					text:'清空',
					iconCls:'icon-refresh',
					handler:function(){clearFind();} //清除树过滤
				}
		],
	    listeners:{
	           "click":function(node,event) {
	           			refreshTab(node);
						
					}
	            }
	});
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(westpanel, {
		clearBlank : true,
		autoClear : true
	});
	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// 清除timeOutId
		westpanel.expandAll();// 展开树节点
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
				westpanel.root.cascade(function(n) {
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
		westpanel.root.cascade(function(n) {
					if(n.id!='0'){
							n.ui.show();
						}
				});
	}

    var roletitle = new Ext.form.Label({
		id: 'roletitle',
		html:""
		//cls: 'icon-refresh'
	});
    var centertab =  new Ext.TabPanel({
                id:'main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
				tbar:[roletitle],
                //margins:'0 5 5 0',
                resizeTabs:true,
                //tabWidth:150
                plugins:new Ext.BDP.TabCloseMenu(),
                items:[{
                	title:"数据导出",
                	id:'hometab',
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                }],
                listeners:{ 
                        tabchange:function(tp,p){                   	
                        } 
                } 
		});
		

		/** 新增TabPanel的函数 */
    var refreshTab = function(node){
	    	if (!node.isLeaf()) return;
	    	var obj=Ext.getCmp('hometab');
	    	obj.setTitle(node.text);
	    	var AutCode = node.attributes.myCode;
	    	var url = "dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDP_DataEXPanel"+"&AutCode="+AutCode;
			if ('undefined'!==typeof websys_getMWToken)
		    {
				url += "&MWToken="+websys_getMWToken() //增加token
			}
	    	var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
	    	obj.update(html);

	    	obj.show();	//显示tab页
	    };    
	var BasePanel = new Ext.Panel({
		region:"center",
		layout : 'border',
		id:'BasePanel',
		items:[westpanel,centertab]
	});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[BasePanel]
    	}); 	
	
});
