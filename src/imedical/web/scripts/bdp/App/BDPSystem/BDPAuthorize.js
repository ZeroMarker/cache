/**
 * @Title: 基础数据平台授权主JS
 * @Author: 蔡昊哲 DHC-BDP
 * @Description:用于显示组织结构，用户、科室、安全组,整合菜单授权、元素授权、数据授权。
 * @Created on 2013-5-6
 */

/**----------------------------------调用元素授权控件JS--------------------------------------**/	
	var BDPItemJS1 = '../scripts/bdp/App/System/BDPItemAuthorize/Ext.ux.Multiselect.js';		//菜单授权部分
	var BDPItemJS2 = '../scripts/bdp/App/System/BDPItemAuthorize/DDView.js';  		//元素功能授权部分	
	var BDPItemJS3 = '../scripts/bdp/App/System/BDPItemAuthorize/Ext.form.MultiSelect.js';  		//元素功能授权部分	
	var BDPItemCSS = '../scripts/bdp/App/System/BDPItemAuthorize/Multiselect.css';
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS1+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS2+'"></scr' + 'ipt>');
    document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS3+'"></scr' + 'ipt>');
    document.write('<link rel="stylesheet"' + 'ipt type="text/css" href="'+BDPItemCSS+'"></scr' + 'ipt>');
/**----------------------------------调用元素授权控件JS--------------------------------------**/	
    
