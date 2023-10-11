/**
 * @Title: 基础数据平台-国家/地区标准编码类别对照
 * @Author: sunfengchao 
 * @Description: 国家/地区标准编码类别对照
 * @Created on 2016-4-12
 * @LastUpdated on 2016-4-12 by gxp
 */

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');	
Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	
	var EXECUTABLE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPNATDataConstract&pClassMethod=GetExecutableTreeJson";	
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPNATDataConstract&pClassMethod=GetTreeJson";
	var pagesize = Ext.BDP.FunLib.PageSize.Aut;
	var ObjectReference="1"  //选中的类别ID，全局变量
	var ObjectType="G"		//选中的类别类型，全局变量
	var AutCode =""
	 
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
	ExecutabletreePanel = new Ext.tree.TreePanel({
		id:'ExecutabletreePanel',
		title:'国家/地区标准编码类别对照',
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
	           			addtab(node);
	           			/*if (!node.isLeaf()) return;
						var AutCode=node.attributes.myCode;
						var Url=myTree.dataUrl+'&AutCode=' + AutCode;
						myTree.on('beforeload', function(){   
					        myTree.loader.dataUrl = Url ;  
					        //treeLoader.baseParams = {LastLevel:"TreeRoot"}
						});
						myTree.loader.dataUrl = Url;
					    myTree.loadAuthorizeTree(ObjectType,ObjectReference,AutCode);*/
						
					}
	            }
	});
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(ExecutabletreePanel, {
		clearBlank : true,
		autoClear : true
	});
	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// 清除timeOutId
		ExecutabletreePanel.expandAll();// 展开树节点
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
				ExecutabletreePanel.root.cascade(function(n) {
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
		ExecutabletreePanel.root.cascade(function(n) {
					if(n.id!='0'){
							n.ui.show();
						}
				});
	}
	/*var myTree = new Ext.BDP.Component.DataAutPanel({
		id:"mytree",
        region:"center",
		dataUrl:Tree_ACTION_URL,
        ObjectType : ObjectType, 
		ObjectReference : ObjectReference, 
		AutCode : AutCode,
        pageSize:Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
        disToolbar : true, //是否显示搜索工具条
        isCascade : true,   //级联
        AutClass : "web.DHCBL.BDP.BDPNATDataConstract", //获取授权数据类名称
        getAutMethod : "GetAutJson",					//获取授权数据方法
        saveAutMethod : 'SaveConstractData' //保存授权数据方法
        ///////////////////////////////////////////////////////////////
    });*/
    var roletitle = new Ext.form.Label({
		id: 'roletitle',
		html:""
		//cls: 'icon-refresh'
	});
	var url ="websys.csp";
	if ('undefined'!==typeof websys_getMWToken)
	{
		url += "?MWToken="+websys_getMWToken() //增加token
	} 	
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
                	title:"Home",
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>" 
                }],
                listeners:{ 
                        tabchange:function(tp,p){                   	
                        } 
                } 
		});
		/** 新增TabPanel的函数 */
    var addtab = function(node){
	    	if (!node.isLeaf()) return;
	    	if(ObjectReference == "") {Ext.Msg.alert("提示","请先选择授权类别!"); return;}
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){
	    		obj.setTitle(node.text);
	    		var AutCode = node.attributes.myCode;
				var url1 = "dhc.bdp.ext.default.csp?extfilename=/App/BDPSystem/BDP_NATDataContrast"+"&ObjectType="+ObjectType+"&ObjectReference="+ObjectReference+"&AutCode="+AutCode;
				if ('undefined'!==typeof websys_getMWToken)
				{
					url1 += "&MWToken="+websys_getMWToken() //增加token
				}  
	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url1+"'></iframe>";
	    		obj.update(html);
	    		
	    	}else{
	    		var AutCode = node.attributes.myCode;
				var url1 = "dhc.bdp.ext.default.csp?extfilename=/App/BDPSystem/BDP_NATDataContrast"+"&ObjectType="+ObjectType+"&ObjectReference="+ObjectReference+"&AutCode="+AutCode;
				if ('undefined'!==typeof websys_getMWToken)
				{
					url1 += "&MWToken="+websys_getMWToken() //增加token
				}   
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text,
	            	//tabTip:node.text,
	            	//iconCls:node.attributes.iconCls,
	            	html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url1+"'></iframe>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();	//显示tab页
	    };    
	var BasePanel = new Ext.Panel({
		region:"center",
		layout : 'border',
		id:'BasePanel',
		items:[ExecutabletreePanel,centertab]
	});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
			id:'vp',
        	layout:'border',
        	items:[BasePanel]
    	}); 	
    	
         /** 如果未开启医院级别授权，则禁用此页面。 */
    	var BDPNATAut =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPNationalData");
    	if (BDPNATAut != "Y")
    	{
    		Ext.getCmp('ExecutabletreePanel').disable();
    		//Ext.getCmp('centertab').disable();
    		Ext.getCmp('vp').disable();
    		//Ext.MessageBox.alert("","未开启医院级别授权，请在平台配置下开启，或者联系管理员。");
    		alert('未开启国家/地区标准编码维护功能！如需开启请在平台配置下设置。')
    	}
	
});
