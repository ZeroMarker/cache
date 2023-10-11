
	
	/// 名称:系统配置 -  授权浏览
	/// 描述:包含查看、删除功能
	/// 编写者:基础平台组 - 陈莹
	/// 编写日期:2014-1-26
	
	var ObjectReference=""  //选中的类别ID，全局变量
	var ObjectType=""		//选中的类别类型，全局变量
	var AppSubKey="";
	var OTHLLRowId=""
	//页面说明 helphtmlbtn
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
	var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/BDPPreferences/BDPPreferences.htm";
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
Ext.onReady(function(){
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	
	//获取安全组/科室/用户数据
	var GetObjectReference_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassQuery=GetPre"; 
	var GetSSUserOtherLogonLoc_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassQuery=GetOtherLogonLoc"; 
	
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassQuery=GetList";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassMethod=DeleteData";
	
	var pagesize_grid = Ext.BDP.FunLib.PageSize.Main;
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'under';
	
	
	
	///授权类别
	var GetGroupList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetGroupList";  //获取安全组数据
	var GetLocList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetLocList";  //获取科室数据
	var GetUserList_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.Authorize.BDPAuthorize&pClassQuery=GetUserList";  //获取用户数据
	Ext.BDP.FunLib.TableName="BDP_Preferences"
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
			Ext.getCmp("hidden_objecttype").reset();
       		Ext.getCmp("hidden_objectref").reset();
			Ext.getCmp("hidden_otherloc").reset();
			var title = Ext.getCmp('tabs').getActiveTab().title;
			switchcase(title, "","","");
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
				items : [GroupSearch, '-',GroupText, '->' ,GroupRefresh]
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
			Ext.getCmp("hidden_objecttype").reset();
       		Ext.getCmp("hidden_objectref").reset();
			Ext.getCmp("hidden_otherloc").reset();
			var title = Ext.getCmp('tabs').getActiveTab().title;
			switchcase(title, "","","");
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
	
	/*,
							listeners:{
			'select':function(combo,record,index){
				var userid=Ext.getCmp('TextObjectReference').getValue();
				var Type=Ext.getCmp('TextObjectType').getValue();
				SSUserOtherLogonLocds.load({params:{type:Type,OTHLLParRef:userid}});	
			},
			'change':function(combo,record,index){
				Ext.getCmp('TextSSUserOtherLogonLoc').clearValue(); 

			}}*/
			// 增删改工具条
	var tbbuttonUser = new Ext.Toolbar({
		enableOverflow : true,
		items : ['其他登录科室',{
							xtype : "bdpcombo",
							emptyText:'不选择则为默认登录科室',
							width:160,
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							
							fieldLabel : '<font color=red></font>登录科室',
							id :'TextSSUserOtherLogonLoc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextSSUserOtherLogonLoc'),
							store : SSUserOtherLogonLocds=new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : GetSSUserOtherLogonLoc_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'OTHLLRowId',mapping:'OTHLLRowId'},
										{name:'Desc',mapping:'Desc'} ])
								}),
							mode : 'remote',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'Desc',
							valueField : 'OTHLLRowId',
							listeners:{
			'select':function(combo,record,index){
				var _record = Usergrid.getSelectionModel().getSelected();//records[0]
				if(_record)
				{
					var ObjectReference=_record.get('SSUSRRowId')
					var ObjectType="U"
					Ext.getCmp("hidden_objecttype").reset();
        			Ext.getCmp("hidden_objecttype").setValue(ObjectType);
       				Ext.getCmp("hidden_objectref").reset();
       				Ext.getCmp("hidden_objectref").setValue(ObjectReference);
       				var OTHLLRowId=combo.getValue(); 
       				Ext.getCmp("hidden_otherloc").reset();
       				Ext.getCmp("hidden_otherloc").setValue(OTHLLRowId);
       				var title = Ext.getCmp('tabs').getActiveTab().title;
					switchcase(title, ObjectType,ObjectReference,OTHLLRowId);
					Updateroletitle(ObjectType,ObjectReference,OTHLLRowId)
				}
			},
			'change':function(combo,record,index){
				var _record = Usergrid.getSelectionModel().getSelected();//records[0]
				if(_record)
				{
					var ObjectReference=_record.get('SSUSRRowId')
					var ObjectType="U"
					Ext.getCmp("hidden_objecttype").reset();
        			Ext.getCmp("hidden_objecttype").setValue(ObjectType);
       				Ext.getCmp("hidden_objectref").reset();
       				Ext.getCmp("hidden_objectref").setValue(ObjectReference);
       				var OTHLLRowId=combo.getValue(); 
       				Ext.getCmp("hidden_otherloc").reset();
       				Ext.getCmp("hidden_otherloc").setValue(OTHLLRowId);
       				var title = Ext.getCmp('tabs').getActiveTab().title;
					switchcase(title, ObjectType,ObjectReference,OTHLLRowId);
					Updateroletitle(ObjectType,ObjectReference,OTHLLRowId)
				}
			},
			'blur':function(combo,record,index){
				var _record = Usergrid.getSelectionModel().getSelected();//records[0]
				if(_record)
				{
					var ObjectReference=_record.get('SSUSRRowId')
					var ObjectType="U"
					Ext.getCmp("hidden_objecttype").reset();
        			Ext.getCmp("hidden_objecttype").setValue(ObjectType);
       				Ext.getCmp("hidden_objectref").reset();
       				Ext.getCmp("hidden_objectref").setValue(ObjectReference);
       				var OTHLLRowId=combo.getValue(); 
       				Ext.getCmp("hidden_otherloc").reset();
       				Ext.getCmp("hidden_otherloc").setValue(OTHLLRowId);
       				var title = Ext.getCmp('tabs').getActiveTab().title;
					switchcase(title, ObjectType,ObjectReference,OTHLLRowId);
					Updateroletitle(ObjectType,ObjectReference,OTHLLRowId)
				}
			}
			
		}
						}]
	});
		
	var Usertb = new Ext.Toolbar({
				id : 'Usertb',
				items : [UserSearch,'-', UserText, '-','->' ,UserRefresh],
						listeners : {
					render : function() {
						tbbuttonUser.render(Usergrid.tbar)
					}
				}
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
				stateId : 'Usergrid'
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
			Ext.getCmp("hidden_objecttype").reset();
       		Ext.getCmp("hidden_objectref").reset();
			Ext.getCmp("hidden_otherloc").reset();
			var title = Ext.getCmp('tabs').getActiveTab().title;
			switchcase(title, "","","");
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
			width:280,
			minSize: 280,
			maxSize: 320,
			//expanded : false,
			//margins:'0 0 5 5',
			//cmargins:'0 5 5 5',
			//lines:false,
	    	layout:"accordion",
	    	//extraCls:"roomtypegridbbar",
			//iconCls:'icon-feed', 
	 		//添加动画效果
			//layoutConfig: {animate: true},
			items:[Groupgrid,Locgrid,Usergrid]
		});
		
		
	/*
	// 以下为加载事件  
	var GridClick = function(ObjectType,ObjectReference){
		//clearFind(); //清除树过滤
		//2013-5-14 by lisen
		var f  = function(node) {
			node.getUI().toggleCheck(false);
		}
		Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f);
		var AutJson="";
		AutJson = tkMakeServerCall("web.DHCBL.Authorize.Menu","GetAutJson",ObjectType,ObjectReference);
		if(AutJson!=""){
			var arr = Ext.decode(AutJson);
			for (var i=0;i<arr.length;i++){
				var node = Ext.getCmp("menuConfigTreePanel").getNodeById(arr[i].ID);
				if(node) node.getUI().toggleCheck(true);
				else continue;
			}
		}
		//重置radio为全部
		//Ext.getCmp('radioGroup1').reset();
		//如果是demo,则默认全部选中 2013-8-30 by lisen
		if(ObjectType=="G"&&ObjectReference==1){
			var f  = function(node) {
				node.getUI().toggleCheck(true);
			}
			Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f);
		}
	}
	*/
	Usergrid.on("rowclick", function(grid, rowIndex, e) {								//用户菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		if(_record)
		{
			
			Ext.getCmp('TextSSUserOtherLogonLoc').reset();
			Ext.getCmp("TextSSUserOtherLogonLoc").setValue("");
			
			SSUserOtherLogonLocds.baseParams={type:"U",OTHLLParRef:_record.get('SSUSRRowId')};
       	 	//SSUserOtherLogonLocds.proxy= new Ext.data.HttpProxy({url: GetSSUserOtherLogonLoc_URL+'&type='+"U"+'&OTHLLParRef=' + _record.get('SSUSRRowId')});  
        	//SSUserOtherLogonLocds.load(); 
			
			var ObjectReference=_record.get('SSUSRRowId')
			var ObjectType="U"
			Ext.getCmp("hidden_objecttype").reset();
        	Ext.getCmp("hidden_objecttype").setValue(ObjectType);
       		Ext.getCmp("hidden_objectref").reset();
       		Ext.getCmp("hidden_objectref").setValue(ObjectReference);
       		var OTHLLRowId="" //Ext.getCmp('TextSSUserOtherLogonLoc').getValue(); 
       		Ext.getCmp("hidden_otherloc").reset();
       		Ext.getCmp("hidden_otherloc").setValue(OTHLLRowId);
       		var title = Ext.getCmp('tabs').getActiveTab().title;
			switchcase(title, ObjectType,ObjectReference,OTHLLRowId);
		}
		else
		{
			Ext.getCmp("hidden_objecttype").reset();
       		Ext.getCmp("hidden_objectref").reset();
       		Ext.getCmp("hidden_otherloc").reset();
       		var title = Ext.getCmp('tabs').getActiveTab().title;
       		switchcase(title,"","","");
			
		}
	});
	

	Locgrid.on("rowclick", function(grid, rowIndex, e) {								//科室菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		if(_record)
		{
			ObjectReference=_record.get('CTLOCRowID')
			ObjectType="L"
			Ext.getCmp("hidden_objecttype").reset();
        	Ext.getCmp("hidden_objecttype").setValue(ObjectType);
       	 	Ext.getCmp("hidden_objectref").reset();
       		Ext.getCmp("hidden_objectref").setValue(ObjectReference);
        	Ext.getCmp("hidden_otherloc").reset();
        	Ext.getCmp("hidden_otherloc").setValue("");
        	
        	Ext.getCmp('TextSSUserOtherLogonLoc').reset();
			Ext.getCmp("TextSSUserOtherLogonLoc").setValue("");
			
        	var title = Ext.getCmp('tabs').getActiveTab().title;
			switchcase(title, ObjectType,ObjectReference,"");
	}
	else
		{
			Ext.getCmp("hidden_objecttype").reset();
       		Ext.getCmp("hidden_objectref").reset();
       		Ext.getCmp("hidden_otherloc").reset();
       		var title = Ext.getCmp('tabs').getActiveTab().title;
       		switchcase(title,"","","");
			
		}
		
	});
	
	
	Groupgrid.on("rowclick", function(grid, rowIndex, e) {								//安全组菜单授权
		var _record = grid.getSelectionModel().getSelected();//records[0]
		if(_record)
		{
			ObjectReference=_record.get('SSGRPRowId')
			ObjectType="G"
			Ext.getCmp("hidden_objecttype").reset();
       		Ext.getCmp("hidden_objecttype").setValue(ObjectType);
       		Ext.getCmp("hidden_objectref").reset();
       		Ext.getCmp("hidden_objectref").setValue(ObjectReference);
       		Ext.getCmp("hidden_otherloc").reset();
      	 	Ext.getCmp("hidden_otherloc").setValue("");
      	 	
       		var title = Ext.getCmp('tabs').getActiveTab().title;
			switchcase(title, ObjectType,ObjectReference,"");
		}
		else
		{
			Ext.getCmp("hidden_objecttype").reset();
       		Ext.getCmp("hidden_objectref").reset();
       		Ext.getCmp("hidden_otherloc").reset();
       		var title = Ext.getCmp('tabs').getActiveTab().title;
       		switchcase(title,"","","");
			
		}
	});
	
	
	////基础数据授权
	var GetBaseDataAut_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassQuery=GetBaseDataAut";
	
	var ds_basedata = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
							url : GetBaseDataAut_URL								//---------调用的动作
						}),
				reader : new Ext.data.JsonReader({						    //---------将原始数据转换
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{												//---------列的映射
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'ObjectType',
									mapping : 'ObjectType',
									type : 'string'
								}, {
									name : 'ObjectReference',
									mapping : 'ObjectReference',
									type : 'string'
								}, {
									name : 'Object',
									mapping : 'Object',
									type : 'string'
								}, {
									name : 'AppKey',
									mapping : 'AppKey',
									type : 'string'
								}, {
									name : 'AppSubKey',
									mapping : 'AppSubKey',
									type : 'string'
								}, {
									name : 'AppSubKey1',
									mapping : 'AppSubKey1',
									type : 'string'
								},{
									name:'Data',
									mapping:'Data',
									type:'string'
								},{
									name:'Data1',
									mapping:'Data1',
									type:'string'
								}
						])
				//remoteSort : true										  //----------排序
			});
		/**-------------------加载数据-----------------*/
	ds_basedata.load({
				params : {												  //----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          //----------加载完成后执行的回调函数
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
					 //alert(options);
					 //Ext.Msg.alert('info', '加载完毕, success = '+
					 //records.length);
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging_basedata = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds_basedata,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})	
	/**---------创建grid-----------*/
	var grid_basedata = new Ext.grid.GridPanel({
				id : 'grid_basedata',
				region : 'center',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 300,
				height : 400,
				closable : true,
				store : ds_basedata,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm, {									//----------------定义列
							header : 'ID',
							width : 50,
							sortable : true,
							dataIndex : 'ID',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '授权类别',
							width : 50,
							sortable : true,
							dataIndex : 'ObjectType',
							hidden : true
						}, {
							header : '被授权对象',
							width : 50,
							sortable : true,
							dataIndex : 'ObjectReference',
							hidden : true
						}, {
							header : '被授权对象',
							width : 80,
							sortable : true,
							dataIndex : 'Object'
						}, {
							header : 'AppKey',
							width : 50,
							sortable : true,
							dataIndex : 'AppKey',
							hidden : true
						}, {
							header : '被授权的表',
							width : 50,
							sortable : true,
							dataIndex : 'AppSubKey',
							hidden : true
						}, {
							header : '被授权的表',
							width : 50,
							sortable : true,
							dataIndex : 'AppSubKey1'
						}, {
							header : 'Data',
							width : 200,
							sortable : true,
							dataIndex : 'Data',
							hidden : true
						
						}, {
							header : '授权数据',
							width : 200,
							sortable : true,
							dataIndex : 'Data1'
						}],
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				//title : '生产厂家',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'PHMNFForeignDesc',
				bbar : paging_basedata,                                    //-----------------底部状态栏
				//tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid_basedata'
			});
	
	////功能元素授权
	var GetItemAut_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassQuery=GetItemAut";
	
	var ds_item = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
							url : GetItemAut_URL								//---------调用的动作
						}),
				reader : new Ext.data.JsonReader({						    //---------将原始数据转换
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{												//---------列的映射
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'ObjectType',
									mapping : 'ObjectType',
									type : 'string'
								}, {
									name : 'ObjectReference',
									mapping : 'ObjectReference',
									type : 'string'
								}, {
									name : 'Object',
									mapping : 'Object',
									type : 'string'
								}, {
									name : 'AppKey',
									mapping : 'AppKey',
									type : 'string'
								}, {
									name : 'AppSubKey',
									mapping : 'AppSubKey',
									type : 'string'
								}, {
									name : 'AppSubKey1',
									mapping : 'AppSubKey1',
									type : 'string'
								},{
									name:'Data',
									mapping:'Data',
									type:'string'
								},{
									name:'Data1',
									mapping:'Data1',
									type:'string'
								}
						])
				//remoteSort : true										  //----------排序
			});
		/**-------------------加载数据-----------------*/
	ds_item.load({
				params : {												  //----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          //----------加载完成后执行的回调函数
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
					 //alert(options);
					 //Ext.Msg.alert('info', '加载完毕, success = '+
					 //records.length);
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging_item = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds_item,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})	
	/**---------创建grid-----------*/
	var grid_item = new Ext.grid.GridPanel({
				id : 'grid_item',
				region : 'center',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 300,
				height : 400,
				closable : true,
				store : ds_item,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm, {									//----------------定义列
							header : 'ID',
							width : 50,
							sortable : true,
							dataIndex : 'ID',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '授权类别',
							width : 50,
							sortable : true,
							dataIndex : 'ObjectType',
							hidden : true
						}, {
							header : '被授权对象',
							width : 50,
							sortable : true,
							dataIndex : 'ObjectReference',
							hidden : true
						}, {
							header : '被授权对象',
							width : 80,
							sortable : true,
							dataIndex : 'Object'
						}, {
							header : 'AppKey',
							width : 50,
							sortable : true,
							dataIndex : 'AppKey',
							hidden : true
						}, {
							header : '被授权的表',
							width : 50,
							sortable : true,
							dataIndex : 'AppSubKey',
							hidden : true
						}, {
							header : '被授权的表',
							width : 50,
							sortable : true,
							dataIndex : 'AppSubKey1'
						}, {
							header : 'Data',
							width : 200,
							sortable : true,
							dataIndex : 'Data',
							hidden : true
						
						}, {
							header : '授权数据',
							width : 200,
							sortable : true,
							dataIndex : 'Data1'
						}],
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				//title : '生产厂家',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'PHMNFForeignDesc',
				bbar : paging_item,                                    //-----------------底部状态栏
				//tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid_item'
			});
	//医院级授权
	var GetHospAut_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassQuery=GetHospAut";
	
	var ds_hosp = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
							url : GetHospAut_URL								//---------调用的动作
						}),
				reader : new Ext.data.JsonReader({						    //---------将原始数据转换
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{												//---------列的映射
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'ObjectType',
									mapping : 'ObjectType',
									type : 'string'
								}, {
									name : 'ObjectReference',
									mapping : 'ObjectReference',
									type : 'string'
								}, {
									name : 'Object',
									mapping : 'Object',
									type : 'string'
								}, {
									name : 'AppKey',
									mapping : 'AppKey',
									type : 'string'
								}, {
									name : 'AppSubKey',
									mapping : 'AppSubKey',
									type : 'string'
								}, {
									name : 'AppSubKey1',
									mapping : 'AppSubKey1',
									type : 'string'
								},{
									name:'Data',
									mapping:'Data',
									type:'string'
								},{
									name:'Data1',
									mapping:'Data1',
									type:'string'
								}
						])
				//remoteSort : true										  //----------排序
			});
		/**-------------------加载数据-----------------*/
	ds_hosp.load({
				params : {												  //----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          //----------加载完成后执行的回调函数
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
					 //alert(options);
					 //Ext.Msg.alert('info', '加载完毕, success = '+
					 //records.length);
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging_hosp = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds_hosp,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})	
	/**---------创建grid-----------*/
	var grid_hosp = new Ext.grid.GridPanel({
				id : 'grid_hosp',
				region : 'center',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 300,
				height : 400,
				closable : true,
				store : ds_hosp,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm, {									//----------------定义列
							header : 'ID',
							width : 50,
							sortable : true,
							dataIndex : 'ID',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '授权类别',
							width : 50,
							sortable : true,
							dataIndex : 'ObjectType',
							hidden : true
						}, {
							header : '被授权对象',
							width : 50,
							sortable : true,
							dataIndex : 'ObjectReference',
							hidden : true
						}, {
							header : '被授权对象',
							width : 80,
							sortable : true,
							dataIndex : 'Object'
						}, {
							header : 'AppKey',
							width : 50,
							sortable : true,
							dataIndex : 'AppKey',
							hidden : true
						}, {
							header : '被授权的表',
							width : 50,
							sortable : true,
							dataIndex : 'AppSubKey',
							hidden : true
						}, {
							header : '被授权的表',
							width : 50,
							sortable : true,
							dataIndex : 'AppSubKey1'
						}, {
							header : 'Data',
							width : 200,
							sortable : true,
							dataIndex : 'Data',
							hidden : true
						
						}, {
							header : '授权数据',
							width : 200,
							sortable : true,
							dataIndex : 'Data1'
						}],
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				//title : '生产厂家',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'PHMNFForeignDesc',
				bbar : paging_hosp,                                    //-----------------底部状态栏
				//tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid_hosp'
			});
	
			
			