/**----------------------------------调用附属JS--------------------------------------**/		
	var BDPMenuJS = '../scripts/bdp/App/System/BDPMenuAuthorize.js';		//菜单授权部分
	var BDPItemJS = '../scripts/bdp/App/System/BDPItemAuthorize.js';  		//元素功能授权部分
	var BDPBaseDataJS = '../scripts/bdp/App/System/BDPBaseDataAuthorize.js';  		//数据授权部分	
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPMenuJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPBaseDataJS+'"></scr' + 'ipt>');
/**----------------------------------调用附属JS--------------------------------------**/	


	var ObjectReference=""  //选中的类别ID，全局变量
	var ObjectType=""		//选中的类别类型，全局变量

Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	
	var GetGroupList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetGroupList";  //获取安全组数据
	var GetLocList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetLocList";  //获取科室数据
	var GetUserList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetUserList";  //获取用户数据
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.SSGroup&pClassQuery=GetList";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.SSGroup&pClassMethod=DeleteData";
	
	var pagesize = 26;
	
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	
	/**----显示安全组-----*/
	var SSGRP = Ext.data.Record.create([				        // ------------
        {   name : 'SSGRPRowId',
			mapping : 'SSGRPRowId',
			type : 'string'
		},
		{	name : 'SSGRPDesc',
			mapping : 'SSGRPDesc',
			type : 'string'
		}
	]);

	var Groupds = new Ext.data.Store({											
		proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
			url : GetGroupList_URL								//---------调用的动作
		}),
		reader : new Ext.data.JsonReader({						    //---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		},SSGRP)
	});

	Groupds.load({
		params : {												  //----------ds加载时发送的附加参数
			start : 0,
			limit : pagesize
		},
		callback : function(records, options, success) {          //----------加载完成后执行的回调函数
		}
	});
			
		/**---------分页工具条-----------*/	
	var Grouppaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : Groupds,											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	
	/**---------搜索按钮-----------*/
	var GroupSearch = new Ext.Button({
		id : 'GroupSearch',
		iconCls : 'icon-search',
		//text : '搜索',
		handler : function() {                                  //-----------执行回调函数
			Groupgrid.getStore().load({									//-----------加载查询出来的数据
			params : {
				desc :  Ext.getCmp("GroupText").getValue(),
				start : 0,
				limit : pagesize
			}
		});
		}
	});		
	/**---------刷新按钮-----------*/
	var GroupRefresh = new Ext.Button({
		id : 'GroupRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("GroupText").reset();                     //-----------将输入框清空
			Groupgrid.getStore().load({                              //-----------加载数据
				params : {
					start : 0,
					limit : pagesize
				}
			});
		}
	});		
	/**---------将工具条放在一起-----------*/
	var GroupText = new Ext.form.TextField({
		id : 'GroupText',
		title:'安全组',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
			Groupgrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					desc :  Ext.getCmp("GroupText").getValue(),
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Grouptb = new Ext.Toolbar({
				id : 'Grouptb',
				items : [GroupSearch, '-',GroupText, '->' ,GroupRefresh]
			});
	/**---------创建grid-----------*/
	var Groupgrid = new Ext.grid.GridPanel({
		id : 'grid',
		region:'center',
		iconCls : 'icon-book',
		title:'安全组',
		collapsed :false,              						//默认展开
		closable : true,
		store : Groupds,									//----------------表格的数据集
		trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
		columns : [sm,{
					header : '安全组名',
					width : 150,
					sortable : true,
					dataIndex : 'SSGRPDesc'
				}],
		stripeRows : true,                                //------------------显示斑马线
		loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
			msg : '数据加载中,请稍候...'
		},
		// config options for stateful behavior
		stateful : true,                                  //-----------------
		viewConfig : {									  //-----------------视图配置
			forceFit : true								  //-----------------固定大小
		},
		bbar : Grouppaging,                                    //-----------------底部状态栏
		tbar : Grouptb, 
		stateId : 'grid'
	});
			
			
	/**----显示用户-----*/
	var SSUSE = Ext.data.Record.create([				        // ------------
        {   name : 'SSUSRRowId',
			mapping : 'SSUSRRowId',
			type : 'string'
		},
		{	name : 'SSUSRName',
			mapping : 'SSUSRName',
			type : 'string'
		}
	]);

	var Userds = new Ext.data.Store({											
		proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
			url : GetUserList_URL								//---------调用的动作
		}),
		reader : new Ext.data.JsonReader({						    //---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		},SSUSE)
	});

	Userds.load({
		params : {												  //----------ds加载时发送的附加参数
			start : 0,
			limit : pagesize
		},
		callback : function(records, options, success) {          //----------加载完成后执行的回调函数
		}
	});
			
		/**---------分页工具条-----------*/	
	var Userpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : Userds,											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	
	/**---------搜索按钮-----------*/
	var UserSearch = new Ext.Button({
		id : 'UserSearch',
		iconCls : 'icon-search',
		//text : '搜索',
		handler : function() {                                  //-----------执行回调函数
			Usergrid.getStore().load({									//-----------加载查询出来的数据
			params : {
				desc :  Ext.getCmp("UserText").getValue(),
				start : 0,
				limit : pagesize
			}
		});
		}
	});		
	/**---------刷新按钮-----------*/
	var UserRefresh = new Ext.Button({
		id : 'UserRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("UserText").reset();                     //-----------将输入框清空
			Usergrid.getStore().load({                              //-----------加载数据
				params : {
					start : 0,
					limit : pagesize
				}
			});
		}
	});		
	/**---------将工具条放在一起-----------*/
	var UserText = new Ext.form.TextField({
		id : 'UserText',
		title:'安全组',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
			Usergrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					desc :  Ext.getCmp("UserText").getValue(),
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Usertb = new Ext.Toolbar({
				id : 'Usertb',
				items : [UserSearch, '-',UserText, '->' ,UserRefresh]
			});
	/**---------创建grid-----------*/
	var Usergrid = new Ext.grid.GridPanel({
				id : 'Usergrid',
				region:'center',
				iconCls : 'icon-user',
				title:'用户',
				closable : true,
				store : Userds,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm,{
							header : '用户名',
							width : 150,
							sortable : true,
							dataIndex : 'SSUSRName'
						}],
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				bbar : Userpaging,                                    //-----------------底部状态栏
				tbar : Usertb, 
				stateId : 'grid'
			});		
			
			
	/**----显示科室-----*/
	var CTLOC = Ext.data.Record.create([				        // ------------
        {   name : 'CTLOCRowID',
			mapping : 'CTLOCRowID',
			type : 'string'
		},
		{	name : 'CTLOCDesc',
			mapping : 'CTLOCDesc',
			type : 'string'
		}
	]);

	var Locds = new Ext.data.Store({											
		proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
			url : GetLocList_URL								//---------调用的动作
		}),
		reader : new Ext.data.JsonReader({						    //---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		},CTLOC)
	});

	Locds.load({
		params : {												  //----------ds加载时发送的附加参数
			start : 0,
			limit : pagesize
		},
		callback : function(records, options, success) {          //----------加载完成后执行的回调函数
		}
	});
			
		/**---------分页工具条-----------*/	
	var Locpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : Locds,											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	
	/**---------搜索按钮-----------*/
	var LocSearch = new Ext.Button({
		id : 'LocSearch',
		iconCls : 'icon-search',
		//text : '搜索',
		handler : function() {                                  //-----------执行回调函数
			Locgrid.getStore().load({									//-----------加载查询出来的数据
			params : {
				desc :  Ext.getCmp("LocText").getValue(),
				start : 0,
				limit : pagesize
			}
		});
		}
	});		
	/**---------刷新按钮-----------*/
	var LocRefresh = new Ext.Button({
		id : 'LocRefresh',
		iconCls : 'icon-refresh',
		handler : function() {
			Ext.getCmp("LocText").reset();                     //-----------将输入框清空
			Locgrid.getStore().load({                              //-----------加载数据
				params : {
					start : 0,
					limit : pagesize
				}
			});
		}
	});		
	/**---------将工具条放在一起-----------*/
	var LocText = new Ext.form.TextField({
		id : 'LocText',
		title:'安全组',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
			Locgrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					desc :  Ext.getCmp("LocText").getValue(),
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Loctb = new Ext.Toolbar({
				id : 'Loctb',
				items : [LocSearch, '-',LocText, '->' ,LocRefresh]
			});
	/**---------创建Locgrid-----------*/
	var Locgrid = new Ext.grid.GridPanel({
		id : 'Locgrid',
		region:'center',
		title:'科室',
		iconCls : 'icon-LoginLoc',
		closable : true,
		store : Locds,											//----------------表格的数据集
		trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
		columns : [sm,{
					header : '科室名',
					width : 150,
					sortable : true,
					dataIndex : 'CTLOCDesc'
				}],
		stripeRows : true,                                //------------------显示斑马线
		loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
			msg : '数据加载中,请稍候...'
		},
		// config options for stateful behavior
		stateful : true,                                  //-----------------
		viewConfig : {									  //-----------------视图配置
			forceFit : true								  //-----------------固定大小
		},
		bbar : Locpaging,                                    //-----------------底部状态栏
		tbar : Loctb, 
		stateId : 'grid'
	});
	
	///单击菜单授权
	
	var MenuA = getMeunPanel();
	var GroupA = getGroupPanel();
	var LogonLocA = getLogonLocPanel();
			
	/** 授权类别面板 */
	var westpanel = new Ext.Panel({
			id:'westpanel',
			region:"west",
			title:"<div style='text-align:center'>授权类别</div>",
			//autoScroll:true,
			split:true,
			collapsible:true, //自动收缩按钮 
			border:true,
			width:220,
			minSize: 220,
			maxSize: 300,
			//expanded : false,
			//margins:'0 0 5 5',
			//cmargins:'0 5 5 5',
			//lines:false,
	    	layout:"accordion",
	    	//extraCls:"roomtypegridbbar",
			//iconCls:'icon-feed', 
	 		//添加动画效果
			layoutConfig: {animate: true},
			items:[Groupgrid,Locgrid,Usergrid]
		});
	
			
	/** 初始化TabPanel */
	
	var ItemPanel = new Ext.Panel({
		//width : 600,  
		//height : 600,  
		title:"功能授权",
		layout : 'border',
		id:'ExecutablePanel',
		items:[ExecutabletreePanel,TABPANEL]
		//items:[Panel5,Panel6]
	});
	
	
	
	/** 初始化TabPanel */
	var centertab =  new Ext.TabPanel({
        id:'centertab',
        activeTab:0,
        region:'center',
        enableTabScroll:true,
        resizeTabs: true,
        tabWidth:130,
		minTabWidth:120,
        //margins:'0 5 5 0',
        resizeTabs:true,
        //tabWidth:150
        items:[menuPanel,ItemPanel,DBtb]
	});
		
	
	/** 以下为加载事件  */
	//分情况逐个加载，减小服务器压力，大幅增加加载速度
	var GridClick = function(ObjectType,ObjectReference){
		if(Ext.getCmp('centertab').getActiveTab().id == "menuConfigTreePanel")         
		{		
			menuTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
			menuTreeLoader.load(menuPanel.root)	
			var menuTree = Ext.getCmp("menuConfigTreePanel");
			menuTree.expandAll();
		}
			if(Ext.getCmp('centertab').getActiveTab().id == "BaseDataTB")        
		{
			if(Ext.getCmp('BaseDataTB').getActiveTab().id == "groupConfigTreePanel")
			{
				groupTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
				groupTreeLoader.load(groupPanel.root)
				var groupTree = Ext.getCmp("groupConfigTreePanel");
				groupTree.expandAll();
			}
			if(Ext.getCmp('BaseDataTB').getActiveTab().id == "LogonLocConfigTreePanel")
			{		
				LogonLocTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
				LogonLocTreeLoader.load(LogonLocPanel.root)
				var LogonLocTree = Ext.getCmp("LogonLocConfigTreePanel");
				LogonLocTree.expandAll();
			}
			
			
		}
			if(Ext.getCmp('centertab').getActiveTab().id == "ExecutablePanel")        
		{
			clickevent();
		}			
	}
	
	Usergrid.on("rowclick", function(grid, rowIndex, e) {								//用户菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('SSUSRRowId')	
		ObjectType="U"
		GridClick(ObjectType,ObjectReference);
	},this,{stopEvent:true});
	
	Locgrid.on("rowclick", function(grid, rowIndex, e) {								//科室菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('CTLOCRowID')
		ObjectType="L"
		GridClick(ObjectType,ObjectReference);
	},this,{stopEvent:true});
		
	Groupgrid.on("rowclick", function(grid, rowIndex, e) {								//安全组菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('SSGRPRowId')
		ObjectType="G"
		GridClick(ObjectType,ObjectReference);
	},this,{stopEvent:true});
	
	centertab.on('tabchange', function(tabPanel, newCard, oldCard) {
        if(newCard.id=="menuConfigTreePanel") {
        	menuTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
			menuTreeLoader.load(menuPanel.root)	
			var menuTree = Ext.getCmp("menuConfigTreePanel");
			menuTree.expandAll();
        }
		if(newCard.id=="BaseDataTB") {
			if(Ext.getCmp('BaseDataTB').getActiveTab().id == "groupConfigTreePanel")
			{
				groupTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
				groupTreeLoader.load(groupPanel.root)
				var groupTree = Ext.getCmp("groupConfigTreePanel");
				groupTree.expandAll();
			}
			if(Ext.getCmp('BaseDataTB').getActiveTab().id == "LogonLocConfigTreePanel")
			{		
				LogonLocTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
				LogonLocTreeLoader.load(LogonLocPanel.root)
				var LogonLocTree = Ext.getCmp("LogonLocConfigTreePanel");
				LogonLocTree.expandAll();
			}
		}
		if(newCard.id=="ExecutablePanel") {
			clickevent();
		}		
    });
    
    DBtb.on('tabchange', function(tabPanel, newCard, oldCard) {
		if(Ext.getCmp('BaseDataTB').getActiveTab().id == "groupConfigTreePanel")
			{
				groupTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
				groupTreeLoader.load(groupPanel.root)
				var groupTree = Ext.getCmp("groupConfigTreePanel");
				groupTree.expandAll();
			}
			if(Ext.getCmp('BaseDataTB').getActiveTab().id == "LogonLocConfigTreePanel")
			{		
				LogonLocTreeLoader.baseParams = {ObjectType:ObjectType,ObjectReference:ObjectReference};
				LogonLocTreeLoader.load(LogonLocPanel.root)
				var LogonLocTree = Ext.getCmp("LogonLocConfigTreePanel");
				LogonLocTree.expandAll();
			}		
		});
    
    
	
	
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab]
    	});
    	
	
});



/*	var findGroupTree = function(e){
	var groupDesc = Ext.getCmp('groupTF').getValue();				
	var loader = treePanel.getLoader();
	loader.baseParams.groupDesc = groupDesc;
	loader.load(treePanel.root);
}
	*//** 安全组面板 *//*
    var treeLoader = new Ext.tree.TreeLoader({dataUrl: GetGroupTree_URL}) ; //自动传node id
	var root = new Ext.tree.AsyncTreeNode({id:"groupTreeRoot", text:"安全组", draggable:false}) ;
	var GroupTreePanel = new Ext.tree.TreePanel({
		title:'安全组',
		root:root,
		loader:treeLoader,
		region:'west',
		split:true,
		autoScroll: true, //滚动条
		collapsible:true, //自动收缩按钮 
		border:true,
		width:220,
		minSize: 220,
		maxSize: 300,
		//margins:'0 0 0 0',
		//cmargins:'0 0 0 0',
		//collapseMode: 'mini', //窄收缩边框
		rootVisible:false, //设为false将隐藏根节点	
		tbar: ['查找:',new Ext.form.TwinTriggerField({
			widht:280,id:'groupTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			},
			onTrigger2Click: findGroupTree
		})]
	});*/