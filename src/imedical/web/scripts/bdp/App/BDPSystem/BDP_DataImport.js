/**
 * @Title: 基础数据平台-BDP数据导入
 * @Author: 谷雪萍 DHC-BDP
 * @Description: 数据导入界面
 * @Created on 2016-3-16
 * @LastUpdated on 2016-3-16 by gxp
 */

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');	
Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	
	var EXECUTABLE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=GetExecutableTreeJson&EIflag=I";	
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
		title:'BDP数据导入',
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
	           			GridClick();
					},
				"load":function(){
					GridClick();
				}
	            }
	});
	
		//-----------------------颜色设置
	//设置父菜单颜色
	function cascadeSetColor(node){
		var pn = node.parentNode;
		if (!pn) return;
		
		var b = '';
		Ext.each(pn.childNodes, function(n){
			if (n.text.indexOf("<font color='red'>")==-1){
				b = 'orange';
				return false;
			}else{
				b = 'red';
				return true;
			}
		});
		if (b=='') return;
		if (b=='orange') {
			if(pn.text.indexOf("font")>-1){
				var ptext = pn.text;
				ptext = ptext.substring(ptext.indexOf("'>")+2,ptext.indexOf("</"));
				pn.setText("<font color='orange'>"+ptext+"</font>");
			}else{
				pn.setText("<font color='orange'>"+pn.text+"</font>");
			}
		}
		if (b=='red') {
			if(pn.text.indexOf("font")>-1){
				var ptext = pn.text;
				ptext = ptext.substring(ptext.indexOf("'>")+2,ptext.indexOf("</"));
				pn.setText("<font color='red'>"+ptext+"</font>");
			}else{
				pn.setText("<font color='red'>"+pn.text+"</font>");
			}
		}
		
		cascadeSetColor(pn);
	}
	Ext.getCmp("westpanel").on('textchange', function(node, text, ntext){
		if (node.text.indexOf("<font color='red'>")>-1 & node.isLeaf()){
			cascadeSetColor(node);
		}
	});
	//-----------------------------------------
	var GridClick = function(){
		//2013-8-27 by lisen
		var f  = function(node) {
			node.unselect(); //取消选择
			//node.getUI().getIconEl().src = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
			var str=node.text;
			if(str.indexOf("font")>-1){
				str=str.substring(str.indexOf("'>")+2,str.indexOf("</"));
			}
			node.setText(str);
		}
		Ext.getCmp("westpanel").getRootNode().cascade(f);

		//clickevent();
		
		//判断功能项菜单是否授权,如果已授权则叶子节点显示为红色
		var IDJson = tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetItemPreferences");
		//alert(IDJson)
		if (IDJson=="") return;
		window.eval("var IDArray = " + IDJson);
		for(var i=0;i<IDArray.length;i++){
			var nodeAut="";
			nodeAut=Ext.getCmp("westpanel").getNodeById(IDArray[i].ID);
			if(nodeAut){
				//nodeAut.getUI().getIconEl().src = Ext.BDP.FunLib.Path.URL_Icon+"stop.png";
				nodeAut.setText("<font color='red'>"+nodeAut.text+"</font>");
			}
		}
	}
	
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

		//加锁，可自动解锁
     var mytbar = new Ext.Toolbar({
				items : [{
						id : 'ckLimited',
						xtype : 'checkbox',
						boxLabel : '加锁',
						checked : false,
						listeners : {
							'check' : function(com, checked){ //保存limited、禁用TreePanel
								if(checked){
									var rtn = tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","SaveLockFlag",AutCode,"Y");
									Ext.getCmp('hometab').setDisabled(true);
									Ext.getCmp('showState').setText('<img style="width:12px;height:12px;" src="'+ Ext.BDP.FunLib.Path.URL_Icon +'stop.png" />'
    						+ '<font style="color:red;">当前为加锁状态，不可以导入该菜单的数据。</font>');
								}else{
									var rtn = tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","SaveLockFlag",AutCode,"N");
									Ext.getCmp('hometab').setDisabled(false);
									Ext.getCmp('showState').setText('<img style="width:12px;height:12px;" src="'+ Ext.BDP.FunLib.Path.URL_Icon +'accept.png" />'
									+ '<font style="color:green;">当前为不加锁状态，可以导入该菜单的数据。</font>');
								}
							}
						}
					}, '->', {
						xtype : 'tbtext',
						id : 'showState',
						text : '<img style="width:12px;height:12px;" src="'+ Ext.BDP.FunLib.Path.URL_Icon +'accept.png" />'
									+ '<font style="color:green;">当前为不加锁状态，可以导入该菜单的数据。</font>'
					}]
			});

    var centertab =  new Ext.TabPanel({
                id:'main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
				tbar:mytbar,
                //margins:'0 5 5 0',
                resizeTabs:true,
                //tabWidth:150
                plugins:new Ext.BDP.TabCloseMenu(),
                items:[{
                	title:"数据导入",
                	id:'hometab',
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                }],
                listeners:{ 
                        tabchange:function(tp,p){                   	
                        } 
                } 
		});
		

	//var url = "dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDP_DataIMPanel";   //+"&"
	
		/** 新增TabPanel的函数 */
    var refreshTab = function(node){
	    	if (!node.isLeaf()) return;
	    	var obj=Ext.getCmp('hometab');
	    	obj.setTitle(node.text);
	    	AutCode = node.attributes.myCode;
	    	var url = "dhc.bdp.ct.importdata.csp?AutCode="+AutCode;
	    	if ('undefined'!==typeof websys_getMWToken)
	        {
				url += "&MWToken="+websys_getMWToken() //增加token
			}
	    	var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
	    	obj.update(html);

	    	obj.show();	//显示tab页
	    	
	    	//是否加锁
			var flag = tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","ShowLockFlag",AutCode);
			if(flag=="Y"){
				Ext.getCmp('ckLimited').setValue(true);
				Ext.getCmp('hometab').setDisabled(true);
			}else{
				Ext.getCmp('ckLimited').setValue(false);
				Ext.getCmp('hometab').setDisabled(false);
			}
	    };  
	var BasePanel = new Ext.Panel({
		region:"center",
		layout : 'border',
		id:'BasePanel',
		items:[westpanel,centertab]
	});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
			id:'vp',
        	layout:'border',
        	items:[BasePanel]
    	}); 
    	
      /** 如果未开启BDP数据导入授权，则禁用此页面。 */
    	var BDPHospAut =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPDataImport");
    	if (BDPHospAut != "Y")
    	{
    		Ext.getCmp('westpanel').disable();
    		Ext.getCmp('vp').disable();
    		//Ext.MessageBox.alert("","未开启医院级别授权，请在平台配置下开启，或者联系管理员。");
    		alert('未开启BDP数据导入授权，请在平台配置下开启，或者联系管理员。')
    	}
	
});