/*
 * 
 * 
 * ******************* 菜单树级联设置 ***************************
function cascadeParent(){
	var pn = this.parentNode;
	if (!pn || !Ext.isBoolean(this.attributes.checked)) return;
	if (this.attributes.checked) { //级联选中
		pn.getUI().toggleCheck(true);
	}else {//级联未选中
		var b = true;
		Ext.each(pn.childNodes, function(n){
			if (n.getUI().isChecked()){
				return b = false;
			}
			return true;
		});
		if (b) pn.getUI().toggleCheck(false);
	}
	pn.cascadeParent();
}        
function cascadeChildren(){
	var ch = this.attributes.checked;
	if (!Ext.isBoolean(ch)) return;
	Ext.each(this.childNodes, function(n){
		n.getUI().toggleCheck(ch);
		n.cascadeChildren();
	});
}
Ext.apply(Ext.tree.TreeNode.prototype, {
	cascadeParent: cascadeParent,
	cascadeChildren: cascadeChildren
});
Ext.override(Ext.tree.TreeEventModel, {
	onCheckboxClick: Ext.tree.TreeEventModel.prototype.onCheckboxClick.createSequence(function(e, node){
		node.cascadeParent();
		node.cascadeChildren();
	})
});

*/

//****************************************************************//

	///菜单授权
	var sessionStr = Ext.BDP.FunLib.Session(); //二级授权时使用，20140317 by lisen
	var AutMENUTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPPreferences&pClassMethod=GetMenuAut";
	///var OBJT=Ext.getCmp("hidden_objecttype").getValue()
	///var OBJREF=Ext.getCmp("hidden_objectref").getValue()
	/** 菜单面板 */
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: AutMENUTREE_ACTION_URL , //20140317 by lisen + '&SessionStr=' + sessionStr
				baseParams:{ObjectType:ObjectReference,ObjectReference:ObjectReference,OTHLLRowId:OTHLLRowId}  
   				
				//baseParams : {SessionStr:SessionStr}
			});
	var menuPanel = new Ext.tree.TreePanel({
			//title: '菜单授权',
			region: 'center',
			//xtype:'treepanel',
			id: 'menuConfigTreePanel',
			expanded:true,
			root: MenuTreeroot=new Ext.tree.AsyncTreeNode({
				 	nodeType: 'async',
					id:"menuTreeRoot",
					text:"菜单",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
				}),
			loader: menuTreeLoader,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false
	});		
	
			/*
			 * 
			 * 
			 * 
			 * 
			 * treePanel.getRootNode().removeAll(false);//设为false时不重复加载，如果是TRUE时就会自动加载！ 
  				 * // render the deptTree 
再treePanel.store.load();

reloadNavNode : function() { 
var tree=Ext.getCmp("zuzhitree");
var node= tree.getNodeById(nodeSelected.id)
node.parentNode.reload();
}
reloadNavNode : function() {	
var tree=nodeSelected.getOwnerTree();
         tree.root.reload();
         tree.expandPath(nodeSelected.getPath());
}
reloadNavNode : function() {	
   var tree=Ext.getCmp("zuzhitree");
   var node= tree.getNodeById(nodeSelected.id)
   node.parentNode.reload();
}



treepanel的treestore默认总是自动加载，即使把autoload设为false也一样。为了让其不自动加载，可以这样做：

首先，在定义treestore时不加入proxy设置。

        var menuStore = Ext.create('Ext.data.TreeStore', {
           root: {
               text: 'Ext JS',
               //id: 'src',
               expanded: true
           },
           autoLoad: false
        });


然后，在手动load前，加入proxy。

        menuStore.setProxy({
            type: 'ajax',
            url: 'myAction.action',
            reader: {
                type: 'json'
            }
        });

需要注意的是，在load的时候，必须确保treepanel存在于页面上，也就是说必须已经渲染到一个可视的container中。否则会出现找不到控件的错误。

  				 * reload : function (f){ 
filter = f; 

var loader = deptTree.getLoader(); 
deptTree.on('beforeload', function(){ 
loader.dataUrl = loader.dataUrl ; 
loader.baseParams = filter; 
}); 
root.reload(); 
} 
  				 * 
  				 * var loader = deptTree.getLoader();   
    deptTree.on('beforeload', function(){    
            loader.dataUrl = loader.dataUrl ;   
            loader.baseParams = filter;   
    });   
    root.reload();  
    ///deptTree.render();   
  					///root.expand();  
  				//MenuTreeroot.expand();
  				//var loader = menuPanel.getLoader();    
  				 * //var ObjectType=Ext.getCmp("hidden_objecttype").getValue();
				///var ObjectReference=Ext.getCmp("hidden_objectref").getValue();
				
				//alert(ObjectReference)
				//alert(ObjectType)
				///menuPanel.removeAll()
    			///menuPanel.reload();
    			///menuTreeLoader.baseParams = {ParentID:"menuTreeRoot",SessionStr:sessionStr,ObjectType:Ext.getCmp("hidden_objecttype").getValue(),ObjectReference:Ext.getCmp("hidden_objectref").getValue()};   
   				///Ext.getCmp("menuPanel").getRootNode().cascade(f);
   			///	menuPanel.render();   
   			///	menuPanel.getRootNode().expand();

				//menuTreeLoader.proxy= new Ext.data.HttpProxy({url: });  
        		///menuTreeLoader.load(); 
			
  				 * 
  				 */		
	function switchcase(title, objecttype,objectreference,OTHLLRowId) {
		switch (title) {	
			case '基础数据授权浏览' :
				 //PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
				  
				  // ds_basedata.baseParams={
        			//		objecttype:Ext.getCmp('TextObjectType').getValue(),
        			////		objectreference:Ext.getCmp('TextObjectReference').getValue(),
        			//		OTHLLRowId:Ext.getCmp('TextSSUserOtherLogonLoc').getValue()
        			//	}
				ds_basedata.setBaseParam('objecttype', objecttype);
				ds_basedata.setBaseParam('objectreference', objectreference);
				ds_basedata.setBaseParam('OTHLLRowId', OTHLLRowId);
				
				ds_basedata.load({
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});
				Updateroletitle(objecttype,objectreference,OTHLLRowId)
				//alert(OTHLLRowId)
				break;
			case '功能元素授权浏览' :
				ds_item.setBaseParam('objecttype', objecttype);
				ds_item.setBaseParam('objectreference', objectreference);
				ds_item.setBaseParam('OTHLLRowId', OTHLLRowId);
				
				ds_item.load({
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});
				//alert(OTHLLRowId)
				Updateroletitle(objecttype,objectreference,OTHLLRowId)
				break;	
			case '菜单授权浏览' :		
			  
  				menuPanel.on('beforeload', function(){    
        		    menuTreeLoader.dataUrl = AutMENUTREE_ACTION_URL ;   
         		   	menuTreeLoader.baseParams = {ParentID:"menuTreeRoot",ObjectType:Ext.getCmp("hidden_objecttype").getValue(),ObjectReference:Ext.getCmp("hidden_objectref").getValue(),OTHLLRowId:Ext.getCmp("hidden_otherloc").getValue()};   
   				});
   				menuPanel.root.reload();
				Updateroletitle(objecttype,objectreference,OTHLLRowId)
				//alert(OTHLLRowId)
				break;
			case '医院级授权浏览' :
				ds_hosp.setBaseParam('objecttype', objecttype);
				ds_hosp.setBaseParam('objectreference', objectreference);
				ds_hosp.setBaseParam('OTHLLRowId', OTHLLRowId);
				
				ds_hosp.load({
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});
				Updateroletitle(objecttype,objectreference,OTHLLRowId)
				//alert(OTHLLRowId)
				break;
			
		}
	}
	
	var roletitle = new Ext.form.Label({
		id: 'roletitle',
		html:""
		//cls: 'icon-refresh'
	});
	
	var Updateroletitle = function(ObjectType,ObjectReference,OTHLLRowId){
		var titlestr = tkMakeServerCall("web.DHCBL.BDP.BDPPreferences","GetGroupLocByOTHLL",ObjectType,ObjectReference,OTHLLRowId);
		Ext.getCmp("roletitle").el.dom.innerHTML ="<span style='border: 2px;Font-size:medium'> "+titlestr+"</span>"
	}
	
	  /**------查看所有授权-------*/
	 var tabs = new Ext.TabPanel({
		id : 'tabs',
		width:'80%',
		activeTab : 0,
        region:'center',
        enableTabScroll:true,
        resizeTabs: true,
        tabWidth:130,
		minTabWidth:120,
		tbar:[roletitle],
        //margins:'0 5 5 0',
		items : [{layout:'fit',
					title : '菜单授权浏览',
					items : [menuPanel]
				},{	
					layout:'fit',
					title : '基础数据授权浏览',
					items : [grid_basedata]
				},{
					layout:'fit',
					title : '功能元素授权浏览',
					items : [grid_item]
				
				} ,{
					
					layout:'fit',
					title : '医院级授权浏览',
					items : [grid_hosp]
				}],
		listeners : {
			
					tabchange : function(tp, p) {
						
							var ObjectType=Ext.getCmp("hidden_objecttype").getValue();
							var ObjectReference=Ext.getCmp("hidden_objectref").getValue();
        					var title = Ext.getCmp('tabs').getActiveTab().title;
        					var OTHLLRowId= Ext.getCmp("hidden_otherloc").getValue();
        					
							switchcase(p.title, ObjectType,ObjectReference,OTHLLRowId)
							
						}
					
					
				}
			});
			
	
	
	
	var winViewAut = new Ext.Window({
			title:'查看角色实际授权',
			width:1050,
			minWidth:1050,
            height:570,
			layout:'border',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: [westpanel,tabs],
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
	// 刷新工作条
	var btnViewAllAut = new Ext.Button({
				id : 'btnViewAllAut',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnViewAllAut'),
				tooltip : '查看角色实际授权',
				iconCls : 'icon-search',
				text : '查看角色实际授权',
				handler : function() {
					/*var record1 = Ext.getCmp('TextObjectType').getValue()
					var record2 = Ext.getCmp('TextObjectReference').getValue()
	       			if (record1&&record2){*/
						/*var autTitle1=Ext.getCmp('TextObjectType').getRawValue() 
						var autTitle2=Ext.getCmp('TextObjectReference').getRawValue()*/
						winViewAut.setIconClass('icon-search');
						//winViewAut.setTitle('查看角色实际授权--'+autTitle1+'--'+autTitle2);
						winViewAut.show();
        				/*ds_basedata.baseParams={
        					objecttype:Ext.getCmp('TextObjectType').getValue(),
        					objectreference:Ext.getCmp('TextObjectReference').getValue(),
        					OTHLLRowId:Ext.getCmp('TextSSUserOtherLogonLoc').getValue()
        				}
	           			ds_basedata.load({params:{start:0, limit:Ext.BDP.FunLib.PageSize.Pop}});*/
				 	/*}
	      			else
					{
							Ext.Msg.show({
								title:'提示',
								msg:'请选择要查看授权的角色!',
								icon:Ext.Msg.WARNING,
								buttons:Ext.Msg.OK
							});
					}*/
				}
	});
	  //------查看所有授权(完)-------//	
	
	

	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'del_btn',
		handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						
						for(var i=0;i<rows.length;i++){
							
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[i].get('ID')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									
									if (jsonData.success == 'true')
									{
										//var myrowid = action.result.id;                
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize_grid);
											}
										});
									}
									else {
											var errorMsg = '';
											if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
							}
						}, this);
					}
					}
				}, this);
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	
	
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'ID',
								mapping : 'ID',
								type : 'number'
							}, {
								name : 'ObjectType',
								mapping : 'ObjectType',
								type : 'string'
							}, {
								name : 'ObjectReference',
								mapping : 'ObjectReference',
								type : 'string'
							}, {
								name : 'AppKey',
								mapping : 'AppKey',
								type : 'string'
							}, {
								name : 'AppSubKey',
								mapping : 'AppSubKey',
								type : 'string'
							}, {
								name : 'AppKey1',
								mapping : 'AppKey1',
								type : 'string'
							}, {
								name : 'AppSubKey1',
								mapping : 'AppSubKey1',
								type : 'string'
							}, {
								name : 'Data',
								mapping : 'Data',
								type : 'string'
							}, {
								name : 'Data1',
								mapping : 'Data1',
								type : 'string'
							}, {
								name : 'DataSplitString',
								mapping : 'DataSplitString',
								type : 'string'
							}, {
								name : 'CorrespondingClass',
								mapping : 'CorrespondingClass',
								type : 'string'
							}, {
								name : 'DataMapMode',
								mapping : 'DataMapMode',
								type : 'string'
							
							}
						])
				//remoteSort : true
				//sortInfo: {field : "***RowId",direction : "ASC"}
	});
			
 	// 加载数据
	ds.load({
				params : { start : 0, limit : pagesize_grid },
				callback : function(records, options, success) {
				}
	}); 			
			
	
	// 分页工具条
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_grid,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});


	// 搜索工具条
	var btnSearch = new Ext.Button({
			id : 'btnSearch',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
			tooltip : '搜索',
			iconCls : 'icon-search',
			text : '搜索',
			handler : function() {
				var ObjectType=Ext.getCmp("TextObjectType").getValue();
				var ObjectReference=Ext.getCmp("TextObjectReference").getValue();			
				var AppSubKey=Ext.getCmp("TextAppSubKey").getValue();
							
			
				grid.getStore().baseParams={
						objecttype : ObjectType,
						
						objectreference : ObjectReference,
						
						appsubkey : AppSubKey
						
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize_grid
					}
				});
		}
	});
	
	
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextObjectType").reset();
					Ext.getCmp("TextObjectReference").reset();
					//Ext.getCmp('TextSSUserOtherLogonLoc').reset();
					Ext.getCmp("TextAppSubKey").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize_grid
								}
							});
							
					var Type=Ext.getCmp('TextObjectType').getValue();
					Referenceds.baseParams={objecttype:Type};
					
					/*var userid=Ext.getCmp('TextObjectReference').getValue();
					SSUserOtherLogonLocds.load({params:{type:Type,OTHLLParRef:userid}});*/
					
				}
	});
		// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnDel,'-',
		btnViewAllAut]
	});
		
	// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['授权类别',{
							xtype : "combo",
							shadow:false,
							width:120,
							fieldLabel : '<font color=red></font>授权类别',
							id :'TextObjectType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextObjectType'),
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													name : '安全组',
													value : 'G'
												}, {
													name : '科室',
													value : 'L'
												}, {
													name : '用户',
													value : 'U'
												}]
									}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'name',
							valueField : 'value',
							listeners:{
			'select':function(combo,record,index){
				var Type=Ext.getCmp('TextObjectType').getValue();
				Referenceds.baseParams={objecttype:Type};
				//if(Type="U") Ext.getCmp("TextSSUserOtherLogonLoc").enable();
				//else {Ext.getCmp("TextSSUserOtherLogonLoc").disable();}
			
			},
			'change':function(combo,record,index){
				Ext.getCmp('TextObjectReference').clearValue(); 
				//Ext.getCmp('TextSSUserOtherLogonLoc').clearValue(); 
			}
		}
						},'被授权对象',{
							xtype : "bdpcombo",
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							width:120,
							fieldLabel : '<font color=red></font>ObjectReference',
							id :'TextObjectReference',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextObjectReference'),
							store : Referenceds=new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : GetObjectReference_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'RowId',mapping:'RowId'},
										{name:'Desc',mapping:'Desc'} ])
								}),
							mode : 'remote',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'Desc',
							valueField : 'RowId'
			},'-',
						'被授权的表', 
						{xtype : 'textfield',id : 'TextAppSubKey',width:120,disabled : Ext.BDP.FunLib.Component.DisableFlag('TextAppSubKey')},'-', 
						{xtype : 'textfield',id : 'hidden_objecttype',hidden : true},
						{xtype : 'textfield',id : 'hidden_otherloc',hidden : true},
						{xtype : 'textfield',id : 'hidden_objectref',hidden : true},
						btnSearch,'-', 
						btnRefresh,'-','->',helphtmlbtn
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});

	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '授权浏览',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns :[sm, {
							header : 'ID',
							width : 60,
							sortable : true,
							dataIndex : 'ID',
							hidden : true
						}, {
							header : '授权类别',
							width : 60,
							sortable : true,
							dataIndex : 'ObjectType'
						}, {
							header : '被授权对象',
							width : 60,
							sortable : true,
							dataIndex : 'ObjectReference'
						}, {
							header : '授权类型', 
							width : 60,
							sortable : true,
							dataIndex : 'AppKey',
							hidden : true
						}, {
							header : '授权类型', 
							width : 60,
							sortable : true,
							dataIndex : 'AppKey1'
						}, {
							header : '被授权的表',
							width : 80,
							sortable : true,
							dataIndex : 'AppSubKey',
							hidden : true
						}, {
							header : '被授权的表',
							width : 80,
							sortable : true,
							dataIndex : 'AppSubKey1'
						}, {
							header : '数据',
							width : 100,
							sortable : true,
							dataIndex : 'Data'
						}, {
							header : '授权数据',
							width : 100,
							sortable : true,
							dataIndex : 'Data1'
						}, {
							header : '数据存储格式',
							width : 60,
							sortable : true,
							dataIndex : 'DataSplitString'
						}, {
							header : '授权数据对应解析类',
							width : 80,
							sortable : true,
							dataIndex : 'CorrespondingClass',
							hidden : true
						}, {
							header : 'DataMapMode',
							width : 60,
							sortable : true,
							dataIndex : 'DataMapMode'
						
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true, 
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
	});
	/** 显示修正后的数据20130709lisen */
	var win = new Ext.Window({
					title : '授权数据',
					width : 400,
					height : 200,
					layout : 'fit',
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : true,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : [new Ext.form.TextArea({
						id : 'DataText',
						readOnly : true,
						width : 600,
						height : 300
					})]
	});
	
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e){
		var record = grid.getSelectionModel().getSelected();
		var text = record.get('Data1');
		Ext.getCmp('DataText').setValue(text);
		win.show();
	});
	
	/** 布局 */
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[grid]
    	});
});

