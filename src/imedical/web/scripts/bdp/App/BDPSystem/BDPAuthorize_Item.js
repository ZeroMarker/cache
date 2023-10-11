/**
 * @Title: 基础数据平台-功能元素授权
 * @Author: 蔡昊哲 DHC-BDP
 * @Description: 用于 用户、科室、安全组的功能元素授权
 * @Created on 2013-5-6
 * @Updated on 2013-5-14 by lisen
 * @LastUpdated on 2013-5-31 by chz(修复BUG)
 */

/**----------------------------------调用元素授权控件JS--------------------------------------**/	
	var BDPItemJS1 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.ux.Multiselect.js';		//菜单授权部分
	var BDPItemJS2 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/DDView.js';  		//元素功能授权部分	
	var BDPItemJS3 = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Ext.form.MultiSelect.js';  		//元素功能授权部分	
	var BDPItemCSS = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize/Multiselect.css';
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS1+'"></scr' + 'ipt>');
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS2+'"></scr' + 'ipt>');
    document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS3+'"></scr' + 'ipt>');
    document.write('<link rel="stylesheet"' + 'ipt type="text/css" href="'+BDPItemCSS+'"></scr' + 'ipt>');
/**----------------------------------调用元素授权控件JS--------------------------------------**/	
    
    var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/BDPAuthorize_Item/BDPAuthorize_Item.htm";
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
	
/**----------------------------------调用附属JS--------------------------------------**/		
	var BDPItemJS = '../scripts/bdp/App/BDPSystem/BDPItemAuthorize.js';  		//元素功能授权部分
	document.write('<scr' + 'ipt type="text/javascript" src="'+BDPItemJS+'"></scr' + 'ipt>');
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
	var Groupds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:GetGroupList_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
	      [{   name : 'SSGRPRowId',mapping : 'SSGRPRowId',type : 'string'},
		   {   name : 'SSGRPDesc',mapping : 'SSGRPDesc',type : 'string'}]),					
		remoteSort: true
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
			Groupgrid.getStore().baseParams={
       			desc :  Ext.getCmp("GroupText").getValue()
       		};
			Groupgrid.getStore().load({									//-----------加载查询出来的数据
			params : {
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
			Groupgrid.getStore().baseParams={};
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
       		Groupgrid.getStore().baseParams={
       			desc :  Ext.getCmp("GroupText").getValue()
       		};
			Groupgrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Grouptb = new Ext.Toolbar({
				id : 'Grouptb',
				items : [//GroupSearch, '-',
				GroupText, '->' ,GroupRefresh]
			});
	/**---------创建grid-----------*/
	var Groupgrid = new Ext.grid.GridPanel({
		id : 'Groupgrid',
		region:'center',
		iconCls : 'icon-book',
		title:'安全组',
		collapsed :false,              						//默认展开
		closable : true,
		store : Groupds,									//----------------表格的数据集
		trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
		columns : [sm,
			{ header: '安全组ID',sortable: true, dataIndex: 'SSGRPRowId',width : 50,hidden:true  },
			{ header: '安全组名',sortable: true, dataIndex: 'SSGRPDesc',width : 150  }],
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
		stateId : 'Groupgrid'
	});
			
			
	/**----显示用户-----*/
	var Userds = new Ext.data.Store({											
		proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
			url : GetUserList_URL								//---------调用的动作
		}),
		reader : new Ext.data.JsonReader({						    //---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
			},
			[	{   name : 'SSUSRRowId',mapping : 'SSUSRRowId',type : 'string'},
				{	name : 'SSUSRName',mapping : 'SSUSRName',type : 'string' }]),
			remoteSort: true
				
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
			Usergrid.getStore().baseParams={
       			desc :  Ext.getCmp("UserText").getValue()
       		};
			Usergrid.getStore().load({									//-----------加载查询出来的数据
			params : {
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
			Usergrid.getStore().baseParams={};
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
		title:'用户',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
       		Usergrid.getStore().baseParams={
       			desc :  Ext.getCmp("UserText").getValue()
       		};
			Usergrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Usertb = new Ext.Toolbar({
				id : 'Usertb',
				items : [//UserSearch, '-',
				UserText, '->' ,UserRefresh]
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
				columns : [sm,{ header: '用户ID',sortable: true, dataIndex: 'SSUSRRowId',width : 50,hidden:true  },
							{ header: '用户',sortable: true, dataIndex: 'SSUSRName',width : 150  }],
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
		},CTLOC),
		remoteSort: true
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
			Locgrid.getStore().baseParams={
       			desc :  Ext.getCmp("LocText").getValue()
       		};
			Locgrid.getStore().load({									//-----------加载查询出来的数据
			params : {
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
			Locgrid.getStore().baseParams={};
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
		title:'科室',
		enableKeyEvents : true,
		width:100,
		listeners : {
       	'keyup' : function(field, e){
       		Locgrid.getStore().baseParams={
       			desc :  Ext.getCmp("LocText").getValue()
       		};
			Locgrid.getStore().load({									//-----------加载查询出来的数据
				params : {
					start : 0,
					limit : pagesize
					}
				});
	        }
		}						
	})
	var Loctb = new Ext.Toolbar({
				id : 'Loctb',
				items : [ //LocSearch, '-',
				LocText, '->' ,LocRefresh]
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
		columns : [sm,
			{ header: '科室ID',sortable: true, dataIndex: 'CTLOCRowID',width : 50,hidden:true  },
			{ header: '科室名',sortable: true, dataIndex: 'CTLOCDesc',width : 150  }],
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
		//title:"功能授权",
		region:"center",
		layout : 'border',
		id:'ExecutablePanel',
		items:[ExecutabletreePanel,TABPANEL]
	});
	
	//-----------------------20140215 by lisen
	//设置父菜单颜色，写了一整天，尝试了很多方法终于调出来了哈哈
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
	Ext.getCmp("ExecutabletreePanel").on('textchange', function(node, text, ntext){
		if (node.text.indexOf("<font color='red'>")>-1 & node.isLeaf()){
			cascadeSetColor(node);
		}
	});
	//-----------------------------------------
	
	/** 以下为加载事件  */
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
		Ext.getCmp("ExecutabletreePanel").getRootNode().cascade(f);
		ds.removeAll();
		ds1.removeAll();
		//clickevent();
		
		//判断功能项菜单是否授权,如果已授权则叶子节点显示为红色
		var IDJson = tkMakeServerCall("web.DHCBL.Authorize.Executables","GetItemPreferences",ObjectType,ObjectReference);
		if (IDJson=="") return;
		window.eval("var IDArray = " + IDJson);
		for(var i=0;i<IDArray.length;i++){
			var nodeAut="";
			nodeAut=Ext.getCmp("ExecutabletreePanel").getNodeById(IDArray[i].ID);
			if(nodeAut){
				//nodeAut.getUI().getIconEl().src = Ext.BDP.FunLib.Path.URL_Icon+"stop.png";
				nodeAut.setText("<font color='red'>"+nodeAut.text+"</font>");
			}
		}
	}
	
	Usergrid.on("rowclick", function(grid, rowIndex, e) {								//用户菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('SSUSRRowId')	
		ObjectType="U"
		GridClick();
	},this,{stopEvent:true});
	
	Locgrid.on("rowclick", function(grid, rowIndex, e) {								//科室菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('CTLOCRowID')
		ObjectType="L"
		GridClick();
	},this,{stopEvent:true});
		
	Groupgrid.on("rowclick", function(grid, rowIndex, e) {								//安全组菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		ObjectReference=_record.get('SSGRPRowId')
		ObjectType="G"
		GridClick();
	},this,{stopEvent:true});

    
    
	
	
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,ItemPanel]
    	});
    	
	
});